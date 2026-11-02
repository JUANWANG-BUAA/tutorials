//! epoch 回收：读者持快照期间绝不释放，`release()` 之后才回收。

use std::sync::Arc;
use std::sync::atomic::{AtomicBool, AtomicUsize, Ordering};
use std::thread;

use tidekv::epoch::Heap;

/// 被释放时会把 `flag` 置位，测试据此观察「回收到底发生没有」。
struct Node {
    v: u64,
    flag: Arc<AtomicBool>,
}

impl Drop for Node {
    fn drop(&mut self) {
        self.flag.store(true, Ordering::SeqCst);
    }
}

fn node(v: u64) -> (Node, Arc<AtomicBool>) {
    let flag = Arc::new(AtomicBool::new(false));
    (
        Node {
            v,
            flag: flag.clone(),
        },
        flag,
    )
}

#[test]
fn retired_version_survives_until_reader_releases() {
    let (n0, f0) = node(0);
    let heap: Heap<Node> = Heap::new("t", Box::new(n0));
    assert_eq!(heap.retired_len(), 0);

    // 读者先钉住。
    let guard = heap.pin().expect("pin");
    assert_eq!(guard.load().v, 0);

    // 写者换版本：旧版本进队列，但读者还钉在旧纪元。
    let (n1, f1) = node(1);
    heap.publish(Box::new(n1));
    assert_eq!(guard.load().v, 0, "已钉住的读者仍应看到旧版本");

    let reclaimed = heap.advance();
    assert_eq!(reclaimed, 0, "读者没松手就不该回收");
    assert!(!f0.load(Ordering::SeqCst), "旧版本被提前释放");
    assert_eq!(heap.retired_len(), 1);

    // 新读者看到的是新版本。
    {
        let g2 = heap.pin().unwrap();
        assert_eq!(g2.load().v, 1);
    }

    guard.release();
    let reclaimed = heap.advance();
    assert_eq!(reclaimed, 1, "松手后一次 advance 就该回收");
    assert!(f0.load(Ordering::SeqCst), "旧版本应已被 drop");
    assert_eq!(heap.retired_len(), 0);
    assert_eq!(heap.reclaimed(), 1);
    assert!(!f1.load(Ordering::SeqCst), "当前版本绝不能被释放");
}
#[test]
fn another_threads_pin_blocks_reclaim() {
    // 契约是「谁在 retire 之前钉住，谁就挡住回收」：读者线程先 pin，
    // 之后写者换的两个版本都不能被释放，直到读者退出。
    let (n0, f0) = node(0);
    let heap = Arc::new(Heap::<Node>::new("t2", Box::new(n0)));

    let pinned = Arc::new(AtomicBool::new(false));
    let go = Arc::new(AtomicBool::new(false));
    let (h, g, heap2) = (pinned.clone(), go.clone(), heap.clone());
    let reader = thread::spawn(move || {
        let guard = heap2.pin().unwrap();
        h.store(true, Ordering::SeqCst);
        while !g.load(Ordering::SeqCst) {
            thread::yield_now();
        }
        assert!(guard.load().v <= 2, "钉住的版本不该变成更新的版本");
        drop(guard);
    });

    while !pinned.load(Ordering::SeqCst) {
        thread::yield_now();
    }
    assert_eq!(heap.label(), "t2");
    let (n1, _) = node(1);
    heap.publish(Box::new(n1));
    let (n2, f2keep) = node(2);
    heap.publish(Box::new(n2));
    assert_eq!(heap.retired_len(), 2, "两次发布应各留下一个旧版本");
    for _ in 0..5 {
        assert_eq!(heap.advance(), 0, "读者还钉着，两个旧版本都不该被释放");
    }
    assert!(!f0.load(Ordering::SeqCst));

    go.store(true, Ordering::SeqCst);
    reader.join().unwrap();
    let freed = heap.advance();
    assert_eq!(freed, 2, "读者线程退出后两个旧版本都能回收");
    assert!(f0.load(Ordering::SeqCst));
    assert_eq!(heap.retired_len(), 0);
    assert!(!f2keep.load(Ordering::SeqCst), "当前版本绝不能被释放");
}

#[test]
fn cross_thread_readers_never_observe_a_freed_version() {
    let (n0, _) = node(7);
    let heap = Arc::new(Heap::new("t3", Box::new(n0)));
    let stop = Arc::new(AtomicBool::new(false));
    let reads = Arc::new(AtomicUsize::new(0));
    let mut hs = Vec::new();
    for _ in 0..4 {
        let heap = heap.clone();
        let stop = stop.clone();
        let reads = reads.clone();
        hs.push(thread::spawn(move || {
            while !stop.load(Ordering::Relaxed) {
                let g = heap.pin().unwrap();
                let v = g.load().v;
                assert!(v == 7 || v == 8, "读到不该存在的版本 {v}");
                reads.fetch_add(1, Ordering::Relaxed);
                heap.advance();
                g.release();
            }
        }));
    }
    for i in 0..400 {
        let (n, _) = node(if i % 2 == 0 { 8 } else { 7 });
        heap.publish(Box::new(n));
        heap.advance();
    }
    stop.store(true, Ordering::Relaxed);
    for h in hs {
        h.join().unwrap();
    }
    assert!(reads.load(Ordering::Relaxed) > 0);
    // 读者全部退出后，回收队列应该能被清空。
    for _ in 0..10 {
        if heap.retired_len() == 0 {
            break;
        }
        heap.advance();
    }
    assert_eq!(heap.retired_len(), 0);
    assert!(heap.reclaimed() >= 1, "总该回收过至少一个版本");
}
