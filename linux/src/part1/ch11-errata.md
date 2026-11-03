# 1.11 勘误与版本注记

这一页收本章最容易「换一台机器就不成立」的东西：`EAGAIN` 与阻塞/非阻塞的语义、`SIGPIPE` 的处置、端口复用的两种选项、IPv6 双栈的默认值，以及 macOS 与 Linux 的 socket 差异。正文的 `errata` 盒讲理解陷阱；这一页讲**换一个内核、换一个 libc、换一个平台之后要复核什么**。

**本章基线**：正文的 `ss`/`nstat` 读数来自本书 Ubuntu 24.04.5 虚拟机（aarch64、内核 7.0.0-38-generic、GCC 13.3.0，`sudo` 不可用）；1.11.15 的 `tcpdump` 输出是形状示例（抓包需 `CAP_NET_RAW`，本机未跑）；1.11.16 的 500 连接 `strace` 统计是预期形态。跨平台对照只在本机 macOS 上做，没有 FreeBSD 机器。凡标「VM 实测」的是那台 Ubuntu 虚拟机，标「macOS 实测」的是本机 macOS，其余按末节当作未实测。

## 1. 语义、选项与平台：十五个容易搬家的结论

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「`EAGAIN` 就是 11」 | Linux 是 11，macOS 实测是 35；`EWOULDBLOCK` 在 Linux 与 `EAGAIN` 同值，别处未必。比较一律用宏，不写数字 | `python3 -c 'import errno;print(errno.EAGAIN)'` 两个平台各跑一次；或写 C 打印两个宏 |
| 「非阻塞 `read` 返回 -1 就是对端出错」 | `-1/EAGAIN` 是「暂时没有数据」，应等可读事件再试；`0` 才是 EOF（写端全部关闭）。把两者混淆会出现「对端还活着却提前关连接」 | 非阻塞 fd 上无数据时 `read`，看 `errno`；对端 `close` 后再读，看返回 0 |
| 「`accept` 的新 fd 继承监听 fd 的 `O_NONBLOCK`」 | Linux 上不继承。VM 实测：监听 fd 标志 `0x802`（`O_RDWR\|O_NONBLOCK`），accept 出来的 fd 是 `0x2`。要非阻塞用 `accept4(..., SOCK_NONBLOCK\|SOCK_CLOEXEC)` 一次设好；监听 fd 非阻塞且没有待取连接时，`accept4(fd, ..., 0)` 返回 `EAGAIN`（实测） | `fcntl(lfd, F_GETFL)` 与 `fcntl(cfd, F_GETFL)` 各打印一次；`strace -e trace=accept,accept4,fcntl` 对照 |
| 「阻塞 fd 上 `read` 也会返回 `EAGAIN`」 | 阻塞 fd 没数据就睡眠，不返回 `EAGAIN`；只有非阻塞 fd，或设了 `SO_RCVTIMEO`/`SO_SNDTIMEO` 的超时路径，才可能返回 `EAGAIN`/`EWOULDBLOCK`。超时不是 `ETIMEDOUT` | 阻塞 fd 上无数据 `read`，观察进程睡眠；再设 `SO_RCVTIMEO` 重试，打印 `errno` |
| 「往关闭的连接写，只会得到 `EPIPE`」 | 内核先发 `SIGPIPE`；默认动作是终止进程，所以代码看不到返回值。shell 里是 141 = 128+13。忽略或阻塞信号后才返回 `-1/EPIPE`（32） | `yes \| head -1; echo ${PIPESTATUS[0]}`（VM 实测 141）；C 里 `signal(SIGPIPE, SIG_IGN)` 后再写，看 `errno` |
| 「`MSG_NOSIGNAL` 是同一个常量」 | 数值因平台而异：VM 实测 16384，macOS 实测 524288。BSD 传统上还有 `SO_NOSIGPIPE` 选项（C 头文件有，Python 模块在 macOS 上未导出）；不要用「Python 里没有」推断系统不支持 | `python3 -c 'import socket;print(socket.MSG_NOSIGNAL)'` 两边各跑；C 里查 `SO_NOSIGPIPE` 宏 |
| 「`SO_REUSEADDR` 能解决所有端口占用」 | 它只允许 `bind` 处于 `TIME_WAIT` 的**同一本地地址**，且必须在 `bind` 前设置。另一个进程正在 `LISTEN` 时仍然 `EADDRINUSE`。VM 实测：主动关闭后立刻重绑，不带选项 98，带选项成功 | 服务器主动 `close` 后立刻重绑同一端口；再另起一个 `LISTEN` 进程，重复带选项的绑定，观察仍然失败 |
| 「`SO_REUSEPORT` 能让新进程接管老连接」 | 它只影响**新连接**的分配：内核按四元组哈希把新连接分给某个监听 socket，已有连接固定在原 socket 上。所有 socket 都要设置该选项且同 uid；分发是否均匀未实测 | 两个进程都设 `SO_REUSEPORT` 绑同一端口（VM 实测可以同时 `listen`），再各起连接看落到谁；进程崩溃后原连接是否消失 |
| 「IPv6 socket 默认只收 IPv6」 | 由 `IPV6_V6ONLY` 决定，默认值不可假设。VM 实测（内核 7.0.0-38）与本机 macOS 实测都是 0：绑 `::` 能收 IPv4，peer 显示 `127.0.0.1`；设成 1 后 IPv4 连接返回 `ECONNREFUSED`（111）。容器运行时可能设 1 | `getsockopt(IPPROTO_IPV6, IPV6_V6ONLY)` 读默认值；分别用 `127.0.0.1` 与 `::1` 连；显式设 1 再试 |
| 「`listen(fd, backlog)` 的 backlog 就是队列实际容量」 | `backlog` 只是上限，还受 `net.core.somaxconn` 限制；队列可以短暂超限。VM 实测 `listen(1)` 时 `ss` 显示 `Send-Q 1`，两个待取连接时 `Recv-Q 2`；第 3 条连接 2 秒超时，`TcpExtListenOverflows`/`ListenDrops` 各增长 2 | `ss -lnt '( sport = :端口 )'` 看 `Recv-Q`/`Send-Q`；`nstat -az \| grep -E 'ListenOverflows\|ListenDrops'` 做前后差 |
| 「`nc -vz` 与 `curl` 连不上时退出码一样」 | 两者口径不同：VM 实测关闭端口上 `nc -vz` 退出 1、`curl` 退出 7。脚本里把退出码当统一判据会误判 | 对一个没人监听的端口分别跑 `nc -vz`、`curl -s`，`echo $?` 各记一次 |
| 「`getaddrinfo` 失败看 `errno`」 | 返回的是 `EAI_*`，不是 `errno`；只有 `EAI_SYSTEM` 时 `errno` 才有意义。VM 实测：域名加 `AI_NUMERICHOST` 返回 `-2`（`EAI_NONAME`），macOS 的数值不同。比较用宏与 `gai_strerror` | 传一个域名 + `AI_NUMERICHOST`，打印返回值与 `gai_strerror`；不要打印 `errno` 当结论 |
| 「HTTP/1.1 默认短连接」 | HTTP/1.1 默认持久连接，除非显式 `Connection: close`；HTTP/1.0 才默认关闭。没有 `Content-Length` 也不是 chunked 时，keep-alive 下的 body 边界不成立，浏览器会等到超时 | `curl -v` 看响应头有无 `Content-Length`/`Transfer-Encoding`/`Connection`；用一个不设长度的服务器分别用 `curl` 与浏览器访问 |
| 「`ss -p` 一定能显示进程」 | 只有同用户或足够权限的进程才显示；VM 上 `ss -lntp` 的 `Process` 列可能为空，但表头仍在。没有 pid 不等于没有进程 | `ss -lntp` 与 `ss -lnt` 对照；用自己启动的进程与系统服务各试一次 |
| 「macOS 与 Linux 的 socket 代码可以照搬」 | 本章范围内至少四处不同：`EAGAIN` 数值、`MSG_NOSIGNAL` 数值、`SO_NOSIGPIPE` 的有无、`/proc` 的缺失（`/proc/<pid>/fd`、`/proc/self/io` 拿不到）。`IPV6_V6ONLY` 的默认值这次相同，但不构成保证 | 两个平台各跑一次同一段探测程序；`ls /proc` 在 macOS 上失败；C 里条件编译 `#ifdef SO_NOSIGPIPE` |

## 本章未实测项

下面这些没有本机证据支撑，引用前请当作**待验证的量级、形状或方法**，不要抄成事实：

- **1.11.15 的 `tcpdump` 抓包输出**（`[S]`/`[S.]`/`[.]`/`[F.]` 序列）：`tcpdump` 需要 `CAP_NET_RAW`，本书 `sudo` 不可用，VM 上未抓包；握手与挥手的状态变化是用 `ss` 与 Python 连接实验间接确认的。
- **1.11.15 的 C 版 `SO_REUSEADDR` 对照**（注释掉 `setsockopt` 后 `bind` 失败）：本书只用 Python 复现了 98 与成功两种结果，没有编译正文的 `echo_server` 做同一组对照。
- **1.11.16 的 500 条空闲连接 `strace -c` 统计与「CPU 接近 0」**：`strace -p` 需要 ptrace 权限，未在本书环境跑；`epoll_wait` 次数「与事件批次同阶」是按机制推出的预期，不是读数。
- **1.11.12 的「上万条空闲连接」与 `OUT_SIZE` 背压效果**：未做万级连接压测；`64 KiB` 输出上限是代码里的常量，不是调优结论。
- **1.11.13 对 chunked 响应的处理**：正文说客户端只打印原始块；本书未搭 chunked 服务端实测这段输出。
- **1.11.6 的 PMTUD 黑洞与分片实验**：制造黑洞通常要 netns、路由与防火墙规则，需要 root；「小包通、大包卡」只按机制描述。
- **Nagle 与延迟 ACK 叠加的 40 ms 停顿**：未在本书环境计时；正文给的是量级与成因，不是本机读数。
- **`io_uring` 的提交/完成队列行为**：正文只做模型对比，未写程序验证；内核版本与 liburing 版本都会影响接口细节。
- **`SO_REUSEPORT` 的分流均匀性**：只验证了两个 socket 能同时 `listen`，没有统计连接落到各 socket 的比例；「按四元组哈希」是内核实现口径，不是本机测量。
- **macOS 上 `SO_REUSEPORT`、`SO_LINGER`、`SO_RCVTIMEO` 的具体行为**：本章只实测了 `EAGAIN`、`MSG_NOSIGNAL`、`IPV6_V6ONLY` 默认值与 IPv4→`::` 的连接；BSD 的端口复用语义与 Linux 有历史差异，未逐项对照。
- **FreeBSD 与其他 BSD**：没有机器，未测。
- **公网 DNS 的超时秒数**：`getaddrinfo` 可能阻塞数秒，具体取决于 `/etc/resolv.conf` 的 `timeout`/`attempts`；本书未对公网域名计时。
- **CSAPP 第 11 章的页码与小节边界**：只按正文「母本对应」表核对结构，没有重读原书；中文版是扫描件，引用的是章节号而不是书内句子。

## 发现新问题怎么记

按「现象 → 命令与输出 → 机器/内核/libc/平台 → 建议改法」四段记，不要只写「我这里不对」。本章的结论大多挂在环境上，所以请一并附上：`uname -a`；`python3 -VV`；`ss -V`；`getent ahosts localhost`；`sysctl net.core.somaxconn`（可读）；`ulimit -n`；以及完整编译命令（有没有 `-O2`、有没有 `-D_GNU_SOURCE`）。涉及数字时写明口径：是 `ss` 的队列长度、`nstat` 的累计计数、`strace` 的调用次数，还是正文的参考形状。本章多数分歧都出在把后一种数当前一种用。
