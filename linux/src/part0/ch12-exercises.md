# 0.12 习题集

三组分层：A 组概念判断（口答即可）、B 组诊断推理（写出步骤）、C 组动手实验（在虚拟机里跑）。**全部附解答**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；
2. 卡住了，回到对应小节的「即时自测」重读，不要直接看答案；
3. 做完再对照解答，重点看自己卡在哪一步；
4. 做错的题记一个记号，三天后只重做记号题。

## A 组 · 概念判断

::: ex A1 · 启动五段

从按下电源到登录提示符，控制权经过哪五段？每段给一条证据命令。

::: sol 解答

固件 → 引导器 → 内核 → initramfs → init/systemd → target。证据：`efibootmgr -v`/`ls /sys/firmware/efi`、`grep menuentry /boot/grub/grub.cfg`、`cat /proc/cmdline`/`dmesg`、`lsinitramfs /boot/initrd.img-$(uname -r)`、`systemctl get-default`/`systemd-analyze`。排障先找“最后一段有证据的地方”。

:::
:::

::: ex A2 · unit 类型与依赖

systemd 有哪些 unit 类型？`Requires`/`Wants`/`After`/`Before` 各是什么？

::: sol 解答

类型：service、socket、timer、target、mount、automount、path、slice、scope、swap、device。`Requires` 强依赖（失败则本 unit 失败），`Wants` 弱依赖，`After`/`Before` 只控制顺序，不拉起依赖；`PartOf`/`BindsTo` 有传播/绑定语义。`After` 不等于 `Requires`。

:::
:::

::: ex A3 · service unit

一个 service unit 有哪三节？`Type=simple/oneshot/forking/notify` 各是什么？`Restart=` 怎样用？

::: sol 解答

`[Unit]`（Description/After/Wants）、`[Service]`（Type/ExecStart/Restart/User/Environment）、`[Install]`（WantedBy=multi-user.target）。`simple` 启动即完成；`oneshot` 执行完退出；`forking` 父退出子继续（配 `PIDFile`）；`notify` 等 `sd_notify`。`Restart=on-failure/always` + `RestartSec`；`enable --now` 开机自启并立即启动。

:::
:::

::: ex A4 · journalctl

`journalctl -u`/`-b`/`-p`/`--since`/`-f`/`-k` 各做什么？怎样看某个服务本次启动的日志？

::: sol 解答

`-u unit` 按 unit；`-b` 按 boot（`-b -1` 上一次）；`-p err` 优先级；`--since/--until` 时间；`-f` 跟随；`-k` 内核日志。`journalctl -u ssh -b` 看本次启动 ssh 日志；`--list-boots` 列 boot；`-o json/cat` 换格式。

:::
:::

::: ex A5 · cron 与 timer

cron 与 systemd timer 各怎样用？`Persistent=true` 解决什么？`systemctl list-timers` 看什么？

::: sol 解答

cron：`crontab -e` 五段 + 命令；`/etc/cron.d`。timer：`.timer` 配 `OnCalendar`/`OnBootSec`/`Persistent=true`，`.service` 放命令；`systemctl enable --now foo.timer`。`Persistent=true` 让错过触发在开机后补跑；`list-timers` 看下次/上次触发。cron 默认不补跑（anacron 可补）。

:::
:::

::: ex A6 · logrotate

logrotate 配置在哪？`daily`/`size`/`rotate`/`compress`/`postrotate` 各做什么？`copytruncate` 有什么风险？

::: sol 解答

主配 `/etc/logrotate.conf`，片段 `/etc/logrotate.d/*`。`daily`/`weekly`/`size` 触发；`rotate N` 保留份数；`compress` 压缩；`postrotate ... endscript` 轮转后发信号。`copytruncate` 复制后截断，复制与截断之间写入会丢；优先 `create` + 让程序重开文件。

:::
:::

::: ex A7 · 启动排障

开机失败/进 emergency，按什么顺序查？`systemctl --failed`/`journalctl -b -p err` 各给什么？

::: sol 解答

先看是否过引导器/内核（GRUB 菜单、`/proc/cmdline`），再看 `systemctl --failed` 与 `journalctl -b -p err`；进 emergency/rescue 修 fstab/unit；`systemd.unit=rescue.target`/`rd.break` 临时救援；`systemd-analyze blame/critical-chain` 看耗时。不要一上来重装。

:::
:::

::: ex A8 · 依赖语义与 service 类型

`Requires` 与 `After` 的区别？`Type=forking` 为什么要 `PIDFile`？沙箱选项各做什么？

::: sol 解答

`Requires` 强需求，依赖失败本 unit 失败；`After` 只排序不拉起。`forking` 父进程退出、子进程继续，systemd 需要 `PIDFile` 找主进程。沙箱：`PrivateTmp`、`ProtectSystem=strict`、`ProtectHome`、`NoNewPrivileges`、`ReadWritePaths`、`CapabilityBoundingSet`；`systemd-analyze security` 评分。

:::
:::

## B 组 · 诊断推理

::: ex B1 · `203/EXEC`

`systemctl start myapp` 报 `203/EXEC`。列出至少四种原因与验证。

::: sol B1 核对

① `ExecStart` 路径不存在/拼错；② 文件不可执行（`chmod +x`）；③ shebang 解释器不存在（`#!/usr/bin/env python3` 但无 python3）；④ 权限/SELinux/挂载 `noexec`；⑤ `ExecStart` 用了 shell 语法（管道/重定向），systemd 不走 shell。查：`systemctl cat`、`ls -l`、`file`、`journalctl -u`、`namei -l`。

:::
:::

::: ex B2 · service 起不来

`systemctl status myapp` 显示 failed，但手动运行命令正常。列出至少三种原因。

::: sol B2 核对

① 环境不同（`PATH`/`Environment`/`WorkingDirectory`/`User`）；② 权限/文件描述符/端口被占；③ `Type` 不对（后台进程用 `simple`，应 `forking`+`PIDFile` 或 `notify`）；④ 依赖没起（`After` 不是依赖，需 `Requires/Wants`）；⑤ 沙箱选项挡住（`ProtectSystem`/`PrivateTmp`）；⑥ `ExecStart` 引用相对路径。看 `journalctl -u` 与 `systemd-analyze verify`。

:::
:::

::: ex B3 · timer 不触发

`foo.timer` 显示 active，但任务没跑。列出至少四种原因与验证。

::: sol B3 核对

① `.timer` 没 `enable`/没启动；② `OnCalendar` 语法/时区错：`systemd-analyze calendar`；③ 对应 `.service` 名字不对/不存在；④ `Persistent`/`AccuracySec`/`RandomizedDelaySec` 影响；⑤ 服务本身失败：`journalctl -u foo.service`；⑥ 系统休眠/时间跳变。`systemctl list-timers --all`、`systemctl status foo.timer`。

:::
:::

::: ex B4 · cron 不触发

`crontab -l` 有任务，但没执行。列出至少四种原因与验证。

::: sol B4 核对

① cron 服务没跑：`systemctl status cron`；② PATH/环境不同：脚本里写绝对路径/设 PATH；③ 权限/脚本不可执行/shebang；④ 时间字段/时区错；⑤ 输出被 mail 吞/没日志：`journalctl -u cron`、`/var/log/syslog`；⑥ `%` 未转义。用 `* * * * * /path/script >> /tmp/cron.log 2>&1` 调试。

:::
:::

::: ex B5 · logrotate 没轮转

`/etc/logrotate.d/myapp` 配了 daily，但日志没轮转。列出至少三种原因与验证。

::: sol B5 核对

① 条件不满足（daily 未到/size 未到）；② 权限/`su` 配置不对；③ `postrotate` 信号失败/程序没重开文件；④ logrotate 定时器没跑（`systemctl list-timers logrotate.timer`）；⑤ 配置语法错：`logrotate -d /etc/logrotate.conf` 预演；⑥ `copytruncate`/`create` 选项冲突。先 `-d` 看决策。

:::
:::

::: ex B6 · journald 丢日志

高频日志在 journal 里缺行。为什么？怎样调？

::: sol B6 核对

journald 有 rate limit（`RateLimitIntervalSec`/`RateLimitBurst`），高频日志会被丢弃；`Storage=volatile` 重启丢；`SystemMaxUse` 满了会轮转/丢旧。查 `journalctl --disk-usage`、`/etc/systemd/journald.conf`；调 `RateLimitBurst`/`Storage=persistent`/`SystemMaxUse`，`systemctl restart systemd-journald`。

:::
:::

## C 组 · 动手实验

::: ex C1 · 写一个 service

写一个 `hello.service`：`ExecStart` 运行脚本，`Restart=on-failure`，`User=nobody`，`WantedBy=multi-user.target`；`enable --now` 并查日志。

::: sol C1 核对

```ini
[Unit]
Description=hello
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/hello.sh
Restart=on-failure
RestartSec=2
User=nobody

[Install]
WantedBy=multi-user.target
```

`systemctl daemon-reload`、`systemctl enable --now hello`、`systemctl status hello`、`journalctl -u hello -b`。注意脚本/解释器权限、`User` 可读、`ExecStart` 绝对路径。

:::
:::

::: ex C2 · 写一个 timer

写 `backup.service` + `backup.timer`，每天 03:00 跑，`Persistent=true`；用 `list-timers` 验证。

::: sol C2 核对

`backup.service`：`Type=oneshot`、`ExecStart=/usr/local/bin/backup.sh`。`backup.timer`：

```ini
[Unit]
Description=daily backup

[Timer]
OnCalendar=*-*-* 03:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

`systemctl daemon-reload`、`systemctl enable --now backup.timer`、`systemctl list-timers --all`。`systemd-analyze calendar '*-*-* 03:00:00'` 验证表达式；`Persistent=true` 补跑错过。

:::
:::

::: ex C3 · 203/EXEC 实验

故意把 `ExecStart` 指向不存在的路径/不可执行文件，观察 `203/EXEC`，再修好。

::: sol C3 核对

```bash
sudo systemctl edit --full hello   # 或改 /etc/systemd/system/hello.service
# ExecStart=/no/such/app
sudo systemctl daemon-reload
sudo systemctl restart hello
systemctl status hello             # 203/EXEC
journalctl -u hello -b
```

修：路径存在、`chmod +x`、shebang 解释器存在、无 `noexec`。`systemd-analyze verify hello.service` 也能提前发现部分问题。

:::
:::

::: ex C4 · Persistent timer 实验

把 timer 设成过去时间/停机一段时间，验证 `Persistent=true` 开机补跑；对比 `Persistent=false`。

::: sol C4 核对

```ini
[Timer]
OnCalendar=*-*-* 03:00:00
Persistent=true
```

把系统时间/停机跨过 03:00，开机后 `systemctl list-timers` 应显示已补跑/下次；`journalctl -u backup.service` 看执行记录。改 `Persistent=false` 再试，错过的不会补。实验用虚拟机，别改宿主时间。

:::
:::

::: ex C5 · 巡检与取证

用 `systemctl --failed`、`systemctl list-timers --all`、`systemd-analyze blame`、`journalctl -b -p err` 做一次巡检；写一个只读巡检脚本。

::: sol C5 核对

```bash
systemctl --failed
systemctl list-timers --all
systemd-analyze blame | head
journalctl -b -p err --no-pager | tail -50
journalctl --disk-usage
```

脚本把这些输出到文件/日志，带时间戳；只读，不改服务。`systemd-analyze verify` 校验 unit；`systemd-analyze security` 看沙箱评分。巡检先看 failed/timer/err，再看耗时。

:::
:::
