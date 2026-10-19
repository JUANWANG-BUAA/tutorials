# R.1 命令行速查

> 只放「高频 + 易错」；完整解释回各章。默认 Ubuntu 24.04 / bash 5.2。

## 1. 导航与文件

| 目的 | 命令 |
|:--|:--|
| 当前目录 | `pwd -P`（物理路径，解开符号链接） |
| 列出（含隐藏、inode） | `ls -alhi` |
| 按大小/时间排序 | `ls -lhS` / `ls -lht` |
| 只看目录 | `ls -d */` |
| 建目录（含父） | `mkdir -p a/b/c` |
| 复制保留属性 | `cp -a src dst` |
| 移动/改名 | `mv -- old new` |
| 删除（先确认） | `ls -ld -- target && rm -rf -- target` |
| 硬链接 | `ln src dst` |
| 软链接 | `ln -s target link` |
| 查看链接指向 | `readlink -f link` |
| 元数据 | `stat file` |
| 文件类型 | `file file` |
| 磁盘占用 | `du -xhd1 . \| sort -h` |
| 目录树 | `tree -L 2 -a` |

## 2. 权限

| 目的 | 命令 |
|:--|:--|
| 八进制 | `chmod 644 f` / `chmod 755 d` |
| 符号 | `chmod u+x,g-w,o=r f` |
| 递归 | `chmod -R u+rwX dir`（`X` 只给目录/已可执行文件） |
| 属主 | `chown user:group f` |
| 默认权限 | `umask` / `umask 022` |
| ACL | `getfacl f` / `setfacl -m u:alice:rw f` |
| 能力 | `getcap f` / `setcap cap_net_bind_service=+ep f` |
| 查找 setuid | `find / -perm -4000 -type f 2>/dev/null` |

判定顺序：`root` → 属主 → 属组 → other；ACL mask 会限制有效权限；目录的 `x` 是「能进入」，`r` 是「能列名」。

## 3. 文本处理

| 目的 | 命令 |
|:--|:--|
| 查找内容 | `grep -RIn --exclude-dir=.git 'pat' .` |
| 固定串 | `grep -F 'a.b'` |
| 扩展正则 | `grep -E 'a\|b'` |
| PCRE | `grep -P '(?<=x)y'` |
| 只输出匹配 | `grep -o 'pat'` |
| 前后文 | `grep -C3 'pat'` |
| 替换 | `sed -i.bak 's/old/new/g' f` |
| 按行号 | `sed -n '10,20p' f` |
| 删除空行 | `sed '/^$/d' f` |
| 字段抽取 | `awk -F: '{print $1, $3}' /etc/passwd` |
| 条件统计 | `awk '$3>100 {n++} END{print n}' f` |
| 去重计数 | `sort f \| uniq -c \| sort -nr` |
| 列 | `cut -d, -f2,4 f` |
| 拼接 | `paste a b` |
| 十六进制 | `xxd -g1 f` / `hexdump -C f` |

## 4. 重定向与管道

| 写法 | 含义 |
|:--|:--|
| `> f` | stdout 覆盖到 f |
| `>> f` | 追加 |
| `2> f` | stderr 到 f |
| `2>&1` | stderr 复制到当前 stdout（顺序重要） |
| `&> f` | stdout+stderr 到 f（bash） |
| `< f` | stdin 来自 f |
| `<<EOF` | here-doc |
| `<<<"$s"` | here-string |
| `\|` | 管道；默认只有 stdout |
| `\|&` | stdout+stderr 都进管道（bash） |
| `tee f` | 分流到文件与 stdout |
| `<(cmd)` | 进程替换（bash） |
| `set -o pipefail` | 管道任一失败即失败 |

退出码：`$?`；`PIPESTATUS[@]` 看每段；`SIGPIPE` 退出码 141。

## 5. 进程、作业、信号

| 目的 | 命令 |
|:--|:--|
| 快照 | `ps -eo pid,ppid,stat,pcpu,pmem,etime,cmd --sort=-pcpu` |
| 线程 | `ps -eLf` / `top -H -p PID` |
| 树 | `pstree -ap` |
| 后台 | `cmd &` |
| 作业 | `jobs -l` / `fg %1` / `bg %1` |
| 脱离终端 | `nohup cmd >out 2>&1 &` / `setsid cmd` |
| 发信号 | `kill -TERM PID` / `kill -9 PID` |
| 按名 | `pkill -f 'pattern'` |
| 超时 | `timeout 10s cmd` |
| 等待 | `wait` / `wait -n` |
| 查看状态 | `cat /proc/PID/status` |
| 查看栈 | `cat /proc/PID/stack`（root） |

信号：`TERM` 可捕获、`KILL` 不可捕获、`INT` 是 Ctrl-C、`HUP` 是终端关闭、`STOP/CONT` 暂停/继续、`CHLD` 子进程状态变化。

## 6. 磁盘与文件系统

| 目的 | 命令 |
|:--|:--|
| 空间 | `df -hT` / `df -i` |
| 目录占用 | `du -xhd1 /var \| sort -h` |
| 块设备 | `lsblk -f` |
| 挂载 | `findmnt -T /path` |
| 挂载/卸载 | `mount /dev/sdb1 /mnt` / `umount /mnt` |
| 只读重挂 | `mount -o remount,rw /` |
| 文件系统 | `mkfs.ext4` / `mkfs.xfs` |
| LVM | `pvs` / `vgs` / `lvs` / `lvextend -r -L +10G vg/lv` |
| RAID | `mdadm --detail /dev/md0` |
| SMART | `smartctl -a /dev/sdX` |
| 谁占用挂载点 | `fuser -vm /mnt` |

`df` 满但 `du` 小：`lsof +L1` 找被删除仍打开的文件。

## 7. 包、服务、日志

| 目的 | 命令 |
|:--|:--|
| 更新 | `sudo apt update && sudo apt upgrade` |
| 安装/删除 | `sudo apt install pkg` / `sudo apt remove pkg` |
| 查文件属于哪个包 | `dpkg -S /path` |
| 包内容 | `dpkg -L pkg` |
| 服务状态 | `systemctl status svc` |
| 启停 | `sudo systemctl start/stop/restart svc` |
| 开机自启 | `sudo systemctl enable --now svc` |
| 失败原因 | `systemctl --failed` / `journalctl -xeu svc` |
| 本次启动日志 | `journalctl -b` |
| 实时日志 | `journalctl -f -u svc` |
| 定时器 | `systemctl list-timers` |
| cron | `crontab -e` / `crontab -l` |

## 8. 网络

| 目的 | 命令 |
|:--|:--|
| 地址 | `ip -br addr` |
| 路由 | `ip route get 8.8.8.8` |
| 邻居 | `ip neigh` |
| 监听 | `ss -lntp` |
| 连接 | `ss -tnp state established` |
| 统计 | `ss -s` |
| 套接字明细 | `ss -tin` |
| 抓包 | `sudo tcpdump -i any -nn -s0 -w cap.pcap` |
| 读包 | `tcpdump -r cap.pcap 'tcp port 443'` |
| DNS | `dig +short example.com` / `resolvectl query` |
| HTTP | `curl -v --trace-time` |
| 端口测试 | `nc -vz host 443` |
| 带宽 | `iperf3 -c host -P 4` |
| 路径 | `mtr -rwc 100 host` |

## 9. 性能

| 症状 | 先看 |
|:--|:--|
| CPU 高 | `top`、`mpstat -P ALL 1`、`perf top -p PID` |
| load 高但 CPU 闲 | `ps -eo state,wchan,comm \| awk '$1=="D"'`、`iostat -xz` |
| 内存涨 | `free -h`、`smem -tk`、`/proc/PID/status` |
| 磁盘慢 | `iostat -xz 1`、`iotop -oPa` |
| 网络慢 | `ss -tin`、`tcpdump`、`mtr` |
| 系统调用多 | `strace -c -T -p PID` |
| 内核热点 | `perf top -g`、`bpftrace` |

## 10. Bash 惯用法

```bash
set -euo pipefail                  # 严格模式（注意语境例外）
IFS=$'\n\t'                        # 安全分词
name=${1:?usage: $0 NAME}          # 必填参数
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
while IFS= read -r line; do ...; done < file   # 不丢反斜杠
mapfile -t arr < file              # 读数组
for f in *.log; do [ -e "$f" ] || continue; done
printf '%s\n' "$var"               # 优于 echo
```

易错：

- `for f in $(ls)`：文件名含空格会拆开；用 glob。
- `while read` 在管道里是子 shell，变量改了外面看不到；用进程替换或 `mapfile`。
- `[ $x = y ]` 在 `x` 为空时变成 `[ = y ]`；用 `[[ ]]` 或加引号。
- `cd` 失败后继续 `rm -rf *`：先 `cd ... || exit 1`。
- `set -e` 在 `if`/`&&`/`||`/`!` 语境不触发；别把它当万能。

## 11. 一页诊断顺序

```text
1. 现象：什么坏了？影响谁？从什么时候开始？
2. 变更：最近改了什么（发布/配置/证书/磁盘）？
3. 资源：CPU / 内存 / 磁盘 / 网络 / fd
4. 进程：在不在？什么状态？卡在哪？
5. 日志：应用 / 内核 / systemd
6. 证据：命令输出存档，再动手
```

> 回 [R.2 系统编程速查](cheatsheet-sysprog.md)；需要按症状排查去 [A.3](../appendix/debugging.md)。
