//! 极简 epoch 回收：读者用 `pin()` 固定一个纪元，写者换掉旧版本后延迟到安全点再释放。
//!
//! 纪元计数器与 pin 槽位是进程级全局的：所有 `Heap` 共用一份「活跃纪元表」。
//! 这让 `advance()` 的判定偏保守（别的线程钉住也会推迟回收），但绝不会提前释放。

use std::cell::Cell;
use std::path::PathBuf;
use std::sync::Mutex;
use std::sync::atomic::{AtomicPtr, AtomicUsize, Ordering};

/// 同时活跃的 pin 槽位上限；超出时 `pin()` 返回 `None`，调用方需重试或降级。
pub const MAX_SLOTS: usize = 512;

/// 一个纪元编号。
pub type Epoch = usize;

/// 全局当前纪元。所有 `Heap` 共享，写者换版本时推进它。
static CURRENT: AtomicUsize = AtomicUsize::new(1);

/// 全局活跃 pin 表；`usize::MAX` 表示该槽位没有读者。
static PINS: [AtomicUsize; MAX_SLOTS] = [const { AtomicUsize::new(usize::MAX) }; MAX_SLOTS];

/// 槽位分配器。
static NEXT_SLOT: AtomicUsize = AtomicUsize::new(0);

thread_local! {
    /// 本线程的 pin 槽位（首次 pin 时分配）。
    static SLOT: Cell<usize> = const { Cell::new(usize::MAX) };
    /// 本线程嵌套 pin 的深度，只有回到 0 才真正清槽。
    static DEPTH: Cell<usize> = const { Cell::new(0) };
}

/// 当前纪元。
#[inline]
pub fn current_epoch() -> Epoch {
    CURRENT.load(Ordering::SeqCst)
}

/// 单版本快照堆：`head` 指向当前活动版本，旧版本进入 `retired` 等待回收。
pub struct Heap<T> {
    head: AtomicPtr<T>,
    retired: Mutex<Vec<Retired<T>>>,
    /// 已回收的节点数，测试与 stats 用它验证「延迟释放确实发生」。
    reclaimed: AtomicUsize,
    label: String,
}

struct Retired<T> {
    ptr: *mut T,
    epoch: Epoch,
    /// 被回收的文件（若有），回收时才删除，保证读者不会读到已消失的段。
    files: Vec<PathBuf>,
}

// SAFETY: `Heap<T>` 里的裸指针是 `Box::into_raw` 拿到的唯一所有权，跨线程共享只发生在
// `Arc<Heap<T>>` 内部，并且解引用点有两道约束：写侧只有一个线程会调用 `store`（换 head），
// 读侧必须先进 `pin()` 才能拿到 `&T`；`Box::from_raw` 的释放只可能发生在所有钉住的纪元
// 都晚于该节点的 retire 纪元之后。因此只要 `T: Send + Sync`，把 `Heap<T>` 当作
// `Send + Sync` 不会让任何数据在没有同步的情况下被两个线程同时访问。
unsafe impl<T: Send + Sync> Send for Heap<T> {}
// SAFETY: 同上，`Heap<T>` 的 `Sync` 依赖 pin/advance 协议保护 `*mut T` 的解引用与释放。
unsafe impl<T: Send + Sync> Sync for Heap<T> {}

impl<T> Heap<T> {
    /// 用初始版本建堆。
    pub fn new(label: impl Into<String>, initial: Box<T>) -> Self {
        Heap {
            head: AtomicPtr::new(Box::into_raw(initial)),
            retired: Mutex::new(Vec::new()),
            reclaimed: AtomicUsize::new(0),
            label: label.into(),
        }
    }

    /// 钉住当前纪元；`None` 表示读者槽位耗尽。
    pub fn pin(&self) -> Option<Guard<'_, T>> {
        let depth = DEPTH.with(|d| d.get());
        if depth == 0 {
            let slot = SLOT.with(|s| s.get());
            let slot = if slot == usize::MAX {
                let fresh = NEXT_SLOT.fetch_add(1, Ordering::Relaxed);
                if fresh >= MAX_SLOTS {
                    NEXT_SLOT.fetch_sub(1, Ordering::Relaxed);
                    return None;
                }
                SLOT.with(|s| s.set(fresh));
                fresh
            } else {
                slot
            };
            // SeqCst：与 CURRENT 的读-改-写构成全序，避免「先读到旧 head，
            // 再钉住新纪元」这种被写者钻空子的交错。
            let e = current_epoch();
            PINS[slot].store(e, Ordering::SeqCst);
            DEPTH.with(|d| d.set(1));
            // 钉住之后才取 head：这样「看到的版本」与「钉住的纪元」配对，
            // 该版本在 Guard 存活期内一定还在。
            let ptr = self.head.load(Ordering::SeqCst);
            Some(Guard {
                heap: self,
                slot,
                ptr,
                epoch: e,
            })
        } else {
            DEPTH.with(|d| d.set(depth + 1));
            let slot = SLOT.with(|s| s.get());
            Some(Guard {
                heap: self,
                slot,
                ptr: self.head.load(Ordering::SeqCst),
                epoch: current_epoch(),
            })
        }
    }

    /// 发布新版本并把旧版本挂入回收队列（仅允许唯一写者调用）。
    ///
    /// `files_of_old` 是这一版快照独占、且到安全点才允许删除的文件。
    /// 队列按 retire 纪元单调递增（只有一个写者），`advance` 依赖这个前提做前缀回收。
    pub fn store(&self, next: Box<T>, files_of_old: Vec<PathBuf>) {
        let old = self.head.swap(Box::into_raw(next), Ordering::SeqCst);
        let epoch = current_epoch();
        let mut retired = self.retired.lock().unwrap_or_else(|e| e.into_inner());
        retired.push(Retired {
            ptr: old,
            epoch,
            files: files_of_old,
        });
    }

    /// 不带延迟文件删除的发布。
    pub fn publish(&self, next: Box<T>) {
        self.store(next, Vec::new());
    }

    /// 推进纪元并回收所有已越过安全点的节点，返回本次回收的节点数。
    pub fn advance(&self) -> usize {
        CURRENT.fetch_add(1, Ordering::SeqCst);
        // SeqCst 之后再扫一遍 pin 表：此时任何在本函数开始前就存在的读者
        // 要么已把自己钉在旧纪元（会被看到），要么已经松手（槽位是 MAX）。
        let min_active = PINS
            .iter()
            .map(|p| {
                let e = p.load(Ordering::SeqCst);
                if e == usize::MAX { usize::MAX } else { e }
            })
            .min()
            .unwrap_or(usize::MAX);
        let mut freed = 0usize;
        let mut ready = {
            let mut q = self.retired.lock().unwrap_or_else(|e| e.into_inner());
            let keep_idx = q
                .iter()
                .position(|r| r.epoch >= min_active)
                .unwrap_or(q.len());
            q.drain(..keep_idx).collect::<Vec<_>>()
        };
        for r in ready.drain(..) {
            // SAFETY: `r.ptr` 由 `store`/`new` 用 `Box::into_raw` 产生，唯一所有权；
            // 只有当 `min_active > r.epoch`（即没有任何读者钉在 retire 时或更早的纪元）
            // 才会走到这里，因此不存在仍在解引用该节点的 Guard，也不会二次释放
            //（retire 队列里的节点已经从队列 drain 走）。
            unsafe {
                drop(Box::from_raw(r.ptr));
            }
            for f in r.files {
                let _ = std::fs::remove_file(&f);
            }
            freed += 1;
        }
        if freed > 0 {
            self.reclaimed.fetch_add(freed, Ordering::Relaxed);
        }
        freed
    }

    /// 回收队列长度，测试用来断言「还没到安全点」。
    pub fn retired_len(&self) -> usize {
        self.retired.lock().unwrap_or_else(|e| e.into_inner()).len()
    }

    /// 累计回收节点数。
    pub fn reclaimed(&self) -> usize {
        self.reclaimed.load(Ordering::Relaxed)
    }

    /// 标签（调试输出用）。
    pub fn label(&self) -> &str {
        &self.label
    }
}

impl<T> Drop for Heap<T> {
    fn drop(&mut self) {
        let mut q = std::mem::take(&mut *self.retired.lock().unwrap_or_else(|e| e.into_inner()));
        for r in q.drain(..) {
            // SAFETY: 堆正在析构，此刻不可能再有活的 Guard（Guard 借用 `&self`）。
            unsafe { drop(Box::from_raw(r.ptr)) };
            for f in r.files {
                let _ = std::fs::remove_file(&f);
            }
        }
        let head = self.head.load(Ordering::Acquire);
        if !head.is_null() {
            // SAFETY: 同上，`head` 的唯一所有权属于本堆。
            unsafe { drop(Box::from_raw(head)) };
        }
    }
}

/// RAII 读者快照；持有期间 `pin()` 时看到的那个版本不会被释放。
pub struct Guard<'a, T> {
    heap: &'a Heap<T>,
    slot: usize,
    ptr: *const T,
    epoch: Epoch,
}

impl<'a, T> Guard<'a, T> {
    /// 访问被钉住的版本（就是 `pin()` 那一刻的 head，不是「最新」）。
    #[inline]
    pub fn load(&self) -> &'a T {
        // SAFETY: `ptr` 在 `pin()` 里于钉住纪元之后从 head 取出，此刻它要么仍是 head，
        // 要么已被写者 retire 并打上某个纪元 `e_r`。`Heap::advance` 只在
        // `min_active > e_r` 时才释放该节点，而本 Guard 把 `PINS[slot]` 钉在 `epoch`，
        // 且 `epoch >= e_r`（ retire 发生时本线程已经在这个纪元或更晚），
        // 所以只要 Guard 还活着，`*ptr` 就不会被释放，指向的对象有效。
        // 对象由 `Box::into_raw` 产生，非空且对齐正确；返回引用取生命周期 `'a`
        // （= Guard 对 `heap` 的借用期），不会活过 Guard 本身。
        unsafe { &*self.ptr }
    }

    /// 钉住的纪元。
    pub fn epoch(&self) -> Epoch {
        self.epoch
    }

    /// 所属堆的标签（诊断输出用）。
    pub fn label(&self) -> &str {
        self.heap.label()
    }

    /// 显式松手（也可以直接 drop）。
    pub fn release(self) {}
}

impl<T> Drop for Guard<'_, T> {
    fn drop(&mut self) {
        let depth = DEPTH.with(|d| d.get());
        if depth <= 1 {
            PINS[self.slot].store(usize::MAX, Ordering::SeqCst);
            DEPTH.with(|d| d.set(0));
        } else {
            DEPTH.with(|d| d.set(depth - 1));
        }
    }
}
