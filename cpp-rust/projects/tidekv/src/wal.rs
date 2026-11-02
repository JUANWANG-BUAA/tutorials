//! WAL：追加式日志。每帧 = 长度 + 载荷 + CRC32，崩溃恢复时逐帧校验。

use std::fs::{File, OpenOptions};
use std::io::{self, Read, Seek, SeekFrom, Write};
use std::path::{Path, PathBuf};

use crate::crc32::crc32;

/// 单个 WAL 帧的最大载荷长度，超过即视为损坏（防止把随机字节当长度）。
pub const MAX_PAYLOAD: u32 = 1 << 24;

/// 操作类型。
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum OpKind {
    /// 写入。
    Put = 1,
    /// 删除（墓碑）。
    Delete = 2,
}

/// 一条 WAL 记录（也是 memtable 的输入单元）。
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Record {
    /// 全局单调序号。
    pub seq: u64,
    /// Put / Delete。
    pub kind: OpKind,
    /// 键。
    pub key: Vec<u8>,
    /// 值；Delete 时为空。
    pub value: Vec<u8>,
}

impl Record {
    /// 编码成载荷字节：`seq | kind | key_len | val_len | key | value`。
    pub fn payload(&self) -> Vec<u8> {
        let mut p = Vec::with_capacity(21 + self.key.len() + self.value.len());
        p.extend_from_slice(&self.seq.to_le_bytes());
        p.push(self.kind as u8);
        p.extend_from_slice(&(self.key.len() as u32).to_le_bytes());
        p.extend_from_slice(&(self.value.len() as u32).to_le_bytes());
        p.extend_from_slice(&self.key);
        p.extend_from_slice(&self.value);
        p
    }

    /// 解码载荷；长度字段与实际字节不符时返回 `None`。
    pub fn decode(p: &[u8]) -> Option<Record> {
        if p.len() < 17 {
            return None;
        }
        let seq = u64::from_le_bytes(p[0..8].try_into().ok()?);
        let kind = match p[8] {
            1 => OpKind::Put,
            2 => OpKind::Delete,
            _ => return None,
        };
        let klen = u32::from_le_bytes(p[9..13].try_into().ok()?) as usize;
        let vlen = u32::from_le_bytes(p[13..17].try_into().ok()?) as usize;
        if p.len() != 17 + klen + vlen {
            return None;
        }
        Some(Record {
            seq,
            kind,
            key: p[17..17 + klen].to_vec(),
            value: p[17 + klen..].to_vec(),
        })
    }
}

/// 追加日志句柄。
pub struct Wal {
    path: PathBuf,
    file: File,
    bytes: u64,
}

impl Wal {
    /// 打开（或创建）WAL，定位到文件末尾。
    pub fn open(path: &Path) -> io::Result<Self> {
        let file = OpenOptions::new()
            .read(true)
            .append(true)
            .create(true)
            .open(path)?;
        let bytes = file.metadata()?.len();
        Ok(Self {
            path: path.to_path_buf(),
            file,
            bytes,
        })
    }

    /// 追加一条记录，返回该帧在文件里的起始偏移。
    pub fn append(&mut self, r: &Record) -> io::Result<u64> {
        let payload = r.payload();
        let total = (payload.len() + 4) as u32;
        let crc = crc32(&payload);
        let off = self.bytes;
        self.file.write_all(&total.to_le_bytes())?;
        self.file.write_all(&payload)?;
        self.file.write_all(&crc.to_le_bytes())?;
        self.bytes += 4 + payload.len() as u64 + 4;
        Ok(off)
    }

    /// 把缓冲刷到 OS，并在 `durability` 为真时额外 `fsync`。
    pub fn sync_to(&mut self, durability: bool) -> io::Result<()> {
        self.file.flush()?;
        if durability {
            self.file.sync_all()?;
        }
        Ok(())
    }

    /// 当前文件长度。
    pub fn len(&self) -> u64 {
        self.bytes
    }

    /// 是否为空日志。
    pub fn is_empty(&self) -> bool {
        self.bytes == 0
    }

    /// 路径。
    pub fn path(&self) -> &Path {
        &self.path
    }

    /// 轮转：`from` 之前的记录已经进了段文件，可以丢弃；`from` 之后的记录
    /// 原样搬到新 WAL，然后原子替换旧文件。写线程是唯一追加者，所以 `[from, end)`
    /// 一定是若干完整帧。
    pub fn rotate_keeping(&mut self, from: u64) -> io::Result<()> {
        self.file.flush()?;
        let from = from.min(self.bytes) as usize;
        let mut tail = Vec::new();
        if (self.bytes as usize) > from {
            let mut f = File::open(&self.path)?;
            f.seek(SeekFrom::Start(from as u64))?;
            f.read_to_end(&mut tail)?;
        }
        let expect = self.bytes as usize - from;
        if tail.len() < expect {
            return Err(io::Error::other("wal shrank during rotation"));
        }
        tail.truncate(expect);
        let tmp = {
            let mut p = self.path.clone();
            p.set_extension("wal.new");
            p
        };
        {
            let mut nf = File::create(&tmp)?;
            nf.write_all(&tail)?;
            nf.sync_all()?;
        }
        std::fs::rename(&tmp, &self.path)?;
        self.file = OpenOptions::new()
            .read(true)
            .append(true)
            .create(true)
            .open(&self.path)?;
        self.bytes = tail.len() as u64;
        Ok(())
    }

    /// 丢弃整个日志（只在没有在途写时使用）。
    pub fn reset(&mut self) -> io::Result<()> {
        self.rotate_keeping(self.bytes)
    }
}

/// 恢复结果。
#[derive(Clone, Debug, Default)]
pub struct Recovery {
    /// 通过 CRC 校验、可以安全重放的记录。
    pub records: Vec<Record>,
    /// 被拒绝的尾部记录条数（含第一帧校验失败的那一帧）。
    pub rejected_records: usize,
    /// 有效字节数：截断到此处即可继续追加。
    pub valid_bytes: usize,
    /// 被丢弃的尾部字节数。
    pub discarded_bytes: usize,
}

impl Recovery {
    /// 是否存在被拒绝的记录。
    pub fn has_rejected(&self) -> bool {
        self.rejected_records > 0
    }
}

/// 顺序扫描 WAL，遇到第一帧 CRC/长度不符就停止接受，并统计尾部被拒绝的记录数。
pub fn recover(path: &Path) -> io::Result<Recovery> {
    let mut buf = Vec::new();
    if !path.exists() {
        return Ok(Recovery::default());
    }
    File::open(path)?.read_to_end(&mut buf)?;
    Ok(recover_bytes(&buf))
}

/// 对给定字节做恢复；独立出来便于测试与 `tide-probe` 复用。
pub fn recover_bytes(buf: &[u8]) -> Recovery {
    let mut out = Recovery::default();
    let mut pos = 0usize;
    loop {
        if buf.len() - pos < 4 {
            break;
        }
        let total = u32::from_le_bytes(buf[pos..pos + 4].try_into().unwrap()) as usize;
        if total < 4 || total > MAX_PAYLOAD as usize || pos + total + 4 > buf.len() {
            break;
        }
        let payload = &buf[pos + 4..pos + 4 + total - 4];
        let stored = u32::from_le_bytes(buf[pos + total..pos + total + 4].try_into().unwrap());
        if stored != crc32(payload) {
            out.rejected_records = count_tail_records(buf, pos, total + 4);
            out.valid_bytes = pos;
            out.discarded_bytes = buf.len() - pos;
            return out;
        }
        match Record::decode(payload) {
            Some(r) => out.records.push(r),
            None => {
                out.rejected_records = count_tail_records(buf, pos, total + 4);
                out.valid_bytes = pos;
                out.discarded_bytes = buf.len() - pos;
                return out;
            }
        }
        pos += total + 4;
        out.valid_bytes = pos;
    }
    out.discarded_bytes = buf.len() - out.valid_bytes;
    out
}

/// 统计从 `from` 起（含这一帧）到文件末尾还有多少帧被拒绝。
/// `frame_len` 是坏帧自己声明的长度：它的 CRC 已经不合格，不能再拿它的字段当依据，
/// 但长度字段仍是唯一可用的重同步线索，所以从这里往后继续按长度走。
fn count_tail_records(buf: &[u8], from: usize, frame_len: usize) -> usize {
    let mut n = 1usize; // 当前这一帧本身
    let mut pos = from + frame_len;
    loop {
        if buf.len() - pos < 4 {
            break;
        }
        let total = u32::from_le_bytes(buf[pos..pos + 4].try_into().unwrap()) as usize;
        if total < 4 || total > MAX_PAYLOAD as usize || pos + total + 4 > buf.len() {
            break;
        }
        pos += total + 4;
        n += 1;
    }
    n
}

/// 用于测试与恢复演练：把文件截断到有效前缀（模拟崩溃后被丢弃的尾部）。
pub fn truncate_to(path: &Path, valid_bytes: usize) -> io::Result<()> {
    let f = OpenOptions::new().write(true).open(path)?;
    f.set_len(valid_bytes as u64)
}
