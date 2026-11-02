#!/bin/sh
# mdBook 预处理器的启动器：选第一个装得下 markdown-it-py 的解释器。
# 本机 PATH 里的 python3 可能是刚升级、尚未装依赖的 Homebrew 版本，
# 直接写死 python3 会让构建随 PATH 随机成功或失败。
set -e
for py in python3 /usr/bin/python3 python3.13 python3.12 python3.11; do
    if command -v "$py" >/dev/null 2>&1 && "$py" -c 'import markdown_it' >/dev/null 2>&1; then
        exec "$py" "$(dirname "$0")/mathbook.py" "$@"
    fi
done
echo "mathbook: 没有找到装有 markdown-it-py 的 Python 解释器；" >&2
echo "         先执行 pip3 install -r requirements.txt（或指定带该依赖的解释器）。" >&2
exit 1
