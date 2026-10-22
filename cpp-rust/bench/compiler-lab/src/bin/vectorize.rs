use compiler_lab::{Case, add_slices, add_with_calls, borrowed_sum, input_data, measure};
use std::hint::black_box;
fn run(f: fn(&mut [u64], &[u64]), input: &[u64], output: &mut [u64]) -> u64 {
    output.fill(0);
    f(black_box(output), black_box(input));
    borrowed_sum(black_box(output))
}
fn main() {
    let input = input_data(16384);
    let mut left = vec![0; input.len()];
    let mut right = left.clone();
    let expected = input.iter().copied().fold(0, u64::wrapping_add);
    let mut cases = [
        Case {
            name: "zip",
            run: Box::new(|| run(add_slices, &input, &mut left)),
            expected,
        },
        Case {
            name: "calls",
            run: Box::new(|| run(add_with_calls, &input, &mut right)),
            expected,
        },
    ];
    measure(&mut cases, input.len());
}
