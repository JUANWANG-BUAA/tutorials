# 0.4 章末总结

## 五单元一览

| 单元 | 核心问题 | 关键结论 | 典型陷阱 |
|:--|:--|:--|:--|
| **一、先定位是哪一层**（0.4.1） | `Permission denied` 到底卡在哪？ | 先看 DAC mode 与目录 `x`，再看 ACL、capability、sudo/LSM、挂载 `ro`/`noexec`、immutable；每层都有不同证据。 | 一上来 `chmod 777`；只看文件 mode 不看目录 `x`；把 LSM 拒绝当 DAC。 |
| **二、mode、目录与 umask**（0.4.2–0.4.5） | 十二位各是什么？新文件权限从哪来？ | mode 含 setuid/setgid/sticky + owner/group/other 的 rwx；目录 `r` 列名、`w` 增删项、`x` 穿过；新文件 `666 & ~umask`，新目录 `777 & ~umask`。 | 把目录 `r` 当“能进目录”；把 `umask` 当权限掩码而不是“去掉的位”；忘了 setuid 在脚本上无效。 |
| **三、特殊授权与账号**（0.4.6–0.4.9） | 怎样给单个人/单个程序开小灶？ | ACL 给单用户/组授权，mask 限制有效权限；capability 把 root 拆成小块；`passwd`/`shadow`/`group` 存账号；`sudo` 按策略提权，不是沙箱。 | 把 ACL 当 mode 的同义词；以为 capability 等于 root；把 `sudo` 当隔离环境。 |
| **四、位级结构与判定路径**（0.4.10–0.4.19） | 内核到底怎样判定？ | 内核按 `fsuid`/`fsgid` 与 inode mode、ACL、capability 逐层判定；sticky 限制删除/重命名；setuid 改变 euid；ACL 存在 xattr；capability 有五集合；`sudo` 配置有 `secure_path`。 | 以为 root 绕过一切；忽略 `noexec`/`ro`；以为 setuid 脚本可用；忽略 ACL mask。 |
| **五、实验与脚本**（0.4.20–0.4.22） | 怎样证明是这一层？ | `strace` 看 `setresuid`/`setxattr`/`setcap`；`getfacl`/`capsh` 看状态；审计脚本找 world-writable、无主、setuid。 | 不做 dry-run；审计脚本误报/漏报；不检查挂载与 LSM。 |

## 一条主线

这一章分两遍。**第一遍先会用**：拿到一次 `Permission denied`，先按 DAC → 目录 `x` → ACL → capability → sudo/LSM 的顺序定位；然后学会 mode 十二位、目录的 `r/w/x`、`umask`、`chmod`/`chown`/特殊位；再用 ACL、capability、账号与 `sudo` 处理特殊授权。**第二遍看内核与边界**：mode 的位级结构、内核判定路径、目录/sticky、umask 的三个来源、setuid 的真实边界、ACL 的 mask 与默认 ACL、capability 的五个集合、`passwd`/`shadow`/`group` 字段、`sudoers` 的结构。**最后用三个实验、两个脚本与陷阱清单收口。**

## 看到问题先选工具

| 症状 | 第一动作 | 为什么 |
|:--|:--|:--|
| `Permission denied` | `namei -l <path>`、`ls -ld` 逐级看 | 可能是目录缺 `x`、ACL、capability、LSM 或只读挂载。 |
| `chmod 777` 后仍拒绝 | 看 ACL、capability、LSM、挂载 | DAC 不是唯一层；ACL mask 可能限制有效权限。 |
| 新文件权限不对 | `umask`、`umask -S` | 新文件 = `666 & ~umask`，新目录 = `777 & ~umask`。 |
| 目录能读不能进 | `ls -ld` 看 `x` | 目录 `r` 列名，`x` 才能穿过/访问子项。 |
| 共享目录别人删我文件 | 看 sticky bit（`/tmp` 1777） | sticky 只允许 owner/root 删除或重命名。 |
| `ping` 不再是 setuid | `getcap $(command -v ping)` | 现代发行版用 `cap_net_raw` 替代 setuid root。 |
| `sudo` 找不到命令 | `sudo -l`、`secure_path` | `sudo` 默认重置 `PATH`；用绝对路径或改 sudoers。 |
| setuid 脚本不生效 | 用编译后的二进制或 capability | Linux 忽略脚本上的 setuid 位。 |
| ACL 设了却没生效 | `getfacl` 看 `mask` | mask 是 ACL 有效权限的上限；`setfacl -m m::rwx` 调整。 |
| 审计脚本误报 | 排除 `/proc`/`/sys`/容器挂载 | 虚拟文件系统与挂载属性会造成假阳性。 |

## 能否讲出这八句话

1. `Permission denied` 先看目录的 `x`，再看文件 mode，然后才是 ACL、capability、LSM 与挂载。
2. mode 的十二位是 setuid/setgid/sticky + owner/group/other 的 `rwx`；目录的 `r`、`w`、`x` 是三种不同能力。
3. 新文件权限是 `666 & ~umask`，新目录是 `777 & ~umask`；`umask` 是“去掉的位”，不是“授予的位”。
4. `chmod` 改 mode，`chown` 改 owner/group；setuid 让程序以文件 owner 的 euid 运行，Linux 忽略脚本上的 setuid。
5. ACL 给单用户/组授权，存在 `system.posix_acl_access` xattr 里；mask 是 ACL 有效权限的上限。
6. capability 把 root 的特权拆成小块；`ping` 用 `cap_net_raw` 而不是 setuid root；capability 有 inheritable/permitted/effective/bounding/ambient 五集合。
7. `passwd`/`shadow`/`group` 分别存账号、密码哈希与组；`sudo` 按 `sudoers` 策略提权，有 `secure_path`，不是沙箱。
8. sticky bit 只允许文件 owner/目录 owner/root 删除或重命名；`/tmp` 的 `1777` 就是例子。

## 学完之后

1. **[闭卷回忆卡](ch04-recall.md)**：先合上正文，把判定顺序、mode 十二位、umask、ACL、capability、sudo 六组结论从空白纸上叫出来。
2. **[习题集](ch04-exercises.md)**：A 组检查概念，B 组诊断“为什么 777 还不行/为什么删不掉/为什么 sudo 找不到”，C 组做 setuid、ACL、capability 实验。
3. **[学习目标自检表](ch04-checklist.md)**：把卡住的点对到正文小节和习题，回到那一节重读。
4. **[勘误与版本注记](ch04-errata.md)**：把 capability、`sudo`、`umask` 来源、`ping` 的版本差异过一遍。
5. **下一站**：[0.5 重定向、管道与文本流](ch05.md) 会回到 fd 表；本章的 `open` 权限判定会在那里与 fd 复制接上。
