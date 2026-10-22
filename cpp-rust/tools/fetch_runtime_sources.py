#!/usr/bin/env python3
"""Fetch only explicitly listed supporting sources; fetching is not reviewing."""
import hashlib
import json
from pathlib import Path
from urllib.request import urlopen
from bs4 import BeautifulSoup

ROOT = Path(__file__).resolve().parents[1]
CACHE = ROOT.parent / '.work/cpp-rust-sources/web'
URLS = {
    'stanford-process-slides': 'https://web.stanford.edu/class/cs110l/slides/lecture-10-2022.pdf',
    'mit-scheduling': 'https://pdos.csail.mit.edu/6.S081/2020/lec/l-threads.txt',
    'tokio-runtime': 'https://docs.rs/tokio/1.54.0/tokio/runtime/index.html',
    'tokio-blocking': 'https://docs.rs/tokio/1.54.0/tokio/task/fn.spawn_blocking.html',
    'tokio-process': 'https://docs.rs/tokio/1.54.0/tokio/process/index.html',
    'std-child': 'https://doc.rust-lang.org/1.99.0/std/process/struct.Child.html',
}

def main():
    CACHE.mkdir(parents=True, exist_ok=True)
    manifest = ROOT / 'sources/web.json'
    rows = json.loads(manifest.read_text())
    for key, url in URLS.items():
        with urlopen(url, timeout=45) as response:
            data, final = response.read(), response.url
        ext = '.pdf' if data.startswith(b'%PDF') else '.html' if b'<html' in data[:1000].lower() else '.txt'
        (CACHE / (key + ext)).write_bytes(data)
        if ext == '.html':
            soup = BeautifulSoup(data, 'html.parser')
            main_node = soup.find('main') or soup
            (CACHE / (key + '.txt')).write_text(main_node.get_text('\n', strip=True))
        rows = [r for r in rows if r['id'] != key] + [dict(
            id=key, url=url, final_url=final, sha256=hashlib.sha256(data).hexdigest(),
            bytes=len(data), status='fetched-not-reviewed')]
        manifest.write_text(json.dumps(rows, ensure_ascii=False, indent=2) + '\n')
        print(key, len(data), ext)

if __name__ == '__main__':
    main()
