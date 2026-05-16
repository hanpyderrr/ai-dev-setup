---
name: project-init
description: Full project bootstrap for Claude Code — auto-detects project type, generates CLAUDE.md from codebase analysis, runs git init, creates .gitignore, sets up .claude/settings.json with per-type pre-approved commands, and initializes Claude+Codex collaboration files. Use whenever the user says "初始化项目", "project init", "bootstrap project", "setup new project", "initialize repo", "set up Claude Code for this project", or when starting to work in a fresh or uninitialized directory. Replaces /init entirely and also handles git and collaboration setup in one shot.
---

# Project Init

A complete project setup skill that does in one pass what otherwise takes four or five separate steps.

## What this skill does

1. Detect project type(s) from files on disk
2. Read and analyze the codebase, then write `CLAUDE.md`
3. Initialize a git repo if one doesn't exist yet
4. Create or augment `.gitignore` for the detected type(s)
5. Create `.claude/settings.json` with pre-approved commands so common tool calls don't interrupt the user with permission prompts
6. Run `codex-init-project.ps1` to set up Claude+Codex collaboration files

Work through these steps in order. Report what was skipped (already existed) vs. what was created.

---

## Step 1 — Detect project type

Scan the project root (and one level deep) for marker files. A project can have multiple types simultaneously (e.g., Qt + C++ are common together).

| Marker files | Type label |
|---|---|
| `CMakeLists.txt`, `*.cmake`, mass of `*.c`/`*.cpp`/`*.h` | **cpp** |
| `*.pro` (Qt project file) | **qt** |
| `requirements.txt`, `setup.py`, `pyproject.toml`, `*.py` (several) | **python** |
| `package.json` | **node** |
| `*.uvprojx`, `*.ewp`, `*.ioc`, `*.s` (ARM assembly) | **embedded** |
| `Cargo.toml` | **rust** |
| `go.mod` | **go** |
| `Makefile` alone (no C++ marker) | **makefile** |

Note the detected types — they drive Steps 4 and 5.

---

## Step 2 — Analyze codebase and write CLAUDE.md

Read selectively — you're building a mental model, not cataloguing every file.

**What to read:**
- `README.md` / `README.txt` if present
- Build configs: `CMakeLists.txt`, `Makefile`, `*.pro`, `package.json`, `pyproject.toml`
- Entry-point sources (e.g., `main.cpp`, `main.py`, `main.go`)
- Key scripts (shell scripts, automation scripts)
- Any existing docs or architecture notes (`.txt`, `.md` in root)
- A sample of up to 3 non-trivial source files to understand patterns

**What to extract:**
- How to build each component (exact commands)
- How to run the project
- High-level architecture — nodes, data flow, protocols, hardware interfaces if embedded
- Non-obvious conventions (file formats, naming, hardware-side constraints)

**Write `CLAUDE.md`** at the project root. Always start with:

```
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.
```

Then write the substantive sections. Don't pad it with generic advice. Focus on what's genuinely non-obvious from reading the file names alone — build quirks, deployment steps, data format contracts, hardware constraints, cross-compilation requirements.

If `CLAUDE.md` already exists and has real content (not just the standard header), **do not overwrite it** — append a `## [Project Init additions]` section only if there's something worth adding.

---

## Step 3 — Git init

Check whether the directory is already inside a git repo:

```bash
git rev-parse --git-dir 2>/dev/null
```

If this fails (exit code nonzero), run `git init`. If it succeeds, skip this step and note "git repo already exists."

---

## Step 4 — Create or augment .gitignore

Read `references/gitignore-templates.md` for the pattern blocks. Use the blocks that match your detected types plus the universal block (always include it).

If `.gitignore` already exists:
- Check which blocks are already covered
- Append only missing blocks, with a `# [project-init added]` comment before each appended section

If it doesn't exist, write a new one combining universal + type-specific blocks.

---

## Step 5 — Create .claude/settings.json

Read `references/settings-permissions.md` for the permission lists per project type.

Create `.claude/` if it doesn't exist. Then:

- If `.claude/settings.json` doesn't exist: write a fresh file with universal + type-specific allow-list
- If it exists: read it, merge in any missing permissions from the type-specific list, write back

Format:
```json
{
  "permissions": {
    "allow": [
      "Bash(git *)",
      "..."
    ]
  }
}
```

---

## Step 6 — Codex collaboration files

Run the shared initializer script (Windows/PowerShell):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.agents\bin\codex-init-project.ps1" -ProjectRoot "<absolute-project-root>"
```

After it completes, confirm these files exist at the project root:
- `AGENTS.md`
- `AI_HANDOFF.md`
- `AI_REVIEW.md`
- `AI_CODEX_RESULT.md`
- `AI_CODEX_AUDIT.md`

And confirm `CLAUDE.md` now contains `LOCAL_CODEX_WORKER_RULES_START`.

If the script is not available (path doesn't exist or returns an error), skip this step with a note — don't block the rest of the init.

---

## Step 7 — Summary

Print a concise report:

```
## Project Init Complete

**Detected types**: cpp, qt

| Step | Result |
|------|--------|
| CLAUDE.md | Created (437 words) |
| git init | Skipped (repo already existed) |
| .gitignore | Created (cpp + qt + universal blocks) |
| .claude/settings.json | Created (18 allow-rules) |
| Codex collab files | Created (AGENTS.md, AI_HANDOFF.md, AI_REVIEW.md, AI_CODEX_RESULT.md, AI_CODEX_AUDIT.md) |
```

If anything was skipped or failed, say why.
