//! tidekv：单写多读的本地键值引擎，WAL + memtable + 不可变段 + 布隆 + 子进程压缩 + epoch 回收。
//!
//! 只依赖 `std`：`crates.io` 在本机的缓存不可假设可用，全书的实验包都按离线约束写。
#![warn(missing_docs)]

pub mod bloom;
pub mod codec;
pub mod crc32;
pub mod engine;
pub mod epoch;
pub mod ipc;
pub mod memtable;
pub mod segment;
pub mod stats;
pub mod testutil;
pub mod wal;

pub use codec::{Codec, CodecRecord, FixedCodec};
pub use engine::{
    CompactReport, Config, Lookup, SegmentList, Snapshot, Tide, TideError, TideResult,
};
pub use epoch::{Guard, Heap};
pub use memtable::{Entry, EntryKind, Memtable};
pub use segment::{Segment, SegmentInfo};
pub use stats::Stats;
pub use wal::{OpKind, Record};
