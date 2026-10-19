# CHECK-KERRISK-ERRORS：Kerrisk 母本事实错误与实质漏节核查

> 只读核查报告。未修改 `src/`、`SUMMARY.md`、`book.toml`、`theme/`、`tools/`。
> 核查对象：`src/part2/ch01.md`–`ch19.md`（19 章，28,915 行）。
> 行号以 **2026-10-19 08:55 CST** 的当前文件为准；A.2 为已修复条目。
> 证据口径：Linux man-pages（man7.org，抓取版本 6.19；目标内核 Linux 6.8）；原书目录 `写作规范/source-toc/clean-kerrisk.md`；代码块用 `zig cc -target x86_64-linux-gnu -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -c` 做交叉编译（等价于 Linux gcc 头文件环境）。
> 最终版：A 为 Top 20 核查记录（9 条当前仍存在 + 11 条核查期间已修复），B 为 15 条实质漏节，C 为已核对清单。

## 0. 结论速览

- 当前仍存在的**确定性事实错误 9 条**（有 man 页/内核源码/直接证据）；另有 11 条在核查期间被并行修复，见 A.2。
- 错误集中在三类：**返回/状态解码**（`/proc/pid/stat` 的 `exit_code`、`clock()` 回绕）、**API 原型**（`mq_open`、`sem_open`）、**时区规则**（`TZ` 空值、缺 tzdata）。
- 首轮曾发现 4 个完整程序在 `-Wall -Wextra -Werror` 下不能编译（缺头文件/未定义常量）；当前均已修复（F-09、F-10 及同批修复项）。当前完整程序只剩 `liburing`/`libacl` 外部依赖无法在本机验证。
- `2.2.4.1 ioctl`、`2.2.8.1 fadvise`、`2.2.9.1 mkstemp`、`2.6.8.1 mount`、`2.14.6.1 mqd_t`、`2.15.7.1 semop`、`2.17.1.1 服务器模型` 的主干语义基本正确；具体问题见 C。

---

## A. 事实错误 Top 20（含核查期间已被并行修复的条目）

> **状态快照：2026-10-19 08:55 CST。** `src/part2` 在本轮核查期间被并行修改：首轮报告的 20 条里，有 11 条已在 08:45–08:55 被修掉（见 A.2）；下列 **A.1 的 9 条仍存在于当前文件**。每条都给出当前 `文件:行`、原错误说法、正确说法与证据；已修复条目保留作验收对照。

### A.1 仍存在（9 条，按严重度）

#### A-01 `st_ctime` 的更新条件写反：写文件**会**更新 ctime

- **位置**：`src/part2/ch05.md:54`（同一错误语气也见 `:718` 附近）。
- **错误原文**：
  > `chmod` 会改它，创建后改内容不会改它（改的是 `mtime`）。
- **正确说法**：`ctime` 是 inode 状态变更时间；**写文件内容会同时更新 `mtime` 和 `ctime`**（因为文件大小/数据块/时间戳属于 inode 状态）。`chmod`/`chown`/`link`/`rename`/`unlink` 也会更新 ctime；只有「改内容不动 inode」的情况不存在。
- **证据**：`inode(7)`：*"Last status change timestamp (ctime) ... It is changed by writing or by setting inode information (i.e., owner, group, link count, mode, etc.)."*（<https://man7.org/linux/man-pages/man7/inode.7.html>）；`stat(2)` 同义（<https://man7.org/linux/man-pages/man2/stat.2.html>）。
- **修法**：改为「`chmod`/`chown`/`link`/`rename` 会改 ctime；`write`/`truncate` 也会改 ctime（同时改 mtime）」；不要用 ctime 判断「是否只改了内容」。

#### A-02 `times()` 的代码注释仍写「返回自开机以来」，且片段缺 `<unistd.h>`

- **位置**：`src/part2/ch08.md:1238–1243`（注释在 `:1242`；`sysconf/_SC_CLK_TCK` 在 `:1243`）。
- **错误原文**：
  ```c
  #include <sys/times.h>
  #include <time.h>
  struct tms t;
  clock_t ticks = times(&t);        /* 返回自开机以来的 clock ticks */
  long hz = sysconf(_SC_CLK_TCK);   /* 每秒多少 tick，通常 100 */
  ```
- **正确说法**：
  - `times(2)` 的起点 POSIX 只保证「过去某个任意点」；Linux 2.4 及更早才是开机，**Linux 2.6+ 是 boot 前 `(2^32/HZ) - 300` 秒**。不能当 uptime。
  - `sysconf()` 与 `_SC_CLK_TCK` 需要 `<unistd.h>`；当前片段只有 `<sys/times.h>`/`<time.h>`，`-Werror` 下 `sysconf` 隐式声明、`_SC_CLK_TCK` 未定义。
- **证据**：`times(2)` HISTORY（<https://man7.org/linux/man-pages/man2/times.2.html>）；`sysconf(3)` 的 `<unistd.h>`（<https://man7.org/linux/man-pages/man3/sysconf.3.html>）。实测编译：
  ```
  error: call to undeclared function 'sysconf'
  error: use of undeclared identifier '_SC_CLK_TCK'
  ```
- **修法**：注释改成与 2.8.11.1 表格一致；补 `#include <unistd.h>`。

#### A-03 `termios` 的 `VINTR/VQUIT/VSUSP` 被标成「仅规范模式」，实际只受 `ISIG` 控制

- **位置**：`src/part2/ch19.md:687–698`（表头 `仅规范模式`；`VINTR` 在 `:689`、`VQUIT` 在 `:690`、`VSUSP` 在 `:698`）。
- **错误原文**：
  > `| VINTR | Ctrl-C | SIGINT | 是 |`
  > `| VQUIT | Ctrl-\ | SIGQUIT | 是 |`
  > `| VSUSP | Ctrl-Z | SIGTSTP | 是 |`
- **正确说法**：`VINTR`/`VQUIT`/`VSUSP` 是否产生信号由 **`ISIG`** 决定，与 `ICANON` 无关；非规范模式（cbreak）保留 `ISIG` 时，Ctrl-C 仍然产生 `SIGINT`。只有 `VERASE`/`VKILL`/`VEOF`/`VEOL` 等行编辑字符才依赖 `ICANON`。该书自己在 2.19.8 的 cbreak 段落也写了「保留 `ISIG`，Ctrl-C 仍然产生 `SIGINT`」，与本表矛盾。
- **证据**：`termios(3)` 的 `ISIG`：*"When any of the characters INTR, QUIT, SUSP, or DSUSP are received, generate the corresponding signal."*（<https://man7.org/linux/man-pages/man3/termios.3.html>）；`ICANON` 只控制规范模式/行编辑。
- **修法**：把「仅规范模式」列改成「条件」：`VINTR/VQUIT/VSUSP` → `ISIG`；`VERASE/VKILL/VEOF/VEOL` → `ICANON`；`VSTART/VSTOP` → `IXON`；`VREPRINT/VWERASE/VLNEXT/VDISCARD` → `IEXTEN`。

#### A-04 `O_TMPFILE` 的「只有创建者能 `linkat`」不成立

- **位置**：`src/part2/ch02.md:637`。
- **错误原文**：
  > 只有创建者能 `linkat`，且不能跨文件系统；
- **正确说法**：`linkat(fd, "", ..., AT_EMPTY_PATH)` 只要求调用者持有该 fd 并具备 `CAP_DAC_READ_SEARCH`（或走 `/proc/self/fd/N` 的替代路径）；没有「创建者」检查。fd 通过 `SCM_RIGHTS` 传给另一个进程后，对方也可以 `linkat`。真正的限制是 `O_TMPFILE|O_EXCL` 会设置不可链接状态，以及不能跨文件系统（`EXDEV`）。
- **证据**：`open(2)` 的 `O_TMPFILE` 段只说明 `O_EXCL` 阻止 link、`linkat` 需要 `CAP_DAC_READ_SEARCH`，没有 creator 限制（<https://man7.org/linux/man-pages/man2/open.2.html>）；`linkat(2)` 的 `AT_EMPTY_PATH` 规则（<https://man7.org/linux/man-pages/man2/linkat.2.html>）。
- **修法**：改为「`linkat` 需要 fd + `CAP_DAC_READ_SEARCH`；`O_EXCL` 打开的临时文件不可链接；不能跨文件系统」。

#### A-05 `readv`/`writev` 的「glibc 可能拆分」不成立

- **位置**：`src/part2/ch02.md:1271`。
- **错误原文**：
  > 最大段数 | `sysconf(_SC_IOV_MAX)`，Linux 通常 1024；原始 syscall 超过返回 `EINVAL`，glibc 可能拆分
- **正确说法**：Linux/glibc 的 `readv`/`writev` 是系统调用的薄包装（`SYSCALL_CANCEL(readv, ...)`），**不会**替调用者拆分 `iovcnt`；超过 `IOV_MAX` 时内核返回 `EINVAL`。POSIX 也不要求 libc 拆分。
- **证据**：glibc `sysdeps/unix/sysv/linux/readv.c`：`return SYSCALL_CANCEL (readv, fd, iov, iovcnt);`（<https://github.com/bminor/glibc/blob/release/2.39/master/sysdeps/unix/sysv/linux/readv.c>）；`readv(2)` ERRORS 的 `EINVAL`（<https://man7.org/linux/man-pages/man2/readv.2.html>）。
- **修法**：删掉「glibc 可能拆分」，改成「超过 `IOV_MAX` 返回 `EINVAL`；要更多段就分批调用」。

#### A-06 `RLIMIT_SIGPENDING` 的「0 表示无限制」是反的

- **位置**：`src/part2/ch10.md:1000`。
- **错误原文**：
  > 实时信号按**真实 UID** 记账，上限是 `RLIMIT_SIGPENDING`（默认值通常是 0 表示无限制？实际 `ulimit -i` 常见 127551）。
- **正确说法**：资源限制值 `0` 表示**不允许排队任何信号**，不是「无限制」。Linux 的默认值由内核按线程数推导（常见 127551），不是 0；`RLIM_INFINITY` 才表示无限制。`sigqueue()` 超限返回 `EAGAIN`；`kill()` 对已排队信号仍可送一次。
- **证据**：`getrlimit(2)` 的 `RLIMIT_SIGPENDING`：限制「may be queued for the real user ID」，`sigqueue` 才强制执行（<https://man7.org/linux/man-pages/man2/getrlimit.2.html>）；`signal(7)` 的排队上限（<https://man7.org/linux/man-pages/man7/signal.7.html>）。
- **修法**：删掉「0 表示无限制」的猜测，改成「0 表示不允许排队；默认值通常非 0；无限制用 `RLIM_INFINITY`」。

#### A-07 `clock_gettime` 的 errno 表多列了 `EPERM`

- **位置**：`src/part2/ch11.md:640`。
- **错误原文**：
  > `| clock_gettime | ... | 0，写 *tp | EFAULT、EINVAL、ENODEV、ENOTSUP、EPERM | ... |`
- **正确说法**：`EPERM` 是 `clock_settime()` 的错误（缺 `CAP_SYS_TIME`/动态时钟写权限）；`clock_gettime()` 不会因为权限失败。读取时钟的错误是 `EFAULT`、`EINVAL`、`ENODEV`、`ENOTSUP`（动态时钟），32 位还有 `EOVERFLOW`。
- **证据**：`clock_gettime(2)` ERRORS：`EACCES`/`EPERM` 只列在 `clock_settime` 下；`clock_gettime` 列 `EFAULT`、`EINVAL`、`ENODEV`、`ENOTSUP`（<https://man7.org/linux/man-pages/man2/clock_gettime.2.html>）。
- **修法**：从 `clock_gettime` 行删 `EPERM`；`clock_settime` 行保留 `EPERM`/`EACCES`。

#### A-08 「`syscall()` 在某些架构上走 vDSO」没有依据

- **位置**：`src/part2/ch01.md:741`。
- **错误原文**：
  > glibc 的 `syscall()` 是一段 C/汇编包装，负责按 ABI 排寄存器并做 `errno` 翻译；某些架构上它还会走 vDSO 或做指针检查。
- **正确说法**：`syscall()` 是通用系统调用入口，直接执行架构的陷入指令（x86-64 `syscall`、ARM64 `svc` 等），不做 vDSO 分派。vDSO 是 glibc 对**特定函数**（`clock_gettime`、`gettimeofday`、`time` 等）的优化，不是 `syscall()` 的路径。`syscall()` 也不会做用户指针有效性检查（只做参数传递与 `errno` 翻译）。
- **证据**：`syscall(2)` DESCRIPTION：*"syscall() is a small library function that invokes the system call whose assembly language interface has the specified number..."*（<https://man7.org/linux/man-pages/man2/syscall.2.html>）；glibc `sysdeps/unix/sysv/linux/syscall.c` 直接走 `INTERNAL_SYSCALL`，无 vDSO 分支。
- **修法**：删掉「走 vDSO 或做指针检查」，改成「按 ABI 排寄存器、执行陷入指令、把负返回值翻译成 `-1/errno`」。

#### A-09 `POSIX_FADV_NOREUSE` 的语义写成「不留在缓存」，且未标 Linux 版本

- **位置**：`src/part2/ch02.md:569`。
- **错误原文**：
  > `| POSIX_FADV_NOREUSE | 只读一次，不留在缓存 | 一次性归档 |`
- **正确说法**：
  - Linux 2.6.18–6.2：该 flag 是 **no-op**；
  - Linux 6.3+：表示页替换算法可以忽略对**已映射页**的访问（用于大文件流式读），并不保证「读一次就丢弃」；
  - 它不会主动释放 page cache；要释放用 `POSIX_FADV_DONTNEED`。
- **证据**：`posix_fadvise(2)` 的 `POSIX_FADV_NOREUSE` 段：*"from Linux 2.6.18 until Linux 6.2 this flag was a no-op. Since Linux 6.3, POSIX_FADV_NOREUSE signals that the kernel page replacement algorithm can ignore access to mapped page cache marked by this flag."*（<https://man7.org/linux/man-pages/man2/posix_fadvise.2.html>）。
- **修法**：表格加版本列/备注；典型场景改为「大文件流式读，允许页替换忽略」，不要写「不留在缓存」。

### A.2 核查期间已修复（保留验收）

> 以下 11 条是 08:42–08:55 首轮报告中已确认、并被并行修改修复的条目。行号是**修复后**的当前行，供验收。

| # | 位置（修复后） | 原错误 | 当前状态/证据 |
|--:|:--|:--|:--|
| F-01 | `ch08.md:1071,1073,1217,1224` | `/proc/pid/stat` 字段 52 的 `exit_code` 位布局/示例错 | 已改为 wait status；`_exit(42)` → `0x2a00`，用 `WEXITSTATUS` 解码。`proc_pid_stat(5)` 字段 52 |
| F-02 | `ch14.md:390,643` | `mq_open` 固定四参数 | 已改 variadic；表注「无 `O_CREAT` 时两参数」。`mq_open(3)` |
| F-03 | `ch15.md:218,695` | `sem_open` 固定四参数 | 已改 variadic。`sem_open(3)` |
| F-04 | `ch11.md:192–193` | `TZ` 空值当 `/etc/localtime` | 已拆成「未设置→/etc/localtime；空/不可解释→UTC」。`tzset(3)` |
| F-05 | `ch11.md:194,221` | 缺 tzdata 说「会失败」 | 已改「静默回退 UTC，tzset 无错误返回」 |
| F-06 | `ch08.md:1255` | `clock()` 回绕「同上 248 天」 | 已改「32 位约 72 分钟；64 位不回绕」。`clock(3)` |
| F-07 | `ch08.md:1254` | `times()` 起点「开机以来」 | 已改「POSIX 任意点；Linux 2.6+ boot 前 `(2^32/HZ)-300` 秒」 |
| F-08 | `ch07.md:903–905` | `clone()` 的 `child_tid` 参数错位 | 已改为 `NULL, NULL, NULL, &child_tid` 并加参数顺序注释 |
| F-09 | `ch02.md:299` | `ioctl` 示例缺 `<linux/fs.h>` | 已补 `#include <linux/fs.h>` |
| F-10 | `ch03.md:260` | `mkstemp` 示例缺 `<stdlib.h>` | 已补 `#include <stdlib.h>` |
| F-11 | `ch09.md:615,623` | `setreuid` 的 saved UID 条件把「或」写成「且」 | 已改为「`r` 被设置，**或** `e` 被设成不等于旧 `r` 的值」。`setreuid(2)` |

**同批修复的次要项**（不在 Top 20 计数内）：`ch04.md:582` `setlinebuf` 返回 `void`、`:590–591` `__fpurge` 返回 `void`/`fpurge` 返回 `int`；`ch13.md:1086` 补 `<signal.h>`；`ch09.md:1137` 去掉 Linux 不存在的 `ENOATTR`；`ch14.md:654,1425` `mq_send` 优先级改为 `>= MQ_PRIO_MAX`。

## B. 实质漏节 Top 15（按「part2 无教学落点」判定）

> 判定口径：原书 `x.y` 节有独立 API/机制；`src/part2` 只有一句提及、只在示例里调用、或完全没有落点；**不是**总结/练习/废弃接口。跨篇已覆盖的（如 K35 在 part3/ch05、K41/42 在 part1/ch07、K40 在 part0/ch12）不计入，但在备注中说明。

| # | 节号 | 标题 | 为什么算漏（当前证据） | 建议补到 |
|--:|:--|:--|:--|:--|
| 1 | 10.5 | 更新系统时钟 | 只有 `clock_settime` 一行表项和 `settimeofday` 的旁白；`settimeofday`/`stime`/`adjtime`/`clock_settime` 的原型、权限、对绝对定时器的影响没有集中落点 | 2.11.8 后加「设置时钟」小节 |
| 2 | 10.6 | 软件时钟（jiffies） | 只有 `_SC_CLK_TCK` 和 `/proc/PID/stat` 的 utime/stime；`HZ`、jiffies、`times()` 起点、`/proc/stat` 的 `btime` 关系没有讲 | 2.8.11.1 或 2.11.8 |
| 3 | 6.7 | 环境列表 | `environ` 只在 `execve` 示例里出现；`putenv`/`unsetenv` 0 次，`setenv` 只作为调用；环境字符串的所有权、修改 `environ` 的规则、`clearenv` 的泄漏风险没有讲 | 2.8.2（exec 环境）或 2.9.5 |
| 4 | 8.5 | 密码加密和用户认证 | ch09 讲 passwd/shadow 文件与 NSS，但 `crypt(3)`、`getspnam(3)`、salt/哈希格式、认证失败路径 0 次 | 2.9.2 |
| 5 | 18.11 | `fts` 文件树遍历 | 2.6.7 只有「scandir/fts/nftw 选择」表；`fts_open/fts_read/fts_children/fts_set` 无原型、无示例 | 2.6.7 末尾 |
| 6 | 22.7 | `siginterrupt()` | part2 0 次；老代码用它与 `SA_RESTART` 互操作，读者遇到 `siginterrupt` 无法映射 | 2.10.9（`SA_RESTART` 段） |
| 7 | 37.5 | 使用 `syslog` 记录消息和错误 | 只有 2.19.6 守护进程示例中的 `openlog/syslog` 调用；`setlogmask` 0 次，facility/priority、`/dev/log` 与 journald 的关系未讲 | 2.19.6 |
| 8 | 46.4 | `msgctl()` 操作 | 只有 `IPC_STAT` 的 `msqid_ds` 字段表和 `IPC_SET` 一句；`IPC_INFO`/`MSG_STAT`/`MSG_INFO`、`IPC_SET` 权限边界未系统讲 | 2.14.18 |
| 9 | 47.6 | `semctl()` 操作 | 只有 `SETVAL`/`IPC_RMID` 两个调用；`GETVAL/GETALL/SETALL/IPC_STAT/IPC_SET/SEM_STAT/SEM_INFO` 无表 | 2.15.7.1 |
| 10 | 48.5 | `shmctl()` 操作 | 只有 `IPC_RMID` 一个调用；`IPC_STAT/IPC_SET/SHM_LOCK/SHM_UNLOCK/SHM_INFO` 无表 | 2.15.7 |
| 11 | 63.3 | 信号驱动 I/O | 映射表标为「背景」；正文只有 `O_ASYNC`/`SIGIO`/`F_SETOWN` 的零散提及，没有「设置 owner → 注册 SIGIO → 读 si_fd → 处理 EAGAIN」的完整链路 | 2.18.11 前补一小节 |
| 12 | 14.10 | 虚拟内存文件系统：tmpfs | `/dev/shm`、`tmpfs` 作为名词出现多次，但 `mount -t tmpfs`、`size=`/`nr_inodes=`、内存回收与 shm 对象生命周期的关系没有落点 | 2.15.2 |
| 13 | 6.6 | 命令行参数（`argc`/`argv`） | ch08 只把 `argv` 传给 `execve`；`argv[0]` 约定、`argc`/`argv` 在 `main` 的第三种形式、参数与环境区的 `/proc/PID/cmdline` 观测没有专门讲 | 2.8.1 或 2.1.7 |
| 14 | 61.13.5 | 顺序数据包套接字（`SOCK_SEQPACKET`） | 2.16.10 只在 `SOCK_SEQPACKET` 行说「AF_UNIX 支持」；消息边界、`sendmsg`/`recvmsg` 语义、与 `SOCK_STREAM`/`SOCK_DGRAM` 的对照没有展开 | 2.16.8 或 2.17.1 |
| 15 | 55.3.6 | 锁定饿死和排队加锁请求的优先级 | 2.3.6/2.3.15 讲 `flock`/POSIX/OFD 锁的冲突与死锁，但没有「F_SETLKW 等待队列是否 FIFO、写者饿死、唤醒顺序」的语义 | 2.3.15 |

> 说明：K35（进程优先级/调度）在 `src/part3/ch05.md` 有完整落点；K41/42（共享库）在 `src/part1/ch07.md`；K40（utmp/wtmp）在 `src/part0/ch12.md`，且属淘汰/背景，故不计入 part2 漏节。

## C. 已核对无问题清单（按当前文件，2026-10-19 08:55）

### C.1 指定重点节的复核结论

| 节 | 核对点 | 结论 |
|:--|:--|:--|
| 2.2.4.1 `ioctl` | `int ioctl(int, unsigned long, ...)`；`_IOC_NR/TYPE/SIZE` 位段；`_IO/_IOR/_IOW/_IOWR`；`TIOCGWINSZ`/`FIONREAD`/`FS_IOC_GETFLAGS`；`ENOTTY/EINVAL/EFAULT/EPERM` | 正确；示例已补 `<linux/fs.h>`（F-09 已修复） |
| 2.2.8.1 `posix_fadvise` | 6 个 `POSIX_FADV_*`；`DONTNEED` 只丢干净页；`madvise` 作用于 mmap 区间；`MADV_HUGEPAGE/NOHUGEPAGE` | 基本正确；`NOREUSE` 仍见 A-09 |
| 2.2.9.1 `mkstemp` | `O_CREAT|O_EXCL|O_RDWR` + 0600；模板 6 个 X；`tmpfile`/`O_TMPFILE` 对比 | 正确；示例已补 `<stdlib.h>`（F-10 已修复） |
| 2.6.8.1 `mount/umount2` | 原型；`MS_BIND/MS_REC/MS_PRIVATE/MS_SLAVE/MS_REMOUNT`；`MNT_DETACH`；`CAP_SYS_ADMIN` | 正确；`MS_BIND` 忽略 `fstype/data` 的说明也正确 |
| 2.8.11.1 `times/clock` | `struct tms` 四字段；`_SC_CLK_TCK` 换算；`clock()` 是 CPU 时间；`getrusage` 对照 | 表格已修正（F-06/F-07）；代码片段仍有 A-02 的注释/头文件问题 |
| 2.11.2.1 `TZ/tzset` | 未设置→`/etc/localtime`；空/不可解释→UTC；`TZ=Asia/Shanghai`；`TZ=UTC0`/`:UTC`；`tzname/timezone/daylight` | 正确（F-04/F-05 已修复）；`localtime_r` 返回值未检查属小瑕疵 |
| 2.11.8.1 时间转换 | `gmtime_r/localtime_r/mktime/timegm/strftime/strptime/tzset` 原型；`tm_isdst=-1`；`strftime` 不用 `errno` 判断 | 正确 |
| 2.14.6.1 `mqd_t` | Linux 上 `mqd_t` 是 fd；可 fork/exec/epoll；`mq_close` 只关描述符；`mq_unlink` 删名字 | 正确；`mq_open` 原型已修正（F-02） |
| 2.15.7.1 `semop/SEM_UNDO` | `semop` 数组原子性；`SEM_UNDO` 只对 `semop` 生效；`semctl(SETVAL)` 不记 undo | 正确；`sem_open` 原型已修正（F-03） |
| 2.17.1.1 服务器模型 | 迭代/每连接 fork/线程/pre-fork/epoll/SO_REUSEPORT；`accept4`；`SIGCHLD` 回收；惊群 | 正确；fork 版 echo 是伪代码，未标 `text`（低危） |

### C.2 已逐项对照 man 页、未发现事实错误的高频 API（抽样）

- 文件 I/O：`open/openat`（flags、`O_CLOEXEC`、`O_TMPFILE`、`O_PATH`、`O_NOFOLLOW`、`O_DIRECTORY`）、`read/write`（短读短写、`EINTR`、`EAGAIN`）、`close`（不重试）、`dup/dup2/dup3`、`fcntl(F_GETFL/F_SETFL/F_DUPFD_CLOEXEC)`、`lseek`、`pread/pwrite`、`readv/writev`、`mmap/munmap/msync/mprotect/mlock/mincore/mremap`、`fallocate`、`sendfile/splice/tee/copy_file_range`。
- 文件属性：`stat/lstat/fstat/fstatat`、`struct stat` 字段、`S_IS*`/权限位、`chmod/chown`、`utimensat/futimens`、`xattr` 四件套、ACL 常量与 `acl_*` 原型、`statx`/`statvfs`。
- 目录/事件：`readdir/telldir/seekdir`、`link/symlink/readlink/realpath`、`mkdir/rmdir/rename/unlink`、`nftw`、`inotify_*`、`renameat2`。
- 进程：`fork/vfork/clone/clone3`（flags 表）、`exit/_exit/atexit/on_exit`、`wait/waitpid/waitid/wait4`、`WIF*` 宏、`execve/exec*`、`posix_spawn`。
- 凭证：`setuid/seteuid/setreuid/setresuid/setfsuid` 的矩阵（`setreuid` 条件已修复，F-11）、`setgroups`、`capget/capset`、file capability 的 `security.capability` 布局。
- 信号：`sigaction`/`sa_flags`、`sigprocmask`、`sigpending`、`sigsuspend`、`sigwait/sigwaitinfo/sigtimedwait`、`sigqueue`、实时信号编号、`signalfd`。
- 时间：`clock_gettime/getres/settime`、`nanosleep`/`clock_nanosleep`、`alarm/setitimer/getitimer`、`timer_create/settime/gettime/getoverrun/delete`、`timerfd_*`；除 A-07 的 `EPERM` 外无发现。
- 线程/同步：`pthread_create/join/detach/exit/cancel`、属性对象、`pthread_mutex_*`、`pthread_cond_*`、`pthread_rwlock_*`、`pthread_barrier_*`、`pthread_spin_*`、`sem_*`、`futex` 路径。
- IPC：`pipe/pipe2`、`mkfifo`、`popen/pclose`、`mq_*`、`shm_*`、`sem_*`、System V `msgget/msgsnd/msgrcv/msgctl`、`semget/semop/semctl`、`shmget/shmat/shmdt/shmctl`。
- 套接字：`socket/bind/listen/accept/accept4/connect`、`send/recv/sendto/recvfrom/sendmsg/recvmsg/sendmmsg/recvmmsg`、`shutdown`、`getsockname/getpeername`、`getaddrinfo/getnameinfo/gai_strerror`、`struct msghdr/cmsghdr/ucred`、`SCM_RIGHTS`、`SO_*` 主要选项。
- 多路复用/异步：`select/pselect/poll/ppoll`、`epoll_create1/ctl/wait/pwait/pwait2`、`EPOLL*` 位值、`eventfd/signalfd/timerfd`、`io_uring_setup/enter/register`。
- 终端/pty：`termios` 结构、`tcgetattr/tcsetattr`、`cf*`、`tcflush/tcflow/tcdrain`、`tcgetpgrp/tcsetpgrp/tcgetsid`、`posix_openpt/grantpt/unlockpt/ptsname`、`openpty/forkpty/login_tty`、`TIOC*`。

### C.3 未实测/需在 Linux 6.8 上复跑的点

- `io_uring` 程序依赖 `liburing-dev`；本机交叉编译缺该头文件，未能编译验证。
- ACL 程序依赖 `libacl1-dev`；同上。
- `/proc/PID/stat` 的 `exit_code` 示例、`clone` 示例、`timerfd` 示例的**运行输出**未在 Linux 6.8 上实跑（本机为 macOS）；结论来自 man 页 + 内核源码，不是运行观测。
- `SO_REUSEPORT` 在 AF_UNIX 上的支持、`EPOLLEXCLUSIVE` 与 `EPOLLONESHOT` 的组合等边角，只做了 man/内核源码核对，未做运行实验。

---

## D. 方法与局限

1. **行号会漂移**：`src/part2` 在本轮核查期间被并行修改（08:45–08:53），A.1 的 9 条是 08:55 复核仍存在的；A.2 的 11 条是首轮发现、复核时已修复的。最终提交前应再跑一次 A.1 的 `文件:行`。
2. **编译口径**：完整程序用 `zig cc -target x86_64-linux-gnu -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -c` 检查；等价于 Linux gcc 头文件环境，但不是 Ubuntu 24.04 的 gcc 实测。`liburing`/`libacl` 依赖外部开发包，未计入「代码块错误」。
3. **原书页码**：本报告只对 `clean-kerrisk.md` 的节号与 man 页，不逐页核对 PDF 页码；B 的「为什么漏」以当前正文关键词/标题为准。
4. **只读约束**：本报告未改 `src/`、`SUMMARY.md`、`book.toml`、`theme/`、`tools/`。A.2 的修复是并行写入者的改动，不是本报告所为。
