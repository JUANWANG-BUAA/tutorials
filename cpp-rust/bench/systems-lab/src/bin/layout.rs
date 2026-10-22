use std::mem::{align_of, size_of};
fn show<T>(name: &str) {
    println!("{name},size={},align={}", size_of::<T>(), align_of::<T>());
}
fn main() {
    show::<crossbeam_queue::ArrayQueue<u64>>("ArrayQueue<u64>");
    show::<crossbeam_epoch::Guard>("Guard");
    show::<crossbeam_epoch::Collector>("Collector");
    show::<std::sync::Arc<[u8]>>("Arc<[u8]>");
    show::<&[u8]>("&[u8]");
    show::<Vec<u8>>("Vec<u8>");
    show::<std::sync::atomic::AtomicPtr<u64>>("AtomicPtr<u64>");
}
