//! WAL 的 CRC 与崩溃恢复契约。

use std::fs::OpenOptions;
use std::path::Path;

use tidekv::testutil::TempDir;
use tidekv::wal::{self, OpKind, Record, Wal};

fn rec(seq: u64, k: &[u8], v: &[u8]) -> Record {
    Record {
        seq,
        kind: if v.is_empty() {
            OpKind::Delete
        } else {
            OpKind::Put
        },
        key: k.to_vec(),
        value: v.to_vec(),
    }
}

fn write_n(path: &Path, n: u64, vlen: usize) {
    let mut w = Wal::open(path).unwrap();
    for i in 1..=n {
        let v = vec![b'x' + (i % 26) as u8; vlen];
        w.append(&rec(i, format!("k{i:03}").as_bytes(), &v))
            .unwrap();
    }
    w.sync_to(true).unwrap();
}

#[test]
fn clean_wal_replays_everything() {
    let t = TempDir::new("wal-clean");
    let p = t.path().join("tide.wal");
    write_n(&p, 8, 40);
    let r = wal::recover(&p).unwrap();
    assert_eq!(r.records.len(), 8);
    assert_eq!(r.rejected_records, 0);
    assert_eq!(r.discarded_bytes, 0);
    assert_eq!(r.records[7].key, b"k008");
}

#[test]
fn truncated_tail_is_rejected_and_counted() {
    let t = TempDir::new("wal-trunc");
    let p = t.path().join("tide.wal");
    write_n(&p, 10, 64);
    let full = std::fs::metadata(&p).unwrap().len();
    // 模拟写到一半掉电：砍掉最后一帧的尾部字节。
    let f = OpenOptions::new().write(true).open(&p).unwrap();
    // 一帧 = 4 字节长度 + (17 + key4 + value64) 载荷 + 4 字节 CRC = 93 字节。
    const FRAME: u64 = 4 + 17 + 4 + 64 + 4;
    f.set_len(full - 20).unwrap();
    let r = wal::recover(&p).unwrap();
    assert_eq!(r.records.len(), 9, "只应重放完整的 9 帧");
    assert_eq!(r.rejected_records, 0, "半帧不构成可识别的记录");
    assert_eq!(r.valid_bytes + r.discarded_bytes, full as usize - 20);
    assert_eq!(r.valid_bytes, 9 * FRAME as usize);
    assert_eq!(r.discarded_bytes, full as usize - 20 - 9 * FRAME as usize);
}

#[test]
fn corrupted_crc_stops_replay_and_counts_the_tail() {
    let t = TempDir::new("wal-crc");
    let p = t.path().join("tide.wal");
    write_n(&p, 12, 32);
    let mut bytes = std::fs::read(&p).unwrap();
    // 第 7 帧的载荷中间翻一个位。
    let mut pos = 0usize;
    for _ in 0..6 {
        let total = u32::from_le_bytes(bytes[pos..pos + 4].try_into().unwrap()) as usize;
        pos += total + 4;
    }
    let payload_mid = pos + 4 + 12;
    bytes[payload_mid] ^= 0b1000_0000;
    std::fs::write(&p, &bytes).unwrap();
    let r = wal::recover(&p).unwrap();
    assert_eq!(r.records.len(), 6);
    assert_eq!(r.rejected_records, 6, "第 7..12 帧都应被拒绝计数");
    assert!(r.has_rejected());
}

#[test]
fn crc_detects_flipped_crc_field_itself() {
    let t = TempDir::new("wal-crc-field");
    let p = t.path().join("tide.wal");
    write_n(&p, 5, 16);
    let mut bytes = std::fs::read(&p).unwrap();
    let n = bytes.len();
    bytes[n - 1] ^= 1;
    std::fs::write(&p, &bytes).unwrap();
    let r = wal::recover(&p).unwrap();
    assert_eq!(r.records.len(), 4);
    assert_eq!(r.rejected_records, 1);
}

#[test]
fn delete_records_round_trip() {
    let t = TempDir::new("wal-del");
    let p = t.path().join("tide.wal");
    let mut w = Wal::open(&p).unwrap();
    w.append(&rec(1, b"a", b"1")).unwrap();
    w.append(&rec(2, b"a", b"")).unwrap();
    w.sync_to(true).unwrap();
    drop(w);
    let r = wal::recover(&p).unwrap();
    assert_eq!(r.records.len(), 2);
    assert_eq!(r.records[1].kind, OpKind::Delete);
}

#[test]
fn append_after_recovery_keeps_old_frames() {
    let t = TempDir::new("wal-append");
    let p = t.path().join("tide.wal");
    write_n(&p, 4, 8);
    let mut w = Wal::open(&p).unwrap();
    w.append(&rec(5, b"k005", b"y")).unwrap();
    w.sync_to(true).unwrap();
    drop(w);
    let r = wal::recover(&p).unwrap();
    assert_eq!(r.records.len(), 5);
    assert_eq!(r.rejected_records, 0);
}

#[test]
fn rotate_keeping_preserves_tail_records() {
    let t = TempDir::new("wal-rotate");
    let p = t.path().join("tide.wal");
    let mut w = Wal::open(&p).unwrap();
    for i in 1..=6u64 {
        w.append(&rec(i, format!("k{i}").as_bytes(), b"v")).unwrap();
    }
    w.sync_to(true).unwrap();
    // 假装前 4 帧已经进段：从第 4 帧末尾开始保留。
    let bytes = std::fs::read(&p).unwrap();
    let mut off = 0usize;
    for _ in 0..4 {
        let total = u32::from_le_bytes(bytes[off..off + 4].try_into().unwrap()) as usize;
        off += total + 4;
    }
    w.rotate_keeping(off as u64).unwrap();
    w.sync_to(true).unwrap();
    drop(w);
    let r = wal::recover(&p).unwrap();
    assert_eq!(r.records.len(), 2);
    assert_eq!(r.records[0].seq, 5);
    assert_eq!(r.records[1].seq, 6);
}
