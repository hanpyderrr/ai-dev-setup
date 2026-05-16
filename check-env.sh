#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="${1:-$(cd "$(dirname "$0")" && pwd)}"

check_tool() {
    local name="$1"
    if command -v "$name" >/dev/null 2>&1; then
        echo "- $name: OK"
    else
        echo "- $name: MISSING"
    fi
}

echo "Tool check:"
check_tool git
check_tool gh
check_tool node
check_tool python3
check_tool claude
check_tool codex

MANIFEST="$REPO_ROOT/config/skills/skills-manifest.json"
VENDORED_DIR="$REPO_ROOT/skills/vendored"
CLAUDE_CONFIG_REPO="$REPO_ROOT/config/claude/CLAUDE.md"
CODEX_CONFIG_REPO="$REPO_ROOT/config/codex/AGENTS.md"
CLAUDE_CONFIG_LOCAL="$HOME/.claude/CLAUDE.md"
CODEX_CONFIG_LOCAL="$HOME/.codex/AGENTS.md"

echo ""
echo "Repo files:"
[ -f "$MANIFEST" ] && echo "- skill manifest: OK" || echo "- skill manifest: MISSING"
[ -d "$VENDORED_DIR" ] && echo "- vendored skills dir: OK" || echo "- vendored skills dir: MISSING"

echo ""
echo "Config files:"
[ -f "$CLAUDE_CONFIG_REPO" ] && echo "- repo Claude config: OK" || echo "- repo Claude config: MISSING"
[ -f "$CODEX_CONFIG_REPO" ] && echo "- repo Codex config: OK" || echo "- repo Codex config: MISSING"
[ -f "$CLAUDE_CONFIG_LOCAL" ] && echo "- local Claude config: OK" || echo "- local Claude config: MISSING"
[ -f "$CODEX_CONFIG_LOCAL" ] && echo "- local Codex config: OK" || echo "- local Codex config: MISSING"
