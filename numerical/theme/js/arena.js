/* 数值分析教程 · 必考点竞技场（可降级增强）。
 *
 * 设计原则与 na.js 一致：**先有可读的静态内容，再叠加交互**。
 *   - 题库以普通 HTML 写在页面里（.arena-bank），默认就是一份带解析的问答清单：
 *     关 JS、打印、搜索都能用，公式由构建期 KaTeX 渲染（本项目不用运行时 KaTeX）。
 *   - 脚本只在 #arena-mount 里另起一块「竞技场」舞台，把题目**克隆**进去做限时答题；
 *     原始题库被折进一个 <details>，避免剧透，但随时可展开查阅。
 *   - 所有交互态类名（is-correct 等）只加在克隆体上，原始题库不受影响。
 *
 * 竞技元素：分关解锁、限时、连击倍率、段位、个人最佳、错题本（localStorage 持久化）。
 * 全部状态存 localStorage 键 na-arena-v1，读写都包 try/catch（隐私模式下静默降级）。
 */
(function () {
  "use strict";

  var KEY = "na-arena-v1";
  var mount = document.getElementById("arena-mount");
  var bank = document.getElementById("arena-bank");
  if (!mount || !bank) return;

  /* 关卡元信息：题目只带 data-lv，关卡名与说明写在这里（纯 UI 文案）。 */
  var LEVEL_META = {
    1: { name: "误差与精度", desc: "第 1–2 讲 · 误差四分类、有效数字判据、递推稳定性、精度保护" },
    2: { name: "范数与条件数", desc: "第 2–3 讲 · 向量/矩阵范数、相容性、‖A‖<1 可逆、条件数" },
    3: { name: "线性方程组与迭代法", desc: "第 3–6 讲 · 高斯消去、LU 分解、ρ(G)<1、Jacobi/G–S、SOR" },
    4: { name: "特征值与幂法", desc: "第 6–7 讲 · 单位化幂法、2-范数取特征值、反幂法、位移" },
    5: { name: "非线性方程与插值", desc: "第 7–11 讲 · 二分法、不动点收敛、牛顿全局收敛、割线法、插值、最佳平方逼近与正交多项式" }
  };

  /* 段位门槛按**正确率**判定：分数受连击影响不稳定，正确率才代表掌握程度。 */
  var TIERS = [
    { min: 1.0, name: "王者", cls: "rank-king" },
    { min: 0.9, name: "钻石", cls: "rank-diamond" },
    { min: 0.8, name: "铂金", cls: "rank-platinum" },
    { min: 0.65, name: "黄金", cls: "rank-gold" },
    { min: 0.5, name: "白银", cls: "rank-silver" },
    { min: -1, name: "青铜", cls: "rank-bronze" }
  ];
  var CLEAR_RATIO = 0.7;   // 正确率 ≥ 70% 判定通关，解锁下一关
  var SECONDS_PER_Q = 30;  // 单关限时 = 题数 × 该值（再设下限）

  function tierOf(ratio) {
    for (var i = 0; i < TIERS.length; i++) if (ratio >= TIERS[i].min) return TIERS[i];
    return TIERS[TIERS.length - 1];
  }

  function loadState() {
    try {
      var raw = JSON.parse(localStorage.getItem(KEY));
      if (raw && typeof raw === "object" && !Array.isArray(raw)) {
        ["best", "cleared", "wrong"].forEach(function (key) {
          if (!raw[key] || typeof raw[key] !== "object" || Array.isArray(raw[key])) raw[key] = {};
        });
        raw.maxCombo = Number.isFinite(raw.maxCombo) && raw.maxCombo >= 0 ? raw.maxCombo : 0;
        Object.keys(raw.best).forEach(function (key) { if (!Number.isFinite(raw.best[key]) || raw.best[key] < 0) delete raw.best[key]; });
        return raw;
      }
    } catch (e) { /* 隐私模式 / 存储被禁：当作空状态。 */ }
    return { best: {}, cleared: {}, wrong: {}, maxCombo: 0 };
  }
  function saveState(s) {
    try { localStorage.setItem(KEY, JSON.stringify(s)); } catch (e) { /* 忽略写入失败 */ }
  }

  var state = loadState();

  /* ---------------------------------------------------------------- 读题库 */

  function text(el) { return el ? el.innerHTML : ""; }

  var items = [];
  Array.prototype.forEach.call(bank.querySelectorAll(".arena-q"), function (el) {
    var optEls = Array.prototype.slice.call(el.querySelectorAll(".aq-opts li"));
    if (!optEls.length) return;
    var a = parseInt(el.getAttribute("data-a"), 10);
    if (isNaN(a) || a < 0 || a >= optEls.length) a = 0;
    items.push({
      id: el.getAttribute("data-id") || ("q" + items.length),
      lv: parseInt(el.getAttribute("data-lv"), 10) || 1,
      a: a,
      point: el.getAttribute("data-point") || "",
      tag: el.getAttribute("data-tag") || "",
      src: el.getAttribute("data-src") || "",
      href: el.getAttribute("data-href") || "",
      promptHTML: text(el.querySelector(".aq-prompt")),
      optsHTML: optEls.map(function (li) { return li.innerHTML; }),
      expHTML: text(el.querySelector(".exp-body"))
    });
  });
  if (!items.length) return;

  var byLevel = {};
  items.forEach(function (it) { (byLevel[it.lv] = byLevel[it.lv] || []).push(it); });
  var levelNums = Object.keys(byLevel).map(Number).sort(function (x, y) { return x - y; });

  /* ------------------------------------------------------------ 构建外壳 */

  function el(tag, cls, html) {
    var n = document.createElement(tag);
    if (cls) n.className = cls;
    if (html != null) n.innerHTML = html;
    return n;
  }

  var shell = el("div", "arena-shell");
  var head = el("div", "arena-head");
  head.appendChild(el("span", "arena-title", "必考点竞技场"));
  head.appendChild(el("span", "arena-sub", "限时 · 连击倍率 · 段位 · 错题本"));
  head.appendChild(el("span", "arena-spacer"));
  head.appendChild(el("span", "arena-a11y-help", "键盘：1–9 选项 · Enter 下一题"));
  shell.appendChild(head);

  var hud = el("div", "arena-hud");
  var hudCells = {};
  [["score", "得分"], ["combo", "连击"], ["mult", "倍率"], ["time", "剩余"]].forEach(function (pair) {
    var c = el("div", "arena-stat");
    c.appendChild(el("span", "k", pair[1]));
    var v = el("span", "v", "0");
    c.appendChild(v);
    hudCells[pair[0]] = c;
    hud.appendChild(c);
  });
  var bar = el("div", "arena-bar", "<i></i>");
  hud.appendChild(bar);
  shell.appendChild(hud);

  var panel = el("div", "arena-panel");
  var levelsGrid = el("div", "arena-levels");
  panel.appendChild(levelsGrid);
  var wrongbook = el("div", "arena-wrongbook");
  panel.appendChild(wrongbook);
  shell.appendChild(panel);

  var stage = el("div", "arena-stage");
  stage.hidden = true;
  shell.appendChild(stage);

  var result = el("div", "arena-result");
  result.hidden = true;
  shell.appendChild(result);

  mount.appendChild(shell);

  /* 题库折叠：JS 可用时藏起原文，避免默认剧透。 */
  if (!bank.dataset.folded) {
    bank.dataset.folded = "1";
    var fold = el("details", "arena-bank-fold");
    var sum = el("summary", null, "题库原文 · 含答案（点开查阅；关掉 JS 时它默认展开）");
    bank.parentNode.insertBefore(fold, bank);
    fold.appendChild(sum);
    fold.appendChild(bank);
  }

  /* ------------------------------------------------------------ 关卡界面 */

  function remainingWrong() {
    return Object.keys(state.wrong).filter(function (id) { return items.some(function (item) { return item.id === id; }); });
  }

  function renderWrongbook() {
    var ids = remainingWrong();
    wrongbook.innerHTML = "";
    var h = el("div", "wb-head");
    h.appendChild(el("b", null, "错题本"));
    h.appendChild(el("span", null, ids.length ? ids.length + " 题待攻克" : "暂无错题"));
    if (ids.length) {
      var clear = el("button", "arena-btn ghost", "清空");
      clear.type = "button";
      clear.style.marginLeft = "auto";
      clear.style.padding = "5px 12px";
      clear.style.fontSize = "11px";
      clear.addEventListener("click", function () { state.wrong = {}; saveState(state); renderWrongbook(); });
      h.appendChild(clear);
    }
    wrongbook.appendChild(h);
    if (!ids.length) {
      wrongbook.appendChild(el("p", "wb-empty", "答错的题会自动收进这里，随时回来重刷；答对后自动移出。"));
      return;
    }
    var ol = el("ol");
    ids.forEach(function (id) {
      var w = items.find(function (item) { return item.id === id; });
      var li = el("li");
      var tag = el("span", "wb-tag");
      tag.textContent = w.tag;
      li.appendChild(tag);
      var point = el(w.href ? "a" : "span");
      if (w.href) point.setAttribute("href", w.href);
      point.textContent = w.point;
      li.appendChild(point);
      ol.appendChild(li);
    });
    wrongbook.appendChild(ol);
  }

  function renderLevels() {
    levelsGrid.innerHTML = "";
    levelNums.forEach(function (lv, idx) {
      var meta = LEVEL_META[lv] || { name: "第 " + lv + " 关", desc: "" };
      var qn = byLevel[lv].length;
      var unlocked = idx === 0 || state.cleared[levelNums[idx - 1]];
      var best = state.best[lv];
      var btn = el("button", "arena-level");
      btn.type = "button";
      btn.disabled = !unlocked;
      if (state.cleared[lv]) btn.classList.add("is-cleared");
      btn.innerHTML =
        '<span class="lv-no">第 ' + "一二三四五六七八九".charAt(idx) + " 关</span>" +
        '<span class="lv-name">' + meta.name + "</span>" +
        '<span class="lv-desc">' + meta.desc + "</span>" +
        '<span class="lv-meta">' + qn + " 题 · 限时 " + levelTime(lv) + " 秒" +
        (best != null ? ' · <span class="lv-best">最佳 ' + best + " 分</span>" : "") + "</span>";
      if (state.cleared[lv]) btn.insertAdjacentHTML("beforeend", '<span class="lv-flag">已通关</span>');
      if (!unlocked) btn.insertAdjacentHTML("beforeend", '<span class="lv-flag">未解锁</span>');
      btn.addEventListener("click", function () { startRound(lv); });
      levelsGrid.appendChild(btn);
    });
  }

  function levelTime(lv) { return Math.max(90, byLevel[lv].length * SECONDS_PER_Q); }

  function showPanel() {
    var hadRound = Boolean(round);
    stopTimer();
    round = null;
    panel.hidden = false;
    stage.hidden = true;
    result.hidden = true;
    hud.classList.remove("is-on");
    renderLevels();
    renderWrongbook();
    var first = levelsGrid.querySelector("button:not(:disabled)");
    if (first && hadRound) first.focus({ preventScroll: true });
  }

  /* ------------------------------------------------------------ 一轮作答 */

  var round = null;
  var timerId = null;

  function shuffle(arr) {
    var a = arr.slice();
    for (var i = a.length - 1; i > 0; i--) {
      var j = Math.floor(Math.random() * (i + 1));
      var t = a[i]; a[i] = a[j]; a[j] = t;
    }
    return a;
  }

  function startRound(lv) {
    var pool = shuffle(byLevel[lv]);
    round = {
      active: true,
      lv: lv,
      pool: pool,
      i: 0,
      score: 0,
      combo: 0,
      maxCombo: 0,
      correct: 0,
      answered: 0,
      total: pool.length,
      left: levelTime(lv) * 10,   // 以 0.1 秒为单位
      limit: levelTime(lv) * 10,
      waiting: false,
      missIds: []
    };
    panel.hidden = true;
    result.hidden = true;
    stage.hidden = false;
    hud.classList.add("is-on");
    updateHud();
    renderQuestion();
    runTimer();
  }

  function runTimer() {
    stopTimer();
    round.deadline = Date.now() + round.left * 100;
    timerId = setInterval(function () {
      syncTime();
    }, 100);
  }
  function syncTime() {
    if (!round || !round.active) return false;
    round.left = Math.max(0, Math.ceil((round.deadline - Date.now()) / 100));
    updateHud();
    if (round.left <= 0) { endRound("timeout"); return false; }
    return true;
  }
  function stopTimer() { if (timerId) { clearInterval(timerId); timerId = null; } }

  function updateHud() {
    hudCells.score.querySelector(".v").textContent = round.score;
    hudCells.combo.querySelector(".v").innerHTML = round.combo + "<small>连</small>";
    var mult = Math.min(round.combo, 5);
    hudCells.mult.querySelector(".v").innerHTML = (mult || 1) + "<small>×</small>";
    hudCells.mult.classList.toggle("is-hot", mult >= 3);
    hudCells.combo.classList.toggle("is-hot", round.combo >= 3);
    var secs = Math.ceil(round.left / 10);
    hudCells.time.querySelector(".v").textContent = secs + "s";
    var ratio = round.left / round.limit;
    var fill = bar.querySelector("i");
    fill.style.width = (ratio * 100) + "%";
    bar.classList.toggle("is-danger", ratio < 0.25);
  }

  var KEYS = ["A", "B", "C", "D", "E", "F", "G", "H", "I"];

  function renderQuestion() {
    round.waiting = false;
    var q = round.pool[round.i];
    stage.innerHTML = "";
    stage.dataset.qid = q.id;

    stage.appendChild(el("div", "arena-progress",
      "第 " + (round.i + 1) + " / " + round.total + " 题" +
      (q.tag ? " · " + q.tag : "") + (q.point ? " · 考点：" + q.point : "")));

    var view = el("div", "arena-qview");
    view.appendChild(el("div", "aq-prompt", q.promptHTML));
    var opts = el("ol", "aq-opts arena-opts");
    q.optsHTML.forEach(function (html, idx) {
      var li = el("li");
      li.setAttribute("role", "button");
      li.setAttribute("tabindex", "0");
      li.dataset.i = String(idx);
      li.appendChild(el("span", "opt-key", KEYS[idx] || String(idx + 1)));
      var body = el("span", "opt-body", html);
      li.appendChild(body);
      li.addEventListener("click", function () { answer(idx); });
      li.addEventListener("keydown", function (ev) {
        if (ev.key === "Enter" || ev.key === " ") { ev.preventDefault(); ev.stopPropagation(); answer(idx); }
      });
      opts.appendChild(li);
    });
    view.appendChild(opts);
    stage.appendChild(view);

    var fb = el("div", "arena-feedback");
    fb.setAttribute("role", "status");
    fb.hidden = true;
    stage.appendChild(fb);

    var actions = el("div", "arena-actions");
    var next = el("button", "arena-btn", round.i === round.total - 1 ? "查看战绩" : "下一题 →");
    next.type = "button";
    next.hidden = true;
    next.addEventListener("click", advance);
    actions.appendChild(next);
    var quit = el("button", "arena-btn ghost", "退出本关");
    quit.type = "button";
    quit.addEventListener("click", function () { stopTimer(); showPanel(); });
    actions.appendChild(quit);
    stage.appendChild(actions);

    var first = opts.querySelector("li");
    if (first) first.focus({ preventScroll: true });
  }

  function answer(idx) {
    if (!round || round.waiting || !syncTime()) return;
    round.waiting = true;
    var q = round.pool[round.i];
    var opts = stage.querySelectorAll(".arena-opts li");
    var correct = idx === q.a;
    round.answered += 1;

    if (correct) {
      round.combo += 1;
      round.maxCombo = Math.max(round.maxCombo, round.combo);
      round.correct += 1;
      var mult = Math.min(round.combo, 5);
      round.score += 100 * mult;
      if (state.wrong[q.id]) { delete state.wrong[q.id]; saveState(state); }
    } else {
      round.combo = 0;
      round.missIds.push(q.id);
      state.wrong[q.id] = { point: q.point, tag: q.tag, src: q.src, href: q.href };
      saveState(state);
    }

    Array.prototype.forEach.call(opts, function (li) {
      var i = Number(li.dataset.i);
      li.classList.add("is-locked");
      li.setAttribute("tabindex", "-1");
      li.setAttribute("aria-disabled", "true");
      if (i === q.a) li.classList.add("is-correct");
      else if (i === idx) li.classList.add("is-wrong");
      else li.classList.add("is-dim");
    });

    var fb = stage.querySelector(".arena-feedback");
    fb.hidden = false;
    fb.classList.add(correct ? "is-correct" : "is-wrong");
    fb.innerHTML =
      '<span class="fb-verdict">' + (correct ? "✓ 正确  +" + (100 * Math.min(round.combo, 5)) + " 分" : "✗ 错误") + "</span>" +
      (q.expHTML || "") +
      (q.src ? '<span class="fb-src">出处：' + (q.href ? '<a href="' + q.href + '">' + q.src + "</a>" : q.src) + "</span>" : "");

    var next = stage.querySelector(".arena-actions .arena-btn:not(.ghost)");
    next.hidden = false;
    next.focus({ preventScroll: true });
    updateHud();
    renderWrongbook();

    // 解析保留到读者明确选择下一题，不用延迟任务抢走阅读位置。
  }

  function advance() {
    if (!round || !round.waiting || !syncTime()) return;
    round.i += 1;
    if (round.i >= round.total) { endRound("done"); return; }
    renderQuestion();
  }

  function endRound(reason) {
    if (!round || !round.active) return;
    round.active = false;
    stopTimer();
    var ratio = round.total ? round.correct / round.total : 0;
    var tier = tierOf(ratio);
    var passed = ratio >= CLEAR_RATIO;
    var timeBonus = Math.round(round.left / 10) * 5;
    var finalScore = round.score + (reason === "done" ? timeBonus : 0);

    state.maxCombo = Math.max(state.maxCombo || 0, round.maxCombo);
    var prevBest = state.best[round.lv];
    var isNew = prevBest == null || finalScore > prevBest;
    if (isNew) state.best[round.lv] = finalScore;
    if (passed) state.cleared[round.lv] = true;
    saveState(state);

    hud.classList.remove("is-on");
    stage.hidden = true;
    result.hidden = false;
    result.innerHTML = "";

    result.appendChild(el("div", "rs-score", finalScore + "<small style='font-size:16px;color:var(--muted)'> 分</small>"));
    result.appendChild(el("div", "rs-tier",
      reason === "timeout" ? "⏱ 时间到" : (passed ? "🏅 通关！" : "再接再厉")));
    var badge = el("span", "rank-badge " + tier.cls, tier.name);
    result.appendChild(badge);
    if (isNew) result.appendChild(el("div", "arena-newbest", "★ 新纪录（本关历史最佳）"));
    if (round.maxCombo >= 3) result.insertAdjacentHTML("beforeend",
      '<div class="arena-newbest" style="color:var(--muted)">最长连击 ' + round.maxCombo + " 连续答对</div>");

    var tally = el("div", "arena-tally");
    [["答对", round.correct + " / " + round.total],
     ["正确率", Math.round(ratio * 100) + "%"],
     ["时长奖励", "+" + (reason === "done" ? timeBonus : 0)]].forEach(function (p) {
      var c = el("div");
      c.appendChild(el("span", "k", p[0]));
      c.appendChild(el("span", "v", p[1]));
      tally.appendChild(c);
    });
    result.appendChild(tally);

    var acts = el("div", "arena-actions");
    var again = el("button", "arena-btn", "再来一局");
    again.type = "button";
    again.addEventListener("click", function () { startRound(round.lv); });
    acts.appendChild(again);
    var back = el("button", "arena-btn ghost", "返回关卡");
    back.type = "button";
    back.addEventListener("click", showPanel);
    acts.appendChild(back);
    result.appendChild(acts);
    again.focus({ preventScroll: true });

    if (round.missIds.length) {
      var miss = el("div", "arena-wrongbook");
      miss.appendChild(el("div", "wb-head", "<b>本关错题已收入错题本</b><span>" + round.missIds.length + " 题</span>"));
      result.appendChild(miss);
    }
  }

  /* ------------------------------------------------------- 键盘（全局） */

  document.addEventListener("keydown", function (ev) {
    if (!round || stage.hidden || ev.defaultPrevented || ev.isComposing || ev.ctrlKey || ev.metaKey || ev.altKey) return;
    if (!stage.contains(ev.target) || ev.target.isContentEditable || ev.target.closest("input, textarea, select, button, a, summary")) return;
    if (ev.key >= "1" && ev.key <= "9") {
      var idx = Number(ev.key) - 1;
      if (!round.waiting && idx < round.pool[round.i].optsHTML.length) { ev.preventDefault(); answer(idx); }
    } else if (ev.key === "Enter") {
      var next = stage.querySelector(".arena-actions .arena-btn:not(.ghost)");
      if (next && !next.hidden) { ev.preventDefault(); advance(); }
    }
  });
  document.addEventListener("visibilitychange", function () { if (timerId) syncTime(); });

  showPanel();
})();

/* 考场计时器（可降级增强）：页面里放 <div class="exam-timer" data-minutes="60"></div>，
 * 就在此处渲染一个倒计时秒表——开始 / 暂停 / 复位。关 JS 时该 div 为空，不影响阅读。
 * 与竞技场共用同一套进度条外观，但不计算分数（用于「综合自测卷」的请计时闭卷）。 */
(function () {
  "use strict";
  var host = document.querySelector(".exam-timer");
  if (!host) return;

  var minutes = parseFloat(host.getAttribute("data-minutes"));
  if (!Number.isFinite(minutes) || minutes <= 0) minutes = 60;
  var total = Math.round(minutes * 60);
  var left = total;
  var tickId = null;
  var running = false;
  var deadline = 0;

  function fmt(s) {
    var m = Math.floor(s / 60), ss = s % 60;
    return (m < 10 ? "0" : "") + m + ":" + (ss < 10 ? "0" : "") + ss;
  }

  var box = document.createElement("div");
  box.className = "arena-shell";
  box.style.margin = "26px 0";
  box.innerHTML =
    '<div class="arena-head"><span class="arena-title">考场计时</span>' +
    '<span class="arena-sub">建议 ' + minutes + " 分钟 · 闭卷独立完成</span>" +
    '<span class="arena-spacer"></span>' +
    '<span class="arena-a11y-help">开始后计时 · 时间到自动提示</span></div>';

  var hud = document.createElement("div");
  hud.className = "arena-hud is-on";
  hud.style.gridTemplateColumns = "1fr";
  var stat = document.createElement("div");
  stat.className = "arena-stat";
  stat.innerHTML = '<span class="k">剩余时间</span>';
  var val = document.createElement("span");
  val.className = "v";
  val.style.fontSize = "30px";
  val.textContent = fmt(left);
  stat.appendChild(val);
  hud.appendChild(stat);
  var bar = document.createElement("div");
  bar.className = "arena-bar";
  var fill = document.createElement("i");
  bar.appendChild(fill);
  hud.appendChild(bar);
  box.appendChild(hud);

  var panel = document.createElement("div");
  panel.className = "arena-panel";
  var acts = document.createElement("div");
  acts.className = "arena-actions";
  acts.style.margin = "0";
  var start = document.createElement("button");
  start.className = "arena-btn";
  start.type = "button";
  start.textContent = "开始计时";
  var reset = document.createElement("button");
  reset.className = "arena-btn ghost";
  reset.type = "button";
  reset.textContent = "复位";
  acts.appendChild(start);
  acts.appendChild(reset);
  panel.appendChild(acts);
  box.appendChild(panel);

  function paint() {
    val.textContent = fmt(left);
    fill.style.width = (left / total * 100) + "%";
    bar.classList.toggle("is-danger", left / total < 0.2);
  }

  function stop() { if (tickId) { clearInterval(tickId); tickId = null; } running = false; start.textContent = "继续"; }
  function tick() {
    left = Math.max(0, Math.ceil((deadline - Date.now()) / 1000));
    if (left <= 0) { stop(); start.textContent = "时间到"; start.disabled = true; }
    paint();
  }

  start.addEventListener("click", function () {
    if (running) { tick(); stop(); if (left <= 0) start.textContent = "时间到"; return; }
    if (left <= 0) return;
    running = true;
    deadline = Date.now() + left * 1000;
    start.textContent = "暂停";
    tickId = setInterval(tick, 250);
  });
  reset.addEventListener("click", function () {
    stop(); left = total; start.disabled = false; start.textContent = "开始计时"; paint();
  });

  host.appendChild(box);
  document.addEventListener("visibilitychange", function () { if (running) tick(); });
  paint();
})();
