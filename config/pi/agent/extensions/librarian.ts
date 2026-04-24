/**
 * Librarian Extension
 *
 * Manages a persistent local cache of git repositories for reading and analysis.
 * Repos are stored at ~/.cache/librarian/<host>/<org>/<repo>.
 *
 * Three tools:
 *   repo_checkout  — clone or update a repo, returns its local path
 *   repo_list      — list everything already in the cache with staleness info
 *   repo_search    — ripgrep across one or all cached repos
 *
 * Git operations run via pi.exec (not the bash tool) so they don't trip the
 * safety gate on every fetch.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Type } from "@sinclair/typebox";
import { existsSync, mkdirSync, readdirSync, readFileSync, statSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { dirname, join } from "node:path";

// ─────────────────────────────────────────────────────────────────────────────
// Constants
// ─────────────────────────────────────────────────────────────────────────────

const CACHE_ROOT = join(homedir(), ".cache", "librarian");
const DEFAULT_HOST = "github.com";
const UPDATE_INTERVAL = 300; // seconds (5 min)
const LAST_FETCH_FILE = ".git/librarian-last-fetch";

// Deep-link path segments that indicate we should strip to owner/repo
const DEEP_LINK_SEGMENTS = new Set([
  "tree", "blob", "pull", "issues", "commit",
  "actions", "releases", "compare", "wiki", "discussions",
]);

// ─────────────────────────────────────────────────────────────────────────────
// Types
// ─────────────────────────────────────────────────────────────────────────────

interface ParsedRepo {
  host: string;
  org: string;
  repo: string;
}

// ─────────────────────────────────────────────────────────────────────────────
// URL parsing
// ─────────────────────────────────────────────────────────────────────────────

function parseRepoUrl(input: string): ParsedRepo {
  let s = input.trim();

  // Strip query string and fragment
  s = s.split("?")[0].split("#")[0].trim();

  let host: string;
  let path: string;

  if (s.startsWith("git@")) {
    // git@github.com:owner/repo.git
    host = s.slice(4, s.indexOf(":"));
    path = s.slice(s.indexOf(":") + 1);
  } else if (s.startsWith("ssh://")) {
    // ssh://git@github.com/owner/repo
    const rest = s.slice(6);
    const slashIdx = rest.indexOf("/");
    const hostPart = rest.slice(0, slashIdx);
    host = hostPart.includes("@") ? hostPart.slice(hostPart.indexOf("@") + 1) : hostPart;
    path = rest.slice(slashIdx + 1);
  } else if (s.startsWith("http://") || s.startsWith("https://")) {
    // https://github.com/owner/repo[/...]
    const rest = s.replace(/^https?:\/\//, "");
    const slashIdx = rest.indexOf("/");
    host = rest.slice(0, slashIdx < 0 ? undefined : slashIdx);
    path = slashIdx < 0 ? "" : rest.slice(slashIdx + 1);
  } else if (s.includes("/")) {
    const firstSegment = s.split("/")[0];
    if (firstSegment.includes(".") || firstSegment === "localhost") {
      // github.com/owner/repo
      host = firstSegment;
      path = s.slice(firstSegment.length + 1);
    } else {
      // owner/repo shorthand
      host = DEFAULT_HOST;
      path = s;
    }
  } else {
    throw new Error(`Unsupported repository format: "${input}". Use owner/repo, a full URL, or git@host:path.`);
  }

  // Strip .git suffix and trailing slashes
  path = path.replace(/\.git$/, "").replace(/\/+$/, "");

  // Strip deep-link suffixes: owner/repo/tree/main/... → owner/repo
  const parts = path.split("/");
  if (parts.length >= 3 && DEEP_LINK_SEGMENTS.has(parts[2])) {
    path = parts.slice(0, 2).join("/");
  }

  const finalParts = path.split("/").filter(Boolean);
  if (finalParts.length < 2) {
    throw new Error(`Could not extract org/repo from: "${input}"`);
  }

  return {
    host,
    org: finalParts.slice(0, -1).join("/"),
    repo: finalParts[finalParts.length - 1],
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// Cache helpers
// ─────────────────────────────────────────────────────────────────────────────

function checkoutPath(p: ParsedRepo): string {
  return join(CACHE_ROOT, p.host, p.org, p.repo);
}

function originUrl(p: ParsedRepo): string {
  return `https://${p.host}/${p.org}/${p.repo}.git`;
}

function isCloned(path: string): boolean {
  return existsSync(join(path, ".git"));
}

function lastFetchEpoch(path: string): number {
  try {
    return parseInt(readFileSync(join(path, LAST_FETCH_FILE), "utf-8").trim(), 10) || 0;
  } catch {
    return 0;
  }
}

function touchLastFetch(path: string): void {
  writeFileSync(join(path, LAST_FETCH_FILE), String(Math.floor(Date.now() / 1000)));
}

function isStale(path: string, intervalSeconds = UPDATE_INTERVAL): boolean {
  return Math.floor(Date.now() / 1000) - lastFetchEpoch(path) > intervalSeconds;
}

/** Walk the cache root and return every cloned repo */
function listCachedRepos(): Array<{ host: string; org: string; repo: string; path: string; lastFetch: number; stale: boolean }> {
  const results: ReturnType<typeof listCachedRepos> = [];
  if (!existsSync(CACHE_ROOT)) return results;

  // Walk: CACHE_ROOT/<host>/<org>/<repo>
  for (const host of readdirSync(CACHE_ROOT)) {
    const hostDir = join(CACHE_ROOT, host);
    if (!statSync(hostDir).isDirectory()) continue;
    for (const org of readdirSync(hostDir)) {
      const orgDir = join(hostDir, org);
      if (!statSync(orgDir).isDirectory()) continue;
      for (const repo of readdirSync(orgDir)) {
        const repoDir = join(orgDir, org, repo);
        // handle nested org (e.g. github.com/my-org/my-repo)
        // the actual path is CACHE_ROOT/host/org/repo
        const repoPath = join(orgDir, repo);
        if (!existsSync(join(repoPath, ".git"))) continue;
        const lf = lastFetchEpoch(repoPath);
        results.push({
          host, org, repo: repo,
          path: repoPath,
          lastFetch: lf,
          stale: isStale(repoPath),
        });
      }
    }
  }
  return results;
}

// ─────────────────────────────────────────────────────────────────────────────
// Extension
// ─────────────────────────────────────────────────────────────────────────────

export default function (pi: ExtensionAPI) {

  // ── repo_checkout ──────────────────────────────────────────────────────────

  pi.registerTool({
    name: "repo_checkout",
    label: "Repo Checkout",
    description:
      "Ensure a GitHub/GitLab/Bitbucket repository is cloned into the local cache " +
      "(~/.cache/librarian/<host>/<org>/<repo>) and return its path. " +
      "Accepts any URL format: owner/repo, https://github.com/owner/repo, git@host:org/repo.git, etc. " +
      "Uses a partial clone (--filter=blob:none) for speed. " +
      "Re-fetches if the cached copy is stale (default: 5 min). " +
      "Always check repo_list first to see if the repo is already cached.",
    promptSnippet: "Clone or update a remote repo into the local cache and return its path",
    promptGuidelines: [
      "Always call repo_list before repo_checkout to avoid redundant network calls.",
      "After checkout, use the returned path only when you need a specific file — do not read the repo speculatively.",
      "Do not modify files inside the cache — it is shared across sessions.",
    ],
    parameters: Type.Object({
      url: Type.String({ description: "Repository URL or owner/repo shorthand" }),
      forceUpdate: Type.Optional(Type.Boolean({ description: "Fetch even if not stale (default: false)" })),
      updateIntervalSeconds: Type.Optional(Type.Number({ description: "Seconds before a cached repo is considered stale (default: 300)" })),
    }),

    async execute(_id, params, signal) {
      let parsed: ParsedRepo;
      try {
        parsed = parseRepoUrl(params.url);
      } catch (err) {
        throw new Error(`Failed to parse repository URL: ${err instanceof Error ? err.message : String(err)}`);
      }

      const path = checkoutPath(parsed);
      const origin = originUrl(parsed);
      const interval = params.updateIntervalSeconds ?? UPDATE_INTERVAL;

      let cloneState: "cloned" | "existing" = "existing";
      let updateState: "fetched" | "skipped" | "forced" = "skipped";
      let ffState: "fast-forwarded" | "skipped" | "not-attempted" = "not-attempted";

      // ── Clone if missing ──
      if (!isCloned(path)) {
        mkdirSync(dirname(path), { recursive: true });
        const cloneResult = await pi.exec("git", [
          "clone", "--filter=blob:none", "--no-checkout", origin, path,
        ], { signal, timeout: 120_000 });
        if (cloneResult.code !== 0) {
          throw new Error(`git clone failed:\n${cloneResult.stderr}`);
        }
        // Default checkout so we have a working tree
        await pi.exec("git", ["-C", path, "checkout"], { signal, timeout: 30_000 });
        touchLastFetch(path);
        cloneState = "cloned";
        updateState = "fetched";
      }

      // ── Fetch if stale or forced ──
      const shouldFetch = params.forceUpdate || isStale(path, interval);
      if (cloneState === "existing" && shouldFetch) {
        const fetchResult = await pi.exec("git", [
          "-C", path, "fetch", "--prune", "--tags", "origin",
        ], { signal, timeout: 60_000 });
        if (fetchResult.code !== 0) {
          throw new Error(`git fetch failed:\n${fetchResult.stderr}`);
        }
        touchLastFetch(path);
        updateState = params.forceUpdate ? "forced" : "fetched";

        // Attempt fast-forward on a clean branch with a tracked upstream
        const branchResult = await pi.exec("git", ["-C", path, "symbolic-ref", "--short", "-q", "HEAD"], { signal });
        const upstreamResult = await pi.exec("git", ["-C", path, "rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{u}"], { signal });
        const dirtyResult = await pi.exec("git", ["-C", path, "status", "--porcelain", "--untracked-files=no"], { signal });

        const branch = branchResult.stdout.trim();
        const upstream = upstreamResult.stdout.trim();
        const dirty = dirtyResult.stdout.trim();

        if (branch && upstream && !dirty) {
          const ffResult = await pi.exec("git", ["-C", path, "merge", "--ff-only", upstream], { signal });
          ffState = ffResult.code === 0 ? "fast-forwarded" : "skipped";
        } else {
          ffState = "skipped";
        }
      }

      return {
        content: [{
          type: "text", text: [
            `repo:   ${parsed.host}/${parsed.org}/${parsed.repo}`,
            `path:   ${path}`,
            `origin: ${origin}`,
            `state:  ${cloneState} | update: ${updateState} | fast-forward: ${ffState}`,
          ].join("\n")
        }],
        details: { host: parsed.host, org: parsed.org, repo: parsed.repo, path, cloneState, updateState },
      };
    },
  });

  // ── repo_list ─────────────────────────────────────────────────────────────

  pi.registerTool({
    name: "repo_list",
    label: "Repo List",
    description:
      "List all repositories currently in the local cache (~/.cache/librarian). " +
      "Always call this before repo_checkout to check whether a repo is already available locally.",
    promptSnippet: "List all repos already in the local cache",
    parameters: Type.Object({}),

    async execute() {
      const cached = listCachedRepos();

      if (cached.length === 0) {
        return {
          content: [{ type: "text", text: "Cache is empty. No repositories have been checked out yet." }],
          details: { repos: [] },
        };
      }

      const lines = cached.map(r => {
        const age = Math.floor(Date.now() / 1000) - r.lastFetch;
        const ageStr = age < 60 ? `${age}s ago`
          : age < 3600 ? `${Math.floor(age / 60)}m ago`
            : `${Math.floor(age / 3600)}h ago`;
        const staleFlag = r.stale ? " [STALE]" : "";
        return `${r.host}/${r.org}/${r.repo}  →  ${r.path}  (fetched ${ageStr}${staleFlag})`;
      });

      return {
        content: [{ type: "text", text: `${cached.length} cached repo(s):\n\n${lines.join("\n")}` }],
        details: { repos: cached },
      };
    },
  });

  // ── repo_search ───────────────────────────────────────────────────────────

  pi.registerTool({
    name: "repo_search",
    label: "Repo Search",
    description:
      "Search code across one or more cached repositories using ripgrep. " +
      "Searches the entire cache if no repos are specified. " +
      "Use after repo_checkout to find patterns, implementations, or usages.",
    promptSnippet: "Ripgrep across cached repositories",
    parameters: Type.Object({
      pattern: Type.String({ description: "Search pattern (regex supported)" }),
      repos: Type.Optional(Type.Array(Type.String(), {
        description: "Limit search to these repos, e.g. ['owner/repo']. Searches all cached repos if omitted.",
      })),
      fileType: Type.Optional(Type.String({ description: "File type filter, e.g. 'ts', 'py', 'rs', 'go'" })),
      context: Type.Optional(Type.Number({ description: "Lines of context around matches (default: 3)" })),
      caseSensitive: Type.Optional(Type.Boolean({ description: "Case-sensitive search (default: false)" })),
      maxResults: Type.Optional(Type.Number({ description: "Max results to return (default: 30)" })),
    }),

    async execute(_id, params, signal) {
      if (!existsSync(CACHE_ROOT)) {
        return {
          content: [{ type: "text", text: "Cache is empty. Run repo_checkout first." }],
          details: {},
        };
      }

      // Resolve search roots
      let searchRoots: string[];
      if (params.repos && params.repos.length > 0) {
        searchRoots = params.repos.map(r => {
          try {
            const parsed = parseRepoUrl(r);
            return checkoutPath(parsed);
          } catch {
            return join(CACHE_ROOT, r); // allow bare path fragments
          }
        }).filter(p => existsSync(p));

        if (searchRoots.length === 0) {
          throw new Error(`None of the specified repos are in the cache: ${params.repos.join(", ")}`);
        }
      } else {
        searchRoots = [CACHE_ROOT];
      }

      const args = [
        "--line-number",
        "--heading",
        "--color", "never",
        "-C", String(params.context ?? 3),
        "--max-count", String(params.maxResults ?? 30),
        // Exclude git internals
        "--glob", "!.git/**",
      ];

      if (!params.caseSensitive) args.push("--ignore-case");
      if (params.fileType) args.push("--type", params.fileType);

      args.push("--", params.pattern, ...searchRoots);

      const result = await pi.exec("rg", args, { signal, timeout: 30_000 });
      const output = result.stdout.trim() || "(no matches found)";
      const matchCount = (output.match(/^\d+:/gm) ?? []).length;

      return {
        content: [{ type: "text", text: `Found ${matchCount} match(es) for "${params.pattern}":\n\n${output}` }],
        details: { matchCount, searchRoots },
      };
    },
  });
}
