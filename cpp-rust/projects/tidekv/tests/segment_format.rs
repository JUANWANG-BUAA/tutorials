//! 段文件格式：页脚魔数、整段 CRC、零拷贝读路径。

use tidekv::segment::{self, Segment, segment_name};
use tidekv::testutil::TempDir;
use tidekv::{Entry, EntryKind};

const MAGIC_LEN: usize = 5;

fn entries(n: usize) -> Vec<(Vec<u8>, Entry)> {
    (0..n)
        .map(|i| {
            (
                format!("k{i:05}").into_bytes(),
                Entry::new(
                    i as u64 + 1,
                    if i % 7 == 0 {
                        EntryKind::Delete
                    } else {
                        EntryKind::Put(format!("value-{i}").into_bytes())
                    },
                ),
            )
        })
        .collect()
}

#[test]
fn round_trip_and_footer_layout() {
    let t = TempDir::new("seg-format");
    let data = entries(500);
    let refs: Vec<(&[u8], &Entry)> = data.iter().map(|(k, e)| (k.as_slice(), e)).collect();
    let path = t.path().join(segment_name(3));
    let info = segment::write_segment(&path, 3, &refs, 8).unwrap();
    assert_eq!(info.entries, 500);
    let raw = std::fs::read(&path).unwrap();
    assert_eq!(
        &raw[raw.len() - segment::FOOTER_LEN..raw.len() - segment::FOOTER_LEN + MAGIC_LEN],
        b"TIDE1"
    );
    let seg = Segment::open(&path).unwrap();
    assert_eq!(seg.info().id, 3);
    assert_eq!(seg.info().bytes as usize, raw.len());
    let (index_off, bloom_off, bloom_len) = seg.regions();
    assert!(index_off < bloom_off && bloom_off + bloom_len + segment::FOOTER_LEN == raw.len());
    for (k, e) in &data {
        let got = seg.get(k).expect("must find the key");
        assert_eq!(got.seq, e.seq);
        match e.value() {
            None => assert!(got.is_tombstone()),
            Some(v) => assert_eq!(got.value.unwrap(), v),
        }
    }
    assert!(seg.get(b"zzz-not-there").is_none());
}

#[test]
fn zero_copy_borrow_outlives_the_lookup_call() {
    // 返回的 &[u8] 直接指向段缓冲：同一个键读两次的值必须是同一块内存。
    let t = TempDir::new("seg-zerocopy");
    let data = entries(64);
    let refs: Vec<(&[u8], &Entry)> = data.iter().map(|(k, e)| (k.as_slice(), e)).collect();
    let path = t.path().join(segment_name(1));
    segment::write_segment(&path, 1, &refs, 8).unwrap();
    let seg = Segment::open(&path).unwrap();
    let a = seg.get(b"k00001").unwrap().value.unwrap();
    let b = seg.get(b"k00001").unwrap().value.unwrap();
    assert!(std::ptr::eq(a, b), "两次读必须指向同一份缓冲，不该二次拷贝");
    let base = seg.buffer().as_ptr();
    let off = a.as_ptr() as usize - base as usize;
    assert!(
        off > 0 && off < seg.buffer().len(),
        "值应落在段缓冲内部，off={off}"
    );
}

#[test]
fn any_byte_flip_breaks_the_segment_crc() {
    let t = TempDir::new("seg-crc");
    let data = entries(120);
    let refs: Vec<(&[u8], &Entry)> = data.iter().map(|(k, e)| (k.as_slice(), e)).collect();
    let path = t.path().join(segment_name(2));
    segment::write_segment(&path, 2, &refs, 8).unwrap();
    let good = std::fs::read(&path).unwrap();
    assert!(Segment::open(&path).is_ok());
    // 数据区、索引区、布隆区里各挑一个字节翻转，页脚 CRC 都必须报错。
    let (index_off, bloom_off, _) = Segment::open(&path).unwrap().regions();
    for pos in [16usize, index_off / 2, index_off + 3, bloom_off + 2] {
        let mut bad = good.clone();
        bad[pos] ^= 0b0001_0000;
        std::fs::write(&path, &bad).unwrap();
        let e = Segment::open(&path)
            .err()
            .expect("must reject the flipped segment");
        assert!(
            e.to_string().contains("crc") || e.to_string().contains("range"),
            "unexpected error: {e}"
        );
    }
}

#[test]
fn unsorted_input_is_refused() {
    let t = TempDir::new("seg-unsorted");
    let e = Entry::new(1, EntryKind::Put(b"v".to_vec()));
    let data = [(b"b".to_vec(), &e), (b"a".to_vec(), &e)];
    let refs: Vec<(&[u8], &Entry)> = data.iter().map(|(k, e)| (k.as_slice(), *e)).collect();
    let err = segment::write_segment(&t.path().join(segment_name(9)), 9, &refs, 8).unwrap_err();
    assert!(err.to_string().contains("sorted"), "{err}");
}

#[test]
fn max_seq_and_scan_prefix() {
    let t = TempDir::new("seg-scan");
    let data = entries(300);
    let refs: Vec<(&[u8], &Entry)> = data.iter().map(|(k, e)| (k.as_slice(), e)).collect();
    let path = t.path().join(segment_name(4));
    segment::write_segment(&path, 4, &refs, 8).unwrap();
    let seg = Segment::open(&path).unwrap();
    assert_eq!(seg.max_seq(), 300);
    let hit = seg.scan_prefix(b"k0001");
    assert_eq!(hit.len(), 10, "k00010..k00019");
    for (k, _) in &hit {
        assert!(k.starts_with(b"k0001"));
    }
}
