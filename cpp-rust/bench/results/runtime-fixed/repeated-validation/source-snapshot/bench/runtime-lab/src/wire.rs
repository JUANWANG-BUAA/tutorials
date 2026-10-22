//! Explicit little-endian wire format. Native repr(C) is NOT used for serialization.
use std::io::{self, Read, Write};
pub const FRAME_LEN: usize = 24;
pub const READY: &[u8; 8] = b"RPCv0001";

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Frame {
    pub request_id: u64,
    pub value: u64,
}

impl Frame {
    pub fn encode(self) -> [u8; FRAME_LEN] {
        let mut bytes = [0u8; FRAME_LEN];
        bytes[0..2].copy_from_slice(&1u16.to_le_bytes());
        bytes[4..8].copy_from_slice(&(FRAME_LEN as u32).to_le_bytes());
        bytes[8..16].copy_from_slice(&self.request_id.to_le_bytes());
        bytes[16..24].copy_from_slice(&self.value.to_le_bytes());
        bytes
    }

    pub fn decode(bytes: [u8; FRAME_LEN]) -> io::Result<Self> {
        if bytes[0..2] != 1u16.to_le_bytes()
            || bytes[2..4] != [0, 0]
            || bytes[4..8] != (FRAME_LEN as u32).to_le_bytes()
        {
            return Err(io::Error::new(
                io::ErrorKind::InvalidData,
                "invalid version/flags/length",
            ));
        }
        let mut id = [0; 8];
        id.copy_from_slice(&bytes[8..16]);
        let mut value = [0; 8];
        value.copy_from_slice(&bytes[16..24]);
        Ok(Self {
            request_id: u64::from_le_bytes(id),
            value: u64::from_le_bytes(value),
        })
    }
}

/// None only for clean EOF between frames; truncated frames are errors.
pub fn read_frame(reader: &mut impl Read) -> io::Result<Option<Frame>> {
    let mut bytes = [0; FRAME_LEN];
    loop {
        match reader.read(&mut bytes[..1]) {
            Ok(0) => return Ok(None),
            Ok(_) => break,
            Err(e) if e.kind() == io::ErrorKind::Interrupted => continue,
            Err(e) => return Err(e),
        }
    }
    reader.read_exact(&mut bytes[1..])?;
    Frame::decode(bytes).map(Some)
}

pub fn write_frame(writer: &mut impl Write, frame: Frame) -> io::Result<()> {
    writer.write_all(&frame.encode())?;
    writer.flush()
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn explicit_roundtrip_and_byte_order() {
        let f = Frame {
            request_id: 0x0102030405060708,
            value: u64::MAX,
        };
        let bytes = f.encode();
        assert_eq!(&bytes[8..16], &[8, 7, 6, 5, 4, 3, 2, 1]);
        assert_eq!(Frame::decode(bytes).expect("valid frame"), f);
    }
    #[test]
    fn rejects_each_header_field() {
        for index in [0, 2, 4] {
            let mut bytes = Frame {
                request_id: 1,
                value: 2,
            }
            .encode();
            bytes[index] ^= 0xff;
            assert_eq!(
                Frame::decode(bytes).expect_err("bad header").kind(),
                io::ErrorKind::InvalidData
            );
        }
    }
    #[test]
    fn eof_is_not_truncated_frame() {
        assert_eq!(read_frame(&mut &[][..]).expect("clean EOF"), None);
        assert_eq!(
            read_frame(&mut &[1u8][..]).expect_err("truncated").kind(),
            io::ErrorKind::UnexpectedEof
        );
    }
}
