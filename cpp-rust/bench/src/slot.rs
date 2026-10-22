//! Single-slot SPSC laboratory channel: nonblocking attempts, no disconnect protocol.
//! This is not a production channel and does not claim lock-free progress.
use std::cell::{Cell, UnsafeCell};
use std::marker::PhantomData;
use std::mem::MaybeUninit;
use std::sync::atomic::{AtomicBool, Ordering};

pub struct Slot<T> {
    full: AtomicBool,
    value: UnsafeCell<MaybeUninit<T>>,
}

// SAFETY: only split(&mut self) creates endpoints, exactly one of each.
// Each endpoint is !Sync and uses &mut self for attempts. Release/Acquire on
// `full` transfers exclusive payload access, in both directions. T: Send allows
// moving ownership across threads. T need not be Sync: simultaneous reads do not occur.
unsafe impl<T: Send> Sync for Slot<T> {}

pub struct Producer<'a, T> {
    slot: &'a Slot<T>,
    not_sync: PhantomData<Cell<()>>,
}

pub struct Consumer<'a, T> {
    slot: &'a Slot<T>,
    not_sync: PhantomData<Cell<()>>,
}

impl<T> Default for Slot<T> {
    fn default() -> Self {
        Self::new()
    }
}

impl<T> Slot<T> {
    pub const fn new() -> Self {
        Self {
            full: AtomicBool::new(false),
            value: UnsafeCell::new(MaybeUninit::uninit()),
        }
    }

    /// Both endpoint borrows must end before another split or drop is possible.
    pub fn split(&mut self) -> (Producer<'_, T>, Consumer<'_, T>) {
        (
            Producer {
                slot: self,
                not_sync: PhantomData,
            },
            Consumer {
                slot: self,
                not_sync: PhantomData,
            },
        )
    }
}

impl<T> Producer<'_, T> {
    pub fn try_send(&mut self, value: T) -> Result<(), T> {
        if self.slot.full.load(Ordering::Acquire) {
            return Err(value);
        }
        // SAFETY: false observed with Acquire means consumer's previous read has
        // finished (or this is the initial empty slot); only this producer writes.
        unsafe {
            (*self.slot.value.get()).write(value);
        }
        self.slot.full.store(true, Ordering::Release);
        Ok(())
    }
}

impl<T> Consumer<'_, T> {
    pub fn try_recv(&mut self) -> Option<T> {
        if !self.slot.full.load(Ordering::Acquire) {
            return None;
        }
        // SAFETY: producer published an initialized T before the observed Release.
        // Producer cannot write again until this consumer publishes false.
        let value = unsafe { (*self.slot.value.get()).assume_init_read() };
        self.slot.full.store(false, Ordering::Release);
        Some(value)
    }
}

impl<T> Drop for Slot<T> {
    fn drop(&mut self) {
        if *self.full.get_mut() {
            // SAFETY: &mut self excludes all live endpoints. Full means exactly
            // one initialized T remains and has not been taken by consumer.
            unsafe {
                self.value.get_mut().assume_init_drop();
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::atomic::AtomicUsize;
    use std::sync::Arc;

    #[test]
    fn capacity_one_and_reuse() {
        let mut slot = Slot::new();
        let (mut tx, mut rx) = slot.split();
        assert_eq!(rx.try_recv(), None);
        assert_eq!(tx.try_send(3), Ok(()));
        assert_eq!(tx.try_send(5), Err(5));
        assert_eq!(rx.try_recv(), Some(3));
        assert_eq!(tx.try_send(5), Ok(()));
        assert_eq!(rx.try_recv(), Some(5));
    }

    #[test]
    fn non_copy_payload_crosses_threads() {
        let mut slot = Slot::new();
        let (mut tx, mut rx) = slot.split();
        std::thread::scope(|scope| {
            scope.spawn(move || {
                for i in 0..2000 {
                    let mut pending = format!("message-{i}");
                    loop {
                        match tx.try_send(pending) {
                            Ok(()) => break,
                            Err(v) => {
                                pending = v;
                                std::thread::yield_now();
                            }
                        }
                    }
                }
            });
            for i in 0..2000 {
                let value = loop {
                    if let Some(v) = rx.try_recv() {
                        break v;
                    }
                    std::thread::yield_now();
                };
                assert_eq!(value, format!("message-{i}"));
            }
        });
    }

    struct Tracked(Arc<AtomicUsize>);
    impl Drop for Tracked {
        fn drop(&mut self) {
            self.0.fetch_add(1, Ordering::Relaxed);
        }
    }

    #[test]
    fn unread_payload_is_dropped_once() {
        let count = Arc::new(AtomicUsize::new(0));
        {
            let mut slot = Slot::new();
            let (mut tx, _rx) = slot.split();
            assert!(tx.try_send(Tracked(Arc::clone(&count))).is_ok());
        }
        assert_eq!(count.load(Ordering::Relaxed), 1);
    }

    #[test]
    fn received_payload_is_not_dropped_again() {
        let count = Arc::new(AtomicUsize::new(0));
        {
            let mut slot = Slot::new();
            let (mut tx, mut rx) = slot.split();
            assert!(tx.try_send(Tracked(Arc::clone(&count))).is_ok());
            drop(rx.try_recv().expect("published payload"));
        }
        assert_eq!(count.load(Ordering::Relaxed), 1);
    }
}
