# 1.8 闭卷回忆卡

这一页不是摘要，而是一组**检索练习**。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡的第一句是**一句话答案**，后面三两句是支撑它的证据或边界，答完再展开核对。

本章是两遍式，卡也分两组：**A 组对应第一遍**（1.8.1–1.8.7 的概念与判读，口答即可），**B 组对应第二遍**（1.8.8–1.8.16 的机制、程序与取证，务必动笔或跑一遍）。建议在学完当天、隔天、第 3 天、第 7 天各做一次，每次只记三种结果：✓ 能完整说出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 第一遍：概念与判读

::: method 回忆 1 · 四类异常的分水岭

中断、故障、陷阱、终止各返回哪一条指令？为什么缺页能「重试」而除零不能？`int3` 属于哪一类？

::: sol 一句话

**按返回地址分：中断和陷阱返回下一条指令，故障重试当前指令，终止不返回；缺页是故障，因为它是可修复的缺页而不是真的越界；`int3` 是陷阱。**

中断由外部设备异步触发（网卡、时钟），处理完继续走下一条；陷阱是指令**有意**触发（`int3`、`syscall`），也返回下一条；故障是当前指令执行失败但可能修复，CPU 在指令提交前报错，保存的返回地址就是出错指令本身，内核补好页表后 `iret` 回去重执行，这次就成功了；除零也属故障，但内核没有「修好除数」的办法，只能把它转成 `SIGFPE` 或终止进程。终止是不可恢复的硬件错误（双重故障、机器检查），不返回。

:::
:::

::: method 回忆 2 · fork 复制什么、共享什么、清空什么

`fork` 之后父子两个进程共享文件偏移吗？pending 信号、定时器、记录锁、信号处置呢？COW 省掉的是哪一次拷贝？

::: sol 一句话

**fd 表复制但指向同一个打开文件描述，所以偏移共享；pending 清空、定时器不继承、记录锁不继承、信号处置继承；COW 省掉的是物理页拷贝，页表仍然要复制。**

要独立偏移，子进程必须重新 `open`，`dup` 也共享偏移。子进程继承处理函数与阻塞掩码，但 pending 集合被清空；`alarm` 定时器不继承；`fcntl` 记录锁不继承。写时复制让 `fork` 的成本主要落在页表复制上：任意一方写入触发写保护缺页，内核才复制那一页。

:::
:::

::: method 回忆 3 · exec 保留与重置

`execve` 之后，pid、fd、阻塞掩码、自定义 handler、`SIG_IGN`、pending 信号各自怎样？`nohup` 靠哪一条工作？

::: sol 一句话

**pid、fd（除非 `FD_CLOEXEC`）、阻塞掩码、pending 都保留；捕获的 handler 重置为默认，被忽略的信号保持忽略——`nohup` 就是把 `SIGHUP` 设成 `SIG_IGN`。**

因为旧的处理函数地址在新地址空间里没有意义，所以捕获的处置被清掉；而 `SIG_IGN` 是「不处理」，地址空间换掉也仍然成立，POSIX 明确规定它跨 exec 保持。`atexit` 处理器不会执行；`FD_CLOEXEC` 是防止 fd 泄漏的关键，打开文件时应默认加 `O_CLOEXEC`。

:::
:::

::: method 回忆 4 · 把 status 拆开

子进程 `exit(7)`，父进程直接 `printf("%d", status)` 会打印什么？换成 `WTERMSIG` 的场景呢？被停止要看状态需要什么标志？

::: sol 一句话

**会打印 1792（7 左移 8 位）；被信号杀死时 `WTERMSIG` 给出信号号（如 `SIGTERM` 是 15）；要看 `WIFSTOPPED` 必须给 `waitpid` 加 `WUNTRACED`。**

`status` 是编码过的 16 位整数，退出码在低 8 位，信号号在另一段，所以必须用 `WIFEXITED`/`WEXITSTATUS`、`WIFSIGNALED`/`WTERMSIG`、`WCOREDUMP` 这些宏。忘记循环 `waitpid` 也是常见错：`EINTR` 要重试，多个子进程要 `while (waitpid(-1, &st, 0) > 0)`。

:::
:::

::: method 回忆 5 · 信号的生命周期与「不排队」

四个阶段是什么？标准信号和实时信号在排队上差在哪？3 个子进程同时退出，`SIGCHLD` 会来几次？

::: sol 一句话

**产生 → pending → 递送 → 处置；标准信号同一种只保留一个、实时信号排队；3 个子进程可能只来 2 次 `SIGCHLD`（本书实测就是 2 次），所以要循环收割。**

阻塞只是让信号停在 pending 集合里，解除阻塞后内核在「下一次从内核态返回用户态」时递送。标准信号不排队是很多 bug 的根源：handler 只 `waitpid` 一次，剩下的子进程就留在僵尸状态——实测三个子进程、父进程只 `wait` 一次，最后确实剩 2 个 `Z`。

:::
:::

::: method 回忆 6 · SA_RESTART 救什么、不救什么

哪些系统调用会被自动重启？`read` 已经读到一半呢？`epoll_wait` 呢？

::: sol 一句话

**`read`、`write`、`wait` 这类可重启调用会重启；已读到部分数据的 `read` 只返回短读；`pause`、`sigsuspend`、`nanosleep`、`epoll_wait` 永远返回 `EINTR`。**

`SA_RESTART` 只是「让内核在返回用户态前重新发起这个调用」，不是「让信号消失」。本书实测同一个 `read`：`sa_flags=0` 时 0.105 s 后返回 `-1`、`errno=4`（`EINTR`）；设了 `SA_RESTART` 后调用被重启，0.305 s 时拿到 5 个字节。所以健壮的代码永远自己写 `EINTR` 重试。

:::
:::

::: method 回忆 7 · 异步信号安全

handler 里为什么不能 `printf`、`malloc`、`pthread_mutex_lock`？安全 handler 有哪三种写法？

::: sol 一句话

**因为这些函数会拿锁、改堆、用静态缓冲区，而 handler 可能正好在主程序持锁或改堆的中途插进来；安全写法是置 `volatile sig_atomic_t` 标志、写 self-pipe、或 `signalfd`。**

`printf` 要锁 stdio 缓冲区，`malloc` 要改空闲链表，锁函数可能重入死锁。POSIX 的安全清单很短：`write`、`read`、`open`、`close`、`_exit`、`kill`、`sigaction`、`sigprocmask` 等。实践中的 handler 只做一件事：置标志或 `write` 一个字节，复杂逻辑回主循环。

:::
:::

::: method 回忆 8 · pause 的空窗与 sigsuspend 的原子

`while (!stop) pause();` 为什么会永久睡眠？`sigsuspend` 凭什么消除这个窗口？

::: sol 一句话

**信号可能在「判断 `stop`」和「进入 `pause`」之间递送，`pause` 只等下一次，于是睡死；`sigsuspend` 把「置掩码」和「睡眠」做成一个原子操作，信号要么已在 pending 被立刻递送，要么在睡眠中把它唤醒。**

`sigsuspend(&prev)` 的语义是：把掩码设为 `prev`（解除阻塞）并挂起，返回后掩码恢复成调用前的值。本书实测：先阻塞 `SIGINT`、`raise` 一次，再走 `pause` 那条路，标志早已是 1，`pause` 仍然睡满 2 秒的 `alarm` 兜底；换 `sigsuspend`，0.000 秒返回。

:::
:::

::: method 回忆 9 · setjmp/longjmp 的三条规则

`longjmp(env, 0)` 会让 `setjmp` 返回什么？哪些变量在跳回后不可信？中间栈帧的清理谁来执行？从 handler 跳出要注意什么？

::: sol 一句话

**返回 1（0 被改成 1）；`setjmp` 之后被改过、又没有 `volatile` 的自动变量不可信；没人执行中间帧的清理；从 handler 跳出要用 `sigsetjmp(env, 1)`/`siglongjmp` 才恢复信号掩码。**

C 标准只保证 `volatile` 变量的值被恢复，因为优化器可能把普通变量留在寄存器里——本书实测同一份代码在 `-O2` 下打印旧值 1、`-O0` 下打印 42，这就是「未定义行为看起来正常工作」的样子。`longjmp` 只恢复寄存器，不恢复堆、文件、锁；它也不能跨进程、跨线程。

:::
:::

## B. 第二遍：机制、程序与取证

::: method 回忆 10 · 向量、错误码与 %cr2

x86-64 的 IDT 有多大、前多少项留给 CPU？`#PF` 的错误码五位各是什么？出错地址在哪？缺页的三种结局？

::: sol 一句话

**256 项、每项 16 字节，前 32 个向量由 CPU 保留；错误码五位是 P（页不存在/保护违规）、W/R（读/写）、U/S（内核/用户）、RSVD、I/D；出错地址在 `%cr2`；结局是补齐页表后重试、转 `SIGSEGV`、扩栈。**

常见向量（完整表在 [1.8.8](ch08.md#sec-1.8.8)）：0 `#DE` 除零、3 `#BP` 断点、6 `#UD` 非法指令、13 `#GP`、14 `#PF`、18 `#MC`。`error 4` 是二进制 100，即 P=0、读、用户态。`do_page_fault()` 用地址找 `vm_area_struct`：在合法 VMA 内且权限允许就按需分配（匿名页清零、文件页读入、COW 复制）；不在就发信号。

:::
:::

::: method 回忆 11 · syscall 与函数调用差在哪

参数寄存器有哪一处不同？返回地址存在哪？入口地址从哪来？为什么说它是「特权级切换」而不是异常？

::: sol 一句话

**第四个参数用 `r10` 而函数调用用 `rcx`；返回地址存在 `%rcx`、标志存在 `%r11`；入口在 `MSR_LSTAR`；它由硬件强制切换栈与特权级，所以是切换指令而不是异常。**

`syscall` 还要 `swapgs` 换内核 GS 基址，然后进 `entry_SYSCALL_64` 保存寄存器、按 `rax` 里的调用号分派。`strace` 能看见参数，是因为它用 `ptrace` 在入口和出口停下读寄存器；`perf trace` 走 tracepoint，开销更小。开销上函数调用是几纳秒，系统调用是几十到几百纳秒（含缓解措施）。

:::
:::

::: method 回忆 12 · 僵尸、孤儿、subreaper 与 clone 标志

僵尸占什么资源？谁收养孤儿？`fork` 在 Linux 上是什么？线程和进程的 `clone` 标志差在哪？

::: sol 一句话

**僵尸只占 PID 与一个 `task_struct`（不占内存）；孤儿由 PID 1 或最近的 subreaper 收养；`fork` 就是 `clone(SIGCHLD, 0)`；线程多了 `CLONE_VM`、`CLONE_FILES`、`CLONE_FS`、`CLONE_SIGHAND`、`CLONE_THREAD`。**

`prctl(PR_SET_CHILD_SUBREAPER, 1)` 让某个进程当「二传手」，容器运行时用它回收孙进程——PID 1 不 `wait` 就会积僵尸，这也是 `mycontainer` 必须处理的一件事。`vfork` 是 `CLONE_VM|CLONE_VFORK`，子进程借用父进程地址空间并阻塞父进程直到 `exec`/`_exit`，只适合「立刻 exec」。

:::
:::

::: method 回忆 13 · sa_flags 七个标志与三种安全写法

`SA_RESTART`、`SA_NODEFER`、`SA_RESETHAND`、`SA_SIGINFO`、`SA_ONSTACK`、`SA_NOCLDSTOP`、`SA_NOCLDWAIT` 各管什么？`signalfd` 解决什么问题？

::: sol 一句话

**分别是：重启慢调用、handler 执行时不禁用自身、进 handler 后恢复默认处置、用三参数 handler 拿 `siginfo_t`、在备用栈上执行、子进程停/继续时不发 `SIGCHLD`、子进程退出不产生僵尸；`signalfd` 把信号变成 fd 事件，能塞进 `epoll`。**

`SA_SIGINFO` 的 `siginfo_t` 里就有 `si_code`（标志表见 [1.8.10](ch08.md#sec-1.8.10)）（`SI_USER` 表示来自 `kill`、`CLD_EXITED` 表示子进程正常退出），这是判「谁发的」最直接的证据。self-pipe 是同一思路的手工版：handler 里 `write` 一个字节，主循环 `poll` 读端。

:::
:::

::: method 回忆 14 · sigsetjmp 与普通 setjmp 的分工

`sigsetjmp(env, 1)` 的第二个参数是什么？不恢复掩码会怎样？`longjmp` 能在两个线程之间跳吗？

::: sol 一句话

**第二个参数表示「是否保存信号掩码」，传 1 才保存；不恢复的话，handler 执行期间被自动阻塞的信号会一直阻塞下去；不能跨线程，跳到另一个线程的 `jmp_buf` 是未定义行为。**

信号 handler 执行时，该信号默认被自动阻塞（除非 `SA_NODEFER`），所以从 handler 里 `longjmp` 出去、又没恢复掩码，那个信号就永久收不到了——12 条陷阱里的第 12 条讲的就是它。

:::
:::

::: method 回忆 15 · 会话、进程组与 Ctrl-Z 的链路

三层对象各是什么？只有谁能读终端？`Ctrl-Z` 从按键到 shell 拿回控制权，中间经过谁？

::: sol 一句话

**会话（`sid`）包含若干进程组（`pgid`），其中一个是前台组（`tpgid`）；只有前台组能读终端；`Ctrl-Z` 是终端驱动向前台组发 `SIGTSTP`，进程停止，shell 用 `tcsetpgrp` 收回前台。**

后台组读终端收 `SIGTTIN`、写收 `SIGTTOU`，默认动作都是停止。`fg` 是 `SIGCONT` 加 `tcsetpgrp`，`bg` 是 `SIGCONT` 但不给终端读权限。写守护进程要 `setsid()` 脱离控制终端（五步循环见 [1.8.14](ch08.md#sec-1.8.14)），再 `fork` 一次确保不是会话首进程。作业控制是 shell 打开的，实测非交互 `bash -c` 里 `sleep &` 与 shell 同组，`kill -TSTP` 停不住它。

:::
:::

::: method 回忆 16 · 一行 strace 该读哪几段

`clone(...)` 的 flags 里没有 `CLONE_VM` 说明什么？`wait4` 的第二个参数为什么直接是 `WIFEXITED...`？`--- SIGCHLD ---` 里的 `si_code=CLD_EXITED` 说明什么？

::: sol 一句话

**没有 `CLONE_VM` 说明是进程不是线程；`wait4` 的状态被 strace 解码成了宏表达式；`CLD_EXITED` 说明子进程是正常退出而不是被信号杀死。**

一次典型的 fork/exec/wait 在 trace 里是：`clone` → 子进程 `execve` → `exit_group(7)` → 父进程 `wait4` 返回 → `--- SIGCHLD ---`。`strace -p` 会暂停目标进程，生产环境更该用 `perf trace` 或 eBPF。

:::
:::

::: method 回忆 17 · /proc 的五位掩码怎么读

`SigPnd`、`ShdPnd`、`SigBlk`、`SigIgn`、`SigCgt` 各是什么？装一个 `SIGTERM` 处理器、阻塞 `SIGHUP`，这两个字段会是多少？`grep ^Sig` 会多抓到什么？

::: sol 一句话

**依次是线程 pending、进程 pending、阻塞、忽略、捕获；实测装 `SIGTERM` 处理器得 `SigCgt: 0000000000004000`，阻塞 `SIGHUP` 得 `SigBlk: 0000000000000001`；`grep ^Sig` 还会抓到 `SigQ: 1/43361`。**

第 1 位对应信号 1（`SIGHUP`），所以 `SIGHUP` 是 `...0001`；`SIGPIPE` 是 13，忽略它得 `...1000`；`SIGTERM` 是 15，捕获它是 `...4000`。调试「为什么收不到」时先看 `SigBlk` 是不是非零，再看 `SigIgn` 是不是被设成了 `SIG_IGN`。

:::
:::

::: method 回忆 18 · 十二条陷阱里挑六条说「现象→原因→修复」

至少说六条，其中必须含「输出重复两遍」「`SIGCHLD` 只来一次」「`longjmp` 后变量值不对」这三条。

::: sol 一句话

**子进程用了 `exit` 而非 `_exit`，刷新了继承来的 stdio 缓冲→输出两遍；标准信号不排队→多个退出合并成一次 `SIGCHLD`；自动变量没加 `volatile`→`longjmp` 后读到寄存器里的旧值。**

另外三条常考的：直接打印 `status` 得到 1792（要用 `WEXITSTATUS`）；`fd` 没加 `O_CLOEXEC` 泄漏到子进程（`fork` 复制 fd 表、`exec` 默认保留）；`waitpid` 不返回是因为子进程被停止而调用没加 `WUNTRACED`。剩下的六条在 [1.8.16](ch08.md#sec-1.8.16) 的表里，逐条都能写成「现象 → 原因 → 修复」三列。

:::
:::
