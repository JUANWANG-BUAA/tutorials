# 1.12 勘误与版本注记

这一页收本章最容易「换一台机器、换一个编译器就不成立」的东西：`volatile` 的边界、优化级别对竞争程序的影响、`pthread` 的默认栈、TSan 与 ASan 的冲突、aarch64 与 x86-64 的代码生成，以及 `perf`/`gdb` 在受限环境里的可用性。正文的 `errata` 盒讲理解陷阱；这一页讲**换一个内核、换一个 libc、换一个架构之后要复核什么**。

**本章基线**：正文标「VM 实测」的读数来自本书 Ubuntu 24.04.5 虚拟机（aarch64、内核 7.0.0-38-generic、GCC 13.3.0、clang 18.1.3、4 vCPU，`sudo` 不可用）。`perf_event_paranoid=4`、`ptrace_scope=1`；`pthread`、`taskset`、`strace`、`valgrind` 可用，`gdb -p` 被拒。凡标「macOS」的是本机对照，本章没有在 macOS 上重跑并发实验；其余按末节当作未实测。

## 1. 语义、编译器与平台：十五个容易搬家的结论

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「`volatile` 能当同步用」 | 只禁止编译器缓存该对象；不保证原子，也不建立 happens-before。VM 实测：同一份 `race_lab.c` 加 `-DUSE_VOLATILE -O2`，三次只有 1083959/1095390/1073863（期望 4000000）；原子版本三次都是 4000000 | 同一源码分别加 `-DUSE_VOLATILE` 与 `-DUSE_ATOMIC` 编译，在 `-O2` 下各跑三次；再用 TSan 看 `volatile` 版本仍报 `data race` |
| 「`-O2` 下竞争程序算对了，说明没问题」 | 编译器按单线程语义把循环折叠成一次加法；数据竞争是 UB，「对」只是这次代码生成的结果。VM 实测：`-O0` 三次是 2042685/2222928/2126285，`-O2` 三次 4000000 | 同一源码 `-O0` 与 `-O2` 对照；换 GCC/clang、加 `-fno-strict-aliasing` 或加日志再看；结论只写「UB」 |
| 「`pthread` 默认栈就是 8 MiB，所有架构一样」 | 8 MiB 是 glibc 在本书 aarch64 上的默认**虚拟**栈；`PTHREAD_STACK_MIN` 随架构与版本变。VM 实测：`pthread_attr_getstacksize` 为 8388608，`PTHREAD_STACK_MIN` 为 131072（128 KiB）；`pthread_attr_setstacksize(4096)` 返回 `EINVAL`（22） | 写个小程序打印 `pthread_attr_getstacksize` 与 `PTHREAD_STACK_MIN`；再试 4 KiB 与 256 KiB 两次 `setstacksize` |
| 「每个线程 8 MiB，1000 个线程就要 8 GiB 物理内存」 | 8 MiB 是虚拟地址预留，物理页按需缺页；真实占用要看 RSS、guard page、内核栈与 TLS。VM 实测：200 个默认栈线程让 `VmSize` 从 2268 kB 涨到 1653468 kB，`Threads` 201；换成 256 KiB 栈后是 99292 kB | `grep -E 'Threads\|VmSize\|VmRSS' /proc/<pid>/status`；用 `pthread_attr_setstacksize` 对照；不要只用 `VmSize` 推物理内存 |
| 「设了 `SO_REUSEADDR` 就万事大吉」式误解 | 1.11 里它只解决「绑定处于 `TIME_WAIT` 的本地地址」，救不了别人正在 `LISTEN`；这是「一个开关解决一类问题」的错觉。并发里有三个同构版本：加锁不等于没有竞争（漏保护、锁外读）、开 TSan 不等于没有竞争（只覆盖执行路径）、设 `O_NONBLOCK` 不等于不会阻塞（`epoll_wait`、磁盘 I/O、`getaddrinfo` 仍会阻塞） | 对每个「开关」问一句「它管哪一段、不管哪一段」；用负例验证：故意漏一把锁、故意跑未覆盖分支、故意在事件循环里做磁盘读 |
| 「TSan 与 ASan 可以一起开，一次查两类问题」 | GCC 13.3 直接拒绝：`cc1: error: '-fsanitize=thread' is incompatible with '-fsanitize=address'`。两者都要接管内存布局与运行时，不能共存 | `cc -fsanitize=address,thread ...` 看报错；分开构建两个二进制，各自跑 |
| 「TSan 编译完直接跑就行」 | 本书 VM 上直接跑报 `FATAL: ThreadSanitizer: unexpected memory mapping`；加 `setarch -R` 关 ASLR 后正常，抓到竞争时退出码 66。内核、glibc 与 ASLR 设置都会影响 | `setarch -R ./race_tsan; echo $?`；不加 `-R` 再跑一次对照；把 `uname -r` 与 `setarch --version` 记在旁边 |
| 「TSan/helgrind 没报，就是没有竞争」 | 两者都只检查**执行到的**路径；压测覆盖不到的分支、依赖特定时序的交错仍可能漏。helgrind 在本书 VM 上跑 `race_g`（`-O0`）只用了 0.24 s、报 6 errors / 2 contexts，但这是小程序，不代表大程序的开销 | 故意写一个「只有特定交错才触发」的竞争，看工具能否报；换 `-O0`/`-O2`、换线程数各跑几次 |
| 「`pthread_*` 失败看 `errno`」 | 它们直接返回错误码，成功为 0，不设 `errno`。VM 实测：对已 detach 的线程 `pthread_join` 返回 22（`EINVAL`），同时 `errno` 仍为 0（`Success`）；用 `perror` 会打印 `Success` | 打印 `rc` 与 `errno` 两个值；用 `strerror(rc)` 而不是 `perror` |
| 「线程退出了，资源就回收了」 | 只有 detached 线程如此。joinable 线程返回后栈、TLS、返回值仍保留，等 `join`；`Threads` 会回落，但 `VmSize` 可能阶梯上涨。VM 实测：200 线程 join 后 `Threads` 回 1，`VmSize` 仍为 35292 kB（glibc 缓存），未回到 2268 kB | 分批创建不 join 的线程，采样 `/proc/<pid>/status`；再改成 join/detach 对照；不要只看 `Threads` 一个数 |
| 「aarch64 与 x86-64 的内存模型差不多，代码可以照搬」 | x86-64 是较强的 TSO，release/acquire 常编成普通 `mov`；ARM64 是弱模型，需要 `stlr`/`ldar` 与屏障。本书 VM 实测（GCC 13.3 与 clang 18，`-O2`）：release 存是 `stlr`、acquire 读是 `ldar`、relaxed `fetch_add` 走 `__aarch64_ldadd4_relax`；**seq_cst 存两套编译器都只编出单条 `stlr`**，与正文表里写的 `dmb ish` 不同 | `cc -O2 -S mo.c` 与 `clang -O2 -S mo.c` 各看一次；结论按语言模型写，不按某条指令猜语义；x86-64 侧要在 x86 机器上复核 |
| 「`seq_cst` 一定比 `relaxed` 慢很多」 | 要看操作类型与架构：x86-64 上 RMW 无论什么序都带 `lock`，差距小；ARM64 上读改写与屏障的差距更明显。VM 实测的 `bench_lab` 里，最慢的是全局 mutex（1 核 24.7–26.8 ms，4 核 80.3–98.6 ms），不是原子序 | 用同一负载分别测 relaxed / seq_cst / mutex，记录 ns/op 与线程数；不要引用别处的倍数当本机结论 |
| 「`perf c2c` 能直接看到伪共享的 HITM」 | 本书 VM 的 `perf_event_paranoid=4`，硬件事件被拒；`perf c2c record` 报 `failed: no PMU supports the memory events`。`perf stat` 的 `cache-references` 也拿不到 | `perf stat -e cache-misses true` 看权限报错；`perf c2c record` 看 PMU 报错；改用 `taskset` + 计时或 `_Alignas(64)` 对照 |
| 「照抄 1.12.15 的 `fs.c` 就能看到 2–5 倍伪共享」 | 正文的 `s.a++` 在 `-O2` 下会被折叠成一次加法。VM 实测：原样编译两版都约 0.1 ms；给字段加 `volatile` 后才看到同一行 21.6–23.1 ms、`_Alignas(64)` 6.5–15.0 ms（约 1.4–3.5 倍，波动大） | 先跑原样版本，确认是否被优化；加 `volatile` 或每轮读一次数组；同时记录编译选项与 CPU 频率策略 |
| 「1.12.16 有十八条陷阱」 | 正文导语写「十八条陷阱（1.12.16）」，而 [1.12.16](ch12.md#sec-1.12.16) 的标题与表格是**九条**。引用时以标题的九条为准，不要把导语当数量 | 打开 1.12.16 数表格行；若后续补到十八条，再改导语与自检表 |

## 本章未实测项

下面这些没有本机证据支撑，引用前请当作**待验证的量级、形状或方法**，不要抄成事实：

- **x86-64 侧的代码生成与性能**：本书只有 aarch64 机器；`clang --target=x86_64-linux-gnu -S` 能出汇编，但本章没有做逐条对照，也没有在 x86 上跑 `bench_lab`。x86 的 `lock`/`xchg` 行为按架构文档描述。
- **`perf stat` 与 `perf c2c`**：`perf_event_paranoid=4`，硬件事件与 PMU 内存事件都不可用；正文的 HITM 列与「cache-misses 差值」未取得读数。
- **`gdb -p` 的线程栈**：`ptrace_scope=1`，本书用户 attach 被拒（`Could not attach to process`）；死锁取证只验证了 `timeout` 的 124 与 `ps -L` 的 `wchan`，没有拿到 `thread apply all bt` 的真实栈。
- **helgrind 的 20–100 倍开销**：只在 `race_g` 这种小二进制上跑了 0.24 s、6 errors / 2 contexts，没有做「同一程序原生 vs helgrind」的计时比。
- **十万连接、万级线程的压测**：没有做；8 MiB 栈的账是 200 线程的实测加上线性推算，不是万级连接的读数。
- **1.12.9 的 `atomic_bench` 三种模式读数**：本章跑了自写的 `bench_lab`（mutex vs 局部累加），没有复现 `atomic_bench` 的 relaxed/seq_cst/mutex 三行输出与 ns/op。
- **RCU/liburcu、用户态 seqlock、优先级继承（PI futex）**：只讲机制与接口，没有编译运行；`synchronize_rcu` 的宽限期长度、`PTHREAD_PRIO_INHERIT` 的行为都未测。
- **`io_uring` 与异步 I/O**：只做模型对比，没有写程序验证；内核版本与 liburing 版本都会影响接口。
- **cgroup 的 `pids.max`/`cpu.max` 实验**：没有写权限，未实际制造 `pthread_create` 的 `EAGAIN`；只按 5.3 的接口与内核计数口径描述。
- **1.12.13 的 Little 定律算例**（2 万请求/秒 × 5 ms = 100）是算式，不是压测结论；`N ≈ 核数 × (1 + W_io/W_cpu)` 也只是起点。
- **macOS 上的并发实验**：本章没有在 macOS 上重跑 `race_lab`、`taskset`（macOS 没有 `taskset`）或 TSan；跨平台只做了代码生成层面的观察。
- **CSAPP 第 12 章、OSTEP 第 25–34 章的页码与小节边界**：只按正文「母本对应」表核对结构，没有重读原书。

## 发现新问题怎么记

按「现象 → 命令与输出 → 机器/内核/libc/编译器/架构 → 建议改法」四段记，不要只写「我这里不对」。本章的结论大多挂在环境上，所以请一并附上：`uname -a`；`gcc --version` 与 `clang --version`；`ldd --version`；`nproc` 与 `taskset -pc $$`；`ulimit -u`、`ulimit -s`；`cat /proc/sys/kernel/perf_event_paranoid`、`cat /proc/sys/kernel/yama/ptrace_scope`；`pthread_attr_getstacksize` 与 `PTHREAD_STACK_MIN` 的打印值；完整编译命令（`-O0`/`-O2`、有没有 `-fsanitize=thread`、有没有 `-DUSE_VOLATILE`）；以及是否用了 `setarch -R`。涉及数字时写明口径：是计数器的最终值、`VmSize`、`VmRSS`、`ns/op`、`strace` 的调用次数，还是正文的参考形状。本章多数分歧都出在把后一种数当前一种用。
