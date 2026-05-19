---
description: Open, create, or update a visual canvas — add images, text, PDFs, and wiki pages to Obsidian canvas files.
---

Read the `canvas` skill. Then run the operation matching the user's command.

| Command | What it does |
|---------|-------------|
| `/canvas` | Status check — report node counts, list zones, open instructions |
| `/canvas new [name]` | Create a new named canvas in wiki/canvases/ |
| `/canvas add image [path]` | Add image to canvas (download if URL, copy if outside vault) |
| `/canvas add text [content]` | Add a text card to the canvas |
| `/canvas add pdf [path]` | Add a PDF document node |
| `/canvas add note [page]` | Add a wiki page as a linked card |
| `/canvas zone [name] [color]` | Add a new labeled zone group |
| `/canvas list` | List all canvases with node counts |

Default canvas: `wiki/canvases/main.canvas`

If the canvas file does not exist, create it before adding anything.
