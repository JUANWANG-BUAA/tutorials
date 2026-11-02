//! 测试与基准共用的临时目录工具（只用 `std`，没有 `tempfile` 依赖）。

use std::fs;
use std::path::{Path, PathBuf};
use std::sync::atomic::{AtomicU64, Ordering};

static COUNTER: AtomicU64 = AtomicU64::new(0);

/// 一个带自动清理的临时目录。
pub struct TempDir {
    path: PathBuf,
    keep: bool,
}

impl TempDir {
    /// 在 `TMPDIR`（默认 `/tmp`）下建一个进程内唯一的目录。
    pub fn new(tag: &str) -> TempDir {
        let n = COUNTER.fetch_add(1, Ordering::Relaxed);
        let pid = std::process::id();
        let mut p = std::env::temp_dir();
        p.push(format!("tidekv-{tag}-{pid}-{n}"));
        let _ = fs::remove_dir_all(&p);
        fs::create_dir_all(&p).expect("create temp dir");
        TempDir {
            path: p,
            keep: false,
        }
    }

    /// 目录路径。
    pub fn path(&self) -> &Path {
        &self.path
    }

    /// 保留目录（调试时看落盘文件）。
    pub fn keep(&mut self) {
        self.keep = true;
    }
}

impl Drop for TempDir {
    fn drop(&mut self) {
        if !self.keep {
            let _ = fs::remove_dir_all(&self.path);
        }
    }
}

/// 提交一笔写：遇到有界准入拒绝就退避重试，直到成功。
/// 这是测试与基准里的通用写法——真实调用方也应该这么处理 `AdmissionRejected`。
pub fn put(tide: &crate::Tide, key: &[u8], value: &[u8]) -> u64 {
    submit(tide, key, Some(value))
}

/// 提交一笔删除，语义同 [`put`]。
pub fn delete(tide: &crate::Tide, key: &[u8]) -> u64 {
    submit(tide, key, None)
}

fn submit(tide: &crate::Tide, key: &[u8], value: Option<&[u8]>) -> u64 {
    let mut spins = 0u32;
    loop {
        let r = match value {
            Some(v) => tide.put(key, v),
            None => tide.delete(key),
        };
        match r {
            Ok(seq) => return seq,
            Err(crate::TideError::AdmissionRejected { .. }) => {
                spins += 1;
                if spins < 64 {
                    std::hint::spin_loop();
                } else {
                    std::thread::yield_now();
                }
            }
            Err(e) => panic!("write failed: {e}"),
        }
    }
}
