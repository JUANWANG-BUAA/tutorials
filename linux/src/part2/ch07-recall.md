# 2.7 闭卷回忆卡

这一页是检索练习，不是摘要。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。21 张卡分三组：**A 组考创建与继承（2.7.1–2.7.4）**，**B 组考终止与回收（2.7.5–2.7.6）**，**C 组考内核路径与 wait 全景（2.7.7–2.7.8）**。建议学完当天、隔天、第 3 天、第 7 天各做一次，只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 创建与继承

::: method 回忆 1 · `fork` 的返回值三分支
`fork()` 在父进程、子进程、失败时各返回什么？失败时哪个 errno 更常见、由哪些上限触发？fork 后谁先运行有保证吗？
::: sol 答案
父进程返回子进程 PID（>0），子进程返回 0，失败返回 -1。`EAGAIN` 比 `ENOMEM` 更常见：`RLIMIT_NPROC`（按**真实 UID** 统计该用户的进程/线程总数）、cgroup v2 `pids.max`、`kernel.threads-max`、`kernel.pid_max` 耗尽都会触发；`ENOMEM` 是内核分配不出 `task_struct`/内核栈/页表。fork 后父子谁先运行**由调度器决定，没有任何保证**——依赖特定顺序就是竞争条件（Linux 2.6.32 起默认父先跑，但 `sched_child_runs_first` 可改，别依赖）。要确定顺序必须用信号量、文件锁、管道或信号同步。
:::
:::

::: method 回忆 2 · 继承清单：复制、共享、清零三类
`fork` 后地址空间、fd 表、信号处置、未决信号、信号掩码、定时器、进程组、凭证、`cwd`/`umask` 各属于哪一类？`MAP_SHARED` 呢？
::: sol 答案
**COW 共享物理页**：地址空间（页表复制、私有可写 PTE 标只读）。**复制但指向同一对象**：fd 表（表项指向同一个打开文件描述，偏移与文件状态标志共享）。**继承（复制）**：信号处置（`SIG_IGN`/处理器地址）、信号掩码、进程组与会话、资源限制、凭证（UID/GID 四件套与 capability）、`umask`/`cwd`/`chroot`、环境列表。**清零/不继承**：未决信号（子进程从空信号集开始）、定时器（`alarm`/`setitimer` 清零）、`fcntl` 记录锁（子进程不持有）。**特例**：`flock` 锁继承（共享同一打开文件描述）；`MAP_SHARED` 映射共享同一物理页、写入互相可见、**不触发 COW**。这张表解释三类高频 bug：子进程写到父进程的共享映射、`alarm` 超时在 fork 后失效、子进程继承一堆没关的 fd。
:::
:::

::: method 回忆 3 · fd 表复制 vs 打开文件描述共享
为什么说「父子 fd 各自独立」是错的？父进程读 100 字节后子进程 `read` 从哪开始？`dup` 改变结论吗？`O_APPEND` 呢？
::: sol 答案
fd 表被复制（父子各有自己的描述符数组），但**对应表项指向同一个打开文件描述（`struct file`）**——文件偏移与文件状态标志（`O_APPEND` 等）存在 `struct file` 里，所以共享。父进程读 100 字节，子进程的 `read` 从 101 开始；子进程 `lseek` 父进程也看得到（本机实测：子进程 lseek 到 500，父进程读出 offset=500）。`dup` 不改变结论——`dup` 本来就指向同一 `struct file`。`O_APPEND` 下每次写都定位到当前末尾，父子同写一文件不会互相覆盖（但输出会交错，要不交错需 `wait` 同步）。不想共享就 fork 后各自立即 `close` 不用的 fd，或 exec 前靠 `O_CLOEXEC`/`close_range` 清掉。
:::
:::

::: method 回忆 4 · COW 三步与断裂点
写时复制（COW）的三步是什么？断裂以什么为单位？`MAP_PRIVATE` 与 `MAP_SHARED` 在 fork 后各是什么行为？
::: sol 答案
三步：① 内核为子进程复制**页表**（不是数据页），把私有可写 PTE 改成只读；② 每个物理页引用计数加一；③ 任一方写入只读页触发缺页，内核判断是 COW 缺页，分配新页、复制内容、改 PTE 可写、原页引用计数减一。断裂以**页**为单位（本机页 4096 字节）：改一个字节也要隔离整页；若页已独占（引用计数 1）内核可直接恢复可写、无须复制。`MAP_PRIVATE`（普通堆、栈、`.data`）双方写入互不可见、各自触发 COW；`MAP_SHARED`（含 `mmap(MAP_SHARED|MAP_ANONYMOUS)` 与共享文件映射）**不触发 COW**、双方看同一物理页、写入立刻互相可见、同步要自己做。通过 `read`/`write` 访问的文件内容不属于地址空间，共享与否由 fd 决定，与 COW 无关。
:::
:::

::: method 回忆 5 · RSS、PSS 与实际物理页（4 页手算）
4 个已驻留私有匿名页，fork 后子进程写 2 页、父不写：父子 RSS、PSS、合计物理页各是多少？为什么 RSS 之和会重复计算？
::: sol 答案
fork 后未写：父 RSS=4、子 RSS=4、合计物理页=4（共享）、父 PSS=2、子 PSS=2。子写 2 页后：父 RSS=4、子 RSS=4、合计物理页=6（父独占 2 + 子独占 2 + 仍共享 2）、父 PSS=3、子 PSS=3（`2 + 2/2`）。子退出后：父 RSS=4、合计物理页=4、父 PSS=4。RSS 把每个共享页在每个映射进程里都算一遍，所以 RSS 之和重复计算共享页；PSS 按映射进程数分摊，更适合核对实际占用。关键反直觉：**子进程写后 RSS 没翻倍（仍 4），但物理页从 4 涨到 6**——COW 确实发生了，只是「替换映射」而非「保留两份」。真实实验要在父子都存活时读各自 `smaps`，不能等子退出后才观察共享阶段。
:::
:::

::: method 回忆 6 · 多线程 fork 为什么只允许 async-signal-safe
多线程程序里 `fork()` 复制了几个线程？子进程为什么调 `malloc`/`printf` 可能永久阻塞？POSIX 的限制是什么？
::: sol 答案
只复制**调用线程**，其他线程在子进程中不存在（子进程 `gettid()` 与父进程调用者不同）。但其他线程持有的锁、正在写的缓冲区以「被复制的一份」留在子进程内存里：线程 A 拿着 glibc malloc 的 arena 锁时线程 B fork，子进程复制了「锁已被持有」的状态，子进程一调 `malloc`（哪怕只是 `printf` 内部）就发现锁被占、永久阻塞——持有者线程已经不存在了。POSIX 规定：多线程程序中 fork 后到 exec 前，子进程只能调 **async-signal-safe** 函数（`execve`、`_exit`、`write` 等在列表里；`malloc`、`printf`、`pthread_mutex_lock`、`syslog` 不在）。窗口很窄但高并发下稳定出现，`gdb` 附加只见子进程卡在 `__lll_lock_wait`。
:::
:::

::: method 回忆 7 · `pthread_atfork` 三钩子与 `_Fork`
`pthread_atfork(prepare, parent, child)` 三个钩子各在何时、按什么顺序执行？它能解决所有死锁吗？`_Fork()` 呢？
::: sol 答案
`prepare` 在 fork **之前**于父进程按注册的**逆序**执行（典型动作：把自己知道的锁全拿下）；`parent` 在 fork 后于父进程按**正序**执行、`child` 在 fork 后于子进程按**正序**执行（典型动作：解锁）。它只能解决你**自己注册**的锁；glibc malloc 的 arena 锁、stdio 的 `FILE` 锁、NSS/DNS 解析器内部的锁不归你管——所以它是缓解手段不是许可证。`_Fork()`（glibc 2.34+）跳过 atfork 处理器、不跑 fork 兼容逻辑，语义更接近裸系统调用，但**锁状态依然被复制**，限制没消失。工程结论：多线程程序不要 fork 出「继续跑业务逻辑」的子进程；要并行用线程，要执行外部程序用 `posix_spawn` 或 fork 后立刻 exec。
:::
:::

::: method 回忆 8 · `vfork` 的语义与唯一正确形状
`vfork` 与 `fork` 的两点区别是什么？子进程哪些动作会破坏父进程？唯一正当用途与正确写法是什么？
::: sol 答案
两点区别：① 子进程**共享**父进程地址空间（不复制页表/数据页），直到成功 exec 或 `_exit`；② 父进程被**挂起**，直到子进程 exec 或 `_exit`（内核里阻塞在 `wait_for_vfork_done()` 的 completion 上）。因为共享同一套页表和栈：子进程修改任何局部变量父进程恢复后看得到、子进程从函数 `return` 会返回到父进程调用栈（行为未定义）、子进程调 `exit()` 会 flush 父进程 stdio 并跑父进程 atexit。SUSv3 规定修改数据（除存返回值的 `pid_t`）、从调用函数返回、在 exec/`_exit` 前调任何其他函数都是未定义。唯一正当用途是「立刻 exec」，正确形状只有 `pid=vfork(); if(pid==0){ execve(...); _exit(127); }`。SUSv4 已把 vfork 删除，现代代码用 `posix_spawn` 替代。
:::
:::

::: method 回忆 9 · `clone` flags 与 `posix_spawn` 返回值
`pthread_create` 在 Linux 上是哪组 clone flags？「只有 `CLONE_VM`」是不是线程？`posix_spawn` 成功/失败各返回什么？本机 glibc 2.39 用什么实现它？
::: sol 答案
`pthread_create` = `clone(CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|...)`——线程与进程是同一套创建接口的不同 flag 组合。「只有 `CLONE_VM`」**不是**线程：线程还要 `CLONE_THREAD`（同 TGID、共享 `signal_struct`）；只有 `CLONE_VM` 的两个进程共享地址空间但各有独立信号与退出状态，`ps -L` 看不到第二个线程。组合硬规则：`CLONE_THREAD` 必须带 `CLONE_SIGHAND`、`CLONE_SIGHAND` 必须带 `CLONE_VM`，违反 `EINVAL`。`posix_spawn` **成功返回 0、失败返回错误码**（不是 -1/errno，要用 `strerror(rc)` 而非 `perror`）。本机 glibc 2.39/aarch64 实测它用 **`clone3(CLONE_VM|CLONE_VFORK|CLONE_CLEAR_SIGHAND)`** 实现（不是老书说的裸 `clone`），比手写 fork+exec 少一次页表复制——详见[勘误页](ch07-errata.md)。
:::
:::

## B. 终止与回收

::: method 回忆 10 · `exit`、`_exit` 与 `main` 返回
`exit()` 按顺序做哪四件事？`_exit()` 做什么、不做什么？`main` 里 `return n` 等价于谁？
::: sol 答案
`exit(status)` 是库函数，四步：① 按注册的**逆序**调 `atexit`/`on_exit` 处理器；② flush 并关闭所有 stdio 流；③ 删除 `tmpfile()` 创建的临时文件；④ 调 `_exit(status)`。`_exit(status)` 是系统调用，直接进内核：关闭所有 fd、释放内存与锁、把退出状态留给父进程、变僵尸——**不** flush stdio、**不**跑 atexit。`main` 里 `return n` 等价于 `exit(n)`（C 运行时把 main 返回值作为 exit 参数）；在其他函数里 `return` 只是返回不终止进程。注意：若退出处理过程要访问 main 的局部变量，从 main 返回是未定义行为（如 `setvbuf` 引用了 main 的本地缓冲区）。
:::
:::

::: method 回忆 11 · `atexit`/`on_exit` 的顺序与生命周期
退出处理程序按什么顺序执行？fork 后子进程继承吗？exec 后呢？信号致死会跑吗？`on_exit` 比 `atexit` 多什么？
::: sol 答案
按注册的**逆序**（LIFO）执行——先注册的后执行，适合「后申请的资源先释放」；`atexit` 与 `on_exit` 注册的函数在**同一列表**里混排逆序。fork 创建的子进程**继承**父进程已注册的退出处理函数；exec 会**移除**所有已注册处理器（程序段被替换）。进程因信号异常终止或直接 `_exit` 时**不跑**退出处理程序——所以 SIGKILL 无法触发清理，最佳实践是给 SIGTERM 建处理器设标志、让主程序调 exit。`on_exit`（glibc 非标准扩展）比 `atexit` 多两个能力：处理器能拿到传给 exit 的 status、能带一个注册时的 arg 参数；可移植代码应避免用 `on_exit`。处理器里不要再调 `exit`（SUSv3 未定义，某些系统会无限递归）。
:::
:::

::: method 回忆 12 · fork 后 stdio 重复输出
为什么 fork 后子进程 `exit()` 会重复输出？为什么终端上常常看不到、重定向到文件就看到？两种修复是什么？
::: sol 答案
stdio 缓冲区在**用户空间内存**里，fork 时被复制。若 fork 前缓冲区有未 flush 数据（`printf` 无换行），父子各持一份；子进程 `exit()` 会 flush 自己复制来的那份、父进程 `exit()` 再 flush 自己那份——同一数据输出两次。终端是**行缓冲**，上一条输出通常以换行结尾、缓冲区已空，所以看不到；重定向到文件/管道是**全缓冲**，数据一直攒着，fork 时缓冲区非空就重复（本机实测：`_exit` 版 count=1、`exit` 版 count=2）。两种修复：① fork 前 `fflush(NULL)`（或 `setvbuf` 关缓冲）；② 子进程一律 `_exit()`。通用原则：创建子进程的应用里通常只有一个进程（父）该调 `exit`，其余调 `_exit`，保证只有一个进程 flush 与跑 atexit。
:::
:::

::: method 回忆 13 · 退出码低 8 位与状态字宏
`exit(256)`/`exit(1000)` 父进程看到什么？「128+信号号」是谁的约定？`WIFEXITED`/`WIFSIGNALED`/`WIFSTOPPED`/`WIFCONTINUED` 各判什么？
::: sol 答案
退出码只有**低 8 位**能传给父进程：`exit(256)` 看到 0、`exit(1000)` 看到 232（1000 & 0xff）。「128+信号编号」是 **shell 的约定**（`$?`），不是内核口径——内核里被信号杀死时 `WIFSIGNALED` 为真、`WTERMSIG` 给信号号，退出码字段根本不存在。状态字 `int status` 是位打包的，必须用宏解码不能直接比：`WIFEXITED`（正常退出，配 `WEXITSTATUS` 取低 8 位码）、`WIFSIGNALED`（被信号杀，配 `WTERMSIG`、`WCOREDUMP`）、`WIFSTOPPED`（被信号停止，配 `WSTOPSIG`）、`WIFCONTINUED`（被 SIGCONT 继续，`status==0xffff`）。取值大于 128 的退出码会和 shell 的「128+信号」混淆，应避免。
:::
:::

::: method 回忆 14 · 僵尸占什么、怎么回收
僵尸进程占的是内存页还是别的？`ps` 里什么状态？为什么 `kill -9` 杀不死？有哪几条回收路径？
::: sol 答案
僵尸（zombie）是已终止但父进程尚未 `wait` 的进程，占的是 **PID 与 `task_struct` 及少量记账信息**（退出状态、资源用量），**不是内存页**——内存早已释放。`ps` 状态位是 **Z**（本机实测 `ps -o stat` 显示 Z）。`kill -9` 杀不死它——它已经死了，信号无处递送（本机实测 `kill -9` 返回 0 但僵尸仍在）。回收路径：① 父进程调 `wait`/`waitpid`/`waitid` 取走状态，内核删除僵尸；② 父进程自己退出，僵尸过继给 init（PID 1）或最近的 subreaper，由后者 `wait` 回收。长期不回收会耗尽 PID：`fork` 返回 `EAGAIN`，「进程数没满却创建不了进程」。唯一彻底清除无人收的僵尸的办法是杀掉其父进程（让 init 接管）。
:::
:::

::: method 回忆 15 · 孤儿过继与 `PR_SET_PDEATHSIG`
父进程先死，子进程 `getppid()` 变成什么？subreaper 是什么？`PR_SET_PDEATHSIG` 怎么用、为什么顺序不能反？
::: sol 答案
父进程先于子进程终止，子进程成**孤儿**，被过继给 init（PID 1）或最近的 **subreaper**（用 `prctl(PR_SET_CHILD_SUBREAPER)` 标记的进程，容器里常用），`getppid()` 返回过继后的父 PID。`prctl(PR_SET_PDEATHSIG, sig)` 让子进程在**父进程死亡时**收到指定信号（本机实测：父退出后子进程被 SIGTERM 杀死，免特权可做）。顺序不能反：**先 `prctl` 再检查 `getppid()`**——若父进程恰在两步之间退出，`getppid()` 已变 1/subreaper，检查失败直接 `_exit`；若先检查再 prctl，父死在中间则信号永远收不到（内核不补发）。注意 PDEATHSIG 在 fork 时被清零、且发给的是父**线程**死亡而非整个进程，多线程下要小心。
:::
:::

::: method 回忆 16 · `SIGCHLD` 合并与免僵尸的代价
为什么 `SIGCHLD` 处理器里只 `waitpid` 一次会漏收？正确循环怎么写？设 `SIG_IGN`/`SA_NOCLDWAIT` 有什么代价？
::: sol 答案
标准信号**不排队**：处理器运行时引发它的信号被阻塞，期间多个子进程退出只记一次未决，处理器可能只被调一次。所以处理器里必须 `while (waitpid(-1, &st, WNOHANG) > 0)` 把已退出的**全部**收干净，返回 0（无事件）或 -1（出错/ECHILD）时退出循环；还要保存恢复 `errno`（waitpid 会改它）。完全不想管僵尸可在**创建子进程之前**把 `SIGCHLD` 设 `SIG_IGN` 或给 `sigaction` 加 `SA_NOCLDWAIT`：子进程退出直接回收、不产生僵尸。代价是**再也拿不到退出状态**——`waitpid` 返回 `ECHILD`，只适合 fire-and-forget。注意 Linux 上设 `SIG_IGN` 不影响**既有**僵尸（仍要照常 wait），且默认处置虽也是忽略，显式 `SIG_IGN` 才有免僵尸效果（SIGCHLD 这点很独特）。
:::
:::

## C. 内核路径与 wait 全景

::: method 回忆 17 · `kernel_clone`→`copy_process` 顺序与回滚
`copy_process()` 返回的是 PID 还是别的？新进程何时才可运行？失败时按什么顺序回滚？vfork 的父进程阻塞在哪？
::: sol 答案
`copy_process()` 返回 **`struct task_struct *`** 不是 PID；PID 在复制完成后才经 `pid_vnr()` 取出，`CLONE_PARENT_SETTID` 在这一刻把 PID 写回父进程给的地址。新进程在 **`wake_up_new_task()` 之前不可运行**——所有资源复制完才入队，所以子进程看不到「复制到一半」的状态。任一步失败走与复制顺序**相反**的 `bad_fork_cleanup_*` 回滚链（`copy_thread` 失败清 io、`copy_io` 失败清 namespaces……一直到 `copy_files` 失败清 semundo），已建立的资源全释放，父进程看不到半成品。vfork 的父进程阻塞点不在调度器而在 `wait_for_vfork_done()` 的 **completion** 上，子进程 exec/exit 时 `complete_vfork_done()` 唤醒它——这解释了 vfork 子进程不 exec 会把父永久挂起。
:::
:::

::: method 回忆 18 · COW 页表层与 `clone3` 协商
`copy_page_range` 对私有可写映射做什么？`do_wp_page` 在引用计数为 1 时怎么优化？`clone3` 的大小协商与 `set_tid` 是什么？
::: sol 答案
`copy_mm`（未设 `CLONE_VM`）→`dup_mm`→`dup_mmap` 遍历每个 VMA→`copy_page_range` 复制页表项，对私有可写映射把**父子双方 PTE 都设只读**、引用计数加一，这一步不复制数据页。写入缺页时 `do_wp_page` 判断 `PageAnon` 与 `page_count`：**引用计数为 1 直接恢复可写**（没别人共享，不必复制），大于 1 才分配新页复制——所以「fork 后父先退出，子再写那页」内核不必复制。`clone3`（Linux 5.3）把参数放进可扩展的 `struct clone_args`，第二参是结构体大小，内核用**大小协商**向前兼容（旧内核见更大的结构体返回 `EINVAL`，调用者退回小结构或 `clone`，并处理 `ENOSYS`）。`set_tid` 允许在**新 PID 命名空间**里指定子进程 PID（容器构造「容器内 PID 1」），无 `CAP_CHECKPOINT_RESTORE`/`CAP_SYS_ADMIN` 时 `EPERM`。
:::
:::

::: method 回忆 19 · `waitpid` 四种 pid 与 `waitid` 的 idtype
`waitpid` 的 pid 取 >0、-1、0、<-1 各等谁？`waitid` 的 idtype 有哪四种？`waitid` 成功返回什么？
::: sol 答案
`waitpid` 的 pid：`>0` 等 PID 等于它的那个子进程；`-1` 等任意子进程（等价 `wait`）；`0` 等与调用者**同一进程组**的任意子进程；`<-1` 等进程组 ID 等于 `-pid` 的任意子进程。`waitid` 把「等谁」拆成 idtype：`P_ALL`（忽略 id，任意子进程）、`P_PID`（PID 等于 id）、`P_PGID`（进程组等于 id，注意要显式传 `getpgrp()` 不能传 0）、`P_PIDFD`（id 是 pidfd 不是 PID，Linux 5.4）。`waitid` **成功返回 0**、子进程信息在 `siginfo_t` 里（不是返回 PID）；失败返回 -1。`P_PIDFD` 的价值是消除 PID 回绕竞态：`pidfd_open(pid)` 的 fd 绑定进程对象，即使目标退出、PID 被复用，fd 也不指向新进程——服务管理器用它发信号、等退出，避免「kill 错进程」。
:::
:::

::: method 回忆 20 · `waitid` 全 flags 与 `WNOWAIT`
`waitid` 的事件位与附加位各有哪些？`WNOWAIT` 与 `WNOHANG` 差在哪？`WNOHANG` 无事件时返回什么、怎么区分「没有子进程」？
::: sol 答案
事件位（至少指定一个否则 `EINVAL`）：`WEXITED`（等退出）、`WSTOPPED`（等停止，等价 waitpid 的 `WUNTRACED`）、`WCONTINUED`（等 SIGCONT 继续）。附加位：`WNOHANG`（非阻塞）、`WNOWAIT`（只取信息不回收，子进程仍是僵尸可再等）、`__WALL`/`__WCLONE`/`__WNOTHREAD`（Linux 专有，管 clone 子进程）。`WNOWAIT` 照常阻塞等事件、只是**不把子进程从僵尸队列摘除**（本机实测：peek 后 `/proc/<pid>/stat` 仍是 Z，再 waitpid 才消失）；`WNOHANG` 是不阻塞。`WNOHANG` 下要区分两种「返回 0」：调用前把 `siginfo_t` 清零，返回 0 且 `si_pid==0` 是「有子进程但无事件」；若**根本没有匹配的子进程**则返回 -1、`errno=ECHILD`（本机实测两种情形都验证了）。`WNOWAIT` 拼写就是 WNOWAIT，本机值 `0x01000000`。
:::
:::

::: method 回忆 21 · 状态字宏 vs `siginfo_t` 与 rusage 单位
`si_code` 的六个取值各是什么、`si_status` 怎么读？`CLD_*` 与 `WIF*` 能交叉用吗？`ru_maxrss` 在 Linux 与 macOS 上单位差在哪？
::: sol 答案
`si_code`：`CLD_EXITED`（正常退出，`si_status` 是退出码 0–255）、`CLD_KILLED`（被信号杀无 core，`si_status` 是信号号）、`CLD_DUMPED`（被杀有 core，信号号）、`CLD_TRAPPED`（ptrace 陷阱）、`CLD_STOPPED`（停止信号）、`CLD_CONTINUED`（SIGCONT）。本机 glibc 2.39 实测常量值：EXITED=1、KILLED=2、DUMPED=3、TRAPPED=4、**STOPPED=5**、CONTINUED=6（注意 2 是 KILLED 不是 STOPPED）。`CLD_*` 与 `WIF*` 是**两套编码不能交叉**：`si_code==CLD_EXITED` 时直接读 `si_status`，不要 `WEXITSTATUS(si_status)`。`wait4` 的 `struct rusage`：`ru_maxrss` 在 **Linux 上是 KiB**、macOS/BSD 上是字节，跨平台要处理 1024 倍差异；`ru_inblock`/`ru_oublock` 是实际块设备 I/O（512B 块）不是 read/write 调用次数，页缓存命中不增加。
:::
:::