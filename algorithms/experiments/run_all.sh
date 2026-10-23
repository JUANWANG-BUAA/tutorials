#!/usr/bin/env bash
# algorithms 实验统一运行脚本
# 运行所有章节实验，汇总结果

set -e

cd "$(dirname "$0")"

PASS=0
FAIL=0
SKIP=0

for ch in ch{01..14}; do
    if [[ ! -d "$ch" ]]; then
        echo "[SKIP] $ch (目录不存在)"
        SKIP=$((SKIP + 1))
        continue
    fi

    lab_script=$(find "$ch" -name "*_lab.py" | head -1)
    if [[ -z "$lab_script" ]]; then
        echo "[SKIP] $ch (无实验脚本)"
        SKIP=$((SKIP + 1))
        continue
    fi

    echo -n "[$ch] $(basename "$lab_script") ... "
    if python3 "$lab_script" > /dev/null 2>&1; then
        echo "PASS"
        PASS=$((PASS + 1))
    else
        echo "FAIL"
        FAIL=$((FAIL + 1))
    fi
done

echo "==============================="
echo "experiments: PASS=$PASS FAIL=$FAIL SKIP=$SKIP"

if [[ $FAIL -gt 0 ]]; then
    exit 1
fi
