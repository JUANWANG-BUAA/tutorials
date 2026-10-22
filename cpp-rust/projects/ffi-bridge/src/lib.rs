//! Integer data component; the C surface never exposes a Rust allocation pointer.
//!
//! All pointer-taking exports require the caller contract in `include/bridge.h`.
//! Numeric checks reject common mistakes, not arbitrary invalid allocations.
#![deny(unsafe_op_in_unsafe_fn)]

use std::mem::{align_of, size_of};
use std::panic::{AssertUnwindSafe, catch_unwind};
use std::sync::{Arc, Mutex, OnceLock};

pub const OK: i32 = 0;
pub const EINVAL: i32 = 1;
pub const ERANGE: i32 = 2;
pub const ESTALE: i32 = 3;
pub const ECAPACITY: i32 = 4;
pub const EPANIC: i32 = 5;
pub const EPOISON: i32 = 6;
pub const ERESOURCE: i32 = 7;
pub const VERSION: u32 = 1;
pub const MAX_WORDS: usize = 1 << 24;
const MAX_SLOTS: usize = 4096;

/// Fixed-width metadata. Offsets and alignment are checked by both languages.
#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct InfoV1 {
    pub abi_version: u32,
    pub struct_size: u32,
    pub len: u64,
    pub checksum: u64,
}

/// Wrapping arithmetic is intentional: every u64 input is valid.
#[inline]
pub fn mix(value: u64) -> u64 {
    (value ^ (value >> 29))
        .wrapping_mul(0x9e37_79b9_7f4a_7c15)
        .wrapping_add(0x243f_6a88_85a3_08d3)
}

/// Rust callers use slices; no registry or C pointers are needed.
pub fn transform(input: &[u64], output: &mut [u64]) -> Result<(), i32> {
    if input.len() != output.len() {
        return Err(ECAPACITY);
    }
    for (source, dest) in input.iter().zip(output) {
        *dest = mix(*source);
    }
    Ok(())
}

pub fn checksum(values: &[u64]) -> u64 {
    values.iter().fold(0, |sum, x| sum.wrapping_add(*x))
}

#[derive(Default)]
struct Slot {
    generation: u32,
    data: Option<Arc<[u64]>>,
}

#[derive(Default)]
struct Registry {
    slots: Vec<Slot>,
}

impl Registry {
    fn insert(&mut self, data: Arc<[u64]>) -> Result<u64, i32> {
        // Generation MAX is retired instead of wrapping to an old identity.
        if let Some((index, slot)) = self
            .slots
            .iter_mut()
            .enumerate()
            .find(|(_, slot)| slot.data.is_none() && slot.generation < u32::MAX)
        {
            slot.generation += 1;
            slot.data = Some(data);
            return Ok((u64::from(slot.generation) << 32) | (index as u64 + 1));
        }
        if self.slots.len() == MAX_SLOTS {
            return Err(ERESOURCE);
        }
        self.slots.try_reserve(1).map_err(|_| ERESOURCE)?;
        self.slots.push(Slot {
            generation: 1,
            data: Some(data),
        });
        Ok((1u64 << 32) | self.slots.len() as u64)
    }

    fn locate(&mut self, handle: u64) -> Result<&mut Slot, i32> {
        let low = handle as u32;
        if low == 0 {
            return Err(ESTALE);
        }
        let slot = self.slots.get_mut(low as usize - 1).ok_or(ESTALE)?;
        if slot.generation != (handle >> 32) as u32 || slot.data.is_none() {
            return Err(ESTALE);
        }
        Ok(slot)
    }

    fn snapshot(&mut self, handle: u64) -> Result<Arc<[u64]>, i32> {
        self.locate(handle)?.data.as_ref().cloned().ok_or(ESTALE)
    }

    fn release(&mut self, handle: u64) -> Result<Arc<[u64]>, i32> {
        self.locate(handle)?.data.take().ok_or(ESTALE)
    }
}

static REGISTRY: OnceLock<Mutex<Registry>> = OnceLock::new();

fn registry() -> &'static Mutex<Registry> {
    REGISTRY.get_or_init(|| Mutex::new(Registry::default()))
}

fn snapshot(handle: u64) -> Result<Arc<[u64]>, i32> {
    registry().lock().map_err(|_| EPOISON)?.snapshot(handle)
}

fn boundary(f: impl FnOnce() -> Result<(), i32>) -> i32 {
    match catch_unwind(AssertUnwindSafe(f)) {
        Ok(Ok(())) => OK,
        Ok(Err(code)) => code,
        Err(payload) => {
            // A user-defined panic payload could itself panic in Drop.
            // Exceptional path deliberately leaks the payload, not a data handle.
            std::mem::forget(payload);
            EPANIC
        }
    }
}

fn range<T>(ptr: *const T, len: usize) -> Result<(usize, usize), i32> {
    if len == 0 {
        return Ok((0, 0));
    }
    if ptr.is_null() || !(ptr as usize).is_multiple_of(align_of::<T>()) {
        return Err(EINVAL);
    }
    let bytes = len.checked_mul(size_of::<T>()).ok_or(ERANGE)?;
    if bytes > isize::MAX as usize {
        return Err(ERANGE);
    }
    let start = ptr as usize;
    Ok((start, start.checked_add(bytes).ok_or(ERANGE)?))
}

fn separate(a: (usize, usize), b: (usize, usize)) -> Result<(), i32> {
    if a.0 < b.1 && b.0 < a.1 {
        Err(EINVAL)
    } else {
        Ok(())
    }
}

fn checked_len(len: u64) -> Result<usize, i32> {
    let len = usize::try_from(len).map_err(|_| ERANGE)?;
    if len > MAX_WORDS {
        return Err(ERANGE);
    }
    Ok(len)
}

/// # Safety
/// `out` is an aligned writable u64 for the duration of the call.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn rb_mix(value: u64, out: *mut u64) -> i32 {
    boundary(|| {
        range(out, 1)?;
        // SAFETY: caller supplies writable storage; range checked null/alignment.
        unsafe { out.write(mix(value)) };
        Ok(())
    })
}

/// # Safety
/// Input and output are live, initialized/input and writable/output allocations
/// of `len` words, disjoint and not concurrently mutated. Null is allowed at zero.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn rb_transform(input: *const u64, out: *mut u64, len: u64) -> i32 {
    boundary(|| {
        let len = checked_len(len)?;
        separate(range(input, len)?, range(out, len)?)?;
        if len != 0 {
            // SAFETY: numeric checks above plus the caller's allocation/lifetime
            // and nonaliasing guarantees establish both slices for this call.
            let input = unsafe { std::slice::from_raw_parts(input, len) };
            // SAFETY: output is disjoint, writable and exclusively borrowed.
            let output = unsafe { std::slice::from_raw_parts_mut(out, len) };
            transform(input, output)?;
        }
        Ok(())
    })
}

/// # Safety
/// `out_handle` is writable and disjoint from `input[0..len]`. Input stays live
/// and immutable until return. Success copies input; no C allocation is adopted.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn rb_create_copy(input: *const u64, len: u64, out_handle: *mut u64) -> i32 {
    boundary(|| {
        let len = checked_len(len)?;
        separate(range(input, len)?, range(out_handle, 1)?)?;
        let mut data = Vec::new();
        data.try_reserve_exact(len).map_err(|_| ERESOURCE)?;
        if len != 0 {
            // SAFETY: caller owns initialized, immutable words for this call.
            data.extend_from_slice(unsafe { std::slice::from_raw_parts(input, len) });
        }
        let handle = registry()
            .lock()
            .map_err(|_| EPOISON)?
            .insert(Arc::from(data))?;
        // SAFETY: checked metadata and caller's writable storage contract.
        unsafe { out_handle.write(handle) };
        Ok(())
    })
}

/// # Safety
/// `out_handle` is an aligned writable u64; only success changes its value.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn rb_generate(seed: u64, len: u64, out_handle: *mut u64) -> i32 {
    boundary(|| {
        range(out_handle, 1)?;
        let len = checked_len(len)?;
        let mut data = Vec::new();
        data.try_reserve_exact(len).map_err(|_| ERESOURCE)?;
        data.extend((0..len).map(|i| mix(seed.wrapping_add(i as u64))));
        let handle = registry()
            .lock()
            .map_err(|_| EPOISON)?
            .insert(Arc::from(data))?;
        // SAFETY: caller guarantees output validity and exclusive access.
        unsafe { out_handle.write(handle) };
        Ok(())
    })
}

/// # Safety
/// `out` points to writable InfoV1 storage, aligned, live and exclusive.
/// `version` must be 1 and `bytes` must equal size_of::<InfoV1>().
#[unsafe(no_mangle)]
pub unsafe extern "C" fn rb_info(handle: u64, version: u32, bytes: u32, out: *mut InfoV1) -> i32 {
    boundary(|| {
        if version != VERSION || bytes as usize != size_of::<InfoV1>() {
            return Err(EINVAL);
        }
        range(out, 1)?;
        let data = snapshot(handle)?;
        let info = InfoV1 {
            abi_version: VERSION,
            struct_size: size_of::<InfoV1>() as u32,
            len: data.len() as u64,
            checksum: checksum(&data),
        };
        // SAFETY: full output object is initialized, no Rust references escape.
        unsafe { out.write(info) };
        Ok(())
    })
}

/// # Safety
/// `out[0..capacity]` is writable, live and exclusive. `written` is a writable
/// u64 disjoint from that region. Null out is allowed only at zero capacity.
/// On error neither output changes; capacity must cover the complete object.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn rb_copy(
    handle: u64,
    out: *mut u64,
    capacity: u64,
    written: *mut u64,
) -> i32 {
    boundary(|| {
        let capacity = checked_len(capacity)?;
        separate(range(out, capacity)?, range(written, 1)?)?;
        let data = snapshot(handle)?;
        if capacity < data.len() {
            return Err(ECAPACITY);
        }
        if !data.is_empty() {
            // SAFETY: registry storage is never exported; caller's output is a
            // separate live allocation with sufficient capacity, no aliases.
            unsafe { std::ptr::copy_nonoverlapping(data.as_ptr(), out, data.len()) };
        }
        // SAFETY: caller provides writable metadata disjoint from output.
        unsafe { written.write(data.len() as u64) };
        Ok(())
    })
}

/// Release consumes the registry ownership once. Concurrent snapshots may finish.
#[unsafe(no_mangle)]
pub extern "C" fn rb_release(handle: u64) -> i32 {
    boundary(|| {
        let data = registry().lock().map_err(|_| EPOISON)?.release(handle)?;
        // Do not free a large allocation while holding the registry lock.
        drop(data);
        Ok(())
    })
}

#[cfg(feature = "test-hooks")]
#[unsafe(no_mangle)]
pub extern "C" fn rb_test_panic() -> i32 {
    boundary(|| panic!("intentional FFI boundary probe"))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn retirement_never_wraps_generation() {
        let mut r = Registry {
            slots: vec![Slot {
                generation: u32::MAX,
                data: None,
            }],
        };
        let h = r.insert(Arc::from([1u64])).expect("insert new slot");
        assert_eq!(h as u32, 2);
        assert_eq!(r.snapshot((u64::from(u32::MAX) << 32) | 1), Err(ESTALE));
    }

    #[test]
    fn bounded_registry_and_reuse() {
        let mut r = Registry::default();
        let mut handles = Vec::new();
        for _ in 0..MAX_SLOTS {
            handles.push(r.insert(Arc::from([])).expect("available slot"));
        }
        assert_eq!(r.insert(Arc::from([])), Err(ERESOURCE));
        let old = handles[0];
        drop(r.release(old).expect("first release"));
        let next = r.insert(Arc::from([])).expect("reuse slot");
        assert_ne!(next, old);
        assert_eq!(r.release(old), Err(ESTALE));
    }

    #[test]
    fn snapshot_keeps_data_after_release() {
        let mut r = Registry::default();
        let h = r.insert(Arc::from([3u64, 5])).expect("insert");
        let copy = r.snapshot(h).expect("snapshot");
        drop(r.release(h).expect("release"));
        assert_eq!(checksum(&copy), 8);
        assert_eq!(r.snapshot(h), Err(ESTALE));
    }

    #[test]
    fn panic_boundary_and_poison_policy() {
        assert_eq!(boundary(|| panic!("safe regression")), EPANIC);
        let local = Mutex::new(Registry::default());
        let _ = catch_unwind(|| {
            let _guard = local.lock().expect("initial lock");
            panic!("poison only the local registry");
        });
        assert!(local.is_poisoned());
        assert_eq!(local.lock().map_err(|_| EPOISON).err(), Some(EPOISON));
    }
}
