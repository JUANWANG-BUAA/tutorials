use evidence_lab::{compute, report, warm};
use std::hint::black_box;
use std::time::{Duration, Instant};

const STEPS: u64 = 1_000_000;

fn run(wait: bool) -> u64 {
    let value = compute(STEPS);
    if wait {
        std::thread::sleep(Duration::from_millis(40));
    }
    black_box(value)
}

fn main() {
    let args: Vec<_> = std::env::args().collect();
    if args.get(1).is_some_and(|s| s == "--profile") {
        let wait = args.get(2).is_some_and(|s| s == "wait");
        let start = Instant::now();
        let mut checksum = 0;
        while start.elapsed() < Duration::from_secs(5) {
            checksum ^= run(wait);
        }
        println!("profile,wait={wait},checksum={checksum}");
        return;
    }
    let expected = compute(STEPS);
    warm(|| {
        assert_eq!(run(false), expected);
    });
    warm(|| {
        assert_eq!(run(true), expected);
    });
    let mut all = [Vec::new(), Vec::new()];
    println!("unit=batch_ms;steps={STEPS};requested_sleep_ms=40;checksum={expected}");
    for round in 0..21 {
        for offset in 0..2 {
            let index = (round + offset) % 2;
            let start = Instant::now();
            let value = run(index == 1);
            let ms = start.elapsed().as_secs_f64() * 1000.0;
            assert_eq!(value, expected);
            all[index].push(ms);
            println!(
                "raw,{},round={round},value={ms:.6},checksum={value}",
                ["cpu", "wait"][index]
            );
        }
    }
    for (case, samples) in ["cpu", "wait"].iter().zip(all.iter()) {
        report(case, samples);
    }
}
