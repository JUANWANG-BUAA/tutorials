#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""guard.py — agent 生成代码的三层门禁与证据化裁决（教学实现）。

用法：
    python3 guard.py TARGET... [--lang auto|python|c|rust] [--policy policy.json]
                      [--static-only] [--compile] [--run] [--tests fixture.json]
                      [--json]

裁决：accept(0) / reject(1) / quarantine(2)。
本程序用 RLIMIT + 超时 + 环境清理**遏制**普通错误，不是安全隔离：
没有命名空间、seccomp、landlock 或虚拟机边界。读 README 的「不提供的保证」。
"""

from __future__ import annotations

import argparse
import ast
import copy
import dataclasses
import datetime as _dt
import difflib
import hashlib
import io
import json
import os
import re
import resource
import shutil
import signal
import subprocess
import sys
import tempfile
import time
import tokenize
from pathlib import Path

TOOL = "guard.py"
SCHEMA = 1
SEVERITIES = ("info", "low", "medium", "high")
RANK = {s: i for i, s in enumerate(SEVERITIES)}
VERDICT_EXIT = {"accept": 0, "reject": 1, "quarantine": 2}
LANG_EXT = {"python": ".py", "c": ".c", "rust": ".rs"}
EXT_LANG = {".py": "python", ".c": "c", ".h": "c", ".rs": "rust"}

# 规则目录：id -> (默认严重度, 一句话说明)。策略只能覆盖严重度，不能新增规则。
RULES: dict[str, tuple[str, str]] = {
    # Python：执行 / 进程 / 网络 / 文件
    "PY-EVAL": ("high", "eval/exec/compile 执行任意代码"),
    "PY-OS-SYSTEM": ("high", "os.system/os.popen 启动 shell"),
    "PY-SUBPROCESS": ("high", "subprocess 启动外部进程"),
    "PY-CTYPES": ("high", "ctypes 直接调用本机代码"),
    "PY-PICKLE": ("high", "pickle/marshal 反序列化可执行代码"),
    "PY-NET": ("high", "socket/urllib/http 网络访问"),
    "PY-RMTREE": ("high", "递归删除目录"),
    "PY-FS-DELETE": ("high", "删除/改名文件"),
    "PY-FORK": ("high", "fork/kill 进程控制"),
    "PY-EXEC-FAMILY": ("high", "os.exec*/spawn* 替换或启动进程"),
    "PY-DYN-IMPORT": ("medium", "importlib 动态导入"),
    "PY-DYN-ATTR": ("medium", "getattr 使用非常量属性名，静态解析失效"),
    "PY-FS-WRITE": ("medium", "写文件或创建目录"),
    "PY-ABS-PATH": ("medium", "使用绝对路径，可能逃出工作目录"),
    "PY-ENV-READ": ("low", "读取环境变量"),
    "PY-TEST-SNIFF": ("medium", "读取 CI/测试环境变量，可能针对测试改变行为"),
    "PY-HARD-EXIT": ("medium", "os._exit 绕过清理与测试框架"),
    "PY-INFINITE-LOOP": ("low", "while True 且循环体无 break"),
    "PY-PROMPT-INJECTION": ("low", "注释含提示注入文本（只标记，不执行）"),
    "PY-STAR-IMPORT": ("low", "星号导入使名字来源不可判定"),
    "PY-SYNTAX": ("high", "Python 语法错误，无法解析"),
    # C
    "C-SYSTEM": ("high", "system/popen 启动 shell"),
    "C-EXEC": ("high", "exec* 替换进程映像"),
    "C-FORK": ("high", "fork 创建进程"),
    "C-SOCKET": ("high", "socket/connect 网络访问"),
    "C-DLOPEN": ("high", "dlopen/dlsym 运行时加载代码"),
    "C-FS-DELETE": ("high", "remove/unlink/rmdir 删除文件"),
    "C-UNSAFE-STR": ("medium", "strcpy/strcat/sprintf/gets 无界字符串操作"),
    "C-UNSAFE-SCAN": ("medium", "scanf 族使用 %s，无界输入"),
    "C-ASM": ("medium", "内联汇编绕过源码级检查"),
    "C-MACRO-ALIAS": ("medium", "宏把危险函数改名，token 扫描可能漏报"),
    "C-FS-WRITE": ("medium", "以写模式打开文件"),
    "C-INFINITE-LOOP": ("low", "for(;;)/while(1) 未见到 break"),
    "C-INCLUDE-NET": ("medium", "包含网络头文件"),
    "C-PROMPT-INJECTION": ("low", "注释含提示注入文本（只标记，不执行）"),
    "C-SYNTAX": ("high", "C 编译门禁失败"),
    # Rust
    "RS-COMMAND": ("high", "std::process::Command 启动外部进程"),
    "RS-FS-DELETE": ("high", "删除文件/目录"),
    "RS-LIBC": ("high", "直接调用 libc"),
    "RS-UNSAFE": ("medium", "unsafe 块：编译器不再检查该区域"),
    "RS-NET": ("medium", "网络套接字"),
    "RS-EXTERN-C": ("medium", "extern \"C\" FFI 边界"),
    "RS-ENV": ("low", "读取环境变量"),
    "RS-LOOP": ("low", "loop 未见到 break"),
    "RS-SYNTAX": ("high", "Rust 编译门禁失败"),
    # 门禁自身
    "BUILD-TOOL-MISSING": ("medium", "所需工具链不可用，门禁无法完成"),
    "RUN-NO-TESTS": ("medium", "请求行为门禁但没有测试夹具"),
    "RUN-OUTPUT": ("high", "标准输出与期望不一致"),
    "RUN-EXIT": ("high", "退出码与期望不一致"),
    "RUN-SIGNAL": ("high", "进程被信号终止"),
    "RUN-TIMEOUT": ("medium", "执行超时（可能死循环，也可能只是慢）"),
    "RUN-RESOURCE": ("medium", "触发资源限制（CPU/内存/文件大小/句柄）"),
}

DEFAULT_POLICY: dict = {
    "name": "default",
    "reject_at": "high",
    "quarantine_at": "medium",
    "execute_below": "high",
    "require_tests": True,
    "allow_rules": [],
    "severity_overrides": {},
    "max_file_bytes": 262144,
    "sandbox": {
        "timeout_s": 5.0,
        "cpu_s": 2,
        "address_space_mb": 512,
        "file_size_mb": 1,
        "nofile": 64,
        "max_output_bytes": 65536,
        "max_cases": 20,
    },
}

CI_ENV_KEYS = {
    "CI", "CONTINUOUS_INTEGRATION", "GITHUB_ACTIONS", "GITLAB_CI", "BUILDKITE",
    "JENKINS_URL", "PYTEST_CURRENT_TEST", "COVERAGE_PROCESS_START", "GUARD_TESTS",
}

PROMPT_RE = re.compile(
    r"ignore\s+(all\s+)?(previous|prior)\s+instructions|"
    r"you\s+are\s+(now\s+)?an?\s+(ai|assistant)|system\s+prompt|"
    r"assistant\s*:|human\s*:|忽略(之前|以上|前面).{0,6}(指令|要求)",
    re.IGNORECASE,
)


@dataclasses.dataclass
class Finding:
    rule: str
    severity: str
    message: str
    file: str
    line: int
    snippet: str = ""

    def as_dict(self) -> dict:
        return {
            "rule": self.rule,
            "severity": self.severity,
            "message": self.message,
            "file": self.file,
            "line": self.line,
            "snippet": self.snippet,
        }


class GuardError(Exception):
    """输入/策略/夹具错误：报告后以退出码 2 结束，不产生裁决。"""


# --------------------------------------------------------------------------- #
# 策略
# --------------------------------------------------------------------------- #

def _deep_merge(base: dict, override: dict) -> dict:
    out = copy.deepcopy(base)
    for key, value in override.items():
        if isinstance(value, dict) and isinstance(out.get(key), dict):
            out[key] = _deep_merge(out[key], value)
        else:
            out[key] = value
    return out


def load_policy(path: str | None) -> tuple[dict, str, str]:
    """返回 (策略, 策略文件路径, sha256)。缺省策略仍计算哈希，便于证据复现。"""
    if path is None:
        raw = json.dumps(DEFAULT_POLICY, ensure_ascii=False, sort_keys=True).encode()
        return copy.deepcopy(DEFAULT_POLICY), "<builtin>", hashlib.sha256(raw).hexdigest()
    p = Path(path)
    if not p.is_file():
        raise GuardError(f"策略文件不存在：{path}")
    raw = p.read_bytes()
    try:
        data = json.loads(raw.decode("utf-8"))
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise GuardError(f"策略不是合法 JSON：{exc}") from exc
    if not isinstance(data, dict):
        raise GuardError("策略根必须是对象")
    policy = _deep_merge(DEFAULT_POLICY, data)
    for key in ("reject_at", "quarantine_at", "execute_below"):
        if policy[key] not in RANK:
            raise GuardError(f"策略 {key} 必须是 {SEVERITIES}")
    # 允许相等；只禁止 reject 门槛低于 quarantine（那会让 quarantine 永远不可达）。
    if RANK[policy["reject_at"]] < RANK[policy["quarantine_at"]]:
        raise GuardError("reject_at 不能低于 quarantine_at")
    if not isinstance(policy["allow_rules"], list) or not all(
        isinstance(x, str) for x in policy["allow_rules"]
    ):
        raise GuardError("allow_rules 必须是字符串数组")
    unknown = [r for r in policy["allow_rules"] if r not in RULES]
    if unknown:
        raise GuardError(f"allow_rules 含未知规则：{unknown}")
    overrides = policy["severity_overrides"]
    if not isinstance(overrides, dict):
        raise GuardError("severity_overrides 必须是对象")
    for rule, sev in overrides.items():
        if rule not in RULES:
            raise GuardError(f"severity_overrides 含未知规则：{rule}")
        if sev not in RANK:
            raise GuardError(f"severity_overrides[{rule}] 非法严重度：{sev}")
    sb = policy["sandbox"]
    for key in ("timeout_s", "cpu_s", "address_space_mb", "file_size_mb",
                "nofile", "max_output_bytes", "max_cases"):
        if not isinstance(sb[key], (int, float)) or sb[key] <= 0:
            raise GuardError(f"sandbox.{key} 必须是正数")
    if not isinstance(policy["max_file_bytes"], int) or policy["max_file_bytes"] <= 0:
        raise GuardError("max_file_bytes 必须是正整数")
    return policy, str(p), hashlib.sha256(raw).hexdigest()


def apply_policy(findings: list[Finding], policy: dict) -> tuple[list[Finding], list[dict]]:
    """覆盖严重度、抑制 allow_rules；被抑制的条目保留在 suppressed 证据里。"""
    active: list[Finding] = []
    suppressed: list[dict] = []
    allow = set(policy["allow_rules"])
    overrides = policy["severity_overrides"]
    for f in findings:
        if f.rule in allow:
            suppressed.append({"rule": f.rule, "file": f.file, "line": f.line,
                               "reason": "policy.allow_rules"})
            continue
        sev = overrides.get(f.rule, f.severity)
        active.append(Finding(f.rule, sev, f.message, f.file, f.line, f.snippet))
    return active, suppressed


# --------------------------------------------------------------------------- #
# Python 静态规则
# --------------------------------------------------------------------------- #

_EXACT_CALLS: dict[str, tuple[str, str]] = {
    "eval": ("PY-EVAL", "eval() 执行任意表达式"),
    "exec": ("PY-EVAL", "exec() 执行任意语句"),
    "compile": ("PY-EVAL", "compile() 生成可执行代码对象"),
    "__import__": ("PY-EVAL", "__import__() 动态导入"),
    "builtins.eval": ("PY-EVAL", "builtins.eval() 执行任意表达式"),
    "builtins.exec": ("PY-EVAL", "builtins.exec() 执行任意语句"),
    "builtins.compile": ("PY-EVAL", "builtins.compile() 生成代码对象"),
    "os.system": ("PY-OS-SYSTEM", "os.system() 启动 shell"),
    "os.popen": ("PY-OS-SYSTEM", "os.popen() 启动 shell 管道"),
    "os.remove": ("PY-FS-DELETE", "os.remove() 删除文件"),
    "os.unlink": ("PY-FS-DELETE", "os.unlink() 删除文件"),
    "os.rmdir": ("PY-FS-DELETE", "os.rmdir() 删除目录"),
    "os.removedirs": ("PY-FS-DELETE", "os.removedirs() 递归删除空目录"),
    "os.fork": ("PY-FORK", "os.fork() 创建子进程"),
    "os.forkpty": ("PY-FORK", "os.forkpty() 创建子进程"),
    "os.kill": ("PY-FORK", "os.kill() 发送信号"),
    "os.killpg": ("PY-FORK", "os.killpg() 向进程组发信号"),
    "os._exit": ("PY-HARD-EXIT", "os._exit() 跳过 atexit/缓冲区清理"),
    "shutil.rmtree": ("PY-RMTREE", "shutil.rmtree() 递归删除"),
    "shutil.move": ("PY-FS-DELETE", "shutil.move() 移动文件"),
    "importlib.import_module": ("PY-DYN-IMPORT", "importlib.import_module() 动态导入"),
    "pickle.load": ("PY-PICKLE", "pickle.load() 反序列化可执行对象"),
    "pickle.loads": ("PY-PICKLE", "pickle.loads() 反序列化可执行对象"),
    "marshal.loads": ("PY-PICKLE", "marshal.loads() 反序列化代码对象"),
    "sys.settrace": ("PY-DYN-ATTR", "sys.settrace() 可在运行时改写行为"),
    "os.open": ("PY-FS-WRITE", "os.open() 直接操作文件描述符"),
    "os.mkdir": ("PY-FS-WRITE", "os.mkdir() 创建目录"),
    "os.makedirs": ("PY-FS-WRITE", "os.makedirs() 递归创建目录"),
}

_PREFIX_CALLS: list[tuple[str, str, str]] = [
    ("subprocess", "PY-SUBPROCESS", "subprocess 启动外部进程"),
    ("ctypes", "PY-CTYPES", "ctypes 调用本机代码"),
    ("socket", "PY-NET", "socket 网络访问"),
    ("ssl", "PY-NET", "ssl 网络访问"),
    ("urllib", "PY-NET", "urllib 网络访问"),
    ("http.client", "PY-NET", "http.client 网络访问"),
    ("ftplib", "PY-NET", "ftplib 网络访问"),
    ("smtplib", "PY-NET", "smtplib 网络访问"),
    ("os.exec", "PY-EXEC-FAMILY", "os.exec* 替换进程映像"),
    ("os.spawn", "PY-EXEC-FAMILY", "os.spawn* 启动进程"),
    ("os.posix_spawn", "PY-EXEC-FAMILY", "os.posix_spawn* 启动进程"),
]


def _const_str(node: ast.AST | None) -> str | None:
    if node is None:
        return None
    if isinstance(node, ast.Constant) and isinstance(node.value, str):
        return node.value
    if isinstance(node, ast.BinOp) and isinstance(node.op, ast.Add):
        left = _const_str(node.left)
        right = _const_str(node.right)
        if left is not None and right is not None:
            return left + right
    return None


def _dotted(node: ast.AST | None, aliases: dict[str, str], depth: int = 0) -> str | None:
    if node is None or depth > 12:
        return None
    if isinstance(node, ast.Name):
        return aliases.get(node.id, node.id)
    if isinstance(node, ast.Attribute):
        base = _dotted(node.value, aliases, depth + 1)
        return f"{base}.{node.attr}" if base else node.attr
    return None


def _python_aliases(tree: ast.AST) -> tuple[dict[str, str], list[str]]:
    aliases: dict[str, str] = {}
    stars: list[str] = []
    for node in ast.walk(tree):
        if isinstance(node, ast.Import):
            for a in node.names:
                if a.asname:
                    aliases[a.asname] = a.name
                else:
                    root = a.name.split(".")[0]
                    aliases[root] = root
        elif isinstance(node, ast.ImportFrom):
            mod = node.module or ""
            for a in node.names:
                if a.name == "*":
                    stars.append(mod or ".")
                    continue
                bound = a.asname or a.name
                aliases[bound] = f"{mod}.{a.name}" if mod else a.name
    return aliases, stars


def _has_break(body: list[ast.stmt]) -> bool:
    """只看当前函数/循环作用域；嵌套函数或类里的 break 不算。"""
    for stmt in body:
        if isinstance(stmt, ast.Break):
            return True
        if isinstance(stmt, (ast.FunctionDef, ast.AsyncFunctionDef, ast.ClassDef,
                             ast.Lambda)):
            continue
        for field in ("body", "orelse", "finalbody"):
            child = getattr(stmt, field, None)
            if isinstance(child, list) and _has_break(child):
                return True
        for handler in getattr(stmt, "handlers", []) or []:
            if _has_break(handler.body):
                return True
        for case in getattr(stmt, "cases", []) or []:
            if _has_break(case.body):
                return True
    return False


def _line_snippet(lines: list[str], lineno: int) -> str:
    if 1 <= lineno <= len(lines):
        return lines[lineno - 1].strip()[:160]
    return ""


def scan_python(path: str, text: str, display: str) -> list[Finding]:
    lines = text.splitlines()
    findings: list[Finding] = []

    def add(rule: str, message: str, line: int) -> None:
        sev = RULES[rule][0]
        findings.append(Finding(rule, sev, message, display, line, _line_snippet(lines, line)))

    try:
        tree = ast.parse(text, filename=display)
    except (SyntaxError, ValueError) as exc:
        lineno = getattr(exc, "lineno", 1) or 1
        msg = getattr(exc, "msg", str(exc))
        add("PY-SYNTAX", f"SyntaxError: {msg}（第 {lineno} 行）", lineno)
        return findings

    aliases, stars = _python_aliases(tree)
    for mod in stars:
        add("PY-STAR-IMPORT", f"from {mod} import *：名字来源不可静态判定", 1)

    # 注释：提示注入只做标记，绝不解释、绝不执行。
    try:
        for tok in tokenize.generate_tokens(io.StringIO(text).readline):
            if tok.type == tokenize.COMMENT and PROMPT_RE.search(tok.string):
                add("PY-PROMPT-INJECTION",
                    "注释包含提示注入文本；验证器不读取注释作为指令", tok.start[0])
    except (tokenize.TokenError, IndentationError):
        pass

    def match_call(dotted: str | None, line: int) -> None:
        if not dotted:
            return
        if dotted in _EXACT_CALLS:
            rule, msg = _EXACT_CALLS[dotted]
            add(rule, f"{dotted}()：{msg}", line)
            return
        for prefix, rule, msg in _PREFIX_CALLS:
            if dotted == prefix or dotted.startswith(prefix + "."):
                add(rule, f"{dotted}()：{msg}", line)
                return

    for node in ast.walk(tree):
        if isinstance(node, ast.Call):
            func = node.func
            dotted = _dotted(func, aliases)
            # getattr 单独处理：常量名继续解析，非常量名只能降级为 quarantine。
            if isinstance(func, ast.Name) and func.id == "getattr" and len(node.args) >= 2:
                attr = _const_str(node.args[1])
                base = _dotted(node.args[0], aliases)
                if attr is not None and base:
                    match_call(f"{base}.{attr}", node.lineno)
                elif attr is None:
                    add("PY-DYN-ATTR",
                        "getattr() 的属性名不是字符串常量，静态规则无法确定目标", node.lineno)
                continue
            match_call(dotted, node.lineno)

            if dotted in {"open", "builtins.open", "io.open"}:
                mode = _const_str(node.args[1]) if len(node.args) >= 2 else "r"
                if mode and any(ch in mode for ch in "wax+"):
                    add("PY-FS-WRITE", f"{dotted}(mode={mode!r})：写文件", node.lineno)
            if dotted in {"open", "builtins.open", "io.open", "os.open"}:
                target = _const_str(node.args[0]) if node.args else None
                if target and os.path.isabs(target):
                    add("PY-ABS-PATH", f"绝对路径 {target!r}：可能越过工作目录", node.lineno)
            if dotted in {"os.getenv", "os.environ.get", "os.environ.setdefault"}:
                key = _const_str(node.args[0]) if node.args else None
                if key in CI_ENV_KEYS:
                    add("PY-TEST-SNIFF", f"读取 {key}：可能只在测试环境改变行为", node.lineno)
                else:
                    add("PY-ENV-READ", f"{dotted}() 读取环境变量", node.lineno)
        elif isinstance(node, ast.Attribute) and node.attr in {"write_text", "write_bytes"}:
            add("PY-FS-WRITE", f".{node.attr}：写文件", node.lineno)
        elif isinstance(node, ast.Subscript):
            base = _dotted(node.value, aliases)
            if base == "os.environ":
                key = _const_str(node.slice)
                if key in CI_ENV_KEYS:
                    add("PY-TEST-SNIFF", f"读取 os.environ[{key!r}]：测试环境嗅探", node.lineno)
                else:
                    add("PY-ENV-READ", "读取 os.environ：环境变量可能携带秘密", node.lineno)
        elif isinstance(node, ast.While):
            test = node.test
            truthy = (isinstance(test, ast.Constant) and test.value is True) or (
                isinstance(test, ast.Constant) and test.value == 1)
            if truthy and not _has_break(node.body):
                add("PY-INFINITE-LOOP", "while True 且无 break：行为门禁只能靠超时兜底", node.lineno)
    return findings


# --------------------------------------------------------------------------- #
# C / Rust 静态规则（注释、字符串、token 级扫描）
# --------------------------------------------------------------------------- #

def _blank(chars: list[str], start: int, end: int) -> None:
    for k in range(start, min(end, len(chars))):
        if chars[k] != "\n":
            chars[k] = " "


def c_strip(text: str, keep_comments: bool = False, keep_strings: bool = False) -> str:
    """去掉 C 注释/字符串但保留换行，避免行号偏移。

    keep_comments=True 时只保留注释；keep_strings=True 时保留字符串内容。
    Rust 的普通字符串/字符字面量可复用；raw string 不处理，见 README 限制。
    """
    if keep_comments:
        chars = ["\n" if ch == "\n" else " " for ch in text]
    else:
        chars = list(text)
    i, n = 0, len(text)
    while i < n:
        ch = text[i]
        nxt = text[i + 1] if i + 1 < n else ""
        if ch == "/" and nxt == "/":
            j = text.find("\n", i)
            if j < 0:
                j = n
            if keep_comments:
                for k in range(i, j):
                    chars[k] = text[k]
            else:
                _blank(chars, i, j)
            i = j
            continue
        if ch == "/" and nxt == "*":
            j = text.find("*/", i + 2)
            j = n if j < 0 else j + 2
            if keep_comments:
                for k in range(i, j):
                    chars[k] = text[k]
            else:
                _blank(chars, i, j)
            i = j
            continue
        if ch in {'"', "'"}:
            quote = ch
            j = i + 1
            while j < n:
                if text[j] == "\\":
                    j += 2
                    continue
                if text[j] == quote:
                    j += 1
                    break
                j += 1
            if not keep_strings:
                _blank(chars, i + 1, j - 1)
            i = j
            continue
        i += 1
    return "".join(chars)


C_CALL_RULES: dict[str, tuple[str, str]] = {
    "system": ("C-SYSTEM", "system() 启动 shell"),
    "popen": ("C-SYSTEM", "popen() 启动 shell 管道"),
    "execl": ("C-EXEC", "execl() 替换进程映像"),
    "execle": ("C-EXEC", "execle() 替换进程映像"),
    "execlp": ("C-EXEC", "execlp() 替换进程映像"),
    "execv": ("C-EXEC", "execv() 替换进程映像"),
    "execve": ("C-EXEC", "execve() 替换进程映像"),
    "execvp": ("C-EXEC", "execvp() 替换进程映像"),
    "fork": ("C-FORK", "fork() 创建进程"),
    "socket": ("C-SOCKET", "socket() 创建套接字"),
    "connect": ("C-SOCKET", "connect() 发起网络连接"),
    "dlopen": ("C-DLOPEN", "dlopen() 运行时加载共享库"),
    "dlsym": ("C-DLOPEN", "dlsym() 解析符号"),
    "remove": ("C-FS-DELETE", "remove() 删除文件"),
    "unlink": ("C-FS-DELETE", "unlink() 删除文件"),
    "rmdir": ("C-FS-DELETE", "rmdir() 删除目录"),
    "rename": ("C-FS-DELETE", "rename() 移动/改名文件"),
    "strcpy": ("C-UNSAFE-STR", "strcpy() 无界复制"),
    "strcat": ("C-UNSAFE-STR", "strcat() 无界拼接"),
    "sprintf": ("C-UNSAFE-STR", "sprintf() 无界格式化"),
    "gets": ("C-UNSAFE-STR", "gets() 无界读取"),
}
C_CALL_RE = re.compile(r"\b([A-Za-z_]\w*)\s*\(")


def _c_findings(text: str, display: str) -> list[Finding]:
    lines = text.splitlines()
    code = c_strip(text)
    no_comments = c_strip(text, keep_strings=True)
    comments = c_strip(text, keep_comments=True)
    findings: list[Finding] = []

    def add(rule: str, message: str, line: int) -> None:
        findings.append(Finding(rule, RULES[rule][0], message, display, line,
                                _line_snippet(lines, line)))

    for m in C_CALL_RE.finditer(code):
        name = m.group(1)
        if name in C_CALL_RULES:
            rule, msg = C_CALL_RULES[name]
            add(rule, f"{name}()：{msg}", code.count("\n", 0, m.start()) + 1)
    for m in re.finditer(r"\b(__asm__|asm)\s*(?:volatile\s*)?\(", code):
        add("C-ASM", "内联汇编：源码级规则看不到实际指令", code.count("\n", 0, m.start()) + 1)
    for m in re.finditer(r"\b(?:f|s)?scanf\s*\(\s*\"[^\"]*%s", no_comments):
        add("C-UNSAFE-SCAN", "scanf 族用 %s：输入长度不受限", no_comments.count("\n", 0, m.start()) + 1)
    for m in re.finditer(r"\bfopen\s*\(([^;]*?)\)", no_comments):
        strings = re.findall(r'"([^"]*)"', m.group(1))
        mode = strings[-1] if strings else ""
        if mode and any(ch in mode for ch in "wa+"):
            add("C-FS-WRITE", f"fopen(..., {mode!r}) 以写模式打开", no_comments.count("\n", 0, m.start()) + 1)
    for m in re.finditer(r"#\s*include\s*<(sys/socket|netinet/in|arpa/inet)\.h>", no_comments):
        add("C-INCLUDE-NET", f"包含网络头文件 <{m.group(1)}.h>", no_comments.count("\n", 0, m.start()) + 1)
    for m in re.finditer(
            r"#\s*define\s+\w+\s+(system|popen|exec\w*|socket|connect|remove|unlink|dlopen)\s*$",
            no_comments, re.MULTILINE):
        add("C-MACRO-ALIAS", f"宏把 {m.group(1)} 改名：调用点看起来无害", no_comments.count("\n", 0, m.start()) + 1)
    for m in re.finditer(r"\b(?:while\s*\(\s*1\s*\)|for\s*\(\s*;\s*;\s*\))", code):
        line = code.count("\n", 0, m.start()) + 1
        tail = code[m.end():m.end() + 2000]
        if not re.search(r"\bbreak\s*;", tail):
            add("C-INFINITE-LOOP", "无 break 的死循环：只能由超时/CPU 限制终止", line)
    for m in PROMPT_RE.finditer(comments):
        add("C-PROMPT-INJECTION", "注释包含提示注入文本；验证器不执行注释",
            comments.count("\n", 0, m.start()) + 1)
    return findings


R_CALL_RE = re.compile(
    r"\b(Command::new|std::process::Command|std::fs::remove_file|std::fs::remove_dir_all|"
    r"TcpStream|UdpSocket|TcpListener|libc::\w+|std::env::var|std::env::var_os)\b")
R_RULES: dict[str, tuple[str, str]] = {
    "Command::new": ("RS-COMMAND", "启动外部进程"),
    "std::process::Command": ("RS-COMMAND", "启动外部进程"),
    "std::fs::remove_file": ("RS-FS-DELETE", "删除文件"),
    "std::fs::remove_dir_all": ("RS-FS-DELETE", "递归删除目录"),
    "TcpStream": ("RS-NET", "TCP 套接字"),
    "UdpSocket": ("RS-NET", "UDP 套接字"),
    "TcpListener": ("RS-NET", "TCP 监听"),
    "std::env::var": ("RS-ENV", "读取环境变量"),
    "std::env::var_os": ("RS-ENV", "读取环境变量"),
}


def _rust_findings(text: str, display: str) -> list[Finding]:
    lines = text.splitlines()
    code = c_strip(text)
    comments = c_strip(text, keep_comments=True)
    findings: list[Finding] = []

    def add(rule: str, message: str, line: int) -> None:
        findings.append(Finding(rule, RULES[rule][0], message, display, line,
                                _line_snippet(lines, line)))

    for m in R_CALL_RE.finditer(code):
        token = m.group(1)
        line = code.count("\n", 0, m.start()) + 1
        if token.startswith("libc::"):
            add("RS-LIBC", "直接调用 libc：越过 Rust 的安全边界", line)
        elif token in R_RULES:
            rule, msg = R_RULES[token]
            add(rule, f"{token}：{msg}", line)
    for m in re.finditer(r"\bunsafe\s*\{", code):
        add("RS-UNSAFE", "unsafe 块：该区域的内存安全由作者负责", code.count("\n", 0, m.start()) + 1)
    for m in re.finditer(r"\bextern\s+\"C\"", code):
        add("RS-EXTERN-C", "extern \"C\"：跨语言 ABI 边界", code.count("\n", 0, m.start()) + 1)
    for m in re.finditer(r"\bloop\s*\{", code):
        tail = code[m.end():m.end() + 2000]
        if not re.search(r"\bbreak\b", tail):
            add("RS-LOOP", "loop 无 break：只能由超时/CPU 限制终止",
                code.count("\n", 0, m.start()) + 1)
    for m in PROMPT_RE.finditer(comments):
        add("C-PROMPT-INJECTION", "注释包含提示注入文本；验证器不执行注释",
            comments.count("\n", 0, m.start()) + 1)
    return findings


def scan_source(lang: str, path: Path, display: str) -> list[Finding]:
    data = path.read_bytes()
    try:
        text = data.decode("utf-8")
    except UnicodeDecodeError:
        return [Finding("PY-SYNTAX" if lang == "python" else "C-SYNTAX" if lang == "c" else "RS-SYNTAX",
                        "high", "源码不是 UTF-8，无法静态分析", display, 1, "")]
    if lang == "python":
        return scan_python(display, text, display)
    if lang == "c":
        return _c_findings(text, display)
    if lang == "rust":
        return _rust_findings(text, display)
    raise GuardError(f"未知语言：{lang}")


# --------------------------------------------------------------------------- #
# 编译门禁
# --------------------------------------------------------------------------- #

def _compiler_available(name: str) -> str | None:
    return shutil.which(name)


def compile_gate(lang: str, src: Path, workdir: Path) -> dict:
    """语法/类型门禁。Python: py_compile；C: -fsyntax-only；Rust: --emit=metadata。"""
    started = time.monotonic()
    if lang == "python":
        tool = sys.executable
        argv = [tool, "-I", "-m", "py_compile", "candidate.py"]
        copy_to = workdir / "candidate.py"
    elif lang == "c":
        tool = _compiler_available("cc")
        if tool is None:
            return {"status": "skip", "reason": "cc 不可用", "argv": [], "exit_code": None,
                    "elapsed_ms": 0}
        argv = [tool, "-std=c17", "-Wall", "-Wextra", "-Werror", "-fsyntax-only", "candidate.c"]
        copy_to = workdir / "candidate.c"
    else:
        tool = _compiler_available("rustc")
        if tool is None:
            return {"status": "skip", "reason": "rustc 不可用", "argv": [], "exit_code": None,
                    "elapsed_ms": 0}
        argv = [tool, "--edition", "2021", "--emit=metadata", "-o", "candidate.rmeta", "candidate.rs"]
        copy_to = workdir / "candidate.rs"
    shutil.copyfile(src, copy_to)
    env = compiler_env(str(workdir))
    try:
        proc = subprocess.run(argv, cwd=workdir, env=env, capture_output=True,
                              text=True, timeout=30)
        rc = proc.returncode
        stderr = proc.stderr
    except subprocess.TimeoutExpired:
        rc = -1
        stderr = "编译门禁超时（30s）"
    elapsed = int((time.monotonic() - started) * 1000)
    status = "pass" if rc == 0 else "fail"
    first_line = ""
    lineno = 1
    for line in stderr.splitlines():
        if "error" in line.lower() or "错误" in line:
            first_line = line.strip()
            m = re.search(r":(\d+):(?:\d+:)?", line) or re.search(r"line (\d+)", line)
            if m:
                lineno = int(m.group(1))
            break
    return {
        "status": status,
        "argv": argv,
        "exit_code": rc,
        "elapsed_ms": elapsed,
        "stderr": stderr[-2000:],
        "first_error": first_line[:500],
        "line": lineno,
    }


def clean_env(tmp: str) -> dict[str, str]:
    """只给最小环境；不继承 PATH 之外的用户变量、代理、令牌。"""
    return {
        "PATH": "/usr/bin:/bin:/usr/sbin:/sbin",
        "LANG": "C.UTF-8",
        "LC_ALL": "C.UTF-8",
        "TZ": "UTC",
        "HOME": tmp,
        "TMPDIR": tmp,
        "PYTHONHASHSEED": "0",
        "PYTHONIOENCODING": "utf-8",
        "NO_COLOR": "1",
    }


def compiler_env(tmp: str) -> dict[str, str]:
    """编译器的环境：保留 rustup 定位 toolchain 所需的 HOME/RUSTUP_HOME。

    编译器是受信工具，不执行候选代码；候选程序的运行仍用 clean_env。
    """
    env = clean_env(tmp)
    env["HOME"] = os.path.expanduser("~")
    for key in ("RUSTUP_HOME", "CARGO_HOME"):
        value = os.environ.get(key)
        if value:
            env[key] = value
    return env


# --------------------------------------------------------------------------- #
# 行为门禁
# --------------------------------------------------------------------------- #

def load_cases(path: Path) -> list[dict]:
    if not path.is_file():
        raise GuardError(f"测试夹具不存在：{path}")
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise GuardError(f"测试夹具不是合法 JSON：{exc}") from exc
    if isinstance(data, dict) and "cases" in data:
        cases = data["cases"]
    elif isinstance(data, list):
        cases = data
    else:
        cases = [data]
    if not isinstance(cases, list) or not cases:
        raise GuardError("测试夹具必须包含至少一个 case")
    out = []
    for i, case in enumerate(cases):
        if not isinstance(case, dict):
            raise GuardError(f"case[{i}] 必须是对象")
        name = case.get("name") or f"case-{i + 1}"
        argv = case.get("argv", [])
        if not isinstance(argv, list) or not all(isinstance(x, str) for x in argv):
            raise GuardError(f"case[{name}].argv 必须是字符串数组")
        stdin = case.get("stdin", "")
        if not isinstance(stdin, str):
            raise GuardError(f"case[{name}].stdin 必须是字符串")
        stdout = case.get("stdout")
        if stdout is not None and not isinstance(stdout, str):
            raise GuardError(f"case[{name}].stdout 必须是字符串")
        exit_code = case.get("exit_code", 0)
        if not isinstance(exit_code, int):
            raise GuardError(f"case[{name}].exit_code 必须是整数")
        files = case.get("files", {})
        if not isinstance(files, dict):
            raise GuardError(f"case[{name}].files 必须是对象")
        for rel in files:
            if os.path.isabs(rel) or ".." in Path(rel).parts:
                raise GuardError(f"case[{name}].files 含非法路径：{rel}")
        timeout_s = case.get("timeout_s")
        if timeout_s is not None and (not isinstance(timeout_s, (int, float)) or timeout_s <= 0):
            raise GuardError(f"case[{name}].timeout_s 必须是正数")
        out.append({"name": name, "argv": argv, "stdin": stdin, "stdout": stdout,
                    "exit_code": exit_code, "files": files, "timeout_s": timeout_s})
    return out


def _set_limits(policy: dict):
    sb = policy["sandbox"]
    cpu = int(sb["cpu_s"])
    as_bytes = int(sb["address_space_mb"]) * 1024 * 1024
    fsize = int(sb["file_size_mb"]) * 1024 * 1024
    nofile = int(sb["nofile"])

    def apply() -> None:
        applied: dict[str, object] = {}
        skipped: list[str] = []
        try:
            resource.setrlimit(resource.RLIMIT_CPU, (cpu, cpu + 1))
            applied["cpu_s"] = cpu
        except (ValueError, OSError) as exc:
            skipped.append(f"cpu: {exc}")
        # macOS 的 RLIMIT_AS 不能低于进程当前虚拟地址占用（共享缓存可达数百 GB），
        # 因此从请求值起翻倍，记录真正生效的值；Linux 上第一次就会成功。
        if hasattr(resource, "RLIMIT_AS"):
            value = as_bytes
            effective = None
            for _ in range(12):
                try:
                    resource.setrlimit(resource.RLIMIT_AS, (value, value))
                    effective = value
                    break
                except (ValueError, OSError):
                    value *= 2
            if effective is None:
                skipped.append("address_space: 无法设置低于当前虚拟内存的 RLIMIT_AS")
            else:
                applied["address_space_mb"] = effective // (1024 * 1024)
        try:
            resource.setrlimit(resource.RLIMIT_FSIZE, (fsize, fsize))
            applied["file_size_mb"] = fsize // (1024 * 1024)
        except (ValueError, OSError) as exc:
            skipped.append(f"file_size: {exc}")
        try:
            soft, hard = resource.getrlimit(resource.RLIMIT_NOFILE)
            effective_nofile = min(nofile, hard) if hard != resource.RLIM_INFINITY else nofile
            resource.setrlimit(resource.RLIMIT_NOFILE, (effective_nofile, hard))
            applied["nofile"] = effective_nofile
        except (ValueError, OSError) as exc:
            skipped.append(f"nofile: {exc}")
        try:
            with open(".limits.json", "w", encoding="utf-8") as fh:
                json.dump({"applied": applied, "skipped": skipped}, fh)
        except OSError:
            pass

    return apply


def _snapshot(root: Path, ignore: set[str]) -> dict[str, str]:
    out = {}
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in {"__pycache__"}]
        for name in filenames:
            rel = os.path.relpath(os.path.join(dirpath, name), root)
            if rel in ignore:
                continue
            try:
                st = os.stat(os.path.join(dirpath, name))
            except OSError:
                continue
            out[rel.replace(os.sep, "/")] = f"{st.st_size}"
    return out


def _read_limited(path: Path, limit: int) -> tuple[bytes, bool]:
    with open(path, "rb") as fh:
        data = fh.read(limit + 1)
    return data[:limit], len(data) > limit


def run_cases(lang: str, src: Path, case_file: Path, policy: dict, workdir: Path) -> dict:
    """在临时目录里编译并逐 case 执行；返回结构直接进 JSON 证据。"""
    cases = load_cases(case_file)
    max_cases = int(policy["sandbox"]["max_cases"])
    if len(cases) > max_cases:
        raise GuardError(f"case 数量 {len(cases)} 超过 sandbox.max_cases={max_cases}")
    sb = policy["sandbox"]
    default_timeout = float(sb["timeout_s"])
    max_out = int(sb["max_output_bytes"])
    started = time.monotonic()
    results: list[dict] = []
    commands: list[dict] = []
    findings: list[Finding] = []
    behavior_compile: dict | None = None

    # 行为门禁自己编译可执行文件：语法门禁只证明能解析，不证明能链接。
    if lang == "python":
        shutil.copyfile(src, workdir / "candidate.py")
        base_cmd = [sys.executable, "-I", "-B", "../candidate.py"]
    elif lang == "c":
        cc = _compiler_available("cc")
        if cc is None:
            return {"status": "skip", "reason": "cc 不可用", "cases": [], "commands": [],
                    "findings": [Finding("BUILD-TOOL-MISSING", "medium", "cc 不可用，行为门禁跳过",
                                         str(src), 1)]}
        cmd = [cc, "-std=c17", "-O1", "-o", "candidate", "candidate.c"]
        shutil.copyfile(src, workdir / "candidate.c")
        behavior_compile = _run_command(cmd, workdir, 30)
        commands.append({"kind": "behavior-compile", "argv": cmd, "cwd": "tempdir",
                         "exit_code": behavior_compile["exit_code"],
                         "elapsed_ms": behavior_compile["elapsed_ms"]})
        if behavior_compile["exit_code"] != 0:
            findings.append(Finding("C-SYNTAX", "high",
                                    f"C 链接/编译失败：{behavior_compile['stderr'][:300]}",
                                    str(src), 1))
            return {"status": "fail", "reason": "编译失败", "cases": [], "commands": commands,
                    "findings": findings, "compile": behavior_compile}
        base_cmd = ["../candidate"]
    else:
        rustc = _compiler_available("rustc")
        if rustc is None:
            return {"status": "skip", "reason": "rustc 不可用", "cases": [], "commands": [],
                    "findings": [Finding("BUILD-TOOL-MISSING", "medium", "rustc 不可用，行为门禁跳过",
                                         str(src), 1)]}
        cmd = [rustc, "--edition", "2021", "-O", "-o", "candidate", "candidate.rs"]
        shutil.copyfile(src, workdir / "candidate.rs")
        behavior_compile = _run_command(cmd, workdir, 30)
        commands.append({"kind": "behavior-compile", "argv": cmd, "cwd": "tempdir",
                         "exit_code": behavior_compile["exit_code"],
                         "elapsed_ms": behavior_compile["elapsed_ms"]})
        if behavior_compile["exit_code"] != 0:
            findings.append(Finding("RS-SYNTAX", "high",
                                    f"Rust 链接/编译失败：{behavior_compile['stderr'][:300]}",
                                    str(src), 1))
            return {"status": "fail", "reason": "编译失败", "cases": [], "commands": commands,
                    "findings": findings, "compile": behavior_compile}
        base_cmd = ["../candidate"]

    for idx, case in enumerate(cases):
        case_dir = workdir / f"case-{idx + 1}"
        case_dir.mkdir(parents=True, exist_ok=True)
        for rel, content in case["files"].items():
            target = case_dir / rel
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(content, encoding="utf-8")
        before = _snapshot(case_dir, {".limits.json", ".stdout.txt", ".stderr.txt"})
        stdout_path = case_dir / ".stdout.txt"
        stderr_path = case_dir / ".stderr.txt"
        timeout_s = float(case["timeout_s"] or default_timeout)
        timeout_s = max(0.1, min(timeout_s, 60.0))
        argv = base_cmd + case["argv"]
        t0 = time.monotonic()
        timed_out = False
        with open(stdout_path, "wb") as out_f, open(stderr_path, "wb") as err_f:
            try:
                proc = subprocess.Popen(
                    argv, cwd=case_dir, env=clean_env(str(case_dir)),
                    stdin=subprocess.PIPE, stdout=out_f, stderr=err_f,
                    start_new_session=True, preexec_fn=_set_limits(policy),
                )
            except (OSError, subprocess.SubprocessError) as exc:
                results.append({"name": case["name"], "status": "error",
                                "error": str(exc), "elapsed_ms": 0})
                continue
            try:
                proc.communicate(input=case["stdin"].encode("utf-8"), timeout=timeout_s)
            except subprocess.TimeoutExpired:
                timed_out = True
                try:
                    os.killpg(proc.pid, signal.SIGKILL)
                except ProcessLookupError:
                    pass
                proc.communicate()
        elapsed = int((time.monotonic() - t0) * 1000)
        out_data, out_trunc = _read_limited(stdout_path, max_out)
        err_data, err_trunc = _read_limited(stderr_path, max_out)
        after = _snapshot(case_dir, {".limits.json", ".stdout.txt", ".stderr.txt"})
        created = sorted(set(after) - set(before))
        limits: dict = {"applied": {}, "skipped": []}
        try:
            limits = json.loads((case_dir / ".limits.json").read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            limits["skipped"] = ["limits file missing"]
        rc = proc.returncode
        sig = -rc if rc is not None and rc < 0 else None
        stderr_text = err_data.decode("utf-8", "replace")
        resource_hit = None
        if sig == signal.SIGXCPU:
            resource_hit = "cpu"
        elif sig == signal.SIGXFSZ:
            resource_hit = "fsize"
        elif sig == signal.SIGKILL and not timed_out:
            resource_hit = "address_space_or_oom"
        elif ("MemoryError" in stderr_text or "Cannot allocate memory" in stderr_text
              or "File too large" in stderr_text):
            resource_hit = "address_space" if "MemoryError" in stderr_text else "fsize"
        expected_stdout = case["stdout"]
        cmp_out = None
        if expected_stdout is not None:
            exp = expected_stdout.encode("utf-8")
            cmp_out = "match" if out_data == exp else "mismatch"
        if timed_out:
            status = "timeout"
        elif resource_hit:
            status = "resource"
        elif sig is not None:
            status = "signal"
        elif rc != case["exit_code"]:
            status = "fail-exit"
        elif cmp_out == "mismatch":
            status = "fail-output"
        else:
            status = "pass"
        detail = {
            "name": case["name"],
            "status": status,
            "exit_code": rc,
            "signal": sig,
            "timed_out": timed_out,
            "resource": resource_hit,
            "elapsed_ms": elapsed,
            "timeout_s": timeout_s,
            "stdout_bytes": len(out_data),
            "stdout_sha256": hashlib.sha256(out_data).hexdigest(),
            "stdout_truncated": out_trunc,
            "limits": limits,
            "stderr_bytes": len(err_data),
            "stderr_truncated": err_trunc,
            "expected_stdout_matches": cmp_out,
            "workspace_created": created[:50],
        }
        if status == "fail-output":
            got = out_data.decode("utf-8", "replace").splitlines(keepends=True)
            want = expected_stdout.splitlines(keepends=True)
            diff = list(difflib.unified_diff(want, got, fromfile="expected", tofile="actual", n=1))
            detail["diff"] = "".join(diff[:24])[:2000]
        if stderr_text:
            detail["stderr"] = stderr_text[:1000]
        results.append(detail)
        commands.append({"kind": "run", "argv": argv, "cwd": "case-N",
                         "exit_code": rc, "elapsed_ms": elapsed, "timeout_s": timeout_s})

        if status == "timeout":
            findings.append(Finding("RUN-TIMEOUT", "medium",
                                    f"case {case['name']} 超时 {timeout_s}s", str(src), 0))
        elif status == "resource":
            findings.append(Finding("RUN-RESOURCE", "medium",
                                    f"case {case['name']} 触发资源限制：{resource_hit}", str(src), 0))
        elif status == "signal":
            findings.append(Finding("RUN-SIGNAL", "high",
                                    f"case {case['name']} 被信号 {sig} 终止", str(src), 0))
        elif status == "fail-exit":
            findings.append(Finding("RUN-EXIT", "high",
                                    f"case {case['name']} 退出码 {rc}，期望 {case['exit_code']}",
                                    str(src), 0))
        elif status == "fail-output":
            findings.append(Finding("RUN-OUTPUT", "high",
                                    f"case {case['name']} 标准输出与期望不符", str(src), 0))

    statuses = [c["status"] for c in results]
    if any(s in {"fail-exit", "fail-output", "signal"} for s in statuses) or not results:
        status = "fail"
    elif any(s in {"timeout", "resource"} for s in statuses):
        status = "quarantine"
    else:
        status = "pass"
    return {"status": status, "cases": results, "commands": commands, "findings": findings,
            "elapsed_ms": int((time.monotonic() - started) * 1000),
            "compile": behavior_compile}


def _run_command(argv: list[str], cwd: Path, timeout_s: float) -> dict:
    t0 = time.monotonic()
    try:
        proc = subprocess.run(argv, cwd=cwd, env=compiler_env(str(cwd)),
                              capture_output=True, text=True, timeout=timeout_s)
        rc, out, err = proc.returncode, proc.stdout, proc.stderr
    except subprocess.TimeoutExpired:
        rc, out, err = -1, "", "命令超时"
    return {"exit_code": rc, "stdout": out[-1000:], "stderr": err[-2000:],
            "elapsed_ms": int((time.monotonic() - t0) * 1000)}


# --------------------------------------------------------------------------- #
# 单文件评估与裁决
# --------------------------------------------------------------------------- #

def _hash_file(path: Path) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as fh:
        for chunk in iter(lambda: fh.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()


def _finding_from_compile(check: dict, lang: str, display: str) -> Finding:
    rule = {"python": "PY-SYNTAX", "c": "C-SYNTAX", "rust": "RS-SYNTAX"}[lang]
    msg = check.get("first_error") or (check.get("stderr", "").strip().splitlines() or ["编译失败"])[0]
    return Finding(rule, "high", f"编译门禁失败：{msg[:400]}", display,
                   int(check.get("line") or 1), "")


def evaluate(path: Path, lang: str, policy: dict, mode: dict, tests: Path | None,
             policy_path: str) -> dict:
    started = time.monotonic()
    display = str(path)
    gates = ["static"]
    if not mode["static_only"]:
        gates.append("compile")
    if mode["run"]:
        gates.append("behavior")
    size = path.stat().st_size
    if size > policy["max_file_bytes"]:
        raise GuardError(f"{display} 大小 {size} 超过 max_file_bytes={policy['max_file_bytes']}")
    raw_findings = scan_source(lang, path, display)
    findings, suppressed = apply_policy(raw_findings, policy)
    checks: list[dict] = []
    static_status = "pass" if not findings else (
        "fail" if any(RANK[f.severity] >= RANK[policy["reject_at"]] for f in findings) else "warn")
    checks.append({"name": "static", "status": static_status,
                   "findings": len(findings), "suppressed": len(suppressed)})

    compile_check: dict | None = None
    if not mode["static_only"]:
        with tempfile.TemporaryDirectory(prefix="guard-compile-") as td:
            compile_check = compile_gate(lang, path, Path(td))
        checks.append({"name": "compile", "status": compile_check["status"],
                       "reason": compile_check.get("reason"),
                       "exit_code": compile_check.get("exit_code"),
                       "elapsed_ms": compile_check.get("elapsed_ms", 0)})
        if compile_check["status"] == "fail":
            findings.append(_finding_from_compile(compile_check, lang, display))
        elif compile_check["status"] == "skip":
            findings.append(Finding("BUILD-TOOL-MISSING", "medium",
                                    compile_check.get("reason", "工具链不可用"), display, 1))
    else:
        checks.append({"name": "compile", "status": "skip", "reason": "static-only"})

    behavior: dict | None = None
    behavior_commands: list[dict] = []
    max_sev = max((RANK[f.severity] for f in findings), default=0)
    if mode["run"]:
        if tests is None:
            if policy["require_tests"]:
                findings.append(Finding("RUN-NO-TESTS", "medium",
                                        "请求 --run 但未提供 --tests，行为不可验证", display, 0))
            checks.append({"name": "behavior", "status": "skip", "reason": "no tests fixture"})
        elif max_sev >= RANK[policy["execute_below"]]:
            checks.append({"name": "behavior", "status": "skip",
                           "reason": f"静态严重度达到 {policy['execute_below']}，拒绝执行"})
        elif compile_check is not None and compile_check["status"] != "pass":
            checks.append({"name": "behavior", "status": "skip", "reason": "编译门禁未通过"})
        else:
            with tempfile.TemporaryDirectory(prefix="guard-run-") as td:
                behavior = run_cases(lang, path, tests, policy, Path(td))
            behavior_findings = behavior.get("findings", [])
            behavior_commands = behavior.get("commands", [])
            findings.extend(behavior_findings)
            # 证据只保留一份：详细 case 在 behavior.cases，命令在 evidence.commands。
            behavior.pop("findings", None)
            behavior.pop("commands", None)
            checks.append({
                "name": "behavior",
                "status": behavior["status"],
                "reason": behavior.get("reason"),
                "cases": [{"name": c["name"], "status": c["status"],
                           "exit_code": c["exit_code"], "elapsed_ms": c["elapsed_ms"]}
                          for c in behavior.get("cases", [])],
            })
    else:
        checks.append({"name": "behavior", "status": "skip", "reason": "not requested"})

    findings, suppressed2 = apply_policy(findings, policy)
    suppressed.extend(suppressed2)
    max_sev = max((RANK[f.severity] for f in findings), default=0)
    if max_sev >= RANK[policy["reject_at"]]:
        verdict = "reject"
    elif max_sev >= RANK[policy["quarantine_at"]]:
        verdict = "quarantine"
    else:
        verdict = "accept"

    active_sorted = sorted(findings, key=lambda f: (-RANK[f.severity], f.file, f.line, f.rule))
    if verdict == "quarantine":
        human = {"required": True, "status": "pending", "reason": "存在需要人工判断的中危发现",
                 "reviewer": None, "decision": None, "notes": None}
    elif verdict == "reject":
        human = {"required": False, "status": "not_required",
                 "reason": "硬门禁失败；可申诉，但不应直接合并", "reviewer": None,
                 "decision": None, "notes": None}
    else:
        human = {"required": False, "status": "not_required", "reason": None,
                 "reviewer": None, "decision": None, "notes": None}

    commands: list[dict] = []
    if compile_check and compile_check.get("argv"):
        commands.append({"kind": "compile", "argv": compile_check["argv"], "cwd": "tempdir",
                         "exit_code": compile_check["exit_code"],
                         "elapsed_ms": compile_check["elapsed_ms"]})
    commands.extend(behavior_commands)

    report = {
        "tool": TOOL,
        "schema": SCHEMA,
        "target": display,
        "language": lang,
        "verdict": verdict,
        "gates": gates,
        "policy": {"name": policy["name"], "path": policy_path,
                   "sha256": _policy_hash(policy_path)},
        "findings": [f.as_dict() for f in active_sorted],
        "suppressed": suppressed,
        "checks": checks,
        "evidence": {
            "code_sha256": _hash_file(path),
            "code_bytes": size,
            "tests_sha256": _hash_file(tests) if tests else None,
            "commands": commands,
            "started_at": _dt.datetime.now(_dt.timezone.utc).isoformat(timespec="seconds"),
            "elapsed_ms": int((time.monotonic() - started) * 1000),
        },
        "human_review": human,
        "limits": [
            "进程级 RLIMIT + 超时，不是命名空间/虚拟机隔离",
            "没有文件系统、网络或系统调用隔离",
            "静态规则是模式匹配，不是语义证明",
            "行为门禁只覆盖提供的测试用例",
        ],
    }
    if behavior:
        report["behavior"] = behavior
    return report


def _policy_hash(policy_path: str) -> str:
    if policy_path == "<builtin>":
        raw = json.dumps(DEFAULT_POLICY, ensure_ascii=False, sort_keys=True).encode()
        return hashlib.sha256(raw).hexdigest()
    return _hash_file(Path(policy_path))


# --------------------------------------------------------------------------- #
# CLI
# --------------------------------------------------------------------------- #

def detect_lang(path: Path, requested: str) -> str:
    if requested != "auto":
        return requested
    lang = EXT_LANG.get(path.suffix.lower())
    if lang is None:
        raise GuardError(f"无法从扩展名判断语言：{path}（用 --lang 指定）")
    return lang


def collect_targets(paths: list[str], lang: str) -> list[Path]:
    out: list[Path] = []
    for raw in paths:
        p = Path(raw)
        if not p.exists():
            raise GuardError(f"目标不存在：{raw}")
        if p.is_dir():
            for child in sorted(p.rglob("*")):
                if child.is_file() and not any(part.startswith(".") for part in child.parts):
                    detected = EXT_LANG.get(child.suffix.lower())
                    if detected and (lang == "auto" or detected == lang):
                        out.append(child)
        else:
            out.append(p)
    if not out:
        raise GuardError("没有匹配的目标文件")
    return out


def human_report(report: dict) -> str:
    lines = [f"{report['verdict'].upper():10s} {report['target']} ({report['language']})"]
    for check in report["checks"]:
        detail = f" ({check.get('reason')})" if check.get("reason") else ""
        lines.append(f"  {check['name']:9s} {check['status']}{detail}")
    for f in report["findings"]:
        lines.append(f"  [{f['severity']:6s}] {f['rule']:22s} {f['file']}:{f['line']} {f['message']}")
    if report["human_review"]["required"]:
        lines.append("  human_review: required (quarantine)")
    return "\n".join(lines)


def brief_report(report: dict) -> dict:
    """人类复核视图：保留裁决、发现、门禁与证据摘要，去掉重复的命令参数。"""
    checks = []
    for check in report["checks"]:
        item = {"name": check["name"], "status": check["status"]}
        for key in ("reason", "exit_code", "elapsed_ms", "findings"):
            if check.get(key) is not None:
                item[key] = check[key]
        checks.append(item)
    ev = report["evidence"]
    out = {
        "target": report["target"],
        "language": report["language"],
        "verdict": report["verdict"],
        "findings": report["findings"],
        "checks": checks,
        "evidence": {
            "code_sha256": ev["code_sha256"],
            "policy_sha256": report["policy"]["sha256"],
            "tests_sha256": ev.get("tests_sha256"),
            "commands": [{"kind": c["kind"], "exit_code": c["exit_code"],
                          "elapsed_ms": c["elapsed_ms"]} for c in ev["commands"]],
            "elapsed_ms": ev["elapsed_ms"],
        },
        "human_review": report["human_review"],
    }
    if "behavior" in report:
        behavior = report["behavior"]
        cases = []
        for case in behavior.get("cases", []):
            item = {k: case[k] for k in
                    ("name", "status", "exit_code", "timed_out", "resource",
                     "stdout_sha256", "expected_stdout_matches") if k in case}
            if "limits" in case:
                item["limits"] = case["limits"]
            cases.append(item)
        out["behavior"] = {"status": behavior["status"], "cases": cases}
    return out


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        prog="guard.py",
        description="agent 代码验证器：静态规则 + 编译门禁 + 受限行为门禁 + 证据化裁决")
    parser.add_argument("targets", nargs="+", help="代码文件或目录")
    parser.add_argument("--lang", choices=["auto", "python", "c", "rust"], default="auto")
    parser.add_argument("--policy", default=None, help="策略 JSON；缺省用内置 default")
    parser.add_argument("--json", action="store_true", help="输出机器可读裁决 JSON")
    parser.add_argument("--brief", action="store_true",
                        help="输出人类复核用的 JSON 子集（隐含 --json）")
    parser.add_argument("--static-only", action="store_true", help="只跑静态规则，不编译不执行")
    parser.add_argument("--compile", action="store_true", help="显式启用编译门禁（默认已启用）")
    parser.add_argument("--run", action="store_true", help="启用行为门禁，需要 --tests")
    parser.add_argument("--tests", default=None, help="行为门禁的 JSON 测试夹具")
    args = parser.parse_args(argv)
    if args.brief:
        args.json = True

    try:
        if args.static_only and (args.run or args.tests):
            raise GuardError("--static-only 不能与 --run/--tests 同时使用")
        if args.tests and not args.run:
            raise GuardError("--tests 需要与 --run 一起使用")
        policy, policy_path, _ = load_policy(args.policy)
        tests = Path(args.tests) if args.tests else None
        if tests is not None and not tests.is_file():
            raise GuardError(f"测试夹具不存在：{tests}")
        targets = collect_targets(args.targets, args.lang)
        mode = {"static_only": args.static_only, "run": args.run}
        reports = []
        for target in targets:
            lang = detect_lang(target, args.lang)
            reports.append(evaluate(target, lang, policy, mode, tests, policy_path))
        if len(reports) == 1:
            payload = reports[0]
        else:
            worst = "accept"
            for r in reports:
                if r["verdict"] == "reject":
                    worst = "reject"
                    break
                if r["verdict"] == "quarantine":
                    worst = "quarantine"
            payload = {"tool": TOOL, "schema": SCHEMA, "verdict": worst,
                       "policy": reports[0]["policy"], "targets": reports,
                       "summary": {v: sum(1 for r in reports if r["verdict"] == v)
                                   for v in ("accept", "reject", "quarantine")},
                       "human_review": {
                           "required": worst == "quarantine",
                           "status": "pending" if worst == "quarantine" else "not_required",
                           "reason": "目录中存在 quarantine 目标" if worst == "quarantine" else None,
                           "reviewer": None, "decision": None, "notes": None},
                       "limits": reports[0]["limits"]}
        if args.brief:
            if "targets" in payload:
                payload = {
                    "tool": TOOL, "schema": SCHEMA, "verdict": payload["verdict"],
                    "summary": payload["summary"],
                    "targets": [brief_report(r) for r in reports],
                    "human_review": payload["human_review"],
                }
            else:
                payload = brief_report(payload)
        if args.json:
            print(json.dumps(payload, ensure_ascii=False, indent=2, sort_keys=False))
        else:
            if "targets" in payload:
                for r in reports:
                    print(human_report(r))
                print(f"SUMMARY {payload['summary']} -> {payload['verdict']}")
            else:
                print(human_report(payload))
        return VERDICT_EXIT[payload["verdict"]]
    except GuardError as exc:
        err = {"tool": TOOL, "schema": SCHEMA, "error": str(exc), "verdict": None}
        if args.json:
            print(json.dumps(err, ensure_ascii=False, indent=2))
        else:
            print(f"ERROR: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
