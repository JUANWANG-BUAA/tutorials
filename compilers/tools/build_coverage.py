#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""生成并核查母本覆盖矩阵。

每个单元必须且只能映射到一个已存在的节锚点。矩阵写回
src/appendix/coverage.md 与 coverage.md（评审副本）；任何缺口都拒绝写文件。
"""

from __future__ import annotations

import os
import re
import sys
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
SRC = os.path.join(ROOT, "src")
OUT1 = os.path.join(SRC, "appendix", "coverage.md")
OUT2 = os.path.join(ROOT, "coverage.md")

# (source, 单元, 落点 rel#anchor, 深度, 说明)
UNITS = [
    # 自制编译器
    ("自制编译器", "编译器整体结构", "part1/ch01.md#sec-compilers.1.1.3", "完整", "阶段划分与驱动"),
    ("自制编译器", "编译理论与实际实现", "part1/ch01.md#sec-compilers.1.1.4", "精选", "pass 与工程边界"),
    ("自制编译器", "词法分析", "part1/ch02.md#sec-compilers.1.2.1", "完整", "正则/DFA/最大匹配"),
    ("自制编译器", "语法分析", "part1/ch02.md#sec-compilers.1.2.3", "完整", "递归下降/Pratt"),
    ("自制编译器", "抽象语法树", "part1/ch02.md#sec-compilers.1.2.4", "完整", "节点/span/访问者"),
    ("自制编译器", "语义分析", "part1/ch03.md#sec-compilers.1.3.4", "完整", "类型检查"),
    ("自制编译器", "变量与作用域", "part1/ch03.md#sec-compilers.1.3.2", "完整", "符号表与遮蔽"),
    ("自制编译器", "类型与类型检查", "part1/ch03.md#sec-compilers.1.3.4", "完整", "判断与推导"),
    ("自制编译器", "中间代码", "part1/ch04.md#sec-compilers.1.4.2", "完整", "TAC/CFG"),
    ("自制编译器", "表达式与语句翻译", "part1/ch04.md#sec-compilers.1.4.2", "完整", "控制流降级"),
    ("自制编译器", "函数调用与栈帧", "part2/ch08.md#sec-compilers.2.8.3", "完整", "参数/返回/对齐"),
    ("自制编译器", "寄存器分配", "part2/ch07.md#sec-compilers.2.7.3", "完整", "图着色与溢出"),
    ("自制编译器", "代码生成", "part2/ch08.md#sec-compilers.2.8.5", "完整", "prologue/epilogue"),
    ("自制编译器", "优化", "part2/ch05.md#sec-compilers.2.5.6", "完整", "保守性"),
    ("自制编译器", "链接与加载", "part2/ch08.md#sec-compilers.2.8.1", "交叉引用", "指向 Linux 1.7"),

    # Rust Reference
    ("Rust Reference", "类型与类型参数", "part1/ch03.md#sec-compilers.1.3.1", "精选", "静态类型检查"),
    ("Rust Reference", "名字、作用域与遮蔽", "part1/ch03.md#sec-compilers.1.3.2", "完整", "绑定与解析"),
    ("Rust Reference", "生命周期与借用", "part1/ch03.md#sec-compilers.1.3.5", "精选", "检查器接口"),
    ("Rust Reference", "未定义行为", "part3/ch09.md#sec-compilers.3.9.1", "完整", "抽象机器"),
    ("Rust Reference", "ABI 与链接属性", "part2/ch08.md#sec-compilers.2.8.1", "交叉引用", "ABI 合同"),
    ("Rust Reference", "常量求值", "part2/ch06.md#sec-compilers.2.6.4", "精选", "编译期折叠"),
    ("Rust Reference", "析构与 drop", "part1/ch03.md#sec-compilers.1.3.6", "背景", "清理语义"),
    ("Rust Reference", "模式匹配", "part1/ch02.md#sec-compilers.1.2.4", "背景", "AST 形态"),
    ("Rust Reference", "条件编译与属性", "part1/ch01.md#sec-compilers.1.1.6", "背景", "构建配置"),
    ("Rust Reference", "运算符与重载", "part1/ch03.md#sec-compilers.1.3.4", "精选", "类型约束"),
    ("Rust Reference", "trait 与实现", "part1/ch03.md#sec-compilers.1.3.5", "精选", "实例化边界"),
    ("Rust Reference", "泛型", "part1/ch03.md#sec-compilers.1.3.5", "完整", "单态化"),
    ("Rust Reference", "unsafe 与内存模型", "part3/ch09.md#sec-compilers.3.9.3", "精选", "UB 分类"),
    ("Rust Reference", "FFI 与 repr", "part2/ch08.md#sec-compilers.2.8.3", "精选", "布局与调用"),
    ("Rust Reference", "类型布局", "part2/ch08.md#sec-compilers.2.8.3", "背景", "聚合参数"),
    ("Rust Reference", "内联与 codegen 属性", "part2/ch06.md#sec-compilers.2.6.3", "背景", "内联提示"),

    # Rustc Dev Guide
    ("Rustc Dev Guide", "编译器高层结构", "part1/ch01.md#sec-compilers.1.1.4", "完整", "driver/pass"),
    ("Rustc Dev Guide", "查询系统", "part1/ch01.md#sec-compilers.1.1.7", "精选", "增量与缓存"),
    ("Rustc Dev Guide", "HIR 与 MIR", "part1/ch04.md#sec-compilers.1.4.7", "精选", "IR 谱系"),
    ("Rustc Dev Guide", "THIR 与类型检查", "part1/ch03.md#sec-compilers.1.3.4", "背景", "检查顺序"),
    ("Rustc Dev Guide", "类型推导", "part1/ch03.md#sec-compilers.1.3.4", "完整", "约束求解"),
    ("Rustc Dev Guide", "trait 求解", "part1/ch03.md#sec-compilers.1.3.5", "背景", "实例化"),
    ("Rustc Dev Guide", "借用检查", "part1/ch03.md#sec-compilers.1.3.5", "精选", "生命周期"),
    ("Rustc Dev Guide", "单态化", "part1/ch03.md#sec-compilers.1.3.5", "完整", "代码膨胀"),
    ("Rustc Dev Guide", "代码生成", "part2/ch08.md#sec-compilers.2.8.5", "完整", "后端"),
    ("Rustc Dev Guide", "LLVM 后端", "part2/ch07.md#sec-compilers.2.7.6", "交叉引用", "目标描述"),
    ("Rustc Dev Guide", "调试信息", "part1/ch01.md#sec-compilers.1.1.6", "精选", "可复现构建"),
    ("Rustc Dev Guide", "增量编译", "part1/ch01.md#sec-compilers.1.1.7", "完整", "查询缓存"),
    ("Rustc Dev Guide", "测试与编译测试", "part3/ch10.md#sec-compilers.3.10.4", "精选", "属性测试"),
    ("Rustc Dev Guide", "sanitizer", "part3/ch09.md#sec-compilers.3.9.4", "完整", "插桩"),
    ("Rustc Dev Guide", "fuzz 与回归", "part3/ch10.md#sec-compilers.3.10.2", "完整", "覆盖率"),
    ("Rustc Dev Guide", "性能剖析", "part1/ch01.md#sec-compilers.1.1.7", "背景", "预算"),
    ("Rustc Dev Guide", "交叉编译与目标", "part2/ch08.md#sec-compilers.2.8.1", "背景", "目标三元组"),

    # C 语言现代方法
    ("C 语言现代方法", "词法元素", "part1/ch02.md#sec-compilers.1.2.1", "精选", "token 边界"),
    ("C 语言现代方法", "声明与作用域", "part1/ch03.md#sec-compilers.1.3.2", "精选", "符号表"),
    ("C 语言现代方法", "表达式", "part1/ch02.md#sec-compilers.1.2.3", "背景", "优先级"),
    ("C 语言现代方法", "选择与循环", "part1/ch04.md#sec-compilers.1.4.2", "精选", "CFG 降级"),
    ("C 语言现代方法", "函数", "part2/ch08.md#sec-compilers.2.8.3", "精选", "调用"),
    ("C 语言现代方法", "指针与数组", "part3/ch09.md#sec-compilers.3.9.3", "精选", "越界 UB"),
    ("C 语言现代方法", "字符串", "part3/ch09.md#sec-compilers.3.9.3", "背景", "缓冲区"),
    ("C 语言现代方法", "预处理器", "part1/ch01.md#sec-compilers.1.1.6", "背景", "构建阶段"),
    ("C 语言现代方法", "程序组织", "part1/ch01.md#sec-compilers.1.1.3", "精选", "编译单元"),
    ("C 语言现代方法", "整数类型与转换", "part1/ch03.md#sec-compilers.1.3.6", "完整", "提升与截断"),
    ("C 语言现代方法", "浮点类型", "part2/ch08.md#sec-compilers.2.8.3", "背景", "调用约定"),
    ("C 语言现代方法", "指针算术", "part3/ch09.md#sec-compilers.3.9.3", "精选", "边界 UB"),
    ("C 语言现代方法", "未定义行为", "part3/ch09.md#sec-compilers.3.9.1", "完整", "可观察行为"),
    ("C 语言现代方法", "UB 的例子", "part3/ch09.md#sec-compilers.3.9.2", "完整", "分类"),
    ("C 语言现代方法", "链接", "part2/ch08.md#sec-compilers.2.8.1", "交叉引用", "指向 Linux 1.7"),

    # C++ 程序设计语言
    ("C++ 程序设计语言", "类型与对象", "part1/ch03.md#sec-compilers.1.3.1", "精选", "表示"),
    ("C++ 程序设计语言", "声明与作用域", "part1/ch03.md#sec-compilers.1.3.2", "精选", "名字查找"),
    ("C++ 程序设计语言", "表达式", "part1/ch02.md#sec-compilers.1.2.3", "背景", "求值顺序"),
    ("C++ 程序设计语言", "语句", "part1/ch04.md#sec-compilers.1.4.2", "背景", "控制流"),
    ("C++ 程序设计语言", "函数", "part2/ch08.md#sec-compilers.2.8.3", "精选", "调用/返回"),
    ("C++ 程序设计语言", "命名空间", "part1/ch03.md#sec-compilers.1.3.2", "背景", "限定名"),
    ("C++ 程序设计语言", "重载", "part1/ch03.md#sec-compilers.1.3.4", "精选", "重载决议"),
    ("C++ 程序设计语言", "模板", "part1/ch03.md#sec-compilers.1.3.5", "完整", "实例化"),
    ("C++ 程序设计语言", "类与布局", "part1/ch03.md#sec-compilers.1.3.3", "背景", "成员偏移"),
    ("C++ 程序设计语言", "优化", "part2/ch06.md#sec-compilers.2.6.6", "精选", "pass 顺序"),
    ("C++ 程序设计语言", "异常与栈展开", "part3/ch12.md#sec-compilers.3.12.1", "背景", "执行模型"),
    ("C++ 程序设计语言", "内联", "part2/ch06.md#sec-compilers.2.6.3", "精选", "成本模型"),

    # Effective Modern C++
    ("Effective Modern C++", "auto 与类型推导", "part1/ch03.md#sec-compilers.1.3.4", "精选", "推导规则"),
    ("Effective Modern C++", "移动语义", "part1/ch03.md#sec-compilers.1.3.6", "背景", "值类别"),
    ("Effective Modern C++", "完美转发", "part1/ch03.md#sec-compilers.1.3.5", "背景", "实例化"),
    ("Effective Modern C++", "智能指针与所有权", "part1/ch03.md#sec-compilers.1.3.6", "背景", "清理"),
    ("Effective Modern C++", "lambda 与闭包", "part1/ch03.md#sec-compilers.1.3.5", "背景", "捕获"),
    ("Effective Modern C++", "并发与数据竞争", "part3/ch09.md#sec-compilers.3.9.4", "背景", "TSan"),
    ("Effective Modern C++", "constexpr 与编译期计算", "part2/ch06.md#sec-compilers.2.6.4", "精选", "常量传播"),
    ("Effective Modern C++", "零开销抽象", "part2/ch07.md#sec-compilers.2.7.1", "精选", "指令选择"),
    ("Effective Modern C++", "内联与可见性", "part2/ch06.md#sec-compilers.2.6.3", "背景", "LTO"),
]


def page_anchors():
    out = {}
    for base, dirs, files in os.walk(SRC):
        dirs[:] = [d for d in dirs if d not in {"assets", "fonts"}]
        for f in files:
            if f.endswith(".md"):
                path = os.path.join(base, f)
                rel = os.path.relpath(path, SRC).replace(os.sep, "/")
                text = open(path, encoding="utf-8").read()
                out[rel] = set(re.findall(r"\{#([^\}\s]+)\}", text))
    return out


def check(units, anchors):
    problems = []
    seen = Counter()
    for source, unit, target, depth, note in units:
        key = (source, unit)
        seen[key] += 1
        if "#" not in target:
            problems.append(f"{source}/{unit}: 落点缺锚点")
            continue
        rel, anchor = target.split("#", 1)
        if rel not in anchors:
            problems.append(f"{source}/{unit}: 页面不存在 {rel}")
        elif anchor not in anchors[rel]:
            problems.append(f"{source}/{unit}: 锚点不存在 {target}")
        if depth not in {"完整", "精选", "背景", "交叉引用", "淘汰"}:
            problems.append(f"{source}/{unit}: 非法深度 {depth}")
    for key, n in seen.items():
        if n > 1:
            problems.append(f"重复单元：{key}")
    return problems


def render(units):
    srcs = []
    for s, *_ in units:
        if s not in srcs:
            srcs.append(s)
    stats = Counter((s, d) for s, _, _, d, _ in units)
    lines = []
    lines.append("# 附录 A · 母本覆盖矩阵\n")
    lines.append("本矩阵由 tools/build_coverage.py 生成并校验；每个单元必须映射到一个存在的节锚点。"
                 "「缺口 0」指没有未映射单元，不指逐字覆盖母本全文。\n")
    lines.append("## A.1 总览\n")
    lines.append("| 母本 | 单元 | 完整 | 精选 | 背景 | 交叉引用 | 淘汰 |")
    lines.append("|:--|--:|--:|--:|--:|--:|--:|")
    for s in srcs:
        n = sum(1 for x in units if x[0] == s)
        lines.append(f"| {s} | {n} | {stats[(s,'完整')]} | {stats[(s,'精选')]} | {stats[(s,'背景')]} | {stats[(s,'交叉引用')]} | {stats[(s,'淘汰')]} |")
    lines.append(f"| **合计** | **{len(units)}** | **{sum(1 for x in units if x[3]=='完整')}** | "
                 f"**{sum(1 for x in units if x[3]=='精选')}** | **{sum(1 for x in units if x[3]=='背景')}** | "
                 f"**{sum(1 for x in units if x[3]=='交叉引用')}** | **0** |\n")
    lines.append("## A.2 逐单元映射\n")
    lines.append("| # | 母本 | 单元 | 本书落点 | 深度 | 说明 |")
    lines.append("|--:|:--|:--|:--|:--|:--|")
    for i, (s, u, t, d, note) in enumerate(units, 1):
        rel, anchor = t.split("#", 1)
        lines.append(f"| {i} | {s} | {u} | [{rel}](../{rel}#{anchor}) | {d} | {note} |")
    lines.append("\n## A.3 缺口\n")
    lines.append("缺口：**0**。构建脚本在映射缺失、页面不存在、锚点不存在、深度非法或单元重复时拒绝写出。\n")
    return "\n".join(lines) + "\n"


def main():
    anchors = page_anchors()
    problems = check(UNITS, anchors)
    if problems:
        print(f"覆盖矩阵失败：{len(problems)} 个问题", file=sys.stderr)
        for p in problems:
            print("  -", p, file=sys.stderr)
        return 1
    text = render(UNITS)
    os.makedirs(os.path.dirname(OUT1), exist_ok=True)
    open(OUT1, "w", encoding="utf-8").write(text)
    open(OUT2, "w", encoding="utf-8").write(text.replace("](../", "](src/"))
    srcs = {s: sum(1 for x in UNITS if x[0] == s) for s in {x[0] for x in UNITS}}
    print(f"coverage: {len(UNITS)} units, gap=0")
    for s, n in srcs.items():
        print(f"  {s}: {n}")
    print(f"written: {os.path.relpath(OUT1, ROOT)}, {os.path.relpath(OUT2, ROOT)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
