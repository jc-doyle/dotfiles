/**
 * Ask Extension
 *
 * Two complementary question-answering tools:
 *
 * The `questionnaire` tool — the LLM calls this to ask YOU clarifying questions
 * before doing work. Single question shows a simple option list. Multiple
 * questions show a tab-based UI. Each option can have a description, and
 * there's always a "Type something" free-text fallback.
 */

import { type ExtensionAPI, type Theme } from "@earendil-works/pi-coding-agent";
import { Editor, type EditorTheme, Key, matchesKey, Text, truncateToWidth } from "@earendil-works/pi-tui";
import { Type } from "typebox";

// ─────────────────────────────────────────────────────────────────────────────
// Types
// ─────────────────────────────────────────────────────────────────────────────

interface QuestionOption {
	value: string;
	label: string;
	description?: string;
}

type RenderOption = QuestionOption & { isOther?: boolean };

interface Question {
	id: string;
	label: string;
	prompt: string;
	options: QuestionOption[];
	allowOther: boolean;
}

interface Answer {
	id: string;
	value: string;
	label: string;
	wasCustom: boolean;
	index?: number;
}

interface QuestionnaireResult {
	questions: Question[];
	answers: Answer[];
	cancelled: boolean;
}

// ─────────────────────────────────────────────────────────────────────────────
// Schema
// ─────────────────────────────────────────────────────────────────────────────

const QuestionOptionSchema = Type.Object({
	value: Type.Optional(Type.String({ description: "The value returned when this option is selected (defaults to label)" })),
	label: Type.String({ description: "Display label shown to the user" }),
	description: Type.Optional(Type.String({ description: "Optional hint shown below the label" })),
});

const QuestionSchema = Type.Object({
	id: Type.String({ description: "Unique identifier for this question (used in the answer map)" }),
	label: Type.Optional(Type.String({
		description: "Short label for the tab bar, e.g. 'Scope' or 'Priority'. Defaults to Q1, Q2 ...",
	})),
	prompt: Type.String({ description: "The full question text shown to the user" }),
	options: Type.Array(QuestionOptionSchema, { description: "Options the user can choose from" }),
	allowOther: Type.Optional(Type.Boolean({ description: "Allow free-text 'Type something' option (default: true)" })),
});

const QuestionnaireParams = Type.Object({
	questions: Type.Array(QuestionSchema, {
		description: "One or more questions to ask the user before proceeding",
	}),
});
// Editor theme (shared between tools)
// ─────────────────────────────────────────────────────────────────────────────

function makeEditorTheme(theme: Theme): EditorTheme {
	return {
		borderColor: (s) => theme.fg("accent", s),
		selectList: {
			selectedPrefix: (t) => theme.fg("accent", t),
			selectedText: (t) => theme.fg("accent", t),
			description: (t) => theme.fg("muted", t),
			scrollInfo: (t) => theme.fg("dim", t),
			noMatch: (t) => theme.fg("warning", t),
		},
	};
}

// ─────────────────────────────────────────────────────────────────────────────
// Extension
// ─────────────────────────────────────────────────────────────────────────────

export default function (pi: ExtensionAPI) {

	// ──────────────────────────────────────────────────────────────────────────
	// questionnaire tool — LLM asks the user questions before acting
	// ──────────────────────────────────────────────────────────────────────────

	pi.registerTool({
		name: "questionnaire",
		label: "Questionnaire",
		description:
			"Ask the user one or more clarifying questions before proceeding. " +
			"Use this whenever you need the user's input to make a decision, choose a direction, " +
			"or confirm an approach. For a single question, shows a simple option list. " +
			"For multiple questions, shows a tab-based interface the user can navigate.",
		promptSnippet: "Ask the user clarifying questions before acting",
		promptGuidelines: [
			"Use questionnaire before starting any non-trivial task where assumptions could lead to wasted work.",
			"Keep option labels short and scannable. Use the description field for extra context.",
			"Group related questions together in one questionnaire call rather than asking one at a time.",
		],
		parameters: QuestionnaireParams,

		async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
			if (!ctx.hasUI) {
				return {
					content: [{ type: "text", text: "Error: questionnaire requires interactive mode" }],
					details: { questions: [], answers: [], cancelled: true } as QuestionnaireResult,
				};
			}
			if (params.questions.length === 0) {
				return {
					content: [{ type: "text", text: "Error: no questions provided" }],
					details: { questions: [], answers: [], cancelled: true } as QuestionnaireResult,
				};
			}

			// Normalise: fill in defaults
			const questions: Question[] = params.questions.map((q, i) => ({
				...q,
				label: q.label || `Q${i + 1}`,
				options: q.options.map((o) => ({ ...o, value: o.value ?? o.label })),
				allowOther: q.allowOther !== false,
			}));

			const isMulti = questions.length > 1;
			const totalTabs = questions.length + 1; // questions + Submit tab

			const result = await ctx.ui.custom<QuestionnaireResult>((tui, theme, _kb, done) => {
				let currentTab = 0;
				let optionIndex = 0;
				let inputMode = false;
				let inputQuestionId: string | null = null;
				let cachedLines: string[] | undefined;
				const answers = new Map<string, Answer>();

				const editor = new Editor(tui, makeEditorTheme(theme));

				function refresh() {
					cachedLines = undefined;
					tui.requestRender();
				}

				function submit(cancelled: boolean) {
					done({ questions, answers: Array.from(answers.values()), cancelled });
				}

				function currentQuestion(): Question | undefined {
					return questions[currentTab];
				}

				function currentOptions(): RenderOption[] {
					const q = currentQuestion();
					if (!q) return [];
					const opts: RenderOption[] = [...q.options];
					if (q.allowOther) opts.push({ value: "__other__", label: "Type something.", isOther: true });
					return opts;
				}

				function allAnswered(): boolean {
					return questions.every((q) => answers.has(q.id));
				}

				function advanceAfterAnswer() {
					if (!isMulti) { submit(false); return; }
					if (currentTab < questions.length - 1) currentTab++;
					else currentTab = questions.length; // go to Submit tab
					optionIndex = 0;
					refresh();
				}

				function saveAnswer(id: string, value: string, label: string, wasCustom: boolean, index?: number) {
					answers.set(id, { id, value, label, wasCustom, index });
				}

				editor.onSubmit = (value) => {
					if (!inputQuestionId) return;
					const trimmed = value.trim() || "(no response)";
					saveAnswer(inputQuestionId, trimmed, trimmed, true);
					inputMode = false;
					inputQuestionId = null;
					editor.setText("");
					advanceAfterAnswer();
				};

				function handleInput(data: string) {
					if (inputMode) {
						if (matchesKey(data, Key.escape)) {
							inputMode = false;
							inputQuestionId = null;
							editor.setText("");
							refresh();
							return;
						}
						editor.handleInput(data);
						refresh();
						return;
					}

					const q = currentQuestion();
					const opts = currentOptions();

					if (isMulti) {
						if (matchesKey(data, Key.tab) || matchesKey(data, Key.right)) {
							currentTab = (currentTab + 1) % totalTabs;
							optionIndex = 0;
							refresh();
							return;
						}
						if (matchesKey(data, Key.shift("tab")) || matchesKey(data, Key.left)) {
							currentTab = (currentTab - 1 + totalTabs) % totalTabs;
							optionIndex = 0;
							refresh();
							return;
						}
					}

					// Submit tab
					if (currentTab === questions.length) {
						if (matchesKey(data, Key.enter) && allAnswered()) submit(false);
						else if (matchesKey(data, Key.escape)) submit(true);
						return;
					}

					if (matchesKey(data, Key.up)) { optionIndex = Math.max(0, optionIndex - 1); refresh(); return; }
					if (matchesKey(data, Key.down)) { optionIndex = Math.min(opts.length - 1, optionIndex + 1); refresh(); return; }

					if (matchesKey(data, Key.enter) && q) {
						const opt = opts[optionIndex];
						if (!opt) return;
						if (opt.isOther) {
							inputMode = true;
							inputQuestionId = q.id;
							editor.setText("");
							refresh();
							return;
						}
						saveAnswer(q.id, opt.value, opt.label, false, optionIndex + 1);
						advanceAfterAnswer();
						return;
					}

					if (matchesKey(data, Key.escape)) submit(true);
				}

				function render(width: number): string[] {
					if (cachedLines) return cachedLines;
					const lines: string[] = [];
					const add = (s: string) => lines.push(truncateToWidth(s, width));
					const q = currentQuestion();
					const opts = currentOptions();

					add(theme.fg("accent", "─".repeat(width)));

					// Tab bar (multi-question only)
					if (isMulti) {
						const tabs: string[] = ["  "];
						for (let i = 0; i < questions.length; i++) {
							const question = questions[i];
							if (!question) continue;
							const isActive = i === currentTab;
							const isAnswered = answers.has(question.id);
							const box = isAnswered ? "■" : "□";
							const text = ` ${box} ${question.label} `;
							tabs.push(isActive
								? theme.bg("selectedBg", theme.fg("text", text)) + " "
								: theme.fg(isAnswered ? "success" : "muted", text) + " ");
						}
						const canSubmit = allAnswered();
						const isSubmitActive = currentTab === questions.length;
						const submitText = " ✓ Submit ";
						tabs.push(isSubmitActive
							? theme.bg("selectedBg", theme.fg("text", submitText))
							: theme.fg(canSubmit ? "success" : "dim", submitText));
						add(tabs.join(""));
						lines.push("");
					}

					function renderOptions() {
						for (let i = 0; i < opts.length; i++) {
							const opt = opts[i];
							if (!opt) continue;
							const selected = i === optionIndex;
							const prefix = selected ? theme.fg("accent", "> ") : "  ";
							const color = selected ? "accent" : "text";
							add(prefix + theme.fg(color, `${i + 1}. ${opt.isOther && inputMode ? opt.label + " ✎" : opt.label}`));
							if (opt.description) add(`     ${theme.fg("muted", opt.description)}`);
						}
					}

					if (inputMode && q) {
						add(theme.fg("text", ` ${q.prompt}`));
						lines.push("");
						renderOptions();
						lines.push("");
						add(theme.fg("muted", " Your answer:"));
						for (const line of editor.render(width - 2)) add(` ${line}`);
						lines.push("");
						add(theme.fg("dim", " Enter to submit · Esc to go back"));
					} else if (currentTab === questions.length) {
						add(theme.fg("accent", theme.bold(" Ready to submit")));
						lines.push("");
						for (const question of questions) {
							const answer = answers.get(question.id);
							if (answer) {
								const prefix = answer.wasCustom ? "(wrote) " : "";
								add(`  ${theme.fg("muted", question.label + ":")} ${theme.fg("text", prefix + answer.label)}`);
							}
						}
						lines.push("");
						add(allAnswered()
							? theme.fg("success", " Press Enter to submit")
							: theme.fg("warning", ` Unanswered: ${questions.filter(q => !answers.has(q.id)).map(q => q.label).join(", ")}`));
					} else if (q) {
						add(theme.fg("text", ` ${q.prompt}`));
						lines.push("");
						renderOptions();
					}

					lines.push("");
					if (!inputMode) {
						add(theme.fg("dim", isMulti
							? " Tab/←→ switch · ↑↓ navigate · Enter select · Esc cancel"
							: " ↑↓ navigate · Enter select · Esc cancel"));
					}
					add(theme.fg("accent", "─".repeat(width)));

					cachedLines = lines;
					return lines;
				}

				return {
					render,
					invalidate: () => { cachedLines = undefined; },
					handleInput,
				};
			});

			if (result.cancelled) {
				return {
					content: [{ type: "text", text: "User cancelled — do not proceed, ask again or wait for further instructions." }],
					details: result,
				};
			}

			const answerLines = result.answers.map((a) => {
				const qLabel = questions.find((q) => q.id === a.id)?.label || a.id;
				return a.wasCustom
					? `${qLabel}: user wrote: ${a.label}`
					: `${qLabel}: user selected: ${a.index}. ${a.label}`;
			});

			return {
				content: [{ type: "text", text: answerLines.join("\n") }],
				details: result,
			};
		},

		renderCall(args, theme) {
			const qs = (args.questions as Question[]) || [];
			const labels = qs.map((q) => q.label || q.id).join(", ");
			let text = theme.fg("toolTitle", theme.bold("questionnaire "));
			text += theme.fg("muted", `${qs.length} question${qs.length !== 1 ? "s" : ""}`);
			if (labels) text += theme.fg("dim", `  (${truncateToWidth(labels, 50)})`);
			return new Text(text, 0, 0);
		},

		renderResult(result, _options, theme) {
			const details = result.details as QuestionnaireResult | undefined;
			if (!details) {
				const t = result.content[0];
				return new Text(t?.type === "text" ? t.text : "", 0, 0);
			}
			if (details.cancelled) return new Text(theme.fg("warning", "Cancelled"), 0, 0);
			const lines = details.answers.map((a) => {
				const display = a.index ? `${a.index}. ${a.label}` : a.label;
				const prefix = a.wasCustom ? theme.fg("muted", "(wrote) ") : "";
				return `${theme.fg("success", "✓ ")}${theme.fg("accent", a.id)}: ${prefix}${display}`;
			});
			return new Text(lines.join("\n"), 0, 0);
		},
	});
}
