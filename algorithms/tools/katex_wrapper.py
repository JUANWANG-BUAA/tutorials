#!/usr/bin/env python3
"""
Placeholder KaTeX wrapper for algorithms tutorial.
Real implementation will come from shared/tools/katex_wrapper.py.
"""
import sys
import json

def main():
    if len(sys.argv) > 1:
        if sys.argv[1] == "supports":
            sys.exit(0)

    context = json.load(sys.stdin)
    json.dump(context, sys.stdout)

if __name__ == "__main__":
    main()
