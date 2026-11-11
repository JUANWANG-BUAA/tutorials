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

  function labRotation2d(host) {
    var state = { angle: 30, mode: "active" };
    var initial = [1, 0.5];
    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互演示"));
    head.appendChild(el("b", null, "转向量，还是换坐标？"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "从 +z 朝原点看，逆时针为正。输入列固定为 (1, 0.5, 0)；先预测 ±90° 的输出，再切换模式核对。实线为参考轴，虚线为旋转后的本体轴，所有读数无量纲。"));
    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    var angleControl = slider(controls, "绕 z 的角度 α", -180, 180, 1, state.angle, function (value) {
      state.angle = value;
      draw();
    }, function (value) { return value + "°"; });
    var modeButtons = toggleGroup(controls, "问题", [
      { value: "active", text: "转向量" }, { value: "passive", text: "换坐标" }
    ], state.mode, function (value) { state.mode = value; draw(); });
    var reset = el("button", "lab-btn", "重置");
    reset.type = "button";
    reset.addEventListener("click", function () {
      state.angle = 30;
      angleControl.input.value = "30";
      angleControl.out.textContent = "30°";
      modeButtons[0].click();
    });
    controls.appendChild(reset);
    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    readout.setAttribute("aria-atomic", "true");
    host.appendChild(readout);

    function clean(value) {
      return Math.abs(value) < 0.0005 ? 0 : value;
    }

    function vectorText(vector) {
      return "(" + vector.map(function (value) { return clean(value).toFixed(3); }).join(", ") + ", 0.000)";
    }

    function draw() {
      var radians = state.angle * DEG;
      var cosine = Math.cos(radians);
      var sine = Math.sin(radians);
      var rotation = [[cosine, -sine, 0], [sine, cosine, 0], [0, 0, 1]];
      var transformed = state.mode === "active"
        ? [cosine * initial[0] - sine * initial[1], sine * initial[0] + cosine * initial[1]]
        : [cosine * initial[0] + sine * initial[1], -sine * initial[0] + cosine * initial[1]];
      var scene = fit(canvas, 0.48);
      var context = scene.ctx;
      var colors = scene.c;
      var originX = scene.w * 0.5;
      var originY = scene.h * 0.51;
      var scale = Math.min(scene.w * 0.24, scene.h * 0.23);
      context.font = "13px " + cssVar("--sans");
      context.textAlign = "center";

      function drawVector(vector, color, width, label, dashed) {
        var endX = originX + scale * vector[0];
        var endY = originY - scale * vector[1];
        context.setLineDash(dashed ? [5, 4] : []);
        arrow(context, originX, originY, endX, endY, color, width);
        context.setLineDash([]);
        if (label) {
          context.fillStyle = color;
          context.fillText(label, endX + vector[0] * 15, endY - vector[1] * 15);
        }
      }

      drawVector([1.65, 0], colors.muted, 1, "x", false);
      drawVector([0, 1.65], colors.muted, 1, "y", false);
      drawVector([-1.65, 0], colors.line, 1, "", false);
      drawVector([0, -1.65], colors.line, 1, "", false);
      if (state.mode === "passive") {
        drawVector([1.4 * cosine, 1.4 * sine], colors.green, 1.7, "x′", true);
        drawVector([-1.4 * sine, 1.4 * cosine], colors.gold, 1.7, "y′", true);
        var projection = [transformed[0] * cosine, transformed[0] * sine];
        context.strokeStyle = colors.green;
        context.setLineDash([3, 4]);
        context.beginPath();
        context.moveTo(originX + scale * initial[0], originY - scale * initial[1]);
        context.lineTo(originX + scale * projection[0], originY - scale * projection[1]);
        context.stroke();
        context.setLineDash([]);
        drawVector(initial, colors.blue, 2.7, "P 不动", false);
      } else {
        drawVector(initial, colors.neutral, 1.3, "", true);
        drawVector(transformed, colors.blue, 2.7, "转后", false);
      }
      context.fillStyle = colors.ink;
      context.fillText("O", originX - 12, originY + 18);
      var result = vectorText(transformed);
      var interpretation = state.mode === "active"
        ? "转向量：v_after = R v_before = " + result + "。参考系不动，灰色虚线为转前向量。"
        : "换坐标：p¹ = Rᵀ p⁰ = " + result + "。P 不动，虚线本体轴旋转；读数沿本体轴计算。";
      canvas.setAttribute("aria-label", "绕 z 正转 " + state.angle + " 度。" + interpretation);
      readout.replaceChildren();
      readout.appendChild(el("p", null, "R = Rz(" + state.angle + "°)，列依次为 x′、y′、z′；矩阵元素无量纲。"));
      var tableHolder = el("div");
      tableHolder.innerHTML = matrixHTML(rotation.map(function (row) { return row.map(clean); }), 3);
      var table = tableHolder.querySelector("table");
      table.setAttribute("aria-label", "本体系三轴在参考系中的方向余弦矩阵 R");
      readout.appendChild(table);
      readout.appendChild(el("p", "rotation-result", interpretation));
      readout.appendChild(el("p", null, "输入与输出的模长均为 " + Math.hypot(initial[0], initial[1]).toFixed(3) + "；两种模式都保长，不能据此判断 R 与 Rᵀ 是否用反。"));
    }

    host.hidden = false;
    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  function mount(host, build) {
    if (document.createElement("canvas").getContext === undefined) {
      host.hidden = true;
      return;
    }
    var draw = build(host);
    host.classList.add("lab-ready");
    return draw;
  }

  /* 欧拉角（euler）与 DH 建系（dhframes）两个实验已升级为真 3D 版本
     （euler3d / dh3d），实现移至 theme/js/robot-labs-3d.js；相应的
     旋转矩阵与反解公式也一并并入该文件的数学内核。 */

  /* ---------------- 实验 2：平面 3R 机械臂的正运动学（DH 最小实例） ---------------- */
  function labArm(host) {
    var c = palette();
    var state = { q: [40, -35, 25], showTrace: true, L: [0.5, 0.4, 0.3] };
    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验"));
    head.appendChild(el("b", null, "平面 3R：把 DH 表连乘成末端位置"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "标准 DH：αᵢ = 0，aᵢ = lᵢ，dᵢ = 0。长度 m、滑条角度为度。三个当前轴变换逐次右乘，得到 T₃⁰ = A₁⁰A₂¹A₃²；末端方向角是 θ₁+θ₂+θ₃。先预测零位与第二角 90° 的位置，再操作并读数核对。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    var jointControls = ["θ₁", "θ₂", "θ₃"].map(function (label, index) {
      return slider(controls, label, -180, 180, 1, state.q[index], function (value) { state.q[index] = value; draw(); }, function (value) { return value.toFixed(0) + "°"; });
    });
    var reset = el("button", "lab-btn", "重置平面 3R");
    reset.type = "button";
    controls.appendChild(reset);
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
      /* 每次重绘都重新取色：调色板在 lab 创建时被缓存过，不刷新的话换了主题或
         纸张配色，画布仍是旧颜色（画布不跟着走，正是「两套系统」的观感来源）。 */
      c = palette();
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
      canvas.setAttribute("data-arm-points", JSON.stringify(fk.pts));
      canvas.setAttribute("data-arm-angle", String(fk.angle));
      var end = toScreen(fk.pts[3]);
      trace.push({ x: fk.pts[3].x, y: fk.pts[3].y });
      if (trace.length > 420) trace.shift();

      if (state.showTrace) {
        ctx.strokeStyle = c.accent;
        ctx.globalAlpha = 0.35;
        ctx.lineWidth = 1.6;
        ctx.beginPath();
        trace.forEach(function (point, i) {
          var projected = toScreen(point);
          if (i === 0) ctx.moveTo(projected.x, projected.y);
          else ctx.lineTo(projected.x, projected.y);
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
      html += "<table class='lab-matrix'><thead><tr><th>i</th><th>αᵢ</th><th>aᵢ</th><th>dᵢ</th><th>θᵢ</th></tr></thead><tbody>" +
        "<tr><td>1</td><td>0</td><td>" + state.L[0].toFixed(2) + "</td><td>0</td><td>" + state.q[0].toFixed(0) + "°</td></tr>" +
        "<tr><td>2</td><td>0</td><td>" + state.L[1].toFixed(2) + "</td><td>0</td><td>" + state.q[1].toFixed(0) + "°</td></tr>" +
        "<tr><td>3</td><td>0</td><td>" + state.L[2].toFixed(2) + "</td><td>0</td><td>" + state.q[2].toFixed(0) + "°</td></tr>" +
        "</tbody></table>";
      html += "<p class='lab-note'>系 3 原点就是工具点，无额外偏置。x = l₁c₁ + l₂c₁₂ + l₃c₁₂₃，y = l₁s₁ + l₂s₁₂ + l₃s₁₂₃；红色短线表示工具 x₃ 的朝向。</p>";
      readout.innerHTML = html;
      host.hidden = false;
    }

    reset.addEventListener("click", function () {
      state.q = [40, -35, 25];
      trace = [];
      jointControls.forEach(function (control, index) { control.input.value = state.q[index]; control.out.textContent = state.q[index] + "°"; });
      draw();
    });
    draw();
    window.addEventListener("resize", draw);
    return draw;
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

    /* LSPB 的峰值加速度：a_max = v_c / t_b。λ→0 时 t_b→0、a_max→∞，
       这是「加速段消失、速度阶跃」的退化极限，不是一个可用工况。 */
    function lspbA() {
      var vc = (1 + state.lambda) * d / state.T;
      var tb = state.T - d / vc;
      if (tb <= 1e-9) return Infinity;
      return vc / tb;
    }
    function lspbDegenerate() {
      var vc = (1 + state.lambda) * d / state.T;
      return (state.T - d / vc) <= 1e-9;
    }

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
      /* λ→0 是退化极限：加速时长 tb→0，速度阶跃，曲线退化为匀速。
         不特判会在这里除零出 NaN，整条曲线会被 canvas 丢掉。 */
      if (tb <= 1e-9) return { q: vc * t, v: vc, a: 0 };
      if (t <= tb) return { q: 0.5 * vc * t * t / tb, v: vc * t / tb, a: vc / tb };
      if (t >= T - tb) {
        var s = T - t;
        return { q: d - 0.5 * vc * s * s / tb, v: vc * s / tb, a: -vc / tb };
      }
      var qm = 0.5 * vc * tb + vc * (t - tb);
      return { q: qm, v: vc, a: 0 };
    }

    function draw() {
      /* 同上：每次重绘重新取色（本实验的 c 声明在 398 行） */
      c = palette();
      lam.input.disabled = state.kind !== "lspb";
      var s = fit(canvas, 0.62);
      var ctx = s.ctx, w = s.w, h = s.h;
      var padL = 46, padR = 12, padT = 16, gap = 10;
      var panelW = (w - padL - padR - gap * 2) / 3;
      var vmax = { cubic: 1.5 * d / state.T, quintic: 1.875 * d / state.T, lspb: (1 + state.lambda) * d / state.T }[state.kind];
      var amax = { cubic: 6 * d / (state.T * state.T), quintic: 5.7735 * d / (state.T * state.T), lspb: lspbA() }[state.kind];
      var titles = ["位置 q(t)（m）", "速度 v(t)（m/s）", "加速度 a(t)（m/s²）"];
      var keys = ["q", "v", "a"];
      /* 纵轴范围：amax 退化发散时（λ=0）用有限回退，否则面板刻度被 Infinity 毁掉 */
      var aPlot = isFinite(amax) ? amax : vmax * 5;
      var ranges = [[0, d * 1.06], [-vmax * 1.12, vmax * 1.12], [-aPlot * 1.12, aPlot * 1.12]];
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
      var apeak = { cubic: 6 * d / (state.T * state.T), quintic: 30 * Math.sqrt(3) / 9 * d / (state.T * state.T), lspb: lspbA() }[state.kind];
      var note = {
        cubic: "三次：v 两端为零，但 a 在 t=0 与 t=T 处跳到 ±6d/T² —— 实际机器会在起停瞬间「抖一下」。",
        quintic: "五次：a(0) = a(T) = 0，两端加速度连续（jerk 有限），代价是峰值加速度与峰值速度更高。",
        lspb: "LSPB：加速度是 ±a_max 的方波，速度是梯形。λ 越大巡航段越短；λ→1 时退化为抛物线混合（无匀速段）。"
      }[state.kind];
      var extra = state.kind === "lspb"
        ? "<p class='lab-note'>匀速段速度 v_c = (1+λ)·d/T = " + (((1 + state.lambda) * d / state.T).toFixed(3)) + " m/s，加减速时长 t_b = T − d/v_c = " + (state.T - d / ((1 + state.lambda) * d / state.T)).toFixed(3) + " s；λ 滑杆只对 LSPB 生效。</p>"
        : "";
      var apeakTxt = isFinite(apeak) ? apeak.toFixed(3) : "∞";
      var degenerate = state.kind === "lspb" && lspbDegenerate();
      readout.innerHTML = "<p><b>峰值速度</b> " + vpeak.toFixed(3) + " m/s &nbsp;·&nbsp; <b>峰值加速度</b> " + apeakTxt + " m/s²</p><p>" + note + "</p>" + extra +
        (degenerate ? "<p class='lab-warn'><b>λ = 0 是退化极限</b>：巡航速度降到 d/T，加速时长 t_b = T − d/v_c → 0，峰值加速度发散（速度阶跃），" +
          "曲线本身退化为匀速。实际轨迹不可用，请把 λ 调到 0.05 以上。</p>" : "");
    }

    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* 实验 4（dhframes · 拟人臂 DH 建系 2D 版）已升级为 3D 版 dh3d，
     见 theme/js/robot-labs-3d.js（帧朝向同时修正为与 2.9.4 的 T₃⁰ 第三列一致）。 */

  function labWorkspace2d(host) {
    var presets = {
      full: { title: "全转", limits: [[-180, 180], [-180, 180]] },
      elbow: { title: "肘限位", limits: [[-180, 180], [30, 150]] },
      both: { title: "双关节限位", limits: [[-60, 60], [-120, 120]] }
    };
    var state = { preset: "full", angles: [15, 70] };
    var cache;
    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互演示"));
    head.appendChild(el("b", null, "整个关节域怎样映到工作空间？"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "杆长 1 m、0.6 m；角度逆时针为正。左图横轴 q₁、纵轴 q₂，右图为位置（m）。蓝点：全域采样；橙线：关节域边界；红线：临界候选；紫点：当前位形与末端。采样只作观察，边界结论须用公式核对。"));
    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    var modeButtons = toggleGroup(controls, "限位预设", Object.keys(presets).map(function (key) {
      return { value: key, text: presets[key].title };
    }), state.preset, function (key) {
      state.preset = key;
      state.angles = [15, 70];
      buildSamples();
      syncControls();
      draw();
    });
    var angleControls = [0, 1].map(function (index) {
      return slider(controls, "关节角 q" + (index + 1), -180, 180, 1, state.angles[index], function (value) {
        state.angles[index] = value;
        draw();
      }, function (value) { return value + "°"; });
    });
    var reset = el("button", "lab-btn", "重置");
    reset.type = "button";
    reset.addEventListener("click", function () { modeButtons[0].click(); });
    controls.appendChild(reset);
    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "关节域到位置空间的映射，当前位形的数值见下方读数");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("role", "status");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);

    function position(angles) {
      var first = angles[0] * DEG, second = angles[1] * DEG;
      return [Math.cos(first) + 0.6 * Math.cos(first + second),
        Math.sin(first) + 0.6 * Math.sin(first + second)];
    }

    function buildSamples() {
      var limits = presets[state.preset].limits;
      cache = { samples: [], edges: [], critical: [] };
      for (var first = 0; first <= 72; first++) {
        for (var second = 0; second <= 72; second++) {
          cache.samples.push(position([
            limits[0][0] + (limits[0][1] - limits[0][0]) * first / 72,
            limits[1][0] + (limits[1][1] - limits[1][0]) * second / 72
          ]));
        }
      }
      [0, 1].forEach(function (fixed) {
        limits[fixed].forEach(function (value) {
          var joints = [], points = [], moving = 1 - fixed;
          for (var sample = 0; sample <= 160; sample++) {
            var angles = [0, 0];
            angles[fixed] = value;
            angles[moving] = limits[moving][0] + (limits[moving][1] - limits[moving][0]) * sample / 160;
            joints.push(angles);
            points.push(position(angles));
          }
          cache.edges.push({ joints: joints, points: points });
        });
      });
      [-180, 0, 180].forEach(function (value) {
        if (value < limits[1][0] || value > limits[1][1]) return;
        var joints = [], points = [];
        for (var sample = 0; sample <= 160; sample++) {
          var angles = [limits[0][0] + (limits[0][1] - limits[0][0]) * sample / 160, value];
          joints.push(angles);
          points.push(position(angles));
        }
        cache.critical.push({ joints: joints, points: points });
      });
    }

    function syncControls() {
      angleControls.forEach(function (control, index) {
        var limits = presets[state.preset].limits[index];
        control.input.min = limits[0];
        control.input.max = limits[1];
        control.input.value = state.angles[index];
        control.out.textContent = state.angles[index] + "°";
      });
    }

    function draw() {
      var surface = fit(canvas, 0.49);
      var ctx = surface.ctx, width = surface.w, height = surface.h, colors = surface.c;
      var limits = presets[state.preset].limits;
      var box = { x: 48, y: 42, size: Math.min(width * 0.36, height - 85) };
      var origin = [width * 0.76, box.y + box.size / 2];
      var unit = box.size / 3.6;
      function jointPixel(angles) {
        return [box.x + (angles[0] + 180) / 360 * box.size,
          box.y + (180 - angles[1]) / 360 * box.size];
      }
      function worldPixel(point) {
        return [origin[0] + point[0] * unit, origin[1] - point[1] * unit];
      }
      function dot(point, color, radius) {
        ctx.fillStyle = color;
        ctx.beginPath();
        ctx.arc(point[0], point[1], radius, 0, 2 * Math.PI);
        ctx.fill();
      }
      function line(points, transform, color, thickness, dashed) {
        ctx.strokeStyle = color;
        ctx.lineWidth = thickness;
        ctx.setLineDash(dashed ? [6, 4] : []);
        ctx.beginPath();
        points.forEach(function (point, index) {
          var pixel = transform(point);
          if (index === 0) ctx.moveTo(pixel[0], pixel[1]);
          else ctx.lineTo(pixel[0], pixel[1]);
        });
        ctx.stroke();
        ctx.setLineDash([]);
      }
      ctx.font = "12px " + cssVar("--sans");
      ctx.fillStyle = colors.ink;
      ctx.fillText("关节域 Q（°）", box.x, 22);
      ctx.fillText("位置像 p(Q)（m）", width * 0.56, 22);
      frame(ctx, box.x, box.y, box.x + box.size, box.y + box.size, colors);
      var lower = jointPixel([limits[0][0], limits[1][0]]);
      var upper = jointPixel([limits[0][1], limits[1][1]]);
      ctx.globalAlpha = 0.1;
      ctx.fillStyle = colors.blue;
      ctx.fillRect(lower[0], upper[1], upper[0] - lower[0], lower[1] - upper[1]);
      ctx.globalAlpha = 1;
      line([[-180, 0], [180, 0]], jointPixel, colors.line, 1);
      line([[0, -180], [0, 180]], jointPixel, colors.line, 1);
      line([[-1.75, 0], [1.75, 0]], worldPixel, colors.line, 1);
      line([[0, -1.75], [0, 1.75]], worldPixel, colors.line, 1);
      ctx.fillStyle = colors.muted;
      ctx.fillText("−180", box.x - 14, box.y + box.size + 19);
      ctx.fillText("180  q₁", box.x + box.size - 24, box.y + box.size + 19);
      ctx.fillText("q₂", box.x - 27, box.y - 8);
      ctx.fillText("180", box.x - 30, box.y + 5);
      ctx.fillText("−180", box.x - 37, box.y + box.size);
      ctx.fillText("0", box.x - 14, box.y + box.size / 2 + 4);
      ctx.fillText("0", origin[0] + 4, origin[1] + 14);
      ctx.fillText("1.6", origin[0] + 1.6 * unit - 8, origin[1] + 14);
      ctx.fillText("x", origin[0] + 1.75 * unit + 2, origin[1] + 4);
      ctx.fillText("y", origin[0] + 4, origin[1] - 1.75 * unit);
      ctx.globalAlpha = 0.28;
      ctx.fillStyle = colors.blue;
      cache.samples.forEach(function (point) {
        var pixel = worldPixel(point);
        ctx.fillRect(pixel[0] - 1, pixel[1] - 1, 2, 2);
      });
      ctx.globalAlpha = 1;
      cache.edges.forEach(function (edge) {
        line(edge.joints, jointPixel, colors.gold, 2);
        line(edge.points, worldPixel, colors.gold, 2);
      });
      cache.critical.forEach(function (critical) {
        line(critical.joints, jointPixel, colors.red, 2.2, true);
        line(critical.points, worldPixel, colors.red, 2.2, true);
      });
      var point = position(state.angles);
      var elbow = [Math.cos(state.angles[0] * DEG), Math.sin(state.angles[0] * DEG)];
      line([[0, 0], elbow, point], worldPixel, colors.ink, 3);
      dot(worldPixel([0, 0]), colors.ink, 3);
      dot(worldPixel(elbow), colors.ink, 4);
      dot(worldPixel(point), colors.purple, 5);
      dot(jointPixel(state.angles), colors.purple, 5);
      var radius = Math.hypot(point[0], point[1]);
      var determinant = 0.6 * Math.sin(state.angles[1] * DEG);
      var cosines = [Math.cos(limits[1][0] * DEG), Math.cos(limits[1][1] * DEG)];
      if (limits[1][0] <= 0 && limits[1][1] >= 0) cosines.push(1);
      var radialRange = [Math.sqrt(1.36 + 1.2 * Math.min.apply(null, cosines)),
        Math.sqrt(1.36 + 1.2 * Math.max.apply(null, cosines))];
      readout.textContent = presets[state.preset].title + "：q₁ ∈ [" + limits[0].join(", ") +
        "]°，q₂ ∈ [" + limits[1].join(", ") + "]°。当前 q = (" + state.angles.join(", ") +
        ")°；p = (" + point[0].toFixed(4) + ", " + point[1].toFixed(4) + ") m；ρ = " +
        radius.toFixed(4) + " m；det J = " + determinant.toFixed(4) +
        " m²/rad²。全域半径范围 [" + radialRange.map(function (value) { return value.toFixed(4); }).join(", ") +
        "] m" + (state.preset === "both" ? "（方位覆盖受限，不是整圆环）" : "（肩允许全转，覆盖整圆环）") +
        "。73×73 = " + cache.samples.length + " 个样本；" +
        (Math.abs(determinant) < 1e-10 ? "当前为位置奇异候选。" : "当前不是位置奇异位形。") +
        " 红线数量 " + cache.critical.length + "；橙线仅为边界候选，可能落在位置像内部。";
      host.setAttribute("data-workspace-values", JSON.stringify({
        preset: state.preset, angles: state.angles, limits: limits, point: point, elbow: elbow,
        radius: radius, determinant: determinant, radialRange: radialRange,
        sampleCount: cache.samples.length, criticalCount: cache.critical.length
      }));
    }
    buildSamples();
    syncControls();
    host.hidden = false;
    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  function labCalibration2d(host) {
    var state = { spread: "wide", count: 6, noise: 0 };
    var nominal = [1, .6], truth = [1.04, .57];
    var controls = el("div", "lab-controls");
    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互演示"));
    head.appendChild(el("b", null, "两连杆长度偏差：秩、条件数与验证"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "名义长度 (1.00, 0.60) m，真实长度 (1.04, 0.57) m；只估两个长度偏差。蓝点是训练位形，紫点是独立验证位形。"));
    host.appendChild(controls);
    var spreadButtons = toggleGroup(controls, "位形分布", [
      { value: "wide", text: "宽分布" }, { value: "narrow", text: "集中分布" }
    ], state.spread, function (value) { state.spread = value; draw(); });
    var countControl = slider(controls, "训练样本数", 2, 12, 1, state.count, function (value) {
      state.count = Math.round(value);
      draw();
    }, function (value) { return value + " 个"; });
    var noiseControl = slider(controls, "噪声 σ", 0, 2, .1, state.noise, function (value) {
      state.noise = value;
      draw();
    }, function (value) { return value.toFixed(1) + " mm"; });
    var reset = el("button", "lab-btn", "重置");
    reset.type = "button";
    reset.addEventListener("click", function () {
      state.spread = "wide"; state.count = 6; state.noise = 0;
      spreadButtons[0].click();
      countControl.input.value = "6"; countControl.out.textContent = "6 个";
      noiseControl.input.value = "0"; noiseControl.out.textContent = "0.0 mm";
      draw();
    });
    controls.appendChild(reset);
    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "两连杆长度参数标定示意，估计值与秩条件数见下方读数");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("role", "status");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);

    function measurementAngles(index) {
      if (state.spread === "wide") {
        var first = [-150, -90, -25, 35, 105, 160, -125, 65, 135, -45, 10, 80][index];
        var second = [35, 105, -70, 120, -40, 75, 150, -115, 55, -145, 85, -20][index];
        return [first, second];
      }
      return [20 + (index % 6 - 2.5) * .3, 1 + (index % 4 - 1.5) * .03];
    }
    function point(lengths, angles) {
      var first = angles[0] * DEG, second = angles[1] * DEG;
      return [lengths[0] * Math.cos(first) + lengths[1] * Math.cos(first + second),
        lengths[0] * Math.sin(first) + lengths[1] * Math.sin(first + second)];
    }
    function solve2x2(rows, values) {
      var aa = 0, ab = 0, bb = 0, ac = 0, bc = 0;
      rows.forEach(function (row, index) {
        var value = values[index];
        aa += row[0] * row[0]; ab += row[0] * row[1]; bb += row[1] * row[1];
        ac += row[0] * value; bc += row[1] * value;
      });
      var determinant = aa * bb - ab * ab;
      if (determinant <= 1e-14) return { estimate: [NaN, NaN], determinant: determinant, rank: 1, condition: Infinity };
      var estimate = [(bb * ac - ab * bc) / determinant, (aa * bc - ab * ac) / determinant];
      var trace = aa + bb, discriminant = Math.max(0, trace * trace - 4 * determinant);
      var largest = (trace + Math.sqrt(discriminant)) / 2;
      var smallest = (trace - Math.sqrt(discriminant)) / 2;
      return { estimate: estimate, determinant: determinant, rank: 2,
        condition: smallest > 0 ? Math.sqrt(largest / smallest) : Infinity };
    }
    function draw() {
      var surface = fit(canvas, .46), ctx = surface.ctx, width = surface.w, height = surface.h, colors = surface.c;
      var rows = [], residuals = [], samples = [];
      for (var index = 0; index < state.count; index++) {
        var angles = measurementAngles(index), first = angles[0] * DEG, second = angles[1] * DEG;
        var rowX = [Math.cos(first), Math.cos(first + second)];
        var rowY = [Math.sin(first), Math.sin(first + second)];
        var nominalPoint = point(nominal, angles), truePoint = point(truth, angles);
        var noiseX = state.noise / 1000 * Math.sin((index + 1) * 2.13);
        var noiseY = state.noise / 1000 * Math.cos((index + 1) * 1.71);
        rows.push(rowX, rowY);
        residuals.push(truePoint[0] - nominalPoint[0] + noiseX, truePoint[1] - nominalPoint[1] + noiseY);
        samples.push({ angles: angles, nominal: nominalPoint, measured: [truePoint[0] + noiseX, truePoint[1] + noiseY] });
      }
      var solved = solve2x2(rows, residuals), estimated = solved.estimate;
      var trainSquares = 0;
      samples.forEach(function (sample) {
        var prediction = point([nominal[0] + estimated[0], nominal[1] + estimated[1]], sample.angles);
        trainSquares += Math.pow(prediction[0] - sample.measured[0], 2) + Math.pow(prediction[1] - sample.measured[1], 2);
      });
      var validationAngles = state.spread === "wide" ? [42, -58] : [140, 100];
      var validationNominal = point([nominal[0] + estimated[0], nominal[1] + estimated[1]], validationAngles);
      var validationTruth = point(truth, validationAngles);
      var validationError = Math.hypot(validationNominal[0] - validationTruth[0], validationNominal[1] - validationTruth[1]);
      var trainingRms = Math.sqrt(trainSquares / Math.max(1, samples.length * 2));
      var plotOrigin = [width * .68, height * .54], scale = Math.min(width * .16, height * .28);
      function pixel(pointValue) { return [plotOrigin[0] + pointValue[0] * scale, plotOrigin[1] - pointValue[1] * scale]; }
      function mark(pointValue, color, radius) {
        var location = pixel(pointValue); ctx.fillStyle = color; ctx.beginPath(); ctx.arc(location[0], location[1], radius, 0, 2 * Math.PI); ctx.fill();
      }
      ctx.font = "12px " + cssVar("--sans"); ctx.fillStyle = colors.ink;
      ctx.fillText("量测位置（m）", width * .54, 20); ctx.fillText("参数修正", 16, 20);
      frame(ctx, width * .54, 34, width - 18, height - 18, colors);
      var lineAxis = function (first, second) { ctx.strokeStyle = colors.line; ctx.lineWidth = 1; ctx.beginPath(); ctx.moveTo(first[0], first[1]); ctx.lineTo(second[0], second[1]); ctx.stroke(); };
      lineAxis([plotOrigin[0] - 1.65 * scale, plotOrigin[1]], [plotOrigin[0] + 1.65 * scale, plotOrigin[1]]);
      lineAxis([plotOrigin[0], plotOrigin[1] - 1.65 * scale], [plotOrigin[0], plotOrigin[1] + 1.65 * scale]);
      samples.forEach(function (sample) { mark(sample.measured, colors.blue, 3); });
      mark(validationTruth, colors.purple, 5);
      mark(validationNominal, colors.gold, 5);
      ctx.fillStyle = colors.muted; ctx.fillText("蓝：训练量测", width * .54 + 8, height - 23);
      ctx.fillText("紫：验证真值，金：校准模型", width * .54 + 110, height - 23);
      var bars = [estimated[0], estimated[1], .04, -.03];
      var labels = ["估计 Δa₁", "估计 Δa₂", "真值 Δa₁", "真值 Δa₂"];
      var maxBar = .06, barX = 35, barBase = height - 42, barWidth = 34;
      bars.forEach(function (value, index) {
        var x = barX + index * 46, barHeight = Math.min(95, Math.abs(value) / maxBar * 95);
        ctx.fillStyle = index < 2 ? colors.blue : colors.gold;
        ctx.fillRect(x, value >= 0 ? barBase - barHeight : barBase, barWidth, barHeight);
        ctx.fillStyle = colors.muted; ctx.fillText(labels[index], x - 8, barBase + 17);
        ctx.fillText(isFinite(value) ? value.toFixed(3) : "—", x + 3, value >= 0 ? barBase - barHeight - 4 : barBase + barHeight + 13);
      });
      var text = (state.spread === "wide" ? "宽分布" : "集中分布") + "，训练样本 " + state.count +
        "，σ = " + state.noise.toFixed(1) + " mm。估计 Δa = (" +
        (isFinite(estimated[0]) ? estimated[0].toFixed(4) : "—") + ", " +
        (isFinite(estimated[1]) ? estimated[1].toFixed(4) : "—") + ") m；真值 = (0.0400, −0.0300) m。秩 = " +
        solved.rank + " / 2，条件数 ≈ " + (isFinite(solved.condition) ? solved.condition.toFixed(1) : "∞") +
        "；训练 RMS = " + (trainingRms * 1000).toFixed(3) + " mm；验证误差 = " +
        (validationError * 1000).toFixed(3) + " mm。" +
        (solved.rank < 2 ? "当前数据不足以唯一估计两个参数。" :
          solved.condition > 100 ? "列近相关，噪声会被明显放大。" :
          "当前数据对两个长度偏差可辨识；仍需用其他位形验证。");
      readout.textContent = text;
      host.setAttribute("data-calibration-values", JSON.stringify({
        spread: state.spread, count: state.count, noise: state.noise, estimate: estimated,
        truth: [.04, -.03], rank: solved.rank, condition: solved.condition,
        trainingRms: trainingRms, validationError: validationError, sampleCount: samples.length
      }));
    }
    host.hidden = false;
    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  function labRotationDerivative(host) {
    var state = { angle: 90, rate: 2, step: 0.5 };
    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "旋转导数实验"));
    head.appendChild(el("b", null, "圆弧、切线与反对称矩阵"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "杆长 1 m，绕固定 +z 轴转动。蓝色是当前杆，绿色是精确旋转后的圆弧点，红色是 p+h·ṗ 的切线预测；h 越小，两者越接近。"));
    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    var specs = [
      ["angle", "当前角度", -180, 180, 1, "°"],
      ["rate", "角速度", -4, 4, 0.1, " rad/s"],
      ["step", "步长 h", 0.01, 1, 0.01, " s"]
    ];
    var sliders = specs.map(function (spec) {
      return slider(controls, spec[1], spec[2], spec[3], spec[4], state[spec[0]], function (value) {
        state[spec[0]] = value;
        draw();
      }, function (value) { return value + spec[5]; });
    });
    var reset = el("button", "lab-btn", "重置");
    reset.type = "button";
    reset.addEventListener("click", function () {
      state = { angle: 90, rate: 2, step: 0.5 };
      specs.forEach(function (spec, index) {
        sliders[index].input.value = state[spec[0]];
        sliders[index].out.textContent = state[spec[0]] + spec[5];
      });
      draw();
    });
    controls.appendChild(reset);
    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    host.appendChild(canvas);
    var matrices = el("div", "lab-readout");
    host.appendChild(matrices);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    readout.setAttribute("aria-atomic", "true");
    host.appendChild(readout);

    function draw() {
      var angle = state.angle * DEG;
      var delta = state.rate * state.step;
      var p = [Math.cos(angle), Math.sin(angle)];
      var dp = [-state.rate * Math.sin(angle), state.rate * Math.cos(angle)];
      var exact = [Math.cos(angle + delta), Math.sin(angle + delta)];
      var tangent = [p[0] + state.step * dp[0], p[1] + state.step * dp[1]];
      var fitted = fit(canvas, 0.62);
      var ctx = fitted.ctx;
      var color = fitted.c;
      var cx = fitted.w * 0.5;
      var cy = fitted.h * 0.55;
      var extent = Math.max(1.3, Math.abs(tangent[0]) + 0.25, Math.abs(tangent[1]) + 0.25);
      var scale = Math.min((fitted.w - 50) / (2 * extent), (fitted.h - 115) / (2 * extent));
      function pixel(point) { return [cx + point[0] * scale, cy - point[1] * scale]; }
      function line(a, b, stroke, width, dashed) {
        var from = pixel(a), to = pixel(b);
        ctx.strokeStyle = stroke;
        ctx.lineWidth = width;
        ctx.setLineDash(dashed ? [6, 5] : []);
        ctx.beginPath(); ctx.moveTo(from[0], from[1]); ctx.lineTo(to[0], to[1]); ctx.stroke();
        ctx.setLineDash([]);
      }
      ctx.strokeStyle = color.line;
      ctx.lineWidth = 1;
      ctx.beginPath(); ctx.arc(cx, cy, scale, 0, Math.PI * 2); ctx.stroke();
      line([-1.25, 0], [1.25, 0], color.line, 1);
      line([0, -1.25], [0, 1.25], color.line, 1);
      line([0, 0], p, color.blue, 4);
      line([0, 0], exact, color.green, 2);
      line([0, 0], tangent, color.red, 1, true);
      var pp = pixel(p), ep = pixel(exact), tp = pixel(tangent);
      if (Math.abs(delta) > 0.000001) {
        ctx.strokeStyle = color.green;
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.arc(cx, cy, scale, -angle, -angle - delta, delta > 0);
        ctx.stroke();
        arrow(ctx, pp[0], pp[1], tp[0], tp[1], color.red, 2);
      }
      line(exact, tangent, color.gold, 1.5, true);
      [[pp, color.blue], [ep, color.green], [tp, color.red]].forEach(function (item) {
        ctx.fillStyle = item[1]; ctx.beginPath(); ctx.arc(item[0][0], item[0][1], 5, 0, Math.PI * 2); ctx.fill();
      });
      ctx.fillStyle = color.ink; ctx.font = "12px sans-serif";
      ctx.fillText("单位圆：‖p‖ = 1 m", 14, 20);
      ctx.fillText("绿色 = exp(hS)p；红色 = (I+hS)p", 14, 38);
      var error = Math.hypot(exact[0] - tangent[0], exact[1] - tangent[1]);
      var normError = Math.abs(Math.hypot(tangent[0], tangent[1]) - 1);
      var rotation = [[p[0], -p[1], 0], [p[1], p[0], 0], [0, 0, 1]];
      var derivative = [[dp[0], -dp[1], 0], [dp[1], dp[0], 0], [0, 0, 0]];
      var skew = [[0, -state.rate, 0], [state.rate, 0, 0], [0, 0, 0]];
      matrices.innerHTML = "<div>R（姿态）" + matrixHTML(rotation) + "</div><div>Ṙ（每秒）" + matrixHTML(derivative) + "</div><div>ṘRᵀ = S(ω)（每秒）" + matrixHTML(skew) + "</div>";
      readout.textContent = "p = (" + p.map(function (value) { return value.toFixed(3); }).join(", ") + ") m；ṗ = (" + dp.map(function (value) { return value.toFixed(3); }).join(", ") + ") m/s；精确与切线相差 " + error.toFixed(4) + " m；切线长度误差 " + normError.toFixed(4) + " m；欧拉更新的正交误差最大元素 (hωz)² = " + (delta * delta).toFixed(4) + "。";
      canvas.setAttribute("aria-label", "旋转导数演示：当前向量、指数映射精确点与欧拉切线点");
      host.setAttribute("data-rotation-values", JSON.stringify({ state: state, p: p, derivative: dp, exact: exact, tangent: tangent, error: error, normError: normError, rotation: rotation, rotationDerivative: derivative, skew: skew, orthogonalityError: delta * delta }));
    }
    host.hidden = false;
    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  function labJacobian2d(host) {
    var state = { q1: 0, q2: 90, rate1: 0, rate2: 1, tool: 0 };
    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "速度实验"));
    head.appendChild(el("b", null, "每个关节贡献多少末端速度？"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "两杆各 1 m，工具沿第二杆延长；+z 出纸面，逆时针为正。蓝色是关节 1 的贡献，红色是关节 2 的贡献，绿色是总速度。虚线把两贡献首尾相接；零贡献不画箭头。"));
    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    var controlList = [
      ["q1", "关节角 q₁", -180, 180, 1, "°"],
      ["q2", "关节角 q₂", -180, 180, 1, "°"],
      ["rate1", "关节速度 q̇₁", -2, 2, 0.1, " rad/s"],
      ["rate2", "关节速度 q̇₂", -2, 2, 0.1, " rad/s"],
      ["tool", "工具长度", 0, 0.5, 0.05, " m"]
    ];
    var sliders = controlList.map(function (spec) {
      return slider(controls, spec[1], spec[2], spec[3], spec[4], state[spec[0]], function (value) {
        state[spec[0]] = value;
        draw();
      }, function (value) { return value + spec[5]; });
    });
    function setPreset(q1, q2, rate1, rate2) {
      state = { q1: q1, q2: q2, rate1: rate1, rate2: rate2, tool: 0 };
      controlList.forEach(function (spec, index) {
        sliders[index].input.value = state[spec[0]];
        sliders[index].out.textContent = state[spec[0]] + spec[5];
      });
      draw();
    }
    [
      ["只动关节 2", function () { setPreset(0, 90, 0, 1); }],
      ["角速度抵消", function () { setPreset(0, 90, 1, -1); }],
      ["伸直位形", function () { setPreset(0, 0, 1, -1); }],
      ["重置", function () { setPreset(0, 90, 0, 1); }]
    ].forEach(function (preset) {
      var button = el("button", "lab-btn", preset[0]);
      button.type = "button";
      button.addEventListener("click", preset[1]);
      controls.appendChild(button);
    });
    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    host.appendChild(canvas);
    var matrix = el("div", "lab-readout");
    host.appendChild(matrix);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    readout.setAttribute("aria-atomic", "true");
    host.appendChild(readout);

    function position(q1, q2) {
      return [Math.cos(q1) + (1 + state.tool) * Math.cos(q1 + q2),
        Math.sin(q1) + (1 + state.tool) * Math.sin(q1 + q2)];
    }
    function clean(value) { return Math.abs(value) < 0.0000001 ? 0 : value; }
    function pair(vector) { return "(" + vector.map(function (value) { return clean(value).toFixed(3); }).join(", ") + ")"; }

    function draw() {
      var q1 = state.q1 * DEG;
      var q2 = state.q2 * DEG;
      var elbow = [Math.cos(q1), Math.sin(q1)];
      var wrist = [elbow[0] + Math.cos(q1 + q2), elbow[1] + Math.sin(q1 + q2)];
      var tip = position(q1, q2);
      var columns = [[-tip[1], tip[0]], [elbow[1] - tip[1], tip[0] - elbow[0]]];
      var first = columns[0].map(function (value) { return value * state.rate1; });
      var second = columns[1].map(function (value) { return value * state.rate2; });
      var total = first.map(function (value, index) { return value + second[index]; });
      var step = 0.000001;
      var plus = position(q1 + step * state.rate1, q2 + step * state.rate2);
      var minus = position(q1 - step * state.rate1, q2 - step * state.rate2);
      var difference = plus.map(function (value, index) { return (value - minus[index]) / (2 * step); });
      var error = Math.hypot(total[0] - difference[0], total[1] - difference[1]);
      var omega = state.rate1 + state.rate2;
      var endFirst = tip.map(function (value, index) { return value + 0.45 * first[index]; });
      var endSecond = tip.map(function (value, index) { return value + 0.45 * second[index]; });
      var endTotal = tip.map(function (value, index) { return value + 0.45 * total[index]; });
      var fitted = fit(canvas, 0.64);
      var ctx = fitted.ctx;
      var color = fitted.c;
      var points = [[0, 0], elbow, wrist, tip, endFirst, endSecond, endTotal];
      var xs = points.map(function (point) { return point[0]; });
      var ys = points.map(function (point) { return point[1]; });
      var left = Math.min.apply(null, xs) - 0.45;
      var right = Math.max.apply(null, xs) + 0.45;
      var bottom = Math.min.apply(null, ys) - 0.45;
      var top = Math.max.apply(null, ys) + 0.45;
      var scale = Math.min((fitted.w - 50) / (right - left), (fitted.h - 100) / (top - bottom));
      var centerX = (left + right) / 2;
      var centerY = (top + bottom) / 2;
      function pixel(point) {
        return [fitted.w / 2 + (point[0] - centerX) * scale,
          (fitted.h + 40) / 2 - (point[1] - centerY) * scale];
      }
      function segment(start, end, stroke, width, dashed) {
        var from = pixel(start);
        var to = pixel(end);
        ctx.setLineDash(dashed ? [5, 5] : []);
        ctx.strokeStyle = stroke;
        ctx.lineWidth = width;
        ctx.beginPath();
        ctx.moveTo(from[0], from[1]);
        ctx.lineTo(to[0], to[1]);
        ctx.stroke();
        ctx.setLineDash([]);
      }
      function vector(end, stroke, width) {
        var start = pixel(tip);
        var finish = pixel(end);
        if (Math.hypot(finish[0] - start[0], finish[1] - start[1]) > 0.001) {
          arrow(ctx, start[0], start[1], finish[0], finish[1], stroke, width);
        }
      }
      ctx.font = "12px sans-serif";
      ctx.fillStyle = color.ink;
      ctx.fillText("+x →  +y ↑  +ωz 出纸面；ωz = " + clean(omega).toFixed(2) + " rad/s", 16, 22);
      ctx.strokeStyle = color.ink2;
      ctx.lineWidth = 2;
      ctx.beginPath();
      ctx.moveTo(16, 44);
      ctx.lineTo(16 + scale * 0.5, 44);
      ctx.stroke();
      ctx.fillText("0.5 m 杆长", 22 + scale * 0.5, 48);
      ctx.strokeStyle = color.green;
      ctx.beginPath();
      ctx.moveTo(fitted.w / 2, 44);
      ctx.lineTo(fitted.w / 2 + 0.45 * scale, 44);
      ctx.stroke();
      ctx.fillText("1 m/s 速度", fitted.w / 2 + 0.45 * scale + 6, 48);
      segment([0, 0], elbow, color.ink2, 6);
      segment(elbow, wrist, color.accent, 6);
      if (state.tool > 0) segment(wrist, tip, color.gold, 5, true);
      segment(endFirst, endTotal, color.red, 1.5, true);
      segment(endSecond, endTotal, color.blue, 1.5, true);
      vector(endFirst, color.blue, 2);
      vector(endSecond, color.red, 2);
      vector(endTotal, color.green, 3);
      [["O", [0, 0]], ["关节 2", elbow], ["TCP", tip]].forEach(function (item) {
        var point = pixel(item[1]);
        ctx.fillStyle = color.paper;
        ctx.strokeStyle = color.ink;
        ctx.lineWidth = 1.5;
        ctx.beginPath();
        ctx.arc(point[0], point[1], 5, 0, Math.PI * 2);
        ctx.fill();
        ctx.stroke();
        ctx.fillStyle = color.ink;
        ctx.fillText(item[0], point[0] + 9, point[1] + 18);
      });
      matrix.innerHTML = matrixHTML([
        ["J 的有效行", "关节 1", "关节 2"],
        ["vₓ", clean(columns[0][0]), clean(columns[1][0])],
        ["vᵧ", clean(columns[0][1]), clean(columns[1][1])],
        ["ωz", 1, 1]
      ]) + "<p>完整 J 为 6×2，v_z、ωx、ωy 三行恒为零；位置块列单位 m/rad，角速度块列单位为 1。</p>";
      readout.textContent = "关节 1 贡献 " + pair(first) + " m/s；关节 2 贡献 " + pair(second) +
        " m/s；总线速度 " + pair(total) + " m/s；ωz = " + clean(omega).toFixed(3) +
        " rad/s。位置中心差分 " + pair(difference) + " m/s；差分与 Jq̇ 的误差 " + error.toExponential(2) + " m/s。";
      canvas.setAttribute("aria-label", "平面两连杆速度分解：关节 1 贡献 " + pair(first) +
        "，关节 2 贡献 " + pair(second) + "，总线速度 " + pair(total) + " m/s，角速度 " + clean(omega) + " rad/s");
      host.setAttribute("data-jacobian-values", JSON.stringify({
        state: state, columns: columns, first: first, second: second, total: total,
        omega: omega, difference: difference, error: error, tip: tip
      }));
    }
    host.hidden = false;
    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  function labNullspace2d(host) {
    var angle = 0;
    var head = el('div', 'lab-head');
    head.appendChild(el('span', 'lab-tag', '自运动实验'));
    head.appendChild(el('b', null, '固定笔尖的曲线，与初始零空间的切线'));
    host.appendChild(head);
    host.appendChild(el('p', 'lab-note', '三杆各1 m，目标笔尖(2,1) m。蓝色按逆解重新配置，红色虚线只作一次 q* + φb 更新；两者有相同末杆朝向。灰色为初始构形。'));
    var controls = el('div', 'lab-controls');
    host.appendChild(controls);
    var control = slider(controls, '末杆绝对角 φ', 0, 60, 0.01, 0, function (value) { angle = value; draw(); }, function (value) { return value.toFixed(2) + '°'; });
    [['0.1 rad', 0.1 / DEG], ['0.2 rad', 0.2 / DEG], ['30°', 30], ['60°', 60], ['重置', 0]].forEach(function (preset) {
      var button = el('button', 'lab-btn', preset[0]);
      button.type = 'button';
      button.addEventListener('click', function () {
        control.input.value = preset[1];
        angle = preset[1];
        control.out.textContent = angle.toFixed(2) + '°';
        draw();
      });
      controls.appendChild(button);
    });
    var canvas = el('canvas', 'lab-canvas');
    canvas.setAttribute('role', 'img');
    canvas.setAttribute('aria-label', '等长三杆自运动：蓝色精确曲线保持笔尖，红色切线更新产生漂移');
    host.appendChild(canvas);
    var readout = el('div', 'lab-readout');
    readout.setAttribute('aria-live', 'polite');
    host.appendChild(readout);
    function points(q) {
      var result = [[0, 0]], orientation = 0;
      q.forEach(function (value) {
        orientation += value;
        var previous = result[result.length - 1];
        result.push([previous[0] + Math.cos(orientation), previous[1] + Math.sin(orientation)]);
      });
      return result;
    }
    function format(value) { return (Math.abs(value) < 0.00000005 ? 0 : value).toFixed(5); }
    function vector(values) { return '(' + values.map(format).join(', ') + ')'; }
    function draw() {
      var phi = angle * DEG;
      var wrist = [2 - Math.cos(phi), 1 - Math.sin(phi)];
      var cosine = (wrist[0] * wrist[0] + wrist[1] * wrist[1] - 2) / 2;
      var q2 = Math.acos(cosine);
      var q1 = Math.atan2(wrist[1], wrist[0]) - Math.atan2(Math.sin(q2), 1 + cosine);
      var exact = [q1, q2, phi - q1 - q2];
      var tangent = [-phi, Math.PI / 2 + phi, -Math.PI / 2 + phi];
      var exactPoints = points(exact), tangentPoints = points(tangent), initialPoints = points([0, Math.PI / 2, -Math.PI / 2]);
      var exactError = Math.hypot(exactPoints[3][0] - 2, exactPoints[3][1] - 1);
      var tangentError = Math.hypot(tangentPoints[3][0] - 2, tangentPoints[3][1] - 1);
      var fitted = fit(canvas, 0.64), ctx = fitted.ctx, c = fitted.c;
      var scale = Math.min((fitted.w - 90) / 3, (fitted.h - 100) / 3);
      function pixel(p) { return [45 + (p[0] + 0.25) * scale, fitted.h / 2 + (0.15 - p[1]) * scale]; }
      function chain(list, color, width, dashed) {
        ctx.strokeStyle = color; ctx.lineWidth = width; ctx.setLineDash(dashed ? [7, 5] : []);
        ctx.beginPath();
        list.forEach(function (p, i) { var v = pixel(p); if (i === 0) ctx.moveTo(v[0], v[1]); else ctx.lineTo(v[0], v[1]); });
        ctx.stroke(); ctx.setLineDash([]);
        list.forEach(function (p) { var v = pixel(p); ctx.fillStyle = color; ctx.beginPath(); ctx.arc(v[0], v[1], width + 1, 0, Math.PI * 2); ctx.fill(); });
      }
      ctx.font = '13px sans-serif'; ctx.fillStyle = c.ink;
      ctx.fillText('+x →  +y ↑；各杆长1 m；φ = ' + angle.toFixed(2) + '°', 16, 24);
      ctx.strokeStyle = c.gold; ctx.setLineDash([4, 5]); ctx.lineWidth = 1;
      ctx.beginPath();
      for (var degree = 0; degree <= 60; degree++) {
        var a = degree * DEG, point = pixel([2 - Math.cos(a), 1 - Math.sin(a)]);
        if (degree === 0) ctx.moveTo(point[0], point[1]); else ctx.lineTo(point[0], point[1]);
      }
      ctx.stroke(); ctx.setLineDash([]);
      chain(initialPoints, c.muted, 1.5, true);
      chain(tangentPoints, c.red, 3, true);
      chain(exactPoints, c.blue, 4, false);
      var fixed = pixel([2, 1]); ctx.strokeStyle = c.green; ctx.lineWidth = 2; ctx.beginPath(); ctx.arc(fixed[0], fixed[1], 9, 0, Math.PI * 2); ctx.stroke();
      ctx.fillStyle = c.ink; ctx.fillText('固定目标 (2,1)', fixed[0] - 90, fixed[1] - 20);
      if (tangentError > 0.001) { var tip = pixel(tangentPoints[3]); ctx.fillStyle = c.red; ctx.fillText('切线更新笔尖', tip[0] - 40, tip[1] + 24); }
      ctx.fillStyle = c.gold; ctx.fillText('金色虚线：精确腕点轨迹', 16, fitted.h - 16);
      readout.innerHTML = matrixHTML([
        ['构形', 'q₁ (°)', 'q₂ (°)', 'q₃ (°)'],
        ['精确自运动'].concat(exact.map(function (value) { return value / DEG; })),
        ['一次切线更新'].concat(tangent.map(function (value) { return value / DEG; }))
      ], 5);
      readout.appendChild(el('p', null, '精确笔尖 ' + vector(exactPoints[3]) + ' m；位置误差 ' + exactError.toExponential(2) + ' m。'));
      readout.appendChild(el('p', null, '切线更新笔尖 ' + vector(tangentPoints[3]) + ' m；位置误差 ' + format(tangentError) + ' m；理论值 2(1−cosφ) = ' + format(2 * (1 - Math.cos(phi))) + ' m。'));
      readout.appendChild(el('p', 'lab-note', '两种构形的末杆朝向均为 ' + angle.toFixed(2) + '°。只有位置被固定，朝向未受约束；这不是恒定速度的运动动画。'));
      host.setAttribute('data-nullspace-values', JSON.stringify({ phi: phi, exact: exact, tangent: tangent, exactPoints: exactPoints, tangentPoints: tangentPoints, exactError: exactError, tangentError: tangentError }));
    }
    host.hidden = false; draw(); window.addEventListener('resize', draw); return draw;
  }

  /* ---------------- 主题 / 纸张配色变化 → 全部重绘 ----------------
   * 四个实验的取色都发生在 draw() 里（fit() 会调 palette()），所以换主题或换纸张
   * 配色后必须重画一次，否则画布会停在旧配色上——那是「两套系统」的观感来源之一。
   * mdBook 换主题改写根元素 class，纸张配色改写根元素 data-palette，两者都盯。
   */
  var redraws = [];
  function watchRepaint() {
    if (!window.MutationObserver) return;
    new MutationObserver(function () {
      redraws.forEach(function (fn) { try { fn(); } catch (error) { /* 单个实验出错不影响其余 */ } });
    }).observe(document.documentElement, {
      attributes: true,
      attributeFilter: ["class", "style", "data-palette"]
    });
  }

  /* ---------------- 引导 ---------------- */
  function boot() {
    var hosts = document.querySelectorAll("[data-lab]");
    if (hosts.length === 0) return;
    var registry = { nullspace2d: labNullspace2d, arm: labArm, traj: labTraj, rotation2d: labRotation2d, workspace2d: labWorkspace2d, calibration2d: labCalibration2d, rotationDerivative: labRotationDerivative, jacobian2d: labJacobian2d };
    Array.prototype.forEach.call(hosts, function (host) {
      var name = host.getAttribute("data-lab");
      var builder = registry[name];
      if (builder === undefined) return;
      try {
        var draw = mount(host, builder);
        if (typeof draw === "function") redraws.push(draw);
      } catch (error) {
        host.hidden = true;
      }
    });
  }

  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", boot);
  else boot();
  watchRepaint();
})();
