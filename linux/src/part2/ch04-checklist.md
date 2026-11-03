# 2.4 学习目标自检表

这张表接管 [2.4.17 本章出口检查](ch04.md#sec-2.4.17)：左列是达标项，中列是「怎样算达标」（写成能当场做的动作），右列是「没达标回到哪一节」。正文只给了 7 行出口，这里按**概念（K）、动手（S）、实验（E）、口径（B）**四组展开成 21 条（K 10、S 5、E 3、B 3）；做不到就回右列重读那一段，不要从头再读整章。环境边界（这台机器是 aarch64、`sudo`/`perf` 不可用、ssh 下 stdout 是管道不是终端、正文哪几处读数与本机不符）统一记在[勘误与版本注记](ch04-errata.md)，E 组与 B 组每条都以那一页为准。

## 达标检验

| 检查项 | 达标线 | 回哪一节 |
|:--|:--|:--|
| **K1 `FILE` 与四种 flush** | 不看正文说出 `FILE` 四样成员（fd/标志/读缓冲/写缓冲/锁），列出把缓冲区交内核的四种时刻，并说出「`printf` 返回字符数 ≠ 已写进 fd」 | [2.4.1](ch04.md#sec-2.4.1)；回忆 1、2、[A1](ch04-exercises.md#ex-2.4-A1) |
| **K2 三种缓冲模式** | 30 秒内说全 全/行/无 的写出时机与三条默认规则（stderr 无、终端行、其余全），判断依据说出 `isatty(fileno())` | [2.4.2](ch04.md#sec-2.4.2)；回忆 3、[A2](ch04-exercises.md#ex-2.4-A2) |
| **K3 缓冲何时固化** | 说出模式在**首次 I/O** 按 fd 指向的设备定下并写进 `FILE`，之后 `dup2` 改不回来，由此解释「`fork`/`dup2` 前先 `fflush`」 | [2.4.2](ch04.md#sec-2.4.2)、[2.4.3](ch04.md#sec-2.4.3)；回忆 4 |
| **K4 返回值单位表** | 默写 `fprintf`(字符)/`fscanf`(赋值项，`0`=匹配失败非错误)/`getline`(含`\n`字节)/`fread`(完整项)/`fgetc`(用`int`接) 五个单位与失败判据 | [2.4.4](ch04.md#sec-2.4.4)；回忆 8、[A3](ch04-exercises.md#ex-2.4-A3) |
| **K5 `fread` 短读与 `ferror`/`feof`** | 说出 `fread` 返回 37 可能是「37 完整项 + 半个」，变长数据用 `size=1`；短计数/`-1` 一律靠 `ferror`、`feof` 区分错误与 EOF | [2.4.4](ch04.md#sec-2.4.4)；回忆 10、[A3](ch04-exercises.md#ex-2.4-A3)、[B4](ch04-exercises.md#ex-2.4-B4) |
| **K6 `fork` 队列模型** | 用「每进程一份写队列」说出 `fork`复制/`exec`丢弃/`exit`刷/`_exit`不刷/`fflush`可控；给出两处修复并说明为何「子进程 fork 后又写新数据」时不能只靠 `fflush` | [2.4.5](ch04.md#sec-2.4.5)；回忆 11、12、[A4](ch04-exercises.md#ex-2.4-A4)、[B6](ch04-exercises.md#ex-2.4-B6) |
| **K7 跨层接口** | 说出 `fdopen` 不复制 fd（关流即关 fd，要留原 fd 先 `dup`）、`"a"` 不改内核 `O_APPEND`、`freopen` 失败后 `stdout` 已关不可用、多行原子要 `flockfile` 包 | [2.4.6](ch04.md#sec-2.4.6)；回忆 13、14 |
| **K8 缓冲大小从哪来** | 说出实际缓冲区取 `st_blksize`（本机 4096）不是 `BUFSIZ`（8192）、`setvbuf(f,NULL,...,size)` 里 glibc 忽略 `size`、要控大小须自传 `buf` 且生命周期覆盖整条流 | [2.4.7](ch04.md#sec-2.4.7)、[2.4.8](ch04.md#sec-2.4.8)；回忆 15、16、[B5](ch04-exercises.md#ex-2.4-B5) |
| **K9 内存流时机** | 说出 `open_memstream` 的 `*ptr`/`*sizeloc` 只在 `fflush`/`fclose` 后有效、`fclose` 补的 `\0` 不计入长度、`fmemopen` 关闭不 `free` 调用者的 `buf` | [2.4.9](ch04.md#sec-2.4.9)；回忆 17、[A5](ch04-exercises.md#ex-2.4-A5) |
| **K10 格式化/locale/非阻塞** | 说出 `snprintf` 截断返回「本应长度」（判 `ret>=size`）、`printf(user)` 是格式化串漏洞；`LC_NUMERIC` 让德语 `scanf %f` 读 `3.14` 只到 `3`；非阻塞流 `fread` 返回 0 是 `EAGAIN`（`ferror` 真、`feof` 假）要 `clearerr` | [2.4.11](ch04.md#sec-2.4.11)、[2.4.12](ch04.md#sec-2.4.12)、[2.4.13](ch04.md#sec-2.4.13)；回忆 19、20、[A6](ch04-exercises.md#ex-2.4-A6) |
| **S1 写对 `setvbuf`** | 写一段 `fopen` 后立刻 `setvbuf(f, malloc 的 buf, _IOFBF, n)`，说出为什么不能用栈数组、为什么必须早于首次 `fprintf` | [2.4.7](ch04.md#sec-2.4.7)、[2.4.8](ch04.md#sec-2.4.8)；回忆 5、[B5](ch04-exercises.md#ex-2.4-B5) |
| **S2 处理 `fscanf`/`getline` 循环** | 写出 `while(fscanf(f,"%d",&x)==1)` 且在返回 0 时消费字符不原地循环；`getline` 循环后用 `ferror`/`feof` 收尾 | [2.4.4](ch04.md#sec-2.4.4)、[2.4.10](ch04.md#sec-2.4.10)；回忆 9、18、[B4](ch04-exercises.md#ex-2.4-B4) |
| **S3 修 fork 重复** | 给出 `fork` 前 `fflush` 或子进程 `_exit` 任一修复的完整代码片段，并写出「另一处为何不能省」的一句注释 | [2.4.5](ch04.md#sec-2.4.5)；回忆 11、[C2](ch04-exercises.md#ex-2.4-C2) |
| **S4 用 `snprintf` 算长度再拼串** | 写 `int need=snprintf(NULL,0,...)` 分配 `need+1` 再 `snprintf`，或用 `asprintf`（并说明要 `_GNU_SOURCE`、失败 `*strp` 不可读） | [2.4.11](ch04.md#sec-2.4.11)；回忆 19、[C5](ch04-exercises.md#ex-2.4-C5) |
| **S5 非阻塞流续读** | 写出 `if(n==0 && ferror(f) && errno==EAGAIN){clearerr(f); /* 等可读再试 */}` 的形状，并说明为何事件循环更倾向裸 `read`/`write` | [2.4.13](ch04.md#sec-2.4.13)；回忆 20、[B6](ch04-exercises.md#ex-2.4-B6) |
| **E1 文件大小证缓冲** | 跑 `bufsize`，读出四行 `0/0/18/18`，自己数 `line one\nline two\n`=18 并指出正文「20」是笔误 | [2.4.2](ch04.md#sec-2.4.2)；[C1](ch04-exercises.md#ex-2.4-C1)、[勘误页](ch04-errata.md) |
| **E2 `strace`/`stdbuf` 看缓冲** | 在本机（ssh 管道）跑出「直接跑=一次 21 字节、`stdbuf -oL`/`-o0`=三次 7 字节、`script` 伪终端带 `\r`」，并解释非 tty 为何全缓冲 | [2.4.15](ch04.md#sec-2.4.15)；[C4](ch04-exercises.md#ex-2.4-C4) |
| **E3 延迟错误与内存流** | 跑 `late_error` 得 `6/errno0`→`fflush ENOSPC(28)`→`fclose 0`；跑 `memstream` 得 `fflush` 前 `buf=(nil) len=0`、`fflush` 后 `len=48` | [2.4.3](ch04.md#sec-2.4.3)、[2.4.9](ch04.md#sec-2.4.9)；[C6](ch04-exercises.md#ex-2.4-C6) |
| **B1 读数归属** | 对本章任一数字说出「哪个 libc、哪种 fd/设备、是否 tty」，并区分四类：规范/POSIX 条款、本机工具输出、正文标注的示例读数、未实测；每类各举一例 | [本章依据](ch04-overview.md)、[勘误与版本注记](ch04-errata.md) |
| **B2 环境边界** | 说出测试 VM 是 Ubuntu 24.04.5 **aarch64**、内核 7.0.0-38、GCC 13.3.0、glibc 2.39、4 vCPU；列出本机不能做的（`sudo`、`perf`、跨进程 `strace -p`、`dmesg`）与「ssh 下 stdout 非 tty」这条对缓冲实验的影响 | [环境口径](ch04-overview.md)、[勘误与版本注记](ch04-errata.md) |
| **B3 换平台会搬家什么** | 说出至少四条：`stderr`/终端/文件的默认模式（换非 tty 就变）、`st_blksize` vs `BUFSIZ`、`asprintf`/`getline` 需 `_GNU_SOURCE`/POSIX 宏、德语 `LC_NUMERIC`（两台机器都没装 locale，未实测） | [2.4.2](ch04.md#sec-2.4.2)、[2.4.7](ch04.md#sec-2.4.7)、[2.4.11](ch04.md#sec-2.4.11)、[2.4.12](ch04.md#sec-2.4.12) |

## 没达标怎么办

- **K 组卡住（概念行）**：把因果讲成一句完整的话，例如「因为 `fork` 复制了 stdio 写缓冲区，父子退出各刷一次，所以未 flush 的 `record:` 会变成两份」。讲不出这句就回对应小节的 `errata` 盒重读，不要靠多读几遍正文。
- **S 组卡住（动手行）**：三样必写的东西合上正文默写——`setvbuf`（早于首次 I/O、`buf` 不用栈数组）、`fscanf` 循环的 `==1` + `0` 时消费字符、`fork` 修复的两处。写不出就把 2.4.7 与 2.4.5 的示例代码抄一遍再默写。
- **E 组卡住（实验行）**：先确认环境边界再排错。`cc`/`strace`/`stdbuf`/`script`/`/dev/full` 本机可用，`sudo`/`perf` 不可用；ssh 下 stdout 是管道，「终端行缓冲」要 `stdbuf -oL` 或 `script` 才复现；`snprintf_demo.c` 用正文命令编不过，加 `-Wno-format-truncation`。跑不出预期就降级成「未实测 + 原因」，不要用一次读数推一个常数。
- **B 组卡住（口径行）**：正文有三处与本机不符，逐条对照[勘误页](ch04-errata.md)第 3 节「复跑校正」：`bufsize` 的 18 字节（正文 20）、`stdio_err` 第二行 `ferror=1`（正文 0）、`snprintf_demo` 的编译命令；`st_blksize`/`BUFSIZ`/`asprintf` 的宏前提属于「换 libc/换设备要重取」。
- **只有 K 组全对**：说明还停在「会读」。这一章的出口是「能解释 + 能操作 + 能判断」三条判据（见[章末总结](ch04-summary.md)），S 组与 E 组没做完不要勾这一页。

全部达标后，往下的接口有三处：[2.5 文件属性、扩展属性与 ACL](ch05.md) 会用到本章的 `st_blksize`（它是 `stat` 的一个字段）；[2.10 信号](ch10.md) 讲清为什么信号处理器里绝不能用 `printf`（stdio 有锁、非异步信号安全，正是 2.4.6 那条锁的延伸）；[2.14 socket](ch14.md) 的事件驱动服务绕开 stdio 用裸 `read`/`write`，是 [2.4.13](ch04.md#sec-2.4.13) 结论的工程落地。
