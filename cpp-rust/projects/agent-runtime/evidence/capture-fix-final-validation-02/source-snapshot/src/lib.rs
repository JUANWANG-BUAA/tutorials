//! Bounded named-tool execution on a real Tokio runtime.
//!
//! Only direct children are killed and reaped. No process-tree or sandbox promise.
//! Use `Runtime::shutdown` before destroying the surrounding Tokio runtime.
use std::collections::BTreeMap;
use std::ffi::OsString;
use std::path::{Path, PathBuf};
use std::process::Stdio;
use std::sync::Arc;
use std::time::Duration;
use tokio::io::{AsyncRead, AsyncReadExt};
use tokio::process::Command;
use tokio::sync::{OwnedSemaphorePermit, Semaphore, mpsc, oneshot, watch};
use tokio::task::{JoinHandle, JoinSet};
use tokio::time::{Instant, sleep_until};

#[cfg(target_os = "macos")]
mod process_macos;

#[cfg(not(target_os = "macos"))]
fn spawn_captured(
    command: &mut Command,
) -> std::io::Result<(
    tokio::process::Child,
    tokio::process::ChildStdout,
    tokio::process::ChildStderr,
)> {
    // Unverified on non-macOS: retain the standard library platform implementation.
    // No claim here that every supported OS creates its capture pipes atomically.
    let mut child = command
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()?;
    let out = child.stdout.take().expect("stdout configured as piped");
    let err = child.stderr.take().expect("stderr configured as piped");
    Ok((child, out, err))
}

#[cfg(target_os = "macos")]
use process_macos::spawn_captured;

/// Typed, bounded arguments. No shell parsing, stdin, or arbitrary executable input.
#[derive(Clone, Debug)]
pub enum Input {
    Echo(String),
    Logs { bytes: usize },
    Sleep { millis: u64 },
    Fail { code: u8 },
    Fixed,
}

#[derive(Clone, Debug)]
enum Tool {
    Helper(PathBuf),
    Fixed {
        executable: PathBuf,
        args: Vec<OsString>,
    },
}

/// Construct at startup; immutable after `Runtime::start`.
#[derive(Clone, Debug, Default)]
pub struct Registry(BTreeMap<String, Tool>);

impl Registry {
    /// Register the bundled helper. Canonicalization fixes its absolute path now.
    pub fn helper(&mut self, name: &str, path: impl AsRef<Path>) -> Result<(), String> {
        let path = std::fs::canonicalize(path).map_err(|e| e.to_string())?;
        self.insert(name, Tool::Helper(path))
    }

    /// A trusted administrator may expose a fixed command with fixed arguments.
    /// Request callers cannot override executable, environment, cwd or arguments.
    pub fn fixed(
        &mut self,
        name: &str,
        executable: impl AsRef<Path>,
        args: Vec<OsString>,
    ) -> Result<(), String> {
        if args.len() > 32 || args.iter().any(|s| s.len() > 4096) {
            return Err("fixed argument budget exceeded".into());
        }
        let executable = std::fs::canonicalize(executable).map_err(|e| e.to_string())?;
        self.insert(name, Tool::Fixed { executable, args })
    }

    fn insert(&mut self, name: &str, tool: Tool) -> Result<(), String> {
        if name.is_empty()
            || name.len() > 64
            || !name.bytes().all(|b| b.is_ascii_alphanumeric() || b == b'-')
        {
            return Err("invalid tool name".into());
        }
        if self.0.contains_key(name) {
            return Err("duplicate tool name".into());
        }
        self.0.insert(name.into(), tool);
        Ok(())
    }

    fn resolve(&self, name: &str, input: &Input) -> Result<(PathBuf, Vec<OsString>), SubmitError> {
        let tool = self.0.get(name).ok_or(SubmitError::UnknownTool)?;
        let args: Vec<OsString> = match (tool, input) {
            (Tool::Fixed { executable, args }, Input::Fixed) => {
                return Ok((executable.clone(), args.clone()));
            }
            (Tool::Helper(_), Input::Echo(s)) if s.len() <= 4096 && !s.contains('\0') => {
                vec!["echo".into(), s.into()]
            }
            (Tool::Helper(_), Input::Logs { bytes }) if *bytes <= 16 * 1024 * 1024 => {
                vec!["logs".into(), bytes.to_string().into()]
            }
            (Tool::Helper(_), Input::Sleep { millis }) if *millis <= 60_000 => {
                vec!["sleep".into(), millis.to_string().into()]
            }
            (Tool::Helper(_), Input::Fail { code }) if *code != 0 => {
                vec!["fail".into(), code.to_string().into()]
            }
            _ => return Err(SubmitError::InvalidInput),
        };
        match tool {
            Tool::Helper(path) => Ok((path.clone(), args)),
            Tool::Fixed { .. } => Err(SubmitError::InvalidInput),
        }
    }
}

#[derive(Clone, Debug)]
pub struct Config {
    pub queue: usize,
    pub concurrency: usize,
    /// Maximum retained prefix per stream, not maximum amount drained.
    pub retain: usize,
    /// Bound on waiting for EOF after a direct child has been reaped.
    pub drain_grace: Duration,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            queue: 16,
            concurrency: 4,
            retain: 8192,
            drain_grace: Duration::from_secs(1),
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum SubmitError {
    UnknownTool,
    InvalidInput,
    Full,
    Closed,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Outcome {
    Success,
    NonZero,
    TimedOut,
    Cancelled,
    SpawnFailed,
    WaitFailed,
}

#[derive(Debug, Default)]
pub struct Log {
    pub prefix: Vec<u8>,
    pub total: u64,
    pub checksum: u64,
    pub eof: bool,
    pub error: Option<String>,
}

impl Log {
    /// FNV-1a over *all* drained bytes, including discarded suffixes.
    #[inline(never)]
    pub fn record(&mut self, bytes: &[u8], retain: usize) {
        if self.total == 0 {
            self.checksum = 0xcbf29ce484222325;
        }
        for &byte in bytes {
            self.checksum = (self.checksum ^ u64::from(byte)).wrapping_mul(0x100000001b3);
        }
        self.total = self.total.saturating_add(bytes.len() as u64);
        let n = bytes.len().min(retain.saturating_sub(self.prefix.len()));
        self.prefix.extend_from_slice(&bytes[..n]);
    }
}

#[derive(Debug)]
pub struct ToolResult {
    pub outcome: Outcome,
    pub pid: Option<u32>,
    pub exit_code: Option<i32>,
    /// True only after a successful `Child::wait`.
    pub reaped: bool,
    pub stdout: Log,
    pub stderr: Log,
    pub queue_time: Duration,
    /// Includes spawn, wait and drain/cleanup. Not just external-tool CPU time.
    pub work_time: Duration,
    pub cleanup_error: Option<String>,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Stage {
    Queued,
    Running(u32),
    Reaped,
    Finished,
}

struct Job {
    executable: PathBuf,
    args: Vec<OsString>,
    accepted: Instant,
    deadline: Instant,
    cancelled: watch::Receiver<bool>,
    result: oneshot::Sender<ToolResult>,
    stage: watch::Sender<Stage>,
    _admission: OwnedSemaphorePermit,
}

/// Dropping a ticket requests cancellation; it does not abort the worker task.
/// To observe cleanup, call `cancel` and then `wait` instead of dropping it.
pub struct Ticket {
    result: oneshot::Receiver<ToolResult>,
    cancel: watch::Sender<bool>,
    stage: watch::Receiver<Stage>,
}

impl Ticket {
    /// Wait for a spawn observation or terminal state; no sleep-based start guess.
    pub async fn started(&mut self) -> Option<u32> {
        match self.stage.wait_for(|s| *s != Stage::Queued).await {
            Ok(state) => match *state {
                Stage::Running(pid) => Some(pid),
                _ => None,
            },
            Err(_) => None,
        }
    }

    pub fn cancel(&self) {
        self.cancel.send_replace(true);
    }

    pub async fn wait(mut self) -> Result<ToolResult, oneshot::error::RecvError> {
        (&mut self.result).await
    }
}

impl Drop for Ticket {
    fn drop(&mut self) {
        self.cancel.send_replace(true);
    }
}

#[derive(Clone)]
pub struct Client {
    registry: Arc<Registry>,
    tx: mpsc::Sender<Job>,
    admission: Arc<Semaphore>,
}

impl Client {
    /// No waiting sender task is created. Rejection is synchronous and bounded.
    /// Timeout is measured from admission, including queue residence.
    pub fn try_submit(
        &self,
        name: &str,
        input: Input,
        timeout: Duration,
    ) -> Result<Ticket, SubmitError> {
        if self.tx.is_closed() {
            return Err(SubmitError::Closed);
        }
        if timeout.is_zero() || timeout > Duration::from_secs(60) {
            return Err(SubmitError::InvalidInput);
        }
        let permit = self
            .admission
            .clone()
            .try_acquire_owned()
            .map_err(|_| SubmitError::Full)?;
        let (executable, args) = self.registry.resolve(name, &input)?;
        let accepted = Instant::now();
        let (cancel, cancelled) = watch::channel(false);
        let (result, rx) = oneshot::channel();
        let (stage, status) = watch::channel(Stage::Queued);
        let job = Job {
            executable,
            args,
            accepted,
            deadline: accepted + timeout,
            cancelled,
            result,
            stage,
            _admission: permit,
        };
        self.tx.try_send(job).map_err(|e| match e {
            mpsc::error::TrySendError::Full(_) => SubmitError::Full,
            mpsc::error::TrySendError::Closed(_) => SubmitError::Closed,
        })?;
        Ok(Ticket {
            result: rx,
            cancel,
            stage: status,
        })
    }
}

#[derive(Debug, Default)]
pub struct Shutdown {
    pub joined: usize,
    pub task_failures: Vec<String>,
}

pub struct Runtime {
    client: Client,
    stop: Option<oneshot::Sender<()>>,
    dispatcher: Option<JoinHandle<Shutdown>>,
}

impl Runtime {
    /// Must be called inside a live Tokio runtime with process/time drivers enabled.
    pub fn start(registry: Registry, config: Config) -> Result<Self, String> {
        if config.queue == 0
            || config.queue > 4096
            || config.concurrency == 0
            || config.concurrency > 128
            || config.retain > 1024 * 1024
            || config.drain_grace.is_zero()
            || config.drain_grace > Duration::from_secs(60)
        {
            return Err("configuration outside documented bounds".into());
        }
        let (tx, rx) = mpsc::channel(config.queue);
        let admission = Arc::new(Semaphore::new(config.queue + config.concurrency));
        let client = Client {
            registry: Arc::new(registry),
            tx,
            admission,
        };
        let (stop, stopping) = oneshot::channel();
        let dispatcher = tokio::spawn(dispatch(rx, stopping, config));
        Ok(Self {
            client,
            stop: Some(stop),
            dispatcher: Some(dispatcher),
        })
    }

    pub fn client(&self) -> Client {
        self.client.clone()
    }

    /// Close admission and drain all accepted jobs, including their cleanup.
    /// Existing Client clones become closed; they need not be dropped first.
    pub async fn shutdown(mut self) -> Result<Shutdown, tokio::task::JoinError> {
        if let Some(stop) = self.stop.take() {
            let _ = stop.send(());
        }
        self.dispatcher
            .take()
            .expect("dispatcher owned until shutdown")
            .await
    }
}

impl Drop for Runtime {
    fn drop(&mut self) {
        if let Some(stop) = self.stop.take() {
            let _ = stop.send(());
        }
        // Do not abort the dispatcher: it still owns cleanup responsibility.
        // Only explicit shutdown can observe its completion.
    }
}

async fn dispatch(
    mut rx: mpsc::Receiver<Job>,
    mut stop: oneshot::Receiver<()>,
    config: Config,
) -> Shutdown {
    let mut tasks = JoinSet::new();
    let mut report = Shutdown::default();
    let mut closing = false;
    let mut drained = false;
    loop {
        if drained && tasks.is_empty() {
            break;
        }
        tokio::select! {
            _ = &mut stop, if !closing => {
                closing = true;
                rx.close();
            }
            joined = tasks.join_next(), if !tasks.is_empty() => {
                report.joined += 1;
                if let Some(Err(error)) = joined {
                    report.task_failures.push(error.to_string());
                }
            }
            job = rx.recv(), if !drained && tasks.len() < config.concurrency => {
                match job {
                    Some(job) => { tasks.spawn(run(job, config.clone())); }
                    None => { drained = true; }
                }
            }
        }
    }
    report
}

async fn read_log<R: AsyncRead + Unpin>(
    reader: &mut R,
    log: &mut Log,
    buf: &mut [u8],
    retain: usize,
) {
    match reader.read(buf).await {
        Ok(0) => log.eof = true,
        Ok(n) => log.record(&buf[..n], retain),
        Err(e) => {
            log.error = Some(e.to_string());
        }
    }
}

fn finished(log: &Log) -> bool {
    log.eof || log.error.is_some()
}

async fn run(mut job: Job, config: Config) {
    let started = Instant::now();
    let mut result = ToolResult {
        outcome: Outcome::Success,
        pid: None,
        exit_code: None,
        reaped: false,
        stdout: Log::default(),
        stderr: Log::default(),
        queue_time: started - job.accepted,
        work_time: Duration::ZERO,
        cleanup_error: None,
    };
    if *job.cancelled.borrow() {
        result.outcome = Outcome::Cancelled;
    } else if started >= job.deadline {
        result.outcome = Outcome::TimedOut;
    } else {
        execute(&mut job, &config, &mut result).await;
    }
    result.work_time = started.elapsed();
    job.stage.send_replace(Stage::Finished);
    let _ = job.result.send(result);
    // job._admission is dropped only after actual work and result delivery.
}

async fn execute(job: &mut Job, config: &Config, result: &mut ToolResult) {
    let mut command = Command::new(&job.executable);
    command
        .args(&job.args)
        .env_clear()
        .current_dir("/")
        .stdin(Stdio::null())
        .kill_on_drop(true);
    let (mut child, mut stdout, mut stderr) = match spawn_captured(&mut command) {
        Ok(capture) => capture,
        Err(e) => {
            result.outcome = Outcome::SpawnFailed;
            result.cleanup_error = Some(e.to_string());
            return;
        }
    };
    result.pid = child.id();
    if let Some(pid) = result.pid {
        job.stage.send_replace(Stage::Running(pid));
    }
    let mut out_buf = [0u8; 8192];
    let mut err_buf = [0u8; 8192];
    let mut stopping = false;
    loop {
        tokio::select! {
            status = child.wait() => {
                match status {
                    Ok(status) => {
                        result.reaped = true;
                        job.stage.send_replace(Stage::Reaped);
                        result.exit_code = status.code();
                        if !stopping && !status.success() { result.outcome = Outcome::NonZero; }
                    }
                    Err(e) => {
                        result.outcome = Outcome::WaitFailed;
                        result.cleanup_error = Some(e.to_string());
                    }
                }
                break;
            }
            _ = job.cancelled.wait_for(|v| *v), if !stopping => {
                result.outcome = Outcome::Cancelled;
                stopping = true;
                if let Err(e) = child.start_kill() { result.cleanup_error = Some(e.to_string()); }
            }
            _ = sleep_until(job.deadline), if !stopping => {
                result.outcome = Outcome::TimedOut;
                stopping = true;
                if let Err(e) = child.start_kill() { result.cleanup_error = Some(e.to_string()); }
            }
            () = read_log(&mut stdout, &mut result.stdout, &mut out_buf, config.retain), if !finished(&result.stdout) => {}
            () = read_log(&mut stderr, &mut result.stderr, &mut err_buf, config.retain), if !finished(&result.stderr) => {}
        }
    }
    // Reaping is not EOF: a descendant could still hold a pipe writer.
    let drain_deadline = Instant::now() + config.drain_grace;
    while !finished(&result.stdout) || !finished(&result.stderr) {
        tokio::select! {
            _ = sleep_until(drain_deadline) => {
                if !finished(&result.stdout) { result.stdout.error = Some("drain deadline before EOF".into()); }
                if !finished(&result.stderr) { result.stderr.error = Some("drain deadline before EOF".into()); }
                break;
            }
            () = read_log(&mut stdout, &mut result.stdout, &mut out_buf, config.retain), if !finished(&result.stdout) => {}
            () = read_log(&mut stderr, &mut result.stderr, &mut err_buf, config.retain), if !finished(&result.stderr) => {}
        }
    }
}
