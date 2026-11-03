# 1.8 章末总结

## 五单元一览

| 单元 | 小节 | 核心问题 | 关键结论 | 典型陷阱 |
|:--|:--|:--|:--|:--|
| **一、异常与内核入口** | 1.8.1 → 1.8.8 | 控制权在什么时刻、以什么方式离开当前指令流？ | 四类异常按**返回哪一条指令**分：中断与陷阱返回下一条，故障重试当前指令，终止不返回。「故障」能恢复是因为 CPU 在指令提交前报错、保存的返回地址指向出错指令本身。x86-64 的 IDT 有 256 项、每项 16 字节，前 32 个向量由 CPU 保留；`#PF` 的错误码按 P、W/R、U/S、RSVD、I/D 五位解释，出错地址在 `%cr2`。缺页三种结局：补齐页表后重试、转成 `SIGSEGV`、扩栈。`syscall` 不是异常而是特权级切换指令：`%rip` 存进 `%rcx`、`%rflags` 存进 `%r11`，参数第四位用 `r10` 而不是 `rcx`。 | 把 `syscall` 当异常讲又说不清区别；以为段错误地址写在指令里；把 `int 0x80` 与 `syscall` 混用；以为向量号在所有架构上都是 256 个。 |
| **二、进程容器与进程控制** | 1.8.2、1.8.3 → 1.8.9、1.8.11 | 一份执行上下文由什么组成？`fork`、`exec`、`wait` 各自动哪一块？ | `task_struct` 按「异常处理需要什么」记：`mm`、`files`、`sighand`/`signal`、`cred`、`thread_struct`、`__state`、`exit_state`。`fork` 复制 fd 表但表项指向同一个打开文件描述，**偏移共享**；地址空间靠 COW，省掉的是物理页拷贝而不是页表拷贝；子进程 pending 清空、定时器不继承、`fcntl` 记录锁不继承。`execve` 保留 pid、未设 `FD_CLOEXEC` 的 fd、阻塞掩码，忽略保持忽略、捕获重置默认，这就是 `nohup` 的原理。`status` 必须用宏拆：`exit(7)` 的整数值是 1792，直接 `printf` 看到的就是它。僵尸只占 PID 与一个 `task_struct`；孤儿由 PID 1 或 subreaper 收养。 | 以为父子 fd 偏移独立；直接打印 `status`；以为 exec 保留自定义 handler；把 `system()` 当 fork+exec；以为 `fork` 复制了整份内存。 |
| **三、信号** | 1.8.4 → 1.8.10 | 信号从产生到 handler 执行，中间被谁拦住、谁改主意？ | 四阶段是产生 → pending → 递送 → 处置；标准信号同一种只留一个、实时信号排队。`sigaction` 的七个标志里最容易踩的是 `SA_RESTART`：`read`/`write`/`wait` 会重启，`pause`、`sigsuspend`、`nanosleep`、`epoll_wait` 永不重启，已经读到部分数据的 `read` 也只返回短读。处理函数只能调异步信号安全函数，安全写法是置 `volatile sig_atomic_t` 标志、写 self-pipe、或用 `signalfd` 变成 fd 事件。`sigsuspend` 把「置掩码」与「睡眠」合成一步，消除检查—睡眠空窗。多线程用 `pthread_sigmask`，`sigprocmask` 在多线程程序里行为未定义。 | handler 里 `printf` 或 `malloc`；以为信号会排队；以为设了 `SA_RESTART` 就万事大吉；想捕获 `SIGKILL`；只在主线程屏蔽信号却指望别的线程不被选中。 |
| **四、非本地跳转** | 1.8.5 → 1.8.12 | 「跳回旧栈帧」丢掉了什么，谁替它收尾？ | `setjmp` 存 `%rsp`、`%rip` 与被调用者保存寄存器，`longjmp` 恢复它们；第二参数为 0 会被改成 1，因为 0 表示首次进入。`setjmp` 之后被改过的自动变量，没有 `volatile` 时值不确定——本书在 Ubuntu 24.04 上实测：同一份代码 `-O2` 打印旧值 1，`-O0` 打印 42。`longjmp` 不执行中间栈帧的清理，锁、`free`、`close` 全会漏。从 handler 跳出必须用 `sigsetjmp(env, 1)`/`siglongjmp`，否则信号掩码留在阻塞状态；它不能跨进程、不能跨线程。 | 忘了 `volatile`；从带锁的函数里跳出去；用普通 `setjmp` 从 handler 跳；以为 `longjmp` 会恢复堆和文件。 |
| **五、作业控制与观测** | 1.8.6、1.8.7 → 1.8.13、1.8.14（含 1.8.16） | 前台/后台是谁决定的？一个「收不到信号」的问题该从哪一格查起？ | 三层是会话（`sid`）包进程组（`pgid`）、进程组里有一个前台组（`tpgid`），只有前台组能读控制终端。后台组读终端收 `SIGTTIN`、写收 `SIGTTOU`，默认动作是**停止**而不是报错；`Ctrl-Z` 的链路是终端驱动发 `SIGTSTP`，shell 用 `tcsetpgrp` 收回前台，`fg` 再发 `SIGCONT`。作业控制是 shell 用 `setpgid`/`tcsetpgrp` 打开的，不是终端自动给的。观测三件套：`strace -f -e trace=process,signal` 看 `clone`/`wait4`/`--- SIGCHLD ---`；`/proc/<pid>/status` 的 `SigPnd`/`ShdPnd`/`SigBlk`/`SigIgn`/`SigCgt` 五位掩码；`ps -o pid,ppid,pgid,sid,tpgid,stat` 看关系与状态。 | 以为 `&` 就自动得到独立进程组；把「后台读终端被停住」当权限错误；把 `(core dumped)` 当成拿到了 core 文件；用 `grep ^Sig` 抓字段结果多出一行 `SigQ`。 |

## 一条主线

这一章从「控制流为什么会被掰弯」走到「掰弯之后谁负责收尾」：**先分四类异常（1.8.1），于是知道缺页为什么能重试、系统调用为什么回得来；再看异常处理程序需要什么上下文（1.8.2），于是 `task_struct` 的字段有了次序；`fork/exec/wait` 就在这份上下文上做加减（1.8.3），每一处加法都对应一个真实 bug——偏移共享、fd 泄漏、僵尸；内核要通知进程，用的是信号（1.8.4），而信号最难的不是发，是**什么时候发**：它插在任意两条指令之间，于是有了可重入与竞态；用户态想一口气跳回安全点，用 `setjmp/longjmp`（1.8.5）；多个进程要共享一台终端，用会话与进程组（1.8.6）；这一切看不见，只能用工具取证（1.8.7）。**

第二遍（1.8.8–1.8.14）不引入新主题，只把同一批主题变成能读、能算、能跑：向量表与 `#PF` 错误码（1.8.8）、两张复制/重置表与 `clone` 标志（1.8.9）、`sa_flags` 七标志与 self-pipe（1.8.10）、最小 shell 与 `EINTR` 循环（1.8.11）、`volatile` 与 `sigsetjmp`（1.8.12）、`strace` 时间线（1.8.13）、五步作业控制（1.8.14）。1.8.15 给 Rust 侧对照，1.8.16 用 12 条陷阱收口，[1.8.17 本章小结](ch08.md#sec-1.8.17) 由[自检表](ch08-checklist.md)接管。

看任何一个「跳走了 / 收不到 / 退不掉」，固定问三件事：**谁发的（`si_code`、`si_pid`）？发给谁（pid、进程组、还是任意未阻塞线程）？处理了没有（处置、掩码、pending）？**

## 看到症状先选工具

三列的顺序就是排查顺序：先由症状想到机制，再由机制决定敲哪条命令。别倒过来——先敲命令再看输出，往往只是把同一堆数字读第二遍。

| 症状 | 机制上先想到什么 | 第一动作（命令与判读） |
|:--|:--|:--|
| 退出码打印成 1792 | `status` 是编码过的 16 位，退出码在低 8 位之上 | 用 `WIFEXITED`/`WEXITSTATUS` 拆；看到 1792 就该想到 `7 << 8` |
| 子进程退出了，`ps` 里还有 `Z` | 僵尸是「已死未回收」，只有父进程能收 | `ps -o pid,ppid,stat,cmd`，顺 `PPID` 找到父进程，看它卡在哪一步 |
| 3 个子进程只收到 1～2 次 `SIGCHLD` | 标准信号不排队，多个退出会合并成一次递送 | handler 改成 `while (waitpid(-1, &st, WNOHANG) > 0)`，数 `hits` 与 `Z` 两个量 |
| 慢系统调用莫名失败 | 信号打断了阻塞调用，`errno` 会是 `EINTR`（4） | `if (r < 0 && errno == EINTR) continue;`；再看 `sa_flags` 有没有 `SA_RESTART`，并记住它不是万能的 |
| handler 里偶尔死锁或日志丢失 | `printf`/`malloc` 会拿锁改堆，而 handler 可能插在中间 | 换成只置 `volatile sig_atomic_t` 标志或 `write`；要传数据用 self-pipe |
| 程序卡在 `pause`，信号明明发过 | 信号可能在「检查条件」与「进入睡眠」之间已经递送 | 改 `sigprocmask` 阻塞 + `sigsuspend(&prev)`，或 `sigwaitinfo`/`signalfd` |
| `kill` 了没反应 | 被阻塞、被忽略、被别的线程接走，或进程在 `D` 状态 | 读 `/proc/<pid>/status` 的 `SigBlk`/`SigIgn`/`SigCgt`，再看 `ps -o stat,wchan` |
| `Ctrl-Z` 之后 `fg` 回不去 | 前台组没有在父子之间正确移交 | `ps -o pid,pgid,sid,tpgid,stat` 看 `TPGID` 指着谁；检查 `setpgid` 与 `tcsetpgrp` 各做了没有 |
| 后台进程一读终端就「卡住」 | 后台组读终端收 `SIGTTIN`，默认动作是停止 | `ps -o stat` 看到 `T` 就是它；`kill -CONT` 放回来，或 `fg` 带回前台 |
| `dmesg` 报 `Operation not permitted` | 内核环形缓冲受 `dmesg_restrict` 与 `CAP_SYSLOG` 限制 | `cat /proc/sys/kernel/dmesg_restrict`，改读 `journalctl -k` |
| 没有 core 文件却有 `(core dumped)` | 消息由 shell 依 `WCOREDUMP` 打印，文件去向由 `core_pattern` 决定 | 依次查 `ulimit -c`、`cat /proc/sys/kernel/core_pattern`，再看管道程序的日志（如 `/var/log/apport.log`） |
| `longjmp` 之后变量值不对 | 优化器把值留在寄存器里，`longjmp` 只恢复寄存器快照 | 给跨跳转的自动变量加 `volatile`；`-O0` 与 `-O2` 各编一次对比，并检查漏掉的 `unlock`/`free` |

## 能否讲出这八句话

1. 四类异常的分水岭是返回地址：中断与陷阱返回下一条，故障重试当前指令，终止不返回；缺页是故障，所以内核补完页表后同一条 `mov` 会再执行一次。
2. `syscall` 不是异常而是特权级切换：`%rip` 进 `%rcx`、`%rflags` 进 `%r11`、入口地址在 `MSR_LSTAR`、参数第四位用 `r10`；这就是 `strace` 能在入口处读寄存器看到参数的原因。
3. `fork` 复制 fd 表但共享打开文件描述，所以偏移共享；地址空间走 COW，省的是物理页拷贝；pending 信号清空、定时器不继承、记录锁不继承。
4. `execve` 保留 pid、fd、阻塞掩码，捕获的 handler 重置为默认，`SIG_IGN` 保持忽略——`nohup` 就靠这一条活下来。
5. `status` 是编码过的整数：`exit(7)` 读出来是 1792，必须用 `WEXITSTATUS` 取值，用 `WTERMSIG` 取信号号，`WIFSTOPPED` 还需要 `WUNTRACED`。
6. 标准信号不排队：3 个子进程一起退出，实测只递送 2 次 `SIGCHLD`，所以 handler 必须循环 `waitpid(-1, ..., WNOHANG)` 而不是收一个算一个。
7. `SA_RESTART` 只救可重启的调用：实测同一个 `read`，`sa_flags=0` 时 0.105 s 后返回 `EINTR`，设 `SA_RESTART` 后 0.305 s 拿到 5 个字节；`pause`、`sigsuspend`、`epoll_wait` 永远自己处理 `EINTR`。
8. 前台/后台不是终端的属性而是 shell 的动作：会话包进程组、进程组里选一个前台组，`Ctrl-Z` 是终端驱动发 `SIGTSTP`，`fg` 是 shell 发 `SIGCONT` 加 `tcsetpgrp`。

## 学完之后

1. **[闭卷回忆卡](ch08-recall.md)**：A 组只考第一遍的概念与判读，B 组只考第二遍的机制、程序与取证；合上正文，把「1792」「2 次 `SIGCHLD`」「2.0 s 对 0.0 s」「`SigCgt` 的 `4000`」这几处从空白纸上叫出来。
2. **[习题集](ch08-exercises.md)**：A 组考「会不会判」，B 组给现象让你定位到「谁发的、发给谁、处理了没有」，C 组是四个能在 Ubuntu 24.04 上免 `sudo` 跑完的实验。
3. **[学习目标自检表](ch08-checklist.md)**：这张表接管 [1.8.17 本章小结](ch08.md#sec-1.8.17)，把卡住的那一行对回小节与习题，不必从头再读整章。
4. **[勘误与版本注记](ch08-errata.md)**：本章最容易搬家的是四件事——x86-64 的向量与 `%cr2` 在 aarch64 上换了名字、`dmesg` 与 `coredumpctl` 在受限环境里不可用、`/proc` 与 `ps` 的字段形态、`longjmp` 的行为随 `-O` 变。引用任何一条之前先读「本章未实测项」。
5. **下一站**：进程以为自己独占的内存，是内核用页表变出来的。地址翻译要从 [1.9.3 手算一次四级页表](ch09.md#sec-1.9.3) 算起，缺页的另一半（换出与回收）在 [1.9.4](ch09.md#sec-1.9.4)；`mmap` 与 `SIGBUS` 的现场在 [1.9.12](ch09.md#sec-1.9.12)；线程与信号掩码的交互往上是 [1.12.2](ch12.md#sec-1.12.2)，`fork` 之后只许调异步信号安全函数这条限制，会在 [1.12.8](ch12.md#sec-1.12.8) 讲线程创建时再出现一次。
