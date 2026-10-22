use foundations_lab::{ByteRegion, Record};
use std::mem::{align_of, offset_of, size_of};
use std::num::NonZeroU64;

#[repr(C)]
struct COrder {
    tag: u8,
    value: u64,
    short: u16,
}
struct RustOrder {
    tag: u8,
    value: u64,
    short: u16,
}
#[repr(transparent)]
struct Handle(NonZeroU64);
fn show<T>(name: &str) {
    println!("{name},{},{}", size_of::<T>(), align_of::<T>());
}
fn main() {
    println!("type,size,align");
    show::<COrder>("COrder");
    show::<RustOrder>("RustOrder");
    show::<Record>("Record");
    show::<Option<NonZeroU64>>("Option<NonZeroU64>");
    show::<Option<u64>>("Option<u64>");
    show::<Option<Handle>>("Option<Handle>");
    show::<&[u64]>("&[u64]");
    show::<Vec<u64>>("Vec<u64>");
    show::<ByteRegion>("ByteRegion");
    println!(
        "C offsets,{},{},{}",
        offset_of!(COrder, tag),
        offset_of!(COrder, value),
        offset_of!(COrder, short)
    );
    println!(
        "Rust offsets,{},{},{}",
        offset_of!(RustOrder, tag),
        offset_of!(RustOrder, value),
        offset_of!(RustOrder, short)
    );
}
