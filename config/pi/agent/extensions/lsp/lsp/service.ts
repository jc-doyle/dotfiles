/**
 * Minimal LSP service: manages one client per server/root pair.
 * Syncs files on write/edit, collects diagnostics.
 */

import { EventEmitter } from "node:events";
import { fileURLToPath, pathToFileURL } from "node:url";
import {
	createMessageConnection,
	type MessageConnection,
	StreamMessageReader,
	StreamMessageWriter,
} from "vscode-jsonrpc/node.js";
import { type LSPProcess } from "./launch.js";
import { getServersForFile, type LSPServerDef } from "./servers.js";

// --- Types ---

export interface LSPDiagnostic {
	severity: 1 | 2 | 3 | 4;
	message: string;
	range: {
		start: { line: number; character: number };
		end: { line: number; character: number };
	};
	code?: string | number;
	source?: string;
}

interface ClientEntry {
	serverId: string;
	root: string;
	connection: MessageConnection;
	process: LSPProcess;
	alive: boolean;
	openDocs: Set<string>;
	versions: Map<string, number>;
	diagnostics: Map<string, LSPDiagnostic[]>;
	diagEmitter: EventEmitter;
	hasDiagnosticProvider: boolean;
}

// --- Language ID map ---

const LANG_IDS: Record<string, string> = {
	".ts": "typescript",
	".tsx": "typescriptreact",
	".mts": "typescript",
	".cts": "typescript",
	".js": "javascript",
	".jsx": "javascriptreact",
	".mjs": "javascript",
	".cjs": "javascript",
	".py": "python",
	".go": "go",
	".rs": "rust",
	".json": "json",
	".yaml": "yaml",
	".yml": "yaml",
	".sh": "shellscript",
	".bash": "shellscript",
	".css": "css",
	".scss": "scss",
	".html": "html",
};

function getLangId(filePath: string): string {
	const ext = filePath.substring(filePath.lastIndexOf("."));
	return LANG_IDS[ext] ?? "plaintext";
}

function normalize(p: string): string {
	return p.replace(/\\/g, "/");
}

function pathKey(filePath: string): string {
	return normalize(filePath);
}

// --- Service ---

export type LSPStatusListener = (serverId: string, serverName: string, alive: boolean) => void;

export class LSPService {
	private clients = new Map<string, ClientEntry>(); // "serverId:root"
	private statusListener?: LSPStatusListener;
	constructor(_cwd: string) {}

	/** Register a callback for server start/stop events. */
	onStatus(fn: LSPStatusListener) {
		this.statusListener = fn;
	}

	private notifyStatus(id: string, name: string, alive: boolean) {
		this.statusListener?.(id, name, alive);
	}

	/** Try each registered server in priority order, return first one that can spawn. */
	private async getFirstAliveServer(filePath: string): Promise<LSPServerDef | undefined> {
		const candidates = getServersForFile(filePath);
		for (const server of candidates) {
			try {
				const root = await server.root(filePath);
				if (!root) continue;
				const client = await this.ensureClient(server, root);
				if (client) return server;
			} catch { /* skip */ }
		}
		return undefined;
	}

	/** Sync file content to relevant LSP servers (open or update). */
	async syncFile(filePath: string, content: string): Promise<void> {
		const server = await this.getFirstAliveServer(filePath);
		if (!server) return;
		try {
			const root = await server.root(filePath);
			if (!root) return;
			const client = await this.ensureClient(server, root);
			if (!client) return;
			await this.openOrUpdate(client, filePath, content);
		} catch { /* skip */ }
	}

	/** Get diagnostics for a file, waiting up to timeoutMs. */
	async getDiagnostics(
		filePath: string,
		timeoutMs = 3000,
	): Promise<LSPDiagnostic[]> {
		const server = await this.getFirstAliveServer(filePath);
		if (!server) return [];
		try {
			const root = await server.root(filePath);
			if (!root) return [];
			const client = await this.ensureClient(server, root);
			if (!client) return [];

			if (client.hasDiagnosticProvider) {
				// Pull-based: send textDocument/diagnostic request
				const uri = pathToFileURL(filePath).href;
				try {
					const result = await timedRequest(client.connection, "textDocument/diagnostic", {
						textDocument: { uri },
					}, timeoutMs);
					const items = (result as Record<string, unknown>)?.items as LSPDiagnostic[] | undefined;
					return items ?? [];
				} catch (e) {
					if (e instanceof TimeoutError) {
						// Return special sentinel so caller can report timeout
						return [{ severity: 4 as const, message: `LSP timed out after ${timeoutMs}ms`, range: { start: { line: 0, character: 0 }, end: { line: 0, character: 0 } } }];
					}
					return [];
				}
			}

			// Push-based (typescript-language-server): wait for publishDiagnostics
			client.diagnostics.delete(pathKey(filePath));
			await this.waitForDiags(client, filePath, timeoutMs);
			return client.diagnostics.get(pathKey(filePath)) ?? [];
		} catch { return []; }
	}

	async shutdown(): Promise<void> {
		for (const client of this.clients.values()) {
			client.alive = false;

			// Kill process first so no more messages arrive
			try { client.process.process.kill(); } catch { /* ok */ }

			// Detach streams before disposing connection to prevent
			// ERR_STREAM_DESTROYED from queued writes on destroyed streams
			try { client.process.process.stdin?.destroy(); } catch { /* ok */ }
			try { client.process.process.stdout?.destroy(); } catch { /* ok */ }
			try { client.process.process.stderr?.destroy(); } catch { /* ok */ }

			try {
				client.connection.dispose();
			} catch {
				/* ok */
			}
		}
		this.clients.clear();
	}

	// --- Private ---

	private async ensureClient(
		server: LSPServerDef,
		root: string,
	): Promise<ClientEntry | undefined> {
		const key = `${server.id}:${normalize(root)}`;
		const existing = this.clients.get(key);
		if (existing) {
			if (existing.alive) return existing;
			// Dead — clean up and re-spawn
			try {
				existing.process.process.kill();
			} catch {
				/* ok */
			}
			try {
				existing.connection.dispose();
			} catch {
				/* ok */
			}
			this.clients.delete(key);
		}

		const spawned = await server.spawn(root).catch(() => undefined);
		if (!spawned) return undefined;

		const connection = createMessageConnection(
			new StreamMessageReader(spawned.process.stdout),
			new StreamMessageWriter(spawned.process.stdin),
		);

		const client: ClientEntry = {
			serverId: server.id,
			root,
			connection,
			process: spawned.process,
			alive: true,
			openDocs: new Set(),
			versions: new Map(),
			diagnostics: new Map(),
			diagEmitter: new EventEmitter(),
			hasDiagnosticProvider: false,
		};

		// Handle incoming diagnostics
		connection.onNotification(
			"textDocument/publishDiagnostics" as never,
			(params: { uri: string; diagnostics?: LSPDiagnostic[] }) => {
				const fp = uriToPath(params.uri);
				client.diagnostics.set(pathKey(fp), params.diagnostics ?? []);
				client.diagEmitter.emit("diag", pathKey(fp));
			},
		);

		// Boilerplate request handlers
		connection.onRequest("workspace/workspaceFolders" as never, () => [
			{ name: "root", uri: pathToFileURL(root).href },
		]);
		connection.onRequest("client/registerCapability" as never, async () => {});
		connection.onRequest(
			"client/unregisterCapability" as never,
			async () => {},
		);
		connection.onRequest("workspace/configuration" as never, async () => [
			spawned.initialization ?? {},
		]);
		connection.onRequest(
			"window/workDoneProgress/create" as never,
			async () => {},
		);

		// Lifecycle
		connection.onError(() => {
			client.alive = false;
			this.notifyStatus(server.id, server.name, false);
		});
		connection.onClose(() => {
			client.alive = false;
			this.notifyStatus(server.id, server.name, false);
		});
		spawned.process.process.on("exit", () => {
			client.alive = false;
			this.notifyStatus(server.id, server.name, false);
		});

		connection.listen();

		// Initialize
		try {
			const initResult = await safeRequest(connection, "initialize", {
				processId: process.pid,
				rootUri: pathToFileURL(root).href,
				capabilities: {
					workspace: { workspaceFolders: true, configuration: true },
					textDocument: {
						synchronization: { didOpen: true, didChange: true },
						publishDiagnostics: { versionSupport: true },
					},
				},
				initializationOptions: spawned.initialization,
			});

			// Check if server uses pull-based diagnostics (tsgo) vs push-based (tsserver)
			const caps = (initResult as Record<string, unknown>)?.capabilities as Record<string, unknown> | undefined;
			// tsgo puts diagnosticProvider at top-level, some servers nest under textDocument
			if (caps?.diagnosticProvider || (caps?.textDocument as Record<string, unknown>)?.diagnosticProvider) {
				client.hasDiagnosticProvider = true;
			}

			try {
				connection.sendNotification("initialized" as never);
			} catch {
				/* stream died after init response */
			}
		} catch (err) {
			client.alive = false;
			try {
				connection.dispose();
			} catch {
				/* ok */
			}
			try {
				spawned.process.process.kill();
			} catch {
				/* ok */
			}
			return undefined;
		}

		this.clients.set(key, client);
		this.notifyStatus(server.id, server.name, true);
		return client;
	}

	private async openOrUpdate(
		client: ClientEntry,
		filePath: string,
		content: string,
	): Promise<void> {
		if (!client.alive) return;
		const uri = pathToFileURL(filePath).href;
		const key = pathKey(filePath);
		const lang = getLangId(filePath);

		try {
			if (client.openDocs.has(key)) {
				const version = (client.versions.get(key) ?? 0) + 1;
				client.versions.set(key, version);
				client.connection.sendNotification("textDocument/didChange" as never, {
					textDocument: { uri, version },
					contentChanges: [{ text: content }],
				});
			} else {
				client.versions.set(key, 0);
				client.connection.sendNotification("textDocument/didOpen" as never, {
					textDocument: { uri, languageId: lang, version: 0, text: content },
				});
				client.openDocs.add(key);
			}
		} catch {
			client.alive = false;
		}
	}

	private waitForDiags(
		client: ClientEntry,
		filePath: string,
		timeoutMs: number,
	): Promise<void> {
		const key = pathKey(filePath);

		return new Promise((resolve) => {
			let debounceTimer: ReturnType<typeof setTimeout> | undefined;
			const DEBOUNCE_MS = 500;

			const cleanup = () => {
				client.diagEmitter.off("diag", onDiag);
				if (debounceTimer) clearTimeout(debounceTimer);
				clearTimeout(deadline);
			};

			const onDiag = (fp: string) => {
				if (fp !== key) return;
				// Got diagnostics — reset debounce to wait for settling
				if (debounceTimer) clearTimeout(debounceTimer);
				debounceTimer = setTimeout(() => {
					cleanup();
					resolve();
				}, DEBOUNCE_MS);
			};

			const deadline = setTimeout(() => {
				client.diagEmitter.off("diag", onDiag);
				if (debounceTimer) clearTimeout(debounceTimer);
				resolve();
			}, timeoutMs);

			// Already cached? Still listen for a fresh round
			client.diagEmitter.on("diag", onDiag);
		});
	}
}

// --- Helpers ---

function uriToPath(uri: string): string {
	try {
		return fileURLToPath(uri);
	} catch {
		return uri;
	}
}

class TimeoutError extends Error {
	constructor(ms: number) { super(`timed out after ${ms}ms`); }
}

async function safeRequest(
	conn: MessageConnection,
	method: string,
	params: unknown,
): Promise<unknown> {
	try {
		return await conn.sendRequest(method as never, params as never);
	} catch {
		return undefined;
	}
}

async function timedRequest(
	conn: MessageConnection,
	method: string,
	params: unknown,
	timeoutMs: number,
): Promise<unknown> {
	return await Promise.race([
		conn.sendRequest(method as never, params as never),
		new Promise((_, reject) => setTimeout(() => reject(new TimeoutError(timeoutMs)), timeoutMs)),
	]);
}
