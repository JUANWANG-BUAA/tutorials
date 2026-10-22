use foundations_lab::{Case, N, data, run, sum_index, sum_iter};
use std::hint::black_box;
fn main() {
    let input = data(N);
    let expected = input.iter().fold(0u64, |a, &b| a.wrapping_add(b));
    let mut cases = [
        Case {
            name: "indexed",
            work: Box::new(|| sum_index(black_box(&input))),
            expected,
        },
        Case {
            name: "iterator",
            work: Box::new(|| sum_iter(black_box(&input))),
            expected,
        },
    ];
    run(&mut cases, 512, N);
}
