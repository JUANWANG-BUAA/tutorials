# 2.8 学习目标自检表

这张表接管 [2.8.15 本章小结](ch08.md#sec-2.8.15)原有的达标线。正文的七条出口表原样列在下面（正文末节已改为「本章小结」），再按**概念（K）、动手（S）、实验（E）、口径（B）**四组展开成 21 条——左列是达标项，中列是「怎样算达标」（全部写成能当场做的动作），右列是「没达标回到哪一节」。动手前先确认环境边界：测试机是 aarch64 VM，`sudo` 不可用、`ptrace_scope=1`，哪些能做、哪些只能按「未实测」读，全在[勘误与版本注记](ch08-errata.md)。

## 出口表（接管正文 2.8.15）

| 检查项 | 达标线 | 没达标去哪 |
|:--|:--|:--|
| 说出 exec 保留/重置的属性 | 能覆盖 fd、信号、cwd、定时器 | [2.8.1](ch08.md#sec-2.8.1) |
| 区分 `execv`/`execvp`/`execve` | 说清 `PATH` 与环境来源 | [2.8.2](ch08.md#sec-2.8.2) |
| 解释 shebang 的参数限制 | 知道只能带一个参数 | [2.8.2](ch08.md#sec-2.8.2) |
| 用 `FD_CLOEXEC` 控制 fd 继承 | 能跑出 fd 4 消失的结果 | [2.8.3](ch08.md#sec-2.8.3) |
| 正确解码 `system()`/`pclose()` | 知道返回值是 wait 状态 | [2.8.4](ch08.md#sec-2.8.4) |
| 用 `waitid` 区分退出与被杀 | 知道 `si_code` 不是退出码 | [2.8.6](ch08.md#sec-2.8.6) |
| 说出 `getrusage` 的三个口径限制 | 累计、已回收、单位差异 | [2.8.6](ch08.md#sec-2.8.6) |

## 达标检验

| 检查项 | 达标线 | 回哪一节 |
|:--|:--|:--|
| **K1 exec 保留/重置清单** | 能分两类各举至少四项：保留（PID/凭证/cwd/umask/RLIMIT/掩码/未决/无 CLOEXEC 的 fd/SIG_IGN）与丢掉（捕获的处理器/备选栈/内存映射/atexit/POSIX 定时器） | [2.8.1](ch08.md#sec-2.8.1) |
| **K2 信号处置细分** | 能说出「捕获复位、忽略保留、掩码与未决保留」；忽略 SIGCHLD 跨 exec 在 Linux 保留、SUSv3 不置可否；用 nohup 解释忽略保留的用途 | [2.8.1](ch08.md#sec-2.8.1) |
| **K3 exec 家族与 PATH** | 能说出 l/v/e/p 四个字母含义；只有 execve 是系统调用；PATH 未定义默认 `.:/usr/bin:/bin`；含 `/` 不查 PATH；setuid 慎用 execvp | [2.8.2](ch08.md#sec-2.8.2) |
| **K4 shebang 三限制** | 能说出 optional-arg 整行剩余当一个参数；首行超长静默截断（本机 255 字节）；解释器不查 PATH；无 shebang 时 execve 报 ENOEXEC、execlp 兜底交 sh | [2.8.2](ch08.md#sec-2.8.2) |
| **K5 FD_CLOEXEC 归属** | 能说出它是 fd 表项属性而非 struct file；dup 清除副本这一位、fork 复制、exec 生效；举三个原子设位接口 | [2.8.3](ch08.md#sec-2.8.3)、[2.8.9](ch08.md#sec-2.8.9) |
| **K6 system 返回值与四问题** | 能说出返回 wait 状态要解码、command==NULL/fork 失败/exec 不了 shell 三种特殊返回；四问题（注入/信号/环境PATH/线程）各配一个场景 | [2.8.4](ch08.md#sec-2.8.4) |
| **K7 waitid 与 wait 状态** | 能背 si_code 六取值、仅 CLD_EXITED 时 si_status 是退出码；wait 状态用 WIFEXITED/WEXITSTATUS/WIFSIGNALED/WTERMSIG 解码、不手写位移 | [2.8.6](ch08.md#sec-2.8.6) |
| **K8 getrusage 三口径** | 能说出只统计已回收、是累计值、maxrss 单位 Linux KB/macOS 字节；拿单进程用 wait4 | [2.8.6](ch08.md#sec-2.8.6) |
| **S1 fork+exec+wait 骨架** | 合上正文写出：fork→子进程 execvp→失败按 errno 分流 _exit(127/126)→父进程 waitpid 循环处理 EINTR→解码状态，编译零警告 | [2.8.2](ch08.md#sec-2.8.2)、[2.8.4](ch08.md#sec-2.8.4) |
| **S2 exec_inherit 复跑** | 能编译正文 exec_inherit 并报出：exec 前后 PID 相同、fd 4 消失 fd 3 在、SIGINT=SIG_IGN、SIGTERM=SIG_DFL、SIGUSR1 blocked=yes | [2.8.3](ch08.md#sec-2.8.3) |
| **S3 system_decode 解码** | 能编译正文 system_decode 并报出 exit 3→raw=0x0300/code=3、kill -TERM $$→signal 15、不存在命令→code=127 | [2.8.4](ch08.md#sec-2.8.4) |
| **S4 cloexec fd 表** | 能跑 lab2c8_cloexec 并报出：plain fd 与 dup 副本 exec 后仍在、带 CLOEXEC 的 fd 消失、dup 的 CLOEXEC 位=0 | [2.8.3](ch08.md#sec-2.8.3)、[2.8.9](ch08.md#sec-2.8.9) |
| **S5 stat 解析与换算** | 能编译正文 stat_fields，先找最后一个 `)` 解析；报出僵尸 vsize/rss=0、exit_code=0x2a00 解出 42、utime 滴答×10ms 与 rusage 对上 | [2.8.11](ch08.md#sec-2.8.11) |
| **S6 posix_spawn 错误码** | 能写出 `rc=posix_spawnp(...); if(rc) { errno=rc; perror(...); }`，说出它返回错误码不设 errno；用 strace 看到 clone3(CLONE_VM\|CLONE_VFORK) | [2.8.12](ch08.md#sec-2.8.12) |
| **E1 strace exec 链** | 能用 `strace -f -e trace=execve` 抓 shebang 脚本的 exec 链，区分 sh 版（脚本→echo）与 env 版（多一串 PATH 查找 ENOENT） | [2.8.2](ch08.md#sec-2.8.2)、[2.8.13](ch08.md#sec-2.8.13) |
| **E2 popen SIGPIPE** | 能跑 lab2c8_pipe：默认处置退出 141、忽略 SIGPIPE 后 errno=32(EPIPE) 且 pclose 解出 exit=0 | [2.8.5](ch08.md#sec-2.8.5) |
| **E3 ptrace TRACEME** | 能在 scope=1 机器上用 TRACEME+GET_SYSCALL_INFO 追到子进程 syscall（初始停 signal=5）；附加父进程实测 EPERM；认出 aarch64 nr=214=brk | [2.8.7](ch08.md#sec-2.8.7)、[2.8.12](ch08.md#sec-2.8.12) |
| **E4 失败矩阵复现** | 能当场复现至少两个 errno：单串 200KiB 环境→E2BIG(7)、写方式打开再 exec→ETXTBSY(26)、CRLF shebang→ENOENT(2)、无 shebang→ENOEXEC(8) | [2.8.8](ch08.md#sec-2.8.8) |
| **E5 system/spawn 实现取证** | 能用 strace 看到 glibc 2.39 的 system(NULL) 与 posix_spawn 都走 clone3(CLONE_VM\|CLONE_VFORK\|CLONE_CLEAR_SIGHAND)，system(NULL) 跑 `/bin/sh -c -- "exit 0"` | [2.8.10](ch08.md#sec-2.8.10)、[2.8.12](ch08.md#sec-2.8.12) |
| **B1 数字归属** | 能把本章数字分四类各举一例：规范条款（退出码低 8 位）、本机读数（ARG_MAX=2097152、execve 号 221、shebang 255）、随内核/架构变（BINPRM_BUF_SIZE、syscall 号、glibc 实现路径）、未实测（改 ptrace_scope、binfmt_misc 注册） | [勘误与版本注记](ch08-errata.md) |
| **B2 本机环境边界** | 能报出测试机口径（aarch64、内核 7.0.0-38、glibc 2.39、ptrace_scope=1），说出 sudo 不可用与 scope=1 各挡住哪些实验、对取证的影响 | [章总览·环境口径](ch08-overview.md)、[勘误页](ch08-errata.md) |

## 没达标怎么办

- **K 组卡住**：每个概念先讲一句完整因果再说下一步。例：「因为被捕获的处理器是旧地址空间里的代码地址，exec 换掉地址空间后它不存在了，所以复位为默认；而忽略只是一个状态标志，所以保留」。讲不出因果就回对应小节的 errata 盒重读。
- **S 组卡住**：合上正文在 `/tmp/lab2c8_` 前缀下重做对应程序（习题集 C 组有完整代码与编译命令）；跑不出先核对头文件与编译选项（ptrace 程序用 `<linux/ptrace.h>` 取 `PTRACE_GET_SYSCALL_INFO`，且不要与 `<elf.h>` 之外的内核头混用）。正文 `spawn_stats.c` 的 sscanf 抑制格式与 `exec_fd_audit.c` 的越界/奇偶两处 bug **已在正文修好并实测通过**，习题集若仍引用旧版请按正文为准，详见勘误页。
- **E 组卡住**：先确认命令在本机哪些跑不了（sudo 挡改 ptrace_scope/binfmt_misc、scope=1 挡附加别人），把这些「跑不了」本身当读数记下来，不要改成凭印象的输出。
- **B 组卡住**：把想引用的每个数字问三遍：这是条款、本机读数，还是随内核/架构变的量？后两类必须带出处。aarch64 的 syscall 号别抄 x86——`execve` 是 221 不是 59。
- **只有 K 组全对**：说明还停在「会读」。本章要求会跑、会取证；把 S 组与 E 组做完再来勾这一页。

全部达标后，往下的接口有两处：[2.9 进程凭证、用户、组与能力](ch09.md) 接住「exec 之后你是谁」（本章保留清单里的 UID/GID 在那里展开）；[2.19 终端、pty、作业控制与守护进程](ch19.md) 用到本章的 fd 关闭与信号忽略（守护进程为什么要关 fd、忽略 SIGHUP）。项目侧「子进程退出码读错」「fd 泄漏进不受信子程序」「容器里 fexecve 报 ENOENT」三类问题的判据分别沉淀在 [2.8.4](ch08.md#sec-2.8.4)、[2.8.9](ch08.md#sec-2.8.9) 与 [2.8.8](ch08.md#sec-2.8.8)。