//! `tide-compactor`：压缩子进程。stdin 收 `ipc::CompactJob` 协议，stdout 回一行结果，
//! 每个输入都往 stderr 写一行状态（这样父进程必须真的排空两路管道才能不死锁），
//! 出错时以非零码退出。

use std::process::ExitCode;

use tidekv::Entry;
use tidekv::ipc;
use tidekv::segment::{Segment, merge_dumps, write_segment};

fn run() -> Result<(), String> {
    let job = ipc::read_job_from_stdin().map_err(|e| e.to_string())?;
    let mut dumps = Vec::with_capacity(job.inputs.len());
    let mut failed = 0usize;
    for (i, p) in job.inputs.iter().enumerate() {
        match Segment::open(p) {
            Ok(seg) => {
                eprintln!(
                    "input {i} {} entries={} bytes={}",
                    p.display(),
                    seg.info().entries,
                    seg.info().bytes
                );
                dumps.push(seg.dump());
            }
            Err(e) => {
                failed += 1;
                eprintln!("input {i} {} unreadable: {e}", p.display());
            }
        }
    }
    if dumps.is_empty() {
        return Err(format!(
            "no readable input among {} files",
            job.inputs.len()
        ));
    }
    let before_tombstones: u64 = dumps
        .iter()
        .flat_map(|d| d.iter())
        .filter(|(_, e)| e.is_tombstone())
        .count() as u64;
    let merged = merge_dumps(&dumps, job.drop_tombstones);
    let after_tombstones: u64 = merged.iter().filter(|(_, e)| e.is_tombstone()).count() as u64;
    let dropped = before_tombstones - after_tombstones;
    let refs: Vec<(&[u8], &Entry)> = merged.iter().map(|(k, e)| (k.as_slice(), e)).collect();
    let id = job
        .out
        .file_stem()
        .and_then(|s| s.to_str())
        .and_then(|s| s.trim_start_matches("seg-").split('.').next())
        .and_then(|s| s.parse::<u64>().ok())
        .unwrap_or(1);
    let info = write_segment(&job.out, id, &refs, job.bytes_per_key)
        .map_err(|e| format!("write {:?}: {e}", job.out))?;
    println!(
        "OK\t{}\t{}\t{}\t{}",
        job.out.display(),
        info.entries,
        info.bytes,
        dropped
    );
    if failed > 0 {
        return Err(format!("{failed} input file(s) were unreadable"));
    }
    Ok(())
}

fn main() -> ExitCode {
    match run() {
        Ok(()) => ExitCode::SUCCESS,
        Err(e) => {
            eprintln!("tide-compactor: {e}");
            ExitCode::FAILURE
        }
    }
}
