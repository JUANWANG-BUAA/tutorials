#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."

CC="${EDGE_CC:-clang}"
[[ -x "$CC" ]] || CC="$(command -v clang)"

out=.build/project1
mkdir -p "$out"

echo "==> [Project 1] 编译并运行主机集成仿真测试 (ASan/UBSan)..."
"$CC" -std=c11 -Wall -Wextra -Werror -O2 -g -fsanitize=address,undefined \
    projects/edge-rtos-infer/main.c -o "$out/test-host"

"$out/test-host" | tee "$out/host-run.txt"

echo "==> [Project 1] 运行故障注入破坏性变异测试..."
python3 - <<'PY'
import subprocess
from pathlib import Path

src = Path("projects/edge-rtos-infer/main.c").read_text(encoding="utf-8")
out = Path(".build/project1")

# 变异 1：篡改告警判定条件 (将异常告警反转为正常)
mutant_src = src.replace("if (logits[0] > logits[1])", "if (logits[0] <= logits[1])")
assert mutant_src != src, "Mutation pattern not found"

(out / "mutant.c").write_text(mutant_src, encoding="utf-8")
cmd_build = ["clang", "-std=c11", "-O2", str(out / "mutant.c"), "-o", str(out / "mutant-bin")]
subprocess.run(cmd_build, check=True)

# 预期该变异程序在集成测试中发生断言失败 (非 0 退出)
r = subprocess.run([str(out / "mutant-bin")], capture_output=True, text=True)
if r.returncode != 0:
    print(f"MUTATION PASS: Inverted logic caught by assert, exit={r.returncode}")
else:
    raise SystemExit("MUTATION FAILED: Inverted logic was not caught!")
PY

echo "==> [Project 1] 全部实战工程验证通过！"
