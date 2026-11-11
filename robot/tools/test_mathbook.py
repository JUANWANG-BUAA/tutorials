#!/usr/bin/env python3
"""Regression checks for code whitespace inside nested teaching boxes."""
from html.parser import HTMLParser
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


if __name__ == "__main__":
    unittest.main()
