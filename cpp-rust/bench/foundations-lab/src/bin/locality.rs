use foundations_lab::{Case, N, Record, data, run, sum_aos, sum_soa};
use std::hint::black_box;
fn main() {
    let hot = data(N);
    let aos: Vec<_> = hot
        .iter()
        .map(|&hot| Record { hot, cold: [11; 7] })
        .collect();
    let expected = hot.iter().fold(0u64, |a, &b| a.wrapping_add(b));
    let mut cases = [
        Case {
            name: "aos",
            work: Box::new(|| sum_aos(black_box(&aos))),
            expected,
        },
        Case {
            name: "soa",
            work: Box::new(|| sum_soa(black_box(&hot))),
            expected,
        },
    ];
    run(&mut cases, 128, N);
}
