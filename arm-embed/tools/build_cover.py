#!/usr/bin/env python3
"""生成《嵌入式系统》教程的两个封面资产（SVG）。

- 主封面（深色，600×800）：用于书首页 3D 书封与教程库首页书墙。
  中央插图＝一颗芯片引出五级流水���阶梯 + 异常向量梯，呼应"从复位到运行"。
- rhine 版（浅色版画）：教程库首页 portal 的封面。

与 tools/build_covers.py 同属"图鉴"视觉系统：同一套骨架（出版行 / 印鉴 /
卷号 / 细网格），按学科换中央插图与色温。纯 SVG，无位图、无外链字体。
"""
from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent.parent
OUT_MAIN = ROOT / "arm-embed" / "src" / "assets" / "covers" / "arm-embed.svg"
OUT_RHINE = Path(__file__).resolve().parent.parent / ".." / ".." / "shared" / "theme" / "assets" / "rhine-arm-embed.svg"

FONT = "'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif"
MONO = "'SFMono-Regular','Roboto Mono',Consolas,monospace"


def esc(text: str) -> str:
    return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def txt(x, y, s, size=16, fill="#fff", weight=400, anchor="start", family=FONT, opacity=1, spacing=None):
    extra = f' letter-spacing="{spacing}"' if spacing else ""
    return (
        f'<text x="{x}" y="{y}" fill="{fill}" font-size="{size}" font-weight="{weight}" '
        f'font-family="{family}" text-anchor="{anchor}" opacity="{opacity}"{extra}>{esc(s)}</text>'
    )


def chip(uid: str, x: int, y: int, w: int, h: int, pins: int = 7) -> str:
    """一颗带引脚的芯片。"""
    out = []
    step = w / (pins + 1)
    for i in range(pins):
        px = x + step * (i + 1)
        out.append(f'<rect x="{px-5:.1f}" y="{y-16}" width="10" height="16" rx="2" fill="#2b3a57"/>')
        out.append(f'<rect x="{px-5:.1f}" y="{y+h}" width="10" height="16" rx="2" fill="#2b3a57"/>')
    vstep = h / (pins + 1)
    for i in range(pins):
        py = y + vstep * (i + 1)
        out.append(f'<rect x="{x-16}" y="{py-5:.1f}" width="16" height="10" rx="2" fill="#2b3a57"/>')
        out.append(f'<rect x="{x+w}" y="{py-5:.1f}" width="16" height="10" rx="2" fill="#2b3a57"/>')
    out.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="16" fill="#16233c" stroke="#7d94bb" stroke-opacity=".8"/>')
    out.append(f'<rect x="{x+14}" y="{y+14}" width="{w-28}" height="{h-28}" rx="10" fill="url(#{uid}-grid)" opacity=".4"/>')
    return "".join(out)


def cover_main() -> str:
    uid = "ae"
    top, bottom = "#0b1220", "#1b2740"
    accent, gold = "#f5a524", "#ffd166"
    grid = "#7d94bb"
    body = f'''<defs>
  <linearGradient id="{uid}-bg" x1="0" y1="0" x2="0.8" y2="1">
    <stop offset="0" stop-color="{top}"/><stop offset="1" stop-color="{bottom}"/>
  </linearGradient>
  <linearGradient id="{uid}-accent" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" stop-color="{accent}"/><stop offset="1" stop-color="{gold}"/>
  </linearGradient>
  <radialGradient id="{uid}-glow" cx="50%" cy="50%" r="50%">
    <stop offset="0" stop-color="{accent}" stop-opacity=".42"/><stop offset="1" stop-color="{accent}" stop-opacity="0"/>
  </radialGradient>
  <pattern id="{uid}-grid" width="28" height="28" patternUnits="userSpaceOnUse">
    <path d="M28 0H0V28" fill="none" stroke="{grid}" stroke-width="1"/>
  </pattern>
  <filter id="{uid}-blur" x="-40%" y="-40%" width="180%" height="180%"><feGaussianBlur stdDeviation="12"/></filter>
  <linearGradient id="{uid}-sheen" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" stop-color="#fff" stop-opacity=".17"/><stop offset=".42" stop-color="#fff" stop-opacity=".02"/>
    <stop offset="1" stop-color="#fff" stop-opacity="0"/>
  </linearGradient>
</defs>
<rect width="600" height="800" fill="url(#{uid}-bg)"/>
<rect width="600" height="800" fill="url(#{uid}-grid)" opacity=".22"/>
<ellipse cx="300" cy="330" rx="250" ry="210" fill="url(#{uid}-glow)"/>
<rect x="52" y="104" width="496" height="382" rx="20" fill="#ffffff" fill-opacity=".035" stroke="#ffffff" stroke-opacity=".1"/>
'''
    body += txt(52, 66, "BUAA · TEACHING ATLAS", 10.5, "#b9c9e2", 700, spacing="2.2")
    body += txt(548, 66, "VOL. 14 / EMBEDDED", 10.5, "#b9c9e2", 700, "end", spacing="1.6")

    # 芯片（左中）
    body += chip(uid, 92, 226, 156, 132)
    body += txt(170, 282, "ARM", 25, "#f2f6ff", 700, "middle", MONO, spacing="3")
    body += txt(170, 302, "CORE", 12.5, accent, 700, "middle", MONO, spacing="4")
    body += txt(170, 326, "Cortex-A9", 10.5, "#9fb6d6", 400, "middle", MONO)

    # 异常向量表（右上）
    vectors = [("00", "RST"), ("04", "UND"), ("08", "SWI"), ("18", "IRQ"), ("1C", "FIQ")]
    for i, (addr, tag) in enumerate(vectors):
        y = 148 + i * 30
        hot = tag in ("IRQ", "FIQ")
        body += f'<rect x="368" y="{y}" width="140" height="25" rx="5" fill="{"#2a1c08" if hot else "#16233c"}" stroke="{gold if hot else grid}" stroke-opacity="{".9" if hot else ".45"}"/>'
        body += txt(380, y + 17, f"0x{addr}", 10.5, gold if hot else "#9fb6d6", 700, family=MONO)
        body += txt(498, y + 17, tag, 10.5, "#f6f9ff" if hot else "#8ea6c6", 700, "end", MONO)
    body += txt(368, 316, "异常向量表 · 优先级自上而下", 10, "#9fb6d6")
    body += f'<path d="M248 240 C 290 196, 330 186, 366 186" fill="none" stroke="{gold}" stroke-opacity=".45" stroke-width="1.6" stroke-dasharray="4 7"/>'

    # 存储器映射条（芯片正下方）
    body += '<rect x="92" y="374" width="156" height="22" rx="4" fill="#1d2c47" stroke="#7d94bb" stroke-opacity=".5"/>'
    body += txt(170, 390, "ROM · RAM · MMIO", 9.5, "#9fb6d6", 400, "middle", MONO)
    body += f'<path d="M170 358 L170 372" stroke="{accent}" stroke-width="1.6" stroke-opacity=".8"/>'

    # 五级流水线（下方横排）
    stages = [("IF", "取指"), ("ID", "译码"), ("EX", "执行"), ("MEM", "访存"), ("WB", "回写")]
    sx, sy, sw, sh, gap = 92, 416, 76, 52, 8
    for i, (abbr, cn) in enumerate(stages):
        x = sx + i * (sw + gap)
        body += f'<rect x="{x}" y="{sy}" width="{sw}" height="{sh}" rx="7" fill="#1a2740" stroke="{accent}" stroke-opacity=".85"/>'
        body += txt(x + sw / 2, sy + 24, abbr, 14, "#f6f9ff", 700, "middle", MONO)
        body += txt(x + sw / 2, sy + 42, cn, 11, "#9fb6d6", 400, "middle")
        if i:
            body += f'<path d="M{x-gap+1} {sy+sh/2} L{x-1} {sy+sh/2}" stroke="{gold}" stroke-width="1.6" stroke-opacity=".7"/>'
    body += txt(92, 484, "五级流水线：取指 → 译码 → 执行 → 访存 → 回写", 10, "#8ea6c6")

    # 标题
    body += txt(52, 578, "嵌入式系统", 51, "#f2f7ff", 700, spacing="1")
    body += txt(54, 610, "EMBEDDED SYSTEMS · ARM & RTOS", 12.5, "#9fb6d6", 700, spacing="1.3")
    body += f'<path d="M54 640h196" stroke="url(#{uid}-accent)" stroke-width="3"/>'
    body += txt(54, 674, "ARM 微处理器体系结构 · ARM 指令集", 12.5, "#c8d8f0")
    body += txt(54, 698, "嵌入式操作系统：调度、同步与实时性", 12.5, "#c8d8f0")
    body += txt(548, 674, "3 CHAPTERS", 10.5, gold, 700, "end", MONO, spacing="1.2")
    body += txt(548, 698, "35 SECTIONS", 10.5, "#9fb6d6", 700, "end", MONO, spacing="1.2")
    body += txt(52, 750, "北京航空航天大学 · 研究生课程定制教程", 10, "#8fa8c9", spacing=".6")
    body += f'<g transform="translate(512 738)"><circle r="19" fill="none" stroke="{gold}" stroke-opacity=".7"/><path d="M-9 1h18M0 -8v18" stroke="{gold}" stroke-width="1.2"/><circle r="4" fill="none" stroke="{gold}"/></g>'
    body += f'<rect width="600" height="800" fill="url(#{uid}-sheen)"/>'
    return (
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 800" role="img" '
        'aria-label="嵌入式系统书封：芯片、五级流水线与异常向量表">\n' + body + "\n</svg>\n"
    )


def cover_rhine() -> str:
    """浅色版画版：教程库首页 portal 用。"""
    uid = "aer"
    body = f'''<defs>
  <linearGradient id="plate" x2="1" y2="1"><stop stop-color="#eeece5"/><stop offset=".58" stop-color="#f6f4ef"/><stop offset="1" stop-color="#e2dfd5"/></linearGradient>
  <radialGradient id="halo"><stop stop-color="#d8c08d" stop-opacity=".2"/><stop offset="1" stop-color="#d8c08d" stop-opacity="0"/></radialGradient>
  <pattern id="grid" width="28" height="28" patternUnits="userSpaceOnUse"><path d="M28 0H0V28" fill="none" stroke="#717766" stroke-opacity=".075" stroke-width=".7"/></pattern>
  <pattern id="hatch" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(45)"><path d="M0 0v8" stroke="#6f6a58" stroke-opacity=".14" stroke-width="1.6"/></pattern>
</defs>
<rect width="600" height="800" fill="url(#plate)"/>
<rect width="600" height="800" fill="url(#grid)"/>
<ellipse cx="300" cy="360" rx="250" ry="260" fill="url(#halo)"/>
<rect x="52" y="104" width="496" height="382" rx="16" fill="none" stroke="#8a8471" stroke-opacity=".5"/>
'''
    body += txt(52, 66, "BUAA · TEACHING ATLAS", 10.5, "#6f6a58", 700, spacing="2.2")
    body += txt(548, 66, "VOL. 14 / EMBEDDED", 10.5, "#6f6a58", 700, "end", spacing="1.6")

    # 芯片（左中，版画：细线 + 排线阴影）
    body += f'<rect x="92" y="226" width="156" height="132" rx="10" fill="url(#{uid}-hatch)" stroke="#4a4638" stroke-width="1.6"/>'
    for i in range(5):
        px = 116 + i * 28
        body += f'<rect x="{px-4}" y="212" width="8" height="14" fill="#4a4638"/><rect x="{px-4}" y="358" width="8" height="14" fill="#4a4638"/>'
    for i in range(4):
        py = 252 + i * 28
        body += f'<rect x="78" y="{py-4}" width="14" height="8" fill="#4a4638"/><rect x="248" y="{py-4}" width="14" height="8" fill="#4a4638"/>'
    body += txt(170, 278, "ARM", 26, "#2f2b21", 700, "middle", MONO, spacing="3")
    body += txt(170, 302, "CORTEX-A9", 10.5, "#6f6a58", 700, "middle", MONO, spacing="2")

    # 异常向量梯（右上）
    for i, (addr, tag) in enumerate([("00", "RST"), ("04", "UND"), ("08", "SWI"), ("18", "IRQ"), ("1C", "FIQ")]):
        y = 148 + i * 30
        hot = tag in ("IRQ", "FIQ")
        body += f'<rect x="364" y="{y}" width="144" height="25" rx="4" fill="{"#efe2c4" if hot else "#f6f4ef"}" stroke="#4a4638" stroke-width="{1.5 if hot else 1}"/>'
        body += txt(376, y + 17, f"0x{addr}", 10, "#2f2b21" if hot else "#6f6a58", 700, family=MONO)
        body += txt(498, y + 17, tag, 10, "#2f2b21", 700, "end", MONO)
    body += txt(364, 316, "异常向量表 · 优先级自上而下", 10, "#6f6a58")

    # 存储器条
    body += f'<rect x="92" y="374" width="156" height="22" rx="4" fill="#f6f4ef" stroke="#4a4638" stroke-width="1.1"/>'
    body += txt(170, 390, "ROM · RAM · MMIO", 9.5, "#6f6a58", 400, "middle", MONO)

    # 流水线（下方横排）
    for i, (abbr, cn) in enumerate([("IF", "取指"), ("ID", "译码"), ("EX", "执行"), ("MEM", "访存"), ("WB", "回写")]):
        x = 92 + i * 84
        body += f'<rect x="{x}" y="416" width="76" height="52" rx="6" fill="#f6f4ef" stroke="#4a4638" stroke-width="1.3"/>'
        body += txt(x + 38, 440, abbr, 13, "#2f2b21", 700, "middle", MONO)
        body += txt(x + 38, 458, cn, 10, "#6f6a58", 400, "middle")
    body += txt(92, 484, "五级流水线：取指 → 译码 → 执行 → 访存 → 回写", 10, "#6f6a58")

    body += txt(52, 578, "嵌入式系统", 51, "#2f2b21", 700, spacing="1")
    body += txt(54, 610, "EMBEDDED SYSTEMS · ARM & RTOS", 12.5, "#6f6a58", 700, spacing="1.3")
    body += '<path d="M54 640h196" stroke="#8a6a3c" stroke-width="3"/>'
    body += txt(54, 674, "ARM 微处理器体系结构 · ARM 指令集", 12.5, "#4a4638")
    body += txt(54, 698, "嵌入式操作系统：调度、同步与实时性", 12.5, "#4a4638")
    body += txt(548, 674, "3 CHAPTERS", 10.5, "#8a6a3c", 700, "end", MONO, spacing="1.2")
    body += txt(548, 698, "35 SECTIONS", 10.5, "#6f6a58", 700, "end", MONO, spacing="1.2")
    body += txt(52, 750, "北京航空航天大学 · 研究生课程定制教程", 10, "#6f6a58", spacing=".6")
    return (
        '<svg xmlns="http://www.w3.org/2000/svg" width="900" height="1200" viewBox="0 0 600 800">\n'
        + body
        + "\n</svg>\n"
    )


def main():
    OUT_MAIN.parent.mkdir(parents=True, exist_ok=True)
    OUT_MAIN.write_text(cover_main(), encoding="utf-8")
    print(f"{OUT_MAIN.relative_to(ROOT)}  {OUT_MAIN.stat().st_size/1024:.1f} KB")
    OUT_RHINE = (ROOT / "shared" / "theme" / "assets" / "rhine-arm-embed.svg").resolve()
    OUT_RHINE.parent.mkdir(parents=True, exist_ok=True)
    OUT_RHINE.write_text(cover_rhine(), encoding="utf-8")
    print(f"{OUT_RHINE.relative_to(ROOT)}  {OUT_RHINE.stat().st_size/1024:.1f} KB")


if __name__ == "__main__":
    main()
