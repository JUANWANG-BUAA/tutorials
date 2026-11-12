#!/usr/bin/env bash
# Source, completeness and independently recomputed mathematical examples.
set -euo pipefail
cd "$(dirname "$0")/../.."
python3 numerical/tools/check_book.py
python3 -m unittest discover -s numerical/tools -p 'test_*.py'
python3 numerical/tools/verify_teaching_examples.py
python3 numerical/tools/verify_deep_examples.py
python3 numerical/tools/verify_recovery.py
python3 numerical/tools/verify_content_comparison.py
python3 numerical/tools/verify_editorial_review.py
