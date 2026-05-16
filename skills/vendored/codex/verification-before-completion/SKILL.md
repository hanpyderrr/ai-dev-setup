---
name: verification-before-completion
description: 在声明完成、修复、通过、可提交之前使用。要求先运行新鲜验证命令并读取输出。
---

# 完成前验证

## 铁律

没有新鲜验证证据，不声称完成、通过或修复。

## 步骤

1. 识别什么命令能证明当前结论。
2. 运行完整命令。
3. 读取输出和退出码。
4. 如果失败，报告真实状态和下一步。
5. 如果通过，带着证据说明。

## 常见映射

- Python API: `python -m py_compile`, unit tests, HTTP smoke tests。
- C/C++ parser: `cmake`, `cmake --build`, test executable。
- Qt: `qmake`, `make`, target runtime smoke test。
- Frontend: build, browser smoke test。
- Git: `git status`, `git diff --cached`, remote sync check。

