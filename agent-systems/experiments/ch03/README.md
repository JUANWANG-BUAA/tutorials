# 第 3 章实验：Python 沙箱 runner

本目录是《Agent 系统工程》3.9 节的实验代码。它用 Python 标准库演示四件事：超时后杀整个进程组、用 rlimit 限制资源、限制输出、拒绝工作区外的脚本路径。

> 这不是安全边界。它只做应用层能做的检查；同一个 UID 的子进程仍能读写宿主文件、绕过路径检查、用 `setsid` 逃出进程组。真正的隔离要靠容器/虚拟机、user namespace、capability、seccomp 与 cgroup（第 4 章与 3.3–3.6）。

## 文件

| 文件 | 作用 |
|:--|:--|
| `sandbox_runner.py` | 主 runner：启动、限额、超时、收尸、截断、路径检查 |
| `test_sandbox.py` | 7 条回归测试 |
| `orphan_demo.py` | 复现「只杀父进程，子进程继续写文件」 |
| `verify-linux.sh` | Linux-only 的 openat2 编译/运行自检；macOS 上 SKIP |

## 快速开始

在仓库根目录（`agent-systems/`）执行：

```bash
python3 experiments/ch03/sandbox_runner.py --code 'print(6*7)'
python3 experiments/ch03/sandbox_runner.py --code 'import sys; sys.exit(42)'
python3 experiments/ch03/sandbox_runner.py --code 'import time; time.sleep(10)' --timeout 0.5
python3 experiments/ch03/sandbox_runner.py --code 'print("x"*200000)' --max-output 4096
```

每个命令输出一个 JSON 对象。`ok` 为 `false` 时返回码为 1，便于 shell 判断。

解码 wait status：

```bash
python3 experiments/ch03/sandbox_runner.py --decode-status 0x2a00
```

```json
{
  "kind": "exited",
  "raw": "0x2a00",
  "exit_code": 42,
  "signal": null,
  "signal_name": null,
  "core_dumped": false
}
```

实际运行还会输出 `timed_out` 等字段；解码命令的完整结果以程序输出为准。

## 运行测试

```bash
python3 -m unittest discover -s experiments/ch03 -v
```

覆盖：

1. 正常退出（`exit_code=0`，`ok=true`）；
2. 非零退出（`sys.exit(42)`，`exit_code=42`，`ok=false`）；
3. 超时杀进程组（孙进程不再写 `late.txt`）；
4. 输出超限（返回文本截断到 `max_output_bytes`）；
5. 路径逃逸拒绝（工作区外脚本、指向外部的符号链接均返回 `EPATH`）；
6. `RLIMIT_NOFILE` 生效（`nofile=32` 时第 22 个左右的 fd 失败）；
7. wait status 解码（`0x2a00` → 42，`0x000f` → `SIGTERM`）。

## 孤儿进程演示

```bash
python3 experiments/ch03/orphan_demo.py
python3 experiments/ch03/orphan_demo.py --kill-group
```

第一次只 kill 父进程，子进程继续运行并写 `late.txt`；第二次 kill 整个进程组，`late.txt` 不存在。两次运行的差别只有 `os.kill` 与 `os.killpg`。

## 结果字段

| 字段 | 含义 |
|:--|:--|
| `ok` | `exit_code == 0` 且未超时、未截断、无启动错误 |
| `exit_code` | 正常退出的退出码；被信号终止时为 `null` |
| `signal` / `signal_name` | 终止信号编号与名字；正常退出时为 `null` |
| `timed_out` | 是否因墙钟超时被 kill |
| `output_limited` | 是否因输出超过上限被截断/终止 |
| `stdout` / `stderr` | 解码后的文本，最多 `max_output_bytes` 字节 |
| `stdout_truncated` / `stderr_truncated` | 对应流是否被截断 |
| `bytes` | 原始输出字节数（截断前） |
| `rlimits` | 实际请求的限额；`as_enforced` 表示 `RLIMIT_AS` 是否真的设置 |
| `error` | `EPATH`（路径逃逸）、`ENOENT`（脚本不存在）、`ESCAPED`（SIGKILL 后仍存活） |

## 平台差异

| 能力 | macOS | Linux |
|:--|:--|:--|
| `start_new_session` + `killpg` | 可用 | 可用 |
| `RLIMIT_CPU` / `NOFILE` / `FSIZE` / `CORE` | 可用 | 可用 |
| `RLIMIT_AS` | 不可靠，runner 跳过 | 可用 |
| `RLIMIT_NPROC` | 按用户计，runner 不设 | 按真实 UID 计，runner 不设 |
| cgroup v2 | 无 | 有；本 runner 未实现 |
| netns / OCI | 无 | 有；正文给命令，未在本机运行 |

`RLIMIT_AS` 在 macOS 上可能直接抛 `ValueError: current limit exceeds maximum limit`，所以 `sandbox_runner.py` 只在 Linux 上设置它，并在结果的 `rlimits.as_enforced` 中标明。

## Linux-only 的部分

本 runner **不实现** cgroup、netns 与 OCI。正文 3.4–3.6 中标注「Linux 6.8 / Ubuntu 24.04」的命令（`ip netns`、`nft`、`cgroup.kill`、`runc`）没有在本机 macOS 上运行过，只做了语法/字段核对。需要验证它们时，请在 Linux 6.8+ 的机器上执行，并先确认 cgroup v2 已挂载、当前用户有相应权限。

`verify-linux.sh` 只验证正文 3.3.4 的 `openat2` 示例能否编译并运行；macOS 上会打印 `SKIP`，Linux 上需要 `cc` 与 5.6+ 内核。它不验证 cgroup、netns 或 OCI。

```bash
bash experiments/ch03/verify-linux.sh
```

## 已知限制

- 路径检查是「启动前解析 + 包含判断」，不是原子打开；子进程启动后仍可用绝对路径访问宿主。要原子约束，见正文 3.3.4 的 `openat2`。
- 子进程可以调用 `setsid()` 逃出进程组；runner 的 `killpg` 覆盖不到它。生产环境应加 cgroup `cgroup.kill` 或 PID 命名空间。
- `preexec_fn` 在多线程父进程中不安全；runner 假定自己是单线程的。
- `-I` 隔离模式不会把脚本目录加入 `sys.path`；需要本地 import 的脚本要显式处理 `sys.path`，或去掉 `-I`。
- 输出上限按流计算；stdout 与 stderr 各自最多 `max_output_bytes`，总输出上限约为两倍。
- 这只是教学实现，不要直接用于执行不可信代码。
