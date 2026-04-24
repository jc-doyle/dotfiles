/**
 * Spawn an LSP server process over stdio.
 * No auto-install. Server must be on PATH or in local node_modules.
 */

import { type ChildProcess, spawn } from "node:child_process";
import * as fs from "node:fs";
import * as path from "node:path";

export interface LSPProcess {
	process: ChildProcess;
	stdin: NodeJS.WritableStream;
	stdout: NodeJS.ReadableStream;
	stderr: NodeJS.ReadableStream;
	pid: number;
}

/**
 * Launch an LSP server. Tries local node_modules/.bin first, then PATH.
 */
export async function launchLSP(
	command: string,
	args: string[] = [],
	cwd: string = process.cwd(),
	extraEnv?: Record<string, string>,
): Promise<LSPProcess> {
	const env = { ...process.env, ...extraEnv };

	// Try local node_modules/.bin/<command> first
	const localBin = path.join(cwd, "node_modules", ".bin", command);
	const resolvedCmd = fs.existsSync(localBin) ? localBin : command;

	const needsShell =
		process.platform === "win32" && /\.(cmd|bat)$/i.test(resolvedCmd);

	const proc = spawn(resolvedCmd, args, {
		cwd,
		env,
		stdio: ["pipe", "pipe", "pipe"],
		windowsHide: true,
		...(needsShell ? { shell: true } : {}),
	});

	if (!proc.stdin || !proc.stdout || !proc.stderr) {
		proc.kill();
		throw new Error(`Failed to spawn LSP: ${command}`);
	}

	// Detect immediate crash
	await new Promise<void>((resolve, reject) => {
		let settled = false;
		const fail = (msg: string) => {
			if (!settled) {
				settled = true;
				reject(new Error(msg));
			}
		};
		const ok = () => {
			if (!settled) {
				settled = true;
				resolve();
			}
		};

		proc.on("error", (err) => fail(`LSP spawn error: ${err.message}`));
		proc.on("exit", (code) => {
			if (code !== null) fail(`LSP exited immediately with code ${code}`);
		});
		setTimeout(ok, 50);
	});

	return {
		process: proc,
		stdin: proc.stdin,
		stdout: proc.stdout,
		stderr: proc.stderr,
		pid: proc.pid ?? 0,
	};
}
