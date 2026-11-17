#!/usr/bin/env python3
"""Check that searchable output keeps the exact TeX for formula copying."""

import html
from html.parser import HTMLParser
from pathlib import Path
import runpy
import unittest
from urllib.parse import unquote

katex_wrapper = runpy.run_path(str(Path(__file__).resolve().parents[2] / "tools" / "katex_wrapper.py"))
import katex_index


class AnnotationReader(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.uri = None

    def handle_starttag(self, tag, attrs):
        if tag == "annotation":
            self.uri = dict(attrs).get("src")


class TeXAnnotationTest(unittest.TestCase):
    def test_round_trip_special_characters_and_entities(self):
        source = r"\begin{bmatrix}a&b\\c&d\end{bmatrix} < \|x\|_1 ~ &#124; 中文"
        annotation = '<annotation encoding="application/x-tex">' + html.escape(source, quote=False) + '</annotation>'
        protected = katex_wrapper["neutralize_annotations"](annotation)
        result = katex_index.externalize(protected)
        parsed = AnnotationReader()
        parsed.feed(result)
        prefix = "data:application/x-tex,"
        uri = parsed.uri
        self.assertIsNotNone(uri)
        assert uri is not None
        self.assertTrue(uri.startswith(prefix))
        self.assertEqual(unquote(uri[len(prefix):]), source)
        self.assertNotIn(source, result)

    def test_other_annotations_are_not_changed(self):
        source = '<annotation encoding="text/plain">a &amp; b</annotation>'
        self.assertEqual(katex_index.externalize(source), source)


if __name__ == "__main__":
    unittest.main()
