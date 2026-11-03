# 1.18 章末总结

## 三段主线：三个单元，一条因果链

**第一段，硬件的契约（1.18.1–1.18.3）。** RISC-V 64 有 32 个通用寄存器，`x0` 恒 0，其余按 ABI 分成参数、临时与被调用者保存；特权级相关的状态不在通用寄存器里，而在 CSR 里，用 `csrrw/csrrs/csrrc` 读写。M 是最高特权，通常跑 OpenSBI 一类固件；S 跑内核，能用 `satp` 开页表；U 跑应用，碰不到任何特权 CSR。向上只有一条路——`ecall`：U 的 `ecall` 进 S（`scause=8`），S 的 `ecall` 进 M（`scause=9`），M 的 `ecall` 不往外走（`scause=11`）。向下也只有两条：`sret` 按 `SPP` 回 U 或 S，`mret` 按 `MPP` 回 S 或 U。SBI 就是「S 用 `ecall` 请 M 做事」的那层 ABI：EID 放 `a7`、FID 放 `a6`、参数在 `a0`–`a5`，返回时 **`a0` 是错误码、`a1` 是值**。它不是系统调用，不是硬件指令，也不是内核的一部分；换一块板子，只要固件守这个契约，内核代码就不用改。理解了这一层，才能解释为什么内核第一行打印必须借固件之手。

**第二段，把第一条指令放到正确的地址（1.18.4–1.18.6）。** QEMU `virt` 上电先跑 M 态固件，OpenSBI 占住 `0x8000_0000` 起的 2 MiB，再用 `mret` 把 S 态 PC 设到 `0x8020_0000`；所以链接脚本必须写 `BASE_ADDRESS = 0x80200000`，并把 `.text.entry` 放在 `.text` 最前，`_start` 才会落在固件让出的第一格。`_start` 只做三件事：按 `sbss..ebss` 清 `.bss`、把 `sp` 设到 `boot_stack_top`、`call rust_main`。`la` 是 `auipc`+`addi` 的伪指令，得到的是链接地址；OpenSBI 已经关了 MMU（`satp=0`），所以链接地址就是物理地址，这也是为什么 P2 用 `-bios none` 时要整体搬到 `0x8000_0000`。Rust 侧的最小集合是 `#![no_std]`、`#![no_main]`、`#[panic_handler]`，再加 `panic = "abort"`——没有 unwinding 运行时，默认 `unwind` 会链接失败。输出有两条路：SBI `putchar` 每次一个字符一次 `ecall`，可移植但慢；直接写 16550A 的 `THR` 快，但要自己初始化 `LCR=0x03`、`FCR`、关 `IER`，并在每次写前轮询 `LSR` 的 `THRE`（偏移 `0x05`，bit5）。`volatile` 只阻止编译器合并读，不是内存屏障。

**第三段，把 trap 变成可返回的函数调用（1.18.7–1.18.10）。** trap 发生时硬件只做五件事：把 PC 写进 `sepc`、把原因写进 `scause`（坏地址进 `stval`）、跳到 `stvec`、清 `SIE`、切到 S；32 个通用寄存器一个都不保存，这是软件入口的责任。入口先用 `csrrw sp, sscratch, sp` 把用户 `sp` 换进 `sscratch`、把内核栈换进 `sp`，再分配 272 字节（34 槽）的 `TrapFrame`，把 `x1`、`x3`–`x31` 与从 `sscratch` 取回的 `x2` 存进去，再存 `sepc`/`sstatus`。分发在 Rust 里：`scause` 最高位为 1 是中断，为 0 是异常；`ecall` 的 `sepc` 指向 `ecall` 本身，返回前必须 `+4`，否则原地死循环；中断绝不能 `+4`。返回时先写回 `sstatus`、再写回 `sepc`，恢复通用寄存器，最后 `sret`——顺序反了就没有机会补救。`sscratch` 的初值必须在第一次 trap 之前设好，否则 `csrrw` 换出一个 0，`addi sp, sp, -272` 直接掉进非法地址。时钟中断把这一切变成循环：S 态不能写 CLINT 的 `mtimecmp`，只能通过 SBI `TIME`（EID `0x54494D45`）传**绝对时间**；`sie.STIE` 与 `sstatus.SIE` 两道门都开才会进 trap；handler 里必须重新上弦，否则只响一次。P2 再把 M 态拉进来：配 PMP、用 `medeleg` 把 `ecall-from-U` 委托给 S、`mret` 到 S、`sret` 到 U，U 的 `ecall` 回到 S，S 的 `ecall` 回到 M，最后由 test finisher 让 QEMU 退出。

一句话主线：**先把特权级与 CSR 的契约钉死，再把第一条指令钉在固件让出的地址上，然后用一个 34 槽的现场把 trap 变成可返回的调用，最后让定时器反复敲门；每一步都只相信地址、CSR 与串口这三种证据，没有证据的就标未实测。**

## 表 1：三个特权级的分工

| 特权级 | 谁跑在这里 | 能做什么 / 不能做什么 | 向上与向下 | 关键 CSR |
|:--|:--|:--|:--|:--|
| **M** | ZSBL、OpenSBI、本章 P2 的 `m_main` | 最高特权；可读写全部 CSR、直接访问 CLINT/PLIC 等 M 态设备；不受 PMP 限制，但负责给 S/U 配 PMP | 入口：`ecall`（cause 11）；出口：`mret`（按 `MPP` 回 S 或 U） | `mstatus/mepc/mtvec/mcause/mtval/medeleg/mideleg/pmpcfg0/pmpaddr0` |
| **S** | Linux 内核、本章 P1/P3 与 P2 的 `s_main` | 可用 `satp` 开页表、处理 U 的 `ecall` 与 S 态中断；**不能**读写 M 态 CSR，**不能**直接写 CLINT，碰了就是 illegal instruction 或 access fault | 入口：U 的 `ecall`（cause 8）或 S 中断；出口：`sret`（按 `SPP` 回 U 或 S）；向 M 请求走 `ecall` + SBI | `sstatus/sepc/stvec/scause/stval/sscratch/satp/sie/sip` |
| **U** | 应用程序、本章 P2 的 `u_main` | 只能执行非特权指令、访问自己页表允许的地址；任何 CSR 访问与特权指令都触发 illegal instruction；只能通过 `ecall` 进 S | 入口：无（只能被 `sret` 进入）；出口：`ecall`（cause 8） | 无（`cycle/time/instret` 是否可读由 `mcounteren`/`scounteren` 放行） |

## 表 2：本章用到的 CSR

| CSR | 读写 | 作用 | trap 时谁改 |
|:--|:--|:--|:--|
| `mstatus` | 读写 | M 态全局中断 `MIE`（bit3）、`MPIE`（bit7）、`MPP`（bit11–12）、`MPRV` | 硬件改 `MIE/MPIE/MPP`；`mret` 再从 `MPIE` 恢复 |
| `mepc` | 读写 | M 态 trap 的返回 PC | 硬件写入；软件可改 |
| `mtvec` | 读写 | M 态 trap 入口；低 2 位选直接/向量模式 | 不自动改，软件启动时设 |
| `mcause` | 读 | M 态 trap 原因；最高位 1=中断，0=异常 | 硬件写入 |
| `mtval` | 读 | 附加信息（坏地址、非法指令编码） | 硬件写入 |
| `medeleg` | 读写 | 把指定异常委托给 S 态；bit8 对应 `ecall-from-U` | 不自动改 |
| `pmpcfg0`/`pmpaddr0` | 读写 | 物理内存保护；决定 S/U 能访问哪些地址 | 不自动改；M 态启动时配 |
| `satp` | 读写 | S 态页表根；`0` 表示 MMU 关闭 | 不自动改 |
| `sstatus` | 读写 | S 态 `SIE`（bit1）、`SPIE`（bit5）、`SPP`（bit8） | 硬件改 `SIE/SPIE/SPP`；`sret` 从 `SPIE` 恢复 |
| `sepc` | 读写 | S 态 trap 的返回 PC | 硬件写入；`ecall` 返回前软件 `+4` |
| `stvec` | 读写 | S 态 trap 入口；低 2 位选模式 | 不自动改，软件启动时设 |
| `scause` | 读 | S 态 trap 原因；编码同 `mcause` | 硬件写入 |
| `stval` | 读 | S 态附加信息 | 硬件写入 |
| `sscratch` | 读写 | 本章用它暂存内核栈顶/用户 `sp`，配合入口换栈 | 不自动改；第一次 trap 前必须设好 |
| `sie`/`sip` | 读写 | S 态中断使能与挂起；`STIE`/`STIP` 是 bit5 | 硬件置 `STIP`；软件开 `STIE` |
| `mcounteren` | 读写 | 放行 S 态读 `cycle/time/instret`；`TM` 位关掉后 `rdtime` 触发 illegal instruction | 不自动改；由 M 态固件设置 |

## 表 3：一次 trap 的完整路径

| 阶段 | 谁做 | 发生什么 | 证据 |
|:--|:--|:--|:--|
| **1 触发** | 硬件 + 指令 | U 执行 `ecall`（cause 8）、S 执行 `ecall`（cause 9）、定时器置 `sip.STIP`（中断 5） | 触发指令的地址；`sie/sstatus` 的使能位 |
| **2 硬件入场** | 硬件 | PC → `sepc`；原因 → `scause`；附加信息 → `stval`；跳 `stvec`；清 `SIE`；切到 S；通用寄存器不保存 | GDB 停在 `stvec` 时 `pc`/`scause`/`sepc` |
| **3 换栈与建帧** | 入口汇编 | `csrrw sp, sscratch, sp`；`sp -= 272`；存 `x1`、`x3`–`x31`、从 `sscratch` 取回的 `x2`；存 `sepc`/`sstatus` | `sp` 落在内核栈；`TrapFrame` 34 槽偏移对得上 |
| **4 分发** | Rust handler | `a0 = &TrapFrame`；读 `scause`；最高位 1 走中断、0 走异常；`ecall` 用 `x[17]`（`a7`）当调用号 | handler 里打印的 `scause`/`tf.sepc` |
| **5 处理** | Rust handler | 打印、计数、`set_next_timer`；需要固件时再 `ecall` 进 M（SBI） | 串口输出；`tick` 递增 |
| **6 返回** | 入口汇编 | 写回 `sepc`/`sstatus`；恢复 31 个通用寄存器；`sp += 272`；`csrrw sp, sscratch, sp`；`sret` | 被中断代码继续执行，寄存器值不变 |
| **7 `ecall` 特例** | Rust handler | `sepc += 4` 跳过 `ecall`；中断绝不加 4 | 不加则原地死循环；加错则跳过一条无辜指令 |

## 下一站

1.19 把本章的骨架扩成「像内核的内核」：[1.19 从 rCore 看内核：任务、地址空间与文件系统](ch19.md) 会把「打印 tick」换成「切换任务」、把「关机」换成「调度」，并让你看到 `TrapFrame` 与上下文切换如何共用同一套保存/恢复手法。再往后，[2.1.1 一次系统调用穿过什么](../part2/ch01.md#sec-2.1.1) 会把 U 态的 `ecall` 与本机的 `syscall` 对齐。

自检入口：[闭卷回忆卡](ch18-recall.md) 先合上正文叫出 16 个答案；[习题集](ch18-exercises.md) 的 B 组专练「现象 → 原因 → 修复」；[学习目标自检表](ch18-checklist.md) 接管 1.18.10 的出口；[勘误与版本注记](ch18-errata.md) 的「SBI 只是固件接口」「QEMU 未安装」两条请先读一遍。
