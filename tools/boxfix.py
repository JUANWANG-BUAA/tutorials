#!/usr/bin/env python3
"""平铺闭合修复：为 ex/thm/method 等盒子在内容结尾补上外层 `:::`。

规则（与 tools/mathbook.py 的配平判据一致）：
- `::: xxx` 开盒子；`:::` 闭合；
- 内层只允许 proof / sol 出现在 ex/thm/method 内部；
- 本脚本只负责「把漏掉的外层闭合补上」，不做其他改动。

用法：
    python3 boxfix.py <file.md> [...]        # 修复并报告
    python3 boxfix.py --check <file.md>...   # 只检查
"""
import re
import sys

OPEN_RE = re.compile(r"^:::\s*([A-Za-z]+)")
CLOSE_RE = re.compile(r"^:::\s*$")


def unclosed_indices(lines):
    depth = 0
    fence = False
    stack = []
    for i, s in enumerate(lines):
        t = s.strip()
        if t.startswith("```"):
            fence = not fence
            continue
        if fence:
            continue
        if OPEN_RE.match(t):
            depth += 1
            stack.append(i)
        elif CLOSE_RE.match(t) and stack:
            depth -= 1
            stack.pop()
    return stack


def outer_close_point(lines, open_idx):
    """返回应插入 `:::` 的 0-based 行号（在该行之前插入）。"""
    inner_start = None
    for j in range(open_idx + 1, len(lines)):
        t = lines[j].strip()
        if t.startswith("## "):
            break
        if not CLOSE_RE.match(t) and OPEN_RE.match(t):
            inner_start = j
            break
    if inner_start is None:
        j = open_idx + 1
        while j < len(lines) and not lines[j].strip().startswith("## ") \
                and not OPEN_RE.match(lines[j].strip()):
            j += 1
        k = j - 1
        while k > open_idx and lines[k].strip() == "":
            k -= 1
        return k + 1
    for j in range(inner_start + 1, len(lines)):
        t = lines[j].strip()
        if CLOSE_RE.match(t):
            return j + 1
        if t.startswith("## ") or OPEN_RE.match(t):
            return None
    return None


def fix(path, check=False):
    lines = open(path, encoding="utf-8").read().split("\n")
    before = unclosed_indices(lines)
    if check or not before:
        return len(before), 0
    pts = set()
    for oi in before:
        ip = outer_close_point(lines, oi)
        if ip is None:
            raise SystemExit(f"{path}: 无法定位第 {oi + 1} 行的闭合点")
        pts.add(ip)
    for ip in sorted(pts, reverse=True):
        lines.insert(ip, ":::")
    open(path, "w", encoding="utf-8").write("\n".join(lines))
    rest = unclosed_indices(lines)
    return len(before), len(rest)


def main():
    args = sys.argv[1:]
    check = "--check" in args
    files = [a for a in args if not a.startswith("--")]
    for p in files:
        fixed, rest = fix(p, check=check)
        if check:
            print(f"{p}: 未闭合 {fixed} 个" + ("（已配平）" if fixed == 0 else ""))
        else:
            print(f"{p}: 补 {fixed} 处闭合，剩余未闭合 {rest} 个")


if __name__ == "__main__":
    main()
