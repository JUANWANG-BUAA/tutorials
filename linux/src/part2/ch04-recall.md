# 2.4 闭卷回忆卡

这一页是检索练习，不是摘要。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。21 张卡分三组：**A 组考缓冲层、三种模式与 flush（2.4.1–2.4.3）**，**B 组考返回值、`fork`、跨层接口与缓冲大小（2.4.4–2.4.8）**，**C 组考内存流、行读、格式化、locale、非阻塞与取证（2.4.9–2.4.17）**。建议学完当天、隔天、第 3 天、第 7 天各做一次，只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 缓冲层、三种模式与 flush

::: method 回忆 1 · `FILE` 里装了什么
不看正文说出 `FILE`（glibc 的 `struct _IO_FILE`）至少四样东西。`printf` 一次调用动了什么、没动什么？
::: sol 答案
一个 fd（`_fileno`）、一组标志（读写/追加/EOF/错误）、读缓冲区与写缓冲区（`_IO_read_*`/`_IO_write_base/ptr/end`）、一把保护这个流的锁。`printf` 只把格式化后的字符拷进写缓冲区、移动 `_IO_write_ptr`，**不执行任何系统调用**。`stdin`/`stdout`/`stderr` 是三个预打开的 `FILE *`，包着 fd 0/1/2，`printf(...)` 等价于 `fprintf(stdout,...)`。
:::
:::

::: method 回忆 2 · 把缓冲区交给内核的时刻
数据从用户态缓冲区进入内核，有哪四种时刻？为什么「`printf` 之后立刻 `kill -9`」会丢数据？
::: sol 答案
① 缓冲区满；② 显式 `fflush`；③ `fclose`（先 flush 再 close）；④ 进程正常 `exit`（glibc 的 `__run_exit_handlers`→`_IO_cleanup` 刷所有流）。`kill -9` 是 `SIGKILL`，不经处理器、不跑 `atexit`、不刷 stdio，缓冲区里还没 `write` 的数据随地址空间一起消失——所以「最后一行没了」。
:::
:::

::: method 回忆 3 · 三种缓冲模式与默认规则
全/行/无缓冲各在什么时候 `write`？glibc 的三条默认规则是什么？判断依据是哪个调用？
::: sol 答案
全缓冲 `_IOFBF`：满/`fflush`/`fclose`/`exit` 才写。行缓冲 `_IOLBF`：遇到 `\n`、满、`fflush` 等写。无缓冲 `_IONBF`：每次 stdio 调用直接写。默认规则：`stderr` 无缓冲（C 只要求「非全缓冲」，glibc 取无缓冲）；连终端的流行缓冲；其余全缓冲。依据是 `isatty(fileno(stream))`。
:::
:::

::: method 回忆 4 · 同一句 printf 为何终端立刻、文件要等退出
`printf("hello\n")` 在终端马上出现、`./app > out.txt` 要等程序结束才进文件。是内核变慢了吗？缓冲模式何时被定下来？
::: sol 答案
不是内核慢，是 stdio 从行缓冲切成了全缓冲：终端上 `\n` 触发 flush，重定向到文件（非 tty）后 `\n` 不再触发，数据等缓冲满或 `exit` 才写。关键点：模式在**首次 I/O 时**按当时 fd 指向的设备决定并固化进 `FILE`，之后再 `dup2` 改 fd 的去处也不会改回行缓冲——这正是 [2.3] 反复要求「先 `fflush` 再 `dup2`/`fork`」的根因。
:::
:::

::: method 回忆 5 · `setvbuf` 的时机与四条坑
`setvbuf` 相对首次 I/O 必须什么时候调？返回什么？「`buf` 用局部数组」「`setbuf(f,NULL)` 和 `setvbuf(...,NULL,_IOFBF,0)` 一样」这两条为什么错？
::: sol 答案
必须在**任何 I/O 之前**调用，成功返回 0、失败返回非 0（POSIX 允许它总成功）。`buf==NULL` 由 libc 分配、`size==0` 用默认值。两条坑：① `buf` 的内存必须活到流关闭，传栈数组函数返回后悬空，后续写踩坏内存；② `setbuf(f,NULL)` 是**无缓冲**，而 `setvbuf(f,NULL,_IOFBF,0)` 是让 libc 分配**全缓冲**，同名参数 `NULL` 含义随函数变。还有 `fflush` 只到内核，落盘要 `fsync`。
:::
:::

::: method 回忆 6 · `fflush`、`fclose` 与延迟错误
`fflush(NULL)` 刷哪些流？对输入流 `fflush` 是什么行为？为什么磁盘满时 `fprintf` 成功了、错误到 `fclose` 才出现？
::: sol 答案
`fflush(NULL)` 刷新**所有输出流**（以及有未写数据的流）。对输入流调 `fflush` 在 C 标准是未定义，POSIX 允许对可寻址输入流用它丢弃缓冲，但别依赖。延迟错误：`fprintf` 只把数据写进缓冲区就返回字符数，真正的 `write`（可能 `ENOSPC`/配额满）推迟到 flush；`fclose` 先 flush，错误在这里才冒出来，所以**必须查 `fclose` 返回值**，忽略它等于丢掉最后一次写错误。
:::
:::

::: method 回忆 7 · 与 `write` 混用的后果
`printf("A"); write(1,"B",1); printf("C");` 到程序退出，内核看到的顺序是什么？输入方向混用 `read` 会怎样？
::: sol 答案
内核看到 `B` 先、`AC` 后（`BAC`）：`A` 留在 stdout 缓冲区，`write` 的 `B` 直达内核，`C` 也进缓冲，退出时缓冲区一次性把 `AC` 刷出。本机 `strace` 复跑：`write(1,"B",1)` 然后 `write(1,"AC",2)`。读方向同理：`read` 绕过 stdio 把字节拿走，而 stdio 上次预读的副本还在缓冲里，`fgets` 从副本继续 → 逻辑上重复/跳行。修法只有两种：混用前 `fflush(stdout)`，或只用一层。
:::
:::

## B. 返回值、fork、跨层与缓冲大小

::: method 回忆 8 · 五类返回值各数什么
`fprintf`、`fscanf`、`getline`、`fread`/`fwrite`、`fgetc` 的成功返回值分别是什么单位？哪个的 `0`/`-1` 最容易误判？
::: sol 答案
`fprintf` 写出的**字符数**（可能还在缓冲，不等于写进 fd 的字节）；`fscanf` 成功**赋值的项数**，`EOF` 是首个转换前失败、`0` 是匹配失败（不是错误）；`getline` 读到的**字节数含 `\n`**，`-1` 要 `feof`/`ferror` 区分；`fread`/`fwrite` 返回**完整项数**，只有 `size==1` 才等于字节数；`fgetc` 返回 `unsigned char` 转成的 `int`，必须用 `int` 接否则 `EOF` 与 `0xFF` 分不开。最易误判：`fscanf` 的 `0`（当成错误会漏，当成成功会死循环）。
:::
:::

::: method 回忆 9 · `fscanf` 的 0 与 EOF
`sscanf("oops 7 ms","%d %d %7s",...)` 返回什么？为什么返回 `0` 时直接重试会死循环？`%7s` 的宽度能省吗？
::: sol 答案
返回 `0`：第一个 `%d` 就遇到非整数 `oops`，一个都没赋值。`0` 是「格式不匹配」，**流的位置没有前进**，若不消费掉当前字符就重试会原地死循环。空输入返回 `EOF`（首个转换前就没内容）。`%7s` 的宽度不能省——无宽度的 `%s` 会一直读到 `\0` 写爆缓冲区。循环正确写法 `while (fscanf(f,"%d",&x)==1)`，`0` 时要吃掉当前字符再继续。本机 `scan_demo` 三行输出：rc=3 / rc=0 / rc=EOF。
:::
:::

::: method 回忆 10 · `fread` 的「项数」语义
`fread(buf,sizeof(rec),100,f)` 返回 37，一定是读了 37 条完整记录吗？变长数据该怎么办？短计数怎么区分错误与 EOF？
::: sol 答案
不一定。返回值是**完整项数**，可能读了 37 个完整项外加半个第 38 项（半个项按实现留在流里或被丢弃）。短计数既可能是 EOF 也可能是错误，要用 `ferror(f)`（真=错误）和 `feof(f)`（真=到末尾）区分，不能只看返回值。变长数据改用 `size=1` 自己按长度解析，`size=1` 时返回值才等于字节数。
:::
:::

::: method 回忆 11 · `fork` 为什么会重复输出
`fork` 复制了缓冲区里的什么？父进程 `fork` 前 `printf("record:")` 无换行、重定向到文件、父子都 `exit`，输出是什么？两处修复任选其一即可，是哪两处？
::: sol 答案
`fork` 复制整个用户地址空间，**包括 stdio 缓冲区**。`"record:"` 无换行且目标是非 tty（全缓冲），`fork` 前没刷，父子各留一份，两者退出各刷一次 → 文件里 `record:record:`（本机复跑一致）。修复：① `fork` 前 `fflush(stdout)`；② 子进程用 `_exit` 不刷继承来的缓冲。注意：若子进程 `fork` 后又写了新数据，只 `fflush` 不 `_exit` 仍可能把新数据重复，所以两处各解一半、别只留一处又期望另一处兜底。测试必须重定向到文件，终端行缓冲下 `\n` 会先刷，看不出重复。
:::
:::

::: method 回忆 12 · exec / exit / _exit 对缓冲区各做什么
把 stdio 想成「每个进程一份的写队列」，`fork`、`exec`、`exit`、`_exit`、`fflush` 分别对这个队列做什么？`fork` 后 `exec` 前该做什么？
::: sol 答案
`fork` 复制队列（父子各写各的）；`exec` **丢弃**队列（替换地址空间，未 flush 的数据丢失，不会替你刷）；`exit` 刷队列（跑 atexit + `_IO_cleanup`）；`_exit` 不刷；`fflush` 是唯一能精确控制队列何时变成 `write` 的操作。所以 `fork` 后 `exec` 前必须 `fflush`，否则父进程刚 `printf` 还没刷的数据会被 `exec` 抹掉。
:::
:::

::: method 回忆 13 · fileno / fdopen / freopen
`fdopen(fd,mode)` 会不会复制 fd？要保留原 fd 怎么办？`"a"` 模式会不会改内核的 `O_APPEND`？`freopen` 失败后原来的 `stdout` 还能用吗？
::: sol 答案
`fdopen` **不复制** fd，流关闭时底层 fd 一起关闭；要保留原 fd 就先 `dup` 再 `fdopen(dup(fd),...)`。`fdopen` 的 `mode` 必须与 fd 打开方式兼容（只读 fd 不能 `"w"`），`"a"` 只是 stdio 层的写位置策略，不改内核 `O_APPEND`。`freopen(path,mode,f)` 会先关闭 `f` 再重开；失败时 `f`（如 `stdout`）**已经关闭**，不要再用它。
:::
:::

::: method 回忆 14 · 线程下 stdio 的锁
单条 `fprintf` 在 glibc 里线程安全吗？要让两行「原子地一起出现」怎么办？已经持锁时用什么省重复加锁？`feof`/`ferror` 什么时候才有意义？
::: sol 答案
POSIX 要求同一 `FILE` 的 stdio 函数线程安全，glibc 在每条 `fprintf`/`fgets` 内部加锁，所以单条调用不会撕裂。但两条独立 `fprintf` 之间可能被别的线程插进来，要用 `flockfile(f)` … `funlockfile(f)` 把这一段包住。已持锁时用 `putc_unlocked`/`getc_unlocked` 省重复加锁，但它们**单独用（不先 `flockfile`）不安全**。`feof`/`ferror` 只在上一次读操作之后才有意义，读到 EOF 后 `feof` 才为真，`clearerr` 清 EOF 与错误标志。
:::
:::

::: method 回忆 15 · 缓冲区大小从哪来
`fopen` 后那块缓冲区多大？`BUFSIZ` 和它是一回事吗？`setvbuf(f,NULL,_IOFBF,1<<20)` 能得到 1 MiB 缓冲吗？
::: sol 答案
全缓冲时大小取 `fstat` 的 `st_blksize`（本机常见 4096），取不到才退回 `BUFSIZ`（glibc 定义为 8192）。所以「缓冲区一定是 4096/8192」都错：`st_blksize` 是这个文件系统的最优 I/O 块，随文件系统变。`BUFSIZ` 只是兜底常量，不等于实际缓冲区。`setvbuf(f,NULL,...,size)` 里 `buf==NULL` 时 **glibc 会忽略 `size`**，要精确指定大小必须自己传一块 `buf`（生命周期覆盖整条流）。
:::
:::

::: method 回忆 16 · setvbuf 家族谁等价于谁
`setbuf`、`setbuffer`、`setlinebuf` 分别等价于哪句 `setvbuf`？`setbuf` 为什么不能用来报错？
::: sol 答案
`setbuf(f,buf)`：`buf` 非空等价 `_IOFBF`+`BUFSIZ`，`buf` 为空等价 `_IONBF`；返回 `void`，无法报错。`setbuffer(f,buf,size)`：GNU/BSD 扩展，等价 `_IOFBF`/`_IONBF` 并按 `size`，仍要求缓冲区活到关流。`setlinebuf(f)`：GNU/BSD 扩展，等价 `setvbuf(f,NULL,_IOLBF,0)`，是「改成行缓冲」最短写法，但行缓冲只保证 `\n` 时 `write`，不保证落盘（落盘仍要 `fsync`）。
:::
:::

## C. 内存流、行读、格式化、locale、非阻塞与取证

::: method 回忆 17 · 两个内存流的规矩
`open_memstream` 的 `*ptr`/`*sizeloc` 什么时候才有意义？`fclose` 补的 `\0` 计不计入长度？`fmemopen` 关闭时会 `free(buf)` 吗？`"a"` 模式追加到哪里？
::: sol 答案
`open_memstream` 的 `*ptr`/`*sizeloc` **只在 `fflush` 或 `fclose` 之后**才更新，`fflush` 前 `*ptr` 可能是 `NULL`、`len` 是旧值（本机复跑：`fflush` 前 `buf=(nil) len=0`，`fflush` 后 `len=48`）。`fclose` 会在末尾补 `\0`，但 `*sizeloc` **不计**它；缓冲区由 libc 分配，调用者 `free(*ptr)`。`fmemopen` 关闭**不会** `free(buf)`，缓冲区归调用者；`"a"` 的追加位置是 `buf` 里第一个 `\0`（不是 `size` 末尾），`"w"` 不自动补终止符。
:::
:::

::: method 回忆 18 · getline 与 fgets 的边界
`fgets(buf,size,f)` 遇到超长行会怎样？`getline` 的返回值含不含 `\n`、含不含结尾 `\0`？为什么读二进制记录不该用 `getline`？
::: sol 答案
`fgets` 最多读 `size-1` 字节、遇 `\n` 停、总补 `\0`；一行超过 `size-1` 时剩下部分留在流里，下一次 `fgets` 继续 → 「读长行得到多条记录」。`getline` 返回读到的字节数，**含分隔符 `\n`、不含结尾 `\0`**（`"abc\n"` 返回 4），无行长限制但可能反复 `realloc`；`lineptr` 要用 `malloc` 的指针或 `NULL`，不能是栈数组。读二进制别用 `getline`：它遇 `\0` 不停、按分隔符读，长度语义与「字符串」不同易算错，用 `fread` 定长读并处理短读。
:::
:::

::: method 回忆 19 · snprintf 截断返回什么
`snprintf(small,8,"%s","0123456789")` 返回几、`small` 里是什么、怎么判截断？`snprintf(NULL,0,...)` 合法吗？`asprintf` 失败时 `*strp` 可信吗？
::: sol 答案
返回 **10**（本应写入的字符数，不含 `\0`），`small` 里是截断后的 `0123456`（7 字符加 `\0`），判截断看 `ret >= size`（本机 `ret=10 size=8 truncated=1`）。截断不是错误、不设 `errno`，只有编码错误才返回负值。`snprintf(NULL,0,...)` 合法（C99），用来算所需长度（本机 `need=16`）。`asprintf` 成功返回字符数并 `malloc` 出 `*strp`（要 `free`），**失败返回 -1 且 `*strp` 未定义**，失败后别读它；`asprintf` 是 GNU 扩展，`-std=c17` 不给 `_GNU_SOURCE` 会报隐式声明。别把用户输入当格式串（`printf(user)` 遇 `%n` 可写任意地址）。
:::
:::

::: method 回忆 20 · locale 与非阻塞流
`setlocale(LC_ALL,"")` 后 `scanf("%f")` 读 `3.14` 在德语环境可能得到什么？序列化为什么钉 `"C"` locale？把 `O_NONBLOCK` 的 fd 包成流后 `fread` 返回 0 是 EOF 吗？怎么续读？
::: sol 答案
德语 `LC_NUMERIC` 用逗号作小数点，`scanf("%f")` 读 `3.14` 只匹配到 `3`，剩下 `.14` 留在流里让后续解析错位。机器可读数据（JSON/配置）要用 `"C"` locale，`setlocale` 是进程级、多线程会竞争，线程独立用 `uselocale`/`newlocale`。非阻塞流上 `fread` 返回 0 **不是 EOF**：glibc 设**错误标志**（`ferror` 真、`feof` 假）、保留 `errno=EAGAIN`；要续读必须先 `clearerr(f)` 否则流一直报错。本机复跑：空管道读 `n=0 ferror=1 feof=0 errno=11`；写完数据 `clearerr` 后 `n=6`，但那行 `ferror` 仍是 1（缓冲要 64 字节、读满 6 后又撞 `EAGAIN`）。
:::
:::

::: method 回忆 21 · 内核路径与三种取证
一次 `printf` 到 `write` 在 glibc 里经过哪几层？为什么 `strace -e write` 看不到每次 `printf`？怎么在不改代码的前提下证明缓冲、并分别得到行缓冲/无缓冲？
::: sol 答案
`vfprintf` 格式化 → `_IO_file_xsputn` 拷进缓冲区 → 溢出 `_IO_file_overflow` → `_IO_do_write` → `_IO_file_write` → `write`。`strace` 只看到 `_IO_file_write` 发出的那几次 `write`，不是每次 `printf`，所以次数对不上。取证：① 用文件大小（`bufsize` 复跑 0/0/18/18）证明数据在缓冲；② `stdbuf -o0`/`-oL`（走 `LD_PRELOAD`，只影响三个标准流、对已 `setvbuf` 或静态链接无效）在不改代码下改模式，本机各得 3 次 `write(1,"tick N\n",7)`；③ 真终端才行缓冲——ssh 下 stdout 是管道、`./tick` 全缓冲一次写 21 字节，要看终端形态用 `script` 造伪终端（此时 `\n` 被 tty 的 ONLCR 转成 `\r\n`，每写 8 字节）。
:::
:::
