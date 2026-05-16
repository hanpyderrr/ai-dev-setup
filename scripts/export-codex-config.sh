#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
SOURCE="$HOME/.codex/AGENTS.md"
TARGET="$REPO_ROOT/config/codex/AGENTS.md"

if [ ! -f "$SOURCE" ]; then
    echo "Warning: ~/.codex/AGENTS.md not found; skipping"
    exit 0
fi

mkdir -p "$(dirname "$TARGET")"
cp "$SOURCE" "$TARGET"
echo "Exported AGENTS.md -> $TARGET"
