# 项目总览与验收路线

<div class="chapter-index">
<div><span class="ci-label">本章回答</span><p>两个项目分别交付什么？怎样从空目录开始，按 Stage 验收？哪些测试必须真正跑过？哪些边界必须主动声明？项目代码与正文是什么关系？</p></div>
<div><span class="ci-label">读完你会</span><p>能按 Stage 拆解两个项目；知道每个 Stage 的输入、产出与验收命令；能区分「演示能跑」与「工程可交付」；能读懂项目里的证据链。</p></div>
</div>

## 0.1 两个项目，两种证据

| 项目 | 目录 | 核心问题 | 最终证据 |
|:--|:--|:--|:--|
| 迷你 C/表达式编译器 | `projects/minic/` | 源程序能否经过真实的 token/AST/TAC/SSA/优化/代码生成，语义不变？ | 解释器与编译执行对拍；SSA/优化输出；`objdump` 栈对齐；边界测试 |
| agent 代码验证器 | `projects/validator/` | agent 生成的代码/补丁能否在合并或执行前被策略、编译、行为三层门禁裁决？ | accept/reject/quarantine 三类裁决 JSON；静态规则测试；受限执行证据 |

两个项目共享一个原则：**结论必须能由第三方用一条命令复现**。不存在「我本地跑过了」但不给命令的验收。

## 0.2 项目一的 Stage

| Stage | 输入 | 产出 | 验收命令 |
|:--|:--|:--|:--|
| S1 | `.mc` 源文件 | token 流、带 span 的 AST | `--emit=tokens` / `--emit=ast` |
| S2 | AST | 语义检查通过/诊断 | 未声明、重复声明、类型错误用例 |
| S3 | AST | TAC + CFG + IR 解释器 | `--emit=ir --run` |
| S4 | TAC | SSA + 常量传播 + DCE | `--emit=ssa --opt` |
| S5 | TAC | x86-64 SysV 汇编 | `--emit=asm --target=darwin` |
| S6 | 汇编 + 源程序 | 编译执行 vs 解释器对拍 | `bash run_tests.sh` |
| S7 | 全链路 | 文档、限制、调试指南 | 本章出口检查 |

迷你语言支持：`int`、变量、赋值、算术/比较/逻辑表达式、`if/else`、`while`、函数（≤6 个 int 参数）、`return`、`print(expr);`、块作用域、注释。**不支持**数组、结构体、指针、浮点、字符串字面量、可变参数、异常、多文件链接。限制不是缺陷，是接口。

## 0.3 项目二的 Stage

| Stage | 输入 | 产出 | 验收命令 |
|:--|:--|:--|:--|
| V1 | 代码 + 策略 | 静态 findings | `--static-only` |
| V2 | 代码 | 编译/语法门禁结果 | `--compile` |
| V3 | 代码 + 测试用例 | 受限执行输出与差分 | `--run` |
| V4 | findings + 证据 | 裁决 JSON（accept/reject/quarantine） | `--json` |
| V5 | 对抗样例 | 已知绕过与边界清单 | `bash run_tests.sh` |

验证器支持 Python（AST 级）、C（token/编译级）、Rust（编译级，可选）。它明确**不是**安全沙箱：真正的隔离要用虚拟机、容器 + seccomp/landlock 或 Wasm 运行时；项目二只做「减少风险 + 留下证据」。

## 0.4 共同工程规则

- 每个 Stage 先写失败测试，再写实现；不允许用 print 调试代替断言。
- 每个公开函数有输入/输出/失败模式；错误信息带文件名与行列（能带则带）。
- 所有子进程调用有超时、输出上限、环境清理；所有临时目录在 `finally` 清理。
- 测试不依赖网络、不依赖当前用户主目录、不依赖系统语言。
- 报告中贴真实输出；如果某项未实测，写「未实测 + 原因」，不伪称通过。

::: method 验收顺序
1. 在干净 shell 里 `cd compilers`。
2. 跑 `bash projects/minic/run_tests.sh`。
3. 跑 `bash projects/validator/run_tests.sh`。
4. 手工执行本章给出的两个 CLI 例子，核对 JSON/汇编/输出。
5. 故意改坏一行，确认测试变红；再恢复。
:::

## 0.5 交付边界

两个项目是教学级实现：优先正确、可读、可测，不追求工业级优化与吞吐。你可以在其上继续扩展，但必须保持三条：

1. 语义变化必须有测试与解释；
2. 安全边界必须声明，不把「资源限制」说成「隔离」；
3. 所有「已验证」都能追溯到命令与输出。

> **下一站**：[第 13 章](../part4/ch13.md)。先跑项目一，再读实现拆解。
