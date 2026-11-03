# 1.16 习题集

三组分层：**A 组概念判断**考「会读、会说理由、会把读数一层层串起来」；**B 组诊断推理**给现象让你判阶段、判契约、判修法；**C 组动手实验**在 Ubuntu 24.04 aarch64 上免 `sudo` 复现本章的关键证据。全部附解答与判据；先独立完成，再展开对照。每题的第一个动作都是「先猜」：把预期写下来，再去验证；猜错的地方才是这题的价值。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；A 组要求口述或写一段完整因果，B 组要求写成「现象 → 机制 → 证据 → 修法」四段。
2. 卡住了回对应小节的「即时自测」重读，不要直接看答案；A 组对应 1.16.1–1.16.7，B 组对应 1.16.3–1.16.10，C 组对应 1.16.3–1.16.9。
3. C 组的命令都在本书的 Ubuntu 24.04.5 虚拟机（aarch64、GCC 13.3.0、4 vCPU）上设计；临时文件统一用 `lab1c16_` 前缀，实验结束删掉。
4. **`sudo` 与 `perf` 不可用**：`cc`/`gcc`、`as`、`ar`、`ld`、`objdump`、`readelf`、`nm`、`size`、`strip`、`objcopy` 可用；`perf stat`/`perf record` 一律跳过并标「未实测」。**VM 没有 Rust 工具链**，Rust 相关步骤按 C4 的方式标「未实测 + 原因」。
5. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch16-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 1.16-A1 · 四阶段流水线与四种产物 {#ex-1.16-A1}

先猜：`cc -c` 停下来的是汇编还是目标文件？Rust 的 `--emit=obj` 之后还会调用链接器吗？

写出 C 的 `.c → .i → .s → .o → a.out` 每步的工具、输入输出与「能在这里做的检查」；再说出 Rust 侧对应的 `--emit=llvm-ir/asm/obj` 与最终链接由谁完成。解释为什么先看 `.o` 而不是 `a.out`。

::: sol 解答

工具链：`cpp`（`cc -E`）做预处理，`.c → .i`，可查宏展开、`#include`、条件编译；`cc1`（`cc -S`）编译，`.i → .s`，可查优化、内联、向量化；`as`（`cc -c`/`as`）汇编，`.s → .o`，得到 `ET_REL`，可查指令编码与重定位；`collect2` 调 `ld`（`cc`）链接，`.o` + 库 → `a.out`（`ET_EXEC`/`ET_DYN`），可查符号、GOT/PLT、段布局。`cc` 是驱动程序，`cc -v` 的最后一段能看到真正的链接命令行。Rust 侧：`rustc --emit=llvm-ir` 出 `.ll`，`--emit=asm` 出 `.s`，`--emit=obj` 出 `.o`，不带 `--emit` 时 `rustc` 在最后同样调用系统链接器（Linux 上通常是 `cc`/`ld`）。先看 `.o` 是因为它保留完整的节、符号表与重定位表，且没有经过链接器的地址分配；`a.out` 的地址已分配、`.rela.text` 已被消费，很多线索就断了。

**判据**：四步工具与产物全对；知道 `cc -E/-S/-c` 各停在哪；能说出 `.o` 是 `ET_REL`；知道 Rust 最后也走系统链接器；能解释「先 `.o` 后 `a.out`」的理由。

:::
:::

::: ex 例 1.16-A2 · ELF 的节、符号与重定位 {#ex-1.16-A2}

先猜：`.bss` 里的 64 MiB 数组会让文件大 64 MiB 吗？`-g` 才会产生符号表吗？

说明 `.text/.rodata/.data/.bss/.symtab/.dynsym/.rela.text/.rela.dyn` 各存什么、谁在什么阶段用；读出 `Bind`/`Type`/`Ndx` 三列的常见值；比较 `R_X86_64_PC32` 与 `R_X86_64_PLT32` 的出现场景与填充内容。

::: sol 解答

`.text` 指令；`.rodata` 只读常量与字符串；`.data` 已初始化全局/静态；`.bss` 未初始化/零初始化，`SHT_NOBITS`，文件里只有节头，加载时映射零页，所以 64 MiB 数组不撑大文件，只占虚拟地址空间；`.symtab`/`.strtab` 是静态符号表，可被 `strip` 删除；`.dynsym`/`.dynstr` 是动态链接必需，不能删；`.rela.text` 是代码段重定位，链接后消失；`.rela.dyn`/`.rela.plt` 由 `ld.so` 在加载或首次调用时处理。`Bind` 有 `LOCAL/GLOBAL/WEAK`，`Type` 有 `FUNC/OBJECT/NOTYPE/TLS`，`Ndx` 是节索引或 `UND`/`ABS`，具体编号用 `readelf -S` 对照。`PC32` 是 RIP 相对 32 位偏移，常见于同文件取数据/函数地址，填「目标 − 下一条指令」；`PLT32` 用于外部函数调用，填「PLT 桩 − 下一条指令」，链接器也可把它解析成直接调用。ARM64 对应 `CALL26` 与 `ADR_PREL_PG_HI21`，RISC-V 对应 `CALL_PLT` 与 `PCREL_HI20`。

**判据**：`.bss` 的 `NOBITS` 与「不占文件」说对；`.symtab` 与 `.dynsym` 的差别说对；三列取值举例正确；`PC32`/`PLT32` 的场景与填充内容不混；能说出至少一组 ARM64/RISC-V 对应重定位。

:::
:::

::: ex 例 1.16-A3 · 静态库、共享库与 SONAME {#ex-1.16-A3}

先猜：`libmath.a` 里只有 `math_sum` 被用到，链接器会把整个 `.o` 拉进来吗？`libmath.so.1` 找不到时，`libmath.so` 能顶替吗？

比较 `.a` 与 `.so` 的链接/运行时行为、体积与升级方式；解释 `SONAME`、`NEEDED`、`RUNPATH` 与符号链接链；说明为什么共享库必须 `-fPIC`，`-fPIC` 与 `-fPIE` 差在哪。

::: sol 解答

`.a` 是 `.o` 的归档，链接器按当前未定义符号抽取成员，抽中一个成员就把整个 `.o` 拉进最终文件；代码进入可执行文件，运行时无额外依赖，升级需要重新链接。`.so` 是 `ET_DYN`，链接时只记录 `NEEDED`（依赖的 `SONAME`），运行时由 `ld.so` 按 `RUNPATH`/`RPATH`、`LD_LIBRARY_PATH`、`/etc/ld.so.cache` 查找并映射；升级可以只换库文件，但要维护 ABI 版本。`SONAME` 是库的运行时身份，通常 `libmath.so.1`，文件系统里需要 `libmath.so.1.0 → libmath.so.1 → libmath.so` 的符号链接链；只有 `libmath.so` 而没有 `libmath.so.1` 时，`NEEDED libmath.so.1` 找不到。共享库加载地址不定，不能含绝对地址重定位，所以所有进 `.so` 的 `.o` 都要 `-fPIC`；`-fPIE` 是给可执行文件的对应选项，语义相近但允许针对可执行文件的优化。

**判据**：`.a` 的「按成员抽取、整个 `.o` 进入」说对；`.so` 的 `NEEDED`/`SONAME`/`RUNPATH` 分工说对；符号链接链与「只有 `.so` 不够」说对；`-fPIC` 的必要性说清；`-fPIC`/`-fPIE` 不混。

:::
:::

::: ex 例 1.16-A4 · 一次 `printf` 的 GOT/PLT 路径 {#ex-1.16-A4}

先猜：第一次调用 `printf` 和第二次调用，走的路径一样吗？`LD_BIND_NOW=1` 改变的是链接还是加载？

画出「调用点 → `.plt` → `.got.plt` → libc」；说明首次调用的解析与写回 GOT；解释 `LD_BIND_NOW=1`、`-Wl,-z,now`、`-fno-plt`、RELRO 各改哪一段。

::: sol 解答

调用点执行 `call printf@plt` 进入 `.plt` 桩；桩里第一条是 `jmp *printf@GOT(%rip)`。首次调用时 GOT 项还指向 `plt0` 的 resolver，控制流进 `ld.so` 解析出 `printf` 的真实地址并写回 GOT；之后调用直接 `jmp *GOT` 到 libc，不再进 resolver，这就是延迟绑定。`LD_BIND_NOW=1` 或链接 `-Wl,-z,now` 把策略改成加载时全部解析（更安全，启动稍慢）；`-fno-plt` 让调用点直接 `call *printf@GOT(%rip)`，省掉 PLT 一跳，但要求 GOT 可读；RELRO 在重定位完成后把 GOT 设为只读，`-Wl,-z,relro,-z,now` 是完整 RELRO，能防 GOT 劫持。`-fno-plt` 与 RELRO 不矛盾：GOT 在解析完成后只读，间接跳转仍可读。

**判据**：三段路径画对；首次/之后调用的差别说清；`LD_BIND_NOW` 定位在加载阶段；`-fno-plt` 省的是哪一跳说对；RELRO 的时机（重定位后）说对。

:::
:::

::: ex 例 1.16-A5 · `-O2`/`-O3` 与 Rust `opt-level` {#ex-1.16-A5}

先猜：同一段循环，GCC 13 的 `-O3` 与 Rust `-C opt-level=3` 生成的代码会一样吗？A 机器上 `-O3` 快 15%，能直接写进 B 机器的报告吗？

分别说出 `-O2`、`-O3`、`-Os` 与 Rust `opt-level=2/3/s` 打开/倾向什么；列出 Rust 侧额外影响产物的四个因素；说明为什么优化收益不能跨编译器、跨版本、跨架构比较。

::: sol 解答

`-O2` 打开成熟的标量优化：内联、常量传播、死代码删除、循环简化、指令调度；`-O3` 再加更激进的循环变换、循环展开与向量化；`-Os` 以体积为先，可能牺牲速度。Rust 的 `-C opt-level` 映射到 LLVM 优化管道，`2`/`3`/`s` 与 C 的档位接近但不等价。Rust 额外影响产物的因素：边界检查（安全切片在 `-O0` 保留，优化后可消除但不保证）、panic 分支与 unwind 表、别名元数据与 `noalias`、`codegen-units`（默认 16 限制跨单元内联，`1` 才最大化）。所以同一段逻辑在 GCC `-O3` 与 rustc `-C opt-level=3` 下指令序列、体积、分支布局都可能不同；优化等级只是一组 pass 的开关名，收益依源码、编译器版本、`-march`/`-mtune` 与数据规模。A 机器的 15% 只能作为该机器、该工具链、该输入的读数；换任何一项都要重测，报告里必须写明 `cc --version`、flags、`uname -m` 与输入。

**判据**：三档 C 与三档 Rust 的倾向说对；Rust 额外因素至少说出边界检查、panic、`codegen-units` 三项；明确「不可跨编译器/版本/架构比较」；给出报告应记录的元数据。

:::
:::

::: ex 例 1.16-A6 · LTO、节回收、可见性与 strip {#ex-1.16-A6}

先猜：`-flto` 之后 `nm` 看不到某个函数，是被内联、被节回收，还是被 `strip`？`strip` 会删 `.dynsym` 吗？

解释 LTO 为什么能跨文件优化、静态库为什么要 `gcc-ar`；说明 `-ffunction-sections -Wl,--gc-sections`、`-fvisibility=hidden`、版本脚本、`strip` 各删/藏什么；区分「被内联」「被节回收」「被 strip」三种「符号消失」。

::: sol 解答

LTO 把 IR 保留到链接阶段，链接器调用 LTO 插件看到整个程序，因此能做跨文件内联、常量传播与 DCE；代价是链接变慢、内存上升、工具链必须匹配。静态库若装 LTO 对象，归档工具要认识这种成员，所以用 `gcc-ar`/`gcc-ranlib`，否则报 `plugin needed to handle lto object`。`-ffunction-sections -fdata-sections` 让每个函数/数据独立成节，`--gc-sections` 删未引用节；`-fvisibility=hidden` 把默认可见性改为隐藏，只导出显式标记的符号；版本脚本用 `global`/`local` 精确控制 ABI；`strip` 默认删 `.symtab` 与 `.debug_*`，保留 `.dynsym`。三种「符号消失」的区分：被内联看调用点是否展开、`readelf -sW` 是否还有该符号；被节回收看对应节是否还在（`readelf -SW`，配合 `-ffunction-sections`）；被 strip 看 `.symtab` 是否还在，代码本身不变（`objdump -d` 仍能看到指令）。`strip` 后 `backtrace` 仍能工作，是因为 `.eh_frame` 与独立 debug 文件还在。

**判据**：LTO 机制与 `gcc-ar` 的关系说对；四种裁剪手段的作用对象说对；三种「符号消失」各有验证方法；`strip` 不删 `.dynsym`；能说出独立 debug 文件的作用。

:::
:::

## B 组 · 诊断推理

::: ex 例 1.16-B1 · 库明明存在，却报 `undefined reference` {#ex-1.16-B1}

先猜：`cc -L. -lmath main.o -o app` 失败，是库没编出来，还是命令行顺序？

一个项目里 `libmath.a` 就在当前目录，`main.o` 也编好了，执行 `cc -L. -lmath main.o -o app` 报 `undefined reference to math_sum`；把 `main.o` 移到 `-lmath` 前面就好了。写出「现象 → 机制 → 证据 → 修法」四段，并说明两个静态库互相依赖时怎么办。

::: sol 解答

现象：库文件存在、路径也对，但链接器说 `math_sum` 未定义；调换顺序后同一组文件链接成功。机制：传统 `ld` 对命令行做单遍扫描，按出现顺序处理；遇到 `-lmath` 时还没有任何未定义符号需要它，归档成员一个都不抽取；随后处理 `main.o` 才产生对 `math_sum` 的引用，但 `libmath.a` 已经扫过，不会回头。静态库按「当前未定义符号」抽取成员，顺序因此是语义的一部分。证据：失败与成功的两条命令行只差参数顺序；`cc -Wl,--trace-symbol=math_sum ...` 能看到符号在何时被引用/定义；`nm main.o` 显示 `U math_sum`。修法：把库放在引用它的目标文件之后；两个静态库互相依赖时，重复列出它们，或用 `-Wl,--start-group liba.a libb.a -Wl,--end-group` 让链接器反复扫描直到没有新符号；`--whole-archive` 是「全量拉入」，解决的是另一类问题，代价是体积。共享库也受顺序影响：Ubuntu 默认 `--as-needed` 会把「未被需要」的 `-l` 丢掉。

**判据**：定位到命令行顺序而非库缺失；说清「单遍扫描 + 按需抽取」；给出 `U`/`--trace-symbol` 一类证据；修法包含「库放后面」与 `--start-group`；不把 `--whole-archive` 当成通用解。

:::
:::

::: ex 例 1.16-B2 · `cannot open shared object file` 与空 `RUNPATH` {#ex-1.16-B2}

先猜：`readelf -d` 里明明有 `RUNPATH`，为什么运行时还说找不到库？

`app-dynamic` 编译时用了 `-Wl,-rpath,$ORIGIN`，`readelf -d` 显示 `RUNPATH` 为空串，运行时 `./app-dynamic` 报 `error while loading shared libraries: libmath.so.1: cannot open shared object file`。写出四段分析：`$ORIGIN` 为什么变空？SONAME 与符号链接链哪里可能断？按什么顺序排查？

::: sol 解答

现象：`readelf -d app-dynamic` 有 `RUNPATH` 条目但值为空；`ldd` 显示 `libmath.so.1 => not found`；程序起不来。机制：`$ORIGIN` 在 shell 里是变量，双引号或不加引号会被展开成空串，链接器收到的是 `-rpath,`；正确写法是单引号 `-Wl,-rpath,'$ORIGIN'`，让字面量 `$ORIGIN` 进动态段。另一个来源是 SONAME 与文件名不一致：`NEEDED` 记录 `libmath.so.1`，但目录里只有 `libmath.so`，没有 `libmath.so.1` 的符号链接。证据：`readelf -dW app-dynamic | grep -E 'NEEDED|RPATH|RUNPATH'`；`ls -l libmath.so*` 看链接链；`ldd ./app-dynamic` 看解析结果；`LD_DEBUG=libs ./app-dynamic` 看搜索路径。修法：单引号包住 `$ORIGIN`；补齐 `libmath.so.1.0 → libmath.so.1 → libmath.so`；或把库装到系统目录并 `ldconfig`，临时用 `LD_LIBRARY_PATH`；最后用 `readelf -d` 确认 `RUNPATH` 非空。

**判据**：定位到 shell 展开或 SONAME/链接链；说清 `$ORIGIN` 的单引号；给出 `readelf -d`/`ldd`/`LD_DEBUG=libs` 证据；修法不只用 `LD_LIBRARY_PATH` 兜底；知道 `RUNPATH` 优先于 `LD_LIBRARY_PATH`、`RPATH` 更早。

:::
:::

::: ex 例 1.16-B3 · 共享库报 `relocation ... can not be used when making a shared object` {#ex-1.16-B3}

先猜：这条报错是链接器版本太老，还是某个 `.o` 没编成位置无关？

把 `mathlib.o`（没加 `-fPIC`）直接 `cc -shared` 成 `.so`，报 `relocation R_AARCH64_ADR_PREL_PG_HI21 against symbol ... can not be used when making a shared object; recompile with -fPIC`（x86-64 上是 `R_X86_64_32`/`R_X86_64_PC32` 一类）。写出四段分析：为什么绝对/非 PIC 重定位不能进共享库？`-fPIC` 与 `-fPIE` 怎么选？已有 `.o` 怎么补救？

::: sol 解答

现象：`cc -shared mathlib.o -o libmath.so` 失败，报错点名某个重定位类型并提示 `recompile with -fPIC`；同一份源码加上 `-fPIC` 重编就好了。机制：共享库要被映射到任意地址，代码里不能出现「链接时写死、加载后不改」的绝对地址；`-fPIC` 让编译器通过 GOT/PLT 或 PC 相对寻址访问外部符号与全局数据，生成可重定位的重定位类型。没加 `-fPIC` 的 `.o` 可能带绝对地址重定位，链接器无法在共享库里安全解析。证据：报错行点名重定位类型与符号；`readelf -rW mathlib.o` 能看到该重定位；对同一源码分别 `-fPIC`/不加编译，比较 `readelf -rW` 与反汇编（有无经 GOT 的间接访问）。修法：所有进入 `.so` 的目标文件统一 `-fPIC` 重编；可执行文件用 `-fPIE`（发行版默认 PIE），不要把 `-fPIE` 的目标文件塞进共享库；已经编好的 `.o` 无法补救，只能重编。注意 `-fPIC` 略增代码与寄存器压力，但这是共享库的必要成本。

**判据**：定位到「目标文件不是 PIC」而非链接器 bug；说清绝对地址与加载地址不定的矛盾；`-fPIC`/`-fPIE` 的适用对象说对；修法是重编而非改链接参数；能给出 `readelf -rW` 证据。

:::
:::

::: ex 例 1.16-B4 · `-O3` 反而更慢，且数字对不上同事的机器 {#ex-1.16-B4}

先猜：同事在 x86-64 上用 clang `-O3` 测得快 20%，你在 aarch64 上用 GCC 13 `-O3` 测得慢 5%，谁错了？

同一段求和循环，同事报告 clang 18 `-O3` 比 `-O2` 快 20%；你在 VM 上用 GCC 13.3 `-O3` 反而慢 5%，且 `size` 变大。写出四段分析：哪些因素导致差异？怎样在同一环境内做可信比较？`perf` 不可用时用什么证据？

::: sol 解答

现象：同一份源码，两套工具链给出相反结论；`-O3` 版本体积更大、耗时略高。机制：`-O3` 只是打开更激进的 pass（向量化、展开、更多内联），是否收益取决于源码形状、数据规模、编译器版本、目标 ISA 与 `-march`/`-mtune`；向量化可能增加代码体积、降低 I-cache 命中，分支多的代码还可能因展开变差。clang 与 GCC 的 pass 集合与代价模型不同，x86-64 与 aarch64 的向量宽度、指令延迟也不同，所以 20% 与 -5% 可以同时为真。证据：`size`/`readelf -SW` 看 `.text` 变化；`objdump -d` 对比循环是否被展开/向量化；`clock_gettime(CLOCK_MONOTONIC)` 或 `/usr/bin/time` 计时，固定输入、多次取中位数；记录 `cc --version`、完整 flags、`uname -m`。修法：只在同编译器、同版本、同架构、同输入内比较；先 `-O2` 建立基线，再逐项加 `-O3`/`-march`/LTO/PGO，每次只改一个变量；`perf` 不可用时只报时间差与代码形状，不报 IPC/miss。

**判据**：不判「谁错」，而是指出工具链/架构/输入不可比；列出至少三个影响因素；给出同环境比较方法与元数据；知道 `perf` 不可用时降级为计时 + `size` + 汇编，不编造读数。

:::
:::

::: ex 例 1.16-B5 · C 链接 Rust 库，报 `undefined reference to math_sum` {#ex-1.16-B5}

先猜：Rust 函数写了 `pub extern "C" fn math_sum`，C 就能按 `math_sum` 找到它吗？

Rust 侧写了 `pub extern "C" fn math_sum(...)` 并编成 `staticlib`，C 侧声明 `extern long math_sum(...)`，链接报 `undefined reference to math_sum`；`nm librustffi.a` 里只有 `_ZN...` 或 `_R...` 开头的符号。写出四段分析：符号名被谁改了？`#[no_mangle]` 与 `pub` 各管什么？为什么 `cdylib` 有时又「看起来能用」？

::: sol 解答

现象：Rust 库编出来了，C 链接却找不到 `math_sum`；`nm` 里是 `_ZN...`（legacy）或 `_R...`（v0）的 mangled 名。机制：Rust 默认对符号做 name mangling，把模块路径、泛型参数、crate 信息编码进符号名，以避免冲突；`extern "C"` 只改调用约定与 ABI，不改符号名；`pub` 只控制 Rust 可见性，不控制导出名。`#[no_mangle]` 才是「不要改名」，让符号在目标文件里就叫 `math_sum`；`cdylib` 会导出 `#[no_mangle] pub extern "C"` 的符号，所以有时 `nm -D` 能看到，但若漏了 `#[no_mangle]` 或符号被 LTO/strip 处理，`nm -D` 也会空。证据：`nm librustffi.a | grep -E 'math_sum|_ZN|_R'`；`nm -D --defined-only lib.so`；`readelf -sW` 看 `Bind`/`Type`。修法：导出函数写 `#[no_mangle] pub extern "C"`（Rust 2024 edition 起写 `#[unsafe(no_mangle)]`）；确认 `crate-type` 包含 `staticlib` 或 `cdylib`；用 `-C symbol-mangling-version=v0` 观察名字变化；链接后 `nm` 复核。C++ 侧的 `extern "C"` 解决的也是同一类问题。

**判据**：定位到 name mangling 而非链接顺序；`#[no_mangle]`/`extern "C"`/`pub` 三者分工说对；给出 `nm` 证据；知道 2024 edition 的 `#[unsafe(no_mangle)]`；不把「`cdylib` 能导出」当成「不用 `#[no_mangle]`」。

:::
:::

::: ex 例 1.16-B6 · `panic=abort` 后 `catch_unwind` 捕获不到 {#ex-1.16-B6}

先猜：库编成 `panic=abort` 后，边界内的 `catch_unwind` 还能把 panic 变成 `Err` 吗？C 调用方会看到什么？

一个 Rust 库用 `panic="abort"` 发布，C 程序在 `extern "C"` 边界内用 `catch_unwind` 包住调用；某次输入触发 panic，进程直接终止而不是返回错误。写出四段分析：abort 与 unwind 的差别？panic 跨 `extern "C"` 为什么是 UB？库作者与调用方各该怎么设计？

::: sol 解答

现象：panic 发生时进程立刻 `abort`，`catch_unwind` 没有返回 `Err`；C 侧看不到可控错误。机制：`panic=abort` 策略下 panic 直接终止进程，不展开栈，`catch_unwind` 依赖的 unwind 机制不存在，因此捕获不到；`Drop` 也不保证执行。即使使用 unwind，panic 跨 `extern "C"` 边界仍是未定义行为，因为 C 没有 unwind 语义；要传播必须两边都支持，用 `extern "C-unwind"`。证据：`readelf -SW` 看 `.eh_frame`/`.gcc_except_table` 是否存在；同一代码用 unwind 与 abort 各构建一次，跑触发 panic 的用例，观察「进程终止」与「返回 Err」；`nm`/`size` 看 unwind 相关符号与体积。修法：库不要依赖调用方 unwind；FFI 边界内用 `catch_unwind`（在 unwind 构建下）把 panic 转成错误码，或统一 `panic=abort` 并在 C 侧按「进程会死」设计；需要跨语言传播时用 `extern "C-unwind"` 并确认两边运行时支持。`#[should_panic]` 测试在 abort 下也失效。

**判据**：说清 abort 不展开栈、`catch_unwind` 捕不到；指出 panic 跨 `extern "C"` 是 UB；`extern "C-unwind"` 的条件说对；给出 `.eh_frame`/构建对比证据；修法区分「库」与「调用方」。

:::
:::

## C 组 · 动手实验

::: ex 例 1.16-C1 · 构建 `.a` 与带 SONAME 的 `.so`，串起 GOT/PLT 四层读数 {#ex-1.16-C1}

先猜：`readelf -d app-dynamic` 里 `NEEDED` 写的是 `libmath.so` 还是 `libmath.so.1`？`LD_PRELOAD` 一个同名 `math_sum` 后，输出里的 `sum` 会变成多少？

按 1.16.3 建 `libmath.a` 与 `libmath.so.1.0`，链接 `app-dynamic`/`app-archive`，用 `readelf -d`、`readelf -r`、`objdump -d -j .plt`、`LD_DEBUG=bindings` 取证；再用 `LD_PRELOAD` 把 `math_sum` 换成固定返回值。

::: sol C1 核对

```bash
mkdir -p ~/lab1c16_work && cd ~/lab1c16_work
cat > mathlib.h <<'EOF'
#ifndef MATHLIB_H
#define MATHLIB_H
#include <stddef.h>
struct pair { long a; long b; };
long math_sum(const long *xs, size_t n);
long math_dot(const long *a, const long *b, size_t n);
const char *math_version(void);
#endif
EOF
cat > mathlib.c <<'EOF'
#include "mathlib.h"
long math_sum(const long *xs, size_t n)
{ long s = 0; for (size_t i = 0; i < n; i++) s += xs[i]; return s; }
long math_dot(const long *a, const long *b, size_t n)
{ long s = 0; for (size_t i = 0; i < n; i++) s += a[i] * b[i]; return s; }
const char *math_version(void) { return "mathlib 1.0"; }
EOF
cat > main.c <<'EOF'
#include <stdio.h>
#include "mathlib.h"
int main(void)
{
    long a[] = {1, 2, 3, 4};
    long b[] = {10, 20, 30, 40};
    printf("%s: sum=%ld dot=%ld\n", math_version(),
           math_sum(a, 4), math_dot(a, b, 4));
    return 0;
}
EOF
cat > mathlib.map <<'EOF'
MATHLIB_1.0 {
    global:
        math_sum;
        math_dot;
        math_version;
    local:
        *;
};
EOF
cc -std=c17 -D_GNU_SOURCE -O2 -Wall -Wextra -Werror -fPIC -c mathlib.c -o mathlib.o
ar rcs libmath.a mathlib.o
cc -shared -Wl,-soname,libmath.so.1 \
   -Wl,--version-script=mathlib.map mathlib.o -o libmath.so.1.0
ln -sf libmath.so.1.0 libmath.so.1
ln -sf libmath.so.1 libmath.so
cc -std=c17 -D_GNU_SOURCE -O2 -Wall -Wextra -Werror main.c \
   -L. -lmath -Wl,-rpath,'$ORIGIN' -o app-dynamic
cc -std=c17 -D_GNU_SOURCE -O2 -Wall -Wextra -Werror main.c libmath.a -o app-archive
./app-dynamic && ./app-archive
readelf -d app-dynamic | grep -E 'NEEDED|RPATH|RUNPATH|SONAME'
readelf -rW app-dynamic | grep -E 'JUMP_SLOT|GLOB_DAT|RELATIVE' | head
objdump -d -j .plt app-dynamic | sed -n '1,20p'
LD_DEBUG=bindings ./app-dynamic 2>&1 | grep -E 'math_(sum|dot|version)' | head
```

预期形状（aarch64 上，以你机器输出为准）：两版程序都打印 `mathlib 1.0: sum=10 dot=300`；`readelf -d` 有 `NEEDED libmath.so.1` 与 `RUNPATH $ORIGIN`（老链接器可能是 `RPATH`）；`readelf -r` 里 `math_sum` 是 `R_AARCH64_JUMP_SLOT`（x86-64 是 `R_X86_64_JUMP_SLOT`）；`.plt` 里能看到 `adrp`/`ldr` 加 `br` 的桩，x86-64 上是 `jmp *...@GOTPCREL(%rip)`；`LD_DEBUG=bindings` 出现 `binding file ... to ...: normal symbol 'math_sum'` 一类行。

打桩：

```bash
cat > interpose.c <<'EOF'
#include <stddef.h>
long math_sum(const long *xs, size_t n)
{ (void)xs; (void)n; return 999; }
EOF
cc -shared -fPIC -O2 -Wall -Wextra -Werror interpose.c -o libinterpose.so
LD_PRELOAD=./libinterpose.so ./app-dynamic
```

预期 `mathlib 1.0: sum=999 dot=300`。若库用版本脚本绑定到 `MATHLIB_1.0`，个别加载器要求替身也带版本，此时用 `.symver` 或给替身加版本脚本；以你机器为准。

**判据**：两版输出都是 `sum=10 dot=300`；`NEEDED` 是 `libmath.so.1` 而非 `libmath.so`；`RUNPATH` 是字面量 `$ORIGIN`；能指出动态重定位类型与 PLT 桩形状；`LD_PRELOAD` 后 `sum=999` 而 `dot` 不变；能解释「绑定发生在运行时」。无需 `sudo`；本套件未在 VM 上逐条复跑，读数以你机器为准。

:::
:::

::: ex 例 1.16-C2 · 链接顺序与 `--start-group` {#ex-1.16-C2}

先猜：`cc main.c libb.a liba.a` 与 `cc main.c liba.a libb.a`，哪条会报 `undefined reference`？`--start-group` 能救哪一条？

构造两个互相依赖的静态库 `liba.a`（`fa` 调 `fb`）与 `libb.a`（`fb` 调 `fa`），先用错误顺序链接看报错，再用 `-Wl,--start-group ... --end-group` 修好；运行确认结果。

::: sol C2 核对

```bash
cd ~/lab1c16_work
cat > a.c <<'EOF'
extern int fb(int);
int fa(int x) { return fb(x) + 1; }
EOF
cat > b.c <<'EOF'
extern int fa(int);
int fb(int x) { return x > 0 ? fa(x - 1) + 1 : 0; }
EOF
cat > cyc_main.c <<'EOF'
#include <stdio.h>
extern int fa(int);
int main(void) { printf("%d\n", fa(3)); return 0; }
EOF
cc -std=c17 -Wall -Wextra -Werror -c a.c -o a.o
cc -std=c17 -Wall -Wextra -Werror -c b.c -o b.o
ar rcs liba.a a.o
ar rcs libb.a b.o
# 错误顺序：先扫 libb.a 时没人需要 fb，b.o 不被抽取
cc cyc_main.c libb.a liba.a -o cyc_bad 2>&1 | tail -5
# 正确顺序：main 需要 fa，先抽 a.o；a.o 需要 fb，再抽 b.o
cc cyc_main.c liba.a libb.a -o cyc_ok && ./cyc_ok
# 循环依赖：组内反复扫描
cc cyc_main.c -Wl,--start-group libb.a liba.a -Wl,--end-group -o cyc_group && ./cyc_group
```

预期：`cyc_bad` 链接失败，报 `undefined reference to 'fb'`（报错符号以你机器为准）；`cyc_ok` 与 `cyc_group` 都成功，输出 `7`。`--start-group`/`--end-group` 让链接器在组内反复扫描，直到没有新符号被解析；代价是链接变慢，组不宜过大。`--whole-archive` 会把所有成员无条件拉入，能绕过顺序问题但会膨胀产物，不是同一件事。

**判据**：能复现错误顺序的 `undefined reference`；说清「先扫的归档没被需要就不抽取」；`--start-group` 位置正确（包住互相依赖的库）；两版输出都是 `7`；能区分 `--start-group` 与 `--whole-archive`。无需 `sudo`。

:::
:::

::: ex 例 1.16-C3 · LTO、`--gc-sections` 与 strip 的体积/符号 {#ex-1.16-C3}

先猜：`-flto` 之后 `nm` 里的符号会变多还是变少？`strip --strip-all` 之后 `readelf -SW` 里 `.dynsym` 还在吗？

用同一份 `lto_a.c` 分别做普通 `-O2`、`-flto=auto`、`-ffunction-sections -fdata-sections -Wl,--gc-sections` 构建，比较 `size` 与 `nm` 符号数；再复制一份 `strip --strip-all`，用 `readelf -SW` 与 `nm` 看删了什么；最后用 `objcopy --only-keep-debug` + `--add-gnu-debuglink` 保留调试信息。

::: sol C3 核对

```bash
cd ~/lab1c16_work
cat > lto_a.c <<'EOF'
#include <stdio.h>
static inline long helper(long x) { return x * 2 + 1; }
long compute(long x) { return helper(x) + helper(x + 1); }
int main(void) { printf("%ld\n", compute(20)); return 0; }
EOF
cc -std=c17 -D_GNU_SOURCE -O2 -Wall -Wextra -Werror lto_a.c -o no-lto
cc -std=c17 -D_GNU_SOURCE -O2 -Wall -Wextra -Werror -flto=auto lto_a.c -o with-lto
cc -std=c17 -D_GNU_SOURCE -O2 -Wall -Wextra -Werror \
   -ffunction-sections -fdata-sections -Wl,--gc-sections lto_a.c -o gc-sections
size no-lto with-lto gc-sections
nm no-lto | grep -E 'helper|compute' || true
nm with-lto | grep -E 'helper|compute' || true
echo "symbols: $(nm no-lto | wc -l) -> $(nm with-lto | wc -l)"
cp with-lto with-lto.stripped
strip --strip-all with-lto.stripped
readelf -SW with-lto.stripped | grep -E 'symtab|dynsym|debug' || true
nm with-lto.stripped 2>&1 | head -3
objcopy --only-keep-debug with-lto with-lto.debug
objcopy --add-gnu-debuglink=with-lto.debug with-lto.stripped
readelf -SW with-lto.stripped | grep -E 'gnu_debuglink|symtab|debug' || true
```

预期形状（以你机器输出为准）：三个程序都打印 `41`；`size` 的 `text` 列三者接近，LTO/gc 版通常不更大，可能更小；`helper` 是 `static inline`，`-O2` 下就可能被内联，`nm` 里看不到它，`compute` 是否保留取决于是否被内联；`with-lto` 的符号总数通常少于 `no-lto`（内联/DCE 删本地符号），但这不是固定值；`strip --strip-all` 后 `.symtab` 与 `.debug_*` 消失，`.dynsym` 仍在（动态链接需要），`nm` 报 `no symbols`；`--add-gnu-debuglink` 后出现 `.gnu_debuglink` 节。`--gc-sections` 只有配合 `-ffunction-sections`/`-fdata-sections` 才有效，否则节粒度不够，删不动。

**判据**：三个程序都输出 `41`；能读出 `size` 的 `text`/`data`/`bss` 列；知道符号数变化不是单调指标；`strip` 后 `.symtab` 消失、`.dynsym` 保留；能指出 `.gnu_debuglink` 的作用；不把「符号少了」直接判成 bug。无需 `sudo`。

:::
:::

::: ex 例 1.16-C4 · Rust `no_std` 静态库被 C 调用（未实测） {#ex-1.16-C4}

先猜：`#![no_std]` 的 `staticlib` 里，`no_std_add` 在 `nm` 里是 `T` 还是 `U`？不写 `-C panic=abort` 会缺什么符号？

按 1.16.6 写 `nostd.rs` 与 `nostd_c.c`，用 `rustc --crate-type staticlib -C panic=abort -C opt-level=2` 生成 `libnostd.a`，再让 `cc` 链接运行；用 `nm` 看符号、`readelf -h` 看产物类型。

::: sol C4 核对

```bash
cd ~/lab1c16_work
cat > nostd.rs <<'EOF'
#![no_std]
use core::panic::PanicInfo;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! { loop {} }

#[no_mangle]
pub extern "C" fn no_std_add(a: i32, b: i32) -> i32 { a.wrapping_add(b) }
EOF
cat > nostd_c.c <<'EOF'
#include <stdint.h>
#include <stdio.h>
extern int32_t no_std_add(int32_t a, int32_t b);
int main(void) { printf("no_std_add=%d\n", no_std_add(20, 22)); return 0; }
EOF
rustc --edition 2021 --crate-type staticlib \
      -C panic=abort -C opt-level=2 nostd.rs -o libnostd.a
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror nostd_c.c libnostd.a -o nostd_c
./nostd_c
nm libnostd.a | grep no_std_add
readelf -h nostd_c | grep Type
```

**未实测 + 原因**：本书 VM 没有 Rust 工具链（`rustc`/`cargo` 均不在），上述两条构建命令无法在 VM 上执行，因此没有本机读数。写作机有 `rustc 1.99.1`，`--crate-type staticlib` 能编出归档，但其中是 **Mach-O 对象**，不是 Linux ELF；VM 的 `cc`/`ld` 不能链接它，macOS 也不能运行 Linux 可执行文件，所以「链接 + 运行」这一步在写作机同样不可完成。若你的机器装有 Linux 版 rustc，按上面命令应得到：程序打印 `no_std_add=42`；`nm libnostd.a` 里 `no_std_add` 是 `T`（已定义于 text）；`readelf -h nostd_c` 的 `Type` 是 `EXEC` 或 `DYN`（取决于 PIE 默认）。不写 `-C panic=abort` 时，静态库可能带入 unwind 运行时与 `eh_personality` 依赖，C 链接器不一定提供对应符号，可能出现未定义符号或 panic 行为未定义。

**判据**：如实区分「命令形状」与「本机读数」；能解释 `T` 与 `U` 的差别；说清 `panic=abort` 去掉的是哪类依赖；明确 VM 无 Rust 工具链、写作机产物是 Mach-O；不编造 `42` 或 `nm` 输出。若环境具备而你没跑，也要写明「未实测」。

:::
:::
