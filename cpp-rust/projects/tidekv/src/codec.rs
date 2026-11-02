//! 编解码缝：同一份编码逻辑的两种调用方式，用来量「分发代价」。
//!
//! 两条路径必须产出**逐字节相同**的输出——这是等价工作比较的前提，
//! 也是 `tests/codec_contract.rs` 里那条断言的由来。测量本身在
//! `src/bin/tide-mech.rs`，这里只提供被测的两条路径。

use std::cmp::Ordering;

/// 段文件里的一条逻辑记录。
#[derive(Clone, Debug)]
pub struct CodecRecord {
    /// 键。
    pub key: Vec<u8>,
    /// 值。
    pub value: Vec<u8>,
}

/// 编解码缝：段文件的读写只经过这一个接口。
pub trait Codec {
    /// 把一条记录追加到输出缓冲。
    fn encode(&self, rec: &CodecRecord, out: &mut Vec<u8>);
    /// 比较两个键（段内按键升序存放）。
    fn cmp_key(&self, a: &[u8], b: &[u8]) -> Ordering;
}

/// 定长键值的实现：键 16 字节、值 64 字节，与第 17 章立项时的输入家族一致。
#[derive(Clone, Copy, Debug)]
pub struct FixedCodec {
    /// 键长度。
    pub key_len: usize,
    /// 值长度。
    pub value_len: usize,
}

impl FixedCodec {
    /// 按给定的键长与值长构造。
    pub const fn new(key_len: usize, value_len: usize) -> FixedCodec {
        FixedCodec { key_len, value_len }
    }
}

impl Codec for FixedCodec {
    fn encode(&self, rec: &CodecRecord, out: &mut Vec<u8>) {
        out.extend_from_slice(&(rec.key.len() as u32).to_le_bytes());
        out.extend_from_slice(&(rec.value.len() as u32).to_le_bytes());
        out.push(1);
        out.extend_from_slice(&rec.key);
        out.extend_from_slice(&rec.value);
    }

    fn cmp_key(&self, a: &[u8], b: &[u8]) -> Ordering {
        a.cmp(b)
    }
}

/// 泛型路径：调用点用具体类型，编译期定死，每个调用点各生成一份代码。
#[inline]
pub fn encode_all<C: Codec>(codec: &C, recs: &[CodecRecord], out: &mut Vec<u8>) {
    for rec in recs {
        codec.encode(rec, out);
    }
}

/// `dyn` 路径：一次间接调用加一张 vtable，调用点不特化。
pub fn encode_all_dyn(codec: &dyn Codec, recs: &[CodecRecord], out: &mut Vec<u8>) {
    for rec in recs {
        codec.encode(rec, out);
    }
}
