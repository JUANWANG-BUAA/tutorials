# 2.1 闭卷回忆卡

这一页是检索练习，不是摘要。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。22 张卡分三组：**A 组考进内核与报告失败（2.1.1–2.1.4）**，**B 组考特性宏、运行时限制与可移植性（2.1.5–2.1.8、2.1.11）**，**C 组考 ABI、错误码映射、资源限制与取证（2.1.9–2.1.17）**。建议学完当天、隔天、第 3 天、第 7 天各做一次，只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 进内核与报告失败

::: method 回忆 1 · 一次 `read` 的六步与两次翻译
不看正文画出 `read(fd, buf, n)` 从用户栈到内核再回来的路径，标出六个步骤；「两次翻译」分别发生在哪一层？
::: sol 答案
① 调用 glibc 的 `read()` 包装函数（不是内核）；② 包装函数把调用号放 `rax`、参数按 ABI 放 `rdi/rsi/rdx`；③ `syscall` 指令切特权级（ring 3 → ring 0），`RIP` 跳到内核注册的 `entry_SYSCALL_64`；④ 保存用户寄存器，`do_syscall_64()` 按 `rax` 查 `sys_call_table` → `ksys_read` → `vfs_read` → `file->f_op->read_iter`；⑤ 返回值放 `rax`：`≥0` 是字节数，`<0` 是 `-errno`（内核约定）；⑥ glibc 检查 `rax`，负数就设 `errno = -rax` 并返回 `-1`。两次翻译：**内核用负数表示错误 → libc 翻译成 `-1` 加 `errno`**；**C 的函数原型 → 架构规定的寄存器摆放**（ABI）。编号是内核 ABI，不是 libc 的私有约定，所以不要自己写 `syscall` 指令。
:::
:::

::: method 回忆 2 · `syscall` 与 `int 0x80` 的五个维度
两者在 x86-64 内核上都能进内核，差别在哪五个维度？在 64 位程序里用 `int 0x80` 传栈上指针会出什么事？
::: sol 答案
① 调用号来源不同：`syscall` 用 `syscall_64.tbl`，`int 0x80` 用 `syscall_32.tbl`，**编号不一样**；② 参数寄存器不同：前者 `rdi/rsi/rdx/r10/r8/r9`，后者 `ebx/ecx/edx/esi/edi/ebp`；③ 指针宽度：`int 0x80` 把指针截断成 32 位；④ 返回：`rax` 与 `eax`，都用负数表示错误；⑤ 性能：`syscall` 不经过中断控制器，`int 0x80` 要走中断门，更慢。在 64 位程序里用 `int 0x80` 调 `SYS_write` 用的是 32 位调用号，指针高 32 位丢失，轻则 `EFAULT`，重则写坏地址——旧教程里常见，不要抄。
:::
:::

::: method 回忆 3 · vDSO：不陷入内核的「系统调用」
哪些调用常走 vDSO？它为什么快？vDSO 是通用机制吗？它的地址能当常数写进代码吗？
::: sol 答案
`gettimeofday()`、`clock_gettime(CLOCK_REALTIME/CLOCK_MONOTONIC)`、`time()`、`getcpu()` 这类极高频、只需要读内核维护的几个变量的调用。内核把一小段代码（virtual dynamic shared object，虚拟动态共享对象）映射进每个进程的地址空间，libc 先看这里有没有实现，有就在用户态读完返回——**没有陷入指令、没有特权级切换**，所以比 `getpid` 快一个数量级。它不是通用机制：你不能把自己写的函数塞进去，它是内核与 libc 之间的性能约定。地址每次 `exec` 都随 ASLR 变，只能运行时找：本机连跑两次 `LD_SHOW_AUXV=1 /bin/true | grep AT_SYSINFO_EHDR` 得到 `0xe3adbdc48000` 与 `0xe4c30b400000`，`grep -E 'vvar|vdso' /proc/self/maps` 里的 `[vvar]`/`[vdso]` 也在同一段随机高位；正文那行 `0x7ffd...` 是 x86-64 的形态，aarch64 不是这个位置。
:::
:::

::: method 回忆 4 · 系统调用与库函数凭什么分
`man` 的 2/3/7 分节各收什么？分节是本质区别吗？给出本章的判据，并用它判 `printf`、`write`、`malloc`、`mmap`、`getpid`、`clock_gettime` 六个。
::: sol 答案
`man 2` 系统调用（内核入口的薄包装），`man 3` 库函数（libc 实现），`man 7` 概念、协议与约定。分节不是本质：`fork()` 在 man 2、`malloc()` 在 man 3，而 `getpid()` 名义是系统调用、`clock_gettime()` 名义也是系统调用却常不陷入。判据：**这个函数是否直接或间接执行一条陷入内核的指令，以及它承诺的语义由谁保证**。逐个：`printf` 格式化与缓冲都在用户态，满缓冲或换行才 `write`（libc 保证，C 标准）；`write` 一次系统调用，数据进 page cache（内核保证，POSIX）；`malloc` 在堆上切块，必要时才 `brk`/`mmap`（libc）；`mmap` 建立 VMA 与映射（内核）；`getpid` 读 `task_struct->pid`，glibc 2.25 后每次都进内核（内核）；`clock_gettime` 通常读 vDSO（内核 + libc 协作）。`strace` 里看到的是 `write`，不是 `printf`。
:::
:::

::: method 回忆 5 · `syscall(2)` 与三个误解
`syscall(2)` 是干什么的、什么时候该用？它比包装函数少了什么？「`printf` 是系统调用」「系统调用一定切换进程」「调用号可以写死」这三条为什么错？
::: sol 答案
`long syscall(long number, ...)` 是 libc 提供的通用逃生口：当某个系统调用还没有包装函数（新内核特性、小众接口）时用它，参数按 ABI 顺序最多 6 个。它仍做 `errno` 翻译，但**不做任何类型检查**，参数类型与指针有效性全靠自己——所以新代码优先用包装函数，只有 man 手册明说「glibc 没有提供包装」才用 `syscall()`。三条误解：① `printf` 不是系统调用，格式化与缓冲在用户态；② 同一进程从用户态陷入内核再返回是**模式切换**（mode switch），不是上下文切换，没调度到别的进程时开销只是保存/恢复寄存器；③ 调用号是架构相关的 ABI：`SYS_read` 在 x86-64 是 0、在 ARM64 是 63，写死数字的代码换架构会调错函数且编译器不报错。
:::
:::

::: method 回忆 6 · `errno` 的七条规则
按重要性说出七条；哪两条最容易被写反？`pthread_mutex_lock` 该怎么判失败？
::: sol 答案
① 先看返回值再看 `errno`（`errno == 0` 不代表成功，`!= 0` 不代表这次失败）；② 成功不清 `errno`（POSIX 明确允许），要复用先 `errno = 0`；③ `errno` 是线程局部的，两个线程各自失败互不覆盖，别当进程级状态传；④ 需要后续继续用时先 `int saved = errno;`，因为 `fprintf`/`strerror`/`free` 都可能改它；⑤ 不是所有函数都设 `errno`：`strtol` 用、`snprintf` 截断不设、`pthread_*` 直接返回错误码；⑥ `EINTR` 是「被打断」不是失败，可重试的调用要单独处理；⑦ `strerror` 不保证线程安全，多线程用 `strerror_r`，注意 GNU 版返回 `char *`、XSI 版返回 `int`。最易写反的是 ①（拿 `errno` 当成败标志）与 ④（打印前不保存）。`pthread_*` 返回 0 是成功、非 0 是错误码本身，写 `== -1` 永远不成立；正确是判 `rc != 0` 并把 `rc`（不是 `errno`）交给 `strerror`。
:::
:::

::: method 回忆 7 · `errno_demo` 的三行各证明什么
`errno_demo` 打印三行：第二行为什么关键？第三行是怎么造出 `EINTR` 的？`sigaction` 里哪个标志位没设、为什么？
::: sol 答案
第一行 `open 失败: errno=2 (No such file or directory)` 证明失败会设 `errno`；第二行「成功之后 `errno` 仍是 2」是关键证据——`open("/etc/hosts")` 明明成功了，`errno` 还是上一次的 2，任何「`errno != 0` 就算出错」的代码在这里都会误判；第三行 `read 被 SIGALRM 打断, got_alarm=1` 证明 `EINTR` 是可区分的「被打断」。做法：`pipe()` 出一个没人写的管道，`read` 阻塞在 `p[0]`；`alarm(1)` 1 秒后发 `SIGALRM`，处理器只做 `got_alarm = 1`（`volatile sig_atomic_t`）；`sa.sa_flags = 0` **故意不设 `SA_RESTART`**，被信号打断的 `read` 才会返回 `-1` 且 `errno == EINTR`，否则内核会把调用重启，看不到这个分支。
:::
:::

::: method 回忆 8 · 三层错误处理与选择顺序
`errMsg`/`errExit`/`errExitEN` 各自的行为与适用场合是什么？`err.c` 的三个设计点是什么？在信号处理器里有什么额外限制？
::: sol 答案
`errMsg`：打印并返回，`errno` 保持不变，用于库与可恢复错误；`errExit`：打印后 `exit(EXIT_FAILURE)`，用于启动阶段与不可恢复错误；中间层：返回 `-1` 透传 `errno`，让调用者决定。三个设计点：① `vErr` 入口先 `int saved = errno;`、返回前还原，这样 `errMsg(...); return -1;` 之后 `errno` 仍是原始错误；② 用 `vsnprintf` 而不是 `snprintf`，因为要传 `va_list`，缓冲区固定 1024，超长截断；③ `errExitEN(errnum, ...)` 接收显式错误号，专门给 `pthread_*` 这类「返回错误码、不设 `errno`」的接口。选择顺序：调用者能恢复（`EAGAIN`/`EINTR`/`ENOENT`）→ 返回 `-1` 并保留 `errno`；不能恢复但进程还有别的事 → 记日志、关掉这个连接继续；不能恢复且继续跑会出错（配置解析失败、特权丢失）→ `errExit`；在**信号处理器**里 → 只能用 `write` 加预先格式化好的字符串，不能用 `fprintf`/`strerror`（它们不是异步信号安全，见 [2.10 信号](ch10.md)）。
:::
:::

## B. 特性宏、运行时限制与可移植性

::: method 回忆 9 · 特性测试宏是什么、写在哪
给特性测试宏下定义。它控制什么、不控制什么？为什么写在 `#include <stdio.h>` 之后等于没写？本书为什么统一用编译命令？
::: sol 答案
特性测试宏（feature test macro）是在**包含任何系统头文件之前**定义的预处理宏，用来告诉 libc「我要求哪一版标准、允许哪些扩展」。它控制**声明是否可见**，不改变运行时行为。`<features.h>` 是 glibc 的总开关，任何系统头都会先包含它；它只在第一次被包含时按当时已定义的宏算出 `__USE_*` 系列，之后再定义特性宏不会重算——所以晚于第一个系统头就失效。统一用命令行 `-D_GNU_SOURCE` 有两个理由：从翻译单元第 0 个字符就生效；而且命令行已定义时源码再 `#define` 一次，在 `-Werror` 下会报 `macro redefined`。
:::
:::

::: method 回忆 10 · 四个宏 + 显式 POSIX 宏关掉默认扩展
`_POSIX_C_SOURCE=200809L`、`_XOPEN_SOURCE=700`、`_DEFAULT_SOURCE`、`_GNU_SOURCE` 各是什么用途？显式定义 `_POSIX_C_SOURCE` 后哪些接口会失去声明，最坏结果是什么？四个坑是什么？
::: sol 答案
`_POSIX_C_SOURCE=200809L`：只要 POSIX.1-2008，适合可移植的库；`_XOPEN_SOURCE=700`：POSIX + XSI（`700` 对应 SUSv4），需要 `openpty` 这类 XSI 接口；`_DEFAULT_SOURCE`：glibc 的默认扩展集（`MSG_NOSIGNAL`、`strdup` 等），也就是「什么都不写时的状态」；`_GNU_SOURCE`：打开全部（POSIX + BSD + GNU），Linux 上的系统程序常用。关键细节：**一旦显式定义 `_POSIX_C_SOURCE`，glibc 就不再默认定义 `_DEFAULT_SOURCE`**，于是 `accept4`、`pipe2`、`dup3`、`signalfd`、`epoll_create1`、`MSG_NOSIGNAL` 失去声明；C17 下未声明函数只是警告，链接时可能碰巧成功——能跑但行为未定义，是最坏组合。四个坑：① 在 `.c` 里 `#define _GNU_SOURCE` 必须早于任何 `#include`，最稳是命令行；② 定义了 `_GNU_SOURCE` 后再定义 `_POSIX_C_SOURCE` 收不回扩展；③ 不要在头文件里定义（包含顺序不可控）；④ `-std=c17` 会打开 `__STRICT_ANSI__`，glibc 因此隐藏部分默认扩展——这就是「`-std=gnu17` 能编、`-std=c17` 不能」的常见原因。
:::
:::

::: method 回忆 11 · 宏矩阵与 ABI 宏
`_GNU_SOURCE` 隐式打开了哪些？`-std=gnu17` 等于 `_GNU_SOURCE` 吗？`_FILE_OFFSET_BITS=64` 和 `_TIME_BITS=64` 为什么不只是「多几个声明」？`__USE_GNU` 能自己写吗？怎么用编译期把 ABI 假设锁住？
::: sol 答案
`_GNU_SOURCE` 隐式定义 `_DEFAULT_SOURCE`、`_POSIX_C_SOURCE=200809L`、`_XOPEN_SOURCE=700`、`_ISOC99_SOURCE`、`_ISOC11_SOURCE`；反过来不成立（定义 `_POSIX_C_SOURCE` 后没有 `_DEFAULT_SOURCE`，BSD 扩展全消失）。`-std=gnu17` 只是不打开 `__STRICT_ANSI__`，让 GCC 语言扩展可用，glibc 的 `_GNU_SOURCE` 仍要显式定义。`_FILE_OFFSET_BITS=64` 把 `off_t` 与 `stat`/`fstat`/`lseek`/`mmap` 的声明重定向到 64 位版本，`struct stat` 布局随之改变，所以它**改的是 ABI**，用不同宏编出来的目标文件混链会坏；`_TIME_BITS=64` 要 64 位 `time_t`，glibc 要求同时定义 `_FILE_OFFSET_BITS=64`，否则编译报错。`__USE_GNU`/`__USE_XOPEN2K8`/`__USE_MISC` 是 `<features.h>` 算出来的，手写无效且可能破坏头文件逻辑，只能通过特性宏间接控制。锁住假设：`_Static_assert(sizeof(off_t) == 8, "需要 64 位 off_t：加 -D_FILE_OFFSET_BITS=64");`、`_Static_assert(sizeof(time_t) >= 8, ...)`——比运行时报错早，也比注释可靠。
:::
:::

::: method 回忆 12 · `sysconf`/`pathconf` 的返回值三态
三个接口分别查什么？`long` 返回值的三种结果是什么？为什么调用前必须 `errno = 0`？哪个接口最容易踩这个坑、为什么？
::: sol 答案
`sysconf(int name)` 查系统级（页大小、CPU 数、fd 上限）；`pathconf(const char *path, int name)` 查路径所在文件系统（`NAME_MAX`、`PATH_MAX`）；`fpathconf(int fd, int name)` 同上但用已打开的 fd。三态：`>= 0` 是限制值；`-1` 且 `errno == 0` 表示该限制**不确定**（indeterminate，没有固定上限）；`-1` 且 `errno != 0` 才是查询失败（`EINVAL` 说明名字不合法）。因为 `-1` 有二义性，正确形状是 `errno = 0; long v = sysconf(...); if (v == -1 && errno != 0) 失败; else if (v == -1) 不确定; else 用 v;`。`pathconf` 更容易踩，因为文件系统上「不确定」很常见（网络文件系统、伪文件系统都可能不给固定上限）。
:::
:::

::: method 回忆 13 · 哪些数能查、哪些数不能抄
说出 `_SC_PAGESIZE`、`_SC_OPEN_MAX`、`_SC_CLK_TCK`、`_SC_NPROCESSORS_ONLN`、`_SC_ARG_MAX`、`_PC_NAME_MAX`、`_PC_PATH_MAX`、`_PC_PIPE_BUF` 各是什么，以及各自的「注意」。为什么不能分配 `PATH_MAX` 字节的栈缓冲区然后假设够用？
::: sol 答案
`_SC_PAGESIZE` 页大小（常 4096，ARM64 内核可编成 16384 或 65536）；`_SC_OPEN_MAX` 在 glibc 上返回本进程 `RLIMIT_NOFILE` **软限制**，不是系统 fd 总数；`_SC_CLK_TCK` 是 `times()` 的时钟频率（`/proc/PID/stat` 的时间单位）；`_SC_NPROCESSORS_ONLN` 在线 CPU 数（Linux 扩展，需 `_GNU_SOURCE`，容器里可能被 cgroup 限制）；`_SC_ARG_MAX` 是 `exec` 的参数 + 环境总长上限（还受栈的 `RLIMIT_STACK` 影响，改栈限制它就变）；`_PC_NAME_MAX` 单个文件名最大长度，随文件系统变（ext4 255，eCryptfs 可能 143）；`_PC_PATH_MAX` 路径最大长度（Linux 上常 4096，但**不是保证**，且路径解析本身没有硬性总长限制）；`_PC_PIPE_BUF` 决定一次 `write` 到管道是否原子（不超过它就保证不与其他写者交错）。`PATH_MAX` 那条的实际做法：用 `getcwd(NULL, 0)` 或 `realpath(path, NULL)` 让 libc 分配，遇到 `ERANGE` 再扩容。
:::
:::

::: method 回忆 14 · `uname`、`sysinfo` 与 `/proc`、`sysfs`
`struct utsname` 六个字段是什么、它读的是什么？`sysinfo` 的两个坑是什么？`/proc` 与 `/sys` 各是什么？取 `/proc` 里的数字有什么纪律？
::: sol 答案
`uname(2)` 填 `sysname`/`nodename`/`release`/`version`/`machine`/`domainname`，返回 0 或 `-1`（`EFAULT`）；它读的是内核启动时固定的字符串，**不反映运行时变化**。`sysinfo(2)` 给 uptime、负载、内存总量/可用量、进程数，两个坑：内存字段单位是 `mem_unit` 个字节（要乘，老内核上可能大于 1），`freeram` 不含可回收的 page cache（想知道「应用还能拿多少」要看 `MemAvailable`）。`/proc` 是进程与内核状态的**文本投影**（`/proc/self/status`、`maps`、`fd/`、`/proc/meminfo`、`/proc/sys/vm/*`），`sysfs`（`/sys`）是设备与驱动的**对象模型**（`/sys/class/net/eth0/mtu`、`/sys/fs/cgroup/`）。纪律：`/proc` 的数字列宽会变，**不要用 `awk '{print $2}'` 依赖列位置**，用 `grep '^VmRSS:'` 再取第二个字段，或读字段顺序稳定的 `/proc/PID/stat`（单位要换算）。另一点：`/proc` 可写但不是磁盘文件——写 `/proc/sys/vm/dirty_ratio` 会调内核的 sysctl 处理函数；`/proc/self/mem` 能读写自己的地址空间（调试器就这么做），偏移无效则 `EIO`；把它当普通文件 `mmap` 或任意 `seek` 会得到莫名其妙的结果。
:::
:::

::: method 回忆 15 · 提交前的十条可移植性检查
说出至少七条；第 9 条（`char` 的符号性）为什么在 x86 上测不出来、在 ARM 上必现？第 10 条「编两次」是哪两次？
::: sol 答案
① 特性测试宏在命令行，不在源文件中间 `#define`；② 不用裸数字：调用号 `SYS_*`、信号 `SIG*`、权限 `S_IRUSR`、错误 `E*`；③ 不用 `int` 装 `size_t`/`off_t`/`pid_t`，用 `ssize_t`/`off_t`/`pid_t`，打印用 `%zd`、`%jd` 或 `PRIdMAX`；④ 限制运行时查（`sysconf`/`pathconf`/`getrlimit`），不抄 `OPEN_MAX`/`NAME_MAX`；⑤ 跨网络/跨文件格式做字节序转换（`htonl`/`ntohl`），不直接把结构体 `write` 到文件；⑥ 路径拼接用 `snprintf` 并检查返回值，不 `strcat`，不假设 `/tmp` 可写或 `/bin/sh` 存在；⑦ 错误码按名字判断，不写 `errno == 11`；⑧ `long` 不等于指针（Windows LLP64 下 `long` 是 32 位），用 `intptr_t`/`uintptr_t`；⑨ `char` 的符号性；⑩ 编两次：`-std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror` 与 `-std=c17 -D_POSIX_C_SOURCE=200809L` 各一次，看扩展依赖在哪。第 ⑨ 条：`EOF` 是 `-1`，`getchar()` 返回 `int`；存进 `char` 后在无符号 `char` 的平台上 `0xFF` 变成 255，与 `-1` 永远不等，循环不终止。x86-64 上 `char` 默认有符号，所以测不出来；ARM 上默认无符号，必现。
:::
:::

## C. ABI、错误映射、资源限制与取证

::: method 回忆 16 · 四架构 ABI 与六个参数位
填出 x86-64 / i386 / ARM64 / RISC-V 64 的陷入指令、调用号寄存器、参数寄存器与返回寄存器。x86-64 为什么第四个参数用 `r10` 而不是 `rcx`？为什么超过六个参数改成传结构体，`clone3` 的 `size` 字段解决什么？
::: sol 答案
x86-64：`syscall`、`rax`、`rdi/rsi/rdx/r10/r8/r9`、返回 `rax`；i386：`int 0x80`、`eax`、`ebx/ecx/edx/esi/edi/ebp`、返回 `eax`；ARM64：`svc #0`、`x8`、`x0`–`x5`、返回 `x0`；RISC-V 64：`ecall`、`a7`、`a0`–`a5`、返回 `a0`。用 `r10` 是因为 `syscall` 指令本身要用 `rcx` 保存返回地址（`rip` 下一条），`rcx` 不能拿来传参数。六不是内核随便定的，而是「能自由传参的寄存器数量 − 返回地址占用」的结果；再多要用栈，而 `syscall` 的换栈由内核控制，用户栈指针不能直接当参数。所以超过六个参数一律传一个指向结构体的指针：`clone3`（`struct clone_args *`）、`openat2`（`struct open_how *`）、`io_uring_setup`（`struct io_uring_params *`）、`bpf`（`union bpf_attr *`）。结构体里的 `size` 字段让内核知道用户态用的是哪个版本，新字段可以追加而不破坏旧程序——这是「ABI 只能加不能改」的实现手法。
:::
:::

::: method 回忆 17 · `EFAULT`、seccomp 与 32 位时间
用户态传野指针给 `read`，进程收到 `SIGSEGV` 吗？为什么内核不能直接解引用用户内存？`access_ok()` 通过能保证不 `EFAULT` 吗？容器里 `openat` 对合法路径返回 `EPERM` 最常见的原因是什么？32 位 `time_t` 溢出带来哪两个可观察后果？
::: sol 答案
不收到 `SIGSEGV`：内核的 `copy_to_user`/`copy_from_user` 会捕获缺页并返回未拷贝的字节数，系统调用最终返回 `-EFAULT`。内核不能直接解引用用户指针，否则一个恶意指针就能让内核崩溃。`access_ok()` 只检查地址范围是否落在用户空间，**不保证页已映射**；真正的映射检查发生在拷贝时，所以「用 `read` 探测地址是否可写」不可靠：`EFAULT` 只说明这次拷贝失败，`access_ok` 通过也不代表不会 `EFAULT`。`EPERM` 在容器里最常见是 seccomp 过滤器：`SECCOMP_RET_ERRNO` 让调用直接返回指定错误码，看起来像普通失败（默认动作才是杀进程），要查 `docker inspect` 的 `SecurityOpt`/seccomp 或 `strace` 确认。32 位时间：① `stat` 大文件可能返回 `EOVERFLOW`（`st_size` 放不下），用 `stat64` 或 `-D_FILE_OFFSET_BITS=64`；② 直接 `syscall(SYS_clock_gettime, ...)` 在新 glibc 的 32 位上可能调错——用户态结构是 64 位、内核旧入口期望 32 位，所以不要绕过包装函数（除非你在写 libc）。
:::
:::

::: method 回忆 18 · `strerror_r` 的两个版本与等价错误码
两个版本各返回什么、由什么决定？GNU 版有一个什么坑？`EAGAIN`/`EWOULDBLOCK`、`ENOTSUP`/`EOPNOTSUPP`、`ENODATA`/`ENOATTR`、`ENOTSUP`/`ENOSYS` 这四组各是什么关系？写 `if (errno == ENOTSUP || errno == EOPNOTSUPP)` 有什么问题？
::: sol 答案
XSI/POSIX 版返回 `int`（0 成功，非 0 是错误码）；GNU 版返回 `char *`（可能指向你给的缓冲区，也可能指向静态字符串）。同一个函数名两种签名，由是否定义 `_GNU_SOURCE` 决定；可移植写法是 `strerror_l`（POSIX.1-2008）或按 `_GNU_SOURCE` 分支。GNU 版的坑：错误码未知时它可能返回 `"Unknown error 1234"` 这样的静态字符串而不是写进 `buf`，所以不能假设返回值等于 `buf`，也不能 `free` 它。四组关系：`EAGAIN == EWOULDBLOCK`（Linux 上都是 11，非阻塞「暂时不可用」）；`ENOTSUP == EOPNOTSUPP`（都是 95，POSIX 允许它们不同）；`EDEADLK == EDEADLOCK`（35，历史别名）；Linux 只有 `ENODATA`，macOS 用 `ENOATTR`，跨平台要 `#ifdef`；而 `ENOTSUP != ENOSYS`——前者「这个对象不支持这个操作」，后者「内核里没有这个系统调用」。那句 `||` 在 Linux 上是重复条件，GCC 可能报 `-Wlogical-op`；本机写 `errno == EOPNOTSUPP` 就够，跨平台再包一层宏。原则：**判断时写名字不写数字，但也不要假设两个名字一定不等**。
:::
:::

::: method 回忆 19 · 错误码到对外语义
`ENOENT`、`EACCES`、`EINVAL`、`ENOSPC`、`EMFILE`、`EAGAIN`、`ETIMEDOUT`、`EINTR`、`EIO` 分别映射到什么 HTTP 状态码、是否重试？退出码用哪套约定？`exit(256)` 的脚本里 `$?` 是多少、为什么？
::: sol 答案
`ENOENT`→404 不重试；`EACCES`/`EPERM`→403 不重试（权限或 LSM 拒绝）；`EINVAL`→400 不重试（常是调用方 bug）；`ENOSPC`/`EDQUOT`→507 不重试；`EMFILE`/`ENFILE`→503 退避重试；`EAGAIN`/`EWOULDBLOCK`→503 + `Retry-After` 重试；`ETIMEDOUT`→504 视语义；`EINTR` 不应到达协议层，在循环里重试；`EIO`→500 不重试但要告警（设备/文件系统错误）。进程侧用 `sysexits.h`：`EX_USAGE`(64)、`EX_DATAERR`(65)、`EX_NOINPUT`(66)、`EX_UNAVAILABLE`(69)、`EX_OSERR`(71)、`EX_IOERR`(74)。`exit(256)` 的实际退出码是 **0**，因为退出码只有 8 位（256 mod 256 = 0）——这是「程序明明失败了但 `$?` 是 0」的常见原因。
:::
:::

::: method 回忆 20 · 三层限制与 `RLIMIT_*`
「还能开多少 fd」有三个数：`sysconf(_SC_OPEN_MAX)`、`ulimit -n`、`/proc/sys/fs/nr_open`。它们在 Linux/glibc 上各属于哪一层？程序该按哪个分配 fd 表？限制排查的五步顺序是什么？`RLIMIT_CPU`、`RLIMIT_FSIZE`、`RLIMIT_NPROC`、`RLIMIT_NOFILE`、`RLIMIT_AS`、`RLIMIT_STACK` 超限时各发生什么？非特权进程能不能提高硬限制？
::: sol 答案
三层：内核全局上限（`fs.nr_open`、`fs.file-max`，约束所有进程）；进程资源限制（`getrlimit(RLIMIT_NOFILE)` 的软/硬限制）；POSIX 查询接口（`sysconf(_SC_OPEN_MAX)`，glibc 上返回**软限制**，是 `RLIMIT_NOFILE` 的投影，不是独立第三层）。所以要按软限制分配 fd 表、以 `getrlimit` 为准（或读 `/proc/self/limits`），按 `nr_open` 分配会先撞上 `EMFILE`。排查五步：① 进程 `cat /proc/PID/limits`；② 内核 `sysctl fs.nr_open fs.file-max`、`/proc/sys/fs/pipe-max-size`；③ 文件系统 `stat -f /path`、`fpathconf` 的 `NAME_MAX`/`PIPE_BUF`；④ 容器/cgroup：systemd 的 `LimitNOFILE=`、Kubernetes 的 `ulimits`、`/sys/fs/cgroup/.../pids.max`；⑤ 不要用 `_SC_OPEN_MAX` 推断系统总量。超限后果各不相同：`RLIMIT_CPU` 软限发 `SIGXCPU`、硬限 `SIGKILL`；`RLIMIT_FSIZE` 发 `SIGXFSZ`，忽略信号则 `write` 返回 `EFBIG`；`RLIMIT_NPROC` 让 `fork/clone` 返回 `EAGAIN`（按 real UID 计进程/线程数）；`RLIMIT_NOFILE` 让 `open/socket` 返回 `EMFILE`；`RLIMIT_AS` 让 `mmap/brk` 返回 `ENOMEM`（是虚拟地址空间，不是 RSS 上限）；`RLIMIT_STACK` 只在主线程栈溢出时 `SIGSEGV`，`pthread` 栈不受它限制。规则：`rlim_cur <= rlim_max`；非特权进程可以降低硬限制但**升不回来**，提高硬限制需要 `CAP_SYS_RESOURCE`；`fork`/`exec` 继承限制；跨进程读写用 `prlimit(2)`（需要权限）。
:::
:::

::: method 回忆 21 · `getopt_long` 的返回值与三个开关
`struct option` 四个字段是什么？`getopt_long` 的六种返回值？`optstring` 开头的 `:` 与 `+` 各改变什么？`optind = 0` 和 `optind = 1` 差在哪？长选项缩写为什么危险？`--color always` 为什么拿不到参数？
::: sol 答案
`struct option { const char *name; int has_arg; int *flag; int val; }`，`has_arg` 取 `no_argument`/`required_argument`/`optional_argument`；`flag == NULL` 时返回 `val`，非 `NULL` 时把 `val` 写进 `*flag` 并返回 0。返回值六种：短选项字符；`val`（`flag == NULL`）；`0`（`flag != NULL`）；`'?'` 未知选项或参数缺失（`opterr = 0` 时不打印）；`':'` 表示缺参数（仅当 `optstring` 以 `:` 开头）；`-1` 解析结束。`optstring` 开头的 `:` 关闭 getopt 自己的报错，并让缺参数返回 `':'` 而不是 `'?'`；开头的 `+` 表示遇到第一个操作数就停止（保持 POSIX 顺序），环境变量 `POSIXLY_CORRECT` 等价于加 `+` 且全局生效；`--` 强制结束选项解析。GNU 默认会**重排** `argv` 把选项集中到前面。`optind` 是下一个待处理参数的下标，解析后 `argv[optind]` 起是操作数；`optind = 0` 是 GNU 的「重新初始化内部状态」（含重新检查 `POSIXLY_CORRECT`），`optind = 1` 只是回到开头、不重置。长选项唯一前缀缩写可用（`--col=never` 匹配 `--color`），但一旦新增同前缀选项（`--count` 与 `--color`）缩写就变 ambiguous 并返回 `'?'`，脚本里不要依赖。`optional_argument` 的长选项必须写 `--color=always`，`--color always` 里的 `always` 会被当成操作数而不是参数。另外它用全局状态（`optind`/`optarg`/`optopt`），多线程同时解析会互相踩。
:::
:::

::: method 回忆 22 · 内核路径与两条取证通道
`do_sys_openat2()` 为什么「先分配 fd 再打开文件」？`vfs_read()` 那十几行能解释哪三个现象？为什么 `strace` 看不到 `vfs_read`？`strace -yy` 的输出里 `= 3</etc/ld.so.cache>` 告诉你什么？`/proc/self/fdinfo/3` 的四个字段与 `/proc/self/syscall` 的第一列分别是什么？
::: sol 答案
`do_sys_openat2`：`build_open_flags` → `getname`（把用户字符串搬进来）→ `get_unused_fd_flags` 在 fd 表里**先占一个号** → `do_filp_open`；打开失败就 `put_unused_fd` 归还，成功才 `fd_install` 装上 `struct file *`。先占号是为了让返回给用户态的 fd 在安装前不会被其他线程抢走。`vfs_read` 的三现象：① `count` 超过约 2 GiB 会被 `MAX_RW_COUNT`（`INT_MAX & PAGE_MASK`）截断，一次 `read` 读不了更多；② 对只写 fd 返回 `EBADF`（`FMODE_READ` 检查），对不支持读的 fd 返回 `EINVAL`；③ 坏缓冲区返回 `EFAULT`（`access_ok` 先拦，真正拷贝失败由 `copy_to_user` 决定）。`strace` 只观察**系统调用边界**，所以看到的是 `read(3, ...) = 12`；`vfs_read`、`filemap_read`、`ext4_file_read_iter` 在内核里，要用 `perf probe`/`bpftrace`/`ftrace`——本书的 VM 上 `sudo` 与 `perf` 都不可用，这一类按「未实测」读。`-yy` 把 fd 翻译成路径：`= 3</etc/ld.so.cache>` 之后动态链接器关掉它，`/lib/aarch64-linux-gnu/libc.so.6` 又拿到同一个 3，说明 **fd 号是复用的**，日志只记数字会指错对象；`pipe2([3<pipe:[...]>, 4<pipe:[...]>], 0)` 说明 `pipe()` 在这台机器上确实由 `pipe2` 落地（aarch64 没有 `pipe` 这个调用号），但 flags 是 0、**没有 `O_CLOEXEC`**：正文那行写着 `O_CLOEXEC`，所以「`pipe()` 会原子设 CLOEXEC」不能当结论，要 CLOEXEC 就显式调 `pipe2(..., O_CLOEXEC)`。`/proc/self/fdinfo/3` 给的是这个 fd 的内核状态：`pos`（共享偏移当前值）、`flags`（八进制，是内核的 `f_flags`，不等于用户态 `O_*` 的简单相加）、`mnt_id`（挂载 ID，可与 `/proc/self/mountinfo` 对上）、`ino`。本机实测只读打开 `/etc/hosts` 是 `pos: 0` / `flags: 0400000` / `mnt_id: 35` / `ino: 2755550`；这个 `0400000` **不是** `O_LARGEFILE`——本机 `<fcntl.h>` 里 `O_LARGEFILE`=0、`O_NOFOLLOW`=`0100000`、`O_DIRECTORY`=`040000`、`O_CLOEXEC`=`02000000`，位值本身随架构变，认位要靠「开两个 flags 不同的 fd 做差」而不是背正文那张表。`/proc/self/syscall` 第一列是**当前正在执行的系统调用号**（正文示例的 `0` 是 x86-64 的 `read`，本机 `cat /proc/self/syscall` 打印的第一列是 63），后面是六个参数寄存器、栈指针与程序计数器；读别人的 `/proc/PID/syscall` 会被 `ptrace_scope=1` 挡住（`Operation not permitted`），所以这条只对自家进程可靠。
:::
:::
