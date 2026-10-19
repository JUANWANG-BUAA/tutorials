# 符号、代码与实验约定

## 1. 记号

| 记号 | 含义 | 首次出现 |
|:--|:--|:--|
| $s_t$ | 第 $t$ 步开始时的状态 | 1.1 |
| $a_t$ | 第 $t$ 步的动作意图 | 1.1 |
| $o_t$ | 执行 $a_t$ 后的观察 | 1.1 |
| $\pi$ | 策略（模型或规则） | 1.1 |
| $E$ | 执行器（校验、授权、执行、观察） | 1.1 |
| $B$ | 预算向量 | 1.5 |
| $\tau$ | 轨迹 | 1.1 |
| $\Phi$ | 进展度量 | 1.5 |
| $T$ | 步数 | 1.2 |
| $k$ | 窗口长度 / 检索返回条数 | 1.5、6.3 |
| $\text{CI}_{95}$ | 95% 置信区间 | 9.4 |

数学里的 `<`、`>` 一律写成 `\lt`、`\gt`，避免 HTML 解析吞掉。字面美元符号写 `\$`。

## 2. 代码

### Python

- 版本 3.11+；实验只用标准库，不要求 `pip install`。
- 类型标注尽量完整；数据类用 `@dataclass`。
- 错误用返回值或异常都要有明确边界；实验里优先返回结构化结果，便于观察。
- 入口脚本带 `if __name__ == "__main__":`，支持 `--help`。
- 测试用 `unittest`，命令固定为 `python3 -m unittest discover -s experiments/chNN -v`。

### C

- C17 + POSIX；编译命令 `cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 -g`。
- Linux 专属代码标注「Linux 6.8 · Ubuntu 24.04」；macOS 上不能编译的，不假装能编译。
- 系统调用失败必须检查 `errno`，并打印可读原因。
- 不贴大段内核源码；只保留能说明路径的 5–25 行，并标注文件与函数。

### Bash

- 脚本首行 `#!/usr/bin/env bash`；建议 `set -euo pipefail`。
- 管道语义要写清：`pipefail` 取最右非零，`PIPESTATUS` 保留每段。
- 资源限制要写清软/硬：`ulimit -n` 改软限，`ulimit -Hn` 改硬限。
- 作业控制要写清作用域：`jobs` 只列当前 shell 的作业，子 shell 看不到父 shell 的作业。

### JSON / YAML

- JSON 不写注释；需要解释时在块后用表格。
- 字段名用 `snake_case`；协议字段（如 MCP 的 `inputSchema`）保持原样，不改成 snake_case。
- 时间统一 ISO 8601 UTC，例如 `2026-10-19T01:22:31Z`。

## 3. 语义盒

本书只用九种盒子：

| 类型 | 用途 |
|:--|:--|
| `def` | 定义、接口语义、状态结构 |
| `thm` | 可证明的保证或边界 |
| `ex` | 例题、走查、失败复盘 |
| `intuition` | 白话解释「为什么」 |
| `method` | 步骤、清单、排障顺序 |
| `errata` | 常见误解、版本差异、陷阱 |
| `note` | 延伸、工具、历史 |
| `proof` | 证明（可折叠） |
| `sol` | 自测答案（可折叠） |

盒子编号写在标题里，例如 `定义 3.1.1`；锚点在花括号里，例如 `{#def-agent-systems.1.3.1.1}`。跨章引用用 `[@def-agent-systems.1.3.1.1]`，构建期会解析成链接；写错锚点会构建失败，而不是静默失效。

## 4. 图

- 机制图优先 ASCII（`<pre class="layout">`）：可复制、可 diff、无外部依赖。
- 需要矢量图时用 `tools/build_figures.py` 生成到 `src/assets/figures/`，页面通过 mdBook 的 include 指令把片段引入（具体写法见任一含图章节的源文件，避免在说明页里触发真实文件引用）。

- 每张图有 `<title>`、`<desc>`、图注；图注以「读图：」开头，正文再给一句结论。
- SVG 的 `id` 以 `as-` 开头，全书唯一；不引用外部字体、图片或脚本。
- 动画只用于「过程」类机制（如循环）；开启「减少动态效果」时必须是静态可读的。

## 5. 实验目录

```text
experiments/
  ch01/  mini_loop.py  test_mini_loop.py  README.md
  ch02/  mcp_stdio_server.py  mcp_client.py  test_protocol.py
  ...
  ch14/
  run_all.sh           # 统一入口：跑所有本机可跑的实验
```

约定：

- 每个目录至少一个可执行入口、一个测试、一个 README。
- 正文引用格式：`python3 experiments/ch02/mcp_client.py --era 2026`。
- 不把大文件、模型权重、网络依赖放进仓库；实验必须离线可跑。
- Linux 专属实验提供 `verify-linux.sh`；macOS 上运行会打印跳过原因，不伪装成功。

## 6. 环境变量

| 变量 | 用途 | 缺省行为 |
|:--|:--|:--|
| `AGENT_BOOK_ROOT` | 实验定位仓库根 | 从脚本位置向上找 `book.toml` |
| `TZ` | 时间戳时区 | 空值/无法解释 → UTC（见 10.7） |
| `NO_COLOR` | 关闭彩色输出 | 有颜色 |
| `PYTHONHASHSEED` | 复现实验 | 随机 |

注意 `TZ` 的语义：空串不是「系统时区」，而是 UTC；`tzdata` 缺失时也是静默 UTC。第 10.7 节会用一个实验演示。

## 7. 版本写法

正文提到版本时，写在句子里，不写在脚注：

- 好：「在 Linux 6.8 上，Landlock ABI 4 支持 TCP bind/connect 限制。」
- 差：「Landlock 支持网络限制。」

接口字段同理：MCP 2026-07-28 的 `server/discover`、2025-11-25 的 `initialize`，都要带版本。读者需要知道结论的适用边界。
