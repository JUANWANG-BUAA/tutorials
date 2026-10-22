use runtime_lab::wire::{read_frame, write_frame, READY};
use std::io::{self, Write};
use std::time::Duration;
fn main() -> io::Result<()> {
    match std::env::args().nth(1).as_deref() {
        Some("rpc") => {
            let mut input = io::stdin().lock();
            let mut output = io::stdout().lock();
            output.write_all(READY)?;
            output.flush()?;
            while let Some(mut frame) = read_frame(&mut input)? {
                frame.value = frame.value.wrapping_mul(3);
                write_frame(&mut output, frame)?;
            }
        }
        Some("flood") => {
            let count = std::env::args()
                .nth(2)
                .unwrap_or_else(|| "2097152".into())
                .parse::<usize>()
                .map_err(|e| io::Error::new(io::ErrorKind::InvalidInput, e))?;
            if count > 64 * 1024 * 1024 {
                return Err(io::Error::other("flood limit exceeded"));
            }
            let data = vec![b'x'; count];
            io::stdout().lock().write_all(&data)?;
            io::stderr().lock().write_all(&data)?;
        }
        Some("sleep") => std::thread::sleep(Duration::from_secs(2)),
        Some("fail") => std::process::exit(7),
        Some("inherit") => {
            // Trusted regression helper: child exits, grandchild retains both pipes.
            let mut child = std::process::Command::new(std::env::current_exe()?)
                .arg("sleep")
                .spawn()?;
            let mut out = io::stdout().lock();
            writeln!(out, "descendant={}", child.id())?;
            out.flush()?;
            // Wait on another native thread; process::exit deliberately skips it.
            std::thread::spawn(move || {
                let _ = child.wait();
            });
            std::process::exit(0);
        }
        _ => {
            return Err(io::Error::new(
                io::ErrorKind::InvalidInput,
                "rpc|flood|sleep|fail|inherit required",
            ))
        }
    }
    Ok(())
}
