//! 内存表：`BTreeMap<Key, Entry>`，条目带序号与墓碑。

use std::collections::BTreeMap;
use std::ops::Bound;

use crate::wal::{OpKind, Record};

/// 键与值都是任意字节串；`BTreeMap` 的序就是字节的字典序。
pub type Key = Vec<u8>;

/// 一条键值记录的可见部分：`Put` 带值，`Delete` 是墓碑。
#[derive(Clone, Debug, PartialEq, Eq)]
pub enum EntryKind {
    /// 正常写入的值。
    Put(Vec<u8>),
    /// 删除墓碑。
    Delete,
}

/// memtable 与段文件里的一条逻辑记录。
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Entry {
    /// 全局单调序号，写入时分配。
    pub seq: u64,
    /// 值或墓碑。
    pub kind: EntryKind,
}

impl Entry {
    /// 新建条目。
    pub fn new(seq: u64, kind: EntryKind) -> Self {
        Self { seq, kind }
    }

    /// 是否为墓碑。
    pub fn is_tombstone(&self) -> bool {
        matches!(self.kind, EntryKind::Delete)
    }

    /// 值（墓碑返回 `None`）。
    pub fn value(&self) -> Option<&[u8]> {
        match &self.kind {
            EntryKind::Put(v) => Some(v),
            EntryKind::Delete => None,
        }
    }

    /// 该条目在 memtable 里占用的粗略字节数，用于触发 flush。
    pub fn bytes(&self) -> usize {
        let v = match &self.kind {
            EntryKind::Put(v) => v.len(),
            EntryKind::Delete => 0,
        };
        v + 32
    }
}

/// 单个 memtable；只被写线程修改，读线程在 `RwLock` 共享锁下读取。
#[derive(Default, Debug)]
pub struct Memtable {
    map: BTreeMap<Key, Entry>,
    bytes: usize,
}

impl Memtable {
    /// 空表。
    pub fn new() -> Self {
        Self::default()
    }

    /// 从 WAL 恢复出来的一批记录构建（同 key 以 WAL 中靠后的记录为准）。
    pub fn from_records(records: &[Record]) -> Self {
        let mut t = Self::new();
        for r in records {
            let kind = match r.kind {
                OpKind::Put => EntryKind::Put(r.value.clone()),
                OpKind::Delete => EntryKind::Delete,
            };
            t.insert(&r.key, Entry::new(r.seq, kind));
        }
        t
    }

    /// 插入一条条目；同 key 覆盖（写线程保证 seq 单调递增）。
    pub fn insert(&mut self, key: &[u8], e: Entry) {
        self.bytes += e.bytes();
        if let Some(prev) = self.map.insert(key.to_vec(), e) {
            self.bytes -= prev.bytes();
        }
    }

    /// 当前条目数。
    pub fn len(&self) -> usize {
        self.map.len()
    }

    /// 是否为空表。
    pub fn is_empty(&self) -> bool {
        self.map.is_empty()
    }

    /// 粗略字节占用。
    pub fn bytes(&self) -> usize {
        self.bytes
    }

    /// 查一个键。
    pub fn get(&self, key: &[u8]) -> Option<&Entry> {
        self.map.get(key)
    }

    /// 按键移除。
    pub fn remove(&mut self, key: &[u8]) -> Option<Entry> {
        let prev = self.map.remove(key)?;
        self.bytes -= prev.bytes();
        Some(prev)
    }

    /// 按前缀扫描，返回内部引用（生命周期等于表本身）。
    pub fn scan_prefix(&self, prefix: &[u8]) -> Vec<(&Key, &Entry)> {
        match prefix_end(prefix) {
            Some(end) => self
                .map
                .range((Bound::Included(prefix.to_vec()), Bound::Excluded(end)))
                .collect(),
            None => self
                .map
                .range((Bound::Included(prefix.to_vec()), Bound::Unbounded))
                .collect(),
        }
    }

    /// 有序迭代（flush 与压缩都依赖这个顺序）。
    pub fn iter(&self) -> impl Iterator<Item = (&Key, &Entry)> {
        self.map.iter()
    }
}

/// 前缀的字典序右开上界；`None` 表示前缀已是最大值，右端不设界。
pub(crate) fn prefix_end(prefix: &[u8]) -> Option<Key> {
    let mut k = prefix.to_vec();
    loop {
        match k.last_mut() {
            None => return None,
            Some(last) if *last == 0xFF => {
                k.pop();
            }
            Some(last) => {
                *last += 1;
                return Some(k);
            }
        }
    }
}
