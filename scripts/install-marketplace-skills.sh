#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
DRY_RUN="${2:-}"
MANIFEST="$REPO_ROOT/config/skills/skills-manifest.json"
SKILLS_DIR="$HOME/.claude/skills"

if [ ! -f "$MANIFEST" ]; then
    echo "Error: skills-manifest.json not found" >&2
    exit 1
fi

if ! command -v python3 &>/dev/null && ! command -v python &>/dev/null; then
    echo "Error: python3 required to parse manifest" >&2
    exit 1
fi

PY=$(command -v python3 || command -v python)

mapfile -t REINSTALL < <($PY -c "
import json, sys
m = json.load(open('$MANIFEST'))
for s in m.get('reinstall_by_name', []):
    print(s)
")

missing=()
present=()

for name in "${REINSTALL[@]}"; do
    if [ -d "$SKILLS_DIR/$name" ]; then
        present+=("$name")
    else
        missing+=("$name")
    fi
done

echo "Skills status:"
echo "  Already installed : ${#present[@]}"
echo "  Missing           : ${#missing[@]}"

if [ ${#missing[@]} -eq 0 ]; then
    echo "All marketplace skills are installed."
    exit 0
fi

echo ""
echo "Missing skills:"
for name in "${missing[@]}"; do echo "  - $name"; done
echo ""

if [ "$DRY_RUN" = "--dry-run" ]; then
    echo "[DryRun] Would attempt: claude plugin install <name> for each missing skill."
    exit 0
fi

failed=()
for name in "${missing[@]}"; do
    echo "Installing $name ..."
    if claude plugin install "$name" 2>/dev/null; then
        echo "  OK"
    else
        echo "  Warning: auto-install failed for $name"
        failed+=("$name")
    fi
done

if [ ${#failed[@]} -gt 0 ]; then
    echo ""
    echo "Could not auto-install the following; install manually in Claude Code:"
    for name in "${failed[@]}"; do echo "  /plugin install $name"; done
    exit 1
fi

echo ""
echo "All marketplace skills installed."
