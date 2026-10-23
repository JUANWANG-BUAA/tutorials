#!/usr/bin/env python3
"""
algorithms 教程质量门禁统一入口
一键运行所有检查，汇总报告。
"""
import subprocess
import sys
from pathlib import Path

def run_check(name: str, cmd: list[str], cwd: Path) -> tuple[bool, str]:
    """运行一个检查，返回 (是否通过, 输出)"""
    try:
        result = subprocess.run(
            cmd,
            cwd=cwd,
            capture_output=True,
            text=True,
            timeout=300
        )
        passed = result.returncode == 0
        output = result.stdout + result.stderr
        return passed, output
    except subprocess.TimeoutExpired:
        return False, "TIMEOUT"
    except Exception as e:
        return False, str(e)

def main():
    root = Path(__file__).parent.parent
    checks = [
        ("结构检查", ["python3", "tools/check_book.py"]),
        ("覆盖矩阵", ["python3", "tools/build_coverage.py"]),
        ("代码围栏", ["python3", "tools/check_snippets.py"]),
        ("实验验证", ["bash", "experiments/run_all.sh"]),
        ("构建测试", ["mdbook", "build"]),
        ("HTML 验证", ["python3", "tools/check_html.py"]),
    ]

    results = []
    print("=" * 60)
    print("algorithms 质量门禁")
    print("=" * 60)

    for name, cmd in checks:
        print(f"\n[{name}] 运行中...", end=" ", flush=True)
        passed, output = run_check(name, cmd, root)
        results.append((name, passed, output))
        status = "✓ PASS" if passed else "✗ FAIL"
        print(status)
        if not passed:
            print(f"  输出: {output[:200]}")

    print("\n" + "=" * 60)
    print("汇总")
    print("=" * 60)
    passed_count = sum(1 for _, p, _ in results if p)
    total = len(results)
    print(f"通过: {passed_count}/{total}")

    for name, passed, _ in results:
        status = "✓" if passed else "✗"
        print(f"  {status} {name}")

    if passed_count == total:
        print("\n🎉 所有检查通过！")
        return 0
    else:
        print(f"\n❌ {total - passed_count} 项检查失败")
        return 1

if __name__ == "__main__":
    sys.exit(main())
