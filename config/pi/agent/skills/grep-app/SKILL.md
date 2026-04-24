---
name: grep-app
description: Search open source code across a million+ GitHub repositories using grep.app (by Vercel). Use when the user wants to find real-world code examples, usage patterns, library implementations, or how other projects solve a specific problem.
---

# grep.app — Open Source Code Search

Search across 1M+ GitHub repos via [grep.app](https://grep.app) by Vercel. No API key required.

## API Endpoint

```
https://grep.app/api/search?q=<query>&<params>
```

## Parameters

| Param | Description | Example |
|-------|-------------|---------|
| `q` | Search query (URL-encoded, use `+` for spaces) | `q=useEffect+cleanup` |
| `regexp` | Enable regex mode | `regexp=true` |
| `case` | Case sensitive | `case=true` |
| `words` | Whole word match | `words=true` |
| `filter[lang][0]` | Filter by language | `filter[lang][0]=TypeScript` |
| `filter[repo][0]` | Filter by repo | `filter[repo][0]=facebook/react` |
| `filter[path][0]` | Filter by path | `filter[path][0]=src/` |
| `page` | Pagination (starts at 1) | `page=2` |

**Important:** Square brackets must be percent-encoded in the URL:
- `[` → `%5B`
- `]` → `%5D`

So `filter[lang][0]=TypeScript` becomes `filter%5Blang%5D%5B0%5D=TypeScript`

## ⚠️ Known Filter Limitations

These were verified by experiment — violating them causes silent failures:

1. **`filter[lang]` is unreliable for common terms.** For broad queries (e.g. `curry`, `async`,
   `retry`), the language filter is silently ignored — results and `.hits.total` are identical
   regardless of which language you pass. Do not run the same query multiple times with different
   `filter[lang]` values expecting different results. Use facets (see below) to see the language
   breakdown from a single request instead.

2. **`filter[repo]` + `filter[lang]` combined breaks repo filtering.** Combining both parameters
   causes the repo filter to stop working — `.hits.total` reverts to the global count and
   completely different repos appear. Use `filter[repo]` alone, never with `filter[lang]`.

3. **`filter[repo]` is not strict.** Results from other repos that vendor or reference the target
   (e.g. bundled copies, lockfiles) can still appear. Always add a `select(.repo == "owner/repo")`
   clause in `jq` to enforce strict filtering.

4. **`.hits.total` does not reflect filter application.** It always shows the global unfiltered
   count. A filter working correctly does not change `.hits.total` — only the actual `.hits.hits`
   results change.

## Snippet HTML

The `.content.snippet` field contains **raw HTML** with `<mark>` tags highlighting matches and
other markup. Always strip HTML before displaying. Use `sed` — not `jq gsub` — to avoid shell
quoting issues (jq gsub patterns with single quotes break inside single-quoted bash strings).

```bash
# Correct: strip HTML with sed AFTER jq extracts the field
curl -sS 'URL' \
  | jq -r '.hits.hits[:5][] | "\(.repo)  \(.path)\n\(.content.snippet)\n"' \
  | sed 's/<[^>]*>//g'
```

## Usage

All examples use double quotes for the URL and strip HTML with `sed`.

### Basic search

```bash
curl -sS "https://grep.app/api/search?q=useEffect+cleanup" \
  | jq -r '.hits.hits[:5][] | "\(.repo)  \(.path)\n\(.content.snippet)\n"' \
  | sed 's/<[^>]*>//g'
```

### Check total hits and top languages/repos before diving in

Use this on a broad query to find which repos and languages have the most signal — then
use those repo names in targeted follow-up searches.

```bash
curl -sS "https://grep.app/api/search?q=curry" \
  | jq '{total: .hits.total, langs: .facets.lang.buckets[:5], repos: .facets.repo.buckets[:5]}'
```

### Search with language filter

Works reliably only for specific/uncommon terms. For common terms, verify it's doing
something by checking if the returned repos actually match the language.

```bash
curl -sS "https://grep.app/api/search?q=dependency+injection&filter%5Blang%5D%5B0%5D=TypeScript" \
  | jq -r '.hits.hits[:5][] | "\(.repo)  \(.path)\n\(.content.snippet)\n"' \
  | sed 's/<[^>]*>//g'
```

### Search within a specific repo (reliable pattern)

Use `filter[repo]` alone (never combined with `filter[lang]`), then enforce strict
repo-filtering client-side with `select()`:

```bash
curl -sS "https://grep.app/api/search?q=_curry2&filter%5Brepo%5D%5B0%5D=ramda%2Framda" \
  | jq -r '.hits.hits[] | select(.repo == "ramda/ramda") | "\(.path)\n\(.content.snippet)\n"' \
  | sed 's/<[^>]*>//g'
```

### Regex search

```bash
curl -sS "https://grep.app/api/search?q=fn+curry%3C&regexp=true&filter%5Blang%5D%5B0%5D=Rust" \
  | jq -r '.hits.hits[:5][] | "\(.repo)  \(.path)\n\(.content.snippet)\n"' \
  | sed 's/<[^>]*>//g'
```

### Paginate

```bash
curl -sS "https://grep.app/api/search?q=useCallback&filter%5Blang%5D%5B0%5D=TypeScript&page=2" \
  | jq -r '.hits.hits[:5][] | "\(.repo)  \(.path)\n\(.content.snippet)\n"' \
  | sed 's/<[^>]*>//g'
```

## Response Structure

```json
{
  "time": 42,
  "facets": {
    "repo": { "buckets": [{ "val": "owner/repo", "count": 100 }] },
    "lang": { "buckets": [{ "val": "Python", "count": 500 }] },
    "path": { "buckets": [{ "val": "src/", "count": 200 }] }
  },
  "hits": {
    "total": 12345,
    "hits": [
      {
        "repo": "owner/repo",
        "branch": "main",
        "path": "src/file.ts",
        "content": { "snippet": "<raw HTML with <mark>matches</mark> highlighted>" },
        "total_matches": "5"
      }
    ]
  }
}
```

## Workflow

1. **Check facets first** — run one broad search and inspect `.facets.lang` and `.facets.repo`
   to find which languages and repos have the most results. This replaces running the same query
   multiple times with different `filter[lang]` values.

2. **Narrow with `filter[repo]`** — pick the most promising repos from the facets and do
   repo-specific searches. Use `filter[repo]` alone, never combined with `filter[lang]`.

3. **Enforce repo filter client-side** — add `select(.repo == "owner/repo")` in `jq` to
   exclude vendored/bundled copies from other repos that slip through.

4. **Always strip HTML** — pipe through `sed 's/<[^>]*>//g'` before reading snippets.

5. **Use repo_checkout to go deeper** — once you find a relevant repo, use `repo_checkout owner/repo`
   to clone it locally and read full files with the `read` tool.

## Common Languages

TypeScript, JavaScript, Python, Go, Rust, Java, C++, C, Ruby, PHP, Swift, Kotlin, Scala, Haskell, Elixir, Shell, Markdown, HTML, CSS, YAML, JSON, SQL, Dart, Lua, Zig, OCaml, Clojure
