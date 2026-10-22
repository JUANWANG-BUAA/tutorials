use foundations_lab::{Case, N, init_push, init_zero, run};
use std::hint::black_box;
fn main() {
    let expected = (0..N).fold(0u64, |a, i| a.wrapping_add((i as u64).wrapping_mul(17)));
    let mut cases = [
        Case {
            name: "push",
            work: Box::new(|| init_push(black_box(N))),
            expected,
        },
        Case {
            name: "zero_fill",
            work: Box::new(|| init_zero(black_box(N))),
            expected,
        },
    ];
    run(&mut cases, 64, N);
}
