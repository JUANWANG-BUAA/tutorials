"""Tracked books shipping katex.css must ship its referenced fonts in git.

`theme/css/katex.css` loads faces via `url(../../fonts/katex/<name>.woff2)`.
mdBook copies `src/` to the output root, so those URLs land on
`<book>/fonts/katex/<name>.woff2`, which must come from `src/fonts/katex/`.
A copy that exists only on the author's disk is invisible to CI: the build
emits CSS whose font URLs cannot be rewritten, `optimize_assets` pools the
broken CSS verbatim, and `audit_site_assets` fails the deploy with20 missing
runtime assets. Catch that at the source tree instead.
"""
import re
import subprocess
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
FONT_URL = re.compile(r"url\(\s*['\"]?([^)'\"]*fonts/katex/([^)'\"]+))")


class KatexFontTrackingTests(unittest.TestCase):
    def test_katex_css_fonts_are_committed(self):
        book_configs = subprocess.check_output(
            ["git", "ls-files", "--", "*/book.toml"], cwd=REPO, text=True
        ).split()
        self.assertTrue(book_configs, "expected tracked book.toml files")
        checked = 0
        for entry in book_configs:
            book_dir = REPO / entry.rsplit("/", 1)[0]
            css = book_dir / "theme/css/katex.css"
            if not css.is_file():
                continue
            fonts_dir = book_dir / "src/fonts/katex"
            with self.subTest(book=book_dir.name):
                tracked = subprocess.check_output(
                    ["git", "ls-files", "--", str(fonts_dir.relative_to(REPO))],
                    cwd=REPO,
                    text=True,
                ).split()
                self.assertTrue(
                    tracked,
                    f"{book_dir.name}/src/fonts/katex is not tracked; CI builds "
                    "without these fonts and the asset audit rejects the site",
                )
                names = [name for _, name in FONT_URL.findall(css.read_text())]
                self.assertTrue(names, f"{css} declares no fonts/katex urls")
                for name in names:
                    font = fonts_dir / name
                    self.assertTrue(font.is_file(), f"{font} missing")
                    # Resolve symlinks (compilers/distributed link into matrix)
                    # so a tracked link pointing at untracked bytes still fails.
                    real = font.resolve().relative_to(REPO)
                    self.assertTrue(
                        subprocess.check_output(
                            ["git", "ls-files", "--", str(real)],
                            cwd=REPO,
                            text=True,
                        ).split(),
                        f"{real} is not tracked; CI would build without it",
                    )
                checked += 1
        self.assertGreaterEqual(
            checked, 2, "expected several tracked books to ship katex.css"
        )


if __name__ == "__main__":
    unittest.main()
