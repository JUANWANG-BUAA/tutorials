# 1.3 习题集

三组分层：A 组概念判断（口答即可）、B 组诊断推理（写出步骤）、C 组动手实验（在虚拟机里跑）。**全部附解答**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；
2. 卡住了，回到对应小节的「即时自测」重读，不要直接看答案；
3. 做完再对照解答，重点看自己卡在哪一步；
4. 做错的题记一个记号，三天后只重做记号题。

## A 组 · 概念判断

::: ex A1 · 寄存器与 ABI

x86-64 的参数/返回值/callee-saved 寄存器各是哪些？`%rsp`/`%rbp` 各做什么？

::: sol 解答

参数：`rdi/rsi/rdx/rcx/r8/r9`；返回：`rax`；callee-saved：`rbx/rbp/r12–r15`；caller-saved：其余。`rsp` 栈指针，`rbp` 帧指针（可选）。调用前栈 16 字节对齐；`rax` 还用于可变参数个数。

:::
:::

::: ex A2 · 寻址模式

`(%rdi)`、`8(%rsp)`、`(%rax,%rcx,4)` 各是什么地址？`lea` 与 `mov` 差在哪？

::: sol 解答

`(%rdi)` = `[rdi]`；`8(%rsp)` = `[rsp+8]`；`(%rax,%rcx,4)` = `[rax + rcx*4]`。通用形式 `disp(base,index,scale)`。`lea` 只算地址（不访存），`mov` 从地址读/写；`lea` 常用来做算术。

:::
:::

::: ex A3 · 传送与算术

`movb/w/l/q`、`movz`/`movs` 各是什么？`add/sub/imul/div` 改哪些 flags？

::: sol 解答

`movb/w/l/q` 按 1/2/4/8 字节传送；`movz` 零扩展、`movs` 符号扩展。`add/sub/imul` 改 ZF/SF/OF/CF；`div/idiv` 用 `rax/rdx`，不按普通 flags 语义。`cmp`/`test` 只改 flags，不写结果。

:::
:::

::: ex A4 · 条件码与跳转

ZF/SF/OF/CF 各是什么？`je/jne/jl/jle/jg/jge` 看哪些 flag？`setl` 做什么？

::: sol 解答

ZF 零、SF 符号、OF 溢出、CF 进位/借位。`je/jne` 看 ZF；`jl/jle/jg/jge` 看 SF/OF/ZF（有符号）；`jb/jbe/ja/jae` 看 CF/ZF（无符号）。`setl` 按条件写 1 字节 0/1。`cmp a,b` 算 `b-a` 设 flags。

:::
:::

::: ex A5 · 控制流

`if`/`switch`/`while`/`for` 在汇编里长什么样？跳转表什么时候用？

::: sol 解答

`if`：`cmp/test` + `jcc`；`switch`：比较链或跳转表；`while/for`：条件在循环头/尾 + `jcc` 回跳。跳转表适合密集/连续 case；稀疏 case 用比较链。

:::
:::

::: ex A6 · 栈帧与 call/ret

`call`/`ret` 各做什么？栈帧里有什么？红区是什么？

::: sol 解答

`call` 压返回地址并跳目标；`ret` 弹返回地址跳回。栈帧：返回地址、保存的 `rbp`/callee-saved、局部变量、对齐 padding。红区是 `rsp` 以下 128 字节，叶子函数可不调整 `rsp` 使用；信号可能破坏，不能跨调用。

:::
:::

::: ex A7 · 数组与结构体

数组元素地址怎样算？结构体字段偏移/padding 怎样定？联合体呢？

::: sol 解答

数组 `base + index*sizeof(elem)`；结构体按字段顺序/对齐插 padding，`offsetof` 给偏移，`sizeof` 含尾部 padding；联合体所有成员偏移 0，大小取最大成员+对齐。`pahole`/`offsetof` 验证。

:::
:::

::: ex A8 · ARM64

ARM64 的参数/返回寄存器是什么？`ldr/str`、`bl/ret`、NZCV 各是什么？

::: sol 解答

参数 `x0–x7`，返回 `x0`；`sp`/`pc`；`ldr/str` 访存，`bl` 调用、`ret` 返回；NZCV 是条件标志。`x8` 常用于 syscall 号；`x29`/`x30` 是 FP/LR。

:::
:::

## B 组 · 诊断推理

::: ex B1 · 参数传错

一个函数在 C 里调用正常，汇编里手调用却拿到错误参数。列出至少三种原因。

::: sol B1 核对

① 参数寄存器错（x86-64 第 4 个是 `rcx` 不是 `r10`，syscall 才用 `r10`）；② 栈对齐/第 7 个参数位置错；③ 结构体按隐藏指针/内存传；④ 返回值/`rax` 没设；⑤ ABI 声明不一致（`extern "C"`）。查 `gdb info registers`/`objdump`。

:::
:::

::: ex B2 · 栈崩

函数返回时崩溃/返回地址错。列出至少三种原因。

::: sol B2 核对

① 栈不平衡（push 没 pop、`sub rsp` 没恢复）；② 缓冲区溢出覆盖返回地址；③ callee-saved 没恢复；④ 对齐错导致 SSE/调用崩；⑤ 红区被信号/调用破坏。`gdb bt`/`x/20gx $rsp`/ASan 定位。

:::
:::

::: ex B3 · callee-saved

你手写的汇编函数破坏了 `rbx`，调用者行为异常。为什么？怎样修？

::: sol B3 核对

`rbx/rbp/r12–r15` 是 callee-saved：被调用者必须保存/恢复。修：`push %rbx`/`pop %rbx`（保持栈平衡），或用 caller-saved 寄存器。ABI 是契约，破坏会导致调用者变量/指针错。

:::
:::

::: ex B4 · 结构体布局

C 结构体传参到汇编，字段偏移和预期不同。为什么？怎样确认？

::: sol B4 核对

对齐/padding/ABI 导致偏移变化；大结构体可能按内存/隐藏指针传，不是寄存器逐字段。用 `offsetof`/`pahole` 看布局，`gdb p &s.field`，`objdump` 看访问偏移；跨语言用 `repr(C)`/`bindgen`。

:::
:::

::: ex B5 · ABI 不匹配

C 与 Rust/汇编混编，程序崩溃/结果错。列出至少三种 ABI 问题。

::: sol B5 核对

① 调用约定不一致（`extern "C"`/`sysv64`）；② 结构体布局不一致（Rust 默认重排，需 `repr(C)`）；③ 返回值/参数类型宽度/符号不一致；④ 栈对齐/可变参数；⑤ 名字修饰（C++）。用 `bindgen`/`static_assert`/ABI 文档核对。

:::
:::

::: ex B6 · `-O0` vs `-O2`

同一函数 `-O0` 汇编很长、`-O2` 很短。为什么？读哪个？

::: sol B6 核对

`-O0` 保留所有变量/栈帧/冗余 load/store，便于调试；`-O2` 内联/寄存器分配/消除冗余。读逻辑先 `-O0`，看优化/性能看 `-O2`；优化可能重排/合并，需对照源码/`-S`。

:::
:::

## C 组 · 动手实验

::: ex C1 · objdump/gdb 读函数

对一个小函数编译 `-O0 -g`，用 `objdump -d`/`gdb` 单步，标出序言/参数/返回/收尾。

::: sol C1 核对

```bash
gcc -O0 -g -fno-omit-frame-pointer demo.c -o demo
objdump -d demo | sed -n '/<add>:/,+25p'
gdb ./demo
(gdb) break add
(gdb) run
(gdb) info registers rdi rsi rsp rbp
(gdb) x/8gx $rsp
(gdb) stepi
```

找 `push %rbp`/`mov %rsp,%rbp`/`sub`/`mov %edi,...`/`add`/`pop %rbp`/`ret`；`gdb` 看参数/栈帧。验收：能说出每个寄存器的作用。

:::
:::

::: ex C2 · 手写汇编函数

写一个 x86-64 汇编函数 `long add(long a,long b)` 返回 `a+b`，从 C 调用；用 `objdump` 验证。

::: sol C2 核对

```asm
    .text
    .globl add
    .type add, @function
add:
    lea (%rdi,%rsi), %rax
    ret
```

编译：`cc -c add.s -o add.o`，C 里 `extern long add(long,long);` 链接。`objdump -d add.o` 看 `lea (%rdi,%rsi),%rax; ret`。验收：C 调用结果正确；`rdi/rsi` 是参数、`rax` 返回。

:::
:::

::: ex C3 · 栈帧观察

用 `gdb` 看递归函数每层 `rsp`/`rbp`/返回地址，画栈帧。

::: sol C3 核对

```bash
gcc -O0 -g -fno-omit-frame-pointer rec.c -o rec
gdb ./rec
(gdb) break rec
(gdb) run
(gdb) bt
(gdb) info frame
(gdb) x/4gx $rsp
```

每层 `rbp` 指向 saved rbp/返回地址；`bt` 列调用链；`x/4gx $rbp` 看 saved rbp/ret。验收：能画出栈帧链与返回地址。

:::
:::

::: ex C4 · ARM64 对照

用交叉编译器编同一函数，`objdump -d` 对比 x86-64/ARM64 的参数/返回/指令。

::: sol C4 核对

```bash
aarch64-linux-gnu-gcc -O0 -c add.c -o add-arm64.o
aarch64-linux-gnu-objdump -d add-arm64.o
objdump -d add.o
```

ARM64 用 `x0/x1` 参数、`x0` 返回、`add x0,x0,x1`/`ret`；x86-64 用 `rdi/rsi`、`rax`、`lea/add`。验收：能列出 ABI/指令差异。

:::
:::

::: ex C5 · 机器码/重定位

用 `objdump -d`/`readelf -r` 看一条 `call` 的机器码与重定位；解释 `e8`/`rel32`。

::: sol C5 核对

```bash
gcc -c call.c -o call.o
objdump -d call.o
readelf -r call.o
```

`call` 常见 `e8 <rel32>`（相对下一条指令的 32 位偏移）；未链接时重定位 `R_X86_64_PLT32`/`PC32` 填目标。`objdump -dr` 同时显示重定位。验收：能说出机器码长度与偏移。

:::
:::
