//! These exports are code-generation probes, not a stable Rust FFI library.
use std::sync::atomic::{AtomicU64, Ordering};

#[no_mangle]
pub extern "C" fn load_relaxed(a: &AtomicU64) -> u64 { a.load(Ordering::Relaxed) }
#[no_mangle]
pub extern "C" fn load_acquire(a: &AtomicU64) -> u64 { a.load(Ordering::Acquire) }
#[no_mangle]
pub extern "C" fn load_seqcst(a: &AtomicU64) -> u64 { a.load(Ordering::SeqCst) }
#[no_mangle]
pub extern "C" fn store_relaxed(a: &AtomicU64, v: u64) { a.store(v, Ordering::Relaxed); }
#[no_mangle]
pub extern "C" fn store_release(a: &AtomicU64, v: u64) { a.store(v, Ordering::Release); }
#[no_mangle]
pub extern "C" fn store_seqcst(a: &AtomicU64, v: u64) { a.store(v, Ordering::SeqCst); }
#[no_mangle]
pub extern "C" fn add_relaxed(a: &AtomicU64, v: u64) { a.fetch_add(v, Ordering::Relaxed); }
#[no_mangle]
pub extern "C" fn add_seqcst(a: &AtomicU64, v: u64) { a.fetch_add(v, Ordering::SeqCst); }
#[no_mangle]
pub extern "C" fn add_return_old(a: &AtomicU64, v: u64) -> u64 { a.fetch_add(v, Ordering::Relaxed) }
