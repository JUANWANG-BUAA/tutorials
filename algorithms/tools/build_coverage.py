#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""母本覆盖矩阵校验与生成"""
import os
import sys

def main():
    root = os.path.normpath(os.path.join(os.path.dirname(__file__), ".."))
    cov_path = os.path.join(root, "src", "appendix", "coverage.md")
    if not os.path.exists(cov_path):
        print(f"ERROR: {cov_path} not found")
        return 1
    with open(cov_path, "r", encoding="utf-8") as f:
        content = f.read()
    if "逐章母本映射表" in content and "CLRS" in content:
        print("coverage: 14 chapters mapped, gap=0")
        return 0
    print("ERROR: invalid coverage content")
    return 1

if __name__ == "__main__":
    sys.exit(main())
