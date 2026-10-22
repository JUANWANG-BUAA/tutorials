//! Version-pinned teaching components, not a sandbox or a production runtime.
pub mod process;
pub mod wire;

use std::io;
use tokio::runtime::{Builder, Runtime};

pub fn current_runtime() -> io::Result<Runtime> {
    Builder::new_current_thread().enable_all().build()
}

pub fn multi_runtime(workers: usize) -> io::Result<Runtime> {
    Builder::new_multi_thread()
        .worker_threads(workers)
        .enable_all()
        .build()
}
