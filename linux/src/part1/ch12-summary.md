# 1.12 章末总结

## 五段浓缩

| 单元 | 小节 | 核心问题 | 关键结论 | 最容易错的地方 |
|:--|:--|:--|:--|:--|
| **一、模型与竞争** | 1.12.1–1.12.2 | 三种并发模型的成本各在哪？共享地址空间为什么让 `counter++` 丢更新？ | 进程模型隔离好但 `fork` 贵；线程模型共享地址空间，创建只分配栈（本书 VM 实测默认 8 MiB 虚拟栈，按需缺页）；事件模型用一个线程管大量 fd，代价是不能阻塞。`counter++` 是 load → add → store 三步，两个线程读到同一个旧值就会丢一次更新；C11 把无同步的并发读写定义为**数据竞争**，行为未定义，编译器可以假设它不发生。修法三层：互斥锁、原子操作、每线程局部累加后合并。`volatile` 只禁止编译器缓存，不保证原子，也不建立 happens-before。 | 把「并发」当「并行」；以为 `volatile` 能修竞争；以为「测出来对」就没有竞争——本书 VM 实测同一份 `race_lab.c`：`-O0` 三次是 2042685/2222928/2126285（期望 4000000），`-O2` 三次都是 4000000（循环被折叠），`-DUSE_VOLATILE -O2` 三次只有约 107–109 万。 |
| **二、同步原语** | 1.12.3–1.12.4 | 锁保护的是什么？条件变量为什么要 `while`？信号量怎样摆顺序才不死锁？ | 锁保护的是**不变量**，不是代码行：先写下哪些字段必须一起更新，再决定临界区。`pthread_cond_wait` 做三件事——释放 mutex、睡眠、醒来后重新获取；它等的是「有人通知」，不是「条件为真」，所以必须 `while` 重查，且改条件要在持锁时做，否则通知可能落在 `wait` 之前。信号量是有计数的资源：`sem_wait` 申请、`sem_post` 归还；有界缓冲区用 `empty=N`、`full=0`、`mutex=1`，生产者必须先等 `empty` 再拿锁，消费者先等 `full` 再拿锁。 | 条件变量用 `if`；先拿锁再等资源信号量（缓冲区满时生产者握锁睡眠，消费者拿不到锁）；以为条件变量会「记住」通知；以为 `pthread_mutex` 默认公平。 |
| **三、任务与 fd** | 1.12.5–1.12.7 | 队列满了怎么办？一个线程怎样管上万条连接？ | 线程池的三个同步点是 `mutex`、`not_empty`、`not_full`；有界队列满时 `submit` 阻塞形成背压，无界队列会把内存吃光。`shutdown` 要广播而不是 `signal`，worker 的循环条件是 `count == 0 && !shutdown`，退出条件是 `count == 0 && shutdown`，写成 `if (shutdown) break` 会丢掉剩余任务。事件循环把「等哪条连接」交给 `epoll` 的就绪链表；LT 漏读还会再报，ET 必须配非阻塞 fd 并一次读到 `EAGAIN`，写侧要自己缓冲并等 `EPOLLOUT`。 | 在持锁时执行任务；关闭时只 `signal` 一个 worker；ET 只读一次；在事件循环里做磁盘 I/O 或 `getaddrinfo`；把 `epoll` 当「一定比线程快」。 |
| **四、生命周期与内存序** | 1.12.8–1.12.11.1 | 线程资源谁回收？`release/acquire` 发布了什么？锁怎样做到无竞争不进内核？ | `pthread_*` 不设 `errno`，直接返回错误码；`perror` 打印的常常是 `Success`。joinable 线程退出后栈与返回值仍保留，必须 `join`；detach 后退出即回收，再 join 返回 `EINVAL`（本书 VM 实测 22，且 `errno` 仍为 0）。内存序只回答「哪些重排被禁止」：`relaxed` 只保证该对象原子，`release` 存 + `acquire` 读构成 synchronizes-with，`seq_cst` 才给全局全序。glibc 的 mutex 是三态状态字 + futex：无竞争时只有用户态原子操作，出现第二个等待者才进内核。读多写少有三条路线：读写锁（读者共享，写者可能饥饿）、seqlock（读者重读）、RCU（读者几乎零开销，写者等宽限期）。 | 用 `perror` 查 `pthread_*`；忘记 join 造成线程泄漏；把 `pthread_t` 当长期 ID；用 `relaxed` 发布数据；以为 RCU 读侧免费就等于写侧也免费；在 RCU 读临界区里睡眠。 |
| **五、证据与收口** | 1.12.12–1.12.17 | 卡死怎样取证？池开多大、怎样关？工具能证明什么？ | 死锁要同时满足互斥、持有并等待、不可剥夺、循环等待，打破任一条即可，工程上最有效的是全局锁序。取证三步：`timeout` 确认卡住（退出码 124）、`ps -L -o stat,wchan` 看线程停在 `futex_do_wait`、再看锁序（TSan 的 `second_deadlock_stack` 或 helgrind 的 lock order）。池容量从 Little 定律 `L = λW` 起步，再用压测找拐点；容器里要读 `cpu.max` 而不是信 `sysconf` 的核数，线程数还算进 `pids.max`。TSan 报「两次访问 + 各自调用栈」，helgrind 不用重编译但更慢；两者都只覆盖执行到的路径。 | 把「算得慢」当死锁；只调大队列不看消费速度；用无界队列；关闭时丢掉在途任务；把 TSan 没报当「没有竞争」；把 `perf c2c` 当必得。 |

## 一条主线

这一章从「一块共享内存」走到「一条可复现的证据链」：**共享状态先要回答三个问题——谁先谁后、读到的值是否完整、失败怎么回滚（1.12.2）；互斥锁、条件变量、信号量分别用「独占」「通知」「计数」回答它们（1.12.3–1.12.4）。** 任务多了，线程池用有界队列把过载变成背压（1.12.5）；fd 多了，事件循环用就绪链表把等待集中起来（1.12.7）。1.12.8–1.12.11 补的是「用对」：生命周期决定资源何时回收，内存序决定一个线程的写何时对另一个线程可见，futex 决定锁的代价落在用户态还是内核，读写锁/seqlock/RCU 决定读多写少时让谁付代价。1.12.12–1.12.17 把这一切变成可取证、可容量规划、可关闭的工程：死锁有等待图，池有 Little 定律，关闭有 drain 语义，工具有 TSan/helgrind/`ps`/`strace`。

如果只记一句话：**看到并发异常，先问谁共享这块状态，再问用什么建立了顺序，最后问证据在哪。** 这三问覆盖本章大多数故障：计数少了是共享且没排序（1.12.2），卡死是锁序成环（1.12.12），通知丢了是条件变量用错（1.12.3），线程泄漏是生命周期没闭合（1.12.8），加核更慢是争用或伪共享（1.12.15）。

## 症状 → 机制 → 命令

| 症状 | 机制 | 先跑什么 |
|:--|:--|:--|
| 4 个线程各加 100 万，结果不到 400 万 | `counter++` 的读—改—写被交错，更新丢失；这是数据竞争，UB | `cc -O1 -g -fsanitize=thread -pthread race_lab.c -o race_tsan`；`setarch -R ./race_tsan`（本书 VM 直接跑会报 `unexpected memory mapping`），报告后退出码 66 |
| 加了 `volatile` 仍然少，甚至更少 | `volatile` 不原子、不建立跨线程顺序，只禁止缓存 | 同上；对照 `-DUSE_ATOMIC` 版本应恒为 4000000（VM 实测） |
| `-O2` 下竞争程序「算对了」 | 编译器把循环折叠成一次加法；UB 下「对」不是保证 | 用 `-O0` 与 `-O2` 各跑三次对照；结论写「UB」，不要写「修好了」 |
| 条件变量醒来后状态不对 | 用 `if` 只查一次，虚假唤醒或条件又被改回假 | 改 `while (!pred) pthread_cond_wait(...)`；在持锁时改谓词再 `signal` |
| 通知发了，等待者还在睡 | 改条件时没持锁，`signal` 落在 `wait` 之前，通知丢失 | 把「改条件 + signal」放进同一临界区；用 `strace -f -e trace=futex` 看等待/唤醒次数 |
| 进程卡死、CPU 接近 0 | 死锁：两个线程各持一把锁再等对方 | `timeout 3 ./deadlock; echo $?` 得 124；`ps -L -o pid,tid,stat,wchan,comm -p <pid>` 看到 `futex_do_wait`；`gdb -p` 在本书 VM 上 attach 被拒（报 `Could not attach to process`，提示检查 `ptrace_scope`，本机值为 1），改用 TSan/helgrind 的锁序报告 |
| 线程数或内存持续涨 | joinable 线程没 join，栈与返回值不回收 | `/proc/<pid>/status` 的 `Threads` 与 `VmSize`；VM 实测 200 个默认栈线程让 `VmSize` 从 2268 kB 涨到 1653468 kB，join 后 `Threads` 回 1、`VmSize` 仍为 35292 kB（glibc 缓存） |
| `pthread_*` 报错却打印 `Success` | `pthread_*` 返回错误码，不设 `errno` | 用 `strerror(rc)`；实测对已 detach 的线程 `pthread_join` 返回 22，`errno` 仍为 0 |
| 容器里 `pthread_create` 返回 `EAGAIN` | 线程数触到 `RLIMIT_NPROC` 或 cgroup `pids.max` | `ulimit -u`；`cat /sys/fs/cgroup/pids.max`、`pids.current`；`pids.events` 的 `max` 计数 |
| 队列在涨、CPU 不高 | 消费速度跟不上；worker 阻塞在 I/O 或锁上，背压没有传到入口 | 采样队列长度与等待时间分位；`strace -f -c -e trace=futex ./server` 看 futex 次数；检查是否持锁做 I/O |
| 加核反而更慢 | 锁争用、缓存行 ping-pong、线程迁移 | `taskset -c 0 ./bench_lab` 与 `taskset -c 0-3 ./bench_lab` 对照；VM 实测全局锁版本 1 核 24.7–26.8 ms，4 核 80.3–98.6 ms |
| 两个变量各自写却互相拖慢 | 伪共享：同一缓存行的不同变量被多核反复失效 | 用 `_Alignas(64)` 分开；VM 实测同一行 21.6–23.1 ms、对齐后 6.5–15.0 ms（`volatile` 计数版，波动大）；`perf c2c` 在本书 VM 不可用 |
| 事件循环里一条慢请求拖住全部 | 循环里做了阻塞调用（磁盘、DNS、大文件） | `strace -p <pid> -e trace=read,write,epoll_wait`；把阻塞操作交给线程池或异步 I/O |
| 1 万条空闲连接把内存吃光 | 每连接一线程，每个线程 8 MiB 虚拟栈 + 内核栈 | `ps -L` 数线程；`/proc/<pid>/status` 看 `VmSize`；改用 `epoll` 或把栈降到 256 KiB–1 MiB |

## 能否讲出这八句话

1. **并发是重叠，并行是同时。** 并发省的是等待，并行省的是时间；并行加速比受 Amdahl 限制，「4 核、90% 可并行」的上限是 `1/(0.1+0.9/4) ≈ 3.08`，不是 4。
2. **`counter++` 不是一步。** 它是 load → add → store，两个线程读到同一个旧值就丢一次更新；C11 把无同步的并发读写定义为 UB，所以「测试通过」不构成正确性。
3. **`volatile` 不是同步。** 它只禁止编译器缓存；本书 VM 实测 `-O2` 下 `volatile` 版本三次只有约 107–109 万（期望 400 万），原子版本三次都是 400 万。
4. **条件变量没有记忆，信号量有计数。** `pthread_cond_wait` 必须配 `while`，改条件必须持锁；`sem_post` 在没人等待时也会加一，所以「先等资源、再拿锁」的顺序不能反。
5. **线程池的难点不在创建线程，在过载与关闭。** 有界队列 + 阻塞提交是背压；关闭要广播、要 drain、要让卡在 `submit` 的调用者返回错误；worker 的循环条件写反就会丢任务。
6. **`pthread_*` 用返回值，不用 `errno`。** joinable 线程不 join 就是泄漏；detach 后不能再 join；默认栈是 8 MiB 虚拟内存，不是 8 MiB 物理内存；200 个线程在本书 VM 上让 `VmSize` 涨到约 1.65 GB。
7. **`release` 存 + `acquire` 读才是发布。** `relaxed` 只保证该对象原子，`seq_cst` 才给全局全序；把发布改成 `relaxed`，`assert(data == 42)` 可能失败，且这是标准允许的。
8. **锁的快路径不进内核。** glibc mutex 用三态状态字 + futex，无竞争时只有两次用户态原子操作；`perf c2c` 在本书 VM 因 `perf_event_paranoid=4` 不可用，伪共享要用 `taskset` + 计时或 `_Alignas(64)` 对照来证。

## 学完之后

1. **[闭卷回忆卡](ch12-recall.md)**：17 张卡分三组——A 组考并发/并行、共享与私有、数据竞争、`volatile`、锁与条件变量；B 组考信号量、线程池、读写锁/seqlock/RCU、内存序、futex；C 组考生命周期、死锁取证、TSan/helgrind、容量与容器限额。合上正文，把「三步」「三个信号量」「三态状态字」从空白纸上叫出来。
2. **[习题集](ch12-exercises.md)**：A 组 6 题考「会读会判」，B 组 6 题给现象让你判竞争、死锁、泄漏与限额，C 组 4 题在 Ubuntu 24.04 上免 `sudo` 复现。先做 A、B，再跑 C；每题都有判据。
3. **[学习目标自检表](ch12-checklist.md)**：这张表接管 [1.12.17 本章小结](ch12.md#sec-1.12.17)，把 7 条出口展开成 18 条，卡住时按右列回到小节与习题。
4. **[勘误与版本注记](ch12-errata.md)**：本章最容易搬家的是默认栈大小、`PTHREAD_STACK_MIN`、TSan 的 ASLR 问题与 ASan 冲突、`pthread_*` 的 `errno`、aarch64 与 x86-64 的代码生成，以及 `perf` 的可用性。引用任何读数前先读未实测项。
5. **下一站**：[2.12 线程](../part2/ch12.md) 会把本章的 `pthread` 调用还原成 `clone`、NPTL 与 futex 的内核路径；第 5 篇的 [5.3.4 cpu 配额](../part5/ch03.md#sec-5.3.4)、[5.3.6 pids 控制器](../part5/ch03.md#sec-5.3.6) 会解释容器里「核数」和「线程数」为什么与宿主机不同。
