# A.3 排错手册：症状 → 假设 → 证据

## 1. 排错不是猜，是收敛

一条纪律贯穿全章：

```text
现象（可观察） → 假设（可证伪） → 证据（命令输出） → 结论（改什么）
```

每次只验证一个假设；每个假设先写「如果成立，应该看到什么」。没有证据的结论叫猜测，不叫排错。

### 1.1 证据日志模板

```markdown
## 2026-10-18 14:02 服务 5xx 升高
- 环境：Ubuntu 24.04 / kernel 6.8.0 / 8 vCPU
- 现象：5xx 从 0.1% 升到 12%，P99 从 20ms 到 2s
- 最近变更：14:00 发布 v1.4.2（改了连接池大小）
- 假设 1：连接池耗尽 → 证据：`ss -s` 显示 TIME_WAIT 3.2 万
- 假设 2：下游超时 → 证据：`curl -w` 下游 P99 正常
- 结论：回滚连接池参数；后续加 pool wait 指标
```

## 2. CPU 高

### 2.1 先分清用户态、内核态、软中断、偷取

```bash
top -b -n1 | head -15
mpstat -P ALL 1 3
```

| 现象 | 可能原因 | 下一步 |
|:--|:--|:--|
| `%us` 高 | 应用计算/死循环/正则回溯 | `perf top -p PID` |
| `%sy` 高 | 系统调用多/锁竞争/内存拷贝 | `strace -c`、`perf top` 看内核符号 |
| `%si` 高 | 网络软中断/NAPI | `/proc/softirqs`、`softnet_stat`、RPS |
| `%wa` 高 | I/O 等待 | `iostat -xz`、`biolatency` |
| `%st` 高 | 虚拟机被宿主抢占 | 换宿主机/查超卖 |

### 2.2 用户态热点

```bash
perf record -F 999 -g -p $PID -- sleep 10
perf report --stdio --sort comm,dso,symbol | head -40
```

读法：

- `Children` 高、`Self` 低：热点在子调用，继续展开；
- `Self` 高：函数本身在烧 CPU；
- 大量 `memcpy`/`malloc`/`free`：看是否拷贝过多、分配过碎；
- 大量 `__lll_lock_wait`：锁竞争，转 `perf lock` 或 `offcputime`。

### 2.3 内核态热点

```bash
sudo perf top -g --sort dso,symbol
sudo bpftrace -e 'profile:hz:99 /pid == '"$PID"'/ { @[kstack] = count(); }'
```

常见：

- `tcp_sendmsg`/`copy_user_enhanced_fast_string`：发送拷贝；
- `__alloc_pages`/`shrink_slab`：内存压力；
- `_raw_spin_lock`：自旋锁竞争；
- `do_sys_openat2`：路径解析/文件打开过多。

## 3. Load 高但 CPU 空闲

`load average` 统计的是「可运行 + 不可中断睡眠」的任务。CPU 空闲但 load 高，通常是 **D 状态**（I/O 等待）。

```bash
ps -eo state,pid,comm,wchan:32 | awk '$1=="D"'
cat /proc/PID/stack        # root
iostat -xz 1
cat /proc/pressure/io      # PSI
```

| 证据 | 结论 |
|:--|:--|
| 大量 D 状态 + `%wa` 高 | 磁盘/NFS/块层卡住 |
| D 状态 + `wchan=...nfs...` | NFS 服务器不可达 |
| D 状态 + `wchan=...rwsem...` | 文件系统/驱动锁 |
| PSI `io some` 高 | I/O 压力真实存在 |

## 4. 内存增长与 OOM

### 4.1 分清「缓存」与「泄漏」

```bash
free -h
cat /proc/meminfo | egrep 'MemAvailable|Cached|Dirty|SReclaimable|SwapCached'
```

- `Cached` 大不是泄漏，可回收；
- `MemAvailable` 才是应用可用；
- `Dirty` 持续高：回写跟不上，查 `iostat` 与 `vm.dirty_*`。

### 4.2 进程级

```bash
ps -eo pid,rss,vsz,comm --sort=-rss | head
cat /proc/PID/status | egrep 'VmRSS|VmSwap|Threads'
pmap -x PID | tail -1
smem -tk -P PID
```

- `RSS` 包含共享库；`PSS` 按共享比例分摊，更接近真实；
- `VmSwap` 高：被换出，延迟会抖；
- 线程数持续涨：线程泄漏。

### 4.3 堆与泄漏

```bash
valgrind --leak-check=full --show-leak-kinds=all ./app
# 或
LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libasan.so.8 ./app
```

- `definitely lost`：确定泄漏；
- `still reachable`：全局缓存/未释放的单例，通常不是 bug；
- `invalid read/write`：越界，优先修。

### 4.4 OOM

```bash
dmesg -T | grep -i -E 'oom|killed process'
cat /proc/PID/oom_score
```

OOM killer 按 `oom_score` 选受害者；容器里看 cgroup 的 `memory.events`：

```bash
cat /sys/fs/cgroup/<path>/memory.events
# oom 12
# oom_kill 3
```

## 5. 磁盘满与 inode 满

```bash
df -hT
df -i
du -xhd1 / | sort -h | tail
```

| 现象 | 原因 | 处理 |
|:--|:--|:--|
| `df` 满但 `du` 小 | 删除的文件仍被进程持有 | `lsof +L1`，重启/截断持有者 |
| `df -i` 满 | 小文件太多 | 清理缓存/邮件/会话文件 |
| `/` 满但 `/var` 不大 | 日志/容器层/`/tmp` | `du -xhd1 /var /tmp` |
| 保留块 | ext4 默认 5% 给 root | `tune2fs -m 1`（慎用） |

## 6. I/O 慢

```bash
iostat -xz 1 5
iotop -oPa
sudo biolatency-bpfcc 10 1
cat /proc/pressure/io
```

读 `iostat`：

- `r/s`、`w/s`：IOPS；
- `rkB/s`、`wkB/s`：吞吐；
- `r_await`、`w_await`：平均等待（含排队）；
- `aqu-sz`：平均队列长度；
- `%util`：设备忙的比例（NVMe 上参考价值有限）。

常见结论：

- `await` 高、`aqu-sz` 高、`%util` 高 → 设备饱和；
- `await` 高、`%util` 低 → 单请求慢（可能是网络存储/驱动）；
- 写多、`Dirty` 高 → 回写瓶颈，调 `vm.dirty_ratio` 或加带宽。

## 7. 网络：拒绝、超时、重置

### 7.1 连接被拒绝（ECONNREFUSED）

```bash
ss -lntp | grep :8080
ip route get 10.0.0.5
nft list ruleset | grep -i 8080
```

顺序：本机有没有监听 → 地址/端口对不对 → 防火墙有没有 drop → 中间有没有 NAT。

### 7.2 连接超时

```bash
ping -c3 host
mtr -rwc 20 host
tcpdump -ni any host and port 8080
```

- SYN 发出去没回：网络/防火墙/NAT；
- SYN 有回、ACK 没回：本机路由/策略路由；
- 握手成功但无响应：应用没 accept/处理慢。

### 7.3 连接被重置（ECONNRESET）

- 对端进程崩溃/重启；
- 对端 `close()` 时接收缓冲区还有未读数据（发送 RST）；
- 中间设备（LB/防火墙）超时切断；
- `tcp_abort_on_overflow=1` 时 accept 队列溢出。

```bash
ss -tin state established '( sport = :8080 )'
dmesg -T | grep -i 'reset\|drop'
```

### 7.4 TIME_WAIT / CLOSE_WAIT

```bash
ss -s
ss -tan state time-wait | wc -l
ss -tan state close-wait | head
```

- `TIME_WAIT` 多：主动关闭方，正常；端口耗尽才需要 `tcp_tw_reuse`（谨慎）；
- `CLOSE_WAIT` 多：**应用没 close**，是代码 bug，不要调内核参数掩盖。

### 7.5 DNS

```bash
dig +trace example.com
resolvectl query example.com
cat /etc/resolv.conf
```

- `SERVFAIL`：上游/权威问题；
- `NXDOMAIN`：名字不存在；
- 解析慢：`dig` 看 query time，查 `resolv.conf` 的 `options timeout`。

## 8. 进程卡住/死锁

```bash
cat /proc/PID/status | grep State
cat /proc/PID/wchan
cat /proc/PID/stack        # root
gdb -p PID -batch -ex 'thread apply all bt'
```

- `S` + `futex_wait`：等锁/条件变量；
- `D` + 文件系统函数：I/O 卡住；
- 多线程互相等：`gdb` 全线程栈，找锁顺序环；
- `T`：被 `SIGSTOP`/调试器暂停。

用户态死锁可用：

```bash
valgrind --tool=helgrind ./app
# 或编译时 -fsanitize=thread
```

## 9. 崩溃与 core dump

```bash
ulimit -c unlimited
cat /proc/sys/kernel/core_pattern
coredumpctl list
coredumpctl gdb PID
```

`gdb` 里：

```text
(gdb) bt full
(gdb) info registers
(gdb) frame N
(gdb) p *ptr
(gdb) x/16gx addr
```

常见信号：

| 信号 | 含义 | 常见原因 |
|:--|:--|:--|
| `SIGSEGV` | 非法内存访问 | 空指针、越界、UAF、栈溢出 |
| `SIGABRT` | `abort()` | 断言失败、`free` 检测到堆损坏 |
| `SIGBUS` | 总线错误 | `mmap` 文件被截断、对齐错误 |
| `SIGFPE` | 算术异常 | 除零、整数溢出陷阱 |
| `SIGILL` | 非法指令 | 二进制/CPU 不匹配、栈被踩 |

## 10. 启动失败

| 阶段 | 现象 | 证据 | 处理 |
|:--|:--|:--|:--|
| 固件 | 黑屏/无引导项 | `efibootmgr` | 重建 ESP/引导项 |
| 引导器 | `grub rescue>` | `ls (hd0,gpt2)/` | 重装 grub |
| 内核 | 卡在 `Waiting for root device` | `dmesg` 最后几行 | initramfs 缺驱动/根参数错 |
| initramfs | `(initramfs)` shell | `blkid` | 修 `root=`/`fstab` |
| systemd | `emergency.target` | `journalctl -xb` | 修失败 unit |
| 登录 | 循环回登录 | `journalctl -u gdm` | 家目录/权限/磁盘满 |

救援步骤：

1. GRUB 里加 `systemd.unit=rescue.target` 或 `init=/bin/bash`；
2. `mount -o remount,rw /`；
3. 修 `/etc/fstab`、unit、权限；
4. `reboot -f`。

## 11. 容器问题

| 现象 | 证据 | 处理 |
|:--|:--|:--|
| 容器起不来 | `docker logs`、`docker inspect` | 看 `State.Error`、`OOMKilled` |
| 容器内看不到进程 | `ls /proc`、`ps` | PID namespace + `--pid=host` 对照 |
| 端口不通 | `docker port`、`ss -lntp` | 端口映射/防火墙 |
| 磁盘涨 | `docker system df` | 镜像/卷/日志 |
| 权限拒绝 | `capsh --print`、`getcap` | capability/seccomp/`--privileged` |
| 网络慢 | `nsenter -t PID -n ss -tin` | 容器 netns 内看重传 |

## 12. 性能回退：二分

```bash
git bisect start
git bisect bad HEAD
git bisect good v1.3.0
# 每次构建并跑基准
git bisect run ./bench/check.sh
```

基准脚本要稳定：

- 固定 CPU 绑核、预热、重复 3 次取中位数；
- 输出机器可读（`RPS=... P99=...`）；
- 阈值判定（例如 RPS 低于基线 5% 算 bad）。

## 13. 一页速查

| 症状 | 第一条命令 | 最常被忽略的证据 |
|:--|:--|:--|
| CPU 高 | `top` + `perf top` | `%si`/`%st` |
| load 高 | `ps -eo state,wchan` | D 状态 |
| 内存涨 | `free` + `smem` | `MemAvailable`、PSS |
| 磁盘满 | `df -h; df -i` | `lsof +L1` |
| I/O 慢 | `iostat -xz` | `aqu-sz`、`await` |
| 连不上 | `ss -lntp` + `tcpdump` | SYN 去哪了 |
| 连接重置 | `ss -tin` + `dmesg` | accept 队列溢出 |
| 进程卡住 | `gdb thread apply all bt` | `wchan` |
| 崩溃 | `coredumpctl gdb` | 寄存器与栈 |
| 启动失败 | `journalctl -xb` | 卡在哪个 target |
| 容器异常 | `docker inspect` | `OOMKilled`/`State.Error` |

> **下一站**：[A.4 母本覆盖矩阵](coverage.md)按原书章节定位正文。
