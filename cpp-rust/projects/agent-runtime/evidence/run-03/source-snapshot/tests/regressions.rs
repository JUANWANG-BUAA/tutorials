//! Safe negative control: reproduce pipe backpressure without leaving a child behind.
use std::process::Stdio;
use std::time::Duration;
use tokio::io::AsyncReadExt;

#[tokio::test]
async fn sequential_drain_regresses_then_explicitly_recovers() {
    let mut child = tokio::process::Command::new(env!("CARGO_BIN_EXE_tool-helper"))
        .args(["logs", "2097152"])
        .stdin(Stdio::null())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .kill_on_drop(true)
        .spawn()
        .expect("real helper");
    let mut stdout = child.stdout.take().expect("pipe");
    let stderr = child
        .stderr
        .take()
        .expect("pipe held open but deliberately not read");
    let mut output = Vec::new();
    let outcome =
        tokio::time::timeout(Duration::from_millis(200), stdout.read_to_end(&mut output)).await;
    assert!(outcome.is_err(), "negative control unexpectedly completed");
    child.kill().await.expect("kill and reap negative control");
    let status = child.wait().await.expect("observed reaped child");
    assert!(!status.success());
    drop(stderr);
    assert!(output.len() < 2 * 1024 * 1024);
}

#[test]
fn cli_reports_outcomes_and_exit_codes() {
    let cli = env!("CARGO_BIN_EXE_agent-runtime");
    for (args, expected, text) in [
        (vec!["echo", "literal ; $HOME"], 0, "outcome=Success"),
        (vec!["fail", "17"], 1, "outcome=NonZero"),
        (vec!["sleep", "5000", "100"], 1, "outcome=TimedOut"),
        (vec!["cancel", "5000", "100"], 1, "outcome=Cancelled"),
    ] {
        let output = std::process::Command::new(cli)
            .args(args)
            .output()
            .expect("CLI launched");
        assert_eq!(output.status.code(), Some(expected));
        let stdout = String::from_utf8(output.stdout).expect("CLI diagnostics utf8");
        assert!(stdout.contains(text), "{stdout}");
        assert!(stdout.contains("reaped=true"), "{stdout}");
    }
    let output = std::process::Command::new(cli)
        .arg("not-a-tool")
        .output()
        .expect("CLI usage");
    assert_eq!(output.status.code(), Some(2));
}
