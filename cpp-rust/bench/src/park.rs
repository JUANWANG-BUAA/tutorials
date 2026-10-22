//! A single-future parking driver. Not an I/O reactor or a multi-task executor.
use std::cell::Cell;
use std::future::Future;
use std::pin::pin;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;
use std::task::{Context, Poll, Wake, Waker};
use std::thread::{self, Thread};

struct Notify {
    thread: Thread,
    notified: AtomicBool,
}
impl Notify {
    fn notify(&self) {
        self.notified.store(true, Ordering::Release);
        self.thread.unpark();
    }
}
impl Wake for Notify {
    fn wake(self: Arc<Self>) {
        self.notify();
    }
    fn wake_by_ref(self: &Arc<Self>) {
        self.notify();
    }
}

thread_local! { static ENTERED: Cell<bool> = const { Cell::new(false) }; }
struct EnterGuard;
impl Drop for EnterGuard {
    fn drop(&mut self) {
        ENTERED.with(|entered| entered.set(false));
    }
}

/// Poll one future until ready. The future must arrange a wake after Pending.
/// Spurious returns from park are allowed; every wake is a request to recheck.
pub fn block_on<F: Future>(future: F) -> F::Output {
    ENTERED.with(|entered| assert!(!entered.replace(true), "nested block_on is unsupported"));
    let _entered = EnterGuard;
    let notify = Arc::new(Notify {
        thread: thread::current(),
        notified: AtomicBool::new(false),
    });
    let waker = Waker::from(Arc::clone(&notify));
    let mut context = Context::from_waker(&waker);
    let mut future = pin!(future);
    loop {
        match future.as_mut().poll(&mut context) {
            Poll::Ready(value) => return value,
            Poll::Pending => {
                while !notify.notified.swap(false, Ordering::Acquire) {
                    thread::park();
                }
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::pin::Pin;
    use std::sync::Mutex;

    struct WakeBeforePending(bool);
    impl Future for WakeBeforePending {
        type Output = u64;
        fn poll(mut self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<u64> {
            if self.0 {
                Poll::Ready(42)
            } else {
                self.0 = true;
                cx.waker().wake_by_ref();
                Poll::Pending
            }
        }
    }

    #[test]
    fn pre_park_notification_is_not_lost() {
        assert_eq!(block_on(WakeBeforePending(false)), 42);
    }

    #[test]
    fn notification_survives_a_consumed_park_token() {
        struct ConsumeToken(bool);
        impl Future for ConsumeToken {
            type Output = ();
            fn poll(mut self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<()> {
                if self.0 {
                    return Poll::Ready(());
                }
                self.0 = true;
                cx.waker().wake_by_ref();
                thread::park(); // consume the unpark token before returning Pending
                Poll::Pending
            }
        }
        block_on(ConsumeToken(false));
    }

    #[test]
    fn nested_call_is_rejected_and_guard_recovers() {
        assert!(std::panic::catch_unwind(|| block_on(async { block_on(async {}) })).is_err());
        assert_eq!(block_on(async { 9 }), 9);
    }

    #[derive(Default)]
    struct Shared {
        ready: bool,
        waker: Option<Waker>,
    }
    struct Completion(Arc<Mutex<Shared>>);
    impl Future for Completion {
        type Output = ();
        fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<()> {
            let mut state = self.0.lock().expect("completion mutex poisoned");
            if state.ready {
                Poll::Ready(())
            } else {
                // Predicate and registration protected by the same lock.
                state.waker = Some(cx.waker().clone());
                Poll::Pending
            }
        }
    }

    #[test]
    fn another_thread_can_complete_future() {
        for _ in 0..50 {
            let state = Arc::new(Mutex::new(Shared::default()));
            let producer_state = Arc::clone(&state);
            let producer = thread::spawn(move || {
                let waker = {
                    let mut s = producer_state.lock().expect("completion mutex poisoned");
                    s.ready = true;
                    s.waker.take()
                };
                if let Some(w) = waker {
                    w.wake();
                }
            });
            block_on(Completion(state));
            producer.join().expect("completion producer panicked");
        }
    }
}
