#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""核验构建产物：生成的 HTML 到底平不平衡。

mdBook 自带的检查器会把代码块里正确转义过的 `&lt;` 先解码再按标签起点处理，
于是对 `exec 3</etc/hosts`、`done < <(...)` 这类行报出一堆 WARN。判据不能靠
人记，所以这里用 Python 的 HTMLParser 复核**真正交付的 HTML**：它的分词器不会
把实体当成标签开头，栈最终应当为空。

用法：
    python3 tools/check_html.py            # 检查 book/ 全部页面
    python3 tools/check_html.py part0      # 只检查某个目录前缀
    python3 mdbook build . && python3 tools/check_html.py

退出码 0 表示产物里没有真实的断标签。
"""

from __future__ import annotations

import os
import re
import sys
from html.parser import HTMLParser

HERE = os.path.dirname(os.path.abspath(__file__))
BOOK = os.path.normpath(os.path.join(HERE, "..", "book"))

VOID = {"area", "base", "br", "col", "embed", "hr", "img", "input", "link",
        "meta", "param", "source", "track", "wbr"}
# 允许隐式闭合：HTML 规范里这些标签会被后一个同类或块级标签自动关掉。
OPTIONAL_CLOSE = {"li", "p", "tr", "td", "th", "dd", "dt", "option"}


class Balance(HTMLParser):
    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.stack: list[tuple[str, int]] = []
        self.errors: list[str] = []

    def handle_starttag(self, tag, attrs):
        if tag in VOID:
            return
        if tag in OPTIONAL_CLOSE:
            self._close_optional(tag)
        self.stack.append((tag, self.getpos()[0]))

    def handle_startendtag(self, tag, attrs):
        pass

    def handle_endtag(self, tag):
        if tag in VOID:
            return
        for i in range(len(self.stack) - 1, -1, -1):
            if self.stack[i][0] == tag:
                # 中间未闭合的标签里，只有允许隐式闭合的才算正常
                for name, line in self.stack[i + 1:]:
                    if name not in OPTIONAL_CLOSE:
                        self.errors.append(
                            f"第 {line} 行 <{name}> 在 </{tag}> 之前没有闭合")
                del self.stack[i:]
                return
        # 隐式闭合过的 p/li 再遇到显式结束标签是合法的，浏览器也忽略
        if tag not in OPTIONAL_CLOSE:
            self.errors.append(f"第 {self.getpos()[0]} 行 多余的 </{tag}>")

    def _close_optional(self, tag):
        for i in range(len(self.stack) - 1, -1, -1):
            if self.stack[i][0] == tag:
                del self.stack[i:]
                return
            if self.stack[i][0] not in OPTIONAL_CLOSE:
                return

    def finish(self):
        for name, line in self.stack:
            if name not in OPTIONAL_CLOSE and name != "html":
                self.errors.append(f"第 {line} 行 <{name}> 到文件结束仍未闭合")


def newest_mtime(root: str, suffix: str) -> tuple[float, str]:
    """返回该目录下指定后缀文件的最新修改时间与路径。"""
    best, path = -1.0, ""
    for dirpath, _, files in os.walk(root):
        for fn in files:
            if fn.endswith(suffix):
                p = os.path.join(dirpath, fn)
                m = os.path.getmtime(p)
                if m > best:
                    best, path = m, p
    return best, path


def summary_pages() -> int:
    src = os.path.join(os.path.dirname(BOOK), "src", "SUMMARY.md")
    if not os.path.exists(src):
        return 0
    n = 0
    for line in open(src, encoding="utf-8"):
        if re.match(r"^\s*- \[.+?\]\(.+?\.md\)\s*$", line):
            n += 1
    return n


def main() -> int:
    prefix = sys.argv[1] if len(sys.argv) > 1 else ""
    if not os.path.isdir(BOOK):
        print(f"没有构建产物 {BOOK}；先跑 mdbook build .", file=sys.stderr)
        return 2

    src_new, src_path = newest_mtime(os.path.join(os.path.dirname(BOOK), "src"), ".md")
    book_new, book_path = newest_mtime(BOOK, ".html")
    if src_new > book_new:
        import datetime as dt
        print("check_html 失败：构建产物比源码旧，现在报的是上一次成功构建的结果。",
              file=sys.stderr)
        print(f"  最新源码：{src_path}（{dt.datetime.fromtimestamp(src_new):%H:%M:%S}）",
              file=sys.stderr)
        print(f"  最新产物：{book_path}（{dt.datetime.fromtimestamp(book_new):%H:%M:%S}）",
              file=sys.stderr)
        print("  两种失败路径：预处理器失败（缺 markdown-it-py）会留下旧产物骗过本检查；"
              "mdbook 自身 panic（如构建时正文代理还在写）会清空 book/。"
              "先确认没有写者在跑，再重新执行：PATH=/usr/bin:$PATH mdbook build .",
              file=sys.stderr)
        return 1

    registered = summary_pages()
    checked = bad = 0
    for root, _, files in os.walk(BOOK):
        for fn in sorted(files):
            if not fn.endswith(".html"):
                continue
            path = os.path.join(root, fn)
            rel = os.path.relpath(path, BOOK).replace(os.sep, "/")
            if prefix and not rel.startswith(prefix):
                continue
            checked += 1
            parser = Balance()
            parser.feed(open(path, encoding="utf-8").read())
            parser.finish()
            if parser.errors:
                bad += 1
                print(f"真实断标签：{rel}")
                for e in parser.errors[:8]:
                    print(f"  - {e}")

    if bad:
        print(f"\ncheck_html 失败：{bad}/{checked} 页有真实断标签。", file=sys.stderr)
        return 1
    print(f"check_html 通过：{checked} 页的交付 HTML 标签栈都平衡"
          f"（SUMMARY 登记 {registered} 页）。")
    if registered and checked < registered:
        print(f"注意：产物页数少于 SUMMARY 登记页数，可能有页面没构建出来。", file=sys.stderr)
        return 1
    print("（mdBook 的 WARN 若集中在含 `&lt;` 代码块的页面，属它自身把实体解码后"
          "误判为标签起点；以本脚本结论为准。）")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
