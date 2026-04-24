/**
 * ASCII rendering with width-adaptive preset selection + LRU cache.
 *
 * `beautiful-mermaid` is our renderer. We render once per (hash, preset)
 * and cache the result. `pickBestPreset` walks roomy → tightest and stops
 * at the first variant that fits the caller's width.
 *
 * colorMode is forced to "none" — pi-tui owns theming, and library ANSI
 * colors would fight the theme.
 */

import { visibleWidth } from "@mariozechner/pi-tui";
import { renderMermaidASCII } from "beautiful-mermaid";
import { createHash } from "node:crypto";

export type MermaidPreset = {
	key: string;
	paddingX: number;
	boxBorderPadding: number;
};

export type RenderedDiagram = {
	ansi: string;
	lines: string[];
	maxWidth: number;
	lineCount: number;
};

export type RenderCache = {
	map: Map<string, RenderedDiagram>;
	maxEntries: number;
};

export const PRESETS: MermaidPreset[] = [
	{ key: "roomy", paddingX: 4, boxBorderPadding: 2 },
	{ key: "normal", paddingX: 2, boxBorderPadding: 1 },
	{ key: "tight", paddingX: 1, boxBorderPadding: 1 },
	{ key: "tighter", paddingX: 1, boxBorderPadding: 0 },
	{ key: "tightest", paddingX: 0, boxBorderPadding: 0 },
];

export function hashCode(code: string): string {
	return createHash("sha256").update(code).digest("hex").slice(0, 10);
}

export function createCache(maxEntries = 128): RenderCache {
	return { map: new Map(), maxEntries };
}

export function renderWithCache(
	cache: RenderCache,
	code: string,
	preset: MermaidPreset,
): RenderedDiagram {
	const key = `${hashCode(code)}|${preset.key}`;
	const existing = cache.map.get(key);
	if (existing) {
		cache.map.delete(key);
		cache.map.set(key, existing);
		return existing;
	}

	const raw = renderMermaidASCII(code, {
		paddingX: preset.paddingX,
		boxBorderPadding: preset.boxBorderPadding,
		colorMode: "none",
	});

	const ansi = raw.trimEnd();
	const lines = ansi.split("\n");
	let maxWidth = 0;
	for (const line of lines) {
		const w = visibleWidth(line);
		if (w > maxWidth) maxWidth = w;
	}

	const rendered: RenderedDiagram = { ansi, lines, maxWidth, lineCount: lines.length };
	cache.map.set(key, rendered);

	if (cache.map.size > cache.maxEntries) {
		const oldest = cache.map.keys().next().value;
		if (oldest) cache.map.delete(oldest);
	}

	return rendered;
}

export function pickBestPreset(
	cache: RenderCache,
	code: string,
	width: number,
): { preset: MermaidPreset; rendered: RenderedDiagram; overflowed: boolean } {
	let last: { preset: MermaidPreset; rendered: RenderedDiagram } | undefined;

	for (const preset of PRESETS) {
		const rendered = renderWithCache(cache, code, preset);
		last = { preset, rendered };
		if (rendered.maxWidth <= width) {
			return { preset, rendered, overflowed: false };
		}
	}

	return { ...last!, overflowed: true };
}

// ── ANSI-safe column slicing (needed by the pannable viewer) ─────────────

/**
 * Slice a line containing ANSI escapes by visible column range.
 *
 * Naive .slice() breaks because escape sequences consume characters
 * but don't render. We walk the string, keep escapes (they set color
 * state for what follows), and only emit visible chars within window.
 * Always appends a reset to prevent mid-sequence color bleed.
 */
export function sliceAnsiByColumns(line: string, startCol: number, maxCols: number): string {
	let col = 0;
	let out = "";
	let i = 0;

	while (i < line.length) {
		if (line[i] === "\x1b" && line[i + 1] === "[") {
			const seq = readAnsiEscape(line, i);
			if (seq) {
				if (col < startCol + maxCols) out += seq;
				i += seq.length;
				continue;
			}
		}

		if (col >= startCol && col < startCol + maxCols) {
			out += line[i];
		}
		col++;
		if (col >= startCol + maxCols) break;
		i++;
	}

	return out + "\x1b[0m";
}

function readAnsiEscape(line: string, start: number): string | undefined {
	if (line[start] !== "\x1b" || line[start + 1] !== "[") return undefined;
	let end = start + 2;
	while (end < line.length) {
		const code = line.charCodeAt(end);
		if (code >= 0x40 && code <= 0x7e) return line.slice(start, end + 1);
		end++;
	}
	return undefined;
}

export function padToWidth(s: string, target: number): string {
	const w = visibleWidth(s);
	if (w >= target) return s;
	return s + " ".repeat(target - w);
}
