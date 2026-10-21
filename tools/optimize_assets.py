#!/usr/bin/env python3
"""Pool identical browser resources across books and fingerprint final bytes.

Run once on the assembled _site, after search/glossary/image postprocessing.
No runtime dependency, CDN, absolute deployment prefix or server header needed.
"""
from __future__ import annotations

import hashlib
import html
import json
import os
import re
import sys
from pathlib import Path
from urllib.parse import unquote, urlsplit

EXTENSIONS = {".js", ".css", ".woff", ".woff2", ".ttf", ".otf", ".eot"}
CSS_URL = re.compile(r"url\(\s*(['\"]?)([^)'\"]+)\1\s*\)")
REFERENCE = re.compile(r'''((?:src|href|data-scene|data-glossary)\s*=\s*["'])([^"']+)(["'])''', re.I)
SEARCH_URL = re.compile(r'''(window\.path_to_searchindex_js\s*=\s*["'])([^"']+)(["'])''')


def optimize(root: Path) -> dict:
    root = root.resolve()
    pool = root / "shared/cache"
    if pool.exists():
        raise ValueError("Asset pooling runs once per clean build; rebuild before repeating it")
    pool.mkdir(parents=True)
    originals = sorted(p for p in root.rglob("*") if p.is_file() and p.name != "cache-worker.js" and
                       (p.suffix in EXTENSIONS or p.name == "glossary.json"))
    mapping: dict[Path, Path] = {}
    content_names: dict[tuple[str, str], Path] = {}
    visiting: set[Path] = set()
    before = sum(p.stat().st_size for p in originals)

    def resolve(source: Path, url: str) -> Path | None:
        parsed = urlsplit(html.unescape(url))
        if parsed.scheme or parsed.netloc or not parsed.path or parsed.path.startswith("/"):
            return None
        target = (source.parent / unquote(parsed.path)).resolve()
        return target if target.is_relative_to(root) and target.is_file() else None

    def relative(target: Path, source: Path) -> str:
        return Path(os.path.relpath(target, source.parent)).as_posix()

    def asset(source: Path) -> Path:
        if source in mapping:
            return mapping[source]
        if source in visiting:
            raise ValueError(f"Circular CSS imports: {source}")
        visiting.add(source)
        data = source.read_bytes()
        if source.name.startswith("toc-") and source.suffix == ".js":
            # mdBook 0.5's sidebar uses sessionStorage without a guard. A
            # denied storage permission must not abort its connectedCallback.
            data = ("""(function () {
const sessionStorage = {
  getItem(key) { try { return globalThis.sessionStorage.getItem(key); } catch { return null; } },
  setItem(key, value) { try { globalThis.sessionStorage.setItem(key, value); } catch {} },
  removeItem(key) { try { globalThis.sessionStorage.removeItem(key); } catch {} }
};
""" + data.decode() + "\n})();\n").encode()
        if source.name.startswith("book-") and source.suffix == ".js":
            data = data.decode().replace(
                "localStorage.removeItem('mdbook-theme');",
                "try { localStorage.removeItem('mdbook-theme'); } catch {}"
            ).encode()
        if source.suffix == ".css":
            def css_url(match):
                value = match[2].strip()
                target = resolve(source, value)
                if target is None:
                    return match[0]
                moved = asset(target) if target.suffix in EXTENSIONS else target
                suffix = value[len(urlsplit(value).path):]
                return 'url("' + relative(moved, pool / "placeholder.css") + suffix + '")'
            data = CSS_URL.sub(css_url, data.decode()).encode()
        # Native searcher's fallback is relative to the book, rather than to
        # the JS file. Keep it valid even when the shared JS URL moves.
        if source.name.startswith("searcher-"):
            text = data.decode()
            def fallback(match):
                target = resolve(source, match[1])
                return "path_to_root + '" + relative(asset(target), source) + "'" if target else match[0]
            data = re.sub(r"path_to_root \+ '(searchindex-[a-f0-9]+\.js)'", fallback, text).encode()
        digest = hashlib.sha256(data).hexdigest()[:16]
        identity = (digest, source.suffix)
        if identity not in content_names:
            stem = re.sub(r"-[a-f0-9]{8}(?=\.|$)", "", source.stem)
            target = pool / f"{stem}-{digest}{source.suffix}"
            target.write_bytes(data)
            content_names[identity] = target
        mapping[source] = content_names[identity]
        visiting.remove(source)
        return mapping[source]

    for source in originals:
        asset(source)

    client = asset(root / "shared/theme/js/cache-client.js")
    for page in root.rglob("*.html"):
        text = page.read_text()
        if 'data-glossary="1"' in text:
            # The JSON's internal chapter links still resolve against book root.
            book = page.relative_to(root).parts[0]
            glossary = root / book / "glossary.json"
            if glossary in mapping:
                text = text.replace('data-glossary="1"', 'data-glossary="' + relative(mapping[glossary], page) + '"')

        def replace(match):
            target = resolve(page, match[2])
            if target not in mapping:
                return match[0]
            value = match[2]
            suffix = value[len(urlsplit(value).path):]
            return match[1] + relative(mapping[target], page) + suffix + match[3]
        text = REFERENCE.sub(replace, text)
        text = SEARCH_URL.sub(replace, text)
        # Preserve the pre-paint preference script, discard its redundant load
        # at the bottom (mdBook additional-js is also its fingerprint registry).
        seen_prefs = False
        def dedupe(match):
            nonlocal seen_prefs
            if "prefs-config-" not in match[0]:
                return match[0]
            if seen_prefs:
                return ""
            seen_prefs = True
            return match[0]
        text = re.sub(r'<script\b[^>]*\bsrc="[^"]+"[^>]*>\s*</script>', dedupe, text)
        loader = '<script defer src="' + relative(client, page) + '" data-worker="' + relative(root / "cache-worker.js", page) + '"></script>'
        text = text.replace("</body>", loader + "\n</body>")
        page.write_text(text)

    manifest = {p.name: p.stat().st_size for p in sorted(pool.iterdir())}
    worker = (root / "shared/theme/cache-worker.js").read_text()
    (root / "cache-worker.js").write_text(worker.replace("/* ASSET_BYTES */ {}", json.dumps(manifest, separators=(",", ":"))))
    for source in originals:
        source.unlink()
    (root / "shared/theme/cache-worker.js").unlink()
    stats = {"original_files": len(originals), "pooled_files": len(manifest),
             "original_bytes": before, "pooled_bytes": sum(manifest.values())}
    print("asset-cache:", json.dumps(stats))
    return stats


if __name__ == "__main__":
    optimize(Path(sys.argv[1] if len(sys.argv) > 1 else "_site"))
