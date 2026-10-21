# 编译器与程序分析 · 从词法到可验证执行

一本可运行的 mdBook 教程：不重写汇编/ABI/ELF 基础，只写编译器与程序分析这一层。14 章 + 2 个完整项目，每章 1000–1400 行，附实验、机制图、agent 生成代码出错案例与质量门禁。

- 4 篇 · 14 章 · 2 个项目
- 前端与 IR：词法/语法/AST、类型/作用域、TAC/CFG/SSA
- 优化与后端：数据流、循环/内联/常量传播、寄存器分配/指令选择、ABI 代码生成
- 正确性与执行：UB/sanitizer/静态分析、fuzzing/差分/属性测试、形式化验证入门、JIT/沙箱
- 项目一：Python 写的迷你 C 编译器（解释器 + SSA + x86-64 SysV 代码生成）
- 项目二：agent 代码验证器（静态规则 + 编译门禁 + 受限执行 + 裁决 JSON）

## 结构

```text
compilers/
  book.toml                 独立 mdBook 配置（mathbook + katex）
  src/
    SUMMARY.md              唯一导航
    index.md preface.md scope.md roadmap.md notation.md env.md
    part1/ch01–ch04.md      前端与 IR
    part2/ch05–ch08.md      优化与后端
    part3/ch09–ch12.md      正确性、验证与执行
    part4/ch13–ch14.md      两个项目
    projects/overview.md    项目总览与验收
    appendix/coverage.md    母本覆盖矩阵（生成物）
    appendix/errata.md      跨书回归与勘误
    appendix/references.md  术语、工具与延伸阅读
    assets/covers/          封面 SVG
  experiments/ch01–ch12/    每章可运行实验
  projects/minic/           项目一完整实现 + 测试
  projects/validator/       项目二完整实现 + 测试
  tools/                    check_book / build_coverage / verify_all / 预处理器
  theme/                    本书样式；共用层符号链接到 shared/theme
  写作规范/                 写作契约与章节大纲
  coverage.md               覆盖矩阵评审副本
  CHECK-compilers.md        独立核查与门禁报告
```

## 构建

```bash
cd compilers
mdbook build .
```

依赖：

```bash
pip3 install -r requirements.txt   # markdown-it-py
cargo install mdbook mdbook-katex  # 若未安装
```

本书通过符号链接复用 `shared/theme` 与根目录 `tools/` 的 KaTeX 包装器，保留本书预处理器。完整预览在仓库根运行 `bash build.sh serve`；`bash check.sh` 执行与 CI 相同的质量检查。单独的 `mdbook build` 不包含中文搜索、术语数据与共享资源后处理。

## 自检

```bash
cd compilers
python3 tools/check_book.py --verbose
python3 tools/build_coverage.py
bash experiments/run_all.sh
bash projects/minic/run_tests.sh
bash projects/validator/run_tests.sh
python3 tools/verify_all.py
```

门禁：

| 门禁 | 标准 |
|:--|:--|
| 构建 | `mdbook build` exit 0，0 条 KaTeX/渲染 WARN |
| 结构 | `check_book.py` 0 问题页、0 重复锚点/HTML id、0 断链/断锚点 |
| 覆盖 | 84 个母本单元，缺口 0 |
| 内链 | 构建后 `check_html.py` 0 错 |
| 章节 | 14/14 在 1000–1400 行，11 个 H2，8–15 条陷阱 |
| 代码 | 项目测试 + 实验真实运行；C 通过 `-Wall -Wextra -Werror` |

## 与另一本书的边界

| 主题 | 去哪里读 | 本书只写 |
|:--|:--|:--|
| 三套 ISA、调用约定、ELF/链接/重定位 | 《Linux 系统与内核》1.7、1.14–1.16 | 代码生成/ABI 合规/链接产物的验证 |
| 进程、虚拟内存、文件、socket | 同书第 2–4 篇 | 沙箱与 JIT 的信任边界 |
| C 语法/指针/数组 | 《C 语言现代方法》 | 类型、转换、UB 的编译器建模 |
| C++ 模板/移动/重载 | 《C++ 程序设计语言》《Effective Modern C++》 | 实例化、内联、零开销抽象的编译视角 |
| Rust 所有权/借用/生命周期 | Rust Reference | 类型检查器与 UB 接口 |

## 复现说明

- 基线：macOS 14+/Ubuntu 24.04、Python 3.11+、clang 15+、LLVM 17+、mdBook 0.5.4、mdbook-katex 0.10+。
- x86-64 代码生成在 Apple Silicon 上通过 `clang -target x86_64-apple-darwin -c` + `llvm-objdump` 验证；项目一在可链接平台执行编译产物，否则用 IR 解释器对拍，并在 CHECK 中标注。
- Linux 专属能力（seccomp/landlock、ELF 程序）只做交叉引用或交叉汇编，不伪称在 macOS 上执行。

## 勘误

发现错误请附：位置（文件 + 锚点）、环境、命令、真实输出、期望行为。格式见 [附录 B](src/appendix/errata.md)。

## 许可

教程正文、图与项目代码由本仓库维护；引用的规范、论文与工具归各自权利人所有。正文为重新组织的讲解与示例，不是母本摘录。
