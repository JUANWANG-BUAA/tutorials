# 项目 C · 网络主线：用户态 TCP/IP · 反向代理 · 抓包分析

<div class="chapter-index">
<div><span class="ci-label">项目目标</span><p>不借助 lwIP、HAProxy、tcpdump 的成品，用 C17 写出三个能互相验证的网络程序：一个跑在 TUN/TAP 上、能 ping、能传文件、能和 Linux 内核协议栈互通的用户态 TCP/IP 栈 <code>mytcp</code>；一个基于 epoll、带连接池、健康检查、超时与零拷贝的反向代理 <code>myproxy</code>；一个用 <code>AF_PACKET</code> 抓包、做流重组、导出 pcap 的分析器 <code>mysniff</code>。最后用 <code>mysniff</code> 解释 <code>myproxy</code> 转发给 <code>mytcp</code> 的每一个字节。</p></div>
<div><span class="ci-label">完成后你能</span><p>逐字段构造以太网、ARP、IPv4、ICMP、UDP、TCP 报文并手算校验和；实现三次握手、四次挥手、序号/确认、超时重传与滑动窗口，并解释每个状态迁移；用 epoll 写一个能扛 <code>wrk</code> 的 HTTP/1.1 反向代理，处理短读、短写、<code>EAGAIN</code>、<code>EPOLLRDHUP</code> 与优雅关闭；用 <code>AF_PACKET</code> 抓到本机流量、重组 TCP 流、写出能被 <code>tcpdump -r</code> 读回的 pcap；在 netns 里搭隔离实验台并完整清理。</p></div>
</div>

第 4 篇把协议讲清楚了：4.1 的分层与封装、4.2 的以太网与 ARP、4.3 的 IPv4 与 ICMP、4.4 的 UDP/TCP 首部、4.5 的握手挥手、4.6 的可靠传输、4.7 的 HTTP 与 TLS。读完这些章节，你能画出状态机，也能在 `tcpdump` 里认出每个字段。但「认得出」和「造得出」之间隔着一条很宽的沟：自己发一个 SYN，才知道校验和覆盖哪些字节；自己等一次重传，才知道 RTO 为什么不能拍脑袋定；自己写一个代理，才知道 `EAGAIN` 不是错误而是常态。

这一页就是把这条沟填上。三个子项目分工明确：

- `mytcp` 造**协议**：从 TAP 设备读以太网帧，逐层解析、逐层封装，最终对外提供一组最小的 socket API；
- `myproxy` 造**应用**：站在 TCP 之上，解析 HTTP/1.1，把请求转发给上游，处理连接复用、超时、重试与关闭；
- `mysniff` 造**证据**：不修改被测程序，从链路层旁路抓包，把前两者发出的字节翻译成可读的流与统计。

三者共享同一套字节序、首部布局与校验和知识。只会其中一个，排障时仍然只能猜：代理慢了，是客户端慢、上游慢、还是本机 TCP 在重传？`mysniff` 的流重组和 `mytcp` 的重传计数器会同时回答这个问题。

> 本页的协议栈核心（校验和、握手/挥手、数据收发、超时重传）已用 socketpair 冒充 TAP 做过用户态注入测试，测试代码随文给出；TAP 设备、netns、`AF_PACKET`、`epoll`、`splice` 这些依赖 Linux 内核的部分，写作环境（macOS）无法运行，**命令与预期输出均标「未实测」**，需要你在 Ubuntu 24.04 虚拟机里跑过之后再写进报告。

## C.0 总览与选做路线 {#sec-c.0}

三个子项目是一条**从协议到应用再到证据**的直线，不是三道并列的练习题。

<pre class="layout">
        ① 造协议                          ② 造应用                          ③ 造证据
┌────────────────────────┐      ┌────────────────────────┐      ┌────────────────────────┐
│        mytcp           │      │        myproxy         │      │        mysniff         │
│ TAP / 以太网 / ARP     │ HTTP │ epoll / HTTP 解析      │ 抓包 │ AF_PACKET / 解析       │
│ IPv4 / ICMP / UDP      │─────▶│ 连接池 / 负载均衡      │─────▶│ 流重组 / 统计          │
│ TCP 状态机 / 重传/窗口 │      │ 超时 / 重试 / 零拷贝   │      │ pcap 导出 / 对照       │
└───────────┬────────────┘      └───────────┬────────────┘      └───────────┬────────────┘
            │                               │                               │
            └──── 10.0.0.2:80 提供内容 ─────┴──── 每字节都能被解释 ──────────┘
                              C.4 把三条线接成一个可复现的演示
</pre>

读图抓两条箭头。第一条 `mytcp → myproxy`：代理的上游就是协议栈，代理发出的 SYN、数据段、FIN 全部由你自己写的代码处理，任何一个字段错了都会在代理侧表现为超时或 502。第二条 `myproxy → mysniff`：抓包点在上游链路（`tap0` 或 `br0`）上，能看到「代理以为发了」和「线上真的发了」的差别——这是排查代理类问题最有效的一组证据。

**为什么是这三个**：它们覆盖了网络工程的三层能力——协议实现、高并发服务、可观测性；而且依赖是单向的：`myproxy` 可以接真 nginx 做上游，`mysniff` 可以抓任何程序，只有 `mytcp` 必须自己从零写。这意味着你可以只做其中一两个而不烂尾。

| 子项目 | 难度 | 投入 | 前置章节 | 最小可交付 | Stage 数 |
|:--|:--|:--|:--|:--|--:|
| C.1 `mytcp` | ★★★★★ | 50–70 h | 4.2–4.6、[2.16](../part2/ch16.md)–[2.18](../part2/ch18.md) | ping 通、三次握手、TCP 回显、能传 10 MB 文件 | 8 |
| C.2 `myproxy` | ★★★☆ | 25–35 h | [2.16](../part2/ch16.md)–[2.18](../part2/ch18.md)、4.7 | HTTP 反代 + 连接池 + 健康检查 + `wrk` 报告 | 8 |
| C.3 `mysniff` | ★★★ | 15–25 h | 4.2–4.5、[2.18](../part2/ch18.md) | 抓包、解析 TCP/UDP、流重组、pcap 可被 tcpdump 读 | 6 |

### C.0.1 实验环境：一个 netns，两台「主机」 {#sec-c.0.1}

所有需要 root 的实验都放进两个 network namespace：`mtlab` 里放 `tap0` 与网桥，`mthost` 扮演 Linux 对端。这样既隔离，又不需要动宿主的路由和防火墙，删掉 namespace 就干净了。

```bash
# 需要 root；只在虚拟机/隔离环境执行
sudo ip netns add mtlab
sudo ip netns add mthost
sudo ip link add veth-a netns mtlab type veth peer name veth-b netns mthost
sudo ip netns exec mtlab ip tuntap add dev tap0 mode tap
sudo ip netns exec mtlab ip link add br0 type bridge
sudo ip netns exec mtlab ip link set tap0 master br0
sudo ip netns exec mtlab ip link set veth-a master br0
sudo ip netns exec mtlab ip link set br0 up
sudo ip netns exec mtlab ip link set tap0 up
sudo ip netns exec mtlab ip link set veth-a up
sudo ip netns exec mthost ip addr add 10.0.0.1/24 dev veth-b
sudo ip netns exec mthost ip link set veth-b up
sudo ip netns exec mthost ip link set lo up

# 看一眼拓扑
sudo ip netns exec mtlab ip -br link
sudo ip netns exec mthost ip -br addr
```

预期输出（未实测，Ubuntu 24.04）：

```text
br0              UP             9a:1c:...
tap0             UP             6e:22:...
veth-a@if3       UP             ca:44:...
lo               UNKNOWN        00:00:00:00:00:00
veth-b@if4       UP             10.0.0.1/24
```

**为什么必须用网桥**：本栈的 MAC 是自己定的（`02:00:00:00:00:02`），和 `tap0` 的 MAC 不同。如果直接把 `10.0.0.1/24` 配在 `tap0` 上，内核收到目的 MAC 不是本接口的帧会标成 `PACKET_OTHERHOST` 并在 IP 层丢弃——`ping` 永远不通。把 `tap0` 设成网桥端口后，网桥工作在混杂模式，会按目的 MAC 转发，帧才能进到我们的进程。这个坑在 Stage 6 还会再提一次。

清理：

```bash
# 删 namespace 会一并删掉里面的 veth、tap、bridge
sudo ip netns del mtlab
sudo ip netns del mthost
# 确认没有残留
ip netns list
ip link show type veth
```

> 三条安全红线：① 只在虚拟机里做，`ip netns`/`iptables` 写错会切断宿主的网络；② 不要对公网地址抓包或压测；③ `ip link del`、`ip netns del` 前先 `echo` 确认变量非空。

### C.0.2 难度、顺序与裁剪 {#sec-c.0.2}

| 你的目标 | 建议顺序 | 可以砍掉 |
|:--|:--|:--|
| 想懂协议怎么实现 | C.1 全部，C.3 Stage 0–2 当调试工具 | C.2 全部 |
| 想做后端/网关 | C.2 全部，C.1 Stage 0–3 理解握手 | C.1 Stage 4–7、C.3 Stage 2 以后 |
| 想做 SRE/排障 | C.3 全部 + C.1 Stage 0–2 + C.2 Stage 0/4 | C.1 Stage 5–7、C.2 Stage 5–7 |
| 全做（推荐） | C.1 → C.2 → C.3 → C.4 | 时间不够时每条只做到 Stage 4 |

三条裁剪原则与项目 A 相同：Stage 0–2 不能跳（编译、跑通、能验证是地基）；增强型 Stage 可以换序（C.1 的 Stage 7 与 Stage 6 互不依赖）；**压测与抓包不能省**，否则验收表里的「性能」「可观测」两栏就是 0 分。

### C.0.3 代码目录与构建基线 {#sec-c.0.3}

```text
mytcp/
├── Makefile
├── include/{net.h,stack.h,tap.h}
├── src/{net,eth,arp,ip,tcp,stack,tap,main}.c
├── tests/{test_net.c,test_tcp.c,test_retx.c,netns.sh}
└── docs/{design.md,stage-notes.md}
```

构建统一用工程手册里的模板（[工程手册](engineering.md)），本页只保留必要差异：`mytcp` 需要 `-D_GNU_SOURCE`（`TUNSETIFF`、`poll`），测试目标分两类——`make test` 跑不需要 root 的单元测试，`make test-net` 跑 netns 集成测试。

```makefile
# mytcp/Makefile
CC      ?= cc
CFLAGS  ?= -std=c17 -D_GNU_SOURCE -Wall -Wextra -Wpedantic -Werror -O2 -g
BIN     := build/mytcp
SRCS    := $(wildcard src/*.c)
OBJS    := $(SRCS:src/%.c=build/%.o)
TESTS   := build/test_net build/test_tcp build/test_retx

all: $(BIN)
$(BIN): $(OBJS)
	@mkdir -p build
	$(CC) $(CFLAGS) -o $@ $^
build/%.o: src/%.c
	@mkdir -p build
	$(CC) $(CFLAGS) -MMD -MP -c -o $@ $<
-include $(OBJS:.o=.d)

build/test_net: tests/test_net.c src/net.c
	@mkdir -p build
	$(CC) $(CFLAGS) -Iinclude $^ -o $@
build/test_tcp: tests/test_tcp.c src/net.c src/eth.c src/arp.c src/ip.c src/tcp.c src/stack.c
	@mkdir -p build
	$(CC) $(CFLAGS) -Iinclude $^ -o $@
build/test_retx: tests/test_retx.c src/net.c src/eth.c src/arp.c src/ip.c src/tcp.c src/stack.c
	@mkdir -p build
	$(CC) $(CFLAGS) -Iinclude $^ -o $@

test: $(TESTS)
	@for t in $(TESTS); do echo "== $$t"; ./$$t || exit 1; done
test-net: all
	sudo tests/netns.sh
clean:
	rm -rf build
.PHONY: all test test-net clean
```

注意 `test_tcp`/`test_retx` 不链接 `tap.c`，测试文件自己提供 `tap_read`/`tap_write` 的假实现（socketpair），所以**不需要 root、不需要 TAP** 就能验证状态机。这是本页最重要的测试设计：把「协议逻辑」和「设备 I/O」切开，前者可在任何 POSIX 系统上测，后者才需要 Linux。

## C.1 用户态 TCP/IP：`mytcp` {#sec-c.1}

### C.1.1 目标与真实对应物 {#sec-c.1.1}

`mytcp` 对应 lwIP（嵌入式）、gVisor 的 netstack（用户态内核）、以及 Linux 的 `net/ipv4`。我们不追求完整：不做 IPv6、不做分片重组、不做 SACK、不做拥塞控制（Stage 7 加一个简化版）、不做窗口缩放。**做的是让一条 TCP 连接真的能建立、能传数据、能体面地关闭，并且能被 Linux 协议栈接受。**

验收的最终形态（Stage 6 之后）：

```bash
# 需要 root；mthost 是 Linux 对端
sudo ip netns exec mthost ping -c3 10.0.0.2
sudo ip netns exec mthost curl -s http://10.0.0.2/          # 需要 --http 模式
sudo ip netns exec mthost dd if=/dev/zero bs=1M count=10 | nc -N 10.0.0.2 7 > /dev/null
```

预期：ping 3/3 通；`curl` 返回 `hello from mytcp`；10 MB 数据在几秒内传完，`mysniff` 统计的重传次数为 0（无丢包时）。这三条分别验证 ICMP、TCP 短连接、TCP 长流。

| 阶段 | 交付 | 对应正文 |
|:--|:--|:--|
| 0 | TAP 打开、帧循环、统计 | 4.1.3、4.2.2 |
| 1 | ARP、IPv4、ICMP echo | 4.2.4、4.3.1、4.3.5 |
| 2 | UDP 回显与端口不可达 | 4.4.2、4.4.11 |
| 3 | 三次握手、状态机、四次挥手 | 4.5.1–4.5.11 |
| 4 | seq/ack、重传、窗口、校验和 | 4.4.3、4.6.1–4.6.3 |
| 5 | 最小 socket API | [1.11.3](../part1/ch11.md#sec-1.11.3)、[2.16](../part2/ch16.md) |
| 6 | 与 Linux 栈互通、HTTP 演示 | [5.6.2](../part5/ch06.md#sec-5.6.2) |
| 7 | 性能、延迟 ACK、调试 | 4.6.8、4.6.10 |

### C.1.2 架构：一个循环、五层解析 {#sec-c.1.2}

```text
tap fd ──read──▶ eth_input ──┬─▶ arp_input ──▶ arp cache / 回包
                             └─▶ ip_input ──┬─▶ icmp_input ──▶ echo reply
                                            ├─▶ udp_input  ──▶ echo / ICMP unreach
                                            └─▶ tcp_input  ──▶ TCB 状态机
                                                                   │
                                            mt_read / mt_write ◀───┘（应用回调）
                                                                   │
tap fd ◀──write── ip_send ◀── tcp_emit ◀───────────────────────────┘
```

三个关键数据结构：

- `struct mt_stack`：全局上下文，持有 tap fd、本机 IP/MAC、所有 TCB 的链表、accept 队列、统计计数器和应用回调；
- `struct mt_sock`：一条连接（或一个监听者）的 TCB，含 `snd_una/snd_nxt/snd_wnd/rcv_nxt`、未确认段链表、收发缓冲区、RTO 变量；
- `struct mt_seg`：一个已发出但未被确认的段，带序号、长度、重试次数、发送时刻与数据副本。

单线程、事件驱动：`poll` 等 tap fd，一次读一个帧，处理完再读下一个，最后跑一遍定时器。这对应内核的软中断收包 + 协议栈处理，只不过内核用 NAPI 批量收，我们一次一个 `read`。**不要小看这个差别**：Stage 7 会看到每包一次系统调用就是本栈的主要开销之一。

::: note 为什么不用 epoll
`mytcp` 只有一个 fd（tap），`poll` 足够且更简单。epoll 的价值在「大量 fd」，那正是 `myproxy` 的场景（C.2）。两个项目用不同机制，不是重复，而是让你看清「事件通知」在不同规模下的选择。
:::

### C.1.3 Stage 0 · TAP 设备与帧循环 {#sec-c.1.3}

**目标**

```bash
make
sudo ip netns exec mtlab ./build/mytcp --tap tap0 --ip 10.0.0.2
# 另一个终端：
sudo ip netns exec mthost ping -c1 10.0.0.2
```

预期：`ping` 超时（Stage 0 还不回 ARP），但 `mytcp` 的统计在 Ctrl-C 后显示 `frames rx 1`（一个 ARP 请求，42 字节）。`ip -n mthost neigh show 10.0.0.2` 显示 `INCOMPLETE` 或 `FAILED`。做到「帧能进用户态、能看清类型」就算过。

**关键概念**：以太网帧格式与 EtherType（[4.2.2](../part4/ch02.md#sec-4.2.2)）；TUN 与 TAP 的区别（TUN 是三层，只有 IP 包；TAP 是二层，有以太网帧，所以 ARP 必须用 TAP）；`IFF_NO_PI` 去掉 4 字节的 PI 头。

**代码**：先定义最小首部与字节序工具。所有多字节字段一律以**网络序**存放，读出来用 `ntohs/ntohl`，写进去用 `htons/htonl`。

```c
/* include/net.h — 只列出 Stage 0 用到的部分 */
#define MT_ETH_ALEN 6
#define MT_ETH_HLEN 14

struct eth_addr { uint8_t b[MT_ETH_ALEN]; };

struct eth_hdr {
    struct eth_addr dst;
    struct eth_addr src;
    uint16_t ethertype;              /* 网络序 */
} __attribute__((packed));

static inline uint16_t mt_rd16(const void *p)
{
    uint16_t v;
    memcpy(&v, p, sizeof v);         /* 避免非对齐指针解引用 */
    return v;
}

int mt_parse_mac(const char *s, struct eth_addr *out);
const char *mt_ip_str(uint32_t addr, char *buf, size_t len);
```

TAP 的打开方式只有十几行，但每个 `ioctl` 都有坑：

```c
/* src/tap.c */
int tap_open(const char *name, char *actual, size_t actual_len)
{
    struct ifreq ifr;
    int fd = open("/dev/net/tun", O_RDWR | O_CLOEXEC);

    if (fd < 0) {
        perror("open /dev/net/tun");
        return -1;
    }
    memset(&ifr, 0, sizeof ifr);
    ifr.ifr_flags = IFF_TAP | IFF_NO_PI;   /* 二层帧，无 PI 头 */
    snprintf(ifr.ifr_name, IFNAMSIZ, "%s", name);
    if (ioctl(fd, TUNSETIFF, &ifr) < 0) {
        perror("ioctl TUNSETIFF");
        close(fd);
        return -1;
    }
    ioctl(fd, TUNSETPERSIST, 1);           /* 进程退出后设备保留，便于反复调试 */
    snprintf(actual, actual_len, "%s", ifr.ifr_name);
    return fd;
}
```

主循环必须处理 `EINTR` 与 `EAGAIN`：信号会打断 `poll`，非阻塞 fd 读到空就停。**短读在 TAP 上不会发生**（一次 `read` 正好一个帧），但 `write` 仍要按循环写，因为这是所有 fd 的通用纪律。

```c
/* src/stack.c */
int mt_run(struct mt_stack *st, int timeout_ms)
{
    struct pollfd pfd = { .fd = st->tapfd, .events = POLLIN };
    int n = poll(&pfd, 1, timeout_ms);

    if (n < 0) {
        if (errno == EINTR)
            return 0;                  /* 信号打断不是错误 */
        return -1;
    }
    if (n > 0 && (pfd.revents & POLLIN)) {
        for (;;) {
            uint8_t frame[MT_FRAME_MAX];
            ssize_t r = tap_read(st->tapfd, frame, sizeof frame);

            if (r < 0) {
                if (errno == EINTR)
                    continue;
                if (errno == EAGAIN || errno == EWOULDBLOCK)
                    break;             /* 一次把可读的帧读干净 */
                return -1;
            }
            if (r == 0)
                break;
            eth_input(st, frame, (size_t)r);
        }
    }
    tcp_timer(st, mt_now_ms());
    return n;
}
```

**验证**

```bash
make
sudo ip netns exec mtlab ./build/mytcp --tap tap0 --ip 10.0.0.2 &
sudo ip netns exec mthost ping -c1 -W1 10.0.0.2 || true
sleep 1
sudo ip netns exec mthost ip neigh show 10.0.0.2
sudo pkill -INT mytcp
```

预期：`ip neigh` 里有 `10.0.0.2 dev veth-b  INCOMPLETE`；`mytcp` 退出时的统计里 `frames rx` 至少为 1。失败时先 `sudo ip netns exec mtlab tcpdump -i tap0 -e -nn`，确认 ARP 请求真的到了 `tap0`；再到不了，就是网桥或 veth 的问题，与本程序无关。

**常见错误**

| 报错/现象 | 原因 | 修复 |
|:--|:--|:--|
| `open /dev/net/tun: No such file or directory` | 内核没加载 `tun`，或容器里没这个设备 | `sudo modprobe tun`；`ls -l /dev/net/tun` |
| `ioctl TUNSETIFF: Operation not permitted` | 不是 root，或 namespace 里没有 `CAP_NET_ADMIN` | 用 `sudo ip netns exec ...` 跑；不要 `setcap` 绕过 |
| `ioctl TUNSETIFF: Device or resource busy` | 同名 tap 已被别的进程占用（`TUNSETPERSIST` 留下的） | `sudo ip link del tap0`，或先杀掉旧进程 |
| `ping` 100% 丢包，但 `tcpdump -i tap0` 能看到 ARP 请求 | `tap0` 直接配了 IP，内核按目的 MAC 丢弃 | 按 C.0.1 改成网桥端口 |
| Ctrl-C 后没有统计 | 信号处理里做了 `printf` 或 `poll` 没设超时 | 只置 `volatile sig_atomic_t` 标志；`poll` 超时 ≤ 200 ms |

**下一步**：帧已经进来了，但 ARP 还没人回。Stage 1 先让 `ping` 通，这会同时验证以太网封装、ARP 缓存和 IP 校验和三条路径。

### C.1.4 Stage 1 · ARP、IPv4 与 ICMP {#sec-c.1.4}

**目标**

```bash
sudo ip netns exec mtlab ./build/mytcp --tap tap0 --ip 10.0.0.2 &
sudo ip netns exec mthost ping -c3 10.0.0.2
```

预期（未实测）：

```text
PING 10.0.0.2 (10.0.0.2) 56(84) bytes of data.
64 bytes from 10.0.0.2: icmp_seq=1 ttl=64 time=0.412 ms
64 bytes from 10.0.0.2: icmp_seq=2 ttl=64 time=0.388 ms
64 bytes from 10.0.0.2: icmp_seq=3 ttl=64 time=0.401 ms

--- 10.0.0.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2043ms
```

同时 `ip -n mthost neigh show 10.0.0.2` 变成 `REACHABLE`，且 MAC 是 `02:00:00:00:00:02`。

**关键概念**：ARP 请求/应答的 28 字节格式与「谁问谁答」（[4.2.4](../part4/ch02.md#sec-4.2.4)）；IPv4 首部 20 字节与首部校验和（[4.3.1](../part4/ch03.md#sec-4.3.1)）；ICMP echo 的 type 8/0 与「校验和只覆盖 ICMP 部分」（[4.3.5](../part4/ch03.md#sec-4.3.5)）；RFC 1071 的反码求和（[4.4.11](../part4/ch04.md#sec-4.4.11)）。

**代码 1：校验和**。这是整个项目最容易写错、也最容易验证的一段。用 32 位累加、最后折叠进位、取反；`sum` 的初值可以复用（伪首部就靠这个）。

```c
/* src/net.c */
uint32_t mt_csum_add(uint32_t sum, const void *data, size_t len)
{
    const uint8_t *p = data;

    while (len >= 2) {
        sum += (uint32_t)((p[0] << 8) | p[1]);   /* 按网络序取 16 位 */
        p += 2;
        len -= 2;
    }
    if (len != 0)
        sum += (uint32_t)(p[0] << 8);            /* 奇数字节补 0 */
    return sum;
}

uint16_t mt_csum_finish(uint32_t sum)
{
    while (sum >> 16)
        sum = (sum & 0xffffu) + (sum >> 16);
    return (uint16_t)~sum;
}

uint16_t mt_csum(const void *data, size_t len)
{
    return mt_csum_finish(mt_csum_add(0, data, len));
}

uint32_t mt_pseudo_sum(uint32_t saddr, uint32_t daddr, uint8_t proto, uint16_t len)
{
    struct pseudo_hdr ph;

    memset(&ph, 0, sizeof ph);
    ph.saddr = saddr;
    ph.daddr = daddr;
    ph.proto = proto;
    ph.len = htons(len);
    return mt_csum_add(0, &ph, sizeof ph);
}
```

约定：`mt_csum()` 返回**主机序**的校验和，写入报文时要 `htons()`；验证一个含校验和字段的首部时，`mt_csum(整个首部) == 0` 表示正确。这两条约定能避免 90% 的「校验和看起来是反的」问题。

**代码 2：ARP 应答**。收到请求先学对方，再判断是不是问自己；是就回，并且顺手把等待这个邻居的包发出去（`arp_flush`）。

```c
/* src/arp.c */
void arp_input(struct mt_stack *st, const uint8_t *frame, size_t len)
{
    struct arp_hdr ah;
    struct eth_hdr eh;

    if (len < MT_ETH_HLEN + sizeof ah)
        return;
    memcpy(&eh, frame, sizeof eh);
    memcpy(&ah, frame + MT_ETH_HLEN, sizeof ah);
    if (ntohs(ah.htype) != 1 || ntohs(ah.ptype) != MT_ETH_P_IP ||
        ah.hlen != MT_ETH_ALEN || ah.plen != 4)
        return;

    arp_learn(st, ah.spa, &ah.sha);          /* 反向学习：任何 ARP 都更新缓存 */

    if (ntohs(ah.op) == 1 && ah.tpa == st->ip) {
        struct eth_addr peer = ah.sha;       /* 单播回给请求者 */
        arp_send(st, 2, &peer, ah.spa);
    }
    arp_flush(st, ah.spa);                   /* 之前因缺 MAC 排队的包现在能发了 */
}
```

`arp_send()` 用广播目的地址 `ff:ff:ff:ff:ff:ff` 构造请求，用请求者的 MAC 构造应答；`arp_queue()` 最多缓存 4 个包、2 秒过期，满了丢最老的并计数。**这个队列不是可选的**：Stage 5 的 `connect` 在不知道对端 MAC 时会先发 ARP，没有队列就会把 SYN 丢掉，表现为「连接偶尔超时」。

**代码 3：IP 发送**。先查路由（本网段直接投递，否则走网关），再查 ARP；查不到就排队并发 ARP 请求。首部校验和必须在所有字段填好、`check = 0` 之后算。

```c
/* src/ip.c */
static int ip_send_mac(struct mt_stack *st, uint8_t proto, uint32_t dst,
                       const struct eth_addr *dmac, const void *payload, size_t len)
{
    uint8_t pkt[MT_FRAME_MAX];
    struct ip_hdr *ip = (struct ip_hdr *)pkt;
    uint16_t total = (uint16_t)(MT_IP_HLEN + len);

    if (len > MT_MTU - MT_IP_HLEN)
        return -1;
    memset(pkt, 0, MT_IP_HLEN);
    ip->vihl = 0x45;
    ip->tot_len = htons(total);
    ip->id = htons(++st->ip_id);
    ip->frag_off = htons(0x4000);        /* DF：本栈不做分片 */
    ip->ttl = 64;
    ip->proto = proto;
    ip->saddr = st->ip;
    ip->daddr = dst;
    ip->check = htons(mt_csum(pkt, MT_IP_HLEN));
    memcpy(pkt + MT_IP_HLEN, payload, len);
    return eth_output(st, dmac, MT_ETH_P_IP, pkt, total);
}
```

**代码 4：ICMP echo 回显**。收到 type 8 就复制整段、改 type 为 0、重算校验和。注意校验和只覆盖 ICMP 首部 + 数据，**不包含 IP 首部**。

```c
/* src/ip.c */
static void icmp_input(struct mt_stack *st, const struct ip_hdr *ip,
                       const uint8_t *p, size_t len)
{
    struct icmp_hdr ic;

    if (len < sizeof ic)
        return;
    memcpy(&ic, p, sizeof ic);
    if (mt_csum(p, len) != 0) {
        st->stats.rx_csum++;
        return;
    }
    if (ic.type == 8 && ic.code == 0) {
        uint8_t reply[MT_MTU];

        memcpy(reply, p, len);
        reply[0] = 0;                    /* Echo Reply */
        reply[1] = 0;
        reply[2] = reply[3] = 0;
        uint16_t c = mt_csum(reply, len);
        reply[2] = (uint8_t)(c >> 8);
        reply[3] = (uint8_t)(c & 0xff);
        ip_send(st, MT_IPPROTO_ICMP, ip->saddr, reply, len);
    }
}
```

**验证**

```bash
make
sudo ip netns exec mtlab ./build/mytcp --tap tap0 --ip 10.0.0.2 &
sudo ip netns exec mthost ping -c3 10.0.0.2
sudo ip netns exec mthost ip neigh show 10.0.0.2
# 抓包逐字段看
sudo ip netns exec mtlab tcpdump -i br0 -nn -vv -c 6 'arp or icmp'
```

预期：ping 3/3；`tcpdump` 里能同时看到 ARP request/reply 与 ICMP echo request/reply，且 `tcpdump` 不报 `bad ip checksum` / `bad icmp checksum`。如果 `tcpdump` 报校验和错，先关掉网卡 offload 再判断（[4.4.11](../part4/ch04.md#sec-4.4.11)）。

**常见错误**

| 报错/现象 | 原因 | 修复 |
|:--|:--|:--|
| `tcpdump: bad ip checksum` | 先算校验和再填 `tot_len/id`，或写入时忘了 `htons` | 所有字段填完、`check=0` 后再算 |
| ping 显示 `Destination Host Unreachable` | ARP 应答的目的 MAC 填成了广播，或 `tha` 没回填 | 应答用请求者的 `sha` 作目的 MAC |
| ping 通了但 `ttl` 不是 64 | 你把自己的 TTL 写成了 255 或没填 | TTL 是「还剩多少跳」，本机发出的填 64 |
| `mt_csum(首部) == 0xffff` 而不是 0 | `finish` 里少取反，或把返回值又当网络序处理了一次 | 记住「返回主机序，写入要 htons」 |
| 抓包看到 ARP 请求，但没有 reply | `ah.tpa` 比较时用了主机序/网络序混用 | `ip` 字段统一网络序，比较前不要转 |

**下一步**：IP 层已经能把任意协议送到对端。Stage 2 加 UDP——它只比 IP 多 8 个字节，却能把「伪首部校验和」「端口分用」「端口不可达」三件事一次讲清。

### C.1.5 Stage 2 · UDP：8 个字节的运输层 {#sec-c.1.5}

**目标**

```bash
printf 'hello' | sudo ip netns exec mthost nc -u -w1 10.0.0.2 7
# 预期输出：hello

sudo ip netns exec mthost nc -u -w1 10.0.0.2 9
# 预期：无输出；tcpdump 里出现 ICMP port unreachable
```

**关键概念**：UDP 首部四个字段与「长度包含首部」（[4.4.2](../part4/ch04.md#sec-4.4.2)）；伪首部把 IP 地址纳入校验（[4.4.11](../part4/ch04.md#sec-4.4.11)）；端口分用与 ICMP 差错报文（[4.3.5](../part4/ch03.md#sec-4.3.5)）。UDP 校验和算出来是 0 时必须写成 `0xffff`——全 0 表示「不校验」，是 IPv4 独有的豁免。

**代码**：收包先验长度与校验和，再按端口分用；端口 7 回显，其余回 ICMP 端口不可达（差错报文要带上原 IP 首部 + 8 字节，让对端知道是哪个包出错了）。

```c
/* src/ip.c */
static void udp_input(struct mt_stack *st, const struct ip_hdr *ip,
                      const uint8_t *p, size_t len)
{
    struct udp_hdr uh;
    uint16_t ulen;

    if (len < sizeof uh)
        return;
    memcpy(&uh, p, sizeof uh);
    ulen = ntohs(uh.len);
    if (ulen < sizeof uh || ulen > len) {
        st->stats.rx_bad++;
        return;
    }
    if (uh.check != 0) {
        uint32_t sum = mt_pseudo_sum(ip->saddr, ip->daddr, MT_IPPROTO_UDP, ulen);
        if (mt_csum_finish(mt_csum_add(sum, p, ulen)) != 0) {
            st->stats.rx_csum++;
            return;
        }
    }
    if (ntohs(uh.dport) == 7) {
        uint8_t buf[MT_MTU];
        struct udp_hdr *out = (struct udp_hdr *)buf;
        size_t plen = ulen - sizeof uh;

        memset(out, 0, sizeof *out);
        out->sport = uh.dport;           /* 源端口 = 请求的目的端口 */
        out->dport = uh.sport;
        out->len = htons(ulen);
        memcpy(buf + sizeof *out, p + sizeof uh, plen);
        uint32_t sum = mt_pseudo_sum(ip->daddr, ip->saddr, MT_IPPROTO_UDP, ulen);
        uint16_t c = mt_csum_finish(mt_csum_add(sum, buf, ulen));
        buf[6] = (uint8_t)(c >> 8);
        buf[7] = (uint8_t)(c & 0xff);
        ip_send(st, MT_IPPROTO_UDP, ip->saddr, buf, ulen);
    } else {
        uint8_t body[MT_IP_HLEN + 8];
        size_t ihl = (size_t)(ip->vihl & 0x0f) * 4;

        memcpy(body, ip, ihl);
        memcpy(body + ihl, p, 8);        /* ICMP 只引用前 8 字节 */
        icmp_send(st, ip->saddr, 3, 3, body, ihl + 8);
    }
}
```

回显时源/目的地址要对调，伪首部也要跟着对调——这是最容易漏的一步，漏了的现象是「本机 `tcpdump` 显示 checksum incorrect，但对端 `nc` 收不到」。

**验证**

```bash
# 终端 1：栈
sudo ip netns exec mtlab ./build/mytcp --tap tap0 --ip 10.0.0.2
# 终端 2：回显
printf 'hello' | sudo ip netns exec mthost nc -u -w1 10.0.0.2 7
# 终端 3：端口不可达
sudo ip netns exec mthost nc -u -w1 10.0.0.2 9; echo "exit=$?"
sudo ip netns exec mtlab tcpdump -i br0 -nn -vv 'udp or icmp'
```

预期：第一条输出 `hello`；第二条 `exit=1`（`nc` 收到 ICMP 差错后退出）；`tcpdump` 显示 `10.0.0.1.xxxxx > 10.0.0.2.7: [udp sum ok]`，以及 `icmp: 10.0.0.2 udp port 9 unreachable`。

**常见错误**

| 报错/现象 | 原因 | 修复 |
|:--|:--|:--|
| `tcpdump` 报 `bad udp cksum`，对端收不到 | 回显时伪首部的源/目的地址没对调 | 用 `ip->daddr, ip->saddr` 重算 |
| 校验和字段写成 `0x0000` | 计算结果为 0 时直接写入 | 0 改为 `0xffff`（IPv4 UDP 特有） |
| `nc` 一直挂着不退出 | UDP 无连接，`nc` 不知道对方收没收到 | 加 `-w1`；或让栈回 ICMP 不可达 |
| 长度字段用了 `len` 而不是 `ulen` | `len` 可能包含以太网填充 | 一律用 UDP 首部里的 `len` |
| ICMP 不可达里引用的是整个 UDP 包 | 规范只要求 IP 首部 + 8 字节 | 截断到 `ihl + 8` |

**下一步**：UDP 把「分用」讲完了，但它没有状态。Stage 3 开始处理 TCP：先只做握手与挥手，把状态机和序号规则立起来，数据先不传——这样出错时你能确定是状态迁移错了，而不是重传算错了。

### C.1.6 Stage 3 · TCP 握手、状态机与挥手 {#sec-c.1.6}

**目标**

```bash
sudo ip netns exec mtlab ./build/mytcp --tap tap0 --ip 10.0.0.2 --listen 7 &
sudo ip netns exec mthost nc -vz -w2 10.0.0.2 7
# 预期：10.0.0.2 (10.0.0.2:7) open
```

`nc -z` 只做 connect 和 close，不传数据——正好把「建立/释放」和 Stage 4 的「数据传输」分开。做到 `open` 且抓包能看到完整 `S/S././F./.` 序列就算过。

**关键概念**：状态迁移见 [4.5](../part4/ch05.md)。三条铁律：`SYN` 和 `FIN` 各占一个序号，所以确认号是 `seq+1`；`ACK` 标志与 `ack` 字段是两回事，只有 `ACK=1` 时 `ack` 才有效；主动关闭方必须经过 `TIME_WAIT`，否则旧连接的迟到报文会污染同四元组的新连接。

| 状态 | 收到 | 动作 | 新状态 |
|:--|:--|:--|:--|
| `LISTEN` | `SYN` | 回 `SYN+ACK`，`rcv_nxt=seq+1` | `SYN_RCVD` |
| `SYN_RCVD` | `ACK`（`ack==snd_nxt`） | 入 accept 队列 | `ESTABLISHED` |
| `SYN_SENT` | `SYN+ACK` | 回 `ACK` | `ESTABLISHED` |
| `ESTABLISHED` | `FIN` | 回 `ACK`，通知 EOF | `CLOSE_WAIT` |
| `ESTABLISHED` | 应用 `close` | 发 `FIN` | `FIN_WAIT_1` |
| `FIN_WAIT_1` | `ACK` 确认了 FIN | — | `FIN_WAIT_2` |
| `FIN_WAIT_1/2` | `FIN` | 回 `ACK` | `TIME_WAIT` |
| `CLOSE_WAIT` | 应用 `close` | 发 `FIN` | `LAST_ACK` |
| `LAST_ACK` | `ACK` | 释放 | `CLOSED` |
| `TIME_WAIT` | 2×MSL 到期 | 释放 | `CLOSED` |

**代码 1：TCB 与序号比较**。序号一律用 `uint32_t` 存主机序，只在写首部时 `htonl`；比较必须用回绕安全的差值。

```c
/* include/tcp.h */
#define MT_TCP_FIN 0x01
#define MT_TCP_SYN 0x02
#define MT_TCP_RST 0x04
#define MT_TCP_PSH 0x08
#define MT_TCP_ACK 0x10
#define MT_TCP_MSS_DEFAULT 1460
#define MT_TCP_RCV_BUF 65535
#define MT_TCP_TIME_WAIT_MS 60000

enum mt_tcp_state {
    MT_CLOSED, MT_LISTEN, MT_SYN_SENT, MT_SYN_RCVD, MT_ESTABLISHED,
    MT_FIN_WAIT_1, MT_FIN_WAIT_2, MT_CLOSE_WAIT, MT_CLOSING,
    MT_LAST_ACK, MT_TIME_WAIT
};

struct mt_sock {
    enum mt_tcp_state state;
    uint32_t saddr, daddr;          /* 网络序：本机、对端 */
    uint16_t sport, dport;          /* 主机序 */
    uint32_t iss, snd_una, snd_nxt, rcv_nxt;
    uint16_t snd_wnd, rcv_wnd, mss;
    uint64_t last_tx_ms, rto_ms, srtt_ms, rttvar_ms;
    uint8_t  retries, eof, used;
    uint8_t  rcvbuf[MT_TCP_RCV_BUF];
    size_t   rcv_len;
    struct mt_sock *next;
};

static inline int mt_seq_lt(uint32_t a, uint32_t b) { return (int32_t)(a - b) < 0; }
static inline int mt_seq_le(uint32_t a, uint32_t b) { return (int32_t)(a - b) <= 0; }
```

`struct mt_stack` 追加 `struct mt_sock *tcb, *listener, *acceptq;` 与 `uint64_t now_ms;`——主循环每轮更新 `now_ms`，测试里可以直接改它来推进时间。

**代码 2：发控制段**。`doff` 以 4 字节为单位；SYN 带 MSS 选项时首部从 20 字节变成 24 字节，`doff` 必须同步变成 6。校验和覆盖「伪首部 + TCP 首部 + 数据」。

```c
/* src/tcp.c */
static uint16_t tcp_csum(uint32_t s, uint32_t d, const uint8_t *seg, size_t n)
{
    uint32_t sum = mt_pseudo_sum(s, d, MT_IPPROTO_TCP, (uint16_t)n);
    return mt_csum_finish(mt_csum_add(sum, seg, n));
}

static size_t tcp_emit(struct mt_stack *st, struct mt_sock *sk, uint8_t flags,
                       uint32_t seq, uint32_t ack, const void *data, size_t len)
{
    uint8_t seg[MT_MTU];
    struct tcp_hdr *th = (struct tcp_hdr *)seg;
    size_t hlen = sizeof *th;

    if (len > MT_MTU - hlen - 4) return 0;
    memset(th, 0, sizeof *th);
    th->sport = htons(sk->sport);
    th->dport = htons(sk->dport);
    th->seq = htonl(seq);
    th->ack = htonl(ack);
    th->flags = flags;
    th->window = htons(sk->rcv_wnd);
    if ((flags & MT_TCP_SYN) && sk->mss != 0) {
        uint8_t *o = seg + hlen;
        o[0] = 2; o[1] = 4;                    /* MSS: kind=2,len=4 */
        o[2] = (uint8_t)(sk->mss >> 8);
        o[3] = (uint8_t)(sk->mss & 0xff);
        hlen += 4;
    }
    th->doff = (uint8_t)(hlen / 4);
    if (len != 0) memcpy(seg + hlen, data, len);
    th->check = htons(tcp_csum(st->ip, sk->daddr, seg, hlen + len));
    if (ip_send(st, MT_IPPROTO_TCP, sk->daddr, seg, hlen + len) < 0) return 0;
    sk->last_tx_ms = st->now_ms;
    st->stats.tx_segs++;
    return hlen + len;
}
```

**代码 3：收包、握手与关闭**。先验校验和与 `doff`，再按四元组查 TCB；查不到且是纯 SYN、目的端口命中监听者才建新 TCB，否则回 RST。RST 的序号规则容易写反：对方带 ACK 时 `seq=ack`，不带 ACK 时 `ack=seq+len`。

```c
/* src/tcp.c */
static struct mt_sock *tcp_lookup(struct mt_stack *st, uint32_t s, uint32_t d,
                                  uint16_t sp, uint16_t dp)
{
    struct mt_sock *sk;
    for (sk = st->tcb; sk != NULL; sk = sk->next)
        if (sk->saddr == d && sk->daddr == s && sk->sport == dp && sk->dport == sp)
            return sk;
    return NULL;
}

static void tcp_rst(struct mt_stack *st, uint32_t s, uint32_t d, uint16_t sp,
                    uint16_t dp, uint32_t seq, uint32_t ack, uint8_t flags)
{
    struct mt_sock t = {0};
    t.saddr = d; t.daddr = s; t.sport = dp; t.dport = sp;
    if (flags & MT_TCP_ACK) tcp_emit(st, &t, MT_TCP_RST, ack, 0, NULL, 0);
    else tcp_emit(st, &t, MT_TCP_RST | MT_TCP_ACK, 0, seq + 1, NULL, 0);
    st->stats.tx_rst++;
}

void tcp_input(struct mt_stack *st, const struct ip_hdr *ip,
               const uint8_t *seg, size_t len)
{
    struct tcp_hdr th;
    struct mt_sock *sk;
    size_t hlen, plen;
    uint32_t seq, ack;
    uint16_t sport, dport;
    uint8_t flags;

    if (len < sizeof th) return;
    memcpy(&th, seg, sizeof th);
    hlen = (size_t)th.doff * 4;
    if (th.doff < 5 || hlen > len) return;
    if (tcp_csum(ip->saddr, ip->daddr, seg, len) != 0) { st->stats.rx_csum++; return; }
    st->stats.rx_segs++;
    sport = ntohs(th.sport); dport = ntohs(th.dport);
    seq = ntohl(th.seq); ack = ntohl(th.ack); flags = th.flags;
    plen = len - hlen;

    sk = tcp_lookup(st, ip->saddr, ip->daddr, sport, dport);
    if (sk == NULL) {
        for (sk = st->listener; sk != NULL; sk = sk->next) {
            struct mt_sock *ns;
            if (sk->sport != dport || !(flags & MT_TCP_SYN) || (flags & MT_TCP_ACK))
                continue;
            ns = calloc(1, sizeof *ns);
            if (ns == NULL) return;
            ns->state = MT_SYN_RCVD;
            ns->saddr = ip->daddr; ns->daddr = ip->saddr;
            ns->sport = dport; ns->dport = sport;
            ns->rcv_nxt = seq + 1; ns->rcv_wnd = MT_TCP_RCV_BUF;
            ns->mss = MT_TCP_MSS_DEFAULT;   /* 完整实现会解析 SYN 里的 MSS 选项 */
            ns->iss = mt_gen_iss(st, ns->saddr, ns->daddr, ns->sport, ns->dport);
            ns->snd_una = ns->iss; ns->snd_nxt = ns->iss + 1;
            tcp_emit(st, ns, MT_TCP_SYN | MT_TCP_ACK, ns->iss, ns->rcv_nxt, NULL, 0);
            ns->next = st->tcb; st->tcb = ns;
            return;
        }
        tcp_rst(st, ip->saddr, ip->daddr, sport, dport, seq, ack, flags);
        return;
    }
    if (flags & MT_TCP_RST) { sk->state = MT_CLOSED; return; }
    if (sk->state == MT_SYN_SENT) {
        if ((flags & (MT_TCP_SYN | MT_TCP_ACK)) == (MT_TCP_SYN | MT_TCP_ACK) &&
            ack == sk->snd_nxt) {
            sk->rcv_nxt = seq + 1; sk->snd_una = ack;
            sk->snd_wnd = ntohs(th.window);
            tcp_emit(st, sk, MT_TCP_ACK, sk->snd_nxt, sk->rcv_nxt, NULL, 0);
            sk->state = MT_ESTABLISHED;
        }
        return;
    }
    if (sk->state == MT_SYN_RCVD) {
        if ((flags & MT_TCP_ACK) && ack == sk->snd_nxt) {
            sk->snd_una = ack; sk->snd_wnd = ntohs(th.window);
            sk->state = MT_ESTABLISHED;
            sk->next = st->acceptq; st->acceptq = sk;
        }
        return;
    }
    /* ESTABLISHED 及关闭中的状态：Stage 4 在此接数据，Stage 3 只处理 ACK/FIN */
    if ((flags & MT_TCP_ACK) && mt_seq_le(sk->snd_una, ack) &&
        mt_seq_le(ack, sk->snd_nxt)) {
        sk->snd_una = ack; sk->snd_wnd = ntohs(th.window);
    }
    if ((flags & MT_TCP_FIN) && seq + (uint32_t)plen == sk->rcv_nxt) {
        sk->rcv_nxt++; sk->eof = 1;
        tcp_emit(st, sk, MT_TCP_ACK, sk->snd_nxt, sk->rcv_nxt, NULL, 0);
        if (sk->state == MT_ESTABLISHED) sk->state = MT_CLOSE_WAIT;
        else if (sk->state == MT_FIN_WAIT_1 || sk->state == MT_FIN_WAIT_2 ||
                 sk->state == MT_CLOSING) sk->state = MT_TIME_WAIT;
    }
    if (sk->state == MT_FIN_WAIT_1 && (flags & MT_TCP_ACK) &&
        sk->snd_una == sk->snd_nxt)
        sk->state = MT_FIN_WAIT_2;
}

int mt_tcp_close(struct mt_stack *st, struct mt_sock *sk)
{
    if (sk->state == MT_ESTABLISHED) {
        tcp_emit(st, sk, MT_TCP_FIN | MT_TCP_ACK, sk->snd_nxt, sk->rcv_nxt, NULL, 0);
        sk->snd_nxt++; sk->state = MT_FIN_WAIT_1; return 0;
    }
    if (sk->state == MT_CLOSE_WAIT) {
        tcp_emit(st, sk, MT_TCP_FIN | MT_TCP_ACK, sk->snd_nxt, sk->rcv_nxt, NULL, 0);
        sk->snd_nxt++; sk->state = MT_LAST_ACK; return 0;
    }
    return -1;
}
```

> `mt_gen_iss` 用「单调时钟 + 四元组」做 splitmix64 混合，不要用 `rand()`：固定种子会让重启后的序号可预测，也会在快速重连时撞序号。

**验证**

```bash
make
sudo ip netns exec mtlab ./build/mytcp --tap tap0 --ip 10.0.0.2 --listen 7 &
sudo ip netns exec mthost nc -vz -w2 10.0.0.2 7
sudo ip netns exec mtlab tcpdump -i br0 -nn -S -c 6 'tcp port 7'
sudo pkill -INT mytcp
```

预期（未实测，序号每次不同）：`S` 的 `seq=3721000001`，`S.` 的 `seq=980000001, ack=3721000002`，第三个包 `ack=980000002`。三个数字各差 1，任何一个不对都是「SYN 不占序号」的错误假设。

**常见错误**

| 报错/现象 | 原因 | 修复 |
|:--|:--|:--|
| `nc` 立刻 `Connection refused` | 目的端口没匹配监听者，回了 RST | 打印 `listener->sport`；确认 `--listen 7` 生效 |
| `nc` 卡住到 `-w2` 超时 | `SYN+ACK` 没发出或校验和错 | `tcpdump -vv` 看 `bad tcp cksum`；核对伪首部地址 |
| `S.` 的 `ack` 少 1 | `rcv_nxt = seq` | `rcv_nxt = seq + 1` |
| 握手成功后对端一直重传 SYN | 重复 SYN 新建了 TCB，没重发 `SYN+ACK` | 命中 `SYN_RCVD` 时重发 `SYN+ACK` |
| 主动关闭停在 `FIN_WAIT_1` | 没处理「ACK 确认 FIN」 | `snd_una == snd_nxt` 时迁移 |
| `TIME_WAIT` 不消失 | `tcp_timer` 没被调用 | 主循环每轮更新 `now_ms` 并调用 |

::: note 为什么 Stage 3 故意不传数据
握手错在「状态与序号」，重传错在「缓冲、定时器与窗口」。同时写，抓包异常时无法归因。这里收到数据只回 dup ACK、绝不推进 `rcv_nxt`，让调试范围减半。
:::

**下一步**：连接能建能关，但传不了字节。Stage 4 接上发送队列、接收缓冲、ACK 与超时重传。

### C.1.7 Stage 4 · 可靠传输：seq/ack、重传、窗口与校验和 {#sec-c.1.7}

**目标**

```bash
sudo ip netns exec mtlab ./build/mytcp --tap tap0 --ip 10.0.0.2 --echo 7 &
sudo ip netns exec mthost sh -c 'dd if=/dev/urandom bs=1k count=512 2>/dev/null >/tmp/in.bin;
  nc -N 10.0.0.2 7 </tmp/in.bin >/tmp/out.bin; cmp /tmp/in.bin /tmp/out.bin && echo INTACT'
# 预期：INTACT
```

512 KB 覆盖窗口回绕（65535）、ACK 合并和大量分段边界。**先做到无丢包 100% 正确，再开丢包**。

**关键概念**：发送侧 `snd_una / snd_nxt / snd_una+snd_wnd`；接收侧 `rcv_nxt` 与 `rcv_wnd`；RTO 用 RFC 6298 简化版（`srtt`、`rttvar`、`rto=srtt+4*rttvar`，下限 200 ms、上限 60 s），超时指数退避；**部分确认**必须裁剪未确认段，否则「ACK 只确认半段」时会永远重传整段；窗口通告的是接收缓冲**剩余空间**，不是常量 65535。

接收侧本 Stage 只接受连续段：乱序段回 dup ACK，让对端重传。正确但不是最优，乱序缓存留作 C.6 练习。

**代码 1：未确认段队列与发送**。`sndbuf` 的 0 号字节对应 `snd_una`；可发送量取「窗口剩余」与 MSS 的较小值；每段保存数据副本，最多 32 段（约 46 KB 在途）。

```c
/* include/tcp.h */
#define MT_TCP_MAX_SEGS 32
struct mt_seg {
    struct mt_seg *next;
    uint32_t seq;
    uint16_t len;
    uint8_t  retries, in_use;
    uint64_t sent_ms;
    uint8_t  data[MT_TCP_MSS_DEFAULT];
};
/* struct mt_sock 追加 */
    struct mt_seg *unacked;      /* 按 seq 升序 */
    uint8_t  sndbuf[MT_TCP_RCV_BUF];
    size_t   snd_len;            /* 以 snd_una 为起点的有效字节 */
```

```c
/* src/tcp.c */
static void tcp_output_pending(struct mt_stack *st, struct mt_sock *sk)
{
    while (sk->snd_len > (size_t)(sk->snd_nxt - sk->snd_una)) {
        size_t off = (size_t)(sk->snd_nxt - sk->snd_una);
        size_t chunk = sk->snd_len - off;
        uint32_t inflight = sk->snd_nxt - sk->snd_una;
        struct mt_seg *sg, *tail;

        if (inflight >= sk->snd_wnd) break;
        if (chunk > (size_t)(sk->snd_wnd - inflight)) chunk = sk->snd_wnd - inflight;
        if (chunk > sk->mss) chunk = sk->mss;
        sg = calloc(1, sizeof *sg);
        if (sg == NULL) break;
        sg->seq = sk->snd_nxt; sg->len = (uint16_t)chunk; sg->sent_ms = st->now_ms;
        memcpy(sg->data, sk->sndbuf + off, chunk);
        if (tcp_emit(st, sk, MT_TCP_ACK | MT_TCP_PSH, sg->seq, sk->rcv_nxt,
                     sg->data, sg->len) == 0) { free(sg); break; }
        sk->snd_nxt += (uint32_t)chunk;
        if (sk->unacked == NULL) sk->unacked = sg;
        else { for (tail = sk->unacked; tail->next; tail = tail->next) ; tail->next = sg; }
    }
}

ssize_t mt_tcp_write(struct mt_stack *st, struct mt_sock *sk, const void *buf, size_t len)
{
    size_t space, n;
    if (sk->state != MT_ESTABLISHED) return -1;
    space = sizeof sk->sndbuf - sk->snd_len;
    n = len < space ? len : space;
    if (n == 0) return 0;
    memcpy(sk->sndbuf + sk->snd_len, buf, n);
    sk->snd_len += n;
    tcp_output_pending(st, sk);
    return (ssize_t)n;
}
```

**代码 2：ACK 与部分确认**。`ack` 落在 `(snd_una, snd_nxt]` 才合法。完全确认的段释放；切在段中间的段要前移 `seq`、缩短 `len`、清零 `retries`——剩下的部分还在 `sndbuf` 里，等下次超时重传。

```c
/* src/tcp.c */
static void tcp_ack(struct mt_stack *st, struct mt_sock *sk, uint32_t ack, uint16_t wnd)
{
    struct mt_seg **pp = &sk->unacked;
    uint32_t adv;

    if (!mt_seq_lt(sk->snd_una, ack) || mt_seq_lt(sk->snd_nxt, ack)) return;
    adv = ack - sk->snd_una;
    sk->snd_una = ack; sk->snd_wnd = wnd;
    while (*pp != NULL) {
        struct mt_seg *sg = *pp;
        if (mt_seq_le(sg->seq + sg->len, ack)) { *pp = sg->next; free(sg); continue; }
        if (mt_seq_lt(sg->seq, ack)) {
            uint32_t cut = ack - sg->seq;
            memmove(sg->data, sg->data + cut, sg->len - cut);
            sg->seq = ack; sg->len = (uint16_t)(sg->len - cut);
            sg->retries = 0; sg->sent_ms = st->now_ms;
        }
        break;
    }
    if (adv > 0 && adv <= sk->snd_len) {
        memmove(sk->sndbuf, sk->sndbuf + adv, sk->snd_len - adv);
        sk->snd_len -= adv;
    }
}
```

**代码 3：接收与窗口**。只有 `seq == rcv_nxt` 才收；应用取走数据后若窗口从 0 恢复，必须主动发窗口更新，否则对端会一直等。

```c
/* src/tcp.c */
static void tcp_recv_data(struct mt_stack *st, struct mt_sock *sk,
                          uint32_t seq, const uint8_t *data, size_t len)
{
    if (len == 0) return;
    if (seq == sk->rcv_nxt && sk->rcv_len < sizeof sk->rcvbuf) {
        size_t space = sizeof sk->rcvbuf - sk->rcv_len;
        size_t take = len < space ? len : space;
        memcpy(sk->rcvbuf + sk->rcv_len, data, take);
        sk->rcv_len += take; sk->rcv_nxt += (uint32_t)take;
        sk->rcv_wnd = (uint16_t)(sizeof sk->rcvbuf - sk->rcv_len);
        tcp_emit(st, sk, MT_TCP_ACK, sk->snd_nxt, sk->rcv_nxt, NULL, 0);
        if (take < len) st->stats.rx_dropped++;
    } else {
        tcp_emit(st, sk, MT_TCP_ACK, sk->snd_nxt, sk->rcv_nxt, NULL, 0);
        if (seq != sk->rcv_nxt) st->stats.dup_acks++;
    }
}

ssize_t mt_tcp_read(struct mt_stack *st, struct mt_sock *sk, void *buf, size_t len)
{
    size_t n = len < sk->rcv_len ? len : sk->rcv_len;
    uint16_t old = sk->rcv_wnd;
    if (n == 0) return 0;
    memcpy(buf, sk->rcvbuf, n);
    memmove(sk->rcvbuf, sk->rcvbuf + n, sk->rcv_len - n);
    sk->rcv_len -= n;
    sk->rcv_wnd = (uint16_t)(sizeof sk->rcvbuf - sk->rcv_len);
    if (old == 0 && sk->rcv_wnd > 0)
        tcp_emit(st, sk, MT_TCP_ACK, sk->snd_nxt, sk->rcv_nxt, NULL, 0);
    (void)st;
    return (ssize_t)n;
}
```

**代码 4：RTO 与重传**。Karn 算法：只对没重传过的段采样 RTT，避免「重传后的 ACK 到底确认哪一次」的歧义。超时后 RTO 翻倍、段重发、`retries` 加一；8 次后放弃。

```c
/* src/tcp.c */
static void tcp_rtt(struct mt_sock *sk, uint64_t rtt)
{
    if (sk->srtt_ms == 0) { sk->srtt_ms = rtt; sk->rttvar_ms = rtt / 2; }
    else {
        uint64_t d = sk->srtt_ms > rtt ? sk->srtt_ms - rtt : rtt - sk->srtt_ms;
        sk->rttvar_ms = (3 * sk->rttvar_ms + d) / 4;
        sk->srtt_ms = (7 * sk->srtt_ms + rtt) / 8;
    }
    sk->rto_ms = sk->srtt_ms + 4 * sk->rttvar_ms;
    if (sk->rto_ms < 200) sk->rto_ms = 200;
    if (sk->rto_ms > 60000) sk->rto_ms = 60000;
}

void tcp_timer(struct mt_stack *st, uint64_t now_ms)
{
    struct mt_sock *sk;
    for (sk = st->tcb; sk != NULL; sk = sk->next) {
        struct mt_seg *sg = sk->unacked;
        uint64_t rto;
        if (sk->state == MT_TIME_WAIT && now_ms - sk->last_tx_ms > MT_TCP_TIME_WAIT_MS) {
            sk->state = MT_CLOSED; continue;
        }
        if (sk->state != MT_ESTABLISHED || sg == NULL) continue;
        rto = sg->retries == 0 ? sk->rto_ms : (sk->rto_ms << sg->retries);
        if (now_ms - sg->sent_ms < rto) continue;
        if (sg->retries >= 8) { sk->state = MT_CLOSED; st->stats.retx_fail++; continue; }
        if (sg->retries == 0 && sk->rto_ms < 30000) sk->rto_ms *= 2;
        tcp_emit(st, sk, MT_TCP_ACK | MT_TCP_PSH, sg->seq, sk->rcv_nxt, sg->data, sg->len);
        sg->sent_ms = now_ms; sg->retries++; st->stats.retx++;
    }
}
```

**代码 5：接回输入路径**。ACK 要先于数据处理（它可能释放窗口）；数据要先于 FIN（FIN 序号是 `seq+len`）。

```c
/* src/tcp.c —— 替换 Stage 3 中 ESTABLISHED 分支的 ACK/FIN 部分 */
    if (flags & MT_TCP_ACK) {
        uint32_t old = sk->snd_una;
        tcp_ack(st, sk, ack, ntohs(th.window));
        if (sk->unacked != NULL && sk->unacked->retries == 0 &&
            mt_seq_lt(old, sk->snd_una))
            tcp_rtt(sk, st->now_ms - sk->unacked->sent_ms);
        tcp_output_pending(st, sk);
    }
    if (plen > 0) tcp_recv_data(st, sk, seq, seg + hlen, plen);
    /* FIN 分支沿用 Stage 3 */
```

**代码 6：不需要 root 的重传测试**。用 `socketpair(AF_UNIX, SOCK_DGRAM)` 冒充 TAP：数据报保留帧边界，测试能逐帧解析，校验和与封装全跑一遍。

```c
/* tests/test_retx.c —— 链接 src/{stack,eth,arp,ip,tcp,net}.c，自己实现 tap_read/write */
#include "stack.h"
#include "tcp.h"
#include <assert.h>
#include <sys/socket.h>
#include <unistd.h>

static int g_tap;
ssize_t tap_write(int fd, const void *b, size_t n)
{ (void)fd; return send(g_tap, b, n, 0) == (ssize_t)n ? (ssize_t)n : -1; }

static void inject(struct mt_stack *st, uint16_t sport, uint32_t seq,
                   uint32_t ack, uint8_t flags)
{
    uint8_t seg[sizeof(struct tcp_hdr)] = {0};
    struct tcp_hdr *th = (struct tcp_hdr *)seg;
    th->sport = htons(sport); th->dport = htons(7);
    th->seq = htonl(seq); th->ack = htonl(ack); th->doff = 5;
    th->flags = flags; th->window = htons(65535);
    th->check = htons(mt_csum_finish(mt_csum_add(
        mt_pseudo_sum(0x0a000001u, 0x0a000002u, MT_IPPROTO_TCP, sizeof *th),
        seg, sizeof *th)));
    tcp_input(st, &(struct ip_hdr){ .saddr = 0x0a000001u, .daddr = 0x0a000002u },
              seg, sizeof *th);
}

int main(void)
{
    struct mt_stack st;
    struct mt_sock *sk;
    int sv[2];
    uint32_t iss;
    static uint8_t data[3000];

    assert(socketpair(AF_UNIX, SOCK_DGRAM, 0, sv) == 0);
    g_tap = sv[0];
    mt_stack_init(&st, sv[1], 0x0a000002u);
    assert(mt_tcp_listen(&st, 7) == 0);

    inject(&st, 40000, 1000, 0, MT_TCP_SYN);
    sk = st.tcb; assert(sk && sk->state == MT_SYN_RCVD);
    iss = sk->iss;
    inject(&st, 40000, 1001, iss + 1, MT_TCP_ACK);
    assert(sk->state == MT_ESTABLISHED);

    assert(mt_tcp_write(&st, sk, data, sizeof data) > 0);
    assert(sk->unacked != NULL);
    st.now_ms += 3000;                 /* 丢掉所有 ACK，触发重传 */
    tcp_timer(&st, st.now_ms);
    assert(st.stats.retx >= 1);
    puts("test_retx: ok");
    return 0;
}
```

```bash
make test     # 无需 root：test_net / test_tcp / test_retx 全绿
```

**验证**

```bash
sudo ip netns exec mtlab ./build/mytcp --tap tap0 --ip 10.0.0.2 --echo 7 &
sudo ip netns exec mthost sh -c 'head -c 524288 /dev/urandom >/tmp/in.bin;
  time nc -N 10.0.0.2 7 </tmp/in.bin >/tmp/out.bin;
  cmp /tmp/in.bin /tmp/out.bin && echo INTACT'
```

丢包（**未实测**，`netem` 对 TAP 注入流量的效果依赖内核版本；若 `tc -s` 的 `dropped` 一直为 0，改用环境变量 `MT_DROP_PCT=5` 在 `ip_send` 里随机丢包）：

```bash
sudo ip netns exec mtlab tc qdisc add dev tap0 root netem loss 5%
# 重跑 cmp：仍应 INTACT，耗时变长、retx 上升
sudo ip netns exec mtlab tc qdisc del dev tap0 root
```

**常见错误**

| 现象 | 原因 | 修复 |
|:--|:--|:--|
| 传到一半卡住 | 零窗口后没有窗口更新 | `mt_tcp_read` 里判 `old==0` 补发 ACK |
| `cmp` 首个差异在 1460 边界 | 部分确认裁剪长度错 | `cut=ack-sg->seq`；`len-=cut` |
| 重传风暴 | `sent_ms` 没更新或 RTO 没退避 | 每次重传改 `sent_ms`；退避封顶 |
| 丢包时永远传不完 | 只回 dup ACK 不快速重传 | 连续 3 个 dup ACK 重传（练习） |
| `snd_una > snd_nxt` | 接受了非法 ACK | 先判 `ack <= snd_nxt` |
| RTT 极大 | 用重传段的 ACK 采样 | Karn：只采 `retries==0` |
| 测试 `read` 粘包 | socketpair 用了 `SOCK_STREAM` | 必须 `SOCK_DGRAM` |

::: errata 这不是生产级 TCP
没有拥塞控制、SACK、乱序缓存、persist timer、窗口缩放。它的价值是「每个字节都能解释」，不是「比内核快」。不要拿它跑公网。
:::

**下一步**：协议层完成。Stage 5 包成 `socket/bind/listen/accept/connect/read/write/close`，让真实程序用一组薄 API 驱动它。

### C.1.8 Stage 5 · 最小 socket API {#sec-c.1.8}

**目标**：应用只改链接、不改逻辑：

```c
int fd = mt_socket(AF_INET, SOCK_STREAM, 0);
mt_bind(fd, "10.0.0.2", 8080); mt_listen(fd, 16);
int c = mt_accept(fd, NULL, 0, NULL);
mt_read(c, buf, sizeof buf); mt_write(c, "hi", 2); mt_close(c);
```

**关键概念**：fd 是应用可见的**小整数下标**，不是内核 fd；`accept` 没有已完成连接时靠 `poll` TAP 阻塞；`read` 返回 0 只表示 EOF；`write` 可能只写一部分，调用方必须循环。语义与 [2.16](../part2/ch16.md) 的阻塞 socket 一致，只是把内核换成自己的 `poll` 循环。

**代码：完整薄封装**。`mt_wait()` 是唯一事件泵：`poll` TAP、读帧、分发、跑定时器；所有阻塞 API 都靠它推进，**不要在回调里再调它**（会重入）。

```c
/* include/api.h */
int  mt_socket(int domain, int type, int protocol);
int  mt_bind(int fd, const char *ip, uint16_t port);
int  mt_listen(int fd, int backlog);
int  mt_accept(int fd, char *peer, size_t cap, uint16_t *pport);
int  mt_connect(int fd, const char *ip, uint16_t port, int timeout_ms);
ssize_t mt_read(int fd, void *buf, size_t len);
ssize_t mt_write(int fd, const void *buf, size_t len);
int  mt_close(int fd);
int  mt_wait(int timeout_ms);
```

```c
/* src/api.c */
#include "api.h"
#include "tcp.h"
#include <errno.h>
#include <poll.h>
#include <stdlib.h>
#include <string.h>

#define MT_MAX_FD 64
struct mt_fd { struct mt_sock *sk; uint8_t kind; };   /* 0=free 1=listener 2=conn */
static struct mt_fd g_fds[MT_MAX_FD];
extern struct mt_stack g_stack;

int mt_wait(int timeout_ms)
{
    struct pollfd p = { .fd = g_stack.tapfd, .events = POLLIN };
    int n = poll(&p, 1, timeout_ms < 0 ? 0 : timeout_ms);
    if (n < 0) return errno == EINTR ? 0 : -1;
    if (n > 0 && (p.revents & POLLIN)) {
        for (;;) {
            uint8_t f[MT_FRAME_MAX];
            ssize_t r = tap_read(g_stack.tapfd, f, sizeof f);
            if (r < 0) {
                if (errno == EINTR) continue;
                if (errno == EAGAIN || errno == EWOULDBLOCK) break;
                return -1;
            }
            if (r == 0) break;
            mt_input_frame(&g_stack, f, (size_t)r);
        }
    }
    g_stack.now_ms = mt_now_ms();
    tcp_timer(&g_stack, g_stack.now_ms);
    return 0;
}

int mt_socket(int domain, int type, int protocol)
{
    int i;
    if (domain != AF_INET || type != SOCK_STREAM || protocol != 0) {
        errno = EAFNOSUPPORT; return -1;
    }
    for (i = 0; i < MT_MAX_FD; i++)
        if (g_fds[i].kind == 0) { memset(&g_fds[i], 0, sizeof g_fds[i]);
                                  g_fds[i].kind = 1; return i; }
    errno = EMFILE; return -1;
}

int mt_bind(int fd, const char *ip, uint16_t port)
{
    uint32_t addr;
    if (fd < 0 || fd >= MT_MAX_FD || g_fds[fd].kind != 1) { errno = EBADF; return -1; }
    if (port == 0 || mt_parse_ip(ip, &addr) < 0 || addr != g_stack.ip) {
        errno = EADDRNOTAVAIL; return -1;
    }
    g_fds[fd].sk = calloc(1, sizeof *g_fds[fd].sk);
    if (g_fds[fd].sk == NULL) return -1;
    g_fds[fd].sk->sport = port; g_fds[fd].sk->saddr = addr;
    g_fds[fd].sk->rcv_wnd = MT_TCP_RCV_BUF; g_fds[fd].sk->mss = MT_TCP_MSS_DEFAULT;
    return 0;
}

int mt_listen(int fd, int backlog)
{
    (void)backlog;
    if (fd < 0 || fd >= MT_MAX_FD || g_fds[fd].sk == NULL) { errno = EINVAL; return -1; }
    g_fds[fd].sk->state = MT_LISTEN;
    g_fds[fd].sk->next = g_stack.listener;
    g_stack.listener = g_fds[fd].sk;
    return 0;
}

int mt_accept(int fd, char *peer, size_t cap, uint16_t *pport)
{
    if (fd < 0 || fd >= MT_MAX_FD || g_fds[fd].sk == NULL ||
        g_fds[fd].sk->state != MT_LISTEN) { errno = EINVAL; return -1; }
    for (;;) {
        if (g_stack.acceptq != NULL) {
            struct mt_sock *sk = g_stack.acceptq;
            int i;
            g_stack.acceptq = sk->next; sk->next = NULL;
            for (i = 0; i < MT_MAX_FD && g_fds[i].kind != 0; i++) ;
            if (i == MT_MAX_FD) { errno = EMFILE; return -1; }
            g_fds[i].kind = 2; g_fds[i].sk = sk;
            if (peer != NULL) mt_ip_str(sk->daddr, peer, cap);
            if (pport != NULL) *pport = sk->dport;
            return i;
        }
        if (mt_wait(100) < 0) return -1;
    }
}

int mt_connect(int fd, const char *ip, uint16_t port, int timeout_ms)
{
    struct mt_sock *sk;
    uint32_t addr, deadline;
    if (fd < 0 || fd >= MT_MAX_FD) { errno = EBADF; return -1; }
    if (mt_parse_ip(ip, &addr) < 0) { errno = EINVAL; return -1; }
    if (g_fds[fd].sk == NULL) {
        g_fds[fd].sk = calloc(1, sizeof *g_fds[fd].sk);
        if (g_fds[fd].sk == NULL) return -1;
        g_fds[fd].sk->rcv_wnd = MT_TCP_RCV_BUF;
        g_fds[fd].sk->mss = MT_TCP_MSS_DEFAULT;
    }
    sk = g_fds[fd].sk;
    sk->sport = sk->sport ? sk->sport : mt_ephemeral_port();
    sk->saddr = g_stack.ip; sk->daddr = addr; sk->dport = port;
    sk->state = MT_SYN_SENT;
    sk->iss = mt_gen_iss(&g_stack, sk->saddr, sk->daddr, sk->sport, sk->dport);
    sk->snd_una = sk->snd_nxt = sk->iss;
    sk->snd_wnd = 65535;
    tcp_emit(&g_stack, sk, MT_TCP_SYN, sk->iss, 0, NULL, 0);
    sk->snd_nxt = sk->iss + 1;
    sk->next = g_stack.tcb; g_stack.tcb = sk;
    g_fds[fd].kind = 2;
    deadline = (uint32_t)(g_stack.now_ms + (uint64_t)(timeout_ms < 0 ? 10000 : timeout_ms));
    while (sk->state == MT_SYN_SENT) {
        if (mt_wait(50) < 0) return -1;
        if (g_stack.now_ms > deadline) { errno = ETIMEDOUT; return -1; }
    }
    if (sk->state != MT_ESTABLISHED) { errno = ECONNREFUSED; return -1; }
    return 0;
}

ssize_t mt_read(int fd, void *buf, size_t len)
{
    if (fd < 0 || fd >= MT_MAX_FD || g_fds[fd].kind != 2) { errno = ENOTCONN; return -1; }
    for (;;) {
        ssize_t n = mt_tcp_read(&g_stack, g_fds[fd].sk, buf, len);
        if (n > 0) return n;
        if (g_fds[fd].sk->eof || g_fds[fd].sk->state == MT_CLOSED) return 0;
        if (mt_wait(100) < 0) return -1;
    }
}

ssize_t mt_write(int fd, const void *buf, size_t len)
{
    if (fd < 0 || fd >= MT_MAX_FD || g_fds[fd].kind != 2) { errno = ENOTCONN; return -1; }
    return mt_tcp_write(&g_stack, g_fds[fd].sk, buf, len);
}

int mt_close(int fd)
{
    int rc = 0;
    if (fd < 0 || fd >= MT_MAX_FD || g_fds[fd].kind == 0) { errno = EBADF; return -1; }
    if (g_fds[fd].kind == 2 && g_fds[fd].sk != NULL) {
        rc = mt_tcp_close(&g_stack, g_fds[fd].sk);
        g_fds[fd].sk = NULL;      /* 不立即 free：FIN 重传还要用 */
    }
    g_fds[fd].kind = 0;
    return rc;
}
```

**验证**：

```bash
make
sudo ip netns exec mtlab ./build/mytcp --tap tap0 --ip 10.0.0.2 --http 80 &
sudo ip netns exec mthost curl -sv http://10.0.0.2/ 2>&1 | head -12
# 预期：HTTP/1.1 200 OK + hello from mytcp
for i in $(seq 1 50); do sudo ip netns exec mthost nc -z -w1 10.0.0.2 80; done
# 全部成功；退出时 TCB 回落到 0（无 fd 泄漏）
```

**常见错误**

| 现象 | 原因 | 修复 |
|:--|:--|:--|
| 第二次 `accept` 永久阻塞 | 摘链时没 `sk->next = NULL` | 摘一个断一个 |
| `read` 返回 `ENOTCONN` | `kind` 没在 accept 里置 2 | 两处都设置 |
| `write` 只写 1448 字节 | 应用没循环；或 `sndbuf` 太小 | 循环写；缓冲至少 64 KB |
| `connect` 偶发超时 | 临时端口撞监听端口 / ARP 未回 | 端口分配跳过监听端口 |
| `close` 后旧 FIN 干扰新连接 | 四元组复用且 TCB 未回收 | 新连接用新端口，或等 `TIME_WAIT` |

**下一步**：API 有了，但还没有像样的应用。Stage 6 在栈上跑一个最小 HTTP 服务器，让 Linux 侧 `curl` 走完整流程。

### C.1.9 Stage 6 · 与 Linux 栈互通：HTTP 演示 {#sec-c.1.9}

**目标**

```bash
sudo ip netns exec mtlab ./build/mytcp --tap tap0 --ip 10.0.0.2 --http 80 &
sudo ip netns exec mthost curl -s http://10.0.0.2/
# 预期：hello from mytcp
```

**关键概念**：`mthost` 的 `10.0.0.1/24` 与 `10.0.0.2` 同网段，内核直接发 ARP；ARP 经 `veth-b → veth-a → br0 → tap0` 到你的进程，你回 ARP 后内核把 MAC 学进 `neigh`；之后 SYN 走同一条路。**不能把 `10.0.0.1/24` 直接配在 `tap0` 上**：内核收到目的 MAC 不是本接口的帧会标 `PACKET_OTHERHOST` 并在 IP 层丢弃，所以必须用网桥（C.0.1）。

HTTP 服务器只需三件事：读到 `\r\n\r\n`、按路径选响应、写回并关闭。必须带 `Content-Length` 与 `Connection: close`，否则 `curl` 等到超时。

**代码：最小 HTTP 服务**

```c
/* src/http.c */
#include "api.h"
#include <stdio.h>
#include <string.h>

static const char *body_for(const char *path)
{
    if (strcmp(path, "/") == 0) return "hello from mytcp\n";
    if (strcmp(path, "/stats") == 0) return "see stderr\n";
    return NULL;
}

static void serve_one(int cfd)
{
    char req[4096], method[8], path[256], ver[16], hdr[256];
    size_t used = 0;
    const char *body;
    int n;

    while (used < sizeof req - 1) {
        ssize_t r = mt_read(cfd, req + used, sizeof req - 1 - used);
        if (r <= 0) return;
        used += (size_t)r; req[used] = '\0';
        if (strstr(req, "\r\n\r\n") != NULL) break;
    }
    if (sscanf(req, "%7s %255s %15s", method, path, ver) != 3) return;
    body = strcmp(method, "GET") != 0 ? "method not allowed\n" : body_for(path);
    if (strcmp(method, "GET") != 0) {
        n = snprintf(hdr, sizeof hdr, "HTTP/1.1 405 Method Not Allowed\r\n"
                     "Content-Length: %zu\r\nConnection: close\r\n\r\n", strlen(body));
    } else if (body == NULL) {
        body = "not found\n";
        n = snprintf(hdr, sizeof hdr, "HTTP/1.1 404 Not Found\r\n"
                     "Content-Length: %zu\r\nConnection: close\r\n\r\n", strlen(body));
    } else {
        n = snprintf(hdr, sizeof hdr, "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n"
                     "Content-Length: %zu\r\nConnection: close\r\n\r\n", strlen(body));
    }
    (void)mt_write(cfd, hdr, (size_t)n);
    (void)mt_write(cfd, body, strlen(body));
}

void http_loop(uint16_t port)
{
    int lfd = mt_socket(AF_INET, SOCK_STREAM, 0);
    if (lfd < 0 || mt_bind(lfd, "10.0.0.2", port) < 0 || mt_listen(lfd, 16) < 0) {
        perror("http listen"); return;
    }
    fprintf(stderr, "[http] listening on %u\n", port);
    for (;;) {
        char peer[32]; uint16_t pport;
        int cfd = mt_accept(lfd, peer, sizeof peer, &pport);
        if (cfd < 0) continue;
        serve_one(cfd);
        mt_close(cfd);
    }
}
```

**验证**

```bash
make
sudo ip netns exec mtlab ./build/mytcp --tap tap0 --ip 10.0.0.2 --http 80 &
sleep 0.5
sudo ip netns exec mthost curl -s -D- http://10.0.0.2/
# 预期：HTTP/1.1 200 OK、Content-Length: 17、hello from mytcp
sudo ip netns exec mthost ip neigh show 10.0.0.2
# 预期：... lladdr 02:00:00:00:00:02 REACHABLE
sudo ip netns exec mtlab tcpdump -i br0 -nn -vv -c 8 'tcp port 80'
# 预期：S/S././P./F.，无 "bad tcp cksum"
sudo pkill -INT mytcp
```

404 也测：`curl -s -o /dev/null -w '%{http_code}\n' http://10.0.0.2/nope` 应为 `404`。

**常见错误**

| 现象 | 原因 | 修复 |
|:--|:--|:--|
| `curl: (7) Failed to connect` | ARP 没回 / `tap0` 没入网桥 | `bridge link show`，重做 C.0.1 |
| `curl` 挂起 | 响应缺 `Content-Length` 或 `Connection: close` | 两者都带 |
| body 为空 | `mt_write` 短写没循环 | 按返回值循环写 |
| `Empty reply` | 没写完就 close | 先写完再 `mt_close` |
| 只有 `ping` 通 | `curl` 走了 IPv6/代理 | `curl -4 --noproxy '*'` |

**下一步**：功能齐了，但「能跑」不等于「跑得好」。Stage 7 加计数器、延迟 ACK、批量收包，并给出可复现的对比方法。

### C.1.10 Stage 7 · 性能与调试 {#sec-c.1.10}

**目标**：建立可观测性（字节、重传、RTT、窗口），做三项优化并用数据证明，形成排查顺序表。

**关键概念**：用户态栈的开销依次是**每包一次系统调用**、**多次拷贝**、**纯软件校验和**、**每段一个 ACK**。优化要按 `perf` 的结论排序；先优化 3% 的那一项，只会让复杂度翻倍。

| 优化 | 做法 | 收益 | 代价 |
|:--|:--|:--|:--|
| 批量收包 | 一次 `poll` 后读到 `EAGAIN` | 减少 `poll` | 单轮延迟略增 |
| 延迟 ACK | 每 2 段或 40 ms 回一个 | ACK 数量减半 | 交互延迟增加 |
| 环形发送缓冲 | 去掉 `memmove` | 大流量拷贝减半 | 复杂度上升 |
| RTO 自适应 | RFC 6298 | 丢包恢复更快 | 采样必须正确 |

**代码：计数器与延迟 ACK**

```c
/* include/stack.h */
struct mt_stats {
    uint64_t rx_frames, rx_segs, tx_segs, rx_csum, retx, retx_fail;
    uint64_t dup_acks, rx_dropped, tx_rst, bytes_tx, bytes_rx;
};
/* struct mt_sock 追加 */
    uint8_t ack_pending, ack_segs;
    uint64_t ack_at_ms;
```

```c
/* src/tcp.c */
static void tcp_maybe_ack(struct mt_stack *st, struct mt_sock *sk, int force)
{
    if (!sk->ack_pending) {
        sk->ack_pending = 1; sk->ack_segs = 0; sk->ack_at_ms = st->now_ms;
    }
    sk->ack_segs++;
    if (force || sk->ack_segs >= 2 || st->now_ms - sk->ack_at_ms >= 40) {
        tcp_emit(st, sk, MT_TCP_ACK, sk->snd_nxt, sk->rcv_nxt, NULL, 0);
        sk->ack_pending = 0; sk->ack_segs = 0;
    }
}

void mt_stats_dump(const struct mt_stack *st)
{
    const struct mt_stats *s = &st->stats;
    double rate = s->tx_segs ? 100.0 * (double)s->retx / (double)s->tx_segs : 0.0;
    fprintf(stderr, "[stats] frames=%llu rx_seg=%llu tx_seg=%llu csum=%llu\n"
            "[stats] tx=%lluB rx=%lluB retx=%llu(%.2f%%) fail=%llu dupack=%llu\n",
            (unsigned long long)s->rx_frames, (unsigned long long)s->rx_segs,
            (unsigned long long)s->tx_segs, (unsigned long long)s->rx_csum,
            (unsigned long long)s->bytes_tx, (unsigned long long)s->bytes_rx,
            (unsigned long long)s->retx, rate, (unsigned long long)s->retx_fail,
            (unsigned long long)s->dup_acks);
}
```

**验证与对比**

```bash
sudo ip netns exec mtlab ./build/mytcp --tap tap0 --ip 10.0.0.2 --sink 7 &
sudo ip netns exec mthost sh -c 'time dd if=/dev/zero bs=1M count=10 | nc -N 10.0.0.2 7'
sudo pkill -INT mytcp                       # 看 [stats]

sudo ip netns exec mtlab perf record -g ./build/mytcp --tap tap0 --ip 10.0.0.2 --sink 7
sudo ip netns exec mtlab perf report --stdio | head -20
sudo ip netns exec mtlab strace -c -f ./build/mytcp --tap tap0 --ip 10.0.0.2 --sink 7
```

预期量级（**未实测**，只判断数量级）：单连接 1024 字节段，吞吐 20–80 MB/s；无丢包时重传率为 0；veth 上平均 RTT 几十微秒。低于 5 MB/s 时先看 `strace -c` 是否每段一次 `poll`，再看 `perf` 是否 `memcpy` 占大头。

**排查顺序**（不要跳）：`ping` → `nc -z` → 1 字节回显 → 1 KB 回显 → 1 MB `cmp` → 5% 丢包 `cmp` → 吞吐/重传率。

**常见错误**

| 现象 | 原因 | 修复 |
|:--|:--|:--|
| 开延迟 ACK 后 `curl` 变慢 | 交互流量被 40 ms 拖住 | 对 PSH/小段强制立即 ACK |
| `retx` 高但数据正确 | dup ACK 触发伪重传 | 检查 `snd_wnd` 与采样 |
| 吞吐随连接数下降 | 单线程 + 线性扫描 | 四元组哈希；或 `epoll` |
| `perf` 全是 `sys_write` | 每段一次 `write` | 批量发送 |
| `bytes_tx` 翻倍 | 重传也计入 | 分列 `bytes_tx`/`bytes_retx` |

**下一步**：C.1 结束。你已经有一个能握手、能传文件、能被 `curl` 访问的用户态栈。C.2 回到内核栈之上写代理，C.3 再回头用抓包验证这两者。
## C.2 反向代理：`myproxy` {#sec-c.2}

C.1 让你知道一个字节从网卡到应用要经过什么；C.2 换个位置：**站在内核 TCP 之上，把「连接」当成可调度的资源**。`myproxy` 是一个 HTTP/1.1 反向代理，最终要能扛住 `wrk`，并且在上游故障、客户端半关闭、进程收到 `SIGTERM` 时都不丢请求、不泄漏 fd。

```text
客户端 ──TCP──▶ myproxy ──TCP──▶ 上游（mytcp / nginx / python -m http.server）
                 │
                 ├─ epoll 事件循环（C.2 Stage 0）
                 ├─ HTTP 解析与首部改写（Stage 1）
                 ├─ 上游长连接池（Stage 2）
                 ├─ 轮询/最少连接 + 健康检查（Stage 3）
                 ├─ 超时、重试、优雅关闭（Stage 4）
                 ├─ splice 零拷贝（Stage 5）
                 ├─ TLS 透传 / SNI 路由（Stage 6）
                 └─ wrk 压测与瓶颈定位（Stage 7）
```

目录与 C.1 平行：`include/{loop,http,pool,balancer,proxy,sni}.h`，`src/{loop,http,pool,balancer,proxy,sni,main}.c`，`tests/{test_http,test_pool}.c`。构建沿用 C.0.3 的 Makefile 模板，只把 `BIN` 改成 `build/myproxy`，并追加 `-pthread`（健康检查线程可选；本页的检查是事件循环内的定时任务，不需要线程）。

**范围**：只做 HTTP/1.1 明文与 TLS 透传（不解密）；不做 HTTP/2、不做 WebSocket 升级（Stage 6 提一句）、不做缓存、不做动态上游发现。所有「未实测」的性能数字都只是量级参考。

### C.2.1 Stage 0 · epoll 事件循环 {#sec-c.2.1}

**目标**：`./build/myproxy --listen 8080 --upstream 127.0.0.1:9000` 能把任意 TCP 字节双向转发；`strace -c` 显示 `epoll_wait` 次数远少于 `read/write` 次数。

**关键概念**：监听 fd 用**水平触发**最省心，连接 fd 用**边沿触发 + 非阻塞 + 读到 `EAGAIN`** 最省事件；`accept` 必须循环到 `EAGAIN`，否则边沿触发下会漏连接；写不完的数据挂到 `out` 缓冲并注册 `EPOLLOUT`，**不要**在 `EPOLLIN` 回调里阻塞写。`EPOLLRDHUP` 表示对端半关闭，仍可能有过路数据，要先读完再关。

```c
/* src/loop.c —— 完整骨架：注册、accept、读、写、关闭 */
#include "loop.h"
#include <errno.h>
#include <fcntl.h>
#include <sys/epoll.h>
#include <unistd.h>

int px_nonblock(int fd)
{
    int fl = fcntl(fd, F_GETFL, 0);
    return fl < 0 ? -1 : fcntl(fd, F_SETFL, fl | O_NONBLOCK);
}

static int px_add(int ep, int fd, uint32_t ev, void *ptr)
{
    struct epoll_event e = { .events = ev, .data.ptr = ptr };
    return epoll_ctl(ep, EPOLL_CTL_ADD, fd, &e);
}

void px_loop(struct px_proxy *p)
{
    struct epoll_event evs[256];

    for (;;) {
        int n = epoll_wait(p->ep, evs, 256, 200);   /* 200ms 跑定时器 */
        if (n < 0) {
            if (errno == EINTR) continue;
            break;
        }
        for (int i = 0; i < n; i++) {
            struct px_conn *c = evs[i].data.ptr;
            uint32_t e = evs[i].events;
            if (c->kind == PX_LISTEN) {
                for (;;) {
                    int fd = accept4(c->fd, NULL, NULL, SOCK_NONBLOCK | SOCK_CLOEXEC);
                    if (fd < 0) break;               /* EAGAIN 或 EMFILE */
                    px_conn_new(p, fd, PX_CLIENT);
                }
            } else {
                if (e & (EPOLLERR | EPOLLHUP)) { px_close(p, c); continue; }
                if (e & EPOLLIN)  px_on_readable(p, c);   /* 内部循环读到 EAGAIN */
                if (e & EPOLLOUT) px_on_writable(p, c);
                if ((e & EPOLLRDHUP) && c->in.len == 0) px_half_close(p, c);
            }
        }
        px_timers(p);
    }
}
```

`px_on_readable` 的纪律：`read` 返回 `EINTR` 重试、`EAGAIN` 退出循环、`0` 标记 EOF、`>0` 追加到 `in` 后交给 Stage 1 的解析器；缓冲超过 `MAX_HEADER + MAX_BODY` 直接回 413 并关连接，不要无限增长。

**验证**：

```bash
make && ./build/myproxy --listen 8080 --upstream 127.0.0.1:9000 &
python3 -m http.server 9000 --bind 127.0.0.1 &
curl -s http://127.0.0.1:8080/ | head -3
strace -c -p $(pgrep -n myproxy)   # 压测后看 epoll_wait/read/write 比例
```

**常见错误**

| 现象 | 原因 | 修复 |
|:--|:--|:--|
| 压测时连接数上不去 | `accept` 只调一次 | 循环 `accept4` 到 `EAGAIN` |
| CPU 100% 但无流量 | 边沿触发下没读到 `EAGAIN` | 读循环直到 `EAGAIN` |
| 大响应卡住 | 没注册 `EPOLLOUT`，或写一半就返回 | 维护 `out.off`，注册 `EPOLLOUT` |
| `EPOLLHUP` 后仍读写 | 事件顺序没处理 | `ERR|HUP` 优先关闭 |

**下一步**：现在是字节转发。Stage 1 解析 HTTP，才能实现连接复用、首部改写和按路径路由。

### C.2.2 Stage 1 · HTTP/1.1 解析与转发 {#sec-c.2.2}

**目标**：正确解析请求行/首部，支持 `Content-Length` 请求体，把**绝对 URI 改写为 origin-form**，剥掉 hop-by-hop 首部，按 `Connection: keep-alive` 决定复用。

**关键概念**：请求行三部分以空格分隔；首部以 `\r\n` 结束、`\r\n\r\n` 终止；首部名大小写不敏感；`Transfer-Encoding: chunked` 必须原样透传（不要试图解析 chunk 长度）；hop-by-hop 首部（`Connection`、`Keep-Alive`、`Proxy-*`、`TE`、`Trailer`、`Upgrade`）不能透传；`Host` 必须保留且唯一。

```c
/* src/http.c —— 增量解析：返回 1=完成，0=需要更多数据，-1=非法 */
#include "http.h"
#include <ctype.h>
#include <string.h>
#include <strings.h>

static char *find_crlfcrlf(char *b, size_t n)
{
    for (size_t i = 0; i + 3 < n; i++)
        if (b[i] == '\r' && b[i+1] == '\n' && b[i+2] == '\r' && b[i+3] == '\n')
            return b + i;
    return NULL;
}

int px_http_parse(struct px_http *h, char *buf, size_t len, size_t *consumed)
{
    char *end = find_crlfcrlf(buf, len), *line, *next;
    size_t hdr_len;

    if (end == NULL) return len > PX_MAX_HEADER ? -1 : 0;
    hdr_len = (size_t)(end - buf) + 4;
    *end = '\0';
    line = strstr(buf, "\r\n");
    if (line == NULL) return -1;
    *line = '\0';
    if (sscanf(buf, "%7s %255s HTTP/%d.%d", h->method, h->target,
               &h->ver_major, &h->ver_minor) != 4) return -1;
    h->keep_alive = h->ver_minor >= 1;
    h->content_length = 0;
    h->chunked = 0;
    for (next = line + 2; *next != '\0'; next = line + 2) {
        char *colon, *val;
        line = strstr(next, "\r\n");
        if (line == NULL) break;
        *line = '\0';
        colon = strchr(next, ':');
        if (colon == NULL) return -1;
        *colon = '\0';
        for (val = colon + 1; *val == ' ' || *val == '\t'; val++) ;
        if (strcasecmp(next, "Content-Length") == 0)
            h->content_length = strtoul(val, NULL, 10);
        else if (strcasecmp(next, "Transfer-Encoding") == 0 &&
                 strcasestr(val, "chunked") != NULL)
            h->chunked = 1;
        else if (strcasecmp(next, "Connection") == 0)
            h->keep_alive = strcasestr(val, "keep-alive") != NULL;
    }
    /* 绝对 URI → origin-form，保留 query */
    if (strncmp(h->target, "http://", 7) == 0) {
        char *slash = strchr(h->target + 7, '/');
        if (slash == NULL) strcpy(h->target, "/");
        else memmove(h->target, slash, strlen(slash) + 1);
    }
    h->body_off = hdr_len;
    *consumed = hdr_len;
    return 1;
}
```

转发时按顺序写：`METHOD SP target SP HTTP/1.1\r\n`、逐条首部（跳过 hop-by-hop 与 `Proxy-Connection`）、补 `Connection: keep-alive` 或 `close`、空行、body。**请求行必须重写**，否则多数上游返回 400——这是 C.1 Stage 6 没做、这里必须补上的一步。

**验证**：

```bash
curl -s -o /dev/null -w '%{http_code}\n' -x http://127.0.0.1:8080 http://127.0.0.1:9000/
# 预期 200；上游日志里的请求行是 "GET / HTTP/1.1" 而不是绝对 URI。
printf 'GET / HTTP/1.1\r\nHost: x\r\n\r\n' | nc 127.0.0.1 8080 | head -1
```

**常见错误**

| 现象 | 原因 | 修复 |
|:--|:--|:--|
| 上游 400 | 转发了绝对 URI | 改写成 origin-form |
| POST body 丢失 | 只转发首部，没等 body 到齐 | 按 `Content-Length` 或 chunked 透传 |
| 长连接第二次请求 400 | 缓冲区没消费掉第一条请求 | 用 `consumed` 前移剩余数据 |
| 首部大小写导致漏判 | 用了 `strcmp` | 一律 `strcasecmp` |

**下一步**：每条请求都新建上游连接，压测时 `TIME_WAIT` 会爆炸。Stage 2 做连接池。

### C.2.3 Stage 2 · 上游连接池 {#sec-c.2.3}

**目标**：同一上游 host:port 复用空闲连接；空闲超过 30 s 或对端已关闭的连接要剔除；池满时按 LRU 关闭；`wrk` 下 `ss -tan state time-wait` 数量显著下降。

**关键概念**：池里存的是**已连接但当前无请求**的 fd；取用前必须用 `recv(fd, &c, 1, MSG_PEEK | MSG_DONTWAIT)` 探测——返回 0 说明对端已关，返回 -1 且 `EAGAIN` 才是健康；HTTP/1.1 的复用前提是**上一个响应完整读完**（有 `Content-Length` 或 chunked 终止），否则连接状态已脏，必须关。

```c
/* src/pool.c */
#include "pool.h"
#include <errno.h>
#include <sys/socket.h>
#include <unistd.h>

struct px_upstream *px_pool_get(struct px_pool *pool, const char *host, uint16_t port)
{
    struct px_upstream **pp = &pool->idle;
    while (*pp != NULL) {
        struct px_upstream *u = *pp;
        char c;
        ssize_t r;
        if (u->port != port || strcmp(u->host, host) != 0) { pp = &u->next; continue; }
        r = recv(u->fd, &c, 1, MSG_PEEK | MSG_DONTWAIT);
        if (r == 0 || (r < 0 && errno != EAGAIN && errno != EWOULDBLOCK)) {
            *pp = u->next;                 /* 对端已关，剔除 */
            close(u->fd); free(u); continue;
        }
        *pp = u->next;
        u->next = NULL;
        return u;
    }
    return NULL;
}

void px_pool_put(struct px_pool *pool, struct px_upstream *u, uint64_t now_ms)
{
    u->idle_since = now_ms;
    if (pool->count >= PX_POOL_MAX) {
        close(u->fd); free(u); return;     /* 简单策略：池满即关 */
    }
    u->next = pool->idle;
    pool->idle = u;
    pool->count++;
}

void px_pool_sweep(struct px_pool *pool, uint64_t now_ms)
{
    struct px_upstream **pp = &pool->idle;
    while (*pp != NULL) {
        struct px_upstream *u = *pp;
        if (now_ms - u->idle_since < PX_IDLE_MS) { pp = &u->next; continue; }
        *pp = u->next;
        close(u->fd); free(u); pool->count--;
    }
}
```

池的 key 用 `host:port` 字符串而非 IP，避免 DNS 变更后仍连旧地址；每次从池里取不到才 `getaddrinfo` + `connect`，且 `connect` 要非阻塞 + `EPOLLOUT` 等完成，不能阻塞事件循环。

**验证**：

```bash
wrk -t2 -c64 -d10s http://127.0.0.1:8080/
ss -tan | awk '$1=="TIME-WAIT"' | wc -l
# 对比 Stage 1（每请求新连接）与 Stage 2 的 TIME_WAIT 数量
```

**常见错误**

| 现象 | 原因 | 修复 |
|:--|:--|:--|
| 复用后收到上一次的响应 | 响应没读完就归还 | 按 Content-Length/chunked 读完再 `put` |
| 偶发 `Connection reset` | 复用了对端刚关闭的连接 | 取用前 `MSG_PEEK` 探测 |
| fd 泄漏 | 池满时只丢指针没 `close` | 每条路径都关 fd |
| 内存涨 | `getaddrinfo` 结果没 `freeaddrinfo` | 成对释放 |

**下一步**：池里有多台上游时，需要选择策略与健康检查。

### C.2.4 Stage 3 · 负载均衡与健康检查 {#sec-c.2.4}

**目标**：支持多上游（`--upstream` 可重复），实现轮询与最少连接两种策略；被动健康检查（连续 3 次连接失败/5xx 标记 DOWN，30 s 后放一个探测请求）与主动检查（每 5 s 发 `GET /healthz`）。

**关键概念**：被动检查零成本但有滞后；主动检查要**限制并发**且不能在事件循环里同步 `connect`。最少连接需要维护 `inflight`，在请求开始/结束时加减。健康状态用 `up/down/unknown` 三态，`down` 的上游不参与选择，全部 `down` 时退化为轮询并快速失败。

```c
/* src/balancer.c */
#include "balancer.h"
#include <string.h>

struct px_upstream *px_pick(struct px_balancer *b)
{
    struct px_upstream *best = NULL;

    for (int i = 0; i < b->n; i++) {
        struct px_upstream *u = &b->ups[i];
        if (u->health == PX_DOWN) continue;
        if (b->policy == PX_ROUND_ROBIN) {
            best = &b->ups[b->rr++ % b->n];
            if (best->health != PX_DOWN) break;
            best = NULL;
        } else {                       /* least_conn */
            if (best == NULL || u->inflight < best->inflight) best = u;
        }
    }
    if (best == NULL) {                /* 全挂：退化为轮询，尽快 502 */
        b->rr = (b->rr + 1) % (b->n ? b->n : 1);
        best = b->n ? &b->ups[b->rr] : NULL;
    }
    return best;
}

void px_report(struct px_balancer *b, struct px_upstream *u, int ok)
{
    if (ok) { u->fail = 0; u->health = PX_UP; return; }
    if (++u->fail >= 3) {
        u->health = PX_DOWN;
        u->retry_at = b->now_ms + 30000;   /* 30s 后半开 */
    }
}
```

半开逻辑：`px_timers` 里对 `DOWN && now >= retry_at` 的上游置 `PROBING`，只放一个请求过去；成功转 `UP`，失败重新计时。主动检查用同一个非阻塞 `connect` 路径，结果走 `px_report`，不要另写一套。

**验证**：

```bash
./build/myproxy --listen 8080 --upstream 127.0.0.1:9000 --upstream 127.0.0.1:9001 \
                --policy least_conn
for i in $(seq 1 6); do curl -s -o /dev/null -w '%{http_code} ' http://127.0.0.1:8080/; done
# 杀掉 9001 后继续压：应看到 502 短暂出现，随后全部落到 9000
```

**常见错误**

| 现象 | 原因 | 修复 |
|:--|:--|:--|
| 轮询下标越界 | `rr % n` 在 `n==0` 时除零 | 先判空 |
| 全 DOWN 后永久 502 | 没有半开探测 | `retry_at` + `PROBING` |
| 最少连接总选中同一台 | `inflight` 没在结束时减 | 请求完成/失败都 `--` |
| 主动检查拖慢主循环 | 同步 `connect` | 非阻塞 + 事件回调 |

**下一步**：上游会慢、会挂、会半关闭。Stage 4 用超时、有限重试和优雅关闭把这些边界收干净。

### C.2.5 Stage 4 · 超时、重试与优雅关闭 {#sec-c.2.5}

**目标**：连接建立、首部读取、响应体传输、空闲复用各有独立超时；只对**幂等方法**且在「尚未向上游写出任何字节」时重试；`SIGTERM` 后停止 accept，等在途请求完成（上限 10 s），再关所有 fd。

**关键概念**：超时不是「一个 `SO_RCVTIMEO` 管全部」——非阻塞循环里要自己记 `deadline`；重试必须区分「连接失败」（可换上游）与「已发出请求后失败」（POST 重试会重复下单）；优雅关闭要能区分**空闲长连接**（立即关）与**在途请求**（等完成）。`SIGTERM` 处理器里只置 `volatile sig_atomic_t`，真正的关闭逻辑在主循环。

```c
/* src/proxy.c */
#include "proxy.h"
#include <signal.h>
#include <string.h>

static volatile sig_atomic_t g_term;

static void on_term(int sig) { (void)sig; g_term = 1; }

static int idempotent(const char *m)
{
    return strcmp(m, "GET") == 0 || strcmp(m, "HEAD") == 0 ||
           strcmp(m, "OPTIONS") == 0;
}

/* 返回 0=已重试，-1=不能重试（交给 502/504） */
int px_maybe_retry(struct px_proxy *p, struct px_conn *c, int reason)
{
    if (c->tried >= 2 || c->upstream_written > 0 ||
        !idempotent(c->req.method))
        return -1;
    c->tried++;
    px_upstream_release(p, c, 0);          /* 丢弃坏连接，不归还池 */
    c->state = PX_CONNECTING;
    c->deadline = p->now_ms + 3000;
    (void)reason;
    return 0;
}

void px_check_timeouts(struct px_proxy *p)
{
    struct px_conn *c, *next;
    for (c = p->conns; c != NULL; c = next) {
        next = c->next;
        if (p->now_ms < c->deadline) continue;
        switch (c->state) {
        case PX_CONNECTING: px_reply_error(p, c, 504); break;
        case PX_READ_HEADER: px_reply_error(p, c, 408); break;
        case PX_STREAMING:
            if (c->req.idempotent && px_maybe_retry(p, c, 0) == 0) continue;
            px_reply_error(p, c, 504); break;
        default:
            if (c->upstream != NULL) px_upstream_release(p, c, 0);
            px_close(p, c);
            break;
        }
    }
}

void px_graceful(struct px_proxy *p)
{
    if (!g_term) return;
    if (!p->draining) {
        p->draining = 1;
        p->drain_deadline = p->now_ms + 10000;
        close(p->listen_fd);
        p->listen_fd = -1;                 /* epoll 自动移除 */
        fprintf(stderr, "[proxy] draining...\n");
    }
    if (p->inflight == 0 || p->now_ms >= p->drain_deadline) {
        px_close_all(p);
        p->running = 0;
    }
}
```

**验证**：

```bash
./build/myproxy --listen 8080 --upstream 10.0.0.9:80 &   # 不可达上游
time curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8080/
# 预期 504，约 3 秒返回；日志显示 2 次重试

kill -TERM %1; time wait
# 预期：不再接新连接；在途请求完成后退出，最长 10 秒
```

**常见错误**

| 现象 | 原因 | 修复 |
|:--|:--|:--|
| 504 秒回 | 没设 deadline，事件循环空转 | 每连接 `deadline` + 定时扫描 |
| POST 被重试两次 | 没判幂等/已写字节 | `upstream_written > 0` 禁止重试 |
| `kill -TERM` 直接断连 | 没装处理器，默认终止 | 只置标志，主循环 drain |
| 优雅关闭一直不退 | 空闲长连接计入 inflight | 空闲连接立即关，只等 in-flight |

**下一步**：Stage 5 处理大响应体，用 `splice` 把内核缓冲直接对接，避免用户态拷贝。

### C.2.6 Stage 5 · 零拷贝：splice 与 sendfile {#sec-c.2.6}

**目标**：代理大文件时，用户态不碰 body；`perf` 中 `memcpy` 占比明显下降；能用 `sendfile` 直接服务静态文件。

**关键概念**：`splice(fd_in, NULL, pipe_w, NULL, len, SPLICE_F_MOVE)` 把数据从 socket 移到管道，再从管道移到另一个 socket，全程在内核页缓存里；两个 `splice` 之间用**固定 64 KB 管道**，避免管道写满死锁；`sendfile(out, in, &off, count)` 适合「文件 → socket」，不适合 socket → socket。TLS 连接不能 `splice`（数据要解密），chunked 编码的 body 也不能直接按长度搬。

```c
/* src/zerocopy.c */
#include "zerocopy.h"
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>

int px_splice_all(int in, int out, size_t len)
{
    int p[2];
    if (pipe2(p, O_NONBLOCK | O_CLOEXEC) < 0) return -1;
    while (len > 0) {
        size_t chunk = len < 65536 ? len : 65536;
        ssize_t n = splice(in, NULL, p[1], NULL, chunk,
                           SPLICE_F_MOVE | SPLICE_F_NONBLOCK);
        if (n < 0) {
            if (errno == EINTR) continue;
            if (errno == EAGAIN) { /* 等 EPOLLIN 后重试 */ close(p[0]); close(p[1]); return 0; }
            close(p[0]); close(p[1]); return -1;
        }
        if (n == 0) break;
        len -= (size_t)n;
        for (ssize_t off = 0; off < n; ) {
            ssize_t w = splice(p[0], NULL, out, NULL, (size_t)(n - off),
                               SPLICE_F_MOVE | SPLICE_F_NONBLOCK);
            if (w < 0) {
                if (errno == EINTR) continue;
                close(p[0]); close(p[1]); return -1;   /* EAGAIN 需 EPOLLOUT 状态机 */
            }
            off += w;
        }
    }
    close(p[0]); close(p[1]);
    return 0;
}
```

生产实现不能像上面这样在 `EAGAIN` 时直接放弃：要把管道 fd 也注册进 epoll，用 `EPOLLOUT` 驱动「管道可写」和「目标 socket 可写」两个状态。本页给出的是**同步版本**，只适合「目标 socket 一直可写」的基准测试；压测时请用状态机版本，否则会丢数据。

**验证**：

```bash
# 准备 100MB 文件，python http.server 支持 Range 但不支持 sendfile；
# 用本代理的 --static 模式对比
./build/myproxy --listen 8080 --static /tmp/big.bin &
curl -s -o /dev/null -w '%{speed_download}\n' http://127.0.0.1:8080/
perf stat -e cycles,instructions,cache-misses ./build/myproxy --listen 8081 --static /tmp/big.bin
```

**常见错误**

| 现象 | 原因 | 修复 |
|:--|:--|:--|
| `splice: Invalid argument` | 两个 fd 类型不支持（如普通文件→socket） | 文件用 `sendfile`，socket 用 `splice` |
| 传输卡死 | 管道写满后没读 | 写一段读一段，或注册 `EPOLLOUT` |
| 数据少一截 | `splice` 返回值没累加 | 循环到 `len==0` |
| HTTPS 代理乱码 | 对加密数据 `splice` | TLS 必须解密后再转发 |

**下一步**：Stage 6 处理 TLS：不解密，只按 SNI 路由；以及 `CONNECT` 方法的隧道。

### C.2.7 Stage 6 · TLS 透传与 SNI 路由 {#sec-c.2.7}

**目标**：客户端与代理建 TLS，代理**不持证书**，只读 ClientHello 里的 SNI，把 TCP 流原样转给对应上游；支持 `CONNECT host:port` 的盲转发。

**关键概念**：TLS 记录层第一个字节 `0x16`（handshake），版本 2 字节，长度 2 字节；握手第一个字节 `0x01`（ClientHello）；SNI 在扩展类型 `0x0000` 里，格式是 `list_len(2) + type(1)=0 + name_len(2) + name`。解析只需** peek 前 2 KB**，不能消费字节，否则握手会坏。透传模式下代理看不到 HTTP，因此不能做 L7 路由、重试或改写。

```c
/* src/sni.c */
#include "sni.h"
#include <string.h>

static uint16_t rd16(const uint8_t *p) { return (uint16_t)((p[0] << 8) | p[1]); }

int px_parse_sni(const uint8_t *b, size_t n, char *out, size_t cap)
{
    size_t p = 5, end, sid, cs, cm, ext, i;

    if (n < 6 || b[0] != 0x16 || b[5] != 0x01) return -1;
    end = 5 + 4 + ((size_t)b[6] << 16 | b[7] << 8 | b[8]);
    if (end > n) end = n;
    p += 4 + 2 + 32;                       /* handshake hdr + version + random */
    if (p >= end) return -1;
    sid = b[p++]; p += sid;
    if (p + 2 > end) return -1;
    cs = rd16(b + p); p += 2 + cs;
    if (p >= end) return -1;
    cm = b[p++]; p += cm;
    if (p + 2 > end) return -1;
    ext = rd16(b + p); p += 2;
    for (i = 0; i < ext && p + 4 <= end; ) {
        uint16_t type = rd16(b + p), len = rd16(b + p + 2);
        p += 4;
        if (p + len > end) return -1;
        if (type == 0x0000 && len >= 5) {
            uint16_t list = rd16(b + p);
            size_t q = p + 2, qend = p + len;
            if (list + 2 <= len && q + 3 <= qend && b[q] == 0) {
                size_t nlen = rd16(b + q + 1);
                if (q + 3 + nlen <= qend && nlen < cap) {
                    memcpy(out, b + q + 3, nlen);
                    out[nlen] = '\0';
                    return 0;
                }
            }
        }
        p += len;
        i += 4u + len;
    }
    return -1;
}
```

用法：`recv(fd, buf, sizeof buf, MSG_PEEK)`，解析成功则按 `sni` 查路由表；解析失败（老客户端、IP 直连）走默认上游。**peek 到的字节不能丢**，后续正常 `read` 会再取一遍。

**验证**：

```bash
./build/myproxy --listen 443 --tls-passthrough \
    --sni example.com=127.0.0.1:9443 --default 127.0.0.1:9443 &
openssl s_client -connect 127.0.0.1:443 -servername example.com -brief
# 预期：证书来自 9443 的上游，代理日志打印 sni=example.com

# CONNECT 盲转发
curl -x http://127.0.0.1:8080 https://example.com/ -v
# 预期：先 "CONNECT example.com:443"，随后 TLS 握手在隧道内完成
```

**常见错误**

| 现象 | 原因 | 修复 |
|:--|:--|:--|
| 握手失败 | `recv` 消费了 ClientHello | 用 `MSG_PEEK` |
| SNI 解析越界 | 没校验扩展长度 | 每步都判 `p + len <= end` |
| `CONNECT` 后卡住 | 只单向转发 | 双向 relay + 半关闭 |
| 所有域名走同一上游 | SNI 扩展偏移错（漏了 session id） | 按 `sid/cs/cm` 顺序跳 |

**下一步**：最后一步不是加功能，而是量出它在什么位置倒下。

### C.2.8 Stage 7 · wrk 压测与瓶颈定位 {#sec-c.2.8}

**目标**：给出可复现的压测命令、指标解释和优化前后对比；能定位「瓶颈在代理、在上游、还是在客户端」。

**关键概念**：`wrk -t4 -c256 -d30s` 的 `Requests/sec`、`Latency`、`Non-2xx`；`-c` 是并发连接数，不是 QPS；延迟看 `p50/p99`，平均值会骗人；`wrk` 自己也可能成为瓶颈（单机压本机时用 `--latency` 并观察 CPU）。对照实验必须**一次只改一个变量**。

```bash
# 基线
wrk -t4 -c256 -d30s --latency http://127.0.0.1:8080/
# 上游直连（把代理摘掉）
wrk -t4 -c256 -d30s --latency http://127.0.0.1:9000/
# 观察
ss -s; ss -tan state established | wc -l
pidstat -p $(pgrep -n myproxy) 1
perf top -p $(pgrep -n myproxy)
```

| 现象 | 大概率瓶颈 | 验证 |
|:--|:--|:--|
| `Non-2xx` 上升、`connect` 超时 | 上游或 fd 上限 | `ulimit -n`、上游日志 |
| QPS 随 `-c` 增加而下降 | 代理每连接内存/扫描 | `perf` 看 `px_pick`/链表遍历 |
| `p99` 高但 QPS 正常 | 排队、超时设置过长 | `--latency` 分布、日志时间戳 |
| 本机 CPU 100% 单核 | 事件循环单线程 | `pidstat -t`、多 worker + `SO_REUSEPORT` |
| `TIME_WAIT` 暴涨 | 没复用上游连接 | Stage 2 的池命中率 |

**验证**：保存三组数据（无池、有池、有池+零拷贝），每组跑 3 次取中位数，记录机器配置。**（未实测）** 本页不给具体 QPS 数字——不同机器的差异可达一个数量级，写死数字只会误导。

**常见错误**

| 现象 | 原因 | 修复 |
|:--|:--|:--|
| `wrk` 报 `too many open files` | 代理或客户端 fd 上限 | `ulimit -n 65535` |
| 压测结果抖动大 | 本机 CPU 争抢 | 客户端与代理分机器，或绑核 |
| QPS 很高但 `Non-2xx` 多 | 上游先崩 | 看上游错误日志，别只看 QPS |

**下一步**：C.2 结束。C.3 用 `AF_PACKET` 在旁路验证：代理说的「转发成功」，线上到底发生了什么。

## C.3 抓包与流分析：`mysniff` {#sec-c.3}

`mysniff` 不参与收发，只在**旁路**把帧抄下来。它的价值是把 C.1/C.2 里「我以为发了」变成「线上确实发了」：代理 502 时，是上游没回、还是回了但被代理读错？`mytcp` 重传时，是 ACK 丢了、还是序号算错？抓包 + 流重组能同时回答。

```text
AF_PACKET 原始套接字 ──▶ 以太网解析 ──▶ IPv4/TCP/UDP 解析 ──▶ 四元组流表
                                                                  │
                                       统计（Top talker/重传/RTT）◀┤
                                                                  ├─▶ pcap 导出
                                                                  └─▶ 与 tcpdump 对照
```

**范围**：只做以太网 + IPv4 + TCP/UDP；不解析 IPv6、VLAN、IP 分片；不做 TLS 解密；不做 DPDK。所有需要 root/`CAP_NET_RAW` 的命令都会标注，并在小节末尾给清理命令。

### C.3.1 Stage 0 · AF_PACKET 抓包 {#sec-c.3.1}

**目标**：`sudo ./build/mysniff -i br0 -c 10` 能打印 10 个帧的摘要；抓包时不阻塞被测程序，丢包率可接受。

**关键概念**：`socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL))` 拿的是**链路层帧**（不含 FCS）；`bind` 到 `sockaddr_ll` 才限定网卡；`PACKET_MR_PROMISC` 打开混杂模式（交换机/网桥场景经常需要）；`recvfrom` 的 `MSG_TRUNC` 让你知道原始长度，避免 snaplen 截断后误判。高吞吐要用 `TPACKET_V3` 的 mmap 环形缓冲，本页先用 `recvfrom` 把语义跑通。

```c
/* src/capture.c */
#include "capture.h"
#include <arpa/inet.h>
#include <linux/if_packet.h>
#include <net/if.h>
#include <sys/socket.h>
#include <unistd.h>

int sn_open(const char *ifname)
{
    struct ifreq ifr = {0};
    struct sockaddr_ll sll = {0};
    struct packet_mreq mr = {0};
    int fd = socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL));

    if (fd < 0) return -1;
    snprintf(ifr.ifr_name, IFNAMSIZ, "%s", ifname);
    if (ioctl(fd, SIOCGIFINDEX, &ifr) < 0) { close(fd); return -1; }
    sll.sll_family = AF_PACKET;
    sll.sll_protocol = htons(ETH_P_ALL);
    sll.sll_ifindex = ifr.ifr_ifindex;
    if (bind(fd, (struct sockaddr *)&sll, sizeof sll) < 0) { close(fd); return -1; }
    mr.mr_ifindex = ifr.ifr_ifindex;
    mr.mr_type = PACKET_MR_PROMISC;
    (void)setsockopt(fd, SOL_PACKET, PACKET_ADD_MEMBERSHIP, &mr, sizeof mr);
    return fd;
}

int sn_capture(int fd, int count, void (*cb)(const uint8_t *, size_t, uint64_t))
{
    uint8_t buf[65536];
    int got = 0;

    while (count == 0 || got < count) {
        struct sockaddr_ll from;
        socklen_t fl = sizeof from;
        ssize_t n = recvfrom(fd, buf, sizeof buf, MSG_TRUNC,
                             (struct sockaddr *)&from, &fl);
        if (n < 0) {
            if (errno == EINTR) continue;
            return -1;
        }
        cb(buf, (size_t)n < sizeof buf ? (size_t)n : sizeof buf, (uint64_t)n);
        got++;
    }
    return got;
}
```

**验证**：

```bash
make
sudo ./build/mysniff -i br0 -c 5
# 预期：5 行 "eth src=... dst=... type=0x0800 len=..."
# 另开终端制造流量：
sudo ip netns exec mthost ping -c2 10.0.0.2
```

清理：`sudo ip link set br0 -promisc`（进程退出后混杂模式会自动关闭，这条用于确认）。

**常见错误**

| 报错/现象 | 原因 | 修复 |
|:--|:--|:--|
| `socket: Operation not permitted` | 缺 `CAP_NET_RAW` | `sudo`，或容器加 `--cap-add NET_RAW` |
| 抓不到任何包 | 绑定了 `lo` 或错网卡 | `ip -br link` 确认接口名 |
| 只看到本机发出的包 | 交换机/网桥另一侧未镜像 | 在网桥或 veth 上抓，开混杂 |
| 大包被截断 | 缓冲区小于 MTU | 缓冲区至少 65536 |

**下一步**：现在只有十六进制。Stage 1 把每个字段解析出来。

### C.3.2 Stage 1 · 以太网 / IPv4 / TCP / UDP 解析 {#sec-c.3.2}

**目标**：输出 `10.0.0.1:40000 > 10.0.0.2:80 [SYN] seq=... ack=... win=...` 这种一行摘要；任何畸形包都不能越界。

**关键概念**：解析的每一步都要**先检查剩余长度**，再读字段；`ihl` 最小 5、`doff` 最小 5；`tot_len` 可能大于实际捕获长度（snaplen 截断），取 `min(tot_len, caplen - ihl)`；TCP 标志位在 `doff` 高 4 位之后的字节里。

```c
/* src/parse.c */
#include "parse.h"
#include <string.h>

int sn_parse(const uint8_t *f, size_t n, struct sn_meta *m)
{
    const struct eth_hdr *e;
    const struct ip_hdr *ip;
    size_t ihl, off;

    if (n < 14) return -1;
    e = (const struct eth_hdr *)f;
    memcpy(m->src_mac, e->src.b, 6);
    memcpy(m->dst_mac, e->dst.b, 6);
    if (ntohs(e->ethertype) != 0x0800) return -1;
    ip = (const struct ip_hdr *)(f + 14);
    if (n < 14 + 20 || (ip->vihl >> 4) != 4) return -1;
    ihl = (size_t)(ip->vihl & 0x0f) * 4;
    if (ihl < 20 || n < 14 + ihl) return -1;
    m->saddr = ip->saddr; m->daddr = ip->daddr;
    m->proto = ip->proto;
    m->tot_len = ntohs(ip->tot_len);
    off = 14 + ihl;
    if (m->proto == 6) {
        const struct tcp_hdr *t;
        if (n < off + 20) return -1;
        t = (const struct tcp_hdr *)(f + off);
        m->sport = ntohs(t->sport); m->dport = ntohs(t->dport);
        m->seq = ntohl(t->seq); m->ack = ntohl(t->ack);
        m->flags = t->flags;
        m->win = ntohs(t->window);
        m->payload_off = off + (size_t)t->doff * 4;
        if (t->doff < 5 || m->payload_off > n) return -1;
        m->payload_len = n - m->payload_off;
    } else if (m->proto == 17) {
        const struct udp_hdr *u;
        if (n < off + 8) return -1;
        u = (const struct udp_hdr *)(f + off);
        m->sport = ntohs(u->sport); m->dport = ntohs(u->dport);
        m->payload_off = off + 8;
        m->payload_len = n - m->payload_off;
    } else {
        m->sport = m->dport = 0;
        m->payload_off = off;
        m->payload_len = n - off;
    }
    return 0;
}
```

**验证**：

```bash
sudo ./build/mysniff -i br0 -c 20 -v
sudo ip netns exec mthost curl -s http://10.0.0.2/ >/dev/null
# 预期：能看到 SYN / SYN-ACK / ACK / PSH 与 HTTP 请求行
```

**常见错误**

| 现象 | 原因 | 修复 |
|:--|:--|:--|
| 端口是乱的 | 忘了 `ntohs` | 端口/窗口 16 位，序号 32 位 |
| 首部偏移差 4 字节 | `doff` 没乘 4 | `doff * 4` |
| 偶发越界崩溃 | 只用 `tot_len` 判断 | 同时看捕获长度 `n` |
| VLAN 流量解析失败 | 以太网类型是 `0x8100` | 先跳过 4 字节 VLAN 头（练习） |

**下一步**：单个包看不出「流」。Stage 2 按四元组重组 TCP。

### C.3.3 Stage 2 · TCP 流重组 {#sec-c.3.3}

**目标**：对每条连接，按方向还原有序字节流；重传不重复计数；乱序段先缓存，补齐后按序交付；能打印一段 HTTP 请求的完整内容。

**关键概念**：流由**四元组 + 方向**唯一确定；`next_seq` 是「已按序交付的下一个字节」；重传（`seq + len <= next_seq`）直接丢弃；重叠段要裁剪；乱序段放入按 `seq` 排序的小数组，`seq == next_seq` 时循环取出。SYN 占一位，建立流时 `next_seq = seq + 1`。

```c
/* src/flow.c */
#include "flow.h"
#include <stdlib.h>
#include <string.h>

#define SN_PENDING 64

struct sn_half {
    uint32_t next_seq;
    uint8_t  buf[SN_STREAM_MAX];
    size_t   len;
    struct { uint32_t seq; uint16_t len; uint8_t data[1460]; } pending[SN_PENDING];
    int      npending;
};

static void deliver(struct sn_flow *f, struct sn_half *h, uint32_t seq,
                    const uint8_t *data, size_t len)
{
    if (len == 0) return;
    if (seq + len <= h->next_seq) { f->retrans++; return; }       /* 纯重传 */
    if (seq < h->next_seq) {                                      /* 部分重叠 */
        size_t cut = h->next_seq - seq;
        data += cut; len -= cut; seq = h->next_seq;
    }
    if (seq > h->next_seq) {                                      /* 乱序：缓存 */
        if (h->npending >= SN_PENDING) { f->dropped++; return; }
        h->pending[h->npending].seq = seq;
        h->pending[h->npending].len = (uint16_t)len;
        memcpy(h->pending[h->npending].data, data, len);
        h->npending++;
        return;
    }
    if (h->len + len <= sizeof h->buf) {                          /* 按序交付 */
        memcpy(h->buf + h->len, data, len);
        h->len += len;
        h->next_seq += (uint32_t)len;
    } else {
        f->dropped++;
    }
    for (;;) {                                                    /* 补齐后续 */
        int i, hit = -1;
        for (i = 0; i < h->npending; i++)
            if (h->pending[i].seq == h->next_seq) { hit = i; break; }
        if (hit < 0) break;
        deliver(f, h, h->pending[hit].seq, h->pending[hit].data,
                h->pending[hit].len);
        h->pending[hit] = h->pending[--h->npending];
    }
}
```

流表用开放寻址或链式哈希（桶数 4096，key 为 `saddr^daddr^sport<<16^dport`），每条流两个 `sn_half`；超过 30 s 无包或 `len` 达上限就导出并回收。**不要**用 `malloc` 给每个段分配节点——抓包路径上分配器会成为瓶颈，固定数组 + 覆盖最旧是更实际的选择。

**验证**：

```bash
sudo ./build/mysniff -i br0 -w /tmp/http.pcap -c 200
# 从 pcap 里挑一条流
sudo ./build/mysniff -r /tmp/http.pcap --flow 10.0.0.1:40000-10.0.0.2:80
# 预期：完整打印 "GET / HTTP/1.1\r\nHost: ..."
```

**常见错误**

| 现象 | 原因 | 修复 |
|:--|:--|:--|
| 重传被算进正文 | 没比较 `seq + len <= next_seq` | 先判重传再交付 |
| 乱序后流永久卡住 | 缓存段没在补齐后重试 | 交付后循环扫描 `pending` |
| 内存暴涨 | 每条流都存全量 | 设上限，超出标记 truncated |
| SYN 后序号差 1 | 忘了 SYN 占一位 | 建流时 `next_seq = seq + 1` |

**下一步**：流有了，Stage 3 从流里算指标。

### C.3.4 Stage 3 · 统计 {#sec-c.3.4}

**目标**：输出 Top talker（按字节）、每端口请求数、每条流的重传数、粗粒度 RTT（SYN→SYN-ACK），并支持 1 s 刷新。

**关键概念**：字节数按**载荷**统计，不要把首部算进吞吐；重传率 = 重传段数 / 总段数；RTT 只在「同一方向、无重传」的样本上算；Top N 用固定大小的小顶堆，不要每次全排序。

```c
/* src/stats.c */
#include "stats.h"
#include <stdio.h>
#include <string.h>

void sn_stats_update(struct sn_stats *s, const struct sn_meta *m, size_t caplen)
{
    s->packets++;
    s->bytes += caplen;
    if (m->proto == 6) {
        s->tcp_pkts++;
        if (m->flags & 0x02) s->syn++;
        if (m->flags & 0x01) s->fin++;
        if (m->flags & 0x04) s->rst++;
    } else if (m->proto == 17) {
        s->udp_pkts++;
    }
}

void sn_stats_dump(const struct sn_stats *s, FILE *out)
{
    fprintf(out, "packets=%llu bytes=%llu tcp=%llu udp=%llu syn=%llu fin=%llu rst=%llu\n",
            (unsigned long long)s->packets, (unsigned long long)s->bytes,
            (unsigned long long)s->tcp_pkts, (unsigned long long)s->udp_pkts,
            (unsigned long long)s->syn, (unsigned long long)s->fin,
            (unsigned long long)s->rst);
}
```

Top talker 用 `struct { uint32_t ip; uint64_t bytes; } top[16]`，插入时若比最小项大就替换并重排；端口统计用 `uint64_t port_bytes[65536]`（512 KB，可接受），输出时扫描取前 10。所有这些都在 `SIGUSR1` 时打印，不打断抓包。

**验证**：

```bash
sudo ./build/mysniff -i br0 -c 1000 --stats
# 预期：
# packets=1000 bytes=... tcp=... udp=...
# top: 10.0.0.1 823441 bytes, 10.0.0.2 12033 bytes
# port 80: 812 requests
```

**常见错误**

| 现象 | 原因 | 修复 |
|:--|:--|:--|
| 字节数偏大 | 把以太网/ IP 首部算进载荷 | 只累加 `payload_len` |
| 端口统计错位 | 用了网络序做下标 | `ntohs` 后再索引 |
| 刷新时丢包 | 在回调里做 `printf` | 统计与输出分离，用信号触发 |

**下一步**：统计结果要能带出去给别人看。Stage 4 写标准 pcap。

### C.3.5 Stage 4 · pcap 导出 {#sec-c.3.5}

**目标**：`mysniff -w out.pcap` 生成的文件能被 `tcpdump -r`、Wireshark 直接打开，包数与时间戳正确。

**关键概念**：pcap 全局头 24 字节（magic、版本、时区、snaplen、linktype）；每个包 16 字节头（`ts_sec`、`ts_usec`、`incl_len`、`orig_len`）；magic `0xa1b2c3d4` 表示微秒 + 本机字节序，写文件时统一用小端；`linktype=1` 是以太网；`incl_len` 是实际写出的长度，`orig_len` 是原始帧长，二者不等说明被 snaplen 截断。

```c
/* src/pcap.c */
#include "pcap.h"
#include <arpa/inet.h>
#include <stdio.h>

struct pcap_ghdr {
    uint32_t magic; uint16_t vmaj, vmin; int32_t thiszone;
    uint32_t sigfigs, snaplen, network;
} __attribute__((packed));

struct pcap_phdr {
    uint32_t ts_sec, ts_usec, incl_len, orig_len;
} __attribute__((packed));

FILE *sn_pcap_open(const char *path, uint32_t snaplen)
{
    struct pcap_ghdr g = { 0xa1b2c3d4u, 2, 4, 0, 0, snaplen, 1 };
    FILE *f = fopen(path, "wb");
    if (f == NULL) return NULL;
    if (fwrite(&g, sizeof g, 1, f) != 1) { fclose(f); return NULL; }
    return f;
}

int sn_pcap_write(FILE *f, const uint8_t *frame, size_t len,
                  uint32_t sec, uint32_t usec, size_t orig_len)
{
    struct pcap_phdr p = { sec, usec, (uint32_t)len, (uint32_t)orig_len };
    if (fwrite(&p, sizeof p, 1, f) != 1) return -1;
    if (fwrite(frame, 1, len, f) != len) return -1;
    return 0;
}
```

写文件用 `setvbuf(f, NULL, _IOFBF, 1 << 20)`，否则每个包一次 `write` 会拖慢抓包；退出前 `fflush` + `fclose`，异常退出会留下 24 字节的坏文件（Wireshark 会报 truncated）。

**验证**：

```bash
sudo ./build/mysniff -i br0 -w /tmp/a.pcap -c 500
tcpdump -r /tmp/a.pcap -nn | wc -l      # 预期 500
capinfos /tmp/a.pcap 2>/dev/null | head
tshark -r /tmp/a.pcap -q -z io,stat,0
```

**常见错误**

| 现象 | 原因 | 修复 |
|:--|:--|:--|
| Wireshark 报 `truncated dump file` | 没 `fclose`，或写入失败没检查 | 退出路径统一 flush/close |
| 时间戳全是 1970 | 用了 `CLOCK_MONOTONIC` | pcap 要 `CLOCK_REALTIME` |
| 包数对但内容错 | `incl_len` 写成 `orig_len` | 分别填捕获长度与原始长度 |
| 中文路径打不开 | 用了 `fopen` 的窄字符 | 本页不处理，改用 ASCII 路径 |

**下一步**：最后一步，和 `tcpdump` 正面对照，确认你的抓包没有系统性偏差。

### C.3.6 Stage 5 · 与 tcpdump 对照 {#sec-c.3.6}

**目标**：同一时间窗、同一网卡上，`mysniff` 与 `tcpdump` 的包数、流数、字节数在可解释的误差内；差异能归因，而不是「大概差不多」。

**关键概念**：两个抓包点即使在同一网卡，也会因为**抓包时机**（qdisc 前后、GRO/TSO 聚合）看到不同的包数；`tcpdump` 默认 snaplen 262144，`mysniff` 若设 1500 会截断大包；时间戳一个来自 `SO_TIMESTAMPNS`，一个来自用户态 `clock_gettime`，会有微秒级差异。对照要**归一化**：按五元组分组、按 payload 字节比较，而不是逐包 diff。

```bash
# 同时抓，同一个过滤条件
sudo tcpdump -i br0 -nn -s 0 -w /tmp/ref.pcap 'tcp port 80' &
sudo ./build/mysniff -i br0 -s 0 -w /tmp/mine.pcap 'tcp port 80' &
curl -s http://10.0.0.2/ >/dev/null
sudo pkill -INT tcpdump; sudo pkill -INT mysniff

# 包数
tcpdump -r /tmp/ref.pcap -nn 2>/dev/null | wc -l
tcpdump -r /tmp/mine.pcap -nn 2>/dev/null | wc -l
# 流数与字节数（按五元组聚合）
tshark -r /tmp/mine.pcap -T fields -e ip.src -e tcp.srcport \
       -e ip.dst -e tcp.dstport -e tcp.len 2>/dev/null | \
  awk -F'\t' '{s[$1":"$2"-"$3":"$4]+=$5} END{for(k in s) print k, s[k]}' | sort
```

预期：包数差异主要来自 GRO 聚合（`tcpdump` 可能看到 64 KB 的「超级包」，而 `mysniff` 看到拆分后的段），**payload 总字节应一致**。若差异超过 1%，先检查过滤表达式是否一致（`tcp port 80` 会同时匹配源和目的）、snaplen 是否一致、是否有一方漏了 `-U` 导致缓冲未刷。

**常见错误**

| 现象 | 原因 | 修复 |
|:--|:--|:--|
| 包数差很多 | 过滤表达式不同 / 抓包点不同 | 用同一个 `-i` 和同一个 BPF |
| 字节数差一个 MSS | GRO/TSO 聚合 | 比较 payload 总量，不比包数 |
| 你的文件打不开 | 用了 `SOCK_DGRAM` 或 strip 了以太网头 | linktype=1 必须写完整以太网帧 |
| 时间戳倒退 | 多线程各自取时间 | 单线程按到达顺序打时间戳 |

**下一步**：C.3 结束。C.4 把三条线接起来：让 `curl` 经过 `myproxy`，打到 `mytcp`，同时用 `mysniff` 解释每一个字节。

## C.4 三条线拼成一个演示 {#sec-c.4}

目标：一条命令搭起「客户端 → 代理 → 用户态栈」的完整链路，同时抓包，最后用一份 pcap 解释整条请求。以下脚本用 C.0.1 的两个 netns，所有命令都需要 root，执行完必须清理。

```bash
#!/usr/bin/env bash
# demo.sh —— 需要 root；只在虚拟机/隔离环境执行
set -euo pipefail
cleanup() {
  sudo pkill -INT mytcp 2>/dev/null || true
  sudo pkill -INT myproxy 2>/dev/null || true
  sudo pkill -INT mysniff 2>/dev/null || true
  sudo ip netns del mtlab 2>/dev/null || true
  sudo ip netns del mthost 2>/dev/null || true
}
trap cleanup EXIT

sudo ip netns add mtlab
sudo ip netns add mthost
sudo ip link add veth-a netns mtlab type veth peer name veth-b netns mthost
sudo ip netns exec mtlab ip link add br0 type bridge
sudo ip netns exec mtlab ip tuntap add dev tap0 mode tap
sudo ip netns exec mtlab ip link set tap0 master br0
sudo ip netns exec mtlab ip link set veth-a master br0
sudo ip netns exec mtlab ip link set br0 up
sudo ip netns exec mtlab ip link set tap0 up
sudo ip netns exec mtlab ip link set veth-a up
sudo ip netns exec mtlab ip addr add 10.0.0.254/24 dev br0
sudo ip netns exec mthost ip addr add 10.0.0.1/24 dev veth-b
sudo ip netns exec mthost ip link set veth-b up

# ① 用户态栈提供 HTTP
sudo ip netns exec mtlab ./build/mytcp --tap tap0 --ip 10.0.0.2 --http 80 &
sleep 0.5
# ② 反向代理指向用户态栈
sudo ip netns exec mtlab ./build/myproxy --listen 0.0.0.0:8080 \
     --upstream 10.0.0.2:80 --policy least_conn &
sleep 0.5
# ③ 旁路抓包
sudo ip netns exec mtlab ./build/mysniff -i br0 -nn -w /tmp/demo.pcap &

# 客户端走代理
sudo ip netns exec mthost curl -sS -x http://10.0.0.254:8080 http://10.0.0.2/
sudo ip netns exec mthost curl -sS -o /dev/null -w 'status=%{http_code}\n' \
     -x http://10.0.0.254:8080 http://10.0.0.2/nope

sleep 0.5
sudo pkill -INT mysniff || true
sudo ip netns exec mtlab tcpdump -r /tmp/demo.pcap -nn -c 20 'tcp'
```

预期输出：第一条 `curl` 打印 `hello from mytcp`；第二条 `status=404`；`tcpdump -r` 能看到**两条独立连接**——客户端到 `10.0.0.254:8080`，代理到 `10.0.0.2:80`。这正是「代理是一条新连接」的直接证据。

把 pcap 读进 `mysniff` 做流重组，应能还原出：

```text
:8080 方向  GET / HTTP/1.1\r\nHost: 10.0.0.2\r\nProxy-Connection: Keep-Alive\r\n...
:80   方向  GET / HTTP/1.1\r\nHost: 10.0.0.2\r\nConnection: keep-alive\r\n...
```

两行请求行的差异（`Proxy-Connection` 被剥掉、目标改成 origin-form、`Connection` 被重写）就是 C.2 Stage 1 的全部工作。**如果两边完全一样，说明你的代理在做透明字节转发，没有真正解析 HTTP。**

演示失败时按这个顺序查：`br0` 是否 `UP` 且有两个从设备（`bridge link`）；`mytcp` 是否收到 ARP（日志）；`myproxy` 的 upstream 是否 `ESTABLISHED`（`ss -tnp`）；`mysniff` 是否绑定了正确的网卡。

清理：

```bash
sudo pkill -INT mytcp myproxy mysniff 2>/dev/null || true
sudo ip netns del mtlab; sudo ip netns del mthost
ip netns list          # 应为空
```

## C.5 验收清单 {#sec-c.5}

逐项自检，每一项都要能给出**命令 + 输出**，不接受「应该可以」。带 ⚠ 的项目依赖内核/硬件，未实测时在报告里注明环境。

| # | 验收项 | 验证命令 | 通过标准 |
|--:|:--|:--|:--|
| 1 | 帧能进用户态 | `mysniff -i br0 -c 5` | 打印 5 个以太网帧，类型正确 |
| 2 | ARP 应答 | `ip netns exec mthost ip neigh show 10.0.0.2` | `REACHABLE` + 自定义 MAC |
| 3 | ICMP 回显 | `ping -c3 10.0.0.2` | 3/3，`ttl=64` |
| 4 | IP 校验和 | `tcpdump -vv` | 无 `bad ip checksum` |
| 5 | UDP 回显 | `nc -u -w1 10.0.0.2 7` | 原样返回 |
| 6 | 端口不可达 | `nc -u -w1 10.0.0.2 9` | 收到 ICMP unreachable，`exit=1` |
| 7 | 三次握手 | `nc -vz 10.0.0.2 7` | `open`，抓包 `S/S./.` 且 ack 差 1 正确 |
| 8 | 四次挥手 | 客户端 Ctrl-C | 抓包 `F././F./.`，主动方进 `TIME_WAIT` |
| 9 | 1 MB 传输 | `nc` 传 `/dev/urandom` 后 `cmp` | 完全一致 |
| 10 | 丢包恢复 ⚠ | `tc qdisc add ... netem loss 5%` | 仍一致，`retx > 0` |
| 11 | 校验和错误丢弃 | 注入坏包 | `csum_err` 增加，连接不推进 |
| 12 | socket API | 栈内 HTTP + `curl` | `200`，body 正确 |
| 13 | 与内核互通 | `curl http://10.0.0.2/` | `hello from mytcp` |
| 14 | 无 fd 泄漏 | 50 次短连接后看 `stats` | TCB 回落到 0 |
| 15 | 代理基本转发 | `curl -x http://127.0.0.1:8080` | 上游内容原样返回 |
| 16 | 首部改写 | 抓包对比两条请求行 | 绝对 URI 被改写，hop-by-hop 被剥 |
| 17 | 上游连接池 | `ss -tan` 的 `TIME_WAIT` | 比每请求新连接显著减少 |
| 18 | 负载均衡 | 两台不同内容的 upstream | 轮询/最少连接分布符合策略 |
| 19 | 健康检查 | 杀一台 upstream | 30 s 内全部切到健康节点，无持续 502 |
| 20 | 超时 | 指向黑洞地址 | 3 s 内 504，不是永久挂起 |
| 21 | 优雅关闭 | `kill -TERM`，同时 `wrk` | 在途请求完成，10 s 内退出 |
| 22 | 零拷贝 ⚠ | `perf` 对比 `memcpy` 占比 | 大文件场景明显下降 |
| 23 | SNI 路由 | `openssl s_client -servername` | 路由到对应上游 |
| 24 | wrk 压测 | `wrk -t4 -c256 -d30s` | 有 QPS/p99/非 2xx 三项数据 |
| 25 | pcap 可读 | `tcpdump -r out.pcap` | 包数一致，Wireshark 无报错 |
| 26 | 流重组 | `mysniff -r out.pcap --flow` | 还原完整 HTTP 请求 |
| 27 | tcpdump 对照 | 同条件双抓 | payload 字节数误差 <1% |
| 28 | 一键演示 | `demo.sh` | 两条连接、两个请求行、404 分支都对 |
| 29 | 清理 | `ip netns list` | 为空，无残留 veth/tap |
| 30 | 文档 | README | 构建、运行、限制、未实测项齐全 |

评分建议：1–14 是 C.1 的地基（每项 4 分），15–24 是 C.2（每项 4 分），25–29 是 C.3/联调（每项 4 分），30 是文档（10 分）。**任何一项「没跑过」都按 0 分计**，不要用「代码看起来对」代替输出。

## C.6 延伸与母本对应 {#sec-c.6}

| 本页内容 | 教程正文 | 经典实现（只读文档，不抄代码） |
|:--|:--|:--|
| 以太网/ARP | [4.2](../part4/ch02.md) | RFC 826；Linux `net/ipv4/arp.c` |
| IPv4/ICMP | [4.3](../part4/ch03.md) | RFC 791/792；`net/ipv4/ip_input.c` |
| UDP/校验和 | [4.4](../part4/ch04.md) | RFC 768/1071；`net/ipv4/udp.c` |
| TCP 握手/挥手 | [4.5](../part4/ch05.md) | RFC 793；`net/ipv4/tcp_input.c` |
| 重传/窗口 | [4.6](../part4/ch06.md) | RFC 6298/5681；`tcp_output.c`、`tcp_timer.c` |
| socket/epoll | [2.16](../part2/ch16.md)–[2.18](../part2/ch18.md) | `man 7 epoll`、`man 2 splice` |
| 容器网络 | [5.6](../part5/ch06.md) | `man 8 ip-netns`、`Documentation/networking/veth.rst` |
| 代理与 TLS | [4.7](../part4/ch07.md) | RFC 9112、RFC 8446（只读 SNI 部分） |

**值得继续做的六个方向**（按投入从低到高）：

1. **拥塞控制**：给 `mytcp` 加 `cwnd`，实现慢启动 + 拥塞避免 + 快速恢复，用 `netem` 对比 Reno 曲线。
2. **SACK 与乱序缓存**：把 C.1 Stage 4 的「只收连续段」升级为乱序队列，重传率应显著下降。
3. **多线程代理**：`SO_REUSEPORT` + 每线程一个 epoll，比较单线程与 4 线程的 QPS/尾延迟。
4. **io_uring**：把 `myproxy` 的 read/write 换成 `io_uring`，观察系统调用次数与上下文切换。
5. **eBPF/XDP 观测**：用 `bpftrace` 统计 TCP 重传、`tcp_drop`，与 `mysniff` 的结果交叉验证。
6. **HTTP/2 与 WebSocket**：在 C.2 上做协议升级，理解「代理不能只转发字节」的边界。

**最后三条工程纪律**：

- **不要抄 lwIP/HAProxy/tcpdump 的源码**。可以读它们的文档、RFC 和测试用例，但代码必须自己写；抄来的代码无法解释每个分支，验收时一问就露馅。
- **每个优化都要有对照数据**。没有基线的「优化」只是改代码。
- **写清楚「没做什么」**。README 里列出不支持的分片、SACK、HTTP/2、TLS 终止，比假装全支持更专业。

到这里，三条线闭环：`mytcp` 造出字节，`myproxy` 搬运字节，`mysniff` 证明字节真的到过线上。你可以只做其中一条，但只要三条都跑通一次，网络就不再是「一堆会背的字段」，而是一条你能亲手复现的路径。
