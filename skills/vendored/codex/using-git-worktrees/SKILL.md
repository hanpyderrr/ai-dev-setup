---
name: using-git-worktrees
description: 开始较大功能、并行开发、需要隔离当前工作区时使用。
---

# 使用 Git Worktree

## 原则

- 保护当前工作区和用户改动。
- 并行任务使用独立目录。
- 不在不清楚状态的主工作区直接做高风险重构。

## 步骤

1. 检查当前 `git status`。
2. 确认是否已有合适隔离环境。
3. 需要时创建新 worktree。
4. 在 worktree 中执行任务。
5. 合并前审查 diff 和验证结果。

## 禁止

- 未经用户明确要求，不运行 `git reset --hard`。
- 不删除用户 worktree 或分支。

