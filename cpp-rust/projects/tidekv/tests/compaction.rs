//! `compact_two`：子进程压缩的语义等价性与真实落盘。

use std::collections::BTreeMap;

use tidekv::testutil;
use tidekv::testutil::TempDir;
use tidekv::{Config, Tide};

fn open(t: &TempDir) -> Tide {
    let cfg = Config {
        dir: t.path().to_path_buf(),
        memtable_flush_bytes: usize::MAX,
        admission_capacity: 4096,
        ..Config::new(t.path())
    };
    Tide::open_engine(cfg).unwrap()
}

/// 朴素模型：只保留存活键值，用来和压缩前后的引擎对照。
fn model_of(pairs: &[(Vec<u8>, Option<Vec<u8>>)]) -> BTreeMap<Vec<u8>, Vec<u8>> {
    let mut m = BTreeMap::new();
    for (k, v) in pairs {
        match v {
            Some(v) => {
                m.insert(k.clone(), v.clone());
            }
            None => {
                m.remove(k);
            }
        }
    }
    m
}

#[test]
fn compact_two_needs_two_segments() {
    let t = TempDir::new("compact-none");
    let tide = open(&t);
    assert!(tide.compact_two().unwrap().is_none(), "零段时无事可做");
    testutil::put(&tide, b"a", b"1");
    tide.flush().unwrap().unwrap();
    assert!(tide.compact_two().unwrap().is_none(), "一段时无事可做");
    tide.close().unwrap();
}

#[test]
fn compact_two_merges_and_keeps_semantics() {
    let t = TempDir::new("compact-basic");
    let tide = open(&t);
    let mut log: Vec<(Vec<u8>, Option<Vec<u8>>)> = Vec::new();
    for i in 0..120u32 {
        let k = format!("k{i:03}").into_bytes();
        let v = format!("v{i}").into_bytes();
        testutil::put(&tide, &k, &v);
        log.push((k, Some(v)));
    }
    tide.flush().unwrap().unwrap();
    for i in (0..120u32).step_by(3) {
        let k = format!("k{i:03}").into_bytes();
        testutil::delete(&tide, &k);
        log.push((k.clone(), None));
    }
    let v = b"updated".to_vec();
    testutil::put(&tide, b"k119", &v);
    log.push((b"k119".to_vec(), Some(v)));
    tide.flush().unwrap().unwrap();
    tide.sync().unwrap();
    let before = tide.scan_prefix(b"").unwrap();
    assert_eq!(tide.segments().len(), 2);

    let report = tide.compact_two().unwrap().expect("compaction happened");
    assert_eq!(report.inputs.len(), 2);
    assert_eq!(report.via, "tide-compactor");
    tide.sync().unwrap();
    let after = tide.scan_prefix(b"").unwrap();
    assert_eq!(before, after, "压缩前后必须逐键等值");
    assert_eq!(after, model_of(&log).into_iter().collect::<Vec<_>>());
    assert_eq!(tide.segments().len(), 1);
    // 两个旧段文件在回收后应该消失。
    for _ in 0..4 {
        tide.advance_epoch();
    }
    let left: Vec<_> = std::fs::read_dir(t.path())
        .unwrap()
        .filter_map(|e| e.ok())
        .map(|e| e.path())
        .filter(|p| p.extension().and_then(|s| s.to_str()) == Some("tide"))
        .collect();
    assert_eq!(left.len(), 1, "旧段文件应被回收删除，剩下 {left:?}");
    tide.close().unwrap();
}

#[test]
fn compact_two_equivalence_under_random_ops() {
    // 同一批随机 key：压缩前后用同一份读集合对照，并检查墓碑被安全丢弃。
    let t = TempDir::new("compact-rand");
    let tide = open(&t);
    let mut log: Vec<(Vec<u8>, Option<Vec<u8>>)> = Vec::new();
    let mut state = 0x1234_5678_9abc_def0u64;
    for round in 0..6 {
        for i in 0..150u64 {
            state ^= state << 13;
            state ^= state >> 7;
            state ^= state << 17;
            let key = format!("{:02}-k{:04}", (state >> 20) % 16, state % 900).into_bytes();
            let r = (state >> 33) % 10;
            if round > 2 && r < 3 {
                testutil::delete(&tide, &key);
                log.push((key, None));
            } else {
                let v = format!("r{round}i{i}").into_bytes();
                testutil::put(&tide, &key, &v);
                log.push((key, Some(v)));
            }
        }
        tide.sync().unwrap();
        tide.flush().unwrap();
    }
    let want = model_of(&log);
    assert!(tide.segments().len() >= 2);
    let before = tide.scan_prefix(b"").unwrap();
    assert_eq!(before, want.clone().into_iter().collect::<Vec<_>>());

    // 一路压到只剩一段。
    let mut guard = 0;
    while let Some(r) = tide.compact_two().unwrap() {
        assert!(r.output.bytes > 0, "输出段文件至少要有页脚");
        guard += 1;
        if guard > 32 {
            panic!("compaction did not converge");
        }
    }
    tide.sync().unwrap();
    assert_eq!(tide.segments().len(), 1);
    let after = tide.scan_prefix(b"").unwrap();
    assert_eq!(after, before, "多次合并后仍应等值");
    let stats = tide.stats();
    assert!(stats.compact >= 2);
    tide.close().unwrap();
}

#[test]
fn compacted_segment_survives_restart() {
    let t = TempDir::new("compact-restart");
    {
        let tide = open(&t);
        for i in 0..80u32 {
            testutil::put(
                &tide,
                format!("k{i:03}").as_bytes(),
                format!("v{i}").as_bytes(),
            );
        }
        tide.flush().unwrap().unwrap();
        for i in 0..80u32 {
            if i % 5 == 0 {
                testutil::delete(&tide, format!("k{i:03}").as_bytes());
            }
        }
        tide.flush().unwrap().unwrap();
        tide.compact_two().unwrap().unwrap();
        tide.sync().unwrap();
        tide.close().unwrap();
    }
    let tide = open(&t);
    for i in 0..80u32 {
        let got = tide.get(format!("k{i:03}").as_bytes()).unwrap();
        if i % 5 == 0 {
            assert_eq!(got, None, "k{i:03} 应仍是删除态");
        } else {
            assert_eq!(got, Some(format!("v{i}").into_bytes()));
        }
    }
    tide.close().unwrap();
}
