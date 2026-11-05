#!/usr/bin/env python3
"""核对第5章正文中的教学假设算术；不验证引文、史实或理论结论。"""
from pathlib import Path
from decimal import Decimal as D
import re
import sys

BOOK = Path(__file__).resolve().parents[1] / 'src/part1/5.md'
text = BOOK.read_text(encoding='utf-8')
failed = []
count = 0


def section(n):
    match = re.search(rf'^## .*?1\.1\.{n}\b.*\n', text, re.M)
    if not match:
        # 标题按章号5.n的情况下仍明确定位，不能静默跳过。
        match = re.search(rf'^## .*?5\.{n}\b.*\n', text, re.M)
    if not match:
        raise ValueError(f'找不到第{n}节')
    rest = text[match.end():]
    return re.split(r'^## ', rest, maxsplit=1, flags=re.M)[0]


def row(block, label):
    for line in block.splitlines():
        cells = [c.strip() for c in line.strip().strip('|').split('|')]
        if line.startswith('|') and cells[0] == label:
            return cells[1:]
    raise ValueError(f'找不到表格行: {label}')


def number(s):
    return D(re.search(r'-?\d+(?:\.\d+)?', s.replace(',', '')).group())


def equal(label, result, displayed):
    global count
    count += 1
    value = number(displayed)
    ok = result == value
    print(f'{"PASS" if ok else "FAIL"} {label}: 计算 {result} / 正文 {value}')
    if not ok:
        failed.append(label)


# 从实际正文表格取输入和显示结果，独立复算而非比较重复常量。
a = section(1)
n, per, total = (row(a, key) for key in ('人数（人）','人均月产量（件）','月总产量（件）'))
for i in range(2):
    equal(f'1 作坊{i+1}月产量', number(n[i])*number(per[i]), total[i])

b = section(2)
wage = row(b, '月工资（元）')
price = row(b, '生活资料价格指数')
real = row(b, '实际工资指数（工资÷价格指数×100）')
for i in range(2):
    equal(f'2 实际工资指数{i+1}', number(wage[i])/number(price[i])*100, real[i])
for pattern, inputs in ((r'名义工资增长(\d+)%', wage), (r'产量增长(\d+)%', row(b,'月产量（件）'))):
    equal('2 增幅', (number(inputs[1])/number(inputs[0])-1)*100, re.search(pattern,b).group(1))

c = section(3)
amounts = {}
for label in ('营业额','外购投入','设备耗费','工资总额','扣上述项目后余额'):
    cells = row(c,label)
    amounts[label] = number(cells[-1])
    if '×' in cells[0]:
        left,right = cells[0].split('×')
        equal('3 '+label, number(left)*number(right), cells[-1])
equal('3 会计余额', amounts['营业额']-amounts['外购投入']-amounts['设备耗费']-amounts['工资总额'], str(amounts['扣上述项目后余额']))

d = section(4)
for i in range(2):
    equal('4 时段完整',number(row(d,'必要协同活动（小时）')[i])+number(row(d,'待安排部分（小时）')[i]),row(d,'总时长（小时）')[i])
equal('4 待安排时间份额',number(row(d,'待安排部分（小时）')[0])/number(row(d,'总时长（小时）')[0])*100,re.search(r'2÷8＝(\d+)%',d).group(1))

e = section(5)
activity = [row(e,key) for key in ('劳动','通勤','生活照料','自主安排')]
total_hours = sum(number(r[0]) for r in activity)
for key,r in zip(('劳动','通勤','生活照料','自主安排'),activity):
    equal('5 '+key+'时间份额',number(r[0])/total_hours*100,r[1])

f = section(6)
m = re.search(r'(\d+)名雇员，每人月工资均为(\d+)元，工资总额为(\d+)元',f)
equal('6 全员工资',D(m[1])*D(m[2]),m[3])

g = section(7)
v = {key:number(row(g,key)[0]) for key in ('期初资金','本期收入','中间投入支出','工资支出','留存余额','次期期初资金')}
equal('7 留存余额',v['本期收入']-v['中间投入支出']-v['工资支出'],str(v['留存余额']))
equal('7 次期期初资金',v['期初资金']+v['留存余额'],str(v['次期期初资金']))

h = section(8)
pay = row(h,'工资（元/月）')
equal('8 工资增幅',(number(pay[1])/number(pay[0])-1)*100,row(h,'工资增幅')[1])
m = re.search(r'(\d+)名劳动者每人领取(\d+)元，合计(\d+)元',h)
equal('8 同薪总额',D(m[1])*D(m[2]),m[3])
print(f'正文教学算术 {count} 项，失败 {len(failed)}。不认证史实、引文或理论。')
sys.exit(bool(failed))
