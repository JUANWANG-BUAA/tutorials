use performance_lab::{ns_per_op, park::block_on, print_stats};
use std::future::Future;
use std::hint::black_box;
use std::pin::Pin;
use std::task::{Context, Poll};
use std::time::Instant;

struct YieldOnce(bool);
impl Future for YieldOnce {
    type Output = ();
    fn poll(mut self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<()> {
        if self.0 {
            Poll::Ready(())
        } else {
            self.0 = true;
            cx.waker().wake_by_ref();
            Poll::Pending
        }
    }
}

#[inline(never)]
fn sync_sum(iters: u64) -> u64 {
    let mut sum = 0u64;
    for i in 0..iters {
        sum = sum.wrapping_add(black_box(i));
    }
    sum
}

async fn async_sum(iters: u64, yielding: bool) -> u64 {
    let mut sum = 0u64;
    for i in 0..iters {
        if yielding {
            YieldOnce(false).await;
        }
        sum = sum.wrapping_add(black_box(i));
    }
    sum
}

fn main() {
    let args: Vec<_> = std::env::args().collect();
    let iters: u64 = args
        .get(1)
        .map(|s| s.parse().expect("iterations: integer"))
        .unwrap_or(100_000);
    let samples: usize = args
        .get(2)
        .map(|s| s.parse().expect("samples: integer"))
        .unwrap_or(21);
    assert!((1..=10_000_000).contains(&iters) && (2..=1000).contains(&samples));
    println!(
        "iterations={iters} samples={samples} future_size={} future_align={}",
        size_of_val(&async_sum(iters, true)),
        align_of_val(&async_sum(iters, true))
    );
    println!("case,sample,ns_per_element");
    let mut results: Vec<Vec<f64>> = vec![Vec::new(); 3];
    let expected = (iters - 1) * iters / 2;
    for sample in 0..=samples {
        for offset in 0..3 {
            let mode = (sample + offset) % 3;
            let begin = Instant::now();
            let sum = match mode {
                0 => sync_sum(black_box(iters)),
                1 => block_on(async_sum(black_box(iters), false)),
                _ => block_on(async_sum(black_box(iters), true)),
            };
            let value = ns_per_op(begin.elapsed(), iters);
            assert_eq!(black_box(sum), expected);
            if sample != 0 {
                println!("{mode},{},{value:.6}", sample - 1);
                results[mode].push(value);
            }
        }
    }
    for (name, values) in ["sync", "async-ready", "async-self-wake"]
        .iter()
        .zip(results.iter())
    {
        print_stats(name, values);
    }
}
