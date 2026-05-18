---
type: meta
title: "Hot Cache"
updated: 2026-05-18
tags:
  - meta
  - hot-cache
status: evergreen
related:
  - "[[index]]"
  - "[[log]]"
  - "[[Wiki Map]]"
  - "[[getting-started]]"
---

# Recent Context

Navigation: [[index]] | [[log]] | [[overview]]

## Last Updated

2026-05-18: DragonScale-related files, docs, scripts, tests, and wiki artifacts were removed from this vault to keep the repo focused on the core wiki workflow and the skills/commands that directly support it.

## Plugin State

- **Core skills**: wiki, wiki-ingest, wiki-query, wiki-lint, save, autoresearch, canvas, defuddle, obsidian-bases, obsidian-markdown
- **Scripts**: none required for the base wiki flow
- **Setup**: `bin/setup-multi-agent.sh` remains for skill bootstrap; base vault setup is otherwise documented through the wiki flow itself
- **Hooks**: session-start and compaction hooks reload `wiki/hot.md`; stop hook reminds the agent to refresh this file after wiki edits

## Active Threads

- Continue simplifying the repo around direct skill usage, with less scaffolding and less repo-specific automation.
- Keep `wiki/` as the main durable knowledge layer and treat source material in `.raw/` as read-only input.

## Style Preferences

- Short and direct responses.
- Parallel tool calls when independent.
- Prefer practical repo cleanup over preserving optional machinery.
