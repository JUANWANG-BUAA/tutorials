#!/usr/bin/env python3
"""Non-timing evidence: compiler rejection, code size, thin LTO and PGO execution."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys

root = Path(__file__).resolve().parent
out = Path(sys.argv[1]).resolve()
out.mkdir(parents=True, exist_ok=False)

def run(args, name, expect_success=True):
    process = subprocess.run([str(a) for a in args], capture_output=True, text=True)
    (out / name).write_text('$ ' + ' '.join(map(str, args)) + '\n' + process.stdout + process.stderr)
    if expect_success and process.returncode:
        raise RuntimeError(name)
    return process

run(['rustc', '-vV'], 'stable-version.txt')
run(['rustc', '+nightly', '-vV'], 'nightly.txt', False)
for row in (root / 'probes/rejected/expected.tsv').read_text().splitlines():
    name, error = row.split('\t')
    process = run(['rustc', '--edition=2024', root / f'probes/rejected/{name}.rs',
                   '--emit=metadata', '-o', out / f'{name}.rmeta'], f'{name}.txt', False)
    assert process.returncode != 0 and error in process.stderr, (name, error)
for level in [0, 3]:
    run(['rustc', '--edition=2024', root / 'probes/stages.rs', f'-Copt-level={level}',
         '--emit=mir,llvm-ir,asm,link', '-o', out / f'stages-o{level}'], f'stages-o{level}-build.txt')
    run([out / f'stages-o{level}'], f'stages-o{level}-run.txt')
run(['cargo', 'build', '--release', '--offline', '--locked', '--manifest-path', root / 'Cargo.toml'], 'build.txt')
rlib = next((root / 'target/release/deps').glob('libcompiler_lab-*.rlib'))
run(['rustc', '--edition=2024', root / 'probes/layout.rs', '--extern', f'compiler_lab={rlib}',
     '-L', f'dependency={root / "target/release/deps"}', '-o', out / 'layout'], 'layout-build.txt')
run([out / 'layout'], 'layout.csv')
for name, extra in [('one', []), ('many', ['--cfg=many']), ('thin', ['--cfg=many', '-Clto=thin'])]:
    run(['rustc', '--edition=2024', '-O', '-Ccodegen-units=1', '-Cdebuginfo=1',
         root / 'probes/code_size.rs', *extra, '-o', out / name], name + '-build.txt')
    run([out / name], name + '-run.txt')
    run(['size', '-m', out / name], name + '-size.txt')
    run(['nm', '-n', out / name], name + '-nm.txt')
sysroot = subprocess.check_output(['rustc', '--print', 'sysroot'], text=True).strip()
profdata = Path(sysroot) / 'lib/rustlib/aarch64-apple-darwin/bin/llvm-profdata'
if profdata.exists():
    run([profdata, '--version'], 'profdata-version.txt')
    data = out / 'pgo-data'
    data.mkdir()
    common = ['rustc', '--edition=2024', '-O', '-Ccodegen-units=1', '--cfg=many', root / 'probes/code_size.rs']
    run([*common, f'-Cprofile-generate={data}', '-o', out / 'pgo-train'], 'pgo-generate.txt')
    run([out / 'pgo-train'], 'pgo-training-run.txt')
    raw = list(data.glob('*.profraw'))
    assert raw
    run([profdata, 'merge', '-o', data / 'merged.profdata', *raw], 'pgo-merge.txt')
    run([*common, f'-Cprofile-use={data / "merged.profdata"}', '-Cllvm-args=-pgo-warn-missing-function',
         '-o', out / 'pgo-use'], 'pgo-use.txt')
    run([out / 'pgo-use'], 'pgo-use-run.txt')
    run(['size', '-m', out / 'pgo-use'], 'pgo-size.txt')
else:
    (out / 'pgo-unavailable.txt').write_text('Matching llvm-profdata is not installed; no PGO run.\n')
rows = []
for path in [*root.glob('probes/**/*.rs'), root / 'extra.py']:
    rows.append({'source': str(path.relative_to(root)), 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()})
(out / 'source-sha256.json').write_text(json.dumps(rows, indent=2) + '\n')
