//! 有界准入：队列满时立刻返回 `AdmissionRejected`，不排队到无界、也不静默丢弃。

use std::sync::Arc;
use std::sync::atomic::{AtomicU64, Ordering};
use std::thread;
use std::time::{Duration, Instant};

use tidekv::testutil::TempDir;
use tidekv::{Config, Tide, TideError};

#[test]
fn full_queue_rejects_immediately() {
    let t = TempDir::new("admission");
    let cfg = Config {
        dir: t.path().to_path_buf(),
        memtable_flush_bytes: usize::MAX,
        admission_capacity: 8,
        ..Config::new(t.path())
    };
    let tide = Tide::open_engine(cfg).unwrap();

    // 一笔巨大的写：写线程要花时间把 32 MiB 灌进 WAL，这期间队列不再被消费。
    let huge = vec![7u8; 32 * 1024 * 1024];
    tide.put(b"huge", &huge).unwrap();
    drop(huge);
    std::thread::sleep(Duration::from_millis(5));

    let started = Instant::now();
    let mut rejected = 0usize;
    let mut accepted = 0usize;
    let mut first: Option<TideError> = None;
    for i in 0..256u32 {
        match tide.put(format!("k{i}").as_bytes(), b"v".as_slice()) {
            Ok(_) => accepted += 1,
            Err(e @ TideError::AdmissionRejected { .. }) => {
                rejected += 1;
                first.get_or_insert(e);
            }
            Err(e) => panic!("unexpected error: {e}"),
        }
    }
    let burst = started.elapsed();
    println!("admission: accepted={accepted} rejected={rejected} burst={burst:?}");
    assert!(rejected > 0, "容量 8 的队列在 256 连发下必然要拒绝");
    assert!(accepted > 0, "队列没满之前应当照常收单");
    let e = first.unwrap();
    match e {
        TideError::AdmissionRejected { capacity, queued } => {
            assert_eq!(capacity, 8);
            assert!(queued <= capacity, "队列长度不得超过容量: {queued}");
        }
        other => panic!("wrong variant {other:?}"),
    }
    // 拒绝必须是 O(1) 返回，而不是把调用方挂住等写线程。
    assert!(
        burst < Duration::from_millis(200),
        "准入拒绝阻塞了 {burst:?}"
    );
    let stats = tide.stats();
    assert_eq!(stats.admission_reject, rejected as u64);
    assert_eq!(
        stats.put,
        (accepted + rejected + 1) as u64,
        "被拒的写也要计数，否则看不出背压"
    );

    // 已接受的写一条都不能丢。
    tide.sync().unwrap();
    for i in 0..256u32 {
        let got = tide.get(format!("k{i}").as_bytes()).unwrap();
        if (i as usize) < accepted {
            assert_eq!(got, Some(b"v".to_vec()), "第 {i} 个被接受的写丢了");
        }
    }
    tide.close().unwrap();
}

#[test]
fn control_commands_also_bounded() {
    // 控制命令（flush/compact/sync）走同一条有界队列：写线程被一个大写占住的窗口里，
    // 16 个线程并发提 compact_two，容量 4 的队列必然把多出来的挡回去。
    let t = TempDir::new("admission-cmd");
    let cfg = Config {
        dir: t.path().to_path_buf(),
        memtable_flush_bytes: usize::MAX,
        admission_capacity: 4,
        ..Config::new(t.path())
    };
    let tide = Arc::new(Tide::open_engine(cfg).unwrap());
    let huge = Arc::new(vec![9u8; 128 * 1024 * 1024]);
    tide.put(b"huge", &huge).unwrap();
    std::thread::sleep(Duration::from_millis(3));

    let rej = Arc::new(AtomicU64::new(0));
    let ok = Arc::new(AtomicU64::new(0));
    let mut hs = Vec::new();
    for _ in 0..16 {
        let tide = tide.clone();
        let rej = rej.clone();
        let ok = ok.clone();
        hs.push(thread::spawn(move || {
            for _ in 0..3 {
                match tide.compact_two() {
                    Ok(_) => {
                        ok.fetch_add(1, Ordering::Relaxed);
                    }
                    Err(TideError::AdmissionRejected { capacity, queued }) => {
                        assert!(queued <= capacity, "队列长度越界: {queued}>{capacity}");
                        rej.fetch_add(1, Ordering::Relaxed);
                    }
                    Err(e) => panic!("{e}"),
                }
            }
        }));
    }
    drop(huge);
    for h in hs {
        h.join().unwrap();
    }
    let (rej_n, ok_n) = (rej.load(Ordering::Relaxed), ok.load(Ordering::Relaxed));
    println!("control commands: accepted={ok_n} rejected={rej_n}");
    assert!(rej_n > 0, "容量 4 的队列在 48 次并发提单下必须拒绝过");
    assert_eq!(rej_n + ok_n, 48);
    tide.close().unwrap();
}

#[test]
fn rejected_write_does_not_disturb_sequence() {
    let t = TempDir::new("admission-seq");
    let cfg = Config {
        dir: t.path().to_path_buf(),
        memtable_flush_bytes: usize::MAX,
        admission_capacity: 2,
        ..Config::new(t.path())
    };
    let tide = Tide::open_engine(cfg).unwrap();
    let huge = vec![1u8; 16 * 1024 * 1024];
    tide.put(b"huge", &huge).unwrap();
    drop(huge);
    std::thread::sleep(Duration::from_millis(5));
    let mut seqs = Vec::new();
    for i in 0..64u32 {
        if let Ok(s) = tide.put(format!("s{i}").as_bytes(), b"x".as_slice()) {
            seqs.push(s);
        }
    }
    tide.sync().unwrap();
    let mut sorted = seqs.clone();
    sorted.sort();
    sorted.dedup();
    assert_eq!(
        sorted.len(),
        seqs.len(),
        "序号必须唯一，被拒的请求也不能复用序号"
    );
    for s in &seqs {
        tide.await_seq(*s).unwrap();
    }
    assert_eq!(tide.get(b"s0").unwrap(), Some(b"x".to_vec()));
    tide.close().unwrap();
}
