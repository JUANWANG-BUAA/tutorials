# 1.11 章末总结

## 五段浓缩

| 单元 | 小节 | 核心问题 | 关键结论 | 最容易错的地方 |
|:--|:--|:--|:--|:--|
| **一、协议与地址** | 1.11.1–1.11.2 | 两个进程隔着网络，靠什么找到彼此并交换字节？ | 分层的价值是「换一层不影响其他层」：HTTP 跑在 TCP 上，QUIC 把可靠传输挪到 UDP 之上。应用层看报文、运输层看段、网络层看包、链路层看帧；每层只读自己的首部。IP 地址 + 端口定位服务端点，源/目的 IP 与端口加协议这**四元组**定位连接。端口 0 让内核挑临时端口，1–1023 通常要特权。网络字节序是大端，`htons` 只转 16 位端口，地址用 `inet_pton` 或 `getaddrinfo`，不要手写 `sscanf`。 | 把「IP:端口」当连接；以为 `htons` 能转 IP 地址；把 `getaddrinfo` 返回的链表只取第一条、不逐个尝试；忘记 `freeaddrinfo`。 |
| **二、生命周期与服务器** | 1.11.3–1.11.5.1 | `socket`/`bind`/`listen`/`accept` 各把连接推进到哪一步？ | 服务器主干是 `socket → bind → listen → accept → read/write → close`。`listen` 之后内核维护 SYN 队列与 accept 队列：`backlog` 与 `net.core.somaxconn` 共同限制全连接队列；队列满时 Linux 丢弃或忽略 ACK，客户端重传，表现为「慢」而不是「被拒」。`accept` 返回**新 fd**，绑定完整四元组；监听 fd 继续收新连接。新 fd 不继承监听 fd 的 `O_NONBLOCK`（本书 VM 实测：监听 fd `0x802`、accept 出来的 fd `0x2`），要非阻塞就用 `accept4`。`TIME_WAIT` 在主动关闭方，Linux 约 60 秒。fork 服务器里父进程 `close(cfd)`、子进程 `close(lfd)`，两边都不能漏。 | 以为 `accept` 返回监听 fd；对监听 fd 直接 `read`；fork 后子进程不关监听 fd；`SIGCHLD` 只 `waitpid` 一次，留下僵尸；HTTP 响应缺 `Content-Length` 却想 keep-alive。 |
| **三、边界、MTU 与排障** | 1.11.6–1.11.7 | TCP 的字节流在哪里断开？出了问题先看哪一层？ | TCP 是有序**字节流**，不保留消息边界；应用自己定边界：4 字节大端长度前缀、`\n`/`\0` 分隔符、固定长度、读到 EOF。HTTP 是「分隔符 + 长度」的组合：头以 `\r\n\r\n` 结束，body 用 `Content-Length`、chunked 或关闭连接。以太网 MTU 1500，IPv4 的 TCP MSS = 1460，IPv6 = 1440；超过 MTU 会分片，丢一片就要重传整包。排障顺序是 `ss` → `getent`/`ip route get` → `curl -v`/`nc -vz` → 抓包，不要一上来就 `tcpdump`。`ss` 的 `State` 列直接指路：大量 `SYN-SENT` 是对端不回，`CLOSE-WAIT` 是应用没 `close`，`TIME-WAIT` 是本机主动关了大量短连接。 | 把一次 `read` 当一条消息；把 `\n\n` 当 HTTP 头结束；以为 `write` 返回成功对端就收到了；把 `CLOSE-WAIT` 当服务端问题（其实是本端没关）；忽略 PMTUD 黑洞导致的「小包通、大包卡」。 |
| **四、解析、选项与报文** | 1.11.8–1.11.10 | `getaddrinfo` 的哪些字段由调用者填？socket 选项各改哪段行为？HTTP 报文怎样切？ | `addrinfo` 只有 `ai_flags`、`ai_family`、`ai_socktype`、`ai_protocol` 是输入，其余是输出。`AI_PASSIVE` 配 `node = NULL` 给服务器通配地址；`AI_NUMERICHOST` 禁 DNS；`AI_ADDRCONFIG` 在只有 loopback 的容器里会骗人。失败返回 `EAI_*` 而不是 `errno`，只有 `EAI_SYSTEM` 才看 `errno`。`SO_REUSEADDR` 解决「重启时绑定 `TIME_WAIT` 地址」，必须在 `bind` 前设置；`SO_REUSEPORT` 让多个 socket 绑同一端口、内核按四元组哈希分流，所有 socket 都要设且同 uid；`SO_LINGER = {1, 0}` 让 `close` 发 RST。HTTP body 有四种边界：`Content-Length`、chunked、连接关闭、无 body 状态（`HEAD`/`204`/`304`）。chunked 的块长是十六进制。 | 以为 `SO_REUSEADDR` 能抢别人正在 `LISTEN` 的端口；以为 `SO_REUSEPORT` 能接管已有连接；用 `atoi` 解析 chunk 长度；把 `Content-Length` 当可信值；`HEAD` 响应还去读 body。 |
| **五、并发、程序、实验与陷阱** | 1.11.11–1.11.18 | 上万条连接该用什么模型？怎样用证据确认？ | 四种模型：每连接一进程（隔离最好、`fork` 贵）、每连接一线程（编程简单、栈与切换贵）、事件循环（十万级连接、回调复杂）、异步 I/O（`io_uring`，完成通知）。`select`/`poll` 每次全量拷贝与扫描，`epoll` 靠内核就绪链表只返回就绪项。边沿触发只在状态变化时报告一次，**必须配非阻塞 fd 并一次读到 `EAGAIN`**，写侧要自己缓冲没发完的字节、等 `EPOLLOUT`。排障证据：`ss -lnt` 看 accept 队列（`Recv-Q` 当前、`Send-Q` backlog 上限），`nstat -az` 看 `TcpExtListenOverflows`/`ListenDrops`，`strace -f -e trace=network` 看调用序列。 | 边沿触发只读一次就回去等事件；监听 fd 忘了设非阻塞导致 `accept` 循环卡住；`epoll_wait` 返回后不处理 `EPOLLERR`/`EPOLLRDHUP`；慢客户端不设输出上限；把 `epoll` 当「一定比线程快」。 |

## 一条主线

这一章从「一条连接」走到「一段可切分的字节」：**连接由四元组唯一确定（1.11.1、1.11.3），监听 socket 只绑本地一半，`accept` 返回的新 fd 才带完整四元组；字节流没有消息边界（1.11.6），边界要么由长度前缀、分隔符、固定长度给出，要么由关闭连接给出；HTTP 把这套规则具体化成 `\r\n\r\n` 加 `Content-Length`/chunked（1.11.5、1.11.10）。** 1.11.8 与 1.11.9 补的是「地址怎么解析、选项怎么改内核行为」；1.11.11 与 1.11.12 把「等哪条连接可读」换成 epoll 的就绪链表，代价是必须读到 `EAGAIN` 并自己管理写缓冲；1.11.13 与 1.11.14 把客户端与解析器写成能跑的程序；1.11.15 与 1.11.16 用 `ss`、`nstat`、`strace` 把队列、`TIME_WAIT` 与事件循环变成读数；1.11.17 的十三条陷阱和 1.11.18 的本章小结收口。

如果只记一句话：**看到网络异常，先问连接在哪个状态，再问边界由谁定义，最后问这个返回值承诺了什么。** 这三问覆盖本章大多数故障：`bind` 失败是状态（`TIME_WAIT`），请求截断是边界（短读），响应丢失是返回值（短写或 `EAGAIN`），进程被杀是 `SIGPIPE`。

## 症状 → 机制 → 命令

| 症状 | 机制 | 先跑什么 |
|:--|:--|:--|
| 服务重启报 `bind: Address already in use` | 旧连接处于 `TIME_WAIT`，端口仍被占用；或另一个进程正在 `LISTEN` | `ss -tan state time-wait '( sport = :8080 )'`；`ss -lntp '( sport = :8080 )'` 看是否有别的进程；前者加 `SO_REUSEADDR`（`bind` 前设置），后者只能换端口或停进程 |
| 客户端连接很慢，但不报「拒绝」 | accept 队列满：`backlog` 太小或 `accept` 太慢，内核丢弃/忽略 ACK，客户端重传 | `ss -lnt '( sport = :8080 )'` 看 `Recv-Q` 是否顶到 `Send-Q`；`nstat -az \| grep -E 'ListenOverflows\|ListenDrops'`；调大 `backlog` 与 `net.core.somaxconn` 只是缓冲，根因是 `accept` 被业务阻塞 |
| 请求解析偶发「unexpected end」 | 短读：TCP 是字节流，一次 `read` 只返回当前可用的字节 | `strace -e trace=read -s 64 ./server`；按 `\r\n\r\n` 或长度前缀循环读，处理 `0`、`EINTR`、`EAGAIN` |
| 响应尾部少一截 | 对端关闭前没读完；或写入短写后没补 | `curl -v` 看 `Content-Length` 与实际字节；`strace -e trace=write` 看每次写的长度；写循环 + 等 `EPOLLOUT` |
| `curl` 正常，浏览器一直转圈 | 响应没有 `Content-Length`，也不是 chunked，HTTP/1.1 又默认 keep-alive，浏览器不知道 body 何时结束 | `curl -v` 看响应头；补 `Content-Length`，或 `Connection: close`，或改 chunked |
| 服务器进程偶尔直接退出，退出码 141 | 向已关闭的连接写触发 `SIGPIPE`，默认动作是终止进程；141 = 128 + 13 | `yes \| head -1; echo ${PIPESTATUS[0]}` 复现 141；`signal(SIGPIPE, SIG_IGN)` 或 `send(..., MSG_NOSIGNAL)`，并把 `EPIPE` 当「对端走了」 |
| IPv6 客户端连不上，IPv4 正常 | 服务器只监听了 `0.0.0.0`；或 `AI_ADDRCONFIG` 在容器里过滤掉了 `AF_INET6` | `ss -lnt` 看监听地址；`getent ahosts 主机名`；用 `AF_UNSPEC` + `AI_PASSIVE` 或双栈 `::`（`IPV6_V6ONLY=0` 时能收 IPv4 映射地址） |
| `accept` 报 `EMFILE` 后 CPU 100% | fd 表达到 `RLIMIT_NOFILE`，监听 socket 仍可读，循环立刻再次失败 | `ulimit -n`；`ls /proc/<pid>/fd \| wc -l`；预留救急 fd：关掉它 → `accept` 一个连接并立即关闭 → 补回 |
| `ss` 里大量 `CLOSE-WAIT` | 对端已发 FIN，本端应用没有 `close`，fd 一直占着 | `ss -tan state close-wait`；查代码里漏掉的 `close`/`shutdown`；`CLOSE-WAIT` 堆积最终会耗尽 fd |
| 大量 `TIME-WAIT` 集中在服务器端口 | 服务器主动关闭了大量短连接（HTTP/1.0 风格） | `ss -tan state time-wait \| wc -l`；改 keep-alive 复用连接；`SO_REUSEADDR` 只解决重启 bind，不减少 `TIME_WAIT` |
| 小包能通，大包卡住 | 路径 MTU 发现被防火墙挡住（ICMP 被丢），大包分片后无人重组 | `ping -M do -s 1472 目标`；`ss -tin dst 目标` 看 `mss`；应用层限制消息大小或做 MSS clamping |
| epoll 服务器有空闲连接却收不到数据 | 边沿触发没有一次读到 `EAGAIN`，剩余数据不再触发事件；或 fd 是阻塞的，读循环卡死整个事件循环 | `ss -tan` 看该连接 `Recv-Q` 是否非零；`strace -p <pid> -e trace=epoll_wait,read`；确保 `SOCK_NONBLOCK` + 读到 `EAGAIN` |
| 长连接空闲一阵后突然消失 | NAT/防火墙超时清理了映射表，两端都不知道 | `ss -tan` 看连接是否还在；应用层心跳；调小 `TCP_KEEPIDLE` 并开启 `SO_KEEPALIVE` |

## 能否讲出这八句话

1. **连接是四元组，不是 socket。** 监听 fd 只绑定「本地 IP:端口」，`accept` 返回的新 fd 才带「客户端 IP:端口 + 服务器 IP:端口 + 协议」，内核靠四元组查连接表。对监听 fd `read` 会失败，因为它不是已连接 socket。
2. **`accept` 返回新 fd，且不继承 `O_NONBLOCK`。** 本书 VM 实测：监听 fd 的标志是 `0x802`（`O_RDWR|O_NONBLOCK`），accept 出来的 fd 是 `0x2`；要让新连接非阻塞，用 `accept4(..., SOCK_NONBLOCK | SOCK_CLOEXEC)` 一次设好。
3. **backlog 限的是已完成握手的队列。** 队列满时内核丢弃或忽略 ACK，客户端重传；现象是「连接慢」而不是「拒绝」。`ss -lnt` 的 `Recv-Q` 是当前排队数，`Send-Q` 是 backlog 上限，VM 上 `listen(1)` 时前者可以超过后者。
4. **TCP 没有消息边界。** 长度前缀、分隔符、固定长度、关闭连接四种方案选一种；HTTP 用 `\r\n\r\n` 分头，用 `Content-Length`、chunked 或 EOF 分 body。一次 `read` 永远不等于一条消息。
5. **`close` 不等于对端立刻收到。** 默认行为是先发完排队数据再发 FIN；`SO_LINGER = {1, 0}` 才发 RST 并丢弃数据，VM 实测对端 `recv` 会得到 `ECONNRESET`（104）。要半关闭用 `shutdown(fd, SHUT_WR)`。
6. **`SO_REUSEADDR` 只解决 `TIME_WAIT` 的 bind。** VM 实测：服务器主动关闭后立刻重绑，不带选项返回 `EADDRINUSE`（98），带上就成功；另一个进程正在 `LISTEN` 时它救不了你。
7. **IPv6 双栈要显式确认。** VM 与 macOS 实测 `IPV6_V6ONLY` 默认都是 0，绑 `::` 能收 IPv4；但容器与发行版可能改成 1，程序应显式 `setsockopt`，不要靠默认值。
8. **epoll 的快有条件。** 它省的是「每次把监视表拷进内核再扫描」，不是省掉用户态处理；边沿触发必须配非阻塞 fd 并读到 `EAGAIN`，写侧要自己缓冲剩余字节，否则会漏事件或卡死循环。

## 学完之后

1. **[闭卷回忆卡](ch11-recall.md)**：18 张卡分三组——A 组考四元组、backlog、`getaddrinfo`、HTTP 边界、选项、TCP/UDP；B 组考 fork 服务器、短读短写、`SIGPIPE`、双栈、epoll 边沿触发、响应切分；C 组考 `ss`/`nstat` 读数、`TIME_WAIT`、macOS 差异与数字归属。合上正文，把四元组、四种边界、`Recv-Q`/`Send-Q` 的两套含义从空白纸上叫出来。
2. **[习题集](ch11-exercises.md)**：A 组 6 题考「会读会判」，B 组 6 题给现象让你判状态、边界与返回值，C 组 4 题在 Ubuntu 24.04 上免 `sudo` 复现。先做 A、B，再跑 C；每题都有判据。
3. **[学习目标自检表](ch11-checklist.md)**：这张表接管 [1.11.18 本章小结](ch11.md#sec-1.11.18)，把 6 条出口展开成 18 条，卡住时按右列回到小节与习题。
4. **[勘误与版本注记](ch11-errata.md)**：本章最容易搬家的是 `EAGAIN` 的数值、`SIGPIPE` 的处置、`SO_REUSEADDR`/`SO_REUSEPORT` 的边界、IPv6 双栈默认值，以及 macOS 与 Linux 的 socket 选项差异。引用任何读数前先读未实测项。
5. **下一站**：[1.12 并发编程](ch12.md) 会把单线程 epoll 扩成线程池 + 多 reactor；第 4 篇的 [4.5.3 `listen`](../part4/ch05.md#sec-4.5.3)、[4.8.16 netfilter](../part4/ch08.md#sec-4.8.16)、[4.10.5 epoll 的三个数据结构](../part4/ch10.md#sec-4.10.5) 会把本章的队列、钩子与就绪链表还原到内核路径。
