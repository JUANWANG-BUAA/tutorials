
#!/usr/bin/env python3
"""Static-site postprocess: image weight + native lazy loading.

Runs on _site/ only; source assets stay untouched.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

try:
    from PIL import Image
except Exception as exc:  # pragma: no cover
    print("optimize_site: Pillow unavailable, HTML attrs only:", exc)
    Image = None

ROOT = Path(sys.argv[1] if len(sys.argv) > 1 else "_site")
IMG_RE = re.compile(r"<img\b([^>]*)>", re.I)
ATTR_RE = re.compile(r"""([a-zA-Z_:][-a-zA-Z0-9_:.]*)\s*=\s*(?:"([^"]*)"|'([^']*)')""")

def attrs_of(raw: str) -> dict[str, str]:
    out = {}
    for m in ATTR_RE.finditer(raw):
        out[m.group(1).lower()] = m.group(2) if m.group(2) is not None else m.group(3)
    return out

def local_image(html: Path, src: str) -> Path | None:
    if not src or src.startswith(("data:", "http:", "https:", "//")):
        return None
    src = src.split("#", 1)[0].split("?", 1)[0]
    candidate = (html.parent / src).resolve()
    try:
        candidate.relative_to(ROOT.resolve())
    except ValueError:
        return None
    return candidate if candidate.is_file() else None

def optimize_images() -> None:
    if Image is None:
        return
    before = after = 0
    changed = 0
    for path in ROOT.rglob("*"):
        if path.suffix.lower() not in {".jpg", ".jpeg", ".png"}:
            continue
        size = path.stat().st_size
        if size < 120_000:
            continue
        try:
            with Image.open(path) as im:
                width, height = im.size
                if size < 150_000 and max(width, height) <= 1600:
                    continue
                before += size
                if max(width, height) > 1600:
                    im.thumbnail((1600, 1600), Image.Resampling.LANCZOS)
                out = path.with_name(path.name + ".opt")
                if path.suffix.lower() == ".png":
                    im.save(out, "PNG", optimize=True)
                else:
                    if im.mode not in ("RGB", "L"):
                        im = im.convert("RGB")
                    im.save(out, "JPEG", quality=82, optimize=True, progressive=True)
                new_size = out.stat().st_size
                if new_size < size * 0.94:
                    out.replace(path)
                    after += new_size
                    changed += 1
                else:
                    out.unlink()
                    after += size
        except Exception as exc:
            print("optimize_site: skip", path, exc)
    if before:
        print(f"optimize_site: images {changed} changed, {before/1048576:.1f}M → {after/1048576:.1f}M")

def optimize_html() -> None:
    pages = 0
    for html in ROOT.rglob("*.html"):
        text = html.read_text(encoding="utf-8")
        seen = 0
        def repl(match: re.Match[str]) -> str:
            nonlocal seen
            raw = match.group(1)
            attrs = attrs_of(raw)
            src = attrs.get("src", "")
            first = seen == 0
            seen += 1
            additions = []
            if first:
                # 首图通常是首屏封面/主图：不要 lazy，否则会拖慢 LCP。
                if "loading" not in attrs:
                    additions.append('loading="eager"')
                if "fetchpriority" not in attrs:
                    additions.append('fetchpriority="high"')
            elif "loading" not in attrs:
                additions.append('loading="lazy"')
            if "decoding" not in attrs:
                additions.append('decoding="async"')
            if Image is not None and "width" not in attrs and "height" not in attrs:
                image = local_image(html, src)
                if image:
                    try:
                        with Image.open(image) as im:
                            additions.append(f'width="{im.width}" height="{im.height}"')
                    except Exception:
                        pass
            if not additions:
                return match.group(0)
            return "<img" + raw.rstrip() + " " + " ".join(additions) + ">"
        new = IMG_RE.sub(repl, text)
        if new != text:
            html.write_text(new, encoding="utf-8")
            pages += 1
    print(f"optimize_site: lazy/dimensions on {pages} pages")

if __name__ == "__main__":
    if not ROOT.is_dir():
        raise SystemExit(f"optimize_site: {ROOT} not found")
    optimize_images()
    optimize_html()
