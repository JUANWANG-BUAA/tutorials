//! `tide-probe`：代码生成探针的靶子。把热函数包在一层 `black_block` 里，
//! 保证 `cargo rustc --bin tide-probe -- --emit=asm` 产出的 asm 里一定留有可 grep 的调用点。

use std::hint::black_box;

use tidekv::bloom::Bloom;
use tidekv::segment::Segment;
use tidekv::testutil::TempDir;
use tidekv::{Config, Entry, EntryKind, Memtable, Tide};

/// 布隆扫描：热路径，只看 `contains`。
#[inline(never)]
fn probe_bloom(b: &Bloom, keys: &[Vec<u8>]) -> usize {
    let mut hits = 0usize;
    for k in keys {
        hits += b.contains(k) as usize;
    }
    hits
}

/// 点查：memtable + 段的两个热函数。
#[inline(never)]
fn probe_get(tide: &Tide, keys: &[Vec<u8>]) -> usize {
    let mut hits = 0usize;
    for k in keys {
        hits += tide.get(k).unwrap().is_some() as usize;
    }
    hits
}

/// 段内零拷贝二分。
#[inline(never)]
fn probe_segment_get(seg: &Segment, keys: &[Vec<u8>]) -> usize {
    let mut hits = 0usize;
    for k in keys {
        hits += seg.get(k).is_some() as usize;
    }
    hits
}

/// memtable 裸查。
#[inline(never)]
fn probe_memtable(m: &Memtable, keys: &[Vec<u8>]) -> usize {
    let mut hits = 0usize;
    for k in keys {
        hits += m.get(k).is_some() as usize;
    }
    hits
}

fn main() {
    let dir = TempDir::new("probe");
    let keys: Vec<Vec<u8>> = (0..2000u32)
        .map(|i| format!("key-{:08}", i).into_bytes())
        .collect();

    let mut b = Bloom::with_capacity(keys.len());
    for k in &keys {
        assert!(b.insert(k));
    }
    let mut all = keys.clone();
    all.extend((5000..5600u32).map(|i| format!("key-{:08}", i).into_bytes()));
    let mut sum = 0usize;
    for _ in 0..50 {
        sum += probe_bloom(black_box(&b), black_box(&all));
    }

    let cfg = Config {
        dir: dir.path().to_path_buf(),
        memtable_flush_bytes: 4096,
        ..Config::new(dir.path())
    };
    let tide = Tide::open_engine(cfg).unwrap();
    for (i, k) in keys.iter().enumerate() {
        tide.put(k, format!("value-{i}").as_bytes()).unwrap();
    }
    tide.flush().unwrap().unwrap();
    tide.flush().unwrap();
    let got = probe_get(&tide, &keys);

    let segs = tide.segments();
    let seg = Segment::open(&segs[0].path).unwrap();
    let in_seg = probe_segment_get(&seg, &keys);

    let mut m = Memtable::new();
    for (i, k) in keys.iter().enumerate() {
        m.insert(
            k,
            Entry::new(
                i as u64 + 1,
                EntryKind::Put(format!("value-{i}").into_bytes()),
            ),
        );
    }
    let in_mem = probe_memtable(&m, &keys);

    println!(
        "probe: bloom_hits={sum} tide_gets={got} segment_gets={in_seg} memtable_gets={in_mem}"
    );
    drop(tide);
}
