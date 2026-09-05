---
name: mermaid
description: Use a Mermaid diagram to explain structure, flow, or relationships when prose would be long or ambiguous. Emit a fenced ```mermaid block and pi's built-in renderer draws it inline in the TUI (setting `markdown.mermaid`, default `streaming`). Parse failures are never reported back to you — validate syntax before emitting.
---

# Diagrams as thought

A well-placed diagram is a force multiplier. It compresses spatial relationships a paragraph has to spell out linearly, makes branch/merge points visible at a glance, and gives both of us a shared artifact to point at. You have a Mermaid renderer — use it when prose would fight the structure of what you're explaining.

## When a diagram pays for itself

Reach for one when the thing you're describing is:

- **A state machine or lifecycle** — auth flows, request states, build phases, session stages.
- **Control flow with branches** — decision trees, guard-clause ladders, error-handling paths.
- **A sequence of interactions across actors** — client/server, service-to-service calls, message passing, distributed transactions.
- **A pipeline or data flow** — ETL stages, build graphs, stream topology, compiler passes.
- **A dependency / module graph** — package relationships, call graphs, architectural layers.
- **A schema or ER relationship** — tables and their joins, entity cardinality, nested config shape.
- **Concurrency/ordering** — happens-before edges, lock acquisition order, task DAG.
- **A refactor plan** — before/after structure, migration path, cut lines.

If you catch yourself writing "A calls B, which then calls C and D in parallel, and D only proceeds if…" — stop. Draw it.

## When prose is better

Don't diagram for the sake of diagramming. Skip it when:

- There are only two or three nodes. "A → B → C" is faster as a sentence.
- The relationship is a **list**, not a graph. Use a bulleted list.
- The thing is **textual / sequential** with no branching. Use numbered steps.
- A code snippet would say the same thing more precisely. Code is also a diagram.
- You'd need more than ~40 nodes to be honest about it — the ASCII won't fit and truth suffers. Split into focused sub-diagrams instead.

## Choosing a type

The terminal renderer supports **exactly these five types** — `journey`, `gantt`, `pie`, etc. render as raw code:

| Thing you're showing                     | Mermaid type           |
| ---------------------------------------- | ---------------------- |
| Decisions, branches, generic flow        | `flowchart` / `graph`  |
| Actors exchanging messages over time     | `sequenceDiagram`      |
| Types and their relationships            | `classDiagram`         |
| Tables and joins                         | `erDiagram`            |
| States and transitions                   | `stateDiagram-v2`      |

Prefer `flowchart TD` (top-down) for pipelines and lifecycles, `flowchart LR` (left-right) for request/response and ETL. `sequenceDiagram` is almost always the right call for "A then B then C across services."

## Emitting diagrams

Put the diagram in a fenced `mermaid` block **inside** your normal response — don't preface it with "here's a diagram:"; just talk around it like you would a code snippet. The TUI catches the fence and renders it below the prose.

````md
The auth flow has three redirects before we get a session:

```mermaid
sequenceDiagram
  participant U as User
  participant App
  participant IdP
  U->>App: GET /login
  App-->>U: 302 → IdP
  U->>IdP: credentials
  IdP-->>U: 302 → App (code)
  U->>App: GET /cb?code=...
  App->>IdP: POST /token
  IdP-->>App: access_token
  App-->>U: Set-Cookie; 302 → /
```

The cookie is HttpOnly, so the SPA can't see it — that's why step 6 is server-to-server.
````

## Keeping diagrams valid

The renderer does **not** report parse failures back into your context. If a diagram fails, the user sees a "Mermaid diagram not rendered: …" warning, but you never learn about it and get no retry — so get it right the first time. Common gotchas:

- Label text with `(`, `)`, `:`, `{`, `}` — wrap it in quotes: `A["label (v2)"]`.
- `end` is a reserved keyword — don't use it as a node id.
- `sequenceDiagram` participants can't contain spaces unless aliased: `participant U as User`.
- Edge labels use `-->|label|` in flowcharts, not `-->label-->`.
- `stateDiagram-v2` needs the `-v2` suffix for composite states.

## Style

- **Node labels short and nouny.** "Cache miss", not "The request did not find a cached entry".
- **The diagram must fit the terminal width (~100 columns).** Anything wider silently renders as raw code with no feedback to anyone. Prefer `TD` (vertical) over `LR`, keep labels under ~15 chars, and if the layout still runs wide, split into two focused diagrams.
- **Use subgraphs sparingly** — they help group but quickly clutter ASCII output. Two focused diagrams beat one cluttered one.
- **Pick a direction and commit** — don't mix `TD` and `LR` across related diagrams in the same response.
- **Edge labels are real estate** — use them for the decision ("yes", "error") not the mechanism ("http call").
- **Don't redraw code.** A function's line-by-line logic belongs in code, not a flowchart. A system of functions calling each other is diagram territory.

## Where a diagram in your own thinking helps

Even when the user hasn't asked for one, drop a small diagram *for yourself* when:

- You're about to describe an architecture you haven't drawn yet — the diagram forces you to make implicit edges explicit, and you'll often catch a gap while drawing it.
- You're planning a multi-file refactor — render the before/after dependency graph and it's obvious which edges change.
- You're debugging an async bug — a `sequenceDiagram` of the race is usually the fastest way to locate it.

Treat Mermaid like a whiteboard you can reach for mid-sentence. That's the whole point of having it.
