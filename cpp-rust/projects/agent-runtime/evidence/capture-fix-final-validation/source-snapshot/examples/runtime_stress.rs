//! Parallel independent runtimes exercising the public named-tool API. Not timing.
use agent_runtime::{Config, Input, Log, Outcome, Registry, Runtime};
use std::time::Duration;

fn validate(log: &Log, byte: u8) {
    const BYTES: usize = 262_144;
    assert!(log.eof && log.error.is_none());
    assert_eq!(log.total, BYTES as u64);
    assert_eq!(log.prefix, vec![byte; 32]);
    let checksum = (0..BYTES).fold(0xcbf29ce484222325u64, |h, _| {
        (h ^ u64::from(byte)).wrapping_mul(0x100000001b3)
    });
    assert_eq!(log.checksum, checksum);
}

#[tokio::main(flavor = "multi_thread", worker_threads = 2)]
async fn main() {
    let helper = std::env::current_exe()
        .expect("executable")
        .parent()
        .expect("examples")
        .parent()
        .expect("profile")
        .join("tool-helper");
    let mut tasks = tokio::task::JoinSet::new();
    for id in 0..8 {
        let helper = helper.clone();
        tasks.spawn(async move {
            let mut registry = Registry::default();
            registry.helper("demo", helper).expect("register");
            let runtime = Runtime::start(
                registry,
                Config {
                    retain: 32,
                    ..Config::default()
                },
            )
            .expect("runtime");
            let client = runtime.client();
            let timeout = client
                .try_submit(
                    "demo",
                    Input::Sleep { millis: 5000 },
                    Duration::from_millis(200),
                )
                .expect("timeout accepted");
            let mut cancel = client
                .try_submit(
                    "demo",
                    Input::Sleep { millis: 5000 },
                    Duration::from_secs(5),
                )
                .expect("cancel accepted");
            assert!(cancel.started().await.is_some());
            cancel.cancel();
            let logs: Vec<_> = (0..8)
                .map(|_| {
                    client
                        .try_submit(
                            "demo",
                            Input::Logs { bytes: 262_144 },
                            Duration::from_secs(5),
                        )
                        .expect("logs accepted")
                })
                .collect();
            for (index, ticket) in [timeout, cancel].into_iter().chain(logs).enumerate() {
                let result = ticket.wait().await.expect("result");
                println!("runtime={id} index={index} {result:?}");
                assert!(result.reaped && result.cleanup_error.is_none());
                for log in [&result.stdout, &result.stderr] {
                    assert!(log.eof && log.error.is_none());
                }
                assert_eq!(
                    result.outcome,
                    match index {
                        0 => Outcome::TimedOut,
                        1 => Outcome::Cancelled,
                        _ => Outcome::Success,
                    }
                );
                if index >= 2 {
                    validate(&result.stdout, b'O');
                    validate(&result.stderr, b'E');
                }
            }
            let shutdown = runtime.shutdown().await.expect("join");
            assert_eq!(shutdown.joined, 10);
            assert!(shutdown.task_failures.is_empty());
        });
    }
    while let Some(joined) = tasks.join_next().await {
        joined.expect("stress runtime");
    }
    println!("reports=80 unexpected_failures=0");
}
