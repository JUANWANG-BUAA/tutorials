# minic — a small C-subset compiler

minic 是第 13 章的配套项目：一个只依赖 Python 3.11+ 标准库的迷你 C 编译器。
它把源码一路降到 x86-64 SysV 汇编，并提供 TAC 解释器用于对拍。

## 快速开始

```bash
cd projects/minic
python3 minic.py examples/fib.mc --run
python3 minic.py examples/fib.mc --run-compiled
python3 minic.py examples/loop.mc --emit=ssa
python3 minic.py examples/loop.mc --emit=asm --target=linux
bash run_tests.sh
```

macOS（Apple Silicon）上执行 x86-64 需要 Rosetta 2；没有 Rosetta 时
`--run-compiled` 会报错，而 `--run`（IR 解释器）与 `--emit=asm` 仍然可用。
Linux 上 `--target=linux` 直接链接本机可执行文件。

## 目录

| 路径 | 内容 |
|:--|:--|
| `minic.py` | CLI 入口 |
| `miniclib/lexer.py` | 手写词法分析，行列号，行/块注释 |
| `miniclib/parser.py` | 递归下降 + Pratt 表达式解析 |
| `miniclib/nodes.py` | AST 节点与符号 |
| `miniclib/sema.py` | 函数表、作用域、符号解析、返回路径检查 |
| `miniclib/tac.py` | TAC、CFG、TAC 解释器 |
| `miniclib/ssa.py` | 支配树、支配边界、剪枝 phi、重命名、验证 |
| `miniclib/opt.py` | 常量传播、折叠、DCE |
| `miniclib/lower.py` | phi 消解（边块 + 并行复制） |
| `miniclib/codegen.py` | x86-64 SysV 栈式代码生成 |
| `miniclib/driver.py` | 管道、诊断、汇编/链接 |
| `examples/` | fib、循环、if/else、print、gcd |
| `tests/cases/` | 42 个用例，期望输出写在源码注释里 |
| `tests/run_tests.py` | 4 种执行模式 + 两个目标汇编检查 + 单元测试 |

## CLI

```text
python3 minic.py FILE [--emit=tokens|ast|ir|cfg|ssa|asm]
                       [--run | --run-compiled | --build --out PATH]
                       [--opt] [--target=darwin|linux] [--verbose] [--keep]
```

- `--run`：TAC 解释器（未开启 `--opt` 时执行直接 TAC，不经过 SSA）。
- `--run --opt`：解释优化后的 SSA 经 phi 消解得到的 TAC。
- `--run-compiled`：汇编、链接并执行生成的 x86-64 程序。
- `--build --out PATH`：生成可执行文件。
- 退出码：编译错误 1，运行期错误 1，内部错误 3；正常执行返回 `main` 的低 8 位。

## 语言子集

```text
program   ::= function+
function  ::= 'int' IDENT '(' params? ')' block
params    ::= 'int' IDENT (',' 'int' IDENT)*        // 至多 6 个
block     ::= '{' stmt* '}'
stmt      ::= 'int' IDENT ('=' expr)? ';'
            | IDENT '=' expr ';'
            | 'if' '(' expr ')' stmt ('else' stmt)?
            | 'while' '(' expr ')' stmt
            | 'return' expr ';'
            | 'print' '(' expr ')' ';'
            | block
            | expr ';'
expr      ::= INT | IDENT | IDENT '(' args? ')' | '(' expr ')'
            | ('-' | '!') expr
            | expr ('*'|'/'|'%') expr
            | expr ('+'|'-') expr
            | expr ('<'|'<='|'>'|'>=') expr
            | expr ('=='|'!=') expr
            | expr '&&' expr
            | expr '||' expr
```

优先级由 `nodes.BIN_PREC` 一张表决定，`&&`/`||` 短路求值，比较与逻辑
的结果是 0/1。所有变量与表达式是 32 位有符号整数；函数统一返回 int。

## 代码生成约定

- 每个 SSA 名字占一个 4 字节栈槽；后端是栈式机器，不做寄存器分配。
- prologue：`pushq %rbp; movq %rsp, %rbp; subq $16k, %rsp`。
  入口 `rsp % 16 == 8`，push 后为 0，`sub` 是 16 的倍数，因此 `call` 前
  `rsp % 16 == 0`。
- 32 位运算一律 `movl`；不会出现 `movq ..., %eax`。
- 参数按 SysV 存到 `%edi, %esi, %edx, %ecx, %r8d, %r9d`。
- `print` 调 `printf("%d\n", x)`；Darwin 符号加下划线，Linux 不加。
- phi 消解：分支边插入独立边块，复制分两阶段经临时槽完成，能处理循环。

## 测试

```bash
bash run_tests.sh
```

对每个非错误用例执行：

1. `--run`（直接 TAC 解释器）
2. `--run --opt`（优化后 SSA 解释器）
3. `--run-compiled`（未优化代码生成）
4. `--run-compiled --opt`（优化后代码生成）

并检查：每段汇编都能被 `clang -target x86_64-apple-darwin` 与
`clang -target x86_64-linux-gnu` 汇编；所有 `subq $N, %rsp` 的 N 是 16 的
倍数；没有 `movq` 写 32 位寄存器；`llvm-objdump` 中的栈帧大小同样对齐。
另有单元测试检查词法位置、优先级、phi 存在性、SSA 验证、优化效果、
phi 消解与诊断格式。

## 已知限制

明确不支持并在词法/语法/语义阶段报错，而不是静默错编：

| 特性 | 处理 | 原因 |
|:--|:--|:--|
| 数组、指针、字符串 | 词法/语法错误 | 需要类型系统、寻址与内存模型 |
| 结构体、联合、枚举 | 保留字报错 | 布局与聚合 ABI 超出子集 |
| 全局变量 | 语法错误 | 只做栈上局部变量与参数 |
| `for`/`do`/`break`/`continue`/`switch`/`goto` | 保留字报错 | 用 `while` 足以演示 CFG/SSA |
| 浮点、`char`、`short`/`long` | 保留字报错 | 单一 32 位 int 语义 |
| 预处理器、`#include` | 不支持 | 单文件编译单元 |
| 逗号表达式、赋值表达式、`++`/`--`、复合赋值 | 语法错误 | 赋值只作为语句 |
| 函数指针、可变参数、超过 6 个参数 | 语法/语义错误 | 调用约定只覆盖 6 个整型寄存器参数 |
| 递归深度/无限循环 | 解释器步数上限 2000 万 | 防止测试挂死 |

语义上与 C 的差异（有意为之，保证解释器与机器码可对拍）：

- 有符号溢出按二进制补码回绕；C 中是 UB。
- 局部变量声明时零初始化；C 中不确定。
- 除零在解释器中是运行期错误，机器码触发 `SIGFPE`；`INT_MIN / -1` 同理。
- 函数可以先用后定义（先收集签名）；C 需要原型。

## 证据

```bash
python3 minic.py examples/loop.mc --emit=ssa
python3 minic.py examples/loop.mc --run
python3 minic.py examples/loop.mc --run-compiled
python3 minic.py examples/loop.mc --emit=asm | sed -n '1,12p'
bash run_tests.sh
```

最后一条在本仓库的 macOS 27.0.1 / Apple clang 21.0.0 / LLVM 22.1.8 上输出：

```text
cases: 42  modes: 4  asm targets: 28
ALL TESTS PASSED (42 cases, 4 execution modes)
```
