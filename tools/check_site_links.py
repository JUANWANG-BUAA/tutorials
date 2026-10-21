#!/usr/bin/env python3
"""Validate generated local hyperlinks and fragments across every book."""
import argparse
import json
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit


class Page(HTMLParser):
    def __init__(self):
        super().__init__()
        self.ids = set()
        self.links = []

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if attrs.get('id'):
            self.ids.add(attrs['id'])
        if tag == 'a' and attrs.get('name'):
            self.ids.add(attrs['name'])
        if tag in ('a', 'area') and attrs.get('href'):
            self.links.append((self.getpos()[0], attrs['href']))


def audit(root, site_url='https://juanwang-buaa.github.io/tutorials/'):
    root = Path(root).resolve()
    site = urlsplit(site_url)
    prefix = site.path.rstrip('/') + '/'
    pages = {}
    for path in sorted(root.rglob('*.html')):
        page = Page()
        page.feed(path.read_text(encoding='utf-8'))
        pages[path] = page

    broken = []
    checked = 0
    for path, page in pages.items():
        for line, href in page.links:
            url = urlsplit(href)
            if url.scheme or url.netloc:
                if url.scheme not in ('', 'http', 'https') or url.netloc.lower() != site.netloc.lower():
                    continue
            url_path = unquote(url.path)
            if url_path.startswith('/'):
                if url_path == prefix.rstrip('/'):
                    url_path += '/'
                if not url_path.startswith(prefix):
                    continue  # Outside this deployed project's route.
                target = root / url_path[len(prefix):]
            else:
                # mdBook serves this page at the missing URL, whose depth is unknown.
                if path.name == '404.html':
                    continue
                target = path.parent / url_path if url_path else path
            target = target.resolve()
            if target.is_dir():
                target /= 'index.html'
            checked += 1
            reason = None
            if not target.is_relative_to(root):
                reason = 'outside_site'
            elif not target.is_file():
                reason = 'missing_file'
            else:
                fragment = unquote(url.fragment).split(':~:', 1)[0]
                if fragment and target in pages and fragment not in pages[target].ids:
                    reason = 'missing_anchor'
            if reason:
                broken.append({'page': str(path.relative_to(root)), 'line': line,
                               'href': href, 'reason': reason})
    return {'pages': len(pages), 'checked_links': checked, 'broken_links': broken}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('root', nargs='?', default='_site')
    parser.add_argument('--site-url', default='https://juanwang-buaa.github.io/tutorials/')
    args = parser.parse_args()
    result = audit(args.root, args.site_url)
    print(json.dumps(result, ensure_ascii=False))
    return int(not result['pages'] or bool(result['broken_links']))


if __name__ == '__main__':
    raise SystemExit(main())
