#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."

CC="${EDGE_CC:-clang}"
[[ -x "$CC" ]] || CC="$(command -v clang)"

out=.build/project2
mkdir -p "$out"

echo "==> [Project 2] 编译并运行主机集成仿真测试 (ASan/UBSan)..."
"$CC" -std=c11 -Wall -Wextra -Werror -O2 -g -fsanitize=address,undefined \
    projects/edge-daq-monitor/main.c -o "$out/test-host"

"$out/test-host" | tee "$out/host-run.txt"

echo "==> [Project 2] 运行故障注入破坏性变异测试..."
python3 - <<'PY'
import subprocess
from pathlib import Path

src = Path("projects/edge-daq-monitor/main.c").read_text(encoding="utf-8")
out = Path(".build/project2")

# 变异 1：数据块校验和计算错误注入 (模拟 DMA 传输位翻转或校验和算法失效)
mutant_src = src.replace("block.checksum = compute_block_checksum(&block);", "block.checksum = compute_block_checksum(&block) ^ 0xA55A;")
assert mutant_src != src, "Mutation pattern not found"

(out / "mutant.c").write_text(mutant_src, encoding="utf-8")
cmd_build = ["clang", "-std=c11", "-O2", str(out / "mutant.c"), "-o", str(out / "mutant-bin")]
subprocess.run(cmd_build, check=True)

# 预期破坏性变异程序在集成测试中发生断言违约
r = subprocess.run([str(out / "mutant-bin")], capture_output=True, text=True)
if r.returncode != 0:
    print(f"MUTATION PASS: Corrupted checksum caught by assert, exit={r.returncode}")
else:
    raise SystemExit("MUTATION FAILED: Corrupted checksum was not caught!")
PY

echo "==> [Project 2] 全部实战工程验证通过！"
