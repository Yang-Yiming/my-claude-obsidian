# claude-obsidian Wiki Design

This fork keeps the LLM Wiki pattern but removes most upstream packaging.

## Current Model

- `wiki/` is the only agent-writable area.
- Everything outside `wiki/` is source material. Agents may read it but should not modify it.
- Generated knowledge lives in `wiki/`: sources, entities, concepts, questions, comparisons, logs, indexes, dashboards, and hot cache.
- Operational metadata that agents maintain should also live under `wiki/`, usually `wiki/meta/`.
- Skills in `skills/<name>/SKILL.md` are the main operating instructions.

## Core Files

- `wiki/hot.md`: short recent-context cache.
- `wiki/index.md`: catalog of wiki pages.
- `wiki/log.md`: append-only operation log, newest entries at the top.
- `wiki/overview.md`: high-level summary.
- `wiki/meta/manifest.json`: optional ingest manifest for source hashes and generated page mappings.

## Ingest Rule

When ingesting a source, read the source from wherever the user points, as long as it is outside `wiki/`. Do not copy source documents into a special raw folder by default. Summaries and extracted knowledge are written into `wiki/`.

## DragonScale

DragonScale files are currently preserved as-is for later review. Do not treat DragonScale as required for normal wiki operation.
