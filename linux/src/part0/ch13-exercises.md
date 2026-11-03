# 0.13 习题集

三组分层：A 组概念判断（口答即可）、B 组诊断推理（写出步骤）、C 组动手实验（在虚拟机里跑）。**全部附解答**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；
2. 卡住了，回到对应小节的「即时自测」重读，不要直接看答案；
3. 做完再对照解答，重点看自己卡在哪一步；
4. 做错的题记一个记号，三天后只重做记号题。

## A 组 · 概念判断

::: ex A1 · 网络三层

链路、地址、路由各管什么？各给一条 `ip` 命令。

::: sol 解答

链路：接口 up/down、MAC、MTU、载波，`ip -br link`；地址：IPv4/IPv6、掩码/CIDR、scope，`ip -br addr`；路由：默认网关/路由表，`ip route`、`ip route get 1.1.1.1`。三层任一层不通，上层都不通；排障从下往上。

:::
:::

::: ex A2 · 配置管理器

netplan、NetworkManager、systemd-networkd 各是什么？怎样确认谁在管？

::: sol 解答

netplan 是 Ubuntu 的 YAML 前端，生成 backend；NetworkManager 管桌面/动态网络（`nmcli`）；systemd-networkd 管服务器/容器网络（`.network`）。确认：`systemctl status systemd-networkd NetworkManager`、`nmcli device status`、`ls /etc/netplan`、`networkctl status`。别同时改两个管理器。

:::
:::

::: ex A3 · `ss` 四个数字

`ss -lntp` 的四列是什么？`Recv-Q`/`Send-Q` 在 LISTEN 与 ESTABLISHED 下各表示什么？

::: sol 解答

Recv-Q、Send-Q、Local Address:Port、Peer Address:Port（`-p` 加进程）。LISTEN 下 Recv-Q 是全连接队列/backlog 占用，Send-Q 是 backlog 上限；ESTABLISHED 下 Recv-Q 是未读字节，Send-Q 是未确认发送字节。`ss -s` 汇总，`ss -i` 看拥塞/RTT。

:::
:::

::: ex A4 · DNS

DNS 解析按什么顺序？`getent hosts`/`dig`/`resolvectl` 各做什么？`ndots` 是什么？

::: sol 解答

`/etc/nsswitch.conf` 决定顺序；`getent hosts` 走 NSS（和程序一致），`dig` 直接问 DNS，`resolvectl query` 看 systemd-resolved。`ndots` 决定“名字里有几个点就先用绝对查询”，search domain 会追加后缀；`ndots` 太大/搜索域多会让解析变慢。

:::
:::

::: ex A5 · ping/mtr/nc/curl

`ping`、`mtr`、`nc -vz`、`curl -v` 各验证哪一层？为什么 `ping` 通不代表端口通？

::: sol 解答

`ping` 验 ICMP 可达/往返；`mtr` 验路径每跳丢包/延迟；`nc -vz host port` 验 TCP 端口可连；`curl -v` 验 DNS/TCP/TLS/HTTP。`ping` 只证明 ICMP，不证明 TCP 端口、防火墙放行、DNS、TLS；要逐层验。

:::
:::

::: ex A6 · tcpdump

`tcpdump -i any -nn` 各参数做什么？怎样只抓某主机/端口？`-w`/`-r` 是什么？

::: sol 解答

`-i any` 所有接口，`-nn` 不解析主机/端口名；过滤 `host 1.2.3.4`、`port 443`、`tcp`、`net 10.0.0.0/8`；`-w file.pcap` 保存，`-r file.pcap` 回放；`-A`/`-X` 看载荷/十六进制。先小过滤再放大。

:::
:::

::: ex A7 · 防火墙与 NAT

`ufw` 与 `nftables` 是什么关系？nftables 的 table/chain/hook 是什么？NAT 的 snat/dnat/masquerade 各做什么？

::: sol 解答

ufw 是 nftables/iptables 的前端；nftables 是内核包过滤框架。table 是命名空间，chain 挂在 hook（input/output/forward/prerouting/postrouting），rule 按顺序匹配。snat 改源、dnat 改目的、masquerade 是动态源 NAT。`nft list ruleset`、`nft -c` 预演。

:::
:::

::: ex A8 · 故障树

按「链路→地址→路由→端口→应用」各给一条证据命令。为什么按这个顺序？

::: sol 解答

链路 `ip -br link`；地址 `ip -br addr`；路由 `ip route get 1.1.1.1`；端口 `ss -lntp`/`nc -vz`；应用 `curl -v`/日志。下层不通上层一定不通；从下往上能快速排除。DNS 可插在路由后/端口前。

:::
:::

## B 组 · 诊断推理

::: ex B1 · ping 通但 curl 不通

`ping example.com` 通，`curl https://example.com` 超时。按层列出至少四种原因与验证。

::: sol B1 核对

① DNS：`getent hosts example.com`/`dig`；② 端口/防火墙：`nc -vz example.com 443`；③ 路由/出口：`ip route get`、`mtr`；④ TLS/证书/时间：`curl -v`、`date`；⑤ 代理/环境变量：`env | grep -i proxy`；⑥ IPv6 优先但不可用：`curl -4`。`ping` 只证明 ICMP。

:::
:::

::: ex B2 · 端口没监听

`ss -lntp` 看不到 8080，但服务进程在。列出至少三种原因。

::: sol B2 核对

① 服务绑到 `127.0.0.1`/别的地址：`ss -lntp` 看 Local Address；② 服务没真正监听/启动失败：`journalctl -u`；③ 端口被别的进程占：`ss -lntp | grep 8080`；④ netns/容器里监听，宿主看不到：`nsenter`/`docker exec`；⑤ `SO_REUSEPORT`/多实例。应用 `bind` 地址与 `ss` 对照。

:::
:::

::: ex B3 · DNS 慢

`curl` 访问域名很慢，IP 直接访问快。列出至少三种原因与验证。

::: sol B3 核对

① DNS 服务器慢/超时：`dig +stats`、`resolvectl`；② `ndots`/search domain 导致多次查询：`cat /etc/resolv.conf`；③ IPv6 AAAA 查询超时：`dig AAAA`、`curl -4`；④ NSS 顺序（files/dns/mdns）：`getent hosts`；⑤ 缓存未命中/negative cache。用 `dig`/`getent` 分别计时。

:::
:::

::: ex B4 · netns/veth 不通

两个 netns 用 veth 连接，`ping` 不通。按层列出检查顺序。

::: sol B4 核对

① veth 两端是否在正确 netns、up：`ip -n ns1 link`；② 地址/掩码是否同网段：`ip -n ns1 addr`；③ 路由：`ip -n ns1 route`；④ 防火墙/nftables：`ip netns exec ns1 nft list ruleset`；⑤ ARP/邻居：`ip -n ns1 neigh`；⑥ 容器/宿主命名空间是否搞混。先 link/addr/route，再防火墙。

:::
:::

::: ex B5 · NAT 不生效

容器/内网主机访问外网失败，SNAT/masquerade 配了但不生效。列出至少三种原因。

::: sol B5 核对

① `ip_forward` 没开：`sysctl net.ipv4.ip_forward`；② nftables 规则没挂到正确 hook/优先级；③ 出接口/源网段不对；④ 防火墙 forward 链默认 drop；⑤ 路由/回程缺失；⑥ conntrack 满。查 `nft list ruleset`、`conntrack -L`、`tcpdump` 两侧。

:::
:::

::: ex B6 · SSH 转发方向反了

`ssh -L`/`-R`/`-D` 分不清，转发不工作。各给一个场景与方向。

::: sol B6 核对

`-L local_port:host:port`：本地端口转发到远端可达的 host:port（如访问内网数据库）；`-R remote_port:host:port`：远端端口转发到本地可达的 host:port（如把本地服务暴露给远端）；`-D port`：本地 SOCKS 代理。方向记法：`-L` 本地监听、`-R` 远端监听；`ssh -v` 看绑定/失败。

:::
:::

## C 组 · 动手实验

::: ex C1 · 画本机网络

用 `ip -br link`、`ip -br addr`、`ip route`、`ss -lntp` 画本机接口/地址/默认路由/监听端口。

::: sol C1 核对

```bash
ip -br link
ip -br addr
ip route
ss -lntp
```

验收：能说出默认出口接口、IP/掩码、默认网关、监听端口与进程；`ip route get 1.1.1.1` 看选路。容器/虚拟机注意 netns。

:::
:::

::: ex C2 · tcpdump 抓一次请求

用 `tcpdump -i any -nn 'tcp port 443'` 抓 `curl https://example.com`，看 SYN/SYN-ACK/ACK 与 TLS。

::: sol C2 核对

```bash
sudo tcpdump -i any -nn 'tcp port 443' -w /tmp/https.pcap
curl -sS https://example.com >/dev/null
sudo tcpdump -r /tmp/https.pcap -nn | head
```

看三次握手（SYN/SYN-ACK/ACK）、TLS ClientHello/ServerHello、FIN；`-w` 保存、`-r` 回放。抓包过滤先小后大；容器/宿主接口不同。

:::
:::

::: ex C3 · nftables 预演

用 `nft -c` 预演一条允许/拒绝规则，`nft list ruleset` 看现有规则；不要直接改生产。

::: sol C3 核对

```bash
sudo nft list ruleset
sudo nft -c add rule inet filter input tcp dport 8080 accept
```

`-c` 只检查语法/依赖，不生效；`list ruleset` 看 table/chain/hook/顺序。生产改规则先备份/预演/有回滚；注意 ufw 可能也管 nftables。

:::
:::

::: ex C4 · veth/netns

创建两个 netns，用 veth 连接，配地址，`ping` 通；再用 nftables 在其中一个 netns 拒绝，观察。

::: sol C4 核对

```bash
sudo ip netns add ns1
sudo ip netns add ns2
sudo ip link add v1 type veth peer name v2
sudo ip link set v1 netns ns1
sudo ip link set v2 netns ns2
sudo ip -n ns1 addr add 10.0.0.1/24 dev v1
sudo ip -n ns2 addr add 10.0.0.2/24 dev v2
sudo ip -n ns1 link set v1 up
sudo ip -n ns2 link set v2 up
sudo ip netns exec ns1 ping -c1 10.0.0.2
```

再在 ns2 `nft add table inet t; nft add chain inet t input '{ type filter hook input priority 0; }'; nft add rule inet t input icmp type echo-request drop`，`ping` 应失败。实验后删 netns/veth。

:::
:::

::: ex C5 · 网络巡检脚本

写一个只读巡检脚本：接口/地址/路由/监听/DNS/默认网关连通性，输出到文件。

::: sol C5 核对

```bash
#!/usr/bin/env bash
set -euo pipefail
out=${1:-./net-audit.txt}
{
    echo "== link"; ip -br link
    echo "== addr"; ip -br addr
    echo "== route"; ip route
    echo "== listen"; ss -lntp
    echo "== dns"; getent hosts example.com || true
    echo "== ping gw"; gw=$(ip route | awk '/default/ {print $3; exit}'); [[ -n $gw ]] && ping -c1 -W1 "$gw" || true
    echo "== ss summary"; ss -s
} > "$out"
echo "wrote $out"
```

只读；先小范围；生产加时间戳/日志/告警。`ss -lntp` 看监听，`getent` 看 NSS/DNS，`ping` 网关看链路/路由。

:::
:::
