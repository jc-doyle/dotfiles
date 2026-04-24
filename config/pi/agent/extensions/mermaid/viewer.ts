/**
 * Pannable full-screen overlay for browsing rendered mermaid diagrams
 * accumulated during the session. Invoked via ctrl+shift+m or /mermaid.
 *
 * Controls:
 *   ←→↑↓            pan 1 cell
 *   shift/alt arrow fast pan (10/5 cells)
 *   home/end        jump left / right
 *   [ / shift+tab   previous diagram
 *   ] / tab         next diagram
 *   esc / ctrl-c    close
 */

import type { ExtensionContext, Theme } from "@mariozechner/pi-coding-agent";
import { Key, matchesKey } from "@mariozechner/pi-tui";

import type { MermaidContextSlice } from "./extract.ts";
import type { RenderCache } from "./render.ts";
import { padToWidth, pickBestPreset, sliceAnsiByColumns } from "./render.ts";

export type ViewerDiagramEntry = {
	id: string;
	block: {
		code: string;
		blockIndex: number;
		startLine: number;
		endLine: number;
	};
	context: MermaidContextSlice;
	source: "assistant" | "user" | "command";
};

const BODY_HEIGHT = 20;

export async function openMermaidViewer(args: {
	ctx: ExtensionContext;
	diagrams: ViewerDiagramEntry[];
	focusIndex?: number;
	cache: RenderCache;
}): Promise<void> {
	const { ctx, diagrams, cache } = args;
	if (!ctx.hasUI || diagrams.length === 0) return;

	const startIndex = args.focusIndex ?? diagrams.length - 1;

	await ctx.ui.custom<void>(
		(tui, theme, _kb, done) => {
			const viewer = new MermaidViewer(diagrams, startIndex, cache, theme, tui, done);
			return {
				render: (w: number) => viewer.render(w),
				handleInput: (data: string) => {
					viewer.handleInput(data);
					tui.requestRender();
				},
				invalidate: () => viewer.invalidate(),
				get focused() {
					return viewer.focused;
				},
				set focused(v: boolean) {
					viewer.focused = v;
				},
			};
		},
		{
			overlay: true,
			overlayOptions: {
				anchor: "top-center",
				width: 100,
				minWidth: 40,
				maxHeight: "80%",
				offsetY: 1,
			},
		},
	);
}

class MermaidViewer {
	private activeIndex: number;
	private panX = 0;
	private panY = 0;
	focused = false;

	private cachedLines?: string[];
	private cachedWidth?: number;

	constructor(
		private diagrams: ViewerDiagramEntry[],
		initialIndex: number,
		private cache: RenderCache,
		private theme: Theme,
		private tui: { requestRender(): void },
		private done: () => void,
	) {
		this.activeIndex = Math.max(0, Math.min(initialIndex, diagrams.length - 1));
	}

	handleInput(data: string): void {
		if (matchesKey(data, Key.escape) || matchesKey(data, Key.ctrl("c"))) {
			this.done();
			return;
		}

		if (matchesKey(data, Key.left)) this.panX -= 1;
		else if (matchesKey(data, Key.right)) this.panX += 1;
		else if (matchesKey(data, Key.up)) this.panY -= 1;
		else if (matchesKey(data, Key.down)) this.panY += 1;
		else if (matchesKey(data, Key.shift("left")) || matchesKey(data, Key.alt("left")))
			this.panX -= 10;
		else if (matchesKey(data, Key.shift("right")) || matchesKey(data, Key.alt("right")))
			this.panX += 10;
		else if (matchesKey(data, Key.shift("up")) || matchesKey(data, Key.alt("up")))
			this.panY -= 5;
		else if (matchesKey(data, Key.shift("down")) || matchesKey(data, Key.alt("down")))
			this.panY += 5;
		else if (matchesKey(data, Key.home)) this.panX = 0;
		else if (matchesKey(data, Key.end)) this.panX = Infinity;
		else if (data === "[" || matchesKey(data, Key.shift("tab"))) {
			this.activeIndex = (this.activeIndex - 1 + this.diagrams.length) % this.diagrams.length;
			this.panX = 0;
			this.panY = 0;
		} else if (data === "]" || matchesKey(data, Key.tab)) {
			this.activeIndex = (this.activeIndex + 1) % this.diagrams.length;
			this.panX = 0;
			this.panY = 0;
		}

		this.invalidate();
	}

	render(width: number): string[] {
		if (this.cachedLines && this.cachedWidth === width) return this.cachedLines;

		const th = this.theme;
		const innerW = Math.max(10, width - 4);
		const dim = (s: string) => th.fg("dim", s);

		const entry = this.diagrams[this.activeIndex];
		if (!entry) return [];

		const { rendered } = pickBestPreset(this.cache, entry.block.code, innerW);

		const content: string[] = [];
		for (const line of entry.context.beforeLines) content.push(dim(line));
		if (entry.context.beforeLines.length > 0) content.push("");
		for (const line of rendered.lines) content.push(line);
		if (entry.context.afterLines.length > 0) content.push("");
		for (const line of entry.context.afterLines) content.push(dim(line));

		const maxPanY = Math.max(0, content.length - BODY_HEIGHT);
		const maxPanX = Math.max(0, rendered.maxWidth - innerW);
		this.panY = Math.max(0, Math.min(this.panY, maxPanY));
		this.panX = Math.max(0, Math.min(this.panX, maxPanX));

		const visible = content.slice(this.panY, this.panY + BODY_HEIGHT);

		const lines: string[] = [];
		const label = ` mermaid ${this.activeIndex + 1}/${this.diagrams.length} `;
		const topFill = "─".repeat(Math.max(0, innerW + 2 - label.length));
		lines.push(`┌${label}${topFill}┐`);

		for (let i = 0; i < BODY_HEIGHT; i++) {
			const raw = i < visible.length ? (visible[i] ?? "") : "";
			const sliced = sliceAnsiByColumns(raw, this.panX, innerW);
			const padded = padToWidth(sliced, innerW);
			lines.push(`│ ${padded} │`);
		}

		const footer = dim("←→↑↓ scroll • [] prev/next • esc close");
		lines.push(`├${"─".repeat(innerW + 2)}┤`);
		lines.push(`│ ${padToWidth(footer, innerW)} │`);
		lines.push(`└${"─".repeat(innerW + 2)}┘`);

		this.cachedLines = lines;
		this.cachedWidth = width;
		return lines;
	}

	invalidate(): void {
		this.cachedLines = undefined;
		this.cachedWidth = undefined;
	}
}
