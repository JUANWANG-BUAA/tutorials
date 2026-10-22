use agent_runtime::{Config, Input, Registry, Runtime};
use std::time::Duration;

#[tokio::main(flavor = "multi_thread", worker_threads = 2)]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let path = std::env::args_os()
        .nth(1)
        .ok_or("provide trusted absolute tool-helper path")?;
    let mut registry = Registry::default();
    registry.helper("inspect", path)?;
    let runtime = Runtime::start(registry, Config::default())?;
    let client = runtime.client();
    let submission = client.try_submit(
        "inspect",
        Input::Echo("agent request: literal arguments".into()),
        Duration::from_secs(2),
    );
    // Always join normal shutdown, including an admission error path.
    let response = match submission {
        Ok(ticket) => Some(ticket.wait().await),
        Err(error) => {
            eprintln!("rejected: {error:?}");
            None
        }
    };
    let shutdown = runtime.shutdown().await?;
    assert!(shutdown.task_failures.is_empty());
    if let Some(response) = response {
        let result = response?;
        println!("{result:?}");
        assert!(result.reaped);
    }
    Ok(())
}
