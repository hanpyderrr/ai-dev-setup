#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
SOURCE="$HOME/.claude/CLAUDE.md"
TARGET="$REPO_ROOT/config/claude/CLAUDE.md"

if [ ! -f "$SOURCE" ]; then
    echo "Warning: ~/.claude/CLAUDE.md not found; skipping"
    exit 0
fi

mkdir -p "$(dirname "$TARGET")"
cp "$SOURCE" "$TARGET"
echo "Exported CLAUDE.md -> $TARGET"
