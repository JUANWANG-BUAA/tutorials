//! 子进程压缩：正常路径、退出码非零带 stderr、大输出不把管道堵死。

use std::path::PathBuf;

use tidekv::ipc::{self, CompactJob};
use tidekv::segment::{self, segment_name};
use tidekv::testutil::TempDir;
use tidekv::{Entry, EntryKind};

fn write_seg(dir: &std::path::Path, id: u64, from: usize, to: usize) -> PathBuf {
    let data: Vec<(Vec<u8>, Entry)> = (from..to)
        .map(|i| {
            (
                format!("k{i:06}").into_bytes(),
                Entry::new(
                    i as u64 + 1,
                    if i % 11 == 0 {
                        EntryKind::Delete
                    } else {
                        EntryKind::Put(vec![b'v'; 40])
                    },
                ),
            )
        })
        .collect();
    let refs: Vec<(&[u8], &Entry)> = data.iter().map(|(k, e)| (k.as_slice(), e)).collect();
    let p = dir.join(segment_name(id));
    segment::write_segment(&p, id, &refs, 8).unwrap();
    p
}

#[test]
fn compactor_merges_two_segments() {
    let t = TempDir::new("ipc-merge");
    let a = write_seg(t.path(), 1, 0, 5_000);
    let b = write_seg(t.path(), 2, 2_500, 7_500);
    let out = t.path().join(segment_name(3));
    let job = CompactJob {
        out: out.clone(),
        inputs: vec![a, b],
        drop_tombstones: true,
        bytes_per_key: 8,
    };
    let res = ipc::spawn_compactor(&job).expect("compaction ok");
    assert!(out.exists());
    assert_eq!(res.out, out);
    let seg = segment::Segment::open(&out).unwrap();
    assert_eq!(seg.info().entries as u64, res.entries);
    assert_eq!(res.entries as usize, seg.dump().len());
    // 键空间 0..7500，其中 Winning 条目里墓碑被丢弃，所以剩下的是「非墓碑并集」。
    assert!(res.entries > 5_000 && res.entries < 7_500, "res={res:?}");
    let dump = seg.dump();
    assert!(dump.iter().all(|(_, e)| !e.is_tombstone()));
    assert!(res.dropped_tombstones > 0);
    println!(
        "merge 5000+5000 keys overlapping 2500 -> entries={} dropped_tombstones={}",
        res.entries, res.dropped_tombstones
    );
}

#[test]
fn compactor_keeps_tombstones_when_asked() {
    let t = TempDir::new("ipc-keep");
    let a = write_seg(t.path(), 1, 0, 800);
    let out = t.path().join(segment_name(2));
    let job = CompactJob {
        out: out.clone(),
        inputs: vec![a],
        drop_tombstones: false,
        bytes_per_key: 8,
    };
    let res = ipc::spawn_compactor(&job).unwrap();
    let seg = segment::Segment::open(&res.out).unwrap();
    let with_tomb = seg.dump().iter().filter(|(_, e)| e.is_tombstone()).count();
    assert!(with_tomb > 0);
    assert_eq!(res.dropped_tombstones, 0);
}

#[test]
fn nonzero_exit_reports_stderr() {
    let t = TempDir::new("ipc-fail");
    let missing = t.path().join(segment_name(42));
    let out = t.path().join(segment_name(99));
    let job = CompactJob {
        out,
        inputs: vec![missing],
        drop_tombstones: true,
        bytes_per_key: 8,
    };
    let e = ipc::spawn_compactor(&job).expect_err("must fail on a missing input");
    assert_ne!(e.code, 0, "退出码非零才能被判定为失败");
    assert!(
        e.message.contains("tide-compactor"),
        "stderr 内容要带回来: {:?}",
        e.message
    );
}

#[test]
fn huge_stderr_does_not_deadlock() {
    // 3000 个不存在的输入：子进程每个都往 stderr 写一行，总量远超 64 KB 管道缓冲。
    // 父进程如果不独立排空 stderr，就会卡在 wait() 上。
    let t = TempDir::new("ipc-stderr");
    let inputs: Vec<PathBuf> = (0..3_000u32)
        .map(|i| t.path().join(segment_name(i as u64)))
        .collect();
    let job = CompactJob {
        out: t.path().join(segment_name(999)),
        inputs,
        drop_tombstones: true,
        bytes_per_key: 8,
    };
    let started = std::time::Instant::now();
    let e = ipc::spawn_compactor(&job).expect_err("all inputs missing");
    let dt = started.elapsed();
    println!(
        "stderr bytes returned to parent: {} in {dt:?}",
        e.message.len()
    );
    assert!(e.message.len() > 64 * 1024, "必须取回被排空的完整 stderr");
    assert!(
        dt < std::time::Duration::from_secs(30),
        "疑似管道死锁: {dt:?}"
    );
}

#[test]
fn wide_output_is_drained_not_deadlocked() {
    // 两个大段合并后 stdout 只回一行，但 stderr 会被子进程写得很长；
    // 如果父进程不排空 stderr，子进程写满管道就会卡死。
    let t = TempDir::new("ipc-drain");
    let a = write_seg(t.path(), 1, 0, 40_000);
    let b = write_seg(t.path(), 2, 20_000, 60_000);
    let out = t.path().join(segment_name(3));
    let job = CompactJob {
        out: out.clone(),
        inputs: vec![a, b],
        drop_tombstones: true,
        bytes_per_key: 8,
    };
    let started = std::time::Instant::now();
    let res = ipc::spawn_compactor(&job).unwrap();
    assert!(res.entries > 0);
    println!("merged {} entries in {:?}", res.entries, started.elapsed());
    assert!(started.elapsed() < std::time::Duration::from_secs(60));
}
