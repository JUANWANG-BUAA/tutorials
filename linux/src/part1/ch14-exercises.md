# 1.14 习题集

三组分层：**A 组概念判断**考「会读、会算、会说理由」；**B 组诊断推理**给现象让你判契约、栈帧、cache 与系统调用；**C 组动手实验**在 Ubuntu 24.04 aarch64 上免 `sudo` 复现本章的关键证据。全部附解答与判据；先独立完成，再展开对照。每题的第一个动作都是「先猜」：把预期写下来，再去验证；猜错的地方才是这题的价值。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；A 组要求口述或写一段完整因果，B 组要求写成「现象 → 机制 → 证据 → 修法」四段。
2. 卡住了回对应小节的「即时自测」重读，不要直接看答案；A 组对应 1.14.1–1.14.13，B 组对应 1.14.4–1.14.14，C 组对应 1.14.11–1.14.15。
3. C 组的命令都在本书的 Ubuntu 24.04.5 虚拟机（aarch64、内核 7.0.0-38-generic、GCC 13.3.0、4 vCPU）上设计；临时文件统一用 `lab1c14_` 前缀，实验结束删掉。
4. **`sudo` 不可用**：`cc`/`gcc`、`as`、`objdump`、`readelf`、`getconf` 可用；**`perf` 不可用**，所以涉及 `perf stat`、`perf c2c` 的步骤一律跳过并标「未实测」。`qemu-aarch64`、`qemu-riscv64`、交叉 gcc、`llvm-mc` 是否安装未在本环境确认，C 组不依赖它们；需要时先 `command -v` 再决定，没有就标未实测。
5. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch14-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 1.14-A1 · 四层契约：ISA、ABI、内核 ABI、微架构 {#ex-1.14-A1}

先猜：同一段 C 在 x86-64 与 ARM64 上「加法语义」一样吗？如果一样，为什么汇编完全不能互搬？

把「寄存器名字、参数放哪、`write` 的号、分支预测器」四件事分别归到 ISA、ABI、内核 ABI、微架构四层，并各给一个「换层就失效」的例子。再说清 `sum3` 的三套汇编差异到底属于哪一层。

::: sol 解答

加法语义是 ISA 层承诺的：`add` 做整数加法，结果一样，所以同一段 C 的**行为**一样。不能互搬是因为另外三层不同。四层：**ISA**——寄存器集合与位宽、指令编码、特权指令、内存模型、异常入口；**ABI**——哪些寄存器传参/返回、谁保存、栈对齐、红区、结构体分类；**内核 ABI**——系统调用号、陷入指令、参数寄存器、返回值 `-errno`；**微架构**——流水线深度、乱序窗口、cache 大小、分支预测器，不承诺兼容，只影响性能。换层失效的例子：ISA 层，`mov $1,%rax` 在 ARM64 上没有 `%rax`；ABI 层，x86 第 7 个参数在栈上，ARM64 第 7 个在 `x6`；内核 ABI 层，`write` 在 x86 是 1、ARM64 是 64；微架构层，同一段指令在两种核上的 CPI 不同，但结果相同。`sum3` 的差异属于 ABI：参数 `rdi/rsi/rdx` 对 `x0/x1/x2` 对 `a0/a1/a2`，返回值 `rax` 对 `x0` 对 `a0`，返回地址栈对 `x30` 对 `ra`；指令条数都是 3，说明 ISA 的算术部分没变。

**判据**：四层名称与归属正确；能指出「ISA 保证语义、ABI 保证调用、内核 ABI 保证陷入、微架构只影响性能」；每个例子能说出「换到哪层就失效」；不把系统调用号说成 ISA 的一部分。

:::
:::

::: ex 例 1.14-A2 · `sum3` 的三套汇编、字节数与三种 `ret` {#ex-1.14-A2}

先猜：三套都是 3 条指令，字节数会一样吗？如果不一样，差在哪？

写出 `long sum3(long a,long b,long c)` 在三套 ISA 上的汇编，标出每条指令的字节数；解释 x86 版本为什么只用 8 字节，而 ARM64 要 12 字节。三种 `ret` 各做什么？RISC-V 的 `ret` 为什么是伪指令？

::: sol 解答

x86-64：`lea (%rdi,%rsi),%rax`（4 字节）、`add %rdx,%rax`（3 字节）、`ret`（1 字节），共 8 字节。ARM64：`add x0,x0,x1`、`add x0,x0,x2`、`ret`，每条 4 字节，共 12 字节。RISC-V：`add a0,a0,a1`、`add a0,a0,a2`、`ret`，每条 4 字节，共 12 字节；默认 `rv64gc` 含 C 扩展时压缩成 6 字节。x86 短在三处：变长编码让常用指令只占 1–4 字节；`lea` 一条就完成 `a+b`（ARM/RISC-V 需要先 `add` 再 `add`，但这里其实是三条对三条，真正的差别是每条 4 字节固定宽度）；两操作数形式让结果直接落回目标寄存器。三种 `ret`：x86 从栈顶弹出返回地址到 `rip`；ARM64 跳到 `x30`（LR）；RISC-V 的 `ret` 是伪指令，展开成 `jalr x0, 0(ra)`，`x0` 作为目的寄存器表示丢弃返回地址。RISC-V 用伪指令是为了让汇编可读，机器码里没有独立的 `ret` 操作码。

**判据**：三套汇编的寄存器与顺序正确；字节数 8/12/12（RVC 6）说对；能指出 x86 的变长与两操作数、ARM/RISC-V 的定长是三处主因；三种 `ret` 的语义说清；知道 `ret` 在 RISC-V 上是伪指令。

:::
:::

::: ex 例 1.14-A3 · 手算频率上限与功耗 {#ex-1.14-A3}

先猜：把电压从 1.0 V 降到 0.85 V，动态功耗会降多少？频率能保持不变吗？

一个核 `T_cq=25 ps`、关键路径 15 级 FO4（每级 9 ps）、连线 35 ps、`T_setup=20 ps`、skew 12 ps、jitter 8 ps：`T_clk` 下限与 `f_max` 各是多少？若 `α=0.12`、`C_eq=150 nF`、`V=1.0 V`、`f=3.2 GHz`，动态功耗多少？漏电占 20% 时总功耗多少？电压降到 0.85 V、频率降到 2.9 GHz 后，动态功耗与总功耗（漏电不变）各是多少？

::: sol 解答

`T_clk ≥ 25 + 15×9 + 35 + 20 + 12 + 8 = 25 + 135 + 35 + 20 + 12 + 8 = 235 ps`，`f_max ≤ 1/235 ps ≈ 4.26 GHz`。动态功耗 `P_dyn = α C_eq V² f = 0.12 × 150 nF × 1² × 3.2 GHz = 57.6 W`。漏电占 20% 表示 `P_dyn` 是总功耗的 80%，总功耗 `57.6 / 0.8 = 72 W`，漏电 14.4 W。降到 0.85 V、2.9 GHz：`P_dyn = 57.6 × 0.85² × (2.9/3.2) ≈ 57.6 × 0.7225 × 0.90625 ≈ 37.7 W`；总功耗 `37.7 + 14.4 = 52.1 W`，比原来低约 28%。注意这里能同时降压降频，是因为放弃了 3.2 GHz；若想保持 3.2 GHz 只降压，`f_max` 会先撑不住——降压与提频不能同时要。

**判据**：`T_clk` 六项相加得 235 ps；`f_max` 在 4.2–4.3 GHz 之间；动态功耗 57.6 W、总功耗 72 W；降压降频后动态约 37.7 W、总约 52 W；能说出 `V²` 缩放与「降压不提频」的因果关系；不把 TDP 当最大功耗。

:::
:::

::: ex 例 1.14-A4 · 200 条指令的 CPI：表值与有限 `n` 的差别 {#ex-1.14-A4}

先猜：正文的 CPI 表说 95% 准确率时总 CPI 是 1.15；对 200 条指令，实际周期数会是 230 吗？

5 级流水、200 条指令、无停顿的周期数与 CPI 各是多少？分支占 20%、误预测惩罚 15 拍，准确率 99%/95%/90%/80% 时，分别算「填充 + 分支停顿」的精确周期数、CPI 与相对非流水线（每条 5 拍）的加速比。正文表里的 1.03/1.15/1.30/1.60 与你的结果差在哪，为什么？

::: sol 解答

无停顿：`5 + 199 = 204` 周期，CPI `204/200 = 1.02`；非流水线 `200×5 = 1000` 周期，加速 `1000/204 ≈ 4.90`。分支额外 CPI = `0.20 × (1−准确率) × 15`。99%：0.03，周期 `204 + 6 = 210`，CPI 1.05，加速 4.76；95%：0.15，周期 `204 + 30 = 234`，CPI 1.17，加速 4.27；90%：0.30，周期 `204 + 60 = 264`，CPI 1.32，加速 3.79；80%：0.60，周期 `204 + 120 = 324`，CPI 1.62，加速 3.09。正文表的 1.03/1.15/1.30/1.60 是 `1 + 额外 CPI` 的**渐近值**，忽略了 `k−1 = 4` 拍的填充/排空；`n` 很大时（1000 条）填充只占 0.4%，表值够用；`n=200` 时填充占 2%，所以精确 CPI 比表值高 0.02。这不是表错，是「CPI 表默认 `n→∞`」的口径问题；答题时写清用的是哪一种。

**判据**：204 与 1.02 算对；四个额外 CPI 0.03/0.15/0.30/0.60 与周期 210/234/264/324 对应；加速比在 4.76/4.27/3.79/3.09 附近；能指出表值是渐近值、有限 `n` 要加填充；不把「CPI 1.15」直接乘 200 当成 230 而不说明口径。

:::
:::

::: ex 例 1.14-A5 · 64 KiB、4 路、64 B 的拆分与 AMAT {#ex-1.14-A5}

先猜：相联度从 8 路降到 4 路，组数是变多还是变少？要多少个同组流才会开始抖动？

L1D 为 64 KiB、4 路组相联、块 64 B、虚拟地址 48 位：组数、offset、index、tag 各多少位？地址 `0x0000_7fff_1234_5678` 的 offset、index、tag 各是什么？几个相距 4 KiB 的数组同时扫描会让这一组开始抖动？按 L1 4 拍/局部缺失 5%、L2 12 拍/20%、L3 40 拍/10%、DRAM 200 拍算 AMAT；把 L1 缺失率降到 2% 后是多少？

::: sol 解答

组数 `64 KiB / (4 × 64 B) = 256`；offset `log2 64 = 6`；index `log2 256 = 8`；tag `48 − 6 − 8 = 34`。地址低 14 位是 `0x1678`：offset `0x678 & 0x3f = 0x38`（56）；index `(0x678 >> 6) & 0xff = 25`；tag `0x7fff12345678 >> 14 = 0x1fffc48d1`。4 路只能放 4 个 tag，5 个相距 4 KiB 的流就会把最早的那个挤出去（8 路要 9 个，见正文）。AMAT：`4 + 0.05 × (12 + 0.2 × (40 + 0.1 × 200)) = 4 + 0.05 × 24 = 5.2` 拍。L1 缺失率 2%：`4 + 0.02 × 24 = 4.48` 拍，快约 14%。注意 index 位数从 6 变 8，是因为组数翻倍；tag 相应少 2 位，地址拆分随容量/相联度一起移动。

**判据**：256 组、6/8/34 位；offset 0x38、index 25、tag `0x1fffc48d1`；抖动阈值 5 个流；AMAT 5.2 与 4.48 算对；能说出「相联度降一半、组数翻倍」；用局部缺失率而不是全局缺失率。

:::
:::

::: ex 例 1.14-A6 · ARM 与 RISC-V 的立即数与寻址边界 {#ex-1.14-A6}

先猜：`add x0,x0,#5000` 与 `ld a0,2048(a1)` 哪一条能汇编通过？

写出 ARM64 的 `add` 立即数、`ldr` 无符号偏移、`ldur` 有符号偏移的范围；写出 RISC-V I/S/B/J 型的立即数范围。判断下面四条能否直接汇编，不能的给出改写：`add x0,x0,#5000`、`ldr x0,[x1,#40000]`、`ld a0,2048(a1)`、`beq a0,a1,far`（`far` 距当前位置 8 KiB）。

::: sol 解答

ARM64：`add` 的 imm12 是 12 位**无符号**，可带 `LSL #12`，所以范围是 0–4095 或 4096–16,773,120（步长 4096），没有负立即数（用 `sub`）。`ldr`/`str` 的无符号偏移是 12 位、按访问宽度缩放：8 字节访问是 0–32760（步长 8）；负数或未对齐用 `ldur`/`stur` 的 9 位有符号偏移（−256..255）。RISC-V：I 型 12 位有符号（−2048..2047），用于 `addi`/`ld`/`jalr`；S 型同样 12 位有符号；B 型 13 位有符号、2 的倍数（±4 KiB）；J 型 21 位有符号、2 的倍数（±1 MiB）；U 型 20 位左移 12。判定：`add x0,x0,#5000` 不能（超过 4095，且不是 4096 的倍数），改成 `add x0,x0,#4096; add x0,x0,#904` 或 `movz x1,#5000; add x0,x0,x1`；`ldr x0,[x1,#40000]` 不能（超过 32760），改成先 `add x2,x1,#32768` 再 `ldr x0,[x2,#7232]`；`ld a0,2048(a1)` 不能（超过 2047），改成 `addi a2,a1,2047; ld a0,1(a2)` 或 `li t0,2048; add a2,a1,t0; ld a0,0(a2)`；`beq a0,a1,far`（8 KiB）不能（超过 ±4 KiB），改成先 `bne` 跳过再 `jal`，或用 `auipc`+`jalr` 构造远跳。RISC-V 还没有「基址 + 变址 × 比例」的寻址，数组下标要先 `slli` 再 `add`。

**判据**：ARM 的 12 位无符号 + 可选左移 12、`ldr` 按宽度缩放、`ldur` 9 位有符号说对；RISC-V 的 I/S/B/J 范围说对；四条判断全对且改写可用；知道 RISC-V 没有 scaled addressing；不把 ARM 的 `ldr` 偏移当成字节数无限。

:::
:::

## B 组 · 诊断推理

::: ex 例 1.14-B1 · 把 x86 汇编贴到 ARM64 上，编译不过 {#ex-1.14-B1}

先猜：把 `sum3` 的 x86 版本原样存成 `.s`，用 `clang --target=aarch64-linux-gnu -c` 编，报的是语法错还是寄存器错？

一位同事把 x86-64 的 `sum3` 汇编直接改成 ARM64 文件，只把文件名换了，构建报一串错。写出「现象 → 机制 → 证据 → 修法」四段。为什么不能靠「助记符同名」逐行替换？

::: sol 解答

现象：汇编器报未知寄存器/非法操作数（例如 `%rdi`、`%rax` 在 AArch64 上没有定义），或者删掉 `%` 后仍报操作数个数不对。机制：ISA 层寄存器集合不同（x86 16 个命名寄存器，ARM64 `x0`–`x30` + `sp`/`xzr`）；ABI 层参数位置不同（`rdi/rsi/rdx` 对 `x0/x1/x2`）；指令形式不同（x86 两操作数、ARM64 三操作数）；返回机制不同（x86 `ret` 弹栈，ARM64 `ret` 跳 `x30`）。证据：`clang --target=aarch64-linux-gnu -c sum3-x86.s` 的报错行号指向 `%rdi`；把同一段 C 用 `-S` 生成 ARM64 版本，`objdump -d` 看到的是 `add x0,x0,x1` 而不是 `lea`。修法：按目标 ISA 重写，或让编译器生成；跨架构复用走 C/内联汇编的约束字符串，不要复用汇编文本。逐行替换之所以不行，是因为同名 `add`/`ret` 的操作数个数与语义都可能不同，`mov` 在两边更是完全不同的指令族。

**判据**：判成「ISA/ABI 不同」而不是「汇编器 bug」；能指出至少两处具体差异（寄存器名、参数位置、操作数个数、`ret`）；给出 `-S` 对照或报错行号作证据；修法是重写/让编译器生成，不是加宏替换。

:::
:::

::: ex 例 1.14-B2 · `clang --target` 能出汇编，却链接不出可执行文件 {#ex-1.14-B2}

先猜：`clang --target=aarch64-linux-gnu -O2 sum3.c -o sum3` 失败，是代码生成错了，还是链接环境缺东西？

在写作机（macOS arm64）上执行 `clang --target=aarch64-linux-gnu -O2 -S sum3.c` 成功，执行 `clang --target=aarch64-linux-gnu -O2 sum3.c -o sum3` 失败。写出四段分析：失败发生在哪个阶段？`-S`/`-c` 为什么能成功？要真正运行还需要什么？在本书 VM 上又该怎么做？

::: sol 解答

现象：`-S` 生成 `.s` 成功，带 `-o` 的链接失败；macOS 上报 `ld: unknown options: --hash-style=gnu --eh-frame-hdr`，Linux 上常见的是找不到 `crt1.o`/`-lc`。机制：`--target` 只改变前端/后端的代码生成目标，不提供目标系统的启动文件、libc 与链接器脚本；`-S` 停在汇编、`-c` 停在目标文件，都不需要这些。要运行还需要目标 sysroot（`crt1.o`、`libc.so`、动态链接器）与一个能执行该 ELF 的环境（真机或 QEMU 用户态）。证据：`file sum3.o` 显示 `ELF 64-bit LSB relocatable, ARM aarch64`；`readelf -h` 的 `Machine` 是 `AArch64`；链接器报错里点名 `crt1.o`/`-lc` 或未知选项。修法：只想看汇编就 `-S`，只想看编码就 `-c` 加 `objdump`；要运行就在 VM 上用本机 `cc`（aarch64 原生），或用交叉 gcc + `qemu-aarch64 -L <sysroot>`。本书 VM 是 aarch64，原生 `cc` 直接可跑；x86/RISC-V 的链接与运行在本环境未实测（没有确认交叉工具链与 QEMU）。

**判据**：把失败定位在链接阶段而不是代码生成；说清 `-S`/`-c` 与链接的差别；给出 `file`/`readelf` 证据；知道要 sysroot + 执行环境；不把「能出汇编」当成「能跑」。

:::
:::

::: ex 例 1.14-B3 · 第 7 个参数读出来是返回地址 {#ex-1.14-B3}

先猜：在 x86-64 上，`mov 8(%rbp), %rax` 取到的是第 7 个参数吗？在 ARM64 上，照 1.14.11 的表用 `[sp]` 取第 7 个参数，会取到什么？

一个 8 参数函数 `f(a,…,h)` 在 x86-64 上把 `[rbp+8]` 当 `g`，结果 `g` 等于调用点的下一条指令地址；在 ARM64 上照正文 1.14.11 的表用入口 `[sp]` 当 `g`，结果 `g` 等于第 9 个参数或旧的栈内容。写出四段分析，并给出两套 ABI 的正确位置。

::: sol 解答

现象：x86 的 `g` 变成返回地址；ARM64 的 `g` 变成别的值。机制：x86-64 的 `call` 先把 8 字节返回地址压栈，所以入口 `[rsp]` 是返回地址、`[rsp+8]` 才是第 7 个参数；`push rbp` 后返回地址在 `[rbp+8]`，第 7、8 个在 `[rbp+16]`/`[rbp+24]`。ARM64 的前 8 个整数参数在 `x0`–`x7`，第 7、8 个是 `x6`/`x7`，**不在栈上**；第 9 个才在入口 `[sp]`，建帧后 `[sp+32]`。正文 1.14.11 的表把第 7、8 参数写成 ARM64/RISC-V 的栈参数，是按 x86 的 6 个寄存器上限套过来的，和 1.14.4、1.14.16 的 A2 矛盾；以 A2 为准，详见[勘误页](ch14-errata.md)第 1 条。证据：`cc -O0 -S` 一个 9 参数函数，ARM64 上能看到前 8 个从 `x0`–`x7` 存入栈、第 9 个从 `[sp]` 取；x86 上能看到 `16(%rbp)`/`24(%rbp)`；`objdump -d` 的序言与 `gdb` 的 `x/6gx $sp` 对得上。修法：按 ABI 表取；不确定就让编译器生成再读，不要手抄偏移；写汇编时把「入口」与「建帧后」两种偏移分开记。

**判据**：x86 的 `[rbp+8]` 是返回地址、`g` 在 `[rbp+16]`；ARM64 的 `g` 在 `x6`、第 9 个才在 `[sp]`；能指出正文 1.14.11 表与 1.14.4/A2 的矛盾并引用勘误；给出编译器或 `gdb` 证据；不把「6 个寄存器」套到 ARM64/RISC-V 上。

:::
:::

::: ex 例 1.14-B4 · 九个数组一扫，L1 像突然变小了 {#ex-1.14-B4}

先猜：9 个相距 4 KiB 的数组同时顺序扫描，是容量不够，还是组冲突？

一台机器 L1D 为 32 KiB、8 路、64 B。程序同时扫描 9 个相距 4 KiB 的 `int` 数组，每个数组都顺序访问，理论上 9 个流的工作集远小于 32 KiB，但实测每次访问都慢。写出四段分析：这属于哪类缺失？为什么 4 KiB 的间距恰好踩中？怎么改？在 `perf` 不可用的环境里怎么取证？

::: sol 解答

现象：工作集很小，但 L1 命中率很差。机制：组数 `32 KiB/(8×64 B)=64`，index 是低 12 位中的第 6–11 位；4 KiB 的整数倍只改变 tag、不改变 index，所以 9 个数组的同一偏移全落在同一组；8 路只能放 8 个 tag，第 9 个流把最早的那个挤出去，之后每次访问都 miss——这是**冲突缺失**，不是容量缺失。证据：`getconf -a | grep -E 'LEVEL1_DCACHE_(SIZE|LINESIZE|ASSOC)'` 确认 32 KiB/64 B/8 路；用 `clock_gettime` 计时对比「9 个紧挨 4 KiB」与「间距 4 KiB+64 B」两版；`perf stat -e L1-dcache-load-misses` 本环境不可用，所以只能用时间差与访问计数间接证明，不能报 miss 数。修法：数组间距加 64 B（改变 index），或把 9 个流分块处理（每次只碰 8 个流的一段），或把数组按 4 KiB+64 B 对齐分配。

**判据**：判成冲突缺失而不是容量缺失；能用 64 组、index 6 位解释 4 KiB 同组；知道 8 路要 9 个流才溢出；改法是 padding 或分块；明确 `perf` 不可用、只用计时证据。

:::
:::

::: ex 例 1.14-B5 · 三条指令，所以三套代码一样大？ {#ex-1.14-B5}

先猜：`sum3` 在三套架构上都是 3 条指令，`.text` 大小会一样吗？如果不一样，`size` 的 `text` 列能直接当指令字节数吗？

同事说「`sum3` 三套都是 3 条指令，所以代码尺寸一样，RISC 的代码密度优势是假的」。写出四段分析：指令条数与字节数是什么关系？x86 为什么短？RISC-V 的 6 字节是怎么来的？`size`/`llvm-size` 的 `text` 列能不能直接比？

::: sol 解答

现象：三套都是 3 条，但字节数不同。机制：x86 是变长编码，`lea`/`add`/`ret` 分别 4/3/1 字节，共 8 字节；ARM64 定长 4 字节，共 12 字节；RISC-V 定长 4 字节，但默认 `rv64gc` 含 C 扩展，常用指令压成 2 字节，所以 6 字节。指令条数只反映「译码要做几次」，字节数才反映「代码占多少 I-cache / 多少 flash」；两者不是一回事。`size` 的 `text` 列还包含只读数据、跳转表、对齐填充，不等于纯指令字节；要看 `objdump -d` 的地址范围或 `llvm-size -A` 的 `.text`。证据：`objdump -d` 看每条指令的偏移，最后一条 `ret` 的地址加长度就是指令字节；`readelf -S` 看 `.text` 的 `Size`。修法/结论：比较代码密度用字节数，比较译码压力用条数与格式；不要用「条数相同」推翻 RISC 的密度差异，也不要用 `size` 的总 `text` 直接和三套 ISA 比。

**判据**：8/12/12（RVC 6）说对；能解释 x86 变长、ARM/RISC-V 定长与 RVC；区分「条数」与「字节数」；知道 `size` 的 `text` 含非指令内容；给出 `objdump`/`readelf` 证据。

:::
:::

::: ex 例 1.14-B6 · 把 `write` 的号写成 1，ARM64 上没有任何输出 {#ex-1.14-B6}

先猜：x86-64 的 `write` 是 1，ARM64 的 1 也是 `write` 吗？如果照抄 `mov x8,#1; svc #0`，会发生什么？

一段从 x86 移植到 ARM64 的 `_start` 把系统调用号写成 1，参数照旧放 `x0/x1/x2`，运行后没有输出、返回码也不是 0。写出四段分析：ARM64 的 1 是什么调用？`write` 的号是多少？x86 系统调用的第 4 个参数为什么不能用 `rcx`？怎么写出可移植的版本？

::: sol 解答

现象：没有输出，`svc #0` 返回一个负值（`-errno`），程序继续执行到 `exit`。机制：系统调用号是内核 ABI，不是 ISA；ARM64 与 RISC-V 遵循 asm-generic，`write` 是 64，而 1 是 `io_destroy`（asm-generic 的编号），参数含义完全不同，所以不会写 stdout。x86-64 的 `write` 是 1，但 `syscall` 会覆盖 `rcx`（返回地址）与 `r11`（标志），第 4 个参数必须用 `r10`，不能用函数调用表的 `rcx`。证据：`grep -E '__NR_(write|io_destroy)' /usr/include/asm-generic/unistd.h` 看到 64 与 1；`strace`/`qemu -strace` 看到实际调用名是 `io_destroy` 而不是 `write`（QEMU 未在本环境确认，未实测）；`objdump -d` 确认 `mov x8,#1` 而不是 `#64`。修法：C 里用 `syscall(SYS_write, ...)` 或直接调 `write(2)`；汇编里用 `#include <asm-generic/unistd.h>` 的 `__NR_write` 或让构建系统注入；x86 的 4 参数调用记得用 `r10`。

**判据**：指出 ARM64/RISC-V 的 `write` 是 64、1 是 `io_destroy`；说清号是内核 ABI；x86 第 4 参数用 `r10` 的理由；给出头文件或 `strace` 证据；修法是不硬编码号；不把「没有输出」归因于 `svc` 指令本身。

:::
:::

## C 组 · 动手实验

::: ex 例 1.14-C1 · 在本机 aarch64 上看 ABI：`sum3` 与 9 参数栈帧 {#ex-1.14-C1}

先猜：本机 `cc -O2 -S sum3.c` 生成的 `sum3` 会有几条指令？9 参数函数的第 9 个参数从哪个地址取？

写 `sum3.c` 与一个 9 参数函数 `f`，用 `cc -O2 -S` 与 `cc -O0 -S` 各生成一次汇编；用 `objdump -d` 看 `sum3` 的指令与字节数；用 `readelf -h` 看 `Machine`；在 9 参数版本里找到第 7、8、9 个参数的来源，并解释为什么第 9 个才在栈上。

::: sol C1 核对

```bash
mkdir -p ~/lab1c14_work && cd ~/lab1c14_work
cat > lab1c14_sum3.c <<'EOF'
long sum3(long a, long b, long c) { return a + b + c; }
long f(long a, long b, long c, long d, long e,
       long f_, long g, long h, long i)
{
    return a + b + c + d + e + f_ + g + h + i;
}
long call9(void) { return f(1, 2, 3, 4, 5, 6, 7, 8, 9); }
EOF
cc -O2 -S lab1c14_sum3.c -o lab1c14_sum3.s
cc -O0 -S lab1c14_sum3.c -o lab1c14_sum3_O0.s
cc -O2 -c lab1c14_sum3.c -o lab1c14_sum3.o
objdump -d lab1c14_sum3.o | sed -n '/<sum3>:/,/^$/p'
readelf -h lab1c14_sum3.o | grep -E 'Class|Machine|Type'
grep -nE 'ldr|str|sub[[:space:]]+sp' lab1c14_sum3_O0.s | head -30
```

预期形状（以你机器输出为准）：`sum3` 是 `add x0,x0,x1`、`add x0,x0,x2`、`ret` 三条，`objdump` 的偏移是 0、4、8，所以指令字节 12；`readelf -h` 显示 `Class: ELF64`、`Machine: AArch64`、`Type: REL`。`-O0` 的 `f` 序言会 `sub sp,sp,#...`，把 `x0`–`x7` 逐个 `str` 到栈上，然后从 `[sp,#...]` 取第 9 个参数；第 7、8 个参数在 `x6`/`x7`，不会从栈上取。这个实验直接验证 1.14.4 与 1.14.16 A2，也解释 1.14.11 表里「第 7 参数在 `[sp]`」为什么不对（见[勘误页](ch14-errata.md)第 1 条）。

**判据**：`sum3` 三条指令、12 字节；`Machine: AArch64`；能在 `-O0` 汇编里指出 `x0`–`x7` 的保存与第 9 个参数的 `ldr ... [sp, ...]`；能说出第 7、8 个在 `x6`/`x7`；`-O2` 可能把 `f` 内联或常量折叠，所以栈帧要看 `-O0` 或加 `__attribute__((noinline))`。无需 `sudo`；本套件未在 VM 上复跑，读数以你机器为准。

:::
:::

::: ex 例 1.14-C2 · 不依赖 libc 的 `hello`：`svc #0` 与 `readelf` {#ex-1.14-C2}

先猜：`cc -nostdlib -static` 链接一个只用 `write`/`exit` 的汇编，入口是 `_start` 还是 `main`？`readelf -h` 的 `Type` 是 `EXEC` 还是 `DYN`？

写一个 aarch64 的 `_start`，只用 `write(1,msg,len)` 与 `exit(0)`；用 `cc -nostdlib -static` 链接，运行看输出与退出码；用 `objdump -d` 找 `svc #0` 与 `x8` 的赋值；用 `readelf -h` 看入口与 `Type`；再用 `readelf -s` 看有没有 `main`。

::: sol C2 核对

```bash
cat > lab1c14_hello.S <<'EOF'
    .section .rodata
msg:    .ascii "hello\n"
len = . - msg
    .text
    .globl _start
_start:
    mov     x8, #64             // SYS_write
    mov     x0, #1              // stdout
    adr     x1, msg
    mov     x2, #len
    svc     #0
    mov     x8, #93             // SYS_exit
    mov     x0, #0
    svc     #0
EOF
cc -nostdlib -static lab1c14_hello.S -o lab1c14_hello
./lab1c14_hello; echo "exit=$?"
objdump -d lab1c14_hello | sed -n '/<_start>:/,/^$/p'
readelf -h lab1c14_hello | grep -E 'Entry|Type|Machine'
readelf -s lab1c14_hello | grep -E ' main$| _start$'
```

预期：输出 `hello`，`exit=0`；`objdump` 里能看到两次 `svc #0`，第一次前有 `mov x8, #0x40`（64），第二次前有 `mov x8, #0x5d`（93）；`readelf -h` 的 `Entry point address` 指向 `_start`，`Machine` 是 `AArch64`；`readelf -s` 只有 `_start`，没有 `main`。`Type` 取决于链接方式：`-static` 通常是 `EXEC`，`-static-pie` 仍是 `DYN`，用 `readelf -h` 的 `Type` 确认，不要凭 `-static` 猜。这个实验把 1.14.5 的三条陷入指令与 1.14.14 的「不依赖 libc」落到本机。

**判据**：输出 `hello` 且退出码 0；`objdump` 找到两次 `svc #0` 与 `x8=64/93`；`readelf -h` 的入口指向 `_start`、`Machine: AArch64`；`readelf -s` 没有 `main`；能解释 `-static` 与 `-static-pie` 的 `Type` 差异。无需 `sudo`；aarch64 VM 原生可跑；x86/RISC-V 版本未实测（无确认的交叉工具链/QEMU）。

:::
:::

::: ex 例 1.14-C3 · 用 `getconf` 与计时验证 cache 几何 {#ex-1.14-C3}

先猜：stride 从 1 增到 8192，每次访问的纳秒数会单调上升吗？`getconf` 报的 L1 行大小一定是 64 B 吗？

用 `getconf` 读出 L1D 的容量、行大小、相联度；写一个按 stride 扫描数组的程序，用 `clock_gettime` 计时，比较 stride=1/16/1024/8192 的 `ns/elem`；解释哪一段是预取与顺序流、哪一段开始组冲突。`perf` 不可用，不许报 miss 数。

::: sol C3 核对

```bash
getconf -a | grep -E 'LEVEL1_DCACHE_(SIZE|LINESIZE|ASSOC)'
cat > lab1c14_stride.c <<'EOF'
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

static double now_ns(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (double)ts.tv_sec * 1e9 + (double)ts.tv_nsec;
}

int main(int argc, char **argv)
{
    size_t n = 1u << 24;                 /* 64 MiB 的 int 数组 */
    size_t stride = argc > 1 ? strtoul(argv[1], NULL, 0) : 1;
    int *a = malloc(n * sizeof *a);
    if (!a) return 1;
    for (size_t i = 0; i < n; i++) a[i] = 1;

    size_t steps = 0;
    long sum = 0;
    double t0 = now_ns();
    for (int rep = 0; rep < 5; rep++)
        for (size_t i = 0; i < n; i += stride) { sum += a[i]; steps++; }
    double t1 = now_ns();
    printf("stride=%zu steps=%zu %.2f ns/elem sum=%ld\n",
           stride, steps, (t1 - t0) / (double)steps, sum);
    free(a);
    return 0;
}
EOF
cc -O2 -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror lab1c14_stride.c -o lab1c14_stride
for s in 1 16 1024 8192; do ./lab1c14_stride $s; done
```

预期方向：stride=1 触发硬件预取，`ns/elem` 最低；stride=16（64 B）每步换一条 line，接近顺序流；stride=1024（4 KiB）开始出现组冲突，明显变慢；stride=8192（32 KiB）在 8 路 32 KiB L1 上几乎每步都 miss，最慢。绝对数字随机器、频率、内存带宽变化，不要抄成常数。注意正文 1.14.10 实验 B 的注释写「64 MiB」，但 `1u << 26` 个 `int` 实际是 256 MiB；这里用 `1u << 24` 才是 64 MiB，见[勘误页](ch14-errata.md)。`perf stat` 的 L1/LLC 计数在本环境不可用，只能看时间差与 `getconf`，所以「组冲突」是从 stride 拐点推断，不是 PMU 读数。

**判据**：三条 `getconf` 值记录下来（容量/行大小/相联度，可能是 64 B 也可能是 128 B）；四个 stride 都跑出数字；`ns/elem` 的方向是 1≈16 < 1024 < 8192（允许噪声）；能解释 stride=4 KiB 同组、8 KiB 同组更严重；明确 `perf` 缺失、不报 miss 数；指出正文注释的 64/256 MiB 不一致。无需 `sudo`。

:::
:::

::: ex 例 1.14-C4 · 手算编码，让汇编器对答案 {#ex-1.14-C4}

先猜：`add x0,x0,x1` 的 32 位字面值是 `0x8B010000`，那它在文件里的四个字节按什么顺序放？`objdump` 显示的字面值与 `xxd` 看到的字节序为什么相反？

把 `add x0,x0,x1`、`ldr x0,[x1,#8]`、`add x0,x0,#1` 写成 `.s`，汇编后用 `objdump -d` 读出三条的 32 位字面值与字节序；再手算一遍字段，核对 `0x8B010000`/`0xF9400420`/`0x91000400`。x86 的 `8b 44 b7 10` 与 RISC-V 的 `0x00B50533` 如果本机没有对应汇编器，标「未实测」并说明原因。

::: sol C4 核对

```bash
cat > lab1c14_enc.s <<'EOF'
    .text
    .globl enc
enc:
    add x0, x0, x1
    ldr x0, [x1, #8]
    add x0, x0, #1
    ret
EOF
cc -c lab1c14_enc.s -o lab1c14_enc.o
objdump -d lab1c14_enc.o
objdump -s -j .text lab1c14_enc.o
```

预期：`objdump -d` 的十六进制列依次是 `8b010000`、`f9400420`、`91000400`、`d65f03c0`；`objdump -s` 的原始字节是小端，第一条是 `00 00 01 8b`，所以「字面值」与「文件字节序」相反。手算：`add x0,x0,x1` 的 sf=1、op=0、S=0、固定 `01011`、shift=00、Rm=1、imm6=0、Rn=0、Rd=0，拼出 `1000 1011 0000 0001 0000 0000 0000 0000` = `0x8B010000`；`ldr x0,[x1,#8]` 的 imm12=1（按 8 缩放），字段拼出 `0xF9400420`；`add x0,x0,#1` 是立即数版，`0x91000400`。x86 的 `8b 44 b7 10` 在写作机上用 `clang --target=x86_64-linux-gnu -c` 汇编同一指令后由 `objdump -d` 实测得到（`movl 0x10(%rdi,%rsi,4), %eax`）；`objdump -D -b binary -m i386:x86-64` 的二进制模式是否可用随 binutils 的编译选项而变，VM 上未确认，跑不了就标未实测。RISC-V 的 `add`/`addi`/`sd` 需要 `llvm-mc -triple=riscv64` 或交叉汇编器；本环境与写作机都没有可用的 RISC-V 后端（Apple clang 21 未注册 riscv64），**未实测**，只保留手算字段。

**判据**：aarch64 三条字面值与字节序全对；能手拼 `add` 的 sf/op/S/固定位/Rm/Rn/Rd；知道 `ldr` 的 imm12 按 8 缩放；能解释小端「字面值 vs 内存字节」；x86/RISC-V 部分如实标「未实测 + 原因」，不编造 `llvm-mc` 输出。aarch64 部分无需 `sudo`；本套件未在 VM 上复跑。

:::
:::
