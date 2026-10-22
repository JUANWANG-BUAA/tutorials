use agent_runtime::{Client, Config, Input, Log, Outcome, Stage, SubmitError, Ticket, ToolResult};
use std::mem::{align_of, size_of};

fn show<T>(name: &str) {
    println!("{name},{},{}", size_of::<T>(), align_of::<T>());
}

fn main() {
    println!("type,size,align");
    show::<Input>("Input");
    show::<Config>("Config");
    show::<Log>("Log");
    show::<ToolResult>("ToolResult");
    show::<Client>("Client");
    show::<Ticket>("Ticket");
    show::<Outcome>("Outcome");
    show::<SubmitError>("SubmitError");
    show::<Stage>("Stage");
    show::<tokio::sync::OwnedSemaphorePermit>("OwnedSemaphorePermit");
}
