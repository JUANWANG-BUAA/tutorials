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

## 修复记录（2026-10-24）

> 本轮只处理 A.1 九条与 A.2 十一条抽验；B 节 15 条漏节**未补写**（按任务约束只计数）。行号为修复后当前值。

### A.1 处置（修复 7 / 已被并行修复 2 / 未找到 0）

| # | 处置 | 位置（修复后） | 说明 |
|--:|:--|:--|:--|
| A-01 | 已被并行修复 | `src/part2/ch05.md:47,49,54,205,716,718` | 「写内容同时更新 mtime+ctime」的表述已正确；报告引用的原句已不存在，无需再改 |
| A-02 | 已被并行修复 | `src/part2/ch08.md:1241,1243` | 已补 `<unistd.h>`，注释改为「POSIX 任意点；Linux 2.6+ 在 boot 之前」。用 `zig cc -target x86_64-linux-gnu -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -c` 复验：原 `sysconf` 隐式声明 / `_SC_CLK_TCK` 未定义两个错误不再出现 |
| A-03 | 本轮修复 | `src/part2/ch19.md:687,706` | 表列「仅规范模式」改为「生效条件」：`VINTR/VQUIT/VSUSP` → `ISIG`，`VERASE/VKILL/VEOF/VEOL/VEOL2` → `ICANON`，`VSTART/VSTOP` → `IXON`，`VREPRINT/VWERASE/VLNEXT/VDISCARD` → `IEXTEN`，`VMIN/VTIME` → 仅非规范；表后补一句与 2.19.8 cbreak「保留 `ISIG`」的一致性说明 |
| A-04 | 本轮修复 | `src/part2/ch02.md:669–670` | 删「只有创建者能 linkat」；改为「不检查创建者，fd 经 `SCM_RIGHTS` 传递后对方也能 linkat」，跨文件系统限制单独成条（`EXDEV`）。`O_EXCL` 与 `CAP_DAC_READ_SEARCH` 两条原有且正确，保留 |
| A-05 | 本轮修复 | `src/part2/ch02.md:1304` | 删「glibc 可能拆分」；改为「glibc 是薄包装，超过 `IOV_MAX` 直接 `EINVAL`，要更多段分批调用」 |
| A-06 | 本轮修复 | `src/part2/ch10.md:1022` | 删「0 表示无限制」的猜测；改为「0 = 不允许排队；无限制用 `RLIM_INFINITY`；默认值按 `RLIMIT_NPROC` 推导、常非 0」，并补「`kill()` 对同一已排队信号仍可再送一次」 |
| A-07 | 本轮修复 | `src/part2/ch11.md:640` | 从 `clock_gettime` 行删 `EPERM`，补注「读时钟不检查权限，`EPERM` 是 `clock_settime` 的错误」及 32 位 `EOVERFLOW`；`clock_settime` 行（:642）的 `EPERM` 保留 |
| A-08 | 本轮修复 | `src/part2/ch01.md:741` | 删「走 vDSO 或做指针检查」；改为「排寄存器、执行陷入指令、翻译 `-1/errno`；不做 vDSO 分派，不做指针检查」 |
| A-09 | 本轮修复 | `src/part2/ch02.md:599,601` | 删「只读一次，不留在缓存」；改为「Linux 2.6.18–6.2 no-op，6.3+ 提示页替换算法忽略已映射页访问」，表后补一句「要释放缓存用 `DONTNEED`，且只对干净页生效」 |

### A.2 抽验（11/11 已确认修复，无残留）

F-01（`ch08.md:1071,1073,1217,1224` wait status 解码）、F-02（`ch14.md:390,643` mq_open variadic）、F-03（`ch15.md:218,695` sem_open variadic）、F-04/F-05（`ch11.md` TZ 空/缺 tzdata → UTC）、F-06/F-07（`ch08.md:1255,1256` clock 回绕与 times 起点）、F-08（`ch07.md:916–918` clone child_tid 参数顺序）、F-09（`ch02.md:329` `<linux/fs.h>`）、F-10（`ch03.md:260` `<stdlib.h>`）、F-11（`ch09.md:615,623` setreuid「或」）——逐条 grep 复验，错误说法均不在文中，报告所引修复后的表述与当前文件一致。无残留，未需追加修改。

### 本轮验证

- `python3 tools/check_book.py`：修复前后输出一致（pages: 113，substantial: 103），未引入新问题。
- `python3 tools/verify_teaching_examples.py`：4 个测试全部通过（含 `test_pending_signal_and_sigsuspend`）。
- `zig cc` 交叉编译复验：A-02 涉及的 `times()` 片段在 `-Wall -Wextra -Werror` 下通过。
- 本轮 7 处修改均为表格/条目/段落文字，未触碰 C 代码块；未新增 H2 小节，未改锚点编号。
- 全库 grep 复扫：A.1/A.2 的错误说法在 `src/` 下已无残留（`src/part0` 的「自开机以来」指 `iostat`/`top` 首帧累计值，语义不同且正确）。

## 漏节处置（2026-10-25）

> B 节 15 条逐条复核后的处置。复核先用《50-节级审计规程》的五种判定重判，再决定补写/不改；补写全部落在 `src/part2/`，API 语义以 man7.org（man-pages 6.19）复核（msgctl/semctl/shmctl/crypt/fts/settimeofday/stime/times/tmpfs 文档逐条对照）。新增行数合计 **+174 行**（part2 29,128 → 29,302，+0.60%，上限 +4%）；`tools/check_book.py` 通过（pages: 113，substantial: 103，问题数 0）；新增 C 代码用 `zig cc -target x86_64-linux-gnu -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror` 编译验证（fts 片段全通过；crypt 片段本机 zig sysroot 无 `libcrypt` 头，换 stub 头验证语法通过，与报告 D.2 的 liburing/libacl 同类限制）。未新起 H2、未改已有编号与锚点；新增 H3 均按所在章的无编号 H3 风格，无新锚点。

### 真缺口，已补写（10 条）

| # | 原报告节号 | 复核后节号 | 补写位置 | 补了什么 |
|--:|:--|:--|:--|:--|
| B1 | 10.5 更新系统时钟 | 同 | `ch11.md` 2.11.8「读时钟」小节末尾 | `clock_settime` 之外补 `settimeofday`（`CAP_SYS_TIME`；Linux 4.3 起早于 `CLOCK_MONOTONIC` 判 `EINVAL`）、`stime()`（glibc 2.31 已删）、`adjtimex`/`adjtime` 渐变（≈500 ppm），及跳变对绝对定时器/`TFD_TIMER_CANCEL_ON_SET` 的影响 |
| B2 | 10.6 软件时钟（jiffies） | 同 | `ch08.md` 2.8.11.1 末尾 | jiffies/HZ 与 `_SC_CLK_TCK`（ABI 固定 100，故 `/proc` tick 分辨率恒 10 ms）、`/proc/stat` 的 `btime`、`times()` 起点 `(2^32/HZ)-300` 的回绕设计动机 |
| B3 | 6.7 环境列表 | 同 | `ch08.md` 2.8.2 末尾新 H3「环境列表：`environ` 与 `setenv` 家族」 | 五个 API 对照表（`getenv`/`setenv`/`putenv`/`unsetenv`/`clearenv`）+ 所有权规则（putenv 不复制、getenv 指针失效、clearenv 无法释放 exec 原始数组） |
| B4 | 8.5 密码加密和用户认证 | 同 | `ch09.md` 2.9.2 末尾 | `$id$salt$hash` 格式（`$1$`/`$5$`/`$6$`/`$y$`）、`crypt`/`crypt_r` 返回值与 errno、`getspnam`、可编译的校验片段（`-lcrypt`） |
| B5 | 18.11 fts 文件树遍历 | 英文原版 18.11（中文版目录该号是 fchdir/目录 fd，fts 系翻译时删去） | `ch06.md` 2.6.7 末尾（think 盒后） | 四函数原型、`fts_read` 的前序/后序语义、`FTS_PHYSICAL/LOGICAL/NOSTAT/XDEV`、`FTS_SKIP` 与 `nftw` 的对应、双层错误模型（`fts_errno` vs `errno`）+ 可编译示例 |
| B7 | 37.5 使用 syslog 记录消息和错误 | 同 | `ch19.md` 2.19.6 末尾新 H3「syslog：priority、facility 与 `/dev/log`」 | priority=facility\|level、`openlog` 四个 option 位、`setlogmask` 静默丢弃语义、`/dev/log`→journald/rsyslog 链路、容器无 `/dev/log` 的丢消息、格式串注入红线 |
| B8 | 46.4 msgctl 操作 | **46.3**（46.4 是关联数据结构） | `ch14.md` 2.14.18 末尾（method 盒后） | cmd 全表：`IPC_STAT`（读权限）/`IPC_SET`（属主/创建者或 `CAP_SYS_ADMIN`；提 `msg_qbytes` 还要 `CAP_SYS_RESOURCE`）/`IPC_RMID`/`IPC_INFO`/`MSG_INFO`/`MSG_STAT(_ANY)`，下标枚举与返回值约定 |
| B9 | 47.6 semctl 操作 | **47.3**（47.6 是 semop） | `ch15.md` 2.15.7.1 末尾（errata 后） | cmd 全表（`GETVAL/GETPID/GETNCNT/GETZCNT/GETALL/SETALL/SETVAL/IPC_STAT/IPC_SET/IPC_RMID/IPC_INFO/SEM_INFO/SEM_STAT`）、`union semun` 调用者自声明、`SETVAL/SETALL` 清 undo 的坑 |
| B10 | 48.5 shmctl 操作 | **48.7**（48.5 是虚拟内存位置） | `ch15.md` 2.15.7 末尾（method 盒前） | cmd 全表：`IPC_STAT/IPC_SET/IPC_RMID`（标记删除，`SHM_DEST`）、`SHM_LOCK/SHM_UNLOCK`（2.6.10 起属主可用，受 `RLIMIT_MEMLOCK`；锁换出不等于预分配页）、`IPC_INFO/SHM_INFO/SHM_STAT(_ANY)` |
| B11 | 63.3 信号驱动 I/O | 同 | `ch18.md` 2.18.11 末尾新 H3「信号驱动 I/O：`SIGIO` 的完整链路」 | `F_SETOWN`（正 PID/负进程组）→ `F_SETFL\|O_ASYNC` → `F_SETSIG` + `SA_SIGINFO` 取 `si_fd` → 非阻塞读 + `EAGAIN` 四步链路；输给 epoll 的机制原因（标准信号合并、每事件一个信号） |

### 覆盖为主，仅补边角（3 条）

| # | 原报告节号 | 复核结论 | 处置 |
|--:|:--|:--|:--|
| B12 | 14.10 tmpfs | tmpfs 机制与 shm 生命周期在 2.15.2/2.15.10/2.15.14 已成体系（`mm/shmem.c`、`/dev/shm` 配额、崩溃残留），报告所称漏点只剩挂载参数 | `ch15.md` 2.15.10「POSIX 共享内存 = tmpfs 文件 + 缺页异常」小节末尾补一段：`mount -t tmpfs -o size=/nr_inodes=`（缺省内存一半，超限 `ENOSPC`，可 remount）、页可换出、容器 `/dev/shm` 是独立实例（`--shm-size`） |
| B13 | 6.6 命令行参数 | `argv[0]` 约定（ch08:79）、`getopt`/`getopt_long`（ch01 两节）、`E2BIG`/`ARG_MAX`/`MAX_ARG_STRLEN`（2.8.8）均已覆盖；真正没有的是 `/proc/PID/cmdline` 观测与 `main` 第三种形式 | `ch08.md` 2.8.2 末尾并入一段：`main(int, char*[], char*[])` 的 `envp` 即初始环境（建议改用 `getenv`）、`/proc/PID/cmdline`（NUL 分隔、显示现值，改 `argv[0]` 可见）与 `/proc/PID/environ` 权限 |
| B14 | 61.13.5 SOCK_SEQPACKET | 类型表（2.16.10）、选型行（2.16.15「需要消息边界的本机 RPC」）已有名词级覆盖；连接语义/截断行为未展开 | `ch17.md` 2.17.1 末尾补对照表（STREAM/DGRAM/SEQPACKET 的连接·边界·顺序）+ `MSG_TRUNC` 截断语义 + 「AF_INET 基本不提供」的适用边界 |

### 复核为已覆盖，不改（1 条）

| # | 原报告节号 | 复核证据 |
|--:|:--|:--|
| B15 | 55.3.6 锁定饿死与排队优先级 | `ch03.md` 2.3.15 已明确写出核心语义：「多个读锁可能饿死一个写锁；Linux 不保证 FIFO，也不保证写者优先（Kerrisk 55.3.6）」，并交叉引用原文节号。判定：覆盖，不改 |

### 淘汰，不写正文（1 条）

| # | 原报告节号 | 淘汰理由 |
|--:|:--|:--|
| B6 | 22.7 `siginterrupt()` | POSIX.1-2008 已删除该接口（`siginterrupt(3)`：*POSIX.1-2008 removes the specification of siginterrupt()*，并指向 `sigaction` 的 `SA_RESTART`）；其机制（`SA_RESTART` 控制慢系统调用重启）在 2.10.3「`SA_RESTART` 与 `EINTR`」已完整覆盖，part2 全文 0 次出现是正确的省略。若未来在 `appendix/legacy.md` 增加「POSIX 删除的 C 接口」条目，可放一条「`siginterrupt` → `sigaction` + `SA_RESTART`/清除」对照 |

### 其他说明

- 原报告 B 表把 msgctl 记为 46.4、semctl 记为 47.6、shmctl 记为 48.5，与原书目录（46.3/47.3/48.7 是「控制操作」）编号错位；本表已按目录更正，处置以 API 为准，不受编号错位影响。
- 报告说明中「K35 在 part3/ch05、K41/42 在 part1/ch07、K40 在 part0/ch12」的三条跨篇项本次未动，维持不计入 part2 漏节的结论。
- 本轮只改 `src/part2/` 9 个文件与本文档；`SUMMARY.md`、`book.toml`、`theme/`、`tools/`、其他篇章未触碰，未执行 git 提交。
