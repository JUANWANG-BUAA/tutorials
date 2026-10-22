use foundations_lab::{Case, N, data, dce_empty, run, sum_iter};
use std::hint::black_box;
fn main() {
    let input = data(N);
    let expected = input.iter().fold(0u64, |a, &b| a.wrapping_add(b));
    let mut cases = [
        Case {
            name: "discarded",
            work: Box::new(|| dce_empty(black_box(&input))),
            expected: 0,
        },
        Case {
            name: "observed",
            work: Box::new(|| sum_iter(black_box(&input))),
            expected,
        },
    ];
    run(&mut cases, 256, N);
}
