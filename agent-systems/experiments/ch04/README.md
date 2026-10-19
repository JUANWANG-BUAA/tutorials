# 第 4 章实验：把权限一层层丢掉

这个目录有三个可运行件：一个 C 加固程序、一个 Linux 验证脚本、一个 `/proc` 检查器。
前两个依赖 Linux 内核接口，**本机 macOS 只能做语法/存在性检查，不能运行**；第三个
在 macOS 上会明确跳过并以 0 退出，便于放进跨平台测试矩阵。

## 文件

| 文件 | 作用 | 依赖 |
|:--|:--|:--|
| `harden.c` | no_new_privs → 清 capability →（可选）landlock → seccomp 白名单，然后尝试 `open("/etc/passwd")` 并打印 errno | Linux 6.8 头文件、gcc/clang、`linux/landlock.h` |
| `verify-linux.sh` | 在 Linux 上编译 `harden.c`、跑两种模式、核对预期输出；macOS 上打印跳过原因并 `exit 1` | bash、cc、grep |
| `inspect_linux.py` | 解析 `/proc/<pid>/status` 的 Cap*/Seccomp/NoNewPrivs；非 Linux 平台打印提示并 `exit 0` | Python 3.11+ 标准库 |

## 在 Ubuntu 24.04 上跑

```bash
cd agent-systems
bash experiments/ch04/verify-linux.sh
```

脚本内部等价于：

```bash
cc -std=c17 -O2 -Wall -Wextra -Werror experiments/ch04/harden.c -o /tmp/harden
/tmp/harden
/tmp/harden --landlock
python3 experiments/ch04/inspect_linux.py
python3 experiments/ch04/inspect_linux.py --pid $$
```

`harden` 的默认模式预期输出（普通用户；如果以 root 运行，`bounding:` 那行会变成
`bounding: dropped 0..40, CAP_SETPCAP last`，`CapEff before drop` 也不再是 0）：

```text
uid=1000 euid=1000
NoNewPrivs: 1
CapEff before drop: 0x0000000000000000
CapEff after drop:  0x0000000000000000
bounding: skipped (errno=1; run as root to exercise)
seccomp: filter installed (TSYNC)
openat("/etc/passwd") after seccomp: EPERM (1)
result: OK
```

`--landlock` 模式多两行；在 Linux 6.8 上 ABI 是 4：

```text
landlock: ABI 4, only /usr is readable
openat("/etc/passwd") after landlock: EACCES (13)
```

这两段是**脚本要核对的预期值**，不是本机 macOS 的运行结果。macOS 原生 `cc` 无法编译
`harden.c`：`<linux/seccomp.h>`、`<linux/landlock.h>`、`<sys/prctl.h>` 都不存在。本机用
`zig cc` 针对 `x86_64-linux-gnu` / `aarch64-linux-gnu` 做了交叉编译，只证明语法与头文件
在 Linux ABI 下成立，没有运行。

## 本机（macOS）实际验证了什么

```bash
python3 -m py_compile experiments/ch04/inspect_linux.py   # OK
bash -n experiments/ch04/verify-linux.sh                  # OK
zig cc -target x86_64-linux-gnu -std=c17 -O2 \
       -Wall -Wextra -Werror -c experiments/ch04/harden.c -o /tmp/harden.o  # OK
python3 experiments/ch04/inspect_linux.py                 # 跳过，exit 0
bash experiments/ch04/verify-linux.sh                     # 跳过，exit 1
```

`inspect_linux.py` 的真实输出：

```text
inspect_linux.py: host is Darwin, not Linux.
/proc/<pid>/status is unavailable here; nothing to inspect.
This checker exits 0 by design so it can live in a cross-platform test matrix.
Run it on Ubuntu 24.04 (Linux 6.8) to see CapEff/Seccomp/NoNewPrivs.
```

`verify-linux.sh` 的真实输出（stderr）：

```text
SKIP: harden.c uses Linux-only seccomp/landlock/prctl/capget interfaces.
      current host: Darwin 27.0.0
      run this on Ubuntu 24.04 (Linux 6.8): bash experiments/ch04/verify-linux.sh
      exiting 1 on purpose: a skip must not look like a pass in CI.
```

离线解析器可以用 `--file` 在一份保存下来的 `status` 上验证，不依赖 Linux：

```bash
python3 experiments/ch04/inspect_linux.py --file /tmp/status.sample
```

## 验证矩阵

| 项目 | macOS 27.0.1 / arm64 | Ubuntu 24.04 / Linux 6.8 |
|:--|:--|:--|
| `harden.c` 编译 | 已验证：`zig cc -target x86_64-linux-gnu -c`（交叉编译，未运行） | `cc -std=c17 -O2 -Wall -Wextra -Werror` |
| `harden` 默认模式 | 未运行 | `verify-linux.sh` 核对 NNP/CapEff/EPERM/OK 关键行 |
| `harden --landlock` | 未运行 | `verify-linux.sh` 核对 ABI 与 EACCES |
| `verify-linux.sh` | 已验证：跳过并 `exit 1` | 应输出 `PASS` |
| `inspect_linux.py` 默认 | 已验证：跳过并 `exit 0` | 读 `/proc/self/status` |
| `inspect_linux.py --file` | 已验证：解析器 | 同 |
| `bash -n` / `py_compile` | 已验证 | 同 |

## 三个限制

1. **`harden.c` 不是生产沙箱。** 它只演示顺序与返回值；真实策略应由 libseccomp /
   Landlock 库生成，并配一份允许列表的回归测试。白名单少一个系统调用，程序就会在
   某个冷路径上 `EPERM`，这类 bug 很难在 happy path 上发现。
2. **capability 的清空在普通用户下是空操作。** 普通用户本来就没有 effective/permitted
   capability（bounding 仍是满的），`CapEff before/after` 都是 0；要观察 bounding 集合
   真的被裁剪，需以 root 运行。即便如此，`no_new_privs` 仍然有意义：它挡住后续 exec 的
   setuid/file-capability。
3. **landlock 只演示了路径规则。** ABI 4 的 TCP 网络规则、ABI 6 的 IPC scope 没有写进
   这个程序；它们需要监听 socket / 发信号的对端才能验证。正文 4.4 给了规则结构。

## 安全提醒

- 不要在宿主机上以 root 直接运行来路不明的 `harden` 变体；先读代码，再在一次性
  VM/容器里跑。这个程序会主动丢弃 capability，但错误实现可能不会。
- `SECCOMP_RET_KILL_PROCESS` 没有 errno，进程直接死；调试时先用 `RET_ERRNO`，
  确认策略稳定后再考虑升级为 kill。
- `/proc/<pid>/status` 可能包含敏感信息（进程名、UID、capability 位图）。把
  `inspect_linux.py --json` 的输出写进日志前，先确认访问控制。
