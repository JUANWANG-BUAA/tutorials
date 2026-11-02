//! 不可变段文件：有序条目 + 末尾索引 + 布隆块 + 页脚，只读打开后一次载入一段 `Vec<u8>`。

use std::fs::File;
use std::io::{self, Read, Write};
use std::path::{Path, PathBuf};

use crate::bloom::Bloom;
use crate::crc32::crc32;
use crate::memtable::{Entry, EntryKind, Key};

/// 页脚魔数。
pub const MAGIC: [u8; 5] = *b"TIDE1";
/// 格式版本。
pub const VERSION: u8 = 1;
/// 页脚固定长度：magic5 + ver1 + entries4 + index_off8 + bloom_off8 + bloom_len4 + crc4。
pub const FOOTER_LEN: usize = 34;
/// 条目头长度：klen4 + vlen4 + op1 + seq8。
const ENTRY_HEAD: usize = 17;
/// 索引项长度：klen4 + offset8。
const INDEX_ITEM: usize = 12;

/// 段的元信息。
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct SegmentInfo {
    /// 单调递增的段号，越大越新。
    pub id: u64,
    /// 文件路径。
    pub path: PathBuf,
    /// 条目数。
    pub entries: usize,
    /// 文件字节数。
    pub bytes: u64,
    /// 键数（等于条目数，段内键唯一）。
    pub keys: usize,
}

/// 一次读命中后的视图；`value` 为 `None` 表示墓碑。
#[derive(Clone, Copy, Debug)]
pub struct Look<'a> {
    /// 条目序号。
    pub seq: u64,
    /// 零拷贝指向段缓冲的值。
    pub value: Option<&'a [u8]>,
}

impl<'a> Look<'a> {
    /// 是否为墓碑。
    pub fn is_tombstone(&self) -> bool {
        self.value.is_none()
    }
}

/// 写出一段：`entries` 必须按键的字典序升序且键唯一。
pub fn write_segment(
    path: &Path,
    id: u64,
    entries: &[(&[u8], &Entry)],
    bytes_per_key: usize,
) -> io::Result<SegmentInfo> {
    let mut buf: Vec<u8> = Vec::new();
    let mut index: Vec<u8> = Vec::new();
    let mut bloom = Bloom::with_capacity_and_bpk(entries.len().max(1), bytes_per_key);
    let mut last: Option<&[u8]> = None;
    for (key, e) in entries {
        if let Some(prev) = last {
            if prev >= *key {
                return Err(io::Error::new(
                    io::ErrorKind::InvalidInput,
                    "segment entries must be sorted and unique by key",
                ));
            }
        }
        last = Some(key);
        let off = buf.len() as u64;
        let value = e.value().unwrap_or(&[]);
        let op: u8 = if e.is_tombstone() { 2 } else { 1 };
        buf.extend_from_slice(&(key.len() as u32).to_le_bytes());
        buf.extend_from_slice(&(value.len() as u32).to_le_bytes());
        buf.push(op);
        buf.extend_from_slice(&e.seq.to_le_bytes());
        buf.extend_from_slice(key);
        buf.extend_from_slice(value);
        index.extend_from_slice(&(key.len() as u32).to_le_bytes());
        index.extend_from_slice(&off.to_le_bytes());
        if !bloom.insert(key) {
            return Err(io::Error::new(
                io::ErrorKind::InvalidInput,
                "bloom bucket overflow",
            ));
        }
    }
    let index_off = buf.len() as u64;
    buf.extend_from_slice(&index);
    let bloom_enc = bloom.encode();
    let bloom_off = buf.len() as u64;
    buf.extend_from_slice(&bloom_enc);
    let crc = crc32(&buf);
    buf.extend_from_slice(&MAGIC);
    buf.push(VERSION);
    buf.extend_from_slice(&(entries.len() as u32).to_le_bytes());
    buf.extend_from_slice(&index_off.to_le_bytes());
    buf.extend_from_slice(&bloom_off.to_le_bytes());
    buf.extend_from_slice(&(bloom_enc.len() as u32).to_le_bytes());
    buf.extend_from_slice(&crc.to_le_bytes());

    let tmp = {
        let mut p = path.to_path_buf();
        p.set_extension("tmp");
        p
    };
    {
        let mut f = File::create(&tmp)?;
        f.write_all(&buf)?;
        f.sync_all()?;
    }
    std::fs::rename(&tmp, path)?;
    let bytes = buf.len() as u64;
    Ok(SegmentInfo {
        id,
        path: path.to_path_buf(),
        entries: entries.len(),
        bytes,
        keys: entries.len(),
    })
}

/// 只读段。整个文件一次性读进 `data`，读路径从 `data` 里切片，不再二次拷贝。
pub struct Segment {
    info: SegmentInfo,
    data: Vec<u8>,
    index_off: usize,
    bloom_off: usize,
    bloom_len: usize,
    bloom: Bloom,
}

impl Segment {
    /// 只读打开并校验页脚与整段 CRC。
    pub fn open(path: &Path) -> io::Result<Self> {
        let mut data = Vec::new();
        File::open(path)?.read_to_end(&mut data)?;
        if data.len() < FOOTER_LEN + ENTRY_HEAD {
            return Err(io::Error::other("segment too short"));
        }
        let f = data.len() - FOOTER_LEN;
        if data[f..f + 5] != MAGIC {
            return Err(io::Error::other("bad segment magic"));
        }
        if data[f + 5] != VERSION {
            return Err(io::Error::other("unsupported segment version"));
        }
        let entries = u32::from_le_bytes(data[f + 6..f + 10].try_into().unwrap()) as usize;
        let index_off = u64::from_le_bytes(data[f + 10..f + 18].try_into().unwrap()) as usize;
        let bloom_off = u64::from_le_bytes(data[f + 18..f + 26].try_into().unwrap()) as usize;
        let bloom_len = u32::from_le_bytes(data[f + 26..f + 30].try_into().unwrap()) as usize;
        let crc = u32::from_le_bytes(data[f + 30..f + 34].try_into().unwrap());
        if crc != crc32(&data[..f]) {
            return Err(io::Error::other("segment crc mismatch"));
        }
        if index_off > f
            || bloom_off > f
            || bloom_off + bloom_len != f
            || index_off + entries * INDEX_ITEM != bloom_off
        {
            return Err(io::Error::other("segment footer out of range"));
        }
        let bloom = Bloom::decode(&data[bloom_off..bloom_off + bloom_len])
            .ok_or_else(|| io::Error::other("bad bloom block"))?;
        let id = path
            .file_stem()
            .and_then(|s| s.to_str())
            .and_then(|s| s.trim_start_matches("seg-").parse::<u64>().ok())
            .unwrap_or(0);
        Ok(Segment {
            info: SegmentInfo {
                id,
                path: path.to_path_buf(),
                entries,
                bytes: data.len() as u64,
                keys: entries,
            },
            data,
            index_off,
            bloom_off,
            bloom_len,
            bloom,
        })
    }

    /// 元信息。
    pub fn info(&self) -> &SegmentInfo {
        &self.info
    }

    /// 布隆过滤器：可能存在，或过滤器判定一定不存在。
    #[inline]
    pub fn bloom_maybe_contains(&self, key: &[u8]) -> bool {
        self.bloom.contains(key)
    }

    /// 索引项：第 `i` 条的键长与数据偏移。
    #[inline]
    fn index_item(&self, i: usize) -> (usize, usize) {
        let p = self.index_off + i * INDEX_ITEM;
        let klen = u32::from_le_bytes(self.data[p..p + 4].try_into().unwrap()) as usize;
        let off = u64::from_le_bytes(self.data[p + 4..p + 12].try_into().unwrap()) as usize;
        (klen, off)
    }

    /// 零拷贝读取一条记录（先过布隆）。
    pub fn get<'a>(&'a self, key: &[u8]) -> Option<Look<'a>> {
        if !self.bloom.contains(key) {
            return None;
        }
        self.get_no_bloom(key)
    }

    /// 跳过布隆的二分查找；引擎侧已经查过布隆并计了统计。
    pub fn get_no_bloom(&self, key: &[u8]) -> Option<Look<'_>> {
        let (_, off) = self.lookup_index(key)?;
        Some(self.look_at(off))
    }

    /// 二分定位：返回 `(键长, 数据偏移)`。
    fn lookup_index(&self, key: &[u8]) -> Option<(usize, usize)> {
        let mut lo = 0usize;
        let mut hi = self.info.entries;
        while lo < hi {
            let mid = lo + (hi - lo) / 2;
            let (klen, off) = self.index_item(mid);
            let stored = self.bytes_at(off + ENTRY_HEAD, klen);
            match stored.cmp(key) {
                std::cmp::Ordering::Less => lo = mid + 1,
                std::cmp::Ordering::Greater => hi = mid,
                std::cmp::Ordering::Equal => return Some((klen, off)),
            }
        }
        None
    }

    /// 从数据区偏移解出一条记录。
    fn look_at(&self, off: usize) -> Look<'_> {
        let vlen = u32::from_le_bytes(self.data[off + 4..off + 8].try_into().unwrap()) as usize;
        let klen = u32::from_le_bytes(self.data[off..off + 4].try_into().unwrap()) as usize;
        let op = self.data[off + 8];
        let seq = u64::from_le_bytes(self.data[off + 9..off + 17].try_into().unwrap());
        let value = if op == 2 {
            None
        } else {
            Some(self.bytes_at(off + ENTRY_HEAD + klen, vlen))
        };
        Look { seq, value }
    }

    /// 前缀扫描：从第一个 `>= prefix` 的条目顺序读到前缀结束，只拷贝命中的值。
    pub fn scan_prefix(&self, prefix: &[u8]) -> Vec<(Vec<u8>, Entry)> {
        let start = self.lower_bound(prefix);
        let mut out = Vec::new();
        for i in start..self.info.entries {
            let (klen, off) = self.index_item(i);
            let key = self.bytes_at(off + ENTRY_HEAD, klen);
            if !key.starts_with(prefix) {
                break;
            }
            let look = self.look_at(off);
            let kind = match look.value {
                None => EntryKind::Delete,
                Some(v) => EntryKind::Put(v.to_vec()),
            };
            out.push((key.to_vec(), Entry::new(look.seq, kind)));
        }
        out
    }

    /// 第一个不小于 `key` 的索引位置。
    fn lower_bound(&self, key: &[u8]) -> usize {
        let mut lo = 0usize;
        let mut hi = self.info.entries;
        while lo < hi {
            let mid = lo + (hi - lo) / 2;
            let (klen, off) = self.index_item(mid);
            if self.bytes_at(off + ENTRY_HEAD, klen) < key {
                lo = mid + 1;
            } else {
                hi = mid;
            }
        }
        lo
    }

    /// 段内最大序号（恢复时用来推 `next_seq`）。
    pub fn max_seq(&self) -> u64 {
        let mut m = 0;
        for i in 0..self.info.entries {
            let (_, off) = self.index_item(i);
            let seq = u64::from_le_bytes(self.data[off + 9..off + 17].try_into().unwrap());
            m = m.max(seq);
        }
        m
    }

    /// 从数据区切一段字节。
    ///
    /// 偏移与长度来自我们自己写出的索引，且整段字节被页脚 CRC 覆盖，
    /// 打开时已校验；越界仍显式检查，因此别名只指向 `self.data` 内部的合法字节。
    #[inline]
    fn bytes_at(&self, off: usize, len: usize) -> &[u8] {
        let end = off + len;
        assert!(
            end <= self.data.len(),
            "segment index out of bounds: off={off} len={len}"
        );
        // SAFETY: `off..end` 已在本函数内检查落在 `self.data` 的 0..len 范围内；
        // 返回的引用借用自 `&self`（生命周期由调用点的 `'a` 决定），
        // 而 `data` 在 `Segment` 存活期内不会 realloc 或移动，
        // 因此该切片与段缓冲同源同生命周期，不存在悬垂或可变别名。
        unsafe { std::slice::from_raw_parts(self.data.as_ptr().add(off), len) }
    }

    /// 把段内所有条目导出为有序向量（压缩子进程使用，允许一次拷贝）。
    pub fn dump(&self) -> Vec<(Vec<u8>, Entry)> {
        let mut out = Vec::with_capacity(self.info.entries);
        for i in 0..self.info.entries {
            let (klen, off) = self.index_item(i);
            let vlen = u32::from_le_bytes(self.data[off + 4..off + 8].try_into().unwrap()) as usize;
            let op = self.data[off + 8];
            let seq = u64::from_le_bytes(self.data[off + 9..off + 17].try_into().unwrap());
            let key = self.bytes_at(off + ENTRY_HEAD, klen).to_vec();
            let kind = if op == 2 {
                EntryKind::Delete
            } else {
                EntryKind::Put(self.bytes_at(off + ENTRY_HEAD + klen, vlen).to_vec())
            };
            out.push((key, Entry::new(seq, kind)));
        }
        out
    }

    /// 数据区字节数。
    pub fn data_bytes(&self) -> usize {
        self.index_off
    }

    /// 段缓冲总长度。
    pub fn buffer_len(&self) -> usize {
        self.data.len()
    }

    /// 布隆块长度。
    pub fn bloom_len(&self) -> usize {
        self.bloom_len
    }

    /// 三个区域的边界：`(索引起点, 布隆起点, 布隆长度)`。
    pub fn regions(&self) -> (usize, usize, usize) {
        (self.index_off, self.bloom_off, self.bloom_len)
    }

    /// 段缓冲（测试与探针用）。
    pub fn buffer(&self) -> &[u8] {
        &self.data
    }
}

/// 段文件名。
pub fn segment_name(id: u64) -> String {
    format!("seg-{:06}.tide", id)
}

/// 把若干段的条目归并成按键升序、键唯一的一组：同键取最大序号；
/// `drop_tombstones` 为真时丢掉墓碑。
pub fn merge_dumps(dumps: &[Vec<(Vec<u8>, Entry)>], drop_tombstones: bool) -> Vec<(Key, Entry)> {
    let mut best: std::collections::BTreeMap<Key, Entry> = std::collections::BTreeMap::new();
    for d in dumps {
        for (k, e) in d {
            match best.get(k) {
                Some(cur) if cur.seq >= e.seq => {}
                _ => {
                    best.insert(k.clone(), e.clone());
                }
            }
        }
    }
    if drop_tombstones {
        best.retain(|_, e| !e.is_tombstone());
    }
    best.into_iter().collect()
}

/// 归并结果的统计，`tide-compactor` 会算一次。
#[derive(Clone, Copy, Debug, Default)]
pub struct MergeStats {
    /// 输入条目总数。
    pub inputs: u64,
    /// 输出条目数。
    pub outputs: u64,
    /// 丢掉的墓碑数。
    pub dropped_tombstones: u64,
}
