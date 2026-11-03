# 0.1 勘误与版本注记

这一页收本章最容易「记成永久真理」的版本敏感事实与跨层误判。正文里的 `errata` 盒讲的是理解陷阱；这一页讲的是**换版本、换发行版、换架构后要复核什么**。

**本章基线**：Ubuntu 24.04、Linux 6.8、glibc 2.39、systemd 255、bash 5.2。换环境时逐条复核。

## 1. 版本与身份

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 1 | `uname -o` 输出 `Linux` | 多数 GNU 用户态输出 `GNU/Linux`；`uname` 本身来自 coreutils | `uname -o`、`uname --version` |
| 2 | `6.8.0-45-generic` 是上游第 45 版 | `6.8.0` 是上游基线，`-45` 是发行版 ABI 编号，`generic` 是配置风味 | `uname -v`、`/boot/config-$(uname -r)` |
| 3 | 发行版 24.04 就一定跑 6.8 内核 | GA/HWE 轨道、云镜像、容器宿主、手动降级都会造成新用户态配旧内核 | `uname -r` 与 `/etc/os-release` 分开看 |
| 4 | 容器里的 `uname -r` 是容器内核 | 容器共享宿主机内核；namespace 只改视图 | 宿主机与容器各跑一次 `uname -r` |
| 5 | `lsb_release` 是通用命令 | LSB 基本废弃，很多新系统不装；`/etc/os-release` 更可靠 | `command -v lsb_release`、`cat /etc/os-release` |

## 2. 标准与二进制

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 6 | POSIX 认证 = 行为完全一致 | POSIX 只保证源码级接口；性能、错误文本、扩展、默认配置都不保证 | `getconf`、`posixoptions`、`grep -P` 是否可用 |
| 7 | 源码能编译，二进制就能随便拷 | 二进制兼容取决于架构、libc、动态加载器路径、符号版本 | `file`、`readelf -l`、`ldd` |
| 8 | `ldd` 只是「看依赖」 | `ldd` 会设置 `LD_TRACE_LOADED_OBJECTS` 并执行 loader；来源不明的文件有风险 | 改用 `readelf -d`、`objdump -p` |
| 9 | 页大小就是 4096 | 页大小随架构与内核配置变化（ARM64 可为 4/16/64 KiB） | `getconf PAGE_SIZE`、`sysconf(_SC_PAGESIZE)` |
| 10 | `/bin` 一定是真实目录 | usrmerge 后 `/bin`、`/sbin`、`/lib` 常是指向 `/usr` 的符号链接 | `ls -ld /bin`、`readlink -f /bin/sh` |

## 3. 模块、启动与系统调用

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 11 | `lsmod` 没有就是没编进内核 | 内建模块不出现在 `lsmod` | `grep -w <m> /lib/modules/$(uname -r)/modules.builtin`、`modinfo -F filename <m>` |
| 12 | `modinfo` 的 `depends:` 为空 = 没有依赖 | 元数据没声明，不代表运行时符号都能解析；`vermagic` 不符也会报 `Unknown symbol` | `modinfo -F vermagic <m>`、`dmesg`、`modprobe --show-depends` |
| 13 | 卸载模块失败是权限问题 | 多数是 `EBUSY`：引用计数不为零 | `cat /sys/module/<m>/refcnt`、`lsmod` 第三列 |
| 14 | 改 `grub.cfg` 就行 | 它是生成物，升级会重写；应改 `/etc/default/grub` 再 `update-grub`/`grub2-mkconfig` | `grep menuentry /boot/grub/grub.cfg`、`cat /etc/default/grub` |
| 15 | `syscall()` 返回 -1 就是内核返回 -1 | 内核返回 `-errno`；glibc 翻译成 `-1` 并设置 `errno` | 裸汇编看返回寄存器；`strace` 看调用 |
| 16 | `strace` 没看到 `clock_gettime` 就是没调用 | vDSO 在用户态完成，不陷入内核 | `ldd` 里有 `linux-vdso.so.1` |
| 17 | `init=/bin/bash` 等于单用户模式 | 它跳过 systemd，没有服务、没有 `/proc`，根可能只读 | 启动后 `mount`、`ps`、`ls /proc` |
| 18 | FHS 是内核强制 | FHS 是约定；内核只认挂载点与 inode | `man 7 hier`、`man 7 file-hierarchy` |

## 4. 本章未实测项

以下结论来自文档与源码，但未在本书写作环境逐条复跑；在别的发行版/内核上使用前先验证：

- `vm.vdso_enabled` 在 6.x 内核上可能不存在；正文实验已给出「不存在」的分支。
- `efibootmgr`、`lsinitramfs`、`mokutil` 在最小化系统上可能未安装；实验脚本已做跳过处理。
- 系统调用号（x86-64 `getpid=39`、ARM64 `getpid=172`）以当前内核头文件为准；交叉编译时用 `SYS_*` 宏，不写死数字。
- 发行版支持周期（Ubuntu 5 年、RHEL 10 年、Fedora 约 13 个月）是量级，具体日期以厂商公告为准。

## 5. 发现新问题怎么记

如果你在别的版本上发现本章结论不成立，按「现象 → 命令/输出 → 涉及的内核/发行版版本 → 建议改法」记到 issue 或笔记里；不要只写「我这里不对」。这张表下一轮会按同一格式增补。
