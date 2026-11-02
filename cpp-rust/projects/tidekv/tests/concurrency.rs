//! 多读者并发：写线程换版本、读者钉快照，最终值必须收敛且没有读到已释放内存。

use std::sync::Arc;
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::thread;

use tidekv::testutil::TempDir;
use tidekv::{Config, Tide};

#[test]
fn many_readers_agree_with_final_value() {
    let t = TempDir::new("conc-readers");
    let cfg = Config {
        dir: t.path().to_path_buf(),
        memtable_flush_bytes: 4096,
        admission_capacity: 4096,
        ..Config::new(t.path())
    };
    let tide = Arc::new(Tide::open_engine(cfg).unwrap());

    // 先写一批并 flush，让读路径落在段上。
    for i in 0..3_000u32 {
        tide.put(format!("k{i:05}").as_bytes(), format!("v{i}").as_bytes())
            .unwrap();
    }
    tide.sync().unwrap();
    tide.flush().unwrap().unwrap();

    let stop = Arc::new(AtomicBool::new(false));
    let ok = Arc::new(AtomicU64::new(0));
    let mut readers = Vec::new();
    for r in 0..8u64 {
        let tide = tide.clone();
        let stop = stop.clone();
        let ok = ok.clone();
        readers.push(thread::spawn(move || {
            let mut local = 0u64;
            let mut i = r;
            while !stop.load(Ordering::Relaxed) {
                i = (i + 1) % 3_000;
                let k = format!("k{i:05}");
                if let Some(v) = tide.get(k.as_bytes()).unwrap() {
                    // 写线程可能已经把它换成了 r{round}v{i}，两种都是合法终值之一。
                    assert!(
                        v.ends_with(format!("v{i}").as_bytes()),
                        "并发读到非法值 {v:?} for k{i:05}"
                    );
                    local += 1;
                }
                if i % 500 == r {
                    // 读者也要能拿到自己的快照并立刻释放。
                    let snap = tide.snapshot().unwrap();
                    let _ = snap.get(k.as_bytes());
                    snap.release();
                }
            }
            ok.fetch_add(local, Ordering::Relaxed);
        }));
    }

    // 一边读一边覆盖写，制造段/ memtable 的版本更替。
    for round in 0..6u32 {
        for i in 0..500u32 {
            let k = format!("k{i:05}");
            tide.put(k.as_bytes(), format!("r{round}v{i}").as_bytes())
                .unwrap();
        }
        tide.sync().unwrap();
        tide.flush().unwrap();
        thread::yield_now();
    }

    // 最后一轮写完之后，所有读者必须收敛到同一份终值。
    let want: Vec<Vec<u8>> = (0..500u32)
        .map(|i| format!("r5v{i}").into_bytes())
        .collect();
    stop.store(true, Ordering::Relaxed);
    for h in readers {
        h.join().unwrap();
    }
    assert!(ok.load(Ordering::Relaxed) > 0);
    for (i, w) in want.iter().enumerate() {
        assert_eq!(
            tide.get(format!("k{i:05}").as_bytes()).unwrap().as_deref(),
            Some(w.as_slice()),
            "键 k{i:05} 终值不对"
        );
    }
    for i in 500..3_000u32 {
        assert_eq!(
            tide.get(format!("k{i:05}").as_bytes()).unwrap(),
            Some(format!("v{i}").into_bytes()),
            "未被覆盖的键 k{i:05} 应保留首值"
        );
    }
    let stats = tide.stats();
    assert!(stats.get >= 1_000, "读者计数 {stats:?}");
    tide.close().unwrap();
}

#[test]
fn concurrent_writers_are_serialized_correctly() {
    let t = TempDir::new("conc-writers");
    let cfg = Config {
        dir: t.path().to_path_buf(),
        memtable_flush_bytes: 2048,
        admission_capacity: 8192,
        ..Config::new(t.path())
    };
    let tide = Arc::new(Tide::open_engine(cfg).unwrap());
    let mut hs = Vec::new();
    for w in 0..4u32 {
        let tide = tide.clone();
        hs.push(thread::spawn(move || {
            let mut retries = 0u32;
            for i in 0..2_000u32 {
                let k = format!("w{w}-k{i:04}");
                let v = format!("{w}-{i}");
                // 准入队列有界，写线程落后时提交会被拒；正确用法是退避后重试。
                loop {
                    match tide.put(k.as_bytes(), v.as_bytes()) {
                        Ok(_) => break,
                        Err(tidekv::TideError::AdmissionRejected { .. }) => {
                            retries += 1;
                            thread::yield_now();
                        }
                        Err(e) => panic!("{e}"),
                    }
                }
            }
            tide.sync().unwrap();
            retries
        }));
    }
    let retries: u32 = hs.into_iter().map(|h| h.join().unwrap()).sum();
    println!("concurrent writers: {retries} admission rejections retried");
    tide.sync().unwrap();
    let all = tide.scan_prefix(b"").unwrap();
    assert_eq!(all.len(), 8_000);
    for w in 0..4u32 {
        for i in 0..2_000u32 {
            assert_eq!(
                tide.get(format!("w{w}-k{i:04}").as_bytes())
                    .unwrap()
                    .as_deref(),
                Some(format!("{w}-{i}").as_bytes()),
                "并发写后 {w}/{i} 值不对"
            );
        }
    }
    assert!(tide.stats().put >= 8_000);
    tide.close().unwrap();
}
