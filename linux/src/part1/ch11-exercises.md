# 1.11 习题集

三组分层：**A 组概念判断**考「会读、会判、会说理由」；**B 组诊断推理**给现象让你判连接状态、字节边界与返回值；**C 组动手实验**在 Ubuntu 24.04 上免 `sudo` 复现本章的关键证据。**全部附解答与判据**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；A 组要求口述或写一段完整因果，B 组要求写成「现象 → 机制 → 证据 → 修法」四段。
2. 卡住了回对应小节的「即时自测」重读，不要直接看答案；A 组对应 1.11.1–1.11.10，B 组对应 1.11.4–1.11.17，C 组对应 1.11.15–1.11.16。
3. C 组的命令都在本书的 Ubuntu 24.04.5 虚拟机（aarch64、内核 7.0.0-38-generic、GCC 13.3.0）上跑过；标注「VM 实测」的是这台机器的读数。`ss`、`nc`、`curl`、`getent`、`nstat`、`python3` 可用。
4. **`sudo` 不可用**：`tcpdump` 需要 `CAP_NET_RAW`，本章实验不用它；C1–C4 全部用 Python 与 `ss`/`nstat` 完成，不需要 root。端口用 19000 以上，避免与系统服务冲突。
5. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch11-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 1.11-A1 · 四元组与两种 socket {#ex-1.11-A1}

一条 TCP 连接由哪四样东西唯一确定？监听 socket 与 `accept` 返回的连接 socket 各绑定了什么？为什么同一台机器能用 8080 端口同时服务上万条连接？对监听 fd 直接 `read` 会怎样？

::: sol 解答

四元组是「源 IP、源端口、目的 IP、目的端口」，再加协议（TCP/UDP）区分同一对端口上的不同协议。监听 socket 只绑定「本地 IP:端口」，不绑定对端，所以它无法区分两个客户端；`accept` 返回的新 fd 绑定完整四元组，并保留独立的连接状态。内核收到段时用四元组查连接表，才知道字节属于哪条连接；因此并发上限靠的是四元组组合，不是端口数量。对监听 fd 直接 `read` 会失败（Linux 返回 `ENOTCONN`），监听 fd 的职责只有 `accept`。新 fd 不继承监听 fd 的 `O_NONBLOCK`，要非阻塞就用 `accept4(..., SOCK_NONBLOCK | SOCK_CLOEXEC)`。

**判据**：四元组四个成分齐全并提到协议；能说清监听 socket 只绑本地、连接 socket 绑完整四元组；能解释「为什么不是多个端口」；能指出对监听 fd `read` 失败。

:::
:::

::: ex 例 1.11-A2 · backlog、两个队列与 `ss` 的数字 {#ex-1.11-A2}

`listen(fd, backlog)` 限制的是哪个队列？三次握手过程中连接在两个队列之间怎样移动？`ss -lnt` 的 `Recv-Q` 与 `Send-Q` 分别是什么？队列满了客户端看到「拒绝」还是「慢」？

::: sol 解答

`backlog` 限制全连接队列（accept queue）的长度，实际值还受 `net.core.somaxconn` 约束。客户端发 SYN 后连接先进入半连接队列（SYN queue），服务器回 SYN+ACK；客户端回 ACK 后移入全连接队列，等待 `accept` 取走。`ss -lnt` 在监听 socket 上：`Recv-Q` 是当前已完成握手、等待 `accept` 的连接数，`Send-Q` 是 backlog 上限；在连接 socket 上则分别是接收缓冲区未读字节数与发送缓冲区未确认字节数。队列满时 Linux 默认丢弃或忽略 ACK，客户端重传，所以表现为「连接慢/超时」，不是明确的拒绝。本书 VM 实测：`listen(1)` 显示 `Recv-Q 0 / Send-Q 1`；20 条并发连接中前 2 条完成、第 3 条 2 秒超时，此时 `Recv-Q 2 / Send-Q 1`，`TcpExtListenOverflows`/`TcpExtListenDrops` 各增长 2。

**判据**：说对「全连接队列」而不是 SYN 队列；两个数字的两套含义都说对；能解释「慢而不是拒」；知道 `Recv-Q` 可以超过 `Send-Q`。

:::
:::

::: ex 例 1.11-A3 · `getaddrinfo` 的输入与 flags {#ex-1.11-A3}

`struct addrinfo` 哪四个字段是输入？`AI_PASSIVE`、`AI_NUMERICHOST`、`AI_ADDRCONFIG`、`AI_V4MAPPED` 各改变什么？失败时为什么不能只看 `errno`？服务器与客户端的标准写法各是什么？

::: sol 解答

输入是 `ai_flags`、`ai_family`、`ai_socktype`、`ai_protocol`；其余是输出。`AI_PASSIVE`：`node == NULL` 时返回通配地址（`0.0.0.0` 与 `::`），服务器 `bind` 前用；客户端误用会连到 `0.0.0.0`。`AI_NUMERICHOST`：禁止 DNS，传域名返回 `EAI_NONAME`；常与 `AI_NUMERICSERV` 一起用。`AI_ADDRCONFIG`：只返回本机已配置的地址族，容器只有 loopback 时可能什么都不返回。`AI_V4MAPPED`：IPv6 查询无结果时返回 `::ffff:a.b.c.d`，需与 `AF_INET6` 同用。失败返回 `EAI_*` 码，`errno` 只在 `EAI_SYSTEM` 时有意义：`EAI_AGAIN` 退避重试，`EAI_NONAME` 不重试。服务器写法是 `AF_UNSPEC` + `AI_PASSIVE` + `node = NULL`，逐个候选 `socket`/`bind`/`listen`；客户端是 `AF_UNSPEC` + 逐个候选 `connect`，成功即停。VM 实测：`AI_PASSIVE` + `NULL` 返回 `0.0.0.0:8080` 与 `[::]:8080`；域名加 `AI_NUMERICHOST` 返回 `-2`。

**判据**：四个输入字段写全；四个 flag 都说对方向；知道 `EAI_*` 与 `errno` 的分工；两端写法各给一条。

:::
:::

::: ex 例 1.11-A4 · HTTP 的四种 body 边界 {#ex-1.11-A4}

HTTP 响应 body 何时结束？chunked 的块长是什么进制、以什么结束？`HEAD`/`204`/`304` 为什么特殊？请求侧怎样切出 body？头与 body 的分界是什么？

::: sol 解答

四种边界：① `Content-Length`，按字节数读满；② `Transfer-Encoding: chunked`，读十六进制块长 + CRLF、块数据 + CRLF，块长 0 结束，可跟 trailer 与空行；③ 两者都没有，以连接关闭（EOF）为界，HTTP/1.0 风格；④ `HEAD`、`204`、`304` 没有 body，即使有 `Content-Length` 也不读。请求侧是请求行 + 头 + 空行；有 body 时看 `Content-Length` 或 chunked。头与 body 的分界是 `\r\n\r\n`，不是 `\n\n`。HTTP/1.1 默认持久连接，所以没有长度就必须 chunked 或显式 `Connection: close`。chunked 的块长用 `strtoul(s, NULL, 16)`，不要用 `atoi`；`Content-Length` 要设上限并与实际读取量核对。

**判据**：四种边界齐全；chunked 是十六进制且 0 结束；无 body 状态至少说两个；分界写成 `\r\n\r\n`；知道 HTTP/1.1 默认 keep-alive。

:::
:::

::: ex 例 1.11-A5 · `SO_REUSEADDR`、`SO_REUSEPORT` 与 `SO_LINGER` {#ex-1.11-A5}

三个选项各改什么？`SO_REUSEADDR` 为什么必须在 `bind` 前设置、它救不了哪种情况？`SO_REUSEPORT` 需要什么条件、连接会迁移吗？`SO_LINGER = {1, 0}` 的 `close` 发什么、对端看到什么？

::: sol 解答

`SO_REUSEADDR` 允许 `bind` 处于 `TIME_WAIT` 的本地地址，解决重启时的 `EADDRINUSE`；它在 `bind` 时检查，所以必须提前设置。它只对「同一地址、`TIME_WAIT`」有效，另一个进程正在 `LISTEN` 同一端口时仍然失败。`SO_REUSEPORT` 让同一 uid 的多个 socket 绑定完全相同的地址和端口，内核按四元组哈希把**新连接**分给其中一个；所有 socket 都要设置，已有连接固定不动，不会迁移。`SO_LINGER = {1, 0}` 让 `close` 立刻发 RST 并丢弃发送缓冲区里未发出的数据；对端 `recv` 得到 `ECONNRESET`（VM 实测 errno 104）。`{1, >0}` 则阻塞到数据发完或超时。`TCP_NODELAY` 关闭 Nagle，交互式协议用；大块传输保持默认。

**判据**：三者的作用域说清（地址复用 / 端口共享 / 关闭语义）；`bind` 前设置与「救不了 LISTEN」两点都在；`SO_REUSEPORT` 的「同 uid、所有 socket、只影响新连接」至少说两点；RST 与 `ECONNRESET` 对上。

:::
:::

::: ex 例 1.11-A6 · TCP 还是 UDP，MSS 怎么算 {#ex-1.11-A6}

按连接、可靠性、边界、拥塞控制、首部五项对比 TCP 与 UDP。MTU 1500 下 IPv4 与 IPv6 的 TCP MSS 各是多少？UDP 的 `sendto` 返回成功说明什么？什么场景该选 UDP？

::: sol 解答

TCP 面向连接、有确认/重传/有序、无消息边界、有拥塞控制、首部 20 字节起；UDP 无连接、不保证到达/顺序/去重、保留数据报边界、无拥塞控制、首部 8 字节。以太网 MTU 1500：IPv4 首部 20 + TCP 首部 20，MSS = 1460；IPv6 首部 40，MSS = 1440。`sendto` 成功只表示数据交给了本机网络栈，不代表对端收到；要可靠性就在应用层做序号、确认、重传，或者用 QUIC。选 UDP 的场景：DNS 这种一问一答、丢了重问成本低；音视频与游戏这种过期数据没有价值、宁愿丢也不愿等重传；QUIC 在 UDP 上自己实现可靠传输与拥塞控制。选 TCP 的场景：HTTP/SSH/数据库这种不能丢字节、需要有序的协议。

**判据**：五项对比不缺；MSS 两个数都算对（1460/1440）；`sendto` 的「本机栈」边界说清；UDP 场景给至少两个并说明理由。

:::
:::

## B 组 · 诊断推理

::: ex 例 1.11-B1 · 解析器偶发「unexpected end of JSON」 {#ex-1.11-B1}

一个 TCP 客户端用 `read(fd, buf, 4096)` 读一行 JSON，读到 100 字节就交给解析器，偶尔报「unexpected end of JSON」。写出「现象 → 机制 → 证据 → 修法」四段。

::: sol B1 核对

现象是解析器偶尔拿到半条报文。机制是短读：TCP 是有序字节流，`read` 只保证返回「当前可用的至少 1 字节」，不保证填满 4096；100 字节可能只是前半段，后半段还在路上。证据：`strace -e trace=read -s 64 ./client` 会看到一次 `read` 返回 100、下一次才拿到剩余；`ss -tan` 看该连接 `Recv-Q` 是否还有未读字节。修法：维护用户态缓冲，循环读到「换行」或「长度前缀」给出的完整边界；每次 `read` 处理 `0`（EOF）、`-1/EINTR`（重试）、`-1/EAGAIN`（等可读事件）；不要假设一次 `read` 等于一条消息。若协议本身没有边界，先改协议（长度前缀或换行），再谈解析。

**判据**：把「短读」与「TCP 无消息边界」连起来；证据命令能复现；修法同时处理边界与 `EINTR`/`EAGAIN`。

:::
:::

::: ex 例 1.11-B2 · 重启后 `bind: Address already in use` {#ex-1.11-B2}

服务用 `Ctrl-C` 停掉后立刻重启，报 `bind: Address already in use`。是 `TIME_WAIT` 还是端口被别的进程占着？各用什么命令确认？两种情况的修法分别是什么？

::: sol B2 核对

先分清两种原因。`TIME_WAIT`：`ss -tan state time-wait '( sport = :8080 )'` 能看到条目；本书 VM 实测，服务器主动关闭后立刻重绑，不带选项返回 `EADDRINUSE`（98），带 `SO_REUSEADDR` 就成功。另一个进程 `LISTEN`：`ss -lntp '( sport = :8080 )'` 能看到监听条目与 pid（能否看到 pid 取决于权限与是否同用户），这时 `SO_REUSEADDR` 无效。修法：前者在 `socket` 之后、`bind` 之前设 `setsockopt(SOL_SOCKET, SO_REUSEADDR, &on, sizeof on)`；后者停掉占用进程或换端口。`SO_REUSEADDR` 不减少 `TIME_WAIT` 数量，只是允许绑定；也不要靠调 `tcp_fin_timeout` 或 `tcp_tw_reuse` 当常规手段（需要 root，且语义不同）。

**判据**：能用两条 `ss` 命令区分两种原因；修法分别给对；知道 `SO_REUSEADDR` 必须在 `bind` 前设置。

:::
:::

::: ex 例 1.11-B3 · `curl` 正常，浏览器一直转圈 {#ex-1.11-B3}

同一个 URL，`curl -v` 能拿到内容，浏览器却一直转圈直到超时。最可能缺哪个头？为什么 `curl` 没暴露问题？怎么改？

::: sol B3 核对

最可能是响应没有 `Content-Length`，也不是 chunked，而 HTTP/1.1 默认持久连接：浏览器不知道 body 在哪里结束，只能等连接关闭或超时。`curl` 在 `Connection: close` 或服务端关闭后读到 EOF，就把已有字节当完整 body，所以看起来正常。证据：`curl -v` 的响应头里没有 `Content-Length`、没有 `Transfer-Encoding`，连接也没有立刻关；`curl -v --max-time 3` 可能显示「Operation timed out」。修法三选一：给出准确的 `Content-Length`；改用 chunked；显式 `Connection: close`（放弃 keep-alive）。生产上优先前两种，第三种会让每个请求都新建连接。

**判据**：指出「缺 `Content-Length` + HTTP/1.1 默认 keep-alive」；解释 `curl` 为什么没暴露（EOF 当边界）；三种修法至少给两种。

:::
:::

::: ex 例 1.11-B4 · 服务器进程偶尔退出，退出码 141 {#ex-1.11-B4}

一个 HTTP 服务器在客户端提前断开时偶尔直接退出，日志停在 `write` 附近，退出码 141。解释原因，给出两种修法，并说明为什么不是「写失败返回 -1 就没事了」。

::: sol B4 核对

141 = 128 + 13，13 是 `SIGPIPE`。向已关闭的 socket 写时，内核先发 `SIGPIPE`；默认动作是终止进程，所以代码根本没机会看到 `write` 的返回值。VM 实测 `yes | head -1` 的 `PIPESTATUS[0]` 就是 141。修法一：进程启动时 `signal(SIGPIPE, SIG_IGN)`，之后 `write` 返回 -1/`EPIPE`（32），按「对端走了」处理；修法二：用 `send(fd, buf, n, MSG_NOSIGNAL)`，只对这次发送抑制信号（Linux 常量 16384）。BSD/macOS 传统上用 `SO_NOSIGPIPE` 选项，macOS 也定义了 `MSG_NOSIGNAL`（实测 524288），跨平台要条件编译。不是「返回 -1 就没事」：默认处置下进程已经死了；即使忽略了信号，也要把 `EPIPE` 与 `EAGAIN`、`EINTR` 分开处理。

**判据**：141 与 `SIGPIPE` 对上；两种修法都给；知道默认处置下 `write` 不返回；能区分 `EPIPE` 与 `EAGAIN`。

:::
:::

::: ex 例 1.11-B5 · IPv4 能连，IPv6 连不上 {#ex-1.11-B5}

服务只写了 `addr.sin_addr.s_addr = htonl(INADDR_ANY)`，监听 `0.0.0.0:8080`。用户的 IPv6 客户端连不上，但 `curl http://127.0.0.1:8080` 正常。原因是什么？怎样改成双栈？容器里 `AI_ADDRCONFIG` 又会带来什么坑？

::: sol B5 核对

`0.0.0.0` 是 IPv4 通配地址，只接受 IPv4 连接；IPv6 客户端连 `::1` 或公网 IPv6 地址时，本机没有对应的监听。证据：`ss -lnt '( sport = :8080 )'` 只看到 `0.0.0.0:8080`；`getent ahosts 主机名` 显示 AAAA 记录；`curl -6` 直接失败。改法：用 `getaddrinfo(NULL, "8080", AF_UNSPEC + AI_PASSIVE)` 拿候选，优先绑 `::` 并显式设 `IPV6_V6ONLY=0`，这样双栈 socket 同时收 IPv4 映射地址；或者分别绑 `::` 与 `0.0.0.0` 两个 socket（注意同一端口上两种布局会冲突）。VM 实测 `IPV6_V6ONLY` 默认 0，绑 `::` 后 `127.0.0.1` 能连上；把它设为 1 后 IPv4 连接返回 `ECONNREFUSED`（111）。容器坑：`AI_ADDRCONFIG` 只返回本机已配置的地址族，容器常只有 `lo` 与一个 IPv4 地址，`AF_INET6` 结果被过滤，`curl -6` 失败；排查时用不带该 flag 的解析对照。

**判据**：指出 `0.0.0.0` 只收 IPv4；双栈方案给出 `::` + `IPV6_V6ONLY` 或两个 socket；`AI_ADDRCONFIG` 的容器行为说清。

:::
:::

::: ex 例 1.11-B6 · epoll 服务器有空闲连接却收不到数据 {#ex-1.11-B6}

一个边沿触发的 epoll 服务器，压测时偶发某条连接「卡住」：客户端发了数据，服务器不再读，`ss` 里该连接 `Recv-Q` 非零，但 CPU 接近 0。原因是什么？怎样证明？修法是什么？

::: sol B6 核对

边沿触发只在状态变化时报告一次。如果 `handle_read` 只 `read` 一次就回去等事件，缓冲区里剩下的数据不会再触发 `EPOLLIN`，连接就挂住；`Recv-Q` 非零、CPU 为 0 正是这个形状。另一个可能：fd 是阻塞的，读循环卡在最后一次 `read` 上，整个事件循环不转（这时 CPU 也接近 0，但所有连接都停）。证据：`ss -tan` 看该连接 `Recv-Q`；`strace -p <pid> -e trace=epoll_wait,read` 看是否只读了一次就回到 `epoll_wait`；在代码里统计每次事件的读取字节数与 `EAGAIN` 次数。修法：fd 用 `SOCK_NONBLOCK`（`accept4` 一次设好），读循环一直读到 `-1/EAGAIN` 才返回；`0` 表示 EOF，其他错误关闭；监听 fd 也要 `accept` 到 `EAGAIN`。写侧同理：`EAGAIN` 时保留剩余字节并注册 `EPOLLOUT`，写完取消。

**判据**：把「ET 只报一次」与「没读到 EAGAIN」连起来；能用 `Recv-Q` 与 `strace` 给出证据；修法同时覆盖读循环、非阻塞 fd 与监听 fd。

:::
:::

## C 组 · 动手实验

::: ex 例 1.11-C1 · 制造 accept 队列溢出：`ss` 与 `nstat` 的证据 {#ex-1.11-C1}

写一个 `listen(1)` 的服务器，故意不 `accept`，并发发起 20 条连接。用 `ss -lnt` 看 `Recv-Q`/`Send-Q`，用 `nstat -az` 看溢出计数。记录你自己机器的数，解释「为什么是超时而不是拒绝」。

::: sol C1 核对

```python
# lab1c11_backlog.py：listen(1) 后不 accept，制造队列溢出
import socket, subprocess, time

srv = socket.socket()
srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
srv.bind(("127.0.0.1", 19003))
srv.listen(1)                      # backlog = 1

def show(tag):
    out = subprocess.run(["ss", "-lnt", "( sport = :19003 )"],
                         capture_output=True, text=True).stdout
    print(f"--- {tag} ---\n{out}", end="")

show("after listen(1)")
cs = []
for i in range(20):
    c = socket.socket()
    c.settimeout(2)
    try:
        c.connect(("127.0.0.1", 19003))
        cs.append(c)
    except OSError as e:
        print("connect fail at", i, e)
        break
print("connected", len(cs))
show("with pending connections")
time.sleep(0.5)
```

```bash
nstat -az | grep -E 'ListenOverflows|ListenDrops'
```

VM 实测（一次运行）：`listen(1)` 后是 `Recv-Q 0 / Send-Q 1`；`connected 2`，第 3 条在 2 秒后超时；此时 `Recv-Q 2 / Send-Q 1`；`TcpExtListenOverflows` 与 `TcpExtListenDrops` 各为 2。原因：全连接队列满后内核丢弃或忽略 ACK，客户端按 SYN 重传退避等待，所以表现为超时；只有端口没人监听时才会立刻 `ECONNREFUSED`。数字会随内核版本、`somaxconn` 与重传策略变化，判据是三条形状：`Recv-Q` 超过 `Send-Q`、连接超时、溢出计数增长。`nstat -az` 里 `-z` 让零计数也显示，`-a` 忽略历史、直接给累计值，便于做前后差。

**判据**：能复现「`Recv-Q` 超过 `Send-Q`」；能说出第几条连接开始超时（不必等于 3）；`nstat` 计数有增长；能解释「慢而不是拒」。无需 `sudo`。

:::
:::

::: ex 例 1.11-C2 · `TIME_WAIT` 与 `SO_REUSEADDR` {#ex-1.11-C2}

让服务器主动关闭一条连接，留下 `TIME_WAIT`；然后立刻在同一端口重绑，分别试「不带选项」与「带 `SO_REUSEADDR`」。预期各是什么？用 `ss` 确认 `TIME_WAIT` 条目。

::: sol C2 核对

```python
# lab1c11_timewait.py
import socket, errno, time

def once(reuse):
    s = socket.socket()
    if reuse:
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind(("127.0.0.1", 19004))
    s.listen(5)
    cli = socket.create_connection(("127.0.0.1", 19004))
    cli.sendall(b"x")
    conn, _ = s.accept()           # 服务器先 close，成为主动关闭方
    conn.recv(10)
    conn.close()
    s.close()
    return cli

once(True)
time.sleep(0.3)
try:
    s = socket.socket()
    s.bind(("127.0.0.1", 19004))
    print("rebind without REUSEADDR: OK")
    s.close()
except OSError as e:
    print("rebind without REUSEADDR:", e.errno, errno.errorcode.get(e.errno))
try:
    s = socket.socket()
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind(("127.0.0.1", 19004))
    print("rebind with REUSEADDR: OK")
    s.close()
except OSError as e:
    print("rebind with REUSEADDR:", e.errno, errno.errorcode.get(e.errno))
```

```bash
ss -tan state time-wait | wc -l
```

VM 实测：不带选项得到 `98 EADDRINUSE`；带 `SO_REUSEADDR` 得到 `OK`；`time-wait` 状态计数为 2（包含本实验与其他残留条目，不是承诺值）。机制：`TIME_WAIT` 出现在主动关闭方，Linux 约 60 秒，期间端口仍被占用；`SO_REUSEADDR` 允许绑定这个处于 `TIME_WAIT` 的本地地址。再做一组对照：另起一个进程保持 `LISTEN` 同一端口，此时带 `SO_REUSEADDR` 也会 `EADDRINUSE`——它救不了「别人正在监听」。

**判据**：两种重绑结果相反（98 与成功）；能用 `ss` 看到 `time-wait` 条目；能区分「`TIME_WAIT` 占用」与「进程正在 `LISTEN`」。无需 `sudo`。

:::
:::

::: ex 例 1.11-C3 · IPv6 双栈：`IPV6_V6ONLY` 的默认值与两种布局 {#ex-1.11-C3}

绑一个 `AF_INET6` 的 `::` socket，读 `IPV6_V6ONLY` 的默认值，再用 IPv4 地址 `127.0.0.1` 连它。然后把选项设为 1 重试。两次结果各说明什么？

::: sol C3 核对

```python
# lab1c11_v6only.py
import socket, errno

def probe(v6only):
    s = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)
    print("IPV6_V6ONLY default =",
          s.getsockopt(socket.IPPROTO_IPV6, socket.IPV6_V6ONLY),
          "-> set", v6only)
    s.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_V6ONLY, v6only)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind(("::", 19008))
    s.listen(1)
    try:
        c = socket.create_connection(("127.0.0.1", 19008), timeout=2)
        print("IPv4 connect: OK, peer =", c.getpeername())
        c.close()
    except OSError as e:
        print("IPv4 connect:", e.errno, errno.errorcode.get(e.errno))
    s.close()

probe(0)
probe(1)
```

VM 实测（Ubuntu 24.04.5、内核 7.0.0-38）：默认值是 0；设 0 时 IPv4 连接成功，peer 显示为 `('127.0.0.1', 19008)`；设 1 时 IPv4 连接返回 `111 ECONNREFUSED`。本机 macOS 的默认值实测也是 0，但这是默认值，不是保证——容器运行时与部分发行版会设 1，服务端要显式设置。两种布局只能选一种：双栈 `::`（`V6ONLY=0`）或 `::` + `0.0.0.0` 两个 socket；同一端口上混用会冲突。若你的机器默认是 1，`probe(0)` 那一步才是开启双栈的开关。

**判据**：读出默认值并记录；`V6ONLY=0` 时 IPv4 能连、`=1` 时被拒；能说出「默认值不可假设、程序要显式设置」。无需 `sudo`。

:::
:::

::: ex 例 1.11-C4 · 一次 `read` 只拿到半条请求 {#ex-1.11-C4}

客户端把一条 HTTP 请求分两次 `sendall`，中间睡 0.2 秒；服务器第一次 `recv(4096)` 会拿到多少？怎样证明「一次 `read` 不等于一条消息」，并写出读到 `\r\n\r\n` 为止的循环？

::: sol C4 核对

```python
# lab1c11_shortread.py
import socket, threading, time

srv = socket.socket()
srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
srv.bind(("127.0.0.1", 19013))
srv.listen(1)
result = {}

def server():
    c, _ = srv.accept()
    first = c.recv(4096)                 # 只读一次
    result["first"] = len(first)
    buf = first
    while b"\r\n\r\n" not in buf:        # 循环读到头的边界
        chunk = c.recv(4096)
        if not chunk:
            break
        buf += chunk
    result["total"] = len(buf)
    c.close()

t = threading.Thread(target=server)
t.start()
cli = socket.create_connection(("127.0.0.1", 19013))
cli.sendall(b"GET / HTTP/1.1\r\nHost: x\r\n")
time.sleep(0.2)
cli.sendall(b"\r\n")
t.join()
cli.close()
srv.close()
print("first read", result["first"], "total", result["total"])
```

VM 实测（连跑 3 次）：`first read 25, total 27`，三次一致——第一次只拿到 `GET / HTTP/1.1\r\nHost: x\r\n`（25 字节），最后的 `\r\n` 在第二次 `recv` 才到。这个实验说明：`read` 的返回值是「这次拿到了多少」，不是「报文有多长」；服务端必须循环读到协议边界（这里是 `\r\n\r\n`），并处理 `0`（EOF）、`-1/EINTR`、`-1/EAGAIN`。若把两次 `sendall` 的间隔去掉，内核可能合并成一个段，第一次就读到 27 字节——所以判据是「可能短读、必须循环」，不是固定数字。

**判据**：第一次 `recv` 小于总长度（或能解释合并的情况）；循环以 `\r\n\r\n` 为边界；能说出 `0`/`EINTR`/`EAGAIN` 三个分支。无需 `sudo`。

:::
:::
