//! Drain both pipes concurrently while retaining at most a fixed prefix per stream.
//! Only direct-child termination is provided; descendants are NOT a security boundary.
use std::io;
use std::process::Stdio;
use std::sync::{Arc, Mutex};
use std::time::{Duration, Instant};
use tokio::io::AsyncRead;
use tokio::process::Command;
use tokio::task::JoinHandle;

#[cfg(target_os = "macos")]
#[path = "process_macos.rs"]
mod macos;

#[derive(Clone, Debug, Default)]
pub struct ReaderDiagnostics {
    pub started_after: Option<Duration>,
    pub last_progress_after: Option<Duration>,
    pub eof_after: Option<Duration>,
    pub dropped_after: Option<Duration>,
    pub polls: u64,
    pub pending_polls: u64,
    pub reads: u64,
    pub failure: Option<String>,
}

#[derive(Clone, Debug, Default)]
pub struct Capture {
    pub prefix: Vec<u8>,
    pub total: u64,
    pub eof: bool,
    pub diagnostics: ReaderDiagnostics,
}
impl Capture {
    pub fn truncated(&self) -> bool {
        self.total > self.prefix.len() as u64
    }
}

#[derive(Debug)]
pub struct Report {
    pub child_pid: u32,
    pub child_reaped_after: Duration,
    /// Parent-side read descriptors for correlation with an external lsof trace.
    /// They have already been closed when this report is returned; do not use.
    pub read_descriptors: [Option<i32>; 2],
    pub exit_code: Option<i32>,
    pub timed_out: bool,
    pub elapsed: Duration,
    pub stdout: Capture,
    pub stderr: Capture,
    pub reader_errors: Vec<String>,
}

fn state_lock(state: &Mutex<Capture>) -> io::Result<std::sync::MutexGuard<'_, Capture>> {
    state
        .lock()
        .map_err(|_| io::Error::other("capture mutex poisoned"))
}

struct DrainLifetime {
    state: Arc<Mutex<Capture>>,
    start: Instant,
}
impl Drop for DrainLifetime {
    fn drop(&mut self) {
        if let Ok(mut s) = self.state.lock() {
            s.diagnostics.dropped_after = Some(self.start.elapsed());
        }
    }
}

async fn drain(
    mut reader: impl AsyncRead + Unpin,
    state: Arc<Mutex<Capture>>,
    cap: usize,
    start: Instant,
) -> io::Result<()> {
    let _lifetime = DrainLifetime {
        state: Arc::clone(&state),
        start,
    };
    state_lock(&state)?.diagnostics.started_after = Some(start.elapsed());
    let mut chunk = [0u8; 8192];
    loop {
        let result = std::future::poll_fn(|cx| {
            // Count actual AsyncRead polls separately from completed reads. No
            // lock is held across Pending or an external reader.poll_read call.
            let mut buf = tokio::io::ReadBuf::new(&mut chunk);
            let result = std::pin::Pin::new(&mut reader).poll_read(cx, &mut buf);
            if let Ok(mut s) = state.lock() {
                s.diagnostics.polls += 1;
                s.diagnostics.pending_polls += u64::from(result.is_pending());
            }
            result.map(|r| r.map(|()| buf.filled().len()))
        })
        .await;
        let mut s = state_lock(&state)?;
        let n = match result {
            Ok(n) => n,
            Err(e) => {
                s.diagnostics.failure = Some(format!(
                    "kind={:?} os={:?}: {e}",
                    e.kind(),
                    e.raw_os_error()
                ));
                return Err(e);
            }
        };
        s.diagnostics.reads += 1;
        if n == 0 {
            s.eof = true;
            s.diagnostics.eof_after = Some(start.elapsed());
            return Ok(());
        }
        s.diagnostics.last_progress_after = Some(start.elapsed());
        s.total = s
            .total
            .checked_add(n as u64)
            .ok_or_else(|| io::Error::other("byte count overflow"))?;
        let keep = n.min(cap.saturating_sub(s.prefix.len()));
        s.prefix.extend_from_slice(&chunk[..keep]);
        // The mutex guard ends here, before the next read().await.
    }
}

struct ReaderTask {
    handle: JoinHandle<io::Result<()>>,
}
impl Drop for ReaderTask {
    fn drop(&mut self) {
        self.handle.abort();
    }
}

async fn finish_reader(mut reader: ReaderTask, grace: Duration) -> Option<String> {
    match tokio::time::timeout(grace, &mut reader.handle).await {
        Ok(Ok(Ok(()))) => None,
        Ok(Ok(Err(e))) => Some(format!("read failed: {e}")),
        Ok(Err(e)) => Some(format!("reader task failed: {e}")),
        Err(_) => {
            reader.handle.abort();
            let _ = (&mut reader.handle).await; // observe cancellation; drops the pipe owner
            Some("drain grace expired: a writer may still own a pipe".to_owned())
        }
    }
}

/// On successful return the direct child has been waited/reaped. Pipe draining may
/// be cut short after grace; callers must inspect eof and reader_errors.
/// No stdin streaming, descendant killing, CPU/memory quota, or sandboxing.
pub async fn run_child(
    command: &mut Command,
    cap: usize,
    deadline: Duration,
    drain_grace: Duration,
) -> io::Result<Report> {
    if cap > 16 * 1024 * 1024 || deadline.is_zero() || drain_grace.is_zero() {
        return Err(io::Error::new(
            io::ErrorKind::InvalidInput,
            "invalid capture/deadline limit",
        ));
    }
    command
        .stdin(Stdio::null())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .kill_on_drop(true);
    let start = Instant::now();
    // macOS capture avoids std's non-atomic pipe/CLOEXEC creation window.
    #[cfg(target_os = "macos")]
    let (mut child, stdout, stderr) = macos::spawn_captured(command)?;
    #[cfg(not(target_os = "macos"))]
    let (mut child, stdout, stderr) = {
        let mut child = command.spawn()?;
        let stdout = child
            .stdout
            .take()
            .ok_or_else(|| io::Error::other("stdout missing"))?;
        let stderr = child
            .stderr
            .take()
            .ok_or_else(|| io::Error::other("stderr missing"))?;
        (child, stdout, stderr)
    };
    let child_pid = child
        .id()
        .ok_or_else(|| io::Error::other("child pid missing"))?;
    #[cfg(unix)]
    let read_descriptors = {
        use std::os::fd::AsRawFd;
        [Some(stdout.as_raw_fd()), Some(stderr.as_raw_fd())]
    };
    #[cfg(not(unix))]
    let read_descriptors = [None, None];
    let out = Arc::new(Mutex::new(Capture::default()));
    let err = Arc::new(Mutex::new(Capture::default()));
    let mut out_task = ReaderTask {
        handle: tokio::spawn(drain(stdout, Arc::clone(&out), cap, start)),
    };
    let mut err_task = ReaderTask {
        handle: tokio::spawn(drain(stderr, Arc::clone(&err), cap, start)),
    };
    let (status, timed_out) = match tokio::time::timeout(deadline, child.wait()).await {
        Ok(status) => match status {
            Ok(status) => (status, false),
            Err(e) => {
                out_task.handle.abort();
                err_task.handle.abort();
                let _ = (&mut out_task.handle).await;
                let _ = (&mut err_task.handle).await;
                return Err(e);
            }
        },
        Err(_) => {
            // A natural exit racing this request is allowed. Still wait to reap.
            let kill_result = child.start_kill();
            let wait_result = child.wait().await;
            match wait_result {
                Ok(status) => (status, true),
                Err(e) => {
                    out_task.handle.abort();
                    err_task.handle.abort();
                    let _ = (&mut out_task.handle).await;
                    let _ = (&mut err_task.handle).await;
                    return Err(kill_result.err().unwrap_or(e));
                }
            }
        }
    };
    let child_reaped_after = start.elapsed();
    let (out_error, err_error) = tokio::join!(
        finish_reader(out_task, drain_grace),
        finish_reader(err_task, drain_grace)
    );
    let stdout = std::mem::take(&mut *state_lock(&out)?);
    let stderr = std::mem::take(&mut *state_lock(&err)?);
    Ok(Report {
        child_pid,
        child_reaped_after,
        read_descriptors,
        exit_code: status.code(),
        timed_out,
        elapsed: start.elapsed(),
        stdout,
        stderr,
        reader_errors: [out_error, err_error].into_iter().flatten().collect(),
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::{
        pin::Pin,
        task::{Context, Poll},
    };
    use tokio::{io::ReadBuf, sync::oneshot};

    struct PendingReader {
        entered: Option<oneshot::Sender<()>>,
        dropped: Option<oneshot::Sender<()>>,
    }
    impl AsyncRead for PendingReader {
        fn poll_read(
            mut self: Pin<&mut Self>,
            _: &mut Context<'_>,
            _: &mut ReadBuf<'_>,
        ) -> Poll<io::Result<()>> {
            if let Some(tx) = self.entered.take() {
                let _ = tx.send(());
            }
            Poll::Pending
        }
    }
    impl Drop for PendingReader {
        fn drop(&mut self) {
            if let Some(tx) = self.dropped.take() {
                let _ = tx.send(());
            }
        }
    }

    #[test]
    fn abort_observes_reader_owner_drop_without_inventing_eof() {
        crate::current_runtime().expect("runtime").block_on(async {
            let (entered_tx, entered_rx) = oneshot::channel();
            let (drop_tx, drop_rx) = oneshot::channel();
            let state = Arc::new(Mutex::new(Capture::default()));
            let task = ReaderTask {
                handle: tokio::spawn(drain(
                    PendingReader {
                        entered: Some(entered_tx),
                        dropped: Some(drop_tx),
                    },
                    Arc::clone(&state),
                    8,
                    Instant::now(),
                )),
            };
            entered_rx.await.expect("reader was actually polled");
            let error = finish_reader(task, Duration::from_millis(1)).await;
            assert!(error
                .expect("expired grace")
                .contains("drain grace expired"));
            drop_rx.await.expect("pipe owner was dropped");
            let capture = state.lock().expect("capture");
            assert!(!capture.eof);
            assert!(capture.diagnostics.eof_after.is_none());
            assert!(capture.diagnostics.started_after.is_some());
            assert!(capture.diagnostics.dropped_after.is_some());
            assert!(capture.diagnostics.pending_polls > 0);
        });
    }

    #[test]
    fn dropping_reader_task_aborts_instead_of_detaching() {
        crate::current_runtime().expect("runtime").block_on(async {
            let (entered_tx, entered_rx) = oneshot::channel();
            let (drop_tx, drop_rx) = oneshot::channel();
            let task = ReaderTask {
                handle: tokio::spawn(drain(
                    PendingReader {
                        entered: Some(entered_tx),
                        dropped: Some(drop_tx),
                    },
                    Arc::new(Mutex::new(Capture::default())),
                    8,
                    Instant::now(),
                )),
            };
            entered_rx.await.expect("reader started");
            drop(task);
            tokio::time::timeout(Duration::from_secs(1), drop_rx)
                .await
                .expect("abort progressed")
                .expect("owner dropped");
        });
    }
}
