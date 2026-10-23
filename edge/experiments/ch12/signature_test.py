"""Host-only signed-envelope experiment; NOT a target secure-boot implementation."""
from __future__ import annotations

import hashlib
import os
from pathlib import Path
import struct
import subprocess
import zlib

OUT = Path(".build/ch12/signatures")
OPENSSL = os.environ.get("EDGE_OPENSSL", "openssl")
HEADER = struct.Struct("<8I")
MAGIC, BOARD, ABI, FLOOR = 0x45494D47, 0x45444745, 7, 2


def command(*args: str, ok: bool = True) -> subprocess.CompletedProcess[bytes]:
    """Execute a bounded OpenSSL command; expected rejection is not success."""
    result = subprocess.run([OPENSSL, *args], capture_output=True, timeout=15)
    if ok and result.returncode != 0:
        raise RuntimeError(result.stderr.decode(errors="replace"))
    return result


def envelope(payload: bytes, *, board: int = BOARD, abi: int = ABI,
             version: int = FLOOR, size: int | None = None) -> bytes:
    """Serialize the exact little-endian model header followed by payload."""
    fields = (MAGIC, version, len(payload) if size is None else size,
              board, abi, 2, zlib.crc32(payload))
    prefix = struct.pack("<7I", *fields)
    return prefix + struct.pack("<I", zlib.crc32(prefix)) + payload


def policy(blob: bytes) -> bool:
    """Check bounded size, canonical bytes, compatibility and software floor."""
    if len(blob) < HEADER.size or len(blob) > HEADER.size + 896:
        return False
    magic, version, size, board, abi, model, crc, hcrc = HEADER.unpack_from(blob)
    return (magic == MAGIC and version >= FLOOR and 0 < size <= 896
            and size == len(blob) - HEADER.size and board == BOARD
            and abi == ABI and model != 0 and zlib.crc32(blob[:28]) == hcrc
            and zlib.crc32(blob[32:]) == crc)


def sign(blob: bytes, key: Path, stem: str) -> bytes:
    """Sign header AND payload with an ephemeral educational P-256 key."""
    source, signature = OUT / f"{stem}.bin", OUT / f"{stem}.sig"
    source.write_bytes(blob)
    command("dgst", "-sha256", "-sign", str(key), "-out", str(signature), str(source))
    return signature.read_bytes()


def accepted(blob: bytes, signature: bytes, pubkey: Path) -> bool:
    """Authenticate a bounded private snapshot, then apply semantic policy."""
    if len(blob) < 32 or len(blob) > 928 or not 8 <= len(signature) <= 80:
        return False
    source, sig = OUT / "verify.bin", OUT / "verify.sig"
    source.write_bytes(blob)
    sig.write_bytes(signature)
    valid = command("dgst", "-sha256", "-verify", str(pubkey), "-signature",
                    str(sig), str(source), ok=False).returncode == 0
    return valid and policy(blob)


def main() -> None:
    """Exercise signature tampering, wrong keys and signed-but-invalid policy."""
    OUT.mkdir(parents=True, exist_ok=True)
    print(command("version").stdout.decode().strip())
    key, pub, other = OUT / "test-only.pem", OUT / "test-only.pub.pem", OUT / "wrong.pem"
    for target in (key, other):
        command("genpkey", "-algorithm", "EC", "-pkeyopt", "ec_paramgen_curve:P-256", "-out", str(target))
        target.chmod(0o600)
    command("pkey", "-in", str(key), "-pubout", "-out", str(pub))
    payload = bytes((i * 37 + 11) & 255 for i in range(127))
    blob = envelope(payload)
    sig = sign(blob, key, "valid")
    assert accepted(blob, sig, pub)
    for i in range(len(blob)):
        damaged = bytearray(blob)
        damaged[i] ^= 1
        assert not accepted(bytes(damaged), sig, pub)
    wrong_sig = sign(blob, other, "wrong-key")
    assert not accepted(blob, wrong_sig, pub)
    assert not accepted(blob, sig[:-1], pub)
    assert not accepted(blob[:-1], sig, pub)
    assert not accepted(blob + b"x", sig, pub)
    for name, bad in {
        "wrong-board": envelope(payload, board=0),
        "wrong-feature-abi": envelope(payload, abi=8),
        "downgrade": envelope(payload, version=1),
        "size-wrap": envelope(payload, size=0xFFFFFFFF),
    }.items():
        assert not accepted(bad, sign(bad, key, name), pub)
    # Independent IEEE CRC oracle uses zlib, not the C implementation.
    assert zlib.crc32(b"123456789") == 0xCBF43926
    print(f"HOST SIGNATURE PASS: header+payload authenticated; {len(blob)} byte mutations rejected; wrong key/truncation/extension rejected")
    print("HOST POLICY PASS: even correctly signed wrong-board/ABI/downgrade/overflow envelopes rejected")
    print("BOUNDARY: ephemeral test key only; no target crypto, root-of-trust, OTP or network transport validated")
    print("fixture SHA-256:", hashlib.sha256(blob).hexdigest())


if __name__ == "__main__":
    main()
