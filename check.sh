#!/usr/bin/env bash
# Local and CI quality gate. See docs/quality-gates.md for scope and prerequisites.
set -euo pipefail
cd "$(dirname "$0")"

build=true
browser=true
for arg in "$@"; do
  case "$arg" in
    --no-build) build=false ;;
    --no-browser) browser=false ;;
    *) echo "Usage: bash check.sh [--no-build] [--no-browser]" >&2; exit 2 ;;
  esac
done

node tools/check_formal.mjs
python3 tools/check_math_examples.py
node --test tools/test_*.mjs
python3 -m unittest discover -s tools -p 'test_*.py'
python3 tools/check_book_boundaries.py

for book in linux agent-systems distributed compilers algorithms embodied cpp-rust edge; do
  python3 "$book/tools/check_book.py"
done
python3 linux/tools/build_coverage.py
python3 agent-systems/tools/build_coverage.py
python3 distributed/tools/check_coverage.py
python3 distributed/tools/check_projects.py
python3 compilers/tools/build_coverage.py
python3 cpp-rust/tools/build_coverage.py --strict
python3 cpp-rust/tools/verify_audits.py

# Keep each project's module search path isolated.
for project in agent-systems/projects/code-agent agent-systems/projects/eval-platform; do
  (cd "$project" && python3 -m unittest discover -s tests -v)
done
bash compilers/projects/minic/run_tests.sh
bash compilers/projects/validator/run_tests.sh
for project in distributed/projects/idempotent-tool distributed/projects/replicated-kv; do
  (cd "$project" && python3 -m unittest discover -v)
done
for project in embodied/projects/car-slam embodied/projects/arm-servoing; do
  (cd "$project" && PYTHONPATH=. python3 -m pytest -q tests)
done
bash edge/projects/edge-rtos-infer/run_tests.sh
bash edge/projects/edge-daq-monitor/run_tests.sh

if "$build"; then
  bash build.sh
else
  python3 tools/audit_site_assets.py _site
  python3 tools/check_site_links.py _site
fi
for book in agent-systems compilers algorithms cpp-rust edge; do
  python3 compilers/tools/check_html.py "_site/$book"
done
if "$browser"; then node tools/check_browser.mjs; fi
echo "Quality gate passed."
