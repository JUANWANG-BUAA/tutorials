//! flush 之后重启，数据必须还在（段文件 + WAL 轮转的契约）。

use tidekv::testutil;
use tidekv::testutil::TempDir;
use tidekv::{Config, Tide};

#[test]
fn data_survives_restart_after_flush() {
    let t = TempDir::new("persist-flush");
    let cfg = Config {
        dir: t.path().to_path_buf(),
        memtable_flush_bytes: 4096,
        ..Config::new(t.path())
    };
    {
        let tide = Tide::open_engine(cfg.clone()).unwrap();
        for i in 0..400u32 {
            testutil::put(
                &tide,
                format!("k{i:04}").as_bytes(),
                format!("v{i}").as_bytes(),
            );
        }
        let info = tide.flush().unwrap().expect("flush produced a segment");
        assert!(info.entries > 0);
        assert_eq!(tide.frozen_tables(), 0);
        tide.close().unwrap();
    }
    // 重新打开：一个字节都不写，只靠磁盘上的段文件。
    let tide = Tide::open_engine(cfg).unwrap();
    assert!(!tide.segments().is_empty());
    for i in 0..400u32 {
        let v = tide.get(format!("k{i:04}").as_bytes()).unwrap();
        assert_eq!(v, Some(format!("v{i}").into_bytes()), "key {i} lost");
    }
    tide.close().unwrap();
}

#[test]
fn wal_only_writes_survive_reopen() {
    let t = TempDir::new("persist-wal");
    let cfg = Config {
        dir: t.path().to_path_buf(),
        // 阈值足够大，保证什么都不会 flush。
        memtable_flush_bytes: usize::MAX,
        ..Config::new(t.path())
    };
    {
        let tide = Tide::open_engine(cfg.clone()).unwrap();
        testutil::put(&tide, b"alpha", b"1");
        testutil::put(&tide, b"beta", b"2");
        testutil::delete(&tide, b"alpha");
        tide.sync().unwrap();
        assert!(tide.segments().is_empty());
        tide.close().unwrap();
    }
    let tide = Tide::open_engine(cfg).unwrap();
    assert!(tide.segments().is_empty());
    assert_eq!(tide.get(b"alpha").unwrap(), None);
    assert_eq!(tide.get(b"beta").unwrap(), Some(b"2".to_vec()));
    tide.close().unwrap();
}

#[test]
fn unflushed_memtable_then_segment_mix_after_reopen() {
    let t = TempDir::new("persist-mix");
    let cfg = Config {
        dir: t.path().to_path_buf(),
        memtable_flush_bytes: 4096,
        ..Config::new(t.path())
    };
    {
        let tide = Tide::open_engine(cfg.clone()).unwrap();
        for i in 0..200u32 {
            testutil::put(&tide, format!("k{i:04}").as_bytes(), b"old");
        }
        tide.flush().unwrap().unwrap();
        for i in 100..300u32 {
            testutil::put(&tide, format!("k{i:04}").as_bytes(), b"new");
        }
        tide.sync().unwrap();
        tide.close().unwrap();
    }
    let tide = Tide::open_engine(cfg).unwrap();
    assert_eq!(tide.get(b"k0050").unwrap(), Some(b"old".to_vec()));
    assert_eq!(tide.get(b"k0150").unwrap(), Some(b"new".to_vec()));
    assert_eq!(tide.get(b"k0250").unwrap(), Some(b"new".to_vec()));
    assert_eq!(tide.get(b"k0999").unwrap(), None);
    tide.close().unwrap();
}

#[test]
fn torn_wal_tail_is_dropped_on_reopen() {
    let t = TempDir::new("persist-torn");
    let cfg = Config {
        dir: t.path().to_path_buf(),
        memtable_flush_bytes: usize::MAX,
        ..Config::new(t.path())
    };
    {
        let tide = Tide::open_engine(cfg.clone()).unwrap();
        testutil::put(&tide, b"a", b"1");
        testutil::put(&tide, b"b", b"2");
        tide.sync().unwrap();
        tide.close().unwrap();
    }
    let wal = t.path().join("tide.wal");
    let mut bytes = std::fs::read(&wal).unwrap();
    // 在最有一条记录中间写脏一个字节，模拟撕裂写。
    let n = bytes.len();
    bytes[n - 3] ^= 0xFF;
    std::fs::write(&wal, &bytes).unwrap();

    let (tide, rec) = Tide::open(cfg).unwrap();
    assert_eq!(rec.records.len(), 1, "第二帧 CRC 不匹配，不该重放");
    assert!(rec.rejected_records >= 1);
    assert_eq!(tide.wal_rejected(), rec.rejected_records as u64);
    assert_eq!(tide.get(b"a").unwrap(), Some(b"1".to_vec()));
    assert_eq!(tide.get(b"b").unwrap(), None);
    tide.close().unwrap();
}
