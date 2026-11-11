# 2.9 章末总结

## 一条主线：四个单元，一条因果链

**第一单元，身份与数据库（2.9.1–2.9.2）。** 每个进程带四个 UID：真实 UID 决定归属与信号权限，有效 UID 决定此刻能做什么，保存 UID 是 exec 时的快照、给临时降权留退路，文件系统 UID 只管文件访问（Linux 专有，NFS 的历史产物）。用户名只是 `/etc/passwd` 里的一行映射，内核只认数字。三文件的字段顺序要背；`getpwnam` 返回静态缓冲区，多线程用 `_r` 版本，返回 0 还要看 `*result` 是否为 `NULL`。

**第二单元，提权与降权（2.9.3–2.9.5）。** exec 一个 setuid-root 程序时，真实 UID 不变，有效与保存 UID 变成文件属主 0，capability 有效集随之变成全集。非特权进程的 `setuid` 只改有效 UID，目标必须是真实或保存 UID 之一；`setresuid(u,u,u)` 三个一起降，保存 UID 也没了，`setuid(0)` 从此 `EPERM`。降权顺序是附加组 → GID → UID → 验证：先降 UID 会丢 `CAP_SETGID`，后面的 `setgroups`/`setresgid` 全部失败。setuid 脚本在 Linux 上无效，`nosuid` 挂载也会忽略 setuid 位。

**第三单元，把 root 拆成位（2.9.6–2.9.7）。** capability 把 root 拆成独立的位（本机内核 7.0 实测 41 个）。五组集合各管一段：Permitted 是可用池，Effective 是当前生效的子集，Inheritable 要文件也声明才参与，Bounding 是上限、只能减，Ambient 让非特权程序把能力带过 exec。内核用不可变的 `struct cred` 存身份，修改走「复制—改副本—原子提交」；凭证是线程级的，glibc 负责向所有线程广播。`capable()` 查初始命名空间，`ns_capable()` 查指定命名空间——容器 root 的秘密就在这一层。

**第四单元，完整规则与收口（2.9.8–2.9.14）。** 规则矩阵把每个调用改哪些字段、非特权允许什么、失败 errno 列全；`setreuid` 会顺手改保存 UID，`setfsuid` 没有错误返回。NSS 让「用户」不再只是本地文件，`getent` 走完整查询链。setuid 程序的攻击面从环境变量延伸到 fd 0/1/2：AT_SECURE 只剥离 `LD_*` 等动态链接器变量，`PATH`/`IFS` 仍要自己清，`system()`/`popen()` 一律禁用。`no_new_privs` 一旦设置不可撤销，setuid 位与 file capability 在后续 exec 全部失效。最后十四个陷阱收口。

一句话主线：**权限是凭证的函数——四个 UID 各管一摊，setuid 在 exec 那一刻提权、按纪律降权，capability 把 root 拆成可单独授予的位，`no_new_privs` 把「不再提权」变成不可逆的承诺。**

## 每节一览

| 小节 | 核心问题 | 关键结论 | 典型陷阱 |
|:--|:--|:--|:--|
| [2.9.1](ch09.md#sec-2.9.1) | 四个 UID 各管什么 | real 管归属、effective 管检查、saved 管退路、fs 管文件 | 以为 `id` 能看到 saved；以为 UID 就是用户名 |
| [2.9.2](ch09.md#sec-2.9.2) | 用户名怎样映射到数字 | passwd 7 字段、shadow 9 字段、group 4 字段 | 把 shadow 哈希当「加密的密码」；`getpwnam_r` 返回 0 就当找到 |
| [2.9.3](ch09.md#sec-2.9.3) | setuid exec 那一刻 | ruid 不变，euid/suid 变文件属主 | 以为脚本也能 setuid；判断特权用 `getuid()` 而不是 `geteuid()` |
| [2.9.4](ch09.md#sec-2.9.4) | 非特权进程能改什么 | 只能在 real/effective/saved 之间切换 | 以为降权后 `seteuid(0)` 还能成功 |
| [2.9.5](ch09.md#sec-2.9.5) | 怎样降权才回不去 | 组 → GID → UID → 验证 `setuid(0)` 失败 | 先降 UID 丢 `CAP_SETGID`；只降 euid 留退路 |
| [2.9.6](ch09.md#sec-2.9.6) | root 怎么拆成位 | 五组集合；`+ep` 直接生效、`+p` 要自己提升 | 以为 `CapBnd` 能加回去；以为 root 永远全能力 |
| [2.9.7](ch09.md#sec-2.9.7) | 内核把身份存哪 | `struct cred` 不可变，复制后原子提交 | 以为凭证是进程级；以为容器 root 对宿主也有效 |
| [2.9.8](ch09.md#sec-2.9.8) | 每个调用的完整规则 | `setreuid` 动 saved；`setfsuid` 无错误返回 | 旧代码 `setreuid` 降权后永久丢 root；AT_SECURE 只清 `LD_*` |
| [2.9.9](ch09.md#sec-2.9.9) | 查询链与重试 | ERANGE 是重试信号；`getent` 走 NSS 全链 | `grep /etc/passwd` 查不到就以为用户不存在 |
| [2.9.10](ch09.md#sec-2.9.10) | exec 变换与 ambient | `P'=(I&F_i)\|(F_p&B)\|A'`；ambient 须在 P 与 I 中 | 以为 `+p` 自动生效；ambient 随便提升 |
| [2.9.11](ch09.md#sec-2.9.11) | 攻击面有哪些 | 环境、PATH、cwd、fd、信号、TOCTOU 都不可信 | 降权后还信任环境变量；`printf(user_input)` |
| [2.9.12](ch09.md#sec-2.9.12) | 怎么把结论变读数 | xattr 解码；uid_map 映射 | 把命名空间内的 root 当宿主机 root |
| [2.9.13](ch09.md#sec-2.9.13) | 哪些坑最常踩 | 十四陷阱现象 → 原因 → 修复 | 见正文清单 |
| [2.9.14](ch09.md#sec-2.9.14) | 出口在哪 | 七条达标线 | 展开在[自检表](ch09-checklist.md) |

## 三条判据

| 判据 | 具体要求（做不到就回右列） | 主要落点 |
|:--|:--|:--|
| **能解释** | 画出 exec setuid-root 前后四个 UID 的变化；说出非特权进程 `setuid`/`seteuid`/`setresuid` 的合法目标集合；说出五组 capability 集合各管什么、bounding 为什么只能减 | [2.9.1](ch09.md#sec-2.9.1)、[2.9.4](ch09.md#sec-2.9.4)、[2.9.6](ch09.md#sec-2.9.6) |
| **能操作** | 读出 `/proc/self/status` 四列与五个位图并用 `capsh --decode` 解码；写出「附加组 → GID → UID → 验证」的降权骨架；用 `getcap`/`stat` 分辨 setuid 与 file capability 两种特权来源 | [2.9.3](ch09.md#sec-2.9.3)、[2.9.5](ch09.md#sec-2.9.5)、[2.9.10](ch09.md#sec-2.9.10) |
| **能判断** | 给「权限被拒 / setuid 失效 / setcap 后仍无权限」现象能定位到机制；引用能力位数、调用号、挂载选项前先说清内核与架构；分清「需 root 未实测」与「实测」 | [2.9.13](ch09.md#sec-2.9.13)、[勘误页](ch09-errata.md) |

## 看到问题先选工具

| 你看到的现象 | 先选什么 | 落点 |
|:--|:--|:--|
| 权限被拒，不知缺哪个身份 | `id` 看 real/effective 与附加组；`/proc/self/status` 的 `Uid:` 四件套与 `CapEff`（`id` 看不到 saved） | [2.9.1](ch09.md#sec-2.9.1) |
| setuid 程序行为异常 | 对照有效/保存 UID 切换规则推演每步调用；`getauxval(AT_SECURE)` 判断 `LD_*` 是否被剥离 | [2.9.8](ch09.md#sec-2.9.8) |
| `setcap` 后程序仍无权限 | `getcap` 确认 xattr 在；`capsh --print` 看 bounding；`/proc/self/status` 的 `NoNewPrivs` 是否为 1 | [2.9.6](ch09.md#sec-2.9.6)、[2.9.10](ch09.md#sec-2.9.10) |
| `chmod u+s` 后提权失败 | `findmnt -T` 看 `nosuid`；`stat` 确认属主与 s 位；脚本则直接无效 | [2.9.3](ch09.md#sec-2.9.3)、[2.9.13](ch09.md#sec-2.9.13) |
| 降权后仍能读特权文件 | 查是不是只改了 euid（saved 还是 0）、附加组是不是没清 | [2.9.5](ch09.md#sec-2.9.5) |
| `id` 查得到但 `grep /etc/passwd` 查不到 | 看 `/etc/nsswitch.conf` 的查询链；用 `getent` 走 NSS 全链 | [2.9.9](ch09.md#sec-2.9.9) |
| 容器里是 root，宿主机文件却写不了 | 读 `/proc/<pid>/uid_map` 看映射；capability 只对本命名空间有效 | [2.9.7](ch09.md#sec-2.9.7)、[2.9.9](ch09.md#sec-2.9.9) |

## 只记一件事

**内核认的是凭证里的整数，不是你的名字。** 用户名只是数据库里的一行映射；权限检查读的是有效 UID、文件系统 UID 与 capability 集合。这一条记牢，setuid 为什么能提权、降权为什么要三个一起降、容器 root 为什么「不完全是 root」、`setcap` 为什么比 `chmod u+s` 更克制，就都有了同一个根。

## 六页怎么用

1. **[章总览](ch09-overview.md)**：先看四单元一览与「环境口径」，确认 aarch64、`sudo` 不可用与 AppArmor 挡用户命名空间的边界。
2. **[章末总结](ch09-summary.md)**（这一页）：合上正文读一遍，把每节一览当目录自查。
3. **[闭卷回忆卡](ch09-recall.md)**：只看问题作答，三种结果（对/含糊/错），下一轮只做含糊与错的。
4. **[习题集](ch09-exercises.md)**：A 概念、B 推理、C 实操；C 组前 6 题在这台 aarch64 VM 上真跑过，每题先猜再跑。
5. **[学习目标自检表](ch09-checklist.md)**：接管 [2.9.14 本章小结](ch09.md#sec-2.9.14)原有的七条达标线，按概念/动手/实验/口径四组逐条当场做。
6. **[勘误与版本注记](ch09-errata.md)**：能力位数、调用号、`/tmp` 挂载选项、用户命名空间可用性都随机器变，抄数字前先看这一页。

## 下一站

[2.10 信号](ch10.md) 进入异步世界：信号从产生到递送经过哪些状态，为什么处理器里只能调用 async-signal-safe 函数。往回查：[2.8 程序执行与子进程监控](ch08.md) 的 exec 保留清单是本章的直接前置（凭证跨 exec 保留正是「换程序不换身份」的默认情形）；[0.4 权限与安全模型](../part0/ch04.md) 是本章的命令行视角。

自检入口：先做[闭卷回忆卡](ch09-recall.md)，再用[学习目标自检表](ch09-checklist.md)逐条打勾；手上读数与正文对不上时，回[勘误页](ch09-errata.md)确认它是不是本来就不属于这台机器。