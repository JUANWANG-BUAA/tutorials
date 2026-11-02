//! 墓碑在「memtable + 冻结表 + 多个段」混合下的正确性。

use tidekv::testutil;
use tidekv::testutil::TempDir;
use tidekv::{Config, Tide};

fn tide_at(t: &TempDir, flush_bytes: usize) -> Tide {
    let cfg = Config {
        dir: t.path().to_path_buf(),
        memtable_flush_bytes: flush_bytes,
        ..Config::new(t.path())
    };
    Tide::open_engine(cfg).unwrap()
}

#[test]
fn delete_in_memtable_hides_value_in_segment() {
    let t = TempDir::new("tomb-seg");
    let tide = tide_at(&t, usize::MAX);
    testutil::put(&tide, b"k1", b"v1");
    testutil::put(&tide, b"k2", b"v2");
    tide.flush().unwrap().unwrap();
    testutil::delete(&tide, b"k1");
    tide.sync().unwrap();
    assert_eq!(tide.get(b"k1").unwrap(), None);
    assert_eq!(tide.get(b"k2").unwrap(), Some(b"v2".to_vec()));
    // 扫描也要跳过被墓碑遮住的键。
    let all = tide.scan_prefix(b"").unwrap();
    assert_eq!(all, vec![(b"k2".to_vec(), b"v2".to_vec())]);
    tide.close().unwrap();
}

#[test]
fn put_after_delete_resurrects() {
    let t = TempDir::new("tomb-reinsert");
    let tide = tide_at(&t, usize::MAX);
    testutil::put(&tide, b"k", b"1");
    testutil::delete(&tide, b"k");
    tide.sync().unwrap();
    assert_eq!(tide.get(b"k").unwrap(), None);
    testutil::put(&tide, b"k", b"2");
    tide.sync().unwrap();
    assert_eq!(tide.get(b"k").unwrap(), Some(b"2".to_vec()));
    tide.flush().unwrap();
    assert_eq!(tide.get(b"k").unwrap(), Some(b"2".to_vec()));
    tide.close().unwrap();
}

#[test]
fn tombstone_across_two_segments_and_restart() {
    let t = TempDir::new("tomb-two");
    {
        let tide = tide_at(&t, usize::MAX);
        testutil::put(&tide, b"x", b"old");
        tide.flush().unwrap().unwrap(); // 段 1
        testutil::delete(&tide, b"x");
        tide.flush().unwrap().unwrap(); // 段 2（只有一条墓碑）
        testutil::put(&tide, b"y", b"live");
        tide.sync().unwrap();
        assert_eq!(tide.segments().len(), 2);
        tide.close().unwrap();
    }
    let tide = tide_at(&t, usize::MAX);
    assert_eq!(tide.get(b"x").unwrap(), None);
    assert_eq!(tide.get(b"y").unwrap(), Some(b"live".to_vec()));
    tide.close().unwrap();
}

#[test]
fn delete_then_flush_then_delete_again() {
    let t = TempDir::new("tomb-twice");
    let tide = tide_at(&t, usize::MAX);
    testutil::put(&tide, b"a", b"1");
    testutil::delete(&tide, b"a");
    tide.flush().unwrap().unwrap();
    testutil::delete(&tide, b"a");
    tide.sync().unwrap();
    assert_eq!(tide.get(b"a").unwrap(), None);
    tide.flush().unwrap().unwrap();
    assert_eq!(tide.get(b"a").unwrap(), None);
    tide.close().unwrap();
}

#[test]
fn mixed_random_ops_match_naive_model() {
    // 与一份朴素模型（BTreeMap<_, Option<>>）逐操作对照，覆盖 put/delete/get 交错。
    let t = TempDir::new("tomb-model");
    let tide = tide_at(&t, 2048); // 小阈值，跑的过程中会自发 flush
    let mut model: std::collections::BTreeMap<Vec<u8>, Option<Vec<u8>>> =
        std::collections::BTreeMap::new();
    let mut state = 0x5DEECE66Du64;
    for i in 0..3000u64 {
        state ^= state << 13;
        state ^= state >> 7;
        state ^= state << 17;
        let pick = (state >> 32) % 100;
        let k = format!("key-{:03}", state % 500).into_bytes();
        if pick < 60 {
            let v = format!("val-{i}").into_bytes();
            testutil::put(&tide, &k, &v);
            model.insert(k, Some(v));
        } else if pick < 75 {
            testutil::delete(&tide, &k);
            model.insert(k, None);
        } else {
            tide.sync().unwrap();
            assert_eq!(
                tide.get(&k).unwrap(),
                model.get(&k).and_then(|o| o.clone()),
                "op {i} key {k:?}"
            );
        }
    }
    tide.sync().unwrap();
    let want: Vec<(Vec<u8>, Vec<u8>)> = model
        .iter()
        .filter_map(|(k, v)| v.as_ref().map(|v| (k.clone(), v.clone())))
        .collect();
    assert_eq!(tide.scan_prefix(b"").unwrap(), want);
    tide.close().unwrap();
}
