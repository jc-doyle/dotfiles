---
name: librarian
description: Research a remote git repository by cloning it into a persistent local cache (~/.cache/librarian) and reading or searching its source. Use when the user references a GitHub/GitLab/Bitbucket repo, or when you need to understand how an open-source library is implemented.
---

# Librarian

Provides a persistent local cache of git repositories for reading and analysis.
Cache location: `~/.cache/librarian/<host>/<org>/<repo>`

## Tools

| Tool | Purpose |
|------|---------|
| `repo_list` | Show everything already in cache — always call this first |
| `repo_checkout` | Clone or update a repo, returns its local path + file tree |
| `repo_search` | Ripgrep across one or all cached repos |

## Standard workflow

### 1. Check the cache first

```
repo_list()
```

If the repo is already there and not stale, skip straight to step 3.

### 2. Clone or update

```
repo_checkout("owner/repo")
# or full URL:
repo_checkout("https://github.com/owner/repo")
repo_checkout("git@github.com:owner/repo.git")
```

`repo_checkout` returns the local path and a two-level file tree so you immediately
understand the project layout.

Force a refresh even if not stale:
```
repo_checkout("owner/repo", forceUpdate: true)
```

### 3. Read and explore

Use the path from `repo_checkout` with `read` and `bash`:

```bash
# Read a specific file
read("<path>/src/index.ts")

# Browse directory
bash("ls -la <path>/src")

# Read README
read("<path>/README.md")

# Check git log
bash("git -C <path> log --oneline -20")

# Show a specific commit
bash("git -C <path> show <sha>")

# Blame a file
bash("git -C <path> blame src/core.ts")
```

### 4. Search across the repo

```
repo_search("createContext", repos: ["facebook/react"], fileType: "ts")
repo_search("fn handle_", fileType: "rs")
repo_search("useEffect.*cleanup", context: 5)
```

Search across ALL cached repos (useful for cross-repo comparison):
```
repo_search("dependency injection")
```

## URL formats accepted by repo_checkout

All of the following resolve to the same cached path:

```
owner/repo                              # GitHub shorthand
github.com/owner/repo                  # host/org/repo
https://github.com/owner/repo          # full HTTPS URL
https://github.com/owner/repo/tree/main/src  # deep link (stripped to owner/repo)
git@github.com:owner/repo.git          # SSH
ssh://git@github.com/owner/repo        # SSH URL
```

## Rules

- **Never modify files in the cache** — it is shared across sessions. Create a worktree or copy files if edits are needed.
- **Prefer `repo_search` over bash+grep** — it handles the cache root and excludes `.git/` automatically.
- **Partial clone** — only blobs touched by `read` or `bash` are downloaded. Large repos are fast to clone.
- **Stale threshold** — 5 minutes by default. Override per-call with `updateIntervalSeconds`.
