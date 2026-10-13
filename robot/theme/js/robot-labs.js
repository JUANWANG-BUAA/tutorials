/* 机器人教程 · 交互实验运行时（渐进增强：没有 canvas 时整块隐藏，不影响正文）。
   约定：内容里只放 <div class="lab" data-lab="xxx" data-...></div>，
   本文件负责生成控件、画布与读数；样式全部走 theme/css/robot.css 的 .lab-* 类。 */
(function () {
  "use strict";

  var DEG = Math.PI / 180;

  function el(tag, cls, text) {
    var node = document.createElement(tag);
    if (cls) node.className = cls;
    if (text !== undefined && text !== null) node.textContent = text;
    return node;
  }

  function cssVar(name) {
    return getComputedStyle(document.documentElement).getPropertyValue(name).trim();
  }

  function palette() {
    return {
      ink: cssVar("--ink"),
      ink2: cssVar("--ink-2"),
      muted: cssVar("--muted"),
      line: cssVar("--line"),
      paper: cssVar("--paper"),
      accent: cssVar("--accent-strong"),
      blue: cssVar("--fig-blue"),
      green: cssVar("--fig-green"),
      gold: cssVar("--fig-gold"),
      red: cssVar("--fig-red"),
      purple: cssVar("--fig-purple"),
      neutral: cssVar("--fig-neutral")
    };
  }

  function fit(canvas, ratio) {
    var width = canvas.clientWidth || (canvas.parentElement && canvas.parentElement.clientWidth) || 640;
    if (width < 260) width = 260;
    var height = Math.max(200, Math.round(width * (ratio || 0.5)));
    var scale = Math.min(window.devicePixelRatio || 1, 2);
    if (canvas.width !== Math.round(width * scale)) {
      canvas.width = Math.round(width * scale);
      canvas.height = Math.round(height * scale);
    }
    canvas.style.height = height + "px";
    var ctx = canvas.getContext("2d");
    ctx.setTransform(scale, 0, 0, scale, 0, 0);
    ctx.clearRect(0, 0, width, height);
    return { ctx: ctx, w: width, h: height, c: palette() };
  }

  function frame(ctx, x0, y0, x1, y1, c) {
    ctx.strokeStyle = c.line;
    ctx.lineWidth = 1;
    ctx.strokeRect(x0 + .5, y0 + .5, x1 - x0, y1 - y0);
  }

  function arrow(ctx, x0, y0, x1, y1, color, width) {
    var angle = Math.atan2(y1 - y0, x1 - x0);
    var head = width * 3.2 + 3;
    ctx.strokeStyle = color;
    ctx.fillStyle = color;
    ctx.lineWidth = width;
    ctx.beginPath();
    ctx.moveTo(x0, y0);
    ctx.lineTo(x1, y1);
    ctx.stroke();
    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x1 - head * Math.cos(angle - 0.42), y1 - head * Math.sin(angle - 0.42));
    ctx.lineTo(x1 - head * Math.cos(angle + 0.42), y1 - head * Math.sin(angle + 0.42));
    ctx.closePath();
    ctx.fill();
  }

  function slider(host, label, min, max, step, value, onInput, format) {
    var wrap = el("label", "lab-ctl");
    var out = el("output", null, format ? format(value) : String(value));
    wrap.appendChild(document.createTextNode(label + " "));
    wrap.appendChild(out);
    var input = el("input");
    input.type = "range";
    input.min = min;
    input.max = max;
    input.step = step;
    input.value = value;
    input.setAttribute("aria-label", label);
    input.addEventListener("input", function () {
      out.textContent = format ? format(parseFloat(input.value)) : input.value;
      onInput(parseFloat(input.value));
    });
    wrap.appendChild(input);
    host.appendChild(wrap);
    return { input: input, out: out };
  }

  function toggleGroup(host, label, options, current, onPick) {
    var wrap = el("span", "lab-group");
    wrap.appendChild(el("span", "lab-group-label", label));
    var buttons = [];
    options.forEach(function (option) {
      var button = el("button", "lab-btn" + (option.value === current ? " on" : ""), option.text);
      button.type = "button";
      button.setAttribute("aria-pressed", option.value === current ? "true" : "false");
      button.addEventListener("click", function () {
        buttons.forEach(function (other) {
          var active = other === button;
          other.classList.toggle("on", active);
          other.setAttribute("aria-pressed", active ? "true" : "false");
        });
        onPick(option.value);
      });
      buttons.push(button);
      wrap.appendChild(button);
    });
    host.appendChild(wrap);
    return buttons;
  }

  function matrixHTML(rows, digits) {
    return "<table class='lab-matrix'><tbody>" + rows.map(function (row) {
      return "<tr>" + row.map(function (value) {
        return "<td>" + (typeof value === "number" ? value.toFixed(digits === undefined ? 3 : digits) : value) + "</td>";
      }).join("") + "</tr>";
    }).join("") + "</tbody></table>";
  }

  function mount(host, build) {
    if (document.createElement("canvas").getContext === undefined) {
      host.hidden = true;
      return;
    }
    build(host);
    host.classList.add("lab-ready");
  }

  /* ---------------- 实验 1：欧拉角（ZYZ / RPY） ---------------- */
  function rotX(a) { return [[1, 0, 0], [0, Math.cos(a), -Math.sin(a)], [0, Math.sin(a), Math.cos(a)]]; }
  function rotY(a) { return [[Math.cos(a), 0, Math.sin(a)], [0, 1, 0], [-Math.sin(a), 0, Math.cos(a)]]; }
  function rotZ(a) { return [[Math.cos(a), -Math.sin(a), 0], [Math.sin(a), Math.cos(a), 0], [0, 0, 1]]; }
  function mul(A, B) {
    var out = [[0, 0, 0], [0, 0, 0], [0, 0, 0]], i, j, k;
    for (i = 0; i < 3; i++) for (j = 0; j < 3; j++) { var s = 0; for (k = 0; k < 3; k++) s += A[i][k] * B[k][j]; out[i][j] = s; }
    return out;
  }
  function zyzMatrix(p, t, s) { return mul(mul(rotZ(p * DEG), rotY(t * DEG)), rotZ(s * DEG)); }
  function rpyMatrix(p, t, s) { return mul(mul(rotZ(p * DEG), rotY(t * DEG)), rotX(s * DEG)); }

  function extractZYZ(R) {
    var out = { ok: true };
    var sb = Math.sqrt(R[0][2] * R[0][2] + R[1][2] * R[1][2]);
    if (sb < 1e-9) {
      out.ok = false;
      out.singular = "s_ϑ = 0：φ 与 ψ 只以 φ+ψ（ϑ=0）或 φ−ψ（ϑ=π）出现，解不唯一。";
      out.phi = Math.atan2(R[1][0], R[0][0]) / DEG;
      out.theta = (R[2][2] > 0 ? 0 : 180);
      out.psi = 0;
      return out;
    }
    out.phi = Math.atan2(R[1][2], R[0][2]) / DEG;
    out.theta = Math.atan2(sb, R[2][2]) / DEG;
    out.psi = Math.atan2(R[2][1], -R[2][0]) / DEG;
    return out;
  }

  function extractRPY(R) {
    var out = { ok: true };
    var cb = Math.sqrt(R[0][0] * R[0][0] + R[1][0] * R[1][0]);
    if (cb < 1e-9) {
      out.ok = false;
      out.singular = "c_ϑ = 0（万向节锁定）：φ 与 ψ 只剩 φ−ψ 或 φ+ψ 的组合，解不唯一。";
      out.phi = Math.atan2(-R[0][1], R[1][1]) / DEG;
      out.theta = (R[2][0] < 0 ? 90 : -90);
      out.psi = 0;
      return out;
    }
    out.phi = Math.atan2(R[1][0], R[0][0]) / DEG;
    out.theta = Math.atan2(-R[2][0], cb) / DEG;
    out.psi = Math.atan2(R[2][1], R[2][2]) / DEG;
    return out;
  }

  function labEuler(host) {
    var c = palette();
    var state = { mode: "zyz", phi: 30, theta: 55, psi: 20 };
    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验"));
    head.appendChild(el("b", null, "同一组角，两种读法：ZYZ 与 RPY"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "拖动三个角，左边画的是当前约定下的姿态坐标架（灰=参考系，彩=动系）；下面同时给出旋转矩阵 R，以及把同一个 R 换用另一种约定反解出来的角度——这正是本节两组逆解公式在做的事。"));

    var controls = el("div", "lab-controls");
    toggleGroup(controls, "约定", [{ value: "zyz", text: "ZYZ" }, { value: "rpy", text: "RPY" }], "zyz", function (value) { state.mode = value; draw(); });
    host.appendChild(controls);
    slider(controls, "φ", -180, 180, 1, state.phi, function (v) { state.phi = v; draw(); }, function (v) { return v.toFixed(0) + "°"; });
    slider(controls, "ϑ", -180, 180, 1, state.theta, function (v) { state.theta = v; draw(); }, function (v) { return v.toFixed(0) + "°"; });
    slider(controls, "ψ", -180, 180, 1, state.psi, function (v) { state.psi = v; draw(); }, function (v) { return v.toFixed(0) + "°"; });

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "当前欧拉角对应的姿态坐标架");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);

    function project(v) {
      var cx = Math.cos(30 * DEG), sy = Math.sin(30 * DEG);
      return { x: (v[0] - v[1]) * cx, y: (v[0] + v[1]) * sy - v[2] };
    }

    function draw() {
      var s = fit(canvas, 0.52);
      var ctx = s.ctx, w = s.w, h = s.h;
      var R = state.mode === "zyz" ? zyzMatrix(state.phi, state.theta, state.psi) : rpyMatrix(state.phi, state.theta, state.psi);
      var origin = { x: w / 2, y: h * 0.62 };
      var scale = Math.min(w, h) * 0.30;
      function plot(vec) {
        var p = project(vec);
        return { x: origin.x + p.x * scale, y: origin.y + p.y * scale };
      }
      // 地面参考网格
      ctx.strokeStyle = c.line;
      ctx.lineWidth = 1;
      [-2, -1, 0, 1, 2].forEach(function (i) {
        var a = plot([i * 0.5, -1, 0]), b = plot([i * 0.5, 1, 0]);
        var d = plot([-1, i * 0.5, 0]), e = plot([1, i * 0.5, 0]);
        ctx.beginPath(); ctx.moveTo(a.x, a.y); ctx.lineTo(b.x, b.y); ctx.stroke();
        ctx.beginPath(); ctx.moveTo(d.x, d.y); ctx.lineTo(e.x, e.y); ctx.stroke();
      });
      var labels = ["x", "y", "z"];
      var colors = [c.blue, c.green, c.gold];
      labels.forEach(function (label, j) {
        var axis = plot([j === 0 ? 1 : 0, j === 1 ? 1 : 0, j === 2 ? 1 : 0]);
        arrow(ctx, origin.x, origin.y, axis.x, axis.y, c.muted, 1.2);
        ctx.fillStyle = c.muted;
        ctx.font = "12px " + cssVar("--sans");
        ctx.fillText(label, axis.x + 4, axis.y + 4);
      });
      labels.forEach(function (label, j) {
        var col = [R[0][j], R[1][j], R[2][j]];
        var tip = plot(col);
        arrow(ctx, origin.x, origin.y, tip.x, tip.y, colors[j], 2.4);
        ctx.fillStyle = colors[j];
        ctx.font = "bold 13px " + cssVar("--sans");
        ctx.fillText("'" + label, tip.x + 5, tip.y - 4);
      });
      ctx.fillStyle = c.ink2;
      ctx.font = "12.5px " + cssVar("--sans");
      ctx.fillText("投影：等轴测（仅为可视化，不是唯一的观察方向）", 10, h - 8);

      var other = state.mode === "zyz" ? extractRPY(R) : extractZYZ(R);
      var otherName = state.mode === "zyz" ? "RPY" : "ZYZ";
      var html = matrixHTML(R, 3).replace("<table", "<span class='lab-matrix-label'>R =</span><table");
      html += "<p><b>当前约定（" + (state.mode === "zyz" ? "ZYZ" : "RPY") + "）</b>：φ=" + state.phi.toFixed(0) + "°，ϑ=" + state.theta.toFixed(0) + "°，ψ=" + state.psi.toFixed(0) + "°</p>";
      if (other.ok) {
        html += "<p><b>换用 " + otherName + " 反解同一个 R</b>：φ=" + other.phi.toFixed(1) + "°，ϑ=" + other.theta.toFixed(1) + "°，ψ=" + other.psi.toFixed(1) + "°（两支解的另一支可由 ±180° 轮换得到）</p>";
      } else {
        html += "<p class='lab-warn'><b>" + otherName + " 反解遇到奇异：</b>" + other.singular + "</p>";
      }
      readout.innerHTML = html;
    }

    draw();
    window.addEventListener("resize", draw);
  }


  /* ---------------- 实验 2：平面 3R 机械臂的正运动学（DH 最小实例） ---------------- */
  function labArm(host) {
    var c = palette();
    var state = { q: [40, -35, 25], showTrace: true, L: [0.5, 0.4, 0.3] };
    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验"));
    head.appendChild(el("b", null, "平面 3R：把 DH 表连乘成末端位置"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "平面 3R 是 DH 法的最小实例：三个关节轴都垂直纸面（α = 0，a = lᵢ，d = 0）。拖动 θ₁…θ₃，看末端怎样随连杆串联移动——公式 x = l₁c₁ + l₂c₁₂ + l₃c₁₂₃ 就是三次左乘（右乘）齐次变换的展开。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    ["θ₁", "θ₂", "θ₃"].forEach(function (label, i) {
      slider(controls, label, -180, 180, 1, state.q[i], function (v) { state.q[i] = v; draw(); }, function (v) { return v.toFixed(0) + "°"; });
    });
    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "平面三连杆机械臂的姿态与末端轨迹");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);
    var trace = [];

    function forward() {
      var pts = [{ x: 0, y: 0 }], angle = 0, i;
      for (i = 0; i < 3; i++) {
        angle += state.q[i] * DEG;
        var prev = pts[i];
        pts.push({ x: prev.x + state.L[i] * Math.cos(angle), y: prev.y + state.L[i] * Math.sin(angle) });
      }
      return { pts: pts, angle: angle };
    }

    function draw() {
      var s = fit(canvas, 0.5);
      var ctx = s.ctx, w = s.w, h = s.h;
      var reach = state.L[0] + state.L[1] + state.L[2];
      var scale = Math.min(w * 0.42, h * 0.42) / reach;
      var ox = w * 0.30, oy = h * 0.55;
      function toScreen(p) { return { x: ox + p.x * scale, y: oy - p.y * scale }; }

      ctx.strokeStyle = c.line;
      ctx.lineWidth = 1;
      ctx.beginPath();
      ctx.moveTo(0, toScreen({ x: 0, y: 0 }).y);
      ctx.lineTo(w, toScreen({ x: 0, y: 0 }).y);
      ctx.stroke();
      ctx.fillStyle = c.muted;
      ctx.font = "11.5px " + cssVar("--sans");
      ctx.fillText("基座水平线", 8, toScreen({ x: 0, y: 0 }).y - 6);

      var fk = forward();
      var end = toScreen(fk.pts[3]);
      trace.push({ x: end.x, y: end.y });
      if (trace.length > 420) trace.shift();

      if (state.showTrace) {
        ctx.strokeStyle = c.accent;
        ctx.globalAlpha = 0.35;
        ctx.lineWidth = 1.6;
        ctx.beginPath();
        trace.forEach(function (point, i) {
          if (i === 0) ctx.moveTo(point.x, point.y);
          else ctx.lineTo(point.x, point.y);
        });
        ctx.stroke();
        ctx.globalAlpha = 1;
      }

      ctx.lineCap = "round";
      for (var i = 0; i < 3; i++) {
        var a = toScreen(fk.pts[i]), b = toScreen(fk.pts[i + 1]);
        var color = [c.blue, c.green, c.gold][i];
        ctx.strokeStyle = color;
        ctx.lineWidth = 7 - i;
        ctx.beginPath();
        ctx.moveTo(a.x, a.y);
        ctx.lineTo(b.x, b.y);
        ctx.stroke();
        ctx.fillStyle = color;
        ctx.beginPath();
        ctx.arc(a.x, a.y, 5.5, 0, 6.2832);
        ctx.fill();
        ctx.fillStyle = c.paper;
        ctx.beginPath();
        ctx.arc(a.x, a.y, 2.2, 0, 6.2832);
        ctx.fill();
      }
      ctx.fillStyle = c.red;
      ctx.beginPath();
      ctx.arc(end.x, end.y, 6.5, 0, 6.2832);
      ctx.fill();
      ctx.strokeStyle = c.red;
      ctx.lineWidth = 2;
      var tipLen = 26;
      ctx.beginPath();
      ctx.moveTo(end.x, end.y);
      ctx.lineTo(end.x + tipLen * Math.cos(-fk.angle), end.y + tipLen * Math.sin(-fk.angle));
      ctx.stroke();

      var x = fk.pts[3].x, y = fk.pts[3].y;
      var html = "<p><b>末端</b>：x = " + x.toFixed(3) + " m，y = " + y.toFixed(3) + " m，姿态 φ = " + (fk.angle / DEG).toFixed(1) + "°；" +
        "末端距基座 " + Math.sqrt(x * x + y * y).toFixed(3) + " m（可达半径 " + reach.toFixed(2) + " m）</p>";
      html += "<table class='lab-matrix'><thead><tr><th>i</th><th>αᵢ₋₁</th><th>aᵢ₋₁</th><th>dᵢ</th><th>θᵢ</th></tr></thead><tbody>" +
        "<tr><td>1</td><td>0</td><td>0</td><td>0</td><td>" + state.q[0].toFixed(0) + "°</td></tr>" +
        "<tr><td>2</td><td>0</td><td>" + state.L[0].toFixed(2) + "</td><td>0</td><td>" + state.q[1].toFixed(0) + "°</td></tr>" +
        "<tr><td>3</td><td>0</td><td>" + state.L[1].toFixed(2) + "</td><td>0</td><td>" + state.q[2].toFixed(0) + "°</td></tr>" +
        "</tbody></table>";
      html += "<p class='lab-note'>工具坐标原点再沿 x₃ 前进 a₃ = " + state.L[2].toFixed(2) + " m：x = l₁c₁ + l₂c₁₂ + l₃c₁₂₃，y = l₁s₁ + l₂s₁₂ + l₃s₁₂₃。</p>";
      readout.innerHTML = html;
    }

    draw();
    window.addEventListener("resize", draw);
  }

  /* ---------------- 实验 3：点对点轨迹规划（三次 / 五次 / LSPB） ---------------- */
  function labTraj(host) {
    var c = palette();
    var state = { kind: "cubic", T: 2, lambda: 0.6 };
    var d = 1;
    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验"));
    head.appendChild(el("b", null, "三次、五次、梯形速度：同一段位移的三张速度剖面"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "从静止到静止走过 1 m，总时间 T。三次多项式加速度两端跳变；五次多项式两端加速度为零（jerk 有限）；LSPB 用「匀加速—匀速—匀减速」三段拼接，加速度是分段常数。拖动滑块比较峰值与端部行为。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    toggleGroup(controls, "运动律", [{ value: "cubic", text: "三次" }, { value: "quintic", text: "五次" }, { value: "lspb", text: "LSPB / 梯形速度" }], "cubic", function (v) { state.kind = v; draw(); });
    slider(controls, "总时间 T", 1, 5, 0.1, state.T, function (v) { state.T = v; draw(); }, function (v) { return v.toFixed(1) + " s"; });
    var lam = slider(controls, "巡航速度系数 λ", 0, 0.98, 0.02, state.lambda, function (v) { state.lambda = v; draw(); }, function (v) { return v.toFixed(2); });
    lam.input.disabled = true;

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "位置、速度、加速度三条曲线随时间的对比");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);

    function sample(kind, lambda, T, t) {
      var tau = Math.min(1, Math.max(0, t / T));
      if (kind === "cubic") {
        return { q: d * (3 * tau * tau - 2 * tau * tau * tau), v: d * (6 * tau - 6 * tau * tau) / T, a: d * (6 - 12 * tau) / (T * T) };
      }
      if (kind === "quintic") {
        return {
          q: d * (10 * Math.pow(tau, 3) - 15 * Math.pow(tau, 4) + 6 * Math.pow(tau, 5)),
          v: d * (30 * tau * tau - 60 * Math.pow(tau, 3) + 30 * Math.pow(tau, 4)) / T,
          a: d * (60 * tau - 180 * tau * tau + 120 * Math.pow(tau, 3)) / (T * T)
        };
      }
      var vc = (1 + lambda) * d / T;
      var tb = T - d / vc;
      if (t <= tb) return { q: 0.5 * vc * t * t / tb, v: vc * t / tb, a: vc / tb };
      if (t >= T - tb) {
        var s = T - t;
        return { q: d - 0.5 * vc * s * s / tb, v: vc * s / tb, a: -vc / tb };
      }
      var qm = 0.5 * vc * tb + vc * (t - tb);
      return { q: qm, v: vc, a: 0 };
    }

    function draw() {
      lam.input.disabled = state.kind !== "lspb";
      var s = fit(canvas, 0.62);
      var ctx = s.ctx, w = s.w, h = s.h;
      var padL = 46, padR = 12, padT = 16, gap = 10;
      var panelW = (w - padL - padR - gap * 2) / 3;
      var vmax = { cubic: 1.5 * d / state.T, quintic: 1.875 * d / state.T, lspb: (1 + state.lambda) * d / state.T }[state.kind];
      var amax = { cubic: 6 * d / (state.T * state.T), quintic: 5.7735 * d / (state.T * state.T), lspb: ((1 + state.lambda) * d / state.T) / (state.T - d / ((1 + state.lambda) * d / state.T)) }[state.kind];
      var titles = ["位置 q(t)（m）", "速度 v(t)（m/s）", "加速度 a(t)（m/s²）"];
      var keys = ["q", "v", "a"];
      var ranges = [[0, d * 1.06], [-vmax * 1.12, vmax * 1.12], [-amax * 1.12, amax * 1.12]];
      var colors = [c.blue, c.green, c.red];
      for (var p = 0; p < 3; p++) {
        var x0 = padL + p * (panelW + gap);
        var y0 = padT, y1 = h - padT;
        frame(ctx, x0, y0, x0 + panelW, y1, c);
        var lo = ranges[p][0], hi = ranges[p][1];
        function X(t) { return x0 + t / state.T * panelW; }
        function Y(v) { return y1 - (v - lo) / (hi - lo) * (y1 - y0); }
        if (lo < 0 && hi > 0) {
          ctx.strokeStyle = c.line;
          ctx.beginPath(); ctx.moveTo(x0, Y(0)); ctx.lineTo(x0 + panelW, Y(0)); ctx.stroke();
        }
        ctx.strokeStyle = colors[p];
        ctx.lineWidth = 2;
        ctx.beginPath();
        for (var i = 0; i <= 160; i++) {
          var t = state.T * i / 160;
          var val = sample(state.kind, state.lambda, state.T, t)[keys[p]];
          if (i === 0) ctx.moveTo(X(t), Y(val)); else ctx.lineTo(X(t), Y(val));
        }
        ctx.stroke();
        ctx.fillStyle = c.ink2;
        ctx.font = "12px " + cssVar("--sans");
        ctx.fillText(titles[p], x0 + 4, y0 + 13);
        ctx.fillStyle = c.muted;
        ctx.font = "11px " + cssVar("--sans");
        ctx.fillText(hi.toFixed(2), 4, y0 + 10);
        ctx.fillText(lo.toFixed(2), 4, y1 - 2);
        ctx.fillText("0", x0 - 8, y1 + 12);
        ctx.fillText(state.T.toFixed(1) + " s", x0 + panelW - 26, y1 + 12);
      }
      var vpeak = { cubic: 1.5 * d / state.T, quintic: 1.875 * d / state.T, lspb: (1 + state.lambda) * d / state.T }[state.kind];
      var apeak = { cubic: 6 * d / (state.T * state.T), quintic: 30 * Math.sqrt(3) / 9 * d / (state.T * state.T), lspb: ((1 + state.lambda) * d / state.T) / (state.T - d / ((1 + state.lambda) * d / state.T)) }[state.kind];
      var note = {
        cubic: "三次：v 两端为零，但 a 在 t=0 与 t=T 处跳到 ±6d/T² —— 实际机器会在起停瞬间「抖一下」。",
        quintic: "五次：a(0) = a(T) = 0，两端加速度连续（jerk 有限），代价是峰值加速度与峰值速度更高。",
        lspb: "LSPB：加速度是 ±a_max 的方波，速度是梯形。λ 越大巡航段越短；λ→1 时退化为抛物线混合（无匀速段）。"
      }[state.kind];
      var extra = state.kind === "lspb"
        ? "<p class='lab-note'>匀速段速度 v_c = (1+λ)·d/T = " + (((1 + state.lambda) * d / state.T).toFixed(3)) + " m/s，加减速时长 t_b = T − d/v_c = " + (state.T - d / ((1 + state.lambda) * d / state.T)).toFixed(3) + " s；λ 滑杆只对 LSPB 生效。</p>"
        : "";
      readout.innerHTML = "<p><b>峰值速度</b> " + vpeak.toFixed(3) + " m/s &nbsp;·&nbsp; <b>峰值加速度</b> " + apeak.toFixed(3) + " m/s²</p><p>" + note + "</p>" + extra;
    }

    draw();
    window.addEventListener("resize", draw);
  }

  /* ---------------- 引导 ---------------- */
  function boot() {
    var hosts = document.querySelectorAll("[data-lab]");
    if (hosts.length === 0) return;
    var registry = { euler: labEuler, arm: labArm, traj: labTraj };
    Array.prototype.forEach.call(hosts, function (host) {
      var name = host.getAttribute("data-lab");
      var builder = registry[name];
      if (builder === undefined) return;
      try {
        mount(host, builder);
      } catch (error) {
        host.hidden = true;
      }
    });
  }

  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", boot);
  else boot();
})();
