# 0.12 学习目标自检表

逐条对照。左列是目标，中列是「怎样算达标」，右列是正文依据与对应习题。卡住时回到依据列重读，不要从头再读整章。

**使用建议**：先做[章末习题](ch12-exercises.md)的 A 组，用错题定位下面几行；再回到对应小节做「即时自测」。不要机械地逐行打钩。

| 目标 | 达标检验 | 依据与习题 |
|:--|:--|:--|
| **K12.1 启动链路** | 能说出固件→引导器→内核→initramfs→systemd→target 与每段证据 | [0.12.1](ch12.md#sec-0.12.1)；A1、D1 |
| **K12.2 unit 类型/依赖** | 能说 service/socket/timer/target/mount/path 与 `Requires`/`Wants`/`After` | [0.12.2](ch12.md#sec-0.12.2)、[0.12.8](ch12.md#sec-0.12.8)；A2、A8、D2、D8 |
| **K12.3 service unit** | 能写 `[Unit]/[Service]/[Install]`、`Type`/`Restart`/`User` | [0.12.3](ch12.md#sec-0.12.3)、[0.12.9](ch12.md#sec-0.12.9)；A3、C1、D3、D9 |
| **K12.4 journalctl** | 会用 `-u/-b/-p/--since/-f/-k` 查日志 | [0.12.4](ch12.md#sec-0.12.4)、[0.12.16](ch12.md#sec-0.12.16)；A4、C5、D4 |
| **K12.5 cron/timer** | 会写 crontab 与 `.timer`，用 `list-timers` 验证 | [0.12.5](ch12.md#sec-0.12.5)、[0.12.11](ch12.md#sec-0.12.11)；A5、C2、D5、D11 |
| **K12.6 logrotate** | 能配 daily/size/rotate/compress/postrotate，知道 `copytruncate` 风险 | [0.12.6](ch12.md#sec-0.12.6)、[0.12.12](ch12.md#sec-0.12.12)；A6、B5、D6 |
| **K12.7 启动排障** | 能用 `--failed`/`journalctl -b -p err`/rescue 排查 | [0.12.7](ch12.md#sec-0.12.7)；A7、B2、D7 |
| **K12.8 依赖语义** | 能区分需求/排序/传播、socket activation | [0.12.8](ch12.md#sec-0.12.8)；A8、B2、D8 |
| **K12.9 service 类型/沙箱** | 能解释 simple/oneshot/forking/notify、Restart、沙箱选项 | [0.12.9](ch12.md#sec-0.12.9)；A3、A8、D9 |
| **K12.10 journald 字段/持久化** | 能说字段、`Storage`、`SystemMaxUse`、rate limit | [0.12.10](ch12.md#sec-0.12.10)；B6、D10 |
| **K12.11 cron/timer 语义** | 能说 cron 环境/PATH、timer 时区/随机延迟/补跑 | [0.12.11](ch12.md#sec-0.12.11)；B3、B4、D11 |
| **K12.12 logrotate 信号** | 能解释 postrotate/信号/create/copytruncate | [0.12.12](ch12.md#sec-0.12.12)；A6、B5、D6 |
| **K12.13 巡检脚本** | 能写只读巡检：failed/timers/blame/disk-usage | [0.12.13](ch12.md#sec-0.12.13)；C5 |
| **K12.14 203/EXEC/补跑实验** | 能复现 203/EXEC 与 Persistent 补跑 | [0.12.14](ch12.md#sec-0.12.14)；C3、C4、D12 |
| **K12.15 systemd-analyze** | 会用 `blame`/`critical-chain`/`verify`/`calendar`/`security` | [0.12.15](ch12.md#sec-0.12.15)；C5、B3 |
| **K12.16 journalctl -b 取证** | 能用 `-b`/`--list-boots` 做跨启动取证 | [0.12.16](ch12.md#sec-0.12.16)；A4、C5、D4 |
| **K12.17 二十一个陷阱** | 能说出至少六条“现象 → 原因 → 修复” | [0.12.17](ch12.md#sec-0.12.17)；B1–B6、D12 |
| **S12.1 写 service** | 能写/启用/查日志一个 service | [0.12.3](ch12.md#sec-0.12.3)；C1 |
| **S12.2 写 timer** | 能写/启用/验证 timer 与 `list-timers` | [0.12.5](ch12.md#sec-0.12.5)；C2 |
| **S12.3 203/EXEC** | 能复现并修复 203/EXEC | [0.12.14](ch12.md#sec-0.12.14)；C3、B1 |
| **S12.4 Persistent timer** | 能验证错过补跑与不补跑 | [0.12.14](ch12.md#sec-0.12.14)；C4 |
| **S12.5 巡检取证** | 能汇总 failed/timers/err/disk-usage | [0.12.13](ch12.md#sec-0.12.13)；C5 |
| **A12.1 版本/发行版** | 能说 systemd/journald/cron 的版本差异 | [0.12.17](ch12.md#sec-0.12.17)；B1–B6 |
| **A12.2 先证据后重启** | 先看 status/journalctl/verify，再决定重启/改 unit | 全章实验；C1–C5 |

## 没达标怎么办

- **K 类卡住**：回到对应小节的「小结」和「即时自测」，先把启动/依赖/service 类型讲一遍。
- **S 类卡住**：在虚拟机里重跑对应实验，把 `systemctl status`/`journalctl`/`list-timers` 的真实输出贴进笔记。
- **A 类卡住**：做 B 组诊断题，强迫自己写出「现象 → unit/日志 → 修复」的链条。

全部达标后，进入 [0.13 网络配置与排障](ch13.md)。
