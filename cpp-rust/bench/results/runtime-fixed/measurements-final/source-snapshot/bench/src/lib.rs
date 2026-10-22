//! Small measurement helpers. A sample is a batch average, not a request percentile.
use std::time::Duration;

pub mod park;
pub mod slot;

#[derive(Debug, PartialEq)]
pub struct Stats {
    pub mean: f64,
    pub stddev: f64,
    pub p50: f64,
    pub p99: f64,
}

/// Nearest-rank quantiles, sample standard deviation (N - 1 denominator).
pub fn summarize(values: &[f64]) -> Stats {
    assert!(values.len() >= 2, "need at least two samples");
    assert!(values.iter().all(|v| v.is_finite() && *v >= 0.0));
    let mut sorted = values.to_vec();
    sorted.sort_by(f64::total_cmp);
    let n = values.len() as f64;
    let mean = values.iter().sum::<f64>() / n;
    let stddev = (values.iter().map(|v| (v - mean).powi(2)).sum::<f64>() / (n - 1.0)).sqrt();
    let rank = |p: f64| sorted[(p * n).ceil() as usize - 1];
    Stats {
        mean,
        stddev,
        p50: rank(0.5),
        p99: rank(0.99),
    }
}

pub fn ns_per_op(elapsed: Duration, operations: u64) -> f64 {
    assert!(operations > 0);
    elapsed.as_secs_f64() * 1e9 / operations as f64
}

pub fn print_stats(name: &str, values: &[f64]) {
    let s = summarize(values);
    println!(
        "{name}: mean={:.3} sd={:.3} batch_p50={:.3} batch_p99={:.3} ns/op n={}",
        s.mean,
        s.stddev,
        s.p50,
        s.p99,
        values.len()
    );
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn nearest_rank_and_sample_variance() {
        let s = summarize(&[4.0, 1.0, 3.0, 2.0]);
        assert_eq!(s.mean, 2.5);
        assert_eq!(s.p50, 2.0);
        assert_eq!(s.p99, 4.0);
        assert!((s.stddev - (5.0_f64 / 3.0).sqrt()).abs() < 1e-12);
    }

    #[test]
    fn flat_distribution() {
        assert_eq!(summarize(&[7.0; 10]).stddev, 0.0);
    }
}
