---
description: Bootstrap or check the local wiki vault.
---

Read the `wiki` skill. Then run the setup workflow:

1. Check whether `wiki/` exists and contains `index.md`, `log.md`, `hot.md`, and `overview.md`.
2. Check whether `wiki/templates/` exists for note templates and whether `wiki/meta/` exists for wiki metadata.
3. If the wiki is missing or incomplete, ask ONE question: "What is this vault for?"
4. Scaffold the minimal wiki structure from the answer.

Then scaffold the wiki structure based on the answer. Don't ask more questions. Show what was created and ask: "Want to adjust anything before we start?"

Examples of what the user might say:
- "Map the architecture of github.com/org/repo"
- "Build a sitemap and content analysis for example.com"
- "Track my SaaS business — product, customers, metrics, roadmap"
- "Research project on [topic] — papers, concepts, open questions"
- "Personal second brain — health, goals, learning, projects"
- "Organize my YouTube channel — transcripts, topics, tools mentioned"
- "Executive assistant brain — meetings, tasks, business context"

If the vault is already set up, report current wiki state from `wiki/index.md`, `wiki/log.md`, and `wiki/meta/manifest.json` if it exists.
