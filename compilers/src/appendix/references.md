# 附录 C · 术语、工具与延伸阅读

<div class="chapter-index">
<div><span class="ci-label">本章回答</span><p>书中的缩写、工具与关键概念去哪里查？哪些规范是结论的最终依据？延伸阅读怎样避免变成「书单堆砌」？</p></div>
<div><span class="ci-label">读完你会</span><p>能快速定位术语、工具版本与规范条目；知道每条结论的证据来源；能按主题继续深入。</p></div>
</div>

## C.1 术语表

| 术语 | 英文 | 一句话 |
|:--|:--|:--|
| 词法单元 | token | 字符流被切分后的最小语法单位 |
| 抽象语法树 | AST | 去掉分隔符、保留结构与位置的树 |
| 三地址码 | three-address code (TAC) | 每条指令至多一个运算、三个地址 |
| 控制流图 | control-flow graph (CFG) | 基本块 + 跳转边 |
| 静态单赋值 | static single assignment (SSA) | 每个变量只定义一次，合流用 phi |
| 支配 | dominance | 从入口到某点必经的关系 |
| 数据流分析 | data-flow analysis | 在格上迭代传递函数求不动点 |
| 活跃变量 | liveness | 某点之后还会被使用的变量 |
| 寄存器分配 | register allocation | 把虚拟寄存器映射到物理寄存器或栈 |
| 指令选择 | instruction selection | 用目标指令覆盖 IR 模式 |
| ABI | application binary interface | 调用、布局、符号的二进制合同 |
| 未定义行为 | undefined behavior (UB) | 标准不规定任何语义的程序行为 |
| 插桩 | instrumentation | 在代码中插入检查/观测代码 |
| 差分测试 | differential testing | 比较多个实现/配置的输出 |
| 属性测试 | property-based testing | 生成输入并检查不变量 |
| 最弱前置条件 | weakest precondition (WP) | 使后置条件成立的最弱前置断言 |
| 即时编译 | just-in-time (JIT) | 运行时生成并执行代码 |

## C.2 工具与证据

| 工具 | 用途 | 本书中的证据 |
|:--|:--|:--|
| `clang` / `gcc` | 编译 C、汇编、sanitizer | 代码可编译、运行输出 |
| `llvm-mc` | 汇编/反汇编单条指令 | 位宽、寻址、指令合法性 |
| `llvm-objdump` | 反汇编目标文件 | 栈帧、调用、寄存器使用 |
| `llvm-readelf` | ELF 节/符号/重定位 | 链接产物（只交叉引用） |
| `nm` / `objdump` | 符号与反汇编 | 编译器输出符号 |
| `python3` | 项目与实验 | 可运行测试 |
| `mdbook` / `mdbook-katex` | 构建 | 页面与公式 |
| `sanitizer` | ASan/UBSan/TSan/MSan | 运行时检测 |
| `clang-tidy` / `scan-build` | 静态分析 | 误报/漏报边界 |
| `AFL++` / `libFuzzer` | 覆盖率引导 fuzz | 第 10 章的方法 |
| Z3 / SMT-LIB | 约束求解 | 第 11 章的可选工具 |
| Wasm runtime | 沙箱执行 | 第 12 章的边界 |

## C.3 规范与文档（结论的最终依据）

- C17：ISO/IEC 9899:2018，尤其 6.5（表达式）、6.2.4（存储期）、3.4.3（未定义行为）。
- C++：ISO/IEC 14882:2020，尤其 6.9（内存模型）、[expr] 的求值顺序。
- Rust Reference：类型、作用域、UB、ABI、链接属性。
- Rustc Dev Guide：查询系统、HIR/MIR、借用检查、单例化、代码生成。
- System V ABI：AMD64 与 AArch64 的调用约定（本书只引用，不重写）。
- LLVM Language Reference：IR 语义、phi、undef/poison。
- WebAssembly Core Specification：验证、执行、内存模型。

## C.4 延伸阅读（按主题）

| 主题 | 读什么 | 为什么 |
|:--|:--|:--|
| 编译器实现 | 自制编译器 | 小语言全链路，适合对照项目一 |
| 优化与数据流 | 龙书的数据流章节 + LLVM 文档 | 框架与工业 IR 的对照 |
| 类型系统 | TAPL（可选） | 推导与可靠性 |
| C 语义 | C 语言现代方法 + 标准 | 声明、转换、UB |
| Rust 编译 | Rust Reference + Rustc Dev Guide | 类型/借用/MIR |
| C++ 抽象 | C++ 程序设计语言 + Effective Modern C++ | 实例化、内联、零开销 |
| 程序分析 | 抽象解释、符号执行综述 | 第 9/11 章的边界 |
| 验证 | CompCert 论文与手册 | 翻译验证的边界 |
| 沙箱 | seccomp/landlock 文档、Wasm spec | 第 12/14 章的信任边界 |

## C.5 版本基线

| 对象 | 基线 |
|:--|:--|
| Python | 3.11+ |
| C | C17，clang 15+/gcc 12+ |
| Rust | 2021 edition，1.75+ |
| LLVM | 17+（核查机 22.1.8） |
| mdBook | 0.5.4 |
| mdbook-katex | 0.10+ |
| 操作系统 | macOS 14+/Ubuntu 24.04 |

版本会变。正文把版本写在句子里；读到时先确认它是否仍适用于你的环境。

> 本书不复制母本代码/图/原文。所有例子、图与项目实现由本仓库维护；外部规范与工具归各自权利人所有。
