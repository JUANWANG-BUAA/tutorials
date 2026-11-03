# 1.19 闭卷回忆卡

这一页是检索练习，不是摘要。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。16 张卡分三组：**A 组考八阶段、批处理与任务切换（1.19.1–1.19.3）**，**B 组考地址空间、进程与文件系统（1.19.4–1.19.6）**，**C 组考 IPC、`read` 路径、设计对照与环境边界（1.19.7–1.19.11）**。建议学完当天、隔天、第 3 天、第 7 天各做一次，只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 八阶段、批处理与任务切换

::: method 回忆 1 · 八个阶段与五个问题
八个阶段各是什么？每个阶段新增的硬件机制与内核抽象分别是什么？贯穿全章的五个问题是什么？
::: sol 答案
八阶段：① 裸机（SBI、UART、CLINT；入口、栈、trap 向量）；② 批处理（U/S 特权级、`ecall`；应用加载器、系统调用）；③ 多任务（内核栈、`sscratch`；任务、调度器、`yield`）；④ 抢占（时钟中断、`STIE`；时间片、tick）；⑤ 地址空间（Sv39、`satp`、TLB；页表、`MapArea`、`MemorySet`）；⑥ 进程（页表切换、COW；PCB、pid、父子关系）；⑦ 文件系统（块设备、virtio；inode、目录项、fd 表）；⑧ IPC/并发（IPI、原子指令；pipe、signal、线程、锁）。五个问题：应用怎么用、硬件给什么、内核存什么、Rust 怎么表达所有权、怎么验证。顺序比单个数据结构重要：先有应用需求，才引入机制。
:::
:::

::: method 回忆 2 · 应用镜像与加载器六步
批处理内核与 app0 各链接到什么地址？加载器的六步是什么？第一次 `sret` 前 `sstatus` 的 `SPP/SPIE/SIE` 应是什么？
::: sol 答案
内核 `0x8020_0000`，app0 `0x8040_0000`，app1 `0x8060_0000`，彼此不重叠；应用 ELF 的入口就是第一条指令。加载器：① `copy_nonoverlapping` 把应用复制到 `APP_BASE`；② `csrw stvec, trap_entry`；③ `csrw sscratch, sp` 保存内核栈顶；④ 设 `sstatus.SPP=0`（回 U）、`SPIE=1`、`SIE=0`；⑤ `csrw sepc, APP_BASE`；⑥ `sret`。`SPP=0` 表示返回 U，`SPIE=1` 让 `sret` 后开中断，`SIE=0` 表示进 U 时先关中断，等第一次 trap 再按需打开。
:::
:::

::: method 回忆 3 · 用户栈与 `sscratch` 的生死线
为什么 `sret` 到 U 之前必须换用户栈？`sscratch` 存什么？第一次 trap 时如果 `sscratch=0` 会怎样？
::: sol 答案
`sret` 只改 PC、特权级与中断使能，不会自动换 `sp`；如果 U 态还拿着内核栈指针，应用一压栈就改内核数据。正确做法是给 U 态准备独立栈，`sret` 前把 `sp` 换过去；`sscratch` 存内核栈顶（或按设计存用户 `sp`），trap 入口用 `csrrw sp, sscratch, sp` 一次性交换。若 `sscratch=0`，入口换出的 `sp=0`，随后 `addi sp, sp, -272` 落到非法地址，load/store fault，甚至嵌套 trap。1.19.2 的示例应用不使用栈，所以没暴露这个问题，不能当作「用户栈已处理好」。
:::
:::

::: method 回忆 4 · `TaskContext` 的 14 个字段与 `__switch`
`TaskContext` 保存哪些寄存器？偏移各是多少？为什么不用保存 `a0–a7` 与 `t0–t6`？`ret` 返回到哪里？
::: sol 答案
`#[repr(C)]` 的 14 个 `usize`：`ra`（偏移 0）、`sp`（8）、`s0–s11`（16–104）。任务切换发生在内核里，是一次普通函数调用：按 RISC-V 调用约定，caller-saved（`ra`、`t0–t6`、`a0–a7`）在进入 `__switch` 前已由编译器保存在**当前任务的内核栈**上，换栈后这些值随旧栈一起留着；只有换栈后仍要恢复的 callee-saved（`s0–s11`）和决定去留的 `ra`、`sp` 必须写进 `TaskContext`。恢复 `next` 的 `ra` 后，`ret` 跳到 `next` 上次调用 `__switch` 的下一条指令——看起来像正常返回，实际已在另一个任务的内核栈上。
:::
:::

::: method 回忆 5 · 时钟把「让出」变成「抢占」
协作式与抢占式的区别是什么？tick handler 只做哪三件事？为什么不能在 handler 里直接 `__switch`？
::: sol 答案
协作式靠任务主动 `yield`，一个死循环就能卡死系统；抢占式靠时钟中断，到点必须让。tick handler 只做：① `set_next_timer()` 重新上弦（不装就只有一次 tick）；② `TICKS.fetch_add(1, Relaxed)` 计数；③ `need_resched.store(true, Relaxed)` 标记需要调度。不能在 handler 里直接 `__switch`：此时当前任务还在中断上下文，栈上有 trap frame，直接换栈会把「中断现场」和「任务上下文」搅在一起；正确做法是置 `need_resched`，在 `sret` 之前检查并切换。Linux 的 `preempt_schedule_irq` 也是这个思路。
:::
:::

## B. 地址空间、进程与文件系统

::: method 回忆 6 · Sv39 的四段拆分与 `satp`
39 位 VA 怎么拆？每一级索引多少位、覆盖多大？`satp` 的 `MODE` 与 `PPN` 各在哪几位？
::: sol 答案
低 12 位页内偏移；往上每 9 位一级：`VPN[2]=VA[38:30]`（level 2，1 GiB 覆盖）、`VPN[1]=VA[29:21]`（level 1，2 MiB）、`VPN[0]=VA[20:12]`（level 0，4 KiB）。`satp`：`63:60=MODE`（8=Sv39、0=Bare、9=Sv48、10=Sv57），`59:44=ASID`，`43:0=PPN`（根页表物理地址 `>>12`）。例如根页表在 `0x8030_0000`，`satp = (8 << 60) | 0x80300`；改完要 `sfence.vma`，否则旧 TLB 项还在。
:::
:::

::: method 回忆 7 · PTE、叶子与大页
PTE 的低 10 位各是什么？什么才算合法叶子？`W=1, R=0` 是什么？大页翻译为什么不能把 `mask` 写成 `0xfff`？
::: sol 答案
位 0–7：`V` 有效、`R` 可读、`W` 可写、`X` 可执行、`U` 用户可访问、`G` 全局、`A` 已访问、`D` 已脏；`53:10` 是物理页号。合法叶子：`V=1` 且（`R=1` 或 `X=1`）；`W=1` 而 `R=0` 是保留组合。非叶子项的 `R/W/X` 全 0；只要有一位为 1，它就是叶子（可能是大页）。大页翻译要保留该级的偏移：level 1 保留 21 位，level 0 保留 12 位；`mask` 写成固定的 `0xfff`，2 MiB 页只保留 4 KiB 偏移，高位全丢，这是页表代码最常见的 bug。
:::
:::

::: method 回忆 8 · `MemorySet` 的所有权与 COW
`MapArea`、`MemorySet`、`PageTable`、`FrameAllocator` 各拥有什么？fork 时哪些复制、哪些共享？`PageTable::drop` 为什么不能见到 PTE 就释放？
::: sol 答案
`MapArea` 表示一段连续 VA + 权限 + 映射类型；`MemorySet` 是 `Vec<MapArea>` 加根页表；`PageTable` 拥有页表页（根与子页），不拥有映射的数据页；数据页由 `FrameAllocator` 或 `Arc<Frame>` 管理。fork 复制 `MemorySet` 的映射关系并把数据页标成 COW，父子暂时共享物理页；写缺页时才分配新页、复制内容、改 PTE 权限。`PageTable::drop` 只能释放页表页；PTE 可能指向共享的数据页、COW 页或设备内存，见到 PTE 就释放会造成 use-after-free 或重复释放。1.19.4 的 `drop_in_place()` 只是类型示意，不是完整页分配器。
:::
:::

::: method 回忆 9 · PCB 的字段与 `Weak`
PCB 里至少有哪些字段？`parent` 为什么用 `Weak`、`children` 为什么用 `Arc`？Linux 的 `task_struct` 怎么处理同一件事？
::: sol 答案
字段：`pid`、`state`、`trap_cx`、`kstack`、`memory_set`、`fd_table`、`parent`、`children`、`exit_code`。`parent` 用 `Weak`：父进程可能先于子进程退出，子进程不能阻止父进程释放；用 `Arc` 会形成父子循环引用，两者都永不释放。`children` 用 `Arc`：父进程要能访问子进程的退出码，子进程变成 zombie 后仍要存在，直到父进程 `wait`。Linux 用 `parent` 裸指针 + `children` 链表 + `real_parent`，靠 `tasklist_lock`/RCU 保护；Rust 把锁与引用计数写进类型，代价是每个字段访问都要加锁，持锁跨阻塞点会死锁。
:::
:::

::: method 回忆 10 · fork、exec、wait 的所有权
fork 复制什么、共享什么？exec 失败时为什么必须保留旧地址空间？zombie 由谁、在什么条件下回收？
::: sol 答案
fork 分配新 pid/PCB/内核栈，复制 `MemorySet`（COW）与 `TrapFrame`；fd 表是「复制表、共享打开文件」——`Arc<dyn File>` 克隆后父子共享同一个 file offset，POSIX 要求如此。exec 不创建新进程：先解析 ELF、建好新页表，全部成功后才原子替换 `MemorySet`，保留 pid 与 fd；若先释放旧地址空间，解析失败时进程就没有地址空间，只能被杀。wait 找子进程：还活着就睡眠，是 zombie 就取退出码并释放 PCB；醒来后必须重新检查条件，防止虚假唤醒与丢失唤醒。
:::
:::

::: method 回忆 11 · `myfs` 的五段布局
`myfs` 的块 0–3 各放什么？inode 与目录项各多大？根目录的 `direct[0]=4`、`hello.txt` 的 `direct[0]=5` 分别指向什么？
::: sol 答案
块 0 超级块（`magic`、`inode_count`、`data_start`）；块 1 inode 位图；块 2 数据位图；块 3 起 inode 区，每个 inode 占 32 字节（`mode`、`size`、`direct[4]`；实际只用了前 24 字节）；`data_start=4` 起数据区。目录项 `DirEntry { inode: u32, name: [u8;28] }` 也是 32 字节。根目录 inode 0 的 `direct[0]=4` 指向块 4 的目录项数组（`.` 与 `hello.txt`）；`hello.txt` inode 1 的 `direct[0]=5` 指向块 5 的文件内容。块 6–7 未用，镜像共 8 块 = 4096 字节。
:::
:::

## C. IPC、`read` 路径、设计对照与环境边界

::: method 回忆 12 · pipe 与线程
pipe 的读端全关、写端继续 `write` 会怎样？写端全关、读端继续 `read` 呢？线程与进程差在哪几个资源上？
::: sol 答案
读端全关：写端 `write` 返回 `-EPIPE` 并触发 `SIGPIPE`（未忽略/阻塞时进程被杀），不再阻塞。写端全关：读端把缓冲区剩余数据读完后再 `read` 返回 0（EOF）。pipe 内部是环形缓冲区 + 读写位置 + `readers/writers` 计数；读空要睡（除非写端全关），写满要睡（除非读端全关）。线程与进程的差别只在共享：线程共享 `Arc<MemorySet>` 与 `Arc<FdTable>`，但内核栈与 trap frame 各自独立；调度单位是线程。Linux 用 `clone(CLONE_VM|CLONE_FILES|...)` 表达同一件事。
:::
:::

::: method 回忆 13 · 一次 `read` 的 11 层
从用户 `read(fd, buf, len)` 到块设备，中间经过哪些层？每层可能返回什么错误？
::: sol 答案
① 用户 `ecall`：`a7=63`（read）、`a0=fd`、`a1=buf`、`a2=len`；② `__s_trap_entry` 换栈、保存寄存器、`scause=8`；③ `syscall()` 按 `a7` 分发；④ `sys_read` 检查 fd 范围与用户指针（`EBADF`/`EFAULT`）；⑤ `FdTable[fd]` 取 `Arc<dyn File>`；⑥ `File::read` 多态（`EINTR`/`EPIPE`）；⑦ `Inode::read_at` 文件偏移 → 块号（越界）；⑧ `BlockCache::get` 命中或发 I/O（超时）；⑨ `BlockDevice::read_block` virtio queue + `wfi`（DMA 错误）；⑩ 中断 handler 唤醒等待者、标记完成（丢失中断）；⑪ 返回用户，写 `a0=读取字节数`、`sepc+=4`。
:::
:::

::: method 回忆 14 · 线程、锁与内存序
自旋锁的 `lock`/`unlock` 各用什么内存序？为什么 `Relaxed` 在 x86-64 上可能「碰巧对」、在 RISC-V 上会错？持自旋锁睡眠为什么是死锁？
::: sol 答案
`lock` 用 `Acquire`、`unlock` 用 `Release`；否则临界区里的写可能被重排到锁外，别的 hart 看到「锁已放、数据没写好」。x86-64 是较强内存模型（TSO），很多重排不会发生，`Relaxed` 可能碰巧正确；RISC-V 是弱内存模型，需要显式 `fence` 或 `Acquire/Release`。持自旋锁睡眠：自旋锁通常关中断，调度器无法运行，睡眠的任务永远不会被唤醒释放锁，其他任务原地自旋，系统停摆；等待应交给互斥锁 + 等待队列，且「检查条件必须在持锁时进行」以防丢失唤醒。
:::
:::

::: method 回忆 15 · rCore、Linux 与 `myrcore` 的六维对照
调度、地址空间、页表、进程、文件、同步六个维度，三者各是什么？Rust 所有权在哪些地方帮忙、哪些地方必须 `unsafe`？
::: sol 答案
调度：rCore 简单 RR/优先级，Linux 6.8 EEVDF + RT + deadline，`myrcore` RR + tick。地址空间：`MemorySet/MapArea`、`mm_struct/vma`、`MemorySet/MapArea`。页表：Sv39 三级、四级/五级 `pgd/p4d/pud/pmd/pte`、Sv39 三级。进程：`TaskControlBlock`、`task_struct`、`Process/Thread`。文件：easy-fs + `File` trait、VFS + ext4/xfs/btrfs、`myfs` + `File` trait。同步：自旋锁/信号量/条件变量、`spinlock/mutex/rwsem/RCU`、`SpinLock/Semaphore`。Rust 帮忙：`Drop` 防泄漏、`Arc` 共享 fd、`Weak` 断父子环、`Mutex<T>` 绑定数据与锁、切片长度检查；逼你 `unsafe`：共享页的 PTE 改权限、用户指针解引用、DMA 写内存、中断上下文里的裸寄存器操作。
:::
:::

::: method 回忆 16 · 证据边界
本章哪些结论有本机证据、哪些没有？rCore 是怎么用的？写作机能做到哪一步？看到 `batch: app exit` 能说什么？
::: sol 答案
本机**没有 RISC-V 硬件，也没有可用的 QEMU/GDB 运行链路**；rCore 只读源码对照，不构建、不运行、不复制 GPLv3 代码。写作机最多做 `clang --target=riscv64 ... -S/-c` 的交叉汇编，没有链接器与运行时，不能链接成 ELF、不能执行；本套件未把交叉汇编输出当证据。1.19.4 与 1.19.6 的主机示例也未复跑。看到 `batch: app exit` 只能说是正文给出的**预期输出形状**，不能说是本机会话记录；寄存器值、断点命中、文件系统镜像字节同理。有本机证据的只有：本章的章节组织、规范里的位定义、以及你按 1.19.10 在**有 QEMU 的机器上**亲自复现出来的东西。
:::
:::
