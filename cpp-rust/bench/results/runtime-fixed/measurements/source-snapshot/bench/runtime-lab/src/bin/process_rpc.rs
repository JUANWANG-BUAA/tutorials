use performance_lab::{ns_per_op, print_stats};
use runtime_lab::wire::{read_frame, write_frame, Frame, READY};
use std::{
    io::{self, Read},
    path::Path,
    process::{Child, ChildStdin, ChildStdout, Command, Stdio},
    time::Instant,
};
struct Session {
    child: Child,
    input: Option<ChildStdin>,
    output: ChildStdout,
}
impl Session {
    fn start(worker: &Path) -> io::Result<Self> {
        let mut child = Command::new(worker)
            .arg("rpc")
            .stdin(Stdio::piped())
            .stdout(Stdio::piped())
            .stderr(Stdio::inherit())
            .spawn()?;
        let result = (|| {
            let input = child
                .stdin
                .take()
                .ok_or_else(|| io::Error::other("stdin missing"))?;
            let mut output = child
                .stdout
                .take()
                .ok_or_else(|| io::Error::other("stdout missing"))?;
            let mut ready = [0; 8];
            output.read_exact(&mut ready)?;
            if &ready != READY {
                return Err(io::Error::other("bad handshake"));
            }
            Ok((input, output))
        })();
        match result {
            Ok((input, output)) => Ok(Self {
                child,
                input: Some(input),
                output,
            }),
            Err(e) => {
                let _ = child.kill();
                let _ = child.wait();
                Err(e)
            }
        }
    }
    fn request(&mut self, id: u64) -> io::Result<()> {
        let frame = Frame {
            request_id: id,
            value: id.wrapping_add(9),
        };
        write_frame(
            self.input
                .as_mut()
                .ok_or_else(|| io::Error::other("closed input"))?,
            frame,
        )?;
        let response =
            read_frame(&mut self.output)?.ok_or_else(|| io::Error::other("early EOF"))?;
        if response.request_id != id || response.value != frame.value.wrapping_mul(3) {
            return Err(io::Error::other("response mismatch"));
        }
        Ok(())
    }
    fn finish(mut self) -> io::Result<()> {
        drop(self.input.take());
        if self.child.wait()?.success() {
            Ok(())
        } else {
            Err(io::Error::other("worker exit failed"))
        }
    }
}
impl Drop for Session {
    fn drop(&mut self) {
        drop(self.input.take());
        if !matches!(self.child.try_wait(), Ok(Some(_))) {
            let _ = self.child.kill();
            let _ = self.child.wait();
        }
    }
}
fn batch(worker: &Path, persistent: bool, requests: u64) -> io::Result<f64> {
    if persistent {
        let mut session = Session::start(worker)?; // ready handshake before timing
        let start = Instant::now();
        for id in 0..requests {
            session.request(id)?;
        }
        let ns = ns_per_op(start.elapsed(), requests);
        session.finish()?;
        Ok(ns) // shutdown excluded
    } else {
        let start = Instant::now();
        for id in 0..requests {
            let mut session = Session::start(worker)?;
            session.request(id)?;
            session.finish()?;
        }
        Ok(ns_per_op(start.elapsed(), requests))
    }
}
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let worker = std::env::current_exe()?.with_file_name("lab-worker");
    for _ in 0..3 {
        batch(&worker, false, 16)?;
        batch(&worker, true, 16)?;
    }
    let mut samples = [Vec::new(), Vec::new()];
    for index in 0..21 {
        for offset in 0..2 {
            let mode = (index + offset) % 2;
            let ns = batch(&worker, mode == 1, 16)?;
            samples[mode].push(ns);
            println!("{},{index},{ns:.9}", ["spawn", "persistent"][mode]);
        }
    }
    for (name, xs) in ["spawn", "persistent"].iter().zip(samples.iter()) {
        print_stats(name, xs);
    }
    Ok(())
}
