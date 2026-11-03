# 2.4 章末总结

## 三段主线：三个单元，一条因果链

**第一段，缓冲层与三种模式（2.4.1–2.4.3，第一个单元）。** `FILE` 是 glibc 的不透明结构（`struct _IO_FILE`），至少装着一个 fd、一组标志、读/写两块用户态缓冲区和一把锁。`printf` 不碰内核，只把字符拷进 `_IO_write_base..ptr`；把缓冲区交给内核只有四种时刻：缓冲满、`fflush`、`fclose`、`exit`。缓冲模式在**首次 I/O 时**由 `isatty(fileno(stream))` 决定并固化进这个流：`stderr` 无缓冲、接终端的流行缓冲、其余全缓冲，大小取 `st_blksize`（本机 4096），取不到才用 `BUFSIZ`（glibc 8192）。所以同一份 `printf("hello\n")` 在终端立刻出现、重定向到文件要等退出——不是内核慢了，是从行缓冲切成了全缓冲。`fflush(NULL)` 刷的是**所有输出流**，对输入流是未定义；`fclose` 先 flush 再 close，磁盘满这类错误会一路延迟到 `fclose` 才冒出来，所以必须查它的返回值。和 `write` 混用时，内核看到的是 `B` 先进、缓冲区里的 `AC` 后进，顺序变成 `BAC`——正确做法只有「混用前 `fflush`」或「只用一层」。

**第二段，返回值与 `fork`（2.4.4–2.4.8，第二个单元）。** stdio 的返回值语义不统一，这是 bug 高发区：`fprintf` 返回**字符数**（不是写进 fd 的字节，可能还在缓冲）、`fscanf` 返回**成功赋值的项数**且 `0` 是匹配失败不是错误、`getline` 返回**含 `\n` 的字节数**、`fread`/`fwrite` 返回**完整项数**、`fgetc` 必须用 `int` 接。判失败要靠 `ferror`/`feof` 而不是光看返回 `-1`/`0`。`fork` 复制整个地址空间，**包括这块缓冲区**：缓冲区里没写出的数据父子各一份，两者退出各刷一次，同一段字节就打了两次——`fork_dup` 复跑得到 `record:record:`，`fork` 前 `fflush` 或子进程 `_exit` 两处修复任一即可。把 stdio 想成「每个进程一份的写队列」：`fork` 复制队列、`exec` 丢弃队列（未 flush 的数据丢失）、`exit` 刷队列、`_exit` 不刷、`fflush` 是你唯一能精确控制队列何时变成 `write` 的手段。`fileno`/`fdopen`/`freopen` 负责跨层：`fdopen` 不复制 fd，关流即关 fd；多线程里单条 stdio 调用自带锁，跨行原子要 `flockfile` 手动包住。

**第三段，大小、内存流、格式化与取证（2.4.9–2.4.17，第三个单元）。** 缓冲区大小是 `st_blksize` 不是 `BUFSIZ`，`setvbuf(f, NULL, _IOFBF, n)` 里 glibc 会忽略 `size`，要控制大小必须自己传一块生命周期覆盖整条流的 `buf`（不能用栈数组）；`setbuf`/`setbuffer`/`setlinebuf` 都是它的包装，`setbuf(f, NULL)` 是**无缓冲**不是「让 libc 分配」。内存流把 stdio 用到内存上：`fmemopen` 包已有内存，`open_memstream` 让流自己长，但 `*ptr`/`*sizeloc` **只在 `fflush`/`fclose` 后才有意义**（本机复跑：`fflush` 前 `buf=(nil) len=0`）。`getline`/`getdelim` 无 `fgets` 的行长限制，返回值含分隔符、含嵌入 `\0` 也不截断。`snprintf` 截断返回的是「本应写入的字符数」，判截断看 `ret >= size`，`asprintf` 要 `_GNU_SOURCE`，`printf(user)` 是格式化字符串漏洞。locale 的 `LC_NUMERIC` 会让德语环境下 `scanf("%f")` 把 `3.14` 只读成 `3`，机器可读数据要钉死 `"C"` locale。非阻塞 fd 包成流后，`fread` 用「设错误标志、`feof` 为假」报告「现在没数据」，必须 `clearerr` 才能续读。最后 2.4.14 给出 `printf`→`_IO_file_xsputn`→`_IO_file_overflow`→`write` 的调用链，2.4.15 用 `strace -e write`、`stdbuf -oL`、伪终端把「缓冲存在」读出来。

一句话主线：**先把「一次 stdio 调用」和「一次 `write`」分开，再把所有顺序、少行、重复、返回值看不懂的现象还原成「缓冲时机」与「返回值语义」两件事，最后用文件大小、`strace`、`stdbuf`、伪终端各证一半——而不是靠「我这看着正常」。**

## 三条判据

| 判据 | 具体要求（做不到就回右列） | 主要落点 |
|:--|:--|:--|
| **能解释** | 画出 `FILE`→缓冲区→`write`→page cache 并说出四种 flush 时机；说全「stderr 无缓冲 / 终端行缓冲 / 其余全缓冲」三条默认规则；讲清 `fork` 为什么重复、`exec` 为什么丢数据 | [2.4.1](ch04.md#sec-2.4.1)、[2.4.2](ch04.md#sec-2.4.2)、[2.4.5](ch04.md#sec-2.4.5) |
| **能操作** | 写对 `setvbuf`（首次 I/O 前、缓冲区不用栈数组、要控大小就传 `buf`）；正确处理 `fread` 短读与 `getline` 的 `ferror`/`feof`；用 `snprintf` 返回值检截断、`open_memstream` 在 `fflush` 后读 `len` | [2.4.3](ch04.md#sec-2.4.3)、[2.4.4](ch04.md#sec-2.4.4)、[2.4.7](ch04.md#sec-2.4.7)、[2.4.9](ch04.md#sec-2.4.9)、[2.4.11](ch04.md#sec-2.4.11) |
| **能判断** | 给现象定位到层：最后一行没了是缓冲、顺序乱是混用 `write`、`fclose` 才报错是延迟错误、`fread` 返回 0 是 `EAGAIN` 不是 EOF；引用数字前先分清 `st_blksize` 与 `BUFSIZ`、终端与非 tty | [2.4.13](ch04.md#sec-2.4.13)、[2.4.16](ch04.md#sec-2.4.16)、[勘误页](ch04-errata.md) |

## 只记一件事

**`printf`/`fprintf` 返回的是「拷进缓冲区的字符数」，不是「内核收到的字节数」——数据可能还全在用户态缓冲里。** 这一条同时解释本章四件事：为什么 `kill -9` 会丢最后一行（缓冲没刷）、为什么 `fork` 后重复（缓冲被复制）、为什么 `fclose` 才报 `ENOSPC`（真正 `write` 推迟到最后）、为什么和 `write` 混用顺序成 `BAC`（缓冲的旧数据后发）。记不住别的没关系，把「stdio 调用 = 一次 `write`」这个直觉改过来，后面每一章用到 stdio 都不会再踩反。

## 六页怎么用

1. **[章总览](ch04-overview.md)**：先看五段一览表与「环境口径」，尤其记住「ssh 下没有 tty」这条会影响 2.4.15 的复现。
2. **[章末总结](ch04-summary.md)**（这一页）：合上正文读一遍，把三段主线当目录自查。
3. **[闭卷回忆卡](ch04-recall.md)**：21 张卡，只看问题作答；`✓/△/×` 三种结果，下一轮只做 `△` 与 `×`。
4. **[习题集](ch04-exercises.md)**：A 组概念判断 6 题、B 组诊断推理 6 题、C 组动手实验 6 题（全部免 `sudo`）；每题第一个动作都是「先猜」。
5. **[学习目标自检表](ch04-checklist.md)**：接管 [2.4.17 本章出口检查](ch04.md#sec-2.4.17)，按概念/动手/实验/口径四组逐条当场做。
6. **[勘误与版本注记](ch04-errata.md)**：正文有三处读数与这台 aarch64 机器不符（`bufsize` 的字节数、`snprintf_demo` 的编译命令、`stdio_err` 的 `ferror`）；抄数字、照搬编译命令前先看第 3 节「复跑校正」。

## 下一站

[2.5 文件属性、扩展属性与 ACL](ch05.md) 从「文件里有什么」转向「文件本身是什么」：`stat` 的字段、稀疏文件、xattr 与 ACL 的落盘方式——本章 `st_blksize` 正是 `stat` 里的一个字段，会在那里展开。往回查：[2.3 高级文件 I/O](ch03.md) 解释 `dup2`/`fork` 为什么要求先 `fflush`；往前看，[2.10 信号](ch10.md) 会讲为什么在信号处理器里绝不能用 `printf`（stdio 有锁、不是异步信号安全），[2.14 socket](ch14.md) 里事件驱动服务通常绕开 stdio 直接用 `read`/`write`，正是本章 2.4.13 的结论。
