#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
RESTORE_VENDORED=false

for arg in "$@"; do
    case "$arg" in
        --restore-vendored-skills) RESTORE_VENDORED=true ;;
    esac
done

# Create required directories
for dir in "$HOME/.claude/skills" "$HOME/.agents/skills" "$HOME/.agents/bin"; do
    mkdir -p "$dir"
    echo "Ensured: $dir"
done

if [ "$RESTORE_VENDORED" = true ]; then
    bash "$REPO_ROOT/scripts/restore-vendored-skills.sh" "$REPO_ROOT"
fi

echo ""
echo "Manual steps still required:"
echo "  - Install and sign in to Claude Code"
echo "  - Install and sign in to Codex"
echo "  - Run: gh auth login"
echo "  - Reconnect any other connectors (Google Drive, etc.)"
echo ""

CHECK_ENV="$REPO_ROOT/check-env.sh"
if [ -f "$CHECK_ENV" ]; then
    bash "$CHECK_ENV" "$REPO_ROOT"
fi
