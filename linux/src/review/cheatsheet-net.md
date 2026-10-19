# R.4 网络速查

> 协议细节以 RFC 与 Linux 6.8 为准；命令默认在 Ubuntu 24.04 上可跑。

## 1. 分层与封装

| 层 | 数据单元 | 典型首部 | Linux 实现位置 |
|:--|:--|:--|:--|
| 应用 | 消息 | HTTP/DNS/TLS | 用户态库/进程 |
| 运输 | 段/数据报 | TCP 20–60 B / UDP 8 B | `net/ipv4/tcp*.c`、`udp.c` |
| 网络 | 包 | IPv4 20–60 B / IPv6 40 B | `net/ipv4/ip_input.c`、`ip_output.c` |
| 链路 | 帧 | 以太网 14 B + FCS | 驱动 + `net/core/dev.c` |
| 物理 | 比特 | — | 网卡/PHY |

封装：应用数据 → TCP 段 → IP 包 → 以太网帧。分用靠首部字段逐层上交（以太网 `type`、IP `protocol`、TCP/UDP `port`）。

## 2. 关键长度

| 项 | 值 | 说明 |
|:--|:--|:--|
| 以太网 MTU | 1500 B | 常见默认；jumbo 9000 |
| IPv4 最小 MTU | 68 B | 分片要求 |
| TCP MSS | MTU - 40（IPv4）/ -60（IPv6） | 只算 TCP 首部+IP 首部 |
| UDP 首部 | 8 B | 源/目的端口、长度、校验和 |
| TCP 首部 | 20 B + 选项 | 选项：MSS、窗口缩放、SACK、时间戳 |
| IPv4 首部 | 20 B + 选项 | `IHL` 以 4 B 为单位 |
| 端口范围 | 0–65535 | 0–1023 需特权；临时端口 `ip_local_port_range` |

## 3. IP / ARP / ICMP

- IPv4 首部：版本、IHL、TOS、总长、ID、flags/frag offset、TTL、protocol、checksum、源/目的 IP。
- 分片：`DF` 置位则不分片，超 MTU 返回 ICMP `frag needed`；分片由源/路由器做，重组在目的端。
- CIDR：`10.0.0.0/8`、`192.168.0.0/16`、`172.16.0.0/12` 私有；`127.0.0.0/8` loopback。
- ARP：IPv4 → MAC；`ip neigh`；免费 ARP 检测冲突。
- ICMP：`echo request/reply`、`dest unreachable`、`time exceeded`、`frag needed`。
- IPv6：40 B 固定首部，扩展首部链；NDP 替代 ARP；SLAAC/DHCPv6。

## 4. TCP 状态机

```text
CLOSED → SYN_SENT → ESTABLISHED → FIN_WAIT_1 → FIN_WAIT_2 → TIME_WAIT → CLOSED
   ↑         ↓            ↓
LISTEN → SYN_RCVD → ESTABLISHED → CLOSE_WAIT → LAST_ACK → CLOSED
```

| 状态 | 含义 | 常见问题 |
|:--|:--|:--|
| `LISTEN` | 监听 | backlog 满 |
| `SYN_SENT` | 主动连接，等 SYN-ACK | 对端不可达/防火墙 |
| `SYN_RCVD` | 收到 SYN，回了 SYN-ACK | SYN flood |
| `ESTABLISHED` | 已建立 | 应用不读导致 `Recv-Q` 涨 |
| `FIN_WAIT_1/2` | 主动关闭 | 对端不回 FIN |
| `CLOSE_WAIT` | 被动关闭，等应用 close | **应用 bug** |
| `LAST_ACK` | 等最后 ACK | 少见 |
| `TIME_WAIT` | 主动关闭方等 2MSL | 端口耗尽 |

三次握手：`SYN(x)` → `SYN-ACK(y, ack=x+1)` → `ACK(ack=y+1)`。四次挥手：`FIN` → `ACK` → `FIN` → `ACK`。

## 5. TCP 可靠性与拥塞控制

- 序号/确认：字节流编号；`seq` 是本段首字节，`ack` 是期望的下一个字节。
- 重传：RTO 基于 RTT（RFC 6298）；快重传（3 个重复 ACK）；SACK。
- 流量控制：接收窗口 `rwnd`；零窗口探测。
- 拥塞控制：`cwnd`、慢启动、拥塞避免、快恢复；CUBIC 默认，BBR 可选。
- Nagle：小包合并；`TCP_NODELAY` 关闭；延迟 ACK 与 Nagle 可能互等。
- `tcp_info`：`ss -tin` 看 `rtt`、`cwnd`、`retrans`、`rcv_space`。

## 6. socket API 时序

```text
服务端: socket → bind → listen → accept → read/write → close
客户端: socket → connect → write/read → close
UDP:    socket → bind/sendto/recvfrom → close
```

| 调用 | 关键点 |
|:--|:--|
| `socket` | `SOCK_CLOEXEC`；`AF_INET/AF_INET6/AF_UNIX` |
| `bind` | `SO_REUSEADDR`；`INADDR_ANY` |
| `listen` | backlog 是 accept 队列上限 |
| `accept4` | 新 fd 设 `SOCK_CLOEXEC/NONBLOCK` |
| `connect` | 非阻塞 `EINPROGRESS`；`poll(POLLOUT)` |
| `send/recv` | 短写/短读；字节流无边界 |
| `shutdown` | 半关闭；`SHUT_WR` 发 FIN |
| `close` | 可能进入 `TIME_WAIT` |

## 7. 收包路径

```text
NIC → DMA 写 RX ring → 硬中断 → napi_schedule
  → NET_RX_SOFTIRQ → net_rx_action → napi_poll
  → 驱动 poll → netif_receive_skb → 协议分发
  → ip_rcv → ip_local_deliver → tcp_v4_rcv
  → sk_receive_queue → 唤醒 socket 等待者
```

关键点：

- 硬中断只登记；协议处理在 NAPI poll；有 budget。
- `RPS/RFS` 把软中断分到多核；`GRO` 合并包。
- `softnet_stat` 第二列是 drop；`/proc/softirqs` 看 NET_RX。
- socket `Recv-Q` 满会丢包；应用读得慢会反压。

## 8. 发包路径

```text
write/sendmsg → tcp_sendmsg → sk_write_queue
  → tcp_transmit_skb → ip_queue_xmit → ip_output
  → dev_queue_xmit → qdisc → 驱动 ndo_start_xmit
  → TX ring → DMA → 网卡
```

- `TSO/GSO` 让网卡分片；`TSO` 关闭时内核分片。
- `qdisc`：`fq_codel` 默认（桌面/服务器不同）；`tc` 可整形/限速。
- `SO_SNDBUF` 太小会阻塞；`ss -tin` 看 `Send-Q`。
- `sendfile`/`splice` 减少拷贝；`MSG_ZEROCOPY` 需驱动支持。

## 9. epoll 与 socket

- `epoll_ctl(ADD)` 注册 `epitem`；socket 等待队列挂 `ep_poll_callback`。
- 事件就绪 → 回调把 `epitem` 挂到 `rdllist` → 唤醒 `epoll_wait`。
- LT：只要可读就通知；ET：状态变化通知一次，必须读到 `EAGAIN`。
- `EPOLLEXCLUSIVE` 缓解多 epoll 惊群；`SO_REUSEPORT` 让多进程分担 accept。
- `EPOLLERR/EPOLLHUP` 总是上报，必须处理并关闭。

## 10. 连接队列与百万连接

| 队列 | 控制 | 查看 |
|:--|:--|:--|
| SYN 队列 | `tcp_max_syn_backlog`、`tcp_syncookies` | `netstat -s` 的 SYN drop |
| accept 队列 | `listen(fd, backlog)`、`somaxconn` | `ss -lnt` 的 `Recv-Q` |

百万连接先撞：

- fd：`ulimit -n`、`fs.file-max`、systemd `LimitNOFILE`；
- 端口：`ip_local_port_range`（客户端）；
- 内存：`tcp_mem`、`sk_buff`、socket 对象；
- conntrack：`nf_conntrack_max`；
- backlog：`somaxconn`；
- epoll 实例与内核对象。

## 11. 常用 sysctl

| 参数 | 作用 | 注意 |
|:--|:--|:--|
| `net.core.somaxconn` | accept 队列上限 | 与 `listen` 取小 |
| `net.ipv4.tcp_max_syn_backlog` | SYN 队列 | SYN flood 时调 |
| `net.ipv4.ip_local_port_range` | 临时端口 | 客户端连接多时扩 |
| `net.ipv4.tcp_tw_reuse` | 复用 TIME_WAIT | 仅出站，谨慎 |
| `net.ipv4.tcp_fin_timeout` | FIN_WAIT_2 超时 | 不要乱调 |
| `net.core.rmem_max/wmem_max` | 套接字缓冲区上限 | 与 `SO_RCVBUF` 配合 |
| `net.ipv4.tcp_rmem/wmem` | TCP 自动调优范围 | 三段：min/default/max |
| `net.ipv4.tcp_congestion_control` | 拥塞控制 | `cubic`/`bbr` |
| `net.core.netdev_max_backlog` | 收包 backlog | 高吞吐调 |
| `net.ipv4.tcp_syncookies` | SYN cookie | 1 默认开 |

## 12. 诊断命令

| 目的 | 命令 |
|:--|:--|
| 监听/连接 | `ss -lntp` / `ss -tnp state established` |
| 套接字明细 | `ss -tin` |
| 统计 | `ss -s` |
| 抓包 | `tcpdump -i any -nn -s0 -w cap.pcap` |
| 读包 | `tcpdump -r cap.pcap 'tcp port 443'` |
| 路由 | `ip route get 8.8.8.8` |
| 邻居 | `ip neigh` |
| DNS | `dig +short example.com` / `resolvectl query` |
| HTTP | `curl -v --trace-time` |
| 带宽 | `iperf3 -c host -P 4` |
| 路径 | `mtr -rwc 100 host` |
| 内核丢包 | `cat /proc/net/softnet_stat` |
| 重传 | `ss -tin \| grep retrans` |

## 13. 容器网络

```text
容器 netns → veth pair → bridge（docker0/cni0）→ 宿主路由/NAT → 外部
```

- `veth` 一对，一端在容器，一端在宿主 bridge。
- `bridge` 二层转发；`iptables/nftables` 做 SNAT/DNAT（端口映射）。
- `overlay`（VXLAN）跨主机；`CNI` 负责分配 IP/路由。
- 排查：`nsenter -t PID -n` 进 netns；`ip -n <ns> addr`；`conntrack -L`。

> 回 [R.3 内核速查](cheatsheet-kernel.md)；协议章节从 [4.1](../part4/ch01.md) 开始。
