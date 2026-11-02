//! 压缩子进程：stdin 传参数、stdout 收结果、stderr 取错误；三路管道都显式排空。

use std::io::{self, Read, Write};
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};
use std::sync::mpsc;
use std::thread;

/// 一次压缩的输入。
#[derive(Clone, Debug)]
pub struct CompactJob {
    /// 输出段路径。
    pub out: PathBuf,
    /// 输入段路径（按新→旧排列）。
    pub inputs: Vec<PathBuf>,
    /// 是否允许丢弃墓碑（仅当输入覆盖了全部历史段时才为真）。
    pub drop_tombstones: bool,
    /// 每键布隆字节数。
    pub bytes_per_key: usize,
}

/// 子进程回报的结果。
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct CompactResult {
    /// 输出段路径。
    pub out: PathBuf,
    /// 输出条目数。
    pub entries: u64,
    /// 输出字节数。
    pub bytes: u64,
    /// 被丢掉的墓碑数。
    pub dropped_tombstones: u64,
}

/// 压缩失败：带退出码与 stderr 全文。
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct CompactorError {
    /// 退出码。
    pub code: i32,
    /// stderr 内容。
    pub message: String,
}

impl std::fmt::Display for CompactorError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "tide-compactor exited with {}: {}",
            self.code, self.message
        )
    }
}

impl std::error::Error for CompactorError {}

/// 定位 `tide-compactor`：
/// 1. `TIDE_COMPACTOR` 环境变量（手工覆盖）；
/// 2. `CARGO_BIN_EXE_tide-compactor`——`cargo test` 给集成测试注入的、已构建好的 bin 路径，
///    因为测试二进制在 `target/debug/deps/`，和 bin 不在同一目录；
/// 3. 与当前可执行文件同目录（release 下 bench 与 compactor 是邻居）；
/// 4. 裸名，交给操作系统的 PATH 查找。
pub fn compactor_path() -> io::Result<PathBuf> {
    for key in ["TIDE_COMPACTOR", "CARGO_BIN_EXE_tide-compactor"] {
        if let Ok(p) = std::env::var(key) {
            let pb = PathBuf::from(p);
            if pb.exists() {
                return Ok(pb);
            }
        }
    }
    let exe = std::env::current_exe()?;
    let dir = exe
        .parent()
        .ok_or_else(|| io::Error::other("current exe has no parent dir"))?;
    let cand = dir.join("tide-compactor");
    if cand.exists() {
        return Ok(cand);
    }
    Err(io::Error::other(
        "tide-compactor binary not found; set TIDE_COMPACTOR",
    ))
}

/// 协议行：`out\0inputs\0drop_tombstones\0bytes_per_key`，输入用 `,` 分隔。
fn encode(job: &CompactJob) -> Vec<u8> {
    let mut s = String::new();
    s.push_str(&job.out.to_string_lossy());
    s.push('\n');
    let inputs: Vec<String> = job
        .inputs
        .iter()
        .map(|p| p.to_string_lossy().into_owned())
        .collect();
    s.push_str(&inputs.join(","));
    s.push('\n');
    s.push_str(if job.drop_tombstones { "1" } else { "0" });
    s.push('\n');
    s.push_str(&job.bytes_per_key.to_string());
    s.push('\n');
    s.into_bytes()
}

fn decode(stdout: &str) -> io::Result<CompactResult> {
    let line = stdout
        .lines()
        .find(|l| !l.trim().is_empty())
        .ok_or_else(|| io::Error::other("compactor printed nothing"))?;
    let mut it = line.split('\t');
    let ok = it.next().unwrap_or("");
    if ok != "OK" {
        return Err(io::Error::other(format!("compactor said {ok}")));
    }
    let out = PathBuf::from(it.next().unwrap_or(""));
    let entries = it
        .next()
        .and_then(|v| v.parse().ok())
        .ok_or_else(|| io::Error::other("bad entries field"))?;
    let bytes = it
        .next()
        .and_then(|v| v.parse().ok())
        .ok_or_else(|| io::Error::other("bad bytes field"))?;
    let dropped = it.next().and_then(|v| v.parse().ok()).unwrap_or(0);
    Ok(CompactResult {
        out,
        entries,
        bytes,
        dropped_tombstones: dropped,
    })
}

/// 起子进程做压缩。三路管道（stdin/stdout/stderr）各自用独立线程排空，
/// 否则子进程写满 64 KB 管道缓冲后会阻塞在 write，而父进程阻塞在 write stdin，形成死锁。
pub fn spawn_compactor(job: &CompactJob) -> Result<CompactResult, CompactorError> {
    let bin = compactor_path().unwrap_or_else(|_| PathBuf::from("tide-compactor"));
    let mut child = match Command::new(&bin)
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
    {
        Ok(c) => c,
        Err(e) => {
            return Err(CompactorError {
                code: -1,
                message: format!("spawn {}: {e}", bin.display()),
            });
        }
    };

    let payload = encode(job);
    let mut stdin = child.stdin.take().expect("stdin piped");
    let t_in = thread::spawn(move || -> io::Result<()> {
        stdin.write_all(&payload)?;
        stdin.flush()?;
        // 关闭写端，子进程才能读到 EOF 并开始干活。
        drop(stdin);
        Ok(())
    });

    let mut stdout = child.stdout.take().expect("stdout piped");
    let (sx, rx) = mpsc::channel::<String>();
    let t_out = thread::spawn(move || {
        let mut buf = String::new();
        stdout.read_to_string(&mut buf)?;
        let _ = sx.send(buf.clone());
        Ok::<(), io::Error>(())
    });

    let mut stderr = child.stderr.take().expect("stderr piped");
    let (ex, erx) = mpsc::channel::<String>();
    let t_err = thread::spawn(move || {
        let mut buf = String::new();
        stderr.read_to_string(&mut buf)?;
        let _ = ex.send(buf);
        Ok::<(), io::Error>(())
    });

    let write_err = t_in
        .join()
        .unwrap_or_else(|_| Err(io::Error::other("stdin panics")));
    let out_text = rx.recv().unwrap_or_else(|_| String::new());
    let err_text = erx.recv().unwrap_or_else(|_| String::new());
    let _ = t_out.join();
    let _ = t_err.join();

    let status = child.wait().map_err(|e| CompactorError {
        code: -1,
        message: format!("wait failed: {e}"),
    })?;

    if !status.success() {
        return Err(CompactorError {
            code: status.code().unwrap_or(-1),
            message: if err_text.trim().is_empty() {
                format!("no stderr; stdin error: {write_err:?}")
            } else {
                err_text.trim().to_string()
            },
        });
    }
    decode(&out_text).map_err(|e| CompactorError {
        code: 0,
        message: e.to_string(),
    })
}

/// 供 `tide-compactor` bin 复用：读取 stdin 协议行。
pub fn read_job_from_stdin() -> io::Result<CompactJob> {
    let mut buf = String::new();
    std::io::stdin().read_to_string(&mut buf)?;
    let mut lines = buf.lines();
    let out = Path::new(lines.next().unwrap_or("")).to_path_buf();
    let inputs_raw = lines.next().unwrap_or("");
    let inputs: Vec<PathBuf> = inputs_raw
        .split(',')
        .filter(|s| !s.is_empty())
        .map(PathBuf::from)
        .collect();
    let drop_tombstones = lines.next().unwrap_or("0") == "1";
    let bytes_per_key = lines
        .next()
        .and_then(|s| s.parse().ok())
        .unwrap_or(crate::bloom::DEFAULT_BYTES_PER_KEY);
    if out.as_os_str().is_empty() || inputs.is_empty() {
        return Err(io::Error::other(
            "usage: out\\ninputs\\ndrop\\nbytes_per_key",
        ));
    }
    Ok(CompactJob {
        out,
        inputs,
        drop_tombstones,
        bytes_per_key,
    })
}
