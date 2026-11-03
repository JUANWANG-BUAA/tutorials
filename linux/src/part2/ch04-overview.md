# 2.4 缓冲与 stdio · 本章导航

::: preview 这一章在讲什么
[2.1](ch01.md) 立了「谁进内核、谁翻译错误」的规矩，[2.2](ch02.md)–[2.3](ch03.md) 写了 `read`/`write`/`lseek` 这层系统调用，两次提醒「`fork`/`dup2` 之前先 `fflush`」却没讲原因。这一章补上中间那层：**`printf` 不是系统调用**，它只把字节搬进一块用户态缓冲区，真正发 `write` 的时机由缓冲模式决定。把这块缓冲区看清楚，你才能解释「程序崩了日志最后一行没了」「重定向到文件后输出晚了」「`fork` 之后同一行打印两次」。核心不是背 API，而是**把「一次 stdio 调用」和「一次 `write`」分开**，再用 `strace`、文件大小、`stdbuf` 把它们各自的时机读出来。
:::

## 本章回答什么

- **`FILE` 里装了什么**：一个 fd、一组标志、读/写两块用户态缓冲区和一把锁；`printf` 只挪 `_IO_write_ptr`，不碰内核（2.4.1）。
- **什么时候真正 `write`**：全缓冲等满、行缓冲等 `\n`、无缓冲每次调用都写；`stderr` 无缓冲、接终端的流行缓冲、其余全缓冲，判断依据是 `isatty(fileno(...))`（2.4.2、2.4.7）。
- **缓冲类型由谁决定**：由 fd 当时指向的设备在**首次 I/O 时**决定并写进 `FILE`，之后再 `dup2` 换个去处也不改模式——这就是 `fflush` 必须在 `fork`/`dup2` 之前的根因（2.4.2、2.4.3）。
- **`fflush`、`fclose` 与混用 `write`**：`fflush(NULL)` 刷所有输出流；`fclose` 可能把错误推迟到最后才报；`printf` 和 `write` 混用会让内核看到的顺序变成 `BAC`（2.4.3）。
- **返回值到底数什么**：`fprintf` 数字符、`fscanf` 数赋值项（`0` 不是错误）、`fread`/`fwrite` 数完整项、`getline` 数含 `\n` 的字节、`fgetc` 要用 `int` 接（2.4.4）。
- **`fork` 为什么会重复**：`fork` 复制整块缓冲区，父子退出各刷一次；两处修复（`fork` 前 `fflush`、子进程 `_exit`）任选其一（2.4.5）。
- **跨层的三个接口**：`fileno` 取 fd、`fdopen` 包 fd（不复制）、`freopen` 重定向标准流；线程下用 `flockfile` 包住多行原子（2.4.6）。
- **缓冲区到底多大**：取 `st_blksize`（本机 4096）而非 `BUFSIZ`（glibc 8192）；`setvbuf` 只有传自己的 `buf` 才控制大小，`buf==NULL` 时 glibc 忽略 `size`（2.4.7、2.4.8）。
- **内存当成文件读写**：`fmemopen` 把已有内存包成流，`open_memstream` 让流自己长，`*ptr`/`*sizeloc` 只在 `fflush` 后有意义（2.4.9）。
- **行读与格式化的边界**：`fgets` 读长行会得到多条记录、`getline` 无此限制；`snprintf` 截断返回的是「本应长度」；`asprintf` 是 GNU 扩展；`printf(user)` 是格式化字符串漏洞（2.4.10、2.4.11）。
- **locale 与非阻塞**：`LC_NUMERIC` 会让 `3.14` 只读成 `3`；把 `O_NONBLOCK` 的 fd 包成流后，`fread` 用「设错误标志」而不是 `EOF` 报告「现在没数据」，要 `clearerr` 才能续读（2.4.12、2.4.13）。
- **落到内核与读数**：一次 `printf` 经过 `_IO_file_xsputn`→`_IO_file_overflow`→`write`；`strace -e write`、`stdbuf`、伪终端怎么各证一半（2.4.14–2.4.15）；跨节陷阱与出口检查（2.4.16–2.4.17）。

## 读完你会

- 画出 `FILE` 的用户态缓冲区到 `write`、到 page cache 的路径，说出触发 flush 的三种时机。
- 不查正文判断任意一个流的默认缓冲模式，并解释同一份 `printf("hello\n")` 在终端立刻出现、重定向到文件却等到退出才写。
- 写对 `setvbuf`：在首次 I/O 之前调用、缓冲区生命周期覆盖整条流、要控制大小就自己给 `buf`。
- 用文件大小（本机 `bufsize` 复跑：0/0/18/18）证明「`fprintf` 之后数据还在缓冲区」，用 `strace` 把 `printf` 次数与 `write` 次数对不上这件事读出来。
- 区分 `fflush`（到内核）与 `fsync`（到磁盘），并检查 `fclose` 的返回值抓延迟错误。
- 复现并修复 `fork` 重复输出，说清为什么 `exec` 会丢缓冲、`_exit` 不刷缓冲。
- 正确处理 `fread` 的「项数」语义与短读，`getline` 的返回值（含 `\n`）与 `ferror`/`feof` 的分工。
- 用 `open_memstream` 先格式化到内存再落盘，知道 `fflush` 前 `*ptr` 可能是 `NULL`。
- 用 `snprintf` 的返回值检测截断、用 `%s` 而不是把用户输入当格式串、给机器可读数据固定 `"C"` locale。
- 在非阻塞流上分辨 `EAGAIN` 与 EOF，并知道事件驱动程序通常绕开 stdio 直接用 `read`/`write`。
- 遇到「最后一行没了/顺序乱了/重复打了/写失败没报」时，按「现象 → 机制 → 证据 → 修法」四段给可复核答案。

## 先修与预计学时

- 系统调用与错误约定：[2.1 系统编程基础](ch01.md)（`errno`、`write` 进内核、`strace` 第一次出场）。
- 文件描述符与重定向：[2.2 文件 I/O](ch02.md)、[2.3 高级文件 I/O](ch03.md)（`fork`/`dup2`/`exec` 与 `fflush` 的关系从这里延续）。
- `printf` 怎么跳到 libc：[1.7 链接、加载与库](../part1/ch07.md)、[1.16 编译链接与优化](../part1/ch16.md)（GOT/PLT 视角的库调用）。
- 阅读：约 120 分钟（17 节，正文有 9 个可编译程序）。C 组实验：约 50 分钟（多为「编译 + 跑 + 对照文件大小/`strace`」）。章末习题：约 60 分钟。

### 环境与口径

- **测试 VM**：Ubuntu 24.04.5，**aarch64（ARM64，不是 x86-64）**、内核 `7.0.0-38-generic`、GCC 13.3.0、glibc 2.39、4 vCPU。可用：`cc`/`gcc`、`strace`（6.8）、`stdbuf`、`timeout`、`script`、`isatty` 语义、`/proc`、`/dev/full`。本章正文九个程序（`bufsize`、`late_error`、`scan_demo`、`linecount`、`fork_dup`、`bufmodes`、`memstream`、`snprintf_demo`、`stdio_err`）都已在这台机器逐个编译运行，读数与差异见[勘误与版本注记](ch04-errata.md)的「复跑校正」。
- **不可用**：`sudo` 与 `perf`。跨进程 `ptrace` 被 `ptrace_scope=1` 挡住，所以 `strace -p <别人的 PID>` 报 `Operation not permitted`，本章 `strace` 一律用「在 strace 下启动程序」；`dmesg` 被 `dmesg_restrict` 挡住。gdb 只能静态分析。
- **一条要紧的 SSH 边界**：通过 ssh 非交互执行时，程序的标准输出接的是**管道不是终端**，`isatty` 为假。所以正文 2.4.15 那句「终端下行缓冲、每行一次 `write`」在 ssh 里复现不出来——不加 `stdbuf`/`script` 时 `./tick` 是全缓冲，一次写 21 字节。要看行缓冲得 `stdbuf -oL`，要看真终端用 `script` 造伪终端（且伪终端会把 `\n` 转成 `\r\n`）。
- **`asprintf` 与 `getline` 的宏前提**：本机 `-std=c17` 不给 `_GNU_SOURCE` 时，`asprintf` 直接报 `implicit declaration`；`getline`/`getdelim` 属 POSIX.1-2008。本书统一 `cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2`。注意正文 `snprintf_demo.c` 用这组命令会因 `-Werror=format-truncation` 编不过（它故意截断），要加 `-Wno-format-truncation`。
- **写作机**：macOS（Apple 芯片 arm64）。能编译本章 C 程序，但**没有 `/proc`、没有 `strace`**，缓冲区与 locale 行为按 Apple 的 libc 走；所有取证动作回 Linux 做，德语 `LC_NUMERIC` 的对照在两台机器都没装对应 locale，按未实测读。
- **口径**：`st_blksize`、`BUFSIZ`、`/dev/full` 的 `ENOSPC`、`getline` 的返回值、`snprintf` 的本应长度这些是条款或可复算读数；纳秒、体积没有稳定意义，本章不引用绝对耗时。

## 本章路线：五段，一条主线

| 段 | 小节 | 这一段回答什么 |
|:--|:--|:--|
| **一、缓冲层与三种模式** | [2.4.1](ch04.md#sec-2.4.1)、[2.4.2](ch04.md#sec-2.4.2)、[2.4.3](ch04.md#sec-2.4.3) | `FILE` 里装了什么？全/行/无缓冲何时写、默认怎么定？`fflush`/`fclose` 与混用 `write` 会怎样？ |
| **二、返回值与 fork** | [2.4.4](ch04.md#sec-2.4.4)、[2.4.5](ch04.md#sec-2.4.5)、[2.4.6](ch04.md#sec-2.4.6) | 字符数、项数、赋值数怎么分？`fork` 为什么重复输出？`fileno`/`fdopen`/`freopen` 与线程锁怎么用？ |
| **三、缓冲大小与 `setvbuf` 家族** | [2.4.7](ch04.md#sec-2.4.7)、[2.4.8](ch04.md#sec-2.4.8) | 缓冲区多大、从哪来？`setvbuf`/`setbuf`/`setbuffer`/`setlinebuf` 各等价于什么？ |
| **四、内存流、行读与格式化** | [2.4.9](ch04.md#sec-2.4.9)、[2.4.10](ch04.md#sec-2.4.10)、[2.4.11](ch04.md#sec-2.4.11)、[2.4.12](ch04.md#sec-2.4.12)、[2.4.13](ch04.md#sec-2.4.13) | 怎么让 stdio 读写内存？`fgets` 为什么读不全一行？`snprintf` 截断返回什么？locale 与非阻塞 fd 各有何坑？ |
| **五、内核路径与取证** | [2.4.14](ch04.md#sec-2.4.14)、[2.4.15](ch04.md#sec-2.4.15)、[2.4.16](ch04.md#sec-2.4.16)、[2.4.17](ch04.md#sec-2.4.17) | 一次 `printf` 走到哪些函数、为什么 `strace` 只看到 `write`？怎么用 `strace`/`stdbuf` 取证？陷阱清单与出口检查。 |

一句话主线：**先把「一次 stdio 调用」和「一次 `write`」分开——`printf` 只进用户态缓冲区，发不发由缓冲模式、`fflush`、`fclose`、`exit` 决定；再把所有「顺序不对/少一行/多一行/返回值看不懂」都还原成缓冲时机与返回值语义两件事；分歧用文件大小、`strace`、`stdbuf`、伪终端四种读数各自证一半，而不是靠「我这看着正常」。**

## 怎么读

- **第一次读**：2.4.1–2.4.3 一口气读完，边读边在纸上画「`FILE` → 缓冲区 → `write` → page cache」一张图；接着跑 `bufsize`（本机 0/0/18/18）把「缓冲存在」变成读数；然后 2.4.5 亲手复现一次 `fork` 重复。
- **正在排一个具体故障**：最后一行丢了看 [2.4.5](ch04.md#sec-2.4.5) 与[习题 B1](ch04-exercises.md#ex-2.4-B1)；顺序乱了看 [2.4.3](ch04.md#sec-2.4.3) 与 [B2](ch04-exercises.md#ex-2.4-B2)；`fclose` 才报错看 [B3](ch04-exercises.md#ex-2.4-B3)；读到一半死循环看 [A4](ch04-exercises.md#ex-2.4-A4)；缓冲区悬空崩溃看 [B5](ch04-exercises.md#ex-2.4-B5)。
- **准备面试或课程考试**：五处必答——三种缓冲模式与默认规则（2.4.2）、`fork` 重复的机制与两种修复（2.4.5）、`fread` 的「项数」语义（2.4.4）、`setvbuf` 的时机与大小规则（2.4.7–2.4.8）、`snprintf` 截断返回值（2.4.11）；先做[习题集](ch04-exercises.md) A 组。
- **怕数字搬家**：`BUFSIZ`（8192）不等于实际缓冲区（`st_blksize` 4096）；「终端行缓冲」在 ssh 管道里不成立；`asprintf` 要有 `_GNU_SOURCE`。逐条列在[勘误与版本注记](ch04-errata.md)，出题与复跑前先读那一页。

## 路线标签与项目回链

- **应用/运维：必读** [2.4.2](ch04.md#sec-2.4.2)、[2.4.3](ch04.md#sec-2.4.3)、[2.4.15](ch04.md#sec-2.4.15)。日志为什么不实时、重定向后顺序为何变、`stdbuf` 能不能当生产方案，都在这三节；**可后补** [2.4.9](ch04.md#sec-2.4.9)（内存流）。
- **系统编程：必读** [2.4.1](ch04.md#sec-2.4.1)–[2.4.8](ch04.md#sec-2.4.8)、[2.4.13](ch04.md#sec-2.4.13)。写守护进程、`fork`/`exec`、事件循环绕开 stdio 都靠这些；**可后补** [2.4.12](ch04.md#sec-2.4.12)（locale）。
- **内核/性能：必读** [2.4.14](ch04.md#sec-2.4.14)、[2.4.15](ch04.md#sec-2.4.15)、[2.4.7](ch04.md#sec-2.4.7)。`printf`→`write` 的调用链、缓冲大小对 `write` 次数的影响、`fsync` 与 `fflush` 的分层都在这里；**可后补** [2.4.10](ch04.md#sec-2.4.10)。
- **项目回链**：容器里「`docker logs` 顺序和本地不一样」「CI 里输出要到进程结束才刷出来」这两类现象，判据分别在本章 [2.4.2](ch04.md#sec-2.4.2) 的行缓冲/非 tty 规则和 [2.4.15](ch04.md#sec-2.4.15) 的 `stdbuf`/伪终端实验；`fork` 后 worker 打印重复的 bug 落 [2.4.5](ch04.md#sec-2.4.5)。

## 章末件

[章末总结](ch04-summary.md) · [闭卷回忆卡](ch04-recall.md) · [习题集](ch04-exercises.md) · [学习目标自检表](ch04-checklist.md) · [勘误与版本注记](ch04-errata.md)

## 这一章的依据

| 母本 | 章节 | 主要落点 |
|:--|:--|:--|
| **K**（Linux/UNIX 系统编程手册） | 第 13 章（stdio 缓冲、`setvbuf`、`fflush`、`st_blksize`/`BUFSIZ`）、第 25 章 25.4（`fork` 与 stdio 缓冲、`_exit`） | 2.4.1–2.4.8、2.4.14–2.4.15 |
| **POSIX / glibc 手册** | `getline`/`getdelim`、`fmemopen`/`open_memstream`、`asprintf`、`setvbuf` | 2.4.9–2.4.13（K 未单列，按 POSIX.1-2008 与 glibc 写） |
| **C**（深入理解计算机系统） | 第 10 章 10.8–10.10（带缓冲的 I/O、RIO 与 stdio 对照） | 2.4.1–2.4.4 |
| **O**（操作系统导论） | 第 39 章（文件与目录） | 2.4.1：fd 与文件对象的背景 |

> K 的中文版覆盖到较早的内核，`open_memstream`、`getdelim`、`stdbuf` 的实现细节按 man-pages 与本机 glibc 2.39 头文件写；正文引 Kerrisk 的页码（p195、p223–225）属旧版格式，本页只按章节号核对，换版本以[勘误页](ch04-errata.md)为准。
