# 2.8 闭卷回忆卡

这一页是检索练习，不是摘要。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。21 张卡分三组：**A 组考 exec 边界与 fd（2.8.1–2.8.3、2.8.9）**，**B 组考便利函数与收结果（2.8.4–2.8.6、2.8.10）**，**C 组考内核路径与观测（2.8.7–2.8.8、2.8.11–2.8.12）**。建议学完当天、隔天、第 3 天、第 7 天各做一次，只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. exec 边界与 fd

::: method 回忆 1 · `execve` 的语义与「不返回」
`execve` 成功时返回什么？失败时返回什么、进程会终止吗？为什么 `if (execve(...) == -1)` 处理的是「唯一能到达的分支」？exec 之后 PID 变吗？
::: sol 答案
成功**不返回**——调用点之后的代码已经不存在了，进程从新程序入口重新跑起来；所以无需检查返回值，「一旦返回就是出错」。失败返回 `-1` 并设 `errno`（`ENOENT`/`EACCES`/`ENOEXEC`/`ETXTBSY`/`E2BIG` 等），**原程序继续执行、不终止**，必须自己 `_exit` 兜底。PID **不变**：exec 换的是地址空间里的程序，不是进程身份；要新进程必须先 fork。本机 `exec_inherit` 实测 exec 前后 `pid=13508` 一致。
:::
:::

::: method 回忆 2 · exec 的保留/重置清单
exec 之后哪些保留、哪些丢掉？至少说出 fd、信号、cwd、定时器、内存映射五类。`nohup` 靠哪一条生效？
::: sol 答案
保留：PID/PPID、进程组/会话/控制终端、真实/有效 UID/GID 与附加组、cwd 与 umask、`RLIMIT_*`、信号掩码与未决信号、**没带 `FD_CLOEXEC` 的 fd**、**被忽略的信号（`SIG_IGN`）**、`setitimer` 间隔定时器。丢掉/重置：**被捕获的信号处理器复位为默认**、备选信号栈关闭、内存映射全丢、`atexit` 处理器全丢、POSIX `timer_create` 定时器不保留。`nohup` 把 `SIGHUP` 设为 `SIG_IGN` 再 exec，靠「忽略状态跨 exec 保留」让新程序免疫终端关闭（前提是新程序没自己重装处理器）。本机实测：`SIGINT=SIG_IGN` 保留、`SIGTERM` 处理器变 `SIG_DFL`。
:::
:::

::: method 回忆 3 · 信号处置的细分
「所有信号处置都会被 exec 重置」对吗？被捕获的、被忽略的、信号掩码、未决信号各怎样？忽略 `SIGCHLD` 跨 exec 保留吗？
::: sol 答案
不对。只有**被捕获**的处理器复位为 `SIG_DFL`（旧处理器的地址已随地址空间丢弃）；**被忽略**的保持忽略；信号掩码与未决信号都保留。忽略 `SIGCHLD` 是 SUSv3 的特例：标准不置可否，**Linux 保留忽略**（Solaris 重置为默认）——要可移植就在 exec 前显式 `signal(SIGCHLD, SIG_DFL)`。这条记反，就会误以为 `nohup` 失效或守护进程的 `SIGCHLD` 设置能跨 exec。
:::
:::

::: method 回忆 4 · exec 家族与 `PATH`
六个 exec 函数名里的 `l`/`v`/`e`/`p` 各代表什么？`execvp` 找不到 `PATH` 时用什么默认值？文件名含 `/` 时还查 `PATH` 吗？setuid 程序里为什么慎用 `execvp`？
::: sol 答案
`l`=参数用列表（list）、`v`=参数用数组（vector）、`e`=显式传 envp（environment）、`p`=查 `PATH`。只有 `execve` 是系统调用，其余是库函数。`PATH` 未定义时 `execvp`/`execlp` 用默认 `.:/usr/bin:/bin`；文件名含 `/` 就当相对/绝对路径、**不查 PATH**。setuid 程序里慎用 `execvp`/`execlp`：`PATH` 可被攻击者控制，可能执行恶意同名程序——应改用已知安全的绝对路径直接 `execve`。`execvp` 找到一个文件但无执行权限时返回 `EACCES` 并停止，不会继续找下一个。
:::
:::

::: method 回忆 5 · shebang 的三个限制
`#!/usr/bin/env python3 -u` 为什么通常失败？shebang 首行超长会怎样（本机内核 7.0）？解释器路径查 `PATH` 吗？没有 shebang 的可执行文件 `execve` 报什么、`execlp` 又怎么处理？
::: sol 答案
Linux 把解释器路径之后**直到行尾的全部文本当成一个参数**，所以 `python3 -u` 被当成一个整体路径名去找，通常失败；选项要写进脚本内部或用 wrapper。首行超长被**静默截断**而非报错：本机内核 7.0（`BINPRM_BUF_SIZE=256`，Linux 5.1 起）首行超过 255 字节（不含换行）的部分被丢弃——实测 `#!/bin/echo ` 后接 300 个 A，echo 只收到 243 个 A。解释器路径**不查 PATH**，一般用绝对路径。既非 ELF 又无 `#!`：`execve` 报 `ENOEXEC`；但 `execlp`/`execvp` 会兜底把它当 `#!/bin/sh` 交给 shell 执行。
:::
:::

::: method 回忆 6 · `FD_CLOEXEC` 是谁的属性
`FD_CLOEXEC` 存在 fd 表项还是打开文件（`struct file`）里？`dup(fd)` 的副本继承这一位吗？同一个打开文件能否一个 fd 带 CLOEXEC、另一个不带？`fork` 会复制这一位吗？
::: sol 答案
存在 **fd 表项**（`fdtable` 的 `close_on_exec` 位图），不在 `struct file` 里。所以同一个打开文件可以有 fd 3 带 CLOEXEC、fd 4 不带——exec 后 3 关、4 留。`dup`/`dup2`/`fcntl(F_DUPFD)` 的副本**清除**这一位（POSIX 规定）；要副本也 CLOEXEC 用 `F_DUPFD_CLOEXEC` 或 `dup3(..., O_CLOEXEC)`。`fork` 复制 fd 表时把这一位**一起复制**；CLOEXEC 只在 **exec** 时生效，fork 后子进程照样看得到 fd。本机实测：`dup(cloexec_fd)` 的新 fd CLOEXEC 位为 0，exec 后仍出现在子进程 `/proc/self/fd`。
:::
:::

::: method 回忆 7 · 原子设位与 `close_range`
为什么「先 `open` 再 `fcntl(F_SETFD)`」在多线程下危险？哪些接口能原子地设 CLOEXEC？`close_range` 解决哪两个问题、两个 flags 各什么意思？
::: sol 答案
两步之间另一线程可能 fork+exec 不受信程序，子程序继承到「已打开但未设位」的 fd——这是非原子窗口。原子接口：`open(O_CLOEXEC)`、`dup3(..., O_CLOEXEC)`、`fcntl(F_DUPFD_CLOEXEC)`、`pipe2(O_CLOEXEC)`、`socket(SOCK_CLOEXEC)`、`accept4(SOCK_CLOEXEC)`。`close_range(first, last, flags)`（Linux 5.9）解决：① 性能——一次关一段，省去上千次 close；② 正确性——内核里对 fd 表加锁一次完成，没有「遍历时别线程新开 fd 落在区间被误关」的窗口。`flags=0` 关闭；`CLOSE_RANGE_CLOEXEC`（5.11）只设位不关，适合「fork 前全标 CLOEXEC 但自己还要用」。容器 seccomp 白名单常没有它，可能 `EPERM`/`ENOSYS`，要留回退。
:::
:::

## B. 便利函数与收结果

::: method 回忆 8 · `system()` 的返回值
`system("exit 3")` 返回 3 吗？`command==NULL` 返回什么？fork 失败返回什么？子进程 exec 不了 shell 返回什么？为什么不能直接 `if (system(cmd) != 0)`？
::: sol 答案
不返回 3，返回 shell 的 **wait 状态** `0x0300`，要 `WEXITSTATUS` 才解出 3。`command==NULL`：shell 可用返回非 0、不可用返回 0（glibc 真的会起一个 shell 跑 `exit 0` 来探测）。fork 或取状态失败返回 `-1` 并设 `errno`。子进程 exec 不了 shell：返回如同 `_exit(127)` 的状态（`0x7f00`）——这与「shell 找不到命令退出 127」**无法区分**。直接 `!= 0` 会把 `-1`、`127`、`128+信号`、wait 状态混为一谈；正确姿势总是先 `WIFEXITED`/`WIFSIGNALED` 解码。本机实测四条：`exit 3`→`0x0300`、`kill -TERM $$`→`0x000f`、不存在命令→`0x7f00`、`true`→`0x0000`。
:::
:::

::: method 回忆 9 · `system()` 的四个问题
`system` 方便背后哪四个问题？setuid 程序里用它为什么等于提权？注入为什么「加引号」也挡不住？
::: sol 答案
① 注入：没有参数数组形式，不可信数据拼进命令串会被 shell 解释（`; rm -rf ~`）；加单引号也不够——数据里含单引号就能闭合。② 信号语义：调用期间忽略 `SIGINT`/`SIGQUIT`，你的优雅退出处理器不触发。③ 环境与 `PATH`：子 shell 继承 `environ` 与 `PATH`，setuid 程序里等于把 root shell 交给 `PATH` 里任意同名程序（`IFS`/`ENV` 也可被利用）。④ 线程安全：临时改全局信号处置，多线程并发调用或与自己的 `SIGCHLD` 处理器并发都不可依赖；也非 async-signal-safe。正解是根本不过 shell：fork + `execve` 绝对路径、参数作数组传。
:::
:::

::: method 回忆 10 · `system()` 期间的信号
`system` 期间调用者的 `SIGCHLD`、`SIGINT`、`SIGQUIT` 各被怎样？为什么要在 fork **之前**设？`system` 返回后立刻 `waitpid(-1)` 可能得到什么？
::: sol 答案
调用者**阻塞 `SIGCHLD`**（防你的处理器抢走 shell 子进程）、**忽略 `SIGINT`/`SIGQUIT`**（让 shell 与前台子进程响应 Ctrl-C，调用者存活）。必须在 fork 之前设，否则「子进程先退出、父进程还没阻塞 SIGCHLD」会有竞态。子进程则把 `SIGINT`/`SIGQUIT` 恢复成默认（如同 fork+exec）。`system` 返回后它已收走自己的 shell 子进程，你若立刻 `waitpid(-1)` 且无其他子进程，会得 `ECHILD`。本机 strace 实测 glibc 2.39 用 `clone3(CLONE_VM|CLONE_VFORK|CLONE_CLEAR_SIGHAND)` 起子进程跑 `/bin/sh -c -- "exit 0"`。
:::
:::

::: method 回忆 11 · `popen`/`pclose` 的边界
`popen(cmd,"r")` 与 `"w"` 各读写什么？`pclose` 返回退出码吗？`"w"` 模式的死锁怎么发生？`pclose` 偶发 `ECHILD` 的根因？
::: sol 答案
`"r"`：读它=读命令的 stdout；`"w"`：写它=喂命令的 stdin。单向，要双向得自己 `pipe`+`fork`+`dup2` 或 `socketpair`。`pclose` 返回 **wait 状态**（`wait4` 的形式），不是退出码，要解码。`"w"` 死锁：子进程往 stdout/stderr 写大量数据、管道缓冲（64 KiB）写满阻塞，父进程又在等它读完输入，双方互等。`pclose` 偶发 `ECHILD`：你的 `SIGCHLD` 处理器抢先回收了 popen 的子进程——统一回收点、popen 期间阻塞 SIGCHLD。本机实测：`popen("head -c 1","w")` 写 1 MiB，默认处置下父进程被 `SIGPIPE` 杀（shell 见 141）；忽略 SIGPIPE 后写端得 `EPIPE`、`pclose` 解出 head 退出 0。
:::
:::

::: method 回忆 12 · `waitid` 的 `si_code`
`waitid` 比 `waitpid` 多给了什么？`si_code` 有哪些取值？什么时候 `si_status` 才是退出码？`WNOWAIT` 干什么？
::: sol 答案
`waitid` 填 `siginfo_t`：`si_code` 给事件原因——`CLD_EXITED`(1)、`CLD_KILLED`(2)、`CLD_DUMPED`(3)、`CLD_TRAPPED`(4)、`CLD_STOPPED`(5)、`CLD_CONTINUED`(6)；还有 `si_pid`、`si_uid`（子进程真实 UID）、`si_status`。**只有 `CLD_EXITED` 时 `si_status` 才是退出码**，其余是信号号——看到 `si_code≠1` 还把 `si_status` 当退出码是监督进程常见错误。`WNOWAIT` 返回状态但子进程仍可等待（稍后再 wait 拿同样信息）。`WNOHANG` 轮询时要先把 `siginfo_t` 清零、靠 `si_pid==0` 判断「无状态变化」。本机实测子进程 `_exit(42)`：`si_code=1 si_status=42 si_uid=1000`。
:::
:::

::: method 回忆 13 · `getrusage` 的三个口径
`getrusage(RUSAGE_CHILDREN)` 统计哪些子进程？是累计还是单个？`ru_maxrss` 在 Linux 与 macOS 单位各是什么？想拿单个子进程的用量怎么办？
::: sol 答案
只统计**已经 wait 回收**的子进程，且是**累计值**（含此前所有已回收子进程）——子进程还没 wait 时读它是 0。`ru_maxrss` 在 **Linux 是 KB**、macOS 是字节，跨平台要换算。拿单个子进程三法：① fork 前与 wait 后各读一次相减（多子进程并发不可靠）；② `wait4(pid, &status, 0, &ru)` 直接拿该子进程的 rusage（最省事）；③ 子进程自己 `getrusage(RUSAGE_SELF)` 经管道发回（最精确但要改子程序）。`maxrss=0` 的常见原因：尚未 wait、统计的是累计、单位/平台差异。
:::
:::

::: method 回忆 14 · wait 状态怎么解码
wait 状态用了哪几个字节？`WIFEXITED`/`WIFSIGNALED`/`WIFSTOPPED` 各何时为真？退出码取哪几位？为什么不要手写位移？
::: sol 答案
实际只用最低 2 字节，但 SUSv3 没规定格式——**总是用宏**不要手写位移。`WIFEXITED` 真（正常 `_exit`）→ `WEXITSTATUS` 取退出码（仅低 8 位有效）；`WIFSIGNALED` 真（被信号杀）→ `WTERMSIG` 取信号号、`WCOREDUMP` 看是否转储；`WIFSTOPPED` 真（被信号停止，需 `WUNTRACED`）→ `WSTOPSIG`；`WIFCONTINUED`（`SIGCONT` 恢复，需 `WCONTINUED`，Linux 2.6.10+）。这几个宏互斥，只有一个为真。`_exit(42)` 的状态是 `0x2a00`（42 在 bits 8–15），不是 42。
:::
:::

## C. 内核路径与观测

::: method 回忆 15 · execve 的五阶段与 errno
`execve` 在内核里分哪几段？`ENOENT`/`EACCES`/`ENOEXEC`/`E2BIG`/`ETXTBSY` 各从哪个阶段来？提交阶段之后为什么极少失败？
::: sol 答案
五段：① 打开（`do_open_execat`）决定 `ENOENT`/`EACCES`/`ELOOP`/`ETXTBSY`；② 格式识别（`search_binary_handler`）决定 `ENOEXEC`/`ELIBBAD`；③ 参数复制（`copy_strings`）决定 `E2BIG`/`EFAULT`；④ 算新凭证（`prepare_bprm_creds`）；⑤ 提交（`begin_new_exec`：丢旧地址空间、关 CLOEXEC fd、切新 mm、装新凭证）。提交阶段之后旧地址空间已丢，无法回退，所以极少失败。`install_exec_creds` 之前进程仍持旧凭证——这是 setuid「exec 那一刻提权」的精确位置。
:::
:::

::: method 回忆 16 · `EACCES` 与 `E2BIG` 的隐藏条件
文件明明有 `x` 位为什么 exec 还 `EACCES`？`E2BIG` 有哪两个上限、各是多少？一个 200 KiB 的环境变量总量没超为什么也 `E2BIG`？
::: sol 答案
`EACCES` 要求路径上**每一级目录**都有 `x`（可搜索）位，不只是目标文件；还可能是挂载点 `noexec`、解释器无 `x`。用 `namei -l path` 一次看清整条路径。`E2BIG` 两个上限：总大小 `ARG_MAX`（本机 `getconf ARG_MAX`=2097152，约 2 MiB，由 `RLIMIT_STACK` 推导）与**单个字符串** `MAX_ARG_STRLEN`=32 页=128 KiB。一个 200 KiB 的环境变量虽总量远未到 2 MiB，但单串超 128 KiB 就直接 `E2BIG`——本机实测 errno=7。
:::
:::

::: method 回忆 17 · `/proc/{pid}/stat` 怎么解析
为什么不能按空格 split 后取第 N 个 token？正确解析起点在哪？`utime`/`stime` 单位是什么、怎么换秒？`rss` 与 `vsize` 单位各是什么？
::: sol 答案
`comm` 字段在括号里、可能含空格与 `)`，按空格 split 会让所有下标偏移。正确做法：先找**最后一个 `)`**，从它之后按位置读。`utime`/`stime` 单位是**时钟滴答**，除以 `sysconf(_SC_CLK_TCK)`（用户态 ABI 固定 100，与内核 `CONFIG_HZ` 无关）得秒，分辨率恒 10 ms。`rss` 单位是**页**（乘 `_SC_PAGESIZE`），`vsize` 单位是**字节**。僵尸时 `vsize`/`rss` 已归 0（页在 `exit_mm` 释放），`utime`/`stime` 仍有效。本机实测僵尸 `utime=5` 滴答=0.050 s，与 `wait4` 的 `ru_utime=0.054 s` 在滴答粒度内对上。
:::
:::

::: method 回忆 18 · `exit_code` 字段与僵尸
`/proc/{pid}/stat` 第 52 字段 `exit_code` 是什么格式？什么时候才有意义？`_exit(42)` 它是多少？怎么解码？
::: sol 答案
`exit_code`（Linux 3.5+）是 **`waitpid(2)` 形式的 wait 状态**，不是「低 8 位退出码」：正常退出时退出码在 bits 8–15，被信号杀时低 7 位是信号号、bit 7 是 core 标志。只在 `state==Z`（僵尸）时有意义，进程被回收后 `/proc` 目录消失。`_exit(42)` → `0x2a00`，用 `WIFEXITED(0x2a00)` 为真、`WEXITSTATUS(0x2a00)==42` 解码，不要手写位移。本机 `stat_fields` 实测僵尸 `exit_code=0x2a00`、`wait4` 解出 code=42。
:::
:::

::: method 回忆 19 · ptrace 最小集与 TRACESYSGOOD
最小追踪两步是什么？`PTRACE_SYSCALL` 为什么停两次？为什么检查 `WSTOPSIG == (SIGTRAP|0x80)`？aarch64 上 syscall 号与返回值在哪个寄存器？
::: sol 答案
两步：子进程 `PTRACE_TRACEME` 后 exec，父进程 `PTRACE_SYSCALL` 让它在每次 syscall **入口与出口各停一次**。设 `PTRACE_O_TRACESYSGOOD` 后，syscall-stop 的信号号变成 `SIGTRAP|0x80`，才能与真正的断点/初始 exec 停止（普通 `SIGTRAP`）区分；不检查就会把断点当 syscall 边界、入口出口计数错位。x86-64 上号在 `orig_rax`、返回值在 `rax`；**aarch64 上在 `regs[8]` 与 `regs[0]`**，或直接用架构无关的 `PTRACE_GET_SYSCALL_INFO`（Linux 5.3+）。本机 aarch64 用后者真跑过：初始停 signal=5，追到 27 个 syscall 入口。
:::
:::

::: method 回忆 20 · ptrace 的权限边界
非 root 能追踪谁？`ptrace_scope=1` 进一步限到什么？本机为什么 `PTRACE_ATTACH` 父进程被拒？容器里通常要什么？
::: sol 答案
非 root 只能跟踪自己的**后代**，或目标显式 `PTRACE_TRACEME`。Yama LSM 的 `kernel.yama.ptrace_scope=1`（本机实测值）进一步只允许直系子进程——所以 `PTRACE_ATTACH` 父进程（非后代）返回 `EPERM`（本机实测 errno=1），`strace -p <别人的PID>` 也不行；取证一律「在 strace 下启动」或「子进程先 TRACEME」。容器里通常需要 `CAP_SYS_PTRACE`。`PTRACE_ATTACH` 会给目标发 `SIGSTOP`，可能改变其行为——系统编程里的「观察者效应」。
:::
:::

::: method 回忆 21 · `posix_spawn` 的形状与实现
`posix_spawn` 封装了什么？返回值是错误码还是设 `errno`？`file_actions` 与 `attrp` 各管什么？glibc 用什么实现、为什么快？
::: sol 答案
封装「fork + 在子进程做一堆文件操作 + exec」。返回**错误码**（成功 0，失败返回 `ENOENT`/`EACCES` 等），**不设 errno**——用 `perror` 前先 `errno = rc`。`file_actions` 按添加顺序在子进程执行（addopen/adddup2/addclose/addclosefrom_np 等）；`attrp` 控制信号掩码/处置、进程组、会话、调度、UID/GID。glibc 用 `clone(CLONE_VM|CLONE_VFORK)` 实现，比 fork 少一次页表复制；代价是 file_actions 运行在共享父地址空间的子进程里、只能用 async-signal-safe 实现。本机 strace 实测 `clone3({flags=CLONE_VM|CLONE_VFORK|CLONE_CLEAR_SIGHAND...})`。
:::
:::