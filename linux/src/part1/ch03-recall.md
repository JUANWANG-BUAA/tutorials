# 1.3 闭卷回忆卡

这页不是摘要，而是一组**检索练习**。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。

建议在学完当天、隔天、第 3 天、第 7 天各做一次。每次只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 第一遍：寄存器与指令

### D1 · 寄存器与 ABI

x86-64 的参数/返回值/callee-saved 寄存器各是哪些？`%rsp`/`%rbp` 各做什么？

::: sol D1 核对

参数：`rdi/rsi/rdx/rcx/r8/r9`；返回：`rax`；callee-saved：`rbx/rbp/r12–r15`；caller-saved：其余。`rsp` 栈指针，`rbp` 帧指针（可选）。调用前栈 16 字节对齐；`rax` 还用于可变参数个数。
:::

### D2 · 寻址模式

`(%rdi)`、`8(%rsp)`、`(%rax,%rcx,4)` 各是什么地址？`lea` 与 `mov` 差在哪？

::: sol D2 核对

`(%rdi)` = `[rdi]`；`8(%rsp)` = `[rsp+8]`；`(%rax,%rcx,4)` = `[rax + rcx*4]`。通用形式 `disp(base,index,scale)`。`lea` 只算地址（不访存），`mov` 从地址读/写；`lea` 常用来做算术。
:::

### D3 · 传送与算术

`movb/w/l/q`、`movz`/`movs` 各是什么？`add/sub/imul/div` 改哪些 flags？

::: sol D3 核对

`movb/w/l/q` 按 1/2/4/8 字节传送；`movz` 零扩展、`movs` 符号扩展。`add/sub/imul` 改 ZF/SF/OF/CF；`div/idiv` 用 `rax/rdx`，不按普通 flags 语义。`cmp`/`test` 只改 flags，不写结果。
:::

### D4 · 条件码与跳转

ZF/SF/OF/CF 各是什么？`je/jne/jl/jle/jg/jge` 看哪些 flag？`setl` 做什么？

::: sol D4 核对

ZF 零、SF 符号、OF 溢出、CF 进位/借位。`je/jne` 看 ZF；`jl/jle/jg/jge` 看 SF/OF/ZF（有符号）；`jb/jbe/ja/jae` 看 CF/ZF（无符号）。`setl` 按条件写 1 字节 0/1。`cmp a,b` 算 `b-a` 设 flags。
:::

### D5 · 控制流

`if`/`switch`/`while`/`for` 在汇编里长什么样？跳转表什么时候用？

::: sol D5 核对

`if`：`cmp/test` + `jcc`；`switch`：比较链或跳转表（`jmp *table(,%rax,8)`）；`while/for`：条件在循环头/尾 + `jcc` 回跳。跳转表适合密集/连续 case；稀疏 case 用比较链。
:::

## B. 第二遍：栈、布局与多架构

### D6 · 栈帧与 call/ret

`call`/`ret` 各做什么？栈帧里有什么？红区是什么？

::: sol D6 核对

`call` 压返回地址并跳目标；`ret` 弹返回地址跳回。栈帧：返回地址、保存的 `rbp`/callee-saved、局部变量、对齐 padding。红区是 `rsp` 以下 128 字节，叶子函数可不调整 `rsp` 使用；信号可能破坏，不能跨调用。
:::

### D7 · 数组与结构体

数组元素地址怎样算？结构体字段偏移/padding 怎样定？联合体呢？

::: sol D7 核对

数组 `base + index*sizeof(elem)`；结构体按字段顺序/对齐插 padding，`offsetof` 给偏移，`sizeof` 含尾部 padding；联合体所有成员偏移 0，大小取最大成员+对齐。`pahole`/`offsetof` 验证。
:::

### D8 · objdump 与 gdb

`objdump -d` 看什么？`gdb` 的 `stepi`/`x/i`/`info registers`/`x/20gx $rsp` 各做什么？

::: sol D8 核对

`objdump -d` 反汇编 `.text`，看地址/机器码/汇编；`gdb stepi` 单步一条指令，`x/i $pc` 看当前指令，`info registers` 看寄存器，`x/20gx $rsp` 看栈，`bt` 看调用链。`disassemble /m` 混合源码。
:::

### D9 · ARM64 对照

ARM64 的参数/返回寄存器是什么？`ldr/str`、`bl/ret`、NZCV 各是什么？

::: sol D9 核对

参数 `x0–x7`，返回 `x0`；`sp`/`pc`；`ldr/str` 访存，`bl` 调用、`ret` 返回；NZCV 是条件标志（Negative/Zero/Carry/Overflow）。`x8` 常用于 syscall 号；`x29`/`x30` 是 FP/LR。
:::

### D10 · 机器码

x86-64 指令怎样编码？REX/ModRM/SIB/disp/imm 各是什么？为什么变长？

::: sol D10 核对

指令 = 前缀 + REX + opcode + ModRM + SIB + disp + imm；REX 扩展寄存器/64 位，ModRM 指定寄存器/内存，SIB 支持 `base+index*scale`，disp/imm 是偏移/立即数。变长为了代码密度/兼容；解析要按字节走。
:::

### D11 · 参数、对齐与红区

超过 6 个参数怎样传？栈对齐要求？红区多大、什么时候不能用？

::: sol D11 核对

前 6 个整数/指针参数用寄存器，其余从右到左压栈；`call` 前 `rsp` 16 字节对齐（`call` 压 8 字节，入口 `rsp%16=8`）。红区 128 字节；信号处理/调用其他函数时不能用红区。大结构体可能通过隐藏指针/内存传。
:::

### D12 · 汇编陷阱

任选四个陷阱，说出“现象 → 原因 → 修复”。

::: sol D12 核对

示例：① AT&T/Intel 操作数顺序反——看语法/反汇编；② `%`/`$` 混——寄存器/立即数；③ 破坏 callee-saved——push/pop；④ 栈不对齐——`sub $8`/`and`；⑤ `-O0` 汇编长——优化/看关键；⑥ ABI 不匹配——按 ABI 声明；⑦ 红区被信号破坏——调整 rsp；⑧ `lea` 当 `mov`——只算地址。
:::
