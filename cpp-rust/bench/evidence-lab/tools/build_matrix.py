#!/usr/bin/env python3
"""Fourth benchmark: fresh package-target and no-op builds, never cold OS caches."""
import hashlib
import json
import math
import os
from pathlib import Path
import statistics
import subprocess
import sys
import time

LAB = Path(__file__).resolve().parents[1]


def summary(values):
    ordered = sorted(values)
    return {"n": len(values), "mean": statistics.mean(values),
            "sd": statistics.stdev(values), "p50": ordered[math.ceil(.5 * len(values)) - 1],
            "p99": ordered[math.ceil(.99 * len(values)) - 1]}


def main():
    out = Path(sys.argv[1]).resolve()
    root = out / "builds"
    root.mkdir()  # Fail closed: never overwrite a prior run.
    observations = []
    env = os.environ.copy()
    for name in ("RUSTFLAGS", "CARGO_ENCODED_RUSTFLAGS", "RUSTC_WRAPPER", "RUSTC_WORKSPACE_WRAPPER"):
        env.pop(name, None)
    env["CARGO_INCREMENTAL"] = "0"
    profiles = ["release", "one", "thin"]
    # Untimed toolchain/filesystem warmup, not a claim to prewarm the whole linker.
    subprocess.run(["rustc", "-Vv"], check=True, stdout=subprocess.DEVNULL)
    with (out / "build-raw.jsonl").open("x") as raw:
        for round_id in range(21):
            for offset in range(3):
                profile = profiles[(round_id + offset) % 3]
                target = root / f"{profile}-{round_id:02}"
                command = ["cargo", "build", "--offline", "--locked", "--manifest-path",
                           str(LAB / "Cargo.toml"), "--profile", profile, "--bin", "feature_work",
                           "--target-dir", str(target), "-j", "1", "-vv"]
                for boundary in ["fresh-package-target", "noop"]:
                    log = out / f"build-{profile}-{round_id:02}-{boundary}.txt"
                    with log.open("x") as stream:
                        start = time.perf_counter_ns()
                        subprocess.run(command, check=True, env=env, stdout=stream, stderr=stream)
                        elapsed_ms = (time.perf_counter_ns() - start) / 1e6
                    binary = target / profile / "feature_work"
                    content = binary.read_bytes()
                    row = {"case": f"{profile}/{boundary}", "round": round_id,
                           "wall_ms": elapsed_ms, "binary_bytes": len(content),
                           "binary_sha256": hashlib.sha256(content).hexdigest(), "command": command}
                    raw.write(json.dumps(row) + "\n")
                    raw.flush()
                    observations.append(row)
                if round_id == 0:
                    result = subprocess.run(["size", "-m", str(binary)], check=True, capture_output=True, text=True)
                    (out / f"size-{profile}.txt").write_text(result.stdout)
                    # Correctness execution is outside measured build intervals.
                    result = subprocess.run([str(binary)], check=True, capture_output=True, text=True)
                    (out / f"verify-{profile}.txt").write_text(result.stdout)
    cases = sorted({row["case"] for row in observations})
    result = {case: summary([row["wall_ms"] for row in observations if row["case"] == case])
              for case in cases}
    (out / "build-summary.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
