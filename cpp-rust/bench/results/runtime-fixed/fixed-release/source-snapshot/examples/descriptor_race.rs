//! macOS fault-injection driver; see diagnostics/README.md. Not a benchmark.
use runtime_lab::{current_runtime, process::run_child};
use std::{
    io,
    path::PathBuf,
    process::Stdio,
    time::{Duration, Instant},
};
use tokio::process::Command;
fn main() -> io::Result<()> {
    let dir = PathBuf::from(std::env::var_os("DRAIN_GATE_DIR").expect("DRAIN_GATE_DIR"));
    let worker = std::env::current_exe()?
        .parent()
        .expect("examples")
        .parent()
        .expect("profile")
        .join("lab-worker");
    let runtime = current_runtime()?; // initialize driver before arming pipe gate
    std::fs::write(dir.join("armed"), b"armed")?;
    std::thread::scope(|scope| -> io::Result<()> {
        let other = scope.spawn(|| -> io::Result<()> {
            let start = Instant::now();
            while !dir.join("ready").exists() {
                if start.elapsed() > Duration::from_secs(10) {
                    return Err(io::Error::other("pipe gate never entered"));
                }
                std::thread::sleep(Duration::from_millis(1));
            }
            println!("gate: {}", std::fs::read_to_string(dir.join("ready"))?);
            let mut inheritor = std::process::Command::new(&worker)
                .arg("inherit")
                .env_remove("DRAIN_GATE_DIR")
                .stdin(Stdio::null())
                .stdout(Stdio::null())
                .stderr(Stdio::null())
                .spawn()?;
            println!("unrelated inheritor pid={}", inheritor.id());
            inheritor.wait()?;
            // Capture real kernel descriptor ownership before allowing CLOEXEC.
            let output = std::process::Command::new("/usr/sbin/lsof")
                .args(["-nP", "-c", "lab-worker"])
                .env_remove("DRAIN_GATE_DIR")
                .output()?;
            std::fs::write(dir.join("lsof.txt"), output.stdout)?;
            std::fs::write(dir.join("release"), b"release")?;
            Ok(())
        });
        let mode = std::env::var("DRAIN_CASE").unwrap_or_else(|_| "flood".into());
        assert!(mode == "flood" || mode == "sleep");
        let deadline = if mode == "sleep" {
            Duration::from_millis(30)
        } else {
            Duration::from_secs(5)
        };
        let mut command = Command::new(&worker);
        command.arg(&mode).env_remove("DRAIN_GATE_DIR");
        let report =
            runtime.block_on(run_child(&mut command, 8, deadline, Duration::from_secs(1)))?;
        other.join().expect("inheritor thread")?;
        println!("{report:#?}");
        std::thread::sleep(Duration::from_millis(2100));
        if mode == "flood" {
            assert_eq!(report.exit_code, Some(0));
            assert!(!report.timed_out);
            assert_eq!(
                (report.stdout.total, report.stderr.total),
                (2097152, 2097152)
            );
        } else {
            assert!(report.timed_out);
            assert_ne!(report.exit_code, Some(0));
        }
        assert!(
            report.stdout.eof && report.stderr.eof && report.reader_errors.is_empty(),
            "unrelated process retained writer: {report:?}"
        );
        Ok(())
    })
}
