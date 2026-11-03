# 0.13 章末总结

## 五单元一览

| 单元 | 核心问题 | 关键结论 | 典型陷阱 |
|:--|:--|:--|:--|
| **一、三层与配置**（0.13.1–0.13.2） | 链路/地址/路由各管什么？谁在管网络？ | 链路看接口/MTU/载波；地址看 IP/掩码/scope；路由看默认网关/表。netplan/NetworkManager/systemd-networkd 可能同时存在，先确认谁在管。 | 只看 IP 不看 link；改错配置管理器；路由表有但接口 down。 |
| **二、工具**（0.13.3–0.13.7） | `ss`/DNS/ping/mtr/nc/curl/tcpdump/防火墙怎样用？ | `ss` 四列是 Recv-Q/Send-Q/Local/Peer；DNS 先 `getent`/`dig`；`ping` 验 ICMP、`nc` 验端口、`curl` 验 HTTP/TLS；`tcpdump` 小过滤；`ufw`/`nft` 看规则。 | 把 `ping` 通当端口通；只看 `ss -l` 不看绑定地址；抓包过滤太宽/太窄。 |
| **三、故障树**（0.13.8） | 按什么顺序查？ | 链路→地址→路由→端口→应用；每层一条命令/证据，定位到最后一层有证据的地方。 | 一上来重启网络；跳过 DNS；只看应用日志。 |
| **四、深水区**（0.13.9–0.13.14） | 路由/策略/netns、DNS 记录、TCP 状态、nftables、BPF、SSH？ | 主表/策略路由/`ip rule`；netns 隔离；A/AAAA/CNAME/`ndots`；TCP 状态机/backlog；nftables table/chain/hook/NAT；BPF 过滤；SSH `-J/-L/-R/-D`。 | 策略路由优先级错；`ndots` 导致慢解析；NAT 只改一侧；SSH 转发方向搞反。 |
| **五、实验与脚本**（0.13.15–0.13.18） | 怎样证明/巡检？ | 三条巡检脚本；veth/netns 防火墙实验；十四个陷阱。 | 不抓包；不做 netns 实验；不 `nft -c` 预演。 |

## 一条主线

这一章先分清**链路/地址/路由**与配置工具，再用 `ss`/DNS/`ping`/`mtr`/`nc`/`curl`/`tcpdump`/防火墙按**故障树**逐层验证；第二遍看策略路由/netns、DNS 记录/`ndots`、TCP 状态机、nftables/NAT、BPF、SSH。最后用巡检脚本、veth/netns 实验与陷阱清单收口。**排障的纪律是：每一层先拿一条证据，再决定下一层。**

## 看到问题先选工具

| 症状 | 第一动作 | 为什么 |
|:--|:--|:--|
| `ping` 不通 | `ip -br link`、`ip -br addr`、`ip route get 1.1.1.1` | 先看链路/地址/路由，不要先怪应用。 |
| `ping` 通但 `curl` 不通 | `getent hosts`、`nc -vz host 443`、`curl -v` | 分层验 DNS/端口/TLS。 |
| 端口没监听 | `ss -lntp`、看服务 bind 地址 | 可能只绑 `127.0.0.1` 或没启动。 |
| DNS 慢/失败 | `dig +stats`、`resolvectl`、`getent hosts` | 分 NXDOMAIN/SERVFAIL/超时/`ndots`/search。 |
| 丢包/延迟 | `mtr`、`tcpdump -i any -nn` | 看哪一跳/哪段；抓包确认。 |
| 防火墙拦截 | `nft list ruleset`、`ufw status verbose` | 看 hook/表/链/规则顺序。 |
| 容器/网络命名空间不通 | `ip netns`、`ip -n <ns> addr/route`、veth | 先确认 netns 内外的链路/地址/路由。 |
| SSH 连不上/转发不对 | `ssh -v`、`-J`、`-L/-R/-D` 方向 | 跳板/本地/远程转发方向容易搞反。 |
| TCP 连接堆积 | `ss -tan`、`ss -s`、`ss -lnt` 的 Recv-Q | 看状态/backlog/队列。 |
| NAT 不生效 | `nft list ruleset`、`conntrack -L` | 看 snat/dnat/masquerade 与钩子。 |

## 能否讲出这八句话

1. 网络三层：链路（接口/MTU/载波）、地址（IP/掩码/scope）、路由（默认网关/表）；`ip -br link/addr`、`ip route`。
2. 配置可能由 netplan/NetworkManager/systemd-networkd 管，先确认谁在管，再改对应配置。
3. `ss` 的四列是 Recv-Q、Send-Q、Local Address:Port、Peer Address:Port；`-lntp` 看监听，`-tan` 看状态。
4. DNS 先 `getent hosts`/`dig`；NXDOMAIN/SERVFAIL/超时/`ndots`/search 是不同问题。
5. `ping` 验 ICMP、`mtr` 验路径、`nc` 验端口、`curl` 验 HTTP/TLS；一层一层来。
6. `tcpdump` 用 BPF 过滤（host/port/net/tcp），先小范围再放大；`-w` 保存、`-r` 回放。
7. 防火墙看 nftables 的 table/chain/hook/规则顺序；NAT 分 snat/dnat/masquerade，注意钩子。
8. 故障树：链路→地址→路由→端口→应用；每层一条证据，定位到最后一层有证据的地方。

## 学完之后

1. **[闭卷回忆卡](ch13-recall.md)**：先合上正文，把三层、`ss` 四列、DNS、故障树、nftables、SSH 六组结论从空白纸上叫出来。
2. **[习题集](ch13-exercises.md)**：A 组检查概念，B 组诊断“为什么 ping 通 curl 不通/为什么端口没监听/为什么 DNS 慢”，C 组做 veth/netns、tcpdump、nftables 实验。
3. **[学习目标自检表](ch13-checklist.md)**：把卡住的点对到正文小节和习题，回到那一节重读。
4. **[勘误与版本注记](ch13-errata.md)**：把 netplan/NetworkManager、nftables、`ss`/`tcpdump` 的版本差异过一遍。
5. **下一站**：[0.14 性能工具与命令行工程化](ch14.md) 会从网络转到系统性能；本章的分层证据会在那里接到 `perf`/`bpftrace`。
