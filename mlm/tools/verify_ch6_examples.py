#!/usr/bin/env python3
"""核算第6章教学假设及后组数字适用范围；不计量理论、真理或异化程度。"""
from fractions import Fraction
from pathlib import Path


def main() -> None:
    predicted_flow = 10
    measured_flow = 8
    difference = predicted_flow - measured_flow
    measured_percent = Fraction(measured_flow, predicted_flow) * 100
    assert difference == 2
    assert measured_percent == 80
    print(f"1.2.2 假设流量：预测{predicted_flow}升/分，实测{measured_flow}升/分，差{difference}升/分，实测占预测{measured_percent}%")
    people = 4
    hours_per_person = 6
    person_hours = people * hours_per_person
    assert person_hours == 24
    print(f"1.2.12 假设工时：{people}人×{hours_per_person}小时={person_hours}人时")
    chapter = Path(__file__).resolve().parents[1] / "src/part1/6.md"
    tail = chapter.read_text().split("## 1.2.16 ", 1)[1]
    assert "两百人住在同一处所" in tail
    assert "72000人的说法" in tail
    assert "未独立核实" in tail
    assert "不能据它计算英国总人口比例" in tail
    print("1.2.21：72000为原著记载且明确未独立核实；不计算比率。")
    print("1.2.23：两百人为集中/联合概念辨析的假设人数，无派生算术。")
    print("PASS：只核算已给定假设的算术，不从中推算历史产量或理论指标。")


if __name__ == "__main__":
    main()
