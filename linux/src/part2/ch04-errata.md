# 2.4 勘误与版本注记

这一页收本章最容易「换一台机器、换一个 libc、把输出重定向一下、换一个挂载的文件系统就不成立」的东西：缓冲模式到底由谁定、缓冲区多大、`setvbuf` 的时机与大小、`fflush`/`fclose` 的范围与延迟错误、`fork` 复制缓冲、返回值单位、内存流的 flush 时机、`asprintf`/`getline` 的宏前提、locale 与非阻塞流。正文里的 `errata` 盒讲**理解陷阱**（把 A 当成 B），这一页讲**搬家陷阱**（在 A 机器/A 设备上成立、到 B 上悄悄变）。用之前记住一条纪律：**别把「一次 stdio 调用」当「一次 `write`」，别把「一个数字」当「到处一样的数字」**——这两条做对了，下面这张表多数行都不必背。

**本章基线**：正文与套件里标「VM」的读数来自本书 Ubuntu 24.04.5 虚拟机（**aarch64 / ARM64，不是 x86-64**、内核 `7.0.0-38-generic`、GCC 13.3.0、glibc 2.39、4 vCPU）。`sudo` 与 `perf` 不可用；跨进程 `ptrace` 被 `ptrace_scope=1` 挡住（`strace -p <别人的 PID>` 报 `Operation not permitted`，本章 `strace` 只用「在 strace 下启动」）；`dmesg` 被 `dmesg_restrict` 挡住。`cc`、`strace`（6.8）、`stdbuf`、`timeout`、`script`、`/dev/full` 可用。**一条要紧前提**：通过 ssh 非交互执行时程序的 stdout 接的是**管道不是终端**，`isatty` 为假，正文「终端行缓冲」那一半在本机要靠 `stdbuf`/`script` 才复现得出来。第 3 节是把正文九个程序在这台机器上逐个编译运行后的对照；写作机是 Apple 芯片 macOS（arm64），没有 `/proc`、没有 `strace`，缓冲与 locale 按 Apple 的 libc 走。

## 1. 十九条容易搬家的结论

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「缓冲类型由 fd 决定，`dup2` 把 fd 换个去处就跟着改」 | 由 fd **当时指向的设备**在**首次 I/O 时**判定（`isatty(fileno())`）并固化进这个 `FILE`；之后再 `dup2` 到终端或文件都不会改回模式。这正是 2.3 要求「`fork`/`dup2` 前先 `fflush`」的根因 | 先 `printf` 一下（定下模式）再 `dup2` 到 tty，看是否仍按旧模式刷；本机 ssh 下 stdout 是管道 → 判为非 tty（见第 3 节 tick 实验） |
| 「`fprintf` 之后 `setvbuf` 也能改缓冲模式」 | 标准要求在**任何 I/O 之前**调用 `setvbuf`；首次操作之后再调，glibc 可能直接忽略或行为未定义 | `fopen` 后立刻 `setvbuf` 与「先 `fprintf` 再 `setvbuf`」各编一版跑，比较 flush 时机（正文 2.4.2 errata 第 1 条） |
| 「`fflush(NULL)` 刷新所有流」 | 刷的是**所有输出流**（以及带未写数据的流）；对输入流 `fflush` 在 C 标准里未定义，POSIX 只对可寻址输入流允许「丢弃缓冲」，别依赖 | `man 3 fflush` 的范围说明；对输入流想要「丢缓冲」用 `__fpurge`/不混用 `read`，别用 `fflush` |
| 「`_IONBF` 就是一次 stdio 调用恰好一次 `write`」 | 不保证。`_IONBF` 仍有一字节内部缓冲，一次 `printf` 会不会拆成多次 `write` 取决于上一次是否留了半个字节；「调用数 = 写数」这个等式在任何模式下都不成立 | 本机 `stdbuf -o0` 或 `setvbuf(_IONBF)` 跑 `tick`，`strace -e write` 数 `write(1,...)` 次数；单次 `printf("hi\n")` 恰得一次 `write(1,"hi\n",3)`，但别据此推「永远一次」 |
| 「行缓冲到处一样，`\n` 一定会触发写出」 | 行缓冲只在**连终端**时是默认；输出重定向到文件或管道后切成**全缓冲**，`\n` 不再触发，数据等满/`fflush`/`exit`。同一份 `printf("hello\n")` 终端立刻、文件要等退出 | 本机经 ssh：`strace -e trace=write ./tick`（管道）得一次 21 字节；`stdbuf -oL` 得三次 7 字节；`script` 伪终端才像终端（且 `\n` 被 ONLCR 转成 `\r\n`） |
| 「`fwrite`/`fread` 返回值就是成功读写的字节数」 | 返回的是**完整项数**，不是字节数；短计数既可能是 EOF 也可能是错误，单看返回值分不出来 | `size=1` 时返回值才等于字节数；短读后用 `ferror(f)`（错误）与 `feof(f)`（末尾）区分（正文 2.4.4） |
| 「`printf` 带 `\n` 就绝不会重复输出」 | 目标是非 tty（文件/管道）时是全缓冲，`\n` 不触发 flush，`fork` 复制的缓冲区父子各刷一份，照样重复 | 本机 `fork_dup` 复跑：重定向到文件得 `record:record:`；要看出重复必须重定向，终端行缓冲下 `\n` 先刷反而掩盖 |
| 「`stdout` 的缓冲区就是 `BUFSIZ`」 | 全缓冲大小取 `fstat` 的 `st_blksize`（本机 4096），取不到才用 `BUFSIZ`（glibc 定义 8192）。`BUFSIZ` 是兜底常量，不等于实际缓冲区 | `bufmodes` 首行本机打 `BUFSIZ=8192 PAGE=4096`；`stat -f`/`fstat` 看 `st_blksize`，别背 4096 或 8192 |
| 「文本文件上 `ftell` 的偏移就是第几行/第几字符」 | Linux 文本模式不做 `\r\n` 转换，`ftell` 给的是**字节偏移**；但同一 `FILE` 上读写交替时，写后读要 `fflush`/`fseek`、读后写要 `fseek`（除非读到 EOF），否则未定义 | 用 `fseek`/`fseeko` 在纯文本文件上按字节偏移 seek 验证；混合读写不加 `fseek` 复现「碰巧能跑」的假象（正文 2.4.3） |
| 「`tmpfile()`/`mkstemp()` 帮我把临时文件建安全了」 | **本章正文没有讲 `tmpfile`/`mkstemp`**，别从 stdio 推出安全临时文件结论。`/tmp` 世界可写且有符号链接：先 `access`/判断不存在再 `open` 有 TOCTOU 窗口，被抢建/换链即中招；安全做法是 `O_CREAT\|O_EXCL`（或 `mkstemp`）原子创建 | `man 3 mkstemp`、`man 3 tmpfile`；这一步属跨节安全提醒，不在 2.4 正文范围，别把没读过的接口当 stdio 自带 |
| 「`fclose` 返回成功，数据就落盘了」 | `fclose` 只把数据交给内核（`write`，进 page cache），断电/崩溃仍可能丢；落盘要 `fsync(fileno(f))` | 正文 2.4.2 errata 第 3 条「`fflush` 不等于落盘」；需要持久性就在 `fflush` 后 `fsync`（`fsync` 的具体语义按文档，本机未做掉电验证） |
| 「`fclose` 失败后这个流还能接着用」 | `fclose` 一旦调用（成或败）流即失效，不可再用；而且**返回 0 不代表写成功**——失败的 `fflush` 可能已把缓冲丢弃，`fclose` 无数据可写也就不再报错 | 本机 `late_error` 写 `/dev/full`：`fflush` 得 `errno=28`，`fclose` 反而返回 0（`errno=0`），故两个返回值都要看、别只信一个 |
| 「`snprintf` 截断会返回 -1 或设 `errno`」 | 截断不是错误，返回的是「若缓冲足够本应写入的字符数」（不含 `\0`），只有编码错误才返回负值；判截断看 `ret >= size` | 本机 `snprintf(small[8],"%s","0123456789")` 返回 **10**、`small`=`0123456`、`truncated=1`（见第 3 节） |
| 「`asprintf` 是标准 C / POSIX 接口」 | 是 GNU/BSD 扩展，非 C 标准；`-std=c17` 不给 `_GNU_SOURCE` 时报 `implicit declaration of function 'asprintf'`（正文标它「GNU/POSIX.1-2008」偏宽）；失败返回 -1 且 `*strp` 未定义，别读 | 本机分别用 `-std=c17`（无宏）与 `-D_GNU_SOURCE` 编只调 `asprintf` 的小程序，前者隐式声明警告、后者得 `3 x-1` |
| 「`open_memstream` 之后马上能读 `*ptr`/`*sizeloc`」 | 只在 `fflush` 或 `fclose` **之后**才更新；之前 `*ptr` 可能是 `NULL`、`*sizeloc` 是旧值；`fclose` 补的结尾 `\0` 不计入 `*sizeloc` | 本机 `memstream`：`fflush` 前 `buf=(nil) len=0`，`fflush` 后 `len=48`（见第 3 节） |
| 「`fmemopen` 关闭时会 `free` 那块内存」 | 不会，缓冲区归调用者，`fclose` 后仍要自己 `free`；`"w"` 不自动补终止符，`"a"` 追加位置是块里第一个 `\0`（不是 `size` 末尾），`size==0` 返回 `NULL`+`EINVAL` | 正文 2.4.9 errata 四条；写完 `buf` 用 `strlen`/`len` 验证有没有终止符 |
| 「`getline` 是标准 C，遇 `\0` 会停」 | `getline`/`getdelim` 属 POSIX.1-2008，不是 C17，需 `_POSIX_C_SOURCE>=200809L` 或 `_GNU_SOURCE`；它按分隔符读、遇嵌入 `\0` 不停，返回值含分隔符 `\n`（`"abc\n"` 返回 4） | 本机 `linecount` 读 `a\nbbb\ncc\n` 得 `lines=3 longest=4`；用 `-std=c17` 无宏编 `getline` 看是否隐式声明 |
| 「`stdbuf` 能给任意程序改缓冲、生产也可靠它」 | `stdbuf` 只影响 `stdin/stdout/stderr` 三个标准流，靠 `LD_PRELOAD`；对**静态链接**程序、对**已经自己 `setvbuf`** 过的流都无效。调试方便，别当生产方案 | 本机 `stdbuf -oL/-o0` 对动态链接的 `tick` 生效（见第 3 节）；拿一个 `-static` 的程序试就失效 |
| 「`stderr` 可以随手改成全缓冲提速」 | 能改，但错误信息会延迟到崩溃前才出现、甚至随进程消失；C 只要求 `stderr`「非全缓冲」，glibc 取**无缓冲**就是为了立刻可见。改它要三思 | 正文 2.4.2、2.4.7 的默认规则；把 `stderr` `setvbuf(_IOFBF)` 后 `kill -9` 看错误丢不丢 |

## 2. 另外三条常被当成定理的写法

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「混用 `printf` 与 `write` 只是风格问题」 | 顺序会变：`printf("A"); write(1,"B",1); printf("C")` 在全缓冲下内核看到 `B` 先、`AC` 后（`BAC`）。读方向更隐蔽——`read` 绕开 stdio 会把预读副本丢掉，`fgets` 从旧副本继续就「少读一行」 | 本机复跑 `strace -e trace=write` 得 `write(1,"B",1)` 然后 `write(1,"AC",2)`，`od -c` 文件是 `B A C`；修法只有「统一一层」或「混用前 `fflush`」 |
| 「`fscanf` 返回 0 是出错」 | `0` 是**匹配失败**、不是错误也不是 EOF，而且**流位置不前进**——原地重试就是死循环；EOF 只在首个转换前失败时返回 | 本机 `scan_demo`：`"oops 7 ms"` 对 `%d %d %7s` 返回 **0**，空输入才返回 EOF；循环写 `==1` 并在 0 时消费当前字符 |
| 「非阻塞流上 `fread` 返回 0 就是 EOF」 | 是「现在没数据」：glibc 设**错误标志**（`ferror` 真、`feof` 假）、保留 `errno=EAGAIN`；不 `clearerr` 流一直报错、后续调用直接失败 | 本机 `stdio_err`：空管道首行 `n=0 ferror=1 feof=0 errno=11`；`clearerr` 后再读才拿到 `hello` |

## 3. 复跑校正（2026-11-02，同一台 VM）

下面是把正文九个程序（`bufsize`、`late_error`、`scan_demo`、`linecount`、`fork_dup`、`bufmodes`、`memstream`、`snprintf_demo`、`stdio_err`）与 `tick` 实验在这台 aarch64 虚拟机（`cc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0`、`ldd (Ubuntu GLIBC 2.39-0ubuntu8.9) 2.39`、strace 6.8）上逐个编译运行后，与正文对不上的地方。程序大多能用正文命令一次编过并复现正文读数（`late_error`、`scan_demo`、`bufmodes`、`memstream`、`linecount`、`fork_dup` 全对上）；只有下面四处不符，套件的读数一律以「本机实测」列为准。

| 正文原写法 | 本机实测 | 结论 |
|:--|:--|:--|
| 2.4.2 `bufsize.c`：终端块 `# fflush 之后 size=20`，正文解释「两行共 20 字节」 | 四行是 `0/0/18/18`；`printf 'line one\nline two\n' \| wc -c` = **18**（`line one`8+`\n`+`line two`8+`\n`） | 正文把字节数算错了，应是 **18**。核心读数（`fprintf` 后 0、`fflush` 后变非零）不受影响；套件的 C1 用 18 |
| 2.4.11 `snprintf_demo.c` 的编译命令 `cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2` | 本机**编译失败**：`-Werror=format-truncation` 把「故意把 10 字节截进 `small[8]`」判成错误 `'%'s' directive output truncated writing 10 bytes into a region of size 8` | 命令与示例代码在这里冲突。加 `-Wno-format-truncation` 即可编过，运行读数不变（`ret=10 size=8 truncated=1 buf=0123456`、`asprintf ret=14`、`need=16`）。正文应补一句「故意截断的样例要关掉 `-Wformat-truncation`」 |
| 2.4.13 `stdio_err` 预期第二行 `after clearerr: n=6 ferror=0 feof=0` | 本机得 `after clearerr: n=6 ferror=`**`1`**` feof=0`（`data=hello` 仍正确读出） | 正文这一行读数错。原因：`clearerr` 后 `fread(buf,1,64,in)` 读满缓冲请求 64，只拿到 6 字节后又在该空管道上撞 `EAGAIN`，重新置了错误标志——数据读到了，但 `ferror` 是真。这条正好强化「别只看 `ferror`，要看返回值/`errno`」 |
| 2.4.15「`strace -e trace=write ./tick`（终端）：每行一次 `write(1,"tick N\n",7)`」 | 本机经 ssh：stdout 是**管道**，`./tick` 全缓冲 → **一次** `write(1,"tick 0\ntick 1\ntick 2\n",21)`；`stdbuf -oL`/`-o0` 才得三次 `write(1,"tick N\n",7)`；`script` 伪终端下 trace 到 `script` 转发的三次 `write(1,"tick N\r\n",8)`（多出 `\r` 是 tty ONLCR） | 「终端行缓冲」这一半在本机默认复现不出来（没有 tty）。要么 `stdbuf -oL`、要么接真终端/伪终端。伪终端里 `\n→\r\n` 属 tty 层转换，不是 stdio 行为，别混淆 |
| 【复核 2026-11-02】2.4.2 `bufsize`：`# fflush 之后 size=20` / 「两行共 20 字节」 | 本机跑读数 `0/0/18/18`；`printf 'line one\nline two\n' \| wc -c` = 18 | 复核确认 **18**；正文两处 `size=20` 改 `size=18`、解释句按 8+1+8+1 计算并附 `wc -c` 对账口径 |
| 【复核 2026-11-02】2.4.11 `snprintf_demo` 的编译命令 `-Wall -Wextra -Werror -O2` | 本机 exit=1，报错 `'%'s' directive output truncated writing 10 bytes into a region of size 8 [-Werror=format-truncation=]`；加 `-Wno-format-truncation` 后 exit=0，运行读数 `ret=10 size=8 truncated=1 buf=0123456`、`asprintf ret=14`、`need=16` 不变；把 `size` 换成运行期 `cap` 变量仍报同错（按 `__glibc_objsize(small)`=8 判） | 命令调整：正文命令加 `-Wno-format-truncation`，附报错原文与「故意截断样例为什么要关那一个警告」；「改示例绕开警告」那条路本机否证，不采用 |
| 【复核 2026-11-02】2.4.13 `stdio_err` 第二行 `ferror=0` | 复跑三次 `ferror=`**`1`** 稳定；`strace` 序列：`read(3,"hello\n",4096)=6` 紧跟 `read(3,...,4096)=-1 EAGAIN`（同一次 `fread` 凑缓冲 4096 时撞非阻塞空管道）；「去掉 clearerr」变体也 `n=6 ferror=1 data=hello` | 概念订正：读数改 `ferror=1`；解释重写为「这次 `fread` 自己尾随 `read` 撞 `EAGAIN` 立起错误标志，不是 `clearerr` 失效」；旧「不 `clearerr` 第二次返回 0」一句一并纠正（本机否证 glibc 会这样短路） |
| 【复核 2026-11-02】2.4.15「终端：每行一次 `write`」演示 | 三种环境本机实测：①非交互 ssh 管道 / `> 文件`：`[ -t 1 ]` = not tty，一次 `write(1,"tick 0\ntick 1\ntick 2\n",21)`；`/tmp/tick.out` `wc -c` = 21；②`stdbuf -oL` / `-o0`（仍管道）：三次 `write(1,"tick N\n",7)`；③`script` 伪终端：tick 的 `strace` 显示三次 `write(1,"tick N\n",7)`，`cat -A` 见 `tick N^M$`（`od -An -c` 见 `\r \n`），`strace -f` 追 `script` 见其自己 `write(1,"tick N\r\n",8)` | 正文重写为三种环境（管道 / stdbuf / 伪终端）各给命令 + 真实读数 + 一张对照表 + 「你在自己机器上会看到什么」说明；`\r` 归为 tty `ONLCR`（不是 stdio），`tick` 7 与 `script` 8 分属两进程 |

另有一条把「推断」升级为「实测」的印证（不是差异）：正文 2.4.3 说 `printf`/`write` 混用内核看到 `BAC`——本机 `strace` 直接证成 `write(1,"B",1)` + `write(1,"AC",2)`、文件 `od -c` 为 `B A C`。正文 `late_error` 的 `fprintf 6/errno=0`、`fflush errno=28 (ENOSPC)`、`fclose errno=0` 三个值本机逐字复现。

## 4. 本章未实测项

下面这些在本环境没有本机证据，引用时当作**待验证的形状、量级或方法**，不要抄成事实：

- **德语/法语 `LC_NUMERIC`**（2.4.12 的 `scanf("%f")` 读 `3.14` 只到 `3`）：本机 `locale -a` 里**没有装 `de_DE`/`fr_FR`**，无法在 VM 复现这一现象；「locale 影响数值解析」是机制层结论，本机未跑出对照输出。写作机 macOS 同样没有对应 locale。
- **`tmpfile`/`mkstemp` 与符号链接攻击**：本章正文未涉及这两个接口，套件也没有构造 `/tmp` 抢建/换链现场；第 1 节那行只是安全提醒，不在 2.4 的实测范围。
- **`fsync` 的落盘语义与掉电后果**：`fsync`/`fdatasync` 到磁盘的持久性需要真实磁盘或 root 权限验证，本机只做机制说明，未实测。
- **`st_blksize` 在别的文件系统/内核页大小上的取值**：本机 `/tmp` 在 ext4 根分区上、页 4096，`st_blksize` 观察到 4096；NFS/FUSE/64 KiB page 内核上缓冲区会不同，未在这些环境测。
- **真硬件终端下的行缓冲**：本机的「终端」是用 `script` 造的伪终端（且会做 ONLCR 转换），不是物理 tty；物理终端的换行/回显细节未实测。
- **多线程下 `flockfile`/`_unlocked` 的实际竞态复现**：正文给出正确用法，本机没有构造两个线程交错写同一 `FILE` 的现场。
- **跨 libc 的行为差**：正文只讲 Linux/glibc 2.39。musl 等实现下 `BUFSIZ`、`stderr` 默认模式、`asprintf`/`fmemopen` 可用性都可能不同，本套件未测。
- **母本页码**：正文引 Kerrisk 的 p195、p223–225 属旧版格式，本书约定只按章节号（第 13 章、第 25 章 25.4）核对，页码不作为依据。

## 5. 发现新问题怎么记

按「**现象 → 命令与输出 → 机器/设备/libc → 建议改法**」四段记，不要只写「我这里不对」——本章的结论挂在「输出接的是终端还是管道/文件」「哪个 libc」「缓冲区多大」上，缺了第三段就没有可比较的基准。四段这样填：

1. **现象**：一句话说清「谁在什么时候看起来坏了」。例：「`bufsize` 打完 `fflush 之后 size=20` 之后，我机器上 `stat` 出来的其实没那么多」。
2. **命令与输出**：贴你**原样敲的编译命令行**与**未经删减的运行输出**（含 `strace` 行、`wc -c`、退出码）。例：`cc -std=c17 ... snprintf_demo.c` 的完整报错；`strace -e trace=write ./tick` 的 `write(1,...)` 行。
3. **机器/设备/libc**：至少附 `uname -a`、`uname -m`、`cc --version | head -1`、`ldd --version | head -1`、`strace -V | head -1`、`getconf PAGE_SIZE`；**必须写清这次运行里 stdout 是不是 tty**（`[ -t 1 ] && echo tty`）、是不是经 ssh 管道、`/dev/full` 是否可写；涉及缓冲大小附 `stat -f`/`fstat` 的 `st_blksize`。
4. **建议改法**：写「该改成什么动作」而不是「正文错了」。例：「正文该标 18 字节」「示例应加 `-Wno-format-truncation` 并注一句『故意截断的样例』」「终端行缓冲那段应改成 `stdbuf -oL` 演示」。

最后把结论归到四类再说话：**规范/POSIX 条款**（可断言，如「`setvbuf` 要早于首次 I/O」）、**本机工具输出**（可复算，如「本机 `BUFSIZ`=8192、`PAGE`=4096、`bufsize` 后 18 字节」）、**正文标注的示例读数**（只作形状参考，如各程序的预期输出）、**未实测**（必须写清为什么没测，如德语 locale、`fsync` 落盘、`tmpfile`/`mkstemp`）。本章最常见的分歧，是把「终端 = 行缓冲」当成「任何地方 = 行缓冲」，以及把「一次 stdio 调用」当成「一次 `write`」。
