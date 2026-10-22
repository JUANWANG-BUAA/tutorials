//! Atomically close-on-exec capture pipes on macOS.
//!
//! Rust 1.99 std uses pipe() followed by two fcntl operations on this platform.
//! A concurrent spawn can inherit the write end between those operations.
//! macOS 27 provides pipe2; older systems fail explicitly rather than silently
//! reintroducing that race. No global spawn lock can protect arbitrary callers.
use std::{
    io,
    os::fd::{FromRawFd, OwnedFd},
    sync::OnceLock,
};
use tokio::process::{Child, ChildStderr, ChildStdout, Command};

type Pipe2 = unsafe extern "C" fn(*mut libc::c_int, libc::c_int) -> libc::c_int;

fn pipe_cloexec() -> io::Result<(OwnedFd, OwnedFd)> {
    static PIPE2: OnceLock<Option<Pipe2>> = OnceLock::new();
    let pipe2 = PIPE2
        .get_or_init(|| {
            // SAFETY: static NUL-terminated name; RTLD_DEFAULT is the process symbol
            // scope. System libSystem stays loaded for the process lifetime.
            let symbol = unsafe { libc::dlsym(libc::RTLD_DEFAULT, c"pipe2".as_ptr()) };
            if symbol.is_null() {
                None
            } else {
                // SAFETY: Apple's pipe2 has the exact C signature above. POSIX dlsym
                // returns a callable function pointer for a function symbol.
                Some(unsafe { std::mem::transmute::<*mut libc::c_void, Pipe2>(symbol) })
            }
        })
        .ok_or_else(|| {
            io::Error::new(io::ErrorKind::Unsupported,
        "atomic capture requires macOS pipe2 (macOS 27+); refusing racy pipe/fcntl fallback")
        })?;
    let mut fds = [-1; 2];
    // SAFETY: fds is writable for both output integers; O_CLOEXEC is valid for
    // pipe2. On success both returned descriptors are fresh and uniquely owned.
    if unsafe { pipe2(fds.as_mut_ptr(), libc::O_CLOEXEC) } != 0 {
        return Err(io::Error::last_os_error());
    }
    // SAFETY: successful pipe2 initialized both distinct descriptors, each now
    // has one Rust owner. No raw descriptor escapes before CLOEXEC is installed.
    Ok(unsafe { (OwnedFd::from_raw_fd(fds[0]), OwnedFd::from_raw_fd(fds[1])) })
}

pub(super) fn spawn_captured(
    command: &mut Command,
) -> io::Result<(Child, ChildStdout, ChildStderr)> {
    let (out_read, out_write) = pipe_cloexec()?;
    let (err_read, err_write) = pipe_cloexec()?;
    // Conversions transfer ownership; Tokio registers the nonblocking read ends.
    let out = ChildStdout::from_std(std::process::ChildStdout::from(out_read))?;
    let err = ChildStderr::from_std(std::process::ChildStderr::from(err_read))?;
    command.stdout(out_write).stderr(err_write);
    let result = command.spawn();
    // Unlike Stdio::piped(), explicit Stdio handles remain in Command after
    // spawn. Release BOTH parent writer owners on success AND on spawn error.
    command
        .stdout(std::process::Stdio::null())
        .stderr(std::process::Stdio::null());
    Ok((result?, out, err))
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::os::fd::AsRawFd;
    #[test]
    fn both_pipe_ends_are_cloexec_at_return() {
        let (read, write) = pipe_cloexec().expect("macOS 27 pipe2");
        for fd in [read.as_raw_fd(), write.as_raw_fd()] {
            // SAFETY: owned live descriptor; F_GETFD takes no third argument.
            let flags = unsafe { libc::fcntl(fd, libc::F_GETFD) };
            assert!(flags >= 0 && flags & libc::FD_CLOEXEC != 0);
        }
    }
}
