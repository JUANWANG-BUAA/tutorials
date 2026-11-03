# 1.15 闭卷回忆卡

这一页是检索练习，不是摘要。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。16 张卡分三组：**A 组考调用、寄存器、指令、栈帧与参数（1.15.1–1.15.5）**，**B 组考 `_start`、系统调用与内联汇编（1.15.6–1.15.7）**，**C 组考工具取证与环境边界（1.15.8–1.15.11）**。建议学完当天、隔天、第 3 天、第 7 天各做一次，只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 调用、寄存器、指令与栈帧

::: method 回忆 1 · 三条调用指令与返回地址
`call`/`bl`/`jal` 各把返回地址放在哪？非叶函数各要保存什么？叶子函数为什么可以不碰栈？ARM64 的 `ret` 会弹栈吗？
::: sol 答案
x86-64 的 `call` 把返回地址压入栈顶，`ret` 弹出到 `rip`。ARM64 的 `bl` 把返回地址写入 `x30`（LR），`ret` 是 `br x30`，**不弹栈**。RISC-V 的 `jal`/`call` 把返回地址写入 `ra`（`x1`），`ret` 是伪指令 `jalr x0, 0(ra)`。非叶函数：x86-64 的返回地址已由 `call` 压栈，通常无需额外保存，但要用 `rbx` 等被调用者保存寄存器时仍要保存；ARM64 通常开头 `stp x29, x30, [sp, #-16]!`；RISC-V 通常 `addi sp,sp,-16; sd ra,8(sp)`。叶子函数不调用别人，LR/`ra` 不会被覆盖，也不需要栈帧，所以可以完全不碰栈。`stp x29,x30` 保存的是**当前函数的** FP 和 LR，不是「压返回地址」。
:::
:::

::: method 回忆 2 · 寄存器责任表
整数参数、浮点参数、返回值、被调用者保存、调用者保存、栈对齐、红区，三套 ABI 各是什么？`x30`、`v8`–`v15`、`gp`/`tp` 有什么特殊？
::: sol 答案
整数参数：`rdi,rsi,rdx,rcx,r8,r9` / `x0`–`x7` / `a0`–`a7`。浮点：`xmm0`–`xmm7` / `v0`–`v7` / `fa0`–`fa7`。返回值：`rax`（128 位 `rdx:rax`）/ `x0`（`x1:x0`）/ `a0`（`a1:a0`）。被调用者保存：`rbx,rbp,r12`–`r15` / `x19`–`x29` 与 `v8`–`v15` 低 64 位 / `s0`–`s11`。调用者保存：`rax,rcx,rdx,rsi,rdi,r8`–`r11` / `x0`–`x18` / `a0`–`a7` 与 `t0`–`t6`。栈对齐：x86-64 调用前 16 字节、入口 `rsp%16==8`；ARM64 公共接口 16 字节；RISC-V 16 字节。红区：x86-64 128 字节（叶子函数可用），ARM64/RISC-V 无。`x30` 是链接寄存器，不属于普通被调用者保存；ARM64 的 `v8`–`v15` 只保证低 64 位；RISC-V 的 `gp` 是全局指针、`tp` 是线程指针，不能当临时变量。
:::
:::

::: method 回忆 3 · 同一操作的三种写法
加载 8 字节、存 8 字节、加法、立即数加法、比较跳转、调用、返回、栈分配、取地址、系统调用，三套汇编各怎么写？
::: sol 答案
加载：`mov 8(%rdi),%rax` / `ldr x0,[x1,#8]` / `ld a0,8(a1)`。存储：`mov %rax,8(%rdi)` / `str x0,[x1,#8]` / `sd a0,8(a1)`。加法：`add %rsi,%rax` / `add x0,x0,x1` / `add a0,a0,a1`。立即数：`add $16,%rsp` / `add sp,sp,#16` / `addi sp,sp,16`。比较跳转：`cmp %rsi,%rdi; jg L` / `cmp x0,x1; b.gt L` / `bgt a0,a1,L`。调用：`call foo` / `bl foo` / `call foo`（`auipc`+`jalr`）。返回：`ret` / `ret` / `ret`。栈分配：`sub $32,%rsp` / `sub sp,sp,#32` / `addi sp,sp,-32`。取地址：`lea 8(%rdi),%rax` / `add x0,x1,#8` / `addi a0,a1,8`。系统调用：`syscall` / `svc #0` / `ecall`。注意 x86-64 是 AT&T「源在前」，ARM64/RISC-V 是「目标在左」。
:::
:::

::: method 回忆 4 · `framed` 的三张栈图
`framed` 的 x86-64、ARM64、RISC-V 序言/尾声各是什么？返回地址、保存的 FP/LR、保存的 `rbx`/`x19`/`s1`、局部变量各在栈的什么位置？x86 为什么 `sub $24`？
::: sol 答案
x86-64：`push %rbp; mov %rsp,%rbp; push %rbx; sub $24,%rsp`；局部变量在 `-32(%rbp)`；尾声 `add $24,%rsp; pop %rbx; pop %rbp; ret`。进入时 `rsp%16==8`，`push rbp` 后为 0，`push rbx` 后为 8，`sub 24` 后回到 0；24 不是 16 的倍数，但和前面 8 字节的 `push` 合起来保持对齐。ARM64：`stp x29,x30,[sp,#-32]!; mov x29,sp; str x19,[sp,#16]`；局部变量在 `[sp,#24]`；尾声 `ldr x19,[sp,#16]; ldp x29,x30,[sp],#32; ret`。RISC-V：`addi sp,sp,-32; sd ra,24(sp); sd s0,16(sp); sd s1,8(sp); addi s0,sp,32`；局部变量在 `-32(s0)`；尾声按相反顺序 `ld` 后 `addi sp,sp,32; ret`。三张图共同点：返回地址在 x86 是硬件压的、在 ARM64/RISC-V 是软件存的；被调用者保存区在更高地址；局部变量夹在 `sp` 与保存区之间；`-O2` 下可能没有帧指针，但责任划分不变。
:::
:::

::: method 回忆 5 · 第 7、8、9 个参数
9 个 `long` 参数在三套 ABI 下分别从哪取？建帧后偏移怎么变？≤16 字节结构体、>16 字节结构体、HFA、可变参数各怎么处理？
::: sol 答案
x86-64 只有 6 个整数参数寄存器：第 7、8、9 个走栈，入口 `[rsp+8]`/`[rsp+16]`/`[rsp+24]`（`call` 先压了 8 字节返回地址），`push rbp` 后是 `[rbp+16]`/`[rbp+24]`/`[rbp+32]`。ARM64 有 8 个：第 7、8 个在 `x6`/`x7`，第 9 个在入口 `[sp]`，建帧 32 字节后 `[sp+32]`。RISC-V 有 8 个：第 7、8 个在 `a6`/`a7`，第 9 个在入口 `0(sp)`，建帧后 `32(sp)`。≤16 字节结构体：x86-64 拆成 1–2 个 INTEGER/SSE 八字节；ARM64 拆 1–2 个寄存器；RISC-V 拆 1–2 个寄存器（≤2×XLEN）。>16 字节：三家都传指针（调用者在栈上复制）。HFA：ARM64 可走 `v0`–`v3`/`s0`–`s3`。可变参数：x86-64 用 `%al` 记录向量寄存器个数；ARM64 匿名参数主要走栈；RISC-V 用 `va_list` 保存区。
:::
:::

::: method 回忆 6 · 栈对齐与红区
x86-64 进入函数时 `rsp % 16` 是多少？`call` 前要多少？序言怎么补？红区是什么，为什么 ARM64/RISC-V 没有？`movaps` 段错误怎么来的？
::: sol 答案
x86-64 入口 `rsp % 16 == 8`（`call` 压了 8 字节），`call` 前要求 `rsp % 16 == 0`。若序言 `push %rbp`（8），再 `sub` 8 的奇数倍即可，例如 `push %rbp; mov %rsp,%rbp; sub $16,%rsp` 仍保持 0。红区是 SysV 允许叶子函数在 `rsp` 以下 128 字节内暂存、不调整 `rsp` 的约定，信号处理会跳过；ARM64/RISC-V 没有这个约定，`sp` 以下不保证安全。`movaps` 要求 16 字节对齐，调用前 `rsp` 不是 0 就段错误；序言 `sub` 总量要保持 16 的倍数。另一条相关规则：叶子函数用红区后一旦加了调用就崩，因为调用者的栈帧会覆盖红区。
:::
:::

## B. `_start`、系统调用与内联汇编

::: method 回忆 7 · `_start` 为什么不能 `ret`
不依赖 libc 的 `_start` 怎么用 `write`/`exit`？为什么结束必须走 `exit`/`exit_group`？内核进入 `_start` 时栈顶是什么？
::: sol 答案
aarch64 版本：`mov x8,#64; mov x0,#1; adr x1,msg; mov x2,#len; svc #0`，然后 `mov x8,#93; mov x0,#42; svc #0`。`_start` 没有调用者，栈上没有返回地址，`x30`/`ra` 也没有被 `bl`/`jal` 设置过；误用 `ret` 会跳到垃圾地址，所以结束必须走 `exit`/`exit_group`。内核进入 `_start` 时栈顶不是返回地址，而是 `argc`、`argv[]`、`envp[]`、`auxv[]`；glibc 的 `_start` 会把这些交给 `__libc_start_main`。裸 `write` 失败返回 `-errno`，不设置 `errno`，必须检查负值。
:::
:::

::: method 回忆 8 · 三套系统调用号
`read`/`write`/`openat`/`close`/`exit`/`exit_group` 在 x86-64、ARM64、RISC-V 上各是多少？号属于哪一层契约？为什么不能硬编码？
::: sol 答案
x86-64：`read`=0、`write`=1、`openat`=257、`close`=3、`exit`=60、`exit_group`=231。ARM64 与 RISC-V 遵循 asm-generic：`read`=63、`write`=64、`openat`=56、`close`=57、`exit`=93、`exit_group`=94。系统调用号是**内核 ABI**，不是 ISA；同一台机器上不同架构可以有不同编号。跨架构不要硬编码，用 `SYS_write`/`syscall()`；只有写 `_start` 或调试内核入口时才直接写数字。x86 的 1 是 `write`，ARM64 的 1 是 `io_destroy`。
:::
:::

::: method 回忆 9 · `syscall` 的第 4 个参数
x86-64 系统调用的参数顺序是什么？第 4 个为什么是 `r10` 而不是 `rcx`？`r11` 又为什么被破坏？ARM64/RISC-V 有等价问题吗？
::: sol 答案
x86-64 系统调用参数：`rdi,rsi,rdx,r10,r8,r9`，号在 `rax`。`syscall` 指令用 `rcx` 保存返回 `rip`、用 `r11` 保存 `rflags`，硬件会写这两个寄存器，所以第 4 个参数不能用 `rcx`，改用 `r10`；内联汇编还要把 `"rcx"`、`"r11"` 声明为 clobber。ARM64 的 `svc #0` 参数在 `x0`–`x5`、号在 `x8`，返回值在 `x0`，没有这种隐式覆盖；RISC-V 的 `ecall` 参数在 `a0`–`a5`、号在 `a7`，也没有。
:::
:::

::: method 回忆 10 · C 内联汇编的约束
写一个 `sys_write` 的 C `asm volatile`，输出、输入、clobber 各写什么？为什么必须 `volatile` 与 `"memory"`？ARM64/RISC-V 版本差在哪？
::: sol 答案
x86-64：`__asm__ volatile("syscall" : "=a"(ret) : "a"(1L), "D"(fd), "S"(buf), "d"(n) : "rcx", "r11", "memory");`。`"=a"` 是 `rax` 输出，`"D"/"S"/"d"` 是 `rdi/rsi/rdx`，`rcx`/`r11` 必须声明为 clobber，`"memory"` 告诉编译器内核可能读写缓冲区、不要重排。没有输出的 `asm` 必须 `volatile`，否则可能被优化掉。ARM64：把号 64 放进 `x8`、fd 放 `x0`、buf 放 `x1`、长度放 `x2`，`svc #0`，`"+r"(x0)` 读写同一寄存器；RISC-V：号 64 放 `a7`、参数 `a0`/`a1`/`a2`，`ecall`，`"+r"(a0)`。两套都不需要 `rcx`/`r11` 这类 clobber。
:::
:::

::: method 回忆 11 · Rust `asm!` 与 C 的差别
Rust 的 `asm!` 怎么写输入输出、读写同一寄存器、内存与栈的承诺？和 C 的 `asm volatile` 表怎么对？
::: sol 答案
Rust 用 `in("rax") 1isize` 指定输入，`lateout("rax") ret` 指定输出，`inout("x0") fd => ret` 表示读写同一寄存器；`options(nostack)` 声明不碰栈，`options(nomem)` 才是承诺不碰内存，`options(preserves_flags)` 才承诺标志不变。C 的 `"=a"(ret)` 对应 `lateout("rax") ret`，`"D"(fd)` 对应 `in("rdi") fd`，`"+r"(x0)` 对应 `inout("x0")`；C 用 `"memory"` clobber，Rust 默认可能读写内存，要显式 `nomem` 才排除。Rust 的 `asm!` 默认有副作用，不需要 `volatile`；x86 的 `syscall` 仍要 `lateout("rcx") _`、`lateout("r11") _`。
:::
:::

## C. 工具取证与环境边界

::: method 回忆 12 · `objdump`/`readelf` 能看出什么
`readelf -sW`、`readelf -rW`、`objdump -d` 各能回答什么问题？x86-64/ARM64/RISC-V 的调用重定位名各是什么？
::: sol 答案
`readelf -sW` 看符号：`framed` 是 `GLOBAL FUNC`、`add_one` 可能是 `LOCAL FUNC`；跨文件时出现 `UND add_one`。`readelf -rW` 看重定位：x86-64 的跨文件调用是 `R_X86_64_PLT32`，ARM64 是 `R_AARCH64_CALL26`，RISC-V 是 `R_RISCV_CALL_PLT`/`R_RISCV_JAL`。`objdump -d` 看序言/尾声与参数寄存器：`push %rbp`、`sub $0x18,%rsp`、`mov %rdi,%rbx`，或 `stp x29,x30`、`ldr x0,[sp,...]`。`-O2` 可能把 `framed` 内联掉，用 `__attribute__((noinline))` 阻止；`--no-show-raw-insn` 只看指令。
:::
:::

::: method 回忆 13 · `gdb` 要核对哪三件事
在 `gdb` 里看一次调用，重点确认哪三件事？x86-64 与 ARM64 的寄存器/命令怎么换？
::: sol 答案
三件事：入口 `sp` 是否 16 字节对齐；返回地址在栈的哪个偏移；被调用者保存寄存器是否真的被保存。x86-64：`break framed`、`run`、`info registers rdi rsi rsp rbp rbx`、`x/6gx $rsp`、`bt`、`disassemble /r framed`、`finish`、`info registers rax`。ARM64：寄存器换成 `x0/x1/sp/x29/x30`，用 `x/6gx $sp` 看保存的 `x29/x30`；RISC-V 换成 `a0/a1/sp/s0/ra`。`bt` 依赖帧指针，`-O2` 省略帧指针时可能断链。
:::
:::

::: method 回忆 14 · 十二条陷阱里最先该记哪几条
说出至少六条汇编/ABI 陷阱，以及每条的一句话证据。
::: sol 答案
① 返回地址错乱：用 `jmp` 进入或栈溢出覆盖返回地址；看调用点是否 `call`/`bl`/`jal`。② `movaps` 段错误：`rsp` 未 16 字节对齐；看 `call` 前 `rsp%16`。③ 红区失效：叶子函数加了调用；看有没有 `sub`。④ ARM64 嵌套调用返回错地址：没保存 `x30`；看开头有没有 `stp x29,x30`。⑤ RISC-V 递归只返回一层：没保存 `ra`；看每层有没有 `sd ra`。⑥ 调用者保存寄存器跨调用被改：把 `rax/rcx/rdx/rsi/rdi/r8-r11` 当长期变量；改放 `rbx/r12-r15`。⑦ 被调用者保存没恢复：用了 `rbx` 直接 `ret`；看 `push/pop` 是否成对。⑧ `printf("%f")` 垃圾：x86-64 没设 `%al`；看调用点有没有 `movl $1,%eax`。⑨ 结构体 C/Rust 不一致：Rust 没 `#[repr(C)]`。⑩ 内联汇编 `-O2` 错：缺 `"memory"`/clobber。⑪ 裸 `syscall` 负数当字节数：失败返回 `-errno`。⑫ RISC-V `li symbol_difference` 报 `fixup value out of range`：改用常量或运行时相减。
:::
:::

::: method 回忆 15 · 写作机能做什么、不能做什么
写作机（macOS arm64 + clang 21）能对哪些架构出汇编/目标文件？为什么不能链接运行？VM 上又该怎么做？
::: sol 答案
写作机的 `clang --target=x86_64-linux-gnu`、`--target=aarch64-linux-gnu`、`--target=riscv64-linux-gnu` 能出汇编（`-S`）与 ELF 目标文件（`-c`）；但 `--target` 只改代码生成，不提供目标 sysroot、`crt1.o`、`-lc` 与目标链接器，所以带 `-o` 的链接会失败；ELF 在 macOS 上也不能执行。VM 是 aarch64，原生 `cc` 可直接编译、链接、运行 aarch64 程序；x86-64/RISC-V 的链接与运行需要交叉 sysroot + 真机或 QEMU，本环境未确认，按「未实测」处理。能出目标文件不等于能跑，`file`/`readelf -h` 只能证明架构，不能证明可执行。
:::
:::

::: method 回忆 16 · 环境边界与未实测项
本环境哪些工具可用、哪些不可用？`perf`、`gdb`、`cargo asm`、交叉运行各怎么处理？哪些结论必须降级？
::: sol 答案
VM：`cc`/`gcc`、`as`、`objdump`、`readelf` 可用；`sudo` 不可用；`perf` 不可用，`perf stat`/`perf record` 全部标「未实测」，替代是 `clock_gettime` 计时。`gdb`、`cargo`、交叉 gcc、QEMU 是否安装未确认，先 `command -v` 再决定。写作机只能交叉汇编 x86-64/RISC-V/aarch64，不能链接运行。必须降级的结论：所有 `perf` 读数、`gdb` 交互输出、`cargo asm`/`cargo llvm-lines` 输出、x86-64/RISC-V 的实际执行结果、RISC-V 的运行时行为；只保留 ABI 条款、寄存器编号、栈偏移与工具能直接读出的 ELF 字段。
:::
:::
