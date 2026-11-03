# 1.8 勘误与版本注记

这一页收本章最容易「记成永久真理」的东西：x86-64 的向量表与寄存器名、`dmesg`/`coredumpctl` 这类取证链在受限环境里的可用性、glibc 的 `signal()` 语义随编译选项变、`/proc` 与 `ps` 的字段形态、以及 `longjmp` 随优化级别变。正文里的 `errata` 盒讲理解陷阱；这一页讲**换一台机器、换一个 libc、换一个编译选项之后要复核什么**。

**本章基线**：正文的向量表、`#PF` 错误码、`%cr2`、`int 0x80`、`r10` 都是 x86-64 的形态；aarch64 上对应物换了名字。本书在一台 Ubuntu 24.04.5 虚拟机（aarch64、4 vCPU、内核 7.0.0-38-generic、GCC 13.3.0、glibc 2.39、strace 6.8、`sudo` 不可用）上复跑过：1.8.11 与 1.8.12 的两个程序编译运行、输出与正文一致；`status` 的 1792、`SIGCHLD` 只递送 2 次、`pause` 与 `sigsuspend` 的 2.0 s 对 0.0 s 都是这台机器上的读数。凡标「VM 实测」的只属于这台机器，其余按末节当作未实测。

## 1. 架构：x86-64 的记号在 aarch64 上不成立

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 1 | 异常都由「256 项 IDT」分发，出错地址在 `%cr2`，系统调用走 `int 0x80`/`syscall` | aarch64 用**异常向量表**（基址在 `VBAR_EL1`）、用 `svc #0` 进内核，出错地址在 `FAR_EL1`。VM 实测：`objdump -d /lib/aarch64-linux-gnu/libc.so.6` 里就是 `svc #0x0`，没有 `syscall` 指令 | `uname -m`；`objdump -d /lib/*/libc.so.6 \| grep -m2 -w svc`；x86-64 上同样的位置是 `syscall` |
| 2 | 段错误时内核会打印 `segfault at 0 ip ... error 4 in crash[...]`，`error 4` 能读出读写与用户态 | `error` 是 x86 `#PF` 错误码的十进制；aarch64 用 ESR/ISS 编码，而且这次崩溃 `journalctl -k` 里**根本没有** segfault 行（VM 实测：跑空指针程序后 `journalctl -k -n 40` 没有任何相关记录，只有 `rc=139`） | 跑一个空指针程序看 `echo $?`（应为 139 = 128+11），再 `journalctl -k` 里搜 segfault；x86 上再对照一次 |
| 3 | `dmesg` 总能读内核环形缓冲，1.8.1 与 1.8.7 的 `dmesg \| tail` 可以直接照抄 | VM 实测 `dmesg: read kernel buffer failed: Operation not permitted`，因为 `dmesg_restrict=1` 且普通用户没有 `CAP_SYSLOG`。替代路径是 `journalctl -k`（VM 上可读，用户在 adm 组） | `cat /proc/sys/kernel/dmesg_restrict`；`dmesg \| tail -1`；`journalctl -k -n 3` |
| 4 | `kill -l` 的编号表是 x86 专用的，aarch64 上会少几个信号 | 编号是 Linux 通用表：VM 实测 16 仍是 `SIGSTKFLT`、17 `SIGCHLD`、20 `SIGTSTP`、21 `SIGTTIN`、22 `SIGTTOU`。但 `SIGRTMIN` **不是 32**——`kill -l` 里 31 之后直接跳到 34，32/33 被 NPTL 自己占用了 | `kill -l \| grep -E 'STKFLT\|RTMIN'`；跨架构对比同一张表 |

## 2. core 与取证链：消息、文件与工具是三件事

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 5 | 崩溃后有 `(core dumped)`，就能 `coredumpctl debug` 一条龙看栈 | 三者互不等价：消息由 shell 依 `WCOREDUMP` 打印；文件去向由 `core_pattern` 决定；工具看你装了什么。VM 实测：`core_pattern` 是管道 `\|/usr/share/apport/apport ...`，机器上**没有 `coredumpctl`**，`ulimit -c` 为 0；崩溃后 `/var/log/apport.log` 写的是 `executable does not belong to a package, ignoring`，`/var/crash` 里也没有新文件 | 依次跑 `ulimit -c`、`cat /proc/sys/kernel/core_pattern`、`command -v coredumpctl`；崩溃后看 `/var/log/apport.log` 与 `/var/crash` |
| 6 | 没有 tty 时 `ps` 的 `TPGID` 会等于自己的进程组 | VM 实测在 `ssh` 直接执行的命令里 `TPGID` 是 **-1**（没有前台组），`tty` 报 `not a tty`，`STAT` 也没有 `+` 后缀 | `ps -o pid,pgid,sid,tpgid,stat -p $$`；`tty`；有 pty 时（`script`）再跑一次对照 |
| 7 | `ps` 的 `STAT` 只有 `R/S/D/T/Z` 五个字母 | 还有附加位：`s` 是会话首进程、`l` 是多线程、`+` 在前台组、`<` 高优先级、`N` 低优先级。VM 实测同时见到过 `Ss+`（pty 里的 shell）、`Ss`（无 tty 的会话首进程）、`S+`、`T`（`SIGTTIN` 停住的后台 `cat`）、`Z` | `ps -o stat= -p <pid>` 与 `man 1 ps` 的 PROCESS STATE CODES 段对照 |

## 3. glibc 与语义：同一个函数名，两套行为

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 8 | 正文说「Linux 的 glibc `signal()` 用 BSD 语义、会重启系统调用」，所以照着写就行 | **取决于编译选项**。VM 实测同一份 `signal(SIGUSR1, h)`：`-std=c17`（严格模式）下 strace 显示 `sa_flags=SA_INTERRUPT\|SA_NODEFER\|SA_RESETHAND`（System V：不重启、执行一次后复原）；`-std=gnu17` 或加 `-D_GNU_SOURCE` 才是 `sa_flags=SA_RESTART`、`sa_mask=[USR1]` | `strace -e trace=rt_sigaction ./a.out`，两种编译各跑一次；结论是**别用 `signal()`，用 `sigaction` 把标志写死** |
| 9 | 设了 `SA_RESTART`，`read` 就不会再返回 `EINTR` | 只对「尚未交付数据」的可重启调用成立。VM 实测同一个 `read`：`sa_flags=0` 时 0.105 s 返回 `-1`、`errno=4`；`SA_RESTART` 时 0.305 s 拿到 5 个字节（中间被重启过一次）。已读到部分数据的 `read` 只返回短读；`pause`、`sigsuspend`、`epoll_wait` 永不重启 | 写两个进程：一个 100 ms 后发信号、200 ms 后写 5 字节，父进程分别用两种 `sa_flags` 读管道 |
| 10 | 1792 是某个内核或 glibc 版本的编码怪癖 | 它是 POSIX 定的编码：退出码放在低 8 位之上的那一段。VM 实测 `raw=1792`、`WEXITSTATUS=7`；被信号杀死时 `raw=15`、`WTERMSIG=15`，两种架构一致 | 跑 [例 1.8-C1](ch08-exercises.md#ex-1.8-C1)；再看 `waitpid(2)` 的「Exit status」一节 |
| 11 | 「一个子进程退出对应一次 `SIGCHLD`」 | 标准信号不排队。VM 实测 3 个子进程几乎同时退出，`SIGCHLD` 只递送 **2 次**，父进程只 `wait` 一次就留下 **2 个** 僵尸（`ps` 里两个 `Z`）。具体次数随时序变，不要拿 2 当承诺 | 跑 [例 1.8-C2](ch08-exercises.md#ex-1.8-C2)，把 `hits` 与 `Z` 的数量分开记 |

## 4. `/proc`、作业控制与优化级别

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 12 | `grep ^Sig /proc/<pid>/status` 正好得到五个信号字段 | 还会抓到 `SigQ`（待处理队列与上限，实测 `SigQ: 1/43361`）。五个掩码是 16 位十六进制、从第 1 位对应信号 1：实测装 `SIGTERM` 处理器得 `SigCgt: ...4000`、阻塞 `SIGHUP` 得 `SigBlk: ...0001`、忽略 `SIGPIPE` 得 `SigIgn: ...1000`；同时装 `SIGINT` 与 `SIGCHLD` 得 `...00010002` | `grep -E 'SigPnd\|ShdPnd\|SigBlk\|SigIgn\|SigCgt' /proc/self/status`，再自己 `sigaction` 几个信号复跑 |
| 13 | `cmd &` 之后作业就自动有了独立进程组，`Ctrl-Z` 一定能停 | 作业控制是 **shell 打开的**，不是终端自动给的。VM 实测：pty 里跑非交互 `bash -c 'sleep 30 &'`，`sleep` 的 `PGID` 与 shell 相同，`kill -TSTP` 完全没用（`STAT` 仍是 `S`）；换 `bash -m -c` 才有独立 `PGID`，`kill -TSTP` 之后 `STAT` 变 `T`，`kill -CONT` 回到 `S` | `script -qec "bash -m -c '...'" /dev/null`，在两种 shell 选项下各看一次 `ps -o pid,pgid,tpgid,stat` |
| 14 | 后台进程读终端会拿到 `EIO` 或读到 EOF | 内核发的是 `SIGTTIN`，默认动作是**停止**（不是报错）。VM 实测在 pty 里 `bash -m -c 'cat &'`，`cat` 的 `STAT` 直接变 `T`，要 `kill -CONT` 才继续；`SIGTTOU` 对应后台写，仅在 `stty tostop` 开启时触发 | 同上，把 `cat` 换成写终端再试一次 |
| 15 | `longjmp` 之后变量「就是」旧值或「就是」新值，是确定行为 | 是未定义行为，**随优化级别变**。VM 实测同一份代码：`-O2` 打印 `plain=1 vol=42`（非 `volatile` 的变量没跟上），`-O0` 打印 `plain=42 vol=42`。所以「我这儿跑对了」不能当证据 | `gcc -O0` 与 `gcc -O2` 各编一次同一个 `setjmp` 程序；读完给跨跳转变量加 `volatile` 再对比 |
| 16 | `strace -f` 的输出应该像书里那样一行一件事，字段固定 | strace 6.8 会把 `strace: Process N attached` **插进** `clone(...)` 那一行；`wait4` 会出现 `<unfinished ...>` 与 `<... wait4 resumed>`；`--- SIGCHLD ---` 比书里的示例多 `si_utime`、`si_stime`。这些是排版与版本差异，不是输出被截断 | `strace -f -e trace=process,signal ./spawn /bin/sh -c 'exit 7'`，把被插断的两行拼起来读 |

## 本章未实测项

下面这些没有本机证据支撑，引用前请当作**待验证的机制或方法**，不要抄成事实：

- **交互式终端的按键链**。`Ctrl-Z`/`fg`/`bg` 的真实按键序列没有在交互 shell 里按过；只在场由 `script` 造出来的 pty 里，用 `kill -TSTP`/`kill -CONT` 复现了「独立进程组 → `T` → `S`」这一段。`jobs -l`、`disown` 的完整输出同理，只见过非交互形态。
- **x86-64 的 segfault 日志与 `error 4`**。1.8.8 的 `error 4` 位解释按 x86 `#PF` 错误码引用；本机 `dmesg` 不可读，aarch64 也没有打印 segfault 行，所以这一条只有文献依据。
- **core 的 `gdb bt`**。本机没有 `coredumpctl`，`core_pattern` 又把 core 交给 apport，而非 apt 包的程序被 apport 丢弃（日志原文 `executable does not belong to a package, ignoring`），所以没有拿到可调试的 core。
- **Rust 侧（1.8.15）**。虚拟机没有 `rustc`/`cargo`，`Command::spawn`、`Child::wait` 自动处理 `EINTR`、`signal_hook` 的自管道、`pidfd_open`/`pidfd_send_signal` 全部按文档引用。
- **多线程信号**。`pthread_sigmask`、`sigwait`/`sigwaitinfo`、`tgkill`、进程级信号落到哪个线程——没有写多线程程序验证；1.8.10 那几条按 POSIX 与 man 页引用。
- **实时信号排队与 `sigqueue` 带值**。正文说「标准信号不排队、实时信号排队」，本书只验证了标准信号这一半。
- **`prctl(PR_SET_CHILD_SUBREAPER)` 与容器里 PID 1 的回收**。没有搭容器环境，1.8.9 的收养链路按文档引用。
- **`perf trace` 与 eBPF 替代 `strace`**。需要特权，本机 `perf_event_paranoid=4`，未实测；1.8.13 只写了「更合适」的方向。
- **`vfork` 与 `CLONE_*` 的组合行为**。1.8.9 的表按 `clone(2)` 引用，没有实际调用。
- **CSAPP 的页内数字与原文**。中文第 3 版在本机是纯扫描版、没有文本层，中文 OCR 不可用。本章只按 8.1–8.7 的章节结构核对覆盖范围（p538–p586，逐小节状态见正文末「母本对应」），没有引用书里的句子和页内数字。

## 发现新问题怎么记

按「现象 → 命令与输出 → 机器/内核/编译器/工具版本 → 建议改法」四段记，不要只写「我这里不对」。本章的结论大多挂在环境与编译选项上，所以请一并附上这几行：`uname -a`；`ldd --version` 或 `getconf GNU_LIBC_VERSION`；`gcc --version`；完整编译命令（有没有 `-std=gnu17`、`-D_GNU_SOURCE`、`-O0`/`-O2`）；`strace -V`；`cat /proc/sys/kernel/dmesg_restrict`；`cat /proc/sys/kernel/core_pattern`；`ulimit -c`；`ps -o pid,pgid,sid,tpgid,stat -p $$` 与 `tty` 的输出。

涉及数字时请写明**口径**：那个 1792 是 `status` 的原始值，那个 2.0 秒是墙钟、还是一次 `alarm` 兜底，那个 `SigCgt` 是十六进制位图而不是计数。本章的多数分歧都出在把「某台机器的一次读数」当成「机制」，或者把 x86 的细节当成 Linux 的通用形态。这张表按同一格式继续增补。
