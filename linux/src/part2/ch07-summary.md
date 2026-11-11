# 2.7 章末总结

## 四个单元，一条因果链

**第一单元，创建与继承（2.7.1–2.7.2）。** `fork()` 调用一次返回两次：父进程拿到子进程 PID（>0）、子进程拿到 0、失败返回 -1（`EAGAIN` 比 `ENOMEM` 更常见——`RLIMIT_NPROC`、cgroup `pids.max`、`kernel.pid_max` 都会触发）。子进程是父进程的**逻辑副本**，内核在 `copy_process()` 里逐项决定：地址空间按 COW 共享物理页、fd 表被复制但表项指向同一个打开文件描述（所以**文件偏移共享**）、信号处置继承但未决信号清空、定时器不继承、`fcntl` 记录锁不继承而 `flock` 继承、`cwd`/`umask`/凭证/资源限制都复制。COW 的三步是「复制页表→私有可写 PTE 标只读→任一方写入触发缺页才复制」，断裂点以页为单位（改一个字节也隔离整页 4 KiB）；`MAP_SHARED` 不触发 COW、写入立刻互相可见。关键反直觉：**RSS 不翻倍也可能发生了大量 COW**——子进程写后把「指向共享旧页」换成「指向私有新页」，驻留页数量没变但物理页翻倍，要用 PSS 或 `smaps` 的 `Private_Dirty`/`Shared_Dirty` 才看得清。

**第二单元，变体与危险区（2.7.3–2.7.4）。** 多线程程序里 `fork()` 只复制**调用线程**，其他线程消失，但它们持有的锁（glibc malloc 的 arena 锁、stdio 的 `FILE` 锁）以「被占住」的状态定格在子进程内存里——子进程一拿就永久阻塞。所以 POSIX 规定 fork 后到 exec 前只能调 **async-signal-safe** 函数；`pthread_atfork` 只能救你自己注册的锁，救不了 libc 内部的锁。三条变体：`vfork` 借父进程地址空间、父进程挂起到子进程 exec/`_exit`，子进程改变量/`return`/`exit` 都会破坏父进程，唯一正当形状是「立刻 exec、失败 `_exit`」；`clone` 用 flags 决定共享什么，本机 `strace` 实测 `pthread_create` 发的是 `clone3(CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|…)` 且 `exit_signal=0`——线程与进程同源，差别就在这一组 flags；`posix_spawn` 把 fork+exec 封装好，**成功返回 0、失败返回错误码**（不是 -1/errno）。

**第三单元，终止与回收（2.7.5–2.7.6）。** `exit()` 是库函数走四步：逆序跑 `atexit`/`on_exit`→flush 并关闭 stdio→删 `tmpfile`→调 `_exit`；`_exit()` 是系统调用直接进内核，不 flush、不跑 atexit。退出码只有低 8 位有效（`exit(256)` 父进程看到 0），「128+信号号」是 shell 约定不是内核口径。fork 前 stdio 缓冲区非空时，子进程 `exit()` 会把复制来的缓冲区再 flush 一遍——重复输出的根因，修复只有「fork 前 `fflush(NULL)`」或「子进程一律 `_exit`」。进程死后先变**僵尸**（`ps` 状态 Z），占 PID 与 `task_struct`、不占内存页，`kill -9` 杀不死（已经死了），只能父进程 `wait` 或父进程退出后过继给 init/subreaper 回收。`SIGCHLD` 是通知不是队列：标准信号不排队、会合并，处理器里必须 `while (waitpid(-1, &st, WNOHANG) > 0)` 收干净；设 `SIG_IGN`/`SA_NOCLDWAIT` 可免僵尸但**再也拿不到退出状态**（`waitpid` 返回 `ECHILD`）。

**第四单元，内核与 wait 全景（2.7.7–2.7.8）。** 用户态一次 `fork` 落到 `kernel_clone()`→`copy_process()`：后者返回 `task_struct*` 不是 PID，PID 复制完才取；新进程在 `wake_up_new_task()` 前不可运行；任一步失败走与复制顺序相反的 `bad_fork_cleanup_*` 回滚链。`wait` 家族五个接口：`waitpid` 的 pid 有四种语义（>0 指定、-1 任意、0 同组、<-1 指定组），`waitid` 把「等谁」（`P_ALL`/`P_PID`/`P_PGID`/`P_PIDFD`）与「等什么事件」（`WEXITED`/`WSTOPPED`/`WCONTINUED`）拆开，成功返回 0、信息在 `siginfo_t`；`WNOWAIT` 只报告不回收（子进程仍是 Z，可再等），`P_PIDFD` 绑定进程对象防 PID 复用竞态。`si_status` 口径由 `si_code` 决定：`CLD_EXITED` 时是退出码、`CLD_KILLED`/`CLD_STOPPED`/`CLD_CONTINUED` 时是信号号。

一句话主线：**创建与销毁都是协议——继承规则决定子进程拿到什么，`SIGCHLD` 决定父进程何时知道，`wait` 决定资源何时真正释放；漏掉任何一环，症状都不是报错，而是僵尸堆积、fd 泄漏、内存慢慢翻倍。**

## 三条判据

| 判据 | 具体要求（做不到就回右列） | 主要落点 |
|:--|:--|:--|
| **能解释** | 画出 `fork` 后「复制/共享/清零」三栏；说出 COW 断裂点与「RSS 不翻倍也复制了页」；说出多线程 fork 死锁窗口、僵尸为什么 `kill -9` 无效、`SIGCHLD` 为什么会合并 | [2.7.1](ch07.md#sec-2.7.1)、[2.7.2](ch07.md#sec-2.7.2)、[2.7.3](ch07.md#sec-2.7.3)、[2.7.6](ch07.md#sec-2.7.6) |
| **能操作** | 写出 `waitpid` 四事件循环与 `SIGCHLD` 的 `while WNOHANG` 回收；用 `waitid`+`WNOWAIT` 先看后收；fork 前 `fflush(NULL)` 或子进程 `_exit` 消除重复输出 | [2.7.5](ch07.md#sec-2.7.5)、[2.7.6](ch07.md#sec-2.7.6)、[2.7.8](ch07.md#sec-2.7.8) |
| **能判断** | 给「僵尸堆积/内存翻倍/fork 后卡死/重复输出」现象能定位到机制；引用调用号、`CLD_*` 常量、`posix_spawn` 实现前先说清架构与 glibc 版本 | [2.7.7](ch07.md#sec-2.7.7)、[勘误页](ch07-errata.md) |

## 看到问题先选工具

| 现象 | 先选什么 | 看到什么算命中 |
|:--|:--|:--|
| 僵尸堆积、`fork` 开始 `EAGAIN` | `ps -eo stat,ppid,pid,comm \| awk '$1 ~ /^Z/'` 找僵尸与其父；父进程补 `waitpid(-1, &st, WNOHANG)` 循环 | STAT=Z 的行指向同一个不回收的父进程 |
| fork 后内存翻倍 | 读 `/proc/<pid>/smaps` 的 `Private_Dirty`/`Shared_Dirty`，对照 COW 断裂 | fork 后 `Shared_Dirty` 涨、子进程写后双方 `Private_Dirty` 各涨一份 |
| 多线程服务 fork 后卡死 | 子进程只调 async-signal-safe；`gdb` 看栈是否停在 `__lll_lock_wait`/futex | 卡在 malloc arena 锁，持有者线程已不存在 |
| fd 泄漏、下游程序输入卡住 | `ls -l /proc/self/fd` 数继承的 fd；子进程 exec 前 `close_range` 或逐个 `close`、设 `O_CLOEXEC` | 子进程持有一堆本不该继承的 fd |
| 子进程重复输出 | fork 前 `fflush(NULL)`，或子进程改 `_exit` | 重定向到文件时 `buffered-before-fork` 只出现一次 |

## 只记一件事

**`fork` 复制的是逻辑副本，`wait` 释放的才是真实资源。** 这两句共用一个根：创建与销毁都是协议——COW 让「复制」延迟到写入那一刻，僵尸让「销毁」延迟到父进程确认那一刻。把 `fork` 当成「立刻复制全部内存」、把 `exit` 当成「立刻消失」，本章其余结论都会跟着错位。

## 六页怎么用

1. **[章总览](ch07-overview.md)**：先看四个单元一览与「环境口径」，确认 aarch64 上 `fork` 走 `clone` 这条版本事实。
2. **[章末总结](ch07-summary.md)**（这一页）：合上正文读一遍，把四个单元当目录自查。
3. **[闭卷回忆卡](ch07-recall.md)**：只看问题作答，三种结果（对/含糊/错），下一轮只做含糊与错的。
4. **[习题集](ch07-exercises.md)**：概念、诊断、动手三组；C 组六题都在这台 aarch64 VM 上真跑过，每题第一个动作是「先猜再跑」。
5. **[学习目标自检表](ch07-checklist.md)**：接管 [2.7.9 本章出口检查](ch07.md#sec-2.7.9)，按概念/动手/实验/口径四组逐条当场做。
6. **[勘误与版本注记](ch07-errata.md)**：调用号、`CLD_*` 常量、`posix_spawn` 实现、`PR_SET_PDEATHSIG` 都随架构与版本变，第 2 节「复跑校正」列了这台机器上实测与正文不符之处，抄数字前先看这一页。

## 下一站

[2.8 程序执行与子进程监控](ch08.md) 接着讲 `fork` 的另一半：`execve` 怎么把当前进程替换成新程序、哪些属性保留、`system()` 为什么是陷阱。往回查：[2.2 文件 I/O](ch02.md) 的打开文件描述是「偏移共享」的前置；[2.3 高级文件 I/O](ch03.md) 的记录锁与 `flock` 在继承清单里语义不同。

自检入口：先做[闭卷回忆卡](ch07-recall.md)，再用[学习目标自检表](ch07-checklist.md)逐条打勾；手上读数与正文对不上时，回[勘误页](ch07-errata.md)确认它是不是本来就不属于这台机器。