//! Small, safe workloads for evidence collection, not a profiler implementation.
use std::hint::black_box;
use std::sync::atomic::{AtomicU64, Ordering};
use std::time::{Duration, Instant};

/// A fixed-size event value; it is not a serialized format.
#[derive(Clone, Copy, Debug)]
pub struct Event {
    /// Logical operation identifier.
    pub id: u64,
    /// Elapsed nanoseconds at the observation site.
    pub elapsed_ns: u64,
}

/// A deliberately non-inlined arithmetic kernel with defined overflow.
#[inline(never)]
pub fn mix(value: u64) -> u64 {
    black_box(value)
        .rotate_left(9)
        .wrapping_mul(0x9e37_79b9_7f4a_7c15)
        .wrapping_add(17)
}

/// Compute a reproducible checksum over exactly `count` steps.
pub fn compute(count: u64) -> u64 {
    let mut value = 7;
    for _ in 0..count {
        value = mix(value);
    }
    value
}

/// Instrumentation modes intentionally change the observation granularity.
#[derive(Clone, Copy, Debug)]
pub enum Mode {
    /// No per-operation observations.
    None,
    /// One local counter and one atomic commit per batch.
    Batch,
    /// A timestamp and atomic commit for every operation.
    Each,
}

/// Return both the workload checksum and the number of recorded operations.
pub fn observed(count: u64, mode: Mode) -> (u64, u64) {
    let counter = AtomicU64::new(0);
    let mut value = 7;
    for id in 0..count {
        let clock = matches!(mode, Mode::Each).then(Instant::now);
        value = mix(value);
        if let Some(clock) = clock {
            black_box(Event {
                id,
                elapsed_ns: clock.elapsed().as_nanos() as u64,
            });
            counter.fetch_add(1, Ordering::Relaxed);
        }
    }
    if matches!(mode, Mode::Batch) {
        counter.fetch_add(count, Ordering::Relaxed);
    }
    (value, counter.load(Ordering::Relaxed))
}

/// Sum bytes; `checked` intentionally adds observable per-byte audit work.
///
/// Both feature configurations preserve the returned value.
/// ```
/// assert_eq!(evidence_lab::sum_bytes(&[1, 2, 255]), 258);
/// ```
pub fn sum_bytes(bytes: &[u8]) -> u64 {
    bytes
        .iter()
        .map(|&byte| {
            #[cfg(feature = "checked")]
            black_box(Event {
                id: u64::from(byte),
                elapsed_ns: 0,
            });
            u64::from(byte)
        })
        .sum()
}

/// Reject incomplete evidence before a performance comparison.
pub fn complete_samples(samples: &[f64]) -> Result<(), &'static str> {
    if samples.len() != 21 {
        return Err("expected exactly 21 observations");
    }
    if samples.iter().any(|x| !x.is_finite() || *x <= 0.0) {
        return Err("observations must be finite and positive");
    }
    Ok(())
}

/// Nearest-rank quantile, used only after validating nonempty observations.
pub fn nearest_rank(sorted: &[f64], probability: f64) -> f64 {
    let rank = (probability * sorted.len() as f64).ceil() as usize;
    sorted[rank.max(1) - 1]
}

/// Warm up a workload for at least half a second; initialization is not timed.
pub fn warm(mut work: impl FnMut()) {
    let start = Instant::now();
    while start.elapsed() < Duration::from_millis(500) {
        work();
    }
}

/// Print descriptive statistics of 21 batch observations, not request latency.
pub fn report(case: &str, samples: &[f64]) {
    complete_samples(samples).expect("valid measurements");
    let mean = samples.iter().sum::<f64>() / samples.len() as f64;
    let sd = (samples.iter().map(|x| (x - mean).powi(2)).sum::<f64>() / (samples.len() - 1) as f64)
        .sqrt();
    let mut sorted = samples.to_vec();
    sorted.sort_by(f64::total_cmp);
    println!(
        "summary,{case},n={},mean={mean:.6},sd={sd:.6},p50={:.6},p99={:.6}",
        samples.len(),
        nearest_rank(&sorted, 0.5),
        nearest_rank(&sorted, 0.99)
    );
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn observation_does_not_change_business_result() {
        let expected = compute(1024);
        assert_eq!(observed(1024, Mode::None), (expected, 0));
        assert_eq!(observed(1024, Mode::Batch), (expected, 1024));
        assert_eq!(observed(1024, Mode::Each), (expected, 1024));
    }
    #[test]
    fn feature_result_matches_reference() {
        let data: Vec<u8> = (0..=255).cycle().take(4099).collect();
        assert_eq!(
            sum_bytes(&data),
            data.iter().fold(0, |a, b| a + u64::from(*b))
        );
        assert_eq!(sum_bytes(&[]), 0);
    }
    #[test]
    fn reject_missing_or_invalid_samples() {
        assert!(complete_samples(&[1.0; 20]).is_err());
        assert!(complete_samples(&[f64::NAN; 21]).is_err());
        assert!(complete_samples(&[0.0; 21]).is_err());
        assert!(complete_samples(&[1.0; 21]).is_ok());
    }
    #[test]
    fn small_sample_p99_is_maximum() {
        let sorted: Vec<_> = (1..=21).map(f64::from).collect();
        assert_eq!(nearest_rank(&sorted, 0.5), 11.0);
        assert_eq!(nearest_rank(&sorted, 0.99), 21.0);
    }
    #[test]
    fn batch_counter_loses_distribution_not_count() {
        let (_, count) = observed(129, Mode::Batch);
        assert_eq!(count, 129);
        assert_ne!(std::mem::size_of::<Event>(), 0);
    }
}
