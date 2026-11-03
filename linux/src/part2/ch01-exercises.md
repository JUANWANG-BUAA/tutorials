# 2.1 习题集

三组分层：**A 组概念判断**考「会画、会说理由、会把层与层的关系讲清」；**B 组诊断推理**给现象让你判层、判契约、判修法；**C 组动手实验**在本书的 Ubuntu 24.04.5 aarch64 虚拟机上免 `sudo` 复现本章的关键证据。全部附解答与判据；先独立完成，再展开对照。每题的第一个动作都是「先猜」：把预期写下来，再去验证；猜错的地方才是这题的价值。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟；A 组要求口述或写一段完整因果，B 组要求写成「现象 → 机制 → 证据 → 修法」四段，C 组要求先写下预期读数再敲命令。
2. 卡住了回对应小节的「即时自测」或 `errata` 盒重读，不要直接看答案：A 组对应 2.1.1–2.1.11，B 组对应 2.1.3–2.1.16，C 组对应 2.1.3–2.1.15。
3. C 组的命令都在 Ubuntu 24.04.5（aarch64、内核 7.0.0-38、GCC 13.3.0、glibc 2.39、4 vCPU）上设计；源码一律从正文抄（`errno_demo.c`、`limits.c`、`limits2.c`、`feature_matrix.c`、`abi_probe.c`、`opts.c`），临时文件统一用 `lab2c01_` 前缀，实验结束删掉。
4. **`sudo` 与 `perf` 不可用**：`cc`、`strace`、`getconf`、`uname`、`ulimit`、`namei`、`sysctl`（读）、`/proc`、`/sys` 可用；2.1.14 结尾的 `sudo bpftrace`/`sudo perf probe`、2.1.7 里写 `/proc/sys/vm/*` 的动作一律跳过并标「未实测」。`strace` 只用「在 strace 下启动程序」的方式（`strace ./prog`），`strace -p <别人的 PID>` 可能被 `ptrace_scope` 挡住。
5. **正文有四处标着或暗示 x86-64 的读数**（2.1.2 的纳秒数、2.1.6 的 `limits` 输出、2.1.9 的调用号、2.1.15 的 `strace` 与 `fdinfo`）。C 组里的每一条预期都已经在这台 aarch64 机器上复跑过；凡是你看到的与正文不一样的地方都是正常的，要写出差异并解释，不要改数字去迁就正文。
6. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch01-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 2.1-A1 · 一次 `read` 的六步与两个翻译 {#ex-2.1-A1}

先猜：`read()` 返回 `-1` 那一刻，`errno` 里那个数是内核写的还是 libc 写的？内核自己看到的错误长什么样？

不看正文画出 `read(fd, buf, n)` 从用户态到内核再返回的完整路径，标出六步；指出「两次翻译」分别发生在哪一层、各翻译什么；说明为什么「永远不要自己写 `syscall` 指令」，以及 `syscall(2)` 比包装函数少做了什么。

::: sol 解答

六步：① 用户调用 glibc 的 `read()` 包装函数；② 包装函数把调用号写进 `rax`、参数按 ABI 放进 `rdi`/`rsi`/`rdx`；③ `syscall` 指令把特权级从 ring 3 切到 ring 0，`RIP` 跳到内核注册的 `entry_SYSCALL_64`；④ 内核保存用户寄存器，`do_syscall_64()` 按 `rax` 在 `sys_call_table` 取函数指针 → `ksys_read` → `vfs_read` → `file->f_op->read_iter`；⑤ 返回值放 `rax`：`≥0` 是字节数，`<0` 是 `-errno`；⑥ 回到 glibc，它检查 `rax`，为负就把 `errno` 设成 `-rax` 并返回 `-1`。两次翻译：**错误表示法**（内核的 `-ENOENT` ↔ C 世界的 `-1` + `errno`，翻译在 libc）与**接口形态**（C 函数原型 ↔ 寄存器摆放，翻译也在 libc 的包装函数里）。所以 `errno` 里那个数是 libc 写的，内核从来没见过 `errno`——它只返回负数。不要自己写陷入指令的理由：调用号与参数寄存器是**架构相关的 ABI**（x86-64 `syscall`/`rax`/`rdi...`、ARM64 `svc #0`/`x8`/`x0–x5`、i386 `int 0x80`/`eax`/`ebx...`），写死编号或寄存器换架构就调错函数，编译器不会报错；`syscall(2)` 帮你排寄存器并做 `errno` 翻译，但**不做类型检查**，参数类型和指针有效性全靠自己，所以只在 man 手册明说「glibc 没有提供包装」时用它。

**判据**：六步顺序对、能指出查表发生在 `do_sys_call` 而不是 libc；两个翻译点都落在 libc 层；说出至少两组架构差异（陷入指令 + 调用号寄存器）；能解释 `syscall()` 少做的是类型检查。

:::
:::

::: ex 例 2.1-A2 · `getpid` 进内核、`clock_gettime` 常不进 {#ex-2.1-A2}

先猜：同样标在 `man 2`，`getpid()` 和 `clock_gettime()` 的实际路径一样吗？把两者的耗时差记成「`getpid` 慢 15 倍」，能搬到别的机器上讲吗？

给出「系统调用 vs 库函数」的判据（不是 `man` 分节），并逐个判断 `printf`、`write`、`malloc`、`mmap`、`getpid`、`clock_gettime` 走不走内核、语义由谁保证。再说清 vDSO 是什么、为什么它快、哪些调用能用它、为什么不能把自己写的函数放进去，以及正文那组纳秒数该怎么读。

::: sol 解答

判据一条：**这个函数是否直接或间接执行一条陷入内核的指令，以及它承诺的语义由谁保证**。`man 2`/`man 3` 只是手册排版。逐个：`printf` 在用户态格式化并缓冲，满/换行才 `write`（libc，C 标准）；`write` 一次系统调用，数据进 page cache（内核，POSIX）；`malloc` 在堆上切块，必要时才 `brk`/`mmap`（libc）；`mmap` 建立 VMA 与映射（内核）；`getpid` 读 `task_struct->pid`，glibc 2.25 起不再缓存、每次都进内核（内核）；`clock_gettime` 先看 vDSO 有没有实现，有就在用户态读完返回（内核 + libc 协作）。vDSO（virtual dynamic shared object）是内核映射进每个进程地址空间的一小段代码，读的是内核维护的共享数据页，没有陷入、没有特权级切换，所以便宜一个数量级；能用它的只有内核已经准备好的那几类高频只读调用（`clock_gettime`/`gettimeofday`/`time`/`getcpu`），它是内核与 libc 之间的性能约定，不是给应用扩展的机制。关于那组数：正文标的是 x86-64 虚拟机，`syscall(SYS_getpid)` 约 318 ns、`getpid()` 约 316 ns（两者几乎相等，正说明 `getpid` 没走 vDSO）、`clock_gettime` 约 19 ns。**要记的是「一次陷入 ≈ 数百纳秒、一次 vDSO 读 ≈ 数十纳秒」这个量级关系**，绝对值属于那台机器；本机的测试环境是 aarch64，要引用必须先自己重跑（见 [C2](ch01-exercises.md#ex-2.1-C2)），并写清 `uname -m`、编译器与 flags。

**判据**：判据表述不含「看 man 分节」；六个函数判断全对且说出保证者；`getpid` 与 `clock_gettime` 的差能说成「是否陷入」；对纳秒数的处理是「量级关系 + 归属机器」而不是照抄。

:::
:::

::: ex 例 2.1-A3 · `errno` 七条规则里最关键的三条 {#ex-2.1-A3}

先猜：`if (errno != 0) 报错` 为什么是错的？`errno` 是进程里只有一个的全局变量吗？`pthread_mutex_lock(&m) == -1` 为什么永远不成立？

写出七条规则；解释 `errno` 为什么可以在线程间互不干扰（glibc 里它是怎么展开的）；给出「成功但 `errno` 仍是上次的值」的具体场景；说明 `pthread_*` 与 `strerror` 各自的返回值约定，以及为什么 `strerror_r` 有两种写法。

::: sol 解答

七条：① 先看返回值再看 `errno`；② 成功**不保证**清 `errno`（POSIX 明确允许），要复用先 `errno = 0`；③ `errno` 是线程局部的；④ 要跨过后续调用就先 `int saved = errno;`；⑤ 不是所有函数都设它（`strtol` 设，`snprintf` 截断不设，`pthread_*` 直接返回错误码）；⑥ `EINTR` 是「被打断」不是失败，要重试；⑦ `strerror` 不保证线程安全，用 `strerror_r`，而它有 GNU（返回 `char *`）与 XSI（返回 `int`）两个不兼容版本。`errno` 不是普通全局变量：glibc 把它定义成宏 `(*__errno_location())`，指向的是 libc 线程局部存储里的一个 `int`，所以两个线程各自失败互不覆盖；也正因它是一个函数调用形式，自写的裸汇编陷入或某些非 libc 环境根本不会碰它。具体误判场景：正文 `errno_demo` 里 `open("/nonexistent/file")` 失败把 `errno` 设成 2，紧接 `open("/etc/hosts")` **成功**返回有效 fd，但 `errno` 仍是 2——按「`errno != 0` 就报错」写会把成功当失败。`pthread_*` 返回 0 表示成功、非 0 就是错误码本身，所以判 `rc != 0` 并把 `rc` 传给 `strerror`，而不是读 `errno`（`== -1` 永远不成立）。`strerror_r` 的两个版本由是否定义 `_GNU_SOURCE` 决定，GNU 版可能返回静态字符串而不写你的缓冲区，所以可移植做法是 `strerror_l` 或按宏分支。

**判据**：七条全出且不把 ② 说成「成功会清零」；说出 `(*__errno_location())` 与线程私有；复现出「成功但 `errno` 非 0」的场景；`pthread_*` 与 `strerror_r` 两处都答对。

:::
:::

::: ex 例 2.1-A4 · 三层封装与「该不该退出」 {#ex-2.1-A4}

先猜：`errMsg` 打印完之后，调用者读到的 `errno` 是原始错误还是被打印过程改过的值？`pthread_mutex_lock` 失败时 `errMsg` 能打印出正确文本吗？

说明 `errMsg`/`errExit`/`errExitEN` 三者的行为与适用场合；解释 `err.c` 的三个设计点（为什么先存 `errno`、为什么用 `vsnprintf`、`errExitEN` 为什么必须存在）；给出「这个错误该怎么处理」的四步判断顺序；指出在信号处理器里为什么不能用 `fprintf`/`strerror`。

::: sol 解答

三层：`errMsg` 打印并返回、保持 `errno` 不变（库、可恢复错误）；`errExit` 打印后 `exit(EXIT_FAILURE)`（启动阶段、不可恢复）；中间层返回 `-1` 透传 `errno`，让调用者决定。三个设计点：① `vErr` 第一句 `int saved = errno;`、返回前 `errno = saved;` 还原——这样调用者 `errMsg(...); return -1;` 之后 `errno` 仍是原始错误，因为 `fprintf`/`strerror` 内部可能调 `malloc`/`write`/locale 相关函数并改写它；② 用 `vsnprintf` 是因为参数已经是 `va_list`，`snprintf` 不能接 `va_list`，缓冲区固定 1024、超长截断（错误信息不需要无限长）；③ `errExitEN(errnum, ...)` 接收显式错误号，专供 `pthread_*` 这类**不设 `errno`** 的接口——此时 `errMsg` 只能看到 `errno`，那里可能还是上一次无关调用的残留值。四步顺序：调用者能恢复吗（`EAGAIN`/`EINTR`/`ENOENT`）→ 能就返回 `-1` 保留 `errno`；不能恢复但进程还有别的事（一个连接坏了）→ 记日志、关掉它、继续；不能恢复且继续运行会出错（配置解析失败、特权丢失）→ `errExit`；在信号处理器里 → 只能 `write` + 预先格式化好的字符串。最后一条的理由：`fprintf` 会取 stdio 锁、可能 `malloc`，`strerror` 可能返回静态缓冲区并被并发调用改写，而信号可能打断一个持有这些资源的调用——后果是死锁或读到半成品，这正是异步信号安全（async-signal-safe，信号处理器里只允许的那一小撮函数）要防的事（见 [2.10 信号](ch10.md)）。

**判据**：三层的「行为 + 场合」不混；三个设计点各说出原因（尤其 `va_list` 那条）；`errExitEN` 与 `pthread_*` 绑定；四步顺序完整；信号处理器的理由说出「锁/分配/静态缓冲区」中至少两条。

:::
:::

::: ex 例 2.1-A5 · 为什么 `-D_GNU_SOURCE` 是必需的 {#ex-2.1-A5}

先猜：`-D_POSIX_C_SOURCE=200809L` 会让程序「少几个函数」还是「少几个声明」？为什么 `#define _GNU_SOURCE` 写在 `#include <stdio.h>` 后面没用？

解释特性测试宏控制的是什么、`<features.h>` 与 `__USE_*` 系列怎么工作；说明为什么显式定义 `_POSIX_C_SOURCE` 之后 `accept4`/`pipe2`/`strdup` 会失去声明；说明 `-std=c17` 与 `-std=gnu17` 的差别是不是等于 `_GNU_SOURCE`；说出 `_FILE_OFFSET_BITS=64` 与 `_TIME_BITS=64` 为什么属于 ABI 而不只是声明。

::: sol 解答

特性测试宏控制**声明是否可见**，不改变运行时行为：接口在 libc 里一直存在，宏只决定头文件给不给你看。`<features.h>` 是总开关，任何系统头都会先包含它，它只在**第一次被包含时**按当时已定义的宏算出 `__USE_GNU`/`__USE_XOPEN2K8`/`__USE_MISC` 这些内部标记；写在 `#include <stdio.h>` 之后时 `features.h` 已经算完，等于没定义。`_GNU_SOURCE` 会隐式打开 `_DEFAULT_SOURCE`、`_POSIX_C_SOURCE=200809L`、`_XOPEN_SOURCE=700`、`_ISOC99/11_SOURCE`；反过来，一旦显式定义 `_POSIX_C_SOURCE`，glibc 不再默认给 `_DEFAULT_SOURCE`，BSD/GNU 扩展（`accept4`、`pipe2`、`dup3`、`signalfd`、`epoll_create1`、`MSG_NOSIGNAL`、`strdup`）就失去声明。`-std=gnu17` 只是不打开 `__STRICT_ANSI__`，让 GCC 语言扩展可用，**不等于** `_GNU_SOURCE`：glibc 的 GNU 扩展接口仍要显式定义；`-std=c17` 打开 `__STRICT_ANSI__`，glibc 因此隐藏一部分默认扩展，这就是「同一份代码 `gnu17` 能编、`c17` 不能」的常见原因，本书的写法是 `-std=c17 -D_GNU_SOURCE` 两者同时显式。`_FILE_OFFSET_BITS=64` 把 `off_t` 变 64 位并把 `stat`/`fstat`/`lseek`/`mmap` 重定向到 64 位版本，`struct stat` 的**大小与字段布局**随之改变；`_TIME_BITS=64` 把 `time_t` 换成 64 位且 glibc 要求同时定义 `_FILE_OFFSET_BITS=64`。它们改的是符号版本与结构体布局，所以是 ABI：不同宏编出来的目标文件混链会坏。把假设写进 `_Static_assert(sizeof(off_t) == 8, "...")` 能在编译期就拦住。

**判据**：说清「声明可见性 vs 运行时行为」；`features.h` 只算一次、顺序敏感的机制说对；`_POSIX_C_SOURCE` 关掉 `_DEFAULT_SOURCE` 的因果说对；明确 `gnu17 ≠ _GNU_SOURCE`；能说出 `_FILE_OFFSET_BITS` 改结构体布局这一层。

:::
:::

::: ex 例 2.1-A6 · 六参数上限与结构体扩展 {#ex-2.1-A6}

先猜：`mmap` 刚好六个参数是巧合吗？为什么 `clone3` 不直接多加几个参数，而要传一个带 `size` 的结构体指针？

填出四架构的陷入指令、调用号寄存器、参数寄存器与返回寄存器；解释 x86-64 为什么第四个参数用 `r10` 而不是 `rcx`、为什么系统调用最多六个参数；列出改传结构体的四个调用与各自的结构体；说明 `size` 字段带来的演进能力，以及为什么用户态传坏指针得到的是 `EFAULT` 而不是 `SIGSEGV`。

::: sol 解答

| 架构 | 陷入指令 | 调用号 | 参数寄存器 | 返回 |
|:--|:--|:--|:--|:--|
| x86-64 | `syscall` | `rax` | `rdi`、`rsi`、`rdx`、`r10`、`r8`、`r9` | `rax` |
| i386 | `int 0x80` | `eax` | `ebx`、`ecx`、`edx`、`esi`、`edi`、`ebp` | `eax` |
| ARM64 | `svc #0` | `x8` | `x0`–`x5` | `x0` |
| RISC-V 64 | `ecall` | `a7` | `a0`–`a5` | `a0` |

`r10` 而非 `rcx`：`syscall` 指令自身要用 `rcx` 存返回地址（`RIP` 的下一条），`r11` 存 `RFLAGS` 快照，所以 `rcx` 不能拿来传参数，第四个位置顺延到 `r10`；这个细节从 C 源码看不出来，但手写汇编时必须遵守。六不是内核随手定的数，而是「可用于传参的寄存器数量减去被陷入指令占用的」结果；再多就得用栈传，而 `syscall` 的换栈过程由内核控制，用户栈指针不能直接当参数——所以超过六个参数的系统调用一律改成传一个指向结构体的指针：`clone3` 的 `struct clone_args *`、`openat2` 的 `struct open_how *`、`io_uring_setup` 的 `struct io_uring_params *`、`bpf` 的 `union bpf_attr *`（`mmap` 刚好六个标量，用满了位）。结构体方案还解决扩展性：`size` 字段告诉内核用户态用的是哪个版本的结构，新字段只能追加不能改已有偏移，因为**ABI 一旦发布只能加不能改**，否则所有已编译的程序都会坏掉。坏指针为什么是 `EFAULT`：内核不能直接解引用用户内存（一个恶意指针就能让内核崩溃），必须走 `copy_to_user`/`copy_from_user`，它们捕获缺页并返回未拷贝的字节数，系统调用于是返回 `-EFAULT`；`access_ok()` 只检查地址范围是否落在用户空间，不保证页已映射，所以「用 `read` 探测某地址能否写」不可靠。

**判据**：四架构表填对（尤其 `x8`/`a7` 的调用号寄存器）；说清 `rcx` 被 `syscall` 占用；「六」的理由说到寄存器与换栈；四个结构体入口至少列两个并说清 `size` 的演进作用；`EFAULT` 与 `copy_*_user`/`access_ok` 的关系说对。

:::
:::

## B 组 · 诊断推理

::: ex 例 2.1-B1 · 隐式声明 `accept4`，链接居然成功 {#ex-2.1-B1}

先猜：`implicit declaration of function 'accept4'` 之后还把程序链出来了，这算「没问题」吗？运行时最坏会怎样？

同事把编译命令改成 `cc -std=c17 -D_POSIX_C_SOURCE=200809L -Wall -Wextra -Werror ...`，`accept4` 报隐式声明；他去掉 `-Werror` 后链接通过、在 x86-64 上跑起来「看起来正常」。写出「现象 → 机制 → 证据 → 修法」四段，并说明这种「能跑」为什么比编译失败更危险。

::: sol 解答

现象：编译期只有警告（去掉 `-Werror` 就消失），链接期找不到任何缺符号，运行期在开发机上看不出异常。机制：显式定义 `_POSIX_C_SOURCE` 后 glibc 不再默认给 `_DEFAULT_SOURCE`，`accept4` 的声明从 `<sys/socket.h>` 里消失；C17 里调用未声明函数是**约束违反**，编译器按旧规则把它当成「返回 `int`、参数按默认提升传递」，于是返回值截成 `int`、指针与 64 位整数按错误的宽度和位置传；而共享库里 `accept4` 符号确实存在，链接器自然找得到。证据：`cc -std=c17 -D_POSIX_C_SOURCE=200809L -fsyntax-only` 报 `implicit declaration of function 'accept4'; did you mean 'accept'?`；加 `-D_GNU_SOURCE` 后同一命令通过；`nm -D /lib/*/libc.so.6 | grep accept4` 能看到符号确实存在（说明「链接成功」不意外）；`man 2 accept4` 的 FEATURES 段写着 `_GNU_SOURCE`。修法：命令行统一加 `-D_GNU_SOURCE`（本书的做法），并且**永远带 `-Werror`**；要跨 BSD/macOS 就把这些 Linux 扩展隔离在平台层，核心逻辑只用 `_POSIX_C_SOURCE=200809L`，并按规定编两次（2.1.8 第 10 条）来暴露扩展依赖。危险点在于：它不给失败信号，只给「我这能跑」；换架构、换 libc、换调用约定时参数会被静默解释错，那时现场已经丢完了。

**判据**：定位到「特性宏关掉了声明」而不是「库没装」；说出未声明函数按 `int` 返回 + 默认参数提升的两个后果；给出 `-fsyntax-only`、`nm -D`、`man 2` 三类证据中至少两个；修法包含命令行加宏 + 保留 `-Werror` + 编两次，而不只说「加 `_GNU_SOURCE`」。

:::
:::

::: ex 例 2.1-B2 · 日志里打出的是上一次的错误 {#ex-2.1-B2}

先猜：`open` 返回 `ENOENT`，日志却打印「Cannot allocate memory」——`errno` 撒谎了吗？

一个函数写成：`fopen("/var/log/app.err", "a")`，成功后 `fprintf(f, "%s: %s\n", what, strerror(errno))`，失败就直接 `exit(1)`。上线后发现错误文本经常和真实原因不符，而且有时同一个 bug 在两个线程里打出不同的文本。写出四段分析：谁改写了 `errno`？为什么加不加 `fflush` 都救不了？多线程那一半是什么原因？给出最小修法。

::: sol 解答

现象：真实错误是 `ENOENT`，打印出来却成了别的意思；行为随负载与时序变化。机制：`fopen`/`fprintf`/`fclose` 内部都会调系统调用与 libc 函数，任何一个失败都会**改写** `errno`（`fopen` 失败时它甚至会把原始错误的线索覆盖成自己的错误）；等 `strerror(errno)` 执行时读到的已经是最后一次写入的值。`errno` 成功时不清零、失败时才设，所以「读它的时候它属于谁」完全取决于中间发生过什么。加 `fflush` 不解决问题：`fflush` 自己也是会调 `write` 的库函数，同样能改 `errno`，而且此时错误码已经被前面那几次调用覆盖掉了。多线程那一半：`errno` 是线程局部的（glibc 里是 `(*__errno_location())`），两个线程读到的是各自槽位——所以「不同线程打出不同文本」不是它共享了状态，恰恰是它们各自的 `errno` 被各自的中间调用改写了；同一条日志里的错误可能来自完全不同的失败点。证据：正文 `errno_demo` 第二行「成功之后 `errno` 仍是 2」直接证明成功不改写、也不清零；`strace -f ./app` 能看到在错误发生与打印之间夹了哪些 `openat`/`read`/`write`；把 `strerror(errno)` 换成 `strerror(saved)` 后文本立刻稳定。修法：错误处理函数入口第一句 `int saved = errno;`，后续所有输出都用 `saved`（`err.c` 的 `vErr` 还额外在返回前 `errno = saved;` 还原，让调用者能继续判断）；`pthread_*` 那类接口不要用 `errno`，把返回值本身当错误码交给 `errExitEN`；打印要线程安全就用 `strerror_r`/`strerror_l` 而不是 `strerror`。

**判据**：说出「中间任何一个 libc 调用都可能改写 `errno`」而不是「`errno` 不可靠」；解释 `fflush` 无用；线程那一半说对「线程私有，各被各的改写」；给出 `int saved = errno;` 这一行修法并说明 `errExitEN`/`strerror_r` 的适用；证据里至少有一条来自 `errno_demo` 或 `strace`。

:::
:::

::: ex 例 2.1-B3 · 三个数字打架：`sysconf`、`ulimit`、`nr_open` {#ex-2.1-B3}

先猜：一个程序照 `sysconf(_SC_OPEN_MAX)` 的值预分配 fd 表，结果远早于该值就收到 `EMFILE`。是 `sysconf` 骗人，还是它算的不是你以为的那件事？

服务启动时打印 `sysconf(_SC_OPEN_MAX)` = 1048576，运维说 `ulimit -n` 也是这个数；跑了一阵在几万个 fd 之前就拿不到新 fd。写出四段分析：三层限制各是什么、谁约束谁？`sysconf` 在这条链里处于哪一层？为什么正文说「`_SC_OPEN_MAX` 与 `ulimit -n` 应一致，`nr_open` 通常远大于两者」还不够？按什么顺序排查？

::: sol 解答

现象：程序按一个很大的数分配 fd 表，却在远小于它的地方拿到 `EMFILE`。机制：限制有三层——内核全局（`fs.nr_open` 是每个进程 fd 号的绝对上限，`fs.file-max` 是**全系统**打开文件总数）、进程资源限制（`RLIMIT_NOFILE` 的软限 `rlim_cur` 是当前生效值，硬限 `rlim_max` 是软限的上界）、POSIX 查询接口（glibc 的 `sysconf(_SC_OPEN_MAX)` 就是本进程软限制的投影，不是独立的第三层，其他 libc 可能不同）。`EMFILE` 由**本进程软限制**触发，`ENFILE` 才对应系统总量；所以「按 `nr_open` 或按查询到的大数预分配」都会先撞 `EMFILE`。正文那句「`ulimit -n` 与 `_SC_OPEN_MAX` 应一致」只说对了本进程这一层，它还有两个变数：软限制可能在运行时被 `setrlimit`/`prlimit` 改动；服务进程的限制常常不是当前 shell 的值（systemd 的 `LimitNOFILE=`、容器启动参数、`ulimit` 之后又换用户会话），所以「我这儿 `ulimit -n` 是 X」推不出「服务进程的软限是 X」。另外 fd 号还会被别的东西占住：`/proc/PID/fd` 里的泄漏、继承来的管道、被 `dup` 出来的副本。证据与排查顺序：① 看进程 `cat /proc/PID/limits`（`Max open files` 的 soft/hard）；② 看内核 `sysctl fs.nr_open fs.file-max`；③ 看文件系统 `stat -f /path`、`fpathconf` 的 `NAME_MAX`/`PIPE_BUF`；④ 看容器/cgroup：`LimitNOFILE=`、Kubernetes `ulimits`、`/sys/fs/cgroup/.../pids.max`；⑤ 数实际占用 `ls /proc/PID/fd | wc -l`。修法：程序按 `getrlimit(RLIMIT_NOFILE)` 的**软限**分配（或按需增长），需要在硬限内提高软限时 `rlim_cur = rlim_max` 再 `setrlimit`，超过硬限会 `EPERM`（提高硬限要 `CAP_SYS_RESOURCE`）；不要用 `_SC_OPEN_MAX` 推断系统总量。

**判据**：三层与「谁约束谁」说清，能区分 `EMFILE`/`ENFILE`；指出 glibc 的 `_SC_OPEN_MAX` 是软限投影；说出至少两个「shell 里的 `ulimit` 不等于服务进程的限制」的具体来源；排查顺序里出现 `/proc/PID/limits`；修法给 `getrlimit` 而不是「信 `sysconf`」。

:::
:::

::: ex 例 2.1-B4 · 一次 `read` 只读了 2 GiB 不到 {#ex-2.1-B4}

先猜：`read(fd, buf, 3ULL << 30)` 返回一个比请求小很多的正数，是文件不够大，还是内核根本不打算一次给你这么多？

一个程序请求一次读 3 GiB，实际拿到 2147479552 字节就返回；换一种写法后，同一个 fd 对只写模式打开的文件返回 `-1`，另一种 fd 返回 `EINVAL`；把缓冲区指针换成一个未映射地址则返回 `EFAULT` 而不是崩溃。三件事分别由 `vfs_read` 的哪一行解释？「返回正数但小于请求」能不能当失败处理？

::: sol 解答

三件事都出自 `vfs_read` 那十几行的检查顺序：① `if (count > MAX_RW_COUNT) count = MAX_RW_COUNT;`——`MAX_RW_COUNT` 是 `INT_MAX & PAGE_MASK`（4 KiB 页上是 `0x7ffff000` = 2147479552），一次调用不可能读更多，所以 3 GiB 被截到约 2 GiB − 4 KiB，返回正数是**截断**不是失败；② `if (!(file->f_mode & FMODE_READ)) return -EBADF;`——只写打开的 fd 来读得到 `EBADF`（描述符不允许这个操作），而 `if (!(file->f_mode & FMODE_CAN_READ)) return -EINVAL;` 对应「这类对象不支持读」（某些设备/特殊 fd），所以两者要分开判；③ `if (unlikely(!access_ok(buf, count))) return -EFAULT;`——用户缓冲区不在合法范围就 `EFAULT`；即使 `access_ok` 过了，真正拷贝时缺页仍由 `copy_to_user` 捕获并返回 `EFAULT`，进程不会收到 `SIGSEGV`，因为内核不直接解引用用户内存。「返回正数但小于请求」不能当失败：`read` 的返回值语义是「这次实际拿到多少字节」，短计数在普通文件、管道、终端上都正常（2.14 管道与 [2.4 缓冲与 stdio](ch04.md) 会反复用到），要读满必须自己循环累加，同时把 `-1` + `EINTR`（被打断，重试）与 `-1` + `EAGAIN`（非阻塞暂时不可用）分开处理。另外 `rw_verify_area` 还会检查偏移与权限，越界/非法也可能给出 `EINVAL`；`read` 目录返回 `EISDIR`。修法：把 `read` 当「搬运工的趟数」而不是「一次搬完」——循环 `n = read(fd, p + got, want - got)`，`n > 0` 累加，`n == 0` 是 EOF，`n == -1` 时先判 `EINTR` 重试、再判其他错误退出；大缓冲区不要指望一次系统调用搬完。

**判据**：三处现象各对应到 `MAX_RW_COUNT`/`FMODE_READ`（`EBADF` 与 `EINVAL` 分得开）/`access_ok`+`copy_to_user`；明确「短计数不是失败」并说清 `0`/`EINTR`/`EAGAIN` 三种情况；不判「文件不够大」；能写出重试循环的形状。

:::
:::

::: ex 例 2.1-B5 · 同一行命令行在同事机器上解析得不一样 {#ex-2.1-B5}

先猜：`./tool file.txt -v` 在你机器上 `-v` 生效，在同事的 BSD 机器上被当成文件名——谁的工具坏了？

一个脚本调用 `./opts -v -n3 a.txt b.txt` 一切正常；另一处写成 `./opts a.txt -v`，本地也「生效」，换到另一个环境就报 `unknown option: -v` 或把 `-v` 当操作数。同时 `--color always` 里的 `always` 没被当参数；某天新增 `--count` 之后，原来能用的 `--col=never` 报 ambiguous；多线程解析时 `optarg` 出现张冠李戴。逐条判：哪个是 `getopt` 的实现差异、哪个是规范行为、哪个是自己写错？

::: sol 解答

五条各有各的层：① `./opts a.txt -v` 之所以在 GNU 上「生效」，是 **GNU 扩展会重排 `argv`** 把选项挪到前面；POSIX 的约定是遇到第一个非选项参数就停止解析，所以别的实现把 `-v` 当操作数是**符合规范**的。等价开关是 `optstring` 开头的 `+` 或环境变量 `POSIXLY_CORRECT`。结论：选项写在操作数前面，别依赖重排。② `--color always` 拿不到值：`optional_argument` 的长选项只认 `--color=always`，空格形式里的 `always` 是操作数；这是规范行为，不是 bug。③ `--col=never` 报 ambiguous：长选项支持**唯一前缀缩写**，`--count` 与 `--color` 共存后 `--col` 不再是唯一前缀，于是返回 `'?'`；脚本里必须写全称，因为别人加一个选项就能把你的脚本改坏。④ 多线程解析互相踩：`getopt`/`getopt_long` 用全局状态（`optind`/`optarg`/`optopt`），不是线程安全的，两个线程同时解析必然张冠李戴；要么串行化，要么每个任务在自己进程里解析。⑤ 关于 `optarg` 与 `optind` 的用法：`optarg` 指向 `argv` 内部，生命周期跟着 `argv`，不能 `free`、也不要假设重新解析后还指向同一个串；多次解析前在 GNU 上要用 `optind = 0`（会连内部状态与 `POSIXLY_CORRECT` 检查一起重置），`optind = 1` 只是回到开头不重置内部状态，而 `optind = 0` 本身是 GNU 扩展——这一条也是「换实现就不一样」的来源。修法形状：`opterr = 0` 自己打印错误；`case ':'` 报「需要参数」并用 `optopt` 指出是哪个选项，`case '?'` 报未知选项（`optopt` 为 0 时用 `argv[optind - 1]` 打印长选项原文），两者退出码不同；解析完用 `argc -= optind; argv += optind;` 取操作数，并检查 `optind >= argc` 的「缺操作数」情况。

**判据**：五条分别归到「GNU 扩展」「规范」「自己依赖缩写」「线程不安全」「GNU 扩展」；指出 BSD/POSIX 的停止行为是合规而非坏了；`--color=always` 与缩写歧义两条给出可执行改法；`optind = 0` 标注为 GNU 行为。

:::
:::

::: ex 例 2.1-B6 · 容器里 `openat` 对合法路径返回 `EPERM` {#ex-2.1-B6}

先猜：`access(path, W_OK)` 过了、`open` 却 `EACCES`，是权限位还是别的东西？`strace` 里看到 `= -1 EPERM` 是不是「文件权限不足」？

三种现象：① `openat` 对存在且权限正确的路径返回 `EPERM`；② `access(path, W_OK)` 返回 0，紧接 `open(path, O_WRONLY)` 返回 `EACCES`；③ 想确认 `vfs_read` 到底进了几次，但 `strace` 只看到 `read(3, ...) = 12`。逐条给出：机制、当场怎么证、怎么修。第 ③ 条还要说明本书的 VM 为什么补不上这个观测缺口。

::: sol 解答

① 机制：seccomp 过滤器。它的默认动作是杀进程，但 `SECCOMP_RET_ERRNO` 能让调用**直接返回指定错误码**，长得就像普通失败；容器的默认 profile 会拦一批调用，所以 `EPERM` 与文件权限无关。证据：`docker inspect` 看 `SecurityOpt`/seccomp 配置，`strace -f -e trace=openat ./app` 看这个路径是否**每次**都 `EPERM`（权限问题通常随路径/用户变化，seccomp 是随调用号变化）；换 `--security-opt seccomp=unconfined` 复跑一次即可确认（这条要 root 或容器权限，本书 VM 上按未实测读）。修法：把被拦的调用加进自定义 profile，或换一条等价的、没被拦的路径；不要把 `EPERM` 当 `EACCES` 处理成「提示用户改权限」。② 机制：`access()` 按 **real UID** 检查，`open()` 按 **effective UID** 检查，setuid 程序或多身份场景里两者本就不同；即使一致，检查与打开之间还有 TOCTOU（time-of-check-to-time-of-use，检查完到使用之间文件可能被别人换掉）窗口。证据：`strace -f -e trace=openat,access ./app` 看两个调用的先后与各自结果；`namei -l path` 逐级看目录的 `x` 位（缺一层就 `EACCES`）；`ls -l` 与 `id` 对比 real/effective 身份；`dmesg | grep -i apparmor` 在这台 VM 上跑不了（`dmesg_restrict=1`），改用 `/var/log` 里可读的记录或按 LSM 未命中处理，并标未实测。修法：**不要先 `access` 再 `open`**，直接 `open` 并处理错误；确实需要按 effective 身份预检查时用 `faccessat(fd, path, W_OK, AT_EACCESS)`。③ 机制：`strace` 只观察系统调用边界，`vfs_read`/`filemap_read`/`ext4_file_read_iter` 是内核内部函数，要 `perf probe`/`bpftrace`/`ftrace` 这类内核侧探针。本书的 VM 上 `sudo` 不可用、`perf` 也拿不到事件，所以 2.1.14 结尾那两条 `sudo bpftrace`/`sudo perf probe` 一律按未实测读；免 root 能做的替代是边界内的读数：`strace -T`/`-c` 看调用次数与耗时形状、`/proc/self/io` 看 `rchar` 与 `read_bytes` 的差（有没有真的走块设备）、`/proc/self/fdinfo/N` 看偏移推进、`getrusage` 看缺页计数。顺带一条相关判据：符号可能被内联（`vfs_read` 在部分配置下是 `static inline`），即使有 root 也可能探不到，那时换 `ksys_read` 或 `__arm64_sys_read`/`__x64_sys_read`。

**判据**：①归到 seccomp 并给出「按调用号而不是按路径失败」的判据，不提议改文件权限；②说清 real/effective UID 与 TOCTOU，修法给「直接 open」或 `AT_EACCESS`；③说清 `strace` 的层次边界，替代读数至少给两个（`/proc/self/io`、`-c`/`-T`、`fdinfo`），并如实写出本机 `sudo`/`perf` 不可用、`dmesg` 被挡住。

:::
:::

## C 组 · 动手实验

::: ex 例 2.1-C1 · 跑通 `errno_demo` 并做三处改动 {#ex-2.1-C1}

先猜：把 `errno = 0;` 那一句删掉，第二行输出会变吗？把 `sa.sa_flags = 0` 改成 `SA_RESTART`，第三行还在吗？

按 [2.1.3](ch01.md#sec-2.1.3) 抄出 `errno_demo.c`，编译运行并逐行解释输出；然后做三个改动：删掉开头的 `errno = 0`、把 `sa.sa_flags` 设成 `SA_RESTART`、在 `errMsg` 之前插入一次会失败的 `open`。记录每次改动前后的输出差异。

::: sol 核对

```bash
mkdir -p ~/lab2c01_work && cd ~/lab2c01_work
# 把正文 2.1.3 的 errno_demo.c 抄进来（它自带 static errMsg/errExit，不需要 err.c）
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 -g errno_demo.c -o errno_demo
./errno_demo; echo "exit=$?"
```

预期四行（本机 aarch64 与正文一致，`errno=2` 与文本 `No such file or directory` 是 `ENOENT`）：`open 失败: errno=2 (...)`、`成功之后 errno 仍是 2 (...)`、`read 被 SIGALRM 打断, got_alarm=1`、`exit=0`。三处改动：**删 `errno = 0`** 后第二行通常仍是 2，但这一行不再有意义——你没法区分「上一次留下的 2」和「这次真的写进去的 2」；在别的时序（前一次失败是别的错误）下第二行的数字会跟着变，这正是七条规则里第 ② 条。**设 `SA_RESTART`** 后 `read` 被 `SIGALRM` 打断会被内核重启，调用继续阻塞，程序不再打印第三行而是卡住——用 `timeout 5 ./errno_demo; echo "exit=$?"` 跑，会看到退码 124（超时）而不是 0。**在 `errMsg` 之前插一次会失败的 `open`** 会改写 `errno`，如果不保存就直接打印，错误文本变成后来那次失败的意思。

**判据**：原始四行对上（退出码 0）；`SA_RESTART` 那次能观察到「不再打印第三行 + `timeout` 退码 124」；能说清第二行证明的是「成功不清 `errno`」；第三处改动能说出被谁改写。无需 `sudo`；实验产物在 `~/lab2c01_work`，做完删掉。

:::
:::

::: ex 例 2.1-C2 · 本机取数并与正文对照 {#ex-2.1-C2}

先猜：`./limits` 的输出会和正文那一段一样吗？哪几行必然不同、为什么？

编译运行 2.1.6 的 `limits.c` 与 2.1.12 的 `limits2.c`，再跑 `uname -a`、`nproc`、`getconf PAGE_SIZE`、`ulimit -n`、`cat /proc/self/limits`、`sysctl fs.nr_open fs.file-max 2>/dev/null`。把本机读数与正文（标着 x86-64 的那一段）逐行做成一张对照表，并给每个差异写一句原因。

::: sol 核对

```bash
cd ~/lab2c01_work
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 limits.c -o limits
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 limits2.c -o limits2
./limits; ./limits2
uname -a; nproc; getconf PAGE_SIZE; ulimit -n
cat /proc/self/limits | head -5
sysctl fs.nr_open fs.file-max 2>/dev/null || grep . /proc/sys/fs/nr_open /proc/sys/fs/file-max
```

预期形状（下列读数已在这台 aarch64 虚拟机上复跑核对）：`./limits` 第一行是 `printf("%s %s %s\n", ...)` 的结果 `Linux 7.0.0-38-generic aarch64`，而正文那段终端块贴的是 `6.8.0-45-generic` + `x86_64`，还写成 `sysname=Linux release=...` 这种带标签的样子——与它自己的源码不符，本机复跑证明真实首行没有等号。五项系统限制本机是：`_SC_PAGESIZE` 4096、`_SC_OPEN_MAX` **1024**、`_SC_CLK_TCK` 100、`_SC_ARG_MAX` 2097152、`_SC_NPROCESSORS_ONLN` **4**；正文贴的是 1048576 与 8。`_SC_OPEN_MAX`=1024 恰好等于本机 `ulimit -n`（软限制），而 `cat /proc/self/limits` 显示 hard=1048576、`sysctl fs.nr_open` 也是 1048576——这一组数正好把「glibc 返回软限制」这句变成读数。`_SC_ARG_MAX` 与正文相同不是巧合：它由 `RLIMIT_STACK`（8 MiB）推出来，两台机器的栈限制一样；把 `ulimit -s` 改掉它就跟着变。`_PC_NAME_MAX(/tmp)`=255、`_PC_PATH_MAX(/tmp)`=4096，`df -T /tmp` 显示本机 `/tmp` 就在 ext4 根分区（`/dev/sda2`）上、不是 tmpfs，所以与正文数值相同纯属巧合，换机器要先看 `df -T`。`limits2` 本机另给出 `RLIMIT_NPROC soft=hard=43361`、`_SC_IOV_MAX` 1024、`_PC_PIPE_BUF(/tmp)` 4096、`pipe capacity=65536`（16 个 4 KiB 页），最后一行是 `setrlimit 超硬限制: Operation not permitted`（非特权进程升不了硬限）。差异表写成「本机值 / 正文值 / 归属（架构、内核、libc、会话 ulimit、文件系统）」四列。

**判据**：能列出至少四个本机与正文不同的行（本机至少是：架构名与内核版本、`_SC_OPEN_MAX` 1024 对 1048576、`_SC_NPROCESSORS_ONLN` 4 对 8，以及正文 `limits` 块那种 `sysname=...` 的写法与源码不符），并对每个说出「架构相关 / 内核配置相关 / 会话限制相关 / 文件系统相关」中的哪一类；`_SC_OPEN_MAX` 与自己 `ulimit -n` 相等（并解释 glibc 为什么这么实现、为什么它不等于 `fs.nr_open`）；查 `NAME_MAX` 前先看 `df -T`；不修改正文数字去迁就本机。

:::
:::

::: ex 例 2.1-C3 · 三种特性宏各编一次，并复现「隐式声明」 {#ex-2.1-C3}

先猜：`feature_matrix.c` 用默认、`_POSIX_C_SOURCE=200809L`、`_GNU_SOURCE` 三种命令编，哪几行会变？`-fsyntax-only` 那条报什么？

跑 2.1.11 的 `feature_matrix.c` 三次构建对照 `__USE_GNU`/`__USE_MISC`/`__USE_XOPEN2K8`；再用 2.1.5 那份 `accept4_demo.c` 复现「隐式声明但链接成功」（正文末尾「把 2.1.5 引用的 `accept4_demo.c` 补全」那一节给了完整源码；这里只用一个四行的最小版本做同样的实验，两者结论一致）；最后把 `_Static_assert` 加进源码，看它在什么条件下拦住编译。

::: sol 核对

```bash
cd ~/lab2c01_work
cc -std=c17 -Wall -Wextra -Werror -O2 feature_matrix.c -o fm_default
cc -std=c17 -D_POSIX_C_SOURCE=200809L -Wall -Wextra -Werror -O2 feature_matrix.c -o fm_posix
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 feature_matrix.c -o fm_gnu
./fm_default; echo ---; ./fm_posix; echo ---; ./fm_gnu
getconf GNU_LIBC_VERSION
cat > accept4_demo.c <<'EOF'
/* 最小复现版；正文 2.1.5 引用的是完整版 accept4_demo.c（见本章末尾的补全小节），
   两者在 -D_POSIX_C_SOURCE=200809L 下给出同一条隐式声明警告 */
#include <sys/socket.h>
int main(void) { return accept4(0, 0, 0, 0) < 0; }
EOF
cc -std=c17 -D_POSIX_C_SOURCE=200809L -Wall -Wextra -fsyntax-only accept4_demo.c
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -fsyntax-only accept4_demo.c
cc -std=c17 -D_POSIX_C_SOURCE=200809L -Wall -Wextra accept4_demo.c -o accept4_bad
nm -D /lib/aarch64-linux-gnu/libc.so.6 | grep -w accept4
```

预期（这一段在本机复跑过）：**第一条命令就编译失败**——`feature_matrix.c: error: 'off_t' undeclared (first use in this function)`。原因是 `-std=c17` 打开 `__STRICT_ANSI__`、又没有定义任何特性宏时，glibc 不给默认扩展集，`<unistd.h>`/`<time.h>` 里就不会带出 `off_t` 这个类型名。这恰好是 2.1.5 第四条坑的直接证据，但正文把它当成「能编出来再比较」的例子，所以这一步要按现象记录而不是硬凑输出。两条修法任选：加 `-D_POSIX_C_SOURCE=200809L` 或 `-D_GNU_SOURCE`，或在源文件最前面补 `#include <sys/types.h>`；用 `#include <sys/types.h>` 修好后，无宏版本的输出是 `__USE_GNU=0`、`__USE_XOPEN2K8=0`、`__USE_MISC=0`（三项全 0），`_POSIX_C_SOURCE=200809L` 版本是 `0 / 1 / 0`，`_GNU_SOURCE` 版本是 `1 / 1 / 1`——「显式定义 POSIX 宏就关掉默认扩展」的读数就是中间那一列的 `__USE_MISC=0`。三者第一行都是 `glibc 2.39`；`sizeof(off_t)`/`sizeof(time_t)` 三处都是 8（64 位 LP64 上本来就走 64 位，正文那句「32 位上意味着 32 位 off_t」在这台机器上无法直接演示）。`-fsyntax-only` 那条报 `implicit declaration of function 'accept4'; did you mean 'accept'?`（不带 `-Werror` 时它是警告，退出码仍是 0；正文命令带了 `-Werror` 就变错误），换 `_GNU_SOURCE` 就干净通过；而 `-D_POSIX_C_SOURCE` 版本去掉 `-Werror` 后**真的能链出来**（本机复跑：链接退出码 0），`nm -D /lib/aarch64-linux-gnu/libc.so.6` 里能看到 `T accept4@@GLIBC_2.17`——这就把「声明消失」与「符号存在」分开了。`_Static_assert(sizeof(off_t) == 8, ...)` 在本机不会触发；想看到它拦住编译，就临时写成 `_Static_assert(sizeof(off_t) == 4, ...)`，报错信息正是你写在里面的那句提示。`cc -m32` 在本机直接报 `unrecognized command-line option '-m32'`，所以「32 位 ABI 下宏改变布局」这一条按未实测读，只做纸面推演。

**判据**：说出无宏版本为什么编译失败（`__STRICT_ANSI__` 关掉默认扩展、`off_t` 不见），并给出两条修法之一；三种组合 `000`/`010`/`111`（按 `__USE_GNU`/`__USE_XOPEN2K8`/`__USE_MISC` 读）与预期一致；能复现「报隐式声明 → 加 `_GNU_SOURCE` 就过 → 去掉 `-Werror` 仍能链接」三步；`nm -D` 确认符号存在；说出 `_Static_assert` 触发时编译器给出的是自己写的那句话；如实标注 32 位那条在本机未实测。

:::
:::

::: ex 例 2.1-C4 · 在 aarch64 上跑 `abi_probe` {#ex-2.1-C4}

先猜：`abi_probe` 打印的 `SYS_read` 在这台机器上是 0 还是 63？传一个 `0x1` 当缓冲区的 `getrandom` 会让进程崩溃吗？

编译运行 2.1.9 的 `abi_probe.c`，记录全部输出；用头文件核对每个调用号；再验证两件事：坏指针得到 `EFAULT`（进程不崩）、`syscall(SYS_getpid)` 之后 `errno` 是 0。

::: sol 核对

```bash
cd ~/lab2c01_work
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 abi_probe.c -o abi_probe
./abi_probe; echo "exit=$?"
grep -rn -E '^#define __NR_(read|write|openat|getrandom|statx|clone3)\b' \
    /usr/include/aarch64-linux-gnu/asm/ /usr/include/*/asm/ 2>/dev/null | head
echo | cc -dM -E -include sys/syscall.h - | grep -E '\bSYS_(read|write|openat|statx|clone3)\b'
```

预期（本机已复跑）：`sizeof(off_t)=8 sizeof(time_t)=8 sizeof(long)=8`（LP64）；`getrandom(bad) = -1, errno=14 (Bad address)`，也就是 `EFAULT`，程序继续跑到 `exit=0`——坏指针不产生 `SIGSEGV`，因为内核用 `copy_from_user` 捕获缺页；`syscall(SYS_getpid)=<某个 pid> errno=0`（本机一次跑到 84611），说明 `syscall(3)` 自己做了 `-errno → -1 + errno` 的翻译，成功路径上 `errno` 保持 0。**调用号那一行必然和正文不同**：正文贴的 x86-64 是 `SYS_read=0 SYS_write=1 SYS_openat=257`、`SYS_statx=332`；本机 `./abi_probe` 打印 `SYS_read=63 SYS_write=64 SYS_openat=56`、`SYS_statx=291`、`SYS_clone3=435`。`echo | cc -dM -E -include sys/syscall.h -` 会给出 `__NR_read 63`、`__NR_write 64`、`__NR_openat 56`、`__NR_statx 291`、`__NR_getrandom 278`、`__NR_clone3 435`——注意 `SYS_*` 只是 `__NR_*` 的别名，所以要看到数值就得展开这一层。`clone3` 恰好两边都是 435（较新的调用在通用表里编号一致），这提醒另一件事：**有的数看起来一样也不能背**，因为它只是这一对架构的巧合。正文那句「`SYS_read` 在 ARM64 是 63」在这里得到直接印证。

**判据**：本机 `SYS_read` 打印 63 而不是 0，并能用 `grep`/`-dM` 复核；`getrandom` 那次输出是 `-1` + `errno=14`，进程退出码 0；`syscall(SYS_getpid)` 后 `errno=0`；写出一张「x86-64 正文值 vs 本机 aarch64 值」的调用号对照，并注明编号来自 `SYS_*` 宏而不是硬编码。

:::
:::

::: ex 例 2.1-C5 · `strace` 三变体 + `fdinfo` + 阻塞进程 {#ex-2.1-C5}

先猜：`strace` 里 fd 3 会不会指向两个不同文件？`-e inject` 打在第一次 `openat` 上，程序会走到你预期的错误分支吗？

跑 2.1.15 的两条通道：`strace -f -yy -e trace=%file,%desc`、`strace -c`、`strace -e trace=openat -P /etc/hosts`；用 `exec 3<...` 打开一个 fd 后读 `/proc/self/fdinfo/3`；再看一个阻塞进程的 `/proc/PID/syscall`；最后做一次故障注入，让目标 `openat` 返回 `EACCES`。

::: sol 核对

```bash
cd ~/lab2c01_work
strace -V | head -1
strace -f -yy -e trace=%file,%desc ./limits2 2>&1 | head -20
strace -c -e trace=openat,read,write ./limits2
strace -e trace=openat -P /etc/hosts ./limits2
strace -e trace=openat -o lab2c01_op.txt ./limits2; grep -n 'openat' lab2c01_op.txt | head
exec 3</etc/hosts; cat /proc/self/fdinfo/3; ls -l /proc/self/fd/3; exec 3<&-
tail -f /dev/null & p=$!; cat /proc/$p/syscall; kill $p
```

读法与预期（本机已复跑）：`-yy` 会把 fd 翻译成路径，于是看到 `openat(AT_FDCWD</home/...>, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3</etc/ld.so.cache>`，紧跟一条 `close(3</etc/ld.so.cache>)`，之后 `openat(..., "/lib/aarch64-linux-gnu/libc.so.6", ...) = 3</usr/lib/aarch64-linux-gnu/libc.so.6>`——**同一个 3 被复用**，日志里只记数字会指错对象；注意 `-yy` 显示的是解析后的真实路径（`/usr/lib/...`），而传给 `openat` 的是 `/lib/...` 那个符号链接。库目录那一行本机是 `aarch64-linux-gnu`，正文贴的 `x86_64-linux-gnu` 属于另一台机器。`/tmp` 那一行本机解码成 `O_RDONLY|O_CLOEXEC|O_DIRECTORY`，与正文的 `O_RDONLY|O_DIRECTORY|O_CLOEXEC` 是同一组位、只是打印顺序不同（flags 的解码顺序随 strace 版本变）。`pipe2([3<pipe:[341634]>, 4<pipe:[341634]>], 0) = 0`：`pipe()` 在这台 aarch64 上确实由 `pipe2` 落地（通用调用表里没有单独的 `pipe`），但 flags 是 **0**，没有 `O_CLOEXEC`——正文那行写着 `O_CLOEXEC` 且 fd 是 4/5，所以「`pipe()` 会原子设 CLOEXEC」这句本机没有印证，要 CLOEXEC 就显式 `pipe2(..., O_CLOEXEC)`。`fcntl(4<pipe:[...]>, F_GETPIPE_SZ) = 65536` 是默认 16 个页。失败行写成 `= -1 ENOENT (No such file or directory)`：符号名来自内核的 `-errno`，括号里是 `strerror` 文本。`fdinfo` 四条字段本机实测：`pos: 0`、`flags: 0400000`、`mnt_id: 35`、`ino: 2755550`（`ls -l /proc/self/fd/3` 给出 `-> /etc/hosts`）。**别照正文解释这个 `flags`**：本机 `<fcntl.h>` 里 `O_LARGEFILE` 是 0、`O_NOFOLLOW` 是 `0100000`、`O_DIRECTORY` 是 `040000`、`O_CLOEXEC` 是 `02000000`，而内核打印的是 `f_flags`（含内核内部位）。认位的办法是做差：再开一个 `O_RDONLY|O_CLOEXEC` 的 fd，`flags` 变成 `02400000`，多出来的正是 `02000000`；开目录的 fd 是 `0440000`，多出来的是 `040000`。`/proc/self/syscall` 本机打印 `63 0x3 0x... 0x20000 ...`——第一列 63 就是 aarch64 的 `read`（正文示例的 `0` 是 x86-64），后面六个是参数寄存器，最后两个是 SP 与 PC；这条只对**自家进程**可靠：本机的 `/proc/sys/kernel/yama/ptrace_scope` 是 1，`cat /proc/<别人的 PID>/syscall` 直接报 `Operation not permitted`，`strace -p <PID>` 也在 `ptrace(PTRACE_SEIZE...)` 上失败，所以本实验一律用「在 strace 下启动」。注入实验要小心：本机 `limits2` 的四次 `openat` 依次是 `/etc/ld.so.cache`、`libc.so.6`、`/sys/devices/system/cpu/online`、`/tmp`，所以 `when=1` 打到的是动态链接器，实测程序**照常跑完并退出 0**（链接器退回默认搜索路径，你的错误分支一次都没走到）；正确做法是先用 `-o op.txt` 数出目标路径是第 N 次，再 `strace -e trace=openat -e inject=openat:error=EACCES:when=4 ./limits2`，本机得到 `openat(..., "/tmp", ...) = -1 EACCES (Permission denied) (INJECTED)` 加程序自己的 `open /tmp: Permission denied`（想从第 N 次起每次都注入写 `when=4+`）。`perf`/`bpftrace` 那一层（看 `vfs_read`）本机不可用，按未实测。

**判据**：能指出 fd 3 被复用（两个不同路径依次拿到同一个 3）；本机 libc 路径是 `aarch64-linux-gnu`，并说清 `-yy` 打印的是解析后的 `/usr/lib/...`；`F_GETPIPE_SZ` 报出本机读数 65536 并解释它等于 16 × 页大小；看到 `pipe2(..., 0)` 而没有 `O_CLOEXEC`，并据此拒绝「`pipe()` 自动设 CLOEXEC」这条；`fdinfo` 的 `flags` 用「两个 fd 做差」的方式认位，而不是把 `0400000` 念成 `O_LARGEFILE`；`/proc/self/syscall` 第一列读出 63 并说出它是本架构的 `read`；注入实验至少一次真的走进 `EACCES` 分支（`when=4`），并能说出 `when=1` 为什么看不到效果；如实写出内核侧探针与 `strace -p` 在本机不可用。

:::
:::

::: ex 例 2.1-C6 · `opts` 的六种命令行与三种退出码 {#ex-2.1-C6}

先猜：`POSIXLY_CORRECT=1 ./opts a.txt -v` 之后 `-v` 还在选项里吗？`./opts --count` 的退出码和 `./opts --bad` 的是同一个吗？

编译 2.1.13 的 `opts.c`，跑六条命令：`-v -n3 a.txt b.txt`、`--count=2 --color --output=/tmp/x a.txt`、`--count`、`--col=never a.txt`、`-- -n`、`POSIXLY_CORRECT=1 ./opts a.txt -v`；再补两条 `-n abc a.txt` 与 `-n0 a.txt`。记录每条的输出与 `$?`。

::: sol 核对

```bash
cd ~/lab2c01_work
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 opts.c -o opts
./opts -v -n3 a.txt b.txt;            echo "rc=$?"
./opts --count=2 --color --output=/tmp/x a.txt; echo "rc=$?"
./opts --count;                       echo "rc=$?"
./opts --col=never a.txt;             echo "rc=$?"
./opts -- -n;                         echo "rc=$?"
POSIXLY_CORRECT=1 ./opts a.txt -v;    echo "rc=$?"
./opts -n abc a.txt;                  echo "rc=$?"
./opts -n0 a.txt;                     echo "rc=$?"
```

预期与读法：① `-v -n3 a.txt b.txt` 打印 `count=3 output=(stdout) color=auto operands=2` 加两条操作数——`-n3` 的捆绑形式与 `-n 3` 等价；退出码 0。② 长选项带等号 + 无值的 `--color`（`optional_argument`）走 `optarg ? optarg : "always"`，`color=always`；0。③ `--count` 缺参数：`optstring` 以 `:` 开头，返回 `':'` 而不是 `'?'`，本机打印 `option -n requires an argument`、退出码 **2**——报的是 `-n` 而不是 `--count`，因为 `struct option` 的 `val` 就是 `'n'`，`optopt` 拿到的是 `val`。④ `--col=never` 是唯一前缀缩写，能匹配 `--color`；`never` 通过值校验；0。⑤ `--` 之后 `-n` 变成操作数：`optind >= argc` 之外还有操作数，所以走 verbose 分支之外的路径；这里因为没给 `-v` 什么都不打印，退出码 0（若加 `-v` 会看到 `operands=1`，操作数是字面量 `-n`）。⑥ `POSIXLY_CORRECT=1 ./opts a.txt -v`：POSIX 模式下遇到第一个非选项就停止，`-v` 成为操作数；本机什么都不打印、退出码 **0**（因为 `verbose` 没被设起来，`operands=` 那行根本不会输出）——「看着没报错，其实选项丢了」正是这种形态，也是 [习题 B5](ch01-exercises.md#ex-2.1-B5) 里同事那台机器的现象。想看两条干净对照，用这一对：`./opts a.txt --count` 本机报 `option -n requires an argument` 并返回 2（GNU 重排把 `--count` 提前解析了），`POSIXLY_CORRECT=1 ./opts a.txt --count` 返回 0 且一句错误都不说（`--count` 被当成操作数）。⑦ `-n abc`：`parse_count` 里 `strtol` 的 `end` 停在 `'a'`（`end != s` 但 `*end != '\0'`），报 `invalid count: abc`，退出码 `EXIT_FAILURE`(1)——注意它和选项错误用的 **2** 不同：用法错误与数据错误应该分开退出码，脚本能靠 `$?` 区分。⑧ `-n0`：`v <= 0` 触发同一条 `invalid count`，也是 1。顺带验一条坑：`strtol` 前先 `errno = 0`，因为它是「用 `errno` 报告范围错误」的那类函数（`ERANGE`），而 `snprintf` 截断就不设 `errno`。

**判据**：八条命令的退出码依次是 0/0/**2**/0/0/0/**1**/1（本机实测），并能对每条说出走到了哪个 `case`；`--` 之后 `-n` 被当操作数这一点被观察到；`option -n requires an argument` 里报的是 `val`（`-n`）而不是长选项名，并说清为什么；`POSIXLY_CORRECT` 那一对（`a.txt --count` 加与不加）给出 2 与 0 的差异，据此拒绝「依赖 GNU 重排」的写法；能区分「用法错误 2」与「数据错误 1」两种退出码并解释为什么要分开。

:::
:::
