# 1.10 习题集

三组分层：**A 组概念判断**考「会读、会判、会说理由」；**B 组诊断推理**给现象让你判返回值、生命周期与持久化边界；**C 组动手实验**在 Linux 上免 `sudo` 复现本章的关键证据。**全部附解答与判据**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；A 组要求口述或写一段完整因果，B 组要求写成「现象 → 机制 → 证据 → 修法」四段。
2. 卡住了回对应小节的「即时自测」重读，不要直接看答案；A 组对应 1.10.1–1.10.10，B 组对应 1.10.8–1.10.16，C 组对应 1.10.14–1.10.15。
3. C 组的命令都在本书的 Ubuntu 24.04.5 虚拟机（aarch64、内核 7.0.0-38-generic、GCC 13.3.0、glibc 2.39、strace 6.8）上跑过；标注「VM 实测」的是这台机器的读数。
4. **`sudo` 不可用**：1.10.15 的 `drop_caches` 需要 root，不能照跑；C4 用 `posix_fadvise(POSIX_FADV_DONTNEED)` 加 `/proc/self/io` 做免特权替代。C1–C3 都不需要 root。
5. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch10-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 1.10-A1 · `read` 只返回 100 {#ex-1.10-A1}

`read(fd, buf, 4096)` 返回 100。能否说明文件只剩 100 字节？列出至少三条其他可能原因，并写出「读满 4096 字节」的循环要点。返回值 0 和 -1 各是什么？

::: sol 解答

不能。100 只说明这次拿到了 100 字节，可能是 EOF（文件只剩 100），也可能是管道/socket 缓冲区里只有 100 且写端未关闭、终端规范模式一次只给一行、信号在部分数据到达后打断、`O_DIRECT` 或设备块大小限制、NFS 返回的块小于请求。读满的循环：`done = 0`；`while (done < n)` 调 `read(fd, p + done, n - done)`；`r == 0` 表示 EOF，跳出并返回短计数；`r == -1 && errno == EINTR` 继续；其他 `-1` 返回错误；否则 `done += r`。返回 0 是 EOF，不是错误；返回 -1 才是错误，具体看 `errno`（`EINTR`、`EAGAIN`、`EIO` 等）。

**判据**：能说出「100 不是 EOF 的证据」，循环同时处理短计数、`0` 与 `EINTR`，并明确 `-1` 要看 `errno`。

:::
:::

::: ex 例 1.10-A2 · 四个 `stat` 字段 {#ex-1.10-A2}

解释 `st_size`、`st_blocks`、`st_blksize`、`st_ctim` 各是什么。为什么稀疏文件会让 `ls -l` 与 `du` 对不上？`stat`、`lstat`、`fstatat` 在符号链接上有什么区别？

::: sol 解答

`st_size` 是逻辑大小（字节）；`st_blocks` 是实际分配的 512 字节块数；`st_blksize` 是推荐的 I/O 粒度（常见 4096，不是磁盘扇区）；`st_ctim` 是 inode 状态改变时间，不是创建时间。稀疏文件的 `st_size` 可以很大而 `st_blocks` 很小甚至为 0，所以 `ls -l` 看逻辑大小、`du` 看实际占用。`stat` 跟随符号链接，看到目标文件；`lstat` 不跟随，看到链接本身的 inode 与长度；`fstatat(dirfd, path, &st, flags)` 默认跟随，传 `AT_SYMLINK_NOFOLLOW` 才不跟随，且相对 `dirfd` 解析。遍历目录时优先 `fstatat`，避免「先拼路径再 `stat`」被 `rename` 打断。

**判据**：四个字段的口径都说对；能解释稀疏文件；能说出 `lstat` 与 `fstatat` 的「不跟随」开关。

:::
:::

::: ex 例 1.10-A3 · `readdir` 的三个边界 {#ex-1.10-A3}

目录为什么不能用 `read` 读？`d_type` 为什么可能是 `DT_UNKNOWN`？`readdir` 返回的指针能保存吗？多线程遍历同一目录要注意什么？

::: sol 解答

目录是「名字 → inode」的结构化记录，不是字节流；Linux 与 macOS 的 `read(2)` 对目录都返回 `EISDIR`，要用 `opendir`/`readdir`/`closedir`（glibc 底层 `getdents64`）。`d_type` 只是目录项里的提示，XFS、NFS 等文件系统可能返回 `DT_UNKNOWN`，必须对每个名字做 `fstatat` 补齐；这也是 `ls` 在冷目录上变慢的原因之一。`readdir` 返回的指针由 `DIR` 内部缓冲区持有，下一次 `readdir` 可能覆盖它，要保存名字必须复制。`readdir` 不保证线程安全；多线程遍历同一目录要用各自的 `DIR`，或加锁。

**判据**：能说出 `EISDIR`、`DT_UNKNOWN` 要用 `fstatat` 补齐、返回指针会失效；多线程方案至少给一种。

:::
:::

::: ex 例 1.10-A4 · 重定向顺序 {#ex-1.10-A4}

`cmd 2>&1 >out` 与 `cmd >out 2>&1` 之后，stdout 与 stderr 分别去哪？画出 fd 表的变化。`dup2(oldfd, newfd)` 在 `oldfd == newfd` 时做什么？

::: sol 解答

`cmd 2>&1 >out` 从左到右：先把 fd 2 复制成 fd 1 当前指向的终端，再把 fd 1 改成 `out`；所以 stderr 仍在终端，stdout 进文件。`cmd >out 2>&1` 先把 fd 1 指向 `out`，再把 fd 2 复制 fd 1，两者都进文件。`dup2` 的边界：`oldfd == newfd` 直接返回 `newfd`，不关闭也不改标志；`newfd` 已打开时原子地先关闭再复制；`oldfd` 无效返回 -1/`EBADF`，`newfd` 不变；`newfd` 超出 `RLIMIT_NOFILE` 也返回 `EBADF`。`dup3` 多一个 `flags`（`O_CLOEXEC`），且 `oldfd == newfd` 返回 `EINVAL`。

**判据**：两个顺序的结果都说对，并能用「复制当前值」解释；`dup2` 的 `oldfd == newfd` 与 `dup3` 的差别不能漏。

:::
:::

::: ex 例 1.10-A5 · `write` 成功与落盘 {#ex-1.10-A5}

`printf("done\n")` 重定向到文件后，程序 `_exit`，这行还在吗？`write(fd, buf, n)` 返回 `n` 后立刻断电，数据一定在磁盘上吗？要保证「临时文件 → `rename`」的持久化，顺序是什么？

::: sol 解答

`printf` 写的是 stdio 用户缓冲区；重定向到文件时 stdout 默认全缓冲，`_exit` 不会刷新缓冲区，所以这行可能丢。要保证写出，调用 `fflush(stdout)`、改用行缓冲，或让程序正常 `exit`/`fclose`。`write` 返回 `n` 只说明数据进了 page cache 并标脏；进程崩溃不影响内核回写，但机器掉电会丢。要持久化，`fsync(fd)`（数据 + 元数据）或 `fdatasync(fd)`（数据 + 必要元数据）；`rename` 只改目录项，之后还要 `open` 父目录得到 `dirfd` 并 `fsync(dirfd)`。顺序：写临时文件 → `fsync(filefd)` → `close` → `rename` → `open(dir)` + `fsync(dirfd)`。

**判据**：区分「进程崩溃」与「机器掉电」；知道 stdio 缓冲与 page cache 是两层；持久化顺序包含目录 `fsync`。

:::
:::

::: ex 例 1.10-A6 · 五个场景选接口 {#ex-1.10-A6}

为下面五个场景各选一个首选接口并给理由：① 格式化日志；② 网络上的行协议；③ 8 GiB 文件的随机读；④ 把文件内容发到 socket；⑤ 高并发小 I/O。

::: sol 解答

① stdio（`printf`/`fprintf`）：缓冲、格式化、错误处理成熟，但注意全缓冲与 `fflush`。② RIO 或手写循环：必须处理短读短写与 `EINTR`；不要用 stdio 写 socket，`fprintf` 可能缓冲、可能部分写、错误码被 `FILE` 状态掩盖。③ `mmap` 或 `pread`：避免多次拷贝、按页缺页；`mmap` 注意 `SIGBUS` 与文件截断。④ `sendfile`：文件 page cache 直接挂到 socket，省掉用户态拷贝；需要 TLS 或用户态处理时不能直接用。⑤ `epoll` + 非阻塞 fd；极高 IOPS/批量提交用 `io_uring`。共同判据是返回值语义、数据层次与持久化边界。

**判据**：五个场景都给出接口与一条场景相关的理由；至少说出一个「不能用 stdio」的边界。

:::
:::

## B 组 · 诊断推理

::: ex 例 1.10-B1 · 解析器把短读当完整报文 {#ex-1.10-B1}

一个 TCP 客户端用 `read(fd, buf, 4096)` 读一行 JSON，返回 100 就交给解析器，偶尔报「unexpected end of JSON」。写出「现象 → 机制 → 证据 → 修法」四段。

::: sol B1 核对

现象是解析器偶尔拿到半条报文。机制是短读：TCP 是字节流，`read` 只保证返回「当前可用的至少 1 字节」，不保证填满 4096；100 字节可能只是报文的前半段，后半段还在路上。证据（形状示例）：`strace -e trace=read -s 32 ./client` 会看到 `read(3, "{\"id\":1,...", 100) = 100`，下一次 `read` 才拿到剩余；用 `tcpdump` 也能看到分段。修法：维护用户态缓冲，循环读到「换行」或「长度前缀」给出的完整边界；每次 `read` 处理 `0`（EOF）、`-1/EINTR`（重试）、`-1/EAGAIN`（等可读事件）；不要假设一次 `read` 等于一条消息。若协议没有边界，先改协议（长度前缀或换行），再谈解析。

**判据**：能把「短读」与「TCP 字节流无边界」连起来；证据命令能复现；修法同时处理边界与 `EINTR`/`EAGAIN`。

:::
:::

::: ex 例 1.10-B2 · `O_APPEND` 了还是交错 {#ex-1.10-B2}

多进程写同一个日志文件，打开时都带了 `O_APPEND`，但日志行仍然互相穿插。为什么？怎么改？

::: sol B2 核对

`O_APPEND` 只保证**单次 `write`** 的「定位到末尾 + 写」是原子的；如果一条日志分成 `write(时间)`、`write(内容)`、`write(换行)` 三次，三次之间可能插入别的进程的写，行就交错。另一个可能是用了 stdio 的多次 `fprintf`，每次刷新时机不同。修法：在用户态把一条日志拼成一个缓冲区，用一次 `write` 写出；管道场景还要注意单次写不超过 `PIPE_BUF`（Linux 4096）才保证不与其他写者交错，超过则可能被拆分。不能把 `O_APPEND` 当成「整条日志原子」。证据：`strace -f -e trace=write ./prog` 看每次写的长度与内容；如果是三次小写，就能解释交错。

**判据**：说清「单次 `write` 原子」而不是「整条日志原子」；修法是合并成一次写；知道 `PIPE_BUF` 只约束管道。

:::
:::

::: ex 例 1.10-B3 · `fork` 后输出重复 {#ex-1.10-B3}

程序在 `fork` 前用 `printf` 打了一行（没有换行），`fork` 后父子都调用 `exit`，终端上看到这行出现两次。为什么？两种修法各有什么代价？

::: sol B3 核对

`printf` 的字节还在父进程的 stdio 用户缓冲区里；`fork` 复制整个地址空间，子进程也得到一份同样的缓冲区；父子各自 `exit` 时都刷新，于是同一行被写两次。修法一：子进程用 `_exit`（或 `_Exit`），不刷新 stdio 缓冲区，代价是子进程自己缓冲区里未写出的内容也会丢，必须在 `fork` 前把要保留的内容 `fflush` 掉。修法二：`fork` 前 `fflush(NULL)`，把父进程所有输出流刷新，代价是多一次系统调用、且要记得在所有 `fork` 路径上做。若子进程紧接着 `execve`，旧地址空间被替换，缓冲区不会被子进程刷新，但父进程那份仍会在父进程退出时刷新，所以「只出现一次」的前提是父进程正常退出；不要依赖这个巧合。

**判据**：能指出「缓冲区被 `fork` 复制」；两种修法都说得出代价；知道 `_exit` 与 `exit` 的差别。

:::
:::

::: ex 例 1.10-B4 · `rm` 了文件，`df` 不降 {#ex-1.10-B4}

`rm /var/log/app.log` 后 `df -h` 仍然满，`du` 也找不到这个大文件。最可能的原因是什么？怎么确认、怎么修？

::: sol B4 核对

最可能是有进程还持有这个文件的打开 fd。`unlink` 只删目录项，inode 的链接数减一；只要引用计数不为 0（还有 fd 打开），数据块就不释放。确认：`ls -l /proc/<pid>/fd | grep deleted` 会看到 `app.log (deleted)`；`lsof +L1` 列出链接数为 0 但仍打开的文件。修法：让持有者关闭 fd（重启服务、滚动日志后重新打开），或临时 `truncate` 那个 fd 对应的文件（`truncate -s 0 /proc/<pid>/fd/N`，需要权限且要小心）。长期修法是日志轮转后给进程发信号让它重新 `open`，而不是只 `mv` 走。不要用 `du` 找不到就判断「空间没被占用」。

**判据**：能说出「目录项删除 ≠ inode 释放」；会用 `/proc/<pid>/fd` 或 `lsof +L1` 确认；修法指向关闭/重新打开 fd。

:::
:::

::: ex 例 1.10-B5 · `accept` 报 `EMFILE` 后空转 {#ex-1.10-B5}

一个单线程服务器每个连接一个 fd，跑久了 CPU 100%，日志里反复出现 `accept: Too many open files`。`ulimit -n` 是 1024。解释原因，给出「救急 fd」的修法，并说明为什么不能只是 `continue`。

::: sol B5 核对

`EMFILE` 表示进程 fd 表达到 `RLIMIT_NOFILE` 软限制；`accept` 失败后监听 socket 仍然可读，下一次循环又立刻返回 `EMFILE`，于是空转烧 CPU。只 `continue` 不解决问题，因为导致满的那个连接还在。救急 fd 模式：启动时 `open("/dev/null", O_RDONLY | O_CLOEXEC)` 预留一个 fd；`accept` 返回 `EMFILE` 时先 `close(idlefd)` 腾出一个位置，再 `accept` 一个连接并立刻 `close`（丢弃），然后重新 `open` 救急 fd；记录日志并考虑降载/退出。长期方案是修 fd 泄漏（`ls /proc/<pid>/fd | wc -l`、`lsof -p`），或把连接数控制在 `RLIMIT_NOFILE` 以下；提高限制需要改 `ulimit`/systemd `LimitNOFILE`，通常需要权限。`ENFILE` 是系统文件表满，处理思路不同。

**判据**：能区分 `EMFILE` 与 `ENFILE`；救急 fd 的顺序正确（关→accept→close→补回）；知道 `continue` 为什么会空转。

:::
:::

::: ex 例 1.10-B6 · `fsync` 了文件，`rename` 后还是旧内容 {#ex-1.10-B6}

程序写 `config.tmp`，`fsync(fd)`，`close`，`rename("config.tmp", "config")`，然后机器掉电。重启后发现 `config` 还是旧内容，甚至为空。漏了哪一步？`O_DIRECT` 能不能替代这一步？

::: sol B6 核对

漏了目录项的持久化。`fsync(filefd)` 只保证文件数据与 inode 落盘；`rename` 改的是父目录的目录项，目录项本身可能还在 page cache，掉电后可能回滚到旧名字/旧 inode。正确顺序：写临时文件 → `fsync(filefd)` → `close` → `rename` → `open` 父目录（`O_DIRECTORY`）→ `fsync(dirfd)`。`O_DIRECT` 只绕过文件数据的 page cache，不保证目录项、inode 或设备缓存，不能替代 `fsync`；它也不能替代「文件 → 目录」的顺序。若还要保证「要么旧要么新」，目录 `fsync` 是必要的一步。

**判据**：能指出漏的是目录 `fsync`；顺序完整；知道 `O_DIRECT` 与 `fsync` 不是一回事。

:::
:::

## C 组 · 动手实验

::: ex 例 1.10-C1 · 数 `write` 次数：缓冲区的直接证据 {#ex-1.10-C1}

写一个输出 1000 行的程序，分别重定向到 `/dev/null` 与接到伪终端，用 `strace` 数 `write` 次数与每次大小。解释差异；记录你自己机器的数，不要抄正文的「1–2 次」。

::: sol C1 核对

```c
/* buffered.c */
#include <stdio.h>
int main(void) {
    for (int i = 0; i < 1000; i++)
        printf("line %04d\n", i);
    return 0;
}
```

```bash
cc -O2 -o buffered buffered.c
strace -c -e trace=write ./buffered > /dev/null
strace -e trace=write -s 24 ./buffered > /dev/null
script -qec "strace -c -e trace=write ./buffered" /dev/null
```

VM 实测（Ubuntu 24.04.5、glibc 2.39、strace 6.8）：重定向到 `/dev/null` 是 **3 次** `write`，大小分别为 4096、4096、1808（合计 10000 字节）；`script` 分配 pty 后是 **1000 次**，每次一行。原因：stdout 重定向到文件时全缓冲（`_IOFBF`），缓冲区按 4096 字节刷；pty 上是行缓冲（`_IOLBF`），遇到 `\n` 就写。正文 1.10.14 说「通常 1–2 次」，在这台机器上不成立；不同 glibc/`BUFSIZ` 可能给出不同次数，判据是「远少于 1000 次」与「pty 约 1000 次」的形状，而不是某个固定数字。`strace` 只数次数，不能用来测性能。

**判据**：能复现「重定向少量大块写 vs pty 每行一写」；记录并报告自己的次数与大小；能解释 `_IOFBF` 与 `_IOLBF`。无需 `sudo`。

:::
:::

::: ex 例 1.10-C2 · `O_DIRECT` 的对齐边界 {#ex-1.10-C2}

用 `dd` 与一个自写程序证明 `O_DIRECT` 要求缓冲区地址、偏移、长度对齐。先跑 `bs=4k` 与 `bs=1000` 的对照，再在 C 里试「对齐成功、偏移 1、缓冲区 +1」三种情况。

::: sol C2 核对

```bash
dd if=/dev/zero of=/tmp/od.bin bs=1M count=8
dd if=/tmp/od.bin of=/dev/null bs=4k iflag=direct
dd if=/tmp/od.bin of=/dev/null bs=1000 iflag=direct
```

VM 实测（`/tmp`）：`bs=4k` 成功，`bs=1000` 报 `dd: error reading '/tmp/od.bin': Invalid argument`，0 字节。C 侧：

```c
void *p;
posix_memalign(&p, 4096, 4096);
int fd = open("/tmp/od.bin", O_RDWR | O_DIRECT);
ssize_t r1 = pwrite(fd, p, 4096, 0);          /* 对齐：成功 */
ssize_t r2 = pwrite(fd, p, 4096, 1);          /* 偏移 1：-1/EINVAL */
ssize_t r3 = pwrite(fd, (char *)p + 1, 4096, 0); /* 缓冲区 +1：-1/EINVAL */
```

VM 实测三种结果分别为 4096、-1/`EINVAL`（22）、-1/`EINVAL`。判据是：对齐那组成功，另外两组都在 `errno` 里给出 `EINVAL`，并能指出是哪一项没对齐。若你的文件系统不支持 `O_DIRECT`，`open` 本身可能返回 `EINVAL`，这时换一个支持的文件系统或如实记录「本机不支持」，不要把它误判成对齐问题。无需 `sudo`。

**判据**：三组结果齐全；能指出「地址、偏移、长度」三项；`errno` 是 `EINVAL` 而不是笼统的「失败」。无需 `sudo`。

:::
:::

::: ex 例 1.10-C3 · fd 表、`dup2` 与 `(deleted)` {#ex-1.10-C3}

写一个 30 行程序：保存 stdout，打开文件并用 `dup2` 把 stdout 指过去，写一行；恢复 stdout，再写一行；另开一个临时文件，`unlink` 后 `readlink("/proc/self/fd/N")`。预期看到什么？

::: sol C3 核对

```c
#define _GNU_SOURCE
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

int main(void) {
    int saved = dup(STDOUT_FILENO);
    int fd = open("/tmp/fdprobe.out", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    dup2(fd, STDOUT_FILENO);
    close(fd);
    printf("to-file\n");
    fflush(stdout);                 /* 关键：恢复前刷新 */
    dup2(saved, STDOUT_FILENO);
    close(saved);
    printf("to-terminal\n");

    int del = open("/tmp/fdprobe.del", O_RDWR | O_CREAT | O_TRUNC, 0600);
    if (write(del, "x", 1) != 1) { perror("write"); return 1; }
    unlink("/tmp/fdprobe.del");
    char path[64], target[256];
    snprintf(path, sizeof path, "/proc/self/fd/%d", del);
    ssize_t n = readlink(path, target, sizeof target - 1);
    if (n >= 0) { target[n] = 0; fprintf(stderr, "link=%s\n", target); }
    return 0;
}
```

```bash
cc -std=c17 -O2 fdprobe.c -o fdprobe && ./fdprobe
```

判据：`/tmp/fdprobe.out` 里只有 `to-file`，终端上只有 `to-terminal`；`stderr` 打印的 `link=` 以 `/tmp/fdprobe.del (deleted)` 结尾。若忘了 `fflush(stdout)`，`to-file` 可能在恢复 stdout 之后才被刷新到终端，这是 1.10.5 的坑。把 `dup2` 换成 `dup3` 并在 `oldfd == newfd` 时观察 `EINVAL`，可以再加一组对照。无需 `sudo`。

**判据**：两个输出各到各的文件/终端；`readlink` 出现 `(deleted)`；能解释 `dup2` 共享打开文件描述、`close(fd)` 后 stdout 仍持有引用。

:::
:::

::: ex 例 1.10-C4 · 没有 root，怎么证明 page cache {#ex-1.10-C4}

`drop_caches` 需要 root，本书环境 `sudo` 不可用。写一个程序：创建 32 MiB 文件、`fsync`、关闭；重新打开后 `posix_fadvise(POSIX_FADV_DONTNEED)`；读一遍，再读一遍，每次前后读 `/proc/self/io`。用 `rchar` 与 `read_bytes` 证明第二次读命中 page cache。

::: sol C4 核对

关键调用（`io_stats` 的实现就是打开 `/proc/self/io`，读 `rchar` 与 `read_bytes` 两行，这里省略）：

```c
int fd = open("/tmp/pagecache.bin", O_RDWR | O_CREAT | O_TRUNC, 0600);
/* 写入 32 MiB，fsync，close */
fd = open("/tmp/pagecache.bin", O_RDONLY);
posix_fadvise(fd, 0, 0, POSIX_FADV_DONTNEED);   /* 丢掉干净页，不需要 root */
io_stats("after-drop");                          /* 读 /proc/self/io 的 rchar/read_bytes */
while ((n = read(fd, buf, 65536)) > 0) total += n;
io_stats("first-read");
lseek(fd, 0, SEEK_SET);
while ((n = read(fd, buf, 65536)) > 0) total += n;
io_stats("second-read");
```

VM 实测：`after-drop` 时 `read_bytes=0`；第一次读后 `read_bytes=33554432`（正好 32 MiB），`rchar` 增加约 32 MiB；第二次读后 `read_bytes` **不再增加**，`rchar` 再增加约 32 MiB。判据：第一次读让 `read_bytes` 增加约文件大小，第二次只增加 `rchar`，说明第二次没有进块层、命中 page cache。注意 `rchar` 是累计值，包含动态链接器读 ELF 的字节，所以基线与增量都要看；`read_bytes` 也是累计值，比较两次的差。若 `fadvise` 没有把页丢掉（文件仍被 mmap 或有其他引用），第一次 `read_bytes` 可能不增加，这时先确认没有别的映射，再重跑。无需 `sudo`；这就是 1.10.15 第 1 步的免特权替代。

**判据**：第一次 `read_bytes` 增量约为文件大小，第二次为 0 增量；`rchar` 两次都增加；能解释 `drop_caches` 与 `fadvise` 的作用范围差异。无需 `sudo`。

:::
:::
