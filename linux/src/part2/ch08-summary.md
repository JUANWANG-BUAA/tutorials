# 2.8 章末总结

## 一条主线：四个单元，一条因果链

**第一单元，exec 的边界（2.8.1–2.8.3）。** `execve` 用新程序替换当前进程的地址空间：成功**不返回**、PID 不变，失败返回 `-1` 并设 `errno`、原程序继续跑。跨过这道边界，保留的有 PID/PPID、进程组与会话、真实/有效 UID/GID、cwd 与 umask、`RLIMIT_*`、信号掩码与未决信号、没带 `FD_CLOEXEC` 的 fd、以及**被忽略的信号**（`SIG_IGN`）；丢掉的有**被捕获的信号处理器**（复位为默认）、备选信号栈、内存映射、`atexit` 处理器、POSIX 定时器。`nohup` 正是把 `SIGHUP` 设成 `SIG_IGN` 再 exec，靠「忽略跨 exec 保留」让新程序免疫终端关闭。exec 家族六个函数只差「怎么找文件」（带 `p` 查 `PATH`）与「怎么传参/环境」（`l` 列表、`v` 数组、`e` 显式 envp）；shebang 的解释器只能带**一个**参数，首行超长被静默截断。fd 默认全部继承，`FD_CLOEXEC` 是 fd 表项的属性而非打开文件的属性，`dup` 会清掉副本的这一位。

**第二单元，便利封装的代价（2.8.4–2.8.5、2.8.10）。** `system()` 替你 fork 一个子进程跑 `/bin/sh -c`、自己 wait，期间**阻塞 `SIGCHLD`、忽略 `SIGINT`/`SIGQUIT`**；它的返回值是 shell 的 **wait 状态**，不是退出码——`system("exit 3")` 返回 `0x0300`，要用 `WEXITSTATUS` 解出 3。四个问题：注入（不可信数据拼进命令串）、信号语义（你的 `SIGINT` 处理器期间不触发）、环境与 `PATH`（setuid 程序里等于交出 root shell）、线程安全（临时改全局信号处置）。`popen()` 是单向管道：`"r"` 读子进程 stdout、`"w"` 写它的 stdin，`pclose` 返回的同样是 wait 状态；`"w"` 模式下子进程输出写满管道而你不去读，就双向死锁。

**第三单元，拿到可信的结果（2.8.6–2.8.7）。** 三个来源各管一段：`waitid` 的 `siginfo_t` 给**事件原因**（`si_code` 区分 `CLD_EXITED`/`CLD_KILLED`/`CLD_DUMPED`，只有 `CLD_EXITED` 时 `si_status` 才是退出码）；`getrusage(RUSAGE_CHILDREN)` 给**已回收子进程的累计**资源（要单个子进程用 `wait4`）；`/proc/{pid}/stat` 给**实时快照**（`utime`/`stime` 以时钟滴答计，除以 `_SC_CLK_TCK`）。`ptrace` 最小集是子进程 `PTRACE_TRACEME` 后 exec、父进程 `PTRACE_SYSCALL` 让它在每次 syscall 入口与出口各停一次；`PTRACE_O_TRACESYSGOOD` 把 syscall-stop 标成 `SIGTRAP|0x80`，才能与断点区分。

**第四单元，内核深处与收口（2.8.8–2.8.15）。** `execve` 在内核里走五阶段：打开（决定 `ENOENT`/`EACCES`/`ETXTBSY`）、格式识别（决定 `ENOEXEC`）、参数复制（决定 `E2BIG`）、提交新凭证与地址空间。`EACCES` 最易误判——路径上**每一级目录**都要有 `x` 位。`close_range` 一次关闭/标记一段 fd，避开逐个 close 的性能与竞态问题。`posix_spawn` 在 glibc 2.39 上用 `clone3(CLONE_VM|CLONE_VFORK|CLONE_CLEAR_SIGHAND)` 省去页表复制（本机 `strace` 实测），返回错误码而非设 `errno`。最后十四陷阱与本章小结收口。

一句话主线：**exec 是一道有明确保留清单的边界——先搞清它保留什么/丢掉什么，再看 `system`/`popen` 把 fork+exec+wait 打包后藏起的信号与注入代价，最后用 `waitid`/`getrusage`/`/proc` 把子进程的结局读成可信的读数。**

## 每节一览

| 小节 | 核心问题 | 关键结论 | 典型陷阱 |
|:--|:--|:--|:--|
| [2.8.1](ch08.md#sec-2.8.1) | exec 替换了什么 | 成功不返回、PID 不变；忽略的信号保留、捕获的处理器复位 | 以为 exec 创建新进程；以为所有信号处置都重置 |
| [2.8.2](ch08.md#sec-2.8.2) | 怎么找程序、传参数 | 六函数只差找文件与传参；shebang 只带一个参数 | `#!/usr/bin/env python3 -u` 把 `python3 -u` 当一个路径 |
| [2.8.3](ch08.md#sec-2.8.3) | fd 怎么跨 exec | 没带 CLOEXEC 的 fd 全继承 | 以为 exec 后所有 fd 都关；以为 exec 失败会终止进程 |
| [2.8.4](ch08.md#sec-2.8.4) | `system` 返回值怎么读 | 返回 wait 状态，要 `WEXITSTATUS` 解码 | 把 `0x0300` 当 3；在 setuid 程序里用 `system` |
| [2.8.5](ch08.md#sec-2.8.5) | `popen` 怎么拿输出 | 单向管道，`pclose` 返回 wait 状态 | `"w"` 模式不读输出导致死锁 |
| [2.8.6](ch08.md#sec-2.8.6) | 怎么收退出与资源 | waitid 给原因、getrusage 给累计、/proc 给快照 | `si_code≠1` 却把 `si_status` 当退出码 |
| [2.8.7](ch08.md#sec-2.8.7) | 怎么旁观 syscall | TRACEME + SYSCALL 停两次 | 不设 TRACESYSGOOD 把断点当 syscall 边界 |
| [2.8.8](ch08.md#sec-2.8.8) | errno 从哪个阶段来 | 五阶段各有失败点 | 文件有 `x` 仍 `EACCES`（某级目录缺 `x`/noexec） |
| [2.8.9](ch08.md#sec-2.8.9) | 怎么原子控制 fd | `O_CLOEXEC` 原子；`close_range` 批量 | 先 open 再 fcntl 的非原子泄漏窗口 |
| [2.8.10](ch08.md#sec-2.8.10) | system/popen 动了哪些信号 | 阻塞 SIGCHLD、忽略 SIGINT/SIGQUIT | `system` 返回后 `waitpid(-1)` 得 `ECHILD` |
| [2.8.11](ch08.md#sec-2.8.11) | stat 字段怎么解析 | 先找最后一个 `)`；滴答除 `_SC_CLK_TCK` | 按空格 split 取第 N 个 token（comm 含空格就错位） |
| [2.8.12](ch08.md#sec-2.8.12) | 现代接口怎么用 | spawn 用 clone(VM\|VFORK)、返回错误码 | spawn 失败却读旧 `errno` |
| [2.8.13](ch08.md#sec-2.8.13) | 怎么把结论变读数 | strace 看序列、stat 与 ps 对照 | 把 strace 的 `execve=0` 当成「返回了」 |
| [2.8.14](ch08.md#sec-2.8.14) | 哪些坑最常踩 | 十四陷阱现象→原因→修复 | 见正文清单 |
| [2.8.15](ch08.md#sec-2.8.15) | 本章出口在哪 | 七条达标线 | 展开在[自检表](ch08-checklist.md) |

## 看到问题先选工具

| 你看到的现象 | 先选什么 | 落点 |
|:--|:--|:--|
| exec 失败、不知为何 | 读 `errno` + `strace -e trace=execve,execveat ./prog`，对照失败矩阵 | [2.8.8](ch08.md#sec-2.8.8) |
| 子进程继承了不该有的 fd | `ls -l /proc/<pid>/fd`，用 `close_range`/`O_CLOEXEC` 收口 | [2.8.9](ch08.md#sec-2.8.9) |
| `system()` 返回值「不对」 | 别直接比较，用 `WIFEXITED`/`WEXITSTATUS`/`WIFSIGNALED` 解码 | [2.8.4](ch08.md#sec-2.8.4) |
| 子进程疑似被信号杀 | `waitid` 看 `si_code`（`CLD_KILLED`/`CLD_DUMPED`）与 `si_status` | [2.8.6](ch08.md#sec-2.8.6) |
| 想知道子进程用了多少 CPU/内存 | `wait4` 拿单个 `rusage`；`/proc/<pid>/stat` 的 utime/stime 看实时 | [2.8.6](ch08.md#sec-2.8.6)、[2.8.11](ch08.md#sec-2.8.11) |
| `pclose` 偶发 `ECHILD` | 查是不是 `SIGCHLD` 处理器抢先回收了子进程 | [2.8.10](ch08.md#sec-2.8.10) |
| shebang 脚本启动失败 | `head -1 \| xxd` 看首行：CRLF、超长截断、解释器不存在 | [2.8.2](ch08.md#sec-2.8.2)、[2.8.8](ch08.md#sec-2.8.8) |

## 只记一件事

**exec 换的是「进程里装的是什么」，不是「这个进程是谁」。** PID、凭证、没带 CLOEXEC 的 fd、被忽略的信号都跨过边界保留；地址空间、捕获的处理器、内存映射全部丢掉。这一条记牢，`nohup` 为什么有效、`system` 为什么危险、fd 为什么会泄漏、`wait` 收的到底是谁的结局，就都有了同一个根。

## 六页怎么用

1. **[章总览](ch08-overview.md)**：先看四单元一览与「环境口径」，确认 aarch64 与 `ptrace_scope=1` 的边界。
2. **[章末总结](ch08-summary.md)**（这一页）：合上正文读一遍，把每节一览当目录自查。
3. **[闭卷回忆卡](ch08-recall.md)**：只看问题作答，三种结果（对/含糊/错），下一轮只做含糊与错的。
4. **[习题集](ch08-exercises.md)**：A 概念、B 推理、C 实操；C 组在这台 aarch64 VM 上真跑过，每题先猜再跑。
5. **[学习目标自检表](ch08-checklist.md)**：接管 [2.8.15 本章小结](ch08.md#sec-2.8.15)原有的七条达标线，按概念/动手/实验/口径四组逐条当场做。
6. **[勘误与版本注记](ch08-errata.md)**：shebang 上限、`execveat`/`close_range` 版本、aarch64 syscall 号、glibc 2.39 实现路径都随内核与架构变，抄数字前先看这一页。

## 下一站

[2.9 进程凭证、用户、组与能力](ch09.md) 回答「exec 之后你是谁」：真实/有效/保存 UID 如何决定权限，setuid 程序为什么要先降权再干活。往回查：[2.7 进程创建与终止](ch07.md) 的 `fork`/`wait` 是本章的直接前置；[2.10 信号](ch10.md) 的处置与掩码是「忽略保留/捕获复位」的基础。

自检入口：先做[闭卷回忆卡](ch08-recall.md)，再用[学习目标自检表](ch08-checklist.md)逐条打勾；手上读数与正文对不上时，回[勘误页](ch08-errata.md)确认它是不是本来就不属于这台机器。