//! `tide-bench`：A/B 配对基准。
//!
//! A（基线）= 进程内 `RwLock<BTreeMap<Vec<u8>, Option<Vec<u8>>>>`；
//! B = `Tide`（含 flush 到段的批生命周期）。两边吃完全相同的操作序列，
//! 结果与一份独立参考实现（单线程 `HashMap` 回放）三方比对后才计时。

use std::collections::{BTreeMap, HashMap};
use std::env;
use std::error::Error;
use std::fs;
use std::hint::black_box;
use std::io::Write;
use std::path::PathBuf;
use std::rc::Rc;
use std::sync::RwLock;
use std::time::{Duration, Instant};

use tidekv::testutil::TempDir;
use tidekv::{Config, Tide};

/// CSV 里数值的单位。
const UNITS: &str = "ns_per_op";
const TAGS: &[&str] = &[
    "user", "session", "order", "token", "index", "shard", "blob", "meta", "node", "link", "tree",
    "page", "slot", "host", "peer", "task",
];
/// A/B 两个 arm 的名字。
const ARMS: [&str; 2] = ["A", "B"];

#[derive(Clone, Debug)]
enum Op {
    Put(Vec<u8>, Vec<u8>),
    Del(Vec<u8>),
    Get(Vec<u8>),
    Scan(Vec<u8>),
}

#[derive(Clone, Debug)]
struct Workload {
    name: &'static str,
    description: &'static str,
    ops: Rc<Vec<Op>>,
    nops: usize,
}

/// splitmix64：所有 case 的输入序列只由这一个发生器产生，A/B/参考共用同一份序列。
struct Rng(u64);

impl Rng {
    fn new(seed: u64) -> Rng {
        Rng(seed)
    }
    #[inline]
    fn next_u64(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9E37_79B9_7F4A_7C15);
        let mut z = self.0;
        z = (z ^ (z >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94D0_49BB_1331_11EB);
        z ^ (z >> 31)
    }
    #[inline]
    fn below(&mut self, n: u64) -> u64 {
        self.next_u64() % n
    }
}

fn key_at(i: u64) -> Vec<u8> {
    format!("{}::{:08}", TAGS[(i % TAGS.len() as u64) as usize], i).into_bytes()
}

fn value_at(vlen: usize, i: u64) -> Vec<u8> {
    let mut v = Vec::with_capacity(vlen);
    v.extend_from_slice(format!("v{i:08}-").as_bytes());
    while v.len() < vlen {
        let c = b'a' + ((v.len() + i as usize) % 26) as u8;
        v.push(c);
    }
    v.truncate(vlen);
    v
}

fn build_case(name: &'static str, description: &'static str, n: usize, seed: u64) -> Workload {
    let mut rng = Rng::new(seed);
    let mut ops = Vec::with_capacity(n);
    match name {
        "put_wide" => {
            for i in 0..n as u64 {
                let k = rng.below(20_000);
                let r = rng.below(100);
                if r < 70 {
                    ops.push(Op::Put(key_at(k), value_at(300, i)));
                } else if r < 80 {
                    ops.push(Op::Del(key_at(k)));
                } else {
                    ops.push(Op::Get(key_at(k)));
                }
            }
        }
        "get_hot" => {
            for i in 0..2_000u64 {
                ops.push(Op::Put(key_at(i), value_at(120, i)));
            }
            for i in 0..n as u64 {
                let r = rng.below(100);
                if r < 90 {
                    ops.push(Op::Get(key_at(rng.below(2_000))));
                } else {
                    ops.push(Op::Put(key_at(rng.below(2_000)), value_at(120, i)));
                }
            }
        }
        "get_absent" => {
            for i in 0..1_000u64 {
                ops.push(Op::Put(key_at(i), value_at(120, i)));
            }
            for _ in 0..n {
                ops.push(Op::Get(key_at(10_000 + rng.below(10_000))));
            }
        }
        "scan_12" => {
            for i in 0..4_096u64 {
                ops.push(Op::Put(key_at(i), value_at(80, i)));
            }
            for _ in 0..n {
                if rng.below(100) < 80 {
                    ops.push(Op::Get(key_at(rng.below(4_096))));
                } else {
                    let t = rng.below(TAGS.len() as u64) as usize;
                    ops.push(Op::Scan(TAGS[t].as_bytes().to_vec()));
                }
            }
        }
        other => panic!("unknown case {other}"),
    }
    let nops = ops.len();
    Workload {
        name,
        description,
        ops: Rc::new(ops),
        nops,
    }
}

fn cases(seed: u64, n: usize) -> Vec<Workload> {
    vec![
        build_case(
            "put_wide",
            "70% put(300B) / 10% delete / 20% get over 20k keys",
            n,
            seed ^ 0x11,
        ),
        build_case(
            "get_hot",
            "90% point get on 2k warm keys / 10% put",
            n,
            seed ^ 0x22,
        ),
        build_case(
            "get_absent",
            "100% point get on keys never written (bloom must reject)",
            n,
            seed ^ 0x33,
        ),
        build_case(
            "scan_12",
            "80% get / 20% prefix scan over 16 tags and 4k keys",
            n,
            seed ^ 0x44,
        ),
    ]
}

// ---------------------------------------------------------------- A：基线

type Map = RwLock<BTreeMap<Vec<u8>, Option<Vec<u8>>>>;

/// 基线：同一个操作序列，同一套语义（`None` = 墓碑 = 不存在）。
fn run_baseline(map: &Map, ops: &[Op]) {
    for op in ops {
        match op {
            Op::Put(k, v) => {
                map.write().unwrap().insert(k.clone(), Some(v.clone()));
            }
            Op::Del(k) => {
                map.write().unwrap().insert(k.clone(), None);
            }
            Op::Get(k) => {
                let g = map.read().unwrap();
                let hit = g
                    .get(k)
                    .and_then(|o| o.as_ref())
                    .map(|v| v.len())
                    .unwrap_or(0);
                black_box(hit);
            }
            Op::Scan(p) => {
                let g = map.read().unwrap();
                let n = g
                    .range(p.clone()..)
                    .take_while(|(k, _)| k.starts_with(p))
                    .filter(|(_, v)| v.is_some())
                    .inspect(|kv| {
                        black_box(kv);
                    })
                    .count();
                black_box(n);
            }
        }
    }
}

/// 独立参考实现：单线程 `HashMap` 回放，没有锁、没有引擎，只用来当「真值」。
fn run_reference(ops: &[Op]) -> BTreeMap<Vec<u8>, Vec<u8>> {
    let mut live: HashMap<Vec<u8>, Vec<u8>> = HashMap::new();
    for op in ops {
        match op {
            Op::Put(k, v) => {
                live.insert(k.clone(), v.clone());
            }
            Op::Del(k) => {
                live.remove(k);
            }
            Op::Get(_) | Op::Scan(_) => {}
        }
    }
    live.into_iter().collect::<BTreeMap<_, _>>()
}

/// 状态摘要：只取决于「当前存活键值集合」，墓碑折叠成不存在。
fn digest_pairs<'a, I: Iterator<Item = (&'a [u8], &'a [u8])>>(it: I) -> u64 {
    let mut h: u64 = 0;
    for (k, v) in it {
        h = mix_state(h ^ fnv(k));
        h = mix_state(h ^ fnv(v));
        h = mix_state(h ^ (k.len() as u64) ^ ((v.len() as u64) << 32));
    }
    h ^ (h >> 17)
}

fn digest_ref(m: &BTreeMap<Vec<u8>, Vec<u8>>) -> u64 {
    digest_pairs(m.iter().map(|(k, v)| (k.as_slice(), v.as_slice())))
}

fn digest_baseline(m: &Map) -> u64 {
    let g = m.read().unwrap();
    digest_pairs(
        g.iter()
            .filter_map(|(k, v)| v.as_ref().map(|v| (k.as_slice(), v.as_slice()))),
    )
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
fn mix_state(mut x: u64) -> u64 {
    x ^= x >> 33;
    x = x.wrapping_mul(0xFF51_AFD7_ED55_8CCD);
    x ^ (x >> 33)
}

// ---------------------------------------------------------------- B：tidekv

/// B 的一次批生命周期：空目录起引擎，写够 `flush_every` 个操作就 flush 成不可变段，
/// 之后的读要穿过布隆 + 段索引。
struct BatchRun {
    tmp: TempDir,
    tide: Tide,
    flush_every: usize,
}

impl BatchRun {
    fn new(flush_every: usize) -> Result<BatchRun, Box<dyn Error>> {
        let tmp = TempDir::new("bench");
        let mut cfg = Config::new(tmp.path());
        // 自动 flush 关掉，改由批生命周期显式控制，保证两边每批做的事一样。
        cfg.memtable_flush_bytes = usize::MAX;
        cfg.admission_capacity = 65_536;
        cfg.durable = false;
        let tide = Tide::open_engine(cfg)?;
        Ok(BatchRun {
            tmp,
            tide,
            flush_every,
        })
    }

    fn run(&mut self, ops: &[Op]) -> Result<(), Box<dyn Error>> {
        let mut since = 0usize;
        for op in ops {
            match op {
                Op::Put(k, v) => {
                    self.tide.put(k, v)?;
                }
                Op::Del(k) => {
                    self.tide.delete(k)?;
                }
                Op::Get(k) => {
                    let hit = self.tide.get(k)?;
                    black_box(hit.map(|v| v.len()).unwrap_or(0));
                }
                Op::Scan(p) => {
                    let n = self.tide.scan_prefix(p)?.len();
                    black_box(n);
                }
            }
            since += 1;
            if since >= self.flush_every {
                self.tide.sync()?;
                self.tide.flush()?;
                since = 0;
            }
        }
        self.tide.sync()?;
        Ok(())
    }

    /// 把最终状态整份扫出来算摘要（scan 走的是引擎自己的读路径）。
    fn digest(&self) -> Result<u64, Box<dyn Error>> {
        assert!(self.tmp.path().exists(), "批生命周期期间工作目录不该消失");
        let pairs = self.tide.scan_prefix(b"")?;
        Ok(digest_pairs(
            pairs.iter().map(|(k, v)| (k.as_slice(), v.as_slice())),
        ))
    }
}

impl Drop for BatchRun {
    fn drop(&mut self) {
        let _ = self.tide.close();
    }
}

// ---------------------------------------------------------------- 计时

struct ArmOutcome {
    batches: Vec<f64>,
    warm_ns_per_op: f64,
}

/// 先预热到 `warm` 时长为止，再跑 `batches` 个批次，每批 `nops` 次操作。
/// 每一批都从空状态开始（`f` 自己负责重建状态），所以批次之间可比。
fn measure<F: FnMut() -> Result<(), Box<dyn Error>>>(
    warm: Duration,
    batches: usize,
    nops: usize,
    mut f: F,
) -> Result<ArmOutcome, Box<dyn Error>> {
    let mut warm_elapsed = Duration::ZERO;
    let mut warm_iters = 0usize;
    let deadline = Instant::now() + warm;
    while Instant::now() < deadline {
        let t0 = Instant::now();
        f()?;
        warm_elapsed += t0.elapsed();
        warm_iters += 1;
    }
    let mut out = Vec::with_capacity(batches);
    for _ in 0..batches {
        let t0 = Instant::now();
        f()?;
        out.push(t0.elapsed().as_nanos() as f64 / nops as f64);
    }
    let per_op = warm_elapsed.as_nanos() as f64 / (warm_iters.max(1) * nops) as f64;
    Ok(ArmOutcome {
        batches: out,
        warm_ns_per_op: per_op,
    })
}

fn arg(name: &str, default: &str) -> String {
    let mut it = env::args();
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
    env::args().any(|a| a == name)
}

fn main() {
    if let Err(e) = real_main() {
        eprintln!("tide-bench: {e}");
        std::process::exit(1);
    }
}

fn real_main() -> Result<(), Box<dyn Error>> {
    let seed: u64 = arg("--seed", "20261028").parse()?;
    let rounds: usize = arg("--rounds", "21").parse()?;
    let batches: usize = arg("--batches", "30").parse()?;
    let nops: usize = arg("--ops", "900").parse()?;
    let warm_ms: u64 = arg("--warm-ms", "500").parse()?;
    let out_path = PathBuf::from(arg("--out", "results/run-01/bench.csv"));
    let verify_path = PathBuf::from(arg("--verify", "results/run-01/bench-verification.txt"));
    let flush_every: usize = arg("--flush-every", "300").parse()?;
    let smoke = arg_present("--smoke");

    let (rounds, batches, warm) = if smoke {
        (3, 3, Duration::from_millis(80))
    } else {
        (rounds, batches, Duration::from_millis(warm_ms))
    };
    let warm_ms = warm.as_millis() as u64;

    let cases = cases(seed, nops);
    let mut order_rng = Rng::new(seed.wrapping_mul(0x9E37_79B9_7F4A_7C15) ^ 0xABCD);
    // 每轮内部 A/B 的先后随机化，轮次本身的顺序也随机化。
    let mut arm_order = Vec::with_capacity(rounds);
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
    csv.push_str("# tidekv A/B paired benchmark\n");
    csv.push_str(&format!("# units={UNITS} (value_ns_per_op column)\n"));
    csv.push_str(&format!(
        "# seed={seed} rounds={rounds} batches_per_round={batches} ops_per_batch={nops} warmup_ms={warm_ms} flush_every={flush_every}\n"
    ));
    csv.push_str(&format!(
        "# {}\n",
        cases
            .iter()
            .map(|c| format!("{}: {}", c.name, c.description))
            .collect::<Vec<_>>()
            .join(" | ")
    ));
    csv.push_str("kind,case,round,arm_order,arm,batch,value_ns_per_op,ops,warm_ns_per_op\n");

    let mut verify = String::new();
    verify.push_str("tide-bench correctness gate: A = RwLock<BTreeMap> baseline, B = tidekv, REF = naive HashMap replay\n");
    verify.push_str("one generated op sequence per case, fed byte-for-byte to all three; state digest compared\n\n");

    let mut mismatch = 0usize;
    let mut rows = 0usize;
    for w in &cases {
        let ops = w.ops.as_slice();
        let ref_map = run_reference(ops);
        let ref_digest = digest_ref(&ref_map);

        let map: Map = RwLock::new(BTreeMap::new());
        run_baseline(&map, ops);
        let a_digest = digest_baseline(&map);
        let mut br = BatchRun::new(flush_every)?;
        br.run(ops)?;
        let b_digest = br.digest()?;
        drop(br);
        let verdict = if a_digest == b_digest && a_digest == ref_digest {
            "MATCH"
        } else {
            mismatch += 1;
            "MISMATCH"
        };
        verify.push_str(&format!(
            "case {} -- {}\n  ops={} live_keys(ref)={} A={:016x} B={:016x} REF={:016x} -> {verdict}\n\n",
            w.name,
            w.description,
            w.nops,
            ref_map.len(),
            a_digest,
            b_digest,
            ref_digest
        ));

        for &r in &round_seq {
            for ai in 0..ARMS.len() {
                let run_a_first = arm_order[r] == "A_then_B";
                let arm = if (ai == 0) == run_a_first { "A" } else { "B" };
                let outcome = run_arm(arm, ops, w.nops, warm, batches, flush_every)?;
                let mean = outcome.batches.iter().sum::<f64>() / outcome.batches.len() as f64;
                for (b, v) in outcome.batches.iter().enumerate() {
                    csv.push_str(&format!(
                        "raw_batch,{case},{round},{order},{arm},{batch},{val:.6},{ops},0\n",
                        case = w.name,
                        round = r,
                        order = arm_order[r],
                        batch = b,
                        val = v,
                        ops = w.nops,
                    ));
                    rows += 1;
                }
                csv.push_str(&format!(
                    "BATCH_MEAN,{case},{round},{order},{arm},-1,{mean:.6},{ops},{warm:.6}\n",
                    case = w.name,
                    round = r,
                    order = arm_order[r],
                    mean = mean,
                    ops = w.nops,
                    warm = outcome.warm_ns_per_op,
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
        "tide-bench: rounds={rounds} batches={batches} ops/batch={nops} warmup_ms={warm_ms} flush_every={flush_every} seed={seed} csv_rows={rows} -> {}",
        out_path.display()
    );
    println!(
        "tide-bench: verification -> {} (digest mismatches = {mismatch})",
        verify_path.display()
    );
    for l in verify
        .lines()
        .filter(|l| l.starts_with("case ") || l.starts_with("  ops="))
    {
        println!("tide-bench: {l}");
    }
    if mismatch > 0 {
        return Err(format!("{mismatch} case(s) where A/B/REF digests differ").into());
    }
    Ok(())
}

fn run_arm(
    arm: &str,
    ops: &[Op],
    nops: usize,
    warm: Duration,
    batches: usize,
    flush_every: usize,
) -> Result<ArmOutcome, Box<dyn Error>> {
    if arm == "A" {
        let owned = ops.to_vec();
        measure(warm, batches, nops, move || {
            let map: Map = RwLock::new(BTreeMap::new());
            run_baseline(&map, &owned);
            Ok(())
        })
    } else {
        let owned = ops.to_vec();
        measure(warm, batches, nops, move || {
            let mut br = BatchRun::new(flush_every)?;
            br.run(&owned)
        })
    }
}
