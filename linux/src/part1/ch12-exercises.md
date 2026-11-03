# 1.12 习题集

三组分层：**A 组概念判断**考「会读、会判、会说理由」；**B 组诊断推理**给现象让你判竞争、死锁、泄漏与限额；**C 组动手实验**在 Ubuntu 24.04 上免 `sudo` 复现本章的关键证据。**全部附解答与判据**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；A 组要求口述或写一段完整因果，B 组要求写成「现象 → 机制 → 证据 → 修法」四段。
2. 卡住了回对应小节的「即时自测」重读，不要直接看答案；A 组对应 1.12.1–1.12.9，B 组对应 1.12.2–1.12.15，C 组对应 1.12.2、1.12.8、1.12.13、1.12.15。
3. C 组的命令都在本书的 Ubuntu 24.04.5 虚拟机（aarch64、内核 7.0.0-38-generic、GCC 13.3.0、4 vCPU）上跑过；标注「VM 实测」的是这台机器的读数，数字会随内核、libc 与调度变化。
4. **`sudo` 不可用**：`pthread`、`taskset`、`strace`、`valgrind` 可用；`perf` 的硬件事件被 `perf_event_paranoid=4` 挡住，C 组不用它；`gdb -p` 在本书 VM 上 attach 被拒（提示检查 `ptrace_scope`，本机为 1），取证改用 `ps -L`。端口与 CPU 都用本机现有资源，不需要 root。
5. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch12-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 1.12-A1 · 并发、并行与 Amdahl 上限 {#ex-1.12-A1}

并发与并行的区别是什么？单核能不能并发？一个程序 90% 的耗时可以并行，用 4 核与 8 核的加速比上限各是多少？为什么「加核」之前要先找串行部分？

::: sol 解答

并发是「多个任务在时间上重叠」，单核分时也能并发，解决的是「等待时别闲着」；并行是「多个任务在同一时刻真正执行」，需要多核，解决的是「算得更快」。二者收益模型不同：并发看吞吐与延迟，并行受 Amdahl 定律约束。设串行占比 `s = 0.1`，`p` 核的上限是 `1/(s + (1-s)/p)`：`p = 4` 时 `1/(0.1 + 0.225) ≈ 3.08`；`p = 8` 时 `1/(0.1 + 0.1125) ≈ 4.71`。核数翻倍，加速比只从 3.08 涨到 4.71，因为串行部分不摊薄。工程上先找串行部分：初始化、单线程 I/O、全局锁、负载不均；找不到就加核，通常只是把争用放大。

**判据**：能说清「单核并发、多核并行」；两个加速比都算对（3.08、4.71，允许四舍五入）；能指出串行占比决定上限，并给出至少两个串行来源。

:::
:::

::: ex 例 1.12-A2 · 数据竞争、`volatile` 与三种修法 {#ex-1.12-A2}

`counter++` 在机器层是哪几步？两个线程各加 100 万次为什么结果小于 400 万？C11 如何定义这种访问？`volatile` 为什么修不了？互斥锁、原子操作、局部累加三种修法各适合什么场景？

::: sol 解答

`counter++` 是 load → add → store 三步，中间可被插入。两个线程读到同一个旧值，各自加一后写回，更新丢失一次；线程越多、循环越长，丢得越多。C11 把「两个线程无同步地访问同一内存、至少一个在写」定义为**数据竞争**，行为未定义——编译器可以假设它不发生，从而做出循环折叠这类优化。`volatile` 只禁止编译器缓存该对象，不保证原子性，也不建立 happens-before，所以修不了竞争。三种修法：① 互斥锁包住 `counter++`，适合临界区长、要保护多个相关字段；② `atomic_fetch_add_explicit(&counter, 1, memory_order_relaxed)`，适合单个计数器/标志位；③ 每线程局部累加，最后用锁或原子操作合并，适合可分解的统计与计算，竞争最少。

**判据**：三步写全；把丢失更新与「数据竞争 = UB」连起来；说清 `volatile` 缺原子性与顺序两层；三种修法各给适用场景；知道原子版本仍可能有缓存行争用。

:::
:::

::: ex 例 1.12-A3 · 条件变量：`while`、丢失唤醒与广播 {#ex-1.12-A3}

`pthread_cond_wait` 做了哪三件事？为什么必须用 `while` 而不是 `if`？「丢失唤醒」在什么时序下发生？`signal` 与 `broadcast` 各用在哪？

::: sol 解答

`pthread_cond_wait` 释放 mutex、睡眠、被唤醒后重新获取 mutex；它等的是「有人通知」，不是「条件为真」。必须 `while`：可能虚假唤醒，也可能醒来时条件又被别的线程改回假，`if` 只查一次就直接进临界区，会读到不满足条件的状态。丢失唤醒的时序是：消费者检查条件为假 → 尚未进入 `wait` → 生产者改条件并 `signal`（若没持锁）→ 消费者才睡，通知已经过去。修法是「持锁改条件，再 `signal`」。`signal` 唤醒一个等待者，适合「每个通知只够一个任务」；`broadcast` 唤醒全部，适合状态变化影响所有等待者（如 `shutdown`、队列由空变非空且多个 worker 可竞争）。条件变量没有记忆，通知时没有等待者就丢失；信号量的计数会保留。

**判据**：三件事齐全；`while` 的理由同时提到虚假唤醒与谓词再次变假；丢失唤醒的时序能画出来；`signal`/`broadcast` 各给一个场景；知道条件变量不保存通知。

:::
:::

::: ex 例 1.12-A4 · 信号量有界缓冲区的顺序 {#ex-1.12-A4}

有界缓冲区用哪三个信号量、初值各是多少？生产者与消费者的等待顺序是什么？如果把「先等资源、再拿锁」反过来，会在什么状态下死锁？为什么不能只用条件变量加一个计数？

::: sol 解答

`empty = N`（空槽数）、`full = 0`（已填槽数）、`mutex = 1`（保护 `in/out` 与槽位）。生产者先 `sem_wait(empty)` 再 `pthread_mutex_lock(mutex)`；消费者先 `sem_wait(full)` 再拿锁；`in/out` 与缓冲区读写都在锁内。反过来（先拿锁再等资源）：缓冲区满时生产者握着 `mutex` 睡在 `empty` 上，消费者要拿 `mutex` 才能取数据并 `sem_post(empty)`，锁永远拿不到，双方永久等待。只用条件变量加计数也能实现，但要把「计数」本身放进锁里保护，并处理通知丢失；信号量的优势是计数与等待是同一个原子操作，`sem_post` 在没人等待时也会加一，「记忆」不会丢。无论哪种，顺序原则都是「先等资源、再拿锁」，且不要在持锁时做可能阻塞的事。

**判据**：三个初值正确；两端顺序正确；能说清反序时死锁的具体状态（满/空）与持锁关系；能指出信号量「有记忆」、条件变量「没记忆」。

:::
:::

::: ex 例 1.12-A5 · 线程池：背压、关闭与队列策略 {#ex-1.12-A5}

线程池用哪三个同步对象？有界队列满时 `submit` 应该怎样？`shutdown` 为什么要 `broadcast`？worker 的循环条件与退出条件各是什么？队列满的五种策略各适合谁？

::: sol 解答

三个同步对象：`mutex` 保护队列与计数，`not_empty` 让 worker 在空队列上等，`not_full` 让 `submit` 在满队列上等。队列满时 `submit` 阻塞，形成背压（backpressure），内存有界；无界队列在过载时 OOM，比拒绝更糟。`shutdown` 要 `pthread_cond_broadcast` 两个条件变量：`signal` 只唤醒一个 worker，其余永远睡；同时要让卡在 `not_full` 上的 `submit` 醒来并返回错误。worker 的循环条件是 `while (count == 0 && !shutdown)`，退出条件是 `count == 0 && shutdown`；写成 `if (shutdown) break` 会在队列还有任务时退出，丢掉在途工作。五种队列策略：阻塞提交（上游能等）、立即拒绝（面向用户，快速返回 503）、调用者执行（自然限流）、丢弃最旧（可接受丢任务）、无界队列（最简但会 OOM）。容量按 Little 定律起步，再压测找拐点。

**判据**：三个同步对象与两个条件变量说对；背压与「无界队列 OOM」的对比在；`broadcast` 与两个判断顺序都说对；五种策略至少说四种并给适用场景；知道要暴露队列长度与等待时间分位。

:::
:::

::: ex 例 1.12-A6 · 十万连接与 100 ms 磁盘 I/O {#ex-1.12-A6}

10 万条低流量长连接，选线程池还是事件循环？如果每个请求要做 100 ms 的磁盘 I/O 呢？真实系统怎样混用两者？跨线程传递 fd 与缓冲区时最容易错在哪？

::: sol 解答

10 万条低流量长连接选事件循环：线程池为每条连接常驻一个线程，每个线程默认 8 MiB 虚拟栈加内核栈，内存与调度都撑不住；事件循环用一个线程管全部 fd，只在就绪时处理。若每个请求有 100 ms 磁盘 I/O，纯事件循环会被阻塞调用拖住：一个慢请求让所有连接停摆。做法是把阻塞操作交给线程池或异步 I/O，事件循环只负责网络事件与状态机。真实服务器常混用：`epoll` 线程收发包、解析协议，业务提交线程池，线程池的回调把结果写回 event loop。跨线程传递 fd 与缓冲区时，最容易错在所有权与生命周期：谁负责 `close`、谁负责 `free`、回调时连接是否还在、写侧没发完的字节由谁保存；必须明确「fd 是进程级资源，缓冲区是堆对象」，并用队列 + `eventfd` 唤醒，而不是在多线程里对同一个 fd 调 `epoll_ctl`。

**判据**：两个场景的选择都给出理由（连接数、阻塞比例、共享状态）；混用结构说清；至少指出两个跨线程所有权问题（fd 关闭、缓冲区释放、连接生命周期、写缓冲）；知道 `epoll_ctl` 不要跨线程操作同一 fd。

:::
:::

## B 组 · 诊断推理

::: ex 例 1.12-B1 · 计数偶发少，`-O2` 反而「算对了」 {#ex-1.12-B1}

一个统计服务用 4 个线程各把全局 `long counter` 加 100 万次，压测时结果偶尔少几十万；把编译选项从 `-O0` 改成 `-O2` 后，连续几次都正好 400 万，团队认为「优化修好了」。写出「现象 → 机制 → 证据 → 修法」四段，并说明为什么 `-O2` 的「正确」不算数。

::: sol B1 核对

现象：`-O0` 下结果小于期望且每次不同；`-O2` 下偶尔正好等于期望。机制：`counter++` 是 load → add → store，线程间无同步，更新丢失；这是 C11 定义的数据竞争，行为未定义。`-O2` 下编译器按「单线程语义不变」把循环折叠成一次加法，所以结果「对」了——这不是程序正确，而是 UB 的一种表现；换编译器、换版本、加日志都可能变回去。本书 VM 实测同一份 `race_lab.c`：`-O0` 三次 2042685/2222928/2126285；`-O2` 三次 4000000；`-DUSE_VOLATILE -O2` 三次约 107–109 万；`-DUSE_ATOMIC` 三次 4000000。证据：`cc -O1 -g -fsanitize=thread -pthread race_lab.c -o race_tsan`，`setarch -R ./race_tsan` 报 `data race`，退出码 66；报告里两次访问都在 `worker`，`Location is global 'counter'`。修法：用 `atomic_fetch_add_explicit(..., memory_order_relaxed)` 或互斥锁；若要减少争用，每线程局部累加后合并。

**判据**：把「-O2 算对」判成 UB 而不是修复；能给出 `-O0` 与 `-O2` 的对照实验；TSan 命令含 `setarch -R`（或说明本机 ASLR 问题）；修法给原子与锁两种。

:::
:::

::: ex 例 1.12-B2 · 服务卡死，CPU 接近 0 {#ex-1.12-B2}

一个双线程服务在压测中偶发完全卡住：进程还在，CPU 接近 0，日志停在两次「加锁成功」之间。怎样证明是死锁而不是算得慢？在不能 `sudo`、`gdb -p` 被拒的机器上，能拿到哪些证据？修法有哪些？

::: sol B2 核对

现象：进程存活、CPU 为 0、没有新日志。机制：两个线程各持一把锁再申请对方那把（AB/BA），形成循环等待；四个条件同时满足，谁也不释放。证据：① `timeout 3 ./deadlock; echo $?` 返回 124，说明不是算得慢；② `ps -L -o pid,tid,stat,wchan,comm -p <pid>` 看到线程状态 `S`、`wchan` 为 `futex_do_wait`（本书 VM 实测该字段；`gdb -p` 报 `Could not attach to process` 并提示检查 `ptrace_scope`，本机值为 1）；③ 在代码里给锁命名并打印「已持有/正在等」，或画等待图（节点是线程与锁，边是持有/等待），有环即死锁；④ TSan 的 `TSAN_OPTIONS="second_deadlock_stack=1"` 或 helgrind 的 `lock order ... violated` 能在运行时报告锁序反转。修法按代价：全局锁序（最常用）、`trylock` 全部失败全放、`pthread_mutex_timedlock` 超时回滚、锁层级、消息传递、无锁结构；修完跑 1000 次压测并重跑锁序检查。

**判据**：能用 `timeout` 的 124 区分「卡住」与「慢」；至少给出 `ps -L` 的 `wchan` 证据；知道本机 `gdb -p` 不可用时不硬编造栈；修法给全局锁序 + 一种回滚手段；提到修后复测。

:::
:::

::: ex 例 1.12-B3 · 线程数回落了，`VmSize` 却一台阶一台阶涨 {#ex-1.12-B3}

一个请求处理程序每来一批请求就创建 200 个线程做计算，不做 `join`，线程函数直接 `return NULL`。运行几小时后 `Threads` 看起来正常，但 `VmSize` 持续上涨，最终 OOM。解释原因，给出证据与两种修法。为什么「线程已经退出」不等于「资源已经回收」？

::: sol B3 核对

现象：`Threads` 回落到正常值，`VmSize` 阶梯上涨。机制：默认创建的线程是 joinable；线程函数返回后任务结束、`Threads` 减少，但栈、TLS、返回值仍保留，等待 `pthread_join` 回收。每批 200 个线程就留下 200 份栈映射，虚拟内存阶梯上涨；物理内存是否同步上涨取决于是否触碰过栈页，但地址空间与内核资源确实没归还。本书 VM 实测：200 个默认栈线程让 `VmSize` 从 2268 kB 涨到 1653468 kB；`join` 后 `Threads` 回 1，但 `VmSize` 仍有 35292 kB（glibc 缓存，不立刻归还）；改用 256 KiB 栈后同样 200 个线程只有 99292 kB。证据：`grep -E 'Threads|VmSize' /proc/<pid>/status` 定时采样；`ls /proc/<pid>/task | wc -l` 对照。修法：① 保存 `pthread_t` 并 `pthread_join`；② 创建时 `pthread_detach` 或用 `pthread_attr_setdetachstate` 设为 detached；③ 更好的做法是用固定线程池，不要每批创建。注意 join 之后 `VmSize` 不一定立刻回到基线，不能只看这一个数字判断泄漏。

**判据**：把「线程退出」与「资源回收」分开；能解释 joinable 的栈/TLS/返回值保留；给出 `Threads` 与 `VmSize` 的采样证据；两种修法（join、detach）都给；知道 join 后 `VmSize` 可能被 glibc 缓存。

:::
:::

::: ex 例 1.12-B4 · 容器里 `pthread_create` 返回 `EAGAIN` {#ex-1.12-B4}

一个 4 核容器里跑服务，启动 300 个 worker 线程，日志里出现 `pthread_create: Resource temporarily unavailable`，但宿主机很空闲。列出至少三个可能原因与各自的检查命令；为什么「宿主机空闲」不代表容器里能建线程？

::: sol B4 核对

`EAGAIN` 表示资源不足，不是参数错。三个常见原因：① cgroup `pids.max`：线程也计一个任务，300 个线程加主线程超限；查 `cat /sys/fs/cgroup/pids.max`、`pids.current`、`pids.events`（`max` 计数增长）。② `RLIMIT_NPROC`（每用户进程/线程数）：查 `ulimit -u`，以及 `/proc/<pid>/limits` 的 `Max processes`；容器里可能被设得很低。③ 内存/栈：每个线程 8 MiB 虚拟栈，几百个线程在 32 位或受限地址空间里可能失败；查 `/proc/<pid>/status` 的 `VmSize`，用 `pthread_attr_setstacksize` 降到 256 KiB–1 MiB。另有 cgroup 内存上限导致的分配失败、`/proc/sys/kernel/threads-max` 等。宿主机空闲不代表容器能建：限额按 cgroup 算，核数 `sysconf` 还可能返回宿主核数，让人误以为「4 核可以开 300 个」。修法：按线程峰值设 `pids.max`，或把池大小降到 `核数 × (1 + W_io/W_cpu)` 的量级并用队列吸收突发。

**判据**：至少三个原因（`pids.max`、`RLIMIT_NPROC`、内存/栈）；每个都有检查命令；能解释线程计入 `pids.current`；修法不是「无限调大」，而是按峰值与池容量算。

:::
:::

::: ex 例 1.12-B5 · 加核反而更慢 {#ex-1.12-B5}

同一个 4 线程全局锁计数程序，绑在 1 个核上跑 25 ms，放开到 4 个核却要 80–99 ms。列出三种可能机制，各给一个能区分它们的实验；怎样判断是锁争用、线程迁移还是伪共享？

::: sol B5 核对

三种机制：① 锁争用：所有线程抢同一把 mutex，临界区虽短，但缓存行所有权在核间来回转移，核越多争用越重；② 线程迁移：线程在核间被调度器搬动，本地缓存与 TLB 失效；③ 伪共享：不同变量落在同一缓存行，写一个就让另一个核的副本失效。区分实验：① 用 `taskset -c 0` 与 `taskset -c 0-3` 跑同一二进制，本书 VM 实测全局锁版本 1 核 24.7–26.8 ms、4 核 80.3–98.6 ms——加核变慢，先把嫌疑落在争用/迁移；② 把全局锁改成每线程局部累加再合并，同样对照：VM 实测局部版本 1 核 1.2–1.4 ms、4 核 0.6–0.9 ms，说明争用消失后不再随核数变慢；③ 伪共享用「同一结构体两个字段」与 `_Alignas(64)` 两版对照，VM 实测同一行 21.6–23.1 ms、对齐后 6.5–15.0 ms（`volatile` 计数版）；④ 观察 `ps -L -o tid,psr` 看线程是否频繁换核，`/proc/<pid>/task/<tid>/stat` 的上下文切换计数辅助判断。`perf c2c` 在本书 VM 不可用（`perf_event_paranoid=4`），不要编 HITM 数字。

**判据**：三种机制都说清；`taskset` 对照实验能落地；知道「加核变慢」首先怀疑争用与迁移，而不是「CPU 不行」；伪共享用对齐对照；知道本机 `perf c2c` 不可用。

:::
:::

::: ex 例 1.12-B6 · 通知偶尔丢失，消费者一直睡 {#ex-1.12-B6}

一个生产者-消费者用条件变量实现：生产者把任务放进队列后调用 `pthread_cond_signal`，但没有持锁；消费者用 `while (count == 0) pthread_cond_wait(...)`。低负载正常，高负载偶发「队列里有任务，消费者还在睡」。解释时序，给出证据与修法。为什么把 `if` 改成 `while` 也救不了这个 bug？

::: sol B6 核对

现象：队列非空但消费者不醒，直到下一个任务到来才被唤醒（延迟一个任务）。机制：生产者改 `count` 与 `signal` 不在同一临界区。时序是：消费者持锁检查 `count == 0` → 释放锁、尚未真正睡下 → 生产者不持锁地把 `count` 改成 1 并 `signal`（此时等待队列为空，通知丢失）→ 消费者才进入 `wait`，于是睡过这次通知。`while` 只保证「醒来后重查谓词」，管不了「通知在睡之前发生」，所以 `if` 改 `while` 不修这个 bug。证据：`strace -f -e trace=futex ./pc` 看 `FUTEX_WAKE` 与 `FUTEX_WAIT` 的次数与顺序；在生产者、消费者两侧打印时间戳与 `count`；本书 VM 的 `pool_lab` 用持锁改条件 + `broadcast`，三次都 `maxq=2 done=8`，没有丢任务。修法：把「改 `count`、入队、`signal`」放进同一个 `mutex` 临界区；`signal` 放在解锁前或解锁后都可以（POSIX 允许），但改条件必须持锁；关闭用 `broadcast`。若是多消费者且每次只加一个任务，`signal` 足够；若一次加多个，按数量 `signal` 或直接 `broadcast`。

**判据**：时序能画出「检查 → 释放锁 → 通知 → 睡」的窗口；知道 `while` 解决虚假唤醒、不解决丢失唤醒；证据用 `strace` 或日志时间戳；修法是「持锁改条件再通知」；知道 `signal`/`broadcast` 的选择依据。

:::
:::

## C 组 · 动手实验

::: ex 例 1.12-C1 · 同一份源码，四种计数器：`-O0`、`-O2`、`volatile`、`atomic` {#ex-1.12-C1}

用一份源码编译出四个二进制，观察数据竞争在不同优化级别下的表现；再用 TSan 抓一次。记录你自己机器的数，并解释「`-O2` 算对」为什么不等于正确。

::: sol C1 核对

```c
/* race_lab.c：默认有竞争；-DUSE_VOLATILE / -DUSE_ATOMIC 切换实现
 * cc -std=c17 -O0 -pthread race_lab.c -o race_o0
 * cc -std=c17 -O2 -pthread race_lab.c -o race_o2
 * cc -std=c17 -O2 -pthread -DUSE_VOLATILE race_lab.c -o race_vol
 * cc -std=c17 -O2 -pthread -DUSE_ATOMIC   race_lab.c -o race_atomic
 */
#define _GNU_SOURCE
#include <pthread.h>
#include <stdatomic.h>
#include <stdio.h>

#define NTHREADS 4
#define NLOOP    1000000L

#ifdef USE_ATOMIC
static atomic_long counter;
#elif defined(USE_VOLATILE)
static volatile long counter;
#else
static long counter;
#endif

static void *worker(void *arg)
{
    (void)arg;
    for (long i = 0; i < NLOOP; i++) {
#ifdef USE_ATOMIC
        atomic_fetch_add_explicit(&counter, 1, memory_order_relaxed);
#else
        counter++;
#endif
    }
    return NULL;
}

int main(void)
{
    pthread_t t[NTHREADS];
    for (int i = 0; i < NTHREADS; i++) {
        if (pthread_create(&t[i], NULL, worker, NULL) != 0) {
            perror("pthread_create");
            return 1;
        }
    }
    for (int i = 0; i < NTHREADS; i++)
        pthread_join(t[i], NULL);
#ifdef USE_ATOMIC
    printf("counter=%ld expected=%ld\n", atomic_load(&counter), NTHREADS * NLOOP);
#else
    printf("counter=%ld expected=%ld\n", counter, NTHREADS * NLOOP);
#endif
    return 0;
}
```

```bash
cc -std=c17 -O0 -Wall -Wextra -Werror -pthread race_lab.c -o race_o0
cc -std=c17 -O2 -Wall -Wextra -Werror -pthread race_lab.c -o race_o2
cc -std=c17 -O2 -Wall -Wextra -Werror -pthread -DUSE_VOLATILE race_lab.c -o race_vol
cc -std=c17 -O2 -Wall -Wextra -Werror -pthread -DUSE_ATOMIC   race_lab.c -o race_atomic
for i in 1 2 3; do ./race_o0; done
for i in 1 2 3; do ./race_o2; done
for i in 1 2 3; do ./race_vol; done
for i in 1 2 3; do ./race_atomic; done

cc -std=c17 -g -O1 -fsanitize=thread -pthread race_lab.c -o race_tsan
setarch -R ./race_tsan; echo "exit=$?"
```

VM 实测（一次会话）：`-O0` 三次 `2042685 / 2222928 / 2126285`；`-O2` 三次 `4000000`；`volatile -O2` 三次 `1083959 / 1095390 / 1073863`；`atomic` 三次 `4000000`。TSan 直接运行会报 `FATAL: ThreadSanitizer: unexpected memory mapping`，加 `setarch -R` 后报 `WARNING: ThreadSanitizer: data race`，`Location is global 'counter'`，退出码 66。解释：`-O2` 把循环折叠成一次加法，所以「对」；`volatile` 禁止缓存但不原子，所以丢得更多；原子版本每次读—改—写不可分割，所以恒等。判据不是某个具体数字，而是：`-O0` 小于期望、`volatile` 也小于期望、`atomic` 恒等于期望、TSan 能报出同一个变量。若你的机器 `-O2` 下仍然小于期望，也正常——UB 不承诺方向。

**判据**：四个二进制都跑过并记录；能指出 `-O2` 的「对」来自优化而非修复；TSan 报告含两次访问与变量名；知道本机需要 `setarch -R`；原子版本恒等于 400 万。无需 `sudo`。

:::
:::

::: ex 例 1.12-C2 · 200 个线程的栈账：默认 8 MiB vs 256 KiB {#ex-1.12-C2}

创建 200 个线程，分别用默认栈与 `pthread_attr_setstacksize(256 KiB)`，读 `/proc/self/status` 的 `Threads` 与 `VmSize`。两次的差值说明什么？`join` 之后 `VmSize` 会回到基线吗？

::: sol C2 核对

```c
/* stack_lab.c：默认栈 vs 256 KiB 栈
 * cc -std=c17 -O1 -Wall -Wextra -Werror -pthread stack_lab.c -o stack_lab
 */
#define _GNU_SOURCE
#include <pthread.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

static void *sleeper(void *arg)
{
    (void)arg;
    usleep(200000);
    return NULL;
}

static void show(const char *tag)
{
    FILE *f = fopen("/proc/self/status", "r");
    char line[256];

    printf("-- %s --\n", tag);
    while (f != NULL && fgets(line, sizeof line, f) != NULL) {
        if (strncmp(line, "Threads:", 8) == 0 || strncmp(line, "VmSize:", 7) == 0)
            fputs(line, stdout);
    }
    if (f != NULL)
        fclose(f);
}

static void run(int n, size_t stack)
{
    pthread_attr_t attr;
    pthread_t t[256];

    pthread_attr_init(&attr);
    if (stack != 0)
        pthread_attr_setstacksize(&attr, stack);
    for (int i = 0; i < n; i++) {
        if (pthread_create(&t[i], &attr, sleeper, NULL) != 0) {
            printf("create failed at %d\n", i);
            break;
        }
    }
    show(stack != 0 ? "200 threads @256KiB" : "200 threads @default");
    for (int i = 0; i < n; i++)
        pthread_join(t[i], NULL);
    pthread_attr_destroy(&attr);
}

int main(void)
{
    show("baseline");
    run(200, 0);
    show("after join");
    run(200, 262144);
    return 0;
}
```

VM 实测：`baseline` 是 `VmSize 2268 kB / Threads 1`；200 个默认栈线程是 `VmSize 1653468 kB / Threads 201`；`join` 后是 `VmSize 35292 kB / Threads 1`；200 个 256 KiB 栈线程是 `VmSize 99292 kB / Threads 201`。差值说明默认栈约 8 MiB 是**虚拟**预留：200 × 8 MiB ≈ 1.6 GB，与实际增量同量级，但物理页只在触碰时分配。`join` 后 `Threads` 回 1，`VmSize` 没有回到 2268 kB，而是 35 MB 左右——glibc 缓存了部分栈映射，不能只看 `VmSize` 判断泄漏。要读默认值用 `pthread_attr_getstacksize`；本书 VM 实测 8388608，`PTHREAD_STACK_MIN` 为 131072；`pthread_attr_setstacksize(4096)` 返回 `EINVAL`（22）。判据是「默认远大于 256 KiB 版」「`Threads` 等于 n+1」「join 后线程数回落」，不是死记 1653468。

**判据**：两次 `VmSize` 相差一个数量级；`Threads` 为 201；能说出 8 MiB 是虚拟内存、按需缺页；知道 join 后 `VmSize` 不一定回基线；能读到 `PTHREAD_STACK_MIN`。无需 `sudo`。

:::
:::

::: ex 例 1.12-C3 · 用 `taskset` 把争用钉出来 {#ex-1.12-C3}

4 个线程各做 100 万次「读数组并累加」，分别用全局互斥锁与每线程局部累加。把进程分别绑到 1 个核与 4 个核，各跑三次。哪种实现随核数变慢？为什么？这能说明「锁的代价」与「并行的收益」各在什么条件下成立？

::: sol C3 核对

```c
/* bench_lab.c：全局锁 vs 每线程局部累加；数组在运行时初始化，防止循环被折叠
 * cc -std=c17 -O2 -Wall -Wextra -Werror -pthread bench_lab.c -o bench_lab
 * taskset -c 0   ./bench_lab
 * taskset -c 0-3 ./bench_lab
 */
#define _GNU_SOURCE
#include <pthread.h>
#include <stdatomic.h>
#include <stdio.h>
#include <time.h>

#define NTHREADS 4
#define NLOOP 1000000L

static pthread_mutex_t mtx = PTHREAD_MUTEX_INITIALIZER;
static long shared;
static long data[64];
static atomic_long sink;

static double now_ms(void) { struct timespec ts; clock_gettime(CLOCK_MONOTONIC, &ts); return ts.tv_sec*1e3 + ts.tv_nsec/1e6; }

static void *mutex_worker(void *a) { (void)a; for (long i=0;i<NLOOP;i++){ pthread_mutex_lock(&mtx); shared += data[i & 63]; pthread_mutex_unlock(&mtx);} return NULL; }
static void *local_worker(void *a) { (void)a; long s=0; for (long i=0;i<NLOOP;i++) s += data[i & 63]; atomic_fetch_add_explicit(&sink, s, memory_order_relaxed); return NULL; }

static double run(int local) {
    pthread_t t[NTHREADS]; double t0=now_ms();
    for (int i=0;i<NTHREADS;i++) pthread_create(&t[i],NULL,local?local_worker:mutex_worker,NULL);
    for (int i=0;i<NTHREADS;i++) pthread_join(t[i],NULL);
    return now_ms()-t0;
}

int main(void) {
    for (int i=0;i<64;i++) data[i]=i+1;
    double tm = run(0), tl = run(1);
    double ops = (double)NTHREADS*NLOOP;
    printf("mutex %.1f ms %.1f ns/op | local %.1f ms %.1f ns/op | speedup %.2fx sum=%ld\n",
           tm, tm*1e6/ops, tl, tl*1e6/ops, tm/tl, shared + atomic_load(&sink));
    return 0;
}
```

VM 实测：`taskset -c 0` 三次，`mutex` 为 `26.8 / 24.7 / 25.6 ms`（6.2–6.7 ns/op），`local` 为 `1.2–1.4 ms`；`taskset -c 0-3` 三次，`mutex` 为 `80.3 / 85.8 / 98.6 ms`（20.1–24.6 ns/op），`local` 为 `0.6–0.9 ms`。结论：全局锁版本从 1 核到 4 核反而慢 3–4 倍，因为锁的缓存行在核间来回搬、等待者被唤醒又睡；局部版本不共享写，随核数略微变快。这说明「锁的代价」在争用时会被核数放大，「并行的收益」只在临界区之外或可分解的工作上成立。注意 `local` 版本仍有一次原子合并，但每个线程只做一次，不在热路径。数字随机器与调度变化，判据是方向：`mutex` 在 4 核明显慢于 1 核，`local` 不明显。

**判据**：两组 `taskset` 都跑过并记录；能指出 `mutex` 在 4 核更慢；能解释缓存行争用与唤醒开销；知道 `local` 的合并也要同步一次；不把单次读数当基准结论。无需 `sudo`。

:::
:::

::: ex 例 1.12-C4 · 有界队列的背压与关闭：`maxq`、耗时与 `futex` 计数 {#ex-1.12-C4}

2 个 worker、队列容量 2、8 个各 30 ms 的任务。记录队列最大长度、完成数、提交阶段耗时与总耗时；再用 `strace -f -c -e trace=futex` 数一次 `futex` 调用。为什么总耗时接近 `8 × 30 / 2 = 120 ms` 而不是 `8 × 30 = 240 ms`？队列满时 `submit` 在等什么？

::: sol C4 核对

```c
/* pool_lab.c：2 个 worker、队列容量 2、8 个 30 ms 任务
 * cc -std=c17 -O2 -Wall -Wextra -Werror -pthread pool_lab.c -o pool_lab
 * ./pool_lab
 * strace -f -c -e trace=futex ./pool_lab
 */
#define _GNU_SOURCE
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#define NW 2
#define QCAP 2
#define NJOB 8

typedef struct task { int id; struct task *next; } task_t;
static pthread_mutex_t mtx = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t not_empty = PTHREAD_COND_INITIALIZER;
static pthread_cond_t not_full  = PTHREAD_COND_INITIALIZER;
static task_t *head, *tail;
static int count, shutdown_flag, maxq, done;

static double now_ms(void){struct timespec ts;clock_gettime(CLOCK_MONOTONIC,&ts);return ts.tv_sec*1e3+ts.tv_nsec/1e6;}

static void *worker(void *a){
    (void)a;
    for(;;){
        pthread_mutex_lock(&mtx);
        while(count==0 && !shutdown_flag) pthread_cond_wait(&not_empty,&mtx);
        if(count==0 && shutdown_flag){pthread_mutex_unlock(&mtx);break;}
        task_t *t=head; head=t->next; if(!head) tail=NULL; count--;
        pthread_cond_signal(&not_full);
        pthread_mutex_unlock(&mtx);
        usleep(30000);
        free(t);
        pthread_mutex_lock(&mtx); done++; pthread_mutex_unlock(&mtx);
    }
    return NULL;
}

static int submit(int id){
    task_t *t=malloc(sizeof *t); t->id=id; t->next=NULL;
    pthread_mutex_lock(&mtx);
    while(count==QCAP && !shutdown_flag) pthread_cond_wait(&not_full,&mtx);
    if(tail) tail->next=t; else head=t;
    tail=t; count++;
    if(count>maxq) maxq=count;
    pthread_cond_signal(&not_empty);
    pthread_mutex_unlock(&mtx);
    return 0;
}

int main(void){
    pthread_t w[NW];
    for(int i=0;i<NW;i++) pthread_create(&w[i],NULL,worker,NULL);
    double t0=now_ms();
    for(int i=0;i<NJOB;i++) submit(i);
    double t1=now_ms();
    pthread_mutex_lock(&mtx); shutdown_flag=1;
    pthread_cond_broadcast(&not_empty); pthread_cond_broadcast(&not_full);
    pthread_mutex_unlock(&mtx);
    for(int i=0;i<NW;i++) pthread_join(w[i],NULL);
    printf("maxq=%d done=%d submit=%.0f ms total=%.0f ms\n",maxq,done,t1-t0,now_ms()-t0);
    return 0;
}
```

VM 实测：三次 `maxq=2 done=8 submit=65/60/60 ms total=129/121/121 ms`；`strace -f -c -e trace=futex` 的一次运行里 `futex` 22 次调用、2 次错误，输出仍为 `maxq=2 done=8`。总耗时接近 120 ms 而不是 240 ms，因为两个 worker 并行，8 个 30 ms 任务分成两列；`submit` 在队列满时睡在 `not_full` 上，提交阶段约 60 ms 就是背压把调用者挡住的时间。`futex` 次数不多，因为 worker 取任务、睡、唤醒都在用户态状态字与 futex 之间切换，只有真正竞争/睡眠才进内核。判据：`maxq` 不超过 2、`done` 为 8、总耗时约为「任务数 / worker 数 × 单任务时间」、`strace` 能看到 `futex`。若把 `QCAP` 改成 64，`maxq` 会变大、提交阶段变短、总耗时不变，这就是「队列吸收突发但不缩短服务时间」。

**判据**：`maxq ≤ 2`、`done = 8`；总耗时约为 120 ms 量级；能解释背压发生在 `submit` 而不是 worker；`strace` 里能看到 `futex`；能预测把容量改大后的变化。无需 `sudo`。

:::
:::
