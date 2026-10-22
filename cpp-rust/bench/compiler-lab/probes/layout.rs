use std::mem::{align_of, size_of};
trait Operation {
    fn run(&self) -> u64;
}
impl Operation for u64 {
    fn run(&self) -> u64 {
        *self
    }
}
fn print<T>(name: &str) {
    println!("{name},{},{}", size_of::<T>(), align_of::<T>());
}
fn main() {
    println!("type,size,align");
    print::<Vec<u64>>("Vec<u64>");
    print::<&[u64]>("&[u64]");
    print::<&u64>("&u64");
    print::<&dyn Operation>("&dyn Operation");
    print::<Box<dyn Operation>>("Box<dyn Operation>");
    print::<Option<&u64>>("Option<&u64>");
    print::<[u8; 256]>("[u8;256]");
    print::<compiler_lab::Affine>("Affine");
    print::<compiler_lab::DropProbe<'_>>("DropProbe");
    print::<Option<compiler_lab::DropProbe<'_>>>("Option<DropProbe>");
    let value: &dyn Operation = &7u64;
    assert_eq!(value.run(), 7);
}
