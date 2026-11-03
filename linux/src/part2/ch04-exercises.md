# 2.4 习题集

三组分层：**A 组概念判断**考「会画、会说单位、会把缓冲时机讲清」；**B 组诊断推理**给现象让你判层、判时机、判修法；**C 组动手实验**在本书的 Ubuntu 24.04.5 aarch64 虚拟机上免 `sudo` 复现本章的关键证据。全部附解答与判据；先独立完成，再展开对照。每题的第一个动作都是「先猜」：把预期写下来，再去验证；猜错的地方才是这题的价值。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟；A 组要求口述或写一段完整因果，B 组要求写成「现象 → 机制 → 证据 → 修法」四段，C 组要求先写下预期读数再敲命令。
2. 卡住了回对应小节的 `errata` 盒或「即时自测」重读，不要直接看答案：A 组对应 2.4.1–2.4.13，B 组对应 2.4.3–2.4.16，C 组对应 2.4.2–2.4.15。
3. C 组的命令都在 Ubuntu 24.04.5（aarch64、内核 7.0.0-38、GCC 13.3.0、glibc 2.39、4 vCPU）上设计；源码一律从正文抄（`bufsize.c`、`fork_dup.c`、`bufmodes.c`、`memstream.c`、`snprintf_demo.c`、`stdio_err.c`、`late_error.c`、`tick.c`），临时文件统一用 `lab2c04_` 前缀。
4. **`sudo` 与 `perf` 不可用**：`cc`、`strace`（6.8）、`stdbuf`、`timeout`、`script`、`/dev/full` 可用；`strace` 只用「在 strace 下启动程序」，`strace -p <别人的 PID>` 会被 `ptrace_scope=1` 挡住。**通过 ssh 跑时 stdout 是管道不是终端**，`isatty` 为假，正文「终端行缓冲」那一半要靠 `stdbuf`/`script` 才复现得出来。
5. 凡是要贴具体数字的读数，都已在这台 aarch64 机器复跑过；与正文不一致的地方（`bufsize` 的字节数、`snprintf_demo` 的编译命令、`stdio_err` 的 `ferror`）见[勘误页](ch04-errata.md)「复跑校正」，要写出差异并解释，不要改数字去迁就正文。
6. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch04-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 2.4-A1 · `FILE` 与四种 flush 时机 {#ex-2.4-A1}

先猜：`printf("hello")` 返回 5，此刻 `hello` 在内核里还是在用户内存里？`_exit` 之后 `exit` 之前，缓冲区归谁管？

不看正文说出 `FILE` 至少装的四样东西；列出把用户态缓冲区交给内核的四种时刻；解释为什么「`printf` 之后立刻 `kill -9`」丢数据、而「`printf` 之后 `fork`」不丢但可能重复。

::: sol 解答

`FILE`（glibc 的 `struct _IO_FILE`）至少有：fd（`_fileno`）、标志位（读/写/追加/EOF/错误/用户缓冲）、读缓冲区、写缓冲区（`_IO_write_base/ptr/end`），外加一把保护这个流的锁。`printf("hello")` 返回 5 只表示「5 个字符拷进了写缓冲区」，数据还在用户内存，没进内核。交缓冲区的四种时刻：缓冲区满、显式 `fflush`、`fclose`（先 flush 再 close）、正常 `exit`（`__run_exit_handlers`→`_IO_cleanup` 刷所有流）。`kill -9` 是 `SIGKILL`，不经处理器、不跑 atexit、不刷 stdio，缓冲区随地址空间消失，所以丢；`fork` 复制整个地址空间**包括缓冲区**，数据不丢，但父子各持一份、退出各刷一次，就变成重复。

**判据**：四样成员说全；四种 flush 时机说全；把「返回字符数 ≠ 写进 fd 的字节」讲清；能区分「`kill -9` 丢」与「`fork` 重复」各因哪条机制。

:::
:::

::: ex 例 2.4-A2 · 三种模式、默认规则与「何时定下来」 {#ex-2.4-A2}

先猜：`printf("hello\n")` 在终端和 `./app > out.txt` 下，`write` 次数一样吗？模式是在 `fopen` 那一刻定的，还是第一次 I/O 那一刻定的？

说出全/行/无缓冲各自的写出时机；说出 glibc 的三条默认规则及其判断依据；解释同一份 `printf("hello\n")` 为何终端立刻、文件要等退出；再说明缓冲模式在何时被固化、之后 `dup2` 改 fd 的去处会不会改回来，由此解释 [2.3](ch03.md) 为什么要求「先 `fflush` 再 `dup2`/`fork`」。

::: sol 解答

写出时机：全缓冲 `_IOFBF` 满/`fflush`/`fclose`/`exit`；行缓冲 `_IOLBF` 遇 `\n`、满、`fflush` 等；无缓冲 `_IONBF` 每次 stdio 调用直接写。三条默认规则：`stderr` 无缓冲（C 只要求非全缓冲，glibc 取无缓冲），连终端的流行缓冲，其余全缓冲；依据是 `isatty(fileno(stream))`。终端上 `\n` 触发行缓冲 flush，所以立刻出现；重定向到文件是非 tty → 全缓冲，`\n` 不触发，等满或 `exit`——不是内核慢，是模式不同。关键：模式在**首次 I/O 时**按当时 fd 指向的设备算出并写进这个 `FILE`，之后再 `dup2` 把 fd 换到终端或文件都不会改回。所以 `dup2`/`fork` 之前若缓冲区已有数据，要么它按旧模式迟迟不刷、要么被复制，必须先 `fflush` 把数据在可控时刻交出去。

**判据**：三种时机不混；三条默认规则含「stderr/终端/其余」齐全且说出 `isatty`；「内核没变慢，是 stdio 切模式」这句到位；说出模式在首次 I/O 固化、`dup2` 改不回来，并接上 `fflush` 的必要性。

:::
:::

::: ex 例 2.4-A3 · 五类返回值的单位 {#ex-2.4-A3}

先猜：`fread(buf,1,sizeof buf,f)` 返回 `sizeof buf` 和 `fread(rec,sizeof(rec),100,f)` 返回 37，两个「返回数」是同一单位吗？`fgetc` 为什么不能用 `char` 接？

填一张表：`fprintf`、`fscanf`、`getline`、`fread`/`fwrite`、`fgetc` 的成功返回值各是什么单位，失败/边界怎么判；指出哪两个的 `0`/短计数最容易被误判成错误，正确的区分手段是什么。

::: sol 解答

`fprintf`/`printf`：写出的**字符数**，可能还在缓冲区，不等于落到 fd 的字节，失败返回负数并设 `errno`。`fscanf`/`scanf`：成功**赋值的项数**，`EOF` 是首个转换前失败、`0` 是匹配失败（**不是错误**）。`getline`/`getdelim`：读到的**字节数含分隔符 `\n`、不含结尾 `\0`**，`-1` 是 EOF 或错误，要 `feof`/`ferror` 分。`fread`/`fwrite`：**完整项数**，只有 `size==1` 才等于字节数，短计数可能既少一个完整项又混半个，要靠 `ferror`/`feof` 分。`fgetc`/`getchar`：返回 `unsigned char` 转成的 `int`，必须用 `int` 接——否则 `char` 为无符号时 `0xFF` 与 `EOF`(-1) 永远不相等，循环不终止。最易误判：`fscanf` 的 `0`（当错误会漏、当成功会死循环）与 `fread` 的短计数（当 EOF 会提前退出）。统一手段：读方向用 `ferror`（真=错误）和 `feof`（真=末尾）区分，不要只看返回值。

**判据**：五项单位全对；说出 `fscanf` 的 `0` 是匹配失败不是错误；说出 `fgetc` 用 `int` 的理由；`fread` 只有 `size=1` 才是字节；给出 `ferror`/`feof` 这一区分手段。

:::
:::

::: ex 例 2.4-A4 · `fork` 重复与 exec/exit/_exit {#ex-2.4-A4}

先猜：`fork` 前 `printf("record:")`（无换行）重定向到文件，父子都 `exit`，文件里是几个 `record:`？把 `printf` 改成带 `\n` 并且不重定向（接终端），还重复吗？

用「每个进程一份的写队列」这个心智模型，说出 `fork`、`exec`、`exit`、`_exit`、`fflush` 各对队列做什么；给出两处修复并说明为什么「子进程 `fork` 后又写了新数据」时不能只靠 `fflush`；说明测试为什么要重定向到文件。

::: sol 解答

文件里是 `record:record:`（本机复跑一致）：`"record:"` 无换行、目标非 tty → 全缓冲、没刷，`fork` 复制缓冲区，父子退出各刷一份。带 `\n` 且接终端时**看不出重复**——行缓冲下 `\n` 当场 flush，`fork` 前缓冲区已空，这也是「测试必须重定向」的原因。队列模型：`fork` 复制队列（父子各写各的）；`exec` 丢弃队列（替换地址空间，未 flush 的数据丢失，不替你刷）；`exit` 刷队列、`_exit` 不刷；`fflush` 是唯一能精确控制队列何时变 `write` 的操作。两处修复：① `fork` 前 `fflush(stdout)`；② 子进程用 `_exit`。为什么两处各解一半：`fflush` 清的是 `fork` 那一刻之前的缓冲，若子进程 `fork` 后又往 stdout 写了新数据，只有 `_exit`（或子进程再 `fflush`）才不让新数据重复——所以别指望「`fflush` 了就不用 `_exit`」。

**判据**：说出 `record:record:` 的成因（复制 + 各刷一次）；带 `\n` 接终端不重复并能解释；队列五动作全对；两处修复各自适用场景说清；知道 `exec` 丢数据要在其前 `fflush`。

:::
:::

::: ex 例 2.4-A5 · 内存流的时机与格式化截断 {#ex-2.4-A5}

先猜：`open_memstream` 之后立刻读 `len` 能拿到正确长度吗？`snprintf(small,8,"%s","0123456789")` 返回 8 还是别的数？返回负数才是截断吗？

说明 `open_memstream` 的 `*ptr`/`*sizeloc` 何时才有效、`fclose` 补的 `\0` 计不计长度、`fmemopen` 关闭会不会释放调用者的 `buf`；说明 `snprintf` 截断时返回什么、怎么判截断、`snprintf(NULL,0,...)` 用来干什么；说出 `asprintf` 的宏前提与失败时 `*strp` 的可信度。

::: sol 解答

`open_memstream` 的 `*ptr`/`*sizeloc` **只在 `fflush` 或 `fclose` 之后**才更新，之前 `buf` 可能是 `NULL`、`len` 是旧值（本机复跑：`fflush` 前 `buf=(nil) len=0`，`fflush` 后 `len=48`）。`fclose` 会补结尾 `\0` 但**不计入** `*sizeloc`；缓冲区由 libc 分配，调用者负责 `free(*ptr)`。`fmemopen` 关闭**不会** `free(buf)`，那块内存归调用者；`"w"` 不自动补终止符。`snprintf` 返回「若缓冲足够本应写入的字符数」（不含 `\0`），本机 `small[8]` 装 `"0123456789"` 返回 **10**、写进去 `0123456`（7+`\0`），判截断看 `ret >= size`；截断不是错误、返回负数只是编码错误。`snprintf(NULL,0,...)` 合法（C99），用来算所需长度（本机 `need=16`）。`asprintf` 成功返回字符数并 `malloc` 出字符串（要 `free`），失败返回 -1 且 `*strp` **未定义**；它是 GNU 扩展，`-std=c17` 不给 `_GNU_SOURCE` 时报隐式声明（本机复现）。

**判据**：`open_memstream` 在 flush 后读、`\0` 不计长度、`fmemopen` 不 free 三条到位；`snprintf` 返回 10、判据 `ret>=size`、负值≠截断三条到位；`snprintf(NULL,0)` 用途说对；`asprintf` 需 `_GNU_SOURCE` 且失败 `*strp` 不可读。

:::
:::

::: ex 例 2.4-A6 · locale、非阻塞与安全边界 {#ex-2.4-A6}

先猜：非阻塞流上 `fread` 返回 0 一定是 EOF 吗？`printf(user_input)` 比 `printf("%s",user_input)` 多犯了什么错？

解释 `setlocale(LC_ALL,"")` 后德语环境 `scanf("%f")` 读 `3.14` 会得到什么、为什么机器可读数据要钉 `"C"` locale；说明非阻塞 fd 包成流后 `fread` 如何报告「现在没数据」、为什么必须 `clearerr` 才能续读；说出 `%n` 为什么危险、`%s` 为什么要带宽度。

::: sol 解答

德语 `LC_NUMERIC` 用逗号作小数点，`scanf("%f")` 读 `3.14` 只匹配到 `3`，剩下 `.14` 留在流里让下一次解析错位；所以序列化（JSON/配置）要用 `"C"` locale，`setlocale` 又是进程级、多线程共享会竞争，线程独立 locale 用 `uselocale`/`newlocale`。非阻塞流：`fread` 内部 `read` 得 `-1/EAGAIN` 时，glibc 返回已读项数或 0、设**错误标志**（`ferror` 真、`feof` 假）、保留 `errno=EAGAIN`，这不是 EOF；不 `clearerr` 流一直报错，后续调用直接失败，所以要先 `clearerr(f)` 再等 epoll 可读重试。`%n` 把「已写字符数」写进一个 `int *`：当格式串来自用户输入时，`%n` 能写任意地址，是经典格式化字符串漏洞，可越权读写、崩溃——所以永远 `printf("%s",user)`，别 `printf(user)`。`%s` 不带宽度会一路读到 `\0` 写爆缓冲区，要用 `%.*s` 或 `%10s` 限宽。

**判据**：locale 两条后果（scanf 错位 + 序列化钉 C）到位；非阻塞「设错误标志不是 EOF、要 clearerr」说清；`%n` 归到格式化字符串漏洞且给 `printf("%s",user)` 修法；`%s` 限宽说出原因。

:::
:::

## B 组 · 诊断推理

::: ex 例 2.4-B1 · 程序崩了，日志最后一行没了 {#ex-2.4-B1}

先猜：`fprintf(logf,...)` 每条都返回正数，进程被 `kill -9` 后 `logf` 少了最后几行——是 `fprintf` 骗了你，还是别人没刷？

一段守护进程把日志 `fprintf` 到一个 `fopen("...","a")` 的 `FILE *`，崩溃（`SIGKILL` 或被 `_exit`）后最后几行没落盘。写出「现象 → 机制 → 证据 → 修法」四段。

::: sol 解答

现象：每条 `fprintf` 都返回正数（字符数），文件却少了末尾几条；崩溃方式越暴力丢得越多。机制：`fprintf` 只把数据写进用户态缓冲区，追加模式打开的是普通文件（非 tty）→ 全缓冲，`\n` 不触发 flush；`SIGKILL`/`_exit` 不跑 atexit、不 `_IO_cleanup`，缓冲区里没来得及 `write` 的数据随进程消失。证据：本机 `bufsize` 复跑直接演示——`fprintf(f,"line one\nline two\n")` 之后 `stat` 文件仍是 **0** 字节，`fflush` 后才变 **18**。修法分级：关键日志后立刻 `fflush(f)`（到内核，进 page cache）；要求断电也不丢再加 `fsync(fileno(f))`（到磁盘）；崩溃日志这类可直接 `_IONBF` 或绕过 stdio 用 `write`；`SIGTERM` 等可控信号里装 handler 做 `fflush`，但 `SIGKILL` 拦不住。

**判据**：定位到「数据在缓冲区、崩溃跳过 flush」而不是「`fprintf` 失败」；说出追加/非 tty → 全缓冲；证据是文件在 `fflush` 前后的大小差；修法区分 `fflush`（到内核）与 `fsync`（到磁盘），并承认 `SIGKILL` 不可恢复。

:::
:::

::: ex 例 2.4-B2 · 重定向后输出顺序变了 {#ex-2.4-B2}

先猜：同一个程序在终端看着对、`./app | cat` 或重定向到文件后顺序乱了，谁改了顺序？`write` 和 `printf` 谁先进内核？

有人为了「打点更快」在几个地方直接 `write(STDOUT_FILENO,...)`，其余用 `printf`。本地跑没事，管道/重定向里两段输出交错错了。写出四段分析。

::: sol 解答

现象：`printf("A"); write(STDOUT_FILENO,"B",1); printf("C");` 在终端看起来正常，重定向或进管道时变成 `BAC`。机制：`A`、`C` 进 stdout 的用户态缓冲区，非 tty 是全缓冲，退出时才 `write` 出 `AC`；`write` 的 `B` 当场直达内核。于是内核先收到 `B`，后收到 `AC`。证据：本机复跑 `strace -e trace=write` 得到 `write(1,"B",1)` 然后 `write(1,"AC",2)`，文件 `od -c` 是 `B A C`。修法只有两种：**只用一层**（全 stdio 或全 `write`），或在混用前 `fflush(stdout)` 把 `A` 先交给内核再 `write("B")`。读方向同理——`read(0,...)` 绕开 stdio 会把 stdio 预读副本丢掉，导致「少读一行」，混读混写要么统一层要么显式 `fflush`/`__fpurge`。

**判据**：说清 `BAC` 的两条路径（缓冲 vs 直达）；给出 `strace`/`od -c` 证据；修法给「统一一层」或「混用前 `fflush`」，不提议「把 sleep 加长」这类无效招；顺带点出读方向也有镜像问题。

:::
:::

::: ex 例 2.4-B3 · `fclose` 返回 EOF，之前 `fprintf` 都成功 {#ex-2.4-B3}

先猜：磁盘满时最后一次 `fprintf` 仍返回正数，是它没报错还是错误被推迟了？`fclose` 返回 EOF 时，缓冲区里的数据现在是写出去了还是丢了？

批量导出程序循环 `fprintf` 全成功，收尾 `fclose(f)` 返回 `EOF`。写出四段：错误真正发生在哪一步？为什么必须检查 `fclose`/`fflush` 的返回值？`fclose` 失败后 `f` 还能不能用？

::: sol 解答

现象：`fprintf` 一路返回正数，`fclose` 才给 `EOF`。机制：`fprintf` 只写缓冲区并返回字符数，真正的 `write`（可能是 `ENOSPC`、配额、NFS 提交失败）推迟到 flush；`fclose` 内部先 flush 再 close，错误在这里第一次能被你看到。所以「不查 `fclose` 返回值」等于丢掉最后一次写错误。证据：本机 `late_error` 写 `/dev/full` 复跑——`fprintf(f,"hello\n")` 返回 **6** 且 `errno=0`，直到 `fflush(f)` 才 `EOF`、`errno=28 (No space left on device)`。注意本机那次 `fclose` 反而返回 0：因为失败的 `fflush` 已把缓冲丢弃，`fclose` 再写就没东西可写、也就不再报错——这正说明「两个返回值都要看、别只信一个」。`fclose` 一旦调用（无论成败）流即失效，**不能再使用**；要判落盘是否成功，应在写完时主动 `fflush` 并查返回值，而不是等 `fclose`。

**判据**：定位到延迟错误（`fprintf` 进缓冲、`fclose`/`fflush` 才 `write`）；给出 `/dev/full` 的 6/0→EOF/28 证据；解释「`fclose` 返回 0 不代表写成功」这一实现相关细节；说出 `fclose` 后不可再用、应主动 `fflush` 检查。

:::
:::

::: ex 例 2.4-B4 · 读到一半死循环 / 提前退出 {#ex-2.4-B4}

先猜：`while (fscanf(f,"%d",&x) != EOF)` 遇到一个非数字字符为什么会卡死？`while (getline(...)!=-1)` 结束后 `ferror` 为真说明什么？

两个解析循环：① `fscanf` 循环读到 `abc` 就 CPU 100% 不退出；② `getline` 循环用 `-1` 判结束，但有一回其实中途读错了却当成正常读完。各写四段：机制、当场怎么证、正确写法。

::: sol 解答

① 机制：`fscanf` 返回 `0` 表示**匹配失败**（不是错误也不是 EOF），且**流的位置没有前进**——`%d` 撞上一个字母，字符留在原地，条件 `!=EOF` 成立，下次又读同一个字符，死循环。证据：本机 `scan_demo` 复跑，`"oops 7 ms"` 对 `"%d %d %7s"` 返回 **0**，`""`（空）才返回 EOF。正确写法：`while (fscanf(f,"%d",&x)==1)` 只在赋值成功时继续；返回 `0` 时要么消费掉当前字符（读一个字符丢掉）要么报错退出，别让流停在原地。② 机制：`getline` 返回 `-1` 既可能是 EOF 也可能是错误，只判 `-1` 会把错误当「正常读完」。证据/做法：循环结束后先 `ferror(f)`（真=读错误，要处理），`feof(f)`（真=到末尾）区分——正文 `linecount.c` 正是这么写的（本机复跑 `lines=3 longest=4`）。

**判据**：①说出「`0` 是匹配失败、流不前进 → 原地死循环」并给 `==1` 或消费字符的修法；能区分 EOF 与 `0`；②说出 `-1` 的两种含义并给 `ferror`/`feof` 的收尾判据；至少引用一处本机读数。

:::
:::

::: ex 例 2.4-B5 · `setvbuf` 之后程序莫名其妙崩 {#ex-2.4-B5}

先猜：`setvbuf(f, buf, _IOFBF, sizeof buf)` 里 `buf` 是个函数内局部数组、函数返回后继续用 `f`，会立刻崩还是过一会儿崩？`setvbuf(f, NULL, _IOFBF, 1<<20)` 真拿到 1 MiB 缓冲吗？

有人为了「指定缓冲大小」写了一个返回 `FILE *` 的工厂函数，`buf` 用栈数组，`fopen` 后 `setvbuf`、函数返回，调用方接着往 `f` 写，跑一会儿踩坏别的栈。写出四段分析，并说清 `setvbuf` 该在什么时候调、`size` 什么时候才生效。

::: sol 解答

现象：不立刻崩，用了一会儿才崩或行为错乱——典型的悬空指针被复用。机制：`setvbuf` 让流拿你的 `buf` 当缓冲区，但 `buf` 是栈数组、函数一返回栈帧回收，缓冲区内存失效；后续 stdio 写入往这块已失效内存里搬数据，踩坏别的栈，未定义行为，崩不崩、何时崩全看运气。证据/判据：把 `buf` 改成 `malloc` 或静态数组后崩溃消失。规则两条：① `setvbuf` 必须在**任何 I/O 之前**调用，否则行为未定义、glibc 可能忽略；② `buf==NULL` 时 **glibc 忽略 `size`**，`setvbuf(f,NULL,_IOFBF,1<<20)` 只是请求全缓冲，得不到 1 MiB；要精确大小必须自己传一块**生命周期覆盖整条流**的 `buf`。对照：`setbuf(f,NULL)` 是**无缓冲**，不是「让 libc 分配」，这一点最容易记反。

**判据**：定位到「缓冲区生命周期不足 → 悬空」而非「缓冲太大撑爆内存」；说出 `setvbuf` 要早于首次 I/O；说出 `buf==NULL` 时 glibc 忽略 `size`、要控大小就自传 `buf`；点出 `setbuf(f,NULL)` 是无缓冲。

:::
:::

::: ex 例 2.4-B6 · fork 出 worker 后每行打两遍 + 非阻塞读一直返回 0 {#ex-2.4-B6}

先猜：`fork` 出 worker、父进程紧接着 `printf` 若干进度行，`> file` 里每行都在——是 worker 也在打，还是缓冲区被复制？把 `O_NONBLOCK` 的 fd `fdopen` 成流，`fread` 一直返回 0 但 `feof` 为假，缺了哪一步？

两种现象各写四段：① `fork` 之后父子都往继承来的 stdout 写、重定向到文件出现成对重复行；② 非阻塞管道上 `fread` 返回 0、`ferror` 真、`errno=EAGAIN`，程序以为「结束了」不再读。

::: sol 解答

① 机制：`fork` 复制 stdio 缓冲区，父子退出各刷一份；更隐蔽的是 `fork` **之后**父进程新写的进度行，也进了「被复制过队列」语义下的两份缓冲（worker 若也 `exit` 会刷它继承+新增的）。证据/修法：`fork` 前 `fflush(stdout)`，子进程用 `_exit` 不刷继承缓冲；本机 `fork_dup` 复跑 `record:record:`，`fork_dup fix` 得 `record:`。别只留一处又指望另一处兜底。② 机制：非阻塞流上 `fread` 用「设错误标志 + 保留 `errno=EAGAIN`」报告「现在没数据」，这**不是 EOF**（`feof` 假）；不 `clearerr` 流一直错误，后续调用直接返回失败 → 看着像「读完了其实是卡住了」。证据：本机 `stdio_err` 复跑首行 `n=0 ferror=1 feof=0 errno=11`。修法：`if (n==0 && ferror(f) && errno==EAGAIN) { clearerr(f); 等 epoll 可读再试; }`。写方向对称：`fwrite` 可能只进缓冲返回成功，真正的 `EAGAIN` 要到 `fflush` 返回 `EOF` 才出现——事件驱动服务因此通常绕开 stdio，直接用 `read`/`write`。

**判据**：①归到缓冲区复制并给两处修复；②说出「`ferror` 真、`feof` 假、`errno=EAGAIN` 不是 EOF」、要 `clearerr` 重试；写出/读两个方向都给证据；点出「事件循环用裸 `read`/`write`」这一实践结论。

:::
:::

## C 组 · 动手实验

::: ex 例 2.4-C1 · 用文件大小证明缓冲：`bufsize` {#ex-2.4-C1}

先猜：`fprintf` 之后 `stat` 这个文件是多少字节？`fflush` 之后呢？正文注释说两行是「20 字节」，对吗？

编译运行 2.4.2 的 `bufsize.c`，记录四个时刻（写入前、`fprintf` 后、`fflush` 后、`fclose` 后）的文件大小；再手工数 `"line one\nline two\n"` 到底几字节，与正文注释对照。

::: sol 核对

```bash
mkdir -p /tmp/lab2c04_work && cd /tmp/lab2c04_work
# 抄入正文 2.4.2 的 bufsize.c，命名 lab2c04_bufsize.c
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 lab2c04_bufsize.c -o lab2c04_bufsize
timeout 10 ./lab2c04_bufsize
printf 'line one\nline two\n' | wc -c      # 手工数实际字节
```

本机 aarch64 复跑读数：四行是 `写入前 size=0`、`fprintf 之后、fflush 之前 size=0`、`fflush 之后 size=18`、`fclose 之后 size=18`。`wc -c` 给 **18**：`line one`(8)+`\n`(1)+`line two`(8)+`\n`(1)=18。**`fprintf` 之后仍是 0 字节，是缓冲存在最直接的证据**。注意与正文的差异：正文注释与解释都写「两行共 20 字节」、`fflush 之后 size=20`，本机实测是 **18**，正文明显把字节数算错了（见[勘误页](ch04-errata.md)复跑校正）。`buf_demo.txt` 由程序自己 `unlink`，不留残档。

**判据**：`fprintf` 后大小 0、`fflush` 后变非零这一对比被观察到；自己数出 18 字节并指出正文「20」是笔误；能说「0 字节 ≠ 没写，是还在缓冲区」。无需 `sudo`；实验产物用 `lab2c04_` 前缀，保留不删。

:::
:::

::: ex 例 2.4-C2 · 复现并修复 fork 重复输出：`fork_dup` {#ex-2.4-C2}

先猜：不重定向、直接跑（接的是 ssh 管道），会重复吗？重定向到文件呢？`fix` 参数版呢？

编译 2.4.5 的 `fork_dup.c`，分别跑「重定向到文件」与「重定向 + `fix`」两种；再故意在**接终端的伪终端**里跑一次看 `\n` 触发行缓冲会不会掩盖重复。

::: sol 核对

```bash
cd /tmp/lab2c04_work
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 lab2c04_fork_dup.c -o lab2c04_fork_dup
timeout 10 ./lab2c04_fork_dup     > /tmp/lab2c04_out.txt;  echo "raw=$(cat /tmp/lab2c04_out.txt)"
timeout 10 ./lab2c04_fork_dup fix > /tmp/lab2c04_out2.txt; echo "fix=$(cat /tmp/lab2c04_out2.txt)"
# 伪终端下（isatty 为真 → 行缓冲），record: 无换行仍留在缓冲，退出时父子各刷：
timeout 10 script -qec './lab2c04_fork_dup' /dev/null > /tmp/lab2c04_pt.txt 2>&1; echo "pty=$(tr -d '\r' </tmp/lab2c04_pt.txt)"
```

本机复跑读数：`raw=record:record:`（重定向到文件、全缓冲、缓冲区被复制、父子各刷一份），`fix=record:`（`fork` 前 `fflush` + 子进程 `_exit`，两处修复都在）。这正是正文 2.4.5 演示的两行输出。伪终端那次仍得 `record:record:`——因为 `printf("record:")` 没有 `\n`，行缓冲也没被触发，`fork` 前缓冲区仍是脏的；**要制造「`\n` 掩盖重复」的对照，得把 `record:` 改成带 `\n`**：那时接终端会当场刷、不重复，重定向到文件（全缓冲）仍可能重复，这就是正文 2.4.5 errata 第 1 条「测试必须重定向」的含义。

**判据**：复现 `record:record:` 与 `fix` 版 `record:`；说清「无 `\n` 时行缓冲也不触发，所以伪终端也重复」；能设计「改成带 `\n` 再接终端 vs 再重定向」这组对照来验证行缓冲/全缓冲差；解释两处修复各挡住哪一份。

:::
:::

::: ex 例 2.4-C3 · 三种模式下的写入时机：`bufmodes` {#ex-2.4-C3}

先猜：`fprintf(f,"abc")`（无换行）在 `_IONBF`/`_IOLBF`/`_IOFBF` 下，`fflush` 前文件各是多少字节？把 `"abc"` 改成 `"abc\n"` 后，`_IOLBF` 那一行会变吗？

跑 2.4.7 的 `bufmodes.c`，记录三种模式 `fflush` 前后大小与首行 `BUFSIZ`/`PAGE`；再用一个改过的版本把 `fprintf(f,"abc")` 换成 `"abc\n"`，只看 `_IOLBF`。

::: sol 核对

```bash
cd /tmp/lab2c04_work
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 lab2c04_bufmodes.c -o lab2c04_bufmodes
timeout 10 ./lab2c04_bufmodes
```

本机复跑读数：首行 `BUFSIZ=8192 PAGE=4096`；`IONBF before/after = 3/3`（每次 stdio 调用直接 `write`，`abc` 立即落盘，`fflush` 前后都 3）；`IOLBF before/after = 0/3`（`abc` 无换行 → 还在缓冲 → 0，`fflush` 后才 3）；`IOFBF before/after = 0/3`（同理全缓冲）。把 `"abc"` 改成 `"abc\n"`（4 字节含换行）单独跑 `_IOLBF`：本机复跑得 `before fflush size=4`、`after fflush size=4` —— 换行触发 `_IOLBF` 当场写出，`fflush` 前就是 4。这印证正文那句「改成 `abc\n`，`IOLBF` 的前一行会变成 4」。顺带读出 `BUFSIZ`(8192) 只是兜底常量、页是 4096，实际缓冲区取 `st_blksize`（见[勘误页](ch04-errata.md)）。

**判据**：三组 `0/3`、`3/3`、`0/3` 与预期一致；`_IONBF` 「立即写」与 `_IOLBF`/`_IOFBF`「`abc` 时不写」的区别被观察到；把无换行换成有换行后 `_IOLBF` 变 4 的对照被复现；不把 `BUFSIZ` 当成实际缓冲区大小。

:::
:::

::: ex 例 2.4-C4 · `strace` + `stdbuf` + 伪终端看缓冲：`tick` {#ex-2.4-C4}

先猜：通过 ssh 跑 `strace -e trace=write ./tick`（不重定向），会看到几次 `write`？正文说「终端每行一次」，在这台机器、这条 ssh 通道上成立吗？

跑 2.4.15 的 `tick.c`，用 `strace` 分别看「直接跑（ssh 管道）」「重定向到文件」「`stdbuf -oL`」「`stdbuf -o0`」「`script` 伪终端」五种情形的 `write(1,...)` 行。

::: sol 核对

```bash
cd /tmp/lab2c04_work
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 lab2c04_tick.c -o lab2c04_tick
echo "--- 直接跑（stdout 是 ssh 管道，非 tty）---"; strace -e trace=write ./lab2c04_tick 2>&1 >/dev/null | grep 'write(1'
echo "--- 重定向到文件 ---"; strace -e trace=write ./lab2c04_tick >/tmp/lab2c04_tick.out 2>/tmp/lab2c04_tick.strace; grep 'write(1' /tmp/lab2c04_tick.strace
echo "--- stdbuf -oL ---"; strace -e trace=write stdbuf -oL ./lab2c04_tick 2>&1 >/dev/null | grep 'write(1'
echo "--- stdbuf -o0 ---"; strace -e trace=write stdbuf -o0 ./lab2c04_tick 2>&1 >/dev/null | grep 'write(1'
echo "--- script 伪终端 ---"; strace -e trace=write script -qec './lab2c04_tick' /dev/null >/dev/null 2>&1 | grep 'write(1' | head -3
```

本机复跑读数：① **直接跑（ssh 管道）= 全缓冲，一次** `write(1,"tick 0\ntick 1\ntick 2\n",21)`；② 重定向到文件 = 同样一次 21 字节；③ `stdbuf -oL` = 三行各 `write(1,"tick N\n",7)`；④ `stdbuf -o0` = 三行各 `write(1,"tick N\n",7)`；⑤ `script` 伪终端下（这里 trace 的是 `script` 转发的写）出现三次 `write(1,"tick N\r\n",8)`——多了 `\r` 是 tty 的 ONLCR 把 `\n` 转成 `\r\n`。**关键差异**：正文 2.4.15 说「`strace -e trace=write ./tick`（终端）每行一次」，但本书的测试是通过 ssh 非交互执行，stdout 接的是管道不是终端，`isatty` 为假 → 全缓冲 → 一次写 21 字节，正文那三种「每行一次」在这里**不靠 `stdbuf` 就复现不出来**（见[勘误页](ch04-errata.md)复跑校正）。要「每行一次」：动态链接程序用 `stdbuf -oL`（本机各得 3×7 字节），要看真终端形态用 `script`（此时字节带 `\r`）。

**判据**：观察到「ssh 管道下直接跑 = 一次 21 字节」而非三次，并解释是 `isatty` 为假导致全缓冲；`stdbuf -oL`/`-o0` 各得三次 `write(1,"tick N\n",7)`；能说出 `stdbuf` 只对三个标准流、`LD_PRELOAD`、对静态链接或已 `setvbuf` 的流无效；点出伪终端多出 `\r` 是 ONLCR 转换，不是 stdio 行为。

:::
:::

::: ex 例 2.4-C5 · 截断检测与 `asprintf`：`snprintf_demo` {#ex-2.4-C5}

先猜：正文给的编译命令 `-Wall -Wextra -Werror -O2` 能让 `snprintf_demo.c` 一次编过吗？`snprintf` 返回的 10 是「写了 10 个字节进缓冲」还是别的？

按正文命令编 `snprintf_demo.c`，记录报错；改用可行命令编出来后运行，记录 `snprintf`/`asprintf`/`need` 三行；再用 `-std=c17`（不给 `_GNU_SOURCE`）单编一个只调 `asprintf` 的小程序看编译期反应。

::: sol 核对

```bash
cd /tmp/lab2c04_work
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 lab2c04_snprintf_demo.c -o lab2c04_snprintf_demo   # 预期：失败
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -Wno-format-truncation -O2 lab2c04_snprintf_demo.c -o lab2c04_snprintf_demo && timeout 10 ./lab2c04_snprintf_demo
cat > /tmp/lab2c04_asp.c <<'EOF'
#include <stdio.h>
#include <stdlib.h>
int main(void){char *s=NULL;int r=asprintf(&s,"%s-%d","x",1);printf("%d %s\n",r,s);free(s);return 0;}
EOF
cc -std=c17 -Wall -Wextra -fsyntax-only /tmp/lab2c04_asp.c        # 不给 _GNU_SOURCE
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 /tmp/lab2c04_asp.c -o /tmp/lab2c04_asp && timeout 10 /tmp/lab2c04_asp
```

本机复跑读数：正文那条命令**编译失败**——`-Werror=format-truncation` 把「故意把 10 字节截进 `small[8]`」判成错误：`error: '%s' directive output truncated writing 10 bytes into a region of size 8`（见[勘误页](ch04-errata.md)复跑校正，这是正文命令的一个坑，不是代码逻辑错）。加 `-Wno-format-truncation` 后运行得：`snprintf ret=10 size=8 truncated=1 buf=0123456`、`asprintf ret=14 str=build-42-linux`、`safe: %s%s%n`、`need=16`。`ret=10` 是「**本应**写入的字符数」，实际只写 7 个加 `\0`，`truncated=1` 才是截断信号。不给 `_GNU_SOURCE` 那条报 `implicit declaration of function 'asprintf'`（证明 `asprintf` 是 GNU 扩展），给 `_GNU_SOURCE` 后编过并打印 `3 x-1`。

**判据**：如实记录正文命令因 `-Wformat-truncation` 编不过、并给出 `-Wno-format-truncation` 的可行命令；读出 `ret=10` 是「本应长度」不是「写入字节」且 `truncated=1`；`asprintf ret=14`、`need=16` 对上；复现「无 `_GNU_SOURCE` → `asprintf` 隐式声明」，据此拒绝正文「GNU/POSIX.1-2008 扩展」的宽松标注。

:::
:::

::: ex 例 2.4-C6 · 内存流与延迟错误：`memstream` + `late_error` {#ex-2.4-C6}

先猜：`open_memstream` 后、`fflush` 前读 `len` 会是多少？`/dev/full` 上 `fprintf` 会失败吗，还是到 `fflush` 才失败？

编译运行 2.4.9 的 `memstream.c` 与 2.4.3 的 `late_error.c`；重点核对 `memstream` 三行的 `buf`/`len` 时机，与 `late_error` 的 `fprintf`/`fflush`/`fclose` 三个返回值与 `errno`。

::: sol 核对

```bash
cd /tmp/lab2c04_work
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 lab2c04_memstream.c -o lab2c04_memstream
timeout 10 ./lab2c04_memstream
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 lab2c04_late_error.c -o lab2c04_late_error
timeout 10 ./lab2c04_late_error
```

`memstream` 本机复跑读数：`before fflush: buf=(nil) len=0`（**`fflush` 前 `*ptr` 是 NULL、长度是 0**）、`after fflush: len=48`（三条 `line-N: value=M\n` 共 48 字节）、`after fclose: len=48` 加内容、`parsed[0..2] n=16`（`fmemopen` 把同一块内存包成输入流，`getline` 每行 `n=16` 含 `\n`）。`late_error` 本机复跑读数：`fprintf 返回 6，errno=0`（`hello\n` 六个字符只进缓冲，`/dev/full` 的错误还没发生）、`fflush errno=28 (No space left on device), fclose errno=0 (Success)`——`ENOSPC` 第一次出现在 `fflush`；`fclose` 返回 0 是因为失败的 `fflush` 已把缓冲丢弃，`fclose` 无数据可写也就无错，正文那句「两个返回值都要看」由此得到印证。

**判据**：`memstream` 「`fflush` 前 `len=0`/`buf=(nil)`、`fflush` 后 `len=48`」被观察到，并据此拒绝「立刻读 `len`」；`late_error` 三个返回/错误值 `6+errno0` → `EOF/28` → `0` 全部对上；能用「错误延迟到 flush」解释 `fprintf` 成功、`fclose` 反而不报错这一实现相关细节。无需 `sudo`。

:::
:::
