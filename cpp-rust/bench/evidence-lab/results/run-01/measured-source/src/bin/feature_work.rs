use evidence_lab::{report, sum_bytes, warm};
use std::hint::black_box;
use std::time::Instant;

fn main() {
    let bytes: Vec<u8> = (0..=255).cycle().take(1_048_576).collect();
    let expected = bytes.iter().fold(0_u64, |sum, byte| sum + u64::from(*byte));
    let case = if cfg!(feature = "checked") {
        "checked"
    } else {
        "default"
    };
    warm(|| {
        assert_eq!(sum_bytes(black_box(&bytes)), expected);
    });
    let mut samples = Vec::new();
    println!(
        "unit=ns_per_byte;case={case};bytes={};checksum={expected}",
        bytes.len()
    );
    for round in 0..21 {
        let start = Instant::now();
        let value = sum_bytes(black_box(&bytes));
        let ns = start.elapsed().as_secs_f64() * 1e9 / bytes.len() as f64;
        assert_eq!(value, expected);
        samples.push(ns);
        println!("raw,{case},round={round},value={ns:.6},checksum={value}");
    }
    report(case, &samples);
    println!(
        "layout,Vec_u8,size={},align={}",
        std::mem::size_of::<Vec<u8>>(),
        std::mem::align_of::<Vec<u8>>()
    );
    println!(
        "layout,slice_u8,size={},align={}",
        std::mem::size_of::<&[u8]>(),
        std::mem::align_of::<&[u8]>()
    );
}
