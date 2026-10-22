fn main() {
    const COUNT: usize = 8192;
    systems_lab::measure(&["short_pin", "stalled_pin"], COUNT, |case| {
        systems_lab::epoch_batch(case == 1, COUNT)
    });
    let collector = crossbeam_epoch::Collector::new();
    let holder = collector.register();
    let worker = collector.register();
    let dropped = std::sync::Arc::new(std::sync::atomic::AtomicUsize::new(0));
    let guard = holder.pin();
    for batch in 1..=4 {
        systems_lab::retire(&worker, &dropped, 1024);
        println!(
            "retention,batch={batch},retired={},dropped={},payload_bytes={}",
            batch * 1024,
            dropped.load(std::sync::atomic::Ordering::Relaxed),
            batch * 1024 * 256
        );
    }
    drop(guard);
    systems_lab::drain(&worker, &dropped, 4096);
    println!(
        "retention,after_unpin,dropped={}",
        dropped.load(std::sync::atomic::Ordering::Relaxed)
    );
}
