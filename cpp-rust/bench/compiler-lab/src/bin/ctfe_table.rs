use compiler_lab::{BIT_TABLE, Case, lookup_bits, measure, runtime_table};
use std::hint::black_box;
fn main() {
    let input: Vec<u8> = (0u8..=255).collect();
    let expected = input.iter().map(|v| u64::from(v.count_ones())).sum();
    let mut cases = [
        Case {
            name: "static_table",
            run: Box::new(|| lookup_bits(black_box(&BIT_TABLE), black_box(&input))),
            expected,
        },
        Case {
            name: "rebuild_table",
            run: Box::new(|| {
                let table = runtime_table();
                lookup_bits(black_box(&table), black_box(&input))
            }),
            expected,
        },
    ];
    measure(&mut cases, input.len());
}
