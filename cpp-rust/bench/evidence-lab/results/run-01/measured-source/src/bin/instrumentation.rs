use evidence_lab::{Mode, compute, observed, report, warm};
use std::hint::black_box;
use std::time::Instant;

const STEPS: u64 = 200_000;
fn main() {
    let modes = [Mode::None, Mode::Batch, Mode::Each];
    let names = ["none", "batch", "each"];
    let expected = compute(STEPS);
    warm(|| {
        for mode in modes {
            black_box(observed(STEPS, mode));
        }
    });
    let mut all = [Vec::new(), Vec::new(), Vec::new()];
    println!("unit=ns_per_step;steps={STEPS};checksum={expected}");
    for round in 0..21 {
        for offset in 0..3 {
            let index = (round + offset) % 3;
            let start = Instant::now();
            let (value, count) = observed(STEPS, modes[index]);
            let ns = start.elapsed().as_secs_f64() * 1e9 / STEPS as f64;
            assert_eq!(value, expected);
            assert_eq!(count, if index == 0 { 0 } else { STEPS });
            all[index].push(ns);
            println!(
                "raw,{},round={round},value={ns:.6},checksum={value},count={count}",
                names[index]
            );
        }
    }
    for (case, samples) in names.iter().zip(all.iter()) {
        report(case, samples);
    }
    println!(
        "layout,Event,size={},align={}",
        std::mem::size_of::<evidence_lab::Event>(),
        std::mem::align_of::<evidence_lab::Event>()
    );
}
