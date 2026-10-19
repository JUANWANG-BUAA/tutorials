# 第 1 章实验：最小 agent 内核

```bash
cd agent-systems
python3 experiments/ch01/mini_loop.py --task sum --mode good
python3 experiments/ch01/mini_loop.py --task sum --mode loop --max-steps 5
python3 -m unittest discover -s experiments/ch01 -v
```

- `good`：读文件 → 写结果 → finish，3 步结束。
- `loop`：永远重复同一个工具调用，靠 `max_steps` / `max_tool_calls` 终止。
- `badarg`：动作多带一个字段，被 schema 校验拒绝，错误作为观察回到循环。

代码只依赖 Python 3.11 标准库；`trace.jsonl` 是每步一行，可直接 `jq` 观察。
