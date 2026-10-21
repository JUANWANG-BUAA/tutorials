#!/usr/bin/env python3
"""Check generated runtime references without assuming a deployment prefix."""
import json
import re
import sys
from collections import Counter
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit


def audit(root):
    missing, duplicate, invalid_prepaint = [], [], []
    class Page(HTMLParser):
        def __init__(self, path):
            super().__init__()
            self.path, self.ids = path, []
            self.in_head = False
            self.preferences = []

        def handle_starttag(self, tag, attrs):
            attrs = dict(attrs)
            if tag == 'head':
                self.in_head = True
            if tag == 'script' and re.fullmatch(r'prefs-config-[0-9a-f]+\.js', Path(urlsplit(attrs.get('src', '')).path).name):
                self.preferences.append(self.in_head and 'async' not in attrs and 'defer' not in attrs and attrs.get('type', '').lower() != 'module')
            if attrs.get('id'):
                self.ids.append(attrs['id'])
            references = []
            if tag in ('script', 'img') and attrs.get('src'):
                references.append(attrs['src'])
            if tag == 'link' and attrs.get('rel') in ('stylesheet', 'preload', 'icon', 'shortcut icon'):
                references.append(attrs.get('href', ''))
            for key in ['data-scene', 'data-worker', 'data-glossary']:
                if attrs.get(key) and attrs[key] != '1':
                    references.append(attrs[key])
            for value in references:
                parsed = urlsplit(value)
                if parsed.scheme or parsed.netloc or not parsed.path:
                    continue
                if not (self.path.parent / unquote(parsed.path)).is_file():
                    missing.append([str(self.path.relative_to(root)), value])

        def handle_endtag(self, tag):
            if tag == 'head':
                self.in_head = False

    pages = list(root.rglob('*.html'))
    for path in pages:
        parser = Page(path)
        parser.feed(path.read_text())
        if parser.preferences != [True]:
            invalid_prepaint.append(str(path.relative_to(root)))
        if path.name not in ('print.html', 'toc.html'):
            duplicate.extend([str(path.relative_to(root)), key, n] for key, n in Counter(parser.ids).items() if n > 1)
    for path in root.rglob('*.css'):
        for _, value in re.findall(r'''url\(\s*(['"]?)([^)'"\s]+)\1\s*\)''', path.read_text()):
            parsed = urlsplit(value)
            if parsed.scheme or parsed.netloc or not parsed.path:
                continue
            if not (path.parent / unquote(parsed.path)).is_file():
                missing.append([str(path.relative_to(root)), value])
    result = {'pages': len(pages), 'missing_runtime_assets': missing, 'duplicate_ids': duplicate, 'invalid_prepaint_preferences': invalid_prepaint}
    print(json.dumps(result, ensure_ascii=False))
    return bool(not pages or missing or duplicate or invalid_prepaint)


if __name__ == '__main__':
    raise SystemExit(audit(Path(sys.argv[1] if len(sys.argv) > 1 else '_site')))
