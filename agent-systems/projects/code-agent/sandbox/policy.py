"""路径与出口策略：所有文件访问都必须穿过这里。"""

from __future__ import annotations

import ipaddress
import os
from dataclasses import dataclass
from pathlib import Path
from urllib.parse import urlparse


class PolicyError(Exception):
    """策略拒绝；调用方应把它转成结构化错误，而不是崩溃。"""

    def __init__(self, code: str, message: str):
        super().__init__(message)
        self.code = code
        self.message = message


@dataclass(frozen=True)
class Workspace:
    root: Path

    def __post_init__(self) -> None:
        object.__setattr__(self, "root", Path(self.root).resolve())
        self.root.mkdir(parents=True, exist_ok=True)

    def resolve(self, rel: str, *, must_exist: bool = False) -> Path:
        """把相对路径解析到工作区内；拒绝绝对路径、`..` 与符号链接逃逸。"""
        if not rel or rel.startswith("/") or rel.startswith("\\"):
            raise PolicyError("EPERM", f"absolute path not allowed: {rel!r}")
        if any(part == ".." for part in Path(rel).parts):
            raise PolicyError("EPERM", f"parent traversal not allowed: {rel!r}")
        candidate = (self.root / rel).resolve(strict=False)
        try:
            candidate.relative_to(self.root)
        except ValueError:
            raise PolicyError("EPERM", f"path escapes workspace: {rel!r}") from None
        if must_exist and not candidate.exists():
            raise PolicyError("ENOENT", f"no such file: {rel!r}")
        return candidate

    def relative(self, path: Path) -> str:
        return str(path.resolve().relative_to(self.root))


@dataclass(frozen=True)
class EgressPolicy:
    """默认拒绝所有出口；allowlist 是精确 host 匹配，不做通配。"""

    allowed_hosts: frozenset[str] = frozenset()

    def check_url(self, url: str) -> None:
        parsed = urlparse(url)
        if parsed.scheme not in {"http", "https"}:
            raise PolicyError("EPERM", f"scheme not allowed: {parsed.scheme!r}")
        host = (parsed.hostname or "").lower()
        if not host:
            raise PolicyError("EPERM", "missing host")
        if host in self.allowed_hosts:
            return
        # 直接拒绝 IP 字面量与私网，避免 DNS 重绑定之外的简单绕过。
        try:
            ip = ipaddress.ip_address(host)
        except ValueError:
            ip = None
        if ip is not None and (ip.is_private or ip.is_loopback or ip.is_link_local):
            raise PolicyError("EPERM", f"private address blocked: {host}")
        raise PolicyError("EPERM", f"host not in allowlist: {host}")
