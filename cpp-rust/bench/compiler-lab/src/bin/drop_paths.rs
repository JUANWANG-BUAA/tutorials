use compiler_lab::{Case, conditional_drop, measure, option_drop};
use std::{cell::Cell, hint::black_box};
fn run(f: fn(bool, &Cell<u64>)) -> u64 {
    let count = Cell::new(0);
    for i in 0..4096 {
        f(black_box(i % 2 == 0), &count);
    }
    count.get()
}
fn main() {
    let mut cases = [
        Case {
            name: "implicit",
            run: Box::new(|| run(conditional_drop)),
            expected: 8192,
        },
        Case {
            name: "option",
            run: Box::new(|| run(option_drop)),
            expected: 8192,
        },
    ];
    measure(&mut cases, 4096);
}
