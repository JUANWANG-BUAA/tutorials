#!/usr/bin/env python3
"""Recompute audited slide examples using data read from current prose."""
from decimal import Decimal, ROUND_HALF_UP, localcontext
from fractions import Fraction as Q
import re

import mpmath as mp
import sympy as sp

import verify_recovery as r


def part(file, anchor):
    return r.section(file, '{#'+anchor+'}').split('\n:::', 1)[0]


def rational(cell):
    cell = cell.strip().strip('$').replace('−', '-')
    return Q(cell)


def rows(text):
    return [[c.strip() for c in line.strip('|').split('|')]
            for line in text.splitlines() if re.match(r'\| [−-]?\d', line)]


def check_divided_differences():
    text = part('course/ch05/sec51.md', 'slide-log-divided-differences')
    table = rows(text)
    assert len(table) == 5
    nodes = [rational(row[0]) for row in table]
    values = [rational(row[1]) for row in table]
    assert nodes == list(map(Q, ['2.2','2.4','2.6','2.8','3']))
    assert values == list(map(Q, ['.78846','.87547','.95551','1.02962','1.09861']))
    cols = [values]
    for k in range(1, 5):
        cols.append([(cols[-1][i+1]-cols[-1][i])/(nodes[i+k]-nodes[i])
                     for i in range(5-k)])
        for i, value in enumerate(cols[k]):
            assert rational(table[i+k][k+1]) == value
    x = sp.Symbol('x')
    polynomial = sum(sp.Rational(col[0].numerator,col[0].denominator)*
                     sp.prod(x-sp.Rational(t.numerator,t.denominator) for t in nodes[:k])
                     for k,col in enumerate(cols))
    for node, value in zip(nodes, values):
        assert polynomial.subs(x,sp.Rational(node.numerator,node.denominator)) == sp.Rational(value.numerator,value.denominator)
    assert r'-\frac{23}{3840}(x-2.20)' in text
    # Away from the symmetric midpoint, swapping left/right error is detectable.
    for point in [Q(1,2),Q(3,2),Q(5,2)]:
        left=sp.interpolate([(0,0),(1,1),(2,8)],x)
        right=sp.interpolate([(1,1),(2,8),(3,27)],x)
        z=sp.Rational(point.numerator,point.denominator)
        difference=(left-right).subs(x,z)
        assert z**3-left.subs(x,z) == z/(0-3)*difference
        assert z**3-right.subs(x,z) == (z-3)/(0-3)*difference


def check_gauss_examples():
    text = part('course/ch06/sec67.md','ex-6.7.2')
    assert r'\sqrt{x+1.5}' in text
    displays=re.findall(r'\\approx([\d.]+)',text)
    simpson=(mp.sqrt(mp.mpf('.5'))+4*mp.sqrt(mp.mpf('1.5'))+mp.sqrt(mp.mpf('2.5')))/3
    nodes, weights=mp.gauss_quadrature(3,'legendre')
    gauss=mp.fdot(weights,[mp.sqrt(mp.mpf('1.5')+t) for t in nodes])
    exact=mp.mpf(2)/3*(mp.mpf('2.5')**mp.mpf('1.5')-mp.mpf('.5')**mp.mpf('1.5'))
    assert len(displays)>=3
    for actual,shown in zip([simpson,gauss,exact],displays[:3]):r.close_to_printed(actual,shown)
    text=part('course/ch06/sec67.md','slide-gauss-unit-interval')
    nodes,weights=mp.gauss_quadrature(4,'legendre')
    table=rows(text);assert len(table)==4
    for t,w,row in zip(nodes,weights,table):
        for actual,shown in zip([t,w,(1+t)/2,w/2],row):
            r.close_to_printed(actual,shown.replace('−','-'))
    mapped=[(1+t)/2 for t in nodes]; mapped_weights=[w/2 for w in weights]
    for degree in range(8):
        assert mp.almosteq(mp.fdot(mapped_weights,[x**degree for x in mapped]),mp.mpf(1)/(degree+1))
    assert abs(mp.fdot(mapped_weights,[x**8 for x in mapped])-mp.mpf(1)/9)>mp.mpf('1e-6')
    text=part('course/ch06/sec67.md','slide-gauss-log-two')
    table=rows(text);assert len(table)==4
    for row in table:
        n=int(row[0]);t,w=mp.gauss_quadrature(n,'legendre')
        value=mp.fdot(w,[1/(3+z) for z in t])
        r.close_to_printed(value,row[1]);r.close_to_printed(mp.log(2)-value,row[2])
        assert value<mp.log(2)
    # The separate exp(1/x) example retains its own data and accurate rounding.
    text=part('course/ch06/sec67.md','ex-6.7.3')
    table=[line.strip('|').split('|') for line in text.splitlines() if re.match(r'\| \$-?\d',line)]
    assert len(table)==4
    for t,row in zip(nodes,table):r.close_to_printed(mp.exp(2/(t+3)),row[1])
    value=mp.fdot(weights,[mp.exp(2/(t+3)) for t in nodes])/2
    shown=re.search(r'\\approx(2\.020\d+)',text)[1]
    r.close_to_printed(value,shown)


def augmented(text):
    arrays=re.findall(r'\\begin\{array\}\{ccc\|r\}(.*?)\\end\{array\}',text,re.S)
    return [sp.Matrix([[sp.Rational(c) for c in row.split('&')]
                       for row in a.split(r'\\')]) for a in arrays]


def symbolic_matrix(text, marker):
    tail=text[text.index(marker):]
    body=re.search(r'\\begin\{pmatrix\}(.*?)\\end\{pmatrix\}',tail,re.S)[1]
    return sp.Matrix([[sp.sympify(c.replace('ab','a*b'),locals={"a":sp.Symbol("a",real=True),"b":sp.Symbol("b",real=True)})
                       for c in row.split('&')] for row in body.split(r'\\')])


def check_linear_examples():
    text=part('course/ch02/sec21.md','slide-gauss-sequential')
    a=sp.Matrix([[1,-2,2],[2,-3,-3],[4,1,6]]);b=sp.Matrix([-2,4,3])
    work=a.row_join(b)
    work[1,:]=work[1,:]-2*work[0,:];work[2,:]=work[2,:]-4*work[0,:]
    first,second=augmented(text);assert work==first
    work[2,:]=work[2,:]-9*work[1,:];assert work==second
    assert a*sp.Matrix([2,1,-1])==b
    text=part('course/ch02/sec21.md','slide-gauss-partial-pivot')
    a=sp.Matrix([[1,0,1],[2,-1,0],[-1,2,1]]);b=sp.Matrix([4,-2,-4]);work=a.row_join(b)
    first,second=augmented(text)
    work.row_swap(0,1);work[1,:]=work[1,:]-work[0,:]/2;work[2,:]=work[2,:]+work[0,:]/2
    assert work==first
    work.row_swap(1,2);work[2,:]=work[2,:]-work[1,:]/3;assert work==second
    assert a*sp.Matrix([-6,-10,10])==b
    text=part('course/ch02/sec22.md','ex-2.2.2')
    L=r.matrix_after(text,'$$L=');U=r.matrix_after(text,'U=')
    a=sp.Matrix([[1,2,3],[2,5,2],[3,1,5]]);b=sp.Matrix([14,18,20])
    assert L*U==a and L*sp.Matrix([14,-10,-72])==b
    assert U*sp.Matrix([1,2,3])==sp.Matrix([14,-10,-72])
    assert r'14,18,20' in text and r'(1,2,3)' in text
    text=part('course/ch02/sec24b.md','slide-jacobi-three-variable')
    triples=re.findall(r'\\boldsymbol x\^\{\((\d)\)\}=\(([^)]+)\)',text)
    assert len(triples)==3
    a=sp.Matrix([[8,-3,2],[4,11,-1],[6,3,12]]);d=sp.diag(8,11,12);b=sp.Matrix([20,33,36]);v=sp.zeros(3,1)
    for k,printed in triples:
        v=v+d.inv()*(b-a*v)
        assert list(v)==[sp.Rational(t) for t in printed.split(',')]
    assert a*sp.Matrix([3,2,1])==b
    text=part('course/ch02/sec24b.md','slide-jacobi-parameter')
    a,lam=sp.symbols('a lambda',real=True)
    g=symbolic_matrix(text,'G_J=')
    assert sp.expand((lam*sp.eye(3)-g).det()-lam*(lam**2-2*a**2))==0
    assert r'|a|<\frac1{\sqrt2}' in text
    text=part('course/ch02/sec24b.md','slide-jacobi-gs-two-variable')
    b=sp.Symbol('b',real=True)
    gj=symbolic_matrix(text,'G_J=');gs=symbolic_matrix(text,'G_{GS}=')
    assert sp.expand((lam*sp.eye(2)-gj).det()-lam**2-a*b/9)==0
    assert sp.expand((lam*sp.eye(2)-gs).det()-lam*(lam+a*b/9))==0
    assert '|ab|<9' in text
    text=part('course/ch03/sec31.md','ex-3.0.1')
    a=r.matrix_after(text,'A=')
    assert set(a.eigenvals())=={1,2,4}
    for value,vector in [(1,[1,-1,1]),(2,[1,0,-1]),(4,[1,2,1])]:
        assert a*sp.Matrix(vector)==value*sp.Matrix(vector)
    text=part('course/ch02/sec24.md','slide-richardson-parameter')
    assert r'0<\omega<\frac12' in text
    a=sp.Matrix([[3,1],[1,3]])
    assert set(a.eigenvals())=={2,4}
    assert a*sp.Matrix([sp.Rational(1,8),sp.Rational(5,8)])==sp.Matrix([1,2])


def check_rounding_and_review():
    text=part('course/ch02/sec23.md','ex-2.3-textbook5')
    a=r.matrix_after(text,'A=');b=sp.Matrix([sp.Rational('.1440'),sp.Rational('.8642')])
    inverse=r.matrix_after(text,'A^{-1}=')
    assert a*inverse==sp.eye(2) and a.inv()*b==sp.Matrix([2,-2])
    norm=lambda mat:max(sum(abs(x) for x in mat.row(i)) for i in range(mat.rows))
    printed=int(re.search(r'条件数为 \$(\d+)',text)[1]);assert norm(a)*norm(inverse)==printed
    with localcontext() as ctx:
        ctx.prec=8;ctx.rounding=ROUND_HALF_UP
        D=Decimal;m=D('.2161')/D('1.2969')
        u=D('.1441')-m*D('.8648');v=D('.1440')-m*D('.8642')
        x2=v/u;x1=(D('.8642')-D('.8648')*x2)/D('1.2969')
        assert (x1,x2)==(D('1.3331791'),D('-1'))
        assert max(abs(x1-2),abs(x2+2))/2==D('.5')
    text=r.read('course/ch02/recall-cards.md')
    assert r'G_J=-D^{-1}(L+U)=I-D^{-1}A' in text
    assert r'\omega=1$ 在区间内' in text and '降低数据精度' not in text
    # A zero determinant of G does not make I-G singular.
    a=sp.Matrix([[4,-1],[-1,3]]);d=sp.diag(4,3);l=sp.Matrix([[0,0],[-1,0]]);u=l.T
    gs=-(d+l).inv()*u
    assert gs.det()==0 and (sp.eye(2)-gs).det()!=0
    assert max(abs(t) for t in gs.eigenvals())<1
    text=r.read('course/ch02/mock-exam.md')
    assert '顺序消元第一步零主元' in text and '每题 10 分，共 20 分' in text
    assert '参考解答' in text and '只凭两个绝对数字' not in text
    assert sp.Matrix([[0,2,1],[2,2,3],[4,6,5]])*sp.Matrix([sp.Rational(1,2),1,0])==sp.Matrix([2,3,8])
    # Small absolute residual/large absolute error can coexist with cond=1.
    a=sp.eye(2)/10**9;error=sp.Matrix([sp.Rational(1,1000),0])
    assert norm(a)*norm(a.inv())==1 and max(abs(v) for v in a*error)==sp.Rational(1,10**12)


def check_newton():
    text=part('course/ch04/sec41b.md','slide-newton-exponential')
    table=rows(text);assert len(table)==5
    x=mp.mpf('.5')
    for k,row in enumerate(table):
        assert int(row[0])==k;r.close_to_printed(x,row[1])
        x=x-(x-mp.exp(-x))/(1+x)
    text=r.read('course/ch04/sec41b.md')
    assert r'\frac{-1.384}{0.08}=17.9' in text
    x=Q(3,5);f=x**3-x-1;derivative=3*x*x-1
    assert f==Q('-1.384') and derivative==Q('.08') and x-f/derivative==Q('17.9')


if __name__=='__main__':
    for check in [check_divided_differences,check_gauss_examples,check_linear_examples,
                  check_rounding_and_review,check_newton]:
        check();print('PASS:',check.__name__)
    print(f'PASS: source examples; {r.checked_values} printed values recomputed')
