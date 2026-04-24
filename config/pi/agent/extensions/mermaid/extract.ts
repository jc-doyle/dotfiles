/**
 * Fenced mermaid block extraction.
 *
 * We scan line-by-line rather than with a global regex because model
 * output often has nested fences, stray backticks, or unclosed blocks.
 * The parser stays simple and forgiving.
 */

export type MermaidBlock = {
	code: string;
	blockIndex: number;
	startLine: number;
	endLine: number;
};

export type MermaidContextSlice = {
	beforeLines: string[];
	afterLines: string[];
};

const OPENING_FENCE = /^\s*`{3,}\s*mermaid\b/i;
const CLOSING_FENCE = /^\s*`{3,}\s*$/;

export function extractMermaidBlocks(text: string, maxBlocks = 10): MermaidBlock[] {
	const lines = text.replace(/\r\n?/g, "\n").split("\n");
	const blocks: MermaidBlock[] = [];
	let i = 0;

	while (i < lines.length && blocks.length < maxBlocks) {
		const line = lines[i] ?? "";
		if (OPENING_FENCE.test(line)) {
			const startLine = i;
			i++;
			const codeLines: string[] = [];
			while (i < lines.length && !CLOSING_FENCE.test(lines[i] ?? "")) {
				codeLines.push(lines[i] ?? "");
				i++;
			}
			const endLine = i;
			const code = codeLines.join("\n").trimEnd();
			if (code.length > 0) {
				blocks.push({ code, blockIndex: blocks.length, startLine, endLine });
			}
		}
		i++;
	}
	return blocks;
}

export function captureContextSlice(
	text: string,
	block: MermaidBlock,
	radius = 5,
): MermaidContextSlice {
	const lines = text.replace(/\r\n?/g, "\n").split("\n");
	const beforeLines = lines.slice(Math.max(0, block.startLine - radius), block.startLine);
	const afterLines = lines.slice(
		block.endLine + 1,
		Math.min(lines.length, block.endLine + 1 + radius),
	);
	stripTrailingEmpty(beforeLines);
	stripTrailingEmpty(afterLines);
	return { beforeLines, afterLines };
}

/** Handle pi message content: string or ContentPart[]. */
export function extractText(content: unknown): string {
	if (typeof content === "string") return content;
	if (Array.isArray(content)) {
		return content
			.filter(
				(p): p is { text: string } =>
					typeof p === "object" && p !== null && "text" in p && typeof (p as any).text === "string",
			)
			.map((p) => p.text)
			.join("\n");
	}
	return "";
}

function stripTrailingEmpty(arr: string[]): void {
	while (arr.length > 0 && (arr[arr.length - 1] ?? "").trim() === "") {
		arr.pop();
	}
}

/**
 * First non-comment token gives us the diagram type (graph, flowchart,
 * sequenceDiagram, etc). Returned verbatim so callers can decide what
 * they support.
 */
export function getMermaidTypeToken(code: string): string | null {
	for (const line of code.split(/\r?\n/)) {
		const trimmed = line.trim();
		if (!trimmed) continue;
		if (trimmed.startsWith("%%")) continue;
		return trimmed.split(/\s+/)[0] ?? null;
	}
	return null;
}
