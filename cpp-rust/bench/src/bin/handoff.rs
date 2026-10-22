//! End-to-end transfer of an eight-u64 payload. Fixed one producer / one consumer.
use performance_lab::{ns_per_op, print_stats, slot::Slot};
use std::hint::{black_box, spin_loop};
use std::sync::{mpsc, Barrier};
use std::time::Instant;

#[derive(Debug, PartialEq)]
struct Message([u64; 8]);

fn spin_handoff(iters: u64) -> f64 {
    let mut slot = Slot::new();
    let (mut tx, mut rx) = slot.split();
    let ready = Barrier::new(2);
    let start = Barrier::new(2);
    std::thread::scope(|scope| {
        let (ready, start) = (&ready, &start);
        let writer = scope.spawn(move || {
            ready.wait();
            start.wait();
            for i in 0..iters {
                let mut message = Message([i; 8]);
                loop {
                    match tx.try_send(message) {
                        Ok(()) => break,
                        Err(value) => {
                            message = value;
                            spin_loop();
                        }
                    }
                }
            }
        });
        ready.wait();
        let begin = Instant::now();
        start.wait();
        for i in 0..iters {
            let message = loop {
                if let Some(value) = rx.try_recv() {
                    break value;
                }
                spin_loop();
            };
            assert_eq!(black_box(message), Message([i; 8]));
        }
        let elapsed = begin.elapsed();
        writer.join().expect("producer panicked");
        ns_per_op(elapsed, iters)
    })
}

fn channel_handoff(iters: u64) -> f64 {
    let (tx, rx) = mpsc::sync_channel(1);
    let ready = Barrier::new(2);
    let start = Barrier::new(2);
    std::thread::scope(|scope| {
        let (ready, start) = (&ready, &start);
        let writer = scope.spawn(move || {
            ready.wait();
            start.wait();
            for i in 0..iters {
                tx.send(Message([i; 8])).expect("consumer disconnected");
            }
        });
        ready.wait();
        let begin = Instant::now();
        start.wait();
        for i in 0..iters {
            assert_eq!(
                black_box(rx.recv().expect("producer disconnected")),
                Message([i; 8])
            );
        }
        let elapsed = begin.elapsed();
        writer.join().expect("producer panicked");
        ns_per_op(elapsed, iters)
    })
}

fn main() {
    let args: Vec<_> = std::env::args().collect();
    let iters: u64 = args
        .get(1)
        .map(|s| s.parse().expect("iterations: integer"))
        .unwrap_or(20_000);
    let samples: usize = args
        .get(2)
        .map(|s| s.parse().expect("samples: integer"))
        .unwrap_or(21);
    assert!((1..=1_000_000).contains(&iters) && (2..=1000).contains(&samples));
    println!(
        "iterations={iters} samples={samples} payload_size={} payload_align={}",
        size_of::<Message>(),
        align_of::<Message>()
    );
    println!("case,sample,ns_per_message");
    black_box(spin_handoff(iters));
    black_box(channel_handoff(iters));
    let mut spin = Vec::new();
    let mut channel = Vec::new();
    for sample in 0..samples {
        for step in 0..2 {
            if (sample + step) % 2 == 0 {
                let value = spin_handoff(iters);
                println!("slot,{sample},{value:.6}");
                spin.push(value);
            } else {
                let value = channel_handoff(iters);
                println!("sync_channel,{sample},{value:.6}");
                channel.push(value);
            }
        }
    }
    print_stats("slot", &spin);
    print_stats("sync_channel", &channel);
}
