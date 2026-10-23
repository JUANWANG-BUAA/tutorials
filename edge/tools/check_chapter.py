#!/usr/bin/env python3
"""Check one substantial chapter using the shared edge structural checker."""
import json
import sys
from check_book import check_page

if len(sys.argv) != 2:
    raise SystemExit('usage: python3 tools/check_chapter.py partN/chNN.md')
result = check_page(sys.argv[1], sys.argv[1])
print(json.dumps({k: result[k] for k in ('rel', 'lines', 'h2', 'problems')}, ensure_ascii=False, indent=2))
raise SystemExit(bool(result['problems']))
