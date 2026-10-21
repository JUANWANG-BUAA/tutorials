#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""guard.py 的回归测试：CLI 是契约，因此全部通过子进程调用。"""

from __future__ import annotations

import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GUARD = ROOT / "guard.py"


def run_guard(*args: object, timeout: float = 60.0) -> subprocess.CompletedProcess:
    return subprocess.run(
        [sys.executable, str(GUARD), *map(str, args)],
        cwd=ROOT, capture_output=True, text=True, timeout=timeout,
    )


def run_json(*args: object, timeout: float = 60.0):
    proc = run_guard(*args, "--json", timeout=timeout)
    try:
        data = json.loads(proc.stdout)
    except json.JSONDecodeError:
        data = None
    return proc, data


def rules(report: dict) -> list[str]:
    return [f["rule"] for f in report.get("findings", [])]


def rustc_works() -> bool:
    exe = shutil.which("rustc")
    if exe is None:
        return False
    try:
        proc = subprocess.run([exe, "--version"], capture_output=True, timeout=10)
    except (OSError, subprocess.TimeoutExpired):
        return False
    return proc.returncode == 0


class StaticRules(unittest.TestCase):
    def test_clean_python_accepts(self) -> None:
        proc, data = run_json("fixtures/good/sum.py", "--static-only")
        self.assertEqual(proc.returncode, 0)
        self.assertEqual(data["verdict"], "accept")
        self.assertEqual(data["findings"], [])

    def test_eval_rejected(self) -> None:
        proc, data = run_json("fixtures/bad/eval_dynamic.py", "--static-only")
        self.assertEqual(proc.returncode, 1)
        self.assertIn("PY-EVAL", rules(data))

    def test_import_alias_rejected(self) -> None:
        proc, data = run_json("fixtures/bad/agent_alias.py", "--static-only")
        self.assertEqual(proc.returncode, 1)
        self.assertIn("PY-OS-SYSTEM", rules(data))
        finding = [f for f in data["findings"] if f["rule"] == "PY-OS-SYSTEM"][0]
        self.assertEqual(finding["line"], 3)

    def test_getattr_constant_folding_rejected(self) -> None:
        proc, data = run_json("fixtures/bad/getattr_concat.py", "--static-only")
        self.assertEqual(proc.returncode, 1)
        self.assertIn("PY-OS-SYSTEM", rules(data))

    def test_getattr_variable_quarantined(self) -> None:
        proc, data = run_json("fixtures/quarantine/dynamic_attr.py", "--static-only")
        self.assertEqual(proc.returncode, 2)
        self.assertIn("PY-DYN-ATTR", rules(data))
        self.assertEqual(data["verdict"], "quarantine")
        self.assertTrue(data["human_review"]["required"])

    def test_network_rejected(self) -> None:
        proc, data = run_json("fixtures/bad/net.py", "--static-only")
        self.assertEqual(proc.returncode, 1)
        self.assertIn("PY-NET", rules(data))

    def test_infinite_loop_is_low_severity(self) -> None:
        proc, data = run_json("fixtures/quarantine/timeout_loop.py", "--static-only")
        self.assertEqual(proc.returncode, 0)
        self.assertIn("PY-INFINITE-LOOP", rules(data))
        self.assertEqual(data["findings"][0]["severity"], "low")

    def test_prompt_injection_comment_is_flagged_not_followed(self) -> None:
        proc, data = run_json("fixtures/good/injection_comment.py", "--static-only")
        self.assertEqual(proc.returncode, 0)
        self.assertIn("PY-PROMPT-INJECTION", rules(data))
        self.assertNotIn("PY-EVAL", rules(data))
        self.assertTrue(all(f["severity"] == "low" for f in data["findings"]))

    def test_python_string_literals_are_not_calls(self) -> None:
        proc, data = run_json("fixtures/good/strings_only.py", "--static-only")
        self.assertEqual(proc.returncode, 0)
        self.assertEqual(data["findings"], [])

    def test_c_string_literal_false_positive_control(self) -> None:
        proc, data = run_json("fixtures/c/string_ok.c", "--static-only")
        self.assertEqual(proc.returncode, 0)
        self.assertEqual(data["findings"], [])

    def test_c_system_rejected(self) -> None:
        proc, data = run_json("fixtures/c/system_bad.c", "--static-only")
        self.assertEqual(proc.returncode, 1)
        self.assertIn("C-SYSTEM", rules(data))

    def test_c_macro_alias_quarantined(self) -> None:
        proc, data = run_json("fixtures/c/macro_alias.c", "--static-only")
        self.assertEqual(proc.returncode, 2)
        self.assertIn("C-MACRO-ALIAS", rules(data))

    def test_python_syntax_error_rejected(self) -> None:
        proc, data = run_json("fixtures/bad/syntax.py", "--static-only")
        self.assertEqual(proc.returncode, 1)
        self.assertIn("PY-SYNTAX", rules(data))

    def test_policy_allow_suppresses_rule(self) -> None:
        proc, data = run_json("fixtures/good/injection_comment.py",
                              "--policy", "fixtures/policies/allow_prompt.json",
                              "--static-only")
        self.assertEqual(proc.returncode, 0)
        self.assertEqual(data["findings"], [])
        self.assertTrue(any(s["rule"] == "PY-PROMPT-INJECTION" for s in data["suppressed"]))

    def test_policy_strict_escalates_low(self) -> None:
        proc, data = run_json("fixtures/good/injection_comment.py",
                              "--policy", "fixtures/policies/strict.json",
                              "--static-only")
        self.assertEqual(proc.returncode, 2)
        self.assertEqual(data["findings"][0]["severity"], "low")

    def test_unknown_policy_rule_is_an_error(self) -> None:
        with tempfile.TemporaryDirectory() as td:
            path = Path(td) / "bad.json"
            path.write_text('{"allow_rules": ["NO-SUCH-RULE"]}', encoding="utf-8")
            proc, data = run_json("fixtures/good/sum.py", "--policy", path,
                                  "--static-only")
        self.assertEqual(proc.returncode, 2)
        self.assertIsNone(data["verdict"])
        self.assertIn("NO-SUCH-RULE", data["error"])

    def test_directory_aggregate_verdict(self) -> None:
        proc, data = run_json("fixtures/bad", "--static-only")
        self.assertEqual(proc.returncode, 1)
        self.assertEqual(data["verdict"], "reject")
        self.assertGreaterEqual(data["summary"]["reject"], 2)
        self.assertEqual(len(data["targets"]),
                         sum(data["summary"].values()))

    def test_static_only_skips_compile_and_behavior(self) -> None:
        proc, data = run_json("fixtures/good/sum.py", "--static-only")
        checks = {c["name"]: c for c in data["checks"]}
        self.assertEqual(checks["compile"]["status"], "skip")
        self.assertEqual(checks["behavior"]["status"], "skip")
        self.assertEqual(data["evidence"]["commands"], [])


class CompileGate(unittest.TestCase):
    def test_python_compile_passes(self) -> None:
        proc, data = run_json("fixtures/good/sum.py")
        self.assertEqual(proc.returncode, 0)
        checks = {c["name"]: c for c in data["checks"]}
        self.assertEqual(checks["compile"]["status"], "pass")
        self.assertEqual(checks["compile"]["exit_code"], 0)

    def test_c_warning_is_error(self) -> None:
        proc, data = run_json("fixtures/c/warn_unused.c")
        self.assertEqual(proc.returncode, 1)
        self.assertIn("C-SYNTAX", rules(data))
        self.assertEqual(data["findings"][0]["line"], 2)

    def test_c_undefined_reference_only_fails_when_linking(self) -> None:
        proc, data = run_json("fixtures/c/link_bad.c", "--run",
                              "--tests", "fixtures/tests/link_bad.json")
        checks = {c["name"]: c for c in data["checks"]}
        self.assertEqual(checks["compile"]["status"], "pass")
        self.assertEqual(checks["behavior"]["status"], "fail")
        self.assertIn("C-SYNTAX", rules(data))
        self.assertEqual(proc.returncode, 1)

    @unittest.skipUnless(rustc_works(), "rustc 不可用")
    def test_rust_typecheck_passes(self) -> None:
        proc, data = run_json("fixtures/rust/hello.rs")
        self.assertEqual(proc.returncode, 0)
        self.assertEqual({c["name"]: c for c in data["checks"]}["compile"]["status"], "pass")

    @unittest.skipUnless(rustc_works(), "rustc 不可用")
    def test_rust_unsafe_is_quarantine(self) -> None:
        proc, data = run_json("fixtures/rust/unsafe_ok.rs", "--static-only")
        self.assertEqual(proc.returncode, 2)
        self.assertIn("RS-UNSAFE", rules(data))

    @unittest.skipUnless(rustc_works(), "rustc 不可用")
    def test_rust_type_error_rejected(self) -> None:
        proc, data = run_json("fixtures/rust/broken.rs")
        self.assertEqual(proc.returncode, 1)
        self.assertIn("RS-SYNTAX", rules(data))

    def test_missing_import_passes_compile_but_fails_run(self) -> None:
        proc, data = run_json("fixtures/bad/missing_import.py", "--run",
                              "--tests", "fixtures/tests/missing_import.json")
        checks = {c["name"]: c for c in data["checks"]}
        self.assertEqual(checks["compile"]["status"], "pass")
        self.assertIn("RUN-EXIT", rules(data))
        self.assertEqual(proc.returncode, 1)


class BehaviorGate(unittest.TestCase):
    def test_accept_with_behavior(self) -> None:
        proc, data = run_json("fixtures/good/sum.py", "--run",
                              "--tests", "fixtures/tests/sum.json")
        self.assertEqual(proc.returncode, 0)
        self.assertEqual(data["behavior"]["cases"][0]["status"], "pass")
        self.assertIn("limits", data["behavior"]["cases"][0])

    def test_wrong_stdout_rejected(self) -> None:
        proc, data = run_json("fixtures/bad/wrong.py", "--run",
                              "--tests", "fixtures/tests/wrong.json")
        self.assertEqual(proc.returncode, 1)
        self.assertIn("RUN-OUTPUT", rules(data))

    def test_exit_code_mismatch_rejected_even_when_stdout_matches(self) -> None:
        proc, data = run_json("fixtures/bad/exit_after_print.py", "--run",
                              "--tests", "fixtures/tests/exit3_wrong.json")
        self.assertEqual(proc.returncode, 1)
        self.assertIn("RUN-EXIT", rules(data))
        self.assertEqual(data["behavior"]["cases"][0]["stdout_sha256"],
                         hashlib.sha256(b"ok\n").hexdigest())

    def test_exit_three_can_be_accepted_with_matching_fixture(self) -> None:
        proc, data = run_json("fixtures/bad/exit_after_print.py", "--run",
                              "--tests", "fixtures/tests/exit3.json")
        self.assertEqual(proc.returncode, 0)
        self.assertEqual(data["behavior"]["cases"][0]["exit_code"], 3)

    def test_timeout_is_quarantine(self) -> None:
        proc, data = run_json("fixtures/quarantine/timeout_loop.py", "--run",
                              "--tests", "fixtures/tests/timeout.json", timeout=30)
        self.assertEqual(proc.returncode, 2)
        self.assertIn("RUN-TIMEOUT", rules(data))
        self.assertEqual(data["behavior"]["cases"][0]["status"], "timeout")

    def test_file_size_limit_is_quarantine(self) -> None:
        proc, data = run_json("fixtures/quarantine/big_output.py", "--run",
                              "--tests", "fixtures/tests/big_output.json", timeout=30)
        self.assertEqual(proc.returncode, 2)
        self.assertIn("RUN-RESOURCE", rules(data))
        self.assertEqual(data["behavior"]["cases"][0]["resource"], "fsize")

    def test_run_without_tests_is_quarantine(self) -> None:
        proc, data = run_json("fixtures/good/sum.py", "--run")
        self.assertEqual(proc.returncode, 2)
        self.assertIn("RUN-NO-TESTS", rules(data))

    def test_env_sniffing_is_quarantine_even_if_output_matches(self) -> None:
        proc, data = run_json("fixtures/quarantine/env_sniff.py", "--run",
                              "--tests", "fixtures/tests/env_local.json")
        self.assertEqual(proc.returncode, 2)
        self.assertIn("PY-TEST-SNIFF", rules(data))
        self.assertEqual(data["behavior"]["cases"][0]["status"], "pass")

    def test_argv_is_passed(self) -> None:
        proc, data = run_json("fixtures/good/argv.py", "--run",
                              "--tests", "fixtures/tests/argv.json")
        self.assertEqual(proc.returncode, 0)
        self.assertEqual(data["behavior"]["cases"][0]["stdout_sha256"],
                         hashlib.sha256(b"alpha beta\n").hexdigest())

    def test_workspace_diff_records_created_file(self) -> None:
        proc, data = run_json("fixtures/good/writes_file.py",
                              "--policy", "fixtures/policies/allow_fs.json",
                              "--run", "--tests", "fixtures/tests/writes.json")
        self.assertEqual(proc.returncode, 0)
        self.assertEqual(data["behavior"]["cases"][0]["workspace_created"], ["out.txt"])

    def test_tests_fixture_hash_is_recorded(self) -> None:
        fixture = ROOT / "fixtures/tests/sum.json"
        proc, data = run_json("fixtures/good/sum.py", "--run",
                              "--tests", "fixtures/tests/sum.json")
        self.assertEqual(data["evidence"]["tests_sha256"],
                         hashlib.sha256(fixture.read_bytes()).hexdigest())

    def test_high_severity_static_finding_prevents_execution(self) -> None:
        proc, data = run_json("fixtures/bad/agent_alias.py", "--run",
                              "--tests", "fixtures/tests/sum.json")
        checks = {c["name"]: c for c in data["checks"]}
        self.assertEqual(checks["behavior"]["status"], "skip")
        self.assertIn("静态严重度", checks["behavior"]["reason"])
        kinds = [c["kind"] for c in data["evidence"]["commands"]]
        self.assertNotIn("run", kinds)


class CliContract(unittest.TestCase):
    def test_three_verdicts_map_to_exit_codes(self) -> None:
        cases = [
            ("fixtures/good/sum.py", 0),
            ("fixtures/bad/eval_dynamic.py", 1),
            ("fixtures/quarantine/dynamic_attr.py", 2),
        ]
        for target, expected in cases:
            proc = run_guard(target, "--static-only")
            self.assertEqual(proc.returncode, expected, target)

    def test_missing_tests_fixture_is_an_error(self) -> None:
        proc, data = run_json("fixtures/good/sum.py", "--run",
                              "--tests", "fixtures/tests/nope.json")
        self.assertEqual(proc.returncode, 2)
        self.assertIsNone(data["verdict"])
        self.assertIn("测试夹具不存在", data["error"])

    def test_static_only_conflicts_with_run(self) -> None:
        proc = run_guard("fixtures/good/sum.py", "--static-only", "--run")
        self.assertEqual(proc.returncode, 2)

    def test_report_has_evidence_and_review_fields(self) -> None:
        proc, data = run_json("fixtures/good/sum.py", "--run",
                              "--tests", "fixtures/tests/sum.json")
        for key in ("tool", "schema", "verdict", "findings", "checks",
                    "evidence", "human_review", "limits"):
            self.assertIn(key, data)
        self.assertEqual(len(data["evidence"]["code_sha256"]), 64)
        self.assertEqual(len(data["evidence"]["commands"]), 2)
        self.assertEqual(data["human_review"]["required"], False)

    def test_unknown_extension_is_an_error(self) -> None:
        with tempfile.TemporaryDirectory() as td:
            path = Path(td) / "code.txt"
            path.write_text("print(1)\n", encoding="utf-8")
            proc, data = run_json(path, "--static-only")
        self.assertEqual(proc.returncode, 2)
        self.assertIn("扩展名", data["error"])

    def test_explicit_language_overrides_extension(self) -> None:
        proc, data = run_json("fixtures/good/strings_only.py", "--lang", "python",
                              "--static-only")
        self.assertEqual(proc.returncode, 0)


if __name__ == "__main__":
    unittest.main(verbosity=2)
