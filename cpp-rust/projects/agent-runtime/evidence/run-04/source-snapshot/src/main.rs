use agent_runtime::{Config, Input, Outcome, Registry, Runtime};
use std::time::Duration;

async fn run() -> Result<bool, Box<dyn std::error::Error>> {
    let args: Vec<String> = std::env::args().skip(1).collect();
    let (input, timeout, cancel_after) = match args.as_slice() {
        [mode, text] if mode == "echo" => (Input::Echo(text.clone()), 2000, None),
        [mode, bytes] if mode == "logs" => (Input::Logs { bytes: bytes.parse()? }, 2000, None),
        [mode, millis, timeout] if mode == "sleep" => (
            Input::Sleep { millis: millis.parse()? }, timeout.parse()?, None,
        ),
        [mode, millis, after] if mode == "cancel" => (
            Input::Sleep { millis: millis.parse()? }, 60_000, Some(after.parse::<u64>()?),
        ),
        [mode, code] if mode == "fail" => (Input::Fail { code: code.parse()? }, 2000, None),
        _ => return Err("usage: agent-runtime echo TEXT | logs BYTES | sleep MILLIS TIMEOUT_MS | cancel MILLIS AFTER_MS | fail CODE".into()),
    };
    // Fixed sibling path. No PATH search or request-controlled helper filename.
    let helper = std::env::current_exe()?.with_file_name("tool-helper");
    let mut registry = Registry::default();
    registry.helper("demo", helper)?;
    let runtime = Runtime::start(registry, Config::default())?;
    let submission = runtime
        .client()
        .try_submit("demo", input, Duration::from_millis(timeout));
    let ticket = match submission {
        Ok(ticket) => ticket,
        Err(error) => {
            runtime.shutdown().await?;
            return Err(format!("admission: {error:?}").into());
        }
    };
    if let Some(after) = cancel_after {
        tokio::time::sleep(Duration::from_millis(after)).await;
        ticket.cancel();
    }
    let response = ticket.wait().await;
    let report = runtime.shutdown().await?;
    let result = response?;
    println!(
        "outcome={:?} pid={:?} exit={:?} reaped={} queue_us={} work_us={}",
        result.outcome,
        result.pid,
        result.exit_code,
        result.reaped,
        result.queue_time.as_micros(),
        result.work_time.as_micros()
    );
    for (name, log) in [("stdout", &result.stdout), ("stderr", &result.stderr)] {
        println!(
            "{name}: total={} retained={} checksum={:016x} eof={} error={:?} prefix={:?}",
            log.total,
            log.prefix.len(),
            log.checksum,
            log.eof,
            log.error,
            String::from_utf8_lossy(&log.prefix)
        );
    }
    if let Some(error) = &result.cleanup_error {
        eprintln!("cleanup: {error}");
    }
    if !report.task_failures.is_empty() {
        return Err(format!("worker failures: {:?}", report.task_failures).into());
    }
    Ok(result.outcome == Outcome::Success
        && result.reaped
        && result.stdout.eof
        && result.stderr.eof
        && result.cleanup_error.is_none())
}

#[tokio::main(flavor = "multi_thread", worker_threads = 2)]
async fn main() -> std::process::ExitCode {
    match run().await {
        Ok(true) => std::process::ExitCode::SUCCESS,
        Ok(false) => std::process::ExitCode::from(1),
        Err(error) => {
            eprintln!("{error}");
            std::process::ExitCode::from(2)
        }
    }
}
