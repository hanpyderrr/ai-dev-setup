---
name: sync-ai-config
description: Sync skills and global config to the ai-dev-setup git repo. Use immediately after adding or modifying any skill, after editing ~/.claude/CLAUDE.md, or after editing any AGENTS.md file. Also invoke when the user says "sync config", "push skills", "update ai-dev-setup", or "sync to git".
---

# Sync AI Config

Run this after any of the following:
- A new skill was added or an existing skill was modified
- `~/.claude/CLAUDE.md` was edited
- Any `AGENTS.md` file was edited

## Step 1 — Find the ai-dev-setup repo

Check these locations in order, pick the first that exists and has the expected git remote:

```
E:\vs-workspace\ai-dev-setup      (Windows primary)
~/vs-workspace/ai-dev-setup       (Linux/Mac)
~/ai-dev-setup
```

Verify with: `git -C <path> remote get-url origin` — should contain `ai-dev-setup`.

If not found, tell the user and stop. Don't guess.

## Step 2 — Run the export script

**Windows:**
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "<repo>\scripts\export-custom-skills.ps1" -RepoRoot "<repo>"
```

**Linux/Mac:**
```bash
bash <repo>/scripts/export-custom-skills.sh <repo>
```

This copies vendored skills and `~/.claude/CLAUDE.md` into the repo.

## Step 3 — Commit and push

```bash
git -C <repo> add -A
git -C <repo> status --short
git -C <repo> commit -m "chore: sync skills and config"
git -C <repo> push
```

If `git status` shows nothing to commit, say so and skip the commit.

## Step 4 — Confirm

Report what was synced: which skills were exported, whether CLAUDE.md changed, and the commit hash.
