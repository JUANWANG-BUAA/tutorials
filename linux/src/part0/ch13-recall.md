# 0.13 闭卷回忆卡

这页不是摘要，而是一组**检索练习**。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。

建议在学完当天、隔天、第 3 天、第 7 天各做一次。每次只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 第一遍：先会用

### D1 · 网络三层

链路、地址、路由各管什么？各给一条 `ip` 命令。

::: sol D1 核对

链路：接口 up/down、MAC、MTU、载波，`ip -br link`；地址：IPv4/IPv6、掩码/CIDR、scope，`ip -br addr`；路由：默认网关/路由表，`ip route`、`ip route get 1.1.1.1`。三层任一层不通，上层都不通；排障从下往上。
:::

### D2 · 配置管理器

netplan、NetworkManager、systemd-networkd 各是什么？怎样确认谁在管？

::: sol D2 核对

netplan 是 Ubuntu 的 YAML 配置前端，生成 backend（networkd/NetworkManager）；NetworkManager 管桌面/动态网络（`nmcli`）；systemd-networkd 管服务器/容器网络（`.network`）。确认：`systemctl status systemd-networkd NetworkManager`、`nmcli device status`、`ls /etc/netplan`、`networkctl status`。别同时改两个管理器。
:::

### D3 · `ss` 四个数字

`ss -lntp` 的四列是什么？`Recv-Q`/`Send-Q` 在 LISTEN 与 ESTABLISHED 下各表示什么？

::: sol D3 核对

四列：Recv-Q、Send-Q、Local Address:Port、Peer Address:Port（`-p` 加进程）。LISTEN 下 Recv-Q 是当前全连接队列/backlog 占用，Send-Q 是 backlog 上限；ESTABLISHED 下 Recv-Q 是未读字节，Send-Q 是未确认发送字节。`ss -s` 汇总，`ss -i` 看拥塞/ RTT。
:::

### D4 · DNS

DNS 解析按什么顺序？`getent hosts`/`dig`/`resolvectl` 各做什么？`ndots` 是什么？

::: sol D4 核对

`/etc/nsswitch.conf` 决定顺序（files/dns/systemd-resolved 等）；`getent hosts name` 走 NSS（和程序一致），`dig name` 直接问 DNS，`resolvectl query name` 看 systemd-resolved。`ndots` 决定“名字里有几个点就先用绝对查询”，search domain 会追加后缀；`ndots` 太大/搜索域多会让解析变慢。
:::

### D5 · ping/mtr/nc/curl

`ping`、`mtr`、`nc -vz`、`curl -v` 各验证哪一层？为什么 `ping` 通不代表端口通？

::: sol D5 核对

`ping` 验 ICMP 可达/往返；`mtr` 验路径每跳丢包/延迟；`nc -vz host port` 验 TCP 端口可连；`curl -v` 验 DNS/TCP/TLS/HTTP。`ping` 只证明 ICMP，不证明 TCP 端口、防火墙放行、DNS、TLS；要逐层验。
:::

### D6 · tcpdump

`tcpdump -i any -nn` 各参数做什么？怎样只抓某主机/端口？`-w`/`-r` 是什么？

::: sol D6 核对

`-i any` 所有接口，`-nn` 不解析主机/端口名；过滤 `host 1.2.3.4`、`port 443`、`tcp`、`net 10.0.0.0/8`；`-w file.pcap` 保存，`-r file.pcap` 回放；`-A`/`-X` 看载荷/十六进制。先小过滤再放大，避免抓满磁盘。
:::

### D7 · 防火墙

`ufw` 与 `nftables` 是什么关系？nftables 的 table/chain/hook 是什么？NAT 的 snat/dnat/masquerade 各做什么？

::: sol D7 核对

ufw 是 nftables/iptables 的前端；nftables 是内核包过滤框架。table 是命名空间，chain 挂在 hook（input/output/forward/prerouting/postrouting），rule 按顺序匹配。snat 改源、dnat 改目的、masquerade 是动态源 NAT（出口 IP）。`nft list ruleset` 看规则，`nft -c` 预演。
:::

## B. 第二遍：深水区与证据

### D8 · 故障树

按「链路→地址→路由→端口→应用」各给一条证据命令。为什么按这个顺序？

::: sol D8 核对

链路 `ip -br link`；地址 `ip -br addr`；路由 `ip route get 1.1.1.1`；端口 `ss -lntp`/`nc -vz`；应用 `curl -v`/日志。下层不通，上层一定不通；从下往上能快速排除，不会在应用层瞎猜。DNS 可插在路由后/端口前。
:::

### D9 · 路由、策略路由与 netns

主路由表/策略路由/network namespace 各是什么？`ip rule`/`ip netns` 怎样用？

::: sol D9 核对

主表是默认路由表（`ip route`）；策略路由用 `ip rule` 按源/目的/mark 选不同表（`ip route add ... table 100`）；netns 是独立的网络栈（接口/地址/路由/防火墙），`ip netns add`、`ip -n ns link/addr/route`、veth 连接。容器网络就是 netns + veth + bridge/NAT。
:::

### D10 · DNS 记录与 `ndots`

A/AAAA/CNAME/MX/TXT/NS/SOA 各是什么？`ndots`/search domain 怎样影响解析？

::: sol D10 核对

A IPv4、AAAA IPv6、CNAME 别名、MX 邮件、TXT 文本/验证、NS 权威服务器、SOA 区信息。`ndots` 决定名字里点数 ≥n 时先查绝对名；search domain 会追加后缀尝试。`ndots:5` + 多 search 会让短名字先拼后缀、多次查询，表现为解析慢；K8s 里常见。
:::

### D11 · TCP 状态与 `ss`

LISTEN/SYN-SENT/SYN-RECV/ESTABLISHED/FIN-WAIT/CLOSE-WAIT/LAST-ACK/TIME-WAIT 各是什么？`ss -tan` 怎样看？

::: sol D11 核对

LISTEN 监听；SYN-SENT 主动连接；SYN-RECV 收到 SYN；ESTABLISHED 已建立；FIN-WAIT 主动关闭等待；CLOSE-WAIT 被动关闭等待应用关闭；LAST-ACK 最后确认；TIME-WAIT 等待 2MSL。`ss -tan` 看所有 TCP 状态，`ss -tan state time-wait` 过滤；大量 CLOSE-WAIT 常是应用没关连接。
:::

### D12 · nftables、BPF 与 SSH

nftables 的 hook 有哪些？BPF 过滤表达式怎么写？SSH `-J`/`-L`/`-R`/`-D` 各做什么？

::: sol D12 核对

hook：prerouting/input/forward/output/postrouting。BPF：`tcp port 80`、`host 1.2.3.4`、`net 10.0.0.0/8`、`tcp[tcpflags] & tcp-syn != 0`。SSH：`-J jump` 跳板，`-L local:host:port` 本地转发，`-R remote:host:port` 远程转发，`-D port` 动态 SOCKS。方向搞反是常见错误。
:::
