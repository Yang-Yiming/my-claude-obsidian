---
description: Bootstrap or check the claude-obsidian wiki vault. Reads the wiki skill and runs setup workflow.
---

Read the `wiki` skill. Then run the setup workflow:

1. Check if this directory has `wiki/`. If yes, report current wiki state from `wiki/index.md`, `wiki/hot.md`, and `wiki/log.md` when present.
2. If `wiki/` is missing, ask ONE question: "What is this vault for?"

Then build the wiki structure based on the answer. Don't ask more questions. Scaffold `wiki/` only, show what was created, and ask: "Want to adjust anything before we start?"

Examples of what the user might say:
- "Map the architecture of github.com/org/repo"
- "Build a sitemap and content analysis for example.com"
- "Track my SaaS business — product, customers, metrics, roadmap"
- "Research project on [topic] — papers, concepts, open questions"
- "Personal second brain — health, goals, learning, projects"
- "Organize my YouTube channel — transcripts, topics, tools mentioned"
- "Executive assistant brain — meetings, tasks, business context"

If the vault is already set up, skip to checking what has been ingested recently and offering to continue where things left off.
