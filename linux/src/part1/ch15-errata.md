# 1.15 勘误与版本注记

这一页收本章最容易「换一台机器、换一个架构、换一个编译器就不成立」的东西：三套 ISA/ABI 的边界、寄存器数量、参数溢出、系统调用约定、内联汇编约束、工具链能力，以及母本 CSAPP 的版本问题。正文的 `errata` 盒讲理解陷阱；这一页讲**换架构、换工具链之后要复核什么**。

**本章基线**：正文与套件里标「VM」的读数来自本书 Ubuntu 24.04.5 虚拟机（aarch64、GCC 13.3.0、4 vCPU，`sudo` 不可用）。`cc`/`gcc`、`as`、`objdump`、`readelf` 可用；**`perf` 不可用**；`gdb`、`cargo`、交叉 gcc、QEMU 是否安装未确认。写作机是 macOS arm64 + clang 21：`--target=x86_64-linux-gnu`、`--target=aarch64-linux-gnu`、`--target=riscv64-linux-gnu` 能交叉汇编（`-S`/`-c`），但**不能链接、不能运行**。凡标「未实测」的，请看末节。

## 1. 十五条容易搬家的结论

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「三套 ISA 的汇编可以互搬，改改寄存器名就行」 | 助记符同名不代表语义相同：x86 两操作数、ARM64/RISC-V 三操作数；`ret` 在 x86 是弹栈、在 ARM64 是 `br x30`、在 RISC-V 是 `jalr x0,0(ra)`；`mov` 在三家是完全不同的指令族。ABI 又规定了不同的参数与保存规则 | 把 x86 的 `sum3` 原样交给 `clang --target=aarch64-linux-gnu -c`，看 `%rdi`/`%rax` 报未知寄存器；再把同一段 C 用 `-S` 生成三份，对照参数寄存器 |
| 「`clang --target` 能出汇编，就能交叉运行」 | `--target` 只改代码生成，不提供 sysroot、`crt1.o`、`-lc` 与目标链接器；`-S`/`-c` 能成功，带 `-o` 的链接会失败；ELF 在 macOS 上也不能执行 | `-S`/`-c` 与 `-o` 各跑一次；失败信息点名 `crt1.o`/`-lc`（macOS 上是 `ld: unknown options: --hash-style=gnu --eh-frame-hdr`）；`file`/`readelf -h` 只能确认架构，不能证明可执行 |
| 「第 7 个参数在三套 ABI 上都在栈上」 | x86-64 只有 6 个整数参数寄存器，第 7 个起走栈；**ARM64 与 RISC-V 有 8 个**，第 7、8 个在 `x6`/`x7`、`a6`/`a7`，第 9 个才在入口 `[sp]`/`0(sp)` | 写 9 参数函数 `cc -O0 -S`：aarch64 上 `x0`–`x7` 全部 `str` 到栈、第 9 个从 `[sp]` 取；再查 AAPCS64 §5.4.2 与 RISC-V psABI 的整数参数规则 |
| 「第 9 个参数在三套 ABI 上的栈偏移一样」（x86-64 只有 6 个参数寄存器，ARM64/RISC-V 各有 8 个） | x86-64 入口 `[rsp+24]`、建帧后 `[rbp+32]`；ARM64 入口 `[sp]`、建 32 字节帧后 `[sp+32]`；RISC-V 入口 `0(sp)`、建帧后 `32(sp)`。偏移取决于帧大小与是否保存 FP/LR，不能跨架构照抄 | 在 `-O0` 汇编里找第 9 个参数的 `ldr`/`ld`/`mov`；用 `gdb` 的 `x/6gx $sp` 对照入口栈顶；先确认帧大小再算偏移 |
| 「x86-64 系统调用第 4 个参数是 `rcx`」 | 函数调用表第 4 个是 `rcx`，但 `syscall` 用 `rcx` 保存返回 `rip`、`r11` 保存 `rflags`；第 4 个系统调用参数必须用 `r10`，内联汇编还要声明 `"rcx","r11"` clobber | 查 `syscall(2)` 的 ABI 表；写一个 4 参数 `openat`/`pwrite64`，把 `r10` 改成 `rcx` 看 `mode`/偏移是否写错；`objdump -d` 看 `syscall` 前是否有 `mov %rcx,%r10` |
| 「`write` 的系统调用号在哪儿都是 1」 | 号是内核 ABI，不是 ISA：x86-64 是 1，ARM64 与 RISC-V 遵循 asm-generic 是 64；ARM64 的 1 是 `io_destroy`。`openat` 等编号也可能不同 | `grep -E '__NR_(write|io_destroy)' /usr/include/asm-generic/unistd.h` 看到 64 与 1；`strace`/`qemu -strace` 看实际调用名（QEMU 未在本环境确认，未实测）；写跨架构代码用 `SYS_write` |
| 「ARM64 的 `ret` 也从栈顶弹返回地址」 | `ret` 是 `br x30`；`bl` 只写 `x30`，不写栈。栈上的 LR 副本是编译器为嵌套调用主动保存的，不是硬件压的返回地址 | 看 `bl` 后 `x30` 的变化；看 `ret` 的机器码 `d65f03c0`；看非叶函数开头有没有 `stp x29,x30`、结尾有没有 `ldp` |
| 「`stp x29, x30` 是在压返回地址」 | 它保存的是**当前函数的**帧指针与链接寄存器，供本函数返回前恢复；真正的返回地址在 `x30`，`ret` 不从栈上取 | 对照 `-O0` 汇编：`stp` 在序言、`ldp` 在尾声；`ret` 前没有从栈上 `ldr` 到 `x30` 的指令（除非函数自己恢复） |
| 「红区三套 ABI 都有」 | 红区只有 x86-64 SysV 有 128 字节，且只对叶子函数有效；ARM64/RISC-V 没有，`sp` 以下不保证安全 | 看 ARM64/RISC-V 序言是否先 `sub sp` 再写；在 x86-64 叶子函数里用 `-mno-red-zone` 对比；查 SysV ABI 的 red zone 条款 |
| 「x86-64 入口 `rsp` 就是 16 字节对齐」 | 入口 `rsp%16==8`（`call` 压了 8 字节），`call` 前才要求 `rsp%16==0`；序言 `sub` 总量要与 `push` 合起来凑 16 的倍数 | 用 `gdb` 在函数入口 `p $rsp % 16`；看序言 `push`/`sub` 算术；`movaps` 段错误就是反例 |
| 「每个函数都有序言，`push %rbp` 是保存返回地址」 | 叶子函数可以完全没有序言（`max3` 连栈都不碰）；`push %rbp` 保存的是调用者的帧指针，返回地址已由 `call` 压栈 | 看 `max3` 的反汇编只有 `cmp/cmov/ret`；看 `framed` 的 `push %rbp` 与 `call` 压栈是两件事 |
| 「内联汇编在 `-O0` 正常，就说明约束写对了」 | 缺 `volatile` 的无输出 `asm` 可能被优化掉；缺 `"memory"` 会让编译器把缓冲区写重排到 `syscall` 之后；缺 `rcx`/`r11` clobber 会让编译器把活值放在被覆盖的寄存器里 | 同一段 C 用 `-O0` 与 `-O2` 各编一次，比较 `syscall` 前后的指令顺序；加 `"memory"` 后复跑；`objdump -d` 看 `syscall` 前是否设置了号与参数 |
| 「裸 `syscall` 失败返回 `-1` 并设置 `errno`」 | 裸系统调用失败返回 `-errno`（例如 `-EBADF`），不设置 `errno`；`errno` 是 libc 包装做的 | 故意传坏 fd 调 `write`，检查返回值是否为 `-9` 一类；对比 libc `write` 返回 `-1` 且 `errno=EBADF` |
| 「RISC-V 的 `li reg, symbol_difference` 总能汇编」 | `li` 对需要重定位的符号差不能直接展开，GNU as 可能报 `fixup value out of range`；要用常量、`.equ` 的绝对值，或 `la` 两个符号后运行时相减 | 写 `li a2, msg_end - msg` 汇编一次；改成显式数字或 `la t0,msg; la t1,msg_end; sub a2,t1,t0` 再汇编 |
| 「CSAPP 中文第 3 版可以像英文版一样引页码与原句」 | 中文第 3 版是**纯扫描版**：整页是图片，没有文本层，页码与英文版也不一一对应。只能按目录与章节号核对落点（第 3 章 3.7/3.8/3.11、第 7 章），不能引用句子与页码 | 在 PDF 里选中一段文字，若复制为空或整页是图，就是扫描版；`pdftotext` 输出为空也说明没有文本层。本书只写「CSAPP 第 3 章 3.7」这类章节号，不写页码 |

## 本章未实测项

下面这些没有本机证据支撑，引用前请当作**待验证的量级、形状或方法**，不要抄成事实：

- **所有 `perf` 读数**（1.15.9 的 `perf stat`/`perf record`/`perf report`）：本环境 `perf` 不可用；命令形状可照抄，数字没有。替代是 `clock_gettime(CLOCK_MONOTONIC)` 计时，只报时间差，不报 IPC、分支失败率或 cache miss。
- **`gdb` 交互输出**（1.15.9）：`gdb` 是否安装未确认；即使安装，`x/6gx $sp`、`info registers`、`bt` 的具体值也随编译器与优化级别变化。正文只给命令形状与「要核对哪三件事」，不抄会话记录。
- **`cargo asm`/`cargo llvm-lines`**（1.15.9）：需要额外安装，未在本环境确认；没有就跳过，不影响本章代码。
- **x86-64/RISC-V 的链接与运行**：写作机只能 `-S`/`-c`，链接失败（macOS 上是 `ld: unknown options...`）；VM 是 aarch64，x86-64/RISC-V 需要 QEMU 或真机，本环境未确认。C4 只做交叉汇编与 `readelf`，执行部分标「未实测 + 原因」。
- **C1–C3 的 VM 读数**：只用 VM 确认可用的 `cc`/`objdump`/`readelf`，设计上可跑，但本套件写作时未在 VM 上逐条复跑；具体的寄存器分配、栈偏移与输出以你机器为准。
- **三条陷阱的崩溃现场**（`ret` 跳随机地址、`movaps` 段错误、红区被覆盖）：本章给的是机制推论与修法，没有在本机注入 `SIGILL`/`SIGSEGV` 并抓 core；要复现请自己构造最小例子。
- **CSAPP 扫描版的页码**：本章只按目录与章节号核对，未把任何页码或原句当作引用依据。

## 发现新问题怎么记

按「现象 → 命令与输出 → 机器/架构/编译器/内核 → 建议改法」四段记，不要只写「我这里不对」。本章的结论大多挂在架构与工具链上，所以请一并附上：`uname -a` 与 `uname -m`；`cc --version`；`clang --version` 与 `clang --print-targets`（如果用了交叉 target）；`readelf -h` 的 `Machine`/`Type`；`objdump -d` 的原始几行；以及 `perf stat true` 的报错（证明是否可用）。涉及数字时写明口径：是 ABI 条款、工具输出、量级示例，还是「未实测」。本章多数分歧都出在把「x86 的 6 个参数寄存器」当成三家通用，或把「能出汇编/目标文件」当成「能跑」。
