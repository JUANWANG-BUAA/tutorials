#!/usr/bin/env bash
# verify-linux.sh — 在 Linux 上编译并验证 harden.c；macOS 上明确跳过并非零退出。
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$(uname -s)" != "Linux" ]]; then
  cat >&2 <<EOF
SKIP: harden.c uses Linux-only seccomp/landlock/prctl/capget interfaces.
      current host: $(uname -s) $(uname -r)
      run this on Ubuntu 24.04 (Linux 6.8): bash experiments/ch04/verify-linux.sh
      exiting 1 on purpose: a skip must not look like a pass in CI.
EOF
  exit 1
fi

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

cc -std=c17 -O2 -Wall -Wextra -Werror "$here/harden.c" -o "$work/harden"

out="$("$work/harden")"
printf '%s\n' "$out"
grep -qx 'NoNewPrivs: 1' <<<"$out"
grep -qx 'CapEff after drop:  0x0000000000000000' <<<"$out"
grep -qx 'seccomp: filter installed (TSYNC)' <<<"$out"
grep -qx 'openat("/etc/passwd") after seccomp: EPERM (1)' <<<"$out"
grep -qx 'result: OK' <<<"$out"

out2="$("$work/harden" --landlock)"
printf '%s\n' "$out2"
grep -qxE '^landlock: ABI [0-9]+, only /usr is readable$' <<<"$out2"
grep -qx 'openat("/etc/passwd") after landlock: EACCES (13)' <<<"$out2"
grep -qx 'openat("/etc/passwd") after seccomp: EPERM (1)' <<<"$out2"
grep -qx 'result: OK' <<<"$out2"

grep -qxE '^bounding: (dropped 0\.\.[0-9]+, CAP_SETPCAP last|skipped \(errno=[0-9]+; run as root to exercise\))$' <<<"$out"

echo "PASS: harden.c (seccomp whitelist + optional landlock)"
