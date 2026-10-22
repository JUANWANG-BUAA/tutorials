use runtime_lab::wire::{Frame, FRAME_LEN};
use std::mem::{align_of, align_of_val, size_of, size_of_val};
fn main() {
    let yielding = tokio::task::yield_now();
    println!(
        "Frame size={} align={} wire={}",
        size_of::<Frame>(),
        align_of::<Frame>(),
        FRAME_LEN
    );
    println!(
        "yield_now size={} align={}",
        size_of_val(&yielding),
        align_of_val(&yielding)
    );
    println!(
        "JoinHandle<u64> size={} align={}",
        size_of::<tokio::task::JoinHandle<u64>>(),
        align_of::<tokio::task::JoinHandle<u64>>()
    );
    println!(
        "mpsc::Sender<u64> size={} align={}",
        size_of::<tokio::sync::mpsc::Sender<u64>>(),
        align_of::<tokio::sync::mpsc::Sender<u64>>()
    );
}
