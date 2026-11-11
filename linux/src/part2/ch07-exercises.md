# 2.7 习题集

三组分层：**A 组概念判断**考「会不会说理由」；**B 组诊断推理**给现象让你判机制、判断点、给修法；**C 组动手实验**全部在这台免 `sudo` 的 Ubuntu 24.04.5 aarch64 虚拟机（内核 `7.0.0-38-generic`、glibc 2.39）上真跑过，每题都写「看到什么算对」。共 18 题。每题第一个动作都是「先猜」：把预期写下再验证，猜错的地方才是这题的价值。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟；A 组要求说出一段完整因果，B 组写成「现象 → 机制 → 读数 → 修法」四段。
2. 卡住了回对应小节重读，不要直接看答案：A 组对应 2.7.1–2.7.6，B 组对应 2.7.2–2.7.8，C 组对应 2.7.1–2.7.8。
3. C 组命令都按本机设计：程序与产物统一 `lab2c7_` 前缀放 `/tmp`，编译用 `gcc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2`。这台机器是共享的，**只清理自己精确命名的文件，禁止宽通配删除**。
4. **环境边界**：`sudo` 与 `perf` 不可用，`ptrace_scope=1`（`strace -p` 不可用，一律「在 strace 下启动」）。凡需 root 的步骤（`clone` 特权 flag、`clone3` 的 `set_tid`）一律标「本机不可做」。C 组贴出的 PID、地址、文件名后缀每次运行都不同，**看关系不看具体值**。
5. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch07-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 2.7-A1 · `fork` 复制了什么、没复制什么 {#ex-2.7-A1}

先猜：父进程有一个打开的 fd、一个阻塞着的 `SIGUSR1`、一个 `alarm(10)` 定时器、一把 `fcntl` 记录锁。fork 后子进程里这四样各是什么状态？

把继承清单分成「复制」「共享」「清零/不继承」三类，并解释为什么 fd 偏移共享而 `cwd` 不共享。

::: sol 解答

fd：**表复制、表项指向同一打开文件描述**，所以偏移与 `O_APPEND` 状态共享（属「复制但共享底层对象」）。阻塞的 `SIGUSR1`：是**未决信号**，子进程**清空**（信号掩码继承，但未决集从空开始）。`alarm(10)`：定时器**不继承**，子进程里清零——这是 fork 后超时逻辑失效的根因。`fcntl` 记录锁：**不继承**，子进程不持有父进程的记录锁（但 `flock` 锁继承，因为共享同一打开文件描述）。地址空间 COW 共享、信号处置继承、凭证/`cwd`/`umask`/资源限制复制。为什么 fd 偏移共享而 `cwd` 不共享：内核 `copy_files()` 复制 fd 表后表项仍指向同一个 `struct file`（偏移在 `struct file` 里），而 `copy_fs()` 给每个进程一份独立的 `fs_struct` 副本（`cwd` 在里面），所以子进程 `chdir` 不影响父进程。**判据**：四样状态全对；三类划分清楚；「偏移在 struct file、cwd 在 fs_struct」的结构原因说清。

:::
:::

::: ex 例 2.7-A2 · COW 断裂点与 RSS/PSS 手算 {#ex-2.7-A2}

先猜：4 个已驻留私有匿名页，fork 后子进程写 1 页、父不写，父子 RSS、PSS、合计物理页各是多少？子进程 RSS 会变成 5 吗？

手算三时刻（fork 后未写、子写 1 页、子退出）的 RSS/PSS/物理页，并解释为什么 RSS 不翻倍也可能发生了 COW。

::: sol 解答

子写 1 页后：父 RSS=4、子 RSS=4（**不是 5**——子进程把「指向共享旧页」换成「指向私有新页」，驻留页数量不变）、合计物理页=5（父独占 1 + 子独占 1 + 仍共享 3）、父 PSS=子 PSS=`1 + 3/2 = 2.5`。fork 后未写：RSS 各 4、物理页 4、PSS 各 2。子退出后：父 RSS=4、物理页 4、父 PSS=4。RSS 把共享页在每个映射进程里都算一遍，所以 RSS 之和重复计算；PSS 按映射进程数分摊。**关键**：子进程写后 RSS 没变（仍 4）但物理页从 4 涨到 5——COW 确实发生了，只是「替换映射」而非「保留两份」，所以「RSS 不翻倍」不能证明「没复制」。真实实验要在父子都存活时读 `smaps` 的 `Private_Dirty`/`Shared_Dirty`（见 C2）。**判据**：三时刻数字全对；子 RSS=4 不是 5；「替换映射」解释清。

:::
:::

::: ex 例 2.7-A3 · `exit`、`_exit`、`atexit` 的四步差异 {#ex-2.7-A3}

先猜：注册两个 atexit 处理器 H1、H2（H1 先注册），进程 `exit(0)` 时谁先跑？子进程 `_exit(0)` 时跑吗？fork 前 printf 无换行，子进程 `exit` 与 `_exit` 输出差在哪？

说出 `exit` 的四步顺序、`_exit` 跳过哪些、atexit 的执行顺序与继承规则。

::: sol 解答

`exit(0)` 四步：① 逆序跑 atexit/on_exit（**H2 先、H1 后**，LIFO）；② flush 并关闭 stdio；③ 删 tmpfile；④ 调 `_exit(0)`。`_exit(0)` 直接进内核，**不跑 atexit、不 flush stdio**。atexit 处理器 fork 后子进程**继承**、exec 后**清除**、信号致死时**不跑**。fork 前 printf 无换行：缓冲区被复制，子进程 `exit` 会 flush 复制来的那份（重复输出）+ 跑继承的 atexit；子进程 `_exit` 什么都不做（只父进程 flush 一次）。本机实测 `_exit` 版 `buffered-before-fork` 出现 1 次、`exit` 版 2 次（见 C4）。修复：fork 前 `fflush(NULL)` 或子进程一律 `_exit`。**判据**：四步顺序对；H2 先 H1 后；继承/exec 清除/信号不跑三条说全。

:::
:::

::: ex 例 2.7-A4 · 僵尸占什么、为什么 `kill -9` 无效 {#ex-2.7-A4}

先猜：一个僵尸进程占的是内存页还是别的？`kill -9 <zombie>` 返回什么、僵尸消失吗？有哪几条办法真正清除它？

说出僵尸占用的资源、`ps` 状态位、回收路径，以及长期不回收的后果。

::: sol 解答

僵尸占 **PID 与 `task_struct` 及少量记账信息**（退出状态、资源用量），**不占内存页**（内存早已释放）。`ps` 状态位 **Z**。`kill -9` 返回 0（系统调用成功）但僵尸**不消失**——它已经死了，信号无处递送（本机实测 kill-9-rc=0 后 ps 仍见 Z）。真正清除：① 父进程 `wait`/`waitpid`/`waitid` 取走状态；② 父进程退出，僵尸过继给 init/subreaper 由其回收。长期不回收会耗尽 PID（`kernel.pid_max` 或 cgroup `pids.max`），`fork` 返回 `EAGAIN`——「进程数没满却创建不了进程」。对无人收的僵尸，唯一彻底办法是杀掉其父进程让 init 接管。**判据**：「占 PID/task_struct 不占内存页」说对；kill -9 返回 0 但无效；两条回收路径 + EAGAIN 后果。

:::
:::

::: ex 例 2.7-A5 · 多线程 fork 为什么只允许 async-signal-safe {#ex-2.7-A5}

先猜：线程 A 正在 `malloc` 内部持锁，线程 B 此刻 fork，子进程调 `printf` 会怎样？子进程继承了几个线程？`pthread_atfork` 能救吗？

描述死锁窗口的三步，说出 POSIX 限制与三种正确写法。

::: sol 解答

子进程只继承**调用 fork 的那个线程**（线程 B），线程 A 不存在。但线程 A 持有的 malloc arena 锁以「被占住」状态定格在子进程复制来的内存里。三步死锁：① 线程 A 拿 arena 锁未释放；② 线程 B fork，子进程复制「锁已被持有」的内存；③ 子进程调 `printf`（内部 malloc）发现锁被占、永久阻塞——持有者线程 A 已不存在。POSIX 限制：多线程程序 fork 后到 exec 前只能调 **async-signal-safe** 函数。三种正确写法：① fork 后只 exec (and `_exit`)；② fork 前把状态收干净（`fflush(NULL)`、暂停其他线程）；③ `pthread_atfork` 注册钩子——但它**只能救你自己注册的锁**，救不了 libc 内部的 malloc/stdio/NSS 锁。工程结论：多线程程序别 fork 出继续跑业务的子进程，要并行用线程、要执行外部程序用 `posix_spawn`。**判据**：三步窗口说全；「只复制调用线程」；atfork 的局限点明。

:::
:::

::: ex 例 2.7-A6 · `vfork`、`clone`、`posix_spawn` 怎么选 {#ex-2.7-A6}

先猜：要「执行外部程序并改 stdout 重定向」用哪个？要「子进程改 uid、进新命名空间」用哪个？要「子进程继续跑一段自己的代码」用哪个？`posix_spawn` 失败返回 -1 吗？

给出三者的决策表，说出 `vfork` 的唯一正当形状与 `posix_spawn` 的返回值口径。

::: sol 解答

决策：① 执行外部程序、不需复杂父子通信 → `posix_spawn`（file actions 能做重定向/关 fd）；② 需精细控制子进程（改 uid、设 rlimit、进命名空间）→ `fork` + 子进程调 async-signal-safe 函数 + `execve`；③ 子进程继续跑自己的代码 → **线程**，不是进程。`vfork` 唯一正当形状是「立刻 exec、失败 `_exit`」，现代代码不该手写（SUSv4 已删除），用 `posix_spawn` 替代。`posix_spawn` **成功返回 0、失败返回错误码**（不是 -1/errno），要用 `strerror(rc)` 而非 `perror`。`clone` 是底层：`pthread_create` = `clone(CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|...)`，容器用 `CLONE_NEWPID`/`CLONE_NEWNS` 等。本机 glibc 2.39 的 `posix_spawn` 实测走 `clone3(CLONE_VM|CLONE_VFORK|CLONE_CLEAR_SIGHAND)`（见 C5）。**判据**：三种场景选对；posix_spawn 返回值口径对；vfork 形状与淘汰说清。

:::
:::

## B 组 · 诊断推理

::: ex 例 2.7-B1 · 僵尸堆积导致 `fork` EAGAIN {#ex-2.7-B1}

现象：一个服务每秒 fork 一个子进程执行任务但从不 wait，三天后 `fork` 开始返回 `EAGAIN`，`ps` 里进程数看起来并没满。

按「现象 → 机制 → 读数 → 修法」四段作答。

::: sol 解答

**现象**：长期运行的父进程突然 fork 失败 `EAGAIN`，进程总数看起来不高。**机制**：子进程退出后变僵尸，父进程不 `wait`，PID 与 `task_struct` 不释放；僵尸越积越多，耗尽 `kernel.pid_max` 或 cgroup `pids.max`（注意不是「活进程数」满，是 PID 配额满）。**读数**：`ps -eo stat,ppid,pid,comm | awk '$1 ~ /^Z/'` 数僵尸、看它们共同的父进程；`cat /proc/sys/kernel/pid_max`、`cat /sys/fs/cgroup/pids.max`（容器里）对照配额；`ls /proc/<ppid>/task` 看父进程线程。**修法**：父进程注册 `SIGCHLD` 处理器 `while (waitpid(-1, &st, WNOHANG) > 0)` 回收，或周期性 `waitpid(-1, ..., WNOHANG)`；若不需要退出状态可设 `SA_NOCLDWAIT`/`SIG_IGN`（代价是 `waitpid` 从此 `ECHILD`）；架构上别再每任务 fork。容器里 PID 1 不回收就用 `--init`/`tini`。**判据**：「僵尸占 PID 配额」是根因；ps 找 Z 与共同父进程；SIGCHLD while 循环修法。

:::
:::

::: ex 例 2.7-B2 · fork 后内存翻倍 {#ex-2.7-B2}

现象：一个占了 2 GiB 的服务 fork 出子进程后，监控显示总内存接近 4 GiB；但子进程只是偶尔写几个全局变量。

按四段作答；怎么区分「真复制」与「COW 共享」？

::: sol 解答

**现象**：fork 后总内存逼近翻倍，子进程写入量却很小。**机制**：fork 时 COW 共享物理页（不翻倍），但子进程**每写一个私有页就触发一次 COW 复制**——以页为单位（4 KiB），改一个字节也隔离整页；子进程写的全局变量分散在很多页上，就把那些页都复制了一份，父子各持一个私有副本，物理页翻倍。**读数**：在父子都存活时读 `/proc/<pid>/smaps` 对应区域的 `Private_Dirty`/`Shared_Dirty`——fork 后未写时 `Shared_Dirty` 高、`Private_Dirty` 低；子进程写后双方 `Private_Dirty` 各涨一份（本机 64 MiB 实测见 C2：65536→共享 65536→双方各 65536）。`pmap -X` 或 `smem` 看 PSS 更准（RSS 之和会重复算共享页）。**修法**：子进程若立刻 exec 则几乎不写、COW 不发生（fork+exec 划算）；若子进程要长期跑且只读，用 `MAP_SHARED` 或 `madvise(MADV_DONTFORK)` 避免复制；真要隔离就接受翻倍并预算内存。**判据**：「以页为单位、写才复制」是根因；smaps Private/Shared_Dirty 读数；RSS 重复计算与 PSS 的区别。

:::
:::

::: ex 例 2.7-B3 · 多线程服务 fork 后卡死 {#ex-2.7-B3}

现象：一个多线程服务偶发 fork 出的子进程「卡住不动」，不报错也不退出；`gdb` 附加只见子进程停在 `__lll_lock_wait`。低负载时几乎不出现，高峰期稳定复现。

按四段作答；为什么低负载不出现？怎么修？

::: sol 解答

**现象**：子进程卡在锁等待，无报错，高峰期必现。**机制**：fork 只复制调用线程，其他线程持有的 glibc malloc arena 锁（或 stdio `FILE` 锁）以「被占住」状态定格在子进程里；子进程随后调 `malloc`/`printf` 去拿同一把锁，持有者线程已不存在，永久阻塞。低负载时其他线程恰好没持锁，窗口躲过去了；高峰期持锁概率高，必现——这是**概率事件**不是确定性 bug。**读数**：`gdb -p <child>` 看栈停在 `__lll_lock_wait`/`futex`（本机 `ptrace_scope=1` 附加别人的进程被挡，需在 strace/gdb 下启动或调 scope，按未实测读）；子进程 `/proc/<pid>/stack` 需 root。**修法**：子进程 fork 后只调 async-signal-safe 函数、立刻 exec；或改用 `posix_spawn`；或 fork 前暂停其他线程并 `fflush(NULL)`；`pthread_atfork` 只能救自己注册的锁，救不了 libc 内部锁。**判据**：「锁被定格 + 持有者线程消失」是根因；概率性解释低负载不出现；async-signal-safe/posix_spawn 修法。确定性死锁复现在共享机器上未实测（见[勘误页](ch07-errata.md)）。

:::
:::

::: ex 例 2.7-B4 · 子进程继承 fd 把下游卡住 {#ex-2.7-B4}

现象：一个服务 fork+exec 出一个下游程序，下游程序读 stdin 却迟迟等不到 EOF；用 `lsof` 看下游进程持有一堆本不该有的 fd（包括一个管道的写端）。

按四段作答；为什么管道写端没关会卡住 EOF？

::: sol 解答

**现象**：下游程序等不到 EOF，持有继承来的多余 fd。**机制**：fork 复制 fd 表，子进程继承父进程**所有**打开的 fd（除非设了 `O_CLOEXEC`）；exec 默认保留这些 fd。管道的 EOF 条件是**所有写端都关闭**——父进程或子进程只要还持有那个管道写端，读端就永远读不到 EOF。子进程继承了本不该持有的写端，于是下游卡在 read。**读数**：`ls -l /proc/<child>/fd` 或 `lsof -p <child>` 列出继承的 fd，对照哪些是管道写端、哪些不该继承；`ls -l /proc/self/fd` 在 fork 前数一遍。**修法**：① 打开时就设 `O_CLOEXEC`（exec 自动关）；② 子进程 exec 前 `close_range(3, ~0U, 0)` 关掉除标准流外的所有 fd（本机 `__NR_close_range` 存在）；③ 父子各自立即 close 不用的 fd（Kerrisk 图 24-2 的标准做法）。**判据**：「管道 EOF 要所有写端关闭」是根因；/proc/<pid>/fd 取证；O_CLOEXEC/close_range 修法。

:::
:::

::: ex 例 2.7-B5 · fork 后输出重复且顺序乱 {#ex-2.7-B5}

现象：程序重定向到文件后，某行 printf 输出出现两次，且 `write()` 的输出排在 `printf` 前面；输出到终端时正常。

按四段作答；为什么终端正常、文件重复？为什么 write 先于 printf？

::: sol 解答

**现象**：重定向到文件时 printf 行重复、write 输出提前；终端正常。**机制**：stdio 缓冲区在用户空间，fork 复制了一份；终端是行缓冲（换行即 flush，fork 时缓冲区空），文件是全缓冲（数据攒着，fork 时缓冲区非空被复制），父子各 exit 各 flush 一次→重复。`write()` 直接进内核缓冲区、fork 不复制它，且立即落盘；printf 要等 exit flush 才出来——所以 write 的输出排在还没 flush 的 printf 前面。**读数**：重定向到文件复现（本机实测 `_exit` 版 count=1、`exit` 版 count=2，见 C4）；对照终端运行；`strace -e trace=write` 看 write 与 printf 底层 write 的时序。**修法**：fork 前 `fflush(NULL)`，或子进程 `_exit`；混合 stdio 与系统调用 I/O 时要么全用 stdio 要么全用 write，别混（Kerrisk 13.7 的告诫）。**判据**：行缓冲 vs 全缓冲解释终端/文件差异；write 不复制 + 立即落盘解释顺序；两种修复。

:::
:::

::: ex 例 2.7-B6 · `waitid` 返回值与 `si_status` 读错 {#ex-2.7-B6}

现象：有人用 `waitid` 的返回值当子进程 PID 用，永远是 0；又把 `si_status` 一律当退出码，被信号杀死的子进程「退出码」变成了 15；`WNOHANG` 时把 `si_pid==-1` 当「无事件」。

按四段作答；给出正确的判读口径。

::: sol 解答

**现象**：三处口径错误。**机制**：① `waitid` 成功返回 **0**，子进程信息在 `siginfo_t`（`si_pid` 才是 PID），拿返回值当 PID 永远得 0；② `si_status` 的含义由 `si_code` 决定——`CLD_EXITED` 时是退出码、`CLD_KILLED`/`CLD_DUMPED` 时是**信号号**（被 SIGTERM 杀 si_status=15 不是退出码 15）、`CLD_STOPPED` 时是停止信号、`CLD_CONTINUED` 时是 SIGCONT；③ `WNOHANG` 无事件时 `si_pid==0`（不是 -1），返回 0；**根本没有匹配子进程**才返回 -1/ECHILD。**读数**（本机实测）：正常退出 `si_code=1 si_status=7`；被 SIGTERM 杀 `si_code=2 si_status=15`；SIGSTOP 停止 `si_code=5 si_status=19`；WNOHANG 有活子进程无事件 `rc=0 si_pid=0`；无子进程 `rc=-1 errno=10`。**修法**：调用前 `memset(&si,0,...)`；用 `si.si_pid` 取 PID；按 `si_code` 分支读 `si_status`；区分「返回 0 且 si_pid==0」（无事件）与「返回 -1/ECHILD」（无子进程）。`CLD_*` 与 `WIF*` 是两套编码，别交叉（不要 `WEXITSTATUS(si_status)`）。**判据**：返回 0 不是 PID；si_status 按 si_code 分支；si_pid==0 vs ECHILD 区分。

:::
:::

## C 组 · 动手实验

::: ex 例 2.7-C1 · fork 后共享文件偏移 {#ex-2.7-C1}

先猜：父进程打开一个空文件，fork 后子进程写 100 字节再 `lseek` 到 500，父进程读出的当前偏移是多少？如果父子 fd 真是「各自独立」，应该是多少？

写一个程序：`mkstemp` 开文件、fork、子进程写 100 字节并 lseek 到 500 后 `_exit`、父进程 `waitpid` 后读偏移。编译运行。

::: sol 解答

编译：`gcc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 lab2c7_offset.c -o lab2c7_offset`。本机实测（ubuntu24，aarch64，文件名后缀每次随机）：

```text
file=/tmp/lab2c7_offset_qPRmIx fd=3
parent before fork: offset=0
child after write : offset=100
parent after child: offset=500 (子进程 lseek 到 500 的遗产)
```

父进程读出 **500**——子进程的 `lseek` 遗产父进程看得到，证明 fd 表虽复制、表项指向**同一个打开文件描述**，偏移共享。若 fd 真「各自独立」，父进程应仍是 0。注意子进程那行 `offset=100` 能看到，是因为程序开头 `setvbuf(stdout, NULL, _IONBF, 0)` 关了缓冲——否则子进程 `_exit` 不 flush，那行会丢（这正是 C4 的坑）。**看到什么算对**：父进程最终偏移=500（子进程 lseek 的值），不是 0；子进程写后偏移=100。

:::
:::

::: ex 例 2.7-C2 · COW 前后 smaps 的 Private_Dirty {#ex-2.7-C2}

先猜：父进程 mmap 64 MiB 私有匿名映射并逐页触碰，fork 后子进程未写时，这段在 smaps 里是 `Private_Dirty` 还是 `Shared_Dirty`？子进程逐页写一字节后，父子的 `Private_Dirty` 各变成多少？

写程序读 `/proc/self/smaps` 中该区域的 `Private_Dirty`/`Shared_Dirty`，用管道同步让父进程在子进程写完后（子仍存活）再读一次。

::: sol 解答

编译：`gcc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 lab2c7_cow.c -o lab2c7_cow`。本机实测（ubuntu24，aarch64，页 4096，区域地址每次随机）：

```text
region=0xf48a43000000 len=64 MiB page=4096
parent before fork         Private_Dirty=65536 kB Shared_Dirty=0 kB
child after fork(no write) Private_Dirty=0 kB Shared_Dirty=65536 kB
child after write          Private_Dirty=65536 kB Shared_Dirty=0 kB
parent after child wrote   Private_Dirty=65536 kB Shared_Dirty=0 kB
```

四个时刻讲清 COW：① fork 前父独占 64 MiB（65536 kB）脏页；② fork 后未写，页变 COW 共享，`Private_Dirty` 归 0、`Shared_Dirty`=65536（mapcount=2 算共享）；③ 子进程逐页写后拿到自己的私有副本，`Private_Dirty` 回到 65536；④ 子进程写后父进程的原页 mapcount 降回 1、恢复独占，`Private_Dirty` 也回到 65536——**此时父子各 64 MiB，物理内存翻倍到 128 MiB**。这就是「fork 后内存翻倍」的微观证据，也印证 A2 的「RSS 不翻倍但物理页翻倍」（smaps 比 RSS 看得清）。**看到什么算对**：fork 后 `Shared_Dirty` 涨到 65536、`Private_Dirty` 归 0；子写后双方 `Private_Dirty` 各 65536。

:::
:::

::: ex 例 2.7-C3 · 僵尸的 Z 状态与 waitpid 回收 {#ex-2.7-C3}

先猜：子进程 `_exit` 后父进程不 wait，`ps -o stat` 看到什么状态？`kill -9` 这个僵尸返回什么、它消失吗？父进程 `waitpid` 后再 `ps` 呢？

写程序：fork 子进程立刻 `_exit`，父 sleep 1 秒后用 `system("ps -o pid,ppid,stat,comm -p <child>")` 观察，再 `kill -9`，再 `waitpid`，再 `ps`。

::: sol 解答

编译：`gcc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 lab2c7_zombie.c -o lab2c7_zombie`。本机实测（ubuntu24，aarch64，PID 每次随机）：

```text
child=10108 exited, parent not waiting yet
--- ps before reap (expect STAT=Z, comm=<defunct>) ---
    PID    PPID STAT COMMAND
  10108   10085 Z    lab2c7_zombie
kill-9-rc=0
--- reaped: waitpid=10108 WIFEXITED=1 code=0 ---
--- ps after reap (expect no such process) ---
    PID    PPID STAT COMMAND
ps-rc=1
```

回收前 STAT=**Z**（僵尸）；`kill -9` 返回 **0** 但僵尸仍在（已经死了，信号无效）；`waitpid` 回收后 `WIFEXITED=1 code=0`，再 `ps` 返回 **1**（进程已消失）。程序开头同样要 `setvbuf` 关缓冲，否则父进程的 printf 会攒到 exit 才输出、和 `system()` 的即时输出顺序错乱。**看到什么算对**：回收前 STAT=Z；kill -9 返回 0 但 Z 仍在；waitpid 后 ps 查无此进程（rc=1）。

:::
:::

::: ex 例 2.7-C4 · `_exit` 不 flush 而 `exit` flush {#ex-2.7-C4}

先猜：fork 前 `printf("buffered-before-fork")`（无换行），子进程分别用 `_exit(0)` 和 `exit(0)`，重定向到文件后 `buffered-before-fork` 各出现几次？atexit 处理器各跑几次？

写程序带一个开关参数（`_exit`/`exit`），注册 atexit 处理器，fork 前 printf 无换行。分别重定向运行并 `grep -c`。

::: sol 解答

编译：`gcc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 lab2c7_flush.c -o lab2c7_flush`。运行 `./lab2c7_flush _exit > lab2c7_out1.txt; ./lab2c7_flush exit > lab2c7_out2.txt`。本机实测（ubuntu24，aarch64，PID 每次随机）：

```text
out1 (_exit):
buffered-before-fork
child done exit=0
[atexit] pid=10297

out2 (exit):
buffered-before-fork[atexit] pid=10300
buffered-before-fork
child done exit=0
[atexit] pid=10299

grep -c buffered-before-fork: out1=1  out2=2
```

`_exit` 版：子进程直接进内核不 flush，只有父进程 flush 一次→`buffered-before-fork` 出现 **1** 次，atexit 只父进程跑（pid=10297）。`exit` 版：子进程先跑继承的 atexit（pid=10300）、再 flush 复制来的缓冲区，父进程再 flush 自己那份→出现 **2** 次，atexit 跑两次（10300 子、10299 父）。out2 第一行 `buffered-before-fork[atexit]...` 连在一起，正是子进程 flush 的缓冲区与 atexit 输出挤在一行。**看到什么算对**：out1 count=1、out2 count=2；out2 有两个不同 PID 的 atexit 行。

:::
:::

::: ex 例 2.7-C5 · strace 认 aarch64 的 fork/vfork/spawn {#ex-2.7-C5}

先猜：在这台 aarch64 机器上 `strace` 一个 `fork()`，看到的是 `fork(...)` 还是别的调用？`vfork()` 呢？`posix_spawn()` 呢？`/usr/include/asm-generic/unistd.h` 里有 `__NR_fork` 吗？

分别写 fork、vfork、posix_spawn 三个最小程序，`strace -e trace=clone,clone3,fork,vfork` 运行；再 grep 头文件确认调用号。

::: sol 解答

本机实测（ubuntu24，aarch64，glibc 2.39，PID/地址每次随机）：

```text
grep -c __NR_fork /usr/include/asm-generic/unistd.h  ->  0
grep __NR_clone /usr/include/asm-generic/unistd.h    ->  #define __NR_clone 220

fork()  -> clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x...) = <pid>
vfork() -> clone(child_stack=0x..., flags=CLONE_VM|CLONE_VFORK|SIGCHLD) = <pid>
posix_spawn(/bin/true) -> clone3({flags=CLONE_VM|CLONE_VFORK|CLONE_CLEAR_SIGHAND, exit_signal=SIGCHLD, stack=0x..., stack_size=0x9000}, 88) = <pid>
```

aarch64 **没有 `fork`/`vfork` 系统调用**（`__NR_fork` grep 计数 0），两者都由 glibc 包装成 `clone`（调用号 **220**）：fork 用 `SIGCHLD|CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID`，vfork 用 `CLONE_VM|CLONE_VFORK|SIGCHLD`。`posix_spawn` 在 glibc 2.39 上走 **`clone3`**（不是老书说的裸 `clone`），flags 是 `CLONE_VM|CLONE_VFORK|CLONE_CLEAR_SIGHAND`、带 `stack_size`。这推翻「fork 就是 fork 系统调用」的 x86-64 常识——正文 2.7.7 的 `__x64_sys_fork` 只适用于 x86-64。**看到什么算对**：fork/vfork 都显示为 `clone`；`__NR_clone` 是 220、无 `__NR_fork`；posix_spawn 显示为 `clone3` 且带 `CLONE_VFORK`。

:::
:::

::: ex 例 2.7-C6 · waitid 的 WNOWAIT 与 si_status 口径 {#ex-2.7-C6}

先猜：`waitid(P_PID, pid, &si, WEXITED|WNOWAIT)` 返回什么、`si_code`/`si_status` 是什么、子进程还是 Z 吗？被 SIGTERM 杀死的子进程 `si_status` 是退出码还是信号号？`WNOHANG` 有活子进程但无事件时返回什么？

写程序串起：子进程 `_exit(7)`→WNOWAIT 窥视→waitpid 回收→WNOHANG 无子进程→另一子进程 raise(SIGTERM)→读 si_status；再打印 `CLD_*` 常量与 SIGSTOP/SIGCONT 事件。

::: sol 解答

编译：`gcc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 lab2c7_waitid.c -o lab2c7_waitid`（常量与停止/继续另用 `lab2c7_cld.c`）。本机实测（ubuntu24，aarch64，glibc 2.39，PID 每次随机）：

```text
peek: rc=0 si_code=1 si_status=7 si_pid=9334 state=Z
reap: waitpid=9334 WEXITSTATUS=7 state=?
nohang-nochild: rc=-1 si_pid=0 errno=10(No child processes)
signaled: si_code=2 si_status=15 (SIGTERM=15)

CLD_EXITED=1 CLD_KILLED=2 CLD_DUMPED=3 CLD_TRAPPED=4 CLD_STOPPED=5 CLD_CONTINUED=6
WEXITED=4 WSTOPPED=2 WCONTINUED=8 WNOHANG=1 WNOWAIT=16777216
stopped: si_code=5 si_status=19 (SIGSTOP=19)
nohang-live-child: rc=0 si_pid=0
continued: si_code=6 si_status=18 (SIGCONT=18)
```

`WNOWAIT` 窥视：返回 0、`si_code=1`（CLD_EXITED）、`si_status=7`（退出码），但 `/proc/<pid>/stat` 仍是 **Z**——只报告不回收；随后 waitpid 才真回收（state=?）。被 SIGTERM 杀：`si_code=2`（CLD_KILLED）、`si_status=15`（**信号号**不是退出码）。SIGSTOP 停止：`si_code=5`（CLD_STOPPED）、`si_status=19`；SIGCONT 继续：`si_code=6`、`si_status=18`。`WNOHANG` 有活子进程无事件：`rc=0 si_pid=0`；无子进程：`rc=-1 errno=10(ECHILD)`。**注意**：`CLD_STOPPED=5` 不是 2（2 是 CLD_KILLED），正文 waitid_peek 输出块若写「stopped code=2」是错的，见[勘误页](ch07-errata.md)。**看到什么算对**：WNOWAIT 后仍 Z；si_status 按 si_code 分别是退出码/信号号；CLD_STOPPED=5；WNOHANG 两种返回口径。

:::
:::