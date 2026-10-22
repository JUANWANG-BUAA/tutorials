use agent_runtime::{Config, Input, Outcome, Registry, Runtime, SubmitError};
use std::time::Duration;

fn registry() -> Registry {
    let mut registry = Registry::default();
    registry
        .helper("demo", env!("CARGO_BIN_EXE_tool-helper"))
        .expect("helper exists");
    registry
}

fn start(queue: usize, concurrency: usize, retain: usize) -> Runtime {
    Runtime::start(
        registry(),
        Config {
            queue,
            concurrency,
            retain,
            ..Config::default()
        },
    )
    .expect("valid configuration")
}

fn checksum(byte: u8, n: usize) -> u64 {
    (0..n).fold(0xcbf29ce484222325, |hash, _| {
        (hash ^ u64::from(byte)).wrapping_mul(0x100000001b3)
    })
}

#[tokio::test(flavor = "multi_thread", worker_threads = 2)]
async fn dual_stream_drain_discards_only_retention_not_work() {
    let runtime = start(4, 2, 73);
    let ticket = runtime
        .client()
        .try_submit(
            "demo",
            Input::Logs {
                bytes: 2 * 1024 * 1024,
            },
            Duration::from_secs(5),
        )
        .expect("accepted");
    let result = ticket.wait().await.expect("worker result");
    assert_eq!(result.outcome, Outcome::Success);
    assert!(result.reaped);
    for (log, byte) in [(&result.stdout, b'O'), (&result.stderr, b'E')] {
        assert!(log.eof);
        assert_eq!(log.total, 2 * 1024 * 1024);
        assert_eq!(log.prefix, vec![byte; 73]);
        assert_eq!(log.checksum, checksum(byte, 2 * 1024 * 1024));
        assert!(log.error.is_none());
    }
    assert_eq!(runtime.shutdown().await.expect("join").joined, 1);
}

#[tokio::test]
async fn echo_is_literal_even_with_shell_metacharacters() {
    let runtime = start(1, 1, 4096);
    let literal = "$(touch /not-created); | > & \" newline\n";
    let result = runtime
        .client()
        .try_submit("demo", Input::Echo(literal.into()), Duration::from_secs(2))
        .expect("accepted")
        .wait()
        .await
        .expect("result");
    assert_eq!(result.stdout.prefix, literal.as_bytes());
    assert_eq!(result.outcome, Outcome::Success);
    assert!(
        runtime
            .shutdown()
            .await
            .expect("join")
            .task_failures
            .is_empty()
    );
}

#[tokio::test]
async fn bounded_before_spawn_and_queued_cancel_never_spawns() {
    let runtime = start(1, 1, 32);
    let client = runtime.client();
    let mut first = client
        .try_submit(
            "demo",
            Input::Sleep { millis: 5000 },
            Duration::from_secs(6),
        )
        .expect("first");
    assert!(first.started().await.is_some());
    let second = client
        .try_submit(
            "demo",
            Input::Sleep { millis: 5000 },
            Duration::from_secs(6),
        )
        .expect("queued");
    assert!(matches!(
        client.try_submit("demo", Input::Fixed, Duration::from_secs(1)),
        Err(SubmitError::Full)
    ));
    assert!(matches!(
        client.try_submit(
            "demo",
            Input::Echo("overflow".into()),
            Duration::from_secs(1)
        ),
        Err(SubmitError::Full)
    ));
    second.cancel();
    first.cancel();
    let first = first.wait().await.expect("first result");
    let second = second.wait().await.expect("second result");
    assert_eq!(first.outcome, Outcome::Cancelled);
    assert!(first.reaped);
    assert_eq!(second.outcome, Outcome::Cancelled);
    assert_eq!(second.pid, None);
    let report = runtime.shutdown().await.expect("join");
    assert_eq!(report.joined, 2);
    assert!(report.task_failures.is_empty());
}

#[tokio::test]
async fn timeout_reaps_actual_child_and_closes_both_streams() {
    let runtime = start(2, 1, 256);
    let mut ticket = runtime
        .client()
        .try_submit(
            "demo",
            Input::Sleep { millis: 5000 },
            Duration::from_millis(200),
        )
        .expect("accepted");
    assert!(ticket.started().await.is_some());
    let result = ticket.wait().await.expect("result");
    assert_eq!(result.outcome, Outcome::TimedOut);
    assert!(result.reaped);
    assert!(result.stdout.eof && result.stderr.eof);
    assert!(result.cleanup_error.is_none());
    runtime.shutdown().await.expect("join");
}

#[tokio::test]
async fn queue_residence_consumes_request_deadline() {
    let runtime = start(1, 1, 0);
    let client = runtime.client();
    let mut first = client
        .try_submit(
            "demo",
            Input::Sleep { millis: 5000 },
            Duration::from_secs(6),
        )
        .expect("accepted");
    assert!(first.started().await.is_some());
    let queued = client
        .try_submit(
            "demo",
            Input::Echo("expired".into()),
            Duration::from_millis(20),
        )
        .expect("queued");
    tokio::time::sleep(Duration::from_millis(40)).await;
    first.cancel();
    assert!(first.wait().await.expect("first").reaped);
    let result = queued.wait().await.expect("expired");
    assert_eq!(result.outcome, Outcome::TimedOut);
    assert_eq!(result.pid, None);
    assert!(result.queue_time >= Duration::from_millis(20));
    runtime.shutdown().await.expect("join");
}

#[tokio::test]
async fn nonzero_is_not_a_join_failure() {
    let runtime = start(1, 1, 256);
    let result = runtime
        .client()
        .try_submit("demo", Input::Fail { code: 23 }, Duration::from_secs(2))
        .expect("accepted")
        .wait()
        .await
        .expect("result");
    assert_eq!(result.outcome, Outcome::NonZero);
    assert_eq!(result.exit_code, Some(23));
    assert!(result.reaped && result.stderr.eof);
    assert!(!result.stderr.prefix.is_empty());
    assert!(
        runtime
            .shutdown()
            .await
            .expect("join")
            .task_failures
            .is_empty()
    );
}

#[tokio::test]
async fn normal_shutdown_closes_clones_and_joins_accepted_work() {
    let runtime = start(4, 2, 16);
    let client = runtime.client();
    let tickets: Vec<_> = (0..4)
        .map(|_| {
            client
                .try_submit("demo", Input::Echo("ok".into()), Duration::from_secs(2))
                .expect("accepted")
        })
        .collect();
    let report = runtime.shutdown().await.expect("join");
    assert_eq!(report.joined, 4);
    assert!(report.task_failures.is_empty());
    for ticket in tickets {
        let result = ticket.wait().await.expect("retained result");
        assert_eq!(result.outcome, Outcome::Success);
        assert!(result.reaped);
    }
    assert!(matches!(
        client.try_submit("demo", Input::Fixed, Duration::from_secs(1)),
        Err(SubmitError::Closed)
    ));
}

#[tokio::test]
async fn dropped_ticket_still_has_joined_cleanup() {
    let runtime = start(1, 1, 16);
    let mut ticket = runtime
        .client()
        .try_submit(
            "demo",
            Input::Sleep { millis: 5000 },
            Duration::from_secs(6),
        )
        .expect("accepted");
    let pid = ticket.started().await.expect("spawned");
    drop(ticket);
    let report = runtime.shutdown().await.expect("join");
    assert_eq!(report.joined, 1);
    assert!(report.task_failures.is_empty());
    #[cfg(unix)]
    {
        let output = std::process::Command::new("/bin/ps")
            .args(["-p", &pid.to_string(), "-o", "pid="])
            .output()
            .expect("ps");
        assert!(output.stdout.is_empty(), "direct child still listed: {pid}");
    }
}

#[tokio::test]
async fn concurrency_slot_is_not_released_on_cancel_request() {
    let runtime = start(1, 1, 16);
    let client = runtime.client();
    let mut first = client
        .try_submit(
            "demo",
            Input::Sleep { millis: 5000 },
            Duration::from_secs(6),
        )
        .expect("accepted");
    assert!(first.started().await.is_some());
    let second = client
        .try_submit("demo", Input::Echo("after".into()), Duration::from_secs(2))
        .expect("queued");
    first.cancel();
    let result = first.wait().await.expect("cancelled result");
    assert!(result.reaped);
    let result = second.wait().await.expect("next result");
    assert_eq!(result.outcome, Outcome::Success);
    assert_eq!(runtime.shutdown().await.expect("join").joined, 2);
}

#[test]
fn registry_and_configuration_fail_closed() {
    let mut registry = registry();
    assert!(
        registry
            .helper("demo", env!("CARGO_BIN_EXE_tool-helper"))
            .is_err()
    );
    assert!(
        registry
            .helper("bad/name", env!("CARGO_BIN_EXE_tool-helper"))
            .is_err()
    );
    assert!(registry.helper("missing", "/not/a/tool").is_err());
    assert!(
        Runtime::start(
            registry,
            Config {
                concurrency: 0,
                ..Config::default()
            }
        )
        .is_err()
    );
}

#[tokio::test]
async fn input_budgets_reject_before_spawn() {
    let runtime = start(1, 1, 0);
    let client = runtime.client();
    for input in [
        Input::Echo("x".repeat(4097)),
        Input::Echo("\0".into()),
        Input::Logs {
            bytes: 16 * 1024 * 1024 + 1,
        },
        Input::Sleep { millis: 60_001 },
        Input::Fail { code: 0 },
        Input::Fixed,
    ] {
        assert!(matches!(
            client.try_submit("demo", input, Duration::from_secs(1)),
            Err(SubmitError::InvalidInput)
        ));
    }
    assert!(matches!(
        client.try_submit("unknown", Input::Fixed, Duration::from_secs(1)),
        Err(SubmitError::UnknownTool)
    ));
    assert!(matches!(
        client.try_submit("demo", Input::Fixed, Duration::ZERO),
        Err(SubmitError::InvalidInput)
    ));
    assert_eq!(runtime.shutdown().await.expect("join").joined, 0);
}

#[tokio::test]
async fn missing_executable_at_spawn_is_structured() {
    let path = std::env::temp_dir().join(format!("agent-runtime-missing-{}", std::process::id()));
    std::fs::copy(env!("CARGO_BIN_EXE_tool-helper"), &path).expect("copy helper");
    let mut registry = Registry::default();
    registry
        .fixed("fixed", &path, vec!["echo".into(), "trusted".into()])
        .expect("register");
    std::fs::remove_file(&path).expect("remove before spawn");
    let runtime = Runtime::start(registry, Config::default()).expect("runtime");
    let result = runtime
        .client()
        .try_submit("fixed", Input::Fixed, Duration::from_secs(2))
        .expect("accepted")
        .wait()
        .await
        .expect("result");
    assert_eq!(result.outcome, Outcome::SpawnFailed);
    assert_eq!(result.pid, None);
    assert!(!result.reaped);
    assert!(result.cleanup_error.is_some());
    runtime.shutdown().await.expect("join");
}

#[tokio::test]
async fn fixed_command_accepts_no_request_arguments() {
    let mut registry = Registry::default();
    registry
        .fixed(
            "fixed",
            env!("CARGO_BIN_EXE_tool-helper"),
            vec!["echo".into(), "fixed value".into()],
        )
        .expect("register");
    let runtime = Runtime::start(registry, Config::default()).expect("runtime");
    let client = runtime.client();
    assert!(matches!(
        client.try_submit(
            "fixed",
            Input::Echo("override".into()),
            Duration::from_secs(1)
        ),
        Err(SubmitError::InvalidInput)
    ));
    let result = client
        .try_submit("fixed", Input::Fixed, Duration::from_secs(2))
        .expect("accepted")
        .wait()
        .await
        .expect("result");
    assert_eq!(result.stdout.prefix, b"fixed value");
    assert!(result.reaped);
    runtime.shutdown().await.expect("join");
}

#[tokio::test]
async fn intended_standard_stream_inheritance_still_hits_drain_grace() {
    let pidfile = std::env::temp_dir().join(format!(
        "agent-runtime-inherit-{}-{}",
        std::process::id(),
        std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)
            .expect("clock")
            .as_nanos()
    ));
    let mut registry = Registry::default();
    registry
        .fixed(
            "inherit",
            env!("CARGO_BIN_EXE_tool-helper"),
            vec![
                "inherit".into(),
                pidfile.clone().into_os_string(),
                "2000".into(),
            ],
        )
        .expect("register trusted diagnostic command");
    let runtime = Runtime::start(
        registry,
        Config {
            drain_grace: Duration::from_millis(30),
            ..Config::default()
        },
    )
    .expect("runtime");
    let result = runtime
        .client()
        .try_submit("inherit", Input::Fixed, Duration::from_secs(5))
        .expect("accepted")
        .wait()
        .await
        .expect("result");
    assert_eq!(result.outcome, Outcome::Success);
    assert!(result.reaped);
    for log in [&result.stdout, &result.stderr] {
        assert!(!log.eof, "normal fd 1/2 inheritance must not be suppressed");
        assert_eq!(log.error.as_deref(), Some("drain deadline before EOF"));
    }
    assert_eq!(runtime.shutdown().await.expect("join").joined, 1);
    // Let the deliberately detached fixture finish; this is not a reap claim.
    tokio::time::timeout(Duration::from_secs(5), async {
        while !pidfile.exists() {
            tokio::time::sleep(Duration::from_millis(1)).await;
        }
        while pidfile.exists() {
            tokio::time::sleep(Duration::from_millis(1)).await;
        }
    })
    .await
    .expect("diagnostic descendant finished its bounded hold");
}
