/**
 * Safety Gate Extension — Sandbox mode
 *
 * Designed for use inside a bubblewrap sandbox where filesystem and process
 * isolation is already enforced. Prompts only for genuinely dangerous
 * operations — not every command or file read.
 *
 * Bash:
 *   - Hard-block writes to sensitive paths via redirection/pipe/tee/cp/mv
 *   - Prompt for dangerous command patterns (rm -rf, sudo, eval, etc.)
 *   - Everything else runs silently
 *
 * Write / Edit:
 *   - Hard-block writes to sensitive paths (.env, keys, .ssh, git internals, etc.)
 *   - Soft-prompt for lockfiles (package-lock, yarn.lock, pnpm-lock)
 *   - Everything else writes silently
 *
 * Read:
 *   - Prompt when reading sensitive files (.env, keys, credentials, etc.)
 *   - Everything else reads silently
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { normalize } from "node:path";

export default function (pi: ExtensionAPI) {

	// ────────────────────────────────────────────────────────────────
	// Comment stripping
	// ────────────────────────────────────────────────────────────────

	/**
	 * Strip shell comments from a command before pattern matching so that:
	 *   # rm -rf /          → removed (full-line comment)
	 *   ls -al # list files → ls -al  (inline comment)
	 *   echo "a # b"        → unchanged (# inside double quotes)
	 *   echo 'a # b'        → unchanged (# inside single quotes)
	 *   echo ${#arr}        → unchanged (# not preceded by whitespace)
	 */
	function stripShellComments(command: string): string {
		return command
			.split("\n")
			.map(line => {
				const trimmed = line.trim();
				if (trimmed.startsWith("#")) return "";
				let inSingle = false;
				let inDouble = false;
				for (let i = 0; i < line.length; i++) {
					const ch = line[i];
					const prev = i > 0 ? line[i - 1] : "";
					if (ch === "'" && !inDouble && prev !== "\\") {
						inSingle = !inSingle;
					} else if (ch === '"' && !inSingle && prev !== "\\") {
						inDouble = !inDouble;
					} else if (ch === "#" && !inSingle && !inDouble) {
						if (i === 0 || /\s/.test(line[i - 1])) {
							return line.slice(0, i).trimEnd();
						}
					}
				}
				return line;
			})
			.filter(line => line.trim().length > 0)
			.join("\n");
	}

	// ────────────────────────────────────────────────────────────────
	// Dangerous bash patterns
	// ────────────────────────────────────────────────────────────────

	const dangerousPatterns = [
		{ pattern: /\brm\s+(-\S*[rf]\S*|--recursive|--force)/, desc: "delete with -r/-f flag" },
		{ pattern: /\bsudo\b/, desc: "elevated privileges" },
		{ pattern: /\b(chmod|chown)\b.*777/, desc: "world-writable permissions" },
		{ pattern: /\bcurl\b.*\|\s*(ba?sh|zsh|sh)\b/, desc: "pipe URL to shell" },
		{ pattern: /\bwget\b.*\|\s*(ba?sh|zsh|sh)\b/, desc: "pipe URL to shell" },
		{ pattern: /(^|[|;&\s])\s*eval\s/, desc: "eval execution" },
		{ pattern: /:\(\)\s*\{.*:\s*\|.*:.*&.*\}.*:/, desc: "fork bomb" },
		{ pattern: /\bdd\b.*\bof=\/dev\//, desc: "raw device write" },
		{ pattern: />\s*\/dev\/sd[a-z]/, desc: "write to block device" },
		{ pattern: /\bmkfs\b/, desc: "format filesystem" },
		{ pattern: /\breboot\b/, desc: "system reboot" },
		{ pattern: /\bshutdown\b/, desc: "system shutdown" },
		{ pattern: /\bkill\s+-9\s+-1\b/, desc: "kill all processes" },
		{ pattern: /\bgit\s+push\b.*--force(-with-lease)?/, desc: "force push" },
		{ pattern: /\bgit\s+reset\s+--hard/, desc: "hard reset" },
		{ pattern: /\bgit\s+clean\s+-\S*f/, desc: "force clean untracked files" },
		{ pattern: /\bnpm\s+publish\b/, desc: "publish package" },
		{ pattern: /\bdocker\s+system\s+prune/, desc: "docker prune all" },
		{ pattern: /\bsystemctl\s+(stop|disable|mask)\b/, desc: "stop/disable service" },
	];

	// Hard-blocked bash writes to sensitive paths — always rejected, no prompt
	const dangerousBashWrites = [
		{ pattern: />\s*\S*\.env(?!\.example)(\b|$)/, desc: "redirect into .env file" },
		{ pattern: /\btee\s+\S*\.env(?!\.example)(\b|$)/, desc: "tee into .env file" },
		{ pattern: /\b(cp|mv)\s+\S+\s+\S*\.env(?!\.example)(\b|$)/, desc: "copy/move to .env file" },
		{ pattern: />\s*\S*\.(pem|key)(\s|$)/, desc: "redirect into key file" },
		{ pattern: /\btee\s+\S*\.(pem|key)(\s|$)/, desc: "tee into key file" },
	];

	// ────────────────────────────────────────────────────────────────
	// Protected file paths
	// ────────────────────────────────────────────────────────────────

	// Write: hard-blocked — always rejected, no prompt
	const hardBlockedWritePaths = [
		{ pattern: /\.env($|\.(?!example|sample))/, desc: ".env file" },
		{ pattern: /\.dev\.vars($|\.)/, desc: ".dev.vars file" },
		{ pattern: /(^|\/)\.git\//, desc: "git internals" },
		{ pattern: /(^|\/)\.ssh\//, desc: ".ssh directory" },
		{ pattern: /(^|\/)\.gnupg\//, desc: "GPG directory" },
		{ pattern: /(^|\/)\.aws\//, desc: "AWS config directory" },
		{ pattern: /(^|\/)\.kube\//, desc: "Kubernetes config directory" },
		{ pattern: /(^|\/)node_modules\//, desc: "node_modules directory" },
		{ pattern: /\.(pem|key|p12|pfx)$/, desc: "private key file" },
		{ pattern: /\bid_(rsa|ed25519|ecdsa|dsa)\b/, desc: "SSH private key" },
		{ pattern: /secrets?\.(json|ya?ml|toml|env)$/i, desc: "secrets file" },
		{ pattern: /credentials$/i, desc: "credentials file" },
	];

	// Write: soft-blocked — confirm before allowing
	const softBlockedWritePaths = [
		{ pattern: /package-lock\.json$/, desc: "package-lock.json" },
		{ pattern: /yarn\.lock$/, desc: "yarn.lock" },
		{ pattern: /pnpm-lock\.yaml$/, desc: "pnpm-lock.yaml" },
		{ pattern: /bun\.lock(b)?$/, desc: "bun.lockb" },
	];

	// Read: prompt before allowing — same sensitive categories as write hard-blocks
	const sensitiveReadPaths = [
		{ pattern: /\.env($|\.(?!example|sample))/, desc: ".env file" },
		{ pattern: /\.dev\.vars($|\.)/, desc: ".dev.vars file" },
		{ pattern: /(^|\/)\.ssh\//, desc: ".ssh directory" },
		{ pattern: /(^|\/)\.gnupg\//, desc: "GPG directory" },
		{ pattern: /(^|\/)\.aws\//, desc: "AWS config directory" },
		{ pattern: /(^|\/)\.kube\//, desc: "Kubernetes config directory" },
		{ pattern: /\.(pem|key|p12|pfx)$/, desc: "private key file" },
		{ pattern: /\bid_(rsa|ed25519|ecdsa|dsa)\b/, desc: "SSH private key" },
		{ pattern: /secrets?\.(json|ya?ml|toml|env)$/i, desc: "secrets file" },
		{ pattern: /credentials$/i, desc: "credentials file" },
	];

	// ────────────────────────────────────────────────────────────────
	// BASH — only gate dangerous commands
	// ────────────────────────────────────────────────────────────────

	pi.on("tool_call", async (event, ctx) => {
		if (event.toolName !== "bash") return undefined;
		if (!ctx.hasUI) return { block: true, reason: "Bash blocked in non-interactive mode" };

		const raw = (event.input.command as string) || "";
		const stripped = stripShellComments(raw);
		if (!stripped.trim()) return undefined;

		// Hard-block bash writes to sensitive paths — no prompt
		for (const { pattern, desc } of dangerousBashWrites) {
			if (pattern.test(stripped)) {
				ctx.ui.notify(`🚫 Blocked bash write to protected path: ${desc}`, "warning");
				return { block: true, reason: `Bash writes to protected path: ${desc}` };
			}
		}

		// Dangerous patterns — prompt, but no "allow all" escape hatch
		const dangers = dangerousPatterns.filter(d => d.pattern.test(stripped));
		if (dangers.length === 0) return undefined; // safe — run silently

		const dangerLabel = dangers.map(d => d.desc).join(", ");
		const display = raw.length > 300 ? raw.slice(0, 300) + "\n  ..." : raw;

		const choice = await ctx.ui.select(
			`⚠️  DANGEROUS command (${dangerLabel}):\n\n  ${display}\n`,
			["Allow this once", "Block"],
		);

		return choice === "Allow this once"
			? undefined
			: { block: true, reason: "Blocked by user" };
	});

	// ────────────────────────────────────────────────────────────────
	// WRITE & EDIT — only gate sensitive / locked paths
	// ────────────────────────────────────────────────────────────────

	pi.on("tool_call", async (event, ctx) => {
		if (event.toolName !== "write" && event.toolName !== "edit") return undefined;
		if (!ctx.hasUI) return { block: true, reason: "File write blocked in non-interactive mode" };

		const filePath = (event.input.path as string) || "";
		const normalised = normalize(filePath).replace(/\\/g, "/");
		const action = event.toolName === "write" ? "Write" : "Edit";

		// Hard-block — no prompt
		const hardMatch = hardBlockedWritePaths.find(({ pattern }) => pattern.test(normalised));
		if (hardMatch) {
			ctx.ui.notify(`🚫 Blocked ${action.toLowerCase()} to ${hardMatch.desc}: ${filePath}`, "warning");
			return { block: true, reason: `Protected path: ${hardMatch.desc}` };
		}

		// Soft-block lockfiles — confirm once
		const softMatch = softBlockedWritePaths.find(({ pattern }) => pattern.test(normalised));
		if (softMatch) {
			const ok = await ctx.ui.confirm(
				`⚠️ Modifying ${softMatch.desc}`,
				`Allow ${action.toLowerCase()} to ${filePath}?`,
			);
			return ok ? undefined : { block: true, reason: `User blocked write to ${softMatch.desc}` };
		}

		// Everything else — allow silently
		return undefined;
	});

	// ────────────────────────────────────────────────────────────────
	// READ — only gate sensitive files
	// ────────────────────────────────────────────────────────────────

	pi.on("tool_call", async (event, ctx) => {
		if (event.toolName !== "read") return undefined;
		if (!ctx.hasUI) return undefined;

		const filePath = (event.input.path as string) || "";
		const normalised = normalize(filePath).replace(/\\/g, "/");

		// Only prompt if the file matches a sensitive pattern
		const sensitiveMatch = sensitiveReadPaths.find(({ pattern }) => pattern.test(normalised));
		if (!sensitiveMatch) return undefined; // non-sensitive — read silently

		const choice = await ctx.ui.select(
			`🔑 Reading sensitive file (${sensitiveMatch.desc}):\n\n  ${filePath}\n`,
			["Allow this once", "Block"],
		);

		return choice === "Allow this once"
			? undefined
			: { block: true, reason: "Blocked by user" };
	});
}
