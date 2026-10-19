#!/usr/bin/env python3
"""inspect_linux.py — 读取并解释 Linux 的 /proc/<pid>/status 权限字段。

用法：
    python3 experiments/ch04/inspect_linux.py
    python3 experiments/ch04/inspect_linux.py --pid 1234
    python3 experiments/ch04/inspect_linux.py --file /tmp/status.sample
    python3 experiments/ch04/inspect_linux.py --json

设计取舍：
- 非 Linux 平台不是错误：打印原因后以 0 退出，方便放进跨平台测试矩阵；
  真正要在 Linux 上做门禁时用 --strict（Linux 上读不到 /proc 才非零）。
- 只依赖 Python 3.11 标准库。
"""

from __future__ import annotations

import argparse
import json
import platform
import sys
from pathlib import Path

CAP_NAMES = [
    "CAP_CHOWN",
    "CAP_DAC_OVERRIDE",
    "CAP_DAC_READ_SEARCH",
    "CAP_FOWNER",
    "CAP_FSETID",
    "CAP_KILL",
    "CAP_SETGID",
    "CAP_SETUID",
    "CAP_SETPCAP",
    "CAP_LINUX_IMMUTABLE",
    "CAP_NET_BIND_SERVICE",
    "CAP_NET_BROADCAST",
    "CAP_NET_ADMIN",
    "CAP_NET_RAW",
    "CAP_IPC_LOCK",
    "CAP_IPC_OWNER",
    "CAP_SYS_MODULE",
    "CAP_SYS_RAWIO",
    "CAP_SYS_CHROOT",
    "CAP_SYS_PTRACE",
    "CAP_SYS_PACCT",
    "CAP_SYS_ADMIN",
    "CAP_SYS_BOOT",
    "CAP_SYS_NICE",
    "CAP_SYS_RESOURCE",
    "CAP_SYS_TIME",
    "CAP_SYS_TTY_CONFIG",
    "CAP_MKNOD",
    "CAP_LEASE",
    "CAP_AUDIT_WRITE",
    "CAP_AUDIT_CONTROL",
    "CAP_SETFCAP",
    "CAP_MAC_OVERRIDE",
    "CAP_MAC_ADMIN",
    "CAP_SYSLOG",
    "CAP_WAKE_ALARM",
    "CAP_BLOCK_SUSPEND",
    "CAP_AUDIT_READ",
    "CAP_PERFMON",
    "CAP_BPF",
    "CAP_CHECKPOINT_RESTORE",
]

SECCOMP_MODES = {
    0: "disabled",
    1: "strict",
    2: "filter",
}

CAP_FIELDS = ("CapInh", "CapPrm", "CapEff", "CapBnd", "CapAmb")


def parse_status(text: str) -> dict[str, str]:
    fields: dict[str, str] = {}
    for line in text.splitlines():
        key, sep, value = line.partition(":")
        if sep:
            fields[key.strip()] = value.strip()
    return fields


def decode_caps(hex_value: str) -> list[str]:
    try:
        bits = int(hex_value, 16)
    except ValueError:
        return []
    return [name for i, name in enumerate(CAP_NAMES) if bits & (1 << i)]


def describe(source: str, fields: dict[str, str]) -> dict[str, object]:
    result: dict[str, object] = {"source": source}
    for key in ("Uid", "Gid", "Groups"):
        if key in fields:
            result[key] = " ".join(fields[key].split())

    for key in CAP_FIELDS:
        raw = fields.get(key)
        if raw is None:
            continue
        names = decode_caps(raw)
        result[key] = {
            "hex": raw,
            "count": len(names),
            "names": names,
        }

    nnp = fields.get("NoNewPrivs")
    if nnp is not None:
        result["NoNewPrivs"] = {"value": int(nnp), "set": nnp == "1"}

    seccomp = fields.get("Seccomp")
    if seccomp is not None:
        mode = int(seccomp)
        result["Seccomp"] = {
            "value": mode,
            "mode": SECCOMP_MODES.get(mode, "unknown"),
        }

    filters = fields.get("Seccomp_filters")
    if filters is not None:
        result["Seccomp_filters"] = int(filters)
    return result


def print_human(data: dict[str, object]) -> None:
    print(f"source: {data['source']}")
    for key in ("Uid", "Gid", "Groups"):
        if key in data:
            print(f"{key}: {data[key]}")

    for key in CAP_FIELDS:
        item = data.get(key)
        if not isinstance(item, dict):
            continue
        names = item["names"]
        if key == "CapBnd":
            # bounding 通常是 41 位全 1，列出名字只会淹没输出。
            print(f"{key}: 0x{item['hex']} ({item['count']} caps in set)")
        elif names:
            print(f"{key}: 0x{item['hex']} ({', '.join(names)})")
        else:
            print(f"{key}: 0x{item['hex']} (none)")

    nnp = data.get("NoNewPrivs")
    if isinstance(nnp, dict):
        print(f"NoNewPrivs: {nnp['value']} "
              f"({'set' if nnp['set'] else 'unset'})")

    seccomp = data.get("Seccomp")
    if isinstance(seccomp, dict):
        print(f"Seccomp: {seccomp['value']} ({seccomp['mode']})")

    if "Seccomp_filters" in data:
        print(f"Seccomp_filters: {data['Seccomp_filters']}")


def read_source(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace")


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(
        description="解释 /proc/<pid>/status 里的 capability/seccomp/no_new_privs 字段",
    )
    parser.add_argument("--pid", default="self",
                        help="进程号，默认 self")
    parser.add_argument("--file", type=Path,
                        help="读取保存好的 status 文件（用于离线解析/跨平台测试）")
    parser.add_argument("--json", action="store_true", help="输出 JSON")
    parser.add_argument("--strict", action="store_true",
                        help="在 Linux 上读不到 /proc 时以非零退出")
    args = parser.parse_args(argv)

    if args.file is not None:
        if not args.file.is_file():
            print(f"inspect_linux.py: no such file: {args.file}", file=sys.stderr)
            return 2
        source = str(args.file)
        text = read_source(args.file)
    elif platform.system() != "Linux":
        print(f"inspect_linux.py: host is {platform.system()}, not Linux.")
        print("/proc/<pid>/status is unavailable here; nothing to inspect.")
        print("This checker exits 0 by design so it can live in a "
              "cross-platform test matrix.")
        print("Run it on Ubuntu 24.04 (Linux 6.8) to see "
              "CapEff/Seccomp/NoNewPrivs.")
        return 0
    else:
        source = f"/proc/{args.pid}/status"
        path = Path(source)
        if not path.is_file():
            print(f"inspect_linux.py: cannot read {source}", file=sys.stderr)
            return 2 if args.strict else 0
        text = read_source(path)

    data = describe(source, parse_status(text))
    if args.json:
        print(json.dumps(data, ensure_ascii=False, indent=2, sort_keys=True))
    else:
        print_human(data)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
