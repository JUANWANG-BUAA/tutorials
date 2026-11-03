# 0.12 systemd、启动、日志与定时任务 · 本章导航

::: preview 这一章在讲什么
开机从固件到 `target` 经过哪几段？为什么 `systemctl start` 报 `203/EXEC`？`journalctl` 应该先看哪个 boot？`cron` 与 `systemd timer` 差在哪？`logrotate` 为什么没轮转？这一章先把启动链路、unit 依赖、service 写法讲清，再学日志、定时、轮转与启动排障；第二遍看依赖语义、service 类型/重启/沙箱、journald 字段/持久化、cron vs timer、logrotate 信号。目标是**服务起不来时能按证据定位，而不是重启大法**。
:::

## 读完你会

- 画出固件 → 引导器 → 内核 → initramfs → systemd → target 的启动链路。
- 写一个可用的 service unit：`[Unit]/[Service]/[Install]`、`ExecStart`、`Restart`、`User`、沙箱选项。
- 解释 unit 依赖：`Requires`/`Wants`/`After`/`Before`/`PartOf`/`BindsTo` 的排序与传播。
- 用 `journalctl` 按 boot/unit/priority/时间查日志，用 `-b` 做跨启动取证。
- 选 `cron` 还是 `systemd timer`，处理错过补跑/随机延迟/持久化。
- 配 `logrotate`：轮转、压缩、`postrotate` 信号、`copytruncate` 边界。
- 用 `systemd-analyze` 看启动耗时、校验 unit、算日历。
- 排查 `203/EXEC`、依赖失败、unit 循环、定时不触发等常见问题。

## 先修与预计学时

- 先修：读完 [0.11 软件包、编译、库与镜像](ch11.md)；会 `systemctl`、`journalctl`。**不需要**学过 init 系统；unit/target 的白话解释在本章开头。
- 阅读：约 120–150 分钟；实验与脚本：约 60 分钟；章末习题：约 60 分钟。

## 本章路线：四段，一条主线

| 段 | 小节 | 这一段回答什么 |
|:--|:--|:--|
| **一、启动与服务** | [0.12.1](ch12.md#sec-0.12.1)–[0.12.3](ch12.md#sec-0.12.3) | 开机链路五段是什么？unit 类型/依赖怎样组织？怎样把脚本变成 service？ |
| **二、日志、定时与轮转** | [0.12.4](ch12.md#sec-0.12.4)–[0.12.7](ch12.md#sec-0.12.7) | `journalctl` 按什么顺序查？`cron`/timer 怎样选？`logrotate` 怎样轮转？启动失败怎样排？ |
| **三、unit 语义** | [0.12.8](ch12.md#sec-0.12.8)–[0.12.12](ch12.md#sec-0.12.12) | 依赖的排序/需求/传播？service 类型/重启/沙箱？journald 字段/持久化/限额？cron vs timer 语义？logrotate 轮转/压缩/信号？ |
| **四、压成能力** | [0.12.13](ch12.md#sec-0.12.13)–[0.12.18](ch12.md#sec-0.12.18) | 三条巡检脚本、203/EXEC 与错过补跑实验、`systemd-analyze`、`journalctl -b` 取证、二十一个陷阱。 |

一句话主线：**先画开机链路与 unit 依赖（0.12.1–0.12.2），写一个 service（0.12.3）；再学 `journalctl`/cron/timer/logrotate/启动排障（0.12.4–0.12.7）。第二遍看依赖语义、service 类型/重启/沙箱、journald 字段/持久化、cron vs timer、logrotate 信号（0.12.8–0.12.12）。最后用巡检脚本、实验、`systemd-analyze`、`journalctl -b` 与陷阱清单收口（0.12.13–0.12.18）。**

## 怎么读

- **第一次读**：0.12.1–0.12.7 按顺序；每节先做「即时自测」，再去下一节。service 要自己写一个。
- **只想排障**：0.12.4、0.12.7、0.12.15–0.12.16；先 `systemctl status`/`journalctl -u`/`systemd-analyze`。
- **想写服务/定时任务**：0.12.2–0.12.3、0.12.5、0.12.8–0.12.12；先分清 oneshot/simple/forking。
- **卡住时**：先回[先修工具箱](../prerequisite.md)补进程/信号/日志，再回到对应小节。

## 路线标签与项目回链

- 应用/运维：**必读**（整章；服务、日志、定时、轮转是日常）。
- 系统编程：**必读**（0.12.2–0.12.3、0.12.8–0.12.10；unit/信号/重启策略）。
- 内核/性能：**可后补**（0.12.1、0.12.15；启动耗时/日志）。
- 项目回链：项目 A1（容器 init/PID 1）；A2（`myhttpd`）的 service；D3（`mygit`）的定时备份。

## 章末件

[章末总结](ch12-summary.md) · [闭卷回忆卡](ch12-recall.md) · [习题集](ch12-exercises.md) · [学习目标自检表](ch12-checklist.md) · [勘误与版本注记](ch12-errata.md)

## 这一章的依据

| 母本 | 章节 | 主要落点 |
|:--|:--|:--|
| **Kerrisk** | 第 2、24–27 章（进程、`fork/exec/wait`、信号） | 0.12.3、0.12.9 |
| 鸟哥 | 第 17–19 章（systemd、开机流程、模块） | 0.12.1–0.12.9 |
| Shotts | 第 10 章（进程） | 0.12.3、0.12.9 |
| man-pages | `systemd.service(5)`、`systemd.timer(5)`、`journalctl(1)`、`logrotate(8)`、`crontab(5)` | 0.12.1–0.12.17 |
| **CSAPP** | 第 8 章（异常控制流：进程/信号） | 0.12.3、0.12.9 的背景 |
