# 1.18 闭卷回忆卡

这一页是检索练习，不是摘要。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。16 张卡分三组：**A 组考寄存器、特权级与 SBI（1.18.1–1.18.3）**，**B 组考链接、入口、UART 与 trap 现场（1.18.4–1.18.7）**，**C 组考时钟中断、取证与环境边界（1.18.8–1.18.10）**。建议学完当天、隔天、第 3 天、第 7 天各做一次，只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 寄存器、特权级与 SBI

::: method 回忆 1 · 32 个寄存器与 ABI 别名
`x0`、`ra`、`sp`、`a0`–`a7`、`t0`–`t6`、`s0`–`s11` 各是第几号？谁负责保存？调用一个函数前后，哪些寄存器可以指望不变？
::: sol 答案
`x0=zero` 恒 0；`x1=ra` 返回地址；`x2=sp` 栈指针；`x10–x17=a0–a7` 参数/返回值（`a0/a1` 也放返回值）；`x5–x7` 与 `x28–x31` 是 `t0–t6` 临时寄存器；`x8–x9` 与 `x18–x27` 是 `s0–s11` 被调用者保存。调用约定：`t` 系列与 `a` 系列是 caller-saved，被调用者可以随便改；`s` 系列与 `sp` 是 callee-saved，被调用者要用就得先存后还。`ra` 由 `call` 写入，非叶子函数要自己存。SBI 调用还额外约定 `a7=EID`、`a6=FID`，返回 `a0` 错误码、`a1` 值。
:::
:::

::: method 回忆 2 · CSR 的三条读写指令
`csrrw`、`csrrs`、`csrrc` 各做什么？只想读不想写时为什么常用 `csrrs rd, csr, x0`？`csrr`/`csrw` 是什么？
::: sol 答案
三者都是「读旧值到 `rd`，再按 `rs1` 修改 CSR」：`csrrw` 直接写入 `rs1`；`csrrs` 置位（`csr |= rs1`）；`csrrc` 清位（`csr &= ~rs1`）。`csrrs rd, csr, x0` 的 `rs1` 是 0，置位不改变任何位，等价于纯读，且不会触发写副作用；`csrw csr, rs1` 是 `csrrw x0, csr, rs1`（不关心旧值），`csrr rd, csr` 是 `csrrs rd, csr, x0`。写只读 CSR 或访问当前特权级不够的 CSR 会触发 illegal instruction。
:::
:::

::: method 回忆 3 · M/S/U 三级的权限边界
三个特权级各跑什么？谁能读写哪些 CSR？U 态访问 CSR 会怎样？S 态能不能直接写 CLINT 的 `mtimecmp`？
::: sol 答案
M 最高，跑 ZSBL/OpenSBI 一类固件，能读写全部 CSR、直接访问 CLINT/PLIC 等 M 态设备；S 跑内核，能用 `satp` 开页表、处理 U 的 `ecall`，但读写 `mstatus/mepc/mtvec` 等 M 态 CSR 会 illegal instruction；U 跑应用，任何 CSR 访问与特权指令都 illegal，只能靠 `ecall` 进 S。S 态写 CLINT 的 `mtimecmp`（`0x0200_4000`）会被 PMP 拒绝，报 store access fault；正确路径是 SBI `set_timer` 让 M 代写。M 态自身不受 PMP 限制，但要负责给 S/U 配 PMP。
:::
:::

::: method 回忆 4 · trap 的硬件五步与 `scause`
trap 发生时硬件自动做什么？通用寄存器保存了吗？`scause` 怎么区分中断与异常？`8`、`9`、`11`、`5`、`7` 各是什么？
::: sol 答案
硬件：① 当前 PC 写 `sepc`（M 态是 `mepc`）；② 原因写 `scause`；③ 附加信息写 `stval`；④ 跳到 `stvec`（M 态 `mtvec`）；⑤ 清 `SIE`（M 态清 `MIE`）、切到更高特权级。通用寄存器一个都不保存，入口软件负责。`scause` 最高位（RV64 的 bit63）为 1 表示中断、为 0 表示异常，低位是编号：`8`=U 的 `ecall`，`9`=S 的 `ecall`，`11`=M 的 `ecall`，`5`=S 定时器中断，`7`=M 定时器中断；异常侧还有 `2`=illegal instruction、`12`/`13`/`15`=取指/读/写页错误。
:::
:::

::: method 回忆 5 · SBI 是什么、不是什么
SBI 全称是什么？它连接哪两个特权级？它不是哪三样东西？为什么说「内核第一行打印要借固件之手」？
::: sol 答案
SBI = Supervisor Binary Interface，是 S 态调用 M 态固件（OpenSBI 等）的 ABI，用 `ecall` 实现。它**不是**系统调用（系统调用是 U→S），**不是**硬件指令（硬件只认 `ecall`），**也不是**内核的一部分（它在 M 态固件里）。S 态没有 UART 驱动、也不一定被允许直接碰设备，所以最早的一行输出只能把自己的字符放进 `a0`、EID 放进 `a7`，`ecall` 请 M 态代写串口；这也是「可移植的 bring-up 手段」。
:::
:::

::: method 回忆 6 · SBI 调用约定与两个易错编号
EID、FID、参数、返回值各放哪个寄存器？legacy 的 `putchar`、关机、发 IPI 各是哪个 EID？SRST 与 TIME 的 EID 怎么记？
::: sol 答案
`a7=EID`、`a6=FID`、`a0–a5`=参数 0–5；返回时 **`a0`=错误码（`SBI_SUCCESS=0`，失败为负）、`a1`=值**，不要写反。legacy：`putchar=0x01`（`a0`=字符）、关机=`0x07`、发 IPI=`0x08`；`0x08` 不是关机。现代关机用 SRST，EID `0x53525354`（ASCII `"SRST"`），FID 0，`a0=0` 表示关机、`a1` 是原因，成功不返回。定时器用 TIME，EID `0x54494D45`（ASCII `"TIME"`），FID 0，`a0` 是**绝对时间**。
:::
:::

## B. 链接、入口、UART 与 trap 现场

::: method 回忆 7 · 链接脚本钉住第一条指令
`ENTRY(_start)` 改变什么、不改变什么？为什么 `BASE_ADDRESS` 是 `0x8020_0000`？`.text.entry` 为什么必须最先？`sbss/ebss` 为什么必须是符号？
::: sol 答案
`ENTRY` 只写 ELF 头的入口字段，不改变任何段的地址；QEMU 用 ELF 入口跳转。OpenSBI 占住 `0x8000_0000` 起的 2 MiB，所以内核链接到 `0x8020_0000`，否则会覆盖固件或被固件覆盖。`.text.entry` 放在 `.text` 最前，保证 `_start` 就在 `0x8020_0000`。`sbss/ebss` 是清零循环的边界，必须是链接器符号，Rust 里用数组长度代替会算错（`.bss` 里还有对齐与别的段）。`.bss.stack` 放在 `sbss` 之前，清零循环才不会把启动栈抹掉。
:::
:::

::: method 回忆 8 · `_start` 的三件事与 `la` 的真相
`_start` 在跳到 Rust 前必须做哪三件事？`la` 展开成什么？为什么此时「链接地址就是物理地址」？`call rust_main` 返回会去哪？
::: sol 答案
① 按 `sbss..ebss` 每次 8 字节写 0 清 `.bss`；② 把 `sp` 设到 `boot_stack_top`（栈向低地址长）；③ `call rust_main`。`la` 是伪指令，展开为 `auipc`+`addi`，取的是**链接地址**而非当前物理 PC。OpenSBI 已经把 `satp` 置 0、MMU 关闭，链接地址即物理地址，所以能直接跑。`call` 把返回地址写进 `ra`；`rust_main` 返回会落到 `_start` 末尾的 `wfi` 自旋（保险路径），正常路径是打印后关机、永不返回。
:::
:::

::: method 回忆 9 · `no_std` 三件套与 `panic=abort`
最小 Rust 裸机程序要哪三个属性/项？为什么 `panic = "abort"` 是必须的？`global_asm!` 起什么作用？`#[no_mangle] pub extern "C" fn rust_main` 为什么要这两个修饰？
::: sol 答案
`#![no_std]`（不链 `std`）、`#![no_main]`（不要 C 运行时入口）、`#[panic_handler]`（`no_std` 下必须自己定义 panic 行为）。`panic="abort"` 必须：`no_std` 没有 unwinding 运行时，默认 `unwind` 会因缺 `eh_personality` 等链接失败；abort 也避免 panic 路径展开栈。`global_asm!(include_str!("entry.asm"))` 把入口汇编嵌进目标文件，链接器才看得到 `_start`。`#[no_mangle]` 阻止符号被 mangle，`extern "C"` 用 C 调用约定，汇编里的 `call rust_main` 才能按原名找到它。
:::
:::

::: method 回忆 10 · SBI 输出与 UART 直写的取舍
SBI `putchar` 与直接写 16550A 各有什么代价？UART0 的 `THR`/`LSR`/`LCR` 偏移是多少？写之前为什么要轮询 `THRE`？`volatile` 保证了什么、没保证什么？
::: sol 答案
SBI 每字符一次 `ecall`，可移植、与固件共用输出，但慢且依赖固件；直写 MMIO 快、不经过固件，但地址绑定板卡，要自己初始化。QEMU `virt` 的 UART0 基址 `0x1000_0000`：`THR=0x00`（写即发送）、`IER=0x01`、`FCR=0x02`、`LCR=0x03`、`LSR=0x05`。初始化 `LCR=0x03`（8N1）、`FCR=0x01`（开 FIFO）、`IER=0x00`（关中断），然后轮询 `LSR` 的 bit5 `THRE`，为 1 才写 `THR`，否则会覆盖还没移位发完的字符。`volatile` 只告诉编译器别把连续读合并/删掉，不提供内存屏障；多核或设备顺序要求还要 `fence`。
:::
:::

::: method 回忆 11 · `TrapFrame` 的 34 个槽
34 个 8 字节槽各放什么？为什么 `x2` 不从 frame 恢复、`x0` 不用存？`sepc` 与 `sstatus` 在第几字节？谁负责让汇编偏移与 Rust 结构体一致？
::: sol 答案
槽 0–31 依次是 `x0`–`x31`（每槽 8 字节），槽 32 是 `sepc`（偏移 256），槽 33 是 `sstatus`（偏移 264），共 272 字节。`x0` 硬连线为 0，存了也没用，留槽只为「按编号索引」；`x2` 在入口时已经通过 `sscratch` 换出，内核栈在 `sp`、用户 `sp` 在 `sscratch`，所以从 `sscratch` 取回存进槽 2，出口再由 `csrrw` 换回，不从 frame 恢复。偏移必须由 `#[repr(C)]` 的 `x: [usize; 32] + sepc + sstatus` 保证；汇编用 `sd xN, N*8(sp)`，两者差一个字段就会「`a0` 变成 `sepc`」。
:::
:::

::: method 回忆 12 · trap 入口的三个约定与五个坑
入口为什么先 `csrrw sp, sscratch, sp`？handler 的 ABI 是什么？返回前为什么先写 `sstatus` 再 `sret`？五个常见坑是哪五个？
::: sol 答案
约定一：`sscratch` 存内核栈顶，入口用 `csrrw` 一次性完成「用户 `sp` 存进 `sscratch`、内核栈换进 `sp`」；约定二：`x2` 从 `sscratch` 取，不从 frame 恢复；约定三：handler 是 `extern "C" fn(&mut TrapFrame)`，`a0` 传 frame 指针。`sret` 会用 `sstatus` 的 `SPP/SPIE` 决定回哪级、恢复哪套中断使能，所以必须先写回 `sstatus` 再 `sret`。五个坑：存/恢复 `x0`；漏存 `t0`–`t6`；对中断也 `sepc += 4`；`sstatus` 恢复顺序错；`sscratch` 初值没设（第一次 trap 把 `sp` 换成 0，随后非法地址、嵌套 trap、triple fault）。
:::
:::

::: method 回忆 13 · P2 的三级跳
P2 为什么要配 PMP？`medeleg` 的哪一位委托 `ecall-from-U`？`mret` 前 `mstatus` 的 `MPP/MPIE` 怎么设？`sret` 前 `sstatus` 的 `SPP/SPIE` 怎么设？关机为什么用 test finisher？
::: sol 答案
M 态默认不受 PMP 限制，但 S/U 的每次访存都要过 PMP；`pmpcfg0=0`（无条目）时 S/U 访问任何地址都 access fault。P2 用 `pmpaddr0=0x3fff_ffff_ffff_ffff` + `pmpcfg0=0x0f` 配一个覆盖全地址的 NAPOT RWX 区域（教学用，真内核会分区限制）。`medeleg` 的 bit8 对应 `ecall-from-U`，置 1 后 U 的 `ecall` 进 S 而不是 M。`mret` 前：`MPP=1`（回 S）、`MPIE=1`、`MIE=0`、`mepc=s_main`；`sret` 前：`SPP=0`（回 U）、`SPIE=1`、`SIE=0`、`sepc=u_main`。P2 用 `-bios none` 直接跑在 M 态，没有 OpenSBI 可调 SRST，所以用 QEMU `virt` 的 SiFive test finisher（`0x0010_0000` 写 `0x5555`）退出。
:::
:::

## C. 时钟中断、取证与环境边界

::: method 回忆 14 · 时钟的两层与 `mtimecmp` 的绝对值
RISC-V 的定时器为什么分 M/S 两层？CLINT 的 `mtime`/`mtimecmp` 地址与频率？S 态怎么设定时器？为什么 `a0` 传绝对时间？`rdtime` 在 S 态一定可读吗？
::: sol 答案
`mtime`/`mtimecmp` 属于 M 态 CLINT，S 态不被允许直接写；S 只能通过 SBI `TIME` 请求 M 代写，M 写完后清 `MTIP`、置 `STIP`，S 才看到 `sip.STIP`。QEMU `virt`：`mtimecmp[hart0]=0x0200_4000`（每 hart +8），`mtime=0x0200_BFF8`，只读，10 MHz。S 态先 `rdtime` 读当前，加上间隔（10 ms = 100 000 tick），把「当前 + 100 000」作为 `a0` 传给 EID `0x54494D45`、FID 0——`mtimecmp` 写的是绝对时间，不是间隔。`rdtime` 是否可读取决于 `mcounteren.TM`；OpenSBI 通常放行，没放行就 illegal instruction，只能改用 SBI `TIME`/`get_time`。
:::
:::

::: method 回忆 15 · 打开中断的四步与 tick 只来一次
让 S 态定时器中断真正进来，要按什么顺序做哪四件事？为什么 handler 里必须重新 `set_next_timer`？为什么「只开 `sie.STIE`」不够？
::: sol 答案
顺序：① 设 `stvec` 指向入口；② `sie.STIE=1`（bit5）；③ `sstatus.SIE=1`（bit1）；④ 调 SBI `set_timer` 上弦。原则是「先准备好入口，再开门」：先开全局中断再设 `stvec`，中间来的中断会跳到旧/空向量。`sie.STIE` 只是「允许这类中断」，`sstatus.SIE` 才是总闸，两个都开才进 trap。`mtime >= mtimecmp` 是一次性比较，handler 不重新写 `mtimecmp`，时间不再前进，就只响一次；另外 handler 里打印太多会把 10 ms 拖成 100 ms，教学可以，真实调度不行。
:::
:::

::: method 回忆 16 · 取证链与环境边界
看入口与段布局用什么命令、看什么字段？QEMU + GDB 怎么让 CPU 停在第一条指令？本章哪些结论有本机证据、哪些没有？交叉编译最多做到哪一步？
::: sol 答案
`llvm-readelf -h` 看 `Entry point address`（应为 `0x80200000`）、`Machine: RISC-V`、`Class: ELF64`；`-S` 看 `.text` 的地址（为 0 说明 `-T` 没生效）；`llvm-objdump -d --no-show-raw-insn` 看第一条指令。GDB：QEMU 加 `-s -S` 冻结在第一条指令并开 1234 端口，`gdb-multiarch ... -ex 'target remote :1234' -ex 'info registers pc sp'`。本机**没有 RISC-V 硬件，也没有可用的 QEMU/GDB 运行链路**，所以所有 `hello`/`tick`/`M: hello` 输出、`sstatus` 值、GDB 会话都是形状示例，标未实测；Rust 的 `riscv64gc-unknown-none-elf` target 也未确认。交叉编译最多到 `clang --target=riscv64 ... -S/-c` 的 `.s`/`.o`，没有 riscv64 链接器与运行时，不能链接成 ELF、不能执行。
:::
:::
