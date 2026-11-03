# 1.8 习题集

三组分层，和本章的两遍式结构对齐：**A 组概念判断**考第一遍（1.8.1–1.8.7），要求会读、会判、会说理由；**B 组诊断推理**给现象让你判「谁发的、发给谁、处理了没有」，两遍的知识都要用；**C 组动手实验**考第二遍（1.8.8–1.8.14），要求会写、会跑、会读 trace。**全部附解答与判据**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；
2. B 组务必把四段写完整——「现象 → 机制 → 证据（哪条命令、哪个字段）→ 修法」，本章最常见的错法是跳过证据直接改代码；
3. 卡住了回对应小节的「即时自测」重读，不要直接看答案；
4. C 组的实验都能在 Ubuntu 24.04 上**免 `sudo`** 跑完；需要特权的替代路径写在各题解答里。本书的复现环境是 Ubuntu 24.04.5 虚拟机（aarch64、4 vCPU、内核 7.0.0-38-generic、GCC 13.3.0、glibc 2.39、strace 6.8、`sudo` 不可用），标「VM 实测」的是这台机器上跑出来的；
5. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch08-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 1.8-A1 · 五句关于异常的话 {#ex-1.8-A1}

逐句判断并改正：① 系统调用是一条异常指令；② 缺页处理完成后，CPU 从 `mov` 的下一条指令继续；③ 除零与缺页同类，都能被内核修好；④ `int3` 是故障，因为它是同步的；⑤ aarch64 上也有 256 项 IDT，只是编号不同。

::: sol 解答

① 错。`syscall` 是**特权级切换指令**，它不经过异常表，硬件把 `%rip` 存进 `%rcx`、`%rflags` 存进 `%r11`，跳到 `MSR_LSTAR` 指向的入口；`int 0x80` 才是走 IDT 的陷阱门。② 错。缺页是**故障**，返回地址指向出错的那条指令，`iret` 回去**重试当前指令**，这次命中所以成功。③ 错。同类都是故障，但除零不可修复，内核只能转成 `SIGFPE` 或终止进程；缺页可以补页表。④ 错。`int3` 是陷阱（有意触发、返回下一条），同步与否不是分类依据，**返回地址**才是。⑤ 错。aarch64 用异常向量表（`VBAR_EL1`）与 `svc #0`，没有 x86 那种 256 项 IDT，出错地址在 `FAR_EL1` 而不是 `%cr2`。

**判据**：五句全判对得满分；只判对「对/错」但说不出返回地址或 `svc` 替代 `syscall` 的，算半对。第①③⑤句是必答点——它们正好是 x86 细节被当成通用真理的三处。

:::
:::

::: ex 例 1.8-A2 · fork 之后哪三样东西最容易想反 {#ex-1.8-A2}

填空并说明理由：① 父子进程的文件偏移（共享/独立）；② 子进程的 pending 信号（继承/清空）；③ 父进程自定义的 `SIGINT` 处理函数，子进程 `exec` 之后（保留/重置）。再解释 `nohup` 为什么能活过 `exec`。

::: sol 解答

① 共享——`fork` 复制 fd 表，但表项指向同一个打开文件描述，`f_pos` 在打开文件描述里；要独立偏移必须各自 `open`（`dup` 之后仍然共享）。② 清空——子进程不继承 pending，父进程挂在 pending 里的信号不会落到子进程。③ 重置——捕获的处置在新地址空间里没有意义，内核把它改回默认；但 `SIG_IGN` **保持忽略**，POSIX 明确规定。`nohup` 正是把 `SIGHUP` 设成 `SIG_IGN`，所以 `exec` 之后的程序仍然忽略挂断。

**判据**：①必须点出「fd 表复制、打开文件描述共享」这一层，只说「共享」不给理由算半对；③要能说出「忽略跨 exec 保留」这条 POSIX 规则。

:::
:::

::: ex 例 1.8-A3 · 1792 是从哪来的 {#ex-1.8-A3}

子进程 `return 7` 退出，父进程 `waitpid` 得到 `status`。① 直接 `printf("%d", status)` 打印什么？② 怎么拿到 7？③ 子进程被 `kill -TERM` 杀死时，`status` 是多少、用哪个宏取信号号？④ 想看「子进程被 `Ctrl-Z` 停住」，`waitpid` 要加什么标志？

::: sol 解答

① 1792，即 `7 << 8`：退出码放在低 8 位之上的那一段。② 用 `WIFEXITED(status)` 判断正常退出，再 `WEXITSTATUS(status)` 取值。③ 被信号杀死时整数值就是信号号本身（VM 实测 `raw=15`、`WIFSIGNALED=1`、`WTERMSIG=15`），用 `WTERMSIG` 取号、`WCOREDUMP` 看有没有 core。④ 加 `WUNTRACED`（要继续事件再加 `WCONTINUED`）；不加的话被停止的子进程不会让 `waitpid` 返回。

**判据**：①要给出 1792 这个具体数字并解释是移位而非随机值；②④必须写出宏名，不能用「有个函数可以拆」含糊过去。

:::
:::

::: ex 例 1.8-A4 · 三个子进程、两次 SIGCHLD {#ex-1.8-A4}

父进程 `signal(SIGCHLD, handler)`，handler 里只调一次 `waitpid(-1, NULL, 0)`。3 个子进程几乎同时退出。① 会来几次 `SIGCHLD`？② 最多留下几个僵尸？③ 正确写法是什么？④ 「忽略 `SIGCHLD`」与「捕获 `SIGCHLD`」有什么区别？

::: sol 解答

① 不保证 3 次。标准信号不排队，同一信号在 pending 期间再次产生只记一次，3 次退出可能合并成 1 次递送——本书实测是 **2 次**（一次运行的结果，不保证每次都一样）。② 最多留 2 个僵尸：一次 `waitpid` 只收一个。③ handler 里循环 `while (waitpid(-1, &st, WNOHANG) > 0)` 直到返回 0（没有可回收的）或 -1（出错），把「一个信号收一个」改成「一个信号收干净」。④ 默认动作是忽略，但父进程仍能 `wait` 到状态；显式 `SIG_IGN` 或 `SA_NOCLDWAIT` 会让子进程退出后自动回收、不产生僵尸。

**判据**：①不能答「3 次」；②要给出具体数字并能说出「一次 wait 收一个」；③必须是 `WNOHANG` 的循环，写成 `waitpid(-1, ..., 0)` 会阻塞到最后一个子进程退出，算错。

:::
:::

::: ex 例 1.8-A5 · SA_RESTART 的边界 {#ex-1.8-A5}

四个场景各判「会不会自动重启」：① 阻塞在 `read` 上的管道读，收到信号且设了 `SA_RESTART`；② 同一个 `read` 已经读到了 3 个字节；③ `epoll_wait`；④ `pause`。再说明为什么「设了 `SA_RESTART` 就不用处理 `EINTR`」是错的。

::: sol 解答

① 会重启，调用继续挂着直到有数据。② 不重启，返回短读 3——已经交付了数据就不能「重来」，否则数据会丢。③ 不重启，`epoll_wait` 永远返回 `EINTR`（`select`/`poll` 同理）。④ 不重启，`pause` 的语义就是「睡到下一次信号」，被信号唤醒正是它的正常返回。所以 `SA_RESTART` 只覆盖一部分可重启调用，而且短读、超时语义、`EINTR` 后的重试计数都要自己处理；健壮代码统一写 `do { r = read(...); } while (r < 0 && errno == EINTR);`。

**判据**：四问里 ②③ 是分水岭，只答「都会重启」的说明只记住了口号；能说出「已读部分数据不能重来」的算完整。

:::
:::

::: ex 例 1.8-A6 · 非本地跳转的四条规矩 {#ex-1.8-A6}

① `longjmp(env, 0)` 之后 `setjmp` 返回什么、为什么？② 哪些变量在跳回后不可信？③ `longjmp` 会执行中间函数里的 `free`、`pthread_mutex_unlock` 吗？④ 从信号处理函数里跳出去，为什么必须用 `sigsetjmp(env, 1)`？

::: sol 解答

① 返回 1：0 表示「首次进入 `setjmp`」，不能拿来当错误码，所以 0 被改成 1。② `setjmp` 之后被修改、又没有 `volatile` 的自动变量；C 标准只保证 `volatile` 变量的值被恢复，其余可能还是寄存器里的旧值。③ 不会。`longjmp` 只恢复寄存器，中间栈帧被直接丢弃，锁、堆、打开的文件都留在原状。④ 因为 handler 执行期间该信号被自动阻塞，普通 `setjmp` 不保存掩码，跳出去之后信号永久阻塞；`sigsetjmp(env, 1)` 保存掩码，`siglongjmp` 恢复它。

**判据**：①必须说「0 变 1」并给出理由；②必须点出 `volatile`；④必须提到「handler 期间信号被自动阻塞」。跳回后「值可能不对」不算完整答案，要说清是优化器把它留在寄存器里。

:::
:::

## B 组 · 诊断推理

::: ex 例 1.8-B1 · 日志里偶发的 EINTR {#ex-1.8-B1}

一个采集程序用 `read` 从管道取数据，`sa_flags = 0`。上线后每天有几次「读取失败」，`errno` 是 4，重跑就好。写出四段诊断，并说明加上 `SA_RESTART` 之后还剩什么问题。

::: sol 解答

现象是「偶发失败、重跑就好」，说明不是数据问题而是时序问题：信号在 `read` 阻塞期间到达，内核让调用返回 `-1`、`errno=EINTR`（值为 4），程序把它当致命错误退出了。机制是信号递送打断了慢系统调用，而 `sa_flags=0` 没让内核重启它。证据：VM 实测同一段代码，`flags=0` 时 0.105 s 后打印 `read=-1 errno=4(Interrupted system call)`；设 `SA_RESTART` 后调用被重启，0.305 s 时 `read=5`。修法是所有可能被信号打断的调用都写 `EINTR` 重试循环，并把 `EINTR` 与真正的错误分开处理。

加 `SA_RESTART` 之后仍剩三类问题：已经读到部分数据的 `read` 只返回短读，必须自己拼缓冲区；`epoll_wait`、`poll`、`nanosleep` 永远返回 `EINTR`；如果程序用 `alarm` 做超时，重启会让超时语义变味。

**判据**：必须写出 `errno` 的具体值 4 或名字 `EINTR`；必须给出「循环重试」的具体代码形态；只答「加 `SA_RESTART`」的算不完整，因为短读与非重启调用没解决。

:::
:::

::: ex 例 1.8-B2 · 服务跑三天，PID 快用完了 {#ex-1.8-B2}

一个常驻服务 fork 子进程处理任务，子进程自己退出。三天后 `ps` 里出现几百个 `[worker] <defunct>`，`fork` 开始返回 `EAGAIN`。写出四段诊断与三种修法。

::: sol 解答

现象是「僵尸堆积到耗尽 PID」。机制：子进程退出后内核保留退出状态等父进程 `wait`，父进程没等（或在别处阻塞），于是每个子进程留一个 `task_struct` 与一个 PID；僵尸不占内存，但 PID 有上限。证据：`ps -eo pid,ppid,stat,cmd` 里 `STAT` 为 `Z`、`CMD` 带 `<defunct>`；`ps -o ppid= -p <僵尸pid>` 找到父进程；父进程的 `/proc/<pid>/status` 通常能看出它卡在哪（`State: S` 加 `wchan`）。

三种修法：① 装 `SIGCHLD` 处理器（完整边界见 [1.8.11](ch08.md#sec-1.8.11)），里面 `while (waitpid(-1, &st, WNOHANG) > 0)` 循环收割（首选，注意信号不排队——见 A4）；② 显式给 `SIGCHLD` 设 `SIG_IGN`，或 `sigaction` 加 `SA_NOCLDWAIT`，让内核自动回收；③ 结构上改成「父进程定期 `waitpid(-1, ..., WNOHANG)` 轮询」或把回收交给 subreaper/PID 1（容器里由运行时负责，机制见 [1.8.9](ch08.md#sec-1.8.9)）。

**判据**：四段齐（现象、机制、证据命令、修法）；修法里必须有一条是「循环」而不是「一次 `wait`」，否则在合并场景下仍会漏。只答「加 `wait`」不说明在哪里加，算半对。

:::
:::

::: ex 例 1.8-B3 · kill 了没反应 {#ex-1.8-B3}

`kill -TERM <pid>` 返回 0，进程还在。列出四种可能，并给每种一条一行的判据命令。

::: sol 解答

① 信号被**阻塞**：读 `/proc/<pid>/status` 的 `SigBlk`，非零说明有掩码；`TERM` 是 15，对应第 15 位，`0000000000004000` 就是只阻塞了它。② 信号被**忽略或捕获但不退出**：看 `SigIgn`（忽略）与 `SigCgt`（捕获）里对应位；捕获了但 handler 只记日志，进程当然还在。③ 进程在**不可中断睡眠**（`D`）：`ps -o stat,wchan` 会显示 `D`，`kill -9` 也要等 I/O 返回；大量 `D` 通常意味着存储或网络文件系统卡住。④ 在多线程程序里，进程级信号只会递给**任意一个未阻塞它的线程**：某个线程把 `TERM` 屏蔽了，主线程却在 `futex` 里睡，信号可能落到不想处理它的线程上；判断要 `ls /proc/<pid>/task` 并逐线程读 `SigBlk`。

**判据**：四种里必须包含「阻塞」与「`D` 状态」这两条（它们最常被漏），并且每条都给出一条可执行的判据命令。只笼统说「可能被忽略了」不算。

:::
:::

::: ex 例 1.8-B4 · handler 里打了日志，程序却卡死 {#ex-1.8-B4}

一个程序在 `SIGALRM` 的 handler 里调 `printf("timeout\n")`，偶尔在日志中途卡住不再前进，`gdb` 附上去看到主线程停在 `malloc`。解释因果，并给出改法。

::: sol 解答

现象是「偶发卡死、栈落在 `malloc` 或 stdio 锁里」。机制：handler 可能在主程序执行 `malloc`／`printf` 的**中途**插入；`printf` 要拿 stdio 锁并可能 `malloc` 缓冲区，而这两个函数都不是异步信号安全的，重入就会死锁（主线程持锁，handler 等同一把锁）或破坏堆。证据：`gdb -p <pid>` 的 `bt` 会看到 `__lll_lock_wait` 一类帧；把 handler 改成只置 `volatile sig_atomic_t` 标志后不再复现。

改法：handler 只做一次赋值或 `write(2)`（POSIX 安全清单里），真正的日志在主循环里做；需要跨上下文传数据就用 self-pipe——handler 里 `write(pipefd[1], "x", 1)`，主循环 `poll` 读端；或者用 `signalfd` 把信号变成 fd 事件。**`printf`、`malloc`、`free`、`exit`、`strerror`、`pthread_mutex_lock` 都在禁用名单上**，`_exit` 才安全。

**判据**：必须点出「不是异步信号安全」这层机制而不是「多线程不安全」；改法必须给出「置标志」「self-pipe」「`signalfd`」中的至少两种，并说明主循环怎么接住。

:::
:::

::: ex 例 1.8-B5 · Ctrl-Z 之后 fg 回不去，后台进程一读终端就停 {#ex-1.8-B5}

① 你自己写的迷你 shell 里，`Ctrl-Z` 之后 `fg` 恢复不了作业；② 另一个后台作业一读终端就变成 `T` 状态。分别解释，并说出 `tcsetpgrp`/`tcgetpgrp` 各在哪一步用。

::: sol 解答

① 停是停了（终端驱动把 `SIGTSTP` 发给前台组），但 shell 没有把前台交回来，也没有在新作业启动时把前台交出去。完整链路见 [1.8.14](ch08.md#sec-1.8.14)：`fork` 后子进程 `setpgid(0, 0)`，父进程也 `setpgid(pid, pid)`（父子都设避免竞态），再 `tcsetpgrp(tty, pid)` 把前台给子进程；`waitpid(pid, &st, WUNTRACED)` 看到 `WIFSTOPPED` 就把作业记进后台表，并用 `tcsetpgrp(tty, shell_pgid)` 把前台还给 shell；`fg` 时再 `tcsetpgrp(tty, pgid)` 并发 `kill(-pgid, SIGCONT)`。② 后台组读终端会收到 `SIGTTIN`，**默认动作是停止**——这不是权限错误而是流控：终端输入同一时刻只能归一个前台组。VM 实测在 pty 里跑 `bash -m -c 'cat &'`，`ps -o stat` 显示 `T`，`kill -CONT` 之后才继续。

顺带一个反直觉的实测：非交互 `bash -c`（没开作业控制）里 `sleep &` 与 shell 同 `PGID`，`kill -TSTP` 停不住它；换 `bash -m -c` 才有独立 `PGID` 并能停在 `T`。所以「`&` 就自动得到独立进程组」是错的，是 shell 用 `setpgid` 做的。

**判据**：①必须出现 `tcsetpgrp` 且说清「交给子进程」和「还给 shell」两处；②必须答「`SIGTTIN` 的默认动作是停止」而不是「读失败/EOF」。能补出 `setpgid` 父子都调的理由（竞态）算加分。

:::
:::

::: ex 例 1.8-B6 · 跳出去之后锁没释放、变量还是旧值 {#ex-1.8-B6}

一段代码在持锁的 `update()` 里出错 `longjmp` 回主循环，之后所有 `pthread_mutex_lock` 都卡住；同时 `printf` 出来的 `attempt` 一直是 0。分别解释两条因果，并给出改法。

::: sol 解答

① 锁：`longjmp` 丢弃中间栈帧，`pthread_mutex_unlock` 那一行根本没执行，锁仍归本线程所有（对非递归锁再 `lock` 就死锁）。这不是「跳转不安全」，而是「跳转不做清理」——C 里没有析构函数。改法是把释放放到跳转之后能执行到的地方：`goto cleanup` 结构化收尾最稳；或者在 `setjmp` 成功的分支里显式解锁；或把锁改成「谁加谁解」的短临界区，别跨越可能跳转的调用。② 变量：`attempt` 在 `setjmp` 之后被修改、没有 `volatile`，优化器把它留在寄存器里，`longjmp` 只恢复寄存器快照，于是读到旧值。VM 实测同一份代码：`-O2` 打印 `plain=1 vol=42`，`-O0` 打印 `plain=42 vol=42`——**同一份源码，两个优化级别给两个答案**，这就是未定义行为的典型样子。改法是给跨跳转的变量加 `volatile`。

**判据**：两条因果都要落到机制（「清理不执行」「值留在寄存器」），不能只写「`longjmp` 不安全」；改法要能指出具体改哪一行。能报出 `-O2` 与 `-O0` 行为不同这一实测，说明真跑过。

:::
:::

## C 组 · 动手实验

::: ex 例 1.8-C1 · 把 status 字亲手拆开 {#ex-1.8-C1}

写一个 30 行以内的程序：① 子进程 `_exit(7)`，父进程打印 `status` 的原始值与 `WEXITSTATUS`；② 子进程死循环 `pause`，父进程 100 ms 后 `kill(SIGTERM)`，打印 `WIFSIGNALED` 与 `WTERMSIG`。两次都要能解释数字从哪来。

::: sol C1 核对

```c
/* status.c：两种终局，一个状态字 */
#define _GNU_SOURCE
#include <signal.h>
#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>

int main(void)
{
    pid_t p = fork();
    if (p == 0) _exit(7);                  /* 正常退出 */
    int st = 0;
    waitpid(p, &st, 0);
    printf("raw=%d WIFEXITED=%d WEXITSTATUS=%d\n",
           st, WIFEXITED(st), WEXITSTATUS(st));

    p = fork();
    if (p == 0) for (;;) pause();          /* 等信号 */
    usleep(100000);
    kill(p, SIGTERM);
    waitpid(p, &st, 0);
    printf("raw=%d WIFSIGNALED=%d WTERMSIG=%d\n",
           st, WIFSIGNALED(st), WTERMSIG(st));
    return 0;
}
```

```bash
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 status.c -o status && ./status
```

VM 实测输出（aarch64、GCC 13.3.0）：

```text
raw=1792 WIFEXITED=1 WEXITSTATUS=7
raw=15 WIFSIGNALED=1 WTERMSIG=15
```

判据：第一行必须是 1792，且你能说出 `1792 = 7 << 8`；第二行必须是 15（`SIGTERM` 的编号，`kill -l` 可查），`WIFSIGNALED` 为 1。看不到 1792 而看到 7，说明你打印的是 `WEXITSTATUS` 而不是 `status`；看不到 15 而看到 0，说明 `waitpid` 没等对进程。

`sudo` 不可用不影响这题：全部是自己的进程，不需要任何特权。要在 macOS 上跑，把 `usleep` 换成 `nanosleep` 更稳妥（`usleep` 已废弃但仍然可用）。

:::
:::

::: ex 例 1.8-C2 · 数出被合并掉的 SIGCHLD {#ex-1.8-C2}

fork 3 个子进程，让它们几乎同时退出；父进程的 handler 里只 `waitpid(-1, ..., 0)` 一次。① 数出 `SIGCHLD` 递送了几次；② 数出还剩几个僵尸；③ 加上循环收割，验证僵尸归零。

::: sol C2 核对

```c
/* merge.c：一个信号收一个 vs 收干净 */
#define _GNU_SOURCE
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

static volatile sig_atomic_t hits, reaped;
static int loop;                          /* 1 = 循环收割 */

static void on_chld(int s)
{
    (void)s;
    hits++;
    if (!loop) return;
    int st;
    while (waitpid(-1, &st, WNOHANG) > 0) reaped++;
}

int main(void)
{
    struct sigaction sa;
    memset(&sa, 0, sizeof sa);
    sa.sa_handler = on_chld;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = SA_RESTART | SA_NOCLDSTOP;
    sigaction(SIGCHLD, &sa, NULL);

    for (int i = 0; i < 3; i++)
        if (fork() == 0) { usleep(50000); _exit(0); }

    int st;
    waitpid(-1, &st, 0);                  /* 主流程只收一个 */
    sleep(1);
    printf("hits=%d reaped=%d\n", (int)hits, (int)reaped);   /* loop=1 时看这里 */

    pid_t q = fork();                     /* 用子进程去数，父进程必须还活着 */
    if (q == 0) {
        execlp("sh", "sh", "-c",
               "ps -o pid,stat,cmd --ppid $PPID | sed -n '1,10p'", (char *)NULL);
        _exit(2);
    }
    waitpid(q, NULL, 0);
    return 0;
}
```

先按 `loop = 0` 编译运行，VM 实测：

```text
    PID STAT CMD
 444904 Z    [merge] <defunct>
 444905 Z    [merge] <defunct>
 444906 S    sh -c ps -o pid,stat,cmd --ppid $PPID | sed -n '1,10p'
hits=2 reaped=0
```

再按 `loop = 1` 跑，实测 `hits=2 reaped=2`，`ps` 里一行 `Z` 都不剩。

判据：① `hits < 3`——这是「标准信号不排队」的直接证据，具体是 1 还是 2 取决于时序，不要拿某一次的 2 当承诺；② 至少留下 1 个 `Z`（实测 2 个），且 `PPID` 指向你的程序；③ 循环版必须是 0 个 `Z`，且 `reaped` 等于漏掉的数量。

两个读输出时的坑：`hits` 那行可能排在 `ps` 输出**后面**（stdout 是管道时有缓冲，而你 fork 出去的子进程直接写 fd），别以为程序没打印；`Z` 的 `CMD` 会显示成 `[merge] <defunct>`，名字取的是你起的二进制名。

一个实测踩到的坑值得记：**不能用 `execlp` 在父进程里直接跑 `ps`**——`execl` 会把父进程替换掉，僵尸立刻被 init 收养，`ps` 就一个也看不到，你会误判成「没有僵尸」。要数，就 fork 一个子进程去数。

:::
:::

::: ex 例 1.8-C3 · pause 睡死与 sigsuspend 的 2 秒差 {#ex-1.8-C3}

构造一个**必定**踩中「检查—睡眠空窗」的程序：先阻塞 `SIGINT`、`raise` 一次让它停在 pending，再走 `while (!stop) { 解除阻塞; pause(); }`。用 `alarm(2)` 兜底，量出 `pause` 到底等了多久；再把同一段换成 `sigsuspend`，量第二次。

::: sol C3 核对

```c
/* race.c：同一次 pending 信号，两种等待 */
#define _GNU_SOURCE
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

static volatile sig_atomic_t stop;

static void on_int(int s) { (void)s; stop = 1; }
static void on_alrm(int s) { (void)s; }

static double now(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec + ts.tv_nsec / 1e9;
}

int main(int argc, char **argv)
{
    int use_suspend = argc > 1 && !strcmp(argv[1], "suspend");
    struct sigaction sa;
    memset(&sa, 0, sizeof sa);
    sa.sa_handler = on_int;
    sigemptyset(&sa.sa_mask);
    sigaction(SIGINT, &sa, NULL);
    sa.sa_handler = on_alrm;
    sigaction(SIGALRM, &sa, NULL);

    sigset_t block, prev;
    sigemptyset(&block);
    sigaddset(&block, SIGINT);
    sigprocmask(SIG_BLOCK, &block, &prev);
    raise(SIGINT);                     /* 停在 pending */

    double t0 = now();
    alarm(2);                          /* 兜底：2 秒后打断睡眠 */
    if (use_suspend) {
        while (!stop) sigsuspend(&prev);           /* 原子：置掩码 + 睡眠 */
    } else {
        while (!stop) {
            sigprocmask(SIG_SETMASK, &prev, NULL); /* 信号在这一步递送 */
            pause();                               /* 然后照样睡下去 */
            break;
        }
    }
    printf("%s: %.3f s, stop=%d\n", argv[1], now() - t0, (int)stop);
    return 0;
}
```

```bash
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 race.c -o race
./race pause      # expect: pause: 2.00x s, stop=1
./race suspend    # expect: suspend: 0.000 s, stop=1
```

VM 实测就这两行（两次运行分别是 2.001 s 与 2.003 s，`sigsuspend` 两次都是 0.000 s）：

```text
pause: 2.003 s, stop=1
suspend: 0.000 s, stop=1
```

判据：`pause` 版的耗时必须≈2 s（`alarm` 的兜底）**且** `stop` 已经是 1——`stop=1` 却还在睡，就是空窗的证明；`sigsuspend` 版必须小于 0.05 s。如果你的 `pause` 版 0.000 s 就返回了，说明信号是在 `pause` 之后才到，没踩中窗口，把 `raise` 挪到阻塞之后、`alarm` 之前再试。

**加做（10 行）**：把 `pause` 换成管道上的 `read`，一次 `sa_flags = 0`、一次 `SA_RESTART`，另一个进程 100 ms 后发 `SIGUSR1`、再 200 ms 后写 5 个字节。VM 实测：`flags=0 read=-1 errno=4(Interrupted system call) after 0.105 s`；`flags=268435456 read=5 after 0.305 s`——两个数字就是 A5 那道判断题的证据。

不需要 `sudo`：`alarm`、`sigsuspend`、`pipe` 都是纯用户态与自有进程。

:::
:::

::: ex 例 1.8-C4 · 把一次 fork/exec/wait 读成时间线 {#ex-1.8-C4}

用 `strace -f -e trace=process,signal` 跑一个 fork + `execvp` + `waitpid` 的程序（[1.8.11](ch08.md#sec-1.8.11) 的 `spawn.c` 就行），回答：① `clone` 的 flags 里有没有 `CLONE_VM`，说明什么？② `wait4` 的第二个参数显示成什么？③ `--- SIGCHLD ---` 的 `si_code` 是什么？④ 再用 `/proc/<pid>/status` 证明你的程序装了 `SIGCHLD` 与 `SIGINT` 处理器。

::: sol C4 核对

```bash
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 spawn.c -o spawn
./spawn /bin/sh -c 'exit 7'
strace -f -e trace=process,signal ./spawn /bin/sh -c 'exit 7' 2>&1 | head -20
```

VM 实测（aarch64、strace 6.8、glibc 2.39）的关键几段：

```text
rt_sigaction(SIGCHLD, {sa_handler=0x..., sa_mask=[], sa_flags=SA_RESTART|SA_NOCLDSTOP}, NULL, 8) = 0
clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLDstrace: Process 441432 attached
, child_tidptr=0x...) = 441432
[pid 441432] execve("/bin/sh", ["/bin/sh", "-c", "exit 7"], ...) = 0
[pid 441432] rt_sigaction(SIGINT, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
[pid 441432] exit_group(7)              = ?
<... wait4 resumed>[{WIFEXITED(s) && WEXITSTATUS(s) == 7}], 0, NULL) = 441432
--- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=441432, si_status=7, ...} ---
```

① 没有 `CLONE_VM`，所以是**进程**而不是线程（线程会有 `CLONE_VM|CLONE_FILES|CLONE_THREAD`）。② 状态被 strace 解码成宏表达式 `WIFEXITED(s) && WEXITSTATUS(s) == 7`，比手拆 `status` 直观。③ `si_code=CLD_EXITED` 说明正常退出，若是被信号杀死会是 `CLD_KILLED`；`kill` 发来的信号则是 `SI_USER`。④

```bash
grep -E 'SigPnd|ShdPnd|SigBlk|SigIgn|SigCgt' /proc/<pid>/status
# 1.8.11 的 spawn.c 装了两个 handler，VM 实测：
# SigCgt: 0000000000010002
#   第 1 位（SIGINT=2）与第 16 位（SIGCHLD=17）
```

判据：四问都要给出字段名与值，并能把「没有 `CLONE_VM`」「`CLD_EXITED`」「`SigCgt` 的 `0002` 是 SIGINT、`0001 0000` 是 SIGCHLD」对上号。只抄一段 trace 不解释不算通过。另外 trace 里那行 `rt_sigaction(SIGINT, NULL, {sa_handler=SIG_DFL, ...})` 是子进程 `exec` 之后 shell 在查自己的处置——正好演示「捕获的 handler 跨 exec 被重置」，能指出这一行算加分。

两个环境限制要先知道（都在 VM 上实测）：① `dmesg` 会报 `read kernel buffer failed: Operation not permitted`（`dmesg_restrict=1`，而你没有 `CAP_SYSLOG`），替代路径是 `journalctl -k`；② `strace -f` 在 trace 里会把 `strace: Process N attached` 插进 `clone` 那一行，看起来像输出被截断，实际是 strace 的排版产物，把行拼起来读即可；③ `strace -p` 会暂停目标进程，且本机 `ptrace_scope=1`，只能附着自己拥有的进程——排查生产问题更该用 `perf trace` 或 eBPF，但那需要权限，本环境未实测。

:::
:::
