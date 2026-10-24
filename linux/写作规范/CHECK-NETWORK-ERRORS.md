# CHECK-NETWORK-ERRORS：第 4 篇（4.1–4.12）网络事实核查

> 核查对象：`src/part4/ch01.md`–`ch12.md`
> 对照母本：谢希仁《计算机网络》第 8 版（W）、张彦飞《深入理解 Linux 网络》（N）、Kerrisk《Linux/UNIX 系统编程手册》第 58/61/63 章（K）
> 性质：只读核查，不改正文。所有结论均可由 RFC、原书页码或 Linux 6.8 源码复核。
> 核查时间：2026-10-19。代码实测环境：macOS 27 / Apple clang 21；Linux 专属分支只做静态核对，不冒充运行结果。
> 修订：初版先落盘 top 10；本版扩为 top 20，并补 B 的 15 条、C 的完整清单和实测记录。

## 结论先读

- 已复核出 **20 条硬事实错误**（A1–A20），另有 6 条已确认但不计入 top 20 的问题（A21–A26）。
- 最严重的是五类：
  1. **MSS 与 TCP 选项的关系被写反**（A1、A10）：把「有效载荷 1448」说成「协商 MSS 1448」，把「各方向使用对端通告的 MSS」说成「取双方较小值」。
  2. **分片算术自相矛盾**（A2、A15）：3000 字节 IP 包被写成两片 1480+1020，合计只有 2500 字节；另一处第二片 144 字节凭空多 40 字节。
  3. **代码与实际输出不符**（A3）：`goodput.c` 的文档输出不是该程序跑出来的结果。
  4. **Linux 6.8 内核对象用了旧结构/错误函数**（A17、A18）：`request_sock_queue.max_qlen_log` 等字段在 6.8 已不存在，正常 SYN 入队也不是 `inet_csk_reqsk_queue_add(sk, req, NULL)`。
  5. **延迟 ACK 上限写错**（A19）：40 ms 是常用最小值，不是内核上限。
- 另有 **B 节 15 条实质漏节**，其中谢希仁第 4/6/7 章的漏节最集中；张彦飞 10 章均有落点，但其 6.2.5 的队列算术落点错误（A17/A18），不是「漏」。

---

## A. 事实错误 Top 20

### 速查表

| # | 文件:行 | 一句话错误 | 关键证据 |
|--:|:--|:--|:--|
| A1 | `ch01.md:293` | 时间戳选项让「协商 MSS 变成 1448」 | RFC 9293 §3.7.1；MSS 只计 TCP 载荷 |
| A2 | `ch01.md:323` | 3000 字节 IP 包分成 1480+1020 两片 | RFC 791；2980=1480+1480+20 |
| A3 | `ch01.md:683-690` | `goodput.c` 文档输出与程序实测不符 | 实测 64→134、1460→frag |
| A4 | `ch01.md:789` | 把十六进制 `4006` 当成 IPv4 字段 | 实际是 TTL=0x40 与 proto=0x06 |
| A5 | `ch01.md:509` | 64KB 窗口在 10Gbps/100ms 上是 0.5% | 正确 0.05%（64KiB/125MB） |
| A6 | `ch02.md:283` | VLAN 接口默认「实际可用 1496」、有自己的 qdisc | 6.8 `vlan_dev` 继承 MTU，默认 noqueue |
| A7 | `ch02.md:1055` | `1496+4标签+18头+4FCS=1522` | 标签被算两遍；正确 1496+18+4=1518 |
| A8 | `ch03.md:170-174` | /22 例：/23「刚好不够」、/24 够 300 台 | /23 可用 510；/24 只有 254；/22 总量不够 |
| A9 | `ch03.md:302` | `conntrack -C` 是「经过 NAT 的连接数」 | conntrack(8)：全表条目数 |
| A10 | `ch04.md:581` | MSS 每方向取双方通告的较小者 | 正确：A 发用 B 的值，B 发用 A 的值 |
| A11 | `ch04.md:583` | 窗口缩放 shift 取双方 min | RFC 7323 §2.2–2.3：每方向用对端 shift |
| A12 | `ch05.md:52` | `-S` 下第三个包仍写 `seq 1` | `-S` 是绝对序号，应为 ISN+1 |
| A13 | `ch05.md:314-319` | 状态图把 LAST-ACK 的 ACK 画到 TIME-WAIT | LAST-ACK --ACK--> CLOSED |
| A14 | `ch06.md:1048` | CWR/ECE「由路由器置位」 | 路由器置 IP 的 CE；接收方置 ECE；发送方置 CWR |
| A15 | `ch03.md:1211,1220` | 分片第二片 `length 144`、载荷 124 | 原包 1500、MTU 1400 时第二片应为 124（载荷 104） |
| A16 | `ch03.md:948` | 「回复方向 dst 不是内网地址=SNAT 没生效」 | SNAT 的回复 dst 本来就是 NAT 后公网地址 |
| A17 | `ch05.md:471-507` | 6.8 仍有 `max_qlen_log`/`nr_table_entries`/`syn_wait_lock` | 6.8 `request_sock_queue` 已无这些字段 |
| A18 | `ch05.md:560,570` | 正常 SYN 入队调 `inet_csk_reqsk_queue_add(sk, req, NULL)` | 6.8 正常路径是 `inet_csk_reqsk_queue_hash_add` |
| A19 | `ch06.md:291,297` | Linux 延迟 ACK「上限 40 ms」 | 40ms 是 `TCP_ATO_MIN`/`TCP_DELACK_MIN`；上限 `TCP_DELACK_MAX=HZ/5` |
| A20 | `ch11.md:516`、`ch01.md:155` | 回环 `IFF_NOARP`/`NETIF_F_NO_CSUM`/无 MAC/无校验和 | 6.8 `gen_lo_setup`：flags=IFF_LOOPBACK，features 含 HW_CSUM/RXCSUM，addr_len=6 |

---

### A1. `src/part4/ch01.md:293` — 把「时间戳选项吃掉的载荷」写成「MSS 变成 1448」

**原文**

> 以太网 14 + IP 20 = 34，TCP 首部 32 字节，所以应用数据从偏移 66 开始。若 MTU 1500，一个帧最多 1500 字节 IP 包，应用数据上限是 1500 − 20 − 32 = 1448。**握手时双方协商的 MSS 会比这个小 12 字节——这就是为什么抓包里看到的 MSS 常是 1448 而不是 1460。**

**正确说法**

- IPv4、MTU 1500 时，SYN 里通告的 MSS 仍是 **1460**（1500 − 20 − 20），不因为启用时间戳而变成 1448。
- MSS 的定义是「TCP **载荷**的最大长度」，不含 TCP 首部和选项（RFC 9293 §3.7.1；RFC 6691 §2）。12 字节时间戳选项占用的是 TCP 首部空间，结果是**每个段实际可带的数据变成 1448 字节**，但 MSS 选项值仍是 1460。
- 因此 `tcpdump` 在启用时间戳的 SYN 里仍会显示 `mss 1460`；显示 1448 只可能来自 MSS 钳制（`TCPMSS --clamp-mss-to-pmtu`、隧道/PPPoE 的 MTU 更小），不是「时间戳让 MSS 减 12」。

**证据**

- RFC 9293 §3.7.1（MSS Option）：MSS 是「maximum receive segment size」，只计 TCP 数据，不计 TCP 首部。
- RFC 6691 §2：MSS 不含 TCP/IP 首部；路径 MTU 变小时应调整的是可发送数据量，不是把选项算进 MSS。
- Linux 6.8 `include/net/tcp.h`：`TCPOLEN_TSTAMP_ALIGNED 12`；`tcp_sync_mss()` / `tcp_mtu_to_mss()` 的 `mss = mtu - sizeof(struct iphdr) - sizeof(struct tcphdr)` 与选项长度无关。
- 交叉矛盾：`ch06.md:1071` 已写「带 12 字节选项时，实际段长仍是 MSS，只是首部变长、有效载荷变少」，方向与 A1 相反（这句话本身也不严谨，见 A19/其他）。

---

### A2. `src/part4/ch01.md:323` — 3000 字节 IP 包被分成「两片 1480+1020」

**原文**

> 分片本身长这样：一个 3000 字节的 IP 包走 1500 MTU 的链路，会被切成两片。第一片 `MF=1, offset=0`，载荷 1480 字节；第二片 `MF=0, offset=1480/8=185`，载荷 1020 字节。

**正确说法**

- 3000 字节 IP 包 = 20 字节首部 + **2980 字节载荷**。
- 1500 MTU 下每片最多 1480 字节载荷：2980 = 1480 + 1480 + 20，因此是 **3 片**：
  - 第 1 片：载荷 1480，offset 0，MF=1，IP 总长 1500；
  - 第 2 片：载荷 1480，offset 185，MF=1，IP 总长 1500；
  - 第 3 片：载荷 20，offset 370，MF=0，IP 总长 40。
- 「1480 + 1020 = 2500 字节载荷」对应的是 **2520 字节 IP 包**，不是 3000；且第二片 1020 字节不是 8 的倍数（1020/8=127.5），违反片偏移单位。

**证据**

- RFC 791 §3.1–3.2：片偏移以 8 字节为单位；除最后一片外，每片载荷必须是 8 的倍数。
- 算术复算：3000 − 20 = 2980；2980 − 1480 = 1500；1500 − 1480 = 20。
- 同篇 `ch03.md:1205` 的抓包示例（第一片 1500、第二片 1020）对应的是 2500 字节 IP 包，不能反推 3000 字节包只有两片。

---

### A3. `src/part4/ch01.md:683-690` — `goodput.c` 的「运行输出」不是该程序的实际输出

**原文**

> ```text
> MTU=1500 IPv4 plain
>  payload       wire  overhead  goodput
>       64         64     0.0%   100.0%
>      128        162    21.0%    79.0%
>      512        546     6.2%    93.8%
>     1460       1494     2.3%    97.7%
>     8192       frag        -       -
> ```
>
> （`wire_len` 对小于 60 字节的帧做了填充，所以 64 字节载荷也显示 64；……）

**实际运行**（Apple clang 21，`cc -std=c17 -Wall -Wextra -Werror -O2 goodput.c -o goodput`，与书中命令一致）

```text
MTU=1500 IPv4 plain
 payload       wire   overhead  goodput
      64        134      52.2%    47.8%
     128        198      35.4%    64.6%
     256        326      21.5%    78.5%
     512        582      12.0%    88.0%
    1024       1094       6.4%    93.6%
    1460       frag          -        -
    8192       frag          -        -
   16384       frag          -        -
```

**为什么错**

- `wire_len()` 的 `hdr = e->eth(14) + e->vlan(0) + e->ip(20) + e->l4(32) + e->tls(0) = 66`，返回 `len + 4`（FCS）。64 字节载荷必然是 64+66+4=134，不可能是 64；`min_frame=60` 对 66 字节首部永远不触发。
- 1460 字节载荷 + 66 字节首部 = 1526 > 1514，程序按 `len > mtu + 14` 直接返回 `frag`；文档却给出 `1494`（= 1460+34，只算了 IP+TCP），与程序逻辑不符。
- 文档表格的 162/546/1494 都等于「载荷 + 34（IP+TCP）」，说明输出是手写的，不是程序输出；而 64 那一行又写成 64，三行口径互相矛盾。
- 这一条同时是「代码/输出错误」和「goodput 计算错误」：小包场景下以太网首部与 FCS 恰恰是主要开销，漏掉它们会把 47.8% 夸成 100%。

**证据**

- 程序源码 `src/part4/ch01.md:614-671`；`wire_len()` 第 628–642 行。
- 实测命令与输出见本报告「D. 代码/命令实测记录」。
- 以太网帧格式见 RFC 894 / IEEE 802.3：14 字节首部 + 4 字节 FCS。

---

### A4. `src/part4/ch01.md:789` — tcpdump 十六进制里把 `4006` 当成一个字段

**原文**

> `4006` 是标识与标志/片偏移：`4000` 表示 DF 置位；`06` 是协议号 TCP。

**抓包字节**

```text
0x0000:  4500 003c 1c46 4000 4006 b1e6 7f00 0001
0x0010:  7f00 0001 ...
```

**正确说法**

按 IPv4 首部逐字节拆：

| 偏移 | 字节 | 字段 |
|--:|:--|:--|
| 0–1 | `4500` | version=4，IHL=5（20 字节） |
| 2–3 | `003c` | 总长度 60 |
| 4–5 | `1c46` | 标识 0x1c46 |
| 6–7 | `4000` | 标志 + 片偏移：DF=1，MF=0，offset=0 |
| 8 | `40` | TTL=64 |
| 9 | `06` | 协议=TCP |
| 10–11 | `b1e6` | 首部校验和 |
| 12–15 | `7f000001` | 源地址 127.0.0.1 |
| 16–19 | `7f000001` | 目的地址 127.0.0.1 |

`4006` 不是任何一个 16 位字段：它是 **TTL 的高字节 `40` 与协议字节 `06` 的连读**。把 `4006` 说成「标识与标志/片偏移」既错位，又把 ID（`1c46`）漏掉了。

**证据**

- RFC 791 §3.1 首部格式：flags/fragment offset 在字节 6–7，TTL 在字节 8，protocol 在字节 9。
- 同一段十六进制自身可复算：`4500 003c 1c46 4000 4006 b1e6`。

---

### A5. `src/part4/ch01.md:509` — 64 KB 窗口在 10 Gbps/100 ms 上「只能发挥 0.5%」算错 10 倍

**原文**

> 这就是 4.6 里 `cwnd` 与窗口缩放存在的理由：**16 位窗口最大 64 KB，在 10 Gbps/100 ms 链路上只能发挥 0.5% 的带宽**。

**正确说法**

- 10 Gbps × 100 ms 的 BDP = 10×10⁹ × 0.1 / 8 = **125 MB**。
- 64 KiB = 65 536 B；65 536 / 125 000 000 = **0.0524%**，约 **0.05%**，不是 0.5%。
- 若按 64,000 B 计，也只有 0.0512%。
- 同篇 `ch01.md:452` 的 1 Gbps/40 ms 例子算 1.3% 是对的（64 KiB / 5 MB = 1.28%），说明这是孤立的 10 倍笔误。

**证据**

- BDP 定义与算式：`BDP = 带宽 × RTT`；10 Gbps × 0.1 s = 1 Gbit = 125 MB。
- 64 KiB / 125 MB = 5.24×10⁻⁴ = 0.0524%。

---

### A6. `src/part4/ch02.md:283` — VLAN 接口「实际可用 1496」与「有自己的 qdisc」均错，且与 4.2.23 自相矛盾

**原文**

> 这个接口在协议栈里是一个真实的 netdevice，有自己的 MTU（默认 1500，但实际可用 1496，因为标签占 4 字节）、自己的统计计数、自己的 qdisc。

**正确说法**

- `ip link add link eth0 name eth0.100 type vlan id 100` 创建的 VLAN 接口，MTU **默认继承父接口的 1500**，不会自动减 4；`ip link show eth0.100` 可直接看到 `mtu 1500`。
- 4 字节 802.1Q 标签加在以太网首部之后、IP 包之外：1500 字节 IP 包 → 1518 字节帧（含 FCS），仍是标准以太网最大帧。只有当链路/交换机把**帧长**严格限制在 1518（即不允许 1522）时，才需要把 VLAN 接口 MTU 手动设为 1496。
- VLAN 设备默认是 `noqueue`，真正的排队在父设备的 qdisc 上；4.2.25 第 1179 行自己也写「VLAN 设备自己通常没有 qdisc 排队，真正的排队发生在父设备上」。
- 同篇 4.2.23 第 1055 行明确把「VLAN 接口 MTU 默认 1496」称为「流传很广的错误说法」，与 4.2.6 的这句直接冲突。

**证据**

- Linux 6.8 `net/8021q/vlan_dev.c`：VLAN 设备 MTU 从 real_dev 继承，标签由 `__vlan_hwaccel_put_tag()`/`__vlan_insert_tag()` 在 IP 包外插入。
- `ip link` 实测（任何 Linux 主机）：`ip -d link show eth0.100` 显示 `mtu 1500`；`tc qdisc show dev eth0.100` 显示 `noqueue`。
- 本书自身：`ch02.md:1055`、`ch02.md:1179`。

---

### A7. `src/part4/ch02.md:1055` — VLAN 帧长算式把 4 字节标签算了两遍

**原文**

> 但如果链路上有设备严格限制 1518，就必须把 VLAN 接口 MTU 设成 1496，让「1496 载荷 + 4 标签 + 18 头 + 4 FCS = 1522」落到限制内。

**正确说法**

- 18 字节头 = 14 字节以太网首部 + **4 字节 VLAN 标签**；再加 4 字节 FCS，帧长 = 1496 + 18 + 4 = **1518**，不是 1522。
- 要得到 1522，载荷必须是 **1500**：1500 + 18 + 4 = 1522。
- 反过来说：若目标是把帧压到 1518 以内，VLAN 接口 MTU 应为 1496（1496+18+4=1518），算式应写「1496 + 18 + 4 = 1518」；原文的「4 标签 + 18 头」重复计算了标签。

**证据**

- IEEE 802.1Q：标签 4 字节（TPID 2 + TCI 2），插在源 MAC 之后、EtherType 之前。
- 同篇 4.2.22 第 1004 行公式：`帧长 = 14（首部）+ 载荷 + 填充 + 4（FCS）`；带 VLAN 时 14 已含标签的 4 字节（即 18）。
- 算术：1496+18+4=1518；1500+18+4=1522。

---

### A8. `src/part4/ch03.md:170-174` — /22 划分子网的例子既算错可用主机数，也给出了不可能的方案

**原文**

> - 500 台需要 512 个地址（`/23`），取 `10.20.0.0/23`，可用 510 台，**刚好不够**——所以要用 `/23` 加溢出，或者改成 500 台上限按 512 分配并留余量。……
> - 300 台需要 512 个地址（`/23`），但剩下的只有 `10.20.2.0/23`，正好一整块。
> - 100 台需要 128 个地址（`/25`），从 `10.20.2.0/23` 里切就冲突了。
>
> 正确切法是：`10.20.0.0/23` 给 500 台，`10.20.2.0/24` 给 300 台（254 个够），`10.20.3.0/25` 给 100 台（126 个够）……

**正确说法**

- `/23` 有 512 个地址、**510 个可用主机地址**，500 台是够的（510 ≥ 500），不是「刚好不够」。
- `10.20.2.0/24` 只有 254 个可用主机地址，**不够 300 台**。
- 更根本的是：`10.20.0.0/22` 只有 1024 个地址。按传统定长子网，500 台要 /23（512）、300 台要 /23（512）、100 台要 /25（128），合计 1152 > 1024，**这个 /22 本身就不够分**。正确做法是换更大的块（如 /21）、再申请一个 /22，或重新评估需求；至少不能把 300 台塞进 /24。

**证据**

- 子网可用主机数 = 2^(32−prefix) − 2（RFC 950；/31 例外见 RFC 3021）。
- 算术：/23 = 512−2 = 510；/24 = 256−2 = 254；/25 = 128−2 = 126。
- 总量：512+512+128 = 1152 > 1024。

---

### A9. `src/part4/ch03.md:302` — `conntrack -C` 被说成「经过 NAT 的连接数」

**原文**

> `conntrack -C` 的数字很关键：它等于「当前经过 NAT 的连接数」，接近 `nf_conntrack_max` 时新连接会被丢弃……

**正确说法**

- `conntrack -C` 打印的是 **conntrack 表中的条目总数**，包括所有被跟踪的连接（NAT 与非 NAT、本机与转发），不是「经过 NAT 的连接数」。
- 判断 NAT 负载应结合 `conntrack -L` 的 NAT 扩展/元组，或 nftables 规则计数；`nf_conntrack_count` 同样是全表计数。
- 同篇 `ch03.md:1234` 自己写「`-C` 是当前条目数」，与 4.3.6 的「经过 NAT 的连接数」矛盾。

**证据**

- `conntrack(8)`：`-C, --count` — "Show the number of entries in the conntrack table."
- Linux 6.8 `net/netfilter/nf_conntrack_core.c`：`nf_conntrack_count` 统计整个哈希表条目，不区分 NAT。
- 本书自身：`ch03.md:1234`。

---

### A10. `src/part4/ch04.md:581` — MSS 协商被写成「每个方向取双方通告值的较小者」

**原文**

> MSS 在 SYN 里由双方各自通告，最终**每个方向取自己的通告值和对方通告值的较小者**（实际发送还受 PMTU 约束）。

**正确说法**

- 设 A 通告 `MSS_A`（A 能接收的最大 TCP 载荷），B 通告 `MSS_B`。
- **A 发送时使用 B 通告的 `MSS_B`；B 发送时使用 A 通告的 `MSS_A`**。每个方向用的是「对端通告值」，不是「双方较小者」。
- 因此 A=1460、B=1400 时，A→B 的段 ≤1400，B→A 的段 ≤1460；原文的「取 min」会让两个方向都 ≤1400，是错的。
- 实际发送还受 PMTU/`mss_cache` 约束，但那是另一层限制，不能拿来解释「取 min」。

**证据**

- RFC 9293 §3.7.1：MSS option 由接收方通告，发送方「MUST NOT send data larger than the MSS received from the peer」。
- RFC 6691 §2：MSS 是「maximum size of a TCP segment that a host is willing to receive」，方向性明确。
- Linux 6.8 `tcp_input.c` `tcp_parse_options()` 把对端 MSS 写入 `opt_rx->mss_clamp`；`tcp_sync_mss()` 用它算本端 `mss_cache`，不存在「双方取 min」。

---

### A11. `src/part4/ch04.md:583-586` — 窗口缩放的 shift 被写成「双方取 min」

**原文**

> 窗口缩放把窗口值左移 `shift` 位，`shift` 由双方在 SYN 里各自通告，取 `min(自己的, 对方的)`：

**正确说法**

- 每个方向独立：A 在 SYN 里通告自己的 `shift_A`（用于 A 的接收窗口），B 通告 `shift_B`（用于 B 的接收窗口）。
- A 收到 B 的段时，用 **B 通告的 `shift_B`** 左移窗口字段；B 收到 A 的段时，用 **A 通告的 `shift_A`**。不存在 `min`。
- `ss -ti` 的 `wscale:snd,rcv` 正是两个方向的值；A=7、B=0 时显示 `wscale:7,0` 或 `0,7`（取决于视角），绝不是两边都 0 或都 7。

**证据**

- RFC 7323 §2.2：Window Scale 是「an offer, not a promise」；`shift.cnt` 是「applied to its receive window」。
- RFC 7323 §2.3：收到对端 `shift.cnt=S` 后 `Snd.Wind.Shift=S`，本端 `Rcv.Wind.Shift=R`；`SND.WND = SEG.WND << Snd.Wind.Shift`。
- Linux 6.8 `tcp_input.c`：`tp->rx_opt.snd_wscale` 与 `rcv_wscale` 分开保存，不存在 min。

---

### A12. `src/part4/ch05.md:52` — `tcpdump -S` 下第三个包仍写 `seq 1`

**原文**

> ```text
> 3) 127.0.0.1.51234 > 127.0.0.1.8080: Flags [.], seq 1, ack 1987654322, win 512, length 0
> ```

**正确说法**

- `-S`（`--absolute-tcp-sequence-numbers`）的含义是「打印绝对序号，而不是相对序号」。
- 客户端 ISN = 3123456789，SYN 消耗一个序号，所以第三个 ACK 的 `seq` 应为 **3123456790**，不是 1。
- `seq 1` 是 tcpdump 默认的相对序号口径（把第一个数据字节显示为 1），与命令里的 `-S` 冲突；同一段示例的 `ack 1987654322` 又是绝对口径，前后不一致。

**证据**

- `tcpdump --help` / man：`-S` — "Print absolute, rather than relative, TCP sequence numbers."
- RFC 9293 §3.4：SYN 占一个序号，第三个 ACK 的 `SEQ = ISS+1`。
- 算术：3123456789 + 1 = 3123456790。

---

### A13. `src/part4/ch05.md:314-319` — 状态图把 `LAST-ACK` 的「收 ACK」画到 `TIME-WAIT`

**原文**

> ```text
> │LAST-ACK│  │ FIN-WAIT-2│
> └───┬───┘    └─────┬─────┘
> 收 ACK │          收 FIN│
>        ▼               ▼
>    ┌──────────────────────┐
>    │      TIME-WAIT       │
>    └──────────────────────┘
> ```

**正确说法**

- `LAST-ACK` 是「被动关闭方发完 FIN、等最后 ACK」的状态；收到 ACK 后应进入 **CLOSED**，不是 TIME-WAIT。
- 进入 TIME-WAIT 的路径是：主动关闭方的 `FIN-WAIT-2` 收到 FIN，或 `FIN-WAIT-1` 在收到 ACK 后又收到 FIN（同时关闭时经过 `CLOSING`）。
- 这张图还漏了 `CLOSING` 状态；标题说「11 个状态、全部转换」，但图里没有 CLOSING。

**证据**

- RFC 793 §3.9 状态表：`LAST-ACK STATE — The only thing that can arrive ... is an acknowledgment of our FIN. If our FIN is now acknowledged, delete the TCB, enter the CLOSED state.`
- Linux 6.8 `include/net/tcp_states.h`：`TCP_CLOSING`、`TCP_LAST_ACK`、`TCP_TIME_WAIT` 是独立状态。

---

### A14. `src/part4/ch06.md:1048` — 「CWR / ECE 由路由器置位」

**原文**

> | CWR / ECE | 拥塞窗口已减 / 显式拥塞通知 | ECN 协商成功后由路由器置位 |

**正确说法**

- 路由器在 IP 首部把 ECN 字段的 **CE 位**置 1（不是 TCP 的 ECE）。
- 接收方收到 CE 标记的包后，在 TCP 首部置 **ECE**，把拥塞信号回显给发送方。
- 发送方看到 ECE 后降低拥塞窗口，并在下一个包上置 **CWR** 告诉接收方「已经减窗」。
- 三个标志分属三个角色，不能笼统说「由路由器置位」。

**证据**

- RFC 3168 §6.1：`ECN uses the ECT and CE flags in the IP header ... for signaling between routers and connection endpoints, and uses the ECN-Echo and CWR flags in the TCP header ... for TCP-endpoint to TCP-endpoint signaling.`
- RFC 3168 §6.1.2/§6.1.3：路由器置 CE；接收方置 ECE；发送方置 CWR。

---

### A15. `src/part4/ch03.md:1211,1220` — 分片第二片 `length 144`，解释「载荷 124 + 20 首部 = 144」

**原文**

> ```text
> IP (tos 0x0, ttl 63, id 12345, offset 172, flags [none], proto ICMP (1), length 144)
> ```
>
> 3. **分片的第二片 `offset 172`**。172 × 8 = 1376，正是第一片的载荷长度（MTU 1400 − 20 首部 = 1380，向下取整到 1376）。第二片载荷 124 字节，加 20 字节首部是 144 字节。

**正确说法**

- 原始 ping 是 `-s 1472`，IP 总长 1500，载荷 1480。
- 路由器 r1 MTU 1400，满片载荷 1376；剩余载荷 = 1480 − 1376 = **104**，第二片 IP 总长 = 20 + 104 = **124**，不是 144。
- 144 对应载荷 124，会使原始 IP 包变成 20+1376+124 = 1520 字节，凭空多 20 字节；与「原始包 1500」矛盾。

**证据**

- RFC 791 §3.2 分片算法；算术：1480 − 1376 = 104；104 + 20 = 124。
- 同段抓包第一片 `length 1396`（20+1376），两片总长应为 1396+124=1520（多出的 20 是第二片首部），原始 1500 = 20+1480。

---

### A16. `src/part4/ch03.md:948` — 「回复方向的 `dst` 不是内网地址，说明 SNAT 没生效」

**原文**

> 前半段是原始方向，后半段是回复方向。……**如果回复方向的 `dst` 不是内网地址，说明 SNAT 没生效或规则顺序错了**。

**正确说法**

- 对 **SNAT**，回复方向的 `dst` 本来就应该是 **NAT 后的公网地址**（示例里的 `203.0.113.5`），不是内网地址。
- 原始方向：`src=10.0.0.2 dst=93.184.216.34 sport=51234 dport=80`；回复方向：`src=93.184.216.34 dst=203.0.113.5 sport=80 dport=40001`。这正是 SNAT 生效的样子。
- 判断 SNAT 是否生效，应看「原始方向的 src 是内网、回复方向的 dst 是 NAT 后的地址」；若回复方向的 dst 仍是内网地址，才说明没有做 SNAT。
- 对 **DNAT**，才是回复方向的 `src` 应为内网后端地址。

**证据**

- conntrack 原始/回复 tuple 的定义：回复 tuple 是原始 tuple 的地址/端口对调，并应用 NAT 映射。
- 本书示例本身（`ch03.md:944-947`）就显示 `dst=203.0.113.5`，与 948 行的判据矛盾。
- `conntrack(8)` / `nf_conntrack_tuple` 语义。

---

### A17. `src/part4/ch05.md:471-507` — 4.5.15 仍用旧内核（`listen_sock` 时代）的 `request_sock_queue` 结构

**原文**

> | `max_qlen_log` | `u16` | 半连接队列 | 存的是 **2 的幂次**，不是长度 |
> | `nr_table_entries` | `u16` | 半连接队列 | 哈希桶数，长度是 2 的幂 |
> | `syn_wait_lock` | `rwlock_t` | — | 保护 SYN 哈希表 |
>
> `int reqsk_queue_alloc(struct request_sock_queue *queue, unsigned int nr_table_entries) { ... }`

**正确说法**

- Linux 6.8 的 `struct request_sock_queue`（`include/net/request_sock.h`）只有：`rskq_lock`、`rskq_defer_accept`、`synflood_warned`、`qlen`、`young`、`rskq_accept_head/tail`、`fastopenq`；**没有** `max_qlen_log`、`nr_table_entries`、`syn_wait_lock`。
- 6.8 的 `reqsk_queue_alloc(struct request_sock_queue *queue)` **只接收 queue 一个参数**，不计算队列长度，也不设置 `max_qlen_log`。
- SYN 队列的长度控制已改为 `inet_csk_reqsk_queue_hash_add()` + `sk_max_ack_backlog`/`tcp_max_syn_backlog` 的运行时判断，不存在书里那套 `roundup_pow_of_two(nr_table_entries+1)` 的字段。
- 因此 4.5.15 的字段表、`reqsk_queue_alloc()` 代码和「半连接队列 ≈ min(...)+1 向上取整」的公式都不能用于 Linux 6.8；这是**旧内核资料**，不是「简化」。

**证据**

- Linux 6.8 `include/net/request_sock.h`：`struct request_sock_queue` 字段列表；`void reqsk_queue_alloc(struct request_sock_queue *queue);`
- Linux 6.8 `net/core/request_sock.c`：`reqsk_queue_alloc()` 只初始化 `fastopenq` 和 `rskq_accept_head`。
- Linux 6.8 `net/ipv4/inet_connection_sock.c:1113`：`inet_csk_reqsk_queue_hash_add()` 负责把 request_sock 放进 SYN 哈希表并调用 `inet_csk_reqsk_queue_added()`。

---

### A18. `src/part4/ch05.md:560,570` — 正常 SYN 入队被写成 `inet_csk_reqsk_queue_add(sk, req, NULL)`

**原文**

> ```c
> inet_csk_reqsk_queue_add(sk, req, NULL);      /* 先挂 SYN 表 */
> ```
>
> 注意 `inet_csk_reqsk_queue_add(sk, req, NULL)` 在这条路径上挂的是 **SYN 表**（第三个参数是 `struct sock *child`，此处为 NULL）；第三次 ACK 时同一个函数再被调用一次，这次带 child，挂的是 **accept 链表**。同名函数、两个队列，靠参数区分——读源码时最容易看错的地方。

**正确说法**

- 在 Linux 6.8 中，`inet_csk_reqsk_queue_add()` **只把 request_sock 挂进 accept 链表**（`icsk_accept_queue.rskq_accept_head/tail`），与 `child` 是否为 NULL 无关；它不会挂 SYN 表。
- 正常 SYN 的入队路径是 `tcp_conn_request()` → `inet_csk_reqsk_queue_hash_add(sk, req, timeout)`，进入 SYN 哈希表并增加队列计数。
- `inet_csk_reqsk_queue_add(sk, req, child)` 只在 TFO（Fast Open）已有子 socket 时，把「req + child」直接放进 accept 队列；正常三次握手是在第三次 ACK 的 `tcp_check_req()` 里创建 child，再通过 `inet_csk_complete_hashdance()`/accept 队列完成，不是「同一个函数带 NULL 挂 SYN 表」。
- 「同名函数、两个队列，靠参数区分」是错的；SYN 表和 accept 队列用的是不同的函数/数据结构。

**证据**

- Linux 6.8 `net/ipv4/inet_connection_sock.c:1296`：`inet_csk_reqsk_queue_add()` 只操作 `queue->rskq_accept_head/tail`。
- Linux 6.8 `net/ipv4/tcp_input.c:7234`：正常路径 `inet_csk_reqsk_queue_hash_add(sk, req, req->timeout)`；TFO 路径在 7221 行才用 `inet_csk_reqsk_queue_add(sk, req, fastopen_sk)`。
- Linux 6.8 `include/net/request_sock.h`：`rskq_accept_head` 注释为 "FIFO head of established children"。

---

### A19. `src/part4/ch06.md:291,297` — 「Linux 延迟 ACK 上限 40 ms」

**原文**

> **延迟 ACK**：接收方收到数据后不立刻回 ACK，而是等一小会儿（Linux 上限 40 ms）……
>
> 服务端: 收到 1 字节 → 等 40 ms 再 ACK（延迟 ACK）

**正确说法**

- 40 ms 是 `TCP_DELACK_MIN`/`TCP_ATO_MIN`（HZ≥100 时 `HZ/25`），是**常用/最小值**，不是内核上限。
- 上限是 `TCP_DELACK_MAX`（`HZ/5`）：HZ=1000 时 200 ms，HZ=250 时 50 ms；具体路径还会被 `icsk_delack_max` 限制。
- 「Nagle + 延迟 ACK 造成 40 ms 停顿」作为常见现象可以保留，但不能说「Linux 上限 40 ms」。

**证据**

- Linux 6.8 `include/net/tcp.h`：
  - `#define TCP_DELACK_MAX ((unsigned)(HZ/5)) /* maximal time to delay before sending an ACK */`
  - `#define TCP_DELACK_MIN ((unsigned)(HZ/25))`
  - `#define TCP_ATO_MIN ((unsigned)(HZ/25))`
- Linux 6.8 `net/ipv4/tcp_input.c:6476`：`inet_csk_reset_xmit_timer(..., ICSK_TIME_DACK, TCP_DELACK_MAX, TCP_RTO_MAX);`
- RFC 1122 §4.2.3.2 只要求延迟 ACK 不超过 500 ms，未规定 40 ms 上限。

---

### A20. `src/part4/ch11.md:516`、`src/part4/ch01.md:155` — 回环的 `IFF_NOARP`/`NETIF_F_NO_CSUM`/「无 MAC」均与 6.8 源码不符

**原文**

> 回环为什么不需要 ARP？因为 `lo` 的 `IFF_NOARP` 标志，且路由是 `RTN_LOCAL`……
> 回环为什么不需要校验和？因为 `lo` 的 `NETIF_F_NO_CSUM`/`NETIF_F_LLTX` 等特性……校验和只在 `skb->ip_summed` 上标记为 `CHECKSUM_UNNECESSARY`。

以及：

> **第四段：链路层封装。** 回环设备没有 MAC 地址，以太网首部被简化成 14 字节的「伪首部」……

**正确说法**

- Linux 6.8 的 `gen_lo_setup()` 设置 `dev->flags = IFF_LOOPBACK`，**没有 `IFF_NOARP`**；ARP 不走回环，是因为 `IFF_LOOPBACK`/`RTN_LOCAL` 路径直接返回邻居项，不是 `IFF_NOARP`。
- `lo` 的 features 是 `NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE | NETIF_F_HW_CSUM | NETIF_F_RXCSUM | ... | NETIF_F_LLTX | ...`，**没有 `NETIF_F_NO_CSUM`**。回环并非「不需要校验和」，而是用 `CHECKSUM_UNNECESSARY`/硬件校验和语义跳过软件校验。
- `lo` 有 MAC 地址字段：`dev->addr_len = ETH_ALEN`（6），默认地址是全 0，`hard_header_len = ETH_HLEN`（14），所以 `tcpdump -i lo -e` 能看到 `00:00:00:00:00:00 > 00:00:00:00:00:00` 的以太网首部。说「没有 MAC 地址」与同篇 `ch01.md:406` 的「全是 0」自相矛盾。

**证据**

- Linux 6.8 `drivers/net/loopback.c` `gen_lo_setup()`：
  - `dev->flags = IFF_LOOPBACK;`
  - `dev->addr_len = ETH_ALEN; dev->hard_header_len = ETH_HLEN;`
  - `dev->features = ... | NETIF_F_HW_CSUM | NETIF_F_RXCSUM | ... | NETIF_F_LLTX | ...;`
- Linux 6.8 `net/ipv4/arp.c` `arp_rcv()`：`if (dev->flags & (IFF_NOARP | IFF_LOOPBACK)) goto drop;`——回环是被 `IFF_LOOPBACK` 排除的，不是 `IFF_NOARP`。
- 本书自身：`ch01.md:406`。

---

## A21–A26：其他已确认问题（不计入 Top 20）

| # | 文件:行 | 原文摘要 | 正确说法/证据 |
|--:|:--|:--|:--|
| A21 | `ch09.md:487-488` | 64 KiB、`gso_size=1460`，「生成 44 个段/44 个 1514 字节帧」 | 65536/1460 = 44.89，应为 **45 段**（44×1460+1256）；44 个满帧只覆盖 64,240 字节。若按 64,000 字节才是 44 段，但同段明写 `skb->len ≈ 65536`。 |
| A22 | `ch03.md:794-795` | ICMP type 3 code 1 Host Unreachable → IPv6 `1/1`；code 2 Protocol Unreachable → `1/1` | ICMPv6 type 1：code 1 = administratively prohibited，code 3 = address unreachable。Host Unreachable 应映射到 **1/3**；Protocol Unreachable 在 ICMPv6 无直接对应，不能写 1/1。RFC 4443 §3.1。 |
| A23 | `ch11.md:1062,1088` | VXLAN MTU 1450，却用 `ping -M do -s 1450` 验证 | `-s` 是 ICMP 载荷；1450 MTU 下最大 `-s` 是 1450−20−8=**1422**。`-s 1450` 会生成 1478 字节 IP 包，必然失败，不能证明「小包通」。 |
| A24 | `ch01.md:1184` | 「没有路由时……回 type 3 code 0，并增加 `InAddrErrors`」 | 主机未开转发时无路由是 `EHOSTUNREACH` → **type 3 code 1** + `InAddrErrors`；路由器开转发且 FIB 无匹配才是 `ENETUNREACH` → code 0 + `InNoRoutes`。code 0 与 `InAddrErrors` 不是一对。见 Linux 6.8 `net/ipv4/route.c` `ip_error()`。 |
| A25 | `ch04.md:103` | 「六个标志位」 | TCP 首部控制位共 9 个（NS + CWR/ECE/URG/ACK/PSH/RST/SYN/FIN），常用 8 个；本节图里画了 8 个，文字却说 6 个，前后不一致。RFC 9293 §3.1。 |
| A26 | `ch02.md:483` | `REORDER_HDR`「关闭它会影响硬件加速与抓包看到的字节序」 | `REORDER_HDR` 控制 VLAN 标签在 skb 中的位置（是否在 data 前重排），影响硬件加速/抓包看到的**标签位置**，不是字节序。Linux 6.8 `net/8021q/vlan_dev.c`。 |

---

## B. 漏节 Top 15

> 判定标准：母本节有**独立机制/协议格式/算法**，而第 4 篇只有一句提及或完全没有；「总结性淘汰」和「仅作为背景一句带过」不算漏，但**母本声称「完整」而实际只有一句**的，算漏。
> 页码依据 `写作规范/source-toc/cn8.md`、`clean-network.md`、`clean-kerrisk.md`；W 的节号以第 8 版纸书目录为准。
> 张彦飞 N：10 章均有落点，未发现整节缺失；其 6.2.5「半连接队列长度计算」有落点但用错内核结构（A17/A18），属于「落了但错」，不计入漏节。

| # | 母本节号 + 标题 | 为什么算漏（证据） | 建议补到 |
|--:|:--|:--|:--|
| B1 | W 第 2 章 2.4 信道复用技术（FDM/TDM/STDM/WDM/CDMA） | 全篇只有「信道复用」四个字出现在母本对应表；正文没有频分/时分/统计时分/波分/码分、CDMA 码片正交的任何机制。grep `CDMA` = 0。 | 4.2.1 后新增 4.2.x「信道复用与接入」 |
| B2 | W 第 3 章 3.2 点对点协议 PPP | 4.2.11 只有一段：无 MAC、`0x7e` 填充、LCP/NCP、PPPoE 8 字节；没有 PPP 帧格式（Flag/Address/Control/Protocol/FCS）、字节填充规则、LCP 协商状态机、PPPoE 发现/会话阶段。 | 4.2.11 扩为「PPP/PPPoE 的帧与状态」 |
| B3 | W 第 3 章 3.3.4 以太网信道利用率、3.5 高速以太网（100BASE-T/1000BASE-T/10GBASE） | 4.2.20 只讲编码/符号率；没有信道利用率公式（帧长/争用期/帧间间隔的关系）、冲突窗口与帧长的关系、1000BASE-T 与 1000BASE-X 的 MAC/PHY 差异；「高速以太网」整节缺席。grep `高速以太网`=0。 | 4.2.20–4.2.21 增补 |
| B4 | W 第 4 章 4.1 网络层提供的两种服务（虚电路 vs 数据报） | 只有「网络层是无连接的」一句；没有虚电路/数据报的对比、VC 标识、两种服务在转发/顺序/可靠性上的差异。 | 4.3 导语或 4.3.1 前 |
| B5 | W 第 4 章 4.5 路由选择协议（RIP/OSPF/BGP） | 4.3.4 只有 3 行表格 + 一句「RIP 数跳、OSPF 算路、BGP 讲策略」；没有距离向量算法/计数到无穷、RIP 计时器与 15 跳、OSPF LSA/区域/SPF、BGP 属性/AS 路径/策略。 | 4.3.4 扩为「路由协议三件套」或新增 4.3.x |
| B6 | W 第 4 章 4.7 IP 多播（IGMP、组播路由、DVMRP/PIM） | 全篇没有「多播」；只有 IGMP 协议号 2 和「组播」零散提及，没有 IGMP 报文、组播 MAC 映射、RPF/共享树/源树。grep `多播`=0。 | 4.3.x「组播与 IGMP」 |
| B7 | W 第 4 章 4.8 虚拟专用网 VPN | 只有 IP-in-IP/GRE 的 MTU 一行；没有 VPN 分类（内联网/外联网/远程接入）、隧道模式、IPsec AH/ESP 的协议号与封装。NAT 已覆盖，VPN 没有。 | 4.3.6 后或 4.12.8 |
| B8 | W 第 4 章 4.9 多协议标记交换 MPLS | 只有 EtherType `0x8847` 一行；没有标签栈、LER/LSR、标签分发、VPN 中的 MPLS。以第 8 版纸书目录为准；若该版删去本节，可降为「背景」不计漏。 | 4.3.7 后新增小节 |
| B9 | W 第 5 章 5.4 可靠传输的工作原理（停止等待、ARQ、滑动窗口） | ch06 直接从 TCP 重传/RTO 开始；grep `停止等待`/`ARQ`/`回退N`/`选择重传` 全为 0。没有停止等待协议、超时重传、序号/确认、窗口为 1 的 ARQ 模型，读者缺少「TCP 为什么这样设计」的前置。 | 4.6.1 前新增 4.6.0 或并入 4.6.1 |
| B10 | W 第 6 章 6.2 FTP、6.3 TELNET、6.5 电子邮件（SMTP/POP3/IMAP/MIME）、6.6 DHCP | 全篇没有 FTP 控制/数据连接、SMTP 命令/邮件格式、POP3/IMAP、DHCP 四步（DISCOVER/OFFER/REQUEST/ACK）的任何机制；只有 NAT ALG 提到 FTP、地址配置表提到 DHCP。grep `POP3`/`IMAP`=0。 | 4.7.x「其他应用层协议」或分节补 |
| B11 | W 第 7 章 7.3 数字签名、7.4 鉴别、7.5 密钥分配、7.6.1 IPsec、7.7 防火墙与入侵检测 | 4.7.7/4.7.10 只有一张原语表和三类威胁；没有数字签名流程、报文鉴别/HMAC、KDC/Diffie-Hellman、IPsec SA/AH/ESP、防火墙规则/IDS。grep `鉴别`/`密钥分配`/`入侵检测`=0。 | 4.7.10 扩为「网络安全机制」 |
| B12 | W 第 8 章 8.2–8.5 流式/交互式音视频、RTP/RTCP、拥塞控制 | 4.7.11 只有一页「为什么用 UDP」；没有 RTP 头（PT/seq/timestamp/SSRC）、RTCP 报告、抖动缓冲、FEC/重传策略。grep `RTP` 仅 1 处、`RTCP` 仅 1 处。 | 4.7.11 扩为「实时媒体协议」 |
| B13 | W 第 9 章 9.1 无线局域网 WLAN（802.11 MAC/帧/CSMA/CA）、9.5 移动 IP | 4.2.8 只有 CSMA/CA、隐藏终端、四地址的概述；没有 802.11 帧控制字段、DIFS/SIFS/退避、ACK/重传、移动 IP 的家乡代理/转交地址。grep `移动IP`=0。 | 4.2.8 扩为「无线链路层与移动性」 |
| B14 | K 第 61 章 61.13 高级功能（OOB、sendmsg/recvmsg、SCM_RIGHTS、SCM_CREDENTIALS、SOCK_SEQPACKET、SCTP/DCCP；p1098–1100） | 全篇只有 `sendmsg/recvmsg` 作为函数名出现；没有带外数据、fd 传递、凭据传递、SOCK_SEQPACKET、SCTP/DCCP 的任何机制。grep `SCM_RIGHTS`/`SOCK_SEQPACKET`/`DCCP`=0。 | 4.4 或 4.10 新增「socket 高级语义」 |
| B15 | K 第 63 章 63.3 信号驱动 I/O（p1150–1155）、63.5 pselect/ppoll（p1169 起） | 4.10 只有 `sock_wake_async` 一行提到 SIGIO；没有 O_ASYNC/F_SETOWN、SIGIO 语义、pselect/ppoll 的原子等待。grep `pselect`=0，`ppoll` 只匹配到 `eppoll_entry`（不是系统调用）。 | 4.10.x「其他 I/O 模型」 |

**候补（未入 top 15，但建议一起处理）**

- K 第 61 章 61.2 `shutdown()`、61.5 `getsockname/getpeername`、61.10 `SO_REUSEADDR` 语义、61.11 `accept` 继承：全篇只有 `shutdown` 一句「半关闭」、`SO_REUSEADDR` 只在代码里出现，没有 TIME_WAIT 绑定语义和 accept 继承。建议补 4.5.7/4.5.8。
- W 第 3 章 3.1 三个基本问题（封装成帧/透明传输/差错检测）：4.2.2/4.2.7 有 CRC 和帧格式，但没有「透明传输/字节填充」的系统讲法。
- W 第 4 章 4.6 IPv6 的过渡技术（双协议栈/隧道/NAT64）：4.3.7 只讲首部和 NDP，没有过渡机制。
- K 第 58 章 58.7 RFC：属于背景，不单列。

---

## C. 已核对无问题清单

> 这些条目逐字段/逐算式核对过，暂未发现事实错误；后续若发现新证据会移出。标注「实测」的见 D 节。

### C1. 协议首部与字段

- IPv4 固定首部 20 字节、IHL 单位 4 字节、总长度单位 1 字节、片偏移单位 8 字节、TTL/协议/校验和偏移：`ch03.md:14-41`、`ch03.md:441-473` 正确。
- IPv4 首部校验和示例 `0x9b1a`：`ch03.md:47-84` 源码编译运行，输出 `checksum = 0x9b1a`、`verify = 0x0000`（实测）。
- TCP 固定首部 20 字节、data offset 单位 4 字节（5=20、15=60）、选项区最多 40 字节：`ch04.md:79-141`、`ch06.md:1021-1070` 正确。
- TCP 选项 TLV 长度含 kind+length、EOL/NOP 单字节、MSS=4、WS=3、SACK permitted=2、SACK=2+8n、TS=10：`ch04.md:539-576` 正确；SYN 选项示例 24 字节 → doff=11（0xb0）算术正确。
- UDP 首部 8 字节、长度含首部、IPv4 校验和可 0、IPv6 不可 0：`ch04.md:44-77`、`ch06.md:913-940` 正确；`udp_csum.c` 输出 `0xaab5`/`0xffff`（实测）。
- 以太网 II 14 字节首部、46–1500 载荷、64 字节最小帧（含 FCS）、1518 最大帧：`ch02.md:43-80`、`ch02.md:967-1013` 正确。
- 802.1Q：TPID `0x8100`、TCI 中 PCP 3/DEI 1/VID 12、标签插在源 MAC 之后：`ch02.md:242-287`、`ch02.md:435-490` 正确（VID 0/4095 的保留语义在 `ch02.md:278` 与 `ch02.md:466` 表述不完全一致，但不是硬错）。
- ARP 报文 28 字节、帧长 42（不含 FCS）、请求广播/应答单播、邻居状态机：`ch02.md:157-207`、`ch02.md:361-401` 正确。
- DNS 12 字节头字段（ID/QR/Opcode/AA/TC/RD/RA/Z/RCODE）、压缩指针 14 位偏移、OPT 记录复用 CLASS/TTL：`ch07.md:502-551` 正确。
- TLS 1.3 记录头 5 字节、ContentType 20/21/22/23、legacy_version 0x0303、握手 1-RTT、证书加密：`ch07.md:553-610` 正确。
- IPv6 首部固定 40 字节、无首部校验和、NDP 替代 ARP、MSS 1440：`ch03.md:308-338` 正确。

### C2. 机制与算术

- 以太网最小帧 64 字节 = 6+6+2+46+4；10 Mbps 时隙 512 bit = 51.2 µs；1000BASE-T 半双工时隙 4096 bit = 4.096 µs：`ch02.md:916-965` 正确。
- 编码表：10BASE-T 20 MBd/0.5、100BASE-TX 125 MBd/0.8、1000BASE-X 1.25 GBd/0.8、1000BASE-T 125 MBd×4×2、10GBASE-R 10.3125 GBd×64/66：`ch02.md:848-914` 正确，脚本输出与表一致。
- IPv4 分片程序 `frag_plan.c`：`4000/1500` 输出 1480+1480+1020、偏移 0/1480/2960；`4000/1400` 输出 1376+1376+1228、偏移 0/1376/2752；校验和 `0x2edb/0x2e22/0x4f35` 与 `0x2f43/0x2e97/0x4e7f` 与书中一致（实测）。
- RTO 程序 `rto.c`：五个样本的 SRTT/RTTVAR/RTO 与书中逐行一致；退避 735/1471/2942/5883/11767 ms 一致（实测）。
- TCP 三次握手 SYN/FIN 各消耗一个序号；TIME_WAIT 2MSL=60 s（Linux）；`tcp_tw_recycle` 在 4.12 移除：`ch05.md:14-31`、`ch05.md:212-240` 正确。
- `tcp_tw_reuse=1` 需时间戳、只对主动连接有效：`ch05.md:229-236` 正确。
- `tcp_retries2=15` 约 13–30 分钟、`tcp_syn_retries=6` 约 127 s：`ch04.md:371-395`、`ch05.md:101-110` 正确。
- `ss -ti` 的 `cwnd` 单位 MSS、`rtt` 为 µs 显示为 ms、`retrans:a/b` 为当前/累计：`ch04.md:334-369`、`ch06.md:1074-1098` 大体正确。
- `nstat`/`ss`/`tcpdump` 的常用过滤器（`tcp[13] & 2`、`ip[6:2] & 0x3fff`、`vlan 100`）语法与语义正确：`ch01.md:866-925`、`ch02.md:732-785`。
- TCP 首部 `doff` 单位、MSS 选项 4 字节、窗口缩放 3 字节、SACK permitted 2 字节、时间戳 10 字节：`ch04.md:539-576`、`ch06.md:1021-1070` 正确（MSS 与选项关系的表述见 A1/A19，另计）。
- NAT 钩子顺序 DNAT 在路由前、SNAT 在路由后；`nf_defrag` 优先级 −400、conntrack −200、NAT_DST −100、NAT_SRC 100：`ch03.md:856-930`、`ch08.md:587-610` 正确。
- conntrack 状态 NEW/ESTABLISHED/RELATED/INVALID/UNTRACKED 的语义（UNTRACKED 是 pseudo-state）：`ch03.md:890-910`、`ch08.md:650-670` 大体正确。
- VXLAN 50 字节开销 = 外层 IP 20 + UDP 8 + VXLAN 8 + 内层以太网 14（不含外层以太网）：`ch11.md:1005-1025`、`ch12.md:290-300` 正确。
- nftables 规则语法（table/chain/priority、`ct state`、`tcp dport { ... }`、`dnat to`、`masquerade`、`vmap`）：`ch08.md:969-1100`、`ch12.md:272-290` 语法正确（未在 Linux 上执行）。

### C3. 代码/脚本

- `pkt_layout.c`：编译运行输出 14/34/54、72 字节、MSS 1460/1440，与书中一致（实测）。
- `mac_classify.c`：`0a:58:0a:f4:00:01` 输出单播/本地管理，正确（实测）。
- `vlan_frame.c`：编译运行输出 64 字节、TPID=0x8100、VLAN=100、PCP=0，正确（实测）。
- `frag_plan.c`、`udp_csum.c`、`ip_checksum.c`、`rto.c`：编译运行输出与书中一致（实测）。
- `udp_vs_tcp.c`：编译运行；UDP 4/4/4、TCP 5/5/2（本机一次运行），语义正确（实测；TCP 分段数不保证每次相同）。
- 所有完整 shell 脚本 `bash -n` 通过；`ch10` 的 `<pid>`、`ch12` 的 `setsockopt(fd, ...)` 等是命令行占位片段，不是可执行脚本，`bash -n` 报错不构成正文错误。
- `tcpinfo.c`/`udp_errq.c`：macOS 分支编译通过；Linux 分支未在 Linux 上运行，不能确认 `optlen=232` 等具体数值。

---

## D. 代码/命令实测记录

### D1. 编译环境

- `clang --version`：Apple clang 21.0.0（macOS 27，arm64）。
- 编译命令统一：`clang -std=c17 -Wall -Wextra -Werror -O2 -o <bin> <src>`；对含 `#define _GNU_SOURCE` 的程序，额外测试了「加 `-D_GNU_SOURCE`」与「不加」两种。
- Linux 专属程序（`epoll`、`linux/errqueue.h`）在 macOS 只做静态检查，不声称运行。

### D2. 结果

| 程序 | 书中位置 | 结果 |
|:--|:--|:--|
| `pkt_layout.c` | `ch01.md:187` | 编译运行；输出与书中逐行一致 |
| `goodput.c` | `ch01.md:614` | 编译运行；**输出与书中不一致**（见 A3） |
| `mac_classify.c` | `ch02.md:97` | 编译运行；输出正确 |
| `vlan_frame.c` | `ch02.md:584` | 编译运行；输出正确 |
| `ip_checksum.c` | `ch03.md:47` | 编译运行；`0x9b1a`/`0x0000` 正确 |
| `frag_plan.c` | `ch03.md:966` | 编译运行；两组输出与书中完全一致 |
| `udp_vs_tcp.c` | `ch04.md:149` | 编译运行；UDP 4/4/4、TCP 5/5/2（本机一次运行），语义正确 |
| `tcpinfo.c` | `ch04.md:904` | macOS 分支编译通过；Linux 分支无法在 macOS 运行；加 `-D_GNU_SOURCE` 时 clang 报 `_GNU_SOURCE` 重定义 |
| `udp_errq.c` | `ch04.md:1038` | 同上 |
| `rto.c` | `ch06.md:68` | 编译运行；输出与书中一致 |
| `udp_csum.c` | `ch06.md:943` | 编译运行；`0xaab5`/`0xffff` 正确 |
| `http_get.c`（4.7.1 最小请求） | `ch07.md:37` | 编译运行；本机 `python3 -m http.server` 返回 `HTTP/1.0 200`，读到 `Content-Length` 后正常结束 |
| `http_get.c`（4.7.16 chunked 客户端） | `ch07.md:616` | 编译运行；本机服务返回无长度字段的 1.0 响应，程序按 EOF 读到 18980 字节，行为正确 |
| `dns_query.c` | `ch07.md:803` | 编译通过；未做外网查询 |
| `udp_loss.c` | `ch08.md:721` | 编译通过（macOS 分支） |
| `sendfile_copy.c` | `ch09.md:701` | 编译通过 |
| `epoll_lt_et.c` | `ch10.md:283` | macOS 无 `sys/epoll.h`，未编译；Linux 专属 |
| `conn_mem.c` | `ch11.md:590` | 编译通过 |
| `reuseport.c` | `ch12.md:641` | 编译通过 |
| `veth_rtt.c` | `ch12.md:907` | macOS 无 `linux/errqueue.h`，未编译；Linux 专属 |

### D3. 结论

- 书中「能编译」的整体承诺基本成立；`goodput.c` 是唯一「能编译但输出完全对不上」的程序。
- `#define _GNU_SOURCE` + 编译命令 `-D_GNU_SOURCE` + `-Werror` 的组合在 clang 下会直接失败；建议在所有此类程序中去掉 `-D_GNU_SOURCE` 或去掉源码里的 `#define`。这是**可复现的构建问题**，不涉及协议事实，但会让读者按书中命令编译失败。
- `tcpinfo.c` 的 `mss=65483` 与 `ch01`/`ch05` 的 `mss 65495` 看起来矛盾，但前者是 `ss` 的 `tcpi_snd_mss`（扣除选项后的有效发送 MSS），后者是 SYN 通告的 MSS；两者可以同时成立。建议正文明确「advertised MSS vs effective MSS」，避免读者误判。

---

## E. 方法与限制

**主要证据链接（Linux 6.8 源码 / RFC）**

- RFC 791（IPv4）：https://www.rfc-editor.org/rfc/rfc791
- RFC 792（ICMP）：https://www.rfc-editor.org/rfc/rfc792
- RFC 793（TCP）：https://www.rfc-editor.org/rfc/rfc793
- RFC 9293（TCP 现行标准）：https://www.rfc-editor.org/rfc/rfc9293
- RFC 3168（ECN）：https://www.rfc-editor.org/rfc/rfc3168
- RFC 6691（MSS）：https://www.rfc-editor.org/rfc/rfc6691
- RFC 7323（窗口缩放/时间戳）：https://www.rfc-editor.org/rfc/rfc7323
- RFC 4443（ICMPv6）：https://www.rfc-editor.org/rfc/rfc4443
- Linux 6.8 `include/net/request_sock.h`：https://elixir.bootlin.com/linux/v6.8/source/include/net/request_sock.h
- Linux 6.8 `net/ipv4/inet_connection_sock.c`：https://elixir.bootlin.com/linux/v6.8/source/net/ipv4/inet_connection_sock.c
- Linux 6.8 `net/ipv4/tcp_input.c`：https://elixir.bootlin.com/linux/v6.8/source/net/ipv4/tcp_input.c
- Linux 6.8 `drivers/net/loopback.c`：https://elixir.bootlin.com/linux/v6.8/source/drivers/net/loopback.c
- Linux 6.8 `include/net/tcp.h`：https://elixir.bootlin.com/linux/v6.8/source/include/net/tcp.h
- Linux 6.8 `net/ipv4/route.c`：https://elixir.bootlin.com/linux/v6.8/source/net/ipv4/route.c


- **只读**：未修改 `src/part4` 任何正文；本报告单独落盘。
- **协议核对**：以 RFC 791/792/793/9293/3168/6691/7323/4443 和 Linux 6.8 源码为准；原书页码用 `写作规范/source-toc/clean-network.md`、`cn8.md`、`clean-kerrisk.md` 的页码。
- **代码实测**：只在 macOS 可移植部分运行；Linux 专属路径（epoll、kTLS、netns、nft、ss）以静态核对 + 书中命令语法检查为主，未在 Linux 内核上实测，报告中对这类条目明确标注「未运行」。
- **版本边界**：A17/A18 是「书稿声称 Linux 6.8，但引用了旧内核结构/函数」的问题；A19/A20 是「内核常量/特性写错」。如果作者本意是讲历史内核，应在正文明确标注版本，否则读者按 6.8 对照源码会找不到字段。
- **未完成**：W 第 4.9 节是否在第 8 版保留、部分 802.11/ICMPv6 细节、nft/ss 在真实 Linux 上的逐条执行，仍需在 Linux 环境复核。A1–A20 的结论不依赖这些未完成项。

---

## 修复记录（2026-10-24）

> 处理范围：A1–A26 全部位于 `src/part4/`；本轮只编辑 `src/part4/*.md` 与本文件，未动 SUMMARY.md、book.toml、theme/、tools/、其他篇章。
> 报告行号基于 2026-10-19 快照，正文此后被并行修改过，逐条用「报告引用原文 grep」重定位后处置。
> 6.8 源码复核：A17/A18 相关路径（`tcp_conn_request`、`reqsk_queue_alloc`、`struct request_sock_queue`、`inet_csk_reqsk_queue_is_full`）本轮按在线 v6.8 源码逐行核过后再改。
> 验证：`python3 tools/check_book.py` 开工基线 `pages: 113, total lines: 127033, substantial: 103`（退出码 0）；全部修改落盘后 `pages: 113, total lines: 127117, substantial: 103`（退出码 0，无新增告警）。part4 行数 14918 → 15002（+0.6%，errata 拆组新增标题行所致，在 ±3% 内）。

### A 表处置（26 条）

**已在核查后的并行修改中修复、本轮逐条复核确认（17 条）**：A1（MSS 仍是 1460、每段 1448）、A2（3000 字节包切三片 1480+1480+20，offset 0/185/370）、A3（goodput.c 输出与程序实测一致）、A4（`4006` 是 TTL 高字节与协议字节连读，`1c46` 才是标识）、A5（0.05%）、A6（VLAN MTU 继承父接口、默认 noqueue）、A7（1522 = 1500+14+4+4；严格 1518 时 1496+18+4=1518）、A8（/22 例改为「三块合计 1152 > 1024，/22 本身不够」）、A9（`conntrack -C` 是全表条目数）、A12（`-S` 下第三个包 `seq 3123456790`）、A13（LAST-ACK 收 ACK 进 CLOSED，图含 CLOSING）、A14（CE 路由器置 / ECE 接收方置 / CWR 发送方置）、A15（第二片 `length 124`、载荷 104、tcpdump `offset 1376` 与片偏移字段 172 分开解释）、A16（回复方向 dst 是 NAT 后公网地址，不能当 SNAT 失效判据）、A19（40 ms 是常用量级、上限 `TCP_DELACK_MAX = HZ/5`）、A24（主机未开转发 → code 1 + `InAddrErrors`；开转发无匹配 → code 0 + `InNoRoutes`）、A26（`REORDER_HDR` 管标签位置不是字节序）。

**本轮修复（正文仍有残留，按报告「正确说法」改正，9 条）**：

- **A10/A11（残留）**：`ch04.md` 例 4.4.2 的「两边取 min 后，`ss -ti` 里的 `mss` 与 `wscale:7,7` 就是最终结果」改为「每个方向各自生效……没有『两边取 min』这一步；`wscale:snd,rcv` 是两个方向各自的移位；只有 SYN 与 SYN-ACK 都带 WS 缩放才启用」（RFC 7323）。4.4.10 主文的 MSS/窗口缩放句已由并行修改改对，本轮复核。
- **A17**：`ch05.md` 4.5.15 残留的旧内核公式段整体重写：`reqsk_queue_alloc()` 签名改为 6.8 的 `void reqsk_queue_alloc(struct request_sock_queue *queue)`（只初始化 accept 链表与 fastopenq，不算长度）；删「min → max(8) → +1 → roundup_pow_of_two」手算表，改为「6.8 没有按 2 的幂取整的固定公式：判满是运行时 `qlen >= sk_max_ack_backlog`，`tcp_max_syn_backlog` 只做来源保护（backlog 最后四分之一 + `tcp_peer_is_proven` 不通过才丢）」；4.5.21 出口检查表的同款 roundup 行一并改。
- **A18**：`ch05.md` 4.5.16 代码块按 6.8 重写——TFO 分支才调 `inet_csk_reqsk_queue_add(sk, req, fastopen_sk)`，正常分支是 `inet_csk_reqsk_queue_hash_add(sk, req, req->timeout)`；`sk_acceptq_is_full` 分支去掉旧内核的 `queue_young(sk) > 1` 条件（6.8 直接 `ListenOverflows` + drop），并补上 `tcp_max_syn_backlog` 最后四分之一的来源保护判断；说明由「同名函数、两个队列」改为「两个队列对应两个函数」。连带：4.5.3 的 listen 路径注释 `inet_csk_reqsk_queue_add / inet_hash_insert` 改为 `sk->sk_prot->hash = inet_hash`；4.5.19 bpftrace 读法由「每连接调两次」改为「每连接一次、SYN 走 hash_add」；errata 第 1/3 条同步改；例 4.5.1 内存账按 backlog=somaxconn=4096 重算（半连接 4096×256 B ≈ 1 MB，全连接 4096×2 KB ≈ 8 MB）。
- **A20（同族残留）**：`ch02.md` `arp_rcv()` 简化代码的条件改为 `dev->flags & (IFF_NOARP | IFF_LOOPBACK)`（与 6.8 `net/ipv4/arp.c` 一致），errata「`lo` 是 `IFF_NOARP`」改为「`lo` 挂的是 `IFF_LOOPBACK`（6.8 并没有设 `IFF_NOARP`）」。ch01/ch11 两处主报错点已由并行修改修好（全 0 MAC `addr_len=6`；`NETIF_F_HW_CSUM`/`RXCSUM`）。
- **A21**：`ch09.md` 例 4.9.1「生成 44 个段/44 个 1514 字节的帧」改为 45 段（65536/1460 ≈ 44.9：44 段满载 1460 + 1 段零头）、45 个帧，CPU 开销「1 次 → 45 次」。为保持自洽，`ch01.md`「到了网卡才切成 44 个帧」、`ch08.md`「比 44 个 1500 字节的 skb 走 44 遍」同步改 45。
- **A22**：`ch03.md` 4.3.14 表 ICMPv6 对应列：type 3 code 1 → `1/3（最接近；ICMPv6 无 host unreachable）`，code 2 → `4/1（Parameter Problem：未知 Next Header）`（RFC 4443）。
- **A23**：`ch11.md` `ping -M do -s 1450` → `-s 1422`（1450 − 20 IP − 8 ICMP），命令注释与 errata 第 3 条同步；4.11.24 的 MTU 实验描述重写为「MTU 1500 时 `-s 1472` 败于外层 1550 > 1500；MTU 1450 时同样 `-s 1472` 本地就 message too long，`-s 1422`（内层 IP 1450）才通」。
- **A25**：`ch04.md` 「六个标志位」改为「图中画了 8 个标志位（CWR/ECE/URG/ACK/PSH/RST/SYN/FIN）……RFC 9293 里还有一个更少见的 NS 位」，与首部图一致。

**未找到 0 条**；A 表 26 条全部处置完毕（17 条并行修改已修 + 9 条本轮修复）。

### B 节漏节（不补写，仅计数）

15 条（B1–B15）确认仍未落点；本轮按约定只做事实修复与文稿优化，未补写任何新节。B 表相关的一个间接改善：张彦飞 6.2.5 的队列算术落点已随 A17/A18 改为 6.8 语义（不再是「落了但错」）。

### 同轮文稿优化（与本报告处置无冲突）

- errata「清单墙」拆组 14 处（ch01×2、ch02×2、ch03、ch05、ch06×2、ch07、ch08、ch09、ch10、ch11、ch12），每处拆成 2–4 个 3–6 条的主题组（共 38 组），条目技术表述逐字保留、盒类型不变、无锚点需要保留。
- 术语章内统一：`头部` → `首部`（ch01 ×2、ch07 ×8、ch08 ×2；含 ch07 errata 1 条与 `http_get.c` 错误提示字符串 1 处），不全书强改。
- 行文微调 2 处：`ch10.md` 4.10.12 节首表格补引导句；`ch08.md` 4.8.21 「实验一把「……」串起来看」补标点断句。
