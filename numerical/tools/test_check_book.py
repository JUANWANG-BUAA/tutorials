"""Regression checks for source validation independent of stale rendered pages."""

from __future__ import annotations

import importlib.util
from pathlib import Path
from tempfile import TemporaryDirectory
import unittest
from unittest.mock import patch

SPEC = importlib.util.spec_from_file_location(
    "numerical_check_book", Path(__file__).with_name("check_book.py")
)
assert SPEC is not None and SPEC.loader is not None
checker = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(checker)


class SourceLinkTests(unittest.TestCase):
    def check_link(self, fragment: str) -> list[str]:
        with TemporaryDirectory() as directory:
            root = Path(directory)
            src = root / "src"
            src.mkdir()
            (root / "book").mkdir()
            (root / "book" / "target.html").write_text(
                '<a id="removed"></a>', encoding="utf-8"
            )
            texts = {
                "index.md": f"# Index\n\n[example](target.md#{fragment})\n",
                "target.md": '# Target\n\n<a id="added"></a>\n',
            }
            for rel, text in texts.items():
                (src / rel).write_text(text, encoding="utf-8")
            ids = {rel: checker.page_id_set(rel, text) for rel, text in texts.items()}
            with patch.object(checker, "ROOT", root), patch.object(checker, "SRC", src):
                checker.problems.clear()
                checker.check_links([(rel, rel) for rel in texts], texts, ids)
                return list(checker.problems)

    def test_removed_source_anchor_is_not_rescued_by_old_html(self) -> None:
        self.assertTrue(any("removed" in error for error in self.check_link("removed")))

    def test_new_source_anchor_is_not_rejected_by_old_html(self) -> None:
        self.assertEqual(self.check_link("added"), [])

    def test_existing_box_types_come_from_the_real_preprocessor(self) -> None:
        self.assertTrue({"def", "thm", "ex", "note", "sol"} <= checker.ALLOWED_BOX)
        self.assertTrue({"lecture", "definition", "example"}.isdisjoint(checker.ALLOWED_BOX))


if __name__ == "__main__":
    unittest.main()
