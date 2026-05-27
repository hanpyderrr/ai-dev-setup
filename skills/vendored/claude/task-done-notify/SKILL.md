---
name: task-done-notify
description: 任务完成后主动通知用户（Windows 桌面弹窗 + PushNotification）。用户经常切换窗口，需要知道 Claude 什么时候完成了任务。
---

# 任务完成通知

## 目的

用户在等待 Claude 处理任务时会切换到其他窗口。这个 skill 定义了何时、以何种方式主动通知用户任务已完成。

## 两层通知机制

### Layer 1：Claude 主动调用 PushNotification（任务级）

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

### Layer 2：Stop Hook 自动触发（会话级）

`~/.claude/settings.json` 已配置 Stop hook，每次 Claude 停止响应时自动弹出 Windows 系统托盘通知（"Claude 完成了任务"）。

这是兜底机制，无需 Claude 手动触发。脚本位于：
```
C:\Users\hanpyder\.claude\scripts\notify-done.ps1
```

## 依赖

- `PushNotification`：Claude Code 内置工具，直接调用
- `notify-done.ps1`：Windows 系统托盘气泡通知，由 Stop hook 自动调用
- Stop hook 已在 `~/.claude/settings.json` 配置，无需额外设置

## 平台说明

Stop hook 仅在 Windows 有效（依赖 `System.Windows.Forms`）。`PushNotification` 工具跨平台可用。
