# 1.16 勘误与版本注记

这一页收本章最容易「换一台机器、换一个编译器、换一个架构就不成立」的东西：优化等级的读数、链接顺序、静态库与共享库的边界、符号名与可见性、Rust 工具链产物、FFI 布局，以及母本 CSAPP 的版本问题。正文的 `errata` 盒讲理解陷阱；这一页讲**换工具链、换平台之后要复核什么**。

**本章基线**：正文与套件里标「VM」的读数来自本书 Ubuntu 24.04.5 虚拟机（aarch64、GCC 13.3.0、4 vCPU，`sudo` 不可用）。`cc`/`gcc`、`as`、`ar`、`ld`、`objdump`、`readelf`、`nm`、`size`、`strip`、`objcopy` 可用；**`perf` 不可用**；**VM 没有 Rust 工具链**（`rustc`/`cargo` 均不在），`bindgen`/`cbindgen`/`cargo bloat`/`cargo llvm-lines` 也未安装。写作机是 macOS arm64 + `rustc 1.99.1`：`rustc --emit=asm/obj/llvm-ir` 与直接编译都能成功，但**产物是 Mach-O，不是 ELF**，不能与 Linux `cc`/`ld` 混链，也不能在 VM 上运行。凡标「未实测」的，请看末节。

## 1. 十六条容易搬家的结论

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「`-O3` 一定比 `-O2` 快，A 机器测到的 15% 可以写进 B 机器的报告」 | 优化等级只是一组 pass 的开关名；收益依源码形状、数据规模、编译器与版本、目标 ISA、`-march`/`-mtune`。GCC 的 `-O3` 与 Rust 的 `-C opt-level=3` 走不同实现（LLVM 管道），**结果不可跨编译器比较**；`-O3` 还可能膨胀 I-cache、降低命中 | 同源码、同输入、同机器、同编译器版本内，用 `clock_gettime`/`/usr/bin/time` 多次取中位数，配 `size` 与 `objdump -d`；报告写明 `cc --version`、完整 flags、`uname -m`。跨任何一项都只能叫「另一组读数」 |
| 「加 `-fno-strict-aliasing` 就修好了」 | 它关掉的是编译器基于严格别名的优化假设（TBAA），不是修掉源码里的类型双关。代价是优化变弱、代码可能变慢，而 UB 仍在；正确修法是用 `memcpy`/`union`/`char *` 表达别名 | 同一源码 `-O2` 与 `-O2 -fno-strict-aliasing` 各编一次，比较汇编与计时；开 `-Wstrict-aliasing=2` 看告警；确认改源码后不再需要这个开关 |
| 「库明明存在，就不该 `undefined reference`」 | 传统 `ld` 单遍扫描，命令行顺序即处理顺序；`-lfoo` 出现在引用它的 `.o` 之前时，没有任何未定义符号需要它，归档成员一个都不抽取。两个静态库互相依赖要 `--start-group`/`--end-group`（或重复列出）；Ubuntu 默认 `--as-needed` 也会让共享库顺序有影响 | `cc -L. -lmath main.o` 与 `cc main.o -L. -lmath` 各链一次；`nm main.o` 看 `U math_sum`；`-Wl,--trace-symbol=math_sum` 看解析时机；循环依赖用 `--start-group` 复跑 |
| 「`.a` 与 `.so` 只是打包方式不同，换个链接参数而已」 | `.a` 按成员抽取，代码进最终文件、无运行时依赖、升级要重链；`.so` 整库映射，有 `SONAME`/`NEEDED`/版本脚本，运行时由 `ld.so` 查找，可被 `LD_PRELOAD` 劫持，且必须 `-fPIC`。两者在体积、启动、ABI 维护与安全面上都不同 | `size app-archive app-dynamic`；`readelf -d app-dynamic` 看 `NEEDED`；`ldd` 看解析；`nm -D --defined-only lib.so` 看导出；`LD_PRELOAD` 打桩看行为变化 |
| 「写了 `pub extern "C" fn math_sum`，C 就能按 `math_sum` 链接」 | Rust 默认对符号做 name mangling（legacy `_ZN...` 或 v0 `_R...`），名字随 crate、模块、泛型、编译器版本变化；`extern "C"` 只改 ABI，不改符号名。必须 `#[no_mangle]`（Rust 2024 edition 起写 `#[unsafe(no_mangle)]`）才导出原名；LTO/strip 还会改变可见性 | `nm librustffi.a \| grep -E 'math_sum\|_ZN\|_R'`；`nm -D --defined-only lib.so`；`-C symbol-mangling-version=v0` 观察名字变化；`readelf -sW` 看 `Bind`/`Type` |
| 「CSAPP 中文第 3 版可以像英文版一样引页码与原句」 | 中文第 3 版是**纯扫描版**：整页是图片，没有文本层，页码与英文版也不一一对应。只能按目录与章节号核对落点（第 7 章链接、第 5 章优化），不能引用句子与页码 | 在 PDF 里选中一段文字，若复制为空或整页是图，就是扫描版；`pdftotext` 输出为空也说明没有文本层。本书只写「CSAPP 第 7 章」这类章节号 |
| 「`-fPIC` 与 `-fPIE` 可以互换」 | 进 `.so` 的 `.o` 必须 `-fPIC`；`-fPIE` 是给可执行文件（PIE）的，语义相近但允许针对可执行文件的优化。把 `-fPIE` 目标文件塞进共享库可能仍报 `relocation ... can not be used when making a shared object` | 看报错点名的重定位类型；分别用 `-fPIC`/`-fPIE` 编译同一个 `.o` 再 `cc -shared`；`readelf -rW` 比较重定位种类 |
| 「`-Wl,-rpath,$ORIGIN` 一定写进动态段」 | 不加引号或加双引号时 `$ORIGIN` 被 shell 展开成空串，最终 `RUNPATH` 为空；正确写法是单引号 `'$ORIGIN'`。另外 `NEEDED` 记的是 `SONAME`，只有 `libmath.so` 而没有 `libmath.so.1` 时照样找不到 | `readelf -d` 看 `RUNPATH` 是否为空；`ls -l libmath.so*` 看链接链；`LD_DEBUG=libs` 看搜索路径；`ldd` 看 `not found` |
| 「LTO 静态库用普通 `ar` 打包就行」 | LTO 对象要靠链接器插件识别；归档工具必须配套（`gcc-ar`/`gcc-ranlib`），否则报 `plugin needed to handle lto object`。这是工具链不匹配，不是代码错 | `ar t lib.a` 能看到成员但链接报插件缺失；换 `gcc-ar rcs` 重建后复跑；`command -v gcc-ar` 先确认存在 |
| 「`strip` 会顺带删掉动态符号，所以发布库不能 strip」 | 默认 `strip` 删 `.symtab` 与 `.debug_*`，保留 `.dynsym`；动态链接不会因此失效。真正危险的是手工删节或对错误对象用 `--strip-all`；要保留崩溃定位就另存 debug 文件 | `readelf -SW` 看 `.dynsym` 是否还在；`nm -D` 是否还能列出导出；`objcopy --only-keep-debug` + `--add-gnu-debuglink` 复跑 `backtrace` |
| 「`.bss` 占 64 MiB，文件就该大 64 MiB」 | `.bss` 是 `SHT_NOBITS`，文件里只有节头，加载时映射零页，首次写才分配物理页；`ls -l` 不含它，`size` 的 `bss` 列单独读 | `readelf -SW` 看 `NOBITS`；`size` 的 `text/data/bss` 三列与 `ls -l` 对比；`static char pool[64<<20];` 编译后看文件大小 |
| 「`cargo build --release` 已经是最优化」 | release 默认 `opt-level=3`，但 `codegen-units` 默认 16、`lto` 默认关闭（或仅 thin），跨单元内联受限；`strip="symbols"` 还会让 `cargo bloat` 看不到符号 | 比较 `[profile.release]` 加 `lto="fat"`、`codegen-units=1` 前后的 `size`/`nm`/计时；`cargo build --release -vv` 看实际 rustc 参数 |
| 「`panic=abort` 只是省体积，语义不变」 | abort 不展开栈：`catch_unwind` 捕不到、`Drop` 不保证执行、`#[should_panic]` 失效、panic 跨 `extern "C"` 仍是 UB。要跨语言传播必须 `extern "C-unwind"` 且两边运行时都支持 | 同一代码 abort/unwind 各构建一次，跑触发 panic 的用例；`readelf -SW` 看 `.eh_frame`；`nm`/`size` 看 unwind 符号与体积 |
| 「`no_std` 就是不链接任何东西」 | 仍链接 `core` 与 `compiler_builtins`；最小库要提供 `#[panic_handler]`，最终二进制若裸机还要 `#![no_main]`、入口/链接脚本，用 `alloc` 要给 `#[global_allocator]`。库和二进制都定义 `#[panic_handler]` 会报重复 | 看 `rustc` 报错是「缺失」还是「重复」；`nm libnostd.a` 看 `core` 符号；最终 `readelf -h` 看 `Type` 与入口 |
| 「`-march=native` 编出的包在哪儿都能跑」 | 它使用构建机的指令集扩展；换到不支持 AVX/NEON 变体的机器会 `SIGILL`。发布包应用基线（如 `-march=x86-64-v2`/`-mcpu=generic`）或运行时多版本分发 | `objdump -d` 找新指令；在更老的机器/模拟器上跑；`gcc -march=native -Q --help=target` 看启用了什么 |
| 「C 的 `long` 与 Rust 的 `c_long` 在哪儿都是 64 位」 | Linux 64 位（LP64）是 64 位，Windows（LLP64）是 32 位；`size_t` 是指针宽度。FFI 用 `<stdint.h>` 的 `int64_t`/`int32_t` 与 `size_t`，不要让 bindgen/cbindgen 猜 | 在目标平台打印 `sizeof(long)`；`bindgen` 生成的类型是否 `c_long`；跨平台 CI 各编一次 |
| 「bindgen/cbindgen 装上就一劳永逸」 | 两者都要额外安装（bindgen 还需 `libclang`）；生成物随版本变化，结构体一改而头文件未更新就会布局漂移。要把生成物提交并在 CI 用 `git diff --exit-code` 卡住 | `command -v bindgen cbindgen`；`bindgen --version`；改一个字段后重新生成，看 diff 是否被 CI 捕获 |

## 复跑校正（2026-11-02，同一台 VM）

下面三条是本轮在同一台 Ubuntu 24.04.5 aarch64 虚拟机（`cc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0`）上重跑正文命令时发现的，正文已按**复跑值**订正；旧读数留在这一节，方便你对上自己手上的版本。

| 正文位置 | 原来的读数 | 复跑得到的读数 | 处理 |
|:--|:--|:--|:--|
| 1.16.6 的 `-ffreestanding -nostdlib` 产物 | 文件 1632 字节、`text` 133，并说「打印 freestanding ok」 | 正文当时贴的那份源码**跑不出退出**：`objdump` 里没有 `mov x8, #0x5d`，第二次 `svc` 复用了指令号 64，程序落进 `for(;;)`，`timeout 5` 退码 124。按修正后的 `sys_exit` 独立 asm 块复跑：1632 字节、`text` 129、`rc=0` | 正文换成修正版源码 + 两版反汇编对照；旧读数 133 与新版 129 差 4 字节，属同一函数的两种写法之间的小差异，不再当作可引用数字 |
| 同一份（错误写法的）产物的优化等级敏感性 | 正文未提 | `-O0` 是 1736 / `text` 213；`-O1`/`-O2`/`-O3` 三档都是 1616 / 125，且三档都不退出 | 体积差异只来自「要不要展开」；更重要的是**同一个 bug 在四个等级下都存在**，所以别指望换等级把它绕过去 |
| 1.16.2 里 `int g_zero;` 改成 `= 7;` | 只有定性说法 | `size` 从 `300/8/8` 变 `300/12/4`（`dec` 恒 316）、`.data` 节 `0x8→0xc`、`.bss` 节 `0x8→0x4`、`g_zero` 的 `Ndx` 4→3、文件 `2424→2432` | 补进 1.16.2 的例题；注意文件多出的不是 4 而是 8 字节，因为节对齐重排 |

另有一条从「推断」升级为「实测」：`-nostdlib` 下调用 `printf` 的真实报错是三行（`/usr/bin/ld: ... in function '_start':`、`lab1c16_ns.c:(.text+0x10): undefined reference to 'printf'`、`collect2: error: ld returned 1 exit status`）；而**缺少 `_start` 不会让链接失败**，只报 `warning: cannot find entry symbol _start; defaulting to 000000000040010c` 并照常出产物。这条判据已写进 1.16.6 的例题解答。

顺带一条环境教训与一次自我纠正：本轮两次 ssh 会话在「运行 freestanding 程序」那一步之后就没有下文，最初我怀疑是 `ldd` 卡住，写了「`ldd` 会挂」。加了 `timeout 5` 复跑才看清真相——**卡住的是程序本身，因为它根本不会退出**，`ldd` 单独跑（`timeout 10 ldd free`）正常打印 `not a dynamic executable`。教训有两条： ssh 里跑来历不明的自写二进制一律先套 `timeout`；把现象归因之前先把它隔离出来单独跑一次，否则勘误页会写下第二个错误。

## 本章未实测项

下面这些没有本机证据支撑，引用前请当作**待验证的量级、形状或方法**，不要抄成事实：

- **所有 `perf` 读数**（1.16.9 的 `perf stat`/`perf record`）：本环境 `perf` 不可用；命令形状可照抄，数字没有。替代是 `clock_gettime(CLOCK_MONOTONIC)`/`/usr/bin/time` 计时加 `size` 与汇编对照，只报时间差与代码形状，不报 IPC、分支失败率或 cache miss。
- **Rust 侧的全部构建与运行**（1.16.3 的 `cdylib`/`staticlib`、1.16.6 的 `no_std` 静态库、1.16.7 的双向 FFI、习题 C4）：VM 没有 `rustc`/`cargo`；写作机 `rustc 1.99.1` 能编译，但产物是 Mach-O，不能与 Linux `cc`/`ld` 链接，也不能在 VM 上执行。正文给的是命令形状与判据，不是本机读数。
- **`bindgen`/`cbindgen`/`cargo bloat`/`cargo llvm-lines`**：都需要额外安装（bindgen 还需 `libclang`），本环境未确认；没有就跳过，不影响 C 组实验。
- **`LD_DEBUG`/`ldd` 的具体文本**：输出随 glibc 版本、`RUNPATH`/`RPATH`、`--as-needed` 与库版本脚本变化；正文只给行的形状与要 grep 的关键词，不抄会话记录。`LD_PRELOAD` 对带版本脚本的符号是否生效，个别加载器要求替身也带版本。
- **C1–C3 的 VM 读数**：只用 VM 确认可用的 `cc`/`ar`/`ld`/`readelf`/`nm`/`size`/`strip`/`objcopy` 设计，命令可跑；本套件写作时未在 VM 上逐条复跑，具体体积、符号数与重定位名以你机器为准（aarch64 上是 `R_AARCH64_*`，不是 `R_X86_64_*`）。
- **CSAPP 扫描版的页码**：本章只按目录与章节号核对（第 7 章链接、第 5 章优化），未把任何页码或原句当作引用依据。

## 发现新问题怎么记

按「现象 → 命令与输出 → 机器/架构/编译器/内核 → 建议改法」四段记，不要只写「我这里不对」。本章的结论大多挂在工具链与平台上，所以请一并附上：`uname -a` 与 `uname -m`；`cc --version`（以及 `gcc --version`）；`ld --version`；`rustc --version`/`cargo --version`（如果用了 Rust）；`readelf -h` 的 `Type`/`Machine`；`readelf -d` 的 `NEEDED`/`RUNPATH`；`objdump -d` 的原始几行；以及 `perf stat true` 的报错（证明是否可用）。涉及数字时写明口径：是 ELF/ABI 条款、工具输出、量级示例，还是「未实测」。本章多数分歧都出在把「`-O3` 的数字」当成跨编译器通用，或把「库存在」当成「链接顺序无所谓」。
