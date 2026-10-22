//! Deterministic real child used by CLI, tests and benchmarks; never invokes a shell.
use std::io::{self, Write};
use std::time::Duration;

fn run() -> Result<u8, Box<dyn std::error::Error>> {
    let args: Vec<String> = std::env::args().skip(1).collect();
    match args.as_slice() {
        [mode, text] if mode == "echo" && text.len() <= 4096 => {
            io::stdout().write_all(text.as_bytes())?;
            Ok(0)
        }
        [mode, n] if mode == "logs" => {
            let n: usize = n.parse()?;
            if n > 16 * 1024 * 1024 {
                return Err("log budget exceeded".into());
            }
            // Alternating writes exceed pipe capacities; sequential parent draining deadlocks.
            let out = [b'O'; 8192];
            let err = [b'E'; 8192];
            let mut stdout = io::stdout().lock();
            let mut stderr = io::stderr().lock();
            let mut written = 0;
            while written < n {
                let chunk = (n - written).min(out.len());
                stdout.write_all(&out[..chunk])?;
                stderr.write_all(&err[..chunk])?;
                written += chunk;
            }
            Ok(0)
        }
        [mode, millis] if mode == "sleep" => {
            let millis: u64 = millis.parse()?;
            if millis > 60_000 {
                return Err("sleep budget exceeded".into());
            }
            writeln!(io::stdout(), "READY {}", std::process::id())?;
            io::stdout().flush()?;
            std::thread::sleep(Duration::from_millis(millis));
            Ok(0)
        }
        [mode, code] if mode == "fail" => {
            let code: u8 = code.parse()?;
            if code == 0 {
                return Err("failure code must be nonzero".into());
            }
            writeln!(io::stderr(), "requested failure {code}")?;
            Ok(code)
        }
        _ => Err("usage: tool-helper echo TEXT | logs BYTES | sleep MILLIS | fail CODE".into()),
    }
}

fn main() -> std::process::ExitCode {
    match run() {
        Ok(code) => std::process::ExitCode::from(code),
        Err(error) => {
            eprintln!("{error}");
            std::process::ExitCode::from(2)
        }
    }
}
