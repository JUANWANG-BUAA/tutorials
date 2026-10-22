use runtime_lab::{current_runtime, process::run_child};
use std::{io, time::Duration};
use tokio::{
    process::Command,
    sync::{mpsc, oneshot, Semaphore},
    task::JoinSet,
};

#[test]
fn bounded_channel_and_close_preserve_messages() {
    current_runtime().expect("runtime").block_on(async {
        let (tx, mut rx) = mpsc::channel(1);
        tx.try_send(10).expect("first slot");
        assert!(matches!(
            tx.try_send(20),
            Err(mpsc::error::TrySendError::Full(20))
        ));
        assert_eq!(rx.recv().await, Some(10));
        tx.send(20).await.expect("space reused");
        drop(tx);
        assert_eq!(rx.recv().await, Some(20));
        assert_eq!(rx.recv().await, None);
    });
}

#[test]
fn abort_observed_and_drop_executed() {
    current_runtime().expect("runtime").block_on(async {
        struct Signal(Option<oneshot::Sender<()>>);
        impl Drop for Signal {
            fn drop(&mut self) {
                if let Some(tx) = self.0.take() {
                    let _ = tx.send(());
                }
            }
        }
        let (ready_tx, ready_rx) = oneshot::channel();
        let (drop_tx, drop_rx) = oneshot::channel();
        let task = tokio::spawn(async move {
            let _signal = Signal(Some(drop_tx));
            ready_tx.send(()).expect("ready receiver");
            std::future::pending::<()>().await;
        });
        ready_rx.await.expect("started");
        task.abort();
        assert!(task.await.expect_err("cancelled").is_cancelled());
        drop_rx.await.expect("drop executed");
    });
}

#[test]
fn blocking_permit_is_held_inside_closure() {
    current_runtime().expect("runtime").block_on(async {
        let semaphore = std::sync::Arc::new(Semaphore::new(1));
        let permit = semaphore.clone().acquire_owned().await.expect("permit");
        let (started_tx, started_rx) = oneshot::channel();
        let (stop_tx, stop_rx) = std::sync::mpsc::channel();
        let task = tokio::task::spawn_blocking(move || {
            let _permit = permit;
            started_tx.send(()).expect("observer");
            stop_rx.recv().expect("stop signal");
        });
        started_rx.await.expect("started");
        task.abort();
        assert!(semaphore.clone().try_acquire_owned().is_err());
        stop_tx.send(()).expect("stop worker");
        task.await.expect("started blocking task is not aborted");
        assert!(semaphore.try_acquire_owned().is_ok());
    });
}

#[test]
fn joinset_observes_panic_and_completes_other_task() {
    current_runtime().expect("runtime").block_on(async {
        let mut tasks = JoinSet::new();
        tasks.spawn(async {
            panic!("intentional test panic");
        });
        tasks.spawn(async {});
        let mut successes = 0;
        let mut panics = 0;
        while let Some(result) = tasks.join_next().await {
            match result {
                Ok(()) => successes += 1,
                Err(e) if e.is_panic() => panics += 1,
                Err(e) => panic!("unexpected: {e}"),
            }
        }
        assert_eq!((successes, panics), (1, 1));
    });
}

fn command(mode: &str) -> Command {
    let mut c = Command::new(env!("CARGO_BIN_EXE_lab-worker"));
    c.arg(mode);
    c
}
#[test]
fn concurrently_drains_and_caps_both_streams() {
    current_runtime().expect("runtime").block_on(async {
        let report = run_child(
            &mut command("flood"),
            128,
            Duration::from_secs(5),
            Duration::from_secs(1),
        )
        .await
        .expect("run");
        assert_eq!(report.exit_code, Some(0));
        assert!(!report.timed_out);
        assert!(report.reader_errors.is_empty());
        for capture in [&report.stdout, &report.stderr] {
            assert_eq!(capture.total, 2097152);
            assert_eq!(capture.prefix.len(), 128);
            assert!(capture.eof && capture.truncated());
        }
    });
}
#[test]
fn timeout_kills_and_waits_direct_child() {
    current_runtime().expect("runtime").block_on(async {
        let report = run_child(
            &mut command("sleep"),
            128,
            Duration::from_millis(30),
            Duration::from_secs(1),
        )
        .await
        .expect("run");
        assert!(report.timed_out);
        assert_ne!(report.exit_code, Some(0));
        assert!(report.stdout.eof && report.stderr.eof);
    });
}
#[test]
fn nonzero_exit_is_a_report_not_spawn_error() {
    current_runtime().expect("runtime").block_on(async {
        let report = run_child(
            &mut command("fail"),
            128,
            Duration::from_secs(5),
            Duration::from_secs(1),
        )
        .await
        .expect("run");
        assert_eq!(report.exit_code, Some(7));
        assert!(!report.timed_out);
    });
}
#[test]
fn missing_executable_is_spawn_error() {
    current_runtime().expect("runtime").block_on(async {
        let mut c = Command::new("/this/executable/does/not/exist");
        let e = run_child(&mut c, 128, Duration::from_secs(1), Duration::from_secs(1))
            .await
            .expect_err("spawn fails");
        assert_eq!(e.kind(), io::ErrorKind::NotFound);
    });
}
#[test]
fn wait_before_drain_is_a_reproduced_stall() {
    current_runtime().expect("runtime").block_on(async {
        use tokio::io::AsyncReadExt;
        let mut c = command("flood");
        c.stdout(std::process::Stdio::piped())
            .stderr(std::process::Stdio::piped())
            .kill_on_drop(true);
        let mut child = c.spawn().expect("spawn flood");
        let mut output = child.stdout.take().expect("stdout");
        let _error_output = child.stderr.take().expect("stderr");
        let mut first = [0u8; 1];
        output
            .read_exact(&mut first)
            .await
            .expect("worker started output");
        assert_eq!(first, [b'x']);
        assert!(
            tokio::time::timeout(Duration::from_millis(30), child.wait())
                .await
                .is_err()
        );
        child.start_kill().expect("kill stalled direct child");
        child.wait().await.expect("reap stalled child");
    });
}

#[test]
fn invalid_limit_is_rejected_before_spawn() {
    current_runtime().expect("runtime").block_on(async {
        let error = run_child(
            &mut command("sleep"),
            17 * 1024 * 1024,
            Duration::from_secs(1),
            Duration::from_secs(1),
        )
        .await
        .expect_err("too much retained output");
        assert_eq!(error.kind(), io::ErrorKind::InvalidInput);
    });
}

#[test]
fn inherited_writer_does_not_hang_drainers_forever() {
    current_runtime().expect("runtime").block_on(async {
        let report = run_child(
            &mut command("inherit"),
            128,
            Duration::from_secs(5),
            Duration::from_millis(30),
        )
        .await
        .expect("run");
        assert_eq!(report.exit_code, Some(0));
        assert!(!report.stdout.eof && !report.stderr.eof);
        assert_eq!(report.reader_errors.len(), 2);
        // Helper descendant has a fixed two-second life. No claim of process-tree control.
        tokio::time::sleep(Duration::from_millis(2100)).await;
    });
}
