use performance_lab::{ns_per_op, print_stats};
use runtime_lab::{current_runtime, process::run_child};
use std::time::Duration;
use tokio::process::Command;
const BYTES: usize = 2 * 1024 * 1024;
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let worker = std::env::current_exe()?.with_file_name("lab-worker");
    let rt = current_runtime()?;
    let mut samples = [Vec::new(), Vec::new()];
    for index in 0..24 {
        for offset in 0..2 {
            let mode = (index + offset) % 2;
            let cap = [128, BYTES][mode];
            let mut command = Command::new(&worker);
            command.arg("flood").arg(BYTES.to_string());
            let report = rt.block_on(run_child(
                &mut command,
                cap,
                Duration::from_secs(5),
                Duration::from_secs(1),
            ))?;
            assert!(
                !report.timed_out && report.exit_code == Some(0) && report.reader_errors.is_empty()
            );
            for capture in [&report.stdout, &report.stderr] {
                assert!(capture.eof);
                assert_eq!(capture.total, BYTES as u64);
                assert_eq!(capture.prefix.len(), cap);
            }
            if index >= 3 {
                let ns = ns_per_op(report.elapsed, (BYTES * 2) as u64);
                samples[mode].push(ns);
                println!(
                    "{},{},{ns:.9}",
                    ["prefix128", "retain-all"][mode],
                    index - 3
                );
            }
        }
    }
    print_stats("prefix128", &samples[0]);
    print_stats("retain-all", &samples[1]);
    Ok(())
}
