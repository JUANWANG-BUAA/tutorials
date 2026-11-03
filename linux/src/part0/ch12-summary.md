# 0.12 章末总结

## 四单元一览

| 单元 | 核心问题 | 关键结论 | 典型陷阱 |
|:--|:--|:--|:--|
| **一、启动与服务**（0.12.1–0.12.3） | 开机经过什么？unit 怎样组织？ | 固件→引导器→内核→initramfs→systemd→target 五段；unit 有 service/socket/timer/target/mount/path 等类型；service 由 `[Unit]/[Service]/[Install]` 组成。 | 把 `After` 当依赖；`ExecStart` 写 shell 语法；service 没 `enable`。 |
| **二、日志、定时与轮转**（0.12.4–0.12.7） | 日志怎么查？定时怎么选？轮转怎么配？ | `journalctl -u/-b/-p/--since`；cron 简单但无补跑，timer 支持 `Persistent`/随机延迟；logrotate 按 daily/size 轮转，`postrotate` 发信号。 | 只看当前 boot；cron PATH 不对；logrotate `copytruncate` 丢数据。 |
| **三、unit 语义**（0.12.8–0.12.12） | 依赖/服务类型/沙箱/日志/定时/轮转的边界？ | `Requires` 是需求、`After` 只是排序；`Wants` 弱依赖；`PartOf/BindsTo` 传播；service 类型 simple/oneshot/forking/notify；journald 有字段/持久化/限额；timer 与 cron 语义不同。 | 以为 `After` 会拉起依赖；`Type=forking` 不配 PIDFile；journald rate limit 丢日志；timer 没 `enable`。 |
| **四、实验与脚本**（0.12.13–0.12.18） | 怎样证明/巡检？ | 三条巡检脚本；203/EXEC 与错过补跑实验；`systemd-analyze` 看耗时/校验/日历；`journalctl -b` 做跨启动取证；二十一个陷阱。 | 不 `verify`；不看 `--failed`；不做持久化 timer 实验。 |

## 一条主线

这一章从“开机”走到“服务可运维”。**先画启动链路与 unit 依赖**，写一个 service；**再学 `journalctl`/cron/timer/logrotate/启动排障**。第二遍回到语义：依赖的排序/需求/传播、service 类型/重启/沙箱、journald 字段/持久化/限额、cron vs timer、logrotate 轮转/压缩/信号。最后用巡检脚本、203/EXEC 与错过补跑实验、`systemd-analyze`、`journalctl -b` 与陷阱清单收口。

## 看到问题先选工具

| 症状 | 第一动作 | 为什么 |
|:--|:--|:--|
| service 起不来 | `systemctl status <unit>`、`journalctl -u <unit> -b` | 先看状态/退出码/日志，不要盲重启。 |
| `203/EXEC` | `systemctl cat` 看 `ExecStart` 路径/权限/shebang | 203 是 exec 失败：路径不存在/不可执行/解释器缺失。 |
| 开机慢 | `systemd-analyze blame`、`critical-chain` | 找耗时 unit/链。 |
| 开机失败 | `systemctl --failed`、`journalctl -b -p err` | 先看 failed unit 与错误级日志。 |
| unit 依赖/顺序不对 | `systemctl list-dependencies`、`systemd-analyze verify` | `After` 只是排序，不是拉起；`Requires`/`Wants` 才是需求。 |
| timer 不触发 | `systemctl list-timers --all`、`systemctl status <timer>` | 看 `OnCalendar`/`Persistent`/`enable`/时区。 |
| cron 不触发 | 看 cron 日志、脚本 PATH、权限 | cron 环境极简，PATH/变量不同。 |
| 日志没轮转 | `logrotate -d` 预演、看 size/daily/`copytruncate` | 条件不满足/权限/信号。 |
| journal 占满磁盘 | `journalctl --disk-usage`、`--vacuum-size` | 持久化/限额配置。 |
| 服务权限太大 | `systemd-analyze security <unit>` | 沙箱选项评分。 |

## 能否讲出这八句话

1. 启动五段：固件 → 引导器 → 内核 → initramfs → systemd → target；每段有自己的证据。
2. unit 类型有 service/socket/timer/target/mount/path 等；`Requires`/`Wants` 是需求，`After`/`Before` 只是排序。
3. service 由 `[Unit]/[Service]/[Install]` 组成；`Type=simple/oneshot/forking/notify` 决定 systemd 怎样判断“启动完成”。
4. `journalctl -u <unit> -b -p err --since` 按 unit/boot/优先级/时间查；`-b` 做跨启动取证。
5. cron 简单但默认无补跑；timer 支持 `Persistent=true`/随机延迟/依赖，`systemctl list-timers` 看下次触发。
6. logrotate 按 daily/size 轮转；`postrotate` 发 HUP；`copytruncate` 会丢写窗口，优先 `create`+信号。
7. `203/EXEC` 是 `ExecStart` 路径/权限/shebang 问题；`ExecStart` 不走 shell，管道/重定向要包 `sh -c`。
8. `systemd-analyze verify/blame/security` 与 `journalctl -b` 是排障证据；不要只靠重启。

## 学完之后

1. **[闭卷回忆卡](ch12-recall.md)**：先合上正文，把启动五段、unit 依赖、service 类型、journalctl、cron/timer、logrotate 六组结论从空白纸上叫出来。
2. **[习题集](ch12-exercises.md)**：A 组检查概念，B 组诊断“为什么起不来/为什么定时不触发/为什么日志没轮转”，C 组写 service/timer、做 203/EXEC 与 persistent 实验。
3. **[学习目标自检表](ch12-checklist.md)**：把卡住的点对到正文小节和习题，回到那一节重读。
4. **[勘误与版本注记](ch12-errata.md)**：把 systemd 版本、journald 持久化、cron/timer 语义差异过一遍。
5. **下一站**：[0.13 网络配置与排障](ch13.md) 会从本机服务转到网络；本章的 `journalctl`/service 会在那里接到 `ss`/`tcpdump`。
