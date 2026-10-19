# A.2 工具箱：命令、调试器与观测工具

## 1. 怎么用这一页

这不是命令大全，而是**按任务组织的索引**。每个工具只回答三个问题：什么时候用、看哪一列、常见误读是什么。需要完整参数时查 `man`。

安装基线（Ubuntu 24.04）：

```bash
sudo apt -y install build-essential gdb strace ltrace lsof \
  iproute2 iputils-ping tcpdump socat netcat-openbsd curl \
  linux-tools-common linux-tools-$(uname -r) bpftrace bpftool \
  sysstat iotop fio htop tree ncdu jq \
  shellcheck shellcheck-doc
```

## 2. 文件与文本

| 任务 | 命令 | 看什么 / 注意 |
|:--|:--|:--|
| 文件类型 | `file f` | 不要用扩展名判断 |
| 元数据 | `stat f` | 三个时间：`atime/mtime/ctime` |
| 权限/ACL | `getfacl f` | `mask` 会影响有效权限 |
| 找文件 | `find / -xdev -name '*.log'` | `-xdev` 不跨文件系统 |
| 按时间 | `find . -mtime -1 -type f` | `-mtime` 以 24h 为单位 |
| 按大小 | `find . -size +100M` | `+` 是大于，`-` 是小于 |
| 安全处理文件名 | `find . -print0 \| xargs -0` | 空格/换行文件名 |
| 目录大小 | `du -sh -- *` | `--` 防止 `-` 开头文件名 |
| 磁盘占用 | `ncdu /var` | 交互式，比 `du` 快 |
| 打开的文件 | `lsof -p PID` | `(deleted)` 表示空间未释放 |
| 谁占了挂载点 | `fuser -vm /mnt` | 卸载失败时用 |
| 文件内容 | `less +F f` | 类似 `tail -f`，可翻页 |
| 二进制差异 | `cmp -l a b` | 看第一个不同字节 |
| 十六进制 | `xxd -g1 f` / `hexdump -C f` | 协议/文件格式分析 |
| 文本统计 | `wc -l/-c/-w` | 注意最后一行无换行 |

## 3. 进程与 CPU

| 任务 | 命令 | 看什么 |
|:--|:--|:--|
| 快照 | `ps -eo pid,ppid,stat,pcpu,pmem,etime,comm --sort=-pcpu` | `STAT` 的 `D/R/S/Z/T` |
| 线程 | `ps -eLf` / `top -H -p PID` | 线程 ID 与 CPU |
| 实时 | `top` / `htop` | `%sy`（内核）、`%wa`（I/O）、`%si`（软中断） |
| 每核 | `mpstat -P ALL 1` | 是否单核打满 |
| 历史 | `sar -u 1 5` | 需要 `sysstat` 采集 |
| 调度延迟 | `perf sched latency` | 谁被延迟、延迟多久 |
| 上下文切换 | `pidstat -w -p PID 1` | `cswch/s`（自愿）vs `nvcswch/s`（非自愿） |
| 优先级 | `chrt -p PID` / `nice -n` | 实时任务会饿死普通任务 |
| 进程树 | `pstree -ap` | 谁 fork 了谁 |
| 打开文件 | `ls -l /proc/PID/fd` | fd 泄漏 |
| 内存映射 | `cat /proc/PID/maps` | 共享库、堆、栈、匿名映射 |
| 环境 | `tr '\0' '\n' < /proc/PID/environ` | 排查注入/配置 |
| 栈 | `cat /proc/PID/stack`（root） | 内核栈，D 状态排查 |

`top` 里最容易被误读的列：

- `%wa` 高不一定是磁盘慢，也可能是 NFS/网络文件系统等待；
- `%si` 高看软中断（网络收包），不是用户态；
- `RES` 包含共享库的物理页，`SHR` 才是共享部分；
- `VIRT` 很大不代表内存泄漏（虚拟地址不等于物理页）。

## 4. 内存

| 任务 | 命令 | 看什么 |
|:--|:--|:--|
| 总览 | `free -h` | `available` 才是可用，不是 `free` |
| 明细 | `cat /proc/meminfo` | `Cached`、`Buffers`、`SReclaimable`、`Dirty` |
| 进程 | `smem -tk` / `ps_mem` | PSS 比 RSS 更接近真实占用 |
| 泄漏 | `valgrind --leak-check=full` | still reachable vs definitely lost |
| 堆 | `gdb` + `malloc_stats()` |  arena 数量、peak |
| 缺页 | `perf stat -e page-faults` | minor/major |
| 交换 | `vmstat 1` 的 `si/so` | 持续非零说明内存压力 |
| OOM | `dmesg -T \| grep -i oom` | 被杀进程与 `oom_score` |
| slab | `slabtop` / `/proc/slabinfo` | 内核对象泄漏 |
| NUMA | `numastat -p PID` | 跨节点访问 |

## 5. 磁盘与文件系统

| 任务 | 命令 | 看什么 |
|:--|:--|:--|
| 空间 | `df -hT` / `df -i` | inode 用尽也会 `No space left` |
| I/O | `iostat -xz 1` | `%util`、`await`、`aqu-sz`、`r_await/w_await` |
| 进程 I/O | `iotop -oPa` | 谁在读写 |
| 延迟 | `biolatency`（bcc） | I/O 延迟分布 |
| 文件系统 | `findmnt -T /path` | 挂载选项、源设备 |
| 只读重挂 | `mount -o remount,rw /` | 救援模式常用 |
| 坏块 | `badblocks -sv /dev/sdX` | 会破坏数据，先确认 |
| SMART | `smartctl -a /dev/sdX` | 重映射扇区、温度 |
| 压测 | `fio --name=t --rw=randread --bs=4k --iodepth=32` | IOPS/延迟 |
| 页缓存 | `vmtouch -v file` | 文件有多少在缓存 |

`iostat` 的三个常见误读：

- `%util` 接近 100% 只说明设备忙，不说明饱和（NVMe 多队列下可能仍有余量）；
- `await` 包含排队时间，不纯是设备延迟；
- `svctm` 已废弃，不要再看。

## 6. 网络

| 任务 | 命令 | 看什么 |
|:--|:--|:--|
| 接口 | `ip -br addr` | `UP/LOWER_UP` |
| 路由 | `ip route get 8.8.8.8` | 实际选中的路由与源地址 |
| 邻居 | `ip neigh` | `REACHABLE/STALE/FAILED` |
| 监听 | `ss -lntp` | `Recv-Q` 是 accept 队列 |
| 连接 | `ss -tnp state established` | 四元组、`Send-Q/Recv-Q` |
| 统计 | `ss -s` | 总连接、TIME_WAIT |
| 套接字明细 | `ss -tin` | `rtt`、`cwnd`、`retrans`、`rcv_space` |
| 抓包 | `tcpdump -i any -nn -s0 -w cap.pcap` | 先抓全，再过滤 |
| 过滤 | `tcpdump -r cap.pcap 'tcp port 443'` | BPF 语法 |
| DNS | `dig +short example.com` / `resolvectl query` | TTL、CNAME |
| HTTP | `curl -v --trace-time` | 连接/首字节/总时间 |
| 带宽 | `iperf3 -c host -P 4` | 多流才能打满 |
| 延迟 | `mtr -rwc 100 host` | 每跳丢包 |
| 端口 | `nc -vz host 443` | 只测 TCP 握手 |

`ss -tin` 的关键字段：

- `retrans`：重传次数；持续增长说明丢包/超时；
- `cwnd`：拥塞窗口；小且不涨说明受限；
- `rtt`：平滑 RTT；与 `rttvar` 一起看；
- `rcv_space`：接收窗口；为 0 说明应用读得慢。

## 7. 内核与追踪

| 任务 | 命令 | 说明 |
|:--|:--|:--|
| 内核日志 | `dmesg -T -w` | `-T` 人类时间 |
| 动态调试 | `echo 'file mm/* +p' > /sys/kernel/debug/dynamic_debug/control` | 需 debugfs |
| ftrace | `trace-cmd record -p function_graph -g vfs_read` | 函数调用图 |
| kprobe | `bpftrace -e 'kprobe:vfs_read { @[comm] = count(); }'` | 内核函数 |
| uprobe | `bpftrace -e 'uprobe:/bin/bash:readline { printf("%s\n", str(arg0)); }'` | 用户函数 |
| tracepoint | `perf list tracepoint` | 稳定事件 |
| 系统调用 | `strace -f -tt -T -e trace=%file` | `-T` 每调用耗时 |
| 库调用 | `ltrace -f -S` | 只对动态库有效 |
| 采样 | `perf record -F 999 -g -- PID` | `perf report` |
| 火焰图 | `perf script \| flamegraph.pl > out.svg` | 需要 FlameGraph |
| 锁 | `perf lock` / `lockdep` | 争用与死锁 |
| 中断 | `cat /proc/interrupts` | 每 CPU 计数 |
| 软中断 | `cat /proc/softirqs` | `NET_RX` 等 |
| 网络丢包 | `cat /proc/net/softnet_stat` | 第二列是 drop |

## 8. 容器与命名空间

| 任务 | 命令 | 说明 |
|:--|:--|:--|
| 进程命名空间 | `ls -l /proc/PID/ns` | 看 inode 是否相同 |
| 进入 | `nsenter -t PID -m -u -i -n -p` | 调试容器 |
| 资源 | `systemd-cgtop` / `cat /sys/fs/cgroup/.../cpu.stat` | cgroup v2 |
| 容器 | `docker stats --no-stream` | CPU/内存/网络 |
| 镜像层 | `docker history IMG` | 每层大小 |
| 运行时 | `ctr -n k8s.io containers ls` | containerd |
| 抓容器包 | `nsenter -t PID -n tcpdump ...` | 在 netns 里抓 |

## 9. 构建与二进制

| 任务 | 命令 | 说明 |
|:--|:--|:--|
| 依赖 | `ldd ./app` | 不要对不可信二进制用 `ldd`（会执行） |
| 符号 | `nm -C ./app` | `U` 未定义，`T` 文本段 |
| 段 | `readelf -S ./app` | `.text/.data/.bss/.rodata` |
| 反汇编 | `objdump -d -M intel ./app` | 对照源码 |
| 调试信息 | `readelf --debug-dump=info` | 是否带 `-g` |
| 动态段 | `readelf -d ./app` | `RPATH/RUNPATH/NEEDED` |
| 预加载 | `LD_PRELOAD=./hook.so ./app` | 打桩/注入 |
| 系统调用号 | `ausyscall --dump` | 需要 audit |
| 编译警告 | `-Wall -Wextra -Wpedantic -Wconversion` | 交付前打开 |

## 10. 安全

| 任务 | 命令 | 说明 |
|:--|:--|:--|
| 能力 | `getcap -r / 2>/dev/null` | setcap 的程序 |
| seccomp | `grep Seccomp /proc/PID/status` | 0/1/2 |
| 提权面 | `find / -perm -4000 -type f` | setuid 清单 |
| 审计 | `auditctl -w /etc/passwd -p wa` | 需 auditd |
| 完整性 | `sha256sum -c SHA256SUMS` | 下载校验 |
| 端口暴露 | `ss -lntu` | 只听 127.0.0.1 更安全 |

## 11. 组合用法

### 11.1 找出「谁在写这个目录」

```bash
sudo bpftrace -e '
tracepoint:syscalls:sys_enter_openat /str(args->filename) == "/var/log/app.log"/
{ printf("%s pid=%d\n", comm, pid); }'
```

### 11.2 找出「哪个进程让磁盘忙」

```bash
sudo iotop -oPa -d 1
# 或
sudo bpftrace -e 'kprobe:submit_bio { @[comm] = count(); }'
```

### 11.3 找出「哪个连接在重传」

```bash
ss -tin state established '( dport = :443 )' | grep -B1 retrans
```

### 11.4 找出「谁把 CPU 吃满」

```bash
top -H -b -n1 | head -20
perf top -g -p $(pgrep -n app)
```

## 12. 工具选择的三个原则

1. **先用低开销的**：`ss`/`/proc`/`iostat` 先看，再上 `perf`/`bpftrace`；
2. **一次只改一个变量**：同时调三个参数，出了效果也不知道谁起作用；
3. **留下证据**：命令、输出、时间、版本；不要只截图，存文本。

> **下一站**：[A.3 排错手册](debugging.md)把工具串成「症状 → 假设 → 证据」的流程。
