# 实验环境与工具链

## 1. 两个环境

本书的实验在两类机器上完成，能力不同，标注也不同：

| 环境 | 用途 | 能跑什么 | 不能跑什么 |
|:--|:--|:--|:--|
| Ubuntu 24.04 LTS · Linux 6.8 | 书中的目标环境 | 全部实验，包括 seccomp/landlock/userns/cgroup | — |
| macOS 14+ · Apple Silicon | 写作与快速验证 | Python/Bash 实验、trace、评估、协议 | seccomp/landlock/cgroup/netns；部分 rlimit 行为不同 |

正文里凡是 Linux 专属的命令或 C 代码，都会标「Linux 6.8 · Ubuntu 24.04」。在 macOS 上跑不了不是失败，但不能假装跑过；第 4 章的 `verify-linux.sh` 会明确打印跳过原因。

## 2. 软件版本

| 工具 | 版本 | 用途 |
|:--|:--|:--|
| Python | 3.11+ | 所有 Python 实验；只用标准库 |
| Bash | 5.2（Linux）/ 3.2（macOS 自带） | 脚本实验；差异处标注 |
| C 编译器 | GCC 13 或 Clang 17 | 第 4 章 C 加固程序 |
| mdBook | 0.5.x | 构建本书 |
| mdbook-katex | 0.10.x | 构建期渲染公式 |
| markdown-it-py | 3.x | `mathbook` 预处理器渲染盒子内 Markdown |
| jq | 1.7+ | 观察 JSONL trace |
| strace / perf | 发行版自带 | Linux 观测命令（可选） |

检查环境：

```bash
python3 --version
bash --version | head -1
cc --version | head -1
mdbook --version
mdbook-katex --version
python3 -c 'import markdown_it; print(markdown_it.__version__)'
```

预期输出里 Python 至少 3.11，mdBook 至少 0.4。版本低不一定会失败，但 `book.toml` 的预处理器协议在 0.4/0.5 之间有差异；遇到构建错误先对齐版本。

## 3. 获取与构建

```bash
git clone https://github.com/JUANWANG-BUAA/tutorials.git
cd tutorials/agent-systems

# 仅本书预览
mdbook serve --open

# 结构自检（推荐每次改完都跑）
python3 tools/check_book.py --verbose
python3 tools/check_chapter.py part1/ch01.md

# 覆盖矩阵：缺口必须为 0
python3 tools/build_coverage.py

# 生成 SVG 机制图（已提交生成物，改脚本后才需要重跑）
python3 tools/build_figures.py
```

`mdbook serve` 不包含根目录的搜索索引与术语数据；要得到与线上一致的站点，在仓库根运行 `./build.sh`。本书的搜索索引配置在根 `tools/build_search_js.mjs` 的 `BOOKS` 表里。

## 4. 跑实验

统一入口：

```bash
bash experiments/run_all.sh
```

它按章节顺序运行本机可跑的实验，最后打印汇总。只跑一章：

```bash
python3 experiments/ch01/mini_loop.py --mode good
python3 -m unittest discover -s experiments/ch01 -v
```

约定：

- 所有 Python 实验离线、无第三方依赖；不读网络、不需要 API key。
- 需要真模型的实验（第 9 章的可选部分）会明确标注「需要 API key」，并提供确定性替身。
- 实验输出写到临时目录或 `experiments/.out/`，不污染仓库；`.out/` 已在 `.gitignore` 中。
- Linux 专属实验：`bash experiments/ch04/verify-linux.sh`；macOS 上返回 0 但打印 `SKIP`，不冒充通过。

## 5. 一个最小验证

在开始读第 1 章之前，先确认三件事：

```bash
# 1) Python 能跑，且不依赖第三方包
python3 - <<'PY'
import sys, json, resource, subprocess
print(sys.version.split()[0], "ok")
PY

# 2) 能创建子进程并读到退出码
python3 - <<'PY'
import subprocess
p = subprocess.run(["sh", "-c", "exit 42"])
print("returncode =", p.returncode)
PY

# 3) jq 能解析一行 JSON
printf '%s\n' '{"step":1,"ok":true}' | jq -r '.step'
```

预期：Python 版本 ≥ 3.11；`returncode = 42`；`jq` 输出 `1`。第三条失败就先装 `jq`，第 1 章的 trace 观察会用到它。

## 6. 目录结构

```text
agent-systems/
  book.toml              构建配置
  src/                   正文（SUMMARY.md 是唯一导航）
    part1/ … part4/      14 章
    projects/            项目总览
    appendix/            覆盖矩阵、勘误、参考
    assets/figures/      SVG 机制图片段
    assets/covers/       书封
  experiments/           每章一个可运行实验
  projects/              两个项目的完整实现
  tools/                 mathbook、check_book、build_coverage、build_figures
  theme/                 本书样式（shared/ 的符号链接 + 本书覆盖）
  写作规范/              写作契约、章节大纲、母本目录
```

`src/` 里不放大文件；图是内联 SVG 片段，代码是可运行的短片段，完整实现放在 `experiments/` 与 `projects/`。

## 7. 常见环境问题

| 症状 | 原因 | 处理 |
|:--|:--|:--|
| `mathbook: 需要 markdown-it-py` | 缺依赖 | `pip3 install -r requirements.txt` |
| `mdbook-katex: command not found` | 未安装预处理器 | `cargo install mdbook-katex` |
| `check_book.py` 报「行数不在 1000–1400」 | 章节未写完或删多了 | 补实质内容，不要用空行凑 |
| `SVG 解析失败` | 生成脚本输出的 XML 不合法 | 重跑 `tools/build_figures.py`，检查 `<` 转义 |
| macOS 上 `RLIMIT_AS` 行为异常 | Darwin 对地址空间限制的实现不同 | 用 `RLIMIT_CPU/FSIZE/NOFILE`，或到 Linux 上跑 |
| `TZ` 设了空串却显示 UTC | 这是正确行为，不是 bug | 见 10.7 |
