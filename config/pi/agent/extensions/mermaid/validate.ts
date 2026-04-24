/**
 * Mermaid validation via the renderer itself.
 *
 * `beautiful-mermaid` has its own parser and throws on invalid input.
 * We piggyback on that: if `renderMermaidASCII` completes, the diagram
 * is syntactically valid AND we already have the ASCII we need. If it
 * throws, we treat the thrown message as the validation error and
 * feed it back to the agent for self-correction.
 *
 * This avoids the `mermaid` package's DOMPurify dependency (which
 * doesn't load cleanly in Node without a DOM shim) entirely.
 */

import { renderMermaidASCII } from "beautiful-mermaid";

export type ValidationResult =
	| { ok: true }
	| { ok: false; kind: "syntax-error"; message: string };

/**
 * Try a minimal render. We discard the output — this is purely a
 * syntax probe. Real rendering happens later with width-adaptive
 * presets via the cache, so the throwaway cost is low and the
 * positive result is itself a full render the cache will find again.
 */
export async function validateMermaid(code: string): Promise<ValidationResult> {
	try {
		renderMermaidASCII(code, {
			paddingX: 2,
			boxBorderPadding: 1,
			colorMode: "none",
		});
		return { ok: true };
	} catch (err) {
		const message = err instanceof Error ? err.message : String(err);
		return { ok: false, kind: "syntax-error", message: cleanError(message) };
	}
}

function cleanError(message: string): string {
	return message
		.replace(/\x1b\[[0-9;]*m/g, "")
		.split("\n")
		.map((line) => line.replace(/\s+$/, ""))
		.filter((line) => line.trim().length > 0)
		.join("\n")
		.slice(0, 2000);
}
