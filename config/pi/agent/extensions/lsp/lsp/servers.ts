/**
 * LSP server definitions. Add new servers here.
 *
 * Each server specifies:
 * - id: unique identifier
 * - extensions: file extensions it handles
 * - root: async function to find project root from a file path
 * - spawn: launch the server, returns the process handle + optional init options
 */

import * as fs from "node:fs/promises";
import * as path from "node:path";
import { type LSPProcess, launchLSP } from "./launch.js";

export interface LSPServerDef {
	id: string;
	name: string;
	extensions: string[];
	root: (file: string) => Promise<string | undefined>;
	spawn: (
		root: string,
	) => Promise<
		| { process: LSPProcess; initialization?: Record<string, unknown> }
		| undefined
	>;
}

// --- Root detection ---

/** Walk up from file dir looking for any marker file/dir */
function nearestRoot(
	markers: string[],
): (file: string) => Promise<string | undefined> {
	return async (file: string) => {
		let dir = path.resolve(path.dirname(file));
		const root = path.parse(dir).root;
		while (true) {
			for (const m of markers) {
				try {
					await fs.access(path.join(dir, m));
					return dir;
				} catch {
					/* not found */
				}
			}
			if (dir === root) return undefined;
			dir = path.dirname(dir);
		}
	};
}

// --- Server definitions ---

const TS_EXTENSIONS = [".ts", ".tsx", ".js", ".jsx", ".mjs", ".cjs", ".mts", ".cts"];

/** tsgo — Microsoft's native Go port of TypeScript (preferred) */
export const TsgoServer: LSPServerDef = {
	id: "tsgo",
	name: "tsgo",
	extensions: TS_EXTENSIONS,
	root: nearestRoot(["tsconfig.json", "jsconfig.json"]),
	async spawn(root) {
		const home = process.env.HOME ?? process.env.USERPROFILE ?? "";
		const extNm = path.join(home, ".pi", "agent", "extensions", "lsp", "node_modules");
		const extBin = path.join(extNm, ".bin", "tsgo");
		const localBin = path.join(root, "node_modules", ".bin", "tsgo");
		let cmd = "tsgo";
		if (await fileExists(extBin)) cmd = extBin;
		else if (await fileExists(localBin)) cmd = localBin;
		const proc = await launchLSP(cmd, ["--lsp", "--stdio"], root, {
			NODE_PATH: extNm,
		});
		return { process: proc };
	},
};

/** typescript-language-server — Node.js fallback */
export const TypeScriptServer: LSPServerDef = {
	id: "typescript",
	name: "typescript",
	extensions: TS_EXTENSIONS,
	root: nearestRoot(["tsconfig.json", "package.json", "jsconfig.json"]),
	async spawn(root) {
		const localBin = path.join(root, "node_modules", ".bin", "typescript-language-server");
		const cmd = (await fileExists(localBin)) ? localBin : "typescript-language-server";
		const proc = await launchLSP(cmd, ["--stdio"], root);
		const tsserverPath = await findTsserver(root, cmd);
		return {
			process: proc,
			initialization: tsserverPath
				? { tsserver: { path: tsserverPath } }
				: undefined,
		};
	},
};

// --- Registry ---
// tsgo first; if it fails to spawn, service falls back to typescript-language-server
// via the dead-client re-spawn logic in LSPService.ensureClient.

export const SERVERS: LSPServerDef[] = [
	TsgoServer,
	TypeScriptServer,
];

export function getServersForFile(filePath: string): LSPServerDef[] {
	const ext = path.extname(filePath).toLowerCase();
	return SERVERS.filter((s) => s.extensions.includes(ext));
}

// --- Helpers ---

async function fileExists(p: string): Promise<boolean> {
	try {
		await fs.access(p);
		return true;
	} catch {
		return false;
	}
}

async function findTsserver(
	root: string,
	lspCmd: string,
): Promise<string | undefined> {
	const candidates = [
		path.join(root, "node_modules", "typescript", "lib", "tsserver.js"),
		path.join(path.dirname(lspCmd), "..", "typescript", "lib", "tsserver.js"),
		path.join(
			process.cwd(),
			"node_modules",
			"typescript",
			"lib",
			"tsserver.js",
		),
	];
	for (const c of candidates) {
		if (await fileExists(c)) return c;
	}
	return undefined;
}
