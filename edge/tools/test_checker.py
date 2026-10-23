#!/usr/bin/env python3
"""Regression tests for structural gates; not a technical content audit."""
import contextlib
import io
import tempfile
import unittest
from unittest.mock import patch
import check_book


class CheckerTests(unittest.TestCase):
    def test_empty_summary_is_not_success(self):
        with patch.object(check_book, 'pages_from_summary', return_value=[]):
            with contextlib.redirect_stdout(io.StringIO()):
                self.assertEqual(check_book.main(), 1)

    def test_missing_chapter_numbers_is_not_success(self):
        with patch.object(check_book, 'pages_from_summary', return_value=[('4', 'part1/ch04.md')]):
            with contextlib.redirect_stdout(io.StringIO()):
                self.assertEqual(check_book.main(), 1)

    def test_qualified_layout_is_recognized(self):
        result = check_book.check_page('4', 'part1/ch04.md')
        self.assertFalse(any('pre.layout' in p for p in result['problems']))

    def test_trap_heading_is_not_agent_case(self):
        # The genuine chapter has numbered lists in its agent case as well.
        # Only the final 本章陷阱 section is subject to the 10–15 count.
        result = check_book.check_page('4', 'part1/ch04.md')
        self.assertFalse(any('陷阱条数' in p for p in result['problems']))

    def test_unclosed_fence_is_detected(self):
        _, problems = check_book.strip_fenced('```c\nint x;\n')
        self.assertTrue(any('未闭合' in message for _, message in problems))

    def test_valid_fence_is_accepted(self):
        _, problems = check_book.strip_fenced('```c\nint x;\n```\n')
        self.assertEqual(problems, [])

    def test_missing_page_is_explicit(self):
        with tempfile.TemporaryDirectory() as root:
            with patch.object(check_book, 'SRC', root):
                result = check_book.check_page('6', 'part2/ch06.md')
                self.assertTrue(result['missing'])
                self.assertIn('文件不存在', result['problems'])


if __name__ == '__main__':
    unittest.main()
