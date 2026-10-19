#!/usr/bin/env bash
# 第 3 章 Linux-only 代码的最小验证脚本。
# 在 macOS 上会直接 SKIP；在 Linux 6.8 / Ubuntu 24.04 上编译并运行 openat2 示例。
set -euo pipefail

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "SKIP: Linux-only check; host is $(uname -s)"
  exit 0
fi

if ! command -v cc >/dev/null 2>&1; then
  echo "SKIP: cc not found; install build-essential"
  exit 0
fi

read -r major minor _ < <(uname -r | awk -F. '{print $1, $2, $3}')
if (( major < 5 || (major == 5 && minor < 6) )); then
  echo "SKIP: openat2 needs Linux 5.6+; kernel is $(uname -r)"
  exit 0
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

cat > "$tmp/openat2_demo.c" <<'C'
#define _GNU_SOURCE
#include <fcntl.h>
#include <linux/openat2.h>
#include <stdio.h>
#include <sys/syscall.h>
#include <unistd.h>

int main(void) {
    int root = open(".", O_RDONLY | O_DIRECTORY | O_CLOEXEC);
    if (root < 0) {
        perror("open .");
        return 1;
    }
    struct open_how how = {
        .flags = O_RDONLY | O_CLOEXEC,
        .resolve = RESOLVE_BENEATH | RESOLVE_NO_SYMLINKS | RESOLVE_NO_MAGICLINKS,
    };
    int fd = (int)syscall(SYS_openat2, root, "openat2_demo.c", &how, sizeof(how));
    if (fd < 0) {
        perror("openat2");
        close(root);
        return 1;
    }
    close(fd);
    close(root);
    puts("openat2 OK");
    return 0;
}
C

cc -std=c17 -Wall -Wextra -Werror -o "$tmp/openat2_demo" "$tmp/openat2_demo.c"
(cd "$tmp" && ./openat2_demo)
echo "OK: openat2 compile + run"
