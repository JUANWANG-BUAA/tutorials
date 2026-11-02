//! 无锁计数器。每个计数都用 `AtomicU64`，内存序按「这个值是否用来发布别的数据」区分。

use std::sync::atomic::{AtomicU64, Ordering};

/// 全部计数器。写入端只做自增，读取端只做快照，二者没有 happens-before 需求。
///
/// 内存序选择：
/// - 自增一律用 `Relaxed`：这些计数器不用于守护其它内存，只需要「最终求和正确」，
///   `Relaxed` 在 ARM64 上就是 `stadd`，不带屏障；换成 `AcqRel` 会白白插 `dmb ish`。
/// - 快照读取一律用 `Relaxed`：计数器之间不要求互相一致，同一时刻的不同计数器
///   本来就允许差一拍（这是所有监控计数器的通例）。
/// - 唯一带同步意义的量是「已应用序号」`applied`，它要发布 memtable 里新写入的
///   条目，所以写端 `Release`、等待端 `Acquire`（见 `engine::Writer::ack`）。
#[derive(Debug, Default)]
pub struct Counters {
    /// 提交进准入队列的写请求数。
    pub put: AtomicU64,
    /// 读请求数。
    pub get: AtomicU64,
    /// 读命中。
    pub get_hit: AtomicU64,
    /// 读未命中。
    pub get_miss: AtomicU64,
    /// 布隆判定「可能存在」从而进入二分查找的次数。
    pub bloom_hit: AtomicU64,
    /// 布隆直接判负、省掉二分查找的次数。
    pub bloom_reject: AtomicU64,
    /// flush 次数。
    pub flush: AtomicU64,
    /// 压缩次数。
    pub compact: AtomicU64,
    /// 准入队列满被拒绝的写请求数。
    pub admission_reject: AtomicU64,
    /// epoch 回收掉的快照版本数。
    pub reclaim: AtomicU64,
    /// 布隆桶溢出（容量估计过小）次数。
    pub bloom_overflow: AtomicU64,
    /// 落盘字节数。
    pub bytes_flushed: AtomicU64,
    /// 崩溃恢复时拒绝的尾部 WAL 记录数。
    pub wal_rejected: AtomicU64,
}

/// 计数器快照（可打印、可比较）。
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct Stats {
    /// 提交进准入队列的写请求数。
    pub put: u64,
    /// 读请求数。
    pub get: u64,
    /// 读命中数。
    pub get_hit: u64,
    /// 读未命中数。
    pub get_miss: u64,
    /// 布隆放行、继续做二分的次数。
    pub bloom_hit: u64,
    /// 布隆判负、省掉二分的次数。
    pub bloom_reject: u64,
    /// flush 次数。
    pub flush: u64,
    /// 压缩次数。
    pub compact: u64,
    /// 准入队列满被拒绝的写请求数。
    pub admission_reject: u64,
    /// epoch 回收掉的快照版本数。
    pub reclaim: u64,
    /// 布隆桶溢出次数。
    pub bloom_overflow: u64,
    /// 落盘字节数。
    pub bytes_flushed: u64,
    /// 崩溃恢复时拒绝的 WAL 记录数。
    pub wal_rejected: u64,
}

impl Counters {
    /// 把全部计数器加到 `delta`。
    #[inline]
    fn bump(c: &AtomicU64, delta: u64) {
        c.fetch_add(delta, Ordering::Relaxed);
    }

    /// 一次读请求 +1。
    pub fn add_get(&self, n: u64) {
        Self::bump(&self.get, n);
    }

    /// 读命中 +1。
    pub fn add_get_hit(&self, n: u64) {
        Self::bump(&self.get_hit, n);
    }

    /// 读未命中 +1。
    pub fn add_get_miss(&self, n: u64) {
        Self::bump(&self.get_miss, n);
    }

    /// 布隆放行 +1。
    pub fn add_bloom_hit(&self, n: u64) {
        Self::bump(&self.bloom_hit, n);
    }

    /// 布隆判负 +1。
    pub fn add_bloom_reject(&self, n: u64) {
        Self::bump(&self.bloom_reject, n);
    }

    /// 写提交 +1。
    pub fn add_put(&self, n: u64) {
        Self::bump(&self.put, n);
    }

    /// flush +1。
    pub fn add_flush(&self, n: u64) {
        Self::bump(&self.flush, n);
    }

    /// 压缩 +1。
    pub fn add_compact(&self, n: u64) {
        Self::bump(&self.compact, n);
    }

    /// 准入拒绝 +1。
    pub fn add_admission_reject(&self, n: u64) {
        Self::bump(&self.admission_reject, n);
    }

    /// 回收 +1。
    pub fn add_reclaim(&self, n: u64) {
        Self::bump(&self.reclaim, n);
    }

    /// 布隆桶溢出 +1。
    pub fn add_bloom_overflow(&self, n: u64) {
        Self::bump(&self.bloom_overflow, n);
    }

    /// 落盘字节累加。
    pub fn add_bytes_flushed(&self, n: u64) {
        Self::bump(&self.bytes_flushed, n);
    }

    /// WAL 拒绝记录累加。
    pub fn add_wal_rejected(&self, n: u64) {
        Self::bump(&self.wal_rejected, n);
    }

    /// 取快照：`Relaxed`，理由见类型注释。
    pub fn snapshot(&self) -> Stats {
        Stats {
            put: self.put.load(Ordering::Relaxed),
            get: self.get.load(Ordering::Relaxed),
            get_hit: self.get_hit.load(Ordering::Relaxed),
            get_miss: self.get_miss.load(Ordering::Relaxed),
            bloom_hit: self.bloom_hit.load(Ordering::Relaxed),
            bloom_reject: self.bloom_reject.load(Ordering::Relaxed),
            flush: self.flush.load(Ordering::Relaxed),
            compact: self.compact.load(Ordering::Relaxed),
            admission_reject: self.admission_reject.load(Ordering::Relaxed),
            reclaim: self.reclaim.load(Ordering::Relaxed),
            bloom_overflow: self.bloom_overflow.load(Ordering::Relaxed),
            bytes_flushed: self.bytes_flushed.load(Ordering::Relaxed),
            wal_rejected: self.wal_rejected.load(Ordering::Relaxed),
        }
    }
}

impl Stats {
    /// 布隆判负占比（0.0 表示还没有 miss 查询）。
    pub fn bloom_reject_rate(&self) -> f64 {
        let probes = self.bloom_hit + self.bloom_reject;
        if probes == 0 {
            0.0
        } else {
            self.bloom_reject as f64 / probes as f64
        }
    }
}
