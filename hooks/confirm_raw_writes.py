#!/usr/bin/env python3
import json
import re
import sys
from pathlib import Path


def ask(reason):
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "ask",
            "permissionDecisionReason": reason,
        }
    }))
    sys.exit(0)


def is_raw_path(value):
    if not value:
        return False
    path = Path(str(value))
    text = str(path)
    return text == ".raw" or text.startswith(".raw/") or ".raw" in path.parts


payload = json.load(sys.stdin)
tool_name = payload.get("tool_name", "")
tool_input = payload.get("tool_input", {})

if tool_name in {"Write", "Edit", "MultiEdit"}:
    path = tool_input.get("file_path") or tool_input.get("path")
    if is_raw_path(path):
        ask(f"This tool call modifies {path} under .raw/. Confirm this source-area change.")

if tool_name == "Bash":
    command = tool_input.get("command", "")
    raw_write_patterns = [
        r">\s*\.raw(?:/|\s|$)",
        r">>\s*\.raw(?:/|\s|$)",
        r"\b(?:mv|cp|rsync)\b[^\n;&|]*\s\.raw(?:/|\s|$)",
        r"\b(?:rm|chmod|chown)\b[^\n;&|]*\.raw(?:/|\s|$)",
        r"\b(?:sed|perl)\b[^\n;&|]*-i[^\n;&|]*\.raw(?:/|\s|$)",
        r"\bpython3?\b[^\n;&|]*\.raw(?:/|\s|$)",
    ]
    if any(re.search(pattern, command) for pattern in raw_write_patterns):
        ask("This shell command appears to modify .raw/. Confirm this source-area change.")

sys.exit(0)
