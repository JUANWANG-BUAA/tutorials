use compiler_lab::{
    Affine, Case, Kernel, dynamic_batch, dynamic_items, generic_batch, input_data, measure,
};
use std::hint::black_box;
fn main() {
    let input = input_data(16384);
    let kernel = Affine {
        multiplier: 17,
        increment: 29,
    };
    let expected = input
        .iter()
        .map(|&v| v.wrapping_mul(17).wrapping_add(29).rotate_left(7))
        .fold(0, u64::wrapping_add);
    let erased: &dyn Kernel = black_box(&kernel);
    let mut cases = [
        Case {
            name: "generic",
            run: Box::new(|| generic_batch(black_box(&kernel), black_box(&input))),
            expected,
        },
        Case {
            name: "dyn_item",
            run: Box::new(|| dynamic_items(black_box(erased), black_box(&input))),
            expected,
        },
        Case {
            name: "dyn_batch",
            run: Box::new(|| dynamic_batch(black_box(erased), black_box(&input))),
            expected,
        },
    ];
    measure(&mut cases, input.len());
}
