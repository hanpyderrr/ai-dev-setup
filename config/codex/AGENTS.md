# Codex 全局 Agent 指南

这是由 `ai-dev-setup` 跟踪的 Codex 全局配置。

## 工作方式

- 修改前先理解项目结构和现有实现。
- 如果项目内存在 `AGENTS.md`，必须先阅读；项目级说明优先于本全局说明。
- 除非用户明确要求检查或迁移，否则不要把 `CLAUDE.md` 当作 Codex 指令来源。
- 优先沿用项目已有模式、工具、依赖和脚本。
- 修改范围要紧扣当前任务。
- 不要顺手重构或清理无关代码。
- 除非用户明确要求，不要覆盖、回滚或删除用户已有改动。
- 能通过阅读代码、测试或文档解决的不确定性，先自行调查。
- 只有缺失信息会让继续执行变得有风险时，才向用户提问。
- 对影响较大的多方案选择，实施前先确认方向。
- 涉及架构调整、迁移、公开 API 变化、文件删除或高风险多文件修改时，先说明方案和影响。

## 代码修改

- 做能完成任务的最小一致改动。
- 遵循 rule of three：只有真实重复至少出现三次，或项目已有模式要求时，才引入新抽象。
- 不要随意增加依赖；确实需要时说明原因。
- 匹配仓库现有代码风格。
- 注释要少而有用。
- 代码内注释优先使用英文，除非仓库已经使用其他语言；面向用户的说明默认使用中文。

## 测试与验证

- 修改代码后，先运行最相关、成本最低的验证，例如 unit test、typecheck、lint 或 build。
- 后端 API、数据模型、核心逻辑变更，尽量补充或更新测试。
- 前端行为或构建链变更，实际可行时运行 build/typecheck。
- 数据模型变更必须包含 migration 或初始化逻辑。
- 如果无法运行验证，要说明原因并列出剩余风险。
- 未经过新的验证前，不要声称工作已完成、已修复或已通过。

## Git 习惯

- 除非用户明确要求，不要运行 `git reset --hard`、`git checkout -- .` 等破坏性命令。
- commit 前检查 `git status` 和相关 diff。
- 不要把无关文件放进同一个 commit。
- commit message 保持简洁、事实准确。
- 除非用户明确要求，不要 commit 或 push。
- commit 前检查 staged changes，确认范围符合用户要求。

## 沟通

- 默认用中文回复。
- 表达直接、清楚、简洁。
- 完成后说明改了什么、如何验证、还有什么风险。
- 出错时直接说明问题和下一步修复路径。
- 做 code review 时，优先指出 bug、回归风险、行为风险和缺失测试。

## 安全

- 不要输出或提交 secrets、tokens、cookies、private keys 或 `.env` 内容。
- 不要把真实生产数据写入日志、测试或示例。
- 不要主动读取凭据文件、认证存储、token dump、缓存、大型构建产物或无关目录。
- 涉及删除、迁移、生产数据、权限或计费逻辑时，要保守处理。

## 工具偏好

- 搜索时优先使用 `rg`，不可用时再使用其他工具。
- 通过文件树、入口文件和相关测试定位上下文，避免无关的大范围读取。
- 优先使用项目已有脚本，而不是临时拼命令。
- 除非任务明确需要且已有必要批准，不要安装依赖、拉取远程资源或改变全局工具配置。
- 当完成当前任务所必需的 CMake、CTest、C/C++ 编译器、vcpkg 或其他构建依赖缺失时，默认允许直接安装并继续；如果预计下载量或最终存储占用非常大，安装前先向用户说明估算体积并征求确认。
- 如果命令需要 elevated 或 unsandboxed 权限，通过相应审批机制申请，并说明原因。


## 项目协作记忆

- 如果项目内存在 `docs/agent-work/`，每次开始任务或恢复会话前先阅读其中的 `progress.md`、`AI_HANDOFF.md`、`AI_REVIEW.md`；处理 worker 输出时再读 `AI_CODEX_RESULT.md`。
- 如果项目说明规定协作文件位于 `docs/agent-work/`，不要在根目录新建 `AI_*.md`。
- 完成一次用户可感知的任务节点后，按项目规则更新 handoff/progress，帮助 Claude/Codex 之间保留工作记忆。
## Skill 使用说明

- 多步骤任务使用 planning 类 skill。
- 遇到 bug、测试失败或异常行为时，使用 systematic debugging。
- 声称完成前使用 verification-before-completion。
- 本地 Web UI 相关修改使用 frontend/web testing 类 skill。
- 只有用户明确要求 multi-agent、delegated 或 parallel agent work 时，才使用 subagent。
- 除非用户要求或项目已经使用，不要创建 `AI_HANDOFF.md`、`AI_REVIEW.md`、`AI_CODEX_RESULT.md` 等协作文件。
- 修改全局 agent 配置、skill 或项目 `AGENTS.md` 后，如有配置好的同步脚本就运行，否则提醒用户同步。
- 不要在 Codex 全局指南中加入 Claude 调用 Codex 的委派规则。

