#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""抽取代码围栏做尽力而为的语法检查。

不是所有片段都是独立程序：带 ... 的伪代码、objdump 文本、REPL 会话会跳过。
检查结果用于人工复核，不直接作为内容正确性的证明。

用法：python3 tools/check_snippets.py [--verbose]
"""

from __future__ import annotations

import os
import re
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
SRC = os.path.join(ROOT, "src")
FENCE = re.compile(r"^\s*(`{3,}|~{3,})(.*)$")


def blocks(text):
    fence, info, buf, start = None, "", [], 0
    for i, line in enumerate(text.splitlines(), 1):
        m = FENCE.match(line)
        if m:
            if fence is None:
                fence, info, buf, start = m.group(1)[0], m.group(2).strip(), [], i + 1
                continue
            if m.group(1)[0] == fence:
                yield start, info, "\n".join(buf) + "\n"
                fence, info, buf = None, "", []
                continue
        if fence is not None:
            buf.append(line)
    if fence is not None:
        yield start, info, "\n".join(buf) + "\n"


def run(cmd, src):
    with tempfile.NamedTemporaryFile("w", suffix=".txt", delete=False) as f:
        f.write(src)
        path = f.name
    try:
        p = subprocess.run(cmd, input=src, text=True, capture_output=True, timeout=20)
        return p.returncode, (p.stderr or p.stdout).strip()
    except Exception as e:
        return 99, str(e)
    finally:
        os.unlink(path)


def should_skip(lang, src):
    if "..." in src or "…" in src:
        return "省略号伪代码"
    if lang == "asm":
        return "汇编片段需单独 objdump 核对"
    if lang == "python" and (">>>" in src or re.search(r"^\s*\$ ", src, re.M)):
        return "REPL/会话"
    if lang == "text":
        return "非代码"
    return ""


def main():
    verbose = "--verbose" in sys.argv
    bad = 0
    total = 0
    skipped = 0
    for base, dirs, files in os.walk(SRC):
        dirs[:] = [d for d in dirs if d not in {"assets", "fonts"}]
        for f in files:
            if not f.endswith(".md"):
                continue
            path = os.path.join(base, f)
            rel = os.path.relpath(path, ROOT)
            for line, info, src in blocks(open(path, encoding="utf-8").read()):
                lang = info.split()[0].lower() if info else ""
                if lang not in {"c", "rust", "python", "bash"}:
                    continue
                total += 1
                reason = should_skip(lang, src)
                if reason:
                    skipped += 1
                    if verbose:
                        print(f"SKIP {rel}:{line} {lang} ({reason})")
                    continue
                if lang == "c":
                    cmd = ["cc", "-std=c17", "-fsyntax-only", "-Wno-everything", "-x", "c", "-"]
                elif lang == "rust":
                    rmeta = tempfile.NamedTemporaryFile(suffix=".rmeta", delete=False)
                    rmeta.close()
                    cmd = ["rustc", "--edition", "2021", "--crate-type", "lib",
                           "--emit=metadata", "-o", rmeta.name, "-"]
                elif lang == "python":
                    try:
                        compile(src, f"{rel}:{line}", "exec")
                        continue
                    except SyntaxError as e:
                        bad += 1
                        print(f"FAIL {rel}:{line} python: {e}")
                        continue
                else:
                    cmd = ["bash", "-n"]
                rc, err = run(cmd, src)
                if lang == "rust":
                    try:
                        os.unlink(rmeta.name)
                    except OSError:
                        pass
                if rc != 0:
                    bad += 1
                    print(f"FAIL {rel}:{line} {lang}: {err.splitlines()[-1] if err else rc}")
    print(f"snippets checked={total} skipped={skipped} failed={bad}")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
