//! A fully atomic, intentionally incorrect publication order. No data race / UB.
//! The barriers force a bad schedule; this is not evidence of CPU reordering.
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::sync::Barrier;

fn main() {
    let ready = AtomicBool::new(false);
    let payload = AtomicU64::new(0);
    let published = Barrier::new(2);
    let observed = Barrier::new(2);
    std::thread::scope(|s| {
        s.spawn(|| {
            // BUG: Release only publishes operations BEFORE this store.
            ready.store(true, Ordering::Release);
            published.wait();
            observed.wait();
            payload.store(42, Ordering::Relaxed);
        });
        published.wait();
        assert!(ready.load(Ordering::Acquire));
        let value = payload.load(Ordering::Relaxed);
        println!("ready=true payload={value}: wrong program order, not a hardware-reordering test");
        assert_eq!(value, 0);
        observed.wait();
    });
    assert_eq!(payload.load(Ordering::Relaxed), 42);
}
