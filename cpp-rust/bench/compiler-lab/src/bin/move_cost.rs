use compiler_lab::{Case, borrowed_sum, cloned_sum, input_data, measure};
use std::hint::black_box;
fn main() {
    let input = input_data(16384);
    let expected = input.iter().copied().fold(0, u64::wrapping_add);
    let mut cases = [
        Case {
            name: "borrow",
            run: Box::new(|| borrowed_sum(black_box(&input))),
            expected,
        },
        Case {
            name: "clone",
            run: Box::new(|| cloned_sum(black_box(&input))),
            expected,
        },
    ];
    measure(&mut cases, input.len());
}
