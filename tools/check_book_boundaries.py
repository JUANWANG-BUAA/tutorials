#!/usr/bin/env python3
"""Catch semantic boxes accidentally swallowing chapter or section headings."""
import json
import re
import sys
from pathlib import Path


def check_content(content):
    stack = []
    fence = None
    errors = []
    for number, line in enumerate(content.splitlines(), 1):
        marker = re.match(r'^ {0,3}(`{3,}|~{3,})(.*)$', line)
        if fence:
            if marker and marker[1][0] == fence[0] and len(marker[1]) >= fence[1] and not marker[2].strip():
                fence = None
            continue
        if marker:
            fence = (marker[1][0], len(marker[1]))
            continue
        if re.match(r'^\s*:::\s*$', line):
            if stack:
                stack.pop()
            else:
                errors.append({'line': number, 'reason': 'unexpected_box_close'})
        elif re.match(r'^\s*:::\s*[A-Za-z][\w-]*', line):
            stack.append(number)
        elif re.match(r'^ {0,3}#{1,2}\s', line) and stack:
            errors.append({'line': number, 'reason': 'section_inside_box', 'box_line': stack[-1]})
    errors.extend({'line': number, 'reason': 'unclosed_box'} for number in stack)
    return errors


def audit(root):
    files = sorted(Path(root).glob('*/src/**/*.md'))
    errors = []
    for path in files:
        errors.extend({'file': str(path), **error}
                      for error in check_content(path.read_text(encoding='utf-8')))
    return {'files': len(files), 'invalid_boundaries': errors}


if __name__ == '__main__':
    result = audit(sys.argv[1] if len(sys.argv) > 1 else Path(__file__).resolve().parent.parent)
    print(json.dumps(result, ensure_ascii=False))
    raise SystemExit(int(not result['files'] or bool(result['invalid_boundaries'])))
