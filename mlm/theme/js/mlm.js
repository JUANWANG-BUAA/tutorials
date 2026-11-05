/**
 * mlm.js — 《马克思主义原理》本书脚本
 *
 * 共用附加操作（进度条 / 页内目录 / 解答工具条 / 返回教程库 / 宽公式提示）
 * 由 theme/js/page-extras.js 提供，这里只 boot 配置。
 * 本书专属：回到顶部、表格增强、引用增强、各类教学演示。
 */

(function() {
  'use strict';

  // ========================================================================
  // §1 回到顶部按钮
  // ========================================================================
  function setupBackToTop() {
    const btn = document.createElement('button');
    btn.id = 'back-to-top';
    btn.innerHTML = '↑';
    btn.setAttribute('aria-label', '回到顶部');
    btn.title = '回到顶部';
    document.body.appendChild(btn);

    let ticking = false;
    const onScroll = () => {
      if (!ticking) {
        window.requestAnimationFrame(() => {
          const shouldShow = window.scrollY > window.innerHeight * 1.2;
          btn.classList.toggle('visible', shouldShow);
          ticking = false;
        });
        ticking = true;
      }
    };

    window.addEventListener('scroll', onScroll, { passive: true });
    btn.addEventListener('click', () => {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
  }

  // ========================================================================
  // §3 表格响应式增强
  // ========================================================================
  function enhanceTables() {
    const tables = document.querySelectorAll('.content table');
    tables.forEach(table => {
      // 为超宽表格添加滚动容器
      if (table.scrollWidth > table.clientWidth) {
        const wrapper = document.createElement('div');
        wrapper.style.overflowX = 'auto';
        wrapper.style.webkitOverflowScrolling = 'touch';
        table.parentNode.insertBefore(wrapper, table);
        wrapper.appendChild(table);
      }
    });
  }

  // ========================================================================
  // §5 引用标注增强（为 blockquote.cite 添加交互）
  // ========================================================================
  function enhanceCitations() {
    const cites = document.querySelectorAll('blockquote.cite');
    cites.forEach(cite => {
      // 为引文添加可访问性标注
      if (!cite.hasAttribute('role')) {
        cite.setAttribute('role', 'blockquote');
      }
    });
  }

  // ========================================================================
  // §6 初始化
  // ========================================================================
  function setupWageDemo() {
    document.querySelectorAll('[data-mlm-wage-demo]').forEach(root => {
      if (root.dataset.initialized) return;
      const wage = root.querySelector('[data-wage]');
      const price = root.querySelector('[data-price]');
      const control = root.querySelector('[data-control]');
      const result = root.querySelector('[data-result]');
      const reset = root.querySelector('[data-reset]');
      if (!wage || !price || !control || !result || !reset) return;
      const update = () => {
        const amount = Number(wage.value);
        const index = Number(price.value);
        if (!Number.isFinite(amount) || !Number.isFinite(index) || index <= 0) return;
        const real = amount / index * 100;
        root.querySelector('[data-wage-label]').textContent = String(amount);
        root.querySelector('[data-price-label]').textContent = String(index);
        const comparison = real > 100 ? '购买力高于基期' : real < 100 ? '购买力低于基期' : '购买力与基期相同';
        const relation = control.value === 'shared' ? '产品处置由生产者共同决定；其他劳动关系仍需另查。' : '产品处置仍由外部控制者决定。';
        result.textContent = `实际工资指数${real.toFixed(1)}；${comparison}。${relation}`;
      };
      wage.addEventListener('input', update);
      price.addEventListener('input', update);
      control.addEventListener('change', update);
      reset.addEventListener('click', () => {
        wage.value = '120';
        price.value = '120';
        control.value = 'external';
        update();
      });
      root.dataset.initialized = 'true';
      update();
    });
  }

  function setupFlowDemo() {
    document.querySelectorAll('[data-mlm-flow-demo]').forEach(root => {
      if (root.dataset.initialized) return;
      const flow = root.querySelector('[data-flow]');
      const error = root.querySelector('[data-error]');
      const result = root.querySelector('[data-flow-result]');
      const reset = root.querySelector('[data-flow-reset]');
      if (!flow || !error || !result || !reset) return;
      const update = () => {
        const value = Number(flow.value);
        const bound = Number(error.value);
        if (!Number.isFinite(value) || !Number.isFinite(bound) || bound < 0) return;
        const low = value - bound;
        const high = value + bound;
        root.querySelector('[data-flow-label]').textContent = String(value);
        root.querySelector('[data-error-label]').textContent = String(bound);
        const judgment = low <= 10 && high >= 10
          ? '包含预测10升/分；相容不能单独证明解释，仍须比较替代原因。'
          : '不包含预测10升/分；应复查命题、条件和测量。';
        result.textContent = `测量区间${low.toFixed(1)}–${high.toFixed(1)}升/分，${judgment}`;
      };
      flow.addEventListener('input', update);
      error.addEventListener('input', update);
      reset.addEventListener('click', () => {
        flow.value = '8';
        error.value = '0.5';
        update();
      });
      root.dataset.initialized = 'true';
      update();
    });
  }

  function setupCompositionDemo() {
    document.querySelectorAll('[data-mlm-composition-demo]').forEach(root => {
      if (root.dataset.initialized) return;
      const count = root.querySelector('[data-composition-count]');
      const label = root.querySelector('[data-composition-label]');
      const result = root.querySelector('[data-composition-result]');
      const bar = root.querySelector('[data-composition-bar]');
      const barLabel = root.querySelector('[data-composition-bar-label]');
      const reset = root.querySelector('[data-composition-reset]');
      if (!count || !label || !result || !bar || !barLabel || !reset) return;
      const update = () => {
        const groupA = Number(count.value);
        if (!Number.isInteger(groupA) || groupA < 0 || groupA > 100 || groupA % 4 !== 0) return;
        const groupB = 100 - groupA;
        const supportA = groupA / 4;
        const supportB = groupB * 3 / 4;
        const overall = supportA + supportB;
        const difference = overall - 35;
        label.textContent = String(groupA);
        bar.setAttribute('width', String(overall * 1.9));
        barLabel.textContent = `${overall}%`;
        result.textContent = `第二期甲${groupA}人，其中支持${supportA}人；乙${groupB}人，其中支持${supportB}人。总体支持率${overall}%，较第一期${difference >= 0 ? '增加' : '减少'}${Math.abs(difference)}个百分点；固定第一期80/20权重仍为35%。`;
      };
      count.addEventListener('input', update);
      reset.addEventListener('click', () => {
        count.value = '20';
        update();
      });
      root.dataset.initialized = 'true';
      update();
    });
  }

  function setupConditionDemo() {
    document.querySelectorAll('[data-mlm-condition-demo]').forEach(root => {
      if (root.dataset.initialized) return;
      const rule = root.querySelector('[data-condition-rule]');
      const evidence = root.querySelector('[data-condition-evidence]');
      const outcome = root.querySelector('[data-condition-outcome]');
      const definition = root.querySelector('[data-condition-definition]');
      const result = root.querySelector('[data-condition-result]');
      const reset = root.querySelector('[data-condition-reset]');
      if (!rule || !evidence || !outcome || !definition || !result || !reset) return;
      const update = () => {
        if (!['old', 'new'].includes(rule.value)
            || !['unmet', 'met', 'unknown'].includes(evidence.value)
            || !['occurred', 'absent'].includes(outcome.value)) return;
        definition.textContent = rule.value === 'old'
          ? '本项练习：“该社会形态灭亡”要求“它所能容纳的全部生产力已发挥”。'
          : '本项练习：“新的更高生产关系出现”要求“它的物质存在条件已在旧社会内部成熟”。';
        const occurred = outcome.value === 'occurred';
        if (evidence.value === 'unknown') {
          result.dataset.verdict = 'undetermined';
          result.textContent = occurred
            ? '条件资料不足、结果已发生：不能凭现有资料判为反例，也不能据此确证命题。若接受必要条件命题，逻辑上要求条件成立；检验命题时仍须独立查条件，不可用结果循环证明。'
            : '条件资料不足、结果尚未发生：不能据此推断条件未满足，也不能判定命题已获证；仍需独立条件材料。';
        } else if (evidence.value === 'unmet' && occurred) {
          result.dataset.verdict = 'incompatible';
          result.textContent = '条件未满足、结果已发生：与所练必要条件命题不相容。应核查事实、条件认定及命题本身，不能把结果直接当作条件早已成立的独立证据。';
        } else {
          result.dataset.verdict = 'compatible';
          if (evidence.value === 'met' && !occurred) {
            result.textContent = '条件已满足、结果尚未发生：与必要条件命题相容。条件成立没有给出充分条件或发生日期，不能由尚未发生倒推条件未满足。';
          } else if (occurred) {
            result.textContent = '条件已满足、结果已发生：与必要条件命题相容；个案相容不能单独确证一般历史命题。';
          } else {
            result.textContent = '条件未满足、结果尚未发生：与必要条件命题相容；相容不等于已证明这条历史命题。';
          }
        }
      };
      [rule, evidence, outcome].forEach(control => control.addEventListener('change', update));
      reset.addEventListener('click', () => {
        rule.value = 'new';
        evidence.value = 'unmet';
        outcome.value = 'absent';
        update();
      });
      root.dataset.initialized = 'true';
      update();
    });
  }

  function setupOutsourceDemo() {
    document.querySelectorAll('[data-mlm-outsource-demo]').forEach(root => {
      if (root.dataset.initialized) return;
      const controls = root.querySelector('[data-outsource-controls]');
      const plant = root.querySelector('[data-outsource-plant]');
      const out = root.querySelector('[data-outsource-out]');
      const qty = root.querySelector('[data-outsource-q]');
      const prior = root.querySelector('[data-outsource-prior]');
      const plantLabel = root.querySelector('[data-outsource-plant-label]');
      const outLabel = root.querySelector('[data-outsource-out-label]');
      const qtyLabel = root.querySelector('[data-outsource-q-label]');
      const priorLabel = root.querySelector('[data-outsource-prior-label]');
      const result = root.querySelector('[data-outsource-result]');
      const reset = root.querySelector('[data-outsource-reset]');
      const barA = root.querySelector('[data-outsource-bar-a]');
      const barB = root.querySelector('[data-outsource-bar-b]');
      const textA = root.querySelector('[data-outsource-text-a]');
      const textB = root.querySelector('[data-outsource-text-b]');
      if (!controls || !plant || !out || !qty || !prior || !result || !reset
          || !plantLabel || !outLabel || !qtyLabel || !priorLabel
          || !barA || !barB || !textA || !textB) return;
      const fmt = value => {
        const n = Number(value);
        return Number.isInteger(n) ? String(n) : n.toFixed(2).replace(/0+$/, '').replace(/\.$/, '');
      };
      const update = () => {
        const ha = Number(plant.value);
        const ho = Number(out.value);
        const q = Number(qty.value);
        const prev = Number(prior.value);
        if (![ha, ho, q, prev].every(Number.isFinite)
            || ha < 200 || ha > 1200 || ha % 50 !== 0
            || ho < 0 || ho > 800 || ho % 50 !== 0
            || q < 400 || q > 2000 || q % 50 !== 0
            || prev < 0 || prev > 3) {
          result.textContent = '请使用给定范围：厂内人时200–1200（步长50）、外包0–800（步长50）、合格品400–2000（步长50）、上期同口径B为0–3（0表示无上期）。';
          return;
        }
        const hb = ha + ho;
        const qa = ha > 0 ? q / ha : NaN;
        const qb = hb > 0 ? q / hb : NaN;
        const maxQ = 3;
        barA.setAttribute('width', String(Math.min(qa, maxQ) / maxQ * 300));
        barB.setAttribute('width', String(Math.min(qb, maxQ) / maxQ * 300));
        textA.textContent = `口径A（厂内）：q=${fmt(qa)} 件/人时`;
        textB.textContent = `口径B（完整）：q=${fmt(qb)} 件/人时`;
        plantLabel.textContent = fmt(ha);
        outLabel.textContent = fmt(ho);
        qtyLabel.textContent = fmt(q);
        priorLabel.textContent = prev === 0 ? '无' : fmt(prev);
        let verdict = `厂内H=${fmt(ha)}，外包=${fmt(ho)}，完整H=${fmt(hb)}；Q=${fmt(q)}。A口径q=${fmt(qa)}，B口径q=${fmt(qb)}。差来自边界，不自动等于欺骗。`;
        if (prev === 0) {
          verdict += ' 题面无上期同口径B，不能谈「提高」或「跃升已证实」。';
        } else if (qb > prev) {
          verdict += ` 相对上期同口径B=${fmt(prev)}，本期B更高，可支持该口径下提高；仍不能单凭A的q声称全流程跃升。`;
        } else if (qb === prev) {
          verdict += ` 相对上期同口径B=${fmt(prev)}，本期B持平。`;
        } else {
          verdict += ` 相对上期同口径B=${fmt(prev)}，本期B更低。`;
        }
        result.textContent = verdict;
      };
      [plant, out, qty, prior].forEach(control => control.addEventListener('input', update));
      reset.addEventListener('click', () => {
        plant.value = '600';
        out.value = '400';
        qty.value = '1200';
        prior.value = '0';
        update();
      });
      root.querySelectorAll('[data-outsource-preset]').forEach(button => {
        button.addEventListener('click', () => {
          const map = {
            base: [600, 400, 1200, 0],
            prior: [600, 400, 1200, 1],
            plantonly: [600, 0, 1200, 0]
          };
          const values = map[button.dataset.outsourcePreset];
          if (!values) return;
          plant.value = String(values[0]);
          out.value = String(values[1]);
          qty.value = String(values[2]);
          prior.value = String(values[3]);
          update();
        });
      });
      root.dataset.initialized = 'true';
      update();
      controls.hidden = false;
    });
  }

  function setupInvestBalanceDemo() {
    document.querySelectorAll('[data-mlm-invest-demo]').forEach(root => {
      if (root.dataset.initialized) return;
      const controls = root.querySelector('[data-invest-controls]');
      const income = root.querySelector('[data-invest-income]');
      const duty = root.querySelector('[data-invest-duty]');
      const min = root.querySelector('[data-invest-min]');
      const locked = root.querySelector('[data-invest-locked]');
      const incomeLabel = root.querySelector('[data-invest-income-label]');
      const dutyLabel = root.querySelector('[data-invest-duty-label]');
      const minLabel = root.querySelector('[data-invest-min-label]');
      const lockedLabel = root.querySelector('[data-invest-locked-label]');
      const result = root.querySelector('[data-invest-result]');
      const reset = root.querySelector('[data-invest-reset]');
      const bar = root.querySelector('[data-invest-bar]');
      const mark = root.querySelector('[data-invest-mark]');
      const barText = root.querySelector('[data-invest-bar-text]');
      if (!controls || !income || !duty || !min || !locked || !result || !reset
          || !incomeLabel || !dutyLabel || !minLabel || !lockedLabel
          || !bar || !mark || !barText) return;
      const update = () => {
        const y = Number(income.value);
        const d = Number(duty.value);
        const m = Number(min.value);
        const lock = Number(locked.value);
        if (![y, d, m, lock].every(Number.isFinite)
            || y < 200 || y > 800 || y % 50 !== 0
            || d < 0 || d > 500 || d % 25 !== 0
            || m < 50 || m > 400 || m % 25 !== 0
            || lock < 0 || lock > 300 || lock % 25 !== 0) {
          result.textContent = '请使用给定范围与步长：净收入200–800（50）、义务0–500（25）、最低投入50–400（25）、锁作偿债0–300（25）。';
          return;
        }
        const free = y - d;
        const usable = Math.max(0, free - lock);
        const maxScale = 500;
        bar.setAttribute('width', String(Math.min(usable, maxScale) / maxScale * 300));
        mark.setAttribute('x1', String(10 + m / maxScale * 300));
        mark.setAttribute('x2', String(10 + m / maxScale * 300));
        barText.textContent = `可挪作设备：${usable}（最低线 ${m}）`;
        incomeLabel.textContent = String(y);
        dutyLabel.textContent = String(d);
        minLabel.textContent = String(m);
        lockedLabel.textContent = String(lock);
        if (usable >= m) {
          result.textContent = `净收入${y}−义务${d}=账面余额${free}；其中${lock}锁作偿债，可挪作设备${usable}≥最低投入${m}。账面够数仍不等于安排S已出现：资格、裁决、所有权合同须另查。`;
        } else {
          result.textContent = `净收入${y}−义务${d}=账面余额${free}；锁作偿债${lock}后可挪作设备仅${usable}，低于最低投入${m}。同技术下义务不同，可实施程度不同；不能把停付义务当成通用解放办法。`;
        }
      };
      [income, duty, min, locked].forEach(control => control.addEventListener('input', update));
      reset.addEventListener('click', () => {
        income.value = '400';
        duty.value = '150';
        min.value = '200';
        locked.value = '0';
        update();
      });
      root.querySelectorAll('[data-invest-preset]').forEach(button => {
        button.addEventListener('click', () => {
          const map = { a: [400, 150, 200, 0], b: [400, 300, 200, 0], lock: [400, 150, 200, 200] };
          const values = map[button.dataset.investPreset];
          if (!values) return;
          income.value = String(values[0]);
          duty.value = String(values[1]);
          min.value = String(values[2]);
          locked.value = String(values[3]);
          update();
        });
      });
      root.dataset.initialized = 'true';
      update();
      controls.hidden = false;
    });
  }

  function setupBudgetBalanceDemo() {
    document.querySelectorAll('[data-mlm-budget-demo]').forEach(root => {
      if (root.dataset.initialized) return;
      const controls = root.querySelector('[data-budget-controls]');
      const y = root.querySelector('[data-budget-y]');
      const c = root.querySelector('[data-budget-c]');
      const l = root.querySelector('[data-budget-l]');
      const m = root.querySelector('[data-budget-m]');
      const yLabel = root.querySelector('[data-budget-y-label]');
      const cLabel = root.querySelector('[data-budget-c-label]');
      const lLabel = root.querySelector('[data-budget-l-label]');
      const mLabel = root.querySelector('[data-budget-m-label]');
      const result = root.querySelector('[data-budget-result]');
      const reset = root.querySelector('[data-budget-reset]');
      const bar = root.querySelector('[data-budget-bar]');
      const barText = root.querySelector('[data-budget-bar-text]');
      if (!controls || !y || !c || !l || !m || !result || !reset
          || !yLabel || !cLabel || !lLabel || !mLabel || !bar || !barText) return;
      const update = () => {
        const Y = Number(y.value);
        const C = Number(c.value);
        const L = Number(l.value);
        const M = Number(m.value);
        if (![Y, C, L, M].every(Number.isFinite)
            || Y < 200 || Y > 2000 || Y % 50 !== 0
            || C < 0 || C > 800 || C % 25 !== 0
            || L < 0 || L > 800 || L % 25 !== 0
            || M < 0 || M > 400 || M % 25 !== 0) {
          result.textContent = '请使用给定范围：Y 200–2000、C/L 0–800、M 0–400；步长分别为50/25。';
          return;
        }
        const B = Y - C - L - M;
        const maxAbs = 800;
        const width = Math.min(Math.abs(B), maxAbs) / maxAbs * 150;
        bar.setAttribute('x', String(B >= 0 ? 180 : 180 - width));
        bar.setAttribute('width', String(width));
        bar.setAttribute('fill', B >= 0 ? 'currentColor' : 'none');
        bar.setAttribute('stroke', 'currentColor');
        barText.textContent = `B=${B}`;
        yLabel.textContent = String(Y);
        cLabel.textContent = String(C);
        lLabel.textContent = String(L);
        mLabel.textContent = String(M);
        if (M === 0) {
          result.textContent = `B=Y−C−L−M=${Y}−${C}−${L}−0=${B}。M=0时本期账面更高，但漏计维护可能损害下期条件；难货币化项目应另列，不能当作不存在。本式是教学假定，不是剩余价值公式。`;
        } else {
          result.textContent = `B=Y−C−L−M=${Y}−${C}−${L}−${M}=${B}。写出公式是为使假定可见；授权是否导致停机，还须竞争解释与削弱条件，不能只看余额符号。`;
        }
      };
      [y, c, l, m].forEach(control => control.addEventListener('input', update));
      reset.addEventListener('click', () => {
        y.value = '1000';
        c.value = '200';
        l.value = '400';
        m.value = '100';
        update();
      });
      root.dataset.initialized = 'true';
      update();
      controls.hidden = false;
    });
  }

  function setupProductivityDemo() {
    document.querySelectorAll('[data-mlm-productivity-demo]').forEach(root => {
      if (root.dataset.initialized) return;
      const controls = root.querySelector('[data-productivity-controls]');
      const count = root.querySelector('[data-productivity-count]');
      const hours = root.querySelector('[data-productivity-hours]');
      const rate = root.querySelector('[data-productivity-rate]');
      const result = root.querySelector('[data-productivity-result]');
      const reset = root.querySelector('[data-productivity-reset]');
      const countLabel = root.querySelector('[data-productivity-count-label]');
      const hoursLabel = root.querySelector('[data-productivity-hours-label]');
      const rateLabel = root.querySelector('[data-productivity-rate-label]');
      const series = [
        { bar: root.querySelector('[data-productivity-h-bar]'), label: root.querySelector('[data-productivity-h-text]'), name: 'H' },
        { bar: root.querySelector('[data-productivity-q-bar]'), label: root.querySelector('[data-productivity-q-text]'), name: 'q' },
        { bar: root.querySelector('[data-productivity-output-bar]'), label: root.querySelector('[data-productivity-output-text]'), name: 'Q' }
      ];
      if (!controls || !count || !hours || !rate || !result || !reset
          || !countLabel || !hoursLabel || !rateLabel
          || series.some(item => !item.bar || !item.label)) return;
      const format = value => String(Number(value.toFixed(1)));
      const update = () => {
        const n = Number(count.value);
        const h = Number(hours.value);
        const q = Number(rate.value);
        const tenths = Math.round(q * 10);
        if (!Number.isInteger(n) || n < 20 || n > 200 || n % 10 !== 0
            || !Number.isInteger(h) || h < 4 || h > 12
            || !Number.isFinite(q) || q < 0.5 || q > 2
            || Math.abs(q * 10 - tenths) > 1e-8) {
          result.textContent = '请使用给定范围与步长：人数20–200（每次10人）、每人工时4–12、假定q为0.5–2（每次0.1）。';
          return;
        }
        const totalHours = n * h;
        const output = totalHours * tenths / 10;
        const percentages = [totalHours / 800 * 100, q * 100, output / 800 * 100];
        countLabel.textContent = format(n);
        hoursLabel.textContent = format(h);
        rateLabel.textContent = format(q);
        series.forEach((item, index) => {
          item.bar.setAttribute('width', String(percentages[index] / 600 * 320));
          item.label.textContent = `${item.name}：${format(percentages[index])}%`;
        });
        result.textContent = `总劳动投入H=${format(totalHours)}人时，假定q=${format(q)}件/人时，生成产量Q=${format(output)}件。相对甲：H为${format(percentages[0])}%，q为${format(percentages[1])}%，Q为${format(percentages[2])}%；投入比×假定每人时产出比=产量比。该计算没有识别技术或组织的原因贡献。`;
      };
      const presets = { a: [100, 8, 1], b: [100, 8, 1.5], c: [100, 10, 1.2] };
      const load = values => {
        count.value = String(values[0]);
        hours.value = String(values[1]);
        rate.value = String(values[2]);
        update();
      };
      [count, hours, rate].forEach(control => control.addEventListener('input', update));
      root.querySelectorAll('[data-productivity-preset]').forEach(button => {
        button.addEventListener('click', () => {
          const values = presets[button.dataset.productivityPreset];
          if (values) load(values);
        });
      });
      reset.addEventListener('click', () => load(presets.a));
      root.dataset.initialized = 'true';
      update();
      controls.hidden = false;
    });
  }

  function initBookExtras() {
    if (window.TUTORIALS_EXTRAS && typeof window.TUTORIALS_EXTRAS.boot === 'function') {
      window.TUTORIALS_EXTRAS.boot({
        slug: 'mlm',
        pageTocLevels: ['h2'],
        toolbarPlacement: 'top',
        formulaHint: true
      });
    } else if (document.documentElement && !document.documentElement.classList.contains('tutorials-ready')) {
      // 兜底：extras 未加载时仍摘掉冷启动守卫，避免整页过渡被永久关掉
      document.documentElement.classList.add('tutorials-ready');
    }
  }

  function initDemosAndChrome() {
    setupProductivityDemo();
    setupOutsourceDemo();
    setupInvestBalanceDemo();
    setupBudgetBalanceDemo();
    setupConditionDemo();
    setupCompositionDemo();
    setupFlowDemo();
    setupWageDemo();
    setupBackToTop();
    enhanceTables();
    enhanceCitations();
  }

  function init() {
    initBookExtras();
    initDemosAndChrome();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  window.addEventListener('hashchange', () => {
    setTimeout(initDemosAndChrome, 100);
  });

})();
