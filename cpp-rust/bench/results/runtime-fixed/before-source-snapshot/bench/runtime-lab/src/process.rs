//! Drain both pipes concurrently while retaining at most a fixed prefix per stream.
//! Only direct-child termination is provided; descendants are NOT a security boundary.
use std::io;
use std::process::Stdio;
use std::sync::{Arc, Mutex};
use std::time::{Duration, Instant};
use tokio::io::{AsyncRead, AsyncReadExt};
use tokio::process::Command;
use tokio::task::JoinHandle;

#[derive(Clone, Debug, Default)]
pub struct Capture {
    pub prefix: Vec<u8>,
    pub total: u64,
    pub eof: bool,
}
impl Capture {
    pub fn truncated(&self) -> bool {
        self.total > self.prefix.len() as u64
    }
}

#[derive(Debug)]
pub struct Report {
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

async fn drain(
    mut reader: impl AsyncRead + Unpin,
    state: Arc<Mutex<Capture>>,
    cap: usize,
) -> io::Result<()> {
    let mut chunk = [0u8; 8192];
    loop {
        let n = reader.read(&mut chunk).await?;
        let mut s = state_lock(&state)?;
        if n == 0 {
            s.eof = true;
            return Ok(());
        }
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
    let mut child = command.spawn()?;
    let stdout = child
        .stdout
        .take()
        .ok_or_else(|| io::Error::other("stdout missing"))?;
    let stderr = child
        .stderr
        .take()
        .ok_or_else(|| io::Error::other("stderr missing"))?;
    let out = Arc::new(Mutex::new(Capture::default()));
    let err = Arc::new(Mutex::new(Capture::default()));
    let mut out_task = ReaderTask {
        handle: tokio::spawn(drain(stdout, Arc::clone(&out), cap)),
    };
    let mut err_task = ReaderTask {
        handle: tokio::spawn(drain(stderr, Arc::clone(&err), cap)),
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
    let (out_error, err_error) = tokio::join!(
        finish_reader(out_task, drain_grace),
        finish_reader(err_task, drain_grace)
    );
    let stdout = std::mem::take(&mut *state_lock(&out)?);
    let stderr = std::mem::take(&mut *state_lock(&err)?);
    Ok(Report {
        exit_code: status.code(),
        timed_out,
        elapsed: start.elapsed(),
        stdout,
        stderr,
        reader_errors: [out_error, err_error].into_iter().flatten().collect(),
    })
}
