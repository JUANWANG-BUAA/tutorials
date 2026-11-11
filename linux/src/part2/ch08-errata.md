# 2.8 勘误与版本注记

这一页收本章最容易「换一个内核版本、换一个架构、换一台机器就不成立」的东西：shebang 首行长度上限、`execveat`/`close_range`/`PTRACE_GET_SYSCALL_INFO` 的加入版本、aarch64 的系统调用号、glibc 的 `system`/`posix_spawn` 实现路径、`/proc/stat` 字段口径。正文每节里的 errata 盒讲**理解陷阱**（把 A 当成 B）；这一页讲**搬家陷阱**（在这台机器上成立、到那台机器上悄悄变）外加**正文程序复跑发现的 bug**。页内所有实测读数都来自下面这台机器，**任何别的机器上的数字都不能引用**——引用数字必须带上它属于哪台机器、哪个内核、哪个架构。

**本章基线**：Ubuntu 24.04.5 虚拟机，**aarch64（ARM64）**，内核 `7.0.0-38-generic`，GCC 13.3.0，glibc 2.39，4 vCPU，页大小 4096；`/` 与 `/tmp` 在 `/dev/sda2` **ext4** 上。`sudo` 与 `perf` 不可用；`ptrace_scope=1`；`strace` 6.8、`lsof` 已装。man-pages 版本 6.7。写作机是 macOS（Apple 芯片 arm64）：没有 `/proc`、没有 `strace`，只当「换一个系统会怎样」的对照，正文实验一律回 Linux 做。

## 1. 容易搬家的结论

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「shebang 首行超过 127 字节就报 `ENOEXEC`」 | 两处都要改：① 上限随内核变——Kerrisk 成书时（Linux 3.2，`BINPRM_BUF_SIZE=128`）是 127 字节，**Linux 5.1 起缓冲扩到 256**，本机内核 7.0 实测首行超 **255 字节**（不含换行）才截断；② 超长是**静默截断**不是 `ENOEXEC`。正文 2.8.8 errno 表原写「shebang 行超过 127 字节→ENOEXEC」，**已于 2026-11-09 订正**为「过长是静默截断、不报 ENOEXEC」，并在 2.8.2 补了 250/254/255/256/257/300 六档实测 | 造 `#!/bin/echo ` + N 个 A 的脚本：N=243 全收到、N=244/300 都只收到 243 个 A（首行截到 255 字节）；Kerrisk §27.3（p501）记的是 127 字节旧上限 |
| 「`execveat` 是 Linux 2.6.16 加入的」 | 正文 2.8.8 原写 2.6.16，**已于 2026-11-09 订正**：`man 2 execveat` 的 HISTORY 写 **Linux 3.19、glibc 2.34**。2.6.16 是 `openat` 等 `*at` 家族的版本，别混 | `zcat /usr/share/man/man2/execveat.2.gz \| grep -A3 HISTORY`；本机 man-pages 6.7 |
| 「`execve` 的系统调用号是 59」 | 那是 **x86-64** 的号。本机 aarch64 走 `asm-generic/unistd.h`：`execve`=**221**、`execveat`=281、`close_range`=436、`wait4`=260、`ptrace`=117。正文 2.8.7 的寄存器例子（`orig_rax`/`rax`）也是 x86-64 专属 | `grep __NR_execve /usr/include/asm-generic/unistd.h`；aarch64 上 syscall 号在 `regs[8]`、返回值在 `regs[0]`，或用架构无关的 `PTRACE_GET_SYSCALL_INFO` |
| 「`system()` 用 `fork` 起子进程」 | glibc 2.39 实测走 **`clone3(CLONE_VM\|CLONE_VFORK\|CLONE_CLEAR_SIGHAND)`**（spawn 路径），不是传统 fork；`system(NULL)` 真的起一个 shell 跑 `/bin/sh -c -- "exit 0"` 来探测可用性。正文 2.8.10「用 `__posix_spawn` 或 fork」在本机落到前者 | `strace -f -e trace=clone,clone3,execve,wait4 ./lab2c8_sysnull`；Kerrisk §27.7（p509）讲的是 fork 版教学实现 |
| 「`posix_spawn` 与 `fork` 一样复制页表」 | glibc 用 `clone(CLONE_VM\|CLONE_VFORK)`，子进程**共享父地址空间**、省去页表复制；本机实测 `clone3` 带 `CLONE_VM\|CLONE_VFORK\|CLONE_CLEAR_SIGHAND`。代价是 file_actions 只能用 async-signal-safe 实现 | `man 3 posix_spawn` 的 DESCRIPTION；`strace -f -e trace=clone3,execve ./lab2c8_spawn` |
| 「`close_range` 到处都有」 | Linux **5.9** 加入、glibc **2.34** 才有包装；`CLOSE_RANGE_CLOEXEC` 要 **5.11**。容器 seccomp 默认白名单常没有它，可能 `EPERM`/`ENOSYS`，要留逐 fd 回退 | `zcat /usr/share/man/man2/close_range.2.gz \| grep -A4 HISTORY`；正文 2.8.9 的 `#ifdef SYS_close_range` 回退分支 |
| 「`fexecve` 一定依赖 `/proc`」 | 分版本：glibc **2.27** 起若内核支持就用 `execveat(fd,"",...,AT_EMPTY_PATH)`，不需要 `/proc`；**≤2.26** 才回退 `/proc/self/fd/<fd>`，极简容器没挂 `/proc` 就 `ENOENT`/`ENOSYS` | `man 3 fexecve` 的 NOTES；本机 glibc 2.39 走 execveat 路径 |
| 「`PTRACE_GET_SYSCALL_INFO` 是老接口」 | Linux **5.3** 才加入；且必须在对应 syscall-stop 发生**之前**设好 `PTRACE_O_TRACESYSGOOD`，否则 `info.op` 只给 `PTRACE_SYSCALL_INFO_NONE` | `man 2 ptrace` 的该操作段；本机内核 7.0 实测可用 |
| 「`/proc/<pid>/stat` 第 52 字段 `exit_code` 是低 8 位退出码」 | 它是 **`waitpid(2)` 形式的 wait 状态**（Linux 3.5+）：正常退出码在 bits 8–15（`_exit(42)`→`0x2a00`），要用 `WEXITSTATUS` 解码；只在 `state==Z` 时有意义 | `man 5 proc_pid_stat` 字段 52；本机 `stat_fields` 实测 `exit_code=0x2a00` |
| 「`ptrace` 想附加谁就附加谁」 | 本机 `ptrace_scope=1`：只能跟踪自己的后代或显式 TRACEME 的目标；`PTRACE_ATTACH` 父进程（非后代）实测 `EPERM`。改 scope 要 root，本机不可做 | `cat /proc/sys/kernel/yama/ptrace_scope`→1；`./lab2c8_attach`→`rc=-1 errno=1` |
| 「`system()` 不是线程安全的」 | man 3 system 的 ATTRIBUTES 标 **MT-Safe**（函数内部无数据竞争）。正文 2.8.4 说的「线程安全」问题是指它**临时改进程级信号处置**、与调用者自己的 SIGCHLD 处理器并发时行为不可依赖——这是语义层面，不是函数内部 races，两者别混 | `man 3 system` 的 ATTRIBUTES 表；Kerrisk §27.7 的信号竞态讨论 |

## 2. 复跑校正（2026-11-08，同一台 aarch64 VM）

下表只列**在这台 7.0.0-38 aarch64 VM 上真实跑出来**的项。方法：正文 C 程序按正文编译命令原样编译运行；新实验程序用 `lab2c8_` 前缀。两处正文程序复跑出 bug，单列在表后。

| 正文原写法 | 本机实测 | 结论 |
|:--|:--|:--|
| 2.8.3 `exec_inherit` 预期输出 | 原样复跑：exec 前后 `pid=13508` 一致、`open fds: 0 1 2 3`（fd 4 消失）、`SIGINT=SIG_IGN`、`SIGTERM=SIG_DFL`、`SIGUSR1 blocked=yes`、`DEMO_TOKEN=hello-from-parent` | 与正文一致 |
| 2.8.4 `system_decode` 预期输出 | 原样复跑：`exit 3`→`code=3 (raw=0x0300)`、`kill -TERM $$`→`signal 15 (raw=0x000f)`、不存在命令→`code=127 (raw=0x7f00)`、`true`→`raw=0x0000`、`fork+exec exit 9`→`raw=0x0900` | 与正文一致 |
| 2.8.11 `stat_fields` 预期输出 | 原样复跑：`state=Z threads=1 utime=5`、`vsize=0 rss=0`、`exit_code=0x2a00`、`wait4 code=42 maxrss=16928 KiB`、`utime=0.054s` | 机制与正文一致；具体滴答/maxrss 数随每次运行变（正文示例 utime=6/maxrss=16520 是另一轮的读数），引用时别当固定值 |
| 2.8.10 `exec_timeout` 预期输出 | 原样复跑：`child killed by signal 14 (SIGALRM: alarm survived exec)`、`real 0m1.003s`、exit=0 | 与正文一致：alarm 跨 exec 保留、处理器复位后被 SIGALRM 杀 |
| 2.8.8 errno 表「单串超 `MAX_ARG_STRLEN`→E2BIG」 | `lab2c8_e2big`（单个 200 KiB 环境串，总量远小于 ARG_MAX）：`errno=7 (Argument list too long)` | 与正文一致；`getconf ARG_MAX`=2097152、`PAGE_SIZE`=4096，单串上限 32 页=128 KiB |
| 2.8.8 errno 表 `ETXTBSY`/`ENOEXEC`/CRLF | `lab2c8_txtbusy`：写方式打开再 exec→`errno=26 (Text file busy)`，关 fd 后 exec 成功；无 shebang 可执行文件→`errno=8 (Exec format error)`；CRLF shebang→`errno=2 (No such file or directory)`（解释器 `/bin/sh\r` 不存在） | 与正文一致；CRLF 的根因是解释器路径带 `\r` |
| 2.8.2 shebang「只能带一个参数」 | `#!/bin/echo a b` 脚本输出 `a b ./lab2c8_arg.sh`：`a b` 作为一个参数、脚本路径被内核追加 | 与正文一致 |
| 2.8.12/2.8.10 glibc 实现路径 | `strace` 实测 `system(NULL)` 与 `posix_spawnp` 都用 `clone3({flags=CLONE_VM\|CLONE_VFORK\|CLONE_CLEAR_SIGHAND...})`；`system(NULL)=1`，子进程 exec `/bin/sh -c -- "exit 0"` | 正文「`__posix_spawn` 或 fork」在本机落到 spawn/clone3 路径；`system(NULL)` 确实起 shell |
| 2.8.7 ptrace 权限边界 | `cat /proc/sys/kernel/yama/ptrace_scope`=1；`lab2c8_attach` 附加父进程 `rc=-1 errno=1 (Operation not permitted)`；`lab2c8_trace` 走 TRACEME 追到 27 个 syscall、初始停 signal=5 | 与正文一致；TRACEME 路可跑、附加非后代被挡 |
| 2.8.5 popen 死锁/SIGPIPE | `lab2c8_pipe`：默认处置写 1 MiB 被 SIGPIPE 杀（shell 见 141）；忽略 SIGPIPE 后 `written=65536 errno=32 (Broken pipe)`、`pclose exit=0` | 与正文机制一致；65536=管道缓冲 64 KiB |

**正文程序复跑出的两个 bug（已由主会话在正文修好并实测通过，2026-11-09）**：

1. **2.8.9 `exec_fd_audit.c` 的示例输出与代码矛盾，且有越界 UB。** 原代码对 `i%2==0` 设 `O_CLOEXEC`，而 fd 号 = i+3，所以带 CLOEXEC 的是奇数 fd（3,5,7…）、exec 后留下的是偶数 fd（4,6,8…），与正文「泄漏的全是奇数 fd」的说法相反——把循环下标 i 的奇偶当成了 fd 号的奇偶。另外验证循环 `for (i=0; i<n; i++)` 里 n=32 但 `leaked[]` 只有 16 项，越界读是未定义行为：`-O2` 下实测打印 `fd 1619733012 unexpectedly bad` 这类垃圾号并以 `exit=1` 收场。**实际采用的修法与本节原建议不同**：原建议是「循环上界改 `i < n && i < 16`、把示例输出改成偶数 fd」；主会话改为①按**实际 fd 号**判奇偶（先 `open`，再 `fcntl(fd, F_SETFD, (fd%2==0)?FD_CLOEXEC:0)`），保住正文「偶数号设标志、奇数号泄漏」的原意；②`count_open()` 改为返回「实际存进数组的个数」、总数另由出参带回，数组扩到 `NFDS`，从根上消除越界。修后本机实测 `before=64 / after=32 (expect 32) / leaked: 3 5 7 … 65 / exit=0`。正文 2.8.9 已把这两处当反面教材写明，并补了「先 open 再 fcntl 在多线程下有非原子窗口、生产应用 `O_CLOEXEC`」的口径。
2. **2.8.6 `spawn_stats.c` 在 GCC 13 `-Werror` 下编译失败。** 其 sscanf 用了 `%*lu`/`%*ld`（赋值抑制 + 长度修饰符），GCC 13.3 报 `-Werror=format=`「use of assignment suppression and length modifier together」。抑制转换不赋值，长度修饰符无意义。**修法已应用**：被抑制的 `%*lu`→`%*u`、`%*ld`→`%*d`，需要接收值的 `%lu`/`%ld` 保留。修后编译通过，本机实测 `/proc: state=Z vsize=0 rss=0`、`waitid si_code=1 si_status=42 si_uid=1000`、`rusage user=0.031377s maxrss=264 kB`。正文 2.8.6 的输出块已换成这次真读数，并订正了旧稿「僵尸 `vsize=2465792`」的错误（僵尸地址空间已释放，`vsize` 与 `rss` 都是 0）。

## 3. 本章未实测项

下面这些在这台 VM 上拿不到证据，引用时一律当**待验证的机制结论**，不要抄成读数：

- **一切要 root 的动作**：改 `kernel.yama.ptrace_scope`、注册 `binfmt_misc`（`/proc/sys/fs/binfmt_misc` 写）、`PTRACE_ATTACH` 别人的进程、`PTRACE_O_SUSPEND_SECCOMP`。`sudo` 不可用，全部按「机制结论 + 未实测」；正文给了命令。
- **`binfmt_misc` 跨架构执行**：本机是 aarch64，没有注册 qemu-x86_64 跑 x86 ELF 的现场（注册要 root）；正文 2.8.8 的 qemu 条目按文档级读。
- **`execveat`/`close_range` 在老内核的 `ENOSYS`**：本机内核 7.0 远高于 3.19/5.9，无法复现老内核行为；版本依据来自 man-pages。
- **`fexecve` 在无 `/proc` 容器里的 `ENOENT`**：本机 glibc 2.39 走 execveat 路径、`/proc` 已挂；≤2.26 glibc 的 `/proc` 依赖是 man 页结论，未在本机造无 `/proc` 环境复现。
- **`system` 期间 Ctrl-C 的完整交互**：需要控制终端与前台进程组现场，自动化 ssh 会话不便复现；「忽略 SIGINT/SIGQUIT、shell 与前台子进程响应」按 Kerrisk §27.6（p506）与 man 页读。
- **CSAPP 第 8.4 节的具体页内表述**：中文第 3 版是纯扫描版、本机 tesseract 无 `chi_sim`，**未 OCR**；本章对 CSAPP 只按 `source-toc/clean-csapp.md` 的结构（8.4 进程控制，p549–562）核对，不引用其具体句子或页内数字。
- **`getrusage` 的 `exec` 后 maxrss 重置**：正文 2.8.15 自测 A4 提到「某些内核/平台 exec 后 maxrss 重置」，这是平台相关的机制结论，本机未单独构造对照实验。

## 4. 发现新问题怎么记

按「**现象 → 命令与输出 → 机器/内核/架构/工具版本 → 建议改法**」四段写，缺第四段就没有可比较的基准：

1. **现象**：一句话说清谁看起来坏了。例：「`exec_fd_audit` 跑完 exit=1 还打印一堆垃圾 fd 号」。
2. **命令与输出**：贴**原样敲的命令**与**未经删减的输出**（含 errno 数字与退出码）。
3. **机器口径**：至少附 `uname -a`、`ldd --version | head -1`、`gcc --version | head -1`、`cat /proc/sys/kernel/yama/ptrace_scope`、`getconf ARG_MAX PAGE_SIZE`、`strace -V | head -1`；涉及 syscall 号的附架构与 `/usr/include/asm-generic/unistd.h` 对应行。
4. **建议改法**：写「该改成什么动作」。例：「正文 2.8.9 示例输出的泄漏 fd 应改成偶数，验证循环上界加 `&& i < 16`」。

归类再说话：**规范条款**（退出码低 8 位、dup 清除 CLOEXEC 是 POSIX 规定）、**本机读数**（ARG_MAX=2097152、execve 号 221、shebang 截断 255、scope=1）、**随内核/架构/glibc 变的量**（BINPRM_BUF_SIZE、syscall 号、`system`/`posix_spawn` 实现路径、`execveat`/`close_range` 版本）、**未实测**（写清为什么没测）。本章最常见的分歧有三种：把 x86-64 的 syscall 号与寄存器当本机结论、把 Kerrisk 成书时的旧上限（shebang 127 字节）当现代内核行为、把 wait 状态当退出码。