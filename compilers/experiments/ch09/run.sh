#!/usr/bin/env bash
# 第 9 章实验入口：UB 的可观察差异 + sanitizer + 静态分析。
# 用法（在 compilers/ 下）：bash experiments/ch09/run.sh
set -uo pipefail

cd "$(dirname "$0")"
CC="${CC:-clang}"
BUILD="build"
mkdir -p "$BUILD"
exec 2> "$BUILD/run.stderr"

if [ -d /opt/homebrew/opt/llvm@22/bin ]; then
    PATH="/opt/homebrew/opt/llvm@22/bin:$PATH"
    export PATH
fi

norm() {
    sed -E 's/0x[0-9a-f]+/0xADDR/g; s/==[0-9]+==/==PID==/g; s/pid=[0-9]+/pid=PID/g; s/tid=[0-9]+/tid=TID/g'
}

section() {
    printf '\n===== %s =====\n' "$1"
}

run_capture() {
    local out="$1"
    shift
    OUT="$out" sh -c 'exec "$@" > "$OUT" 2>&1' _ "$@" 2> /dev/null
}

run_case() {
    local exe="$1"
    shift
    run_capture "$BUILD/out.txt" "$exe" "$@"
    local rc=$?
    norm < "$BUILD/out.txt"
    echo "exit=$rc"
}

section "0. 工具链"
if ! command -v "$CC" > /dev/null 2>&1; then
    echo "SKIP: 找不到 C 编译器 CC=$CC"
    exit 0
fi
"$CC" --version | head -n 1
python3 --version
uname -sm

section "1. 严格警告下编译（-std=c17 -Wall -Wextra -Werror）"
for opt in O0 O1 O2; do
    if "$CC" -std=c17 -Wall -Wextra -Werror -pthread "-$opt" -g ub_lab.c \
            -o "$BUILD/ub_$opt"; then
        echo "build -$opt: ok"
    else
        echo "build -$opt: FAILED"
        exit 1
    fi
done

"$CC" -std=c17 -Wall -Wextra -Werror -pthread -funsigned-char -O0 ub_lab.c \
    -o "$BUILD/ub_unsigned_char"
echo "build -funsigned-char: ok"

section "2. 没有 sanitizer：越界与溢出在机器上照常返回"
echo '-- overflow at -O0'; run_case "$BUILD/ub_O0" overflow 2147483647
echo '-- overflow at -O2'; run_case "$BUILD/ub_O2" overflow 2147483647
echo '-- shift 2 31';       run_case "$BUILD/ub_O2" shift 2 31
echo '-- oob-read index 4'; run_case "$BUILD/ub_O1" oob-read 4
echo '-- use-after-free';   run_case "$BUILD/ub_O1" uaf
echo '-- char signedness';  run_case "$BUILD/ub_O0" char-signed
echo '-- same source, -funsigned-char'; run_case "$BUILD/ub_unsigned_char" char-signed

section "3. UBSan：报出有符号溢出与非法移位"
if "$CC" -std=c17 -Wall -Wextra -Werror -pthread -O1 -g \
        -fsanitize=undefined -fno-sanitize-recover=all ub_lab.c \
        -o "$BUILD/ub_ubsan"; then
    echo "-- overflow"; run_case "$BUILD/ub_ubsan" overflow 2147483647
    echo "-- shift";    run_case "$BUILD/ub_ubsan" shift 2 31
else
    echo "SKIP: 本机编译器不支持 -fsanitize=undefined"
fi

section "4. ASan：越界与释放后使用"
if "$CC" -std=c17 -Wall -Wextra -Werror -pthread -O1 -g \
        -fsanitize=address -fno-omit-frame-pointer ub_lab.c \
        -o "$BUILD/ub_asan"; then
    echo "-- oob-read index 4"
    run_capture "$BUILD/out.txt" env ASAN_OPTIONS=detect_leaks=0 "$BUILD/ub_asan" oob-read 4
    echo "exit=$?"
    norm < "$BUILD/out.txt" | grep -E 'ERROR|READ|WRITE|is located|allocated by|freed by|SUMMARY|SEGV|Hint' | head -n 8
    echo "-- oob-write index 4"
    run_capture "$BUILD/out.txt" env ASAN_OPTIONS=detect_leaks=0 "$BUILD/ub_asan" oob-write 4
    echo "exit=$?"
    norm < "$BUILD/out.txt" | grep -E 'ERROR|READ|WRITE|is located|allocated by|freed by|SUMMARY|SEGV|Hint' | head -n 8
    echo "-- use-after-free"
    run_capture "$BUILD/out.txt" env ASAN_OPTIONS=detect_leaks=0 "$BUILD/ub_asan" uaf
    echo "exit=$?"
    norm < "$BUILD/out.txt" | grep -E 'ERROR|READ|WRITE|is located|allocated by|freed by|SUMMARY|SEGV|Hint' | head -n 8
    echo "-- null-guard"
    run_capture "$BUILD/out.txt" env ASAN_OPTIONS=detect_leaks=0 "$BUILD/ub_asan" null-guard
    echo "exit=$?"
    norm < "$BUILD/out.txt" | grep -E 'ERROR|READ|WRITE|is located|allocated by|freed by|SUMMARY|SEGV|Hint' | head -n 8
else
    echo "SKIP: 本机编译器不支持 -fsanitize=address"
fi

section "5. TSan：数据竞争"
if "$CC" -std=c17 -Wall -Wextra -Werror -pthread -O1 -g \
        -fsanitize=thread ub_lab.c -o "$BUILD/ub_tsan"; then
    run_capture "$BUILD/out.txt" env TSAN_OPTIONS=halt_on_error=1 "$BUILD/ub_tsan" race
    echo "exit=$?"
    norm < "$BUILD/out.txt" | grep -E 'WARNING|Write of|Previous write|Location is|SUMMARY' | head -n 8
else
    echo "SKIP: 本机编译器不支持 -fsanitize=thread"
fi

section "6. MSan：未初始化读"
if "$CC" -std=c17 -O1 -g -fsanitize=memory ub_lab.c -o "$BUILD/ub_msan" 2> "$BUILD/msan.err"; then
    echo "MSan build: ok（本实验没有未初始化用例，未运行）"
else
    echo "SKIP: 本机不支持 MemorySanitizer"
    head -n 2 "$BUILD/msan.err"
fi

section "7. 被删掉空指针检查：x86-64 反汇编"
if "$CC" -target x86_64-apple-darwin -std=c17 -O2 -c ub_lab.c -o "$BUILD/ub_x86_O2.o" 2> "$BUILD/x86.err" \
   && command -v llvm-objdump > /dev/null 2>&1; then
    echo "-- -O2"
    llvm-objdump -d --no-show-raw-insn "$BUILD/ub_x86_O2.o" \
        | awk '/<_guarded_load>:/{p=1} p{print} p&&/retq/{exit}'
    "$CC" -target x86_64-apple-darwin -std=c17 -O0 -c ub_lab.c -o "$BUILD/ub_x86_O0.o"
    echo "-- -O0"
    llvm-objdump -d --no-show-raw-insn "$BUILD/ub_x86_O0.o" \
        | awk '/<_guarded_load>:/{p=1} p{print} p&&/retq/{exit}'
else
    echo "SKIP: 交叉目标汇编或 llvm-objdump 不可用"
    head -n 2 "$BUILD/x86.err" 2> /dev/null
fi

section "8. 区间抽象解释：真阳性 / 假阳性 / 漏报"
python3 static_lab.py
echo
echo "-- 把 % 当数学取模（漏报）"
python3 static_lab.py --program=modulo --mod=math
echo
echo "-- 把溢出当回绕（漏报）"
python3 static_lab.py --program=overflow --semantics=wrap

printf '\n全部实验完成；shell/stderr 记录在 %s。\n' "$BUILD/run.stderr"
exit 0
