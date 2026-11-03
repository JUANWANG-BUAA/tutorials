# 1.14 勘误与版本注记

这一页收本章最容易「换一台机器、换一个架构、换一个编译器就不成立」的东西：三套 ISA 的边界、ABI 的寄存器数量、立即数范围、系统调用号、工具链能力，以及母本 CSAPP 的版本问题。正文的 `errata` 盒讲理解陷阱；这一页讲**换架构、换工具链之后要复核什么**。

**本章基线**：正文与套件里标「VM」的读数来自本书 Ubuntu 24.04.5 虚拟机（aarch64、内核 7.0.0-38-generic、GCC 13.3.0、4 vCPU，`sudo` 不可用）。`cc`/`gcc`、`as`、`objdump`、`readelf`、`getconf` 可用；**`perf` 不可用**；`qemu-aarch64`、`qemu-riscv64`、交叉 gcc、`llvm-mc` 是否安装未确认。写作机是 macOS arm64 + Apple clang 21，`--target=x86_64-linux-gnu`/`--target=aarch64-linux-gnu` 能出汇编与 ELF 目标文件，但不能链接、不能运行；`clang --print-targets` 没有 riscv64。凡标「未实测」的，请看末节。

## 1. 十七个容易搬家的结论

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「第 7 个参数在三套 ABI 上都在栈上」（正文 1.14.11 的表与汇编清单） | x86-64 只有 6 个整数参数寄存器，第 7、8 个在栈上；**ARM64 与 RISC-V 有 8 个**，第 7、8 个在 `x6`/`x7`、`a6`/`a7`，第 9 个才在入口 `[sp]`、建帧后 `[sp+32]`。1.14.11 的汇编把 `g`/`h` 从 `[sp,#32]`/`[sp,#40]` 取，是照 x86 的上限套的，跑起来会算错；以 1.14.4 与 1.14.16 的 A2 为准 | 写 9 参数函数 `cc -O0 -S`：aarch64 上 `x0`–`x7` 全部 `str` 到栈、第 9 个从 `[sp]` 取；写作机 clang 21 aarch64 实测如此；再查 AAPCS64 §5.4.2 与 RISC-V psABI 的整数参数规则 |
| 「三套 ISA 的汇编可以互搬，改改寄存器名就行」 | 助记符同名不代表语义相同：x86 两操作数、ARM64/RISC-V 三操作数；`ret` 在 x86 是弹栈、在 ARM64 是跳 `x30`、在 RISC-V 是 `jalr x0,0(ra)`；`mov` 在三家是完全不同的指令族。ABI 又规定了不同的参数与保存规则 | 把 x86 的 `sum3` 原样交给 `clang --target=aarch64-linux-gnu -c`，看 `%rdi`/`%rax` 报未知寄存器；再把同一段 C 用 `-S` 生成三份，对照参数寄存器 |
| 「`clang --target` 能出汇编，就能交叉运行」 | `--target` 只改代码生成，不提供 sysroot、`crt1.o`、`-lc` 与目标链接器；`-S`/`-c` 能成功，带 `-o` 的链接会失败；ELF 在 macOS 上也不能执行。要运行需要交叉 sysroot + 真机或 QEMU | `-S` 与 `-o` 各跑一次；失败信息点名 `crt1.o`/`-lc`（macOS 上是 `ld: unknown options: --hash-style=gnu --eh-frame-hdr`）；`file`/`readelf -h` 确认是目标架构的 ELF |
| 「寄存器差异只是名字不同」 | 数量与职责都不同：x86 16 个通用寄存器、6 个整数参数、无零寄存器、128 B 红区；ARM64 31 个、8 个参数、`xzr`、LR 是 `x30`；RISC-V 32 个、8 个参数、`x0` 恒 0、`ra` 就是 `x1`。x86 系统调用的第 4 个参数是 `r10` 而不是 `rcx`，因为 `syscall` 覆盖 `rcx`/`r11` | 默写 1.14.4 的表；写一个 4 参数 `write` 的 x86 汇编，把 `r10` 改成 `rcx` 看是否写错 fd；`readelf -h` 看 `Machine` 先确认架构 |
| 「ARM64 的 `add` 立即数可以随便写 32 位」 | `add` 的 imm12 是 12 位无符号，可带 `LSL #12`：0–4095 或 4096–16,773,120（步长 4096），没有负立即数（用 `sub`）。`ldr`/`str` 的无符号偏移也是 12 位，但按访问宽度缩放：8 字节访问是 0–32760；`ldur`/`stur` 才是 9 位有符号（−256..255） | `add x0,x0,#5000` 让汇编器报 `immediate out of range`；`ldr x0,[x1,#40000]` 同样报错；改成 `add x0,x0,#4096; add x0,x0,#904` 或 `add x2,x1,#32768; ldr x0,[x2,#7232]` |
| 「RISC-V 的 `ld` 偏移和 ARM 一样按字节随便写」 | I/S 型立即数是 12 位有符号（−2048..2047），且**不按访存宽度缩放**；B 型 13 位有符号、2 的倍数（±4 KiB）；J 型 21 位有符号、2 的倍数（±1 MiB）；U 型 20 位左移 12。RISC-V 也没有「基址 + 变址 × 比例」寻址，数组下标要先 `slli` 再 `add` | `ld a0,2048(a1)` 汇编失败；改成 `addi a2,a1,2047; ld a0,1(a2)`；`beq` 目标超过 ±4 KiB 时汇编器报 `out of range`，需要 `auipc`+`jalr` 或反转分支加 `jal` |
| 「`write` 的系统调用号在哪儿都是 1」 | 号是内核 ABI，不是 ISA：x86-64 是 1，ARM64 与 RISC-V 遵循 asm-generic 是 64；ARM64 的 1 是 `io_destroy`。`openat` 等编号也可能不同。跨架构不要硬编码，用 `SYS_write`/`syscall()` | `grep -E '__NR_(write|io_destroy)' /usr/include/asm-generic/unistd.h` 看到 64 与 1；`strace` 或 `qemu -strace` 看实际调用名（QEMU 未在本环境确认，未实测） |
| 「RISC-V 指令都是 4 字节」 | 默认 `rv64gc` 含 C 扩展，常用指令压缩成 2 字节；`objdump` 按固定 4 字节切分会错位，`sum3` 的 12 字节会变成 6 字节 | `cc -c` 后 `objdump -d` 看每条指令的偏移是 0/2/4 还是 0/4/8；`readelf -S` 看 `.text` 大小；`-march=rv64g` 与 `rv64gc` 各编一次 |
| 「`ret` 在三套 ISA 上是同一条指令」 | x86 的 `ret` 从栈顶弹出返回地址；ARM64 的 `ret` 跳到 `x30`；RISC-V 的 `ret` 是伪指令 `jalr x0,0(ra)`；`call` 在 RISC-V 上也是伪指令，会覆盖 `ra`。ARM64 的非叶函数必须自己把 `x30` 存栈 | 看 `objdump -d` 的机器码：x86 `c3`、ARM64 `d65f03c0`、RISC-V `00008067`（`jalr x0,0(ra)`）；在 RISC-V 的非叶函数里看 `sd ra,...` 是否出现 |
| 「x86 是强序，所以不需要屏障」 | TSO 只禁止 Load→Load、Load→Store、Store→Store，**Store→Load 仍允许**；Dekker litmus 会出现 `r1=r2=0`。要排除它，x86 加 `mfence`（或把 store 换成 `xchg`），ARM64 加 `dmb ish`，RISC-V 加 `fence rw,rw` | 看 1.14.13 的表；跑 C11 版 Dekker 一百万轮统计 `r1==0 && r2==0`；严谨验证用 `herd7` 的 `x86tso.cat`，不要用 QEMU 用户态当内存模型参考 |
| 「cache line 一定是 64 B」 | x86 常见 64 B；部分 ARM64（如 Apple M1）是 128 B。行大小一变，offset 位数、index 边界、同组流的间距全变 | `getconf -a | grep LEVEL1_DCACHE_LINESIZE`；Apple 机器用 `sysctl hw.cachelinesize`；再按 `sets = 容量/(行大小×相联度)` 重算 |
| 「1.14.10 实验 B 分配的是 64 MiB」 | 注释写 64 MiB，但 `1u << 26` 个 `int` 是 64 Mi 个元素 × 4 B = **256 MiB**；实验仍然超过 L3，但注释与分配不一致。要真是 64 MiB 应写 `1u << 24` | `grep -n '1u <<' ch14.md`；用 `sizeof(int)` 乘一遍；跑之前 `free -m` 看占用，或把 `n` 改成 `1u<<24` 再比 |
| 「正文的 `perf stat` 命令可以直接抄」 | 本环境 `perf` 不可用：1.14.7 实验 A（频率/IPC）、1.14.8 的 `branch-misses` 对照、1.14.10 实验 B 的 `L1-dcache-load-misses`/`LLC-load-misses`、1.14.15 的 `perf stat`/`perf c2c` 都没有本机读数。替代：`clock_gettime` 计时 + `getconf` 几何 + 手算 CPI/AMAT | `perf stat true` 报权限/未安装；`command -v perf`；没有就把结论降级为「未实测」，只报时间差与几何，不报 miss 数 |
| 「`qemu-aarch64 -L` 对所有程序都要加」 | `-L` 是给动态链接器指 sysroot 的；静态程序加了反而可能加载错误的 `ld.so`。`-static` 也不等于非 PIE：`-static-pie` 仍是 `DYN` | 静态 `hello` 直接 `qemu-aarch64 ./hello` 与加 `-L` 各跑一次；`readelf -h` 看 `Type` 是 `EXEC` 还是 `DYN`；`readelf -l` 看 `INTERP` 是否存在 |
| 「`clang --target=riscv64` 在写作机上可用」 | 写作机的 Apple clang 21 只注册了 aarch64/arm/x86/wasm 目标，`--target=riscv64-linux-gnu` 报 `No available targets are compatible with triple`；`llvm-mc`/`llvm-objdump`/`llvm-size` 也不在 PATH 上。RISC-V 的汇编与编码核对在本套件里按「未实测」处理 | `clang --print-targets` 看列表；`command -v llvm-mc llvm-objdump llvm-size`；换一台带 RISC-V 后端的 LLVM 再跑同样的 `-S`/`llvm-mc` 命令 |
| 「CSAPP 中文第 3 版可以像英文版一样引页码与原句」 | 中文第 3 版是**纯扫描版**：整页是图片，没有文本层，页码与英文版也不一一对应。只能按目录与章节号核对落点（第 3 章机器级表示、第 4 章 4.4–4.5、第 6 章 6.4–6.6），不能引用句子与页码 | 在 PDF 里选中一段文字，若复制为空或整页是图，就是扫描版；`pdftotext` 输出为空也说明没有文本层。本书只写「CSAPP 第 3 章」这类章节号，不写页码 |
| 「三条指令，所以三套代码一样大」 | 指令条数只反映译码次数，字节数才反映 I-cache 占用：x86 `sum3` 8 字节、ARM64 12 字节、RISC-V 12 字节（RVC 6 字节）。`size` 的 `text` 还含只读数据、跳转表与对齐填充，不等于纯指令字节 | `objdump -d` 看最后一条指令的偏移加长度；`llvm-size -A`/`readelf -S` 看 `.text`；两者对不上时以地址范围为准 |

## 本章未实测项

下面这些没有本机证据支撑，引用前请当作**待验证的量级、形状或方法**，不要抄成事实：

- **所有 `perf` 读数**（1.14.7 实验 A、1.14.8 的 `branch-misses`、1.14.10 实验 B 的 L1/LLC 计数、1.14.15 的 `perf stat`/`perf c2c`）：本环境 `perf` 不可用，正文给出的命令形状可照抄，数字没有。
- **三架构的链接与运行**（1.14.14 实验 B）：写作机只能 `-S`/`-c`，链接失败（macOS 上是 `ld: unknown options...`）；aarch64 的静态 `hello` 在 VM 上可原生跑，但没有在 VM 上复跑；x86/RISC-V 的链接与 `qemu` 执行未实测（交叉工具链与 QEMU 未确认）。
- **RISC-V 的汇编与编码**：写作机 Apple clang 21 没有 riscv64 target，`llvm-mc` 不在 PATH；正文的 `0x00B50533`/`0x00150513`/`0x00113423`/`0x00B51463` 是手算与公开编码规则的结果，未用汇编器对答案。
- **1.14.11 的 ARM64/RISC-V 栈帧汇编清单**：按第 7 参数在栈上写，和 1.14.4/1.14.16 A2 矛盾，不能当作可运行示例；正确布局见勘误表第 1 条，`cc -O0 -S` 的实测形状见习题 C1。
- **7 nm/5 nm 频率与漏电表**（1.14.7）：公开资料的数量级，未在具体工艺库上核对；`size_lab` 的 30–40/40–48/24–32 字节（1.14.15）是预期量级，未在三套工具链上各编一次。
- **C 组实验的 VM 读数**：C1–C3 只用了 VM 确认可用的 `cc`/`objdump`/`readelf`/`getconf`，设计上可跑，但本套件写作时未在 VM 上逐条复跑；读数以你机器为准。C4 的 aarch64 部分可跑，x86 部分可在写作机复现，RISC-V 部分未实测。
- **QEMU 的 `-strace` 输出与内存模型**：`qemu-aarch64 -strace` 的调用名、`qemu-riscv64` 的行为未在本环境确认；QEMU 用户态也不是内存模型的参考实现，Dekker 的重排验证要用 `herd7` 或真机。
- **段错误/非法指令的真实崩溃现场**：本章没有制造 `SIGILL`/`SIGSEGV` 的注入实验；红区、栈对齐、`ret` 覆盖返回地址的后果是机制推论，不是本机崩溃转储。

## 发现新问题怎么记

按「现象 → 命令与输出 → 机器/架构/编译器/内核 → 建议改法」四段记，不要只写「我这里不对」。本章的结论大多挂在架构与工具链上，所以请一并附上：`uname -a` 与 `uname -m`；`cc --version`；`clang --version` 与 `clang --print-targets`（如果用了交叉 target）；`readelf -h` 的 `Machine`/`Type`；`objdump -d` 的原始几行；`getconf -a | grep LEVEL1_DCACHE` 的三行；以及 `perf stat true` 的报错（证明是否可用）。涉及数字时写明口径：是公式结果、工具输出、量级示例，还是「未实测」。本章多数分歧都出在把「x86 的 6 个参数寄存器」当成三家通用，或把「能出汇编」当成「能跑」。
