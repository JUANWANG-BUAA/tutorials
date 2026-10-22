use performance_lab::{ns_per_op, print_stats};
use runtime_lab::{current_runtime, process::run_child};
use std::{
    path::Path,
    time::{Duration, Instant},
};
use tokio::process::Command;
const BYTES: usize = 2 * 1024 * 1024;
async fn observation(worker: &Path, cap: usize) -> std::io::Result<f64> {
    let mut command = Command::new(worker);
    command.arg("flood").arg(BYTES.to_string());
    let report = run_child(
        &mut command,
        cap,
        Duration::from_secs(5),
        Duration::from_secs(1),
    )
    .await?;
    assert!(
        !report.timed_out && report.exit_code == Some(0) && report.reader_errors.is_empty(),
        "{report:#?}"
    );
    for capture in [&report.stdout, &report.stderr] {
        assert!(capture.eof);
        assert_eq!(capture.total, BYTES as u64);
        assert_eq!(capture.prefix.len(), cap);
        // Validate actual retained bytes, not merely vector length. Validation
        // runs after Report's elapsed boundary and is excluded from the sample.
        assert!(capture.prefix.iter().all(|&byte| byte == b'x'));
    }
    Ok(ns_per_op(report.elapsed, (BYTES * 2) as u64))
}
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let worker = std::env::current_exe()?.with_file_name("lab-worker");
    let rt = current_runtime()?;
    for cap in [128, BYTES] {
        let warm = Instant::now();
        while warm.elapsed() < Duration::from_millis(500) {
            rt.block_on(observation(&worker, cap))?;
        }
    }
    let mut samples = [Vec::new(), Vec::new()];
    for index in 0..21 {
        for offset in 0..2 {
            let mode = (index + offset) % 2;
            let ns = rt.block_on(observation(&worker, [128, BYTES][mode]))?;
            samples[mode].push(ns);
            println!("{},{index},{ns:.9}", ["prefix128", "retain-all"][mode]);
        }
    }
    print_stats("prefix128", &samples[0]);
    print_stats("retain-all", &samples[1]);
    Ok(())
}
