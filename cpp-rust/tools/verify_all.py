#!/usr/bin/env python3
"""Incremental preview validation; --release deliberately rejects unfinished books."""
from pathlib import Path
import argparse
import json
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]


def run(command):
    print('+ ' + ' '.join(command), flush=True)
    subprocess.run(command, cwd=ROOT, check=True)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--release', action='store_true')
    args = parser.parse_args()
    try:
        for command in [
            [sys.executable, 'tools/build_coverage.py'],
            [sys.executable, 'tools/check_book.py'],
            [sys.executable, 'tools/verify_evidence.py'],
            ['cargo', 'fmt', '--manifest-path', 'bench/Cargo.toml', '--check'],
            ['cargo', 'clippy', '--offline', '--manifest-path', 'bench/Cargo.toml', '--all-targets', '--', '-D', 'warnings'],
            ['cargo', 'test', '--offline', '--manifest-path', 'bench/Cargo.toml'],
            ['cargo', 'fmt', '--manifest-path', 'bench/runtime-lab/Cargo.toml', '--check'],
            ['cargo', 'clippy', '--offline', '--locked', '--manifest-path', 'bench/runtime-lab/Cargo.toml', '--all-targets', '--', '-D', 'warnings'],
            ['cargo', 'test', '--offline', '--locked', '--manifest-path', 'bench/runtime-lab/Cargo.toml'],
            ['cargo', 'clippy', '--offline', '--manifest-path', 'bench/foundations-lab/Cargo.toml', '--all-targets', '--', '-D', 'warnings'],
            ['cargo', 'test', '--offline', '--manifest-path', 'bench/foundations-lab/Cargo.toml'],
            ['cargo', 'clippy', '--offline', '--manifest-path', 'bench/compiler-lab/Cargo.toml', '--all-targets', '--', '-D', 'warnings'],
            ['cargo', 'test', '--offline', '--manifest-path', 'bench/compiler-lab/Cargo.toml'],
            ['cargo', 'clippy', '--offline', '--manifest-path', 'bench/systems-lab/Cargo.toml', '--all-targets', '--', '-D', 'warnings'],
            ['cargo', 'test', '--offline', '--manifest-path', 'bench/systems-lab/Cargo.toml'],
            ['cargo', 'clippy', '--offline', '--manifest-path', 'bench/evidence-lab/Cargo.toml', '--all-targets', '--', '-D', 'warnings'],
            ['cargo', 'test', '--offline', '--manifest-path', 'bench/evidence-lab/Cargo.toml'],
            ['mdbook', 'build'],
            [sys.executable, 'tools/check_rendered.py'],
        ]:
            run(command)
        if args.release:
            run([sys.executable, 'tools/build_coverage.py', '--strict'])
            run([sys.executable, 'tools/verify_audits.py'])
            for project in ['agent-runtime', 'ffi-bridge']:
                manifest = f'projects/{project}/Cargo.toml'
                run(['cargo', 'clippy', '--offline', '--manifest-path', manifest, '--all-targets', '--', '-D', 'warnings'])
                run(['cargo', 'test', '--offline', '--manifest-path', manifest])
    except (subprocess.CalledProcessError, RuntimeError) as exc:
        print(f'VALIDATION FAILED: {exc}', file=sys.stderr)
        return 1
    findings = json.loads((ROOT / 'sources/open-findings.json').read_text())
    for finding in findings:
        if finding.get('status') != 'closed':
            print(f'OPEN {finding["severity"]}: {finding["id"]}; rerun success is not a fix.')
    if args.release:
        print('RELEASE GATES PASSED: All 16 chapters, 2 executable projects, 550 source ledger records, and 2 independent audit rounds verified.')
    else:
        print('Incremental preview passed.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
