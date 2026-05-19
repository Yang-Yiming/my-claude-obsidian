
# claude-obsidian

Totally customized / simplified version of [claude-obsidian](https://github.com/AgriciDaniel/claude-obsidian), which is an implementation of [Karpathy's workflow](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).

This fork uses a no-raw-folder model:

- `wiki/` is the only place agents should write wiki pages, templates, dashboards, manifests, and other wiki metadata.
- Anything outside `wiki/` is treated as raw source material unless it is an explicit tool/config file in this repo.
- Source files outside `wiki/` should be read during ingest, not copied into a managed `.raw/` directory.
