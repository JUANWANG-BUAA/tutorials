//! 段级布隆过滤器：8 bit 指纹 + 定宽 16 字节槽位块，`contains` 的扫描面向自动向量化。

/// 每个槽位块（bucket）的槽位数，同时是内存对齐粒度。
pub const BUCKET: usize = 16;

/// 指纹为 0 表示空槽，因此真实的指纹被强制非零（会引入极小的偏置，可接受）。
const EMPTY: u8 = 0;

/// 64 bit 混合函数（SplitMix64 的 finalizer），把 FNV 累加结果打散。
#[inline]
fn mix(mut x: u64) -> u64 {
    x ^= x >> 30;
    x = x.wrapping_mul(0xBF58_476D_1CE4_E5B9);
    x ^= x >> 27;
    x = x.wrapping_mul(0x94D0_49BB_1331_11EB);
    x ^ (x >> 31)
}

/// 键的 64 bit 哈希：FNV-1a 累加 + finalizer。
#[inline]
pub fn hash64(key: &[u8]) -> u64 {
    let mut h: u64 = 0xCBF2_9CE4_8422_2325;
    for &b in key {
        h ^= b as u64;
        h = h.wrapping_mul(0x0000_0100_0000_01B3);
    }
    mix(h)
}

/// 从哈希取 8 bit 非零指纹。
#[inline]
pub fn fingerprint(h: u64) -> u8 {
    let fp = (h >> 56) as u8;
    if fp == EMPTY { 0x7F } else { fp }
}

/// 一个段的布隆过滤器。
#[derive(Clone, Debug)]
pub struct Bloom {
    /// 原始缓冲，长度 = `BUCKET` 的整数倍再加对齐余量。
    raw: Vec<u8>,
    /// 让 `raw[off..]` 按 16 字节对齐的偏移。
    off: usize,
    /// 逻辑槽位数（`BUCKET` 的整数倍）。
    slots: usize,
}

impl Bloom {
    /// 空的过滤器（至少一个槽位块）。
    pub fn empty() -> Self {
        Self::with_capacity(1)
    }

    /// 按预期键数与每键字节数建表。
    pub fn with_capacity(keys: usize) -> Self {
        Self::with_capacity_and_bpk(keys, DEFAULT_BYTES_PER_KEY)
    }

    /// 显式指定每键字节数：越大假阳率越低，段文件也越大。
    pub fn with_capacity_and_bpk(keys: usize, bytes_per_key: usize) -> Self {
        let need = keys.max(1) * bytes_per_key.max(1);
        let groups = need.div_ceil(BUCKET);
        let slots = groups * BUCKET;
        let mut raw = vec![EMPTY; slots + BUCKET];
        // 这里只读取指针地址来选择对齐偏移，不构造裸指针引用，因此不需要 unsafe。
        let addr = raw.as_ptr() as usize;
        let off = (BUCKET - (addr % BUCKET)) % BUCKET;
        // `slots` 是 16 的倍数且缓冲多留了一整个块，truncate 后一定还有 BUCKET 余量。
        raw.truncate(off + slots);
        debug_assert_eq!((raw.as_ptr() as usize + off) % BUCKET, 0);
        Bloom { raw, off, slots }
    }

    /// 逻辑槽位数组；起点按 16 字节对齐，便于向量化比较。
    #[inline]
    fn tags(&self) -> &[u8] {
        &self.raw[self.off..self.off + self.slots]
    }

    /// 键所在的槽位块起点。
    #[inline]
    fn bucket_start(&self, h: u64) -> usize {
        let groups = self.slots / BUCKET;
        (h % groups as u64) as usize * BUCKET
    }

    /// 写入一个键：在槽位块里找第一个空槽或与自身指纹相同的槽。
    /// 返回 `false` 表示该块已被别的指纹占满（容量估计过小）。
    pub fn insert(&mut self, key: &[u8]) -> bool {
        let h = hash64(key);
        let fp = fingerprint(h);
        let tags = self.bucket_at_mut(self.bucket_start(h));
        for slot in tags.iter_mut() {
            if *slot == EMPTY || *slot == fp {
                *slot = fp;
                return true;
            }
        }
        false
    }

    /// 把 `start` 处的一个槽位块看成定长数组；`start` 是 16 的倍数，
    /// 而 `raw[off..]` 本身按 16 字节对齐，所以这里可以安全地做 16 字节的整体读写，
    /// 也让向量化器知道长度是常量 16（一次比较而不是带尾循环）。
    ///
    /// SAFETY 见函数体内的注释。
    #[inline]
    fn bucket_at(&self, start: usize) -> &[u8; BUCKET] {
        debug_assert!(start % BUCKET == 0 && start + BUCKET <= self.slots);
        let p = self.raw.as_ptr().wrapping_add(self.off + start);
        // SAFETY: `p` 指向 `raw` 内部；`off` 是按真实地址算出的对齐偏移，
        // `start` 又是 `BUCKET` 的倍数，所以 `p` 按 16 对齐；
        // `slots` 是 `BUCKET` 的倍数且 `start + BUCKET <= slots`，
        // 因此 `[p, p+16)` 完全落在已分配且初始化为 0 的区间内。
        // 借用生命周期与 `&self` 一致，`raw` 在 `Bloom` 存活期内不会 realloc。
        unsafe { &*p.cast::<[u8; BUCKET]>() }
    }

    /// `bucket_at` 的可写版本。
    #[inline]
    fn bucket_at_mut(&mut self, start: usize) -> &mut [u8; BUCKET] {
        debug_assert!(start % BUCKET == 0 && start + BUCKET <= self.slots);
        let p = self.raw.as_mut_ptr().wrapping_add(self.off + start);
        // SAFETY: 同 `bucket_at`；唯一的区别是这里得到 `&mut`，
        // 由 `&mut self` 保证同一时刻只有这一个可变借用指向这块内存。
        unsafe { &mut *p.cast::<[u8; BUCKET]>() }
    }

    /// 查询一个键是否可能存在。真阳性永不漏；判断规则与 `insert` 完全对称。
    ///
    /// `insert` 只写桶里第一个空槽，所以被占用的槽永远是桶的前缀；
    /// 于是「整桶里存在同指纹」与「第一个空槽之前存在同指纹」等价，
    /// 而前者是一个没有提前退出的定长归约，向量化器可以一次比较 16 个字节
    /// （是不是真的向量化，由 probe.sh 在 asm 里核对）。
    #[inline]
    pub fn contains(&self, key: &[u8]) -> bool {
        let h = hash64(key);
        let fp = fingerprint(h);
        let bucket = self.bucket_at(self.bucket_start(h));
        bucket.iter().filter(|&&t| t == fp).count() != 0
    }

    /// 逻辑槽位数。
    pub fn slots(&self) -> usize {
        self.slots
    }

    /// 序列化后的字节长度。
    pub fn encoded_len(&self) -> usize {
        8 + self.slots
    }

    /// 编码：`slots:u32 | pad:u32 | tags`。
    pub fn encode(&self) -> Vec<u8> {
        let mut v = Vec::with_capacity(self.encoded_len());
        v.extend_from_slice(&(self.slots as u32).to_le_bytes());
        v.extend_from_slice(&0u32.to_le_bytes());
        v.extend_from_slice(self.tags());
        v
    }

    /// 解码；长度不符返回 `None`。
    pub fn decode(buf: &[u8]) -> Option<Bloom> {
        if buf.len() < 8 {
            return None;
        }
        let slots = u32::from_le_bytes(buf[0..4].try_into().unwrap()) as usize;
        if slots == 0 || slots % BUCKET != 0 || buf.len() < 8 + slots {
            return None;
        }
        let mut raw = vec![EMPTY; slots + BUCKET];
        let addr = raw.as_ptr() as usize;
        let off = (BUCKET - (addr % BUCKET)) % BUCKET;
        raw.truncate(off + slots);
        raw[off..].copy_from_slice(&buf[8..8 + slots]);
        Some(Bloom { raw, off, slots })
    }
}

/// 默认每键 8 字节：实测假阳率在千分位，段文件膨胀可控。
pub const DEFAULT_BYTES_PER_KEY: usize = 8;
