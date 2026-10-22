//! Fixed per-worker operation count. Timer excludes spawn and includes a completion barrier.
use performance_lab::{ns_per_op, print_stats};
use std::hint::black_box;
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::Barrier;
use std::time::Instant;

// 128 is an experimental separation, not a claim about all machines' line size.
#[repr(align(128))]
struct Padded(AtomicU64);

#[derive(Clone, Copy, Debug)]
enum Mode {
    Shared,
    Adjacent,
    Padded,
    Batched,
}

fn run(mode: Mode, order: Ordering, threads: usize, iters: u64) -> f64 {
    let shared = AtomicU64::new(0);
    let adjacent: Vec<_> = (0..threads).map(|_| AtomicU64::new(0)).collect();
    let padded: Vec<_> = (0..threads).map(|_| Padded(AtomicU64::new(0))).collect();
    let ready = Barrier::new(threads + 1);
    let start = Barrier::new(threads + 1);
    let done = Barrier::new(threads + 1);
    std::thread::scope(|scope| {
        for id in 0..threads {
            let (shared, adjacent, padded, ready, start, done) =
                (&shared, &adjacent, &padded, &ready, &start, &done);
            scope.spawn(move || {
                ready.wait();
                start.wait();
                match mode {
                    Mode::Shared => {
                        for _ in 0..iters {
                            shared.fetch_add(1, order);
                        }
                    }
                    Mode::Adjacent => {
                        for _ in 0..iters {
                            adjacent[id].fetch_add(1, order);
                        }
                    }
                    Mode::Padded => {
                        for _ in 0..iters {
                            padded[id].0.fetch_add(1, order);
                        }
                    }
                    Mode::Batched => {
                        let mut local = 0u64;
                        for _ in 0..iters {
                            local = local.wrapping_add(black_box(1u64));
                        }
                        shared.fetch_add(local, order);
                    }
                }
                done.wait();
            });
        }
        ready.wait();
        let begin = Instant::now();
        start.wait();
        done.wait();
        let elapsed = begin.elapsed();
        let total = match mode {
            Mode::Shared | Mode::Batched => shared.load(Ordering::Relaxed),
            Mode::Adjacent => adjacent.iter().map(|a| a.load(Ordering::Relaxed)).sum(),
            Mode::Padded => padded.iter().map(|a| a.0.load(Ordering::Relaxed)).sum(),
        };
        assert_eq!(total, threads as u64 * iters);
        ns_per_op(elapsed, total)
    })
}

fn main() {
    let args: Vec<_> = std::env::args().collect();
    let threads = args
        .get(1)
        .map(|s| s.parse().expect("threads: integer"))
        .unwrap_or(4);
    let iters = args
        .get(2)
        .map(|s| s.parse().expect("iterations: integer"))
        .unwrap_or(500_000);
    let samples: usize = args
        .get(3)
        .map(|s| s.parse().expect("samples: integer"))
        .unwrap_or(21);
    assert!((1..=64).contains(&threads) && (2..=1000).contains(&samples));
    assert!((1..=100_000_000).contains(&iters));
    let cases = [
        (Mode::Shared, Ordering::Relaxed),
        (Mode::Shared, Ordering::SeqCst),
        (Mode::Adjacent, Ordering::Relaxed),
        (Mode::Padded, Ordering::Relaxed),
        (Mode::Batched, Ordering::Relaxed),
    ];
    println!("threads={threads} iterations_per_thread={iters} samples={samples}");
    println!(
        "AtomicU64 size={} align={} padded_size={} padded_align={}",
        size_of::<AtomicU64>(),
        align_of::<AtomicU64>(),
        size_of::<Padded>(),
        align_of::<Padded>()
    );
    println!("case,sample,ns_per_aggregate_op");
    let mut data: Vec<Vec<f64>> = vec![Vec::new(); cases.len()];
    for &(mode, order) in &cases {
        black_box(run(mode, order, threads, iters));
    }
    // Rotate order to avoid always running SeqCst or padded at the same thermal position.
    for sample in 0..samples {
        for offset in 0..cases.len() {
            let i = (sample + offset) % cases.len();
            let (mode, order) = cases[i];
            let value = run(mode, order, threads, iters);
            println!("{mode:?}-{order:?},{sample},{value:.6}");
            data[i].push(value);
        }
    }
    for (i, &(mode, order)) in cases.iter().enumerate() {
        print_stats(&format!("{mode:?}-{order:?}"), &data[i]);
    }
}
