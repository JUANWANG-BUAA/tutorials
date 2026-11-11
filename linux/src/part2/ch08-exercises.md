# 2.8 习题集

三组分层：**A 组概念判断**考「会不会说理由」；**B 组诊断推理**给现象让你判机制、判断点、给修法；**C 组动手实验**全部在这台免 `sudo` 的 Ubuntu 24.04.5 aarch64 虚拟机上真跑过，每题都写「看到什么算对」。共 19 题。每题第一个动作都是「先猜」：把预期写下再验证，猜错的地方才是这题的价值。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟；A 组要求说出一段完整因果，B 组写成「现象 → 机制 → 读数 → 修法」四段。
2. 卡住了回对应小节的 errata/method 盒重读，不要直接看答案：A 组对应 2.8.1–2.8.6，B 组对应 2.8.4–2.8.12 与 2.8.14，C 组对应 2.8.1–2.8.12。
3. C 组命令都按本机设计：临时文件统一 `lab2c8_` 前缀，程序用 `cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 -g` 编译。清理时**只删 `lab2c8_` 这个精确前缀**，不要宽通配，别碰别人的文件。
4. **环境边界**：`sudo` 与 `perf` 不可用，`ptrace_scope=1`（只能 TRACEME 自己的子进程，附加别人被 `EPERM` 挡）。凡需 root 的步骤一律标「本机不可做」，不要为了跑通去猜数字。aarch64 的 syscall 号与 x86 不同，别抄 x86 的 59。
5. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch08-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 2.8-A1 · exec 保留清单里最易记反的一条 {#ex-2.8-A1}

先猜：父进程把 `SIGINT` 设为忽略、把 `SIGTERM` 设为捕获，exec 之后新程序里这两个信号的处置各是什么？信号掩码呢？

说出 exec 对「被捕获」「被忽略」「掩码」「未决信号」四者的不同处理；用 `nohup` 解释为什么「忽略保留」是有用的设计。

::: sol 解答

exec 后 `SIGINT` 仍是 `SIG_IGN`（忽略保留），`SIGTERM` 变回 `SIG_DFL`（捕获的处理器复位）；信号掩码与未决信号都保留。原因：被捕获的处理器是一段代码，住在旧地址空间里，exec 把地址空间整个换掉，处理器地址已不存在，只能复位为默认；而「忽略」不是一个地址、只是一个状态标志，可以原样跨过边界。`nohup cmd` 正是把 `SIGHUP` 设成 `SIG_IGN` 再 exec——新程序自动免疫终端关闭时的 `SIGHUP`，不需要新程序自己配合。本机 `exec_inherit` 实测：`SIGINT=SIG_IGN`、`SIGTERM=SIG_DFL`、`SIGUSR1 blocked=yes`。**判据**：四者处理全对；从「处理器是代码地址、忽略是状态标志」讲清为什么；`nohup` 机制说对。

:::
:::

::: ex 例 2.8-A2 · `system("exit 3")` 返回的不是 3 {#ex-2.8-A2}

先猜：`int rc = system("exit 3");` 之后 `rc == 3` 成立吗？`rc` 的十六进制是多少？怎么取出 3？

解释 `system` 返回值的本质；列出 `command==NULL`、fork 失败、exec 不了 shell 三种特殊返回；说明为什么 `system("nonexistent")` 与「exec 不了 shell」无法区分。

::: sol 解答

不成立。`rc` 是 shell 的 **wait 状态** `0x0300`（退出码 3 在 bits 8–15），要 `WIFEXITED(rc)` 为真后 `WEXITSTATUS(rc)` 才得 3。特殊返回：`command==NULL` → shell 可用返回非 0、不可用返回 0；fork 或取状态失败 → `-1` 且 `errno` 有值；子进程 exec 不了 shell → 如同 `_exit(127)` 的状态 `0x7f00`。最后一种与「shell 找不到命令、以 127 退出」返回同样的 `0x7f00`，**无法区分**——这是 `system` 的固有局限。直接 `if (rc != 0)` 会把 `-1`、`0x7f00`、`0x0300` 混成一团。本机实测 `exit 3`→`0x0300`、`kill -TERM $$`→`0x000f`、不存在命令→`0x7f00`。**判据**：wait 状态本质说对；三种特殊返回说全；「127 二义性」点明。

:::
:::

::: ex 例 2.8-A3 · `FD_CLOEXEC` 为什么是 fd 的属性 {#ex-2.8-A3}

先猜：`open` 同一个文件两次，fd 3 带 `O_CLOEXEC`、fd 4 不带，exec 后哪个还在？`dup(4)` 出的 fd 5 带 CLOEXEC 吗？

解释 `FD_CLOEXEC` 存在哪一层；说明 `dup`/`fork` 对这一位各做什么；给出原子设位的接口。

::: sol 解答

exec 后 fd 4 还在、fd 3 关闭——因为 `FD_CLOEXEC` 存在 **fd 表项**（`fdtable` 的 `close_on_exec` 位图），不在共享的 `struct file` 里，所以同一打开文件的两个 fd 可以一个带一个不带。`dup(4)` 的 fd 5 **不带** CLOEXEC（POSIX 规定 dup 清除副本的这一位），exec 后 fd 5 也在；`fork` 则把这一位**连同 fd 表一起复制**，CLOEXEC 只在 exec 时生效。原子设位接口：`open(O_CLOEXEC)`、`dup3(O_CLOEXEC)`、`fcntl(F_DUPFD_CLOEXEC)`、`pipe2(O_CLOEXEC)`、`socket(SOCK_CLOEXEC)`、`accept4(SOCK_CLOEXEC)`。本机实测：`dup(cloexec_fd)` 的新 fd CLOEXEC 位为 0，exec 后 fd 3、5 都出现在子进程 `/proc/self/fd`，fd 4 消失。**判据**：「fd 表项 vs struct file」说清；dup 清除/fork 复制/exec 生效三者分开；原子接口至少举三个。

:::
:::

::: ex 例 2.8-A4 · `waitid` 的 `si_status` 不一定是退出码 {#ex-2.8-A4}

先猜：子进程被 `SIGKILL` 杀死，`waitid` 填的 `si_code` 与 `si_status` 各是什么？能把 `si_status` 当退出码吗？

列出 `si_code` 的取值；说明什么时候 `si_status` 才是退出码；给出监督进程里正确的判读顺序。

::: sol 解答

被 `SIGKILL` 杀：`si_code=CLD_KILLED`(2)，`si_status=9`（信号号，不是退出码）。`si_code` 取值：`CLD_EXITED`(1)、`CLD_KILLED`(2)、`CLD_DUMPED`(3)、`CLD_TRAPPED`(4)、`CLD_STOPPED`(5)、`CLD_CONTINUED`(6)。**只有 `CLD_EXITED` 时 `si_status` 才是退出码**，其余是信号号。正确判读：先看 `si_code`——等于 1 才把 `si_status` 当退出码；等于 2/3 把 `si_status` 当致死信号（3 还转储了 core）；等于 5/6 是停止/恢复。看到 `si_code≠1` 却把 `si_status` 当退出码，是监督进程把「被杀」误报成「退出码 9」的典型 bug。本机实测正常退出：`si_code=1 si_status=42 si_uid=1000`。**判据**：六个取值说全；「仅 CLD_EXITED 是退出码」说死；判读顺序先 code 后 status。

:::
:::

::: ex 例 2.8-A5 · `getrusage(RUSAGE_CHILDREN)` 为什么是 0 {#ex-2.8-A5}

先猜：子进程刚 fork 出来还在跑，父进程读 `getrusage(RUSAGE_CHILDREN).ru_maxrss` 是多少？子进程用了 100 MB 但还没 wait，读出来会有 100 MB 吗？

说出 `RUSAGE_CHILDREN` 的三个口径限制；给出拿单个子进程用量的最省事办法；说明 `ru_maxrss` 的单位差异。

::: sol 答案

是 0（或此前已回收子进程的累计值），不会有正在跑的那个子进程的 100 MB。三个口径限制：① 只统计**已经 wait 回收**的子进程；② 是**累计值**，含此前所有已回收子进程，不是某一个；③ 单位差异——`ru_maxrss` 在 Linux 是 KB、macOS 是字节。拿单个子进程最省事用 `wait4(pid, &status, 0, &ru)`，回收的同时直接拿到它的 `rusage`；要更精确就让子进程自己 `getrusage(RUSAGE_SELF)` 经管道发回。`maxrss=0` 的排查顺序：先确认 wait 了没，再确认是不是累计口径，最后核对单位。**判据**：三个限制说全；`wait4` 作为单进程方案；KB/字节单位差异点明。

:::
:::

::: ex 例 2.8-A6 · shebang 为什么只能带一个参数 {#ex-2.8-A6}

先猜：`#!/bin/echo a b` 作为脚本首行，执行后 echo 收到几个参数、输出什么？`#!/usr/bin/env python3 -u` 为什么失败？

解释 Linux 对 optional-arg 的处理；说明 shebang 首行超长的后果（本机内核）；给出可移植写法。

::: sol 解答

Linux 把解释器路径之后**直到行尾的全部文本当成一个参数**，所以 `#!/bin/echo a b` 里 `a b` 是**一个**含空格的参数，再加上内核自动追加的脚本路径——echo 输出 `a b <脚本路径>`（本机实测 `a b ./lab2c8_arg.sh`）。`#!/usr/bin/env python3 -u` 失败同理：`python3 -u` 被当成一个整体路径名去找，找不到。首行超长被**静默截断**：本机内核 7.0（`BINPRM_BUF_SIZE=256`）首行超 255 字节（不含换行）的部分丢弃，不报错。可移植写法：optional-arg 要么不带、要么是单个词；解释器选项放进脚本内部（如 python 脚本里 `sys.argv` 处理）或用一个 wrapper 脚本。**判据**：「整行剩余当一个参数」说对；超长是截断不是报错；可移植写法给出。

:::
:::

## B 组 · 诊断推理

::: ex 例 2.8-B1 · 文件有 `x` 位却 exec 报 EACCES {#ex-2.8-B1}

现象：`/home/alice/bin/tool` 是 `-rwxr-xr-x`，bob 执行却报 `EACCES`；`ls -l` 看目标文件权限明明没问题。

按「现象 → 机制 → 读数 → 修法」四段作答；给出一次看清整条路径的命令。

::: sol 解答

**现象**：目标文件有 `x`，跨用户执行仍 `EACCES`。**机制**：`execve` 要求路径上**每一级目录**都有 `x`（可搜索）位，不只是最后的目标文件；`/home/alice` 若是 `700`，bob 穿不过这一级，得到 `EACCES` 而非 `EPERM`。另一可能是挂载点 `noexec`、或 shebang 解释器本身无 `x`。**读数**：`namei -l /home/alice/bin/tool` 逐级列出权限，一眼看到哪级缺 `x`；`findmnt -T /home/alice/bin/tool` 看挂载选项有没有 `noexec`。**修法**：给路径上必需的目录补 `x`（或把工具放进 bob 可穿过的目录）；`noexec` 挂载则换挂载点或重挂。排查顺序：先 `namei -l` 看整条路径，再 `findmnt` 看挂载，最后才怀疑目标文件本身。**判据**：「每级目录都要 x」是根因；`namei -l`/`findmnt` 给出；`EACCES` 而非 `EPERM` 点明。

:::
:::

::: ex 例 2.8-B2 · 子进程继承了不该有的日志 fd {#ex-2.8-B2}

现象：多线程服务 fork+exec 一个不受信助手程序后，发现助手能往服务的日志文件里写内容；服务用的是「`open` 之后 `fcntl(F_SETFD, FD_CLOEXEC)`」。

按四段作答；解释非原子窗口；给出原子修法与批量收口办法。

::: sol 解答

**现象**：不受信子程序持有服务的日志 fd，可写伪造内容、可 `lseek` 破坏写入位置。**机制**：「先 `open` 再 `fcntl` 设 CLOEXEC」是两步，线程 A 两步之间线程 B fork+exec，子程序继承到「已打开但未设位」的 fd——非原子窗口。**读数**：在助手程序里 `ls -l /proc/self/fd` 能看到指向服务日志的 fd；服务侧 strace 看 `open` 与 `fcntl` 之间夹着别的线程的 `clone`+`execve`。**修法**：一律用原子接口 `open(O_CLOEXEC)`，把两步合一步、窗口消失；已打开的 fd 用 `fcntl(F_DUPFD_CLOEXEC)` 重 dup。批量收口用 `close_range(3, ~0U, CLOSE_RANGE_CLOEXEC)`（Linux 5.11）一次把 3 以上全标 CLOEXEC，或 exec 前 `close_range(3, ~0U, 0)` 全关；容器里 `close_range` 可能被 seccomp 挡，留逐 fd 回退。**判据**：非原子窗口讲清；`O_CLOEXEC` 原子修法；`close_range` 批量收口与回退提到。

:::
:::

::: ex 例 2.8-B3 · `pclose` 偶发 ECHILD {#ex-2.8-B3}

现象：服务用 `popen` 跑命令，`pclose` 大多数时候正常，偶尔返回 `-1`、`errno=ECHILD`；服务装了一个 `SIGCHLD` 处理器做统一回收。

按四段作答；说清根因与两种修法。

::: sol 解答

**现象**：`pclose` 偶发 `-1`/`ECHILD`，不是必现。**机制**：`popen` 的子进程退出时发 `SIGCHLD`，服务的 `SIGCHLD` 处理器里的 `waitpid(-1, ...)` 可能**抢先**把这个子进程回收了；等 `pclose` 再去 wait 同一个 PID，内核已经没有这个未回收子进程，返回 `ECHILD`。这是信号处理器与 `popen` 抢同一个子进程的竞态，所以偶发。**读数**：`pclose` 失败时 `errno==ECHILD`；strace 看 `SIGCHLD` 处理器里的 `wait4` 先于 `pclose` 的 `wait4` 收走了同一 PID。**修法**：① 统一回收点——别让 `SIGCHLD` 处理器无差别 `waitpid(-1)`，只回收自己明确管理的 PID；② `popen`/`pclose` 期间阻塞 `SIGCHLD`，让 `pclose` 独占回收。`pclose` 返回值本身是 wait 状态，解码前先判 `-1`。**判据**：「SIGCHLD 处理器抢先回收」是根因；偶发=竞态说清；两种修法给出。

:::
:::

::: ex 例 2.8-B4 · `/proc/pid/stat` 解析错位 {#ex-2.8-B4}

现象：监控脚本按空格 split `/proc/<pid>/stat` 取第 14 个 token 当 `utime`，对多数进程正常，对某个进程读出的「utime」是个巨大的无关数字。

按四段作答；给出稳健解析法；说明 `utime` 单位与换算。

::: sol 解答

**现象**：个别进程的字段整体偏移。**机制**：第 2 字段 `comm` 在括号里、可能含空格甚至 `)`（进程名可被 `prctl(PR_SET_NAME)` 或 exec 改），按空格 split 时 `comm` 里的空格多出 token，后面所有下标偏移。**读数**：出问题的进程 `cat /proc/<pid>/stat` 看 `comm` 是不是含空格（如 `(my prog)`）；对照 `ps -o comm` 确认。**修法**：先找**最后一个 `)`**（`strrchr(buf, ')')`），从它之后按位置读字段——正文 `stat_fields.c` 就是这么做的。`utime`/`stime` 单位是时钟滴答，除以 `sysconf(_SC_CLK_TCK)`（=100）得秒；`rss` 是页、`vsize` 是字节，别混。**判据**：「comm 含空格致偏移」是根因；「最后一个 )」解析法；滴答/页/字节单位说清。

:::
:::

::: ex 例 2.8-B5 · `posix_spawn` 失败但 errno 是旧值 {#ex-2.8-B5}

现象：`posix_spawnp` 返回非 0，代码里 `perror("spawn")` 打出的却是上一个无关调用的错误（如 `Success` 或别的 errno）。

按四段作答；说明 `posix_spawn` 的错误报告约定；给出正确打印法。

::: sol 解答

**现象**：spawn 明明失败，`perror` 打出的错误对不上。**机制**：`posix_spawn`/`posix_spawnp` **返回错误码本身**（成功 0，失败返回 `ENOENT`/`EACCES`/`EAGAIN` 等），**不设置 `errno`**——这与多数系统调用「返回 -1 并设 errno」相反。直接 `perror` 读的是残留的旧 `errno`。**读数**：打印返回码 `rc` 本身（如 `rc=2` 即 `ENOENT`）；对照 `strerror(rc)` 才是真错误。**修法**：`int rc = posix_spawnp(...); if (rc != 0) { errno = rc; perror("spawn"); }`——先把返回码赋给 `errno` 再 `perror`，或直接 `fprintf(stderr, "spawn: %s\n", strerror(rc))`。glibc 用 `clone(CLONE_VM|CLONE_VFORK)` 实现，子进程共享父地址空间，错误码直接写回，不走 errno。**判据**：「返回错误码、不设 errno」说死；`errno = rc` 或 `strerror(rc)` 修法；与常规系统调用约定对比。

:::
:::

::: ex 例 2.8-B6 · 容器里 `fexecve` 报 ENOENT {#ex-2.8-B6}

现象：宿主上 `fexecve(fd, ...)` 正常，进容器后对同一个打开的 fd 报 `ENOENT`；容器镜像极简、`/proc` 可能没挂。

按四段作答；解释 `fexecve` 的两条实现路径；给出容器里的稳妥写法。

::: sol 解答

**现象**：同一 `fexecve` 宿主正常、容器 `ENOENT`。**机制**：glibc 2.27 起若内核支持就用 `execveat(fd, "", ..., AT_EMPTY_PATH)`，不依赖 `/proc`；更老的 glibc（≤2.26）回退到 `execve("/proc/self/fd/<fd>")`，需要 `/proc` 挂载——极简容器没挂 `/proc` 就 `ENOENT`。man `fexecve(3)` 明确：内核无 `execveat` 且 `/proc` 不可访问时报 `ENOSYS`/`ENOENT`。**读数**：容器里 `mount | grep proc` 看 `/proc` 挂没挂；`ldd --version` 看 glibc；`strace -e trace=execve,execveat` 看走的是哪条路径。**修法**：直接用 `execveat(fd, "", argv, envp, AT_EMPTY_PATH)`（Linux 3.19+）绕开 `/proc` 依赖；或保证容器挂载 `/proc`。注意 `execveat` 是 3.19 加入、glibc 2.34 才有包装，老内核要回退。**判据**：两条实现路径与版本说清；`/proc` 依赖是根因；`execveat(AT_EMPTY_PATH)` 修法。

:::
:::

## C 组 · 动手实验

::: ex 例 2.8-C1 · execve 前后 PID 不变、地址空间全换 {#ex-2.8-C1}

先猜：一个程序 exec 自己之后，PID 变吗？`/proc/self/maps` 里代码段、`[heap]`、`[stack]` 的地址会变吗？

编译运行下面的程序（exec 自己、用参数区分前后），对照两次 maps。

```c
/* lab2c8_maps.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
static int marker = 0x5a5a;
static void show(const char *tag)
{
    printf("%s: pid=%ld &marker=%p\n", tag, (long)getpid(), (void *)&marker);
    FILE *fp = fopen("/proc/self/maps", "r");
    char line[512];
    while (fgets(line, sizeof line, fp) != NULL)
        if (strstr(line, "lab2c8_maps") || strstr(line, "[heap]") || strstr(line, "[stack]"))
            fputs(line, stdout);
    fclose(fp);
}
int main(int argc, char **argv)
{
    if (argc > 1 && strcmp(argv[1], "--after") == 0) { show("after "); return 0; }
    show("before");
    fflush(NULL);
    char *av[] = { argv[0], "--after", NULL };
    execv(argv[0], av);
    perror("execv");
    return 1;
}
```

::: sol 解答

本机实测（aarch64 VM，地址随 ASLR 每次变，下面是其中一次）：

```text
before: pid=13505 &marker=0xc84c161b0010
c84c16190000-c84c16191000 r-xp 00000000 08:02 2883661 /tmp/lab2c8_maps
c84c4a054000-c84c4a075000 rw-p 00000000 00:00 0 [heap]
ffffe792d000-ffffe794e000 rw-p 00000000 00:00 0 [stack]
after : pid=13505 &marker=0xb0f60bf90010
b0f60bf70000-b0f60bf71000 r-xp 00000000 08:02 2883661 /tmp/lab2c8_maps
b0f6216a2000-b0f6216c3000 rw-p 00000000 00:00 0 [heap]
ffffdecd0000-ffffdecf1000 rw-p 00000000 00:00 0 [stack]
```

读法：PID 两次都是 13505（同一个进程），但 `&marker`、代码段、`[heap]`、`[stack]` 的地址全变了——地址空间被整个换掉并重新随机布局；可执行文件路径与 inode（2883661）不变，因为 exec 的是同一个文件。这正是「exec 换程序不换进程」的实证。**看到什么算对**：前后 PID 相同；代码段/heap/stack 地址不同；`fflush(NULL)` 不能省（否则 before 的输出可能随旧地址空间一起丢掉）。

:::
:::

::: ex 例 2.8-C2 · FD_CLOEXEC 在与不在的子进程 fd 表差异 {#ex-2.8-C2}

先猜：父进程开 fd 3（不带 CLOEXEC）、fd 4（带）、fd 5=`dup(4)`，fork 后子进程 exec `ls -l /proc/self/fd`，哪几个 fd 会出现？

编译运行下面的程序，看子进程 exec 后的 fd 表。

```c
/* lab2c8_cloexec.c */
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>
int main(void)
{
    int plain = open("/etc/hosts", O_RDONLY);
    int clo = open("/etc/hosts", O_RDONLY | O_CLOEXEC);
    int duped = dup(clo);
    printf("parent: plain=%d cloexec=%d dup(cloexec)=%d\n", plain, clo, duped);
    printf("dup CLOEXEC bit = %ld\n", (long)(fcntl(duped, F_GETFD) & FD_CLOEXEC));
    fflush(NULL);
    pid_t pid = fork();
    if (pid == 0) {
        execl("/bin/ls", "ls", "-l", "/proc/self/fd", (char *)NULL);
        _exit(127);
    }
    int st; waitpid(pid, &st, 0);
    printf("child exit=%d\n", WEXITSTATUS(st));
    return 0;
}
```

::: sol 解答

本机实测（aarch64 VM）：

```text
parent: plain=3 cloexec=4 dup(cloexec)=5
dup CLOEXEC bit = 0
total 0
lr-x------ 1 juanwang juanwang 64 ... 0 -> pipe:[52687]
l-wx------ 1 juanwang juanwang 64 ... 1 -> pipe:[52688]
l-wx------ 1 juanwang juanwang 64 ... 2 -> pipe:[52689]
lr-x------ 1 juanwang juanwang 64 ... 3 -> /etc/hosts
lr-x------ 1 juanwang juanwang 64 ... 4 -> /proc/13507/fd
lr-x------ 1 juanwang juanwang 64 ... 5 -> /etc/hosts
child exit=0
```

读法：子进程 exec 后 fd 3（plain）和 fd 5（dup 副本，CLOEXEC 位被清）都还在、指向 `/etc/hosts`；原来带 CLOEXEC 的 fd 4 消失了——而 4 这个编号被 `ls` 自己打开的目录 fd 复用（`4 -> /proc/13507/fd`）。两条结论一次看清：CLOEXEC 在 exec 时关 fd；dup 清除副本的 CLOEXEC 位。**看到什么算对**：fd 3、5 指向 `/etc/hosts`；原 fd 4 不在（编号被 ls 复用）；`dup CLOEXEC bit = 0`。

:::
:::

::: ex 例 2.8-C3 · shebang 脚本经 execlp 的实际 exec 链 {#ex-2.8-C3}

先猜：`execlp` 一个 `#!/bin/sh` 脚本，strace 下能看到几次 `execve`？换成 `#!/usr/bin/env sh` 呢？

造两个脚本与一个 execlp 探针，用 strace 抓 exec 链。

```bash
printf '#!/bin/sh\nexec /bin/echo chain-ok\n' > lab2c8_s1.sh
printf '#!/usr/bin/env sh\nexec /bin/echo env-chain-ok\n' > lab2c8_s2.sh
chmod +x lab2c8_s1.sh lab2c8_s2.sh
# lab2c8_execp.c：execlp(argv[1], argv[1], NULL); 失败 perror
PATH=/tmp:$PATH strace -f -e trace=execve ./lab2c8_execp lab2c8_s1.sh
PATH=/tmp:$PATH strace -f -e trace=execve ./lab2c8_execp lab2c8_s2.sh
```

::: sol 解答

本机实测（aarch64 VM，strace 6.8，PID/地址略）：`#!/bin/sh` 脚本：

```text
chain-ok
13701 execve("./lab2c8_execp", ["./lab2c8_execp", "lab2c8_s1.sh"], ...) = 0
13701 execve("/tmp/lab2c8_s1.sh", ["lab2c8_s1.sh"], ...) = 0
13701 execve("/bin/echo", ["/bin/echo", "chain-ok"], ...) = 0
13701 +++ exited with 0 +++
```

`#!/usr/bin/env sh` 脚本（PATH 里加了 /tmp，env 先试 /tmp/sh）：

```text
env-chain-ok
13712 execve("/tmp/lab2c8_s2.sh", ["lab2c8_s2.sh"], ...) = 0
13712 execve("/tmp/sh", ["sh", "/tmp/lab2c8_s2.sh"], ...) = -1 ENOENT
13712 execve("/usr/local/sbin/sh", ...) = -1 ENOENT
13712 execve("/usr/local/bin/sh", ...) = -1 ENOENT
13712 execve("/usr/sbin/sh", ...) = -1 ENOENT
13712 execve("/usr/bin/sh", ["sh", "/tmp/lab2c8_s2.sh"], ...) = 0
13712 execve("/bin/echo", ["/bin/echo", "env-chain-ok"], ...) = 0
```

读法：脚本那次 `execve` 显示 `= 0`，但内核已在调用内部把进程换成解释器（strace 不会单独显示 `/bin/sh` 那次 exec）；随后脚本里的 `exec /bin/echo` 产生第二次 execve。`env` 版多了一串 `ENOENT`——`env` 在 `PATH` 里逐个找 `sh`，这正是 `#!/usr/bin/env` 的运行时查找，也暴露了 PATH 注入面（本机 PATH 含 /tmp，先试 `/tmp/sh`）。全程同一 PID。**看到什么算对**：sh 版两次 execve（脚本→echo）；env 版能看到 env 的 PATH 查找链；理解脚本 execve 的 `=0` 是 strace 显示约定。

:::
:::

::: ex 例 2.8-C4 · 用 WEXITSTATUS 解出 system("exit 3") 的 3 {#ex-2.8-C4}

先猜：`system("exit 3")`、`system("kill -TERM $$")`、`system("no-such-command-xyz")` 的原始返回值各是多少（十六进制）？

编译正文 `system_decode.c`（`cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 -g`）运行，逐行核对 raw 与解码结果。

::: sol 解答

本机实测（aarch64 VM，glibc 2.39）：

```text
sh: 1: no-such-command-xyz: not found
shell available: yes
system exit 3    : exited, code=3 (raw=0x0300)
system signal TERM: killed by signal 15 (raw=0x000f)
system not found  : exited, code=127 (raw=0x7f00)
system true       : exited, code=0 (raw=0x0000)
fork+exec exit 9 : exited, code=9 (raw=0x0900)
```

读法：`exit 3` 的 raw 是 `0x0300` 不是 3——退出码在高 8 位，`WEXITSTATUS` 右移 8 位解出 3；`kill -TERM $$` 让 shell 自己被 SIGTERM(15) 杀，raw=`0x000f`、`WIFSIGNALED` 为真；不存在命令由 shell 报「not found」并以 127 退出，raw=`0x7f00`；`fork+exec exit 9` 直接 wait 子进程，raw=`0x0900`。四条对照把「wait 状态 ≠ 退出码」钉死。**看到什么算对**：四个 raw 值与解码一致；能说出 `0x0300` 的 3 在哪几位；`system(NULL)` 返回非 0（shell 可用）。

:::
:::

::: ex 例 2.8-C5 · popen 读端关闭后写端的 SIGPIPE {#ex-2.8-C5}

先猜：`popen("head -c 1", "w")` 后写 1 MiB，head 读完 1 字节就退出，父进程默认会怎样？先把 SIGPIPE 设为忽略呢？

编译下面的程序，分别不带参数与带 `ign` 跑，看 shell 报告的退出码。

```c
/* lab2c8_pipe.c：带 "ign" 参数则先 signal(SIGPIPE, SIG_IGN) */
#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
int main(int argc, char **argv)
{
    if (argc > 1 && strcmp(argv[1], "ign") == 0) signal(SIGPIPE, SIG_IGN);
    FILE *fp = popen("head -c 1", "w");
    char buf[4096]; memset(buf, 'x', sizeof buf);
    size_t total = 0;
    for (int i = 0; i < 256; i++) {
        size_t n = fwrite(buf, 1, sizeof buf, fp);
        total += n;
        if (n < sizeof buf) break;
    }
    int rc = fflush(fp);
    printf("written=%zu fflush=%d errno=%d (%s)\n", total, rc, errno, strerror(errno));
    int st = pclose(fp);
    if (WIFEXITED(st)) printf("pclose: exit=%d\n", WEXITSTATUS(st));
    return 0;
}
```

::: sol 解答

本机实测（aarch64 VM）：默认处置下进程被 `SIGPIPE` 杀死，只来得及输出 head 回显的一个 `x`，shell 报告退出码 **141**（128+13）：

```text
xshell sees exit=141
```

先忽略 SIGPIPE（`./lab2c8_pipe ign`）后，写端拿到 `EPIPE` 而不是被杀：

```text
xwritten=65536 fflush=0 errno=32 (Broken pipe)
pclose: exit=0
shell sees exit=0
```

读法：head 读 1 字节就退出、关闭管道读端；父进程继续写，默认处置收 `SIGPIPE` 终止（141）。忽略后写调用失败、`errno=32`(EPIPE)，`written=65536` 正好是管道缓冲容量（64 KiB）写满后的短写；`pclose` 仍正常解出 head 的退出码 0。这就是「`popen("w")` 不让子进程产生大量输出/要及时读」的反面教材。**看到什么算对**：默认退出 141；忽略后 errno=32 且进程存活；`pclose` 解出 exit=0。

:::
:::

::: ex 例 2.8-C6 · getrusage 与 /proc/pid/stat 的 CPU 时间对照 {#ex-2.8-C6}

先猜：子进程烧一点 CPU 后 `_exit(42)`，僵尸状态读 `/proc/<pid>/stat` 的 `utime` 是 6 滴答，`wait4` 的 `ru_utime` 会是多少秒？两者为什么不完全相等？

编译正文 `stat_fields.c` 运行，对照 stat 滴答与 wait4 的 timeval。

::: sol 解答

本机实测（aarch64 VM，其中一次）：

```text
stat: state=Z threads=1 utime=5 stime=0
stat: vsize=0 rss=0 pages (0 KiB) starttime=55589
stat: utime+stime=0.050s (HZ=100) exit_code=0x2a00
wait: exited=1 code=42 maxrss=16928 KiB minflt=4125 majflt=0
wait: utime=0.054s stime=0.004s nvcsw=1 nivcsw=19
```

读法：僵尸的 `vsize`/`rss` 已归 0（页在 `exit_mm` 释放），`maxrss` 只能从 `wait4` 拿（16928 KiB）；`exit_code=0x2a00` 是 wait 状态，`WEXITSTATUS` 解出 42。`utime=5` 滴答 × 10 ms = 0.050 s，而 `wait4` 的 `ru_utime=0.054 s`——差在 `/proc/stat` 以 10 ms 滴答计、向下取整，`rusage` 是微秒精度，两者在滴答粒度内一致而非逐位相等。**看到什么算对**：僵尸 vsize/rss=0；exit_code=0x2a00 解出 42；stat 滴答换算与 rusage 在 10 ms 粒度内对上；说出差异来自粒度。

:::
:::

::: ex 例 2.8-C7 · aarch64 上用 GET_SYSCALL_INFO 追子进程 {#ex-2.8-C7}

先猜：`ptrace_scope=1` 的机器上，子进程 `PTRACE_TRACEME` 后 exec `/bin/true`，父进程能追到吗？第一个 syscall 号是多少（aarch64）？附加父进程自己会怎样？

本题的完整 tracer 已在本机编译运行（结构如下伪代码所示，关键是架构无关的 `PTRACE_GET_SYSCALL_INFO`）；再单独跑 `PTRACE_ATTACH(getppid())` 看边界。

```text
/* lab2c8_trace.c 结构（伪代码）：子进程 TRACEME+execl("/bin/true")，父进程循环 */
头文件：sys/ptrace.h 在前、linux/ptrace.h 在后（避免枚举/宏冲突），
        另需 signal.h、stdint.h、stdio.h、sys/wait.h、unistd.h
/* fork 子：ptrace(PTRACE_TRACEME,0,NULL,NULL); execl("/bin/true","true",NULL);
   父：waitpid 拿初始停；PTRACE_SETOPTIONS 设 PTRACE_O_TRACESYSGOOD；
   循环 PTRACE_SYSCALL + waitpid，WSTOPSIG==(SIGTRAP|0x80) 时
   ptrace(PTRACE_GET_SYSCALL_INFO, pid, (void*)sizeof info, &info)，
   info.op==ENTRY 打印 info.entry.nr，==EXIT 打印 info.exit.rval。 */
```

::: sol 解答

本机实测（aarch64 VM，内核 7.0，`ptrace_scope=1`）：TRACEME 这条路可跑，追到 `/bin/true` 的 27 个 syscall：

```text
initial stop: signal=5
entry #1: nr=214
  exit: rval=209198843568128
entry #2: nr=222
  exit: rval=258619919781888
entry #3: nr=48
  exit: rval=-2
entry #4: nr=56
  exit: rval=3
...
tracee exited: code=0
total syscall entries=27
```

读法：初始停 `signal=5`（SIGTRAP，exec 后的第一次停）；`nr=214` 是 aarch64 的 `brk`、`222` 是 `mmap`、`48` 是 `faccessat`、`56` 是 `openat`（动态链接器起步），`rval=-2` 是 `ENOENT`。这些号来自 `/usr/include/asm-generic/unistd.h`，**不是 x86 的号**（x86 execve 是 59，aarch64 是 221）。用 `PTRACE_GET_SYSCALL_INFO`（Linux 5.3+）就不用碰架构寄存器。边界对照：单独跑 `ptrace(PTRACE_ATTACH, getppid(), ...)` 返回 `rc=-1 errno=1 (Operation not permitted)`——父进程不是后代，被 scope=1 挡。**看到什么算对**：TRACEME 路追到 syscall、初始停 signal=5；能对照头文件认出 nr=214=brk；附加父进程 EPERM。编译注意 `<linux/ptrace.h>` 要在 `<sys/ptrace.h>` 之后，否则枚举与宏冲突报错。

:::
:::