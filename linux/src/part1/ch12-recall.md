# 1.12 闭卷回忆卡

这一页不是摘要，而是一组**检索练习**。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。17 张卡分三组：**A 组考并发与并行、共享与私有、数据竞争、`volatile`、锁与条件变量（1.12.1–1.12.3）**，**B 组考信号量、线程池、读写锁/seqlock/RCU、内存序与 futex（1.12.4–1.12.11）**，**C 组考生命周期、死锁取证、工具、容量与模型选择（1.12.8–1.12.17）**。建议在学完当天、隔天、第 3 天、第 7 天各做一次，每次只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 模型、共享状态与同步原语

::: method 回忆 1 · 并发与并行，Amdahl 的上限
并发与并行的区别是什么？单核能不能并发？4 核、90% 可并行的程序，加速比上限是多少？
::: sol 答案
并发是「多个任务在时间上重叠」，单核分时也能并发，省的是等待；并行是「同一时刻真正执行」，要有多核，省的是时间。并行加速比受 Amdahl 定律约束：串行占比 `s` 时上限是 `1/s`。`s = 0.1`、4 核时 `1/(0.1 + 0.9/4) ≈ 3.08`，不是 4。所以「加核」之前先问串行部分在哪：锁竞争、初始化、单线程 I/O 都会把上限压死。本章的线程池（任务并行）与事件循环（等待集中）分别对应这两种收益模型。
:::
:::

::: method 回忆 2 · 线程共享什么、私有什么
线程之间共享哪些资源？每个线程私有哪些？`errno` 为什么在多线程里不会互相覆盖？
::: sol 答案
共享：全局变量、静态变量、堆、打开的文件描述符表、当前工作目录、`umask`、信号处理表（但信号掩码与 pending 集合是每线程的）。私有：栈与寄存器上下文、线程 ID、`errno`、线程局部存储（TLS）、信号掩码、`pthread_cleanup` 栈。glibc 的 `errno` 是线程局部变量，所以每个线程看到自己的错误码；这也是为什么库函数不能返回指向静态缓冲区的指针（`localtime` 要用 `localtime_r`）。共享是性能来源，也是数据竞争与死锁的来源。
:::
:::

::: method 回忆 3 · 数据竞争与 `counter++` 的三步
`counter++` 在机器层是哪几步？两个线程各加 100 万次为什么结果小于 400 万？C11 怎样定义这种行为？本书 VM 上 `-O0`、`-O2`、`volatile` 三种构建各是什么形状？
::: sol 答案
`counter++` 是 load → add → store 三步，中间可被插入；两个线程读到同一个旧值，各自加一后写回，就丢一次更新。C11 把「两个线程无同步地访问同一内存、至少一个在写」定义为**数据竞争**，行为未定义——编译器可以假设它不发生。本书 VM 实测同一份 `race_lab.c`：`-O0` 三次是 2042685/2222928/2126285（期望 4000000）；`-O2` 三次都是 4000000，因为循环被折叠成一次加法；`-DUSE_VOLATILE -O2` 三次只有约 107–109 万。结论不是「-O2 修好了」，而是 UB 下三种结果都不作数；`-DUSE_ATOMIC` 三次都是 4000000。
:::
:::

::: method 回忆 4 · 为什么 `volatile` 不是同步
`volatile` 保证了什么、没保证什么？用它修数据竞争会得到什么？正确替代是什么？
::: sol 答案
`volatile` 只告诉编译器「每次都从内存读/写」，禁止缓存这个对象；它**不保证原子性**（读—改—写仍可交错），也**不建立 happens-before**（不阻止 CPU 与编译器重排其他访存）。所以它修不了数据竞争，只会让 bug 更隐蔽：本书 VM 上 `volatile` 版本在 `-O2` 下仍只得到约 107–109 万（期望 400 万）。正确替代：单个计数器/标志用 `_Atomic` 与合适的 `memory_order`；保护多个相关字段用互斥锁；可分解的统计用每线程局部累加再合并。
:::
:::

::: method 回忆 5 · 锁保护不变量，条件变量必须 `while`
「锁保护的是不变量」是什么意思？`pthread_cond_wait` 做了哪三件事？为什么必须 `while`？「丢失唤醒」怎样发生？
::: sol 答案
锁的粒度应按「哪些字段必须一起更新」来定，而不是按代码行数；临界区太长会串行化，太短会保护不全。`pthread_cond_wait` 做三件事：释放 mutex、睡眠、被唤醒后重新获取 mutex。它等的是「有人通知」，不是「条件为真」：可能虚假唤醒，也可能醒来时条件又被改回假，所以要用 `while (!pred)` 重查。丢失唤醒发生在「检查完条件、还没睡」的窗口：如果改条件的一方不持锁就 `signal`，通知会落在 `wait` 之前而丢失。规则是**持锁改条件，再 `signal`/`broadcast`**；`signal` 唤醒一个，`broadcast` 唤醒全部。
:::
:::

::: method 回忆 6 · 互斥锁的类型与自锁
`PTHREAD_MUTEX_NORMAL`、`ERRORCHECK`、`RECURSIVE`、`ROBUST` 各是什么行为？默认类型重复加锁会怎样？本书 VM 上怎样证明？
::: sol 答案
`NORMAL`（默认）性能优先，重复加锁是死锁，解锁别人的锁未定义；`ERRORCHECK` 重复加锁返回 `EDEADLK`、解锁别人的锁返回 `EPERM`，适合调试；`RECURSIVE` 允许同一线程重复加锁并按计数解锁；`ROBUST` 用于共享内存多进程，持锁进程被 `SIGKILL` 后下一个加锁者得到 `EOWNERDEAD`，修复数据后要调 `pthread_mutex_consistent`。本书 VM 实测：默认 mutex 在同一线程里连续 `lock` 两次，进程不再返回，`timeout 2 ./mtx_type` 退出码 124。这也解释了为什么「回调里再次申请同一把锁」会卡死。
:::
:::

## B. 信号量、池、锁的内部与内存序

::: method 回忆 7 · 三个信号量的有界缓冲区
`empty`、`full`、`mutex` 的初值各是多少？生产者与消费者的等待顺序为什么不能反？反了会在什么状态下死锁？
::: sol 答案
`empty = N`（空槽数）、`full = 0`（已填槽数）、`mutex = 1`（保护 `in/out` 与缓冲区）。生产者先 `sem_wait(empty)` 再 `lock(mutex)`，消费者先 `sem_wait(full)` 再 `lock(mutex)`；`in/out` 与槽位读写都在锁内。反过来的话：缓冲区满时，生产者先拿到 `mutex` 再睡在 `empty` 上；消费者要拿 `mutex` 才能取数据并 `sem_post(empty)`，但锁被生产者占着，双方永久等待。这就是「持有并等待」型死锁。信号量的初值就是资源数量，`sem_wait` 是申请、`sem_post` 是归还；`sem_post` 在没人等待时也会加一，所以信号量「有记忆」，条件变量没有。
:::
:::

::: method 回忆 8 · 线程池的三个同步点与关闭语义
线程池用哪三个同步对象？队列满时 `submit` 怎样形成背压？`shutdown` 为什么要广播？worker 的循环条件与退出条件各是什么？
::: sol 答案
`mutex` 保护队列与计数；`not_empty` 让 worker 在队列空时睡；`not_full` 让 `submit` 在队列满时等。队列满时 `submit` 阻塞，把过载传回调用者，内存有界；无界队列在过载时 OOM，比拒绝更糟。`shutdown` 置位后要 `pthread_cond_broadcast` 两个条件变量：`signal` 只唤醒一个 worker，其余永远睡。worker 的循环条件是 `while (count == 0 && !shutdown)`，退出条件是 `count == 0 && shutdown`；写成 `if (shutdown) break` 会丢掉队列里的剩余任务。关闭还要让卡在 `submit` 的调用者醒来并返回错误，最后 join 与销毁同步对象。
:::
:::

::: method 回忆 9 · 读写锁、seqlock 与 RCU 各让谁付代价
读写锁的读者/写者语义是什么？glibc 默认哪种优先、后果是什么？seqlock 的读者怎样保证不自相矛盾？RCU 的读者为什么几乎免费、写者要等什么？
::: sol 答案
读写锁：多个读者可同时持有读锁，写者独占且与读者互斥。glibc 默认读者优先，读请求源源不断时写者饥饿；`PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP` 可以改成写者优先，但会反过来饿死读者，且禁止递归读锁。seqlock：写者把序号加两次（写前变奇数、写后变偶数），读者读前读后各取一次序号，奇数或前后不一致就重读；它只保证「不把撕裂的数据当有效值」，不保证一致快照，读者不能有副作用、不能睡眠。RCU：读者只做「进入/退出读临界区」的标记，没有原子 RMW；写者复制新版本、原子替换指针、等一个宽限期让旧读者退出后再释放。经典 RCU 的读临界区不能睡眠。
:::
:::

::: method 回忆 10 · 六个内存序与发布模式
`relaxed`、`acquire`、`release`、`acq_rel`、`seq_cst` 各禁止哪些重排？「用标志发布数据」为什么必须是 release 存 + acquire 读？`relaxed` 换成发布序会怎样？
::: sol 答案
`relaxed` 只保证该对象上的原子性，不约束其他访存；`acquire` 禁止它之后的读写被提到它前面；`release` 禁止它之前的读写被挪到它后面；`acq_rel` 两者兼有，用于 RMW；`seq_cst` 在双向之外再给所有线程一个全序。发布模式：写方先写 `data`，再 `store(ready, 1, release)`；读方 `load(ready, acquire)` 看到 1 时，写方在 release 之前的全部写入都可见，`assert(data == 42)` 成立。换成 `relaxed` 就没有这对顺序，`assert` 可能失败——不是概率低，而是标准允许。`seq_cst` 最贵：x86-64 的 store 要 `xchg`/`mfence`，ARM64 通常要屏障；只做计数时用 `relaxed` 就够。
:::
:::

::: method 回忆 11 · futex 的三态状态字
glibc mutex 的状态字有哪三个值？无竞争加锁走哪些用户态操作？什么时候进内核？`FUTEX_WAIT` 为什么不会丢唤醒？
::: sol 答案
状态字：0 = 未加锁，1 = 已加锁无等待者，2 = 已加锁可能有等待者。加锁先 CAS 0→1，成功就进临界区，全程没有系统调用；失败则 CAS 1→2，再 `futex(FUTEX_WAIT, 2)` 睡眠。解锁时原值为 1 就写 0 结束；原值为 2 就写 0 并 `futex_wake(1)`。`FUTEX_WAIT` 在睡眠前会原子地比较状态字，如果已经被改成别的值就返回 `EAGAIN` 不睡，所以「检查后发现要睡、但唤醒已经发生」的窗口被封住。这也是 futex 不能单独当锁用的原因：没有用户态状态字，内核不知道要不要睡。
:::
:::

## C. 生命周期、证据与容量

::: method 回忆 12 · `pthread_*` 的返回值与线程生命周期
`pthread_create`/`join`/`detach` 失败时看什么？joinable 与 detached 的资源归属差在哪？默认栈多大？本书 VM 上 200 个线程的 `VmSize` 是多少？
::: sol 答案
`pthread_*` 不设置 `errno`，直接返回错误码（成功 0）；`perror` 读的是上一个系统调用的 `errno`，常打印 `Success`。`pthread_join` 对已 detach 的线程返回 `EINVAL`（本书 VM 实测 22，且 `errno` 仍为 0）；`EDEADLK` 是自己 join 自己。joinable 线程退出后栈、TLS 与返回值仍保留，直到 `join`；detach 后退出即回收，不能再 join。本书 VM 实测默认栈 8388608 字节（8 MiB 虚拟），`PTHREAD_STACK_MIN` 为 131072（128 KiB，aarch64）；200 个默认栈线程让 `VmSize` 从 2268 kB 涨到 1653468 kB，换成 256 KiB 栈后是 99292 kB。join 后 `Threads` 回 1，但 `VmSize` 仍为 35292 kB（glibc 缓存，不立刻归还）。
:::
:::

::: method 回忆 13 · 死锁的四个条件与取证链
死锁需要哪四个条件？工程上最有效的打破手段是什么？怎样证明一个进程是死锁而不是算得慢？本书 VM 上 `gdb -p` 能用吗？
::: sol 答案
四个条件：互斥、持有并等待、不可剥夺、循环等待；打破任一条即可。工程上最有效的是**全局锁序**：给锁编号，永远按升序获取，AB/BA 就不会成环；其余手段是一次性 `trylock` 全部、超时回滚、锁层级、消息传递、无锁结构。取证：`timeout 3 ./deadlock; echo $?` 返回 124 说明卡住；`ps -L -o pid,tid,stat,wchan,comm -p <pid>` 看到线程 `S` 且 `wchan` 为 `futex_do_wait`；再画等待图找环。本书 VM 的 `ptrace_scope` 为 1，`gdb -p` 报 `Could not attach to process`（提示检查 `ptrace_scope`），所以取证用 `ps` 与 TSan/helgrind 的锁序报告，不把 `gdb bt` 当必得。
:::
:::

::: method 回忆 14 · TSan 与 helgrind 各自能证明什么
TSan 怎样编译、报告里一定有什么？TSan 在本机直接跑会遇到什么？它与 ASan 能同时开吗？helgrind 与它差在哪？
::: sol 答案
TSan：`cc -std=c17 -g -O1 -fsanitize=thread -pthread race.c -o race_tsan`，报告一定给出**两次访问**（读/写、大小、地址）与各自的调用栈，并用 `Location is global 'counter'` 指认变量；`halt_on_error=1` 让第一次就停。本书 VM 直接运行报 `FATAL: ThreadSanitizer: unexpected memory mapping`，要 `setarch -R ./race_tsan` 关 ASLR；抓到竞争时退出码 66。TSan 与 ASan 不能同时开：GCC 13.3 报 `'-fsanitize=thread' is incompatible with '-fsanitize=address'`，要分开构建。helgrind 不用重编译：`valgrind --tool=helgrind ./race`，关键行是 `Possible data race`、`Locks held: none`，锁序反转报 `lock order ... violated`；它更慢，但能跑未插桩的二进制。两者都只覆盖执行到的路径。
:::
:::

::: method 回忆 15 · 线程池开多大、队列满了怎么办
Little 定律给出什么？I/O 密集型为什么要乘 `(1 + W_io/W_cpu)`？容器里 `sysconf(_SC_NPROCESSORS_ONLN)` 为什么不可信？队列满的五种策略各适合谁？
::: sol 答案
Little 定律：稳态并发数 `L = λW`。网关每秒 2 万请求、每个在池内平均 5 ms，则 `L = 20000 × 0.005 = 100`。I/O 密集型任务大部分时间在等，线程数可按 `N ≈ 核数 × (1 + W_io/W_cpu)` 估：4 核、I/O 等待是计算的 9 倍时约 40 个。容器里 `sysconf(_SC_NPROCESSORS_ONLN)` 返回宿主机核数，不是 CPU 配额；要读 cgroup v2 的 `/sys/fs/cgroup/cpu.max`（如 `200000 100000` 表示 2 核）。线程数还算进 `pids.max`，超了 `pthread_create` 返回 `EAGAIN`。队列满：阻塞提交（上游能等）、立即拒绝（面向用户，快速 503）、调用者执行（自然限流）、丢弃最旧（保新弃旧）、无界队列（最简但会 OOM）。无论哪种都要把队列长度与等待时间分位暴露成指标。
:::
:::

::: method 回忆 16 · 伪共享与 `taskset`
伪共享的机制是什么？为什么 `_Alignas(64)` 能修？本书 VM 上有多大差别？`perf c2c` 能用吗？
::: sol 答案
两个线程分别写同一缓存行里的不同变量，缓存一致性协议仍要把整行在核间搬来搬去（cache line ping-pong），每次写都让对方失效。`_Alignas(64)` 把热点变量分到不同缓存行，流量消失；x86-64 与多数 ARM64 的缓存行是 64 B。本书 VM 实测（`volatile` 计数版、2000 万次）：同一行 21.6–23.1 ms，对齐后 6.5–15.0 ms，方向稳定但倍数波动大。`perf c2c` 在本书 VM 不可用（`perf_event_paranoid=4`，报 `no PMU supports the memory events`），所以用「对齐/不对齐」的计时对照与 `ps -L` 的 `PSR` 列判断，而不是引用 HITM 数字。
:::
:::

::: method 回忆 17 · 十万连接与 100 ms 磁盘 I/O 各选什么
10 万条低流量长连接，选线程池还是事件循环？如果每个请求要做 100 ms 磁盘 I/O 呢？真实系统怎样混用？
::: sol 答案
10 万条低流量长连接选事件循环：线程池为每条连接常驻一个线程会耗尽内存与调度资源（每个线程 8 MiB 虚拟栈 + 内核栈）。如果每个请求有 100 ms 磁盘 I/O，纯事件循环会被阻塞调用拖住，应把阻塞操作交给线程池或异步 I/O，事件循环只负责网络事件与状态机。真实的高性能服务器常把两者结合：`epoll` 线程收发包与解析协议，业务提交给线程池，结果再写回 event loop；难点在跨线程传递 fd/缓冲区的所有权与生命周期。判断依据是三条：连接数、每个请求的阻塞比例、共享状态多少。
:::
:::
