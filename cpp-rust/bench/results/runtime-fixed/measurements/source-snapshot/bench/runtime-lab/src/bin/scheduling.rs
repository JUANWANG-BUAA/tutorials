use performance_lab::{ns_per_op, print_stats};
use runtime_lab::{current_runtime, multi_runtime};
use std::{
    hint::black_box,
    time::{Duration, Instant},
};
use tokio::task::JoinSet;
const TASKS: u64 = 128;
const STEPS: u64 = 8192;

#[inline(never)]
fn step(x: u64) -> u64 {
    black_box(x)
        .wrapping_mul(6364136223846793005)
        .wrapping_add(1)
}

async fn batch(quantum: u64) -> u64 {
    let mut tasks = JoinSet::new();
    for id in 0..TASKS {
        tasks.spawn(async move {
            let mut value = id;
            for chunk in 0..STEPS / quantum {
                for _ in 0..quantum {
                    value = step(value);
                }
                black_box(chunk);
                tokio::task::yield_now().await;
            }
            (id, value)
        });
    }
    let mut count = 0;
    let mut checksum = 0;
    while let Some(result) = tasks.join_next().await {
        let (id, value) = result.expect("benchmark task panicked");
        count += 1;
        checksum ^= value.rotate_left(id as u32);
    }
    assert_eq!(count, TASKS);
    black_box(checksum)
}
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let expected = (0..TASKS).fold(0u64, |sum, id| {
        let value = (0..STEPS).fold(id, |x, _| step(x));
        sum ^ value.rotate_left(id as u32)
    });
    let runtimes = [
        ("current", current_runtime()?),
        ("multi4", multi_runtime(4)?),
    ];
    let mut cases = vec![Vec::new(); 4];
    let warm = Instant::now();
    while warm.elapsed() < Duration::from_millis(500) {
        for (_, runtime) in &runtimes {
            for q in [16, 1024] {
                assert_eq!(runtime.block_on(batch(q)), expected);
            }
        }
    }
    for index in 0..21 {
        // Rotate case order to avoid making configuration and clock drift identical.
        for offset in 0..4 {
            let case = (index + offset) % 4;
            let (name, runtime) = &runtimes[case / 2];
            let quantum = [16, 1024][case % 2];
            let start = Instant::now();
            let actual = runtime.block_on(batch(quantum));
            let value = ns_per_op(start.elapsed(), TASKS * STEPS);
            assert_eq!(actual, expected);
            cases[case].push(value);
            println!("{name}-q{quantum},{index},{value:.9}");
        }
    }
    for case in 0..4 {
        print_stats(
            &format!("{}-q{}", runtimes[case / 2].0, [16, 1024][case % 2]),
            &cases[case],
        );
    }
    Ok(())
}
