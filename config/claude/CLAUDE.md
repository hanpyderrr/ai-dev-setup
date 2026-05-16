# 全局开发规范

## 编码工作流：Codex 优先

**每次开始写代码前**，先运行 Codex 预检：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.agents\bin\codex-preflight.ps1" -ProjectRoot "$(Get-Location)"
```

- 若返回 `"ok": true`：将实现任务委派给 Codex，Claude 负责审查结果、检查实际改动、做最终判断
- 若预检失败：Claude 自行实现，不阻塞用户

## Skill / 配置文件同步规则

以下操作完成后，必须调用 `/sync-ai-config` 同步到 ai-dev-setup 仓库：

- 新增或修改任何 skill（`~/.claude/skills/` 或 `~/.agents/skills/`）
- 修改全局 `~/.claude/CLAUDE.md`
- 修改项目内 `AGENTS.md`

---

## 角色纪律

- 改动范围严格限制在当前请求步骤内，不做超出请求的重构或抽象
- 每次改动只解决当前问题，不顺手清理周边代码
- 功能未经人工验证前不视为完成

## 质量门槛

- 后端 API 改动必须有对应测试，且测试通过
- 前端改动必须通过构建检查（`npm run build` 或等效命令）
- 数据模型变更必须包含迁移或初始化逻辑
- 不提交任何密钥、secret 或含真实凭据的配置文件

---

## 多 Agent 协作规范

**仅当用户明确要求引入第二个 AI agent（如 Codex）做审查时，才启用以下规范并创建对应文件。单独使用 Claude 时不创建这些文件。**

### 启用时需创建的文件

- `AI_HANDOFF.md` — Claude Code 每次改完代码后的交接记录
- `AI_REVIEW.md` — 审查 agent 的发现和验证结果
- `AGENTS.md` — 审查 agent 的工作指南

### 交接记录格式（AI_HANDOFF.md）

每次修改文件后，在回复前必须追加一条记录：

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

### Review 处理流程

收到审查 agent 的 Review 后：

1. 读 `AI_REVIEW.md`
2. 按严重程度顺序修复 OPEN 问题
3. 将已修复项在 `AI_REVIEW.md` 中标记为 `[x] FIXED`
4. 在 `AI_HANDOFF.md` 中记录本次修复内容
5. 未解决的问题明确留存，不要隐藏

<!-- CODEX_WORKER_RULES_START -->

## Codex CLI Worker 协作规则

当任务属于大工程、跨模块修改、批量重构、独立审查，或用户明确要求 Claude 与 Codex 配合时，Claude 先尝试使用本机 Codex CLI 作为 worker。

### 调用前检查

先运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.agents\bin\codex-preflight.ps1" -ProjectRoot "$(Get-Location)"
```

仅当返回 `"ok": true` 时才委派任务。若失败，Claude 自行继续，不要阻塞用户。

### 委派实现

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.agents\bin\codex-delegate.ps1" -ProjectRoot "$(Get-Location)" -Prompt "具体任务"
```

Codex 的结果写入 `AI_CODEX_RESULT.md`。Claude 必须读取结果、检查实际改动，并继续负责最终判断。

### 委派审查

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.agents\bin\codex-review.ps1" -ProjectRoot "$(Get-Location)"
```

审查结果写入 `AI_REVIEW.md`。Claude 按严重程度处理发现，不盲目采纳。

### 边界

- Claude 是主控，Codex 是 worker。
- 不让 Codex 再调用 Claude，避免递归协作。
- 不读取 `auth.json`、credentials、token、secret 等文件。
- 失败时回退到 Claude 自己执行。

<!-- CODEX_WORKER_RULES_END -->
