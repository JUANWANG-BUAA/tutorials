# 1.11 闭卷回忆卡

这一页不是摘要，而是一组**检索练习**。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。18 张卡分三组：**A 组考四元组、握手与队列、`getaddrinfo`、HTTP 边界、socket 选项、TCP/UDP（1.11.1–1.11.10）**，**B 组考 fork 服务器、短读短写、`SIGPIPE`、双栈、epoll 与响应切分（1.11.4–1.11.13）**，**C 组考 `ss`/`nstat` 读数、`TIME_WAIT`、跨平台差异与数字归属（1.11.15–1.11.17 与勘误页）**。建议在学完当天、隔天、第 3 天、第 7 天各做一次，每次只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 协议、地址与接口

::: method 回忆 1 · 四元组与两种 socket
一条 TCP 连接由哪四样东西唯一确定？监听 socket 与 `accept` 返回的连接 socket 各绑定了什么？为什么不能直接对监听 fd `read`？

::: sol 答案
四元组是「源 IP、源端口、目的 IP、目的端口」，再加上协议（TCP/UDP）区分同一对端口上的不同协议。监听 socket 只绑定「本地 IP:端口」，不绑定对端，所以它无法区分两个客户端；`accept` 返回的连接 socket 绑定完整四元组，并带独立的连接状态。内核收到一个段时，用四元组查连接表，才知道这些字节属于哪条连接。对监听 fd 直接 `read` 会失败（Linux 返回 `ENOTCONN`），因为它不是已连接 socket；监听 fd 的工作只有 `accept`。同一台服务器能同时服务上万条连接，靠的是四元组的不同组合，不是多个端口。
:::
:::

::: method 回忆 2 · 三次握手、两个队列与 backlog
三次握手过程中，连接在哪个队列里移动？`listen(fd, backlog)` 限制的是哪个队列？`ss -lnt` 的 `Recv-Q`/`Send-Q` 分别是什么？队列满了客户端看到什么？

::: sol 答案
客户端发 SYN 后，连接进入**半连接队列**（SYN queue），服务器回 SYN+ACK；客户端回 ACK 后，连接移入**全连接队列**（accept queue），等 `accept` 取走。`listen` 的 `backlog` 与 `net.core.somaxconn` 共同限制全连接队列长度。`ss -lnt` 在监听 socket 上：`Recv-Q` 是当前已完成握手、等待 `accept` 的连接数，`Send-Q` 是 backlog 上限。队列满时 Linux 默认丢弃或忽略 ACK，客户端重传，现象是「连接慢/超时」而不是「连接被拒」。本书 VM 实测：`listen(1)` 时 `ss` 显示 `Recv-Q 0 / Send-Q 1`；并发发起 20 条连接，前 2 条完成，第 3 条在 2 秒超时，此时 `Recv-Q 2 / Send-Q 1`，`nstat -az` 的 `TcpExtListenOverflows` 与 `TcpExtListenDrops` 各增加 2。具体数字随内核与重传变化，判据是「`Recv-Q` 可以超过 `Send-Q`、连接表现为超时、溢出计数增长」。
:::
:::

::: method 回忆 3 · `getaddrinfo` 的输入、flags 与错误码
`struct addrinfo` 哪四个字段是输入？`AI_PASSIVE`、`AI_NUMERICHOST`、`AI_ADDRCONFIG`、`AI_V4MAPPED` 各改变什么？失败时为什么不能看 `errno`？

::: sol 答案
输入字段是 `ai_flags`、`ai_family`、`ai_socktype`、`ai_protocol`；`ai_addrlen`、`ai_addr`、`ai_canonname`、`ai_next` 是输出。`AI_PASSIVE` 在 `node == NULL` 时返回通配地址（`0.0.0.0` 与 `::`），服务器 `bind` 前用；客户端误用会连到 `0.0.0.0`。`AI_NUMERICHOST` 禁止 DNS，传域名返回 `EAI_NONAME`；`AI_NUMERICSERV` 要求数字端口。`AI_ADDRCONFIG` 只返回本机已配置的地址族，容器只有 loopback 时可能什么都不返回。`AI_V4MAPPED` 在 IPv6 查询无结果时返回 `::ffff:a.b.c.d`，需与 `AF_INET6` 同用。失败返回 `EAI_*` 码，`errno` 只在 `EAI_SYSTEM` 时有意义；`EAI_AGAIN` 可退避重试，`EAI_NONAME` 不该重试。本书 VM 实测：`getaddrinfo(NULL, "8080", AI_PASSIVE)` 返回 `0.0.0.0:8080` 与 `[::]:8080`；对域名加 `AI_NUMERICHOST` 返回 `-2`（`EAI_NONAME`）。数值在 glibc 与 macOS 上不同，比较用宏。
:::
:::

::: method 回忆 4 · HTTP 的四种 body 边界
HTTP 响应 body 什么时候结束？chunked 的块长是什么进制、以什么结束？哪些响应即使有 `Content-Length` 也没有 body？

::: sol 答案
四种边界：① 有 `Content-Length`，按字节数读满；② `Transfer-Encoding: chunked`，先读十六进制块长 + CRLF，再读块数据 + CRLF，块长 0 表示结束，后面可跟 trailer 与空行；③ 两者都没有，以连接关闭（EOF）为界，HTTP/1.0 风格；④ `HEAD`、`204`、`304` 没有 body，即使头里有 `Content-Length` 也不读。请求侧同理：请求行 + 头 + 空行，有 body 时看 `Content-Length` 或 chunked。头部结束标志是 `\r\n\r\n`，不是 `\n\n`。HTTP/1.1 默认持久连接，所以没有长度就必须用 chunked 或显式 `Connection: close`，否则客户端不知道 body 何时结束。chunked 的块长不要用 `atoi`，要用 `strtoul(s, NULL, 16)`。
:::
:::

::: method 回忆 5 · 三个 socket 选项
`SO_REUSEADDR`、`SO_REUSEPORT`、`SO_LINGER` 各改什么？为什么 `SO_REUSEADDR` 必须在 `bind` 前设置？`SO_LINGER = {1, 0}` 的 `close` 会发什么？

::: sol 答案
`SO_REUSEADDR` 允许 `bind` 一个处于 `TIME_WAIT` 的本地地址，解决服务器重启时的 `EADDRINUSE`；它在 `bind` 时检查，之后再设没有意义。它只对「同一地址、`TIME_WAIT` 状态」有效，另一个进程正在 `LISTEN` 同一端口时仍然失败。`SO_REUSEPORT` 允许同一 uid 的多个 socket 绑定完全相同的地址和端口，内核按四元组哈希把**新连接**分给其中一个；所有 socket 都要设置，且已有连接不会迁移。`SO_LINGER = {l_onoff=1, l_linger=0}` 让 `close` 立刻发 RST 并丢弃发送缓冲区里未发出的数据；对端会收到 `ECONNRESET`（本书 VM 实测 errno 104）。`l_onoff=1, l_linger>0` 则阻塞到数据发完或超时。另有 `TCP_NODELAY` 关闭 Nagle，交互式协议常用；大块传输保持默认更省带宽。
:::
:::

::: method 回忆 6 · TCP 与 UDP、MTU 与 MSS
TCP 与 UDP 在连接、可靠性、边界、拥塞控制、首部上的差别各是什么？MTU 1500 下 IPv4/IPv6 的 TCP MSS 各是多少？UDP 的 `sendto` 成功说明什么？

::: sol 答案
TCP 面向连接（三次握手）、有确认/重传/有序、无消息边界、有拥塞控制、首部 20 字节起；UDP 无连接、不保证到达/顺序/去重、保留数据报边界、无拥塞控制、首部 8 字节。典型用途：TCP 跑 HTTP/SSH/数据库，UDP 跑 DNS/视频/游戏与 QUIC 底层。以太网 MTU 1500，IPv4 首部 20 + TCP 首部 20，MSS = 1460；IPv6 首部 40，MSS = 1440。UDP 的 `sendto` 成功只表示数据交给了本机网络栈，不代表对端收到；需要可靠性就在应用层做序号、确认、重传，或直接用 QUIC。UDP 也可以 `connect`，之后用 `send`/`recv`，内核会记录对端并回传 ICMP 错误，但仍然是不可靠数据报。
:::
:::

::: method 回忆 7 · 封装、分用与字节序
画出 HTTP 请求从应用到以太网帧的首部叠加。端口分几段？`htons` 与 `htonl` 各转什么？为什么 IP 地址不能手写 `sscanf("%d.%d.%d.%d")`？

::: sol 答案
应用层是 HTTP 文本；运输层加 TCP 首部（20 字节起）；网络层加 IP 首部（IPv4 20 字节、IPv6 40 字节）；链路层加以太网首部 14 字节、填充与 FCS 4 字节。接收端逐层剥掉首部并「分用」上交：以太网类型字段指出 IPv4/IPv6，IP 的协议字段指出 TCP/UDP，TCP 的端口指出进程。端口 0 保留（`bind` 时让内核挑临时端口），1–1023 知名端口通常要特权或 `CAP_NET_BIND_SERVICE`，1024–49151 注册端口，49152–65535 临时端口（客户端 `connect` 时内核分配）。网络字节序是大端；`htons` 转 16 位端口，`htonl` 转 32 位整数。IP 地址用 `inet_pton` 转，`sscanf` 既不检查每段范围，也不支持 IPv6；更稳的是 `getaddrinfo`。
:::
:::

## B. 程序、并发与边界

::: method 回忆 8 · fork echo 服务器的五个关键点
父进程与子进程各自关闭哪个 fd？为什么要循环 `waitpid(WNOHANG)`？`SA_RESTART` 之后还要不要处理 `EINTR`？子进程为什么用 `_exit`？

::: sol 答案
父进程 `accept` 后 `fork`，子进程拿到连接 fd 的副本：父进程要 `close(cfd)`，只保留监听 fd；子进程要 `close(lfd)`，否则监听 fd 泄漏到子进程，服务器重启时可能 bind 失败。fd 是引用计数，父进程关掉副本不影响子进程手里的连接。`SIGCHLD` 处理函数里循环 `waitpid(-1, NULL, WNOHANG)`：标准信号不排队，只回收一个会留下僵尸；循环到返回 0 或 -1 为止，并保存/恢复 `errno`。`SA_RESTART` 让部分被打断的系统调用自动重启，但并非所有调用都会重启（例如某些 socket 操作），所以 `accept` 与 `read` 仍要处理 `EINTR`。子进程用 `_exit` 而不是 `exit`，避免刷新从父进程继承的 stdio 缓冲区，造成重复输出。echo 子进程没有忽略 `SIGPIPE`：对端已关闭时写会杀死子进程，这对一次性子进程可接受，但要把这当成有意设计。
:::
:::

::: method 回忆 9 · 短读、短写与三个循环
`read` 返回 1–n、0、-1/`EINTR`、-1/`EAGAIN`、-1/`EPIPE` 各做什么？`write` 返回 0 为什么当异常？`send_all` 与 `read_all` 各自的不变量是什么？

::: sol 答案
`read`/`write` 返回 `>0` 且小于请求是短读/短写：移动指针，继续剩余部分；等于请求是完成。`read` 返回 0 是 EOF；`write` 返回 0 在非零请求下应视为异常（置 `EIO`），否则循环不前进会死循环。-1/`EINTR` 是信号打断且未传数据，重试。-1/`EAGAIN` 是非阻塞且暂时不能读写，等可读/可写事件，不能当 EOF。-1/`EPIPE` 是对端关闭，停止写并关闭连接（同时可能收到 `SIGPIPE`）。其他 `-1` 记录 `errno` 并放弃。`send_all(fd, buf, n)` 的不变量是「返回 0 时 n 字节全部写进本机发送缓冲区」，处理短写与 `EINTR`；`read_all(fd, buf, cap)` 读到 EOF 或缓冲区满，返回总字节数，处理 `EINTR`。两者都不断言「对端收到了」。
:::
:::

::: method 回忆 10 · SIGPIPE、EPIPE 与 141
向已关闭的连接写，内核先做什么？默认动作是什么？忽略信号后 `write` 返回什么？Linux 与 BSD 各有什么避免方式？

::: sol 答案
内核对「写端已关闭」的 socket 或管道先发 `SIGPIPE`；默认动作是终止进程，所以很多服务器会「莫名其妙退出」。shell 里看到退出码 141，就是 128 + 13（`SIGPIPE`）；本书 VM 实测 `yes | head -1` 的 `PIPESTATUS[0]` 是 141。忽略或阻塞 `SIGPIPE` 后，`write` 返回 -1/`EPIPE`（32），应用应把它当「对端走了」，停止写并关闭。避免方式：Linux 用 `send(..., MSG_NOSIGNAL)`（实测常量 16384），或进程级 `signal(SIGPIPE, SIG_IGN)`；BSD/macOS 传统上用 `SO_NOSIGPIPE` 选项（C 头文件有，Python 模块未导出），macOS 也定义了 `MSG_NOSIGNAL`（实测常量 524288），跨平台代码用宏并条件编译。`SIGPIPE` 只与管道和 socket 有关，写普通文件不会触发。
:::
:::

::: method 回忆 11 · IPv6 双栈与 `IPV6_V6ONLY`
绑 `::` 的 socket 能收 IPv4 吗？由哪个选项决定？默认值能假设吗？`AI_ADDRCONFIG` 在容器里为什么会导致「IPv6 连不上」？

::: sol 答案
能不能收 IPv4 由 `IPV6_V6ONLY` 决定：为 0 时双栈，IPv4 客户端会以 `::ffff:a.b.c.d` 映射地址出现；为 1 时只收 IPv6。默认值不要假设：本书 VM（Ubuntu 24.04.5、内核 7.0.0-38）与本机 macOS 实测都是 0，绑 `::` 后 `127.0.0.1` 能连上；但容器运行时与某些发行版会设成 1，服务端应显式 `setsockopt(IPPROTO_IPV6, IPV6_V6ONLY, ...)`。同一端口上「双栈 `::`」与「单独的 `0.0.0.0`」会冲突，只能选一种布局；VM 实测把 `V6ONLY` 设为 1 后，IPv4 连接返回 `ECONNREFUSED`（111）。`AI_ADDRCONFIG` 检查「本机是否配置了该地址族」，容器常常只有 `lo` 与一个 IPv4 地址，于是 `AF_INET6` 结果被过滤，`curl -6` 直接失败；排查时用不带该 flag 的 `getaddrinfo` 对照。
:::
:::

::: method 回忆 12 · epoll 边沿触发的三条纪律
边沿触发与水平触发的差别是什么？为什么 ET 必须配非阻塞 fd？读侧与写侧各要守住什么？监听 fd 也要 ET 吗？

::: sol 答案
水平触发（LT，默认）只要缓冲区还有数据，下一次 `epoll_wait` 还会报告；边沿触发（ET）只在状态变化时报告一次。ET 下最后一次 `read` 必须返回 `EAGAIN`，才能确认「读干净了」；如果 fd 是阻塞的，这个 `read` 会永远等下去，整个事件循环卡死，所以 ET + 非阻塞是绑定的组合。读侧纪律：循环 `read` 到 `EAGAIN`，处理 `0`（EOF/`EPOLLRDHUP`）与其他错误；写侧纪律：`write` 短写或 `EAGAIN` 时把剩余字节留在用户态缓冲，注册 `EPOLLOUT`，写完再取消。监听 fd 用 ET 时，也要在一次事件里 `accept4` 到 `EAGAIN`，否则会漏掉新连接。多线程下用 `EPOLLONESHOT` 保证一条连接同一时刻只被一个线程处理。`epoll` 省的是「每次把整张监视表拷进内核再扫描」，不是省掉用户态处理成本。
:::
:::

::: method 回忆 13 · 手写 HTTP 客户端怎样切响应
`send_all` 之后，客户端怎样知道响应头结束？body 长度怎么定？没有 `Content-Length` 时怎么办？`strtok` 解析头有什么副作用？

::: sol 答案
先发请求（带 `Host` 与 `Connection: close`），然后循环 `read` 到 EOF 或缓冲区上限；用 `strstr(resp, "\r\n\r\n")` 找头与 body 的分界，body 从空行后 4 字节开始。逐行扫头，大小写不敏感地找 `Content-Length`：有就按它截断（可能小于已读字节数），没有就保留到 EOF。若响应是 chunked，则不能按 EOF 当 body 结束去解码，要按块长循环读十六进制长度、数据与 CRLF，最后读长度为 0 的块；`HEAD`、`204`、`304` 即使有 `Content-Length` 也没有 body。`strtok` 会把分隔符改写成 `\0`，破坏原缓冲区；只用于打印可以，真实解析应改成不修改数据的扫描（记录偏移与长度）。还要设响应上限（示例是 1 MiB），防止恶意或错误的服务端把内存吃光。
:::
:::

## C. 证据、队列与跨平台

::: method 回忆 14 · `ss` 的四个数字与状态列
监听 socket 与连接 socket 上，`Recv-Q`/`Send-Q` 各表示什么？`SYN-SENT`、`CLOSE-WAIT`、`TIME-WAIT` 大量出现各说明什么？

::: sol 答案
监听 socket：`Recv-Q` 是 accept 队列里已完成三次握手、等待应用 `accept` 的连接数；`Send-Q` 是 backlog 上限。连接 socket：`Recv-Q` 是接收缓冲区里还没被应用读走的字节数；`Send-Q` 是发送缓冲区里还没被对端确认（或还没发出）的字节数。状态列：大量 `SYN-SENT` 说明对端不回 SYN+ACK（防火墙、路由、端口未监听）；大量 `CLOSE-WAIT` 说明对端已发 FIN、本端应用没有 `close`，fd 一直占着；大量 `TIME-WAIT` 说明本机主动关闭了大量短连接。`SYN-RECV` 堆积与 SYN flood 或半连接队列有关；`FIN-WAIT-2` 卡住说明对端没发最后的 FIN。`ss -s` 给汇总，`ss -tanp` 带进程（能否看到 pid 取决于权限与是否同用户）。
:::
:::

::: method 回忆 15 · 用 `ss` 与 `nstat` 看 backlog 溢出
怎样制造一次 accept 队列溢出？`ss` 与 `nstat` 各看哪两个字段？本书 VM 上的读数是什么形状？

::: sol 答案
用 Python 起一个 `listen(1)` 的服务器，`bind` 到 `127.0.0.1`，然后睡 15 秒不 `accept`；另一端并发发起几十条 `connect`。`ss -lnt '( sport = :端口 )'` 看 `Recv-Q`（当前排队）与 `Send-Q`（backlog 上限）；`nstat -az | grep -E 'ListenOverflows|ListenDrops'` 看溢出与丢弃计数（`-z` 让零计数也显示，`-a` 忽略历史、直接给累计值）。本书 VM 实测：`listen(1)` 时 `Recv-Q 0 / Send-Q 1`；发起 20 条连接后前 2 条完成、第 3 条 2 秒超时，`Recv-Q 2 / Send-Q 1`，`TcpExtListenOverflows` 与 `TcpExtListenDrops` 各为 2。判据不是这几个具体数字，而是三条形状：`Recv-Q` 可以超过 `Send-Q`、客户端表现为超时而不是 `ECONNREFUSED`、溢出计数增长。调大 `backlog` 与 `net.core.somaxconn` 只是缓冲；根本办法是让 `accept` 循环不被业务阻塞。
:::
:::

::: method 回忆 16 · `TIME_WAIT` 与 `SO_REUSEADDR` 的实测
`TIME_WAIT` 出现在哪一方、持续多久？服务器重启时为什么 `bind` 失败？加 `SO_REUSEADDR` 后为什么就好了？它救不了哪种情况？

::: sol 答案
`TIME_WAIT` 出现在主动关闭方，Linux 持续约 60 秒（2×MSL）；它保证最后一个 ACK 丢失时还能重发，并让旧连接的迷路报文在网络中消散。服务器重启时，旧连接还在 `TIME_WAIT`，端口仍被占用，`bind` 返回 `EADDRINUSE`。`SO_REUSEADDR` 允许绑定这个处于 `TIME_WAIT` 的本地地址，所以能启动；它必须在 `bind` 之前设置。本书 VM 实测：服务器主动关闭一条连接后立刻重绑同一端口，不带选项返回 `EADDRINUSE`（98），带上 `SO_REUSEADDR` 就成功；`ss -tan state time-wait | wc -l` 能看到残留条目。它救不了「另一个进程正在 `LISTEN` 同一端口」的情况，那种情况只能换端口或停掉占用者；它也不减少 `TIME_WAIT` 的数量，只是让重启不被它挡住。
:::
:::

::: method 回忆 17 · Linux 与 macOS 的 socket 差异
`EAGAIN` 在两边各是多少？`MSG_NOSIGNAL` 呢？`IPV6_V6ONLY` 的默认值一样吗？macOS 上哪些本章证据拿不到？

::: sol 答案
`EAGAIN` 在 Linux 是 11，macOS 是 35；`EWOULDBLOCK` 在 Linux 与 `EAGAIN` 同值，别处未必，比较一律用宏。`MSG_NOSIGNAL` 两边都有但数值不同：本书 Linux 实测 16384，macOS 实测 524288。`IPV6_V6ONLY` 的默认值在本书 VM 与本机 macOS 实测都是 0（绑 `::` 能收 IPv4），但这是默认值，不是保证，服务端要显式设置。macOS 没有 `/proc`：`/proc/<pid>/fd`、`/proc/self/io` 这类证据拿不到；`tcpdump` 需要 `CAP_NET_RAW`，本书 VM 上 `sudo` 不可用，所以本章的抓包输出按形状示例读。Python 在 macOS 上没有导出 `SO_NOSIGPIPE`，但 C 头文件里有；不要用「Python 里没有」推断「系统不支持」。
:::
:::

::: method 回忆 18 · 十三条陷阱里的六条
从 1.11.17 里任选六条，说出「现象 → 原因 → 修复」。至少包含一条生命周期、一条边界、一条返回值。

::: sol 答案
① 服务重启 `bind: Address already in use` → 旧连接在 `TIME_WAIT` → `bind` 前设 `SO_REUSEADDR`，并确认没有别的进程在 `LISTEN`。② 请求被截断 → 一次 `read` 当完整请求 → 按 `\r\n\r\n` 与 `Content-Length` 循环读。③ 响应尾部丢失 → 对端关闭前没读完，或短写没补 → 读到 EOF 或按长度读满，写循环处理短写。④ 大响应卡住 → 非阻塞写返回 `EAGAIN` 后没等 `EPOLLOUT` → 保留剩余字节并注册可写事件。⑤ 路径穿越读到 `/etc/passwd` → URI 未规范化，`..` 与百分号编码都能绕过字符串检查 → 解码后 `realpath` 并校验前缀，或 `openat` + `O_NOFOLLOW`。⑥ 进程偶发退出、退出码 141 → 向已关闭连接写触发 `SIGPIPE` → 忽略信号或用 `MSG_NOSIGNAL`，把 `EPIPE` 当正常关闭。其余七条：`accept` 后 `EMFILE` 空转、`SO_LINGER=0` 导致 RST、浏览器因缺 `Content-Length` 卡住、中文 URL 未解码 404、只监听 `0.0.0.0` 导致 IPv6 连不上、`select`/`poll` 线性扫描导致连接一多就慢、`send` 成功但对方没收到。
:::
:::
