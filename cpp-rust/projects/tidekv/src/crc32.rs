//! CRC-32（IEEE 802.3，反射多项式 `0xEDB88320`）的表法实现，零依赖。

/// 256 项查表，编译期常量折叠，运行期不初始化。
const fn make_table() -> [u32; 256] {
    let mut table = [0u32; 256];
    let mut i = 0usize;
    while i < 256 {
        let mut crc = i as u32;
        let mut j = 0;
        while j < 8 {
            crc = if crc & 1 != 0 {
                (crc >> 1) ^ 0xEDB8_8320
            } else {
                crc >> 1
            };
            j += 1;
        }
        table[i] = crc;
        i += 1;
    }
    table
}

/// 查表法 CRC32 状态机。
#[derive(Clone, Debug, Default)]
pub struct Crc32 {
    state: u32,
}

impl Crc32 {
    /// 新建一个初值为 `0xFFFFFFFF` 的累加器。
    pub fn new() -> Self {
        Self { state: 0xFFFF_FFFF }
    }

    /// 折入一段字节；单次查表只依赖低 8 位，因此可以流水线化。
    pub fn update(&mut self, bytes: &[u8]) {
        let mut crc = self.state;
        for &b in bytes {
            crc = TABLE[((crc ^ b as u32) & 0xFF) as usize] ^ (crc >> 8);
        }
        self.state = crc;
    }

    /// 输出最终校验值（按标准做一次取反）。
    pub fn finalize(&self) -> u32 {
        !self.state
    }
}

/// 一次性算出整段字节的 CRC32。
pub fn crc32(bytes: &[u8]) -> u32 {
    let mut c = Crc32::new();
    c.update(bytes);
    c.finalize()
}

static TABLE: [u32; 256] = make_table();

#[cfg(test)]
mod tests {
    use super::crc32;

    #[test]
    fn known_vectors() {
        assert_eq!(crc32(b""), 0x0000_0000);
        assert_eq!(crc32(b"a"), 0xE8B7_BE43);
        assert_eq!(crc32(b"123456789"), 0xCBF4_3926);
        assert_eq!(
            crc32(b"The quick brown fox jumps over the lazy dog"),
            0x414F_A339
        );
    }
}
