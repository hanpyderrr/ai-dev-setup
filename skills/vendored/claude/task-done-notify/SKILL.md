---
name: task-done-notify
description: 任务完成后或等待用户确认时主动通知用户（Windows 桌面弹窗 + PushNotification + 飞书机器人）。用户经常切换窗口，需要知道 Claude 什么时候完成了任务，以及什么时候在等他确认。
---

# 完成 / 等待确认通知

## 目的

用户在等待 Claude 处理任务时会切换到其他窗口。这个 skill 定义了何时、以何种方式主动通知用户：
1. 任务已完成
2. Claude 遇到问题需要用户确认后才能继续推进

通知通道有三条，按覆盖范围组合使用：
- **PushNotification**（桌面/手机推送）：Claude 主动调用，任务级
- **托盘弹窗**（`notify-done.ps1` / `notify-waiting.ps1`）：Windows 本机，其中 done 由 Stop hook 自动触发
- **飞书机器人**（`notify-feishu.ps1`）：任务级 + 等待确认，覆盖用户不在电脑前的场景

## 两类通知

### 场景 A：任务完成通知

#### Layer 1：Claude 主动调用 PushNotification（任务级）

当完成一个用户可感知的任务节点时，立即调用内置的 `PushNotification` 工具，附上任务结果摘要。

**何时调用：**
- 完成一次多步骤实现任务（涉及多文件修改、测试运行）
- Codex 委派任务执行完毕、Claude 已完成审查
- 用户明确要求的功能/修复已完成并验证
- 耗时操作（构建、测试、长分析）完成

**何时不调用：**
- 单纯回答问题（没有代码改动）
- 对话中间步骤（还没到最终交付）
- 小的单行修改（明显无需等待）

**消息格式（简洁、信息量足够用户决策）：**

```
标题：任务完成 ✓
内容：<一句话描述完成了什么> + 如有风险或待办项 → 简要说明
```

示例：
- "后端 WAL 模式已启用，提醒 worker 已集成到 lifespan"
- "Codex 实现完成，已审查 3 个文件，无安全问题，可提交"
- "build 通过，API 类型错误已修复"

#### Layer 1b：飞书机器人消息（与 PushNotification 同一时机）

任务完成节点调用 PushNotification 后，**同时**调用飞书脚本，把同一条结果摘要推到用户的飞书（手机上也能收到）：

```powershell
powershell -NoProfile -File "C:\Users\hanpyder\.claude\scripts\notify-feishu.ps1" -Message "<结果摘要>"
```

- 消息格式与 PushNotification 相同：一句话结果 + 风险/待办。
- 脚本读环境变量 `FEISHU_BOT_WEBHOOK`（必填）与 `FEISHU_BOT_SECRET`（可选，机器人开签名校验时必填），未设置时静默跳过。
- 失败静默（best-effort），不因通知失败影响任务收尾。

#### Layer 2：Stop Hook 自动触发（会话级）

`~/.claude/settings.json` 已配置 Stop hook，每次 Claude 停止响应时自动弹出 Windows 系统托盘通知（"Claude 完成了任务"）。

这是兜底机制，无需 Claude 手动触发。脚本位于：
```
C:\Users\hanpyder\.claude\scripts\notify-done.ps1
```

### 场景 B：等待确认通知

当 Claude 遇到以下情况、必须停下来等用户确认才能继续推进时，**主动**调用等待确认脚本（Windows 托盘通知），让切走窗口的用户知道该回来做决定了。

**何时调用：**
- 需要用户决策才能继续（AskUserQuestion 提问、方案选择）
- 阻塞性问题：信息缺失、权限、冲突、破坏性操作确认
- 计划需要批准、任务推进方向拿不准必须问用户

**如何调用（PowerShell）：**
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\hanpyder\.claude\scripts\notify-waiting.ps1" -Message "需要你确认：<一句话说明卡点>"
```

脚本位于：
```
C:\Users\hanpyder\.claude\scripts\notify-waiting.ps1
```
默认文案"需要你的确认"，图标为警告（Warning），与"任务完成"的信息（Info）图标区分。

等待确认时**同时**发飞书（用户可能人不在电脑前）：

```powershell
powershell -NoProfile -File "C:\Users\hanpyder\.claude\scripts\notify-feishu.ps1" -Message "需要你确认：<一句话说明卡点>"
```

**何时不调用：**
- 已有其他通知手段覆盖（如刚弹过 PushNotification）
- 问题不阻塞、用户可随时回复（避免频繁打扰）

## 依赖

- `PushNotification`：Claude Code 内置工具，直接调用
- `notify-done.ps1`：Windows 系统托盘气泡通知，由 Stop hook 自动调用
- `notify-waiting.ps1`：Windows 系统托盘警告通知，Claude 等待确认时主动调用
- `notify-feishu.ps1`：飞书机器人消息，任务完成与等待确认时主动调用；依赖用户级环境变量 `FEISHU_BOT_WEBHOOK`（webhook 地址）与 `FEISHU_BOT_SECRET`（可选，加签密钥）。变量用 `setx` 设置一次即可，**严禁写入任何会被 git 同步的文件**（skill、CLAUDE.md 等）
- Stop hook 已在 `~/.claude/settings.json` 配置，无需额外设置

## 平台说明

托盘脚本仅在 Windows 有效（依赖 `System.Windows.Forms`）。`PushNotification` 工具跨平台可用。飞书脚本跨平台逻辑通用，但当前按 PowerShell 5.1 语法编写（Windows PowerShell 实测通过）。
