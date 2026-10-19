# 项目一 · 可沙箱执行的代码 agent

一个能读文件、改文件、跑测试、受限执行的代码 agent。它不追求通用，而是把第 1–4、10、11 章的关键边界做成可测试的代码。

## 能力

- 四层状态（世界/任务/会话/控制）+ JSONL trace
- 工具契约：`fs.read`、`fs.write`、`fs.list`、`patch.apply`、`test.run`、`task.finish`
- 预算：步数、工具调用、墙钟；连续 3 步无进展则终止
- 沙箱：`setsid` 进程组、`killpg` 收尸、`rlimit`（CPU/FSIZE/NOFILE/CORE）、输出上限、临时工作区
- 路径策略：拒绝绝对路径、`..`、符号链接逃逸
- 出口策略：默认拒绝所有 host；allowlist 精确匹配
- 红队：绝对路径、`..`、注入文本、输出炸弹、未测试就 finish

## 运行

```bash
cd projects/code-agent

# 修一个 off-by-one 的 add()，输出 trace
python3 run_demo.py --mode good --trace /tmp/code-agent.jsonl

# 演示预算终止
python3 run_demo.py --mode loop --max-steps 5

# 演示路径逃逸被拒
python3 run_demo.py --mode escape

# 测试
python3 -m unittest discover -s tests -v
```

预期：`good` 输出 `"stop_reason": "done"`、`"steps": 4`；`loop` 以 `max_steps` 或 `no_progress` 结束；`escape` 第一步返回 `EPERM`。

## 目录

```text
code-agent/
  agent/
    state.py     四层状态与预算
    tools.py     工具契约、校验、执行
    policy.py    确定性策略（可替换为 LLM 适配器）
    loop.py      循环、指纹、trace
    trace.py     JSONL 写入/读取
  sandbox/
    runner.py    受限子进程执行
    policy.py    路径与出口策略
  tests/         24 个单元/红队用例
  run_demo.py
```

## 已知边界

- macOS 不支持 `RLIMIT_AS` 的一致语义；`Limits.memory_bytes` 默认 `None`，Linux 上可设。
- `killpg` 只能杀掉同一进程组；如果子进程自己 `setsid` 逃逸，需要 cgroup 或 PID namespace（第 3.5 节）。
- 路径检查与 `open` 之间存在 TOCTOU 窗口；生产实现应使用 `openat2` + `RESOLVE_BENEATH`（第 3.3 节）。
- 没有真实网络工具；`EgressPolicy` 只做 URL 判定，演示用。
