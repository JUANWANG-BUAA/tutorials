import glob
import os
import re
import subprocess
import sys
COLORS={'--fig-blue':'#2f6fa8','--fig-gold':'#b3801f','--fig-green':'#2e7d52','--fig-red':'#b3402f',
        '--fig-purple':'#6b4fa1','--fig-neutral':'#5b6470','--muted':'#6b7280','--line-strong':'#9aa1ab',
        '--line':'#c8cdd4','--ink':'#1f2937','--paper':'#ffffff','--think-line':'#967331','--think-bg':'#f7f3ea'}
def tint(var, pct):
    hexc = COLORS.get(var, '#888888').lstrip('#')
    r,g,b = (int(hexc[j:j+2],16) for j in (0,2,4))
    a = pct/100.0
    return '#%02x%02x%02x' % tuple(round(255 + (c-255)*a) for c in (r,g,b))
def flatten(src, prefix):
    text = open(src, encoding='utf-8').read()
    out=[]
    for i, sv in enumerate(re.findall(r'<svg\b.*?</svg>', text, re.S)):
        s = re.sub(r'color-mix\(in srgb,\s*var\((--[\w-]+)\)\s*(\d+)%,\s*(?:transparent|var\(--[\w-]+\))\s*\)',
                   lambda m: tint(m.group(1), int(m.group(2))), s if (s:=sv) else s)
        s = re.sub(r'color-mix\(in srgb,\s*var\((--[\w-]+)\)\s*\d+%,\s*var\(--[\w-]+\)\s*\)', '#f4f1ea', s)
        s = re.sub(r'var\((--[\w-]+)\)', lambda m: COLORS.get(m.group(1), '#333333'), s)
        if 'xmlns=' not in s:
            s = s.replace('<svg', '<svg xmlns="http://www.w3.org/2000/svg"', 1)
        s = s.replace('<svg', '<svg style="background:#ffffff"', 1)
        p = f'{prefix}{i}.svg'; png = f'{prefix}{i}.png'
        open(p,'w',encoding='utf-8').write(s)
        subprocess.run(['rsvg-convert','-w','900','-o',png,p],check=True)
        out.append(png)
    return out
import os
OUT = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".work", "figs"))
os.makedirs(OUT, exist_ok=True)
targets = sys.argv[1:] or sorted(
    glob.glob(os.path.join(os.path.dirname(OUT), "..", "src", "**", "*.md"), recursive=True))
for f in targets:
    pre = re.sub(r"[^a-z0-9]", "_", os.path.basename(f).replace(".md", ""))[:12]
    for path in flatten(f, os.path.join(OUT, pre)):
        print(path)
