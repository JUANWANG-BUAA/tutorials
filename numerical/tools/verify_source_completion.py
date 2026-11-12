#!/usr/bin/env python3
"""Recompute source additions from the current tutorial, including runnable code.

Covers selected formulas and examples, not a proof of every source statement.
Uses the same SymPy/mpmath dependencies as the existing numerical gates.
"""
from __future__ import annotations

import contextlib
import io
import math
import re

import mpmath as mp
import sympy as sp

import verify_recovery as recovery


def blocks(text: str) -> list[str]:
    return re.findall(r'```python\n(.*?)\n```', text, re.S)


def test_weighted_summary() -> None:
    text = recovery.read('lectures/lec14.md')
    assert r'\rho(x)\frac{\varphi_n(x)}{(x-x_k)' in text
    assert r'\varphi_n(x_k)\,' not in text
    x = sp.Symbol('x')
    phi2 = x*x-sp.Rational(3,5)
    for marker,integrand in [(r'(x^2,\varphi_2)=',x*x*phi2*x*x),
                             (r'(x^3,\varphi_2)=',x**3*phi2*x*x)]:
        line = next(line for line in text.splitlines() if line.startswith(marker))
        value = re.search(r'=(?:\\frac\{?(\d+)\}?\{(\d+)\}|(0))[,\.]',line)
        assert value, line
        printed = sp.Rational(value[1],value[2]) if value[1] else 0
        assert sp.integrate(integrand,(x,-1,1)) == printed
    overview = recovery.read('lectures/overview.md')
    denominator = int(re.search(r'余项 \$-\\frac\{h\^5\}\{(\d+)\}f\^\{\(4\)\}',overview)[1])
    exact = sp.integrate(x**4,(x,0,2))
    simpson = sp.Rational(1,3)*(4+16)
    assert exact-simpson == -sp.Rational(24,denominator)
    assert r'\varphi_2=x^2-\frac35' in overview


def test_simpson_hermite_kernel() -> None:
    text=recovery.section('lectures/lec13.md','{#lec13-S23}','### 7.4')
    assert r"P'(m)=f'(m)" in text
    assert r'(x-a)(x-m)^2(x-b)' in text
    assert r'(x-a)^2' not in text
    x,h=sp.symbols('x h',real=True)
    kernel=(x+h)*x*x*(x-h)
    assert sp.integrate(kernel,(x,-h,h))/24 == -h**5/90
    # Cubic interpolants with the same three values differ by an odd cubic.
    assert sp.integrate((x+h)*x*(x-h),(x,-h,h))==0
    # Extra precision is not true for arbitrary, asymmetric three-node rules.
    arbitrary=x*(x-sp.Rational(1,4))*(x-1)
    assert sp.integrate(arbitrary,(x,0,1)) != 0
    assert r'h=(b-a)/n' in recovery.section('lectures/lec13.md','**C2.**','**C3.**')


def test_rk3_general_order() -> None:
    text = recovery.section('course/ch07/sec71.md','{#method-rk3}','### 同一组节点')
    denominator,weight = map(int,re.search(r'\\tfrac h(\d+)\(k_1\+(\d+)k_2\+k_3\)',text).groups())
    assert r'y_n-hk_1+2hk_2' in text
    t,y,h = sp.symbols('t y h')
    f = t*t+t*y+y*y+1
    value = lambda dt,dy:f.subs({t:t+dt,y:y+dy}, simultaneous=True)
    k1=f; k2=value(h/2,h*k1/2); k3=value(h,-h*k1+2*h*k2)
    numerical=y+h*(k1+weight*k2+k3)/denominator
    derivative2=sp.diff(f,t)+sp.diff(f,y)*f
    derivative3=sp.diff(derivative2,t)+sp.diff(derivative2,y)*f
    exact=y+h*f+h*h*derivative2/2+h**3*derivative3/6
    assert sp.series(numerical-exact,h,0,4).removeO().expand() == 0
    z,beta=sp.symbols('z beta',real=True)
    r3=1+z*(1+weight*(1+z/2)+(1+z+z*z))/denominator
    assert sp.expand(r3)==1+z+z*z/2+z**3/6
    r4=1+z+z*z/2+z**3/6+z**4/24
    assert sp.expand(r4.subs(z,sp.I*beta)*r4.subs(z,-sp.I*beta)-1-beta**6*(beta**2-8)/576) == 0


def test_original_ode_table() -> None:
    text=recovery.section('course/ch07/sec71.md','{#ex-rk-slide-comparison}','<a id="sec-7.2.3">')
    rows=[line.strip('|').split('|') for line in text.splitlines() if re.match(r'\| [01]\.\d ',line)]
    assert len(rows)==11
    h=mp.mpf('0.1'); states=[mp.mpf(1)]*3
    f=lambda t,y:2*t*t+2*y
    for n,row in enumerate(rows):
        t=n*h
        values=[t,*states,mp.mpf('1.5')*mp.exp(2*t)-t*t-t-mp.mpf('.5')]
        for actual,printed in zip(values,row):recovery.close_to_printed(actual,printed)
        y=states[2];k1=f(t,y);k2=f(t+h/2,y+h*k1/2);k3=f(t+h/2,y+h*k2/2);k4=f(t+h,y+h*k3)
        heun1=f(t,states[1])
        states=[states[0]+h*f(t,states[0]),states[1]+h*(heun1+f(t+h,states[1]+h*heun1))/2,
                y+h*(k1+2*k2+2*k3+k4)/6]
    # Preserve the signed-error meaning in the older Euler comparison too.
    original=recovery.section('course/ch07/sec71.md','**Euler 法**：','**改进 Euler 法**：')
    for row in recovery.numeric_rows(original)[1:]:
        recovery.close_to_printed(mp.mpf(row[3])-mp.mpf(row[2]),row[4])


def test_adaptive_runnable_example() -> None:
    text=recovery.read('course/ch07/sec74.md')
    code=blocks(text)[0]; ns={}
    with contextlib.redirect_stdout(io.StringIO()):exec(compile(code,'tutorial-adaptive','exec'),ns)
    nodes,trials=ns['nodes'],ns['trials']
    assert trials[0][3] is False and trials[1][0]==trials[0][0]==0
    assert nodes[-1][0]==1 and all(0<=t<=1 for t,_ in nodes)
    assert all(nodes[i+1][0]>nodes[i][0] for i in range(len(nodes)-1))
    rows=[line.strip('|').split('|') for line in text.splitlines() if re.match(r'\| [01]\.\d{6} ',line)]
    assert len(rows)==len(trials)
    for actual,row in zip(trials,rows):
        for value,printed in zip(actual[:3],row[:3]):recovery.close_to_printed(value,printed)
        assert actual[3] == ('是' in row[3])
    recovery.close_to_printed(nodes[-1][1],re.search(r'y\(1\)\\approx([\d.]+)',text)[1])
    assert abs(nodes[-1][1]-math.e)<5e-6
    # A constant exact solution produces zero estimated error; endpoint is clipped.
    constant,_=ns['adaptive_rk4'](lambda t,y:0,0.,3.,.73,1.)
    assert constant[-1]==(.73,3.)
    z=sp.Symbol('z')
    r=lambda h:1+h+h*h/2+h**3/6+h**4/24
    fine=r(z/2)**2
    assert sp.series((fine-r(z))/15-(sp.exp(z)-fine),z,0,6).removeO()==0


def test_three_projection_examples() -> None:
    text=recovery.read('course/ch05/slide-examples.md');x=sp.Symbol('x',real=True)
    for start,end,fun,limit in [('slide-sine','slide-root',sp.sin(x),sp.pi/2),
                               ('slide-root','slide-arctan',sp.sqrt(1+x*x),sp.Integer(1))]:
        part=text[text.index('{#'+start+'}'):text.index('{#'+end+'}')]
        gram=sp.Matrix([[limit**3/3,limit**2/2],[limit**2/2,limit]])
        rhs=sp.Matrix([sp.integrate(x*fun,(x,0,limit)),sp.integrate(fun,(x,0,limit))])
        coeff=gram.inv()*rhs
        error=sp.integrate(fun*fun,(x,0,limit))-(coeff.T*rhs)[0]
        displays=re.findall(r'\\approx([0-9]+\.[0-9]+)',part)
        assert len(displays)>=3,displays
        for value,printed in zip([*coeff,error],[displays[0],displays[1],displays[-1]]):recovery.close_to_printed(value.evalf(70),printed)
        for power in [0,1]:assert sp.simplify(sp.integrate((fun-coeff[0]*x-coeff[1])*x**power,(x,0,limit)))==0
    part=text[text.index('{#slide-arctan}'):text.index('{#slide-ladle}')]
    b,a=re.search(r'p\(x\)\\approx([\d.]+)\+([\d.]+)x',part).groups()
    i0=mp.quad(mp.atan,[0,1]);i1=mp.quad(lambda x:x*mp.atan(x),[0,1])
    recovery.close_to_printed(4*i0-6*i1,b);recovery.close_to_printed(12*i1-6*i0,a)


def test_ladle_data_and_objectives() -> None:
    text=recovery.read('course/ch05/slide-examples.md');ns={}
    with contextlib.redirect_stdout(io.StringIO()):exec(compile(blocks(text)[0],'tutorial-ladle','exec'),ns)
    # The source's second reading must not silently become 8.20.
    assert ns['volumes']==[6.42,5.20,9.58,9.50,9.70,10.00,9.93,9.99,10.49,10.59,10.60,10.80,10.60,10.90,10.76]
    displays=re.search(r'输出为 `a=([\d.]+), b=([\d.]+), 原容积残差平方和=([\d.]+)`',text).groups()
    k=[mp.mpf(n) for n in ns['k']];v=[mp.mpf(str(n)) for n in ns['volumes']]
    design=mp.matrix([[1,1/n] for n in k]);rhs=mp.matrix([1/n for n in v])
    coeff=mp.lu_solve(design.T*design,design.T*rhs)
    sse=sum((vi-ki/(coeff[0]*ki+coeff[1]))**2 for ki,vi in zip(k,v))
    for value,printed in zip([*coeff,sse],displays):recovery.close_to_printed(value,printed)
    # Independently solve stationary equations in the original volume units.
    def gradient(a,b):
        d=[a*ki+b for ki in k];r=[ki/di-vi for ki,di,vi in zip(k,d,v)]
        return (sum(ri*ki*ki/di**2 for ri,ki,di in zip(r,k,d)),sum(ri*ki/di**2 for ri,ki,di in zip(r,k,d)))
    a,b=mp.findroot(gradient,tuple(coeff))
    original=sum((vi-ki/(a*ki+b))**2 for ki,vi in zip(k,v))
    assert original<sse
    for value,printed in zip([a,b,original],re.search(r'a\\approx([\d.]+)\$、\$b\\approx([\d.]+)\$，原容积残差平方和约为 ([\d.]+)',text).groups()):
        recovery.close_to_printed(value,printed)


def test_euler_initial_error_bound() -> None:
    text=recovery.section('course/ch07/sec71.md','{#euler-initial-stability}','::: thm 定理 7.2')
    assert r'\frac{Mh}{2L}' in text and r'|u_n-v_n|\le e^{L(T-t_0)}|u_0-v_0|' in text
    # y'=sin(y) is nonlinear and globally Lipschitz with L=1, |y''|<=1/2.
    exact0=mp.mpf('.3');initial=mp.mpf('.31')
    for count in [4,8,16,32]:
        h=mp.mpf(1)/count;y=initial;u=exact0
        for n in range(1,count+1):
            y+=h*mp.sin(y);u+=h*mp.sin(u);t=n*h
            exact=2*mp.atan(mp.exp(t)*mp.tan(exact0/2))
            bound=mp.exp(t)*abs(initial-exact0)+h*(mp.exp(t)-1)/4
            assert abs(exact-y)<=bound
            assert abs(y-u)<=mp.exp(t)*abs(initial-exact0)


def test_polynomials_and_pair() -> None:
    x=sp.Symbol('x')
    lag=lambda n:sp.expand(sp.exp(x)*sp.diff(x**n*sp.exp(-x),x,n))
    herm=lambda n:sp.expand((-1)**n*sp.exp(x*x)*sp.diff(sp.exp(-x*x),x,n))
    text=recovery.read('course/ch05/sec55.md')
    assert r'U_{n+1}&=(2n+1-x)U_n-n^2U_{n-1}' in text
    assert r'H_{n+1}&=2xH_n-2nH_{n-1}' in text
    for n in range(1,6):
        assert sp.expand(lag(n+1)-(2*n+1-x)*lag(n)+n*n*lag(n-1))==0
        assert sp.expand(herm(n+1)-2*x*herm(n)+2*n*herm(n-1))==0
    text=recovery.section('course/ch03/sec31.md','{#ex-power-conjugate-pair}','若模最大的是实根')
    a=recovery.matrix_after(text,'A=');u0=sp.Matrix([1,0]);u1=a*u0;u2=a*u1
    p,q=sp.Matrix.hstack(u1,u0).inv()*(-u2)
    assert (p,q)==(-2,5)
    assert set(a.eigenvals())=={1-2*sp.I,1+2*sp.I}


if __name__=='__main__':
    checks=[test_weighted_summary,test_simpson_hermite_kernel,test_rk3_general_order,test_original_ode_table,
            test_adaptive_runnable_example,test_three_projection_examples,
            test_ladle_data_and_objectives,test_euler_initial_error_bound,test_polynomials_and_pair]
    for check in checks:
        check();print(f'PASS {check.__name__}')
    print(f'Source completion checks passed: {len(checks)} groups, {recovery.checked_values} published values.')
