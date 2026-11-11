# 2.7 学习目标自检表

这张表接管 [2.7.9 本章小结](ch07.md#sec-2.7.9)原有的达标线：正文那张 6 条出口表已抄存于此（正文末节已改为「本章小结」），再按**概念（K）、动手（S）、实验（E）、口径（B）**四组展开成 20 条，每条都写成能当场做的动作。动手前先确认环境边界：测试机是 aarch64 VM，`sudo` 不可用、`ptrace_scope=1`，哪些能做、哪些只能按「未实测」读，全在[勘误与版本注记](ch07-errata.md)。

## 出口表（接管自 2.7.9）

| 检查项 | 达标线 | 没达标去哪 |
|:--|:--|:--|
| 说出 `fork` 后哪些资源复制、哪些共享 | 至少覆盖 fd、信号、锁、定时器 | [2.7.1](ch07.md#sec-2.7.1) |
| 用 COW 区分映射与物理页 | 能手算 4 页例题，解释 RSS 不变而 PSS 增长 | [2.7.2](ch07.md#sec-2.7.2) |
| 解释多线程 fork 的死锁窗口 | 能举 `malloc` 锁的例子 | [2.7.3](ch07.md#sec-2.7.3) |
| 区分 `exit`/`_exit` 的四步差异 | 能复现 stdio 重复输出 | [2.7.5](ch07.md#sec-2.7.5) |
| 用 `waitpid` 处理四类事件 | 代码能编译并跑出 stopped/continued | [2.7.6](ch07.md#sec-2.7.6) |
| 解释僵尸占什么、怎么回收 | 能说出 `SA_NOCLDWAIT` 的代价 | [2.7.6](ch07.md#sec-2.7.6) |

## 达标检验

| 检查项 | 达标线 | 回哪一节 |
|:--|:--|:--|
| **K1 fork 返回值与继承清单** | 能说出返回值三分支（父>0、子0、失败-1）与 `EAGAIN` 的四个上限；把继承对象分成复制/共享/清零三类，至少覆盖 fd、信号处置、未决信号、定时器、记录锁、`cwd` | [2.7.1](ch07.md#sec-2.7.1) |
| **K2 fd 表 vs 打开文件描述** | 能解释「fd 表复制但表项指向同一 `struct file`」所以偏移共享、`cwd` 不共享（在 `fs_struct`）；说出 `flock` 继承而 `fcntl` 记录锁不继承 | [2.7.1](ch07.md#sec-2.7.1)、[2.7.7](ch07.md#sec-2.7.7) |
| **K3 COW 三步与断裂点** | 能说出「复制页表→PTE 标只读→写时缺页才复制」；断裂以页为单位；`MAP_PRIVATE` 触发 COW、`MAP_SHARED` 不触发且写入互相可见 | [2.7.2](ch07.md#sec-2.7.2) |
| **K4 RSS/PSS/物理页手算** | 能手算 4 页例题三时刻的 RSS/PSS/物理页；解释「子写后 RSS 不翻倍但物理页翻倍」与「RSS 之和重复算共享页」 | [2.7.2](ch07.md#sec-2.7.2) |
| **K5 多线程 fork 死锁窗口** | 能举 malloc arena 锁三步死锁；说出「只复制调用线程」与 async-signal-safe 限制；`pthread_atfork` 救不了 libc 内部锁 | [2.7.3](ch07.md#sec-2.7.3) |
| **K6 exit/_exit/atexit 四步** | 能说出 exit 四步顺序、_exit 跳过 atexit 与 flush；atexit 逆序、fork 继承、exec 清除、信号致死不跑；退出码低 8 位 | [2.7.5](ch07.md#sec-2.7.5) |
| **K7 僵尸与孤儿** | 能说出僵尸占 PID/`task_struct` 不占内存页、`kill -9` 无效、两条回收路径；孤儿过继 init/subreaper；`PR_SET_PDEATHSIG` 先 prctl 再查 getppid | [2.7.6](ch07.md#sec-2.7.6) |
| **K8 SIGCHLD 与免僵尸代价** | 能说出标准信号合并、处理器里 `while WNOHANG` 收干净；`SIG_IGN`/`SA_NOCLDWAIT` 免僵尸但 `waitpid` 从此 `ECHILD` | [2.7.6](ch07.md#sec-2.7.6) |
| **S1 最小 fork+waitpid 循环** | 合上正文写出 fork 三分支 + 子进程 `_exit` + 父进程 `waitpid` 检查 `EINTR` 的完整代码，编译零警告 | [2.7.1](ch07.md#sec-2.7.1) |
| **S2 COW smaps 观察** | 能跑 `lab2c7_cow` 并报出 fork 后 `Shared_Dirty`=65536、子写后双方 `Private_Dirty` 各 65536（64 MiB 区域） | [2.7.2](ch07.md#sec-2.7.2)、[习题 C2](ch07-exercises.md) |
| **S3 exit vs _exit 对照** | 能跑 `lab2c7_flush` 重定向到文件，报出 `_exit` 版 count=1、`exit` 版 count=2，并指出两个 atexit PID | [2.7.5](ch07.md#sec-2.7.5)、[习题 C4](ch07-exercises.md) |
| **S4 waitpid 四类事件** | 能编译 `reap_children` 跑出 exited/signaled/stopped/continued 四类，说出 `WUNTRACED|WCONTINUED` 各管什么 | [2.7.6](ch07.md#sec-2.7.6) |
| **S5 waitid WNOWAIT 先看后收** | 能跑 `lab2c7_waitid` 报出 WNOWAIT 后仍 Z、`si_code=1 si_status=7`，再 waitpid 回收；区分 `si_pid==0` 与 ECHILD | [2.7.8](ch07.md#sec-2.7.8)、[习题 C6](ch07-exercises.md) |
| **S6 SIGCHLD while 循环** | 能写出 `SIGCHLD` 处理器里 `while (waitpid(-1,&st,WNOHANG)>0)` 并保存恢复 errno，说出为什么不能只 wait 一次 | [2.7.6](ch07.md#sec-2.7.6) |
| **E1 strace 认 clone/clone3** | 可在本机用 `strace -e trace=clone,clone3` 报出 fork→`clone`（调用号 220）、posix_spawn→`clone3(CLONE_VM|CLONE_VFORK|CLONE_CLEAR_SIGHAND)`；grep 确认无 `__NR_fork` | [2.7.7](ch07.md#sec-2.7.7)、[习题 C5](ch07-exercises.md) |
| **E2 僵尸取证** | 能构造僵尸并用 `ps -o stat` 看到 Z、`kill -9` 返回 0 但无效、`waitpid` 后 ps 查无此进程 | [2.7.6](ch07.md#sec-2.7.6)、[习题 C3](ch07-exercises.md) |
| **E3 共享偏移实验** | 能跑 `lab2c7_offset` 报出子进程 lseek 到 500 后父进程读出 500，证明偏移共享 | [2.7.1](ch07.md#sec-2.7.1)、[习题 C1](ch07-exercises.md) |
| **E4 CLD 常量与 si_status** | 能报出本机 `CLD_EXITED=1/KILLED=2/STOPPED=5/CONTINUED=6`，并按 si_code 读 si_status（退出码 vs 信号号） | [2.7.8](ch07.md#sec-2.7.8)、[习题 C6](ch07-exercises.md) |
| **B1 数字归属** | 能把本章数字分四类：规范条款（退出码低 8 位）、本机读数（`__NR_clone`=220、CLD_STOPPED=5、smaps 65536）、随架构/glibc 变的量（fork 走哪个调用、posix_spawn 用 clone 还是 clone3）、未实测（多线程死锁确定性复现、clone 特权 flag）；每类各举一例 | [勘误与版本注记](ch07-errata.md) |
| **B2 本机环境边界** | 能报出测试机口径（aarch64、内核 7.0.0-38、glibc 2.39、cgroup v2），说出 aarch64 无 fork 系统调用、`sudo` 不可用挡住哪些实验、`ptrace_scope=1` 对取证的影响 | [章总览·环境口径](ch07-overview.md)、[勘误页](ch07-errata.md) |

## 没达标怎么办

- **K 组卡住**：每个概念先讲一句完整因果再说下一步。例：「因为 fd 表项指向同一个 `struct file`、偏移存在 `struct file` 里，所以父子偏移共享；而 `cwd` 在每进程一份的 `fs_struct` 里，所以不共享」。讲不出因果就回对应小节重读，不要多刷几遍文字。
- **S 组卡住**：合上正文在 `/tmp/lab2c7_` 前缀下重做对应程序（习题 C 组有编译命令）；跑不出先核对头文件与编译选项（`-D_GNU_SOURCE` 不要在源文件里重复 `#define`，否则 `-Werror` 报重定义）。
- **E 组卡住**：先确认命令在本机哪些跑不了（`sudo` 挡住 clone 特权 flag、`ptrace_scope=1` 挡住 `strace -p`），把这些「跑不了」本身当读数记下来，不要改成「凭印象的输出」。
- **B 组卡住**：把想引用的每个数字问三遍：这是条款、本机读数，还是随架构/glibc 变的量？后两类必须带出处。[勘误页](ch07-errata.md)的「复跑校正」表就是示范——尤其别拿 x86-64 的 `fork` 系统调用常识套这台 aarch64。
- **只有 K 组全对**：说明还停在「会读」。本章要求会跑、会取证；把 S 组与 E 组做完再来勾这一页。

全部达标后，往下的接口有两处：[2.8 程序执行与子进程监控](ch08.md) 讲 `fork` 的另一半 `execve`（本章子进程「立刻 exec」的那一步）；项目侧 [项目 A](../projects/pa.md) 的 `mycontainer`（PID 1 回收、clone 进命名空间）与 [项目 D](../projects/pd.md) 的 `mysh`（fork+exec+wait、作业控制）都以本章为前置。