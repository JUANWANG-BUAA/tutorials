# 0.13 学习目标自检表

逐条对照。左列是目标，中列是「怎样算达标」，右列是正文依据与对应习题。卡住时回到依据列重读，不要从头再读整章。

**使用建议**：先做[章末习题](ch13-exercises.md)的 A 组，用错题定位下面几行；再回到对应小节做「即时自测」。不要机械地逐行打钩。

| 目标 | 达标检验 | 依据与习题 |
|:--|:--|:--|
| **K13.1 网络三层** | 能用 `ip -br link/addr`、`ip route` 区分链路/地址/路由 | [0.13.1](ch13.md#sec-0.13.1)；A1、C1、D1 |
| **K13.2 配置管理器** | 能确认 netplan/NetworkManager/systemd-networkd 谁在管 | [0.13.2](ch13.md#sec-0.13.2)；A2、D2 |
| **K13.3 `ss`** | 能读 Recv-Q/Send-Q/Local/Peer 与 TCP 状态 | [0.13.3](ch13.md#sec-0.13.3)、[0.13.11](ch13.md#sec-0.13.11)；A3、B2、D3、D11 |
| **K13.4 DNS** | 会用 `getent`/`dig`/`resolvectl`，知道 `ndots`/search | [0.13.4](ch13.md#sec-0.13.4)、[0.13.10](ch13.md#sec-0.13.10)；A4、B3、D4、D10 |
| **K13.5 连通性工具** | 能分层用 `ping`/`mtr`/`nc`/`curl` | [0.13.5](ch13.md#sec-0.13.5)；A5、B1、D5 |
| **K13.6 tcpdump** | 会用 `-i/-nn`/host/port/`-w`/`-r` 抓包 | [0.13.6](ch13.md#sec-0.13.6)、[0.13.13](ch13.md#sec-0.13.13)；A6、C2、D6 |
| **K13.7 防火墙** | 能看 ufw/nftables 规则、table/chain/hook/NAT | [0.13.7](ch13.md#sec-0.13.7)、[0.13.12](ch13.md#sec-0.13.12)；A7、C3、D7 |
| **K13.8 故障树** | 能按链路→地址→路由→端口→应用排查 | [0.13.8](ch13.md#sec-0.13.8)；A8、B1、D8 |
| **K13.9 路由/netns** | 能看主表/策略路由/`ip rule`/`ip netns` | [0.13.9](ch13.md#sec-0.13.9)；B4、C4、D9 |
| **K13.10 DNS 记录/`ndots`** | 能说 A/AAAA/CNAME/MX/TXT/NS/SOA 与 `ndots` | [0.13.10](ch13.md#sec-0.13.10)；A4、B3、D10 |
| **K13.11 TCP 状态机** | 能说 LISTEN/SYN/ESTABLISHED/FIN/CLOSE_WAIT/TIME_WAIT | [0.13.11](ch13.md#sec-0.13.11)；A3、D11 |
| **K13.12 nftables/NAT** | 能说 table/chain/hook、snat/dnat/masquerade | [0.13.12](ch13.md#sec-0.13.12)；A7、B5、C3、D7 |
| **K13.13 BPF 过滤** | 能写 host/port/net/tcp 过滤 | [0.13.13](ch13.md#sec-0.13.13)；A6、C2、D12 |
| **K13.14 SSH** | 能用 `-J/-L/-R/-D` 与密钥/配置 | [0.13.14](ch13.md#sec-0.13.14)；B6、D12 |
| **K13.15 巡检脚本** | 能写只读巡检：link/addr/route/ss/DNS/网关 | [0.13.15](ch13.md#sec-0.13.15)；C5 |
| **K13.16 veth/netns 实验** | 能建 netns+veth、配地址、nftables 拦截 | [0.13.16](ch13.md#sec-0.13.16)；C4 |
| **K13.17 十四个陷阱** | 能说出至少六条“现象 → 原因 → 修复” | [0.13.17](ch13.md#sec-0.13.17)；B1–B6、D12 |
| **S13.1 画网络** | 能说出出口接口/地址/网关/监听端口 | [0.13.1](ch13.md#sec-0.13.1)、[0.13.3](ch13.md#sec-0.13.3)；C1 |
| **S13.2 抓包** | 能抓一次 HTTPS 并读握手/TLS | [0.13.6](ch13.md#sec-0.13.6)、[0.13.13](ch13.md#sec-0.13.13)；C2 |
| **S13.3 nftables 预演** | 能用 `nft -c`/`list ruleset` | [0.13.12](ch13.md#sec-0.13.12)；C3 |
| **S13.4 netns/veth** | 能建、通、拦、清理 | [0.13.16](ch13.md#sec-0.13.16)；C4 |
| **S13.5 网络巡检** | 能输出 link/addr/route/ss/DNS/网关连通 | [0.13.15](ch13.md#sec-0.13.15)；C5 |
| **A13.1 版本/管理器** | 能说 netplan/NM/networkd、nftables 版本差异 | [0.13.2](ch13.md#sec-0.13.2)、[0.13.17](ch13.md#sec-0.13.17)；A2、B1–B6 |
| **A13.2 先证据后重启** | 每层先拿一条证据，再决定改配置/重启 | 全章实验；C1–C5 |

## 没达标怎么办

- **K 类卡住**：回到对应小节的「小结」和「即时自测」，先把三层/`ss`/DNS/故障树讲一遍。
- **S 类卡住**：在虚拟机里重跑对应实验，把 `ip`/`ss`/`tcpdump`/`nft` 的真实输出贴进笔记。
- **A 类卡住**：做 B 组诊断题，强迫自己写出「现象 → 层 → 证据 → 修复」的链条。

全部达标后，进入 [0.14 性能工具与命令行工程化](ch14.md)。
