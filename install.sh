#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./install.sh
  ./install.sh --target /path/to/vault --claude --opencode

Options:
  --target PATH   Target Obsidian vault/project root.
  --claude        Install Claude Code configuration.
  --opencode      Install OpenCode configuration.
  --all           Install both Claude Code and OpenCode configuration.
  --yes           Skip confirmation prompts.
  -h, --help      Show this help.
EOF
}

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

have_command() {
  command -v "$1" >/dev/null 2>&1
}

script_dir() {
  local source=${BASH_SOURCE[0]}
  local dir
  dir=$(CDPATH= cd -- "$(dirname -- "$source")" && pwd -P)
  printf '%s\n' "$dir"
}

normalize_path() {
  local path=$1

  if [[ $path == \"*\" && $path == *\" ]]; then
    path=${path:1:${#path}-2}
  elif [[ $path == \'*\' && $path == *\' ]]; then
    path=${path:1:${#path}-2}
  fi

  if [[ $path == "\\~"* ]]; then
    path="~${path#"\\~"}"
  fi
  path=${path//\\ / }

  if [[ $path == "~" ]]; then
    printf '%s\n' "$HOME"
  elif [[ $path == "~/"* ]]; then
    printf '%s/%s\n' "$HOME" "${path#"~/"}"
  elif [[ $path == /* ]]; then
    printf '%s\n' "$path"
  else
    printf '%s/%s\n' "$PWD" "$path"
  fi
}

confirm() {
  local prompt=$1
  local answer
  read -r -p "$prompt [y/N] " answer
  case "$answer" in
    y|Y|yes|YES) return 0 ;;
    *) return 1 ;;
  esac
}

copy_dir_materialized() {
  local src_rel=$1
  local dst_rel=$2
  local src="$SOURCE_DIR/$src_rel"
  local dst="$TARGET_DIR/$dst_rel"

  if [[ ! -d $src ]]; then
    printf '  skip missing %s\n' "$src_rel"
    return 0
  fi

  if [[ -L $dst || -f $dst ]]; then
    rm -f "$dst"
  elif [[ -e $dst && ! -d $dst ]]; then
    die "cannot install directory over existing non-directory: $dst_rel"
  fi

  mkdir -p "$dst"
  rsync -aL "$src/" "$dst/"
  printf '  installed %s\n' "$dst_rel"
}

copy_file_materialized() {
  local src_rel=$1
  local dst_rel=$2
  local src="$SOURCE_DIR/$src_rel"
  local dst="$TARGET_DIR/$dst_rel"

  if [[ ! -e $src && ! -L $src ]]; then
    printf '  skip missing %s\n' "$src_rel"
    return 0
  fi

  if [[ -d $dst && ! -L $dst ]]; then
    die "cannot install file over existing directory: $dst_rel"
  fi

  mkdir -p "$(dirname -- "$dst")"
  rsync -aL "$src" "$dst"
  printf '  installed %s\n' "$dst_rel"
}

init_wiki_scaffold() {
  local src="$SOURCE_DIR/wiki"
  local dst="$TARGET_DIR/wiki"

  if [[ ! -d $src ]]; then
    return 0
  fi

  mkdir -p "$dst"
  rsync -a --ignore-existing \
    --exclude 'pycache/' \
    --exclude '__pycache__/' \
    "$src/templates" "$src/meta" "$dst/" 2>/dev/null || true
  printf '  initialized missing wiki scaffold files\n'
}

TARGET_DIR=
INSTALL_CLAUDE=0
INSTALL_OPENCODE=0
NONINTERACTIVE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      [[ $# -ge 2 ]] || die "--target requires a path"
      TARGET_DIR=$2
      shift 2
      ;;
    --claude)
      INSTALL_CLAUDE=1
      shift
      ;;
    --opencode)
      INSTALL_OPENCODE=1
      shift
      ;;
    --all)
      INSTALL_CLAUDE=1
      INSTALL_OPENCODE=1
      shift
      ;;
    --yes)
      NONINTERACTIVE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "unknown option: $1"
      ;;
  esac
done

SOURCE_DIR=$(script_dir)

have_command rsync || die "rsync is required"

if [[ -z $TARGET_DIR ]]; then
  read -r -p "Target directory: " TARGET_DIR
fi

[[ -n $TARGET_DIR ]] || die "target directory is required"
TARGET_DIR=$(normalize_path "$TARGET_DIR")

if [[ $INSTALL_CLAUDE -eq 0 && $INSTALL_OPENCODE -eq 0 ]]; then
  printf '\nSelect integrations to install:\n'
  printf '  [1] Claude Code\n'
  printf '  [2] OpenCode\n'
  read -r -p "Choices, comma/space separated [1 2]: " choices
  choices=${choices:-"1 2"}
  case " $choices " in
    *1*|*[cC]laude*) INSTALL_CLAUDE=1 ;;
  esac
  case " $choices " in
    *2*|*[oO]pencode*) INSTALL_OPENCODE=1 ;;
  esac
fi

[[ $INSTALL_CLAUDE -eq 1 || $INSTALL_OPENCODE -eq 1 ]] || die "nothing selected"

printf '\nSource: %s\n' "$SOURCE_DIR"
printf 'Target: %s\n' "$TARGET_DIR"
printf 'Install:\n'
[[ $INSTALL_CLAUDE -eq 1 ]] && printf '  [x] Claude Code\n' || printf '  [ ] Claude Code\n'
[[ $INSTALL_OPENCODE -eq 1 ]] && printf '  [x] OpenCode\n' || printf '  [ ] OpenCode\n'

if [[ ! -d $TARGET_DIR ]]; then
  if [[ $NONINTERACTIVE -eq 1 ]] || confirm "Create target directory?"; then
    mkdir -p "$TARGET_DIR"
  else
    die "target directory does not exist"
  fi
fi

if [[ $NONINTERACTIVE -eq 0 ]]; then
  confirm "Install into this target?" || die "cancelled"
fi

printf '\nInstalling files:\n'

if [[ $INSTALL_CLAUDE -eq 1 ]]; then
  mkdir -p "$TARGET_DIR/.claude"
  copy_dir_materialized ".claude/commands" ".claude/commands"
  copy_dir_materialized ".claude/agents" ".claude/agents"
  copy_file_materialized ".claude/settings.json" ".claude/settings.json"
  copy_dir_materialized "hooks" "hooks"
  [[ -e "$SOURCE_DIR/CLAUDE.md" || -L "$SOURCE_DIR/CLAUDE.md" ]] && copy_file_materialized "CLAUDE.md" "CLAUDE.md"
fi

if [[ $INSTALL_OPENCODE -eq 1 ]]; then
  mkdir -p "$TARGET_DIR/.opencode"
  copy_dir_materialized ".opencode/commands" ".opencode/commands"
  copy_dir_materialized ".opencode/skills" ".opencode/skills"
  copy_dir_materialized ".opencode/agents" ".opencode/agents"
  copy_file_materialized "opencode.json" "opencode.json"
  [[ -e "$SOURCE_DIR/AGENTS.md" || -L "$SOURCE_DIR/AGENTS.md" ]] && copy_file_materialized "AGENTS.md" "AGENTS.md"
fi

init_wiki_scaffold

printf '\nDone.\n'
