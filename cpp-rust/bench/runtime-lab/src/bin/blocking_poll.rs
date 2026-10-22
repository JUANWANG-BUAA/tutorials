use performance_lab::print_stats;
use runtime_lab::current_runtime;
use std::time::{Duration, Instant};
use tokio::sync::oneshot;

// Deliberately wrong branch is safe Rust: a performance regression, not UB.
async fn observation(offload: bool) -> f64 {
    let (tx, rx) = oneshot::channel();
    let task = tokio::spawn(async move {
        if offload {
            tokio::task::spawn_blocking(move || {
                tx.send(Instant::now()).expect("observer alive");
                std::thread::sleep(Duration::from_millis(20));
            })
            .await
            .expect("blocking worker panicked");
        } else {
            tx.send(Instant::now()).expect("observer alive");
            std::thread::sleep(Duration::from_millis(20));
        }
    });
    let sent = rx.await.expect("sender alive");
    let delay = sent.elapsed().as_secs_f64() * 1e9;
    task.await.expect("async worker panicked");
    delay
}
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let rt = current_runtime()?;
    for offload in [false, true] {
        let warm = Instant::now();
        while warm.elapsed() < Duration::from_millis(500) {
            rt.block_on(observation(offload));
        }
    }
    let mut samples = [Vec::new(), Vec::new()];
    for index in 0..21 {
        for offset in 0..2 {
            let mode = (index + offset) % 2;
            let delay = rt.block_on(observation(mode == 1));
            samples[mode].push(delay);
            println!("{},{index},{delay:.9}", ["inline", "offload"][mode]);
        }
    }
    print_stats("inline", &samples[0]);
    print_stats("offload", &samples[1]);
    Ok(())
}
