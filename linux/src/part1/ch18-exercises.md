# 1.18 习题集

三组分层：**A 组概念判断**考「会读、会说理由、会画因果」；**B 组诊断推理**给现象让你判层级、判 CSR、判修法；**C 组动手实验**把编译、链接、运行拆开，能做的只做编译步，运行步一律标未实测。每题的第一个动作都是「先猜」：把预期写下来，再去验证；猜错的地方才是这题的价值。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；A 组要求口述或写一段完整因果，B 组要求写成「现象 → 原因 → 修法 → 证据」四段。
2. 卡住了回对应小节的「即时自测」重读，不要直接看答案；A 组对应 1.18.1–1.18.3，B 组对应 1.18.4–1.18.10，C 组对应 1.18.4–1.18.9。
3. C 组全部**需 RISC-V 硬件/QEMU，本机未实测**。本机没有 RISC-V 硬件，也没有可用的 QEMU/GDB 运行链路；能做的只有「命令形状」与「编译到 `.s`/`.o`」这一步，而且这一步也未实测。
4. 凡是需要串口输出、`scause` 数值、GDB 寄存器、`tick` 时间戳的，答案只给「应看到的形状」与「判据」，不抄会话记录。
5. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch18-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 1.18-A1 · 三个特权级与三条指令 {#ex-1.18-A1}

先猜：`sret` 能不能从 U 态执行？`mret` 之后一定回到 S 吗？`ecall` 是「跳转」还是「陷入」？

画出 M/S/U 三层，标出 `ecall`、`sret`、`mret` 的方向与触发条件；说明每条指令从哪一级发出、回到哪一级由谁决定；解释为什么 U 态访问 `sstatus` 会失败，而 S 态访问 `mstatus` 也会失败。

::: sol 解答

`ecall` 是陷入（trap），不是普通跳转：硬件保存 PC 与原因、切到更高特权级、跳到 `stvec`/`mtvec`。U 的 `ecall` 进 S（`scause=8`），S 的 `ecall` 进 M（`scause=9`），M 的 `ecall` 无处可去（`scause=11`，通常由 M 固件处理或报错）。`sret` 只能从 M 或 S 执行（U 执行是 illegal），它按 `sstatus.SPP` 决定回 U 还是 S；`mret` 只能从 M 执行，按 `mstatus.MPP` 决定回 U 还是 S，**不一定是 S**。向下返回不是函数调用：不保存通用寄存器、不压栈，只改 PC 与中断使能。U 态没有任何 CSR 写权限，读 `sstatus` 也 illegal；S 态能读写 S 态 CSR 与 `satp`，但 `mstatus/mepc/mtvec/mcause` 属于 M，访问即 illegal instruction（是否委托由 `medeleg`/`mideleg` 决定，异常委托不改变 CSR 的属主）。

**判据**：三层方向正确；`ecall` 说成陷入；`sret` 看 `SPP`、`mret` 看 `MPP`；知道 `mret` 也能直接回 U；能举出 U/S 越级访问 CSR 的后果。

:::
:::

::: ex 例 1.18-A2 · trap 的硬件动作与 `scause` 编码 {#ex-1.18-A2}

先猜：trap 时硬件会保存 `a0` 吗？定时器中断的 `scause` 是 `5` 还是 `0x8000000000000005`？`ecall` 的 `sepc` 指向下一条指令吗？

按顺序写出 trap 的硬件五步；给出 `scause` 的判别方法；列出 `8/9/11` 与 `5/7` 的含义；说明 `sepc` 在 `ecall` 与中断两种情形下返回前各要不要 `+4`。

::: sol 解答

五步：① 当前 PC 写 `sepc`；② 原因写 `scause`；③ 附加信息写 `stval`；④ 跳到 `stvec`；⑤ 清 `SIE`、切到 S。通用寄存器一个都不保存，`a0` 也不会自动保存。`scause` 在 RV64 上最高位（bit63）为 1 表示中断，低位移出编号；所以 S 定时器中断是 `0x8000_0000_0000_0005`，低 8 位是 `5`，正文 P3 用 `scause >> 63 == 1 && (scause & 0xff) == 5` 判断。异常侧 `8`=U 的 `ecall`、`9`=S 的 `ecall`、`11`=M 的 `ecall`；中断侧 `5`=S 定时器、`7`=M 定时器。`ecall` 的 `sepc` 指向 `ecall` 指令本身，返回前必须 `+4`；中断的 `sepc` 指向被打断的指令，返回时要重新执行它，绝不能 `+4`。

**判据**：五步顺序正确；知道通用寄存器不保存；能写出中断的最高位；`8/9/11` 与 `5/7` 不混；`ecall` 加 4、中断不加 4 说清。

:::
:::

::: ex 例 1.18-A3 · SBI 的契约与两个易错点 {#ex-1.18-A3}

先猜：SBI 的返回值在 `a0` 还是 `a1`？legacy 关机是 `0x07` 还是 `0x08`？SRST 成功后会返回到 `ecall` 的下一条吗？

说明 SBI 连接哪两个特权级、为什么它既不是系统调用也不是硬件；写出 `a6/a7/a0–a5` 的分工与返回约定；给出 `putchar`、legacy 关机、SRST、TIME 的 EID；解释 SRST 的 `a0/a1` 各是什么。

::: sol 解答

SBI 是 S 态通过 `ecall` 调用 M 态固件的 ABI；系统调用是 U→S，硬件只认 `ecall`，SBI 的语义由固件实现。约定：`a7=EID`、`a6=FID`、`a0–a5`=参数；返回 **`a0`=错误码**（0 成功，负失败）、`a1`=值。`putchar`：EID `0x01`，`a0`=字符；legacy 关机：EID `0x07`（`0x08` 是 legacy 发 IPI）；SRST：EID `0x53525354`（`"SRST"`），FID 0，`a0=0` 表示关机、`a1=reason`，**成功不返回**；TIME：EID `0x54494D45`（`"TIME"`），FID 0，`a0`=绝对时间。所以「SBI 调用一定返回」是错的：关机路径要么不返回，要么由固件直接复位。

**判据**：`a0` 错误码、`a1` 值不写反；`0x07`/`0x08` 不混；SRST 的 EID 与 `a0=0` 说对；知道成功关机不返回；能说清它与系统调用的层级差别。

:::
:::

::: ex 例 1.18-A4 · 链接脚本、入口与第一条指令 {#ex-1.18-A4}

先猜：改了 `ENTRY(_start)` 会不会把 `.text` 搬到 `0x80200000`？`la` 取的是当前 PC 还是链接地址？`sbss/ebss` 能不能用 Rust 数组长度代替？

说明 `BASE_ADDRESS=0x80200000` 的由来、`ENTRY` 的作用边界、`.text.entry` 为什么必须最先；写出 `_start` 的三件事；解释 `la` 的展开与 `satp=0` 的关系；说明 `sbss/ebss` 为什么必须是链接器符号。

::: sol 解答

OpenSBI 占 `0x8000_0000` 起 2 MiB，内核链接到 `0x8020_0000` 才不与固件重叠；`-bios none` 时才改用 `0x8000_0000`。`ENTRY` 只写 ELF 入口字段，不移动任何段；把 `_start` 放到 `0x8020_0000` 靠的是 `.text.entry` 排在 `.text` 最前、且 `.` 从 `BASE_ADDRESS` 开始。`_start`：清 `.bss`（按 `sbss..ebss`）、设 `sp=boot_stack_top`、`call rust_main`。`la` 展开为 `auipc`+`addi`，得到链接地址；OpenSBI 已把 `satp` 置 0、MMU 关闭，链接地址即物理地址，所以能直接取指。`sbss/ebss` 是链接器在布局完成后给出的地址边界，`.bss` 里还有对齐填充与其他输入节，Rust 侧无法用某个数组长度精确复现，必须引用符号。

**判据**：2 MiB 的理由说对；`ENTRY` 与段地址分开；`.text.entry` 的作用说对；三件事齐全；`la`/`satp` 关系说清；知道清零边界必须用符号。

:::
:::

## B 组 · 诊断推理

::: ex 例 1.18-B1 · QEMU 无输出，PC 停在 `0x80000000` {#ex-1.18-B1}

先猜：这是链接地址错了，还是串口初始化错了？`-bios default` 与 `0x8000_0000` 能共存吗？

现象：`qemu-system-riscv64 -machine virt -nographic -bios default -kernel hello` 没有任何输出，GDB 看到 PC 停在 `0x8000_0000`。给出原因、修法与两条验证命令。

::: sol 解答

原因：镜像链接到了 `0x8000_0000`，与 OpenSBI 的固件区重叠；`-bios default` 先从 `0x8000_0000` 跑固件，你的入口要么覆盖了固件、要么根本没被跳到。修法：`BASE_ADDRESS` 改回 `0x8020_0000` 重新链接；或者保留 `0x8000_0000` 但改用 `-bios none`，让 QEMU 直接从该地址取指。验证：`llvm-readelf -h hello | grep Entry` 看入口是否为 `0x80200000`；`llvm-objdump -d hello | head` 看第一条指令是否为 `_start` 的清 `.bss` 序列。若入口对但仍停在 `0x80000000`，检查是否误加了 `-bios none` 却链接到 `0x80200000`（反向同样错）。

**判据**：定位到「地址与固件区重叠」而非 UART；知道 `-bios default`/`-bios none` 与两个基址的配对；给出 `readelf`/`objdump` 两类证据。

:::
:::

::: ex 例 1.18-B2 · `ecall` 之后原地死循环 {#ex-1.18-B2}

先猜：是 `ecall` 没有进 S，还是返回地址没前进？`sepc` 此时指向哪条指令？

现象：U 态 `ecall` 进入 S 的 handler，打印了一次，`sret` 后程序又执行同一条 `ecall`，无限重复。给出原因、修法，并说明为什么中断不能照做。

::: sol 解答

原因：`ecall` 触发 trap 时，硬件把 `sepc` 写成 `ecall` 指令本身的地址；handler 处理完不修改 `sepc`，`sret` 就回到同一条 `ecall`，再次陷入。修法：在系统调用返回前执行 `tf.sepc += 4`（或 `csrw sepc, sepc+4`）。中断不同：中断的 `sepc` 指向被打断的那条指令，返回时要重新执行它，加 4 会跳过一条无辜指令，行为变得随机。验证：在 handler 里打印 `tf.sepc` 与 `ecall` 的符号地址比对；或 GDB 单步看 `sret` 后 PC 是否回到同一地址。

**判据**：指出 `sepc` 指向 `ecall` 本身；修法精确到 `+4`；能对比中断情形；给出 `sepc` 证据。

:::
:::

::: ex 例 1.18-B3 · 定时器完全不响，或者只响一次 {#ex-1.18-B3}

先猜：只开 `sie.STIE` 够不够？`mtimecmp` 只写一次会不会一直触发？

现象 A：设了 `set_timer`，但一次 tick 都没有；现象 B：来了 `tick 1` 之后再也没有 `tick 2`。分别给出原因与修法。

::: sol 解答

A：中断要过两道门——`sie.STIE`（bit5，允许 S 定时器中断）与 `sstatus.SIE`（bit1，总闸），只开前者，中断挂起在 `sip.STIP` 但永远不进入 trap；另外 `stvec` 必须在开门前设好，否则可能跳到旧/空向量。修法：按 `stvec → sie.STIE → sstatus.SIE → set_timer` 的顺序初始化。B：`mtime >= mtimecmp` 是一次性比较，handler 不重新写 `mtimecmp`，时间不再前进，所以只响一次。修法：每次 tick 里重新 `set_next_timer()`（读 `rdtime` 加 100 000，再 SBI `TIME`）。验证：在 handler 里打印 `scause` 与下一次的绝对时间；检查 `sie/sstatus` 的位。

**判据**：两道门与 `stvec` 顺序说对；知道 `mtimecmp` 是一次性；修法包含重新上弦；不把「没开总闸」误判成「时钟频率不对」。

:::
:::

::: ex 例 1.18-B4 · S 态写 CLINT 报 fault，`rdtime` 报 illegal {#ex-1.18-B4}

先猜：`0x0200_4000` 是普通内存还是 M 态设备？`rdtime` 是特权指令吗？为什么它会被禁止？

现象 A：S 态执行 `sd` 到 `0x0200_4000`，报 store access fault；现象 B：S 态执行 `rdtime`，报 illegal instruction。分别给出原因与两条修法。

::: sol 解答

A：`0x0200_4000` 是 CLINT 的 `mtimecmp`，属于 M 态设备；S 态的每次访存都要过 PMP，固件通常不给 S 访问这段 MMIO，所以 store access fault。修法：改用 SBI `TIME`（EID `0x54494D45`）让 M 代写绝对时间；不要试图在 S 态直接碰 CLINT。B：`rdtime` 读的是 `time` CSR，S 态能否读由 `mcounteren.TM` 放行；固件若清掉该位，S 执行就 illegal。修法：请固件设置 `mcounteren.TM=1`，或改用 SBI `TIME`/`get_time` 取值。验证：看 `mcause/scause` 的编号（access fault 与 illegal 不同）；检查 PMP 配置与 `mcounteren`。

**判据**：把 A 定位到 PMP、B 定位到 `mcounteren`；修法都指向 SBI；不把两者混成「地址写错」；能说出 `scause` 会不同。

:::
:::

::: ex 例 1.18-B5 · 打印第一个字符后卡死，或只输出半行 {#ex-1.18-B5}

先猜：卡死是 UART 没初始化，还是轮询了错误的寄存器？半行是丢了字符，还是被中断打断？

现象 A：直写 UART，第一个字符后不再动；现象 B：`println!` 输出到一半停止，尤其在 `panic` 路径。给出原因、修法与验证。

::: sol 解答

A：常见三因——`LSR` 偏移读错（应为 `0x05`，bit5 `THRE`）、没初始化 `LCR`（应为 `0x03`，8N1），或初始化顺序反了（先写 `THR` 再设 `LCR`，第一字符用错帧格式）。轮询卡死时 `LSR.THRE` 一直是 0，说明 UART 没被正确配置或地址不是 `0x1000_0000`。修法：先 `LCR=0x03`、`FCR=0x01`、`IER=0x00`，再轮询 `LSR` 的 bit5 后写 `THR`；换行发 `\r\n`，否则是阶梯状而不是卡死。B：`panic` 路径又开了中断，UART 输出被中断处理重入，两个上下文交错写 `THR`，看到半行。修法：panic 里关中断（清 `sstatus.SIE`、`sie`），或用自旋锁保护输出。验证：`objdump` 看偏移常量；在发送前后翻转一个 GPIO/打印标记，确认是否重入。

**判据**：A 落到 `LCR`/`LSR` 偏移与顺序；B 落到重入而非「字符丢了」；修法包含关中断或加锁；知道 `\r\n` 与卡死是两件事。

:::
:::

## C 组 · 动手实验（需 RISC-V 硬件/QEMU，本机未实测）

> **本组全部需 RISC-V 硬件/QEMU，本机未实测。** 本机没有 RISC-V 硬件，也没有可用的 QEMU/GDB 运行链路；C1 的编译步也只给命令形状（工具链后端未确认），C2–C5 的链接与运行都没有本机证据。做题时把「我预期看到什么」写在命令前面，再去有硬件的机器上核对；不要把下面的输出形状当成实测记录。

::: ex 例 1.18-C1 · 只出汇编与目标文件 {#ex-1.18-C1}

先猜：`clang --target=riscv64-unknown-elf -S` 会不会调用链接器？`la` 在 `.s` 里会展开成几条指令？`.text.entry` 段名会出现在目标文件里吗？

用最小 C 文件（一个函数）与一段 `_start` 汇编，分别执行 `-S` 与 `-c`；在 `.s` 里找 `auipc`/`addi` 对，用 `readelf -S`（或 `llvm-readelf`）看节名。说明这一步为什么不能得到可运行的 ELF。本题的运行验证需 RISC-V 硬件/QEMU，本机未实测。

::: sol 解答

`-S` 只到汇编，`-c` 只到 `ET_REL` 目标文件，都不调用链接器；`la` 通常展开成 `auipc`+`addi`（取 PC 相对高 20 位与低 12 位），`.section .text.entry` 会原样出现在 `.s` 与 `.o` 的节表里。拿不到 ELF 的原因：没有 riscv64 链接器与启动文件/库，`-c` 产物没有地址分配、没有程序头，也没有入口；即便手工链接，还需要链接脚本把 `.text.entry` 放到 `0x80200000`，而运行还需要 QEMU 或硬件。命令形状：`clang --target=riscv64-unknown-elf -march=rv64gc -mabi=lp64d -ffreestanding -S t.c -o t.s` 与 `... -c t.c -o t.o`。**本机未实测**：工具链是否带 RISC-V 后端未确认，输出不作证据。

**判据**：知道 `-S`/`-c` 不链接；能在 `.s` 里指出 `auipc`+`addi`；能说出「没有地址分配/程序头/入口」三缺一不可；如实标注未实测。

:::
:::

::: ex 例 1.18-C2 · 入口与段布局 {#ex-1.18-C2}

先猜：链接脚本里 `.text` 的地址会是 `0x80200000` 还是 `0`？`.bss` 会不会占文件空间？`Entry` 字段由谁决定？

把 P1 链接成 ELF 后，用 `llvm-readelf -h/-S` 与 `llvm-objdump -d` 检查入口、`.text` 地址、`.bss` 类型与第一条指令；若 `.text` 是 0，说明哪一步没生效？本题的链接/运行步需 RISC-V 硬件/QEMU，本机未实测。

::: sol 解答

正确结果：`Entry point address: 0x80200000`、`Class: ELF64`、`Machine: RISC-V`；`.text` 的地址是 `0x80200000`；`.bss` 是 `NOBITS`，文件里只有节头，不占文件空间；第一条指令是 `_start` 的清 `.bss` 序列（`la t0, sbss` 展开的 `auipc/addi`）。若 `.text` 是 0，说明 `-T linker.ld` 没生效：检查 `.cargo/config.toml` 是否在项目根目录、`rustflags` 是否带 `-C link-arg=-T...`，或 `rustc` 命令是否漏了 `-C link-arg`。若 `Entry` 不是 `0x80200000`，检查 `ENTRY(_start)` 与 `.text.entry` 是否排在 `.text` 最前。**需 RISC-V 硬件/QEMU 验证运行，本机未实测**；链接步本身也需要 riscv64 链接器。

**判据**：三个字段读对；`.bss` 的 `NOBITS` 说对；`.text=0` 的归因指向 `-T` 未生效；`Entry` 异常归因指向 `ENTRY`/段序。

:::
:::

::: ex 例 1.18-C3 · P1：SBI 打印与关机 {#ex-1.18-C3}

先猜：`putchar` 是一个字符一次 `ecall`，还是一行一次？关机用 legacy `0x07` 还是 SRST？打印后 QEMU 会自动退出吗？

在 QEMU `virt` 上跑 P1（`-bios default -kernel hello`），确认输出 `hello, myrcore` 并退出；若只打印不退出，改哪里？若什么都不打印，先用 `-s -S` 看 PC 在哪。本题需 RISC-V 硬件/QEMU，本机未实测。

::: sol 解答

P1 的 `Console::write_str` 逐字节调用 EID `0x01`，所以是一个字符一次 `ecall`；关机用 SRST（EID `0x53525354`，FID 0，`a0=0` 表示关机，`a1` 是失败标志），不是 legacy `0x07`；SRST 成功不返回，QEMU 应退出。只打印不退出：检查 SRST 的 EID/FID/`a0` 是否写错，或固件是否支持 SRST（老版本只支持 legacy 关机，可退回 EID `0x07`）。什么都不打印：`-s -S` 配合 GDB 看 PC 是否在 `0x80200000`、`sp` 是否已设、`.bss` 是否清对。**需 RISC-V 硬件/QEMU，本机未实测**；输出只作形状。

**判据**：知道 putchar 逐字符；SRST 与 legacy 关机不混；能按「不退出 → SRST 参数」「无输出 → PC/链接地址」分流；标注未实测。

:::
:::

::: ex 例 1.18-C4 · P2：M → S → U 与两级 trap {#ex-1.18-C4}

先猜：`medeleg` 不设时，U 的 `ecall` 会进 S 还是 M？`mret` 前 `MPP` 应为几？PMP 全关时 S 态第一次取指会怎样？

用 `-bios none` 跑 P2，确认 `M: hello from M-mode`、`U`、`M: SRST -> test finisher` 三行；用 GDB 在 `s_trap_handler` 与 `m_trap_handler` 下断点，确认 U 的 `ecall` 先进 S、S 的 `ecall` 再进 M。本题需 RISC-V 硬件/QEMU，本机未实测。

::: sol 解答

`medeleg` 的 bit8 对应 `ecall-from-U`，不设就仍由 M 处理，U 的 `ecall` 不会进 `s_trap_handler`，现象是只看到 `M:` 前缀的输出而没有 `U`。`mret` 前 `MPP=1`（S）、`MPIE=1`、`MIE=0`、`mepc=s_main`；`sret` 前 `SPP=0`（U）、`SPIE=1`、`SIE=0`、`sepc=u_main`。PMP 若 `pmpcfg0=0`，S/U 的第一次取指就 access fault，表现为 M 打印后立刻卡死或反复 trap；P2 用 `pmpaddr0=0x3fff...` + `pmpcfg0=0x0f` 覆盖全地址 RWX。关机走 test finisher（`0x0010_0000` 写 `0x5555`），因为 `-bios none` 没有 M 固件可调 SRST。**需 RISC-V 硬件/QEMU，本机未实测**。

**判据**：`medeleg` bit8 与现象对应；`MPP/SPP` 的值与「回哪级」一致；PMP 全关的后果说对；知道 test finisher 的地址与写入值。

:::
:::

::: ex 例 1.18-C5 · P3：tick 计数与自动关机 {#ex-1.18-C5}

先猜：10 MHz 下 10 ms 是多少 tick？`set_timer` 的 `a0` 是间隔还是绝对时间？第 5 次 tick 后程序怎么退出？

跑 P3，确认 `timer armed` 后每 10 ms 一行 `tick N`，第 5 次后关机；把 `sie.STIE` 或 `sstatus.SIE` 各关一个，记录现象差别；把 handler 里的 `set_next_timer()` 注释掉，记录现象。本题需 RISC-V 硬件/QEMU，本机未实测。

::: sol 解答

10 MHz × 10 ms = 100 000 tick；`a0` 传的是「当前 `rdtime` + 100 000」的**绝对时间**，不是间隔。第 5 次 tick 后调用 SRST 关机（`a0=0`，`a1=0`），成功不返回。只关 `sie.STIE`：`sstatus.SIE=1` 但该类中断不被允许，一次 tick 都没有；只关 `sstatus.SIE`：中断挂在 `sip.STIP`，同样不进入 trap；两者都开才响。注释掉 `set_next_timer()`：`mtimecmp` 停在旧值，`mtime` 早已越过，理论上会持续挂起，但因为 handler 不重新上弦、且中断在入口被清，表现为只来一次或立刻重复触发（依固件与 `sip` 行为），这正是「必须重新上弦」的反例。**需 RISC-V 硬件/QEMU，本机未实测**；时间戳与行数只作形状。

**判据**：100 000 算对；绝对时间说对；两道门的现象能区分；知道不重新上弦的后果；标注未实测。

:::
:::
