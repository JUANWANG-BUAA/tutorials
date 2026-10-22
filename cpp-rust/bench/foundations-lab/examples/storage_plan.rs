//! Safe layout planning; no memory is allocated and no raw pointer is dereferenced.
use std::alloc::Layout;

fn main() -> Result<(), std::alloc::LayoutError> {
    let tag = Layout::new::<u8>();
    let value = Layout::new::<u64>();
    let (combined, value_offset) = tag.extend(value)?;
    let padded = combined.pad_to_align();
    println!(
        "value_offset={value_offset} size={} align={}",
        padded.size(),
        padded.align()
    );
    assert_eq!(value_offset, 8);
    assert_eq!(padded.size(), 16);
    assert_eq!(padded.align(), 8);
    assert!(Layout::array::<u64>(usize::MAX).is_err());
    let zst = Layout::array::<()>(100)?;
    assert_eq!(zst.size(), 0);
    assert_eq!(zst.align(), 1);
    println!(
        "overflow=rejected zst_size={} zst_align={}",
        zst.size(),
        zst.align()
    );
    Ok(())
}
