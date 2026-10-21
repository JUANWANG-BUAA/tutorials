use std::process::Command;

fn main() {
    let _ = Command::new("echo").arg("hi").status();
}
