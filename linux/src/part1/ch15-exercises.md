# 1.15 习题集

三组分层：**A 组概念判断**考「会读、会说理由、会画栈图」；**B 组诊断推理**给现象让你判返回地址、寄存器责任、参数位置与内联汇编约束；**C 组动手实验**在 Ubuntu 24.04 aarch64 上免 `sudo` 复现本章的关键证据。全部附解答与判据；先独立完成，再展开对照。每题的第一个动作都是「先猜」：把预期写下来，再去验证；猜错的地方才是这题的价值。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；A 组要求口述或写一段完整因果，B 组要求写成「现象 → 机制 → 证据 → 修法」四段。
2. 卡住了回对应小节的「即时自测」重读，不要直接看答案；A 组对应 1.15.1–1.15.5，B 组对应 1.15.1–1.15.10，C 组对应 1.15.4–1.15.9。
3. C 组的命令都在本书的 Ubuntu 24.04.5 虚拟机（aarch64、GCC 13.3.0、4 vCPU）上设计；临时文件统一用 `lab1c15_` 前缀，实验结束删掉。
4. **`sudo` 与 `perf` 不可用**：`cc`/`gcc`、`as`、`objdump`、`readelf` 可用；`perf stat`/`perf record` 一律跳过并标「未实测」。`gdb`、`cargo`、交叉 gcc、QEMU 是否安装未确认，先 `command -v` 再决定。
5. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch15-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 1.15-A1 · 三条调用指令与返回地址 {#ex-1.15-A1}

先猜：ARM64 的 `ret` 会不会像 x86 的 `ret` 一样从栈顶取地址？

写出 `call`/`bl`/`jal` 三套调用机制，标出返回地址放在哪、非叶函数各要保存什么、叶子函数为什么可以不碰栈。再解释 `stp x29, x30, [sp, #-16]!` 到底在保存什么，为什么不能说它「压返回地址」。

::: sol 解答

x86-64 的 `call foo` 把下一条指令地址压入栈顶，`ret` 弹出到 `rip`。ARM64 的 `bl foo` 把返回地址写入 `x30`（LR），`ret` 是 `br x30`，**不读写栈**。RISC-V 的 `jal ra, foo`/`call foo` 把返回地址写入 `ra`（`x1`），`ret` 是伪指令 `jalr x0, 0(ra)`。非叶函数：x86-64 的返回地址已由 `call` 压栈，通常不需要额外保存返回地址，但若使用 `rbx` 等被调用者保存寄存器仍要保存；ARM64 必须在调用别人前保存 `x30`，典型是 `stp x29, x30, [sp, #-16]!`；RISC-V 必须 `sd ra, ...(sp)`。叶子函数不调用别人，LR/`ra` 不会被覆盖，所以可以完全不碰栈。`stp x29, x30` 保存的是**当前函数的**帧指针和链接寄存器，供本函数返回前恢复；真正的返回地址是 `bl` 写进 `x30` 的值，不是硬件压进栈的。

**判据**：三种返回机制说对；非叶/叶子的差别说清；能指出 `stp` 是软件保存 FP/LR，不是硬件压返回地址；知道 `ret` 在 ARM64 上不弹栈。

:::
:::

::: ex 例 1.15-A2 · 寄存器责任表与特殊寄存器 {#ex-1.15-A2}

先猜：`x30` 算被调用者保存寄存器吗？ARM64 的 `v8`–`v15` 能完整保存 128 位吗？

默写三套 ABI 的整数/浮点参数、返回值、被调用者保存、调用者保存、栈对齐、红区；再说明 `x30`、`v8`–`v15`、RISC-V 的 `gp`/`tp` 为什么特殊。

::: sol 解答

整数参数：`rdi,rsi,rdx,rcx,r8,r9` / `x0`–`x7` / `a0`–`a7`。浮点：`xmm0`–`xmm7` / `v0`–`v7` / `fa0`–`fa7`。返回值：`rax`（128 位 `rdx:rax`）/ `x0`（`x1:x0`）/ `a0`（`a1:a0`）。被调用者保存：`rbx,rbp,r12`–`r15` / `x19`–`x29` 与 `v8`–`v15` 低 64 位 / `s0`–`s11`（`x8,x9,x18`–`x27`）。调用者保存：`rax,rcx,rdx,rsi,rdi,r8`–`r11` / `x0`–`x18` / `a0`–`a7` 与 `t0`–`t6`。栈对齐：x86-64 调用前 16 字节、入口 `rsp%16==8`；ARM64 公共接口 16 字节；RISC-V 16 字节。红区：x86-64 128 字节（叶子函数可用），ARM64/RISC-V 无。`x30` 是链接寄存器，ABI 表通常单列为「特殊」，不是普通被调用者保存；ARM64 的 `v8`–`v15` 只保证低 64 位，传 `__m128` 时高 64 位可能被破坏；RISC-V 的 `gp` 是全局指针（PIC 锚点）、`tp` 是线程指针，用户代码不能拿它们当临时变量。

**判据**：参数/返回值/保存寄存器三行全对；红区与栈对齐说对；能指出 `x30` 的特殊性、`v8`–`v15` 只保证低 64 位、`gp`/`tp` 的用途；不把 `x30` 当普通 callee-saved。

:::
:::

::: ex 例 1.15-A3 · 十条操作的三种写法 {#ex-1.15-A3}

先猜：RISC-V 的 `add a0,a0,a1` 和 x86 的 `add %rsi,%rax`，操作数方向一样吗？

把「加载 8 字节、存 8 字节、加法、立即数加法、比较跳转、调用、返回、栈分配、取地址、系统调用」写成三套汇编，并标出 AT&T 与 ARM/RISC-V 的操作数方向差异。

::: sol 解答

加载：`mov 8(%rdi),%rax` / `ldr x0,[x1,#8]` / `ld a0,8(a1)`。存储：`mov %rax,8(%rdi)` / `str x0,[x1,#8]` / `sd a0,8(a1)`。加法：`add %rsi,%rax` / `add x0,x0,x1` / `add a0,a0,a1`。立即数：`add $16,%rsp` / `add sp,sp,#16` / `addi sp,sp,16`。比较跳转：`cmp %rsi,%rdi; jg L` / `cmp x0,x1; b.gt L` / `bgt a0,a1,L`。调用：`call foo` / `bl foo` / `call foo`（展开成 `auipc`+`jalr`）。返回：`ret` / `ret` / `ret`（`jalr x0,0(ra)`）。栈分配：`sub $32,%rsp` / `sub sp,sp,#32` / `addi sp,sp,-32`。取地址：`lea 8(%rdi),%rax` / `add x0,x1,#8` / `addi a0,a1,8`。系统调用：`syscall` / `svc #0` / `ecall`。x86-64 是 AT&T「源在前、目标在后」；ARM64/RISC-V 是「目标在左」。比较跳转的条件码方向也要注意：x86 `cmp %rsi,%rdi` 算 `rdi-rsi`，ARM `cmp x0,x1` 算 `x0-x1`。

**判据**：十条操作的三套写法正确；能指出 x86 的 `lea` 与 ARM/RISC-V 的 `add`/`addi` 对应；比较方向不反；知道 RISC-V 的 `call`/`ret` 是伪指令。

:::
:::

::: ex 例 1.15-A4 · `framed` 的三张栈图与 `sub $24` {#ex-1.15-A4}

先猜：`framed` 的 x86 序言为什么是 `sub $24`，不是 `sub $32`？ARM64 的 32 字节帧里，局部变量为什么在 `[sp,#24]`？

写出 `framed` 三套序言/尾声，画出栈图，标出返回地址、保存的 FP/LR、保存的 `rbx`/`x19`/`s1`、局部变量，并解释每套的 16 字节对齐算术。

::: sol 解答

x86-64：`push %rbp; mov %rsp,%rbp; push %rbx; sub $24,%rsp`；局部变量在 `-32(%rbp)`；尾声 `add $24,%rsp; pop %rbx; pop %rbp; ret`。进入时 `rsp%16==8`，`push rbp` 后为 0，`push rbx` 后为 8，`sub 24` 后为 0；`sub $24` 与前面的 8 字节 `push` 合起来凑成 32 字节的 16 的倍数。ARM64：`stp x29,x30,[sp,#-32]!; mov x29,sp; str x19,[sp,#16]`；局部变量在 `[sp,#24]`；尾声 `ldr x19,[sp,#16]; ldp x29,x30,[sp],#32; ret`。32 字节帧内：`[sp]`/`[sp+8]` 是 x29/x30，`[sp+16]` 是 x19，`[sp+24]` 是局部变量。RISC-V：`addi sp,sp,-32; sd ra,24(sp); sd s0,16(sp); sd s1,8(sp); addi s0,sp,32`；局部变量在 `-32(s0)`；尾声按相反顺序 `ld s1,8(sp); ld s0,16(sp); ld ra,24(sp); addi sp,sp,32; ret`。三张图共同点：返回地址在 x86 是硬件压的、在 ARM64/RISC-V 是软件存的；被调用者保存区在更高地址；局部变量夹在 `sp` 与保存区之间。

**判据**：三套序言/尾声顺序正确；x86 的对齐算术说对（8+8+24=40，入口 8 → 0）；ARM64/RISC-V 的 32 字节帧与偏移说对；能指出 `-O2` 可能省略帧指针但责任划分不变。

:::
:::

::: ex 例 1.15-A5 · 第 7、8、9 个参数与结构体 {#ex-1.15-A5}

先猜：9 个 `long` 参数，第 7 个在 ARM64 上也走栈吗？第 9 个在 x86-64 的 `[rsp+24]` 还是 `[rsp+32]`？

写出 9 参数函数在三套 ABI 下的参数位置（入口与建帧后两种偏移）；再说清 ≤16 字节结构体、>16 字节结构体、HFA、可变参数各怎么处理。

::: sol 解答

x86-64 只有 6 个整数参数寄存器：第 7、8、9 个走栈，入口 `[rsp+8]`/`[rsp+16]`/`[rsp+24]`（`call` 先压了 8 字节返回地址），`push rbp` 后是 `[rbp+16]`/`[rbp+24]`/`[rbp+32]`。ARM64 有 8 个：第 7、8 个在 `x6`/`x7`，第 9 个在入口 `[sp]`，建帧 32 字节后 `[sp+32]`。RISC-V 有 8 个：第 7、8 个在 `a6`/`a7`，第 9 个在入口 `0(sp)`，建帧后 `32(sp)`。结构体：≤16 字节，x86-64 拆成 1–2 个 INTEGER/SSE 八字节，ARM64 拆 1–2 个寄存器，RISC-V 拆 1–2 个寄存器（≤2×XLEN）；>16 字节三家都走内存（x86 是 MEMORY 类、调用者在栈上复制，ARM64/RISC-V 通常传指针）；HFA（1–4 个 `float`/`double`）在 ARM64 可走 `v0`–`v3`/`s0`–`s3`。可变参数：x86-64 必须在 `call` 前用 `%al` 记录使用的向量寄存器个数；ARM64 的匿名参数主要走栈；RISC-V 把寄存器参数先存进 `va_list` 保存区。

**判据**：第 7、8 个在 ARM64/RISC-V 仍在寄存器、第 9 个才进栈；x86 的 `[rsp+24]` 与 `[rbp+32]` 两种偏移都对；结构体阈值与 HFA 说对；`%al` 的用途说对；不把「6 个寄存器」套到三家。

:::
:::

::: ex 例 1.15-A6 · 栈对齐、红区与 `movaps` {#ex-1.15-A6}

先猜：x86-64 进入函数时 `rsp%16` 是 0 还是 8？红区在三套 ABI 上都有吗？

解释 x86-64 入口与调用前的对齐要求、序言怎么补、红区的适用条件，以及 `movaps` 段错误和「叶子函数加了调用就崩」的因果。ARM64/RISC-V 为什么不能往 `sp` 以下写？

::: sol 解答

x86-64 入口 `rsp%16==8`（`call` 压了 8 字节），`call` 前要求 `rsp%16==0`。若序言 `push %rbp`（8），再 `sub` 8 的奇数倍即可，例如 `push %rbp; mov %rsp,%rbp; sub $16,%rsp` 仍保持 0；`sub $24` 与 `push %rbx` 合起来也回到 0。红区是 SysV 允许叶子函数在 `rsp` 以下 128 字节内暂存、不调整 `rsp` 的约定，信号处理会跳过；一旦函数调用别人，调用者的栈帧会覆盖这块区域，红区失效。`movaps` 要求 16 字节对齐，调用前 `rsp` 不是 0 就段错误；序言 `sub` 总量要保持 16 的倍数。ARM64/RISC-V 的 ABI 没有红区，`sp` 以下不保证安全，任何写栈都要先减 `sp`；ARM64 要求公共接口 `sp%16==0`，RISC-V 也要求 16 字节对齐。

**判据**：入口 8、调用前 0 说对；`push`+`sub` 的对齐算术对；红区只属于 x86-64 且只对叶子函数有效；`movaps` 与对齐的因果说清；ARM64/RISC-V 没有红区。

:::
:::

## B 组 · 诊断推理

::: ex 例 1.15-B1 · 把 x86 汇编贴到 ARM64 上 {#ex-1.15-B1}

先猜：把 x86-64 的 `sum3` 原样存成 `.s` 交给 `clang --target=aarch64-linux-gnu -c`，报的是寄存器错还是语法错？

一位同事把 x86-64 的 `sum3` 汇编直接改成 ARM64 文件，只换了文件名，构建报一串错。写出「现象 → 机制 → 证据 → 修法」四段，并解释为什么不能靠「助记符同名」逐行替换。

::: sol 解答

现象：汇编器报未知寄存器/非法操作数（例如 `%rdi`、`%rax` 在 AArch64 上没有定义），或者删掉 `%` 后仍报操作数个数不对。机制：ISA 层寄存器集合不同（x86 16 个命名寄存器，ARM64 `x0`–`x30` + `sp`/`xzr`）；ABI 层参数位置不同（`rdi/rsi/rdx` 对 `x0/x1/x2`）；指令形式不同（x86 两操作数，ARM64 三操作数）；返回机制不同（x86 `ret` 弹栈，ARM64 `ret` 跳 `x30`）。证据：`clang --target=aarch64-linux-gnu -c sum3-x86.s` 的报错行号指向 `%rdi`；把同一段 C 用 `-S` 生成 ARM64 版本，看到的是 `add x0,x0,x1` 而不是 `lea`。修法：按目标 ISA 重写，或让编译器生成；跨架构复用走 C/内联汇编的约束字符串，不要复用汇编文本。逐行替换不行，是因为同名 `add`/`ret` 的操作数个数与语义都可能不同，`mov` 在两边更是不同的指令族。

**判据**：判成「ISA/ABI 不同」而不是「汇编器 bug」；能指出至少两处具体差异；给出报错行号或 `-S` 对照作证据；修法是重写/让编译器生成。

:::
:::

::: ex 例 1.15-B2 · 能交叉汇编，却链接不出可执行文件 {#ex-1.15-B2}

先猜：`clang --target=aarch64-linux-gnu -c` 成功、带 `-o` 链接失败，失败在代码生成还是链接环境？

在写作机（macOS arm64）上执行 `clang --target=aarch64-linux-gnu -O2 -S sum3.c` 与 `-c` 都成功，执行带 `-o` 的链接失败。写出四段分析：失败发生在哪个阶段？`-S`/`-c` 为什么能成功？要真正运行还需要什么？在本书 VM 上该怎么做？

::: sol 解答

现象：`-S` 生成 `.s`、`-c` 生成 `.o` 成功，带 `-o` 的链接失败；macOS 上常见 `ld: unknown options: --hash-style=gnu --eh-frame-hdr`，Linux 上常见找不到 `crt1.o`/`-lc`。机制：`--target` 只改变前端/后端的代码生成目标，不提供目标系统的启动文件、libc 与链接器脚本；`-S` 停在汇编、`-c` 停在目标文件，都不需要这些。要运行还需要目标 sysroot（`crt1.o`、`libc.so`、动态链接器）与能执行该 ELF 的环境（真机或 QEMU 用户态）。证据：`file sum3.o` 显示 `ELF 64-bit LSB relocatable, ARM aarch64`；`readelf -h` 的 `Machine` 是 `AArch64`；链接器报错点名 `crt1.o`/`-lc` 或未知选项。修法：只看汇编就 `-S`，只看编码就 `-c` 加 `objdump`；要运行就在 VM 上用本机 `cc`（aarch64 原生），或用交叉 gcc + `qemu-aarch64 -L <sysroot>`。本书 VM 是 aarch64，原生 `cc` 直接可跑；x86-64/RISC-V 的链接与运行在本环境未实测。

**判据**：把失败定位在链接阶段；说清 `-S`/`-c` 与链接的差别；给出 `file`/`readelf` 证据；知道要 sysroot + 执行环境；不把「能出汇编」当成「能跑」。

:::
:::

::: ex 例 1.15-B3 · 第 7 个参数读出来是返回地址 {#ex-1.15-B3}

先猜：x86-64 上 `mov 8(%rbp), %rax` 取到的是第 7 个参数吗？ARM64 上照「第 7 个在栈上」用入口 `[sp]` 取，会取到什么？

一个 8 参数函数 `f(a,…,h)` 在 x86-64 上把 `[rbp+8]` 当 `g`，结果 `g` 等于调用点的下一条指令地址；在 ARM64 上照「第 7 个在栈上」用入口 `[sp]` 当 `g`，结果 `g` 等于第 9 个参数或旧的栈内容。写出四段分析，并给出两套 ABI 的正确位置。

::: sol 解答

现象：x86 的 `g` 变成返回地址；ARM64 的 `g` 变成别的值。机制：x86-64 的 `call` 先把 8 字节返回地址压栈，所以入口 `[rsp]` 是返回地址、`[rsp+8]` 才是第 7 个参数；`push rbp` 后返回地址在 `[rbp+8]`，第 7、8 个在 `[rbp+16]`/`[rbp+24]`。ARM64 的前 8 个整数参数在 `x0`–`x7`，第 7、8 个是 `x6`/`x7`，**不在栈上**；第 9 个才在入口 `[sp]`，建帧后 `[sp+32]`。证据：`cc -O0 -S` 一个 9 参数函数，ARM64 上能看到前 8 个从 `x0`–`x7` 存入栈、第 9 个从 `[sp]` 取；x86 上能看到 `16(%rbp)`/`24(%rbp)`。修法：按 1.15.5 的表取；不确定就让编译器生成再读，不要手抄偏移；写汇编时把「入口」与「建帧后」两种偏移分开记。跨章对照时以 1.15.5 的表为准，不要套用「三套都是 6 个寄存器」的旧说法。

**判据**：x86 的 `[rbp+8]` 是返回地址、`g` 在 `[rbp+16]`；ARM64 的 `g` 在 `x6`、第 9 个才在 `[sp]`；能给出编译器证据；不把「6 个寄存器」套到 ARM64/RISC-V。

:::
:::

::: ex 例 1.15-B4 · `openat` 的第 4 个参数放进了 `rcx` {#ex-1.15-B4}

先猜：x86-64 的 `openat` 四个参数按 `rdi/rsi/rdx/rcx` 放，能打开文件吗？

一段手写 x86-64 汇编用 `rax=257`、`rdi=AT_FDCWD`、`rsi=path`、`rdx=flags`、`rcx=mode` 发 `syscall`，结果创建出的文件权限不对。写出四段分析：第 4 个参数应该放哪？`rcx`/`r11` 为什么不能用来传参？内联汇编还要声明什么？

::: sol 解答

现象：`openat` 返回成功或失败，但 `mode` 不是预期值。机制：x86-64 系统调用参数顺序是 `rdi,rsi,rdx,r10,r8,r9`，第 4 个是 `r10`，不是函数调用表的 `rcx`。`syscall` 指令用 `rcx` 保存返回 `rip`、用 `r11` 保存 `rflags`，硬件会覆盖这两个寄存器；把 `mode` 放 `rcx`，进入内核时已经被返回地址替换。证据：查 `syscall(2)` 的 ABI 表；`objdump -d` 看 `syscall` 前是否有 `mov %rcx,%r10`；写一个 4 参数 `openat`，把 `r10` 改成 `rcx`，观察 `mode`/返回值变化。修法：第 4 个参数用 `r10`，第 5、6 个用 `r8`/`r9`；内联汇编把 `"rcx"`、`"r11"` 声明为 clobber，并加 `"memory"`。ARM64 的 `svc #0` 参数在 `x0`–`x5`、号在 `x8`，没有这个隐式覆盖；RISC-V 的 `ecall` 参数在 `a0`–`a5`、号在 `a7`。

**判据**：第 4 个参数是 `r10`；说清 `syscall` 覆盖 `rcx`/`r11`；给出 `syscall(2)` 或反汇编证据；内联汇编声明两个 clobber；知道 ARM64/RISC-V 无等价问题。

:::
:::

::: ex 例 1.15-B5 · ARM64 嵌套调用后返回错地址 {#ex-1.15-B5}

先猜：一个 ARM64 函数连续两次 `bl`，中间不保存 `x30`，第二次返回后 `ret` 会跳到哪？

一个 ARM64 函数先 `bl inner1`，再 `bl inner2`，最后 `ret`；运行后控制流没有回到调用者。写出四段分析：`x30` 在两次 `bl` 中怎么变？正确序言/尾声是什么？RISC-V 的对应错误是什么？

::: sol 解答

现象：函数执行完没有回到调用者，可能跳回函数内部或跳到 `inner2` 的返回点，形成错乱。机制：`bl` 把返回地址写入 `x30`；第一次 `bl inner1` 写入「inner1 之后」的地址，第二次 `bl inner2` 又覆盖 `x30` 为「inner2 之后」的地址；函数最后 `ret` 跳到的是第二次调用的返回点，不是调用者的返回点。证据：`objdump -d` 看函数开头有没有 `stp x29,x30,[sp,#-16]!`、结尾有没有 `ldp`；`gdb` 在 `ret` 前看 `x30` 是否等于调用者里的返回地址。修法：非叶函数开头 `stp x29, x30, [sp, #-16]!`，结尾 `ldp x29, x30, [sp], #16; ret`；如果还有别的被调用者保存寄存器，一并 `stp`/`ldp`。RISC-V 的对应错误是没保存 `ra`：每次 `call` 覆盖 `ra`，递归时尤其明显，修法是每层 `sd ra, ...(sp)` 并在返回前 `ld`。

**判据**：说清 `bl` 写 `x30`、第二次覆盖第一次；正确序言/尾声成对；给出反汇编或 `gdb` 证据；能类比 RISC-V 的 `ra`。

:::
:::

::: ex 例 1.15-B6 · 内联汇编 `-O0` 正常、`-O2` 出错 {#ex-1.15-B6}

先猜：同一段内联汇编在 `-O0` 能跑、`-O2` 偶发错误，最可能缺的是 `volatile`、`"memory"` 还是寄存器 clobber？

一段 C 内联汇编直接发 `write`，`-O0` 正常，`-O2` 下输出偶尔丢失或长度错。写出四段分析：编译器可能做了哪些重排/复用？x86-64 要声明哪些 clobber？ARM64 的 `x8` 为什么不能随便分配？修法是什么？

::: sol 解答

现象：`-O0` 正常、`-O2` 偶发输出丢失、长度错或寄存器值被覆盖。机制：没有 `volatile` 的无输出 `asm` 可能被优化掉；没有 `"memory"` 时编译器不知道内核会读写缓冲区，会把写操作重排到 `syscall` 之后；没有声明 `rcx`/`r11` 时，编译器可能把活值放在这两个寄存器里，被 `syscall` 覆盖。证据：`cc -O0 -S` 与 `cc -O2 -S` 各生成一次，比较 `syscall` 前后的指令顺序；`objdump -d` 看 `syscall` 前是否设置了 `rax/rdi/rsi/rdx`；在 `-O2` 下加 `"memory"` 后复跑。修法：`__asm__ volatile("syscall" : "=a"(ret) : "a"(1L), "D"(fd), "S"(buf), "d"(n) : "rcx", "r11", "memory");`；ARM64 用 `register long x8 __asm__("x8") = 64;` 并用 `"r"(x8)` 约束，不能让编译器把号放到别的寄存器；RISC-V 同理用 `a7`。Rust 的 `asm!` 默认有副作用，但仍要 `lateout("rcx") _`、`lateout("r11") _`，内存语义默认保守。

**判据**：定位到约束/clobber 而不是指令本身；说清 `volatile`、`"memory"`、`rcx`/`r11` 三个点；ARM64/RISC-V 的号寄存器固定；给出 `-O0`/`-O2` 汇编对照或复跑证据。

:::
:::

## C 组 · 动手实验

::: ex 例 1.15-C1 · 在 VM 上读 `framed` 的序言与尾声 {#ex-1.15-C1}

先猜：`-O2 -fno-omit-frame-pointer` 下 `framed` 还会有 `push %rbp` 吗？`add_one` 会被内联吗？

在 VM 上写 `framed`，用 `-O2 -fno-omit-frame-pointer` 编译，反汇编看序言/尾声、参数寄存器与栈调整；用 `readelf -sW` 看 `framed`/`add_one` 的符号类型；运行程序确认结果。

::: sol C1 核对

```bash
mkdir -p ~/lab1c15_work && cd ~/lab1c15_work
cat > lab1c15_frame.c <<'EOF'
#include <stdio.h>

__attribute__((noinline)) static long add_one(long x) { return x + 1; }

__attribute__((noinline)) long framed(long x, long y)
{
    long local = x * 2;
    long *p = &local;
    long r = add_one(y);
    return *p + r + x;
}

int main(void) { printf("%ld\n", framed(10, 20)); return 0; }
EOF
cc -std=c17 -D_GNU_SOURCE -O2 -fno-omit-frame-pointer -c lab1c15_frame.c -o lab1c15_frame.o
cc -std=c17 -D_GNU_SOURCE -O2 -fno-omit-frame-pointer lab1c15_frame.c -o lab1c15_frame
./lab1c15_frame
objdump -d --no-show-raw-insn lab1c15_frame.o | sed -n '/<framed>:/,/^$/p'
readelf -sW lab1c15_frame.o | grep -E 'framed|add_one'
```

预期形状（以你机器输出为准）：程序打印 `30`；`framed` 的序言能看到保存 `x29/x30`（例如 `stp x29, x30, [sp, #-32]!` 或先 `sub sp` 再 `stp`）、把 `x0`/`x1` 落到栈上、调用 `add_one` 前把 `y` 移到 `x0`；尾声恢复 `x29/x30` 后 `ret`。`readelf -sW` 里 `framed` 是 `GLOBAL FUNC`，`add_one` 是 `LOCAL FUNC`；若 `add_one` 被内联，`noinline` 应阻止。`-O2` 下帧指针可能仍被省略，`-fno-omit-frame-pointer` 才强制保留；关键不是逐字匹配，而是能指出返回地址保存、参数落栈与调用点。

**判据**：程序输出 `30`；能在反汇编里指出 `stp`/`ldp`（或等价的 `str/ldr`）与 `bl add_one`；能指出 `x0`/`x1` 的保存；`readelf -sW` 的符号类型正确；能解释 `-O2` 与 `-fno-omit-frame-pointer` 的差别。无需 `sudo`；本套件未在 VM 上复跑，读数以你机器为准。

:::
:::

::: ex 例 1.15-C2 · 不依赖 libc 的 `_start`：`write`/`exit` 与 `objdump` {#ex-1.15-C2}

先猜：`cc -nostdlib -static` 链接一个只用 `write`/`exit` 的 aarch64 汇编，入口是 `_start` 还是 `main`？退出码能到 42 吗？

写一个 aarch64 的 `_start`，用 `write(1,msg,len)` 输出一行、用 `exit(42)` 结束；链接后运行，检查输出与退出码；用 `objdump` 找两次 `svc #0` 与 `x8` 的赋值；用 `readelf -h` 看入口与 `Machine`。

::: sol C2 核对

```bash
cd ~/lab1c15_work
cat > lab1c15_start.S <<'EOF'
    .section .rodata
msg:
    .ascii "ch15: write/exit via svc\n"
    .set len, . - msg

    .text
    .globl _start
    .type _start, %function
_start:
    mov     x8, #64           // SYS_write
    mov     x0, #1            // fd
    adr     x1, msg
    mov     x2, #len
    svc     #0

    mov     x8, #93           // SYS_exit
    mov     x0, #42
    svc     #0
    .size _start, . - _start
EOF
cc -nostdlib -static -Wl,-e,_start lab1c15_start.S -o lab1c15_start
./lab1c15_start; echo "exit=$?"
objdump -d lab1c15_start | sed -n '/<_start>:/,/^$/p'
readelf -h lab1c15_start | grep -E 'Entry|Type|Machine'
```

预期：输出 `ch15: write/exit via svc`，`exit=42`；`objdump` 里能看到两次 `svc #0`，第一次前有 `mov x8, #0x40`（64），第二次前有 `mov x8, #0x5d`（93）；`readelf -h` 的 `Entry point address` 指向 `_start`，`Machine: AArch64`。`Type` 取决于链接方式：`-static` 通常是 `EXEC`，`-static-pie` 仍是 `DYN`，以 `readelf -h` 为准。`_start` 没有调用者，不能 `ret`；结束必须走 `exit`/`exit_group`。

**判据**：输出正确且 `exit=42`；`objdump` 找到两次 `svc #0` 与 `x8=64/93`；`readelf -h` 入口指向 `_start`、`Machine: AArch64`；能解释 `-static` 与 `-static-pie` 的 `Type` 差异。无需 `sudo`；aarch64 VM 原生可跑。

:::
:::

::: ex 例 1.15-C3 · 9 参数与结构体返回：让编译器给出证据 {#ex-1.15-C3}

先猜：aarch64 的 9 参数函数，第 9 个参数会从 `[sp]` 取吗？`struct pair` 返回会用 `x0:x1` 吗？

写一个 9 个 `long` 参数的函数与一个返回 `struct pair` 的函数，用 `-O0 -S` 生成汇编；找出前 8 个参数落到 `x0`–`x7`、第 9 个从 `[sp]` 取、结构体返回用 `x0`/`x1`；运行程序核对结果。

::: sol C3 核对

```bash
cd ~/lab1c15_work
cat > lab1c15_args.c <<'EOF'
#include <stdio.h>

struct pair { long a; long b; };

__attribute__((noinline))
long f9(long a, long b, long c, long d, long e,
        long f, long g, long h, long i)
{
    return a + b + c + d + e + f + g + h + i;
}

__attribute__((noinline))
struct pair make_pair(long a, long b)
{
    struct pair p = { a, b };
    return p;
}

int main(void)
{
    struct pair p = make_pair(30, 12);
    printf("%ld %ld %ld\n", f9(1,2,3,4,5,6,7,8,9), p.a, p.b);
    return 0;
}
EOF
cc -std=c17 -D_GNU_SOURCE -O0 -S lab1c15_args.c -o lab1c15_args.s
cc -std=c17 -D_GNU_SOURCE -O0 lab1c15_args.c -o lab1c15_args
./lab1c15_args
grep -nE 'f9:|make_pair:|stp|ldr|str|ldp' lab1c15_args.s | head -40
```

预期：程序打印 `45 30 12`；`f9` 的 `-O0` 序言把 `x0`–`x7` 逐个 `str` 到栈上，第 9 个参数用 `ldr xN, [sp]`（或带偏移）取；`make_pair` 的返回把 `a`/`b` 放进 `x0`/`x1`，调用者从 `x0`/`x1` 取回。`-O2` 可能内联或常量折叠，所以取证用 `-O0` 或 `noinline`；偏移的具体数字随编译器版本变化，关键是第 9 个来自 `[sp]` 而不是 `x8`。

**判据**：程序输出 `45 30 12`；能在 `-O0` 汇编里指出 `x0`–`x7` 的保存与第 9 个的 `[sp]` 读取；能指出 `make_pair` 的 `x0`/`x1` 返回；知道第 7、8 个仍在 `x6`/`x7`。无需 `sudo`。

:::
:::

::: ex 例 1.15-C4 · 在写作机上交叉汇编 x86-64 与 RISC-V {#ex-1.15-C4}

先猜：写作机的 clang 21 能对 x86-64 与 RISC-V 出 ELF 目标文件吗？能链接成可执行文件并运行吗？

在写作机上写两段最小的 `_start`（x86-64 用 `syscall`，RISC-V 用 `ecall`），用 `clang --target=... -c` 生成目标文件；用 `file`/`readelf -h` 确认架构与 `Machine`；尝试链接，记录失败原因。明确哪些步骤未实测。

::: sol C4 核对

```bash
cd ~/lab1c15_work
cat > lab1c15_x86.s <<'EOF'
    .section .rodata
msg:    .ascii "ch15 x86\n"
    .set len, . - msg
    .text
    .globl _start
_start:
    movq    $1, %rax
    movq    $1, %rdi
    leaq    msg(%rip), %rsi
    movq    $len, %rdx
    syscall
    movq    $60, %rax
    movq    $42, %rdi
    syscall
EOF
cat > lab1c15_rv.s <<'EOF'
    .section .rodata
msg:    .ascii "ch15 rv\n"
    .set len, . - msg
    .text
    .globl _start
_start:
    li      a7, 64
    li      a0, 1
    la      a1, msg
    li      a2, 8
    ecall
    li      a7, 93
    li      a0, 42
    ecall
EOF
clang --target=x86_64-linux-gnu -c lab1c15_x86.s -o lab1c15_x86.o
clang --target=riscv64-linux-gnu -c lab1c15_rv.s -o lab1c15_rv.o
file lab1c15_x86.o lab1c15_rv.o
readelf -h lab1c15_x86.o | grep -E 'Class|Machine|Type'
readelf -h lab1c15_rv.o  | grep -E 'Class|Machine|Type'
# 链接与运行（预期失败，见下）
clang --target=x86_64-linux-gnu -nostdlib -static -Wl,-e,_start lab1c15_x86.o -o lab1c15_x86 2>&1 | head -5
```

预期形状：两个 `-c` 都成功，`file` 显示 x86-64 与 RISC-V 的 ELF 64-bit LSB relocatable；`readelf -h` 的 `Machine` 分别是 `Advanced Micro Devices X86-64`（62）与 `RISC-V`（243），`Type: REL`。链接步骤在写作机上失败：没有目标 sysroot/`crt1.o`/`-lc` 与目标链接器（macOS 上可能报 `ld: unknown options: --hash-style=gnu --eh-frame-hdr`），即使链出 ELF 也不能在 macOS 上执行。**链接与运行未实测**，原因是写作机不能链接、不能运行目标 ELF；若 `clang --print-targets` 没有 riscv64，则 RISC-V 的 `-c` 也标未实测并说明原因。VM 上只原生跑 aarch64，x86-64/RISC-V 需要 QEMU 或真机，本环境未确认。

**判据**：两个目标文件生成成功（或如实标未实测）；`Machine` 号 62/243 与 `Type: REL` 读对；链接失败原因说清（缺 sysroot/链接器，不是代码生成错误）；明确「交叉汇编 ≠ 交叉运行」；不编造运行输出。

:::
:::
