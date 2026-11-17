#!/usr/bin/env python3
"""Regression checks for the teaching-box preprocessor."""
from contextlib import redirect_stderr
from html.parser import HTMLParser
from io import StringIO
import re
import unittest

import mathbook


class CodeText(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.inside = False
        self.parts = []

    def handle_starttag(self, tag, attrs):
        if tag == "code":
            self.inside = True

    def handle_endtag(self, tag):
        if tag == "code":
            self.inside = False

    def handle_data(self, data):
        if self.inside:
            self.parts.append(data)


class BoxCodeWhitespace(unittest.TestCase):
    def test_fenced_code_survives_nested_boxes_exactly(self):
        source = 'text = """first\n\n    third\n"""\n\n\ndef value():\n    return text\n'
        for marker in ("```", "~~~"):
            with self.subTest(marker=marker):
                content = ("::: ex Test\n\n::: sol Answer\n\n" + marker + "python\n"
                           + source + marker + "\n\n::: \n\n::: \n")
                table = mathbook.LabelTable()
                rendered = mathbook.render_tree(mathbook.parse_tree(content, "test.md", table), table, "test.md")
                self.assertEqual(table.errors, [])
                self.assertIsNone(re.search(r"\n[ \t]*\n", rendered))
                parsed = CodeText()
                parsed.feed(rendered)
                displayed = "".join(parsed.parts)
                self.assertEqual(displayed, source)
                namespace = {}
                exec(compile(displayed, "displayed-code", "exec"), namespace)
                self.assertEqual(namespace["value"](), "first\n\n    third\n")


class MarkdownAnchorReferences(unittest.TestCase):
    def test_counts_only_links_to_the_actual_page(self):
        table = mathbook.LabelTable()
        table.path = {
            "same": "ch01/section.html",
            "other": "ch02/section.html",
            "wrong": "ch03/section.html",
            "image": "ch01/section.html",
            "code": "ch01/section.html",
            "fenced": "ch01/section.html",
        }
        content = "\n".join([
            "[本页](#same)",
            "[跨页](../ch02/section.md#other)",
            "[错误页面](../ch02/section.md#wrong)",
            "![图片](#image)",
            "`[代码](#code)`",
            "[外站](https://example.com/ch03/section.html#wrong)",
            "```",
            "[代码块](#fenced)",
            "```",
        ])
        mathbook.mark_markdown_links(content, "ch01/section.md", table)
        self.assertEqual(table.used, {"same", "other"})


class MergedSectionNumbering(unittest.TestCase):
    @staticmethod
    def book(content):
        return {"sections": [{"Chapter": {
            "name": "6.1 拉格朗日公式", "path": "ch06/sec6-1.md",
            "source_path": "ch06/sec6-1.md", "number": [6, 1],
            "content": content, "sub_items": [],
        }}]}

    def test_each_subsection_has_its_own_letter_sequence(self):
        book = self.book(
            "::: ex 例 6.1.2.A · 势能 {#first}\n正文\n:::\n\n"
            "::: ex 例 6.1.3.A · 力矩 {#second}\n正文\n:::\n\n"
            "::: ex 例 6.1.3.B · 运动 {#third}\n正文\n:::\n\n"
            "见 [@first] 和 [@second]。\n"
        )
        mathbook.process(book)
        rendered = book["sections"][0]["Chapter"]["content"]
        self.assertIn('href="#first">例 6.1.2.A</a>', rendered)
        self.assertIn('href="#second">例 6.1.3.A</a>', rendered)

    def test_duplicate_and_reversed_numbers_still_fail(self):
        for labels, expected in (
            (("6.1.2.A", "6.1.2.A"), "撞号"),
            (("6.1.3.B", "6.1.3.A"), "递增"),
        ):
            with self.subTest(labels=labels), redirect_stderr(StringIO()) as errors:
                book = self.book(
                    f"::: ex 例 {labels[0]} · 先 {{#first}}\n正文\n:::\n\n"
                    f"::: thm 定理 {labels[1]} · 后 {{#second}}\n正文\n:::\n"
                )
                with self.assertRaises(SystemExit):
                    mathbook.process(book)
                self.assertIn(expected, errors.getvalue())


if __name__ == "__main__":
    unittest.main()
