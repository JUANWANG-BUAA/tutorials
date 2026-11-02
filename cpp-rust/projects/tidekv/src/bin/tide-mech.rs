//! `tide-mech`：机制对照基准——17.4 的「泛型 vs dyn 编解码」与 17.7 的「进程内压缩 vs 子进程压缩」。
//!
//! 两组实验都用第 1 章的配对协议：同一份输入、同轮交替、每臂预热、
//! 每轮取批均值，差值按 `diff = B - A` 定义。两组实验各自写一份 CSV，
//! 交给 `analyze_mech.py` 复算区间，再由 `gate.py` 按预算判三态。
//!
//! 等价工作由**输出比对**保证：编解码两臂的输出缓冲必须逐字节相同，
//! 压缩两臂写出的段文件必须逐字节相同；不相等就直接失败，不出数。

use std::error::Error;
use std::fs;
use std::hint::black_box;
use std::io::Write;
use std::path::{Path, PathBuf};
use std::time::{Duration, Instant};

use tidekv::codec::{CodecRecord, FixedCodec, encode_all, encode_all_dyn};
use tidekv::ipc::{CompactJob, spawn_compactor};
use tidekv::memtable::{Entry, EntryKind};
use tidekv::segment::{Segment, merge_dumps, write_segment};
use tidekv::testutil::TempDir;

/// CSV 的数值单位：编码实验是每条记录，压缩实验是每次压缩。
const CSV_VALUE_COLUMN: &str = "value_ns_per_op";

fn arg(name: &str, default: &str) -> String {
    let mut it = std::env::args();
    while let Some(a) = it.next() {
        if a == name {
            if let Some(v) = it.next() {
                return v;
            }
        }
    }
    default.to_string()
}

fn arg_present(name: &str) -> bool {
    std::env::args().any(|a| a == name)
}

/// splitmix64：两个实验的输入只由这一个发生器产生。
struct Rng(u64);

impl Rng {
    fn new(seed: u64) -> Rng {
        Rng(seed)
    }
    fn next_u64(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9E37_79B9_7F4A_7C15);
        let mut z = self.0;
        z = (z ^ (z >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94D0_49BB_133E_11EB);
        z ^ (z >> 31)
    }
    fn below(&mut self, n: u64) -> u64 {
        self.next_u64() % n
    }
}

/// 一次实验的一批结果。
struct ArmOutcome {
    batches: Vec<f64>,
    warm_ns_per_op: f64,
}

/// 预热到 `warm` 为止，再跑 `batches` 批；每批返回「每单位操作纳秒」。
///
/// 复用缓冲（`scratch`）在计时之外分配：分配成本不属于本实验要量的东西，
/// 把它留在计时区只会稀释分发代价，而且两臂的稀释程度还不完全相同。
fn measure<F: FnMut(&mut Vec<u8>) -> Result<(), Box<dyn Error>>>(
    warm: Duration,
    batches: usize,
    units_per_batch: usize,
    scratch_cap: usize,
    mut f: F,
) -> Result<ArmOutcome, Box<dyn Error>> {
    let mut scratch = Vec::with_capacity(scratch_cap);
    let mut warm_elapsed = Duration::ZERO;
    let mut warm_iters = 0usize;
    let deadline = Instant::now() + warm;
    while Instant::now() < deadline {
        let t0 = Instant::now();
        scratch.clear();
        f(&mut scratch)?;
        warm_elapsed += t0.elapsed();
        warm_iters += 1;
    }
    let mut out = Vec::with_capacity(batches);
    for _ in 0..batches {
        let t0 = Instant::now();
        scratch.clear();
        f(&mut scratch)?;
        out.push(t0.elapsed().as_nanos() as f64 / units_per_batch as f64);
    }
    let per_op = warm_elapsed.as_nanos() as f64 / (warm_iters.max(1) * units_per_batch) as f64;
    Ok(ArmOutcome {
        batches: out,
        warm_ns_per_op: per_op,
    })
}

/// 轮次顺序与臂顺序的随机化（每轮独立抛硬币，见 17.8.2 末尾那条设计缺陷）。
fn randomized_orders(rounds: usize, seed: u64) -> (Vec<usize>, Vec<&'static str>) {
    let mut rng = Rng::new(seed.wrapping_mul(0x9E37_79B9_7F4A_7C15) ^ 0xABCD);
    let mut arm_order = Vec::with_capacity(rounds);
    for _ in 0..rounds {
        arm_order.push(if rng.below(2) == 0 {
            "A_then_B"
        } else {
            "B_then_A"
        });
    }
    let mut seq: Vec<usize> = (0..rounds).collect();
    for i in (1..seq.len()).rev() {
        let j = rng.below((i + 1) as u64) as usize;
        seq.swap(i, j);
    }
    (seq, arm_order)
}

// ---------------------------------------------------------------- 实验一：编解码

fn build_records(n: usize, seed: u64) -> Vec<CodecRecord> {
    let mut rng = Rng::new(seed);
    let mut recs = Vec::with_capacity(n);
    for i in 0..n {
        let mut key = Vec::with_capacity(16);
        key.extend_from_slice(&(i as u64).to_le_bytes());
        key.extend_from_slice(&rng.next_u64().to_le_bytes());
        let mut value = Vec::with_capacity(64);
        value.extend_from_slice(format!("v{i:08}-").as_bytes());
        while value.len() < 64 {
            value.push(b'a' + ((value.len() + i) % 26) as u8);
        }
        value.truncate(64);
        recs.push(CodecRecord { key, value });
    }
    recs
}

/// 编解码实验：A = 单态化泛型路径，B = `dyn` 路径。
fn run_codec_experiment(
    rounds: usize,
    batches: usize,
    records_per_batch: usize,
    warm: Duration,
    seed: u64,
) -> Result<(String, String), Box<dyn Error>> {
    let recs = build_records(records_per_batch, seed ^ 0x11);
    let codec = FixedCodec::new(16, 64);

    // 等价工作检查：两条路径的输出必须逐字节相同。
    let mut out_a = Vec::with_capacity(records_per_batch * 88);
    let mut out_b = Vec::with_capacity(records_per_batch * 88);
    encode_all(&codec, &recs, &mut out_a);
    encode_all_dyn(&codec as &dyn tidekv::codec::Codec, &recs, &mut out_b);
    if out_a != out_b {
        return Err("codec arms produced different bytes; refusing to report".into());
    }
    let bytes = out_a.len();
    let digest = tidekv::crc32::crc32(&out_a);

    let mut csv = String::new();
    csv.push_str("# tidekv mechanism benchmark: codec dispatch (17.4)\n");
    csv.push_str("# units=ns_per_record (one op = one encoded record)\n");
    csv.push_str(&format!(
        "# seed={seed} rounds={rounds} batches_per_round={batches} ops_per_batch={records_per_batch} warmup_ms={}\n",
        warm.as_millis()
    ));
    csv.push_str(&format!(
        "# case=codec_dyn -- A = monomorphized generic path, B = &dyn Codec path; outputs byte-identical (bytes={bytes}, crc32={digest:08x})\n",
    ));
    csv.push_str(&format!(
        "kind,case,round,arm_order,arm,batch,{CSV_VALUE_COLUMN},ops,warm_ns_per_op\n"
    ));

    let (round_seq, arm_order) = randomized_orders(rounds, seed);
    for &r in &round_seq {
        let run_a_first = arm_order[r] == "A_then_B";
        for ai in 0..2 {
            let arm = if (ai == 0) == run_a_first { "A" } else { "B" };
            let owned = recs.clone();
            let outcome = if arm == "A" {
                let codec = FixedCodec::new(16, 64);
                measure(
                    warm,
                    batches,
                    records_per_batch,
                    records_per_batch * 88,
                    move |out: &mut Vec<u8>| {
                        encode_all(&codec, &owned, out);
                        black_box(out.len());
                        Ok(())
                    },
                )?
            } else {
                let codec: Box<dyn tidekv::codec::Codec> = Box::new(FixedCodec::new(16, 64));
                measure(
                    warm,
                    batches,
                    records_per_batch,
                    records_per_batch * 88,
                    move |out: &mut Vec<u8>| {
                        encode_all_dyn(codec.as_ref(), &owned, out);
                        black_box(out.len());
                        Ok(())
                    },
                )?
            };
            let mean = outcome.batches.iter().sum::<f64>() / outcome.batches.len() as f64;
            for (b, v) in outcome.batches.iter().enumerate() {
                csv.push_str(&format!(
                    "raw_batch,codec_dyn,{r},{order},{arm},{b},{v:.6},{records_per_batch},0\n",
                    order = arm_order[r]
                ));
            }
            csv.push_str(&format!(
                "BATCH_MEAN,codec_dyn,{r},{order},{arm},-1,{mean:.6},{records_per_batch},{warm:.6}\n",
                order = arm_order[r],
                warm = outcome.warm_ns_per_op,
            ));
        }
    }
    let verify = format!(
        "codec equivalence: generic bytes == dyn bytes -> MATCH (bytes={bytes}, crc32={digest:08x})\n"
    );
    Ok((csv, verify))
}

// ---------------------------------------------------------------- 实验二：压缩

/// 造两个输入段：老段全是写入，新段含 20% 墓碑（覆盖老段的同名键）。
fn build_input_segments(
    dir: &Path,
    entries: usize,
    seed: u64,
) -> Result<(PathBuf, PathBuf), Box<dyn Error>> {
    let mut rng = Rng::new(seed ^ 0x22);
    let mut older: Vec<(Vec<u8>, Entry)> = Vec::with_capacity(entries);
    let mut newer: Vec<(Vec<u8>, Entry)> = Vec::with_capacity(entries);
    for i in 0..entries {
        let key = format!("k{i:08}").into_bytes();
        let value = vec![b'v'; 64];
        older.push((key.clone(), Entry::new(i as u64, EntryKind::Put(value))));
        let kind = if rng.below(100) < 20 {
            EntryKind::Delete
        } else {
            EntryKind::Put(vec![b'w'; 64])
        };
        newer.push((key, Entry::new((entries + i) as u64, kind)));
    }
    let p_old = dir.join("seg-000001.tide");
    let p_new = dir.join("seg-000002.tide");
    let old_refs: Vec<(&[u8], &Entry)> = older.iter().map(|(k, e)| (k.as_slice(), e)).collect();
    let new_refs: Vec<(&[u8], &Entry)> = newer.iter().map(|(k, e)| (k.as_slice(), e)).collect();
    write_segment(&p_old, 1, &old_refs, tidekv::bloom::DEFAULT_BYTES_PER_KEY)?;
    write_segment(&p_new, 2, &new_refs, tidekv::bloom::DEFAULT_BYTES_PER_KEY)?;
    Ok((p_old, p_new))
}

/// 进程内压缩：与 `tide-compactor` 子进程做完全相同的三步。
fn compact_in_process(inputs: &[PathBuf], out: &Path) -> Result<(), Box<dyn Error>> {
    let mut dumps = Vec::with_capacity(inputs.len());
    for p in inputs {
        let seg = Segment::open(p)?;
        dumps.push(seg.dump());
    }
    let merged = merge_dumps(&dumps, false);
    let refs: Vec<(&[u8], &Entry)> = merged.iter().map(|(k, e)| (k.as_slice(), e)).collect();
    write_segment(out, 3, &refs, tidekv::bloom::DEFAULT_BYTES_PER_KEY)?;
    Ok(())
}

/// 压缩实验：A = 进程内合并，B = 子进程合并（走 ipc 协议）。
fn run_compaction_experiment(
    rounds: usize,
    batches: usize,
    entries: usize,
    warm: Duration,
    seed: u64,
) -> Result<(String, String), Box<dyn Error>> {
    let tmp = TempDir::new("mech");
    let (p_old, p_new) = build_input_segments(tmp.path(), entries, seed)?;
    let inputs = vec![p_new.clone(), p_old.clone()];

    // 等价工作检查：两条路径写出的段文件必须逐字节相同。
    let out_a = tmp.path().join("merged-inproc.tide");
    let out_b = tmp.path().join("merged-subproc.tide");
    compact_in_process(&inputs, &out_a)?;
    let job = CompactJob {
        out: out_b.clone(),
        inputs: inputs.clone(),
        drop_tombstones: false,
        bytes_per_key: tidekv::bloom::DEFAULT_BYTES_PER_KEY,
    };
    let report = spawn_compactor(&job).map_err(|e| format!("compactor failed: {e}"))?;
    let bytes_a = fs::read(&out_a)?;
    let bytes_b = fs::read(&out_b)?;
    if bytes_a != bytes_b {
        return Err("compaction arms produced different segment bytes; refusing to report".into());
    }
    let digest = tidekv::crc32::crc32(&bytes_a);

    let mut csv = String::new();
    csv.push_str("# tidekv mechanism benchmark: compaction path (17.7)\n");
    csv.push_str("# units=ns_per_compaction (one op = one two-segment merge)\n");
    csv.push_str(&format!(
        "# seed={seed} rounds={rounds} batches_per_round={batches} ops_per_batch=1 warmup_ms={}\n",
        warm.as_millis()
    ));
    csv.push_str(&format!(
        "# case=compact_subproc -- A = in-process merge, B = subprocess merge over the same ipc protocol; outputs byte-identical (bytes={}, entries={}, crc32={digest:08x})\n",
        bytes_a.len(),
        report.entries
    ));
    csv.push_str(&format!(
        "kind,case,round,arm_order,arm,batch,{CSV_VALUE_COLUMN},ops,warm_ns_per_op\n"
    ));

    let (round_seq, arm_order) = randomized_orders(rounds, seed ^ 0x33);
    for &r in &round_seq {
        let run_a_first = arm_order[r] == "A_then_B";
        for ai in 0..2 {
            let arm = if (ai == 0) == run_a_first { "A" } else { "B" };
            let outcome = if arm == "A" {
                let inputs = inputs.clone();
                let out = tmp.path().join("merged-inproc.tide");
                measure(warm, batches, 1, 0, move |_scratch: &mut Vec<u8>| {
                    compact_in_process(&inputs, &out)?;
                    Ok(())
                })?
            } else {
                let inputs = inputs.clone();
                let out = tmp.path().join("merged-subproc.tide");
                measure(warm, batches, 1, 0, move |_scratch: &mut Vec<u8>| {
                    let job = CompactJob {
                        out: out.clone(),
                        inputs: inputs.clone(),
                        drop_tombstones: false,
                        bytes_per_key: tidekv::bloom::DEFAULT_BYTES_PER_KEY,
                    };
                    let res =
                        spawn_compactor(&job).map_err(|e| format!("compactor failed: {e}"))?;
                    black_box(res.entries);
                    Ok(())
                })?
            };
            let mean = outcome.batches.iter().sum::<f64>() / outcome.batches.len() as f64;
            for (b, v) in outcome.batches.iter().enumerate() {
                csv.push_str(&format!(
                    "raw_batch,compact_subproc,{r},{order},{arm},{b},{v:.6},1,0\n",
                    order = arm_order[r]
                ));
            }
            csv.push_str(&format!(
                "BATCH_MEAN,compact_subproc,{r},{order},{arm},-1,{mean:.6},1,{warm:.6}\n",
                order = arm_order[r],
                warm = outcome.warm_ns_per_op,
            ));
        }
    }
    let verify = format!(
        "compaction equivalence: in-process bytes == subprocess bytes -> MATCH (bytes={}, entries={}, dropped={}, crc32={digest:08x})\n",
        bytes_a.len(),
        report.entries,
        report.dropped_tombstones
    );
    Ok((csv, verify))
}

fn main() -> Result<(), Box<dyn Error>> {
    let seed: u64 = arg("--seed", "20261029").parse()?;
    let rounds: usize = arg("--rounds", "21").parse()?;
    let batches: usize = arg("--batches", "30").parse()?;
    let records: usize = arg("--records", "4096").parse()?;
    let entries: usize = arg("--entries", "4096").parse()?;
    let warm_ms: u64 = arg("--warm-ms", "500").parse()?;
    let out_codec = PathBuf::from(arg("--out-codec", "results/run-02/codec.csv"));
    let out_compact = PathBuf::from(arg("--out-compaction", "results/run-02/compaction.csv"));
    let out_verify = PathBuf::from(arg("--verify", "results/run-02/mech-verification.txt"));

    let (rounds, batches, warm) = if arg_present("--smoke") {
        (3, 3, Duration::from_millis(80))
    } else {
        (rounds, batches, Duration::from_millis(warm_ms))
    };

    let (codec_csv, codec_verify) = run_codec_experiment(rounds, batches, records, warm, seed)?;
    let (compact_csv, compact_verify) =
        run_compaction_experiment(rounds, batches, entries, warm, seed)?;

    for (path, body) in [(&out_codec, codec_csv), (&out_compact, compact_csv)] {
        if let Some(parent) = path.parent() {
            if !parent.as_os_str().is_empty() {
                fs::create_dir_all(parent)?;
            }
        }
        let mut f = fs::File::create(path)?;
        f.write_all(body.as_bytes())?;
    }
    if let Some(parent) = out_verify.parent() {
        if !parent.as_os_str().is_empty() {
            fs::create_dir_all(parent)?;
        }
    }
    let mut v = fs::File::create(&out_verify)?;
    v.write_all(codec_verify.as_bytes())?;
    v.write_all(compact_verify.as_bytes())?;
    println!("tide-mech: codec -> {}", out_codec.display());
    println!("tide-mech: compaction -> {}", out_compact.display());
    println!("tide-mech: verification -> {}", out_verify.display());
    print!("{codec_verify}");
    print!("{compact_verify}");
    Ok(())
}
