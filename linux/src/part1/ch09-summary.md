# 1.9 章末总结

## 五段浓缩：一页看全章

| 单元 | 小节 | 核心问题 | 关键结论 | 典型陷阱 |
|:--|:--|:--|:--|:--|
| **一、地址与一次翻译** | 1.9.1–1.9.4 → 1.9.8 | 一个 48 位地址怎样变成物理地址？缺页时内核凭什么修？ | 虚拟内存不是「swap 的别名」，而是**缓存、管理、保护**三件事共用一套地址翻译；48 位 VA 切成 9/9/9/9/12，一次 TLB 未命中最多读 4 个表项；单级页表要 $2^{36}\times 8=512$ GiB，多级页表只给已映射区间建分支。次缺页不读存储（但仍可能分配/清零/复制页），主缺页要读磁盘或 swap，无效缺页只发信号。64 项 TLB 配 4 KiB 页覆盖 256 KiB，配 2 MiB 页覆盖 128 MiB；改页表要跨核 shootdown，PCID 只省上下文切换的冲刷。 | 把「虚拟内存」等同于 swap；以为 TLB 未命中就要读磁盘；以为大页一定更快、虚拟地址连续物理地址也连续；把 1.9.1 的 128 TiB/64 PiB 与 1.9.8 的 256 TB/128 PB 当成互相矛盾（前者是用户半区，后者是整空间）。 |
| **二、映射与文件** | 1.9.5、1.9.9、1.9.12 | 内核怎样描述地址空间？`mmap` 的参数、失败与信号各是什么？ | VMA 是一条「起始-结束 + 权限 + 文件/偏移」的区间记录，`maps` 只给虚拟布局，`smaps` 的 `Rss` 是驻留、`Pss` 按共享份额折算；`VmSize` 包含未提交的保留，不能当内存用量。`mmap` 必须 `MAP_SHARED`/`MAP_PRIVATE` 二选一，文件映射的 `offset` 要按页对齐；成功返回页对齐地址，失败返回 `MAP_FAILED`（不是 `NULL`）。文件最后一页的尾部是零填充，只有**完全在 EOF 之后**的页才 `SIGBUS`；`SIGSEGV` 则是地址不在映射内或权限不符。 | 用 `if (!p)` 判 `mmap` 失败；以为 `MAP_PRIVATE` 不占物理页；以为 `msync` 等于落盘；把 `SIGBUS` 当成 `SIGSEGV` 的一种写法；以为 `mincore` 给的是精确驻留。 |
| **三、分配器** | 1.9.6、1.9.10、1.9.10.1、1.9.11 | `malloc` 怎样在堆里找到空洞？释放后为什么不立刻还给系统？ | 分配器要满足对齐、不重叠、不移动、及时复用；带边界标记的隐式链表用「头存大小+分配位、脚复制大小」支持向前合并，首次适配线性扫描，分裂的最小剩余块常见取 32 B。生产分配器把它分层：tcache（每线程 64 桶，≤1032 B）→ fastbins（≤128 B，不合并）→ small/large bins → unsorted → top → `brk`/`mmap`；大于 128 KiB（可动态调整）的请求直接 `mmap`，`free` 时才 `munmap`。1 GiB 连续匿名区全部建 4 KiB 页时，页表约 515 页 = 2 MiB + 12 KiB；只预留不访问则不建这些页表。 | 以为 `malloc` 一定来自 `brk`；以为 `free` 会把内存还给 OS；把 1.9.6 的 16 B 头 + 8 B 脚与 1.9.11 程序的 8+8 混用；以为 `malloc` 返回的内存是零；把 `malloc(0)` 的返回值当失败。 |
| **四、错误、观测与陷阱** | 1.9.7、1.9.13、1.9.15 | 崩溃点为什么离 bug 很远？没有 `perf` 时还能看什么？ | 越界写 1 字节可能只破坏下一块的 header，直到 `free` 才炸；UAF 读到的是已被复用的对象；双重释放由 glibc 的 `malloc_printerr` 报 `SIGABRT`。ASan 是编译期插桩，约 2 倍开销、能指到行；Valgrind 是动态翻译，10–50 倍开销但不用重编译。`/proc/self/maps` 看布局，`smaps_rollup` 看 `Rss`/`Pss`/`AnonHugePages`，`pagemap` 的 PFN 需要 `CAP_SYS_ADMIN`，`mincore` 只给近似驻留。`SEGV` 先看 `si_addr` 与 `si_code`，不要直接归因空指针。 | 看到 `SEGV` 就说空指针；只看 `VSZ` 判断泄漏；加了 `madvise(MADV_HUGEPAGE)` 就以为大页生效；把 `perf` 示例输出当自己机器的读数；把 `MAP_FIXED` 当「指定地址更可控」。 |
| **五、语言对照与出口** | 1.9.14、1.9.16 | 谁来释放这块内存？学完怎样自证？ | C 把释放点交给程序员，Rust 把释放点交给作用域（`Drop`），引用计数把释放点交给计数归零，追踪 GC 把释放点交给可达性。Rust 的 `Vec` 扩容会搬家，分配失败默认 abort，需要可失败分配时用 `try_reserve`；`#[global_allocator]` 能在链接期换掉分配器，等价于 C 的 `LD_PRELOAD` 钩子。出口六项能对上，才算把「页表—VMA—分配器—工具」串成一条线。 | 以为 GC 等于不会泄漏；以为 Rust 安全代码不会悬垂就也不用关心内存布局；把 `mem::forget` 当常规释放；以为 `Rc` 能自动打破循环。 |

## 一条主线

这一章从「一个地址值」走到「一块内存的生死」：**先让地址落地（1.9.1）**，把磁盘当下一级存储、物理内存当它的缓存，于是缺页分成次、主、无效三类（1.9.2）；**再让翻译可算（1.9.3、1.9.8）**，9/9/9/9/12 拆开、逐级查表、PFN 拼偏移，顺带看清 TLB 与大页在省哪几次访存（1.9.4）；**接着让内核的账本可见（1.9.5）**，VMA、`maps`、`smaps` 把「进程以为什么都有」翻译成「哪些区间真的在」；`mmap` 是这张账本的用户接口（1.9.9），`SIGBUS`/`mincore` 是它的失败面与观测面（1.9.12）；**然后进入分配器（1.9.6、1.9.10、1.9.11）**，看边界标记怎样分裂与合并、glibc 又怎样用 tcache 与 arena 把锁和碎片压下去；**最后把错误与工具接上（1.9.7、1.9.13、1.9.15）**，让「泄漏、越界、双重释放」有第一现场，让「页表、驻留、大页」有读数。1.9.14 把释放点摆到三种语言里对照，1.9.16 的达标自检由[自检表](ch09-checklist.md)接管。判断任何一次内存问题，固定问三件事：**这块地址在不在 VMA 里？它的页在不在物理内存里？谁负责在什么时候释放它？**

## 症状 → 机制 → 命令

| 症状 | 机制（先想哪一节） | 第一条命令 / 动作 |
|:--|:--|:--|
| 进程 RSS 持续上涨，最后被 OOM 杀 | 泄漏、分配器碎片，或 `MADV_FREE` 尚未回收（1.9.7、1.9.15 第 10 条） | `grep -E -e Rss -e Pss -e Private_Dirty /proc/$pid/smaps_rollup`；`valgrind --leak-check=full --show-leak-kinds=definite ./prog` |
| 收到 `SIGSEGV`，但代码里没有明显的空指针 | 无效缺页：地址不在 VMA、权限不符，或 `si_addr` 是空指针加偏移（1.9.2、1.9.7） | 先读 core/`dmesg` 的 `si_addr` 与 `si_code`，再对照 `/proc/$pid/maps` |
| 读文件映射时收到 `SIGBUS` | 访问了完全在 EOF 之后的页，或文件被截断（1.9.9、1.9.12） | 用 `fstat` 算 `ceil(size/page)*page`，确认越界页号；`mincore` 只作参考 |
| `free(): invalid pointer` / `double free` | 堆元数据被越界写坏，或释放了非 `malloc` 返回的指针（1.9.7、1.9.15） | 重编译加 `-fsanitize=address`，用 `ASAN_OPTIONS=abort_on_error=1` 跑一遍 |
| `malloc` 返回 `NULL` | `ENOMEM`：地址空间上限、`RLIMIT_AS`、overcommit 策略（1.9.10） | `ulimit -v`；`grep -E -e CommitLimit -e Committed_AS /proc/meminfo` |
| `VmSize` 很大但 `Rss` 很小 | 只预留未提交，或大块 `mmap` 尚未触碰（1.9.5、1.9.15 第 12 条） | `grep -E -e VmSize -e VmRSS /proc/$pid/status`；再看 `smaps_rollup` 的 `Rss` |
| 程序启动或 `fork` 后次缺页很多 | 按需分页与写时复制（1.9.2、1.9.15 第 9 条） | `/usr/bin/time -v ./prog` 看 minor/major faults；没有 `perf` 时用这个 |
| 随机访问大数组变慢，缓存缺失却不高 | TLB 覆盖不够，4 KiB 页换得太频繁（1.9.3、1.9.4） | `cat /sys/kernel/mm/transparent_hugepage/enabled`；`grep AnonHugePages /proc/self/smaps_rollup` |
| `mmap` 返回 `MAP_FAILED`，`errno=EINVAL` | `length=0`、`offset` 未按页对齐，或 flags 冲突（1.9.9） | `getconf PAGE_SIZE`，检查 `offset % page == 0` 与 `MAP_SHARED/PRIVATE` 是否只选了一个 |
| 崩溃点离越界写很远 | 越界只破坏了相邻块的 header，直到 `free` 才被发现（1.9.6、1.9.7） | 用 ASan 在写入处报错；`MALLOC_CHECK_=3` 只适合快速复现 |

## 能否讲出这八句话

1. 虚拟内存的三个角色是缓存、管理、保护；swap 只是「缓存容量不够时把冷页换出」的去处，没有 swap 系统也能正常工作。
2. 缺页分次、主、无效三类：次缺页不读存储但可能分配/清零/复制页，主缺页要读磁盘或 swap，无效缺页只发 `SIGSEGV`/`SIGBUS`。
3. 48 位 VA 是 9/9/9/9/12，一次 TLB 未命中最多 4 次表项访存；单级页表要 512 GiB，多级页表只给已映射区间建分支。
4. TLB 覆盖 = 项数 × 页大小：64 项配 4 KiB 是 256 KiB，配 2 MiB 是 128 MiB；大页减少 TLB 压力，代价是内部碎片与分配难度。
5. VMA 是「起始-结束 + 权限 + 文件/偏移」；`maps` 只有虚拟布局，`smaps` 的 `Rss` 是驻留、`Pss` 按共享份额折算，`VmSize` 不能当内存用量。
6. `mmap` 的四种组合决定写时是否 COW、是否写回文件；失败返回 `MAP_FAILED`；文件最后一页尾部零填充，完全在 EOF 之后的页才 `SIGBUS`。
7. 分配器的四条约束是对齐、不重叠、不移动、及时复用；glibc 的路径是 tcache → fastbins → small/large bins → unsorted → top → `brk`/`mmap`，大于 128 KiB 的块直接 `mmap`。
8. 释放点可以交给程序员（C）、作用域（Rust）、计数（`Rc`/`Arc`）或可达性（GC）；GC 只回收不可达对象，救不了 UAF，也挡不住全局缓存造成的泄漏。

## 学完之后

1. **[闭卷回忆卡](ch09-recall.md)**：A 组考概念与判读，B 组考地址拆分、页表账与分裂合并，C 组考 `mmap`、工具与陷阱；合上正文，把 9/9/9/9/12、515 页、128/224/352、`MAP_FAILED`、`SIGBUS` 这几处从空白纸上叫出来。
2. **[习题集](ch09-exercises.md)**：A 组按「会读会判」出题，B 组给现象让你判「泄漏、越界、UAF、TLB、COW」中的哪一类，C 组是能在 Ubuntu 24.04 上免特权复现的四个实验；先做 A 与 B，再跑 C。
3. **[学习目标自检表](ch09-checklist.md)**：这张表接管 [1.9.16 本章小结](ch09.md#sec-1.9.16)，把卡住的对回小节与习题，不必从头再读整章。
4. **[勘误与版本注记](ch09-errata.md)**：本章最容易搬家的是三件事——页大小（4 KiB 还是 16 KiB）、THP 与 `perf` 的可用性、以及 1.9.11/1.9.12 里的示例地址与长度。先读未实测项再引用任何数字。
5. **下一站**：文件页与匿名页的另一半在 [1.10 系统级 I/O](ch10.md) 与 [1.10.15](ch10.md#sec-1.10.15) 的 page cache 证据；并发侧接 [1.12.2 共享地址空间](ch12.md#sec-1.12.2) 与 [1.12.10 futex](ch12.md#sec-1.12.10)；系统调用侧接 [2.3.4 `mmap`](../part2/ch03.md#sec-2.3.4) 与 [2.3.16 缺页路径](../part2/ch03.md#sec-2.3.16)。
