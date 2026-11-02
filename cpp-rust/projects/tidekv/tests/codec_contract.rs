//! 编解码缝的等价工作契约：泛型路径与 `dyn` 路径必须产出逐字节相同的输出。
//!
//! 这条断言是 17.4 那组测量的前提：如果两条路径的输出不同，比较的就不是
//! 「同一件工作的两种写法」，而是两件工作。

use tidekv::codec::{Codec, CodecRecord, FixedCodec, encode_all, encode_all_dyn};

fn records(n: usize) -> Vec<CodecRecord> {
    (0..n)
        .map(|i| CodecRecord {
            key: format!("k{i:08}").into_bytes(),
            value: vec![b'x'; 64],
        })
        .collect()
}

#[test]
fn generic_and_dyn_paths_produce_identical_bytes() {
    let codec = FixedCodec::new(16, 64);
    let recs = records(256);
    let mut a = Vec::new();
    let mut b = Vec::new();
    encode_all(&codec, &recs, &mut a);
    encode_all_dyn(&codec as &dyn Codec, &recs, &mut b);
    assert_eq!(a, b, "generic and dyn paths must agree byte for byte");
    assert!(!a.is_empty());
}

#[test]
fn encoded_record_carries_length_prefixes() {
    let codec = FixedCodec::new(16, 64);
    let recs = vec![CodecRecord {
        key: b"k00000000_______".to_vec(), // 16 字节
        value: vec![b'x'; 64],
    }];
    let mut out = Vec::new();
    encode_all(&codec, &recs, &mut out);
    // 4 字节键长 + 4 字节值长 + 1 字节操作码 + 键 + 值
    assert_eq!(out.len(), 4 + 4 + 1 + 16 + 64);
    assert_eq!(u32::from_le_bytes(out[0..4].try_into().unwrap()), 16);
    assert_eq!(u32::from_le_bytes(out[4..8].try_into().unwrap()), 64);
    assert_eq!(out[8], 1);
}

#[test]
fn empty_input_produces_empty_output() {
    let codec = FixedCodec::new(16, 64);
    let mut a = Vec::new();
    let mut b = Vec::new();
    encode_all(&codec, &[], &mut a);
    encode_all_dyn(&codec as &dyn Codec, &[], &mut b);
    assert!(a.is_empty());
    assert_eq!(a, b);
}
