---
name: codex-worker
description: 当任务需要与本机 Codex CLI 协作（委派实现、独立审查、跨模块重构、批量改动）时使用。Claude 作为主控，Codex 作为 worker。仅在 Windows + PowerShell 环境可用。
---

# Codex Worker 协作流程

## 适用范围

满足以下任一条件时启用：

- 用户明确要求引入 Codex 做实现或审查
- 预计修改 ≥ 5 个文件，且可拆分为清晰子任务
- 单文件改动预计 > 200 行
- 涉及跨模块重构
- 需要独立第二意见的代码审查

**不满足以上条件时不要启用**，避免对简单任务过度工程。

## 平台前提

脚本路径仅适用于 Windows（PowerShell + `$env:USERPROFILE`）。其他平台跳过整套流程，由 Claude 自行处理并告知用户。

## 角色边界

- Claude 是主控，负责判断、审查、最终采纳。
- Codex 是 worker，只接受被委派的具体任务。
- 不让 Codex 调用 Claude，避免递归。
- 失败时回退到 Claude 自行执行，不阻塞用户。

## 流程

### 1. 预检

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.agents\bin\codex-preflight.ps1" -ProjectRoot "$(Get-Location)"
```

返回 `"ok": true` 才继续。否则直接进入 Claude 自行实现路径。

### 2. 委派实现

先将任务描述写入文件（避免引号、换行、特殊字符引发的参数解析问题）：

```powershell
Set-Content -Path ".\AI_CODEX_PROMPT.md" -Value "<具体任务描述>" -Encoding UTF8
```

再调用脚本：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.agents\bin\codex-delegate.ps1" -ProjectRoot "$(Get-Location)" -PromptFile ".\AI_CODEX_PROMPT.md"
```

结果写入 `AI_CODEX_RESULT.md`。Claude 必须：

1. 读取 `AI_CODEX_RESULT.md` 全文。
2. **扫描是否含 secret / token / credential / 私钥痕迹**，发现后立即指出并拒绝采纳该部分。
3. 检查实际改动（`git diff`），与结果描述对照。
4. 对每条改动独立判断是否采纳，不盲信。

### 3. 委派审查

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.agents\bin\codex-review.ps1" -ProjectRoot "$(Get-Location)"
```

结果写入 `AI_REVIEW.md`。Claude 处理每条发现时必须独立验证（读对应代码或跑测试），并标注：

- `ACCEPTED` — 已确认并将修复
- `REJECTED` — 已确认无问题或不适用，说明理由
- `NEEDS-INFO` — 需要更多上下文，挂起

按严重程度顺序处理 `ACCEPTED` 项，修复后在 `AI_REVIEW.md` 标记 `[x] FIXED`。

### 4. 交接记录

仅当本次工作构成一个**完整任务节点**（用户视角的一次交付）时，在 `AI_HANDOFF.md` 追加：

```markdown
## YYYY-MM-DD HH:mm - Claude 交接

### 摘要
- ...

### 修改文件
- `path/to/file`

### 验证方式
- `命令`

### 已知问题
- ...
```

中间步骤、单文件小改动、typo 修复不写 handoff。

## 安全

- 不读取真实凭据文件内容，例如 `.env`、私钥、token dump、credential store；只可检查文件是否存在、是否被误提交或是否出现在 diff 中。
- 不把 Codex 的原始输出直接提交到 Git，先经 Claude 审查。
- Codex 结果中出现的任何凭据痕迹一律拒绝采纳并提示用户。

## 文件清单

启用本 skill 时可能产生的文件：

- `AI_CODEX_RESULT.md` — Codex 实现结果
- `AI_REVIEW.md` — Codex 审查结果及处理状态
- `AI_HANDOFF.md` — 完整任务节点的交接记录
- `AGENTS.md` — 给 Codex 看的项目工作指南（项目级别，按需创建）

未启用本 skill 时不创建上述任何文件。