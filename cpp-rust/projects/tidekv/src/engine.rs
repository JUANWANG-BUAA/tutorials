//! 引擎：单写线程 + 多读快照。写走有界准入队列，读走 epoch 钉住的段列表快照。

use std::collections::VecDeque;
use std::fs;
use std::io;
use std::path::{Path, PathBuf};
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::sync::mpsc::{self, Sender};
use std::sync::{Arc, Condvar, Mutex, RwLock, RwLockReadGuard};
use std::thread::{self, JoinHandle};

use crate::bloom::DEFAULT_BYTES_PER_KEY;
use crate::epoch::{Guard, Heap};
use crate::ipc::{self, CompactJob};
use crate::memtable::{Entry, EntryKind, Memtable};
use crate::segment::{Segment, SegmentInfo, segment_name, write_segment};
use crate::stats::{Counters, Stats};
use crate::wal::{self, OpKind, Record, Recovery, Wal};

/// 引擎错误。
#[derive(Debug)]
pub enum TideError {
    /// 底层 IO 错误。
    Io(io::Error),
    /// 准入队列已满：写请求被立刻拒绝，既不阻塞也不排到无界。
    AdmissionRejected {
        /// 当时的容量上限。
        capacity: usize,
        /// 拒绝时的队列长度。
        queued: usize,
    },
    /// 段文件/WAL 内容损坏。
    Corrupt(String),
    /// 压缩子进程失败。
    Compaction(String),
    /// 引擎已关闭。
    Shutdown,
    /// 写线程此前记录过一个致命错误。
    Writer(String),
}

impl std::fmt::Display for TideError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            TideError::Io(e) => write!(f, "io: {e}"),
            TideError::AdmissionRejected { capacity, queued } => {
                write!(f, "admission rejected: {queued}/{capacity} queued")
            }
            TideError::Corrupt(s) => write!(f, "corrupt: {s}"),
            TideError::Compaction(s) => write!(f, "compaction: {s}"),
            TideError::Shutdown => write!(f, "engine shutdown"),
            TideError::Writer(s) => write!(f, "writer failed: {s}"),
        }
    }
}

impl std::error::Error for TideError {}

impl From<io::Error> for TideError {
    fn from(e: io::Error) -> Self {
        TideError::Io(e)
    }
}

/// 引擎返回的统一 `Result`。
pub type TideResult<T> = Result<T, TideError>;

/// 配置。
#[derive(Clone, Debug)]
pub struct Config {
    /// 数据目录。
    pub dir: PathBuf,
    /// memtable 粗略字节数达到该值就自动 flush。
    pub memtable_flush_bytes: usize,
    /// 有界准入队列容量。
    pub admission_capacity: usize,
    /// 每键布隆字节数。
    pub bytes_per_key: usize,
    /// `sync()` 是否对 WAL 做 `fsync`。
    pub durable: bool,
}

impl Config {
    /// 默认配置：64 KiB memtable、1024 深度准入队列、每键 8 字节布隆、`sync` 不 fsync。
    pub fn new(dir: impl Into<PathBuf>) -> Self {
        Config {
            dir: dir.into(),
            memtable_flush_bytes: 64 * 1024,
            admission_capacity: 1024,
            bytes_per_key: DEFAULT_BYTES_PER_KEY,
            durable: false,
        }
    }
}

/// 读者可见的不可变版本：段列表（新→旧）+ 尚未进段的冻结表（新→旧）。
#[derive(Clone, Default)]
pub struct SegmentList {
    /// 按内容年龄从新到旧排列的段。
    pub segments: Vec<Arc<Segment>>,
    /// 已换出活动表、但段文件还没写完的 memtable，新→旧。
    pub frozen: Vec<Arc<Memtable>>,
}

impl SegmentList {
    /// 段数量。
    pub fn segment_count(&self) -> usize {
        self.segments.len()
    }
}

/// 一次读命中的零拷贝视图；`value` 为 `None` 表示被墓碑遮住。
#[derive(Clone, Copy, Debug)]
pub struct Lookup<'a> {
    /// 条目序号。
    pub seq: u64,
    /// 借用自 memtable/段缓冲的值字节。
    pub value: Option<&'a [u8]>,
}

/// 压缩报告。
#[derive(Clone, Debug)]
pub struct CompactReport {
    /// 输入段。
    pub inputs: Vec<SegmentInfo>,
    /// 输出段。
    pub output: SegmentInfo,
    /// 被丢弃的墓碑数（由子进程报告）。
    pub dropped_tombstones: u64,
    /// 执行者。
    pub via: &'static str,
}

enum Cmd {
    Write(Record),
    Flush(Sender<TideResult<Option<SegmentInfo>>>),
    Compact(Sender<TideResult<Option<CompactReport>>>),
    Sync(Sender<TideResult<()>>),
    Shutdown,
}

struct Shared {
    cfg: Config,
    mem: RwLock<Memtable>,
    heap: Heap<SegmentList>,
    counters: Counters,
    next_seq: AtomicU64,
    submitted: AtomicU64,
    applied: (Mutex<u64>, Condvar),
    queue: (Mutex<VecDeque<Cmd>>, Condvar),
    closed: AtomicBool,
    failure: Mutex<Option<String>>,
}

/// 引擎句柄；内部 `Arc`，可以自由 clone 到多个线程。
pub struct Tide {
    shared: Arc<Shared>,
    writer: Mutex<Option<JoinHandle<()>>>,
}

impl Tide {
    /// 打开（或创建）引擎目录；崩溃恢复在此完成，第二项返回值是 WAL 恢复统计。
    pub fn open(cfg: Config) -> TideResult<(Tide, Recovery)> {
        fs::create_dir_all(&cfg.dir)?;
        let wal_path = cfg.dir.join("tide.wal");
        let rec = wal::recover(&wal_path)?;
        let mem = Memtable::from_records(&rec.records);
        let mut max_seq = rec.records.iter().map(|r| r.seq).max().unwrap_or(0);

        let mut on_disk: Vec<(u64, PathBuf)> = Vec::new();
        for entry in fs::read_dir(&cfg.dir)? {
            let p = entry?.path();
            if p.extension().and_then(|s| s.to_str()) == Some("tide") {
                let id = p
                    .file_stem()
                    .and_then(|s| s.to_str())
                    .and_then(|s| s.trim_start_matches("seg-").parse::<u64>().ok())
                    .unwrap_or(0);
                on_disk.push((id, p));
            }
        }
        on_disk.sort_by_key(|entry| std::cmp::Reverse(entry.0));
        let mut list = SegmentList::default();
        for (_, p) in &on_disk {
            let seg = Segment::open(p).map_err(|e| TideError::Corrupt(format!("{p:?}: {e}")))?;
            max_seq = max_seq.max(seg.max_seq());
            list.segments.push(Arc::new(seg));
        }

        let wal = Wal::open(&wal_path)?;
        let shared = Arc::new(Shared {
            cfg: cfg.clone(),
            mem: RwLock::new(mem),
            heap: Heap::new("segments", Box::new(list)),
            counters: Counters::default(),
            next_seq: AtomicU64::new(max_seq + 1),
            submitted: AtomicU64::new(max_seq),
            applied: (Mutex::new(max_seq), Condvar::new()),
            queue: (Mutex::new(VecDeque::new()), Condvar::new()),
            closed: AtomicBool::new(false),
            failure: Mutex::new(None),
        });
        shared
            .counters
            .add_wal_rejected(rec.rejected_records as u64);
        if rec.discarded_bytes > 0 {
            wal::truncate_to(&wal_path, rec.valid_bytes)?;
        }
        let h = thread::spawn({
            let shared = shared.clone();
            move || writer_loop(shared, wal)
        });
        Ok((
            Tide {
                shared,
                writer: Mutex::new(Some(h)),
            },
            rec,
        ))
    }

    /// 打开引擎并只要句柄。
    pub fn open_engine(cfg: Config) -> TideResult<Tide> {
        Ok(Self::open(cfg)?.0)
    }

    /// 数据目录。
    pub fn dir(&self) -> &Path {
        &self.shared.cfg.dir
    }

    fn submit(&self, cmd: Cmd) -> TideResult<()> {
        let shared = &self.shared;
        let mut q = shared.queue.0.lock().unwrap_or_else(|e| e.into_inner());
        if shared.closed.load(Ordering::Acquire) {
            return Err(TideError::Shutdown);
        }
        if q.len() >= shared.cfg.admission_capacity {
            let queued = q.len();
            shared.counters.add_admission_reject(1);
            return Err(TideError::AdmissionRejected {
                capacity: shared.cfg.admission_capacity,
                queued,
            });
        }
        q.push_back(cmd);
        shared.queue.1.notify_one();
        Ok(())
    }

    /// 写入一个键，返回分配的序号。不阻塞：进有界队列，队列满立刻
    /// `Err(TideError::AdmissionRejected)`。想读到自己的写用 [`Tide::await_seq`] 或 [`Tide::sync`]。
    pub fn put(&self, key: &[u8], value: &[u8]) -> TideResult<u64> {
        self.write(Record {
            seq: self.assign(),
            kind: OpKind::Put,
            key: key.to_vec(),
            value: value.to_vec(),
        })
    }

    /// 删除一个键（写墓碑）。
    pub fn delete(&self, key: &[u8]) -> TideResult<u64> {
        self.write(Record {
            seq: self.assign(),
            kind: OpKind::Delete,
            key: key.to_vec(),
            value: Vec::new(),
        })
    }

    fn assign(&self) -> u64 {
        self.shared.next_seq.fetch_add(1, Ordering::Relaxed)
    }

    fn write(&self, rec: Record) -> TideResult<u64> {
        let seq = rec.seq;
        self.shared.counters.add_put(1);
        // 只有真的进队了才推进 `submitted`：否则被拒的序号会把 `await_seq`
        // 永远吊在半空（它等的那个序号根本不会有人去应用）。
        self.submit(Cmd::Write(rec))?;
        self.shared.submitted.fetch_max(seq + 1, Ordering::AcqRel);
        Ok(seq)
    }

    /// 阻塞直到序号 `seq` 及其之前的写全部落到 memtable。
    ///
    /// 等待走互斥量；写线程是先释放 memtable 写锁、后更新 `applied`，
    /// 所以本函数返回之后再取读锁，一定看得见这些写。
    pub fn await_seq(&self, seq: u64) -> TideResult<()> {
        self.check_failure()?;
        let shared = &self.shared;
        let mut g = shared.applied.0.lock().unwrap_or_else(|e| e.into_inner());
        while *g < seq {
            if shared.closed.load(Ordering::Acquire) {
                return Err(TideError::Shutdown);
            }
            g = shared
                .applied
                .1
                .wait_timeout(g, std::time::Duration::from_millis(50))
                .unwrap_or_else(|e| e.into_inner())
                .0;
        }
        Ok(())
    }

    /// 排空在途写并把 WAL 刷到 OS（`durable` 为真时再 `fsync`）。
    pub fn sync(&self) -> TideResult<()> {
        let target = self.shared.submitted.load(Ordering::Acquire);
        if target > 0 {
            self.await_seq(target - 1)?;
        }
        let (tx, rx) = mpsc::channel();
        self.submit(Cmd::Sync(tx))?;
        rx.recv().map_err(|_| TideError::Shutdown)?
    }

    /// 把当前 memtable 落成一个段文件；空表返回 `Ok(None)`。
    pub fn flush(&self) -> TideResult<Option<SegmentInfo>> {
        let target = self.shared.submitted.load(Ordering::Acquire);
        if target > 0 {
            self.await_seq(target - 1)?;
        }
        let (tx, rx) = mpsc::channel();
        self.submit(Cmd::Flush(tx))?;
        rx.recv().map_err(|_| TideError::Shutdown)?
    }

    /// 合并最老的两个段（子进程执行）；不足两段返回 `Ok(None)`。
    pub fn compact_two(&self) -> TideResult<Option<CompactReport>> {
        let (tx, rx) = mpsc::channel();
        self.submit(Cmd::Compact(tx))?;
        rx.recv().map_err(|_| TideError::Shutdown)?
    }

    /// 钉住一个只读快照；`None` 表示读者槽位耗尽（[`crate::epoch::MAX_SLOTS`]）。
    pub fn snapshot(&self) -> Option<Snapshot<'_>> {
        let shared = &self.shared;
        shared.counters.add_get(1);
        let segs: Guard<'_, SegmentList> = shared.heap.pin()?;
        Some(Snapshot {
            mem: shared.mem.read().unwrap_or_else(|e| e.into_inner()),
            segs,
            counters: &shared.counters,
        })
    }

    /// 拥有所有权的读；不存在或被墓碑遮住时返回 `None`。
    pub fn get(&self, key: &[u8]) -> TideResult<Option<Vec<u8>>> {
        let snap = self.snapshot().ok_or(TideError::Shutdown)?;
        Ok(snap.get_owned(key))
    }

    /// 一次读，同时返回序号（测试与基准用它验证语义）。
    pub fn get_with_seq(&self, key: &[u8]) -> TideResult<Option<(u64, Vec<u8>)>> {
        let snap = self.snapshot().ok_or(TideError::Shutdown)?;
        Ok(snap
            .get(key)
            .and_then(|l| l.value.map(|v| (l.seq, v.to_vec()))))
    }

    /// 按前缀扫描，返回升序、跳过墓碑的 `(key, value)`。
    pub fn scan_prefix(&self, prefix: &[u8]) -> TideResult<Vec<(Vec<u8>, Vec<u8>)>> {
        let snap = self.snapshot().ok_or(TideError::Shutdown)?;
        Ok(snap.scan_prefix(prefix))
    }

    /// 计数器快照。
    pub fn stats(&self) -> Stats {
        self.shared.counters.snapshot()
    }

    /// 当前段列表（新→旧）。
    pub fn segments(&self) -> Vec<SegmentInfo> {
        match self.shared.heap.pin() {
            Some(g) => g.load().segments.iter().map(|s| s.info().clone()).collect(),
            None => Vec::new(),
        }
    }

    /// 待落段的冻结表数量。
    pub fn frozen_tables(&self) -> usize {
        match self.shared.heap.pin() {
            Some(g) => g.load().frozen.len(),
            None => 0,
        }
    }

    /// 驱动一次 epoch 回收，返回本次释放的版本数。
    pub fn advance_epoch(&self) -> usize {
        let n = self.shared.heap.advance();
        self.shared.counters.add_reclaim(n as u64);
        n
    }

    /// 回收队列长度。
    pub fn pending_reclaim(&self) -> usize {
        self.shared.heap.retired_len()
    }

    /// 恢复阶段被拒绝的 WAL 记录数。
    pub fn wal_rejected(&self) -> u64 {
        self.shared.counters.snapshot().wal_rejected
    }

    fn check_failure(&self) -> TideResult<()> {
        let g = self
            .shared
            .failure
            .lock()
            .unwrap_or_else(|e| e.into_inner());
        match &*g {
            Some(s) => Err(TideError::Writer(s.clone())),
            None => Ok(()),
        }
    }

    /// 关闭写线程并 join；`Tide` 被 drop 时也会自动执行。
    pub fn close(&self) -> TideResult<()> {
        {
            let mut q = self
                .shared
                .queue
                .0
                .lock()
                .unwrap_or_else(|e| e.into_inner());
            q.push_back(Cmd::Shutdown);
            self.shared.queue.1.notify_all();
        }
        let h = self.writer.lock().unwrap_or_else(|e| e.into_inner()).take();
        self.shared.closed.store(true, Ordering::Release);
        if let Some(h) = h {
            let _ = h.join();
        }
        self.check_failure()
    }
}

impl Drop for Tide {
    fn drop(&mut self) {
        let _ = self.close();
    }
}

/// epoch 钉住的只读快照：借用写线程的读锁与段缓冲，读路径零拷贝。
pub struct Snapshot<'a> {
    mem: RwLockReadGuard<'a, Memtable>,
    segs: Guard<'a, SegmentList>,
    counters: &'a Counters,
}

impl<'a> Snapshot<'a> {
    /// 零拷贝读：返回的字节借用自活动 memtable、冻结表或段缓冲，
    /// 生命周期不超过本快照；快照存活期间写线程拿不到 memtable 写锁，
    /// 段列表版本也被 epoch 钉住，所以指针不会失效。
    pub fn get(&self, key: &[u8]) -> Option<Lookup<'_>> {
        if let Some(e) = self.mem.get(key) {
            self.counters.add_get_hit(1);
            return Some(Lookup {
                seq: e.seq,
                value: e.value(),
            });
        }
        for t in self.segs.load().frozen.iter() {
            if let Some(e) = t.get(key) {
                self.counters.add_get_hit(1);
                return Some(Lookup {
                    seq: e.seq,
                    value: e.value(),
                });
            }
        }
        for s in self.segs.load().segments.iter() {
            if !s.bloom_maybe_contains(key) {
                self.counters.add_bloom_reject(1);
                continue;
            }
            self.counters.add_bloom_hit(1);
            if let Some(l) = s.get_no_bloom(key) {
                if l.is_tombstone() {
                    self.counters.add_get_miss(1);
                } else {
                    self.counters.add_get_hit(1);
                }
                return Some(Lookup {
                    seq: l.seq,
                    value: l.value,
                });
            }
        }
        self.counters.add_get_miss(1);
        None
    }

    /// 读值并拷出；墓碑与不存在都返回 `None`。
    pub fn get_owned(&self, key: &[u8]) -> Option<Vec<u8>> {
        self.get(key).and_then(|l| l.value.map(|v| v.to_vec()))
    }

    /// 前缀扫描（升序、跳过墓碑）。
    pub fn scan_prefix(&self, prefix: &[u8]) -> Vec<(Vec<u8>, Vec<u8>)> {
        // 每一层都可能带同一个键的不同版本，按序号最大者胜出，最后丢掉墓碑。
        let mut merged: std::collections::BTreeMap<Vec<u8>, (u64, Option<Vec<u8>>)> =
            std::collections::BTreeMap::new();
        for (k, e) in self.mem.scan_prefix(prefix) {
            absorb(&mut merged, k, e.seq, e.value());
        }
        for t in self.segs.load().frozen.iter() {
            for (k, e) in t.scan_prefix(prefix) {
                absorb(&mut merged, k, e.seq, e.value());
            }
        }
        for s in self.segs.load().segments.iter() {
            for (k, e) in s.scan_prefix(prefix) {
                absorb(&mut merged, &k, e.seq, e.value());
            }
        }
        merged
            .into_iter()
            .filter_map(|(k, (_seq, v))| v.map(|v| (k, v)))
            .collect()
    }

    /// 段数量（测试断言用）。
    pub fn segment_count(&self) -> usize {
        self.segs.load().segments.len()
    }

    /// 显式释放快照（等价于 drop）。
    pub fn release(self) {}
}

/// 写线程主体：唯一的 memtable/WAL/段列表修改者。
fn writer_loop(shared: Arc<Shared>, mut wal: Wal) {
    // 写者持有一份权威副本，只负责发布；读侧永远通过 epoch 快照访问。
    let mut state = match shared.heap.pin() {
        Some(g) => g.load().clone(),
        None => SegmentList::default(),
    };
    let mut next_id = state
        .segments
        .iter()
        .map(|s| s.info().id)
        .max()
        .unwrap_or(0)
        + 1;
    loop {
        let batch = take_batch(&shared);
        let mut fatal: Option<String> = None;
        for cmd in batch {
            match cmd {
                Cmd::Write(rec) => {
                    if let Err(e) = apply_write(&shared, &mut wal, &rec) {
                        fatal = Some(e.to_string());
                    }
                }
                Cmd::Flush(tx) => {
                    let res = do_flush(&shared, &mut wal, &mut state, &mut next_id);
                    if let Err(e) = &res {
                        fatal = Some(e.to_string());
                    }
                    let _ = tx.send(res);
                }
                Cmd::Compact(tx) => {
                    let res = do_compact(&shared, &mut state);
                    if let Err(e) = &res {
                        fatal = Some(e.to_string());
                    }
                    let _ = tx.send(res);
                }
                Cmd::Sync(tx) => {
                    let res = wal.sync_to(shared.cfg.durable).map_err(TideError::Io);
                    if let Err(e) = &res {
                        fatal = Some(e.to_string());
                    }
                    let _ = tx.send(res);
                }
                Cmd::Shutdown => {
                    shutdown(&shared, &mut wal);
                    return;
                }
            }
            if fatal.is_some() {
                break;
            }
            let need_flush = {
                let m = shared.mem.read().unwrap_or_else(|e| e.into_inner());
                m.bytes() >= shared.cfg.memtable_flush_bytes
            };
            if need_flush {
                if let Err(e) = do_flush(&shared, &mut wal, &mut state, &mut next_id) {
                    fatal = Some(e.to_string());
                    break;
                }
            }
        }
        if let Some(msg) = fatal {
            let mut g = shared.failure.lock().unwrap_or_else(|e| e.into_inner());
            g.get_or_insert_with(|| msg);
            shared.closed.store(true, Ordering::Release);
            return;
        }
    }
}

fn take_batch(shared: &Arc<Shared>) -> Vec<Cmd> {
    let mut q = shared.queue.0.lock().unwrap_or_else(|e| e.into_inner());
    while q.is_empty() {
        if shared.closed.load(Ordering::Acquire) {
            return vec![Cmd::Shutdown];
        }
        q = shared
            .queue
            .1
            .wait_timeout(q, std::time::Duration::from_millis(20))
            .unwrap_or_else(|e| e.into_inner())
            .0;
    }
    let n = q.len().min(256);
    q.drain(..n).collect()
}

fn apply_write(shared: &Arc<Shared>, wal: &mut Wal, rec: &Record) -> TideResult<()> {
    wal.append(rec)?;
    let e = Entry::new(
        rec.seq,
        match rec.kind {
            OpKind::Put => EntryKind::Put(rec.value.clone()),
            OpKind::Delete => EntryKind::Delete,
        },
    );
    {
        let mut m = shared.mem.write().unwrap_or_else(|p| p.into_inner());
        m.insert(&rec.key, e);
    }
    let mut g = shared.applied.0.lock().unwrap_or_else(|e| e.into_inner());
    if rec.seq > *g {
        *g = rec.seq;
    }
    shared.applied.1.notify_all();
    Ok(())
}

/// 把活动 memtable 落成段文件。换表时先把旧表挂进 `frozen` 并发布，
/// 段文件写完后再移到 `segments`，读者不会在中间丢数据。
fn do_flush(
    shared: &Arc<Shared>,
    wal: &mut Wal,
    state: &mut SegmentList,
    next_id: &mut u64,
) -> TideResult<Option<SegmentInfo>> {
    let mark = wal.len();
    let taken = {
        let mut m = shared.mem.write().unwrap_or_else(|p| p.into_inner());
        if m.is_empty() {
            return Ok(None);
        }
        Arc::new(std::mem::take(&mut *m))
    };
    state.frozen.insert(0, taken.clone());
    publish(shared, state);
    let id = *next_id;
    *next_id += 1;
    let path = shared.cfg.dir.join(segment_name(id));
    let refs: Vec<(&[u8], &Entry)> = taken.iter().map(|(k, e)| (k.as_slice(), e)).collect();
    let info = write_segment(&path, id, &refs, shared.cfg.bytes_per_key)?;
    let seg = Arc::new(Segment::open(&path)?);
    state.frozen.retain(|t| !Arc::ptr_eq(t, &taken));
    state.segments.insert(0, seg);
    publish(shared, state);
    wal.rotate_keeping(mark)?;
    shared.counters.add_flush(1);
    shared.counters.add_bytes_flushed(info.bytes);
    let _ = shared.heap.advance();
    Ok(Some(info))
}

/// 合并最老的两个段：子进程执行；旧段文件的删除排到安全点之后。
fn do_compact(shared: &Arc<Shared>, state: &mut SegmentList) -> TideResult<Option<CompactReport>> {
    if state.segments.len() < 2 {
        return Ok(None);
    }
    let n = state.segments.len();
    let young = n - 2;
    let a = state.segments[young].clone();
    let b = state.segments[n - 1].clone();
    let out_id = state
        .segments
        .iter()
        .map(|s| s.info().id)
        .max()
        .unwrap_or(0)
        + 1;
    let out_path = shared.cfg.dir.join(segment_name(out_id));
    let job = CompactJob {
        out: out_path.clone(),
        inputs: vec![a.info().path.clone(), b.info().path.clone()],
        // 输入一定是「最老的两个」，被墓碑遮住的更老值只可能落在这两个输入里，
        // 所以合并输出可以直接丢掉墓碑。
        drop_tombstones: true,
        bytes_per_key: shared.cfg.bytes_per_key,
    };
    let res = ipc::spawn_compactor(&job).map_err(|e| TideError::Compaction(e.to_string()))?;
    let seg = Arc::new(
        Segment::open(&res.out).map_err(|e| TideError::Corrupt(format!("{:?}: {e}", res.out)))?,
    );
    let inputs = vec![a.info().clone(), b.info().clone()];
    let old_files = vec![a.info().path.clone(), b.info().path.clone()];
    let mut keep: Vec<Arc<Segment>> = Vec::with_capacity(n - 1);
    for (i, s) in state.segments.iter().enumerate() {
        if i != young && i != n - 1 {
            keep.push(s.clone());
        }
    }
    keep.insert(young, seg);
    state.segments = keep;
    shared.heap.store(Box::new(state.clone()), old_files);
    shared.counters.add_compact(1);
    shared.counters.add_bytes_flushed(res.bytes);
    let _ = shared.heap.advance();
    Ok(Some(CompactReport {
        inputs,
        output: SegmentInfo {
            id: out_id,
            path: out_path,
            entries: res.entries as usize,
            bytes: res.bytes,
            keys: res.entries as usize,
        },
        dropped_tombstones: res.dropped_tombstones,
        via: "tide-compactor",
    }))
}

fn publish(shared: &Arc<Shared>, state: &SegmentList) {
    shared.heap.publish(Box::new(state.clone()));
}

/// 把一层里的键版本并入 `merged`：序号大者胜出。
fn absorb(
    merged: &mut std::collections::BTreeMap<Vec<u8>, (u64, Option<Vec<u8>>)>,
    k: &[u8],
    seq: u64,
    v: Option<&[u8]>,
) {
    match merged.get(k) {
        Some((s, _)) if *s >= seq => {}
        _ => {
            merged.insert(k.to_vec(), (seq, v.map(|b| b.to_vec())));
        }
    }
}

/// 退出前把 WAL 落盘，并给还排在队列里的控制命令回一个 `Shutdown`，
/// 避免调用方卡在 `recv()` 上。
fn shutdown(shared: &Arc<Shared>, wal: &mut Wal) {
    let _ = wal.sync_to(true);
    shared.closed.store(true, Ordering::Release);
    {
        let mut q = shared.queue.0.lock().unwrap_or_else(|e| e.into_inner());
        while let Some(c) = q.pop_front() {
            match c {
                Cmd::Flush(tx) => {
                    let _ = tx.send(Err(TideError::Shutdown));
                }
                Cmd::Compact(tx) => {
                    let _ = tx.send(Err(TideError::Shutdown));
                }
                Cmd::Sync(tx) => {
                    let _ = tx.send(Err(TideError::Shutdown));
                }
                Cmd::Write(_) | Cmd::Shutdown => {}
            }
        }
    }
    shared.queue.1.notify_all();
    shared.applied.1.notify_all();
}
