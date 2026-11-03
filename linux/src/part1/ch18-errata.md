# 1.18 勘误与版本注记

这一页收本章最容易「换一块板子、换一版固件、换一个工具链就不成立」的东西：SBI 的定位、三个特权级的权限边界、`scause` 的编码、`mret`/`sret` 的语义、链接地址与固件区的重叠，以及本机的环境边界。正文的 `errata` 盒讲理解陷阱；这一页讲**换平台、换固件、换工具链之后要复核什么**。

**本章基线**：正文与套件里的地址、EID、CSR 位来自 RISC-V 特权级规范、SBI 规范与 QEMU `virt` 源码；**运行结果没有任何本机证据**。本机没有 RISC-V 硬件，也没有可用的 QEMU/GDB 运行链路（`qemu-system-riscv64`、`gdb-multiarch` 不在实验环境里）；Rust 的 `riscv64gc-unknown-none-elf` target 未确认。交叉编译最多到 `clang --target=riscv64 -S/-c` 的 `.s`/`.o`，不能链接成 ELF、不能执行，且这一步同样未实测。凡标「未实测」的，见末节。

## 1. 十六条容易搬家的结论

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「SBI 就是 RISC-V 的系统调用」 | SBI 是 **S 态调用 M 态固件的 ABI**，只用 `ecall` 作为陷入手段；系统调用是 U→S，SBI 是 S→M。它也不是硬件指令、不是内核的一部分，换 OpenSBI/U-Boot 只要守契约，内核侧不用改 | 看 `ecall` 前后特权级：S 执行 `ecall` 时 `mcause=9`（M 侧看到），U 执行时 `scause=8`（S 侧看到）；确认 `putchar`/`SRST` 的实现不在你的内核里 |
| 「三个特权级只是标签，S 也能读写 `mstatus`」 | M 可访问全部 CSR 与 M 态设备；S 只能访问 S 态 CSR 与 `satp`，碰 `mstatus/mepc/mtvec/mcause` 是 illegal instruction；U 连 `sstatus` 都不能读，任何特权指令都 illegal。S/U 的每次访存还要过 PMP | 在 S 态执行 `csrr t0, mstatus`，应触发 illegal；在 U 态执行 `csrr t0, sstatus` 同理；S 态写 `0x0200_4000` 应 store access fault |
| 「`scause` 就是一个小整数，`5` 表示定时器」 | RV64 的 `scause` 最高位（bit63）区分中断（1）与异常（0），低位才是编号。S 定时器中断是 `0x8000_0000_0000_0005`，不是 `5`；`8/9/11` 是 U/S/M 的 `ecall`，`5/7` 是 S/M 定时器中断 | 打印 `scause` 的十六进制；用 `scause >> 63` 与 `scause & 0xff` 分别判断；对照特权级规范的异常/中断编号表 |
| 「`mret`/`sret` 就是 `ret`，回去接着执行」 | 它们不是函数返回：不恢复通用寄存器，只按 `MPP`/`SPP` 切特权级、按 `mepc`/`sepc` 改 PC、用 `MPIE`/`SPIE` 恢复中断使能，并把 `MPP`/`SPP` 置为最低特权（U）。`mret` 可回 S 或 U；`sret` 可回 U 或 S（`SPP=1` 时） | 看 `mstatus.MPP`/`sstatus.SPP` 的值再执行；在 GDB 里单步 `mret`/`sret`，观察 PC 与特权级变化；确认返回后寄存器没有被「恢复」 |
| 「QEMU 装上就能照抄本章输出」 | **本章实验环境 QEMU 未安装**：`qemu-system-riscv64` 与 `gdb-multiarch` 都不在环境里。正文的 `hello, myrcore`、`tick 1`–`tick 5`、`M: hello from M-mode` 全是形状示例；即便别处有 QEMU，输出也随 OpenSBI 版本、`-bios` 选择与机器型号变化 | `command -v qemu-system-riscv64 gdb-multiarch`；有则记录 `qemu-system-riscv64 --version` 与所用 `-bios`；没有就按未实测处理 |
| 「`clang --target=riscv64` 能直接产出可执行文件」 | 交叉编译只能到 `.s`（`-S`）与 `.o`（`-c`）：没有 riscv64 链接器、启动文件与库，产物没有地址分配、没有程序头、没有入口，不能链接成 ELF，更不能在本机执行；工具链还必须**带 RISC-V 后端**（本机未确认） | `clang --target=riscv64-unknown-elf -march=rv64gc -mabi=lp64d -S t.c -o t.s`；`file t.o` 看是否为 `ELF 64-bit LSB relocatable, RISC-V`；尝试 `-o t.elf` 应因缺链接器失败 |
| 「内核链接到 `0x8000_0000`，配 `-bios default` 也能跑」 | `0x8000_0000` 起 2 MiB 被 OpenSBI 占用；`-bios default` 先从那里跑固件，内核再链到同址会覆盖固件或被固件覆盖。`0x8000_0000` 只配 `-bios none`，`0x8020_0000` 才配 `-bios default` | `llvm-readelf -h` 看 `Entry`；GDB 停在 `0x80000000` 就是地址重叠；换 `-bios` 与 `BASE_ADDRESS` 各试一次 |
| 「先开 `sstatus.SIE`，再设 `stvec` 也一样」 | 先开总闸再设入口，中间来的中断会跳到旧/空向量，轻则跑飞，重则 triple fault。正确顺序是 `stvec → sie.STIE → sstatus.SIE → set_timer`；所有中断驱动代码都遵守「先准备入口，再开门」 | 故意把 `csrw stvec` 放到 `csrs sstatus` 之后，观察是否偶发跑飞；正常顺序下 `trap` 入口地址恒定 |
| 「trap 入口就是保存 32 个寄存器」 | 槽位有 32 个，但 `x0` 硬连线为 0 不需保存，`x2` 由 `sscratch` 换出后取回，实际有值的是 31 个（`x1`、`x3`–`x31` 加从 `sscratch` 取回的 `x2`）；`x0` 槽只是占位，方便按编号索引 | 数一遍入口的 `sd` 条数；对照 `TrapFrame` 的 34 槽偏移表；在 GDB 里改 `x0` 观察是否仍为 0 |
| 「SBI 的返回值在 `a0`，错误码在 `a1`」 | 正好相反：**`a0` 是错误码**（`SBI_SUCCESS=0`，失败为负），**`a1` 是值**。`putchar` 的成功只保证字符被接收，不保证已经出现在终端 | 用 TIME 的返回值验证：`a0==0` 且 `a1` 是时间；把 `a0/a1` 对调后看错误处理是否失效 |
| 「legacy 关机是 `0x08`」 | legacy 关机是 **`0x07`**；`0x08` 是 legacy 发 IPI。现代关机用 SRST（EID `0x53525354`，FID 0，`a0=0` 表示关机，`a1=reason`），成功不返回；`0x08` 写错会变成给别的 hart 发中断，而不是关机 | 查 SBI 规范的 legacy 扩展表；关机失败时先核对 EID/FID；用 SRST 时确认固件版本支持 |
| 「`mtimecmp` 写的是下次间隔」 | `mtimecmp` 与 SBI `TIME` 的 `a0` 都是**绝对时间**：先 `rdtime`，再加间隔（10 ms × 10 MHz = 100 000）。而且 S 态不能直接写 `0x0200_4000`，PMP 会拒绝，必须让 M 态代写 | 打印 `rdtime` 与写入值，确认后者大于前者一个间隔；S 态直接 `sd` 到 `0x0200_4000` 应 fault |
| 「`volatile` 就是内存屏障」 | `volatile`/`read_volatile`/`write_volatile` 只阻止编译器把访问优化掉或合并，不保证 CPU 与设备之间的顺序，也不保证多核可见性；需要顺序时用 `fence`，需要互斥时用原子或锁 | 看生成汇编里访问是否被保留；多核场景加 `fence` 前后对比；不要用 `volatile` 代替 `Acquire/Release` |
| 「1.18.4 的预期输出里有一行 `sstatus = 0x...`，所以 P1 会打印它」 | P1 的 `rust_main` 只调用 `println!("hello, myrcore")`，代码里没有读 `sstatus` 的逻辑；那一行是排版遗留的**形状示例**，与代码不一致。读它之前要么补代码，要么按示例处理 | 对照 1.18.4 的 `rust_main` 与「预期输出」；在本机无 QEMU 的情况下，把它归入「未实测的形状」 |
| 「P2 的 PMP 配置可以照搬进真内核」 | P2 用 `pmpaddr0=0x3fff_ffff_ffff_ffff` + `pmpcfg0=0x0f` 配了覆盖全物理地址的 NAPOT RWX 区域，只为让教学 demo 能跑；真实内核会用 PMP 把 S 限制在内核区、U 限制在用户区，这是没有 MMU 时最后一道隔离 | 看 PMP 条目的 `A` 字段（NAPOT）与权限位；对照真实内核的 PMP 分区策略；不要在生产固件里留全地址 RWX |
| 「RISC-V 一定有三层固件，一定需要 SBI」 | 规范只定义特权级，不强制三层固件：可以 M-only 裸跑（P2 的 `-bios none` 就是），也可以没有 SBI。SBI 是「有 M 固件、S 内核」这种组合下的约定；嵌入式场景常常直接跑在 M 态 | 看启动链：`-bios none` 时谁在 M；没有 SBI 时 `ecall` 的 `mcause=9` 由谁处理；确认你的平台是否提供 SBI 实现 |

## 本章未实测项

下面这些没有本机证据支撑，引用前请当作**待验证的形状、量级或方法**，不要抄成事实：

- **所有 QEMU 运行**（1.18.4、1.18.5、1.18.7、1.18.8 的 `qemu-system-riscv64 -machine virt`）：本章实验环境 QEMU 未安装，串口输出、退出码、`tick` 时间戳都没有本机记录。
- **所有 GDB 会话**（1.18.9 的 `-s -S`、`target remote :1234`、`info registers`）：`gdb-multiarch` 不在环境里；命令形状可照抄，寄存器值没有。
- **Rust 侧构建**（`rustup target add riscv64gc-unknown-none-elf`、`cargo build --release`、`rustc --target ...`）：target 是否可用未确认；P1/P2/P3 的二进制没有本机产物。
- **交叉编译步**（`clang --target=riscv64 ... -S/-c`）：工具链是否带 RISC-V 后端未确认；`.s`/`.o` 的形状来自规范与常识，不是本机输出。
- **`llvm-readelf`/`llvm-objdump`**：本环境未确认安装；`Entry point address: 0x80200000`、`.text` 地址等只表示「应该看到什么」。
- **规范细节的版本差**：SBI 的 legacy 接口在 v0.2/v1.0 之间有差异，SRST/TIME 是 v0.2 之后新增；RISC-V 特权级规范的 CSR 位定义也随版本补充。正文按「现代 OpenSBI + SBI v1.0/v2.0」写，老固件要以它自己的文档为准。

## 发现新问题怎么记

按「现象 → 命令与输出 → 机器/固件/工具链 → 建议改法」四段记，不要只写「我这里不对」。本章的结论大多挂在平台与固件上，所以请一并附上：`uname -a` 与 `uname -m`；`qemu-system-riscv64 --version`（如果有）与完整命令行（`-machine`、`-bios`、`-kernel`）；OpenSBI 版本；`llvm-readelf -h` 的 `Entry`/`Machine`/`Class`；`llvm-objdump -d` 的头几行；`clang --version` 与 `-print-targets` 是否含 `riscv64`；以及 `scause`/`sepc` 的十六进制值。涉及数字时写明口径：是规范条款、工具输出形状、量级示例，还是「未实测」。本章多数分歧都出在把「SBI 当成系统调用」，或把「示例输出」当成「本机实测」。
