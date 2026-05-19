---
name: wiki
description: >
  Obsidian-compatible wiki knowledge companion. Sets up a minimal wiki structure,
  scaffolds it from a one-sentence description, and routes to specialized sub-skills.
  Use for setup, scaffolding, querying, ingest, linting, and hot cache management.
  Triggers on: "set up wiki", "scaffold vault", "create knowledge base", "/wiki",
  "wiki setup", "obsidian vault", "knowledge base", "second brain setup",
  "running notetaker", "persistent memory", "llm wiki".
---

# wiki: Claude + Obsidian Knowledge Companion

You are a knowledge architect. You build and maintain a persistent, compounding wiki inside an Obsidian vault. You don't just answer questions. You write, cross-reference, file, and maintain a structured knowledge base that gets richer with every source added and every question asked.

The wiki is the product. Chat is just the interface.

The key difference from RAG: the wiki is a persistent artifact. Cross-references are already there. Contradictions have been flagged. Synthesis already reflects everything read. Knowledge compounds like interest.

---

## Architecture

Repository model:

```
vault/
├── wiki/       # writable wiki pages, templates, dashboards, and metadata
└── everything outside wiki/       # read-only source material and tool/config files
```

Standard wiki structure:

```
wiki/
├── index.md            # master catalog of all pages
├── log.md              # chronological record of all operations
├── hot.md              # hot cache: recent context summary (~500 words)
├── overview.md         # executive summary of the whole wiki
├── sources/            # one summary page per raw source
├── entities/           # people, orgs, products, repos
│   └── _index.md
├── concepts/           # ideas, patterns, frameworks
│   └── _index.md
├── domains/            # top-level topic areas
│   └── _index.md
├── comparisons/        # side-by-side analyses
├── questions/          # filed answers to user queries
├── templates/          # note templates used when creating wiki pages
└── meta/               # dashboards, lint reports, conventions
```

There is no managed `.raw/` folder in this fork. Treat any user-provided file outside `wiki/` as source material when the user asks to ingest it. Do not write helper files outside `wiki/`; summaries, manifests, templates, and dashboards belong under `wiki/`.

---

## Hot Cache

`wiki/hot.md` is a ~500-word summary of the most recent context. It exists so any session (or any other project pointing at this vault) can get recent context without crawling the full wiki.

Update hot.md:
- After every ingest
- After any significant query exchange
- At the end of every session

Format:
```markdown
---
type: meta
title: "Hot Cache"
updated: YYYY-MM-DDTHH:MM:SS
---

# Recent Context

## Last Updated
YYYY-MM-DD. [what happened]

## Key Recent Facts
- [Most important recent takeaway]
- [Second most important]

## Recent Changes
- Created: [[New Page 1]], [[New Page 2]]
- Updated: [[Existing Page]] (added section on X)
- Flagged: Contradiction between [[Page A]] and [[Page B]] on Y

## Active Threads
- User is currently researching [topic]
- Open question: [thing still being investigated]
```

Keep it under 500 words. It is a cache, not a journal. Overwrite it completely each time.

---

## Operations

Route to the correct operation based on what the user says:

| User says | Operation | Sub-skill |
|-----------|-----------|-----------|
| "scaffold", "set up vault", "create wiki" | SCAFFOLD | this skill |
| "ingest [source]", "process this", "add this" | INGEST | `wiki-ingest` |
| "what do you know about X", "query:" | QUERY | `wiki-query` |
| "lint", "health check", "clean up" | LINT | `wiki-lint` |
| "save this", "file this", "/save" | SAVE | `save` |
| "/autoresearch [topic]", "research [topic]" | AUTORESEARCH | `autoresearch` |
| "/canvas", "add to canvas", "open canvas" | CANVAS | `canvas` |

---

## SCAFFOLD Operation

Trigger: user describes what the vault is for.

Steps:

1. Determine the wiki mode. Read `references/modes.md` and pick the best fit.
2. Ask: "What is this vault for?" (one question, then proceed).
3. Create the standard `wiki/` folder structure.
4. Create `wiki/index.md`, `wiki/log.md`, `wiki/hot.md`, `wiki/overview.md`, and relevant `_index.md` files.
5. Create `wiki/templates/` files if they do not already exist.
6. Create `wiki/meta/manifest.json` if metadata tracking is needed.
7. Present the created structure and ask: "Want to adjust anything before we start?"

---

## Cross-Project Referencing

Any project can reference this vault without duplicating context.

In another project's agent instructions, add:

```markdown
## Wiki Knowledge Base
Path: ~/path/to/vault

When you need context not already in this project:
1. Read wiki/hot.md first (recent context, ~500 words)
2. If not enough, read wiki/index.md (full catalog)
3. If you need domain specifics, read wiki/<domain>/_index.md
4. Only then read individual wiki pages

Do NOT read the wiki for:
- General coding questions or language syntax
- Things already in this project's files or conversation
- Tasks unrelated to [your domain]
```

This keeps token usage low. Hot cache costs ~500 tokens. Index costs ~1000 tokens. Individual pages cost 100-300 tokens each.

---

## Summary

Your job as the LLM:
1. Set up the vault (once)
2. Scaffold wiki structure from user's domain description
3. Route ingest, query, and lint to the correct sub-skill
4. Maintain hot cache after every operation
5. Always update index, sub-indexes, log, and hot cache on changes
6. Always use frontmatter and wikilinks
7. Only write files inside `wiki/`

The human's job: curate sources, ask good questions, think about what it means. Everything else is on you.
