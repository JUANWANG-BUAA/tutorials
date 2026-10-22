import tempfile
from pathlib import Path
import unittest
from gate import compare, load_runtime


class GateTests(unittest.TestCase):
    def test_real_feature_regression_is_rejected(self):
        root = Path(__file__).resolve().parents[1] / "results/run-01"
        result = compare(load_runtime(root / "feature-default.txt"),
                         load_runtime(root / "feature-checked.txt"), .2)
        self.assertFalse(result["pass"])

    def test_missing_sample_is_not_a_fast_candidate(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "truncated.txt"
            path.write_text("unit=ns_per_byte\n" + "\n".join(
                f"raw,candidate,round={i},value=1.0,checksum=10" for i in range(20)))
            with self.assertRaisesRegex(ValueError, "21 distinct"):
                load_runtime(path)

    def test_wrong_checksum_is_not_comparable(self):
        with self.assertRaisesRegex(ValueError, "correctness"):
            compare({"mean": 1, "unit": "ns", "checksum": "1"},
                    {"mean": .5, "unit": "ns", "checksum": "2"}, .2)


if __name__ == "__main__":
    unittest.main()
