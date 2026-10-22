//! Two benchmark entries. Raw batch observations go to stdout; no profiler attached there.
use agent_runtime::{Config, Input, Log, Outcome, Registry, Runtime, SubmitError, ToolResult};
use std::hint::black_box;
use std::time::{Duration, Instant};

const REJECTS: usize = 100_000;
const TOOLS: usize = 8;
const BYTES: usize = 262_144;

fn runtime(concurrency: usize, retain: usize) -> Runtime {
    let mut registry = Registry::default();
    registry
        .helper(
            "demo",
            std::env::current_exe()
                .expect("current executable")
                .with_file_name("tool-helper"),
        )
        .expect("helper present");
    Runtime::start(
        registry,
        Config {
            queue: 16,
            concurrency,
            retain,
            ..Config::default()
        },
    )
    .expect("configuration")
}

fn rejected_batch(client: &agent_runtime::Client) -> (u128, usize) {
    let begin = Instant::now();
    let mut rejected = 0;
    for _ in 0..REJECTS {
        let result = client.try_submit("demo", Input::Echo(String::new()), Duration::from_secs(1));
        if matches!(black_box(result), Err(SubmitError::Full)) {
            rejected += 1;
        }
    }
    (begin.elapsed().as_nanos(), rejected)
}

async fn admission() {
    let mut registry = Registry::default();
    registry
        .helper(
            "demo",
            std::env::current_exe()
                .expect("exe")
                .with_file_name("tool-helper"),
        )
        .expect("helper");
    let runtime = Runtime::start(
        registry,
        Config {
            queue: 1,
            concurrency: 1,
            ..Config::default()
        },
    )
    .expect("runtime");
    let client = runtime.client();
    let mut active = client
        .try_submit(
            "demo",
            Input::Sleep { millis: 60_000 },
            Duration::from_secs(60),
        )
        .expect("active");
    assert!(active.started().await.is_some());
    let queued = client
        .try_submit(
            "demo",
            Input::Sleep { millis: 60_000 },
            Duration::from_secs(60),
        )
        .expect("queue");
    let warm = Instant::now();
    while warm.elapsed() < Duration::from_millis(500) {
        assert_eq!(rejected_batch(&client).1, REJECTS);
    }
    println!("case,index,batch_ns,operations,checksum");
    for index in 0..21 {
        let (elapsed, rejected) = rejected_batch(&client);
        assert_eq!(rejected, REJECTS);
        println!("admission-full,{index},{elapsed},{REJECTS},{rejected}");
    }
    queued.cancel();
    active.cancel();
    assert!(active.wait().await.expect("active cleanup").reaped);
    assert_eq!(queued.wait().await.expect("queued result").pid, None);
    assert!(
        runtime
            .shutdown()
            .await
            .expect("join")
            .task_failures
            .is_empty()
    );
}

async fn lifecycle_batch(runtime: &Runtime) -> (u128, Vec<ToolResult>) {
    let client = runtime.client();
    let start = Instant::now();
    let tickets: Vec<_> = (0..TOOLS)
        .map(|_| {
            client
                .try_submit("demo", Input::Logs { bytes: BYTES }, Duration::from_secs(5))
                .expect("bounded admission")
        })
        .collect();
    let mut results = Vec::with_capacity(TOOLS);
    for ticket in tickets {
        results.push(ticket.wait().await.expect("result"));
    }
    (start.elapsed().as_nanos(), results)
}

fn validate(results: &[ToolResult], expected: &[u64; 2], retain: usize) -> u64 {
    assert_eq!(results.len(), TOOLS);
    let mut checksum = 0u64;
    for result in results {
        assert_eq!(result.outcome, Outcome::Success);
        assert!(result.reaped);
        assert!(result.cleanup_error.is_none());
        for (i, log) in [&result.stdout, &result.stderr].iter().enumerate() {
            assert!(log.eof && log.error.is_none());
            assert_eq!(log.total, BYTES as u64);
            assert_eq!(log.prefix.len(), retain.min(BYTES));
            assert_eq!(log.checksum, expected[i]);
            checksum = checksum.wrapping_add(log.checksum);
        }
    }
    black_box(checksum)
}

async fn lifecycle(profile_seconds: Option<u64>) {
    let expected = (*b"OE").map(|b| {
        let mut log = Log::default();
        log.record(&vec![b; BYTES], 0);
        log.checksum
    });
    let cases = [
        ("logs-c1-r0", 1, 0),
        ("logs-c1-r4096", 1, 4096),
        ("logs-c4-r4096", 4, 4096),
    ];
    let runtimes: Vec<_> = cases.iter().map(|(_, c, r)| runtime(*c, *r)).collect();
    let warm_duration = Duration::from_millis(if profile_seconds.is_some() { 10 } else { 500 });
    for (i, runtime) in runtimes.iter().enumerate() {
        let warm = Instant::now();
        while warm.elapsed() < warm_duration {
            let (_, results) = lifecycle_batch(runtime).await;
            validate(&results, &expected, cases[i].2);
        }
    }
    if let Some(seconds) = profile_seconds {
        let start = Instant::now();
        let mut count = 0;
        while start.elapsed() < Duration::from_secs(seconds) {
            let i = cases.len() - 1;
            let (_, results) = lifecycle_batch(&runtimes[i]).await;
            validate(&results, &expected, cases[i].2);
            count += TOOLS;
        }
        println!("profile_tools={count}");
    } else {
        println!("case,index,batch_ns,operations,checksum");
        for index in 0..21 {
            // Rotate first case, avoiding a fixed correlation with drift.
            for offset in 0..cases.len() {
                let i = (index + offset) % cases.len();
                let (elapsed, results) = lifecycle_batch(&runtimes[i]).await;
                let checksum = validate(&results, &expected, cases[i].2);
                println!("{},{index},{elapsed},{TOOLS},{checksum}", cases[i].0);
            }
        }
    }
    for runtime in runtimes {
        assert!(
            runtime
                .shutdown()
                .await
                .expect("join")
                .task_failures
                .is_empty()
        );
    }
}

#[tokio::main(flavor = "multi_thread", worker_threads = 2)]
async fn main() {
    match std::env::args().nth(1).as_deref() {
        Some("admission") => admission().await,
        Some("lifecycle") => lifecycle(None).await,
        Some("profile") => lifecycle(Some(8)).await,
        _ => {
            eprintln!("usage: runtime-bench admission | lifecycle | profile");
            std::process::exit(2);
        }
    }
}
