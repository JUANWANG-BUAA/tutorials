# 0.12 闭卷回忆卡

这页不是摘要，而是一组**检索练习**。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。

建议在学完当天、隔天、第 3 天、第 7 天各做一次。每次只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 第一遍：先会用

### D1 · 启动五段

从按下电源到登录提示符，控制权经过哪五段？每段给一条证据命令。

::: sol D1 核对

固件（UEFI/BIOS）→ 引导器（GRUB/systemd-boot）→ 内核（vmlinuz）→ initramfs（临时根）→ init（systemd PID 1）→ target（multi-user/graphical）。证据：`efibootmgr -v`/`ls /sys/firmware/efi`、`grep menuentry /boot/grub/grub.cfg`、`cat /proc/cmdline`/`dmesg`、`lsinitramfs /boot/initrd.img-$(uname -r)`、`systemctl get-default`/`systemd-analyze`。排障先找“最后一段有证据的地方”。
:::

### D2 · unit 类型与依赖

systemd 有哪些 unit 类型？`Requires`/`Wants`/`After`/`Before` 各是什么？

::: sol D2 核对

类型：service、socket、timer、target、mount、automount、path、slice、scope、swap、device。`Requires` 强依赖（依赖失败则本 unit 失败），`Wants` 弱依赖（失败不阻止），`After`/`Before` 只控制启动顺序，不拉起依赖；`PartOf`/`BindsTo` 有传播/绑定语义。`After` 不等于 `Requires`。
:::

### D3 · service unit

一个 service unit 有哪三节？`Type=simple/oneshot/forking/notify` 各是什么？`Restart=` 怎样用？

::: sol D3 核对

`[Unit]`（Description/After/Wants）、`[Service]`（Type/ExecStart/Restart/User/WorkingDirectory/Environment）、`[Install]`（WantedBy=multi-user.target）。`simple` 启动即认为完成；`oneshot` 执行完退出；`forking` 父进程退出、子进程继续（配 `PIDFile`）；`notify` 等 `sd_notify`。`Restart=on-failure/always` + `RestartSec`；`systemctl enable --now` 开机自启并立即启动。
:::

### D4 · journalctl

`journalctl -u`/`-b`/`-p`/`--since`/`-f`/`-k` 各做什么？怎样看某个服务本次启动的日志？

::: sol D4 核对

`-u unit` 按 unit；`-b` 按 boot（`-b -1` 上一次）；`-p err` 按优先级；`--since/--until` 时间；`-f` 跟随；`-k` 内核日志。`journalctl -u ssh -b` 看本次启动的 ssh 日志；`journalctl --list-boots` 列 boot。`-o json`/`-o cat` 换格式。
:::

### D5 · cron 与 timer

cron 与 systemd timer 各怎样用？`Persistent=true` 解决什么？`systemctl list-timers` 看什么？

::: sol D5 核对

cron：`crontab -e` 五段（分/时/日/月/周）+ 命令；`/etc/cron.d`。timer：`.timer` 配 `OnCalendar=`/`OnBootSec=`/`Persistent=true`，`.service` 放实际命令；`systemctl enable --now foo.timer`。`Persistent=true` 让错过的触发在开机后补跑；`list-timers` 看下次/上次触发。cron 默认不补跑（anacron 可补）。
:::

### D6 · logrotate

logrotate 配置在哪？`daily`/`size`/`rotate`/`compress`/`postrotate` 各做什么？`copytruncate` 有什么风险？

::: sol D6 核对

主配 `/etc/logrotate.conf`，片段 `/etc/logrotate.d/*`。`daily`/`weekly`/`size` 触发；`rotate N` 保留份数；`compress` 压缩；`postrotate ... endscript` 轮转后发信号（如 `kill -HUP`）。`copytruncate` 复制后截断原文件，复制与截断之间写入会丢；优先 `create` + 让程序重开文件。
:::

## B. 第二遍：语义与边界

### D7 · 启动排障

开机失败/进 emergency，按什么顺序查？`systemctl --failed`/`journalctl -b -p err` 各给什么？

::: sol D7 核对

先看是否过引导器/内核（GRUB 菜单、`/proc/cmdline`），再看 `systemctl --failed` 与 `journalctl -b -p err`；进 emergency/rescue 修 fstab/unit；`systemd.unit=rescue.target`/`rd.break` 临时进救援；`systemd-analyze blame/critical-chain` 看耗时。不要一上来重装。
:::

### D8 · 依赖语义

`Requires` 与 `After` 的区别？`Wants`/`PartOf`/`BindsTo` 各是什么？socket activation 是什么？

::: sol D8 核对

`Requires` 是强需求：依赖启动失败，本 unit 失败；`After` 只排序，不拉起依赖。`Wants` 弱需求；`PartOf` 停止/重启传播；`BindsTo` 更紧的绑定（依赖停则本 unit 停）。socket activation：systemd 先监听 socket，有连接再启动 service，省资源/按需启动。
:::

### D9 · service 类型、重启与沙箱

`Type=forking` 为什么要 `PIDFile`？`Restart=` 有哪些值？沙箱选项各做什么？

::: sol D9 核对

`forking` 的父进程启动后退出，systemd 需要 `PIDFile` 找主进程；否则可能认为服务已退出。`Restart=no/on-failure/on-abnormal/always` + `RestartSec`。沙箱：`PrivateTmp`、`ProtectSystem=strict`、`ProtectHome`、`NoNewPrivileges`、`ReadWritePaths`、`CapabilityBoundingSet`；`systemd-analyze security` 评分。沙箱不是万能，要测兼容性。
:::

### D10 · journald 字段与持久化

journald 常见字段有哪些？`Storage=volatile/persistent/auto` 差在哪？`SystemMaxUse` 做什么？rate limit 会怎样？

::: sol D10 核对

字段：`_PID`、`_UID`、`_SYSTEMD_UNIT`、`PRIORITY`、`SYSLOG_IDENTIFIER`、`MESSAGE`、`_BOOT_ID`。`Storage=volatile` 只在内存（重启丢），`persistent` 写 `/var/log/journal`，`auto` 有目录才持久化。`SystemMaxUse` 限总大小；`journalctl --vacuum-size` 清理。rate limit 会丢高频日志，需调 `RateLimitBurst`/`RateLimitIntervalSec`。
:::

### D11 · cron 与 timer 的语义差异

cron 的 `PATH`/环境为什么和登录 Shell 不同？timer 的 `OnCalendar` 时区/随机延迟怎样？错过触发怎么办？

::: sol D11 核对

cron 用极简环境，`PATH` 通常只有 `/usr/bin:/bin`，不读 `.bashrc`；脚本里显式设 `PATH`/变量。timer 的 `OnCalendar` 按系统时区（可 `Timezone=`），`RandomizedDelaySec` 打散；`Persistent=true` 补跑错过的触发，cron 默认不补（anacron 可补）。`systemctl list-timers` 看下次。
:::

### D12 · 203/EXEC 与陷阱

`203/EXEC` 是什么？`ExecStart` 为什么不能直接用管道/重定向？任选三个 systemd 陷阱。

::: sol D12 核对

203/EXEC 是 exec 失败：`ExecStart` 路径不存在/不可执行/shebang 解释器缺失/权限不对。`ExecStart` 不走 shell，管道/重定向/变量展开要包 `sh -c '...'`（或写脚本）。陷阱：`After` 当依赖；service 没 `enable`；`Type=forking` 没 `PIDFile`；timer 没 `enable`；journald rate limit 丢日志；logrotate `copytruncate` 丢写。
:::
