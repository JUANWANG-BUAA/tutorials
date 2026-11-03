# 0.13 勘误与版本注记

这一页收本章最容易「记成永久真理」的版本敏感事实与网络陷阱。正文里的 `errata` 盒讲理解陷阱；这一页讲**换发行版、换网络管理器、换 nftables 版本后要复核什么**。

**本章基线**：Ubuntu 24.04、systemd 255、netplan 1.0、NetworkManager 1.46、nftables 1.0、iproute2 6.1、tcpdump 4.99。换环境时逐条复核。

## 1. 链路、地址与配置

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 1 | `ping` 通就说明网络通 | 只证明 ICMP；TCP 端口/DNS/TLS 可能不通 | `nc -vz`、`curl -v`、`dig` |
| 2 | 有 IP 就能通 | 链路 down/路由缺失/防火墙仍能挡 | `ip -br link`、`ip route get` |
| 3 | 改 `/etc/network/interfaces` 就行 | Ubuntu 24.04 用 netplan；NetworkManager/networkd 可能接管 | `ls /etc/netplan`、`nmcli`、`networkctl` |
| 4 | 两个网络管理器可以同时改 | 会互相覆盖；先确认谁在管 | `systemctl status`、`nmcli device` |
| 5 | `ip addr` 有地址就是 up | 还要看 `UP`/`LOWER_UP`、MTU、载波 | `ip -br link` |
| 6 | IPv4 通 IPv6 一定通 | 双栈可能一边不通；`curl -4/-6` 对比 | `dig AAAA`、`curl -6` |

## 2. `ss`、DNS 与连通性

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 7 | `ss -l` 有端口就能连 | 可能只绑 `127.0.0.1`/IPv6；防火墙也可能挡 | `ss -lntp` 看 Local Address |
| 8 | `Recv-Q` 只是收包数 | LISTEN 下是全连接队列/backlog 占用；ESTABLISHED 下是未读字节 | `ss -lnt`、`ss -tan` |
| 9 | `dig` 通就代表程序能解析 | 程序走 NSS（`getent`），可能受 `nsswitch.conf`/`resolvectl` 影响 | `getent hosts`、`resolvectl query` |
| 10 | DNS 慢就是服务器慢 | `ndots`/search domain 会多次查询；IPv6 AAAA 超时也慢 | `cat /etc/resolv.conf`、`dig +stats` |
| 11 | `ping` 丢包就是网络丢包 | 可能 ICMP 被限速/防火墙区别对待 | `mtr`、`tcpdump`、`nc` |
| 12 | `curl` 超时就是网络问题 | 可能代理环境变量/TLS/证书/时间 | `env | grep -i proxy`、`curl -v` |

## 3. 防火墙、NAT、netns 与 SSH

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 13 | `ufw` 与 `nftables` 是两套独立防火墙 | ufw 是 nftables/iptables 前端；规则可能在同一套里 | `ufw status`、`nft list ruleset` |
| 14 | nftables 规则写了就生效 | 要看 table/chain/hook/优先级/方向 | `nft -c`、`nft list ruleset` |
| 15 | NAT 配了就能通 | 还要 `ip_forward`、forward 链放行、回程路由 | `sysctl net.ipv4.ip_forward`、`conntrack -L` |
| 16 | netns 里外一样 | netns 有独立接口/地址/路由/防火墙 | `ip -n ns addr/route`、`ip netns exec` |
| 17 | SSH `-L`/`-R` 差不多 | `-L` 本地监听、`-R` 远端监听，方向相反 | `ssh -v`、`ss -lntp` |
| 18 | TIME_WAIT 是 bug | 正常状态；大量 CLOSE_WAIT 才可能是应用没关连接 | `ss -tan state`、`ss -s` |
| 19 | 容器端口映射一定生效 | 还要看宿主防火墙/iptables/nftables、bind 地址 | `ss -lntp`、`nft list ruleset` |
| 20 | 网络配置改完立刻生效 | netplan `try`/`apply`、NM `reapply`、networkd `reload` 不同 | 对应管理器命令 |

## 4. 本章未实测项

以下结论来自文档与常见行为，但未在本书写作环境逐条复跑；在别的发行版/云网络环境上使用前先验证：

- netplan/NetworkManager/systemd-networkd 的优先级与 backend 依发行版；`networkctl`/`nmcli` 为准。
- nftables 的 hook 优先级/`inet` 家族/NAT 行为依内核与版本；`nft -c`/`list ruleset` 为准。
- `ss` 的 `Recv-Q`/`Send-Q` 语义在 LISTEN/ESTABLISHED 不同；内核版本可能有细节差异。
- 云厂商的 VPC/安全组/NAT 与本地 nftables 叠加；排障要同时看云控制台。
- 容器网络的 iptables/nftables 规则由 runtime 管理；不要手工删 runtime 规则。

## 5. 发现新问题怎么记

如果你在别的发行版/云环境上发现本章结论不成立，按「现象 → 命令/输出 → 版本/环境 → 建议改法」记到 issue 或笔记里；不要只写「我这里不对」。这张表下一轮会按同一格式增补。
