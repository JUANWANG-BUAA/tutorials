# 0.1 习题集

三组分层：A 组概念判断（口答即可）、B 组推理诊断（写出步骤）、C 组动手实验（在虚拟机里跑）。**全部附解答**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；
2. 卡住了，回到对应小节的「即时自测」重读，不要直接看答案；
3. 做完再对照解答，重点看自己卡在哪一步；
4. 做错的题记一个记号，三天后只重做记号题。

| 组 | 定位 | 建议时长 | 卡壳时去哪 |
|:--|:--|:--|:--|
| **A 组**（8 题） | 概念判断，口答 | 每题 1–2 分钟 | 对应小节的「小结」 |
| **B 组**（6 题） | 推理诊断，写出步骤 | 每题 8–12 分钟 | 对应小节的例子与 `errata` |
| **C 组**（5 题） | 动手实验，记录输出 | 每题 10–20 分钟 | 对应小节的命令块 |

## A 组 · 概念判断

::: ex A1 · Linux 是操作系统还是内核？

“Linux 是一个操作系统”这句话在什么语境下成立、在什么语境下会误导人？完整系统还需要哪些部分？

::: sol 解答

严格说 Linux 是**内核**。完整系统还需要 C 库（glibc/musl）、Shell、coreutils、包管理器、init 系统与默认配置，也就是发行版。日常说「Linux 系统」通常指发行版；排障时要把内核行为、libc 行为、发行版策略分开，否则会把三类完全不同的问题混在一起。`uname -o` 输出 `GNU/Linux` 就是在提醒用户态主要来自 GNU。
:::
:::

::: ex A2 · 三个版本号

`uname -r`、`ldd --version`、`/etc/os-release` 各回答什么问题？为什么可以出现「新发行版 + 旧内核」？

::: sol 解答

`uname -r` 回答内核版本与发行版 ABI 编号；`ldd --version` 回答 C 库版本；`/etc/os-release` 回答用户态发行版版本。三者独立维护：Ubuntu 的 GA/HWE 内核轨道、云厂商自定义镜像、容器宿主、手动降级都会造成新用户态配旧内核。判断内核能力看 `uname -r`，判断用户态与包版本看 `/etc/os-release`。
:::
:::

::: ex A3 · 内核不管什么？

列出至少三件「不是内核提供」的事，并说明分别由谁提供。

::: sol 解答

① `printf`/`malloc`/`fopen`：由 glibc 或 musl 提供，内核只有 `write`、`brk`/`mmap`、`open`；② 管道符 `|`、通配符 `*`、引号、变量展开：由 Shell 提供，内核只看到展开后的 `argv`；③ `apt`、`systemctl`、`ps`：用户态程序，通过 `/proc`、`/sys`、D-Bus 与内核或守护进程对话；④ 「开机自启」「日志轮转」「防火墙默认拒绝」：发行版策略，由 systemd、logrotate、nftables 规则实现。
:::
:::

::: ex A4 · POSIX 保证与不保证

POSIX 保证什么？至少举两项不保证的内容，并各给一个例子。

::: sol 解答

POSIX 保证系统调用、C 库接口、Shell 语法与工具行为的**源码级**可移植。不保证：性能（同一 `read` 在不同内核上快慢不同）、错误文本（`strerror` 内容可变）、扩展接口（`epoll`、`signalfd`、`inotify`、`O_TMPFILE` 不在 POSIX）、默认配置（`umask`、防火墙、`sudo` 组）。所以「POSIX 认证」不等于「行为完全一致」。
:::
:::

::: ex A5 · 内建还是模块？

`lsmod` 里没有 `ext4`，但根文件系统是 ext4。这矛盾吗？给出两条验证命令。

::: sol 解答

不矛盾。`ext4` 很可能被编进内核（built-in），内建模块不出现在 `lsmod`。验证：`grep -w ext4 /lib/modules/$(uname -r)/modules.builtin`；`modinfo -F filename ext4` 看是否输出 `(builtin)`；也可以 `grep -w ext4 /proc/filesystems`。`lsmod` 只列已加载的可加载模块。
:::
:::

::: ex A6 · 容器与内核

为什么容器里不能「升级内核」？需要不同内核时应该用什么？

::: sol 解答

容器与宿主机共享同一个内核；namespace 改变进程看到的视图（PID、网络、挂载、用户等），cgroup 限制资源，但都不替换内核。容器里的 `uname -r` 是宿主机内核。需要不同内核时用虚拟机（或独立物理机），不要试图在容器里换内核。
:::
:::

::: ex A7 · `syscall()` 与 `write()`

`syscall(SYS_write, ...)` 与 `write(...)` 在返回值、`errno`、缓冲和取消点上有什么不同？

::: sol 解答

`write()` 是 glibc 包装：把参数放进寄存器、执行陷入指令、把内核的 `-errno` 翻译成 `-1` 并设置线程局部 `errno`；它还可能参与 pthread 取消点、`EINTR` 重启和符号版本处理。`syscall(SYS_write, ...)` 绕过大部分包装，直接发系统调用；glibc 仍会把负返回值翻译成 `-1` 并设置 `errno`，但不会经过 stdio 缓冲，也不具备 `write()` 的取消点语义。裸汇编则完全没有 `errno`，只有返回寄存器里的负值。
:::
:::

::: ex A8 · FHS 与可变性

用「可变性」解释 `/etc`、`/var`、`/run`、`/usr` 的分工，并给一个放错目录的后果。

::: sol 解答

`/etc` 放主机配置，需要管理员修改并持久化；`/var` 放可变状态（日志、缓存、队列、数据库），需要持久化与备份；`/run` 放本次启动的运行时状态（tmpfs），重启即清；`/usr` 放只读的程序、库和共享数据，随包升级、可整体做镜像。放错例子：把数据库放到 `/run`，重启数据全丢；把日志放到 `/usr`，只读根或镜像升级时写失败；把配置放到 `/usr/lib`，被 `/etc` 同名文件覆盖或升级时丢失。
:::
:::

## B 组 · 推理诊断

::: ex B1 · 新发行版配旧内核

一台机器 `uname -r` 是 `5.15.0-119-generic`，`/etc/os-release` 的 `VERSION_ID=24.04`。它跑的是 5.15 还是 6.8 内核？列出至少三种造成这种组合的原因，并说明怎样判断某个内核特性是否存在。

::: sol 解答

跑的是 5.15 内核。`/etc/os-release` 描述用户态发行版，内核可以独立升级或降级。常见原因：① Ubuntu 的 GA 内核轨道（24.04 初始 GA 可能是较旧内核）与 HWE 轨道并存；② 云厂商自定义镜像锁定内核；③ 容器/虚拟化宿主的内核与镜像用户态不同；④ 手动安装或 hold 了旧内核。判断特性是否存在：看 `uname -r` 的主次版本，再查 `/boot/config-$(uname -r)` 与发行版 backport 说明（Ubuntu USN、RHEL RHSA），不要只看发行版号。
:::
:::

::: ex B2 · Ubuntu 二进制在 Alpine 报 not found

你把 Ubuntu 上编译的动态链接二进制复制到 Alpine 容器，执行时报 `not found`，但 `ls` 能看到文件。按「四层」逐步诊断，给出至少三条命令。

::: sol 解答

`not found` 通常不是文件不存在，而是**动态加载器不存在**。① `file ./app` 看 `interpreter`，Ubuntu 二进制通常指向 `/lib64/ld-linux-x86-64.so.2`；② `readelf -l ./app | grep interpreter` 确认路径；③ 在 Alpine 里 `ls -l /lib64/ld-linux-x86-64.so.2`，通常不存在（musl 用 `/lib/ld-musl-x86_64.so.1`）；④ `ldd ./app` 可能直接报 `not found`。修复：在 Alpine 里装 `gcompat`/`libc6-compat`，或改用 musl 重新编译，或使用静态链接/多阶段构建。不要用 `LD_LIBRARY_PATH` 修，因为它改不了编译时写死的 interpreter 路径。
:::
:::

::: ex B3 · ping 通但 curl 超时

`ping example.com` 能通，`curl https://example.com` 超时。按本章分层列出至少三个可能出问题的层，并给每层第一条验证命令。

::: sol 解答

`ping` 只验证 ICMP 可达，不验证 TCP 443、DNS 或 TLS。① 链路/地址层：`ip -br addr`；② 路由层：`ip route get 1.1.1.1`；③ DNS 层：`getent hosts example.com` 或 `dig example.com`；④ 端口/防火墙层：`nc -vz example.com 443`；⑤ TLS/应用层：`curl -v --max-time 10 https://example.com`。常见根因：DNS 解析失败、防火墙只放 ICMP、代理环境变量、TLS 证书/时间不同步。
:::
:::

::: ex B4 · `Unknown symbol in module`

`modprobe foo` 报 `Unknown symbol in module`，但 `modinfo foo` 的 `depends:` 为空。最可能是什么原因？给出三条排查命令。

::: sol 解答

`depends:` 为空只说明模块元数据没声明依赖，不代表运行时符号都能解析。常见原因：① 模块与当前内核版本不匹配（`vermagic` 不符）；② 依赖的符号属于另一个未加载模块；③ 编译时用了不同内核配置，符号被裁剪；④ Secure Boot 拒绝未签名模块。排查：`modinfo -F vermagic foo` 对比 `uname -r`；`dmesg | tail -30` 看完整报错；`modprobe --show-depends foo` 看依赖解析；`modinfo -F signer foo` 看签名者。
:::
:::

::: ex B5 · 改了 unit 不生效

你改了 `/usr/lib/systemd/system/ssh.service`，`systemctl daemon-reload` 后仍不生效。为什么？给出两条查最终配置的命令。

::: sol 解答

`/usr/lib/systemd/system/` 是包安装的默认配置；`/etc/systemd/system/` 下的同名文件或 drop-in 优先级更高，会覆盖它。正确做法是改 `/etc/systemd/system/ssh.service.d/*.conf` 或 `systemctl edit ssh.service`。查最终配置：`systemctl cat ssh.service`（列出所有来源片段）；`systemd-analyze cat-config systemd/system.conf` 或 `systemd-analyze verify ssh.service`。不要直接改包文件，升级会被覆盖。
:::
:::

::: ex B6 · 页大小不是常量

为什么写底层代码时要用 `sysconf(_SC_PAGESIZE)` 而不是字面量 `4096`？举一个跨架构的后果。

::: sol 解答

页大小是内核配置与架构相关的运行时参数：x86-64 通常 4 KiB，ARM64 可以是 4/16/64 KiB，某些配置还会变。写死 4096 会在 16 KiB 页的系统上导致对齐错误、`mmap` 失败、按页估算的内存/文件大小差 4 倍，甚至越界。正确做法：`long ps = sysconf(_SC_PAGESIZE);`，所有对齐、取整、块数计算都用 `ps`。命令行对应 `getconf PAGE_SIZE`。
:::
:::

## C 组 · 动手实验

::: ex C1 · 做一张机器身份卡

写一个 bash 脚本，输出内核、架构、页大小、发行版 ID/版本、libc 版本；字段缺失时给 `unknown`，不要因缺字段退出。

::: sol 解答

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ -r /etc/os-release ]]; then
    # /etc/os-release 是 shell 变量格式，source 比 grep+cut 稳
    . /etc/os-release
fi

printf 'kernel=%s arch=%s page=%s\n' \
    "$(uname -r)" "$(uname -m)" "$(getconf PAGE_SIZE)"
printf 'distro=%s version=%s like=%s\n' \
    "${ID:-unknown}" "${VERSION_ID:-unknown}" "${ID_LIKE:-none}"
printf 'libc=%s\n' "$(ldd --version 2>/dev/null | head -1 || echo unknown)"
```

关键点：`[[ -r ... ]]` 先确认可读；`${ID:-unknown}` 给缺失字段兜底；所有命令替换加引号，防止值里有空格。Ubuntu、Fedora、Alpine 都能跑，只是输出不同。
:::
:::

::: ex C2 · 用 `strace` 拆一条命令

运行 `strace -f -e trace=execve,openat,getdents64,write ls /etc >/dev/null`，指出 `execve`、第一个 `openat`、`getdents64`、`write` 各做什么。

::: sol 解答

`execve` 把 `/usr/bin/ls` 装入当前进程，替换 Shell 子进程的地址空间；第一个 `openat` 通常是加载器打开 `/etc/ld.so.cache` 找库，此时 `ls` 的 `main` 还没开始；`getdents64` 读目录项，内容由内核文件系统代码提供；`write(1, ...)` 把格式化结果写到标准输出。注意 `ls` 不直接读磁盘，目录内容可能来自页缓存；`strace` 只覆盖系统调用入口，看不到 vDSO、缺页、调度和中断。
:::
:::

::: ex C3 · 判断内建还是模块

选一个你机器上的功能（如 `ext4`、`loop`、`nvme`），用三条命令判断它是内建、可加载还是未编译，并解释输出。

::: sol 解答

以 `ext4` 为例：

```bash
grep -w ext4 "/lib/modules/$(uname -r)/modules.builtin" && echo builtin || echo "not builtin"
modinfo -F filename ext4 2>/dev/null || echo "no ext4.ko"
grep -w ext4 /proc/filesystems || echo "not supported"
```

`modules.builtin` 命中 → 编进内核；`modinfo` 输出 `(builtin)` → 内建，输出 `.ko`/`.ko.zst` 路径 → 可加载；两者都没有但 `/proc/filesystems` 有 → 可能通过其他名字/模块提供；三者都没有 → 当前内核不支持。以本机输出为准，不要背结论。
:::
:::

::: ex C4 · 画本机启动链路

用五条命令给本机启动链路各取一条证据，写成一个五行摘要。

::: sol 解答

```bash
ls -d /sys/firmware/efi && echo UEFI || echo BIOS        # 1 固件
grep -m1 menuentry /boot/grub/grub.cfg 2>/dev/null || true  # 2 引导器
cat /proc/cmdline                                          # 3 内核
lsinitramfs "/boot/initrd.img-$(uname -r)" | head -5        # 4 initramfs
systemctl get-default; systemd-analyze | head -2            # 5 init
```

摘要示例：`firmware=UEFI; loader=grub; kernel=6.8.0-45-generic; initramfs=...; init=systemd (graphical.target)`。排障时先找「最后一段有证据的地方」，问题在它和下一段之间；不要一上来就翻 `journalctl`。
:::
:::

::: ex C5 · 裸系统调用与 libc 包装

写一个 C 程序，分别用 `write()` 和 `syscall(SYS_write, ...)` 输出同一句话，再用 `syscall(SYS_openat, ...)` 打开一个不存在的文件，打印返回值与 `errno`。编译并运行，解释差异。

::: sol 解答

```c
/* rawio.c —— 对比 libc 包装与裸系统调用 */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/syscall.h>
#include <unistd.h>

int main(void)
{
    const char msg[] = "hello\n";

    errno = 0;
    ssize_t n = write(STDOUT_FILENO, msg, sizeof msg - 1);
    printf("write       = %zd, errno=%d\n", n, errno);

    errno = 0;
    long r = syscall(SYS_write, STDOUT_FILENO, msg, sizeof msg - 1);
    printf("syscall write = %ld, errno=%d\n", r, errno);

    errno = 0;
    r = syscall(SYS_openat, AT_FDCWD, "/no/such/file", O_RDONLY, 0);
    printf("raw openat  = %ld, errno=%d (%s)\n", r, errno, strerror(errno));

    errno = 0;
    int fd = open("/no/such/file", O_RDONLY);
    printf("libc open   = %d, errno=%d (%s)\n", fd, errno, strerror(errno));
    return 0;
}
```

编译：`cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 -g rawio.c -o rawio`。成功的 `write` 两次都返回写入字节数；失败时 glibc 的 `syscall()` 与 `write()`/`open()` 都返回 `-1` 并设置 `errno=ENOENT`。区别在路径：`write()` 经过 glibc 包装（取消点、`EINTR` 重启等），`syscall()` 绕过大部分包装；裸汇编才会看到内核原始的 `-ENOENT`。`strace` 里两者都显示为 `write`/`openat`，因为它是按系统调用号反解的。
:::
:::
