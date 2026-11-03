# 0.4 学习目标自检表

逐条对照。左列是目标，中列是「怎样算达标」，右列是正文依据与对应习题。卡住时回到依据列重读，不要从头再读整章。

**使用建议**：先做[章末习题](ch04-exercises.md)的 A 组，用错题定位下面几行；再回到对应小节做「即时自测」。不要机械地逐行打钩。

| 目标 | 达标检验 | 依据与习题 |
|:--|:--|:--|
| **K4.1 判定顺序** | 能按 DAC → 目录 `x` → ACL → capability → LSM/挂载 → immutable 定位拒绝 | [0.4.1](ch04.md#sec-0.4.1)；A1、B1、D1 |
| **K4.2 mode 十二位** | 能读出 setuid/setgid/sticky + rwx，解释 `4755`/`2755`/`1777` | [0.4.2](ch04.md#sec-0.4.2)、[0.4.10](ch04.md#sec-0.4.10)；A2、D2 |
| **K4.3 目录 rwx** | 能解释列名/增删项/穿过，区分“能 ls”与“能 cd” | [0.4.3](ch04.md#sec-0.4.3)、[0.4.11](ch04.md#sec-0.4.11)；A3、B2、D3 |
| **K4.4 umask** | 能算出 `666 & ~umask`/`777 & ~umask`，知道 `umask` 是去掉的位 | [0.4.4](ch04.md#sec-0.4.4)、[0.4.12](ch04.md#sec-0.4.12)；A4、C2、D4 |
| **K4.5 chmod/chown/特殊位** | 能用八进制/符号改权限，知道 setuid/setgid/sticky 的语义 | [0.4.5](ch04.md#sec-0.4.5)、[0.4.13](ch04.md#sec-0.4.13)、[0.4.14](ch04.md#sec-0.4.14)；A5、B4、D5 |
| **K4.6 ACL 与 mask** | 能用 `setfacl`/`getfacl`，解释 mask 与 `ls -l` group 三位 | [0.4.6](ch04.md#sec-0.4.6)、[0.4.15](ch04.md#sec-0.4.15)；A6、B6、C3、D6 |
| **K4.7 capability** | 能说出五个集合，解释 `ping` 为什么用 `cap_net_raw` | [0.4.7](ch04.md#sec-0.4.7)、[0.4.16](ch04.md#sec-0.4.16)；A7、C4、D7 |
| **K4.8 账号文件** | 能读出 `passwd`/`shadow`/`group` 字段，知道 `x` 的含义 | [0.4.8](ch04.md#sec-0.4.8)、[0.4.17](ch04.md#sec-0.4.17)；A8、D8 |
| **K4.9 sudo** | 能解释 `sudoers` 结构、`secure_path`、为什么不是沙箱 | [0.4.8](ch04.md#sec-0.4.8)、[0.4.19](ch04.md#sec-0.4.19)；B5、D9 |
| **K4.10 内核判定路径** | 能说出 `fsuid`/`fsgid`、mode、ACL、capability 的判定顺序 | [0.4.10](ch04.md#sec-0.4.10)；D11 |
| **K4.11 sticky** | 能解释 `/tmp` `1777` 与删除/重命名的 owner 检查 | [0.4.11](ch04.md#sec-0.4.11)；B3、D10 |
| **K4.12 umask 来源** | 能说出 shell、登录配置、systemd/PAM 三个来源与优先级 | [0.4.12](ch04.md#sec-0.4.12)；A4、D4 |
| **K4.13 setuid 边界** | 能解释 euid 切换、脚本 setuid 无效、capability 替代 | [0.4.14](ch04.md#sec-0.4.14)；A5、B4、D5 |
| **K4.14 默认 ACL** | 能解释目录默认 ACL 的继承与 mask | [0.4.15](ch04.md#sec-0.4.15)；A6、C3、D6 |
| **K4.15 capability 集合** | 能区分 inheritable/permitted/effective/bounding/ambient | [0.4.16](ch04.md#sec-0.4.16)；A7、C4、D7 |
| **K4.16 shadow 字段** | 能读出九个字段与 `chage`/`passwd -S` 的关系 | [0.4.17](ch04.md#sec-0.4.17)；A8、D8 |
| **K4.17 sudoers** | 能写 `user host=(runas) commands`，知道 `sudo -l`/`visudo` | [0.4.19](ch04.md#sec-0.4.19)；B5、D9 |
| **S4.1 凭证取证** | 能用 `strace` 看到 `setresuid`/`setresgid`/`execve` | [0.4.20](ch04.md#sec-0.4.20)；C1 |
| **S4.2 ACL 取证** | 能用 `getfacl`/`getfattr`/`strace setxattr` 证明 ACL 在 xattr | [0.4.20](ch04.md#sec-0.4.20)；C3 |
| **S4.3 capability 取证** | 能用 `getcap`/`getpcaps`/`capsh --decode` 读能力 | [0.4.20](ch04.md#sec-0.4.20)；C4 |
| **S4.4 权限审计** | 能写只读审计脚本，找 world-writable/无主/setuid，排除虚拟文件系统 | [0.4.21](ch04.md#sec-0.4.21)；C5 |
| **A4.1 版本与发行版差异** | 能说出 `ping`、`sudo`、`umask` 来源在不同发行版的差异 | [0.4.7](ch04.md#sec-0.4.7)、[0.4.12](ch04.md#sec-0.4.12)；C4 |
| **A4.2 证据优先** | 遇到权限问题先 `namei`/`getfacl`/`getcap`/`strace`，不靠 777 试错 | 全章实验；C1–C5 |

## 没达标怎么办

- **K 类卡住**：回到对应小节的「小结」和「即时自测」，先把判定顺序或 mode 十二位讲一遍。
- **S 类卡住**：在虚拟机里重跑对应实验，把 `namei`/`getfacl`/`getcap`/`strace` 的真实输出贴进笔记。
- **A 类卡住**：做 B 组诊断题，强迫自己写出「现象 → 层 → 证据 → 修复」的链条。

全部达标后，进入 [0.5 重定向、管道与文本流](ch05.md)。
