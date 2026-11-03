# 1.16 编译、链接与优化 · 本章导航

::: preview 这一章在讲什么
[1.7](ch07.md) 讲过符号解析、重定位与 GOT/PLT，[1.15](ch15.md) 把汇编与 ABI 摊开。这一章把两者接回工具链：同一份 `.c`/`.rs`，从预处理到可执行文件经过哪几个程序，每个阶段留下什么可读的产物，链接器又改了哪几个字节。核心不是背命令，而是**把「源码 → 目标文件 → 库 → 运行时绑定」变成一串能用 `readelf`/`objdump`/`nm`/`LD_DEBUG` 逐步复核的读数**；优化、LTO、`no_std`、FFI 都挂在这条链上。
:::

## 本章回答什么

- **一条流水线几个程序**：`cc` 是驱动，依次调 `cpp`/`cc1`/`as`/`collect2`+`ld`；`rustc` 自己做前端与 MIR，再把 LLVM IR 交给 LLVM，最后同样调系统链接器（1.16.1）。
- **ELF 里有什么**：`ET_REL`/`ET_EXEC`/`ET_DYN` 三种容器；`.text/.rodata/.data/.bss` 与 `.symtab/.dynsym` 的分工；`.bss` 为什么 `NOBITS` 不占文件；符号的 `Bind`/`Type`/`Ndx` 怎么读（1.16.2）。
- **重定位在说什么**：`R_X86_64_PC32` 与 `PLT32`、`R_AARCH64_CALL26`、`R_RISCV_CALL_PLT` 各由哪种指令产生，链接器往里填什么；哪些重定位链接后消失、哪些留到运行时（1.16.2）。
- **静态库与共享库不是一种东西**：`.a` 按成员抽取、`.so` 整库映射；SONAME、`NEEDED`、`RUNPATH` 各管什么；`-fPIC` 为什么是共享库的硬前提（1.16.3）。
- **一次外部调用的三段路**：调用点 → `.plt` 桩 → `.got.plt` → libc；首次调用的解析、`LD_BIND_NOW`、`-fno-plt` 与 RELRO 各自改哪一段（1.16.3）。
- **优化等级到底开了什么**：GCC 的 `-O2`/`-O3` 与 Rust 的 `-C opt-level` 不是同一组开关；`codegen-units`、边界检查、panic 分支、别名元数据都会改变产物（1.16.4）。
- **裁剪与隐藏**：`-flto` 把 IR 留到链接、`-ffunction-sections` + `--gc-sections` 删未引用节、`-fvisibility=hidden` 与版本脚本收窄 ABI、`strip` 与独立 debug 文件各删什么（1.16.5）。
- **把运行时拆掉**：`#![no_std]`、`#[panic_handler]`、`panic=abort` 的连带影响；C 侧对应的 freestanding `-nostdlib` 程序（1.16.6）。
- **跨语言边界**：Rust 导出给 C、C 导出给 Rust 各要什么属性；`#[repr(C)]`、所有权、`errno`、panic 跨边界的规则；bindgen/cbindgen 如何让声明不漂移（1.16.7）。
- **怎样取证、哪些会搬家**：`readelf -d/-r`、`nm -D`、`LD_DEBUG=bindings`、`LD_PRELOAD` 打桩怎么一步步串起来；十二条工具链陷阱与环境边界（1.16.8–1.16.11）。

## 读完你会

- 把 `hello.c` 手工拆成 `.i → .s → .o → a.out`，说出每步的工具、输入输出与能做的检查；用 `cc -v` 找到驱动真正执行的链接命令行。
- 用 `rustc --emit=llvm-ir/asm/obj` 得到同一份 `.rs` 的四种产物，并解释为什么最后一步仍然是系统链接器。
- 用 `readelf -h/-SW/-sW/-rW` 读出文件类型、节、符号绑定与重定位；区分 `.symtab` 与 `.dynsym`，解释 `UND`/`GLOBAL`/`WEAK` 与 `NOBITS`。
- 用 `ar rcs` 与 `cc -shared -Wl,-soname,...` 同时产出 `libmath.a` 与 `libmath.so.1.0`，补齐符号链接，并让两版 `main` 都跑出同样结果。
- 用 `readelf -d` 读出 `NEEDED`/`SONAME`/`RUNPATH`，用 `ldd` 与 `LD_DEBUG=bindings` 说明库是从哪找到、符号绑到哪；用 `LD_PRELOAD` 把 `math_sum` 换成固定返回值。
- 画出一次 `printf` 调用的 GOT/PLT 路径，说清首次调用与之后调用的差别，以及 `-Wl,-z,relro,-z,now` 改了什么。
- 对同一段循环生成 `-O0/-O1/-O2/-O3` 的汇编，指出寄存器分配、循环形态与向量化的变化；说清为什么这些数字不能跨编译器比较。
- 用 `-flto=auto`、`-ffunction-sections -Wl,--gc-sections`、`-fvisibility=hidden` 各构建一次，用 `size`/`nm`/`readelf -S` 说明收益与代价。
- 写一个 `#![no_std]` 静态库并让 C 调用，或写一个 `-nostdlib` 的 C 程序直接发 `write`/`exit`；说明 `panic=abort` 为什么常常是 FFI 的默认选择。
- 写双向 FFI：Rust 侧 `#[no_mangle] pub extern "C"` + `#[repr(C)]`，C 侧固定宽度整数；说清谁分配谁释放、panic 与 `errno` 的边界。
- 遇到「库明明存在却 undefined」「`cannot open shared object file`」「`-O3` 反而更慢」时，按「现象 → 机制 → 证据 → 修法」四段给出可复核的答案。

## 先修与预计学时

- 链接与加载的背景：[1.7 链接、加载与库](ch07.md)（符号解析、重定位、GOT/PLT 的直觉）。
- 汇编与 ABI：[1.15.1 三条调用指令](ch15.md#sec-1.15.1)、[1.15.8 工具取证](ch15.md#sec-1.15.8)；本章的 `readelf`/`objdump` 读法与之一致。
- 阅读：约 100 分钟（11 节）。C 组四个实验：约 40 分钟。章末习题：约 55 分钟。

### 环境与口径

- **VM**：Ubuntu 24.04.5（aarch64、GCC 13.3.0、4 vCPU，`sudo` 不可用）。`cc`/`gcc`、`as`、`ar`、`ld`、`objdump`、`readelf`、`nm`、`size`、`strip`、`objcopy` 可用；**`perf` 不可用**，[1.16.9](ch16.md#sec-1.16.9) 的 `perf stat`/`perf record` 一律按「未实测」读，替代是 `clock_gettime`/`/usr/bin/time` 计时加 `size` 与汇编对照。
- **VM 没有 Rust 工具链**：`rustc`/`cargo` 均不在。1.16.3 的 `cdylib`/`staticlib`、1.16.6–1.16.7 的 Rust 代码与习题 C4 在 VM 上跑不了，统一标「未实测 + 原因」；`bindgen`/`cbindgen`/`cargo bloat`/`cargo llvm-lines` 需要额外安装，按未安装处理。
- **写作机**：macOS arm64 + `rustc 1.99.1`。`rustc --emit=asm/obj/llvm-ir` 与直接 `rustc hello.rs -o hello` 都能成功，但**产物是 Mach-O，不是 ELF**；它不能与 VM 上的 Linux `cc`/`ld` 混链，也不能在 VM 上执行。写作机能做的只有「读 Rust 生成的汇编/IR 形状」，链接与运行仍回到 Linux。
- **口径**：正文的节名、重定位名、ELF 字段与命令形状是工具输出或文档条款；aarch64 上看到的动态重定位是 `R_AARCH64_JUMP_SLOT`，x86-64 才是 `R_X86_64_JUMP_SLOT`。C 组只把工具输出当读数，先写预期再跑；凡是本机没有证据的 `perf`、`cargo`、`bindgen` 输出，一律不编造。

## 本章路线：四段，一条主线

| 段 | 小节 | 这一段回答什么 |
|:--|:--|:--|
| **一、产物与容器** | [1.16.1](ch16.md#sec-1.16.1)、[1.16.2](ch16.md#sec-1.16.2) | 哪几个程序接力？`.o` 里留下什么节、符号与重定位？ |
| **二、库与绑定** | [1.16.3](ch16.md#sec-1.16.3) | `.a` 与 `.so` 怎么造、怎么找；GOT/PLT 怎样把 `printf` 接到 libc？ |
| **三、优化、裁剪与边界** | [1.16.4](ch16.md#sec-1.16.4)–[1.16.7](ch16.md#sec-1.16.7) | `-O2`/`opt-level=3` 各做什么；LTO/节回收/strip 删什么；`no_std` 与 FFI 改哪些契约？ |
| **四、实验与收口** | [1.16.8](ch16.md#sec-1.16.8)–[1.16.11](ch16.md#sec-1.16.11) | 怎样用四个工具逐层读数；十二条陷阱；本章小结。 |

一句话主线：**先把「源码 → `.o` → 库 → 可执行文件」每一站的产物与契约分开（1.16.1–1.16.3），再把优化与裁剪看成对同一份 IR 的不同选择（1.16.4–1.16.5），最后用 `no_std` 与 FFI 把语言运行时拆到边界上（1.16.6–1.16.7），并用 `readelf`/`nm`/`LD_DEBUG` 把每条结论变成读数（1.16.8–1.16.11）；看到一个构建问题，固定问三件事——东西在哪一层、谁改的、用什么读出来。**

## 怎么读

- **第一次读**：1.16.1–1.16.3 一口气读完，边读边在纸上画「`.c` → `.o` → `.a`/`.so` → 进程」四格图；然后跳到 1.16.8 照命令跑一遍 `readelf -d` 与 `LD_DEBUG`。
- **正在排一个具体构建故障**：`undefined reference` 看 1.16.10 与[习题 B1](ch16-exercises.md#ex-1.16-B1)；`cannot open shared object file` 看 B2；`-fPIC` 报错看 B3；`-O3` 反而慢看 B4 与[勘误页](ch16-errata.md)；Rust 符号找不到看 B5。
- **准备面试或课程考试**：四阶段与 ELF 三类型（1.16.1–1.16.2）、静态库与共享库的差别（1.16.3）、`-O2`/`-O3` 的取舍（1.16.4）、`#[no_mangle]` + `extern "C"`（1.16.7）是四处必答；先做[习题集](ch16-exercises.md) A 组。
- **怕数字搬家**：体积、符号数、加速比都可复算，但只在同一编译器、同一版本、同一架构内可比；`perf` 与 Rust 工具链在本环境没有，统一记在[勘误页](ch16-errata.md)的「本章未实测项」。

## 路线标签与项目回链

- **应用/运维：必读** [1.16.1](ch16.md#sec-1.16.1)、[1.16.3](ch16.md#sec-1.16.3)、[1.16.10](ch16.md#sec-1.16.10)。部署时的 `LD_LIBRARY_PATH`、`ldd`、`SONAME` 与 `-rpath` 都在这里；**可后补** [1.16.6](ch16.md#sec-1.16.6)（不写裸机/库可跳）。
- **系统编程：必读** [1.16.2](ch16.md#sec-1.16.2)–[1.16.7](ch16.md#sec-1.16.7)、[1.16.10](ch16.md#sec-1.16.10)。发布库、写 FFI、查崩溃栈都绕不开；**可后补** [1.16.9](ch16.md#sec-1.16.9)（`perf` 不可用，先看 `size` 与汇编）。
- **内核/性能：必读** [1.16.4](ch16.md#sec-1.16.4)、[1.16.5](ch16.md#sec-1.16.5)、[1.16.9](ch16.md#sec-1.16.9)。LTO、节回收与 `no_std` 是内核与嵌入式构建的日常；**可后补** [1.16.8](ch16.md#sec-1.16.8)（动态库四层读数）。
- **项目回链**：A1 `mycontainer` 的镜像构建最终要落到「静态链接还是动态链接、基础镜像里有没有 `ld.so`」；本章的 `ldd` 与 `readelf -d` 就是判断「这个二进制换个 rootfs 还能不能跑」的最短路径。

## 章末件

[章末总结](ch16-summary.md) · [闭卷回忆卡](ch16-recall.md) · [习题集](ch16-exercises.md) · [学习目标自检表](ch16-checklist.md) · [勘误与版本注记](ch16-errata.md)

## 这一章的依据

| 母本 | 章节 | 主要落点 |
|:--|:--|:--|
| **CSAPP** | 第 7 章 链接（7.1–7.14） | 1.16.1–1.16.5：驱动、ELF、符号、重定位、动态链接、PIC |
| **CSAPP** | 第 5 章 优化程序性能 | 1.16.4：优化等级与性能证据的读法 |
| **Rust Book** | 第 19 章 unsafe、附录 Cargo/rustc | 1.16.6–1.16.7：`no_std`、FFI、panic 策略 |
| **Rustonomicon** | FFI、`repr(C)`、unwind 边界 | 1.16.7：按 ABI 独立改写 |
| **rCore** | 第 0 章 编译/链接、附录 D `cargo asm` | 1.16.1、1.16.9：只借工具链组织方式 |

> CSAPP 中文第 3 版是纯扫描版，只能按目录与章节号核对落点，不能引用句子与页码；详见[勘误页](ch16-errata.md)。
