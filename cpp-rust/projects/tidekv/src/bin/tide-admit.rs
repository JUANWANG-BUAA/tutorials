//! `tide-admit`：17.6 有界准入的实测——`CAP=64` 与 `CAP=4` 在同一份突发输入下的对照。
//!
//! 一次批的生命周期是「把 `burst_ops` 条大记录尽可能快地提交，然后等在门口受理下来的
//! 那些全部落定」，墙钟只记这一段。两臂唯一的差别是 `admission_capacity`，
//! 因此差值读成「把门口那道上限调小会带来什么」，而不是「换了个引擎」。
//!
//! 两个单位同时报，因为只看其中一个会把取舍藏起来（17.6.3 的三个计数）：
//!   * `ns_per_attempted`：墙钟 ÷ 提交尝试数，分母含被拒的请求；
//!   * `ns_per_accepted`：墙钟 ÷ 真正受理数，分母只含进过日志的请求。
//!
//! 拒绝率与三方一致性写进验证文件，不参与计时判定。
//!
//! 等价性不成立就不出数：本臂最终状态必须等于「把本臂真正受理的那批操作在参考实现里
//! 回放」的结果，且引擎自己的 `put / admission_reject` 计数器必须与夹具记账逐条对上。

use std::error::Error;
use std::fs;
use std::hint::black_box;
use std::io::Write;
use std::path::PathBuf;
use std::thread;
use std::time::{Duration, Instant};

use tidekv::testutil::TempDir;
use tidekv::{Config, Tide, TideError};

const TAGS: &[&str] = &[
    "user", "session", "order", "token", "index", "shard", "blob", "meta", "node", "link", "tree",
    "page", "slot", "host", "peer", "task",
];

/// 两臂共用的两个单位。
const METRICS: [&str; 2] = ["ns_per_attempted", "ns_per_accepted"];

struct Rng(u64);

impl Rng {
    fn new(seed: u64) -> Rng {
        Rng(seed)
    }
    fn next_u64(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9E37_79B9_7F4A_7C15);
        let mut z = self.0;
        z = (z ^ (z >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94D0_49BB_1331_11EB);
        z ^ (z >> 31)
    }
    fn below(&mut self, n: u64) -> u64 {
        self.next_u64() % n
    }
}

fn key_at(i: u64) -> Vec<u8> {
    format!("{}::{:08}", TAGS[(i % TAGS.len() as u64) as usize], i).into_bytes()
}

fn value_at(vlen: usize, i: u64) -> Vec<u8> {
    let mut v = Vec::with_capacity(vlen);
    v.extend_from_slice(format!("a{i:08}-").as_bytes());
    while v.len() < vlen {
        let c = b'a' + ((v.len() + i as usize) % 26) as u8;
        v.push(c);
    }
    v.truncate(vlen);
    v
}

/// 只由种子决定的操作序列，两臂逐字节相同。键会重复，用来检验后写覆盖。
fn build_ops(seed: u64, n: usize, vlen: usize) -> Vec<(Vec<u8>, Vec<u8>)> {
    let mut rng = Rng::new(seed ^ 0xAD11);
    (0..n as u64)
        .map(|i| {
            let k = rng.below(n as u64 * 3);
            (key_at(k), value_at(vlen, i))
        })
        .collect()
}

struct Run {
    wall_ns: u128,
    flush: u64,
    bytes_flushed: u64,
    accepted: usize,
    rejected: usize,
    digest: u64,
    engine_put: u64,
    engine_reject: u64,
}

/// `sync()` 自己也要过准入这道门：队列正满时它会被拒。真实调用方会等一等再试，
/// 所以这里同样重试——重试落在计时界内，浅队列因此付出的代价才被如实计入。
/// 等待用 `yield_now` 而不是固定时长睡眠：睡眠会把墙钟量化成 50 微秒的格子，
/// 那测出来的就是夹具的轮询粒度而不是引擎的排空速度。
fn drain(tide: &Tide) -> Result<(), Box<dyn Error>> {
    loop {
        match tide.sync() {
            Ok(()) => return Ok(()),
            Err(TideError::AdmissionRejected { .. }) => thread::yield_now(),
            Err(e) => return Err(format!("sync failed: {e}").into()),
        }
    }
}

fn one_batch(
    cap: usize,
    flush_bytes: usize,
    ops: &[(Vec<u8>, Vec<u8>)],
) -> Result<Run, Box<dyn Error>> {
    let tmp = TempDir::new("admit");
    let mut cfg = Config::new(tmp.path());
    cfg.admission_capacity = cap;
    // 让写线程真的慢下来：memtable 一小就刷成段文件，突发才会撞在门口。
    cfg.memtable_flush_bytes = flush_bytes;
    cfg.durable = false;
    let tide = Tide::open_engine(cfg)?;

    // 两臂都写同样长的受理标记表，避免「拒得多所以少记账」这种不对称。
    let mut flags: Vec<bool> = vec![false; ops.len()];
    let t0 = Instant::now();
    for (i, (k, v)) in ops.iter().enumerate() {
        match tide.put(k, v) {
            Ok(seq) => {
                flags[i] = true;
                black_box(seq);
            }
            Err(TideError::AdmissionRejected { .. }) => {}
            Err(e) => return Err(format!("unexpected error from put: {e}").into()),
        }
    }
    // 已受理的必须全部落定，否则墙钟只测到「提交快慢」而不是这一批的工作。
    drain(&tide)?;
    let wall_ns = t0.elapsed().as_nanos();

    let accepted = flags.iter().filter(|f| **f).count();
    let rejected = flags.len() - accepted;
    let stats = tide.stats();

    // 参考实现：只回放本臂真正受理的操作。
    let mut refmap: std::collections::BTreeMap<Vec<u8>, Vec<u8>> =
        std::collections::BTreeMap::new();
    for (i, (k, v)) in ops.iter().enumerate() {
        if flags[i] {
            refmap.insert(k.clone(), v.clone());
        }
    }
    let ref_digest = digest(refmap.iter().map(|(k, v)| (k.as_slice(), v.as_slice())));
    let live = tide.scan_prefix(b"")?;
    let engine_digest = digest(live.iter().map(|(k, v)| (k.as_slice(), v.as_slice())));
    if engine_digest != ref_digest {
        return Err(format!(
            "arm CAP={cap}: engine state {engine_digest:016x} != reference replay {ref_digest:016x}; refusing to report"
        )
        .into());
    }
    if stats.put as usize != ops.len() || stats.admission_reject as usize != rejected {
        return Err(format!(
            "arm CAP={cap}: engine counters (put={}, admission_reject={}) disagree with harness (attempted={}, rejected={})",
            stats.put, stats.admission_reject, ops.len(), rejected
        )
        .into());
    }
    if accepted + rejected != ops.len() || live.len() != refmap.len() {
        return Err(format!(
            "arm CAP={cap}: bookkeeping mismatch (accepted+rejected={}, live={}, ref={})",
            accepted + rejected,
            live.len(),
            refmap.len()
        )
        .into());
    }
    tide.close()?;
    Ok(Run {
        wall_ns,
        flush: stats.flush,
        bytes_flushed: stats.bytes_flushed,
        accepted,
        rejected,
        digest: engine_digest,
        engine_put: stats.put,
        engine_reject: stats.admission_reject,
    })
}

fn fnv(b: &[u8]) -> u64 {
    let mut h: u64 = 0xCBF2_9CE4_8422_2325;
    for &x in b {
        h ^= x as u64;
        h = h.wrapping_mul(0x0000_0100_0000_01B3);
    }
    h ^ (h >> 29)
}

#[inline]
fn mix(mut x: u64) -> u64 {
    x ^= x >> 33;
    x = x.wrapping_mul(0xFF51_AFD7_ED55_8CCD);
    x ^ (x >> 33)
}

fn digest<'a, I: Iterator<Item = (&'a [u8], &'a [u8])>>(it: I) -> u64 {
    let mut h: u64 = 0;
    for (k, v) in it {
        h = mix(h ^ fnv(k));
        h = mix(h ^ fnv(v));
        h = mix(h ^ (k.len() as u64) ^ ((v.len() as u64) << 32));
    }
    h ^ (h >> 17)
}

/// 一次正式批：返回 `[ns/attempted, ns/accepted, 墙钟纳秒, 本批受理数, 本批 flush 次数, 落盘字节]`。
/// 分母与实际工作量都落盘——`ns/accepted` 的分母每批不同，不落盘就没人能重算；
/// flush 次数不落盘，「每受理成本由段落盘主导」就只是从声明常量推算出来的一句话。
fn run_measure_batch(
    cap: usize,
    flush_bytes: usize,
    ops: &[(Vec<u8>, Vec<u8>)],
    attempted: usize,
) -> Result<[f64; 6], Box<dyn Error>> {
    let r = one_batch(cap, flush_bytes, ops)?;
    Ok([
        r.wall_ns as f64 / attempted as f64,
        r.wall_ns as f64 / r.accepted.max(1) as f64,
        r.wall_ns as f64,
        r.accepted as f64,
        r.flush as f64,
        r.bytes_flushed as f64,
    ])
}

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

fn main() {
    if let Err(e) = real_main() {
        eprintln!("tide-admit: {e}");
        std::process::exit(1);
    }
}

fn real_main() -> Result<(), Box<dyn Error>> {
    let seed: u64 = arg("--seed", "20261030").parse()?;
    let rounds: usize = arg("--rounds", "21").parse()?;
    let batches: usize = arg("--batches", "20").parse()?;
    let burst_ops: usize = arg("--burst-ops", "240").parse()?;
    let vlen: usize = arg("--value-bytes", "65536").parse()?;
    let flush_bytes: usize = arg("--flush-bytes", "262144").parse()?;
    let warm_ms: u64 = arg("--warm-ms", "300").parse()?;
    let cap_a: usize = arg("--cap-a", "64").parse()?;
    let cap_b: usize = arg("--cap-b", "4").parse()?;
    let out_path = PathBuf::from(arg("--out", "results/run-03/admit.csv"));
    let verify_path = PathBuf::from(arg("--verify", "results/run-03/admit-verification.txt"));
    let smoke = arg_present("--smoke");

    let (rounds, batches, warm) = if smoke {
        (2, 2, Duration::from_millis(40))
    } else {
        (rounds, batches, Duration::from_millis(warm_ms))
    };
    let warm_ms = warm.as_millis() as u64;

    let ops = build_ops(seed, burst_ops, vlen);
    let attempted = ops.len();

    let mut order_rng = Rng::new(seed.wrapping_mul(0x9E37_79B9_7F4A_7C15) ^ 0xAD23);
    let mut arm_order: Vec<&str> = Vec::with_capacity(rounds);
    for _ in 0..rounds {
        arm_order.push(if order_rng.below(2) == 0 {
            "A_then_B"
        } else {
            "B_then_A"
        });
    }
    let mut round_seq: Vec<usize> = (0..rounds).collect();
    for i in (1..round_seq.len()).rev() {
        let j = order_rng.below((i + 1) as u64) as usize;
        round_seq.swap(i, j);
    }

    let mut csv = String::new();
    csv.push_str("# tidekv 17.6 bounded-admission paired benchmark\n");
    csv.push_str("# units: two cases share one wall clock and differ only in the denominator\n");
    csv.push_str(&format!(
        "# seed={seed} rounds={rounds} batches_per_round={batches} ops_per_batch={attempted} warmup_ms={warm_ms} cap_A={cap_a} cap_B={cap_b} value_bytes={vlen} flush_bytes={flush_bytes} durable=false\n"
    ));
    csv.push_str(&format!(
        "# A = admission_capacity {cap_a}, B = admission_capacity {cap_b}; identical op sequence, identical code path\n"
    ));
    csv.push_str(
        "kind,case,round,arm_order,arm,batch,value_ns_per_op,ops,warm_ns_per_op,wall_ns,accepted,flush,bytes_flushed\n",
    );

    // 三方一致性：每臂各采一次（不进入计时判定），比对最终状态与参考回放、计数器与记账。
    let mut verify = String::new();
    verify.push_str("tide-admit correctness gate (must pass before any timing is reported)\n");
    verify.push_str(
        "A = deep admission cap, B = shallow cap; one generated op sequence fed to both\n\n",
    );
    let mut failed = 0usize;
    let mut reject_rows = String::new();
    for (arm, cap) in [("A", cap_a), ("B", cap_b)] {
        match one_batch(cap, flush_bytes, &ops) {
            Ok(r) => {
                let rate = r.rejected as f64 / attempted as f64;
                verify.push_str(&format!(
                    "arm {arm} CAP={cap} attempted={attempted} accepted={} rejected={} reject_rate={rate:.4} digest={:016x} engine_put={} engine_reject={} -> MATCH\n",
                    r.accepted, r.rejected, r.digest, r.engine_put, r.engine_reject
                ));
                reject_rows.push_str(&format!(
                    "reject,{arm},{cap},{attempted},{},{rate:.6}\n",
                    r.accepted
                ));
            }
            Err(e) => {
                failed += 1;
                verify.push_str(&format!("arm {arm} CAP={cap} FAILED: {e}\n"));
            }
        }
    }
    verify.push_str("\n参考回放只重放「本臂真正受理」的操作：被拒的操作必须不改变最终状态。\n");
    verify.push_str("引擎计数器（put / admission_reject）与夹具记账逐条对齐才算通过。\n");
    verify.push_str(&reject_rows);

    if let Some(parent) = verify_path.parent() {
        if !parent.as_os_str().is_empty() {
            fs::create_dir_all(parent)?;
        }
    }
    if failed > 0 {
        fs::write(&verify_path, &verify)?;
        return Err(
            format!("{failed} arm(s) failed the state/counter check; no timings reported").into(),
        );
    }

    let mut rows = 0usize;
    for &r in &round_seq {
        let a_first = arm_order[r] == "A_then_B";
        for ai in 0..2 {
            let (arm, cap) = if (ai == 0) == a_first {
                ("A", cap_a)
            } else {
                ("B", cap_b)
            };
            let deadline = Instant::now() + warm;
            while Instant::now() < deadline {
                let _ = one_batch(cap, flush_bytes, &ops)?;
            }
            let mut vals: [Vec<f64>; 6] = [
                Vec::with_capacity(batches),
                Vec::with_capacity(batches),
                Vec::with_capacity(batches),
                Vec::with_capacity(batches),
                Vec::with_capacity(batches),
                Vec::with_capacity(batches),
            ];
            for _ in 0..batches {
                let six = run_measure_batch(cap, flush_bytes, &ops, attempted)?;
                for (k, v) in six.iter().enumerate() {
                    vals[k].push(*v);
                }
            }
            let mean_of = |v: &[f64]| v.iter().sum::<f64>() / batches as f64;
            for (mi, metric) in METRICS.iter().enumerate() {
                let mean = mean_of(&vals[mi]);
                for (b, v) in vals[mi].iter().enumerate() {
                    csv.push_str(&format!(
                        "raw_batch,{case},{round},{order},{arm},{batch},{val:.6},{ops},0,{wall:.0},{accepted:.0},{flush:.0},{bytes:.0}\n",
                        case = metric,
                        round = r,
                        order = arm_order[r],
                        arm = arm,
                        batch = b,
                        val = v,
                        ops = attempted,
                        wall = vals[2][b],
                        accepted = vals[3][b],
                        flush = vals[4][b],
                        bytes = vals[5][b],
                    ));
                    rows += 1;
                }
                csv.push_str(&format!(
                    "BATCH_MEAN,{case},{round},{order},{arm},-1,{mean:.6},{ops},{warm_ms},{wall:.0},{acc:.2},{flush:.3},{bytes:.0}\n",
                    case = metric,
                    round = r,
                    order = arm_order[r],
                    arm = arm,
                    mean = mean,
                    ops = attempted,
                    wall = mean_of(&vals[2]),
                    acc = mean_of(&vals[3]),
                    flush = mean_of(&vals[4]),
                    bytes = mean_of(&vals[5]),
                ));
                rows += 1;
            }
        }
    }

    if let Some(parent) = out_path.parent() {
        if !parent.as_os_str().is_empty() {
            fs::create_dir_all(parent)?;
        }
    }
    let mut f = fs::File::create(&out_path)?;
    f.write_all(csv.as_bytes())?;
    let mut v = fs::File::create(&verify_path)?;
    v.write_all(verify.as_bytes())?;
    println!(
        "tide-admit: rounds={rounds} batches={batches} attempted/batch={attempted} warmup_ms={warm_ms} cap_A={cap_a} cap_B={cap_b} value_bytes={vlen} flush_bytes={flush_bytes} csv_rows={rows} -> {}",
        out_path.display()
    );
    println!("tide-admit: verification -> {}", verify_path.display());
    for l in verify
        .lines()
        .filter(|l| l.starts_with("arm ") || l.starts_with("reject,"))
    {
        println!("tide-admit: {l}");
    }
    Ok(())
}
