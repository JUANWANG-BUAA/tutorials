use std::hint::black_box;
#[inline(never)]
fn transform<const TAG: u64>(input: &[u64]) -> u64 {
    input.iter().fold(0u64, |sum, &v| {
        sum.wrapping_add(v.wrapping_mul(TAG | 1).rotate_left(TAG as u32 & 63))
    })
}
fn reference(tag: u64, input: &[u64]) -> u64 {
    let mut result = 0u64;
    for &v in input {
        result = result.wrapping_add(v.wrapping_mul(tag | 1).rotate_left(tag as u32 & 63));
    }
    result
}
fn main() {
    let input: Vec<_> = (0u64..4096).map(|v| v.wrapping_mul(173)).collect();
    let functions: &[(u64, fn(&[u64]) -> u64)] = &[
        (1, transform::<1>),
        #[cfg(many)]
        (2, transform::<2>),
        #[cfg(many)]
        (3, transform::<3>),
        #[cfg(many)]
        (4, transform::<4>),
        #[cfg(many)]
        (5, transform::<5>),
        #[cfg(many)]
        (6, transform::<6>),
        #[cfg(many)]
        (7, transform::<7>),
        #[cfg(many)]
        (8, transform::<8>),
        #[cfg(many)]
        (9, transform::<9>),
        #[cfg(many)]
        (10, transform::<10>),
        #[cfg(many)]
        (11, transform::<11>),
        #[cfg(many)]
        (12, transform::<12>),
        #[cfg(many)]
        (13, transform::<13>),
        #[cfg(many)]
        (14, transform::<14>),
        #[cfg(many)]
        (15, transform::<15>),
        #[cfg(many)]
        (16, transform::<16>),
    ];
    let mut checksum = 0u64;
    for _ in 0..32 {
        for &(tag, function) in functions {
            let output = function(black_box(&input));
            assert_eq!(output, reference(tag, &input));
            checksum = checksum.wrapping_add(output);
        }
    }
    println!("instances={} checksum={checksum}", functions.len());
}
