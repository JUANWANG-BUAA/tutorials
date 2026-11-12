#!/usr/bin/env python3
"""Check note attribution links and recompute this audit's added examples."""
from pathlib import Path
import json
import re
import math
from fractions import Fraction as Q

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / 'src'
notes = json.loads((ROOT / 'tools/classroom_notes.json').read_text())
assert len(notes) == len({n['id'] for n in notes}) == 24
for n in notes:
    body = (SRC / n['file']).read_text()
    marker = '<a id="' + n['id'] + '"></a>'
    assert body.count(marker) == 1
    section = body.split(marker, 1)[1].split('\n:::\n', 1)[0]
    assert n['title'] in section
    if n['evidence'] == 'edited-notes':
        assert '据整理稿' in section and not n['time']
    else:
        assert n['lecture'] in [6, 8, 9, 10, 11, 12, 13, 14, 15]
        target = SRC / f"lectures/lec{n['lecture']:02}.md"
        assert '{#' + n['source_anchor'] + '}' in target.read_text()
        assert '#' + n['source_anchor'] + ')' in section
        assert n['time'] in section
    # No invented literal quotations in the authored annotations.
    assert '原话' not in section

# Recompute projection coefficients and residual moments with exact rationals.
# Polynomial coefficient arrays are in increasing powers.
polys = [[Q(1)], [Q(-1,2), 0, Q(3,2)],
         [Q(3,8), 0, Q(-30,8), 0, Q(35,8)]]
coeffs = [Q(1,2), Q(5,8), Q(-3,16)]
for degree, poly, c in zip([0,2,4], polys, coeffs):
    assert (2*degree+1)*sum((Q(v, i+2) for i,v in enumerate(poly)), Q(0)) == c
p = [Q(15,128), 0, Q(105,64), 0, Q(-105,128)]
for k in [0,2,4]:
    assert 2*Q(1,k+2) - sum((2*Q(v,i+k+1) for i,v in enumerate(p) if (i+k)%2==0),Q(0)) == 0
assert Q(2,3) - sum(c*c*Q(2,2*d+1) for c,d in zip(coeffs,[0,2,4])) == Q(1,384)
text = (SRC/'course/ch05/slide-examples.md').read_text().split('{#slide-absolute-value}',1)[1]
for formula in [r'c_0=\frac12', r'\frac58', r'-\frac3{16}', r'\frac1{384}',r'\frac{15}{128}+\frac{105}{64}x^2-\frac{105}{128}x^4']:
    assert formula in text

# Validate the published root values and convergence intervals.
text = (SRC/'course/ch04/sec41.md').read_text().split('{#slide-fixed-point-examples}',1)[1]
for value in ['3.9813393709','-1.7490313860','2.2986433671']:
    assert value in text
    x = float(value)
    residual = x+math.exp(-x)-4 if value != '2.2986433671' else 10-5*x+2*math.sin(x)
    assert abs(residual)<2e-9
assert 3 <= 4-math.exp(-3) <= 4-math.exp(-4) <= 4
assert -2 <= -math.log(6) <= -math.log(5) <= -1
x=0
for _ in range(30): x=math.sqrt(2+x)
assert abs(x-2)<1e-15

# Perturb only u_1. Compare the closed form against exact recurrence arithmetic.
e0,e1=Q(0),Q(1,10**16)
for n in range(1,55):
    closed=Q(2,3)*Q(1,10**16)*(Q(2)**n-Q(2)**(-n))
    assert e1==closed
    e0,e1=e1,Q(5,2)*e1-e0
text=(SRC/'course/ch07/sec71.md').read_text()
assert r'e_n=\frac{2\delta}{3}\left(2^n-2^{-n}\right)' in text
print('PASS: 24 note sources; exact projection; three fixed-point cases; perturbed recurrence')
