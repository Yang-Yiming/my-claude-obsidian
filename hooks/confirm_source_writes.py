#!/usr/bin/env python3
import json
import re
import shlex
import sys
from pathlib import Path


TOOLING_DIRS = {
    ".claude",
    ".github",
    ".opencode",
    "agents",
    "bin",
    "commands",
    "hooks",
    "scripts",
    "skills",
    "tests",
}

TOOLING_FILES = {
    ".gitignore",
    "README.md",
    "opencode.json",
}


def ask(reason):
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "ask",
            "permissionDecisionReason": reason,
        }
    }))
    sys.exit(0)


def repo_relative(value):
    if not value:
        return None

    path = Path(str(value)).expanduser()
    cwd = Path.cwd().resolve()

    try:
        resolved = path.resolve(strict=False) if path.is_absolute() else (cwd / path).resolve(strict=False)
        return resolved.relative_to(cwd)
    except ValueError:
        return path


def is_wiki_path(rel_path):
    return rel_path and rel_path.parts and rel_path.parts[0] == "wiki"


def is_tooling_path(rel_path):
    if not rel_path or not rel_path.parts:
        return False
    text = rel_path.as_posix()
    return text in TOOLING_FILES or rel_path.parts[0] in TOOLING_DIRS


def is_source_area_path(value):
    rel_path = repo_relative(value)
    if rel_path is None:
        return False
    return not is_wiki_path(rel_path) and not is_tooling_path(rel_path)


def shell_paths_that_may_be_written(command):
    paths = []

    for match in re.finditer(r"(?:^|[;&|]\s*)(mv|cp|rsync|rm|chmod|chown|mkdir|tee|touch)\b([^\n;&|]*)", command):
        program = match.group(1)
        try:
            tokens = [token for token in shlex.split(match.group(2)) if not token.startswith("-")]
        except ValueError:
            continue
        if program == "cp" and tokens:
            paths.append(tokens[-1])
        elif program in {"mv", "rsync"}:
            paths.extend(tokens)
        else:
            paths.extend(tokens)

    for match in re.finditer(r"(?:^|[;&|]\s*)(?:sed|perl)\b([^\n;&|]*\s-i[^\n;&|]*)", command):
        try:
            tokens = [token for token in shlex.split(match.group(1)) if not token.startswith("-")]
        except ValueError:
            continue
        paths.extend(token for token in tokens if looks_like_path(token))

    for match in re.finditer(r"(?:>|>>)\s*([^\s;&|]+)", command):
        paths.append(match.group(1).strip("'\""))

    return paths


def looks_like_path(token):
    if not token or token.startswith(("s/", "s#", "s|", "y/", "y#", "y|")):
        return False
    return (
        token.startswith(("/", "./", "../", "~"))
        or "/" in token
        or "." in Path(token).name
    )


payload = json.load(sys.stdin)
tool_name = payload.get("tool_name", "")
tool_input = payload.get("tool_input", {})

if tool_name in {"Write", "Edit", "MultiEdit"}:
    path = tool_input.get("file_path") or tool_input.get("path")
    if is_source_area_path(path):
        ask(f"This tool call modifies {path} outside wiki/. Confirm this source-area change.")

if tool_name == "Bash":
    command = tool_input.get("command", "")
    for path in shell_paths_that_may_be_written(command):
        if is_source_area_path(path):
            ask(f"This shell command appears to modify {path} outside wiki/. Confirm this source-area change.")

sys.exit(0)
