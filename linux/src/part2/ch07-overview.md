# 2.7 进程创建与终止 · 本章导航

::: preview 这一章在讲什么
[2.6](ch06.md) 之前你都在操作「一个进程内部的文件」，从这一章起主角换成**进程本身**：它怎么被创建、怎么结束、结束后谁来收尸。Unix 的进程模型只有两个原语——`fork()` 复制当前进程、`execve()` 替换当前程序（[2.8](ch08.md)），所有 shell、服务管理器、容器运行时都是这两条加 `wait()` 的组合。这一章给你一张地图：`fork` 的「复制」是逻辑上的，物理内存靠写时复制延迟分配；`exit` 的「结束」也不是一瞬间，进程先变僵尸、等父进程确认后才消失。主线一句话：**创建与销毁都是协议，不是函数调用**——父子之间有继承规则、有 `SIGCHLD` 通知、有 `wait` 回收义务，漏掉任何一环，症状都不是报错，而是僵尸堆积、fd 泄漏、内存慢慢翻倍。
:::

## 本章回答什么

- **`fork` 到底复制了什么**：返回值为什么「调用一次、返回两次」；地址空间、fd 表、信号处置、定时器、锁各自是复制、共享还是清零（2.7.1）。
- **「复制」为什么不是真复制**：写时复制（copy-on-write, COW）在哪一刻才真正分配物理页；为什么 RSS 不翻倍也可能发生了大量 COW；`MAP_PRIVATE` 与 `MAP_SHARED` 的分野（2.7.2）。
- **多线程里 `fork` 为什么危险**：只复制调用线程，别的线程持有的锁被「定格」在子进程里；为什么 fork 后只能调 async-signal-safe 函数（2.7.3）。
- **创建变体怎么选**：`vfork` 的怪异语义、`clone` 的 flags 组合、`posix_spawn` 的封装边界（2.7.4）。
- **终止的两条路**：`exit()` 四步与 `_exit()` 一步差在哪；stdio 缓冲区被复制导致的重复输出；退出码为什么只有低 8 位（2.7.5）。
- **死后谁来收**：僵尸占的是什么、为什么 `kill -9` 杀不死；孤儿过继给谁；`wait`/`waitpid`/`waitid`/`wait4` 各能等到什么；`SIGCHLD` 为什么会合并（2.7.6）。
- **落到内核与全选项**：`kernel_clone()`→`copy_process()` 的复制顺序与失败回滚；`waitid` 的 `idtype`、事件位、`WNOWAIT`、`P_PIDFD` 与 `siginfo_t` 口径（2.7.7–2.7.8）。

## 读完你会

- 画出 `fork()` 后地址空间、fd 表、信号处置的继承关系，分清「复制」「共享」「清零」三类对象。
- 用 COW 区分驻留页计数（RSS）与实际物理页，手算 4 页例题的 RSS/PSS，解释「内存翻倍」从哪来。
- 写出不重复 flush、不泄漏僵尸的父进程循环：`waitpid` 四个事件位、`SIGCHLD` 处理器里的 `while (waitpid(-1, &st, WNOHANG) > 0)`。
- 说出多线程程序里 `fork` 的死锁窗口，并选对 `posix_spawn`／「fork 后立刻 exec」／线程三条路。
- 用 `waitid` 的 `si_code`/`si_status` 区分退出、被杀、停止、继续，用 `WNOWAIT` 先看后收。
- 在 aarch64 机器上用 `strace` 认出 `fork` 实际走 `clone`、`posix_spawn` 实际走 `clone3`，不拿 x86-64 常识套 ARM。

## 先修与预计学时

- 进程与地址空间：[1.8 异常控制流](../part1/ch08.md) 的进程抽象；[2.2 文件 I/O](ch02.md) 的 fd 模型与打开文件描述（本章「偏移共享」的前提）。
- 原子性与锁：[2.3 高级文件 I/O](ch03.md) 的 `O_APPEND`、记录锁与 `flock`（继承清单里两把锁语义不同）。
- 阅读：约 90 分钟（9 节，正文有 11 个可编译程序）。动手实验：约 50 分钟（全部免 `sudo`）。章末习题：约 55 分钟。

## 这条主线怎么走

**第一段，创建与继承（2.7.1–2.7.2）。** 先把 `fork` 的返回值三分支记牢，再逐项过继承清单：哪些复制、哪些共享、哪些清零。然后戳破「复制」这个词——COW 让 fork 只复制页表、把私有可写页标只读，任一方写入才真正分裂。这一段结束你应该能解释「为什么 fork 一个 8 GiB 进程不会立刻吃掉 8 GiB」。

**第二段，创建的变体与危险区（2.7.3–2.7.4）。** 多线程程序里 `fork` 只复制调用线程，别的线程的锁被定格，子进程一拿就永久阻塞——所以 fork 后到 exec 前只能调 async-signal-safe 函数。然后是三条创建变体：`vfork`（借地址空间、父挂起）、`clone`（flags 决定共享什么，线程与进程同源）、`posix_spawn`（fork+exec 的封装）。

**第三段，终止与回收义务（2.7.5–2.7.6）。** `exit()` 是库函数走四步（atexit→flush→删临时文件→`_exit`），`_exit()` 是系统调用直接进内核。进程死后先变僵尸，占着 PID 与 `task_struct` 等父进程 `wait`；父先死则过继给 init/subreaper。`SIGCHLD` 是通知不是队列——会合并，处理器里必须 `while` 循环回收。

**第四段，内核路径与 wait 全景（2.7.7–2.7.9）。** 从用户态一次 `fork` 落到 `kernel_clone()`→`copy_process()` 的复制顺序与回滚链；再把 `wait` 家族的全选项摊开：`waitpid` 四种 pid 语义、`waitid` 的 idtype 与事件位、`WNOWAIT` 先看后收、`P_PIDFD` 防 PID 复用。末节 2.7.9 是本章小结，逐条达标线收在[自检表](ch07-checklist.md)。

一句话主线：**创建与销毁都是协议——继承规则决定子进程拿到什么，`SIGCHLD` 决定父进程何时知道，`wait` 决定资源何时真正释放；三者缺一，泄漏就慢慢发生。**

## 本章路线：四个单元，一条主线

| 单元 | 小节 | 这一单元回答什么 |
|:--|:--|:--|
| **一、创建与继承** | [2.7.1](ch07.md#sec-2.7.1)、[2.7.2](ch07.md#sec-2.7.2) | `fork` 返回什么、复制/共享/清零哪些对象？COW 何时才真正复制物理页？ |
| **二、变体与危险区** | [2.7.3](ch07.md#sec-2.7.3)、[2.7.4](ch07.md#sec-2.7.4) | 多线程 `fork` 为什么死锁？`vfork`/`clone`/`posix_spawn` 怎么选？ |
| **三、终止与回收** | [2.7.5](ch07.md#sec-2.7.5)、[2.7.6](ch07.md#sec-2.7.6) | `exit`/`_exit` 差在哪？僵尸怎么回收、孤儿去了哪、`SIGCHLD` 怎么用？ |
| **四、内核与 wait 全景** | [2.7.7](ch07.md#sec-2.7.7)–[2.7.9](ch07.md#sec-2.7.9) | `kernel_clone`→`copy_process` 按什么顺序复制？`waitid` 全选项怎么组合？ |

## 小节一览

| 小节 | 标题 | 一句话 | 本机（免 `sudo`）能做到什么 |
|:--|:--|:--|:--|
| [2.7.1](ch07.md#sec-2.7.1) | `fork()` 的返回值与继承清单 | 调用一次返回两次；复制/共享/清零三类 | 全部可做 |
| [2.7.2](ch07.md#sec-2.7.2) | 写时复制：页表、引用计数与断裂点 | 先共享后分裂，写才复制 | 全部可做（`cow_probe`、smaps 读数） |
| [2.7.3](ch07.md#sec-2.7.3) | 多线程程序中的 `fork()` | 只复制调用线程，锁被定格 | 全部可做（死锁已确定性复现：`signal 14` vs 加钩子后 `exit 0`） |
| [2.7.4](ch07.md#sec-2.7.4) | `vfork()`、`clone()` 与 `posix_spawn()` | 三条创建变体一个决策表 | 全部可做（`strace` 认 flags） |
| [2.7.5](ch07.md#sec-2.7.5) | `exit()`、`_exit()` 与退出处理程序 | 库函数四步 vs 系统调用一步 | 全部可做（`exit_vs_exit`） |
| [2.7.6](ch07.md#sec-2.7.6) | 僵尸、孤儿与 `wait` 家族 | 死后先变僵尸，等父收尸 | 全部可做（`reap_children`、`ps` 看 Z） |
| [2.7.7](ch07.md#sec-2.7.7) | `fork()` 的内核路径 | `kernel_clone`→`copy_process` 顺序与回滚 | 代码级结论；`strace` 认调用可做 |
| [2.7.8](ch07.md#sec-2.7.8) | `wait` 家族的全选项 | `waitid` 的 idtype/事件位/`WNOWAIT` | 全部可做（`waitid_peek`） |
| [2.7.9](ch07.md#sec-2.7.9) | 本章小结 | 三条判据 + 5 问章级自测 | 达标线展开在[学习目标自检表](ch07-checklist.md) |

## 怎么读

- **第一次读**：2.7.1–2.7.2 一口气读完，边读边画「复制/共享/清零」三栏表与 COW 三时刻图；然后跑 `cow_probe` 与 `exit_vs_exit`，先见过现象再读语义。
- **只想排障**：僵尸堆积看 [2.7.6](ch07.md#sec-2.7.6)；fork 后内存翻倍看 [2.7.2](ch07.md#sec-2.7.2)；多线程服务 fork 后卡死看 [2.7.3](ch07.md#sec-2.7.3)；子进程重复输出看 [2.7.5](ch07.md#sec-2.7.5)。
- **准备面试或课程考试**：四处必答——`fork` 继承清单（2.7.1）、COW 断裂点与 RSS/PSS（2.7.2）、`exit`/`_exit` 四步（2.7.5）、僵尸回收与 `SIGCHLD` 合并（2.7.6）。先做[习题集](ch07-exercises.md) A 组。
- **写 shell / 服务管理器 / 容器运行时**：必读 [2.7.6](ch07.md#sec-2.7.6)（回收义务）、[2.7.7](ch07.md#sec-2.7.7)（`clone` flags 与命名空间）、[2.7.8](ch07.md#sec-2.7.8)（`P_PIDFD` 防 PID 复用）。
- **怕数字搬家**：`fork` 走哪个系统调用、`posix_spawn` 用 `clone` 还是 `clone3`、`CLD_*` 常量值都随架构与 glibc 版本变。逐条列在[勘误与版本注记](ch07-errata.md)，引用任何调用号或常量前先读那一页。

## 环境口径

- **测试 VM**：Ubuntu 24.04.5，**aarch64（ARM64，不是 x86-64）**、内核 `7.0.0-38-generic`、GCC 13.3.0、glibc 2.39、4 vCPU、页大小 4096；`/` 与 `/tmp` 在 `/dev/sda2` **ext4** 上，cgroup v2。本章实验都在这台机器上跑过。
- **aarch64 没有 `fork`/`vfork` 系统调用**：`grep __NR_fork /usr/include/asm-generic/unistd.h` 为空，`__NR_clone` 是 220。`fork()` 与 `vfork()` 都由 glibc 包装成 `clone`（本机 `strace` 实测），别拿 x86-64 的 `__x64_sys_fork` 套 ARM。
- **`sudo` 不可用**（需要密码）：`clone` 的 `CLONE_NEWPID`/`CLONE_NEWUSER` 等特权 flag、`clone3` 的 `set_tid`（要 `CAP_CHECKPOINT_RESTORE`）一律按「需 root，本机未实测」读。`PR_SET_PDEATHSIG` 设在自己子进程上免特权，已实测。
- **`perf` 计数器不可用**；`ptrace_scope=1`、`dmesg_restrict=1`：跨进程 `strace -p` 被挡，取证一律「在 strace 下启动」。
- **工具可用性**：`strace`、`lsof`、`gcc` 已装；临时文件统一 `lab2c7_` 前缀。

## 路线标签与项目回链

- **应用/运维：必读** [2.7.5](ch07.md#sec-2.7.5)、[2.7.6](ch07.md#sec-2.7.6)。僵尸堆积、`fork` 返回 `EAGAIN`、服务重启才释放资源都在这两节；**可后补** [2.7.7](ch07.md#sec-2.7.7)。
- **系统编程：必读** [2.7.1](ch07.md#sec-2.7.1)、[2.7.3](ch07.md#sec-2.7.3)、[2.7.4](ch07.md#sec-2.7.4)、[2.7.8](ch07.md#sec-2.7.8)。继承清单与 `wait` 家族是 [2.8](ch08.md)（exec）、[2.10](ch10.md)（信号）、[2.12](ch12.md)（线程）的地基；**可后补** [2.7.2](ch07.md#sec-2.7.2) 的内核细节。
- **内核/性能：必读** [2.7.2](ch07.md#sec-2.7.2)、[2.7.7](ch07.md#sec-2.7.7)。COW 页表层实现、`copy_process` 复制顺序与回滚、`clone` flags 位表都在这里；**可后补** [2.7.8](ch07.md#sec-2.7.8) 的 `do_wait` 控制流。
- **项目回链**：[项目 A](../projects/pa.md) 的 `mycontainer` 把 2.7 列为前置——「容器里 PID 1 不回收僵尸」「`clone` 进新 PID 命名空间」的判据在本章 [2.7.6](ch07.md#sec-2.7.6) 与 [2.7.7](ch07.md#sec-2.7.7)；[项目 D](../projects/pd.md) 的 `mysh` 靠 `fork`+`exec`+`wait` 跑命令、靠 `WUNTRACED`/`WCONTINUED` 做作业控制，判据在 [2.7.6](ch07.md#sec-2.7.6) 与 [2.7.8](ch07.md#sec-2.7.8)；`myhttpd` 的 prefork worker 模型回链 [2.7.1](ch07.md#sec-2.7.1) 的继承清单。

## 章末件

[章末总结](ch07-summary.md) · [闭卷回忆卡](ch07-recall.md) · [习题集](ch07-exercises.md) · [学习目标自检表](ch07-checklist.md) · [勘误与版本注记](ch07-errata.md)

## 这一章的依据

| 母本 | 章节 | 主要落点 |
|:--|:--|:--|
| **K**（Linux/UNIX 系统编程手册） | 第 6 章（进程、进程号、内存布局、虚拟内存）、第 24 章（fork、文件共享、COW、vfork、竞争条件）、第 25 章（exit/_exit、退出处理程序、stdio 交互）、第 26 章（wait 家族、僵尸孤儿、SIGCHLD）、第 28 章（clone flags、fork 成本） | 2.7.1–2.7.8；父子文件共享、COW 语义、`exit` 四步、`waitid` 的 `si_pid==0` 口径为重点 |
| **C**（深入理解计算机系统） | 第 8 章 8.2–8.4（进程、系统调用错误处理、进程控制） | 2.7.1、2.7.5–2.7.6：进程抽象与 fork/wait/exit 的程序视角（扫描版无文本层，按章节结构核对，未引用页内具体表述） |
| **O**（操作系统导论） | 第 4–5 章（进程抽象、进程状态、进程 API、fork/exec 分离的设计动机） | 2.7.1、2.7.6：运行/就绪/阻塞状态机、僵尸是「最终状态」、fork 与 exec 分离让 shell 能在两步之间重定向 |
| **G**（鸟哥的 Linux 私房菜） | 第 16 章（程序管理与 SELinux 初探） | 2.7.6：`ps` 状态位、僵尸的命令行观测 |
| **man-pages / 本机内核 7.0** | `clone(2)`、`clone3(2)`、`waitid(2)`、`prctl(2)`、`posix_spawn(3)` | 2.7.4、2.7.7–2.7.8：aarch64 调用号、`CLD_*` 常量、`P_PIDFD`、`PR_SET_PDEATHSIG` 按 man 页与本机实测补充 |

> K 的中文版覆盖到 Linux 3.2：`clone3`、`P_PIDFD`、`CLONE_CLEAR_SIGHAND`、`CLONE_INTO_CGROUP` 都在它之后；`posix_spawn` 在 glibc 2.39 上改用 `clone3` 实现、aarch64 上 `fork` 走 `clone`（调用号 220）这两条是本机实测的版本敏感事实，以[勘误页](ch07-errata.md)为准。