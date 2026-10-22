//! Future construction/poll/cancellation probes with no OS I/O dependency.
use std::future::Future;
use std::hint::black_box;
use std::pin::pin;
use std::sync::{
    atomic::{AtomicUsize, Ordering},
    Arc,
};
use std::task::{Context, Poll, Waker};

struct Guard(Arc<AtomicUsize>);
impl Drop for Guard {
    fn drop(&mut self) {
        self.0.fetch_add(1, Ordering::Relaxed);
    }
}

async fn cancellation_probe(count: Arc<AtomicUsize>) {
    let _guard = Guard(count);
    std::future::pending::<()>().await;
}

async fn large_across_await() -> u8 {
    let bytes = black_box([7u8; 4096]);
    std::future::pending::<()>().await;
    black_box(bytes[0])
}

async fn large_before_await() -> u8 {
    let first = {
        let bytes = black_box([7u8; 4096]);
        black_box(bytes[0])
    };
    std::future::pending::<()>().await;
    first
}

fn main() {
    println!(
        "across_await size={} align={}",
        size_of_val(&large_across_await()),
        align_of_val(&large_across_await())
    );
    println!(
        "before_await size={} align={}",
        size_of_val(&large_before_await()),
        align_of_val(&large_before_await())
    );
    let dropped = Arc::new(AtomicUsize::new(0));
    drop(cancellation_probe(Arc::clone(&dropped)));
    assert_eq!(dropped.load(Ordering::Relaxed), 0); // body never executed
    {
        let mut future = pin!(cancellation_probe(Arc::clone(&dropped)));
        let mut cx = Context::from_waker(Waker::noop());
        assert!(matches!(future.as_mut().poll(&mut cx), Poll::Pending));
    }
    assert_eq!(dropped.load(Ordering::Relaxed), 1);
    println!("drop before first poll: 0 guards; drop after Pending: 1 guard");
}
