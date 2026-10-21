# 实验环境与工具链

<div class="chapter-index">
<div><span class="ci-label">本章回答</span><p>跑完这本书需要装什么？macOS 与 Linux 的差异在哪里？没有 x86-64 机器怎样验证后端？哪些实验需要 Linux 专属能力？</p></div>
<div><span class="ci-label">读完你会</span><p>能搭出一套最小可复现环境；知道每个工具负责哪类证据；能用 `verify_all.py` 一次跑完结构、实验、构建与链接检查。</p></div>
</div>

## 0.1 最小环境

| 工具 | 版本 | 用途 | 检查命令 |
|:--|:--|:--|:--|
| Python | 3.11+ | 项目与实验 | `python3 --version` |
| C 编译器 | clang 15+ / gcc 12+ | 编译 C、汇编、sanitizer | `cc --version` |
| LLVM | 17+ | `llvm-mc` / `llvm-objdump` / `llvm-readelf` | `llvm-mc --version` |
| Rust | 1.75+ | 类型/UB 示例（可选） | `rustc --version` |
| mdBook | 0.5.x | 构建本书 | `mdbook --version` |
| mdbook-katex | 0.10+ | 公式预渲染 | `mdbook-katex --version` |
| markdown-it-py | 4.x | 语义盒预处理器 | `python3 -c 'import markdown_it'` |

macOS 自带 clang 与 `llvm-objdump`，但未必有 `llvm-mc`。Homebrew 的 `llvm` 通常更完整：

```bash
brew install llvm mdbook
cargo install mdbook-katex
pip3 install markdown-it-py
export PATH="$(brew --prefix llvm)/bin:$PATH"
```

Linux（Debian/Ubuntu）：

```bash
sudo apt install clang llvm python3-pip
cargo install mdbook mdbook-katex
pip3 install markdown-it-py
```

## 0.2 目录与命令

```text
compilers/
  src/                 正文
  experiments/ch01..12/每章实验
  projects/minic/      项目一：迷你 C 编译器
  projects/validator/  项目二：agent 代码验证器
  tools/               检查器、覆盖矩阵、预处理器
  tests/               跨项目测试入口（若有）
```

常用命令：

```bash
# 构建
mdbook build .

# 结构检查
python3 tools/check_book.py --verbose

# 覆盖矩阵
python3 tools/build_coverage.py

# 全部实验（本机可跑）
bash experiments/run_all.sh

# 两个项目
bash projects/minic/run_tests.sh
bash projects/validator/run_tests.sh

# 一键门禁
python3 tools/verify_all.py
```

## 0.3 平台差异

| 能力 | macOS | Linux | 本书处理 |
|:--|:--|:--|:--|
| x86-64 执行 | Apple Silicon 不原生；Rosetta 可选 | 原生 | 代码生成用交叉汇编/objdump 验证，运行用目标架构或 IR 解释器 |
| ELF 工具 | 默认没有 `readelf`；LLVM 有 `llvm-readelf` | binutils/LLVM | 用 `llvm-readelf` |
| seccomp | 无 | 有 | 第 12 章区分「资源限制」与「真正隔离」 |
| `sandbox-exec` | 有但废弃/受限 | 无 | 不作为教学安全边界 |
| `resource` 模块 | 支持 `RLIMIT_*` | 支持 | 第 12/14 章用于崩溃遏制，不宣称安全隔离 |

::: note 没有 x86-64 机器怎么办
第 7–8 章的代码生成实验用两条证据：一是 `llvm-mc`/`clang -target x86_64` 汇编并通过 `llvm-objdump` 反汇编；二是项目一用 TAC 解释器执行同一程序。二者结果一致，说明语义与代码生成至少在一个测试集上对齐。真正的硬件执行是可选的加分项，不是理解前提。
:::

## 0.4 复现性约定

- 所有随机实验固定 seed，并在输出中打印 seed。
- 所有性能结论标注机器、编译器版本、优化级别与重复次数。
- 所有 sanitizer 结论标注 `-fsanitize=` 参数、优化级别与是否 `-fno-omit-frame-pointer`。
- 所有 fuzz 结论标注运行时长、种子、覆盖率和是否发现新路径；没找到 bug 不等于没有 bug。
- 所有外部命令的退出码都要检查；`set -euo pipefail` 是实验脚本的默认。

## 0.5 故障排查

| 症状 | 可能原因 | 处理 |
|:--|:--|:--|
| `mdbook build` 找不到 `tools/mathbook.py` | 不在 `compilers/` 目录 | `cd compilers` 再构建 |
| 公式显示成源码 | `mdbook-katex` 未安装或版本不兼容 | 检查 `book.toml` 的 preprocessor |
| `llvm-mc: command not found` | Homebrew LLVM 未加入 PATH | 见 0.1 |
| C 代码在 macOS 上编译失败 | 用了 Linux 专属头/系统调用 | 看该节标注，改用容器/交叉编译 |
| 实验超时 | 沙箱/资源限制太紧或程序死循环 | 先看 `timeout` 与 `RLIMIT_CPU` |
| 测试因符号名失败 | macOS 需要 `_main` 前缀 | 项目一用 `--target darwin` |

> **下一站**：[第 1 章](part1/ch01.md)。先建立全景，再进入词法。
