# 2.7 勘误与版本注记

这一页收本章最容易「换一个架构、换一个 glibc 版本、换一台机器就不成立」的东西：`fork` 走哪个系统调用、`posix_spawn` 用 `clone` 还是 `clone3`、`CLD_*` 常量值、`waitid` 的返回口径、`PR_SET_PDEATHSIG` 的行为。正文每节里的 errata 盒讲**理解陷阱**（把 A 当成 B）；这一页讲**搬家陷阱**（在 x86-64 上成立、到 aarch64 上悄悄变）。页内所有实测读数都来自下面这台机器，**任何别的机器上的数字都不能引用**——引用调用号或常量必须带上它属于哪个架构、哪个 glibc、哪个内核。

**本章基线**：Ubuntu 24.04.5 虚拟机，**aarch64（ARM64）**，内核 `7.0.0-38-generic`，GCC 13.3.0，glibc 2.39，4 vCPU，页大小 4096；`/` 与 `/tmp` 在 `/dev/sda2` **ext4** 上，cgroup v2（`cgroup2fs`）。`sudo` 与 `perf` 不可用；`ptrace_scope=1`、`dmesg_restrict=1`。写作机是 macOS（Apple 芯片 arm64）：没有 `/proc`、没有 `strace`、`ru_maxrss` 单位也不同，只当「换一个系统会怎样」的对照，正文实验一律回 Linux 做。

## 1. 容易搬家的结论

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「`fork()` 就是 `fork` 系统调用」 | **aarch64 没有 `fork`/`vfork` 系统调用**：`asm-generic/unistd.h` 里 `__NR_fork` 不存在、`__NR_clone`=220。glibc 把 `fork()` 包装成 `clone(SIGCHLD\|CLONE_CHILD_CLEARTID\|CLONE_CHILD_SETTID)`、`vfork()` 包装成 `clone(CLONE_VM\|CLONE_VFORK\|SIGCHLD)`。正文 2.7.7 的 `__x64_sys_fork` 只适用于 x86-64 | `grep __NR_fork /usr/include/asm-generic/unistd.h`（本机计数 0）；`strace -e trace=clone,clone3,fork,vfork ./prog` 看实际调用 |
| 「`posix_spawn` 用 `clone(CLONE_VM\|CLONE_VFORK)` 实现」 | 这是老 glibc 的做法。**本机 glibc 2.39 实测走 `clone3`**，flags=`CLONE_VM\|CLONE_VFORK\|CLONE_CLEAR_SIGHAND`、带 `stack_size`。`CLONE_CLEAR_SIGHAND` 是 Linux 5.5+ 才有的 flag，老书不会提 | `strace -f -e trace=clone,clone3 ./spawn_prog`；对照 glibc 版本 `ldd --version` |
| 「`CLD_STOPPED` 是 2」 | **本机 glibc 2.39：`CLD_STOPPED`=5**，2 是 `CLD_KILLED`。完整：EXITED=1、KILLED=2、DUMPED=3、TRAPPED=4、STOPPED=5、CONTINUED=6。常量值由 `<sys/wait.h>` 提供，代码应用宏不要硬编码 | 写程序 `printf("%d", CLD_STOPPED)`；`raise(SIGSTOP)` 的进程 `waitid(WSTOPPED)` 实测 `si_code=5` |
| 「`waitid` 在 `WNOHANG` 无子进程可等时返回 0」 | 要分两种：**有匹配子进程但无状态事件**→返回 0、`si_pid==0`；**根本没有匹配子进程**→返回 -1、`errno=ECHILD`。正文一句话糊在一起容易读错 | 活子进程未退出时 `waitid(WEXITED\|WNOHANG)` 得 rc=0/si_pid=0；全部回收后再调得 rc=-1/ECHILD |
| 「`si_status` 就是退出码」 | 由 `si_code` 决定：`CLD_EXITED` 时是退出码（0–255），`CLD_KILLED`/`CLD_DUMPED` 时是**信号号**，`CLD_STOPPED` 时是停止信号，`CLD_CONTINUED` 时是 SIGCONT。被 SIGTERM 杀 `si_status=15` 不是「退出码 15」 | `raise(SIGTERM)` 的子进程 `waitid(WEXITED)` 实测 `si_code=2 si_status=15` |
| 「`PR_SET_PDEATHSIG` 要特权 / 不可靠」 | 设在**自己的子进程**上免特权，本机实测有效：父进程退出后子进程收到 SIGTERM 被杀。但顺序必须**先 prctl 再查 getppid**（父死在两步之间时信号不补发）；PDEATHSIG 在 fork 时被清零、随父**线程**死亡触发 | 子进程 `prctl(PR_SET_PDEATHSIG,SIGTERM)` 后 sleep，父进程立刻 exit，观察子进程是否被杀（本机：无「survived」输出） |
| 「`ru_maxrss` 单位到处一样」 | **Linux 上是 KiB**，macOS/BSD 上是字节，差 1024 倍。跨平台代码要 `#ifdef` 处理 | `man 2 getrusage` 的 NOTES 段；本机 Linux 读数为 KiB，macOS 字节口径未在本机重跑 |
| 「`vfork` 是更快的 fork」 | 它是「借父进程地址空间的 fork」：共享页表与栈、父进程挂起到子进程 exec/`_exit`。子进程改变量/`return`/`exit` 都破坏父进程。SUSv3 标记过时、**SUSv4 已删除**，现代代码用 `posix_spawn` | Kerrisk 第 24.3 节；`strace` 看 `CLONE_VM\|CLONE_VFORK`；`man 2 vfork` 的 HISTORY |
| 「fork 后 RSS 没翻倍就是没复制」 | COW 是「替换映射」不是「保留两份」：子进程写后 RSS 可能不变但物理页已翻倍。要看 `smaps` 的 `Private_Dirty`/`Shared_Dirty` 或 PSS，不能只看 RSS | 本机 64 MiB 实测：fork 后 `Shared_Dirty`=65536、子写后双方 `Private_Dirty` 各 65536（物理翻倍到 128 MiB） |

## 2. 复跑校正（2026-11-08，同一台 aarch64 VM）

下表只列**在这台 7.0.0-38 aarch64 VM、glibc 2.39 上真实跑出来**的项。方法：实验程序按 `gcc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2` 编译，文件统一 `/tmp/lab2c7_` 前缀。PID、地址、文件名后缀每次运行都不同，记的是关系不是具体值。

| 正文原写法 | 本机实测 | 结论 |
|:--|:--|:--|
| 2.7.7 「x86-64 上走 `syscall` 进入 `__x64_sys_fork`」 | `grep -c __NR_fork`=0、`__NR_clone`=220；`strace` 下 `fork()`→`clone(flags=CLONE_CHILD_CLEARTID\|CLONE_CHILD_SETTID\|SIGCHLD)`、`vfork()`→`clone(CLONE_VM\|CLONE_VFORK\|SIGCHLD)` | 正文口径限 x86-64；aarch64 上 fork/vfork 都走 clone(220)，应补一句架构差异 |
| 2.7.4/2.7.7 「`posix_spawn` 用 `clone(CLONE_VM\|CLONE_VFORK)` 实现」 | `strace` 下 `posix_spawn(/bin/true)`→`clone3({flags=CLONE_VM\|CLONE_VFORK\|CLONE_CLEAR_SIGHAND, exit_signal=SIGCHLD, stack_size=0x9000}, 88)` | glibc 2.39 改用 clone3，且多一个 CLONE_CLEAR_SIGHAND；正文应加版本条件 |
| 2.7.8 `waitid_peek` 输出块「stopped : code=2」与「CLD_STOPPED 在 glibc 里是 2」 | 打印常量：`CLD_STOPPED=5`、`CLD_KILLED=2`；`raise(SIGSTOP)` 实测 `si_code=5 si_status=19` | **正文常量写错**：stopped 的 si_code 应是 5（CLD_STOPPED），2 是 CLD_KILLED；输出块与解说都要改 |
| 2.7.6 「`waitid` 在 `WNOHANG` 且无子进程可等时返回 0」 | 活子进程无事件：`rc=0 si_pid=0`；无子进程：`rc=-1 errno=10(ECHILD)` | 正文应区分「无事件返回 0」与「无子进程返回 -1/ECHILD」两种 |
| 2.7.2 COW 与 RSS/PSS | 64 MiB 私有匿名映射：fork 前 `Private_Dirty=65536`；fork 后未写 `Private_Dirty=0 Shared_Dirty=65536`；子写后双方 `Private_Dirty` 各 65536 | 与正文 COW 结论一致，smaps 给出「物理翻倍」的直接读数 |
| 2.7.1 fd 偏移共享 | 子进程写 100 字节（offset=100）再 lseek 到 500，父进程 waitpid 后读出 offset=500 | 与正文一致：偏移在共享的 `struct file` 里 |
| 2.7.6 僵尸与回收 | `ps -o stat` 显示 Z；`kill -9` 返回 0 但僵尸仍在；`waitpid` 后 `ps` 返回 1（消失） | 与正文一致：僵尸占 PID 不占内存、kill -9 无效 |
| 2.7.5 stdio 重复输出 | 重定向到文件：`_exit` 版 `buffered-before-fork` count=1、`exit` 版 count=2（两个 atexit PID） | 与正文一致 |
| 2.7.6 `PR_SET_PDEATHSIG` | 子进程设 SIGTERM 后 sleep，父进程立刻 exit；子进程被杀（无「survived」输出） | 免特权有效；印证「先 prctl 再查 getppid」的必要性 |

## 3. 本章未实测项

下面这些在这台 VM 上拿不到证据，引用时一律当**待验证的机制结论**，不要抄成读数：

- **多线程 fork 的 malloc 死锁确定性复现**：它是概率事件（取决于 fork 那一刻别的线程是否持锁），共享机器上不宜做高强度压力复现；且 `ptrace_scope=1` 挡住 `gdb -p`/`strace -p` 附加别人的进程。正文 2.7.3 的死锁窗口按机制结论读，观测方法（栈停在 `__lll_lock_wait`）写在[习题 B3](ch07-exercises.md)。
- **`clone` 的特权 flag**：`CLONE_NEWPID`/`CLONE_NEWUSER`/`CLONE_NEWNS` 等要 `CAP_SYS_ADMIN`，`sudo` 不可用，全部按「需 root，本机未实测」。
- **`clone3` 的 `set_tid`**：指定容器内 PID 要 `CAP_CHECKPOINT_RESTORE`（或 `CAP_SYS_ADMIN`），本机不可做，`EPERM` 来源按 man 页读。
- **`RLIMIT_NPROC`/`pids.max` 耗尽的 `EAGAIN` 现场**：构造它要把共享机器的进程配额打满，影响别的代理，未在本机复现；机制结论（按真实 UID 统计、cgroup 独立计数）照 Kerrisk 与 man 页读。
- **容器内 PID 1 回收对照**：docker 免 sudo 可用但未把本章程序搬进容器跑；「PID 1 不回收僵尸」留待第 5 篇与项目 A1。
- **CSAPP 第 8.2–8.4 节的具体表述**：中文第 3 版是扫描版、无文本层，本机 tesseract 无 `chi_sim` 不能 OCR；只按 `source-toc/clean-csapp.md` 的章节结构（8.2 进程、8.3 系统调用错误处理、8.4 进程控制）核对，未引用页内具体句子或数字。
- **`ru_maxrss` 的 macOS 字节口径**：本机是 Linux（KiB），macOS/BSD 的字节单位是 man 页结论，未在 macOS 重跑对照。

## 4. 发现新问题怎么记

按「**现象 → 命令与输出 → 机器/架构/glibc/内核 → 建议改法**」四段写，缺第四段就没有可比较的基准：

1. **现象**：一句话说清谁看起来坏了。例：「`strace` 一个 fork 程序，看到的不是 `fork` 而是 `clone`」。
2. **命令与输出**：贴**原样敲的命令**与**未经删减的输出**（含调用号、flags、errno 数字）。
3. **机器口径**：至少附 `uname -m`、`uname -r`、`ldd --version | head -1`、`grep __NR_clone /usr/include/asm-generic/unistd.h`；涉及 `posix_spawn`/`CLD_*` 的附 glibc 版本。
4. **建议改法**：写「该改成什么动作」。例：「正文 2.7.7 应补『aarch64 上 fork 走 clone(220)，无独立 fork 系统调用』」。

归类再说话：**规范条款**（退出码低 8 位、vfork 被 SUSv4 删除）、**本机读数**（`__NR_clone`=220、CLD_STOPPED=5、smaps 65536）、**随架构/glibc/内核变的量**（fork 走哪个调用、posix_spawn 用 clone 还是 clone3、`CLONE_CLEAR_SIGHAND` 支持面）、**未实测**（写清为什么没测）。本章最常见的分歧有两种：把 x86-64 的系统调用常识套到 aarch64，以及把「`si_status`」一律当退出码而不看 `si_code`。