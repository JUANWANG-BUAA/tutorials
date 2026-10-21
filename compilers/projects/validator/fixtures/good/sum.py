import sys


def main() -> int:
    parts = sys.stdin.read().split()
    if len(parts) != 2:
        print("need two integers", file=sys.stderr)
        return 2
    print(int(parts[0]) + int(parts[1]))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
