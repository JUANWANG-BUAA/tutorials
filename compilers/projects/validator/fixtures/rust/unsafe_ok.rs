fn main() {
    let x: i32 = 7;
    let p: *const i32 = &x;
    unsafe {
        println!("{}", *p);
    }
}
