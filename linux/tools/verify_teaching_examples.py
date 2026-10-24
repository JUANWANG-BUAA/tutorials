#!/usr/bin/env python3
"""独立复核第二轮页表、条件变量与信号例题；不模拟 Linux 内核。

从任意目录运行：python3 linux/tools/verify_teaching_examples.py
仅依赖标准库；若有 cc，严格编译并运行 POSIX 阻塞信号小实验。
"""

from __future__ import annotations

import itertools
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import unittest

SRC = Path(__file__).resolve().parents[1] / "src"


class TeachingExamples(unittest.TestCase):
    """公式由位运算和穷举独立计算，再与正文中的数字核对。"""

    def test_walk_table(self) -> None:
        text = (SRC / "part1/ch09.md").read_text()
        rows = re.findall(
            r"\| (PML4|PDPT|PD|PT) \| `(0x[0-9a-f]+)` \| "
            r"(\d+) \| `(0x[0-9a-f]+)` \| `(0x[0-9a-f]+)`",
            text,
        )
        self.assertEqual(len(rows), 4)
        va = 0x00007F3C5D2E8A40
        base = 0x1A000
        for row, shift in zip(rows, (39, 30, 21, 12)):
            _, printed_base, printed_idx, printed_addr, value = row
            idx = (va >> shift) & 511
            self.assertEqual(int(printed_base, 16), base)
            self.assertEqual(int(printed_idx), idx)
            self.assertEqual(int(printed_addr, 16), base + idx * 8)
            base = int(value, 16) & 0x000FFFFFFFFFF000
            self.assertEqual(base % 4096, 0)
        self.assertEqual(base | (va & 4095), 0x2E8A0A40)
        crossed = va + 0x5C0
        self.assertEqual(crossed, 0x00007F3C5D2E9000)
        self.assertEqual(((crossed >> 12) & 511, crossed & 4095), (233, 0))

    def test_page_table_count_and_reconstruction(self) -> None:
        for va in (0x7F3C5D2E8A40, 0x7F8C12345678, 0x55555555A1B0):
            fields = [(va >> s) & 511 for s in (39, 30, 21, 12)]
            rebuilt = sum(i << s for i, s in zip(fields, (39, 30, 21, 12)))
            self.assertEqual(rebuilt | (va & 4095), va)
        # 逐页枚举已映射区间；每级表按其覆盖范围去重。
        pages = range(0, 1 << 30, 4096)
        counts = [len({va >> shift for va in pages}) for shift in (21, 30, 39, 48)]
        self.assertEqual(counts, [512, 1, 1, 1])
        self.assertEqual(sum(counts), 515)

    def test_broadcast_does_not_transfer_items(self) -> None:
        for order in itertools.permutations(("A", "B")):
            count_if = 1
            count_while = 1
            consumed: list[str] = []
            for consumer in order:
                count_if -= 1
                if count_while > 0:
                    count_while -= 1
                    consumed.append(consumer)
            self.assertEqual(count_if, -1)
            self.assertEqual(count_while, 0)
            self.assertEqual(len(consumed), 1)

    def test_pending_signal_and_sigsuspend(self) -> None:
        cc = shutil.which("cc")
        if cc is None:
            self.skipTest("无 cc：跳过 POSIX 实验，不将模型当成原生运行")
        source = r"""
#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
static volatile sig_atomic_t ready;
static void mark(int sig) { (void)sig; ready = 1; }
int main(void) {
    struct sigaction sa = {0};
    sigset_t blocked, old, waiting, pending;
    sa.sa_handler = mark;
    if (sigemptyset(&sa.sa_mask) == -1 ||
        sigaction(SIGUSR1, &sa, NULL) == -1 ||
        sigemptyset(&blocked) == -1 ||
        sigaddset(&blocked, SIGUSR1) == -1 ||
        sigprocmask(SIG_BLOCK, &blocked, &old) == -1 ||
        raise(SIGUSR1) != 0 || sigpending(&pending) == -1)
        return EXIT_FAILURE;
    if (ready || sigismember(&pending, SIGUSR1) != 1)
        return EXIT_FAILURE;
    waiting = old;
    if (sigdelset(&waiting, SIGUSR1) == -1)
        return EXIT_FAILURE;
    while (!ready) {
        if (sigsuspend(&waiting) != -1 || errno != EINTR)
            return EXIT_FAILURE;
    }
    if (sigprocmask(SIG_SETMASK, &old, NULL) == -1)
        return EXIT_FAILURE;
    puts("pending before suspend; handler ran after unblocking");
    return EXIT_SUCCESS;
}
"""
        with tempfile.TemporaryDirectory(prefix="linux-teaching-") as temp:
            c_file = Path(temp) / "pending.c"
            binary = Path(temp) / "pending"
            c_file.write_text(source)
            subprocess.run(
                [cc, "-std=c17", "-D_POSIX_C_SOURCE=200809L",
                 "-Wall", "-Wextra", "-Werror", str(c_file), "-o", str(binary)],
                check=True, capture_output=True, text=True, timeout=30,
            )
            result = subprocess.run(
                [str(binary)], check=True, capture_output=True, text=True, timeout=5
            )
            self.assertIn("handler ran after unblocking", result.stdout)


if __name__ == "__main__":
    unittest.main(verbosity=2)
