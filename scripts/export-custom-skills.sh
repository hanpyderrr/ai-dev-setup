#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
MANIFEST="$REPO_ROOT/config/skills/skills-manifest.json"

if [ ! -f "$MANIFEST" ]; then
    echo "Error: skills-manifest.json not found" >&2
    exit 1
fi

PY=$(command -v python3 || command -v python)

while IFS= read -r line; do
    name=$(echo "$line" | $PY -c "import sys,json; d=json.loads(sys.stdin.read()); print(d['name'])")
    src=$(echo "$line"  | $PY -c "import sys,json,os; d=json.loads(sys.stdin.read()); print(d['source_path'].replace('C:/Users/hanpyder', os.environ['HOME']).replace('\\\\','/'))")
    tgt_rel=$(echo "$line" | $PY -c "import sys,json; d=json.loads(sys.stdin.read()); print(d['target_repo_path'])")
    tgt="$REPO_ROOT/$tgt_rel"

    if [ ! -d "$src" ]; then
        echo "Warning: source not found, skipping: $src"
        continue
    fi

    mkdir -p "$(dirname "$tgt")"
    rm -rf "$tgt"
    cp -r "$src" "$tgt"
    echo "Exported $name -> $tgt"
done < <($PY -c "
import json, sys
m = json.load(open('$MANIFEST'))
for s in m.get('vendor_from_local', []):
    print(json.dumps(s))
")

# Export global config files
EXPORT_CLAUDE_CONFIG="$(dirname "$0")/export-claude-config.sh"
if [ -f "$EXPORT_CLAUDE_CONFIG" ]; then
    bash "$EXPORT_CLAUDE_CONFIG" "$REPO_ROOT"
fi

EXPORT_CODEX_CONFIG="$(dirname "$0")/export-codex-config.sh"
if [ -f "$EXPORT_CODEX_CONFIG" ]; then
    bash "$EXPORT_CODEX_CONFIG" "$REPO_ROOT"
fi

echo ""
echo "Done. Remember to commit and push:"
echo "  git add -A && git commit -m 'chore: sync skills and config' && git push"
