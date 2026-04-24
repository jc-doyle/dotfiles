/**
 * pi-ext-mermaid — render mermaid diagrams as ASCII in the TUI, with
 * syntax validation feeding errors back to the model for self-correction.
 *
 * Data flow per assistant/user message:
 *
 *   message_end  ──┐
 *   input        ──┤→ extractMermaidBlocks → validateMermaid
 *                  │                              │
 *                  │         ok? ─────────────────┤
 *                  │         │                    │
 *                  │         ▼                    ▼
 *                  │  sendMessage              sendMessage
 *                  │  (display + render)       (display + compact error)
 *                  │  content: ""              content: "[mermaid:error] …"
 *                  │  deliverAs: "nextTurn"    deliverAs: "nextTurn"
 *                  │                    │
 *                  │                    └──► model sees the error next turn
 *                  │                         and can fix its own diagram
 *                  ▼
 *           context event strips only "" payloads —
 *           error messages stay in context so the fix signal reaches the LLM.
 *
 * The renderer is a MessageRenderer registered for our custom type;
 * valid diagrams render inline as ASCII, invalid diagrams render as a
 * compact error panel showing the parser message.
 */

import type {
	ExtensionAPI,
	ExtensionContext,
	MessageRenderer,
	SessionEntry,
} from "@mariozechner/pi-coding-agent";
import { getMarkdownTheme, keyHint } from "@mariozechner/pi-coding-agent";
import { Box, Spacer, Text, truncateToWidth, type Component } from "@mariozechner/pi-tui";

import {
	captureContextSlice,
	extractMermaidBlocks,
	extractText,
	type MermaidBlock,
	type MermaidContextSlice,
} from "./extract.ts";
import { createCache, hashCode, pickBestPreset, type RenderCache } from "./render.ts";
import { validateMermaid } from "./validate.ts";
import { openMermaidViewer, type ViewerDiagramEntry } from "./viewer.ts";

// ── constants ────────────────────────────────────────────────────────────

const CUSTOM_TYPE = "pi-mermaid";
const MAX_CODE_LENGTH = 20_000;
const MAX_SOURCE_LINES = 500;
const MAX_BLOCKS_PER_MESSAGE = 6;
const MAX_SESSION_DIAGRAMS = 100;
const COLLAPSED_LINES = 12;

// ── message details ──────────────────────────────────────────────────────

type DiagramDetails = {
	id: string;
	code: string;
	source: "assistant" | "user" | "command";
	context: MermaidContextSlice;
	validation: { ok: true } | { ok: false; kind: "syntax-error"; message: string };
};

// ── helpers ──────────────────────────────────────────────────────────────

function makeId(block: MermaidBlock): string {
	return `${Date.now()}:${block.blockIndex}:${hashCode(block.code)}`;
}

function toViewerEntry(d: DiagramDetails): ViewerDiagramEntry {
	return {
		id: d.id,
		block: { code: d.code, blockIndex: 0, startLine: 0, endLine: 0 },
		context: d.context,
		source: d.source,
	};
}

function getLastAssistantText(entries: SessionEntry[]): string | null {
	for (let i = entries.length - 1; i >= 0; i--) {
		const entry = entries[i];
		if (!entry || entry.type !== "message") continue;
		if (entry.message.role !== "assistant") continue;
		const text = extractText(entry.message.content);
		if (text.trim()) return text;
	}
	return null;
}

// ── extension ────────────────────────────────────────────────────────────

export default function mermaidExtension(pi: ExtensionAPI): void {
	const cache: RenderCache = createCache(128);
	let sessionDiagrams: DiagramDetails[] = [];

	const pushDiagram = (d: DiagramDetails) => {
		sessionDiagrams.push(d);
		if (sessionDiagrams.length > MAX_SESSION_DIAGRAMS) {
			sessionDiagrams = sessionDiagrams.slice(-MAX_SESSION_DIAGRAMS);
		}
	};

	// ── renderer ────────────────────────────────────────────────────────

	const renderer: MessageRenderer<DiagramDetails> = (message, { expanded }, theme) => {
		const d = message.details as DiagramDetails | undefined;
		const box = new Box(1, 1, (t: string) => theme.bg("customMessageBg", t));

		if (!d) {
			box.addChild(new Text(theme.fg("dim", "(no diagram data)"), 0, 0));
			return box;
		}

		// Syntax errors render as a compact error panel; beautiful-mermaid's
		// parser is the oracle — if it threw, we show what it said.
		if (!d.validation.ok) {
			const validation = d.validation;
			const errComponent: Component = {
				render: (width: number): string[] => {
					const w = Math.max(1, width);
					const title = theme.fg("error", theme.bold("Mermaid (syntax error)"));
					const lines: string[] = [truncateToWidth(title, w)];
					for (const line of validation.message.split("\n")) {
						lines.push(truncateToWidth(theme.fg("muted", line), w));
					}
					return lines;
				},
				invalidate: () => {},
			};
			box.addChild(errComponent);

			if (expanded) {
				box.addChild(new Spacer(1));
				appendSourceBlock(box, d.code);
			}
			return box;
		}

		// Valid: render ASCII with width-adaptive preset.
		const asciiComponent: Component = {
			render: (width: number): string[] => {
				const w = Math.max(1, width);
				try {
					const { preset, rendered, overflowed } = pickBestPreset(cache, d.code, w);
					const lines: string[] = [];
					let label = theme.fg("customMessageLabel", theme.bold("Mermaid"));
					if (overflowed) label += " " + theme.fg("dim", `[${preset.key}]`);
					lines.push(truncateToWidth(label, w));

					const hasOverflow = rendered.lineCount > COLLAPSED_LINES;
					const isExpanded = expanded || !hasOverflow;
					const visible = isExpanded
						? rendered.lines
						: rendered.lines.slice(0, COLLAPSED_LINES);

					for (const line of visible) {
						lines.push(truncateToWidth(line, w, ""));
					}

					if (hasOverflow && !isExpanded) {
						const remaining = rendered.lineCount - COLLAPSED_LINES;
						const hint = `... (${remaining} more lines, ${keyHint("app.tools.expand", "to expand")})`;
						lines.push(truncateToWidth(theme.fg("muted", hint), w));
					}

					if (overflowed) {
						lines.push(
							truncateToWidth(
								theme.fg("dim", "diagram wider than terminal — ctrl+shift+m to pan"),
								w,
							),
						);
					}

					return lines;
				} catch (err) {
					const msg = err instanceof Error ? err.message : String(err);
					return [truncateToWidth(theme.fg("error", `render error: ${msg}`), w)];
				}
			},
			invalidate: () => {},
		};

		box.addChild(asciiComponent);

		if (expanded) {
			box.addChild(new Spacer(1));
			appendSourceBlock(box, d.code);
		}

		return box;
	};

	pi.registerMessageRenderer(CUSTOM_TYPE, renderer);

	// ── block processing ─────────────────────────────────────────────────

	async function processBlocks(
		blocks: MermaidBlock[],
		fullText: string,
		source: DiagramDetails["source"],
		ctx: ExtensionContext,
	): Promise<void> {
		for (const block of blocks) {
			if (block.code.length > MAX_CODE_LENGTH) {
				if (ctx.hasUI) {
					ctx.ui.notify(
						`Mermaid block too large (${block.code.length} chars, max ${MAX_CODE_LENGTH})`,
						"warning",
					);
				}
				continue;
			}
			const lineCount = block.code.split("\n").length;
			if (lineCount > MAX_SOURCE_LINES) {
				if (ctx.hasUI) {
					ctx.ui.notify(
						`Mermaid block too large (${lineCount} lines, max ${MAX_SOURCE_LINES})`,
						"warning",
					);
				}
				continue;
			}

			const validation = await validateMermaid(block.code);

			// Context-visible content:
			//   valid  → "" (filtered out of `context` event)
			//   error  → "[mermaid:error] …" fed back for self-correction
			let content = "";
			if (!validation.ok) {
				const hash = hashCode(block.code);
				content = `[mermaid:error][hash:${hash}] ${validation.message}`;
			}

			const details: DiagramDetails = {
				id: makeId(block),
				code: block.code,
				source,
				context: captureContextSlice(fullText, block),
				validation,
			};

			pushDiagram(details);

			// No deliverAs option: we only call this after the agent has
			// finished streaming (agent_end, input, command), so we go through
			// the immediate-display path (push to state + emit message_start/end).
			// Using deliverAs:"nextTurn" here would defer display to the user's
			// next message, which is exactly the bug we're avoiding.
			pi.sendMessage({
				customType: CUSTOM_TYPE,
				content,
				display: true,
				details,
			});

			if (ctx.hasUI && !validation.ok) {
				ctx.ui.notify(`Mermaid syntax error: ${firstLine(validation.message)}`, "error");
			}
		}
	}

	// ── events ──────────────────────────────────────────────────────────

	/**
	 * agent_end fires inside the agent run, while isStreaming is still
	 * true. sendMessage during that window goes to steer()/followUp() or
	 * _pendingNextTurnMessages — all of which defer display until the
	 * user's next prompt. The only immediate-display path inside
	 * sendCustomMessage runs when isStreaming === false, which only happens
	 * after finishRun() fires in the agent's `finally` block, i.e. *after*
	 * all agent_end handlers have returned.
	 *
	 * We hop off the event handler with setImmediate so finishRun() runs
	 * first; our sendMessage then lands in the happy path that emits
	 * message_start / message_end and renders inline.
	 */
	pi.on("agent_end", async (event, ctx) => {
		let assistantText = "";
		for (let i = event.messages.length - 1; i >= 0; i--) {
			const msg = event.messages[i];
			if (!msg || msg.role !== "assistant") continue;
			if ((msg as any).customType === CUSTOM_TYPE) continue;
			const text = extractText(msg.content);
			if (text.trim()) {
				assistantText = text;
				break;
			}
		}
		if (!assistantText) return;

		const blocks = extractMermaidBlocks(assistantText, MAX_BLOCKS_PER_MESSAGE + 1);
		if (blocks.length === 0) return;

		if (blocks.length > MAX_BLOCKS_PER_MESSAGE && ctx.hasUI) {
			ctx.ui.notify(
				`Found ${blocks.length} mermaid blocks, rendering first ${MAX_BLOCKS_PER_MESSAGE}`,
				"warning",
			);
		}

		const limited = blocks.slice(0, MAX_BLOCKS_PER_MESSAGE);

		setImmediate(() => {
			void processBlocks(limited, assistantText, "assistant", ctx).catch((err) => {
				if (ctx.hasUI) {
					ctx.ui.notify(
						`Mermaid render failed: ${err instanceof Error ? err.message : String(err)}`,
						"error",
					);
				}
			});
		});
	});

	pi.on("input", async (event, ctx) => {
		if (event.source === "extension") return { action: "continue" as const };

		const text = typeof event.text === "string" ? event.text : "";
		if (!text) return { action: "continue" as const };

		const blocks = extractMermaidBlocks(text, MAX_BLOCKS_PER_MESSAGE + 1);
		if (blocks.length === 0) return { action: "continue" as const };

		await processBlocks(blocks.slice(0, MAX_BLOCKS_PER_MESSAGE), text, "user", ctx);
		return { action: "continue" as const };
	});

	/**
	 * Keep token usage lean: our custom messages with empty content
	 * are pure TUI affordances — strip them from the agent context.
	 * Error messages (non-empty content) stay so the model can self-fix.
	 */
	pi.on("context", async (event) => {
		return {
			messages: event.messages.filter((m: any) => {
				if (m.customType !== CUSTOM_TYPE) return true;
				// keep if it carries an error signal
				const text =
					typeof m.content === "string"
						? m.content
						: Array.isArray(m.content)
							? m.content
									.map((p: any) => (p && typeof p.text === "string" ? p.text : ""))
									.join("")
							: "";
				return text.trim().length > 0;
			}),
		};
	});

	// ── commands & shortcuts ────────────────────────────────────────────

	pi.registerCommand("mermaid", {
		description: "Re-render mermaid blocks from the last assistant message",
		handler: async (_args, ctx) => {
			const lastAssistant = getLastAssistantText(ctx.sessionManager.getBranch());
			if (!lastAssistant) {
				if (ctx.hasUI) ctx.ui.notify("No assistant message found", "warning");
				return;
			}
			const blocks = extractMermaidBlocks(lastAssistant, MAX_BLOCKS_PER_MESSAGE + 1);
			if (blocks.length === 0) {
				if (ctx.hasUI) ctx.ui.notify("No mermaid blocks in last message", "info");
				return;
			}
			await processBlocks(
				blocks.slice(0, MAX_BLOCKS_PER_MESSAGE),
				lastAssistant,
				"command",
				ctx,
			);
		},
	});

	pi.registerShortcut("ctrl+shift+m", {
		description: "Open mermaid diagram viewer",
		handler: async (ctx) => {
			if (sessionDiagrams.length === 0) {
				if (ctx.hasUI) ctx.ui.notify("No mermaid diagrams in session", "info");
				return;
			}
			await openMermaidViewer({
				ctx,
				diagrams: sessionDiagrams.map(toViewerEntry),
				cache,
			});
		},
	});
}

// ── utilities ────────────────────────────────────────────────────────────

function appendSourceBlock(box: Box, source: string): void {
	const md = getMarkdownTheme();
	const indent = md.codeBlockIndent ?? "  ";
	const normalized = source.replace(/\s+$/g, "");
	const highlighted = md.highlightCode?.(normalized, "mermaid");
	const codeLines = highlighted ?? normalized.split("\n").map((line) => md.codeBlock(line));
	const rendered = [
		md.codeBlockBorder("```mermaid"),
		...codeLines.map((line) => `${indent}${line}`),
		md.codeBlockBorder("```"),
	].join("\n");
	box.addChild(new Text(rendered, 0, 0));
}

function firstLine(s: string): string {
	const idx = s.indexOf("\n");
	return idx === -1 ? s : s.slice(0, idx);
}
