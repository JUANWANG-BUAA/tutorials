# 1.19 章末总结

## 三个单元，一条主线

**第一单元，八阶段与两次降级（1.19.1–1.19.3）。** rCore 教程最值钱的是**顺序**：先写应用需要什么，再引入硬件机制与内核抽象。八个阶段压成一张表就是「裸机 → 批处理 → 多任务 → 抢占 → 地址空间 → 进程 → 文件系统 → IPC/并发」。前两个阶段解决「应用不能改内核」：内核在 `0x8020_0000`，应用镜像搬到 `0x8040_0000`，加载器装好 `stvec`、设 `sscratch`、写 `sepc` 与 `sstatus.SPP/SPIE`，最后 `sret` 降级到 U；应用只会 `ecall`，`sepc` 返回前必须 `+4`。第三、四阶段解决「多个应用都要跑」：每个任务有自己的内核栈，`TaskContext` 只存 `ra/sp/s0–s11` 共 14 个 `usize`，`__switch` 换栈后 `ret` 到另一个任务上次调用的下一条指令；时钟中断把「主动 `yield`」变成「到点必须让」，但 handler 只重新上弦、计数、置 `need_resched`，真正切换放在 `sret` 之前。

**第二单元，从地址空间到文件系统（1.19.4–1.19.6）。** 第五阶段给每个进程一个「假装独占」的内存：Sv39 把 39 位 VA 拆成 `VPN[2]`（38:30）、`VPN[1]`（29:21）、`VPN[0]`（20:12）和 12 位页内偏移，`satp.MODE=8`，PPN 是根页表物理页号。PTE 低 10 位是权限，`V=1` 且 `R=1` 或 `X=1` 才是合法叶子；`W=1` 而 `R=0` 是保留组合；非叶子项的 `R/W/X` 全 0；大页翻译要按级别保留 21 位或 30 位偏移，`mask` 写成 `0xfff` 就是经典 bug。内核里 `MemorySet` 拥有 `MapArea` 与 `PageTable`，`PageTable` 只拥有页表页，数据页由 `Arc<Frame>` 共享；fork 复制地址空间并标 COW，写缺页时才复制数据页。第六阶段把「任务」升级成「进程」：PCB 里是 pid、state、`trap_cx`、`kstack`、`memory_set`、`fd_table`、`parent: Weak`、`children: Vec<Arc>`、`exit_code`；fork 复制 `MemorySet` 与 fd 表但**共享打开文件**（file offset 也共享），exec 先建新地址空间再原子替换、保留 pid 与 fd，wait 取走退出码并回收 zombie。第七阶段把持久化接上：`myfs` 用 512 字节块，块 0 超级块、块 1 inode 位图、块 2 数据位图、块 3 起 inode 区（每项 32 字节）、`data_start` 起数据区；inode 的 `direct[4]` 是四个直接块号；目录也是文件，内容是 `DirEntry { inode, name }`；`File` trait 把普通文件、stdio、pipe 统一成 `read/write`，fd 表存 `Arc<dyn File>`。

**第三单元，一条路径与一张对照表（1.19.7–1.19.11）。** 第八阶段补上进程间通信与并发：pipe 是内核里的环形缓冲区，读空要睡、写满要睡，读端全关写端得 `EPIPE` 与 `SIGPIPE`，写端全关读端读完返回 0；线程与进程只差「是否共享地址空间与 fd 表」，内核栈与 trap frame 仍各自独立；自旋锁的 `lock` 用 `Acquire`、`unlock` 用 `Release`，持自旋锁睡眠就是死锁。1.19.8 把前面所有层串成一次 `read`：用户 `ecall`（`a7=63`）→ `__s_trap_entry` 换栈存现场 → `syscall` 分发 → `sys_read` 校验 fd 与用户指针 → `FdTable[fd]` 取 `Arc<dyn File>` → `File::read` 多态 → `Inode::read_at` 算块号 → `BlockCache::get` → `BlockDevice::read_block` → 中断唤醒 → 写 `a0` 并 `sepc+=4`。最后 1.19.9 用六维对照表说明：rCore 不是「小 Linux」，它抽掉的是 RCU、cgroup、namespace、日志、多核负载均衡这些工程复杂度，留下的是机制本身。全章的证据边界只有一句：**本机没有 RISC-V 硬件与 QEMU，rCore 只能读源码对照，所有运行输出都是形状示例。**

一句话主线：**内核是被应用需求一步步逼出来的——先关住应用（U/S + `ecall`），再让多个应用轮流跑（内核栈 + `__switch` + 时钟），再给每个进程一个假装的独占内存（Sv39 + `MemorySet`），再把「程序」变成可创建、可替换、可等待的进程（fork/exec/wait），再把持久化接上（inode + fd 表），最后用 pipe、锁与一次 `read` 把所有抽象串成可追踪的路径；每一步都回答「应用要什么、硬件给什么、内核存什么、Rust 怎么表达、怎么验证」。**

## 表 1：八个阶段一眼表

| 阶段 | 应用需求 | 新增硬件机制 | 新增内核抽象 | `myrcore` 的 Rust 类型 | 典型失败 |
|--:|:--|:--|:--|:--|:--|
| 1 裸机 | 打印、计算、关机 | SBI、UART、CLINT | 入口、栈、trap 向量 | `TrapFrame`、`&'static [u8]` | 链接地址错、栈未设 |
| 2 批处理 | 应用不能改内核 | U/S 特权级、`ecall` | 应用加载器、系统调用 | `AppRef`、`UserContext` | `sepc` 未 `+4` |
| 3 多任务 | 交替执行、主动让出 | 内核栈、`sscratch` | 任务、调度器、`yield` | `TaskContext`、`Arc<Mutex<TCB>>` | 切换时栈没换 |
| 4 抢占 | 公平、交互 | 时钟中断、`STIE` | 时间片、tick | `AtomicUsize`、`Timer` | 忘了重设 `mtimecmp` |
| 5 地址空间 | 隔离、按需分配 | Sv39、`satp`、TLB | 页表、`MapArea`、`MemorySet` | `PageTable`、`MapPermission` | PTE 的 `V/R/W/X` 配错 |
| 6 进程 | fork/exec/wait | 页表切换、COW | PCB、pid、父子关系 | `Arc<Mutex<Process>>`、`Weak` | `Arc` 循环、死锁 |
| 7 文件系统 | 持久化、命名 | 块设备、virtio | inode、目录项、fd 表 | `Arc<Inode>`、`dyn File` | 目录项越界、块号错 |
| 8 IPC/并发 | 协作、共享 | IPI、原子指令 | pipe、signal、线程、锁 | `Arc<Semaphore>`、`Condvar` | 竞态、丢失唤醒 |

## 表 2：贯穿全章的五个问题

| 问题 | 在本章怎么答 | 主要落点 |
|:--|:--|:--|
| **应用怎么用** | 系统调用、文件、信号；接口决定内核要保存什么 | 1.19.2、1.19.5–1.19.7 |
| **硬件给什么** | 特权级、CSR、页表、中断、原子指令；每次只加一件 | 1.19.2–1.19.7 |
| **内核存什么** | 新结构体的字段、谁分配、谁释放、什么时候改 | 1.19.3–1.19.6 |
| **Rust 怎么表达所有权** | `&mut`、`Arc`、`Weak`、`UnsafeCell`，还是只能 `unsafe` | 1.19.3、1.19.5、1.19.9 |
| **怎么验证** | QEMU 输出、GDB 寄存器、`objdump`、`/proc` 或自写测试 | 1.19.10；本机全部未实测 |

## 表 3：总图——从命令行到内核（1.1–1.19）

这张表是第 1 篇的收口。每一行只留「这一章教会你的一件事」和「它到内核里变成了什么」；19 行连起来，就是本书从「敲命令」走到「读内核」的路线。

| 章 | 这一章留下的东西 | 到内核里变成什么 |
|:--|:--|:--|
| [1.1 计算机系统漫游](ch01.md) | 一个 `.c` 文件如何经过预处理、编译、汇编、链接变成进程 | `exec` 加载 ELF、建立第一个用户栈与入口 |
| [1.2 信息的表示与运算](ch02.md) | 补码、字节序、IEEE 754、溢出与类型边界 | PTE 的位域、`scause` 的最高位、`errno` 的负值 |
| [1.3 机器级程序](ch03.md) | x86-64 寄存器、栈帧与调用约定 | trap frame 与上下文切换的字段布局 |
| [1.4 处理器体系结构](ch04.md) | 流水线、冒险、乱序执行与推测 | 为什么内核需要 `fence`、屏障与内存序 |
| [1.5 程序性能优化](ch05.md) | 先度量再改写，性能不是猜出来的 | 调度、缓存与 I/O 路径上的「先取证」 |
| [1.6 存储层次与缓存](ch06.md) | 局部性、组相联、缓存命中与流量 | TLB、页表遍历成本、块缓存 |
| [1.7 链接、加载与库](ch07.md) | 符号解析、重定位、动态链接、加载器 | `exec` 的 ELF 解析、`dlopen` 与 VDSO |
| [1.8 异常控制流](ch08.md) | 异常、进程控制、信号 | trap、fork/exec/wait、信号 frame |
| [1.9 虚拟内存](ch09.md) | 地址翻译、页表、`mmap`、分配器 | Sv39、`MemorySet`、COW、缺页 |
| [1.10 系统级 I/O](ch10.md) | fd、缓冲、短读短写、零拷贝 | fd 表、`read` 路径、`BlockDevice` |
| [1.11 网络编程](ch11.md) | socket、HTTP、`epoll` | socket 也是 fd，等待队列与就绪通知 |
| [1.12 并发编程](ch12.md) | 线程、锁、条件变量、事件循环 | 自旋锁、信号量、`Condvar`、丢失唤醒 |
| [1.13 操作系统导论](ch13.md) | 虚拟化、并发、持久化三条轴 | 八阶段表的理论骨架 |
| [1.14 三套 ISA](ch14.md) | x86-64、ARM64、RISC-V 64 的寄存器与指令 | 同一机制换寄存器名，`__switch` 三版并排 |
| [1.15 汇编与调用约定](ch15.md) | caller-saved / callee-saved 与栈帧 | `TaskContext` 只存 14 个 `usize` 的理由 |
| [1.16 编译、链接与优化](ch16.md) | 工具链、链接脚本、优化级别 | 交叉编译、内核链接地址、`no_std` 构建 |
| [1.17 Rust 系统编程](ch17.md) | 所有权、`Result`、FFI、`unsafe` 的边界 | `Arc`/`Weak`、`Mutex<T>`、trait object |
| [1.18 RISC-V 裸机](ch18.md) | SBI、M/S/U、trap 现场、时钟中断 | `TrapFrame`、`sscratch`、`stvec`、tick |
| [1.19 从 rCore 看内核](ch19.md) | 八阶段、任务、地址空间、进程、文件系统、IPC | 把前面 18 章装进一个教学内核的框架 |

**总图读法**：1.1–1.7 是「程序如何变成机器能跑的字节」；1.8–1.13 是「程序如何在 OS 里被隔离、调度、持久化」；1.14–1.17 是「换架构、换工具链、换语言之后，同一套机制怎么表达」；1.18 是「没有 OS 时，机器自己怎么 trap」；1.19 是「把这些零件装成一个内核」。第 0 篇的命令行经验在这张图的最底层：你敲的每条命令，最终都要落到这张表的某一格上。

## 表 4：rCore、Linux 与 `myrcore`

| 维度 | rCore（教学） | Linux 6.8 | `myrcore`（本章） |
|:--|:--|:--|:--|
| 调度 | 简单 RR/优先级 | EEVDF + RT + deadline | RR + tick |
| 地址空间 | `MemorySet`/`MapArea` | `mm_struct`/vma | `MemorySet`/`MapArea` |
| 页表 | Sv39 三级 | 四级/五级，`pgd/p4d/pud/pmd/pte` | Sv39 三级 |
| 进程 | `TaskControlBlock` | `task_struct` | `Process`/`Thread` |
| 文件 | easy-fs + `File` trait | VFS + ext4/xfs/btrfs | `myfs` + `File` trait |
| 同步 | 自旋锁/信号量/条件变量 | `spinlock`/`mutex`/`rwsem`/RCU | `SpinLock`/`Semaphore` |

**这张表怎么用**：不要把 rCore 当「小 Linux」去背结构体名；它删掉的是 RCU、cgroup、namespace、日志、多核负载均衡这些工程复杂度，保留的是「一个机制最少需要哪些字段」。读 Linux 时，先用这张表找到对应机制，再去看工业级实现多了哪些边界条件。

## 下一站：第 2 篇

1.19 是第 1 篇的终点，也是第 2 篇的起点。本章在 RISC-V 上用 `ecall` 进入 S 态；第 2 篇回到本机 x86-64，用 `syscall` 进入内核，讲同一件事的工程版本：

- [第 2 篇导览：从 API 到正确的系统程序](../part2/overview.md)
- [2.1.1 一次系统调用穿过什么](../part2/ch01.md#sec-2.1.1)：把本章的 `ecall`/`sret` 与 Linux 的 `syscall`/`sysret` 对齐。
- [2.1.9 系统调用 ABI：寄存器、参数上限与返回约定](../part2/ch01.md#sec-2.1.9)：本章的 `a7` 调用号与 `a0` 返回值，在 x86-64 上是 `rax` 与 `-errno`。
- [2.2 文件 I/O](../part2/ch02.md)：本章的 fd 表与 `read` 路径，在 POSIX 上变成 `open/read/write/close` 的返回值与原子性规则。

再往后，第 3 篇会把 `myrcore` 的 `Process/MemorySet/File` 对照到 Linux 6.8 的 `task_struct/mm_struct/file`。你会发现：教学内核删掉的是工程复杂度，不是机制本身；读懂机制之后，Linux 源码只是「同一件事的工业级实现」。

自检入口：[闭卷回忆卡](ch19-recall.md) 先合上正文叫出 16 个答案；[习题集](ch19-exercises.md) 的 B 组专练「现象 → 原因 → 修法」；[学习目标自检表](ch19-checklist.md) 接管 1.19.11 的出口；[勘误与版本注记](ch19-errata.md) 的「只读源码不能声称运行」「rCore 版本不绑定」两条请先读一遍。
