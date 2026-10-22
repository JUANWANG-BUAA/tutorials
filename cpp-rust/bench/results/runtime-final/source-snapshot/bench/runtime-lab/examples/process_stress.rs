//! Additional diagnostic after one intermittent parallel-test drain failure.
//! Not a benchmark, not part of the archived 21-observation cases.
use runtime_lab::{current_runtime, process::run_child};
use std::sync::atomic::{AtomicUsize, Ordering};
use std::time::Duration;
use tokio::process::Command;
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let worker = std::env::current_exe()?
        .parent()
        .expect("examples directory")
        .parent()
        .expect("profile directory")
        .join("lab-worker");
    let failures = AtomicUsize::new(0);
    for round in 0..10 {
        std::thread::scope(|scope| {
            for index in 0..8 {
                let worker = &worker;
                let failures = &failures;
                scope.spawn(move || {
                    let runtime = current_runtime().expect("runtime");
                    let mut command = Command::new(worker);
                    command.arg(if index == 0 { "inherit" } else { "flood" });
                    let report = runtime
                        .block_on(run_child(
                            &mut command,
                            8,
                            Duration::from_secs(10),
                            Duration::from_millis(500),
                        ))
                        .expect("spawn/wait");
                    let expected = index == 0
                        || (report.exit_code == Some(0)
                            && !report.timed_out
                            && report.stdout.eof
                            && report.stderr.eof
                            && report.reader_errors.is_empty());
                    if !expected {
                        failures.fetch_add(1, Ordering::Relaxed);
                        eprintln!("round={round} index={index} {report:?}");
                    }
                });
            }
        });
    }
    // Give fixed-life regression helpers a cleanup window; not a tree-reap proof.
    std::thread::sleep(Duration::from_millis(2100));
    let count = failures.load(Ordering::Relaxed);
    println!("stress: 80 direct child reports, 70 flood cases, unexpected_failures={count}");
    if count == 0 {
        Ok(())
    } else {
        Err(std::io::Error::other("drain stress failure").into())
    }
}
