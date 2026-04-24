/**
 * Minimal LSP extension for pi.
 *
 * - Syncs files to language servers on write/edit
 * - Reports diagnostics (errors/warnings) inline
 * - No auto-install, no formatting, no cascade
 *
 * Add new servers in lsp/servers.ts
 */

import * as fsp from "node:fs/promises";
import * as path from "node:path";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Text } from "@mariozechner/pi-tui";
import { Type } from "@sinclair/typebox";
import { getServersForFile } from "./lsp/servers.js";
import { LSPService } from "./lsp/service.js";

let service: LSPService;
const verbose = false;

const TIMEOUT_MS = 15_000;

function log(msg: string) {
	if (verbose) console.error(`[lsp] ${msg}`);
}

function severityLabel(s: number): string {
	switch (s) {
		case 1:
			return "error";
		case 2:
			return "warning";
		case 3:
			return "info";
		case 4:
			return "hint";
		default:
			return "error";
	}
}

export default function (pi: ExtensionAPI) {
	pi.registerTool({
		name: "lsp_diagnostics",
		label: "LSP Diagnostics",
		description:
			"Run LSP type-checking on a file and return diagnostics (errors/warnings). " +
			"Use after editing TypeScript/JavaScript files to catch errors.",
		promptSnippet: "Check a file for LSP type errors",
		promptGuidelines: [
			"Use lsp_diagnostics after editing .ts/.tsx/.js/.jsx files to verify type correctness.",
		],
		parameters: Type.Object({
			path: Type.String({ description: "Path to the file to check" }),
		}),

		async execute(_id, params, _signal, _onUpdate, _ctx) {
			if (!service) {
				throw new Error("LSP service not started — no active session");
			}

			const filePath = path.resolve(params.path);
			if (getServersForFile(filePath).length === 0) {
				throw new Error(
					`No LSP server registered for extension: ${path.extname(filePath)}`,
				);
			}

			const content = await fsp.readFile(filePath, "utf-8");
			await service.syncFile(filePath, content);
			const diags = await service.getDiagnostics(filePath, TIMEOUT_MS);

			const parts: string[] = [];

			// LSP diagnostics
			const actionable = diags.filter((d) => d.severity <= 2);
			if (actionable.length > 0) {
				parts.push(
					actionable
						.map(
							(d) =>
								`L${d.range.start.line + 1}:${d.range.start.character + 1} ${severityLabel(d.severity)}: ${d.message}`,
						)
						.join("\n"),
				);
			}

			const text = parts.length > 0 ? parts.join("\n") : "✓ no issues";

			return {
				content: [{ type: "text", text }],
				details: { file: filePath, diagnostics: diags },
			};
		},

		renderCall(args, theme) {
			return new Text(
				theme.fg("toolTitle", theme.bold("lsp_diagnostics ")) +
					theme.fg("muted", path.basename(args.path)),
				0,
				0,
			);
		},

		renderResult(result, { expanded }, theme) {
			const details = result.details as
				| {
						diagnostics: Array<{
							severity: number;
							message: string;
							range: { start: { line: number } };
						}>;
				  }
				| undefined;
			const diags = details?.diagnostics ?? [];
			const errors = diags.filter((d) => d.severity === 1).length;
			const warnings = diags.filter((d) => d.severity === 2).length;

			if (diags.length === 0) {
				return new Text(theme.fg("success", "✓ clean"), 0, 0);
			}

			const parts: string[] = [];
			if (errors > 0) parts.push(theme.fg("error", `${errors} err`));
			if (warnings > 0) parts.push(theme.fg("warning", `${warnings} warn`));
			const info = diags.length - errors - warnings;
			if (info > 0) parts.push(theme.fg("dim", `${info} info`));

			let line = parts.join(" ");

			if (expanded) {
				for (const d of diags.filter((d) => d.severity <= 2)) {
					const color = d.severity === 1 ? "error" : "warning";
					line +=
						"\n  " +
						theme.fg(color, `L${d.range.start.line + 1}: ${d.message}`);
				}
			}

			return new Text(line, 0, 0);
		},
	});

	pi.on("session_start", async (_event, ctx) => {
		service = new LSPService(ctx.cwd);
		service.onStatus((id, _name, alive) => {
			if (alive) {
				ctx.ui.setStatus(
					`lsp-${id}`,
					ctx.ui.theme.fg("dim", ctx.ui.theme.bold(`⚙ ${id}`)),
				);
			} else {
				ctx.ui.setStatus(`lsp-${id}`, undefined);
			}
		});
		log("LSP service started");
	});

	pi.on("session_shutdown", async () => {
		await service?.shutdown();
		log("LSP service shut down");
	});

	pi.on("tool_result", async (event, _ctx) => {
		if (!service) return;
		if (event.toolName !== "write" && event.toolName !== "edit") return;

		const input = event.input as { path?: string };
		if (!input?.path) return;

		const filePath = path.resolve(input.path);

		const hasLSP = getServersForFile(filePath).length > 0;
		if (!hasLSP) return;

		try {
			let lspText: string | null = null;
			let hasErrors = false;

			const content = await fsp.readFile(filePath, "utf-8");
			await service.syncFile(filePath, content);
			const diags = await service.getDiagnostics(filePath, 3000);
			hasErrors = diags.some((d) => d.severity === 1);
			const actionable = diags.filter((d) => d.severity <= 2);
			if (actionable.length > 0) {
				lspText = actionable
					.map(
						(d) =>
							`L${d.range.start.line + 1}:${d.range.start.character + 1} ${severityLabel(d.severity)}: ${d.message}`,
					)
					.join("\n");
			}

			// Collect blocks — only inject if there's something to report
			const blocks: Array<{ type: "text"; text: string }> = [];
			if (lspText) blocks.push({ type: "text", text: lspText });
			if (blocks.length === 0) return;

			return {
				content: [...event.content, ...blocks],
				...(hasErrors ? { isError: false } : {}),
			};
		} catch (err) {
			log(`check failed: ${err}`);
		}
	});
}
