# 0.4 勘误与版本注记

这一页收本章最容易「记成永久真理」的版本敏感事实与权限陷阱。正文里的 `errata` 盒讲理解陷阱；这一页讲**换发行版、换内核、换文件系统后要复核什么**。

**本章基线**：Ubuntu 24.04、Linux 6.8、glibc 2.39、sudo 1.9.15、libcap 2.66、acl 2.3.2。换环境时逐条复核。

## 1. mode、目录与 umask

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 1 | `chmod 777` 能解决所有拒绝 | 777 只改 DAC mode；ACL mask、capability、LSM、只读挂载、immutable 仍能拒绝 | `namei -l`、`getfacl`、`getcap`、`findmnt -T`、`lsattr` |
| 2 | 目录 `r` 就是“能进目录” | `r` 只列名，`x` 才能穿过/访问子项 | `ls -ld`、`cd` 测试 |
| 3 | `umask` 是“授予的权限” | 它是“去掉的位”；新文件 `666 & ~umask`，新目录 `777 & ~umask` | `umask`、`umask -S`、`touch` 后 `stat` |
| 4 | `umask` 只有 shell 一个来源 | 还受登录配置、PAM `pam_umask`、systemd `UMask=` 影响 | `grep -R umask /etc/profile* /etc/login.defs /etc/pam.d`；`systemctl show user@*.service -p UMask` |
| 5 | `chmod +s` 在脚本上能提权 | Linux 忽略脚本的 setuid/setgid；解释器以调用者身份运行 | `chmod 4755 script.sh; ./script.sh; id` |
| 6 | `chown` 普通用户也能改 owner | 需要 root 或 `CAP_CHOWN`；普通用户只能改自己文件的组（且须是成员） | `chown` 报错、`capsh --print` |

## 2. ACL、capability 与账号

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 7 | ACL 是 mode 的另一种写法 | ACL 存在 `system.posix_acl_access` xattr；mask 是有效权限上限 | `getfacl -n`、`getfattr -n system.posix_acl_access -e hex` |
| 8 | `ls -l` 的 group 三位就是组权限 | 有 ACL 时它显示 mask，不是 group 权限 | `getfacl` 对比 `ls -l` |
| 9 | ACL 设了就一定生效 | mask、目录 `x`、文件系统 `acl` 选项、LSM 都可能挡住 | `getfacl` 看 `mask::`、`namei -l`、`mount` |
| 10 | capability 等于 root | capability 是拆分的特权；还受 bounding set、LSM、文件系统限制 | `capsh --print`、`getpcaps`、`getcap -r /` |
| 11 | `ping` 仍然 setuid root | 现代发行版多用 `cap_net_raw=ep`；不同发行版可能仍 setuid | `getcap $(command -v ping)`、`ls -l $(command -v ping)` |
| 12 | `sudo` 是沙箱 | 它以目标用户权限运行命令；被授权命令能读写系统 | `sudo -l`、`sudo -u nobody id`、`secure_path` |
| 13 | `sudo -E` 一定保留 `PATH` | `secure_path` 会覆盖；`-E` 受 sudoers 的 `env_reset`/`SETENV` 限制 | `sudo -l`、`sudo env | grep PATH` |
| 14 | `/etc/passwd` 的 `x` 是密码 | `x` 表示哈希在 `/etc/shadow`；字段是 `name:password:uid:gid:gecos:home:shell` | `man 5 passwd`、`man 5 shadow` |

## 3. 内核与 LSM

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 15 | root 能绕过一切 | LSM（SELinux/AppArmor）、immutable、只读挂载、`noexec`、capability bounding set 仍能阻止 | `ausearch -m avc`、`lsattr`、`findmnt`、`capsh` |
| 16 | sticky 位让目录“不可写” | `/tmp` `1777` 所有人可写；sticky 只限制删除/重命名的 owner 检查 | `ls -ld /tmp`、`rm` 测试 |
| 17 | `setuid` 一定改 euid | 需要文件系统 `suid` 挂载、非 `nosuid`、可执行位；脚本被忽略 | `findmnt -T`、`ls -l`、`id` |
| 18 | 权限判定只看文件 mode | 内核用 `fsuid`/`fsgid`、mode、ACL、capability、LSM 逐层判定 | `strace -e setresuid,setresgid`、`capsh`、`dmesg` |

## 4. 本章未实测项

以下结论来自文档与常见行为，但未在本书写作环境逐条复跑；在别的发行版/文件系统上使用前先验证：

- `ping` 的 capability 与 setuid 状态因发行版/版本而异；以 `getcap`/`ls -l` 为准。
- `sudo` 的 `secure_path`、`env_reset`、`SETENV` 默认值随版本与发行版变化；以 `sudo -l` 与 `sudoers(5)` 为准。
- `umask` 的 systemd/PAM 来源在不同发行版配置不同；以 `systemctl show` 与 `/etc/pam.d` 为准。
- ACL 支持依赖文件系统挂载选项 `acl`；tmpfs/overlayfs 行為可能不同，`getfacl` 会报错或不显示。
- capability 的 ambient/bounding 行为依赖内核版本；`capsh --print` 与 `man 7 capabilities` 为准。

## 5. 发现新问题怎么记

如果你在别的发行版/文件系统上发现本章结论不成立，按「现象 → 命令/输出 → 发行版与内核版本 → 建议改法」记到 issue 或笔记里；不要只写「我这里不对」。这张表下一轮会按同一格式增补。
