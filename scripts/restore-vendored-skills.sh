#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
MANIFEST="$REPO_ROOT/config/skills/skills-manifest.json"

if [ ! -f "$MANIFEST" ]; then
    echo "Error: skills-manifest.json not found" >&2
    exit 1
fi

PY=$(command -v python3 || command -v python)

# Restore vendored skills
while IFS= read -r line; do
    name=$(echo "$line"    | $PY -c "import sys,json; d=json.loads(sys.stdin.read()); print(d['name'])")
    src_rel=$(echo "$line" | $PY -c "import sys,json; d=json.loads(sys.stdin.read()); print(d['target_repo_path'])")
    restore=$(echo "$line" | $PY -c "import sys,json,os; d=json.loads(sys.stdin.read()); print(d['restore_path'].replace('%USERNAME%', os.environ.get('USER','')).replace('C:/Users/' + os.environ.get('USER',''), os.environ['HOME']).replace('\\\\','/'))")

    src="$REPO_ROOT/$src_rel"

    if [ ! -d "$src" ]; then
        echo "Warning: vendored skill not found, skipping: $src"
        continue
    fi

    mkdir -p "$(dirname "$restore")"
    rm -rf "$restore"
    cp -r "$src" "$restore"
    echo "Restored $name -> $restore"
done < <($PY -c "
import json
m = json.load(open('$MANIFEST'))
for s in m.get('vendor_from_local', []):
    print(__import__('json').dumps(s))
")

# Restore git_clone skills
while IFS= read -r line; do
    name=$(echo "$line"   | $PY -c "import sys,json; d=json.loads(sys.stdin.read()); print(d['name'])")
    remote=$(echo "$line" | $PY -c "import sys,json; d=json.loads(sys.stdin.read()); print(d['remote'])")
    restore=$(echo "$line" | $PY -c "import sys,json,os; d=json.loads(sys.stdin.read()); print(d['restore_path'].replace('%USERNAME%', os.environ.get('USER','')).replace('\\\\','/'))")

    if [ -d "$restore" ]; then
        echo "Already exists, skipping git_clone: $name"
        continue
    fi

    if ! command -v git &>/dev/null; then
        echo "Warning: git not found, cannot clone $name"
        continue
    fi

    mkdir -p "$(dirname "$restore")"
    echo "Cloning $name from $remote ..."
    git clone "$remote" "$restore"
    echo "Cloned $name -> $restore"
done < <($PY -c "
import json
m = json.load(open('$MANIFEST'))
for s in m.get('git_clone', []):
    print(__import__('json').dumps(s))
")

# Restore global Claude config
CLAUDE_SRC="$REPO_ROOT/config/claude/CLAUDE.md"
CLAUDE_DST="$HOME/.claude/CLAUDE.md"
if [ -f "$CLAUDE_SRC" ]; then
    mkdir -p "$(dirname "$CLAUDE_DST")"
    cp "$CLAUDE_SRC" "$CLAUDE_DST"
    echo "Restored CLAUDE.md -> $CLAUDE_DST"
fi

# Restore global Codex config
CODEX_SRC="$REPO_ROOT/config/codex/AGENTS.md"
CODEX_DST="$HOME/.codex/AGENTS.md"
if [ -f "$CODEX_SRC" ]; then
    mkdir -p "$(dirname "$CODEX_DST")"
    cp "$CODEX_SRC" "$CODEX_DST"
    echo "Restored AGENTS.md -> $CODEX_DST"
fi
