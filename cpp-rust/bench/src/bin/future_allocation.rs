//! Deliberately escaping pins keep the storage strategy visible to the compiler.
//! Measures allocation + initialization + one Ready poll + destruction, not Pin alone.
use performance_lab::{ns_per_op, print_stats};
use std::future::Future;
use std::hint::black_box;
use std::pin::{pin, Pin};
use std::task::{Context, Poll, Waker};
use std::time::{Duration, Instant};

async fn ready(payload: [u8; 256]) -> u64 {
    black_box(payload[0] as u64)
}

#[inline(never)]
fn drive<F: Future<Output = u64>>(future: Pin<&mut F>, cx: &mut Context<'_>) -> u64 {
    match future.poll(cx) {
        Poll::Ready(value) => value,
        Poll::Pending => panic!("ready future unexpectedly pending"),
    }
}

fn batch(heap: bool, iters: u64) -> f64 {
    let mut context = Context::from_waker(Waker::noop());
    let begin = Instant::now();
    let mut sum = 0u64;
    for _ in 0..iters {
        let payload = black_box([7u8; 256]);
        let value = if heap {
            let mut future = Box::pin(ready(payload));
            drive(black_box(future.as_mut()), &mut context)
        } else {
            let future = pin!(ready(payload));
            drive(black_box(future), &mut context)
        };
        sum += black_box(value);
    }
    let elapsed = begin.elapsed();
    assert_eq!(sum, iters * 7);
    ns_per_op(elapsed, iters)
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
        "iterations={iters} samples={samples} future_size={}",
        size_of_val(&ready([7; 256]))
    );
    println!("case,sample,ns_per_ready_future");
    let warmup = Instant::now();
    while warmup.elapsed() < Duration::from_millis(500) {
        black_box(batch(false, iters));
        black_box(batch(true, iters));
    }
    let mut stack = Vec::new();
    let mut heap = Vec::new();
    for sample in 0..samples {
        for offset in 0..2 {
            let is_heap = (sample + offset) % 2 != 0;
            let value = batch(is_heap, iters);
            println!(
                "{},{sample},{value:.6}",
                if is_heap { "box" } else { "stack" }
            );
            if is_heap {
                heap.push(value);
            } else {
                stack.push(value);
            }
        }
    }
    print_stats("stack-pin", &stack);
    print_stats("box-pin", &heap);
}
