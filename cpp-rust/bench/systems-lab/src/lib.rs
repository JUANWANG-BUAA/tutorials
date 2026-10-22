use crossbeam_epoch::{Collector, LocalHandle};
use crossbeam_queue::ArrayQueue;
use std::collections::VecDeque;
use std::hint::black_box;
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::{Arc, Barrier, Mutex};
use std::time::{Duration, Instant};

pub const SAMPLES: usize = 21;

/// Each observation is a complete batch, not a request-latency sample.
pub fn measure<F>(names: &[&str], units: usize, mut run: F)
where
    F: FnMut(usize) -> u64,
{
    assert!(units > 0);
    let start = Instant::now();
    let mut warm = 0;
    while start.elapsed() < Duration::from_millis(500) {
        for case in 0..names.len() {
            black_box(run(case));
        }
        warm += 1;
    }
    println!(
        "warmup_ns={} rounds={warm} units={units}",
        start.elapsed().as_nanos()
    );
    let mut samples = vec![Vec::new(); names.len()];
    for round in 0..SAMPLES {
        for offset in 0..names.len() {
            let case = (round + offset) % names.len();
            let start = Instant::now();
            let checksum = black_box(run(case));
            let ns = start.elapsed().as_nanos();
            let value = ns as f64 / units as f64;
            println!("raw,{},{round},{ns},{units},{checksum}", names[case]);
            samples[case].push(value);
        }
    }
    for (name, mut values) in names.iter().zip(samples) {
        let mean = values.iter().sum::<f64>() / SAMPLES as f64;
        let sd =
            (values.iter().map(|v| (v - mean).powi(2)).sum::<f64>() / (SAMPLES - 1) as f64).sqrt();
        values.sort_by(f64::total_cmp);
        println!(
            "summary,{name},mean={mean:.6},sd={sd:.6},p50={:.6},p99={:.6},unit=ns/unit,n={SAMPLES}",
            values[10], values[20]
        );
    }
}

pub enum Queue {
    Ring(Box<ArrayQueue<u64>>),
    Locked(Mutex<VecDeque<u64>>, usize),
}

impl Queue {
    pub fn new(ring: bool, capacity: usize) -> Self {
        assert!(capacity > 0);
        if ring {
            Self::Ring(Box::new(ArrayQueue::new(capacity)))
        } else {
            Self::Locked(Mutex::new(VecDeque::with_capacity(capacity)), capacity)
        }
    }

    pub fn push(&self, value: u64) -> Result<(), u64> {
        match self {
            Self::Ring(q) => q.push(value),
            Self::Locked(q, capacity) => {
                let mut q = q.lock().expect("queue mutex poisoned");
                if q.len() == *capacity {
                    Err(value)
                } else {
                    q.push_back(value);
                    Ok(())
                }
            }
        }
    }

    pub fn pop(&self) -> Option<u64> {
        match self {
            Self::Ring(q) => q.pop(),
            Self::Locked(q, _) => q.lock().expect("queue mutex poisoned").pop_front(),
        }
    }
}

/// Includes allocation, spawning, barriers, retries, joining and validation.
pub fn queue_batch(ring: bool, each: usize) -> u64 {
    let q = Queue::new(ring, 1024);
    let ready = Barrier::new(4);
    let total = each * 2;
    let next = AtomicUsize::new(0);
    let results = std::thread::scope(|scope| {
        for producer in 0..2 {
            let q = &q;
            let ready = &ready;
            scope.spawn(move || {
                ready.wait();
                for index in 0..each {
                    let mut value = (producer * each + index) as u64;
                    while let Err(v) = q.push(value) {
                        value = v;
                        std::hint::spin_loop();
                    }
                }
            });
        }
        let mut consumers = Vec::new();
        for _ in 0..2 {
            let q = &q;
            let ready = &ready;
            let next = &next;
            consumers.push(scope.spawn(move || {
                ready.wait();
                let mut received = Vec::with_capacity(each);
                loop {
                    let ticket = next.fetch_add(1, Ordering::Relaxed);
                    if ticket >= total {
                        break;
                    }
                    loop {
                        if let Some(v) = q.pop() {
                            received.push(v);
                            break;
                        }
                        std::hint::spin_loop();
                    }
                }
                received
            }));
        }
        consumers
            .into_iter()
            .flat_map(|h| h.join().expect("consumer panic"))
            .collect::<Vec<_>>()
    });
    // Exact multiset validation: a checksum alone cannot detect all duplicates.
    let mut sorted = results;
    sorted.sort_unstable();
    assert_eq!(sorted.len(), total);
    assert!(sorted.iter().enumerate().all(|(i, &v)| v == i as u64));
    assert_eq!(q.pop(), None);
    sorted.iter().sum()
}

pub struct Retired {
    payload: Box<[u8; 256]>,
    dropped: Arc<AtomicUsize>,
}

impl Drop for Retired {
    fn drop(&mut self) {
        black_box(self.payload[0]);
        self.dropped.fetch_add(1, Ordering::Relaxed);
    }
}

pub fn retire(handle: &LocalHandle, dropped: &Arc<AtomicUsize>, count: usize) {
    for id in 0..count {
        let guard = handle.pin();
        let item = Retired {
            payload: Box::new([id as u8; 256]),
            dropped: Arc::clone(dropped),
        };
        // Safe defer requires Send + 'static. No shared raw pointer is involved.
        guard.defer(move || drop(item));
        if id % 32 == 31 {
            guard.flush();
        }
    }
    handle.pin().flush();
}

pub fn drain(handle: &LocalHandle, dropped: &AtomicUsize, expected: usize) {
    // A test deadline, NOT a library guarantee about reclamation latency.
    let start = Instant::now();
    while dropped.load(Ordering::Relaxed) != expected {
        assert!(
            start.elapsed() < Duration::from_secs(5),
            "reclamation did not drain"
        );
        handle.pin().flush();
        std::thread::yield_now();
    }
}

pub fn epoch_batch(stalled: bool, count: usize) -> u64 {
    let collector = Collector::new();
    let holder = collector.register();
    let worker = collector.register();
    let dropped = Arc::new(AtomicUsize::new(0));
    let guard = stalled.then(|| holder.pin());
    retire(&worker, &dropped, count);
    let retained = count - dropped.load(Ordering::Relaxed);
    if stalled {
        assert_eq!(retained, count);
    }
    drop(guard);
    drain(&worker, &dropped, count);
    assert_eq!(dropped.load(Ordering::Relaxed), count);
    // Retained is intentionally NOT the checksum: both cases perform identical drops.
    black_box(retained);
    count as u64
}

#[inline(never)]
pub fn scalar_step(x: u32) -> u32 {
    black_box(x).wrapping_mul(3).wrapping_add(7)
}

#[inline(never)]
pub fn scalar_transform(input: &[u32], output: &mut [u32]) {
    assert_eq!(input.len(), output.len());
    for (x, y) in input.iter().zip(output) {
        *y = scalar_step(*x);
    }
}

#[inline(never)]
pub fn auto_transform(input: &[u32], output: &mut [u32]) {
    assert_eq!(input.len(), output.len());
    for (x, y) in input.iter().zip(output) {
        *y = x.wrapping_mul(3).wrapping_add(7);
    }
}

#[cfg(target_arch = "aarch64")]
#[target_feature(enable = "neon")]
unsafe fn neon_inner(input: &[u32], output: &mut [u32]) {
    use std::arch::aarch64::*;
    let mut i = 0;
    let multiplier = vdupq_n_u32(3);
    let addend = vdupq_n_u32(7);
    while input.len() - i >= 4 {
        // SAFETY: i..i+4 lies within both live slices (equal lengths checked by
        // wrapper). u32 loads/stores accept this alignment; input is shared,
        // output exclusively borrowed, hence no overlap. No pointer escapes.
        unsafe {
            let x = vld1q_u32(input.as_ptr().add(i));
            let y = vaddq_u32(vmulq_u32(x, multiplier), addend);
            vst1q_u32(output.as_mut_ptr().add(i), y);
        }
        i += 4;
    }
    auto_transform(&input[i..], &mut output[i..]);
}

#[inline(never)]
pub fn neon_transform(input: &[u32], output: &mut [u32]) {
    assert_eq!(input.len(), output.len());
    #[cfg(target_arch = "aarch64")]
    {
        assert!(std::arch::is_aarch64_feature_detected!("neon"));
        // SAFETY: runtime detection establishes the feature; equal slices and
        // exclusive output establish memory preconditions of neon_inner.
        unsafe { neon_inner(input, output) }
    }
    #[cfg(not(target_arch = "aarch64"))]
    auto_transform(input, output);
}

pub fn make_input(n: usize) -> Vec<u32> {
    (0..n)
        .map(|i| (i as u32).wrapping_mul(0x9e37_79b9))
        .collect()
}

#[derive(Debug, PartialEq, Eq)]
pub enum ParseError {
    Truncated,
    TooLarge,
    Trailing,
}

pub fn encode_frames(count: usize, length: usize) -> Vec<u8> {
    let length32 = u32::try_from(length).expect("frame length fits u32");
    let mut bytes = Vec::new();
    for id in 0..count {
        bytes.extend_from_slice(&length32.to_le_bytes());
        bytes.extend((0..length).map(|j| (id.wrapping_add(j)) as u8));
    }
    bytes
}

/// The returned view cannot outlive `bytes`; malformed inputs never create pointers.
pub fn next_frame(bytes: &[u8], limit: usize) -> Result<(&[u8], &[u8]), ParseError> {
    let header = bytes.get(..4).ok_or(ParseError::Truncated)?;
    let length = u32::from_le_bytes(header.try_into().expect("four bytes")) as usize;
    if length > limit {
        return Err(ParseError::TooLarge);
    }
    let rest = &bytes[4..];
    let payload = rest.get(..length).ok_or(ParseError::Truncated)?;
    Ok((payload, &rest[length..]))
}

#[inline(never)]
pub fn consume_frame(payload: &[u8]) -> u64 {
    // Sparse access makes the avoided copy visible, not a full checksum bandwidth test.
    payload.iter().step_by(64).map(|&v| u64::from(v)).sum()
}

pub fn view_batch(bytes: &[u8], count: usize, copy: bool) -> u64 {
    let mut rest = bytes;
    let mut sum = 0;
    for _ in 0..count {
        let (payload, tail) = next_frame(rest, 4096).expect("valid generated frame");
        sum += if copy {
            let owned = black_box(payload.to_vec());
            consume_frame(black_box(&owned))
        } else {
            consume_frame(black_box(payload))
        };
        rest = tail;
    }
    assert!(rest.is_empty(), "unexpected trailing data");
    sum
}
