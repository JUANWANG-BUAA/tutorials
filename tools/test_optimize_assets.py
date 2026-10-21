"""Build-time regression checks, independent of mdBook or network access."""
import contextlib
import hashlib
import io
import re
import tempfile
import unittest
from pathlib import Path

from audit_site_assets import audit
from optimize_assets import optimize

REPO = Path(__file__).resolve().parent.parent


class AssetBuildTests(unittest.TestCase):
    def test_shared_urls_css_dependencies_search_fallback_and_content_updates(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for name in ["cache-worker.js", "js/cache-client.js"]:
                dest = root / "shared/theme" / name
                dest.parent.mkdir(parents=True, exist_ok=True)
                dest.write_bytes((REPO / "shared/theme" / name).read_bytes())
            for book in ["matrix", "robot"]:
                folder = root / book
                (folder / "css").mkdir(parents=True)
                (folder / "fonts").mkdir()
                (folder / "deep").mkdir()
                (folder / "fonts/font.woff2").write_bytes(b"same-font")
                (folder / "css/style.css").write_text('@font-face{src:url("../fonts/font.woff2")}')
                (folder / "prefs-config-12345678.js").write_text("window.prefs = 1;")
                (folder / "searchindex-12345678.js").write_text("window.search = " + repr(book) + ";")
                (folder / "searcher-12345678.js").write_text("var fallback = path_to_root + 'searchindex-12345678.js';")
                (folder / "toc-12345678.js").write_text("window.position = sessionStorage.getItem('position');")
                (folder / "book-12345678.js").write_text("localStorage.removeItem('mdbook-theme');")
                (folder / "glossary.json").write_text('{"page":"terms.html"}')
                (folder / "deep/page.html").write_text('''<html data-glossary="1"><head>
<link rel="stylesheet" href="../css/style.css"><script src="../prefs-config-12345678.js"></script></head>
<body><script>window.path_to_searchindex_js = "../searchindex-12345678.js";</script>
<script src="../searcher-12345678.js"></script><script src="../prefs-config-12345678.js"></script></body></html>''')
            stats = optimize(root)
            pages = [(root / b / "deep/page.html").read_text() for b in ["matrix", "robot"]]
            css = [re.search(r'href="([^"]+)"', page)[1] for page in pages]
            self.assertEqual(css[0], css[1])
            pool = root / "shared/cache"
            for file in pool.iterdir():
                self.assertIn(hashlib.sha256(file.read_bytes()).hexdigest()[:16], file.name)
                if file.suffix == ".css":
                    self.assertTrue((pool / re.search(r'url\("([^"]+)"\)', file.read_text())[1]).exists())
            indices = [re.search(r'window.path_to_searchindex_js = "([^"]+)"', page)[1] for page in pages]
            self.assertNotEqual(indices[0], indices[1])
            self.assertIn("data-glossary=\"../../shared/cache/glossary-", pages[0])
            self.assertEqual(pages[0].count("prefs-config-"), 1)
            self.assertIn('data-worker="../../cache-worker.js"', pages[0])
            self.assertLess(stats['pooled_files'], stats['original_files'])
            self.assertFalse((root / "matrix/searchindex-12345678.js").exists())
            worker = (root / "cache-worker.js").read_text()
            self.assertNotIn('/* ASSET_BYTES */ {}', worker)
            for file in pool.glob('searcher-*.js'):
                fallback = re.search(r"path_to_root \+ '([^']+)'", file.read_text())[1]
                self.assertTrue((root / "matrix" / fallback).exists())
            self.assertIn("globalThis.sessionStorage", next(pool.glob('toc-*.js')).read_text())
            self.assertIn("try { localStorage.removeItem", next(pool.glob('book-*.js')).read_text())


class PrepaintAuditTests(unittest.TestCase):
    def test_only_one_blocking_head_script_passes(self):
        cases = [
            ('<head><script src="prefs-config-1234.js"></script></head>', False),
            ('<head></head><script src="prefs-config-1234.js"></script>', True),
            ('<head><script defer src="prefs-config-1234.js"></script></head>', True),
            ('<head><script async src="prefs-config-1234.js"></script></head>', True),
            ('<head><script type="module" src="prefs-config-1234.js"></script></head>', True),
            ('<head><script src="prefs-config-1234.js"></script></head><script src="prefs-config-1234.js"></script>', True),
            ('<head></head>', True),
        ]
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'prefs-config-1234.js').write_text('window.prefs = 1;')
            for markup, expected in cases:
                with self.subTest(markup=markup):
                    (root / 'index.html').write_text(markup)
                    with contextlib.redirect_stdout(io.StringIO()):
                        self.assertEqual(audit(root), expected)

    def test_an_empty_site_is_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            with contextlib.redirect_stdout(io.StringIO()):
                self.assertTrue(audit(Path(directory)))


if __name__ == '__main__':
    unittest.main()
