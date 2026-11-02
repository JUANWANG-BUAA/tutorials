//! 布隆过滤器的两条契约：真阳性一个不漏；假阳性用真实统计报出经验值。

use tidekv::bloom::{Bloom, DEFAULT_BYTES_PER_KEY};
use tidekv::crc32::crc32;
use tidekv::testutil;
use tidekv::testutil::TempDir;
use tidekv::{Config, Segment, Tide};

fn key(i: u64) -> Vec<u8> {
    format!("bloom-key-{i:09}").into_bytes()
}

#[test]
fn no_false_negatives_direct() {
    let n = 20_000u64;
    let mut b = Bloom::with_capacity(n as usize);
    for i in 0..n {
        assert!(b.insert(&key(i)), "桶溢出，容量估计过小");
    }
    for i in 0..n {
        assert!(b.contains(&key(i)), "{i} 号键被漏报，违反布隆契约");
    }
}

#[test]
fn measured_false_positive_rate() {
    let n = 50_000u64;
    let probes = 200_000u64;
    let mut b = Bloom::with_capacity(n as usize);
    for i in 0..n {
        b.insert(&key(i));
    }
    let mut fp = 0u64;
    for i in 0..probes {
        let k = format!("absent-key-{i:09}").into_bytes();
        fp += b.contains(&k) as u64;
    }
    let rate = fp as f64 / probes as f64;
    println!(
        "bloom: bytes_per_key={DEFAULT_BYTES_PER_KEY} slots={} fp={fp}/{probes} rate={:.5} (1/{:.1})",
        b.slots(),
        rate,
        if rate > 0.0 {
            1.0 / rate
        } else {
            f64::INFINITY
        }
    );
    assert!(rate < 0.05, "经验假阳率 {rate} 超出 5% 上界");
    assert!(rate > 0.0, "假阳率为 0 说明过滤器根本没在工作");
}

#[test]
fn encode_decode_round_trip() {
    let mut b = Bloom::with_capacity(5_000);
    let keys: Vec<Vec<u8>> = (0..5_000u64).map(key).collect();
    for k in &keys {
        b.insert(k);
    }
    let enc = b.encode();
    let d = Bloom::decode(&enc).expect("decode");
    for k in &keys {
        assert!(d.contains(k));
    }
    assert_eq!(d.slots(), b.slots());
}

#[test]
fn segment_bloom_rejects_absent_and_never_misses() {
    let t = TempDir::new("bloom-seg");
    let cfg = Config {
        dir: t.path().to_path_buf(),
        memtable_flush_bytes: usize::MAX,
        ..Config::new(t.path())
    };
    let tide = Tide::open_engine(cfg).unwrap();
    let n = 8_000u64;
    for i in 0..n {
        testutil::put(&tide, &key(i), b"v");
    }
    let info = tide.flush().unwrap().unwrap();
    let seg = Segment::open(&info.path).unwrap();
    for i in 0..n {
        assert!(seg.get(&key(i)).is_some(), "段内漏报 {i}");
    }
    let mut fp = 0usize;
    let absent = 50_000u64;
    for i in 0..absent {
        let k = format!("nope-{i:09}").into_bytes();
        fp += seg.get(&k).is_some() as usize;
    }
    println!(
        "segment bloom: {} keys, {fp}/{absent} absent keys slipped through (rate={:.5})",
        info.entries,
        fp as f64 / absent as f64
    );
    assert!(fp as f64 / (absent as f64) < 0.05);

    let before = tide.stats();
    for i in 0..2_000u64 {
        let _ = tide.get(&format!("nope-{i:09}").into_bytes());
    }
    let after = tide.stats();
    let rejected = after.bloom_reject - before.bloom_reject;
    let probed = rejected + (after.bloom_hit - before.bloom_hit);
    println!("engine counters: {rejected} rejected / {probed} probed by absent gets");
    assert!(rejected >= 1_900, "绝大多数不存在的键应被布隆直接挡掉");
    tide.close().unwrap();
}

#[test]
fn crc32_catches_single_bit_flips() {
    let base = b"segment body bytes".to_vec();
    let want = crc32(&base);
    for i in 0..base.len() {
        let mut b = base.clone();
        b[i] ^= 1 << (i % 8);
        assert_ne!(crc32(&b), want, "第 {i} 字节翻转未被发现");
    }
}
