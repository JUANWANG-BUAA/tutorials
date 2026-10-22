#!/usr/bin/env python3
"""Convert this experiment's macOS sample tree to exclusive folded stacks.

This is not a general parser for every sample report version. Reject negative
exclusive counts; retain the original report as the authoritative evidence.
"""
from collections import Counter
from pathlib import Path
import re
import sys


def collapse(text):
    tree = text.split("Call graph:\n", 1)[1].split("\nTotal number", 1)[0]
    frames = []
    result = Counter()
    for line in tree.splitlines():
        match = re.match(r"^([ +!|:]*)(\d+) (.+)$", line)
        if match is None:
            continue
        depth, count, symbol = len(match[1]), int(match[2]), match[3]
        # Remove addresses and source suffixes, retaining actual function names.
        symbol = symbol.split("  (in ")[0].split("   DispatchQueue_")[0]
        symbol = symbol.replace(";", ":")
        while frames and frames[-1][0] >= depth:
            emit(frames, result)
        if frames:
            frames[-1][3] += count
        frames.append([depth, count, symbol, 0])
    while frames:
        emit(frames, result)
    return result


def emit(frames, result):
    _, count, _, children = frames[-1]
    exclusive = count - children
    if exclusive < 0:
        raise ValueError("inconsistent inclusive tree")
    if exclusive:
        result[";".join(frame[2] for frame in frames)] += exclusive
    frames.pop()


def main():
    source, output = map(Path, sys.argv[1:])
    rows = collapse(source.read_text())
    with output.open("x") as stream:
        for path, count in sorted(rows.items()):
            stream.write(f"{path} {count}\n")
    print(f"exclusive observations={sum(rows.values())}; leaves={len(rows)}")


if __name__ == "__main__":
    main()
