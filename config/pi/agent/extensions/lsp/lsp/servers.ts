/**
 * LSP server definitions. Add new servers here.
 *
 * Each server specifies:
 * - id: unique identifier
 * - match: does this server handle the given file path
 * - root: async function to find project root from a file path
 * - spawn: launch the server, returns the process handle + optional init options
 *
 * Binaries resolve from nvim's mason dir (~/.local/share/nvim/mason/bin),
 * falling back to PATH.
 */

import * as fs from "node:fs/promises";
import * as path from "node:path";
import { type LSPProcess, launchLSP } from "./launch.js";

export interface LSPServerDef {
	id: string;
	name: string;
	match: (filePath: string) => boolean;
	root: (file: string) => Promise<string | undefined>;
	spawn: (
		root: string,
	) => Promise<
		| { process: LSPProcess; initialization?: Record<string, unknown> }
		| undefined
	>;
}

// --- Binary resolution ---

const MASON_BIN = path.join(
	process.env.HOME ?? process.env.USERPROFILE ?? "",
	".local",
	"share",
	"nvim",
	"mason",
	"bin",
);

/** Resolve a mason-installed binary, falling back to PATH. */
async function masonBin(name: string): Promise<string> {
	const p = path.join(MASON_BIN, name);
	return (await fileExists(p)) ? p : name;
}

// --- Matchers ---

function byExtension(extensions: string[]): (file: string) => boolean {
	const set = new Set(extensions);
	return (file) => set.has(path.extname(file).toLowerCase());
}

function byBasename(names: string[]): (file: string) => boolean {
	const set = new Set(names.map((n) => n.toLowerCase()));
	return (file) => set.has(path.basename(file).toLowerCase());
}

function isJustfile(file: string): boolean {
	const base = path.basename(file).toLowerCase();
	return base === "justfile" || path.extname(file).toLowerCase() === ".just";
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

/** Root = the file's own directory (per-file servers, no project marker) */
const ownDir = async (file: string) => path.dirname(path.resolve(file));

// --- Server definitions ---

const TS_EXTENSIONS = [".ts", ".tsx", ".js", ".jsx", ".mjs", ".cjs", ".mts", ".cts"];

/** tsgo — Microsoft's native Go port of TypeScript */
export const TsgoServer: LSPServerDef = {
	id: "tsgo",
	name: "tsgo",
	match: byExtension(TS_EXTENSIONS),
	root: nearestRoot(["tsconfig.json", "jsconfig.json"]),
	async spawn(root) {
		const proc = await launchLSP(await masonBin("tsgo"), ["--lsp", "--stdio"], root);
		return { process: proc };
	},
};

/** gopls — official Go language server */
export const GoplsServer: LSPServerDef = {
	id: "gopls",
	name: "gopls",
	match: byExtension([".go"]),
	root: nearestRoot(["go.mod"]),
	async spawn(root) {
		// gopls serves LSP over stdio with no args
		const proc = await launchLSP(await masonBin("gopls"), [], root);
		return { process: proc };
	},
};

/** just-lsp — language server for justfiles (github.com/terror/just-lsp) */
export const JustServer: LSPServerDef = {
	id: "just",
	name: "just",
	match: isJustfile,
	root: nearestRoot([".git", "justfile", "Justfile"]),
	async spawn(root) {
		const proc = await launchLSP(await masonBin("just-lsp"), [], root);
		return { process: proc };
	},
};

const COMPOSE_FILES = [
	"docker-compose.yml",
	"docker-compose.yaml",
	"compose.yml",
	"compose.yaml",
];

/** docker-compose-langserver — validates compose files against the compose spec */
export const DockerComposeServer: LSPServerDef = {
	id: "docker-compose",
	name: "docker-compose",
	match: byBasename(COMPOSE_FILES),
	root: ownDir,
	async spawn(root) {
		const proc = await launchLSP(
			await masonBin("docker-compose-langserver"),
			["--stdio"],
			root,
		);
		return { process: proc };
	},
};

// --- Registry ---

export const SERVERS: LSPServerDef[] = [
	TsgoServer,
	GoplsServer,
	JustServer,
	DockerComposeServer,
];

export function getServersForFile(filePath: string): LSPServerDef[] {
	return SERVERS.filter((s) => s.match(filePath));
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
