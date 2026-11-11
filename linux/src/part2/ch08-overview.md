# 2.8 程序执行与子进程监控 · 本章导航

::: preview 这一章在讲什么
[2.7](ch07.md) 用 `fork` 复制出一个「和自己一样」的进程，但复制不是目的——**换程序**才是。shell 每敲一条命令，都是 fork 之后立刻 exec：进程号不变，地址空间里的代码与数据被整个换掉。这一章给你一张「exec 边界」的地图：跨过去时哪些东西保留（PID、凭证、没带 `FD_CLOEXEC` 的 fd、被忽略的信号）、哪些东西丢掉（捕获的信号处理器、内存映射、POSIX 定时器）；中间夹着 `system()`/`popen()` 这两个替你打包 fork+exec+wait 的便利函数，以及它们藏起来的注入与信号代价；最后是怎么拿到**可信的**退出状态与资源用量。主线一句话：**fork 之后换程序，换完之后收结果**——先搞清 exec 保留什么/丢掉什么，再看便利函数替你做了什么、代价是什么，最后用 `waitid`/`getrusage`/`/proc` 把「子进程到底怎么结束的」读成读数。
:::

## 本章回答什么

- **exec 替换的是什么**：`execve` 成功不返回、PID 不变；保留/重置清单里最容易记反的是「忽略的信号保留、捕获的处理器复位」（2.8.1）。
- **怎么找到并启动程序**：exec 家族六个函数只差「找文件方式」与「参数/环境来源」；`PATH` 查找的安全边界；shebang 只能带一个参数、超长被静默截断（2.8.2）。
- **fd 怎么跨 exec**：不带 `FD_CLOEXEC` 的 fd 全部继承——这是重定向能工作的基础，也是泄漏的主通道；`dup` 会清掉副本的 CLOEXEC 位（2.8.3、2.8.9）。
- **便利函数的代价**：`system()` 的返回值是 wait 状态不是退出码，它自己 fork/wait 并临时忽略 `SIGINT`/`SIGQUIT`、阻塞 `SIGCHLD`；`popen()` 是单向管道，`pclose` 返回的也是 wait 状态（2.8.4、2.8.5、2.8.10）。
- **怎么收结果**：`waitid` 的 `si_code` 区分退出与被杀，`getrusage(RUSAGE_CHILDREN)` 是「已回收子进程」的累计值，`/proc/{pid}/stat` 是实时快照、`utime` 以时钟滴答计（2.8.6、2.8.11）。
- **怎么旁观与深入**：`ptrace` 最小集（`PTRACE_TRACEME` + `PTRACE_SYSCALL`）；`execve` 在内核里的五阶段与 errno 失败矩阵；`posix_spawn` 与 `close_range` 的现代姿势（2.8.7、2.8.8、2.8.12）。

## 读完你会

- 写出 fork + exec + wait 的完整骨架，exec 失败后按 `errno` 分流并 `_exit(127/126)` 兜底。
- 背出 exec 的保留/重置清单，并用 `nohup`（忽略 `SIGHUP` 跨 exec 保留）解释它为什么有效。
- 用 `O_CLOEXEC`/`pipe2`/`dup3` 原子地控制 fd 继承，说出「先 open 再 fcntl」在多线程下的泄漏窗口。
- 正确解码 `system()`/`pclose()` 的返回值：`WIFEXITED`/`WEXITSTATUS`/`WIFSIGNALED`/`WTERMSIG`，不把 `0x0300` 当成 3。
- 用 `waitid` 的 `si_code` 区分「正常退出」与「被信号杀」，用 `wait4` 拿单个子进程的 `rusage`。
- 把 `/proc/{pid}/stat` 的 `utime`/`stime`（滴答）换算成秒，与 `getrusage` 的 `timeval` 对上；先找最后一个 `)` 再解析。
- 在 `ptrace_scope=1` 的机器上用 `PTRACE_TRACEME` 这条路追踪自己的子进程，并知道附加别人的进程为什么被拒。

## 先修与预计学时

- 进程生命周期：[2.7 进程创建与终止](ch07.md)（`fork` 复制了什么、`exit`/`_exit`、僵尸与 `wait`——本章直接续上）。
- 文件与 fd：[2.2 文件 I/O](ch02.md)（`open` flags、`errno` 纪律）、[2.3 高级文件 I/O](ch03.md)（`fcntl`、原子性）。
- 信号基础：[2.10 信号](ch10.md)（处置、掩码、`sigaction`——本章「忽略保留/捕获复位」要用）。
- 阅读：约 100 分钟（15 节，正文有 7 个可编译程序）。动手实验：约 50 分钟（全部免 `sudo`）。章末习题：约 60 分钟。

## 本章路线：四个单元，一条主线

| 单元 | 小节 | 这一单元回答什么 |
|:--|:--|:--|
| **一、exec 的边界** | [2.8.1](ch08.md#sec-2.8.1)–[2.8.3](ch08.md#sec-2.8.3) | exec 替换了什么、保留了什么？怎么找程序、fd 怎么传？ |
| **二、便利封装的代价** | [2.8.4](ch08.md#sec-2.8.4)、[2.8.5](ch08.md#sec-2.8.5) | `system`/`popen` 替你做了什么？返回值怎么读、坑在哪？ |
| **三、拿到可信的结果** | [2.8.6](ch08.md#sec-2.8.6)、[2.8.7](ch08.md#sec-2.8.7) | 怎么知道子进程怎么结束的、用了多少资源？怎么旁观 syscall？ |
| **四、内核深处与收口** | [2.8.8](ch08.md#sec-2.8.8)–[2.8.15](ch08.md#sec-2.8.15) | execve 在内核里怎么走、errno 从哪来？现代接口与陷阱清单 |

一句话主线：**先搞清 exec 这道边界保留什么/丢掉什么，再看 `system`/`popen` 把 fork+exec+wait 打包后藏起的代价，最后用 `waitid`/`getrusage`/`/proc` 把子进程的结局读成可信的读数。**

## 小节一览

| 小节 | 标题 | 一句话 | 本机（免 `sudo`）能做到什么 |
|:--|:--|:--|:--|
| [2.8.1](ch08.md#sec-2.8.1) | `execve()`：替换的是什么 | 成功不返回、PID 不变 | 全部可做（`exec_inherit`） |
| [2.8.2](ch08.md#sec-2.8.2) | exec 家族、`PATH` 与 shebang | 六个函数只差找文件与传参 | 全部可做（`strace` 看 exec 链） |
| [2.8.3](ch08.md#sec-2.8.3) | fd 继承与 `FD_CLOEXEC` | 没带 CLOEXEC 的 fd 全继承 | 全部可做（`/proc/self/fd`） |
| [2.8.4](ch08.md#sec-2.8.4) | `system()`：四个问题 | 返回值是 wait 状态 | 全部可做（`system_decode`） |
| [2.8.5](ch08.md#sec-2.8.5) | `popen()` 与单向管道 | `pclose` 返回 wait 状态 | 全部可做（SIGPIPE 实验） |
| [2.8.6](ch08.md#sec-2.8.6) | `waitid`、`getrusage` 与 `/proc` | 三路观察各管一段 | 全部可做（`spawn_stats`） |
| [2.8.7](ch08.md#sec-2.8.7) | `ptrace` 最小集 | TRACEME + SYSCALL 停两次 | TRACEME 路可做；附加别人被 scope=1 挡 |
| [2.8.8](ch08.md#sec-2.8.8) | execve 内核路径与失败矩阵 | 五阶段、每个 errno 有出处 | 失败矩阵多数可复现 |
| [2.8.9](ch08.md#sec-2.8.9) | `FD_CLOEXEC`、`close_range` 与泄漏面 | 原子设位、批量关闭 | 全部可做（`exec_fd_audit`） |
| [2.8.10](ch08.md#sec-2.8.10) | system/popen 的进程与信号真相 | 阻塞/忽略了哪些信号 | 全部可做（`exec_timeout`） |
| [2.8.11](ch08.md#sec-2.8.11) | `/proc/{pid}/stat` 字段与口径 | 52 字段、滴答换算 | 全部可做（`stat_fields`） |
| [2.8.12](ch08.md#sec-2.8.12) | `posix_spawn` 与 ptrace 进阶 | clone(CLONE_VM\|CLONE_VFORK) | 全部可做（`strace` 看 clone3） |
| [2.8.13](ch08.md#sec-2.8.13) | 两个观测实验 | strace 序列 + stat/ps 对照 | 全部可做 |
| [2.8.14](ch08.md#sec-2.8.14) | 十四个陷阱 | 现象→原因→修复 | 大部分可复现 |
| [2.8.15](ch08.md#sec-2.8.15) | 本章小结 | 三条判据 + 5 问章级自测 | 达标线展开在[自检表](ch08-checklist.md) |

## 怎么读

- **第一次读**：2.8.1–2.8.3 一口气读完，边读边跑 `exec_inherit`，先亲眼看到「PID 没变、fd 4 消失、SIGTERM 处理器复位」再读清单；然后跑 `system_decode` 看 `0x0300`。
- **只想排障**：exec 报 `EACCES`/`ENOEXEC` 看 [2.8.8](ch08.md#sec-2.8.8) 的失败矩阵；子进程继承了不该有的 fd 看 [2.8.9](ch08.md#sec-2.8.9)；`system` 返回值误读看 [2.8.4](ch08.md#sec-2.8.4)；`pclose` 偶发 `ECHILD` 看 [2.8.10](ch08.md#sec-2.8.10)。
- **准备面试或课程考试**：四处必答——exec 保留/重置清单（2.8.1）、`system` 返回值要解码（2.8.4）、`waitid` 的 `si_code` 不是退出码（2.8.6）、`getrusage` 的累计/已回收口径（2.8.6）。先做[习题集](ch08-exercises.md) A 组。
- **写 supervisor / 沙箱 / 构建工具**：必读 [2.8.8](ch08.md#sec-2.8.8)（失败矩阵）、[2.8.12](ch08.md#sec-2.8.12)（`posix_spawn` 与 ptrace 选项）、[2.8.9](ch08.md#sec-2.8.9)（`close_range` 批量关 fd）。
- **怕数字搬家**：shebang 长度上限、`execveat`/`close_range` 的内核版本、aarch64 的 syscall 号、`/proc/stat` 字段口径都随内核与架构变。逐条列在[勘误与版本注记](ch08-errata.md)，引用任何数字前先读那一页。

## 环境口径

- **测试 VM**：Ubuntu 24.04.5，**aarch64（ARM64，不是 x86-64）**、内核 `7.0.0-38-generic`、GCC 13.3.0、glibc 2.39、4 vCPU、页大小 4096；`/` 与 `/tmp` 在 `/dev/sda2` **ext4** 上。本章实验都在 ext4 上跑过。
- **`sudo` 不可用**。需特权的实验（改 `ptrace_scope`、`binfmt_misc` 注册、`PTRACE_ATTACH` 别人的进程）一律标「需 root，本机未实测」并给命令。
- **`ptrace_scope=1`**：只能附加自己的子孙进程；`PTRACE_TRACEME` 那条路可跑，`strace -p <别人的PID>`/`PTRACE_ATTACH` 非后代被 `EPERM` 挡（本机实测）。取证一律「在 strace 下启动」或「子进程先 TRACEME」。
- **`perf` 计数器不可用**、`dmesg_restrict=1`。`strace` 6.8、`lsof` 已装可用。
- **架构提醒**：正文 2.8.7 的 ptrace 寄存器例子用的是 x86-64 的 `orig_rax`/`rax`；这台 aarch64 机器上 syscall 号在 `regs[8]`、返回值在 `regs[0]`，或直接用架构无关的 `PTRACE_GET_SYSCALL_INFO`（本章 C 组用后者真跑过）。`execve` 的调用号是 **221**，不是 x86 的 59。

## 路线标签与项目回链

- **应用/运维：必读** [2.8.4](ch08.md#sec-2.8.4)、[2.8.5](ch08.md#sec-2.8.5)、[2.8.8](ch08.md#sec-2.8.8)、[2.8.14](ch08.md#sec-2.8.14)。脚本里 `system` 返回值误读、命令注入、`EACCES`/`ENOEXEC` 排障都在这几节；**可后补** [2.8.7](ch08.md#sec-2.8.7)、[2.8.11](ch08.md#sec-2.8.11)。
- **系统编程：必读** [2.8.1](ch08.md#sec-2.8.1)、[2.8.3](ch08.md#sec-2.8.3)、[2.8.6](ch08.md#sec-2.8.6)、[2.8.9](ch08.md#sec-2.8.9)、[2.8.12](ch08.md#sec-2.8.12)。exec 边界与 fd 控制是 [2.9](ch09.md)（凭证）、[2.19](ch19.md)（守护进程）的地基；**可后补** [2.8.13](ch08.md#sec-2.8.13)。
- **内核/性能：必读** [2.8.8](ch08.md#sec-2.8.8)、[2.8.10](ch08.md#sec-2.8.10)、[2.8.11](ch08.md#sec-2.8.11)。execve 五阶段、`begin_new_exec` 的提交点、`/proc/stat` 字段口径都在这里；**可后补** [2.8.7](ch08.md#sec-2.8.7)。
- **项目回链**：supervisor / 容器运行时类项目里「子进程退出码读错」「fd 泄漏进不受信子程序」「`fexecve` 在容器里报 `ENOENT`」「shebang 脚本启动失败」四类现象，判据分别在本章 [2.8.4](ch08.md#sec-2.8.4)、[2.8.9](ch08.md#sec-2.8.9)、[2.8.8](ch08.md#sec-2.8.8) 的 `fexecve` 段、[2.8.2](ch08.md#sec-2.8.2)。

## 章末件

[章末总结](ch08-summary.md) · [闭卷回忆卡](ch08-recall.md) · [习题集](ch08-exercises.md) · [学习目标自检表](ch08-checklist.md) · [勘误与版本注记](ch08-errata.md)

## 这一章的依据

| 母本 | 章节 | 主要落点 |
|:--|:--|:--|
| **K**（Linux/UNIX 系统编程手册） | 第 27 章「程序的执行」（p494–515：`execve`、exec 家族、`PATH`、shebang、fd 与 exec、信号与 exec、`system` 及其实现）、第 26 章「监控子进程」（p476–493：wait 状态值、`waitid`、`wait3`/`wait4`、SIGCHLD） | 2.8.1–2.8.6、2.8.10；exec 保留/重置清单、`system` 返回值规则与信号处理、wait 状态宏为重点 |
| **K** | 第 28 章 28.4（exec/fork 对进程属性的影响） | 2.8.1：保留/重置清单的交叉核对 |
| **C**（深入理解计算机系统） | 第 8 章 8.4「进程控制」（扫描版，按 `source-toc` 结构核对，未 OCR 具体页内数字） | 2.8.1–2.8.4：fork/exec/wait 组合的程序视角 |
| **O**（操作系统导论） | 第 5 章「插叙：进程 API」 | 2.8.1、2.8.4：fork/exec/wait 语义对照 |
| **Linux man-pages 6.7 / 内核 5.1+** | `execve(2)`、`execveat(2)`、`close_range(2)`、`system(3)`、`popen(3)`、`ptrace(2)`、`proc_pid_stat(5)`、`posix_spawn(3)` | 2.8.8–2.8.12：shebang 截断、`execveat`/`close_range` 版本、`PTRACE_GET_SYSCALL_INFO`、`exit_code` 字段等成书后新增或本机核实之处 |
| **G**（鸟哥的 Linux 私房菜） | 第 16 章（程序管理与 SELinux 初探） | 2.8.6、2.8.13：`ps`/`/proc` 观测的背景 |

> K 的中文版覆盖到 Linux 3.2：`close_range`（5.9）、`PTRACE_GET_SYSCALL_INFO`（5.3）、`execveat`（3.19）、shebang 缓冲扩到 256 字节（5.1）都在它之后；正文这些处按 man-pages 与本机 aarch64 实测写。aarch64 的 syscall 号、`/proc/stat` 字段口径、glibc 2.39 的 `system`/`posix_spawn` 实现路径换架构换版本就搬家，以[勘误页](ch08-errata.md)为准。