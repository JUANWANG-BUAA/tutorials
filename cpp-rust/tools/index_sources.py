#!/usr/bin/env python3
"""Index local source metadata; extracting a page is NOT recorded as reading it."""
from pathlib import Path
import hashlib
import json
import xml.etree.ElementTree as ET
import zipfile
import fitz

ROOT = Path(__file__).resolve().parents[1]
PRIVATE = ROOT.parent / '.work' / 'cpp-rust-sources'
PRIVATE.mkdir(parents=True, exist_ok=True)
LIBRARY = Path.home() / 'E-Book'
paths = sorted((LIBRARY / 'C++').glob('*.pdf')) + sorted((LIBRARY / 'Rust').glob('*.pdf'))
paths += list((LIBRARY / 'C').glob('C语言程序设计：现代方法*.pdf'))
paths += list((LIBRARY / 'C').glob('CMake*.epub'))
manifest = []
for i, path in enumerate(paths, 1):
    sid = f'S{i:02}'
    row = dict(id=sid, filename=path.name, sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
               status='indexed-not-reviewed', units=[])
    if path.suffix == '.pdf':
        with fitz.open(path) as doc:
            row['pdf_pages'] = len(doc)
            row['units'] = [dict(level=level, title=title, pdf_page=page, status='unreviewed')
                            for level, title, page in doc.get_toc() if page > 0]
            # Chapter opening pages are private reading aids, not published book text.
            pages = sorted({p - 1 for level, _, p in doc.get_toc() if level <= 2 and p > 0})
            row['sampled_pages'] = [p + 1 for p in pages]
            extracts = [{'pdf_page': p + 1, 'text': doc[p].get_text()} for p in pages]
            (PRIVATE / f'{sid}-openings.json').write_text(json.dumps(extracts, ensure_ascii=False, indent=2))
    else:
        with zipfile.ZipFile(path) as archive:
            nav_name = next(n for n in archive.namelist() if n.endswith('/nav.xhtml'))
            nav = ET.fromstring(archive.read(nav_name))
            row['units'] = [dict(title=''.join(a.itertext()).strip(), epub_locator=a.attrib['href'], status='unreviewed')
                            for a in nav.iter('{http://www.w3.org/1999/xhtml}a')]
            row['pagination'] = 'reflowable EPUB; use XHTML locator, not fabricated print pages'
    manifest.append(row)
out = ROOT / 'sources' / 'inventory.json'
out.parent.mkdir(exist_ok=True)
out.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
print(f'{len(manifest)} source files; {sum(len(r["units"]) for r in manifest)} outline entries; all unreviewed')
