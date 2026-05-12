# claude-obsidian: GitHub Copilot Instructions

This repository is a customized Agent Skills package and Obsidian-compatible wiki vault based on Andrej Karpathy's LLM Wiki pattern. It is markdown-first. No build step is required for normal use.

## Project Type

- Agent Skills package
- Obsidian-compatible wiki vault
- Local fork of `claude-obsidian`, with upstream distribution packaging removed

## Repository Layout

- `skills/`: skills, each with a `SKILL.md` defining trigger phrases and instructions
- `hooks/hooks.json`: optional Claude Code lifecycle hooks
- `wiki/`: generated knowledge base (Markdown files with YAML frontmatter)
- Everything outside `wiki/`: source material; agents may read it but should not modify it
- `_templates/`: Obsidian Templater templates

## Conventions Copilot Should Follow

When suggesting edits:

1. **Frontmatter is flat YAML** with plural keys: `tags`, `aliases`, `cssclasses`
2. **Internal links are wikilinks**: `[[Note Name]]`, not Markdown links to `.md` paths
3. **Dates are `YYYY-MM-DD`**, not ISO datetimes
4. **Only `wiki/` is writable for agent-generated knowledge**. Treat everything outside `wiki/` as read-only source material unless the user explicitly asks otherwise.
5. **`wiki/log.md` is append-only**, with new entries at the top
6. **`wiki/hot.md` is overwritten** at session end, not appended to
7. **Skills use only `name` and `description` in frontmatter**. No `allowed-tools`, no `triggers`, no `globs` (these are not part of the Agent Skills spec)
8. **Custom callouts**: pages may use `[!contradiction]`, `[!gap]`, `[!key-insight]`, and `[!stale]`. They remain readable even without custom CSS.

## When Editing Skills (`skills/<name>/SKILL.md`)

- Frontmatter: `name` (matches directory name) and `description` (single quoted line, max ~250 useful chars)
- Body: short, imperative instructions. Reference files with backticks. Do not paste large code blocks unless they're essential.
- Trigger phrases go in the `description` field, not in body or non-standard fields

## When Editing Hooks (`hooks/hooks.json`)

- Valid event names only: `SessionStart`, `Stop`, `PreToolUse`, `PostToolUse`, `PreCompact`, `PostCompact`, `UserPromptSubmit`
- Hook types: `command` (shell), `prompt` (LLM), `http` (POST), `agent` (subagent)
- `matcher` field uses regex against tool names for `PreToolUse`/`PostToolUse`
- For `SessionStart`: matcher uses `startup`, `resume`, `clear`, or `compact`

## Cross-Reference

- Upstream: https://github.com/AgriciDaniel/claude-obsidian
- Pattern source: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
- Authoritative Obsidian-specific skills: https://github.com/kepano/obsidian-skills
