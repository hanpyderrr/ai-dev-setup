---
name: multi-agent-workspace-init
description: Use when a project should be prepared for Claude Code, Codex, or multiple AI agents to collaborate, especially when the user asks to initialize a shared agent workspace, handoff files, task locks, file ownership, changelog, or prevent agents from editing the same files.
---

# Multi-Agent Workspace Init

## Overview

Set up a conservative file-based collaboration workspace for projects where two or more AI agents may work in parallel. The goal is to make current state, task ownership, locks, decisions, and recent changes visible before any agent edits files.

This skill is project-setup guidance, not an automatic overwrite routine. Preserve meaningful existing project records and adapt paths to the repository's language and structure.

## When To Use

Use this when the user wants to:

- initialize a project for Claude Code + Codex collaboration;
- create shared handoff, task, review, or audit files;
- prevent two agents from editing the same `.pptx`, script, document, or source file;
- define a Markdown workflow for "what changed", "who is working", and "what is locked";
- repair a project whose agent instructions point to stale collaboration paths.

Do not use this for a one-agent quick fix unless the user explicitly asks to set up collaboration infrastructure.

## Core Principle

Create one obvious collaboration center and make every agent read it before working. The center should answer four questions quickly:

| Question | File |
|---|---|
| What is the current state? | `CURRENT_STATE.md` |
| Who is doing what? | `TASK_BOARD.md` |
| What changed recently? | `CHANGELOG.md` |
| What files are reserved? | `FILE_OWNERSHIP.md` + `locks/` |

## Choose The Collaboration Path

Prefer an existing project convention over inventing a new one.

1. If the user specifies a path, use it.
2. If the project already has active records under `文档/工作记录/`, use `文档/工作记录/`.
3. Else if it already has active records under `docs/agent-work/`, use `docs/agent-work/`.
4. Else default to `docs/agent-work/` for code projects and ask only if the choice is risky.

Do not maintain two active collaboration centers. If there are stale historical paths, mark them as historical in the project instructions instead of deleting them.

## Standard Files

Create missing files only. Do not overwrite meaningful existing files unless the user explicitly asks for a force refresh.

```text
<collab-root>/
├── README.md
├── CURRENT_STATE.md
├── TASK_BOARD.md
├── CHANGELOG.md
├── DECISIONS.md
├── FILE_OWNERSHIP.md
├── tasks/
│   └── TASK-000-template.md
├── locks/
│   └── README.md
└── archive/
```

### README.md

Purpose: entrypoint for all agents.

Include:

- startup read order;
- file responsibilities;
- task states;
- lock rules;
- start/finish workflow;
- note that old collaboration paths are historical if applicable.

### CURRENT_STATE.md

Purpose: one-page project state, not a log.

Include:

- project goal;
- current primary artifact;
- current framework or architecture;
- highest-priority next steps;
- known blockers and risky claims.

### TASK_BOARD.md

Purpose: compact task index.

Use this table shape:

```markdown
| ID | 状态 | Owner | 文件范围 | 锁 | 下一步 |
|----|------|-------|----------|----|--------|
| TASK-001 | todo | 未分配 | `path/or/page-range` | 无 | 下一步动作 |
```

Use only these states: `todo`, `in_progress`, `blocked`, `review`, `done`, `cancelled`.

### CHANGELOG.md

Purpose: append-only record of what just changed.

Each entry should include:

```markdown
## YYYY-MM-DD HH:mm | Agent | TASK-xxx

- 修改：...
- 验证：...
- 未改：...
- 风险：...
- 下一步：...
```

Do not rewrite older entries. If an earlier entry was wrong, append a correction.

### DECISIONS.md

Purpose: confirmed project decisions and shared wording.

Use stable IDs:

```markdown
## DEC-001 | Decision title

- 决策：...
- 原因：...
- 影响：...
```

For worker agents, suggest decision updates in task results unless the user has assigned them control of this file.

### FILE_OWNERSHIP.md

Purpose: prevent parallel edits to the same files.

Use this table shape:

```markdown
| 文件/范围 | 当前 owner | 可并行 | 说明 |
|---|---|---|---|
| `CHANGELOG.md` | 任意 agent | 是 | 只能追加 |
| `final.pptx` | 未分配 | 否 | 最终组装稿，单 owner 修改 |
```

Mark `.pptx`, generated decks, migration scripts, build scripts, and main specs as non-parallel unless the project has a safer merge strategy.

### tasks/TASK-000-template.md

Purpose: reusable task contract.

Include sections:

```markdown
# TASK-000：任务标题

## Owner
未分配

## 状态
todo

## 文件范围
- `待填写`

## 输入资料
- `待填写`

## 不要修改
- `待填写`

## 背景

## 具体步骤

## 完成标准

## 验证方式

## 交付物

## 剩余风险

## 变更记录
```

### locks/README.md

Purpose: explain lock files.

Lock template:

```markdown
# LOCK TASK-001

owner: Codex
status: active
started_at: YYYY-MM-DD HH:mm
expires_at: YYYY-MM-DD HH:mm
heartbeat: YYYY-MM-DD HH:mm

locked_files:
- path/to/file

reason:
- Why the lock exists.

release_condition:
- What must be true before release.
```

If a lock is stale, do not overwrite the locked files. Mark the task `blocked` and ask the controller or user whether to take over.

## Updating Project Instructions

After creating the collaboration center, update the project agent instruction file if one exists, usually `AGENTS.md`.

The project instructions should say that every agent starts by reading:

1. `<collab-root>/README.md`
2. `<collab-root>/CURRENT_STATE.md`
3. `<collab-root>/TASK_BOARD.md`
4. `<collab-root>/FILE_OWNERSHIP.md`
5. `<collab-root>/DECISIONS.md`
6. `<collab-root>/CHANGELOG.md`
7. The relevant task file and lock files

If the old instructions point to stale paths, explicitly mark those paths as historical rather than leaving contradictory startup instructions.

## Workflow For Each Task

Before editing:

1. Read the collaboration startup files.
2. Select or create a `TASK-xxx.md`.
3. Check `FILE_OWNERSHIP.md` and `locks/`.
4. Create a lock for exclusive files.
5. Update `TASK_BOARD.md` to `in_progress`.
6. Append a start entry to `CHANGELOG.md`.

After editing:

1. Run the relevant verification.
2. Update the task file with deliverables and risk.
3. Append a `CHANGELOG.md` entry.
4. Set the task to `review` or `done`.
5. Mark the lock as `released` or archive it.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Creating both `docs/agent-work/` and `文档/工作记录/` as active centers | Pick one active center and mark the other historical |
| Letting two agents modify one `.pptx` | Split into single-page files or scripts, then assign one owner to assemble |
| Treating `CHANGELOG.md` as a mutable status file | Keep it append-only; use `CURRENT_STATE.md` for current status |
| Writing web or paper excerpts into task board | Put research in a findings document and reference it |
| Lock without expiry | Add `expires_at`, usually within two hours |
| Updating `AGENTS.md` but not syncing config when required | Run the project/user config sync workflow if configured |

## Verification Checklist

Before reporting completion, confirm:

- The collaboration root exists.
- Standard files exist.
- `TASK_BOARD.md` has at least one actionable row or intentionally says no active tasks.
- `FILE_OWNERSHIP.md` marks non-parallel files.
- `locks/README.md` describes lock format and stale lock handling.
- Project instructions point to the active collaboration root.
- If a configured sync workflow exists after editing `AGENTS.md` or skills, it was run or the reason it could not run is reported.
