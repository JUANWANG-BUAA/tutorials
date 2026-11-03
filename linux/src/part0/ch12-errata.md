# 0.12 勘误与版本注记

这一页收本章最容易「记成永久真理」的版本敏感事实与 systemd/定时陷阱。正文里的 `errata` 盒讲理解陷阱；这一页讲**换 systemd、换发行版、换 cron 实现后要复核什么**。

**本章基线**：Ubuntu 24.04、systemd 255、journald 255、cron 3.0、logrotate 3.21。换环境时逐条复核。

## 1. unit 与依赖

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 1 | 改了 unit 文件就生效 | 要 `systemctl daemon-reload`（新 unit 还要 enable） | `systemctl cat`、`daemon-reload` |
| 2 | `After` 会把依赖拉起来 | `After` 只排序；拉起用 `Requires`/`Wants` | `systemctl list-dependencies` |
| 3 | `Requires` 失败不影响本 unit | 强依赖失败，本 unit 失败；`Wants` 才弱 | 停掉依赖测试 |
| 4 | `Type=simple` 适合所有服务 | 后台/daemon 用 `forking`+`PIDFile` 或 `notify`；否则 systemd 可能误判 | `systemctl status`、`PIDFile` |
| 5 | `ExecStart` 可以用管道/重定向 | systemd 不经过 shell；要 `sh -c '...'` 或写脚本 | 写 `ExecStart=echo a > /tmp/x` 测试 |
| 6 | `enable` 与 `start` 一样 | `enable` 开机自启，`start` 本次启动；`enable --now` 两者都做 | `systemctl is-enabled/is-active` |

## 2. 日志、定时与轮转

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 7 | `journalctl` 默认看所有 boot | 默认当前 boot；跨启动用 `-b -1`/`--list-boots` | `journalctl --list-boots` |
| 8 | journald 不丢日志 | 有 rate limit/`SystemMaxUse`/volatile；高频会丢 | `journalctl --disk-usage`、`journald.conf` |
| 9 | `Storage=auto` 一定持久化 | 只有 `/var/log/journal` 存在才持久化 | `ls -d /var/log/journal` |
| 10 | cron 与登录 Shell 环境一样 | cron 环境极简，`PATH` 常只有 `/usr/bin:/bin` | `* * * * * env > /tmp/cron.env` |
| 11 | cron 里 `%` 是普通字符 | crontab 里 `%` 要转义 `\%`，否则当换行 | 测试带日期的命令 |
| 12 | timer 写了就会跑 | 要 `enable --now`，`.service` 名字要对，`OnCalendar` 要合法 | `systemctl list-timers --all`、`systemd-analyze calendar` |
| 13 | `Persistent=true` 对所有 timer 一样 | 只补“错过”的触发；依赖时钟/时区/停机 | 停机跨过触发测试 |
| 14 | logrotate `copytruncate` 很安全 | 复制与截断之间写入会丢；优先 `create`+信号 | 高频写日志测试 |
| 15 | `postrotate` 一定成功 | 信号失败/程序没重开文件，日志会继续写旧 fd | `logrotate -d`、`lsof` |

## 3. 沙箱、启动与排障

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 16 | 沙箱选项越多越安全 | 可能挡住服务（`ProtectSystem`/`PrivateTmp`/`NoNewPrivileges`）；要测 | `systemd-analyze security`、日志 |
| 17 | `203/EXEC` 是权限问题 | 可能是路径/shebang/解释器/`noexec`/shell 语法 | `systemctl cat`、`file`、`journalctl -u` |
| 18 | 启动失败就重装 | 先 `--failed`/`journalctl -b -p err`/rescue | `systemctl --failed` |
| 19 | `systemd-analyze blame` 是全部耗时 | 只看 unit 自身；`critical-chain` 看链 | 两个都看 |
| 20 | systemd 版本差异可以忽略 | `Restart=`/沙箱/`OnCalendar` 依版本；旧版可能不认 | `systemctl --version` |

## 4. 本章未实测项

以下结论来自文档与常见行为，但未在本书写作环境逐条复跑；在别的发行版/systemd 版本上使用前先验证：

- systemd 255 的沙箱选项/`Restart=`/timer 语义依版本；旧版可能不支持某些键。
- journald 的 `Storage=`/`SystemMaxUse=`/rate limit 依发行版配置；`journald.conf` 为准。
- cron 实现（cronie/vixie/cron）行为略有差异；`anacron` 是否安装依发行版。
- logrotate 的 `su`/`create`/`copytruncate` 依版本与文件系统；`-d` 预演为准。
- 容器里的 systemd/PID 1 行为依 runtime；不要假设容器内 systemd 与宿主机一样。

## 5. 发现新问题怎么记

如果你在别的 systemd/发行版上发现本章结论不成立，按「现象 → 命令/输出 → 版本 → 建议改法」记到 issue 或笔记里；不要只写「我这里不对」。这张表下一轮会按同一格式增补。
