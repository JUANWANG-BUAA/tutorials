//! Deterministic macOS inherited-extra-fd regression, not a benchmark.
//! Run only through diagnostics/reproduce_descriptor_race.sh with the dyld gate.
#[cfg(target_os = "macos")]
fn main() -> Result<(), Box<dyn std::error::Error>> {
    use agent_runtime::{Config, Input, Outcome, Registry, Runtime};
    use std::{io, path::PathBuf, process::Stdio, time::Duration};
    let dir = PathBuf::from(std::env::var_os("DRAIN_GATE_DIR").expect("gate directory"));
    let helper = std::env::current_exe()?
        .parent()
        .expect("examples directory")
        .parent()
        .expect("profile directory")
        .join("tool-helper");
    let driver = tokio::runtime::Builder::new_current_thread()
        .enable_all()
        .build()?;
    let mode = std::env::var("DRAIN_CASE").unwrap_or_else(|_| "logs".into());
    assert!(mode == "logs" || mode == "sleep");
    let mut registry = Registry::default();
    registry.helper("demo", &helper).map_err(io::Error::other)?;
    std::fs::write(dir.join("armed"), b"armed")?;
    std::thread::scope(|scope| -> Result<(), Box<dyn std::error::Error>> {
        let other = scope.spawn(|| -> io::Result<()> {
            let start = std::time::Instant::now();
            while !dir.join("ready").exists() {
                if start.elapsed() > Duration::from_secs(10) {
                    return Err(io::Error::other("pipe gate never entered"));
                }
                std::thread::sleep(Duration::from_millis(1));
            }
            let ready = std::fs::read_to_string(dir.join("ready"))?;
            println!("gate: {ready}");
            let pidfile = dir.join("descendant.pid");
            let mut inheritor = std::process::Command::new(&helper)
                .arg("inherit")
                .arg(&pidfile)
                .arg("2000")
                .env_remove("DRAIN_GATE_DIR")
                .env_remove("DYLD_INSERT_LIBRARIES")
                .stdin(Stdio::null())
                .stdout(Stdio::null())
                .stderr(Stdio::null())
                .spawn()?;
            assert!(inheritor.wait()?.success());
            while !pidfile.exists() {
                if start.elapsed() > Duration::from_secs(10) {
                    return Err(io::Error::other("descendant never announced PID"));
                }
                std::thread::sleep(Duration::from_millis(1));
            }
            let pid = std::fs::read_to_string(&pidfile)?;
            std::fs::write(dir.join("observed-descendant.pid"), &pid)?;
            let lsof = std::process::Command::new("/usr/sbin/lsof")
                .args(["-nP", "-p", pid.trim()])
                .env_remove("DRAIN_GATE_DIR")
                .env_remove("DYLD_INSERT_LIBRARIES")
                .output()?;
            std::fs::write(dir.join("lsof.txt"), &lsof.stdout)?;
            std::fs::write(dir.join("lsof-stderr.txt"), &lsof.stderr)?;
            // Always release the blocked syscall before checking expectations.
            std::fs::write(dir.join("release"), b"release")?;
            assert!(lsof.status.success(), "lsof failed");
            let listing = String::from_utf8_lossy(&lsof.stdout);
            assert!(
                listing.contains(pid.trim()),
                "lsof must identify live descendant"
            );
            assert!(
                ready.contains("api=pipe2") && ready.matches("flags=1").count() == 2,
                "capture must be atomically CLOEXEC at the syscall barrier: {ready}"
            );
            for line in listing.lines().skip(1) {
                let fields: Vec<_> = line.split_whitespace().collect();
                if fields.len() > 4 && fields.contains(&"PIPE") {
                    let fd: String = fields[3].chars().take_while(char::is_ascii_digit).collect();
                    if let Ok(fd) = fd.parse::<u32>() {
                        assert!(fd <= 2, "unrelated descendant inherited extra pipe: {line}");
                    }
                }
            }
            // Fixture lifetime is bounded, and completes before this example exits.
            while pidfile.exists() {
                if start.elapsed() > Duration::from_secs(10) {
                    return Err(io::Error::other("descendant did not finish hold"));
                }
                std::thread::sleep(Duration::from_millis(1));
            }
            Ok(())
        });
        let result = driver.block_on(async {
            let runtime = Runtime::start(registry, Config::default()).expect("runtime");
            let (input, timeout) = if mode == "sleep" {
                (Input::Sleep { millis: 5000 }, Duration::from_millis(200))
            } else {
                (
                    Input::Logs {
                        bytes: 2 * 1024 * 1024,
                    },
                    Duration::from_secs(5),
                )
            };
            let result = runtime
                .client()
                .try_submit("demo", input, timeout)
                .expect("accepted")
                .wait()
                .await
                .expect("result");
            let shutdown = runtime.shutdown().await.expect("joined");
            assert_eq!(shutdown.joined, 1);
            assert!(shutdown.task_failures.is_empty());
            result
        });
        other.join().expect("inheritor thread")?;
        println!("{result:#?}");
        assert!(result.reaped && result.cleanup_error.is_none());
        if mode == "logs" {
            assert_eq!(result.outcome, Outcome::Success);
            assert_eq!(result.exit_code, Some(0));
            for (log, byte) in [(&result.stdout, b'O'), (&result.stderr, b'E')] {
                assert_eq!(log.total, 2 * 1024 * 1024);
                assert_eq!(log.prefix, vec![byte; 8192]);
                let checksum = (0..2 * 1024 * 1024).fold(0xcbf29ce484222325u64, |h, _| {
                    (h ^ u64::from(byte)).wrapping_mul(0x100000001b3)
                });
                assert_eq!(log.checksum, checksum);
            }
        } else {
            assert_eq!(result.outcome, Outcome::TimedOut);
            assert_ne!(result.exit_code, Some(0));
        }
        for log in [&result.stdout, &result.stderr] {
            assert!(
                log.eof && log.error.is_none(),
                "unrelated process retained writer: {result:?}"
            );
        }
        Ok(())
    })
}

#[cfg(not(target_os = "macos"))]
fn main() {
    eprintln!("descriptor_race is a macOS-only diagnostic, unverified on this platform");
    std::process::exit(2);
}
