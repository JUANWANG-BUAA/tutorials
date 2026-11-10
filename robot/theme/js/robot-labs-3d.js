/* 机器人教程 · 3D 交互实验运行时（渐进增强：没有 canvas 时整块隐藏，不影响正文）。
   约定与 robot-labs.js 相同：内容里只放 <div class="lab" data-lab="xxx" data-...></div>，
   本文件负责生成控件、3D 画布与读数；样式全部走 theme/css/robot.css 的 .lab-* 类。

   与 2D 实验文件分工：本文件只登记 3D 实验（zoo3d / euler3d / dh3d / …），
   平面俯视类实验（arm / traj）仍由 robot-labs.js 提供。

   3D 引擎：手写轨道相机（拖拽旋转 / 滚轮缩放）+ 透视投影 + 画家算法深度排序 +
   Lambert 平面着色，不依赖任何外部库；配色每次重绘从 CSS 变量取（换主题即重画）。
   数学内核（向量 / DH / 欧拉角 / 雅可比）写成纯函数并在文件尾部暴露给 node
   （tools/check_labs3d_math.mjs 用书中已验证的闭式解对拍）。 */
(function () {
  "use strict";

  var DEG = Math.PI / 180;

  /* ================= 基础 DOM / 画布工具（与 robot-labs.js 同一套约定） ================= */


  /* 运行时注入的文字不经过 KaTeX（构建期才渲染），所以这里把常用的 LaTeX 片段
     翻成等价的 Unicode/纯文本，避免读者看到 b₁₁ 这样的源码。 */
  var SUB = { "0": "₀", "1": "₁", "2": "₂", "3": "₃", "4": "₄", "5": "₅", "6": "₆", "7": "₇", "8": "₈", "9": "₉",
    "a": "ₐ", "e": "ₑ", "i": "ᵢ", "j": "ⱼ", "k": "ₖ", "m": "ₘ", "n": "ₙ", "o": "ₒ", "p": "ₚ", "r": "ᵣ", "s": "ₛ",
    "t": "ₜ", "u": "ᵤ", "v": "ᵥ", "x": "ₓ", "-": "₋", "+": "₊", "=": "₌", "(": "₍", ")": "₎" };
  var SUP = { "0": "⁰", "1": "¹", "2": "²", "3": "³", "4": "⁴", "5": "⁵", "6": "⁶", "7": "⁷", "8": "⁸", "9": "⁹",
    "T": "ᵀ", "n": "ⁿ", "i": "ⁱ", "+": "⁺", "-": "⁻", "(": "⁽", ")": "⁾" };
  function subText(s) {
    return s.split("").map(function (ch) { return SUB[ch] || ch; }).join("");
  }
  function supText(s) {
    return s.split("").map(function (ch) { return SUP[ch] || ch; }).join("");
  }
  /* 只处理本教程用到的 LaTeX 子集：希腊字母、下标上标、根号、关系符。 */
  /* 规则表里的每一项都是「正则源码字符串」：注意 JS 字符串字面量里一个反斜杠
     会被吃掉（"\s" → "s"），所以文件里必须写成两个（"\\s"）。 */
  /* 规则表里的每项是「正则源码字符串」。注意两层转义：
     文件里 2 个反斜杠 → JS 字符串值 1 个 → 正则里表示「可选的字面反斜杠」，
     所以命令规则匹配的是命令名本身（vartheta → ϑ），残留的反斜杠由表尾的清理规则删掉。 */
  /* 规则表里的每项是「正则源码字符串」。注意两层转义：
     文件里 2 个反斜杠 → JS 字符串值 1 个 → 正则里表示「可选的字面反斜杠」，
     所以命令规则匹配的是命令名本身（vartheta → ϑ），残留的反斜杠由表尾的清理规则删掉。 */
  /* 规则表里的每项是「正则源码字符串」。注意两层转义：
     文件里 2 个反斜杠 → JS 字符串值 1 个 → 正则里表示「可选的字面反斜杠」，
     所以命令规则匹配的是命令名本身（vartheta → ϑ），残留的反斜杠由表尾的清理规则删掉。 */
  var TEX_RULES = [
    ["\\\\operatorname{([^}]*)}", function (m) { return m[1]; }],
    ["\\\\mathrm{([^}]*)}", function (m) { return m[1]; }],
    ["\\\\mathbf\\\\*", ""],
    ["\\\\bar\\\\s*([A-Za-z])", function (m) { return m[1] + "̇"; }],
    ["\\\\text{([^}]*)}", function (m) { return m[1]; }],
    ["\\\\dot\\\\s*([A-Za-z])", function (m) { return m[1] + "̇"; }],
    ["\\\\cdot", "·"], ["\\\\times", "×"], ["\\\\pm", "±"],
    ["\\\\le(?![a-zA-Z])", "≤"], ["\\\\ge(?![a-zA-Z])", "≥"],
    ["\\\\ne(?![a-zA-Z])", "≠"], ["\\\\approx", "≈"], ["\\\\equiv", "≡"],
    ["\\\\sqrt{([^}]*)}", function (m) { return "√(" + m[1] + ")"; }],
    ["\\\\vartheta", "ϑ"], ["\\\\varphi", "φ"], ["\\\\theta", "θ"],
    ["\\\\phi", "φ"], ["\\\\psi", "ψ"], ["\\\\alpha", "α"], ["\\\\beta", "β"],
    ["\\\\gamma", "γ"], ["\\\\omega", "ω"], ["\\\\lambda", "λ"], ["\\\\Delta", "Δ"],
    ["\\\\ell", "ℓ"], ["\\\\sigma", "σ"], ["\\\\mu", "μ"], ["\\\\tau", "τ"],
    ["\\\\det", "det"], ["\\\\cot", "cot"], ["\\\\tan", "tan"],
    ["\\\\sin", "sin"], ["\\\\cos", "cos"], ["\\\\log", "log"],
    ["\\\\quad", " "], ["\\\\qquad", " "],
    ["\\\\", ""]
  ];
  function texInline(t) {
    var out = t;
    TEX_RULES.forEach(function (rule) {
      var re = new RegExp(rule[0], "g");
      out = out.replace(re, rule[1]);
    });
    return out
      .replace(/_\{([^}]*)\}/g, function (_, inner) { return subText(inner); })
      .replace(/\^\{([^}]*)\}/g, function (_, inner) { return supText(inner); })
      .replace(/_([A-Za-z0-9])/g, function (_, ch) { return SUB[ch] || ("_" + ch); })
      .replace(/\^([A-Za-z0-9])/g, function (_, ch) { return SUP[ch] || ("^" + ch); });
  }
  function texLite(s) {
    return String(s).replace(/[$]([^$]+)[$]/g, function (_, inner) { return texInline(inner); });
  }

  function el(tag, cls, text) {
    var node = document.createElement(tag);
    if (cls) node.className = cls;
    if (text !== undefined && text !== null) node.textContent = texLite(text);
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
      neutral: cssVar("--fig-neutral"),
      surface: cssVar("--surface-soft")
    };
  }

  function fit(canvas, ratio) {
    var width = canvas.clientWidth || (canvas.parentElement && canvas.parentElement.clientWidth) || 640;
    if (width < 260) width = 260;
    var height = Math.max(220, Math.round(width * (ratio || 0.6)));
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

  /* 矩阵表：单元格可以是数字 / 字符串，或 { v: 值, hl: "悬停联动的 3D 高亮键" } */
  function matrixHTML(rows, digits) {
    return "<table class='lab-matrix'><tbody>" + rows.map(function (row) {
      return "<tr>" + row.map(function (value) {
        if (value && typeof value === "object") {
          return "<td" + (value.hl ? " data-hl='" + value.hl + "'" : "") + ">" +
            (typeof value.v === "number" ? value.v.toFixed(digits === undefined ? 3 : digits) : value.v) + "</td>";
        }
        return "<td>" + (typeof value === "number" ? value.toFixed(digits === undefined ? 3 : digits) : value) + "</td>";
      }).join("") + "</tr>";
    }).join("") + "</tbody></table>";
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

  /* 读数区悬停联动：td[data-hl] 悬停 → 回调高亮键；移出 → 回调 null。
     读数 innerHTML 每次重绘都会重建，所以用事件委托绑在容器上。 */
  function bindHover(readout, onKey) {
    var current = null;
    readout.addEventListener("mouseover", function (event) {
      var td = event.target.closest ? event.target.closest("td[data-hl]") : null;
      if (td && td.getAttribute("data-hl") !== current) {
        current = td.getAttribute("data-hl");
        onKey(current);
      }
    });
    readout.addEventListener("mouseout", function (event) {
      var td = event.target.closest ? event.target.closest("td[data-hl]") : null;
      if (td && current !== null) {
        current = null;
        onKey(null);
      }
    });
  }

  /* ================= 数学内核（纯函数，node 测试直接 require） ================= */

  var kernel = {};

  kernel.addv = function (a, b) { return [a[0] + b[0], a[1] + b[1], a[2] + b[2]]; };
  kernel.subv = function (a, b) { return [a[0] - b[0], a[1] - b[1], a[2] - b[2]]; };
  kernel.sclv = function (a, s) { return [a[0] * s, a[1] * s, a[2] * s]; };
  kernel.dot = function (a, b) { return a[0] * b[0] + a[1] * b[1] + a[2] * b[2]; };
  kernel.crs = function (a, b) {
    return [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]];
  };
  kernel.len = function (a) { return Math.sqrt(kernel.dot(a, a)); };
  kernel.norm = function (a) { var l = kernel.len(a) || 1; return kernel.sclv(a, 1 / l); };
  kernel.rotAxis = function (k, v, ang) {
    var cs = Math.cos(ang), sn = Math.sin(ang), kxv = kernel.crs(k, v), kd = kernel.dot(k, v);
    return [
      cs * v[0] + sn * kxv[0] + kd * (1 - cs) * k[0],
      cs * v[1] + sn * kxv[1] + kd * (1 - cs) * k[1],
      cs * v[2] + sn * kxv[2] + kd * (1 - cs) * k[2]
    ];
  };
  kernel.mul3 = function (A, B) {
    var out = [[0, 0, 0], [0, 0, 0], [0, 0, 0]], i, j, k;
    for (i = 0; i < 3; i++) for (j = 0; j < 3; j++) {
      var s = 0;
      for (k = 0; k < 3; k++) s += A[i][k] * B[k][j];
      out[i][j] = s;
    }
    return out;
  };
  kernel.rotX = function (a) { var c = Math.cos(a), s = Math.sin(a); return [[1, 0, 0], [0, c, -s], [0, s, c]]; };
  kernel.rotY = function (a) { var c = Math.cos(a), s = Math.sin(a); return [[c, 0, s], [0, 1, 0], [-s, 0, c]]; };
  kernel.rotZ = function (a) { var c = Math.cos(a), s = Math.sin(a); return [[c, -s, 0], [s, c, 0], [0, 0, 1]]; };

  /* 齐次位姿 T = { R: 3×3, p: 平移 }（4×4 齐次阵的活动表示） */
  kernel.Tid = function () { return { R: [[1, 0, 0], [0, 1, 0], [0, 0, 1]], p: [0, 0, 0] }; };
  kernel.Tmul = function (A, B) {
    return { R: kernel.mul3(A.R, B.R), p: kernel.addv(A.p, kernel.Trot(A, B.p)) };
  };
  kernel.Trot = function (T, v) {
    var R = T.R;
    return [
      R[0][0] * v[0] + R[0][1] * v[1] + R[0][2] * v[2],
      R[1][0] * v[0] + R[1][1] * v[1] + R[1][2] * v[2],
      R[2][0] * v[0] + R[2][1] * v[1] + R[2][2] * v[2]
    ];
  };
  kernel.Tvec = function (T, v) { return kernel.addv(kernel.Trot(T, v), T.p); };

  /* 标准 DH 关节变换（与书中式一致）：
     A_i^{i-1} = Rot_z(ϑ)·Trans_z(d)·Trans_x(a)·Rot_x(α) */
  kernel.dhA = function (alpha, a, d, th) {
    var ca = Math.cos(alpha), sa = Math.sin(alpha), ct = Math.cos(th), st = Math.sin(th);
    return {
      R: [[ct, -st * ca, st * sa], [st, ct * ca, -ct * sa], [0, sa, ca]],
      p: [a * ct, a * st, d]
    };
  };

  /* DH 链正运动学：rows = [{alpha, a, d, th, type:'R'|'P'}]，
     type 决定 q[i] 进 ϑ 还是 d，另一个取行内常数。返回逐级位姿 frames[0..n]。 */
  kernel.fkChain = function (rows, q) {
    var T = kernel.Tid();
    var frames = [{ o: [0, 0, 0], x: [1, 0, 0], y: [0, 1, 0], z: [0, 0, 1], T: T }];
    for (var i = 0; i < rows.length; i++) {
      var row = rows[i];
      var th = row.type === "P" ? (row.th || 0) : q[i];
      var d = row.type === "P" ? q[i] : (row.d || 0);
      T = kernel.Tmul(T, kernel.dhA(row.alpha || 0, row.a || 0, d, th));
      frames.push({
        o: [T.p[0], T.p[1], T.p[2]],
        x: [T.R[0][0], T.R[1][0], T.R[2][0]],
        y: [T.R[0][1], T.R[1][1], T.R[2][1]],
        z: [T.R[0][2], T.R[1][2], T.R[2][2]],
        T: T
      });
    }
    return frames;
  };

  /* 欧拉角（与 robot-labs.js 的 2D 版同一组公式，集中进内核供测试） */
  kernel.zyzMatrix = function (phi, the, psi) {
    return kernel.mul3(kernel.mul3(kernel.rotZ(phi * DEG), kernel.rotY(the * DEG)), kernel.rotZ(psi * DEG));
  };
  kernel.rpyMatrix = function (phi, the, psi) {
    return kernel.mul3(kernel.mul3(kernel.rotZ(phi * DEG), kernel.rotY(the * DEG)), kernel.rotX(psi * DEG));
  };
  kernel.extractZYZ = function (R) {
    var sb = Math.sqrt(R[0][2] * R[0][2] + R[1][2] * R[1][2]);
    if (sb < 1e-9) {
      return { ok: false, phi: Math.atan2(R[1][0], R[0][0]) / DEG, theta: (R[2][2] > 0 ? 0 : 180), psi: 0 };
    }
    return { ok: true, phi: Math.atan2(R[1][2], R[0][2]) / DEG, theta: Math.atan2(sb, R[2][2]) / DEG, psi: Math.atan2(R[2][1], -R[2][0]) / DEG };
  };
  kernel.extractRPY = function (R) {
    var cb = Math.sqrt(R[0][0] * R[0][0] + R[1][0] * R[1][0]);
    if (cb < 1e-9) {
      return { ok: false, phi: Math.atan2(-R[0][1], R[1][1]) / DEG, theta: (R[2][0] < 0 ? 90 : -90), psi: 0 };
    }
    return { ok: true, phi: Math.atan2(R[1][0], R[0][0]) / DEG, theta: Math.atan2(-R[2][0], cb) / DEG, psi: Math.atan2(R[2][1], R[2][2]) / DEG };
  };

  /* 拟人臂闭式 T₃⁰（原书式 2.66，node 测试对拍用） */
  kernel.anthroT3 = function (t1, t2, t3, a2, a3) {
    var c1 = Math.cos(t1), s1 = Math.sin(t1);
    var c2 = Math.cos(t2), s2 = Math.sin(t2);
    var c23 = Math.cos(t2 + t3), s23 = Math.sin(t2 + t3);
    return {
      R: [[c1 * c23, -c1 * s23, s1], [s1 * c23, -s1 * s23, -c1], [s23, c23, 0]],
      p: [c1 * (a2 * c2 + a3 * c23), s1 * (a2 * c2 + a3 * c23), a2 * s2 + a3 * s23]
    };
  };

  /* 三连杆平面臂闭式 T₃⁰（原书式 2.63） */
  kernel.planarT3 = function (t1, t2, t3, a1, a2, a3) {
    var c1 = Math.cos(t1), s1 = Math.sin(t1);
    var c12 = Math.cos(t1 + t2), s12 = Math.sin(t1 + t2);
    var c123 = Math.cos(t1 + t2 + t3), s123 = Math.sin(t1 + t2 + t3);
    return {
      R: [[c123, -s123, 0], [s123, c123, 0], [0, 0, 1]],
      p: [a1 * c1 + a2 * c12 + a3 * c123, a1 * s1 + a2 * s12 + a3 * s123, 0]
    };
  };

  /* 球形臂闭式 T₃⁰（原书式 2.65） */
  kernel.sphericalT3 = function (t1, t2, d3, d2) {
    var c1 = Math.cos(t1), s1 = Math.sin(t1);
    var c2 = Math.cos(t2), s2 = Math.sin(t2);
    return {
      R: [[c1 * c2, -s1, c1 * s2], [s1 * c2, c1, s1 * s2], [-s2, 0, c2]],
      p: [c1 * s2 * d3 - s1 * d2, s1 * s2 * d3 + c1 * d2, c2 * d3]
    };
  };

  /* 3×3 行列式 */
  kernel.det3 = function (A) {
    return A[0][0] * (A[1][1] * A[2][2] - A[1][2] * A[2][1])
      - A[0][1] * (A[1][0] * A[2][2] - A[1][2] * A[2][0])
      + A[0][2] * (A[1][0] * A[2][1] - A[1][1] * A[2][0]);
  };

  /* 对称 3×3 的 Jacobi 特征分解：返回 { values: [λ0,λ1,λ2], vectors: [[v0],[v1],[v2]] }
     vectors[j] 是 λj 对应的单位特征向量（列向量式）。用显式 JᵀAJ / V←VJ 迭代。 */
  kernel.symEig3 = function (A) {
    var a = [
      [A[0][0], A[0][1], A[0][2]],
      [A[1][0], A[1][1], A[1][2]],
      [A[2][0], A[2][1], A[2][2]]
    ];
    var V = [[1, 0, 0], [0, 1, 0], [0, 0, 1]];
    var i, j, k, l, it;
    for (it = 0; it < 60; it++) {
      /* 选非对角元绝对值最大的一对 */
      var p = 0, q = 1, best = Math.abs(a[0][1]);
      if (Math.abs(a[0][2]) > best) { p = 0; q = 2; best = Math.abs(a[0][2]); }
      if (Math.abs(a[1][2]) > best) { p = 1; q = 2; best = Math.abs(a[1][2]); }
      if (best < 1e-15) break;
      var theta = (a[q][q] - a[p][p]) / (2 * a[p][q]);
      var t = (theta >= 0 ? 1 : -1) / (Math.abs(theta) + Math.sqrt(theta * theta + 1));
      var c = 1 / Math.sqrt(t * t + 1), s = t * c;
      /* J：列 p = [c, s, 0]ᵀ 作用在 (p,q) 平面，列 q = [−s, c, 0]ᵀ */
      var J = [[1, 0, 0], [0, 1, 0], [0, 0, 1]];
      J[p][p] = c; J[p][q] = s; J[q][p] = -s; J[q][q] = c;
      /* A' = Jᵀ A J */
      var tmp = [[0, 0, 0], [0, 0, 0], [0, 0, 0]];
      for (k = 0; k < 3; k++) for (l = 0; l < 3; l++) {
        var acc = 0;
        for (i = 0; i < 3; i++) acc += J[i][k] * a[i][l];
        tmp[k][l] = acc;
      }
      var a2 = [[0, 0, 0], [0, 0, 0], [0, 0, 0]];
      for (k = 0; k < 3; k++) for (l = 0; l < 3; l++) {
        var acc2 = 0;
        for (i = 0; i < 3; i++) acc2 += tmp[k][i] * J[i][l];
        a2[k][l] = acc2;
      }
      a = a2;
      /* V ← VJ（特征向量按列累积） */
      var V2 = [[0, 0, 0], [0, 0, 0], [0, 0, 0]];
      for (k = 0; k < 3; k++) for (l = 0; l < 3; l++) {
        var acc3 = 0;
        for (i = 0; i < 3; i++) acc3 += V[k][i] * J[i][l];
        V2[k][l] = acc3;
      }
      V = V2;
    }
    var vals = [a[0][0], a[1][1], a[2][2]];
    var vecs = [[V[0][0], V[0][1], V[0][2]], [V[1][0], V[1][1], V[1][2]], [V[2][0], V[2][1], V[2][2]]];
    return { values: vals, vectors: vecs };
  };

  /* 几何雅可比的位置块（3×n）：第 i 列 = z_{i−1} × (p_e − p_{i−1}) */
  kernel.geoJacPos = function (frames) {
    var n = frames.length - 1;
    var pe = frames[n].o;
    var J = [[0, 0, 0], [0, 0, 0], [0, 0, 0]];
    for (var i = 1; i <= n; i++) {
      var z = frames[i - 1].z;
      var r = kernel.subv(pe, frames[i - 1].o);
      var col = kernel.crs(z, r);
      J[0][i - 1] = col[0];
      J[1][i - 1] = col[1];
      J[2][i - 1] = col[2];
    }
    return J;
  };

  /* 拟人臂闭式 J̄（3.2.2 式 (3.37)）——node 测试与几何雅可比对拍 */
  kernel.anthroJbar = function (t1, t2, t3, a2, a3) {
    var c1 = Math.cos(t1), s1 = Math.sin(t1);
    var c2 = Math.cos(t2), s2 = Math.sin(t2);
    var c23 = Math.cos(t2 + t3), s23 = Math.sin(t2 + t3);
    var A = a2 * c2 + a3 * c23;
    var B = a2 * s2 + a3 * s23;
    return [
      [-s1 * A, -c1 * B, -c1 * a3 * s23],
      [c1 * A, -s1 * B, -s1 * a3 * s23],
      [0, A, a3 * c23]
    ];
  };

  /* 拟人臂逆解（原书式 2.98–2.110）：返回 4 支解 + 可达性诊断 */
  kernel.anthroIK = function (p, a2, a3) {
    var px = p[0], py = p[1], pz = p[2];
    var norm2 = px * px + py * py + pz * pz;
    var R = Math.sqrt(px * px + py * py);
    var c3 = (norm2 - a2 * a2 - a3 * a3) / (2 * a2 * a3);
    var out = { reachable: Math.abs(c3) <= 1, c3: c3, R: R, shoulderSingular: R < 1e-9, solutions: [] };
    if (!out.reachable) {
      out.reason = c3 > 1
        ? "腕心太远：‖p_w‖ = " + Math.sqrt(norm2).toFixed(3) + " m > a₂ + a₃ = " + (a2 + a3).toFixed(3) + " m（式 2.98 的容许性条件被破坏）"
        : "腕心太近：‖p_w‖ = " + Math.sqrt(norm2).toFixed(3) + " m < |a₂ − a₃| = " + Math.abs(a2 - a3).toFixed(3) + " m（式 2.98 的容许性条件被破坏）";
      return out;
    }
    var s3abs = Math.sqrt(Math.max(0, 1 - c3 * c3));
    var D = a2 * a2 + a3 * a3 + 2 * a2 * a3 * c3;
    var elbows = [s3abs, -s3abs];
    var shoulders = [1, -1];
    for (var e = 0; e < 2; e++) {
      var s3 = elbows[e];
      var th3 = Math.atan2(s3, c3);
      for (var sh = 0; sh < 2; sh++) {
        var sig = shoulders[sh];
        var c2 = (sig * R * (a2 + a3 * c3) + pz * a3 * s3) / D;
        var s2 = (pz * (a2 + a3 * c3) - sig * R * a3 * s3) / D;
        var th2 = Math.atan2(s2, c2);
        var th1 = R < 1e-9 ? 0 : (sig > 0 ? Math.atan2(py, px) : Math.atan2(-py, -px));
        out.solutions.push({
          th1: th1, th2: th2, th3: th3,
          elbow: s3 > 0 ? "up" : "down",
          shoulder: sig > 0 ? "right" : "left",
          sig: sig, s3: s3
        });
      }
    }
    return out;
  };

  /* ================= 3D 引擎：轨道相机 + 画家算法 + 平面着色 ================= */

  /* 颜色工具：支持 #rgb / #rrggbb / rgb(...)，其他格式原样返回（不着色） */
  function parseColor(s) {
    if (!s) return null;
    s = s.trim();
    var m;
    if (s.charAt(0) === "#") {
      if (s.length === 4) {
        return [parseInt(s.charAt(1) + s.charAt(1), 16), parseInt(s.charAt(2) + s.charAt(2), 16), parseInt(s.charAt(3) + s.charAt(3), 16)];
      }
      if (s.length === 7) {
        return [parseInt(s.slice(1, 3), 16), parseInt(s.slice(3, 5), 16), parseInt(s.slice(5, 7), 16)];
      }
      return null;
    }
    m = s.match(/^rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)/);
    if (m) return [parseFloat(m[1]), parseFloat(m[2]), parseFloat(m[3])];
    return null;
  }
  function shadeColor(s, k) {
    var p = parseColor(s);
    if (!p) return s;
    var r = Math.max(0, Math.min(255, Math.round(p[0] * k)));
    var g = Math.max(0, Math.min(255, Math.round(p[1] * k)));
    var b = Math.max(0, Math.min(255, Math.round(p[2] * k)));
    return "rgb(" + r + "," + g + "," + b + ")";
  }

  var LIGHT = kernel.norm([-0.45, 0.5, 0.74]); /* 世界系光向（右上前方） */

  /* makeView(canvas, ratio, opts) → view
     opts: { az 初始方位角°, elv 初始俯仰角°, span 场景尺度, center 视觉中心,
             ratio 画布高宽比, onChange 相机变化时的回调 } */
  function makeView(canvas, ratio, opts) {
    opts = opts || {};
    var cam = { az: opts.az !== undefined ? opts.az : -38, elv: opts.elv !== undefined ? opts.elv : 21, zoom: 1 };
    var span = opts.span || 1.6;
    var center = opts.center || [0, 0, 0];
    var view = { canvas: canvas, cam: cam, ratio: ratio || 0.62, prims: [], span: span, center: center };

    view.onChange = opts.onChange || function () {};

    /* ---- 图元（世界坐标，render 时投影、排序、绘制） ---- */
    view.line = function (a, b, o) {
      o = o || {};
      view.prims.push({ kind: "path", pts: [a, b], color: o.color, width: o.width || 1.6, dash: o.dash, hl: o.hl, noDim: o.noDim });
    };
    view.path = function (pts, o) {
      o = o || {};
      view.prims.push({ kind: "path", pts: pts, color: o.color, width: o.width || 1.6, dash: o.dash, hl: o.hl, noDim: o.noDim });
    };
    /* 填充多边形（世界坐标顶点，自动背面剔除；closed 闭合） */
    view.poly = function (pts, o) {
      o = o || {};
      view.prims.push({ kind: "poly", pts: pts, color: o.color, both: o.both, hl: o.hl, noDim: o.noDim });
    };
    view.sphere = function (c, r, o) {
      o = o || {};
      view.prims.push({ kind: "sphere", c: c, r: r, color: o.color, hl: o.hl, noDim: o.noDim });
    };
    /* 圆柱：沿 a→b，半径 r，N 段细分 */
    view.cyl = function (a, b, r, o) {
      o = o || {};
      var axis = kernel.norm(kernel.subv(b, a));
      var u = kernel.norm(Math.abs(axis[0]) < 0.9 ? kernel.crs(axis, [1, 0, 0]) : kernel.crs(axis, [0, 1, 0]));
      var v = kernel.crs(axis, u);
      var N = o.seg || 12, i, ang;
      var ringA = [], ringB = [];
      for (i = 0; i <= N; i++) {
        ang = 2 * Math.PI * i / N;
        var dir = kernel.addv(kernel.sclv(u, Math.cos(ang)), kernel.sclv(v, Math.sin(ang)));
        ringA.push(kernel.addv(a, kernel.sclv(dir, r)));
        ringB.push(kernel.addv(b, kernel.sclv(dir, r)));
      }
      for (i = 0; i < N; i++) {
        view.prims.push({
          kind: "poly", pts: [ringA[i], ringA[i + 1], ringB[i + 1], ringB[i]],
          color: o.color, both: true, hl: o.hl, noDim: o.noDim
        });
      }
    };
    /* 有向长方体：中心 c，半边长 h=[hx,hy,hz]，姿态 R（列向量系） */
    view.box = function (c, h, R, o) {
      o = o || {};
      var corners = [];
      for (var i = 0; i < 8; i++) {
        var local = [(i & 1 ? 1 : -1) * h[0], (i & 2 ? 1 : -1) * h[1], (i & 4 ? 1 : -1) * h[2]];
        corners.push(kernel.addv(c, kernel.Trot({ R: R, p: [0, 0, 0] }, local)));
      }
      var faces = [[0, 2, 3, 1], [4, 5, 7, 6], [0, 1, 5, 4], [2, 6, 7, 3], [0, 4, 6, 2], [1, 3, 7, 5]];
      faces.forEach(function (f) {
        view.prims.push({
          kind: "poly", pts: f.map(function (idx) { return corners[idx]; }),
          color: o.color, both: true, hl: o.hl, noDim: o.noDim
        });
      });
    };
    /* 圆弧：center 处，平面由正交基 U,V 张成，半径 r，从 from 到 to（弧度） */
    view.arc = function (centerC, U, V, r, from, to, o) {
      o = o || {};
      var pts = [], i, N = 26;
      for (i = 0; i <= N; i++) {
        var t = from + (to - from) * i / N;
        pts.push(kernel.addv(centerC, kernel.sclv(kernel.addv(kernel.sclv(U, Math.cos(t)), kernel.sclv(V, Math.sin(t))), r)));
      }
      view.prims.push({ kind: "path", pts: pts, color: o.color, width: o.width || 1.8, dash: o.dash, hl: o.hl, noDim: o.noDim });
    };
    /* 椭球线框：c 处，三个主轴方向 axes 与半径 radii（可操作度椭球用） */
    view.ellipsoid = function (c, axes, radii, o) {
      o = o || {};
      var rings = [[0, 1], [1, 2], [2, 0]];
      rings.forEach(function (pair) {
        var U = kernel.sclv(axes[pair[0]], radii[pair[0]]);
        var V = kernel.sclv(axes[pair[1]], radii[pair[1]]);
        var pts = [], i, N = 42;
        for (i = 0; i <= N; i++) {
          var t = 2 * Math.PI * i / N;
          pts.push(kernel.addv(c, kernel.addv(kernel.sclv(U, Math.cos(t)), kernel.sclv(V, Math.sin(t)))));
        }
        view.prims.push({ kind: "path", pts: pts, color: o.color, width: o.width || 1.4, dash: o.dash, hl: o.hl, noDim: o.noDim });
      });
      if (o.axesToo) {
        axes.forEach(function (ax, i) {
          view.prims.push({
            kind: "path",
            pts: [kernel.addv(c, kernel.sclv(ax, -radii[i])), kernel.addv(c, kernel.sclv(ax, radii[i]))],
            color: o.color, width: 1, dash: [3, 3], hl: o.hl, noDim: o.noDim
          });
        });
      }
    };
    /* 坐标架：o 原点，R 姿态（或 x/y/z 三向量），size 轴长，labels 各轴文字 */
    view.triad = function (origin, R, size, labels, o) {
      o = o || {};
      var axes = [
        [R[0][0], R[1][0], R[2][0]],
        [R[0][1], R[1][1], R[2][1]],
        [R[0][2], R[1][2], R[2][2]]
      ];
      var colors = [o.colors ? o.colors[0] : null, o.colors ? o.colors[1] : null, o.colors ? o.colors[2] : null];
      axes.forEach(function (ax, i) {
        var tip = kernel.addv(origin, kernel.sclv(ax, size));
        view.prims.push({
          kind: "axis", a: origin, b: tip, color: colors[i], width: o.width || 2.2,
          dim: o.dim, hl: o.hlPrefix ? o.hlPrefix + i : o.hl, noDim: o.noDim
        });
        if (labels) {
          view.prims.push({ kind: "label", p: tip, text: labels[i], color: colors[i], dim: o.dim, noDim: o.noDim });
        }
      });
      if (o.originLabel) {
        view.prims.push({ kind: "label", p: origin, text: o.originLabel, color: null, dim: o.dim, dx: -12, dy: 12, noDim: o.noDim });
      }
    };
    view.label = function (p, text, color, dx, dy) {
      view.prims.push({ kind: "label", p: p, text: text, color: color, dx: dx, dy: dy });
    };
    /* 地面网格：z=0（或指定高度），半径 rad，步长 step */
    view.grid = function (rad, step, z, o) {
      o = o || {};
      var i;
      for (i = -rad; i <= rad + 1e-9; i += step) {
        view.line([i, -rad, z], [i, rad, z], { color: o.color, width: 1, dash: i === 0 ? [] : [1, 5], noDim: true });
        view.line([-rad, i, z], [rad, i, z], { color: o.color, width: 1, dash: i === 0 ? [] : [1, 5], noDim: true });
      }
    };

    /* ---- 投影 ---- */
    function makeProj(w, h) {
      var az = cam.az * DEG, elv = cam.elv * DEG;
      var ca = Math.cos(az), sa = Math.sin(az), cb = Math.cos(elv), sb = Math.sin(elv);
      var f = [-sa * cb, ca * cb, -sb];            /* 视线方向（目标→远离相机） */
      var right = [ca, sa, 0];
      var up = kernel.crs(right, f);
      var dist = span * 2.35;
      var fl = Math.min(w, h) * 1.72 * cam.zoom;
      return function (v) {
        var d = kernel.subv(v, center);
        var vz = kernel.dot(d, f) + dist;
        var vx = kernel.dot(d, right);
        var vy = kernel.dot(d, up);
        var k = fl / (vz > 0.02 ? vz : 0.02);
        return { x: w / 2 + vx * k, y: h / 2 - vy * k, z: vz };
      };
    }

    /* ---- 绘制 ---- */
    view.render = function (highlight) {
      var s = fit(canvas, view.ratio);
      var ctx = s.ctx, w = s.w, h = s.h, c = s.c;
      var proj = makeProj(w, h);
      /* 相机位置：eye = center + dist·(方位角, 俯仰角) 方向 */
      var azr = cam.az * DEG, elr = cam.elv * DEG;
      var dirToEye = [Math.sin(azr) * Math.cos(elr), -Math.cos(azr) * Math.cos(elr), Math.sin(elr)];
      var eye = kernel.addv(center, kernel.sclv(dirToEye, span * 2.35));

      /* 预投影 + 深度 */
      var prims = view.prims;
      var items = [], i, j;
      for (i = 0; i < prims.length; i++) {
        var prim = prims[i];
        if (prim.kind === "poly") {
          var ok = true;
          var pts2 = prim.pts.map(function (p) { return proj(p); });
          for (j = 0; j < pts2.length; j++) if (pts2[j].z <= 0.03) { ok = false; break; }
          if (!ok) continue;
          /* 世界系面法向（Newell）与背面剔除 */
          var n = [0, 0, 0];
          for (j = 0; j < prim.pts.length; j++) {
            var aV = prim.pts[j], bV = prim.pts[(j + 1) % prim.pts.length];
            n[0] += (aV[1] - bV[1]) * (aV[2] + bV[2]);
            n[1] += (aV[2] - bV[2]) * (aV[0] + bV[0]);
            n[2] += (aV[0] - bV[0]) * (aV[1] + bV[1]);
          }
          var ctr = [0, 0, 0];
          prim.pts.forEach(function (p) { ctr[0] += p[0] / prim.pts.length; ctr[1] += p[1] / prim.pts.length; ctr[2] += p[2] / prim.pts.length; });
          var viewDir = kernel.subv(ctr, eye);
          var facing = kernel.dot(kernel.norm(n), kernel.norm(viewDir));
          if (!prim.both && facing > 0) continue;
          var depth = 0;
          pts2.forEach(function (p2) { depth += p2.z / pts2.length; });
          var shade = 0.58 + 0.42 * Math.max(0, kernel.dot(kernel.norm(n), LIGHT));
          if (prim.both && facing > 0) shade = 0.58 + 0.42 * Math.max(0, -kernel.dot(kernel.norm(n), LIGHT));
          items.push({ depth: depth, draw: makePoly(ctx, pts2, prim, shade, highlight) });
        } else if (prim.kind === "path" || prim.kind === "axis") {
          var pts = prim.kind === "axis" ? [prim.a, prim.b] : prim.pts;
          var ok2 = true;
          var pp = pts.map(function (p) { return proj(p); });
          for (j = 0; j < pp.length; j++) if (pp[j].z <= 0.03) { ok2 = false; break; }
          if (!ok2) continue;
          var depth2 = 0;
          pp.forEach(function (p2) { depth2 += p2.z / pp.length; });
          items.push({ depth: depth2, draw: makePath(ctx, pp, prim, highlight, c) });
        } else if (prim.kind === "sphere") {
          var pc = proj(prim.c);
          if (pc.z <= 0.03) continue;
          items.push({ depth: pc.z, draw: makeSphere(ctx, pc, prim, w, h, highlight, c) });
        } else if (prim.kind === "label") {
          var pl = proj(prim.p);
          if (pl.z <= 0.03) continue;
          items.push({ depth: -1e9, draw: makeLabel(ctx, pl, prim, c) }); /* 标签永远最后画 */
        }
      }
      items.sort(function (a, b) { return b.depth - a.depth; }); /* 远的先画 */
      items.forEach(function (item) { item.draw(); });

      /* 操作提示角标 */
      ctx.fillStyle = c.muted;
      ctx.font = "11.5px " + cssVar("--sans");
      ctx.fillText("拖拽旋转 · 滚轮缩放", 10, h - 8);

      view.prims = [];
    };

    function hlState(prim, highlight) {
      if (!highlight) return 0; /* 0 正常 */
      if (prim.hl === highlight) return 2; /* 2 命中 */
      return prim.hl && !prim.noDim ? 1 : 0; /* 1 有联动键但未命中 → 淡化 */
    }

    function makePoly(ctx, pts2, prim, shade, highlight) {
      var st = hlState(prim, highlight);
      return function () {
        var color = st === 2 ? shadeColor(prim.color, 1.28) : prim.color;
        var fill = shadeColor(color, st === 1 ? 0.86 : shade);
        ctx.globalAlpha = st === 1 ? 0.5 : 1;
        ctx.fillStyle = fill;
        ctx.strokeStyle = shadeColor(fill, 0.82);
        ctx.lineWidth = 0.75;
        ctx.beginPath();
        pts2.forEach(function (p, i) { if (i === 0) ctx.moveTo(p.x, p.y); else ctx.lineTo(p.x, p.y); });
        ctx.closePath();
        ctx.fill();
        ctx.stroke();
        ctx.globalAlpha = 1;
      };
    }

    function makePath(ctx, pp, prim, highlight, c) {
      var st = hlState(prim, highlight);
      var isAxis = prim.kind === "axis";
      return function () {
        var color = prim.color || c.ink2;
        ctx.globalAlpha = prim.dim ? 0.55 : (st === 1 ? 0.5 : 1);
        ctx.setLineDash(prim.dash || []);
        if (isAxis) {
          arrow(ctx, pp[0].x, pp[0].y, pp[1].x, pp[1].y, st === 2 ? shadeColor(color, 1.3) : color, st === 2 ? prim.width * 1.7 : prim.width);
        } else {
          ctx.strokeStyle = st === 2 ? shadeColor(color, 1.3) : color;
          ctx.lineWidth = st === 2 ? prim.width * 1.9 : prim.width;
          ctx.lineCap = "round";
          ctx.lineJoin = "round";
          ctx.beginPath();
          pp.forEach(function (p, i) { if (i === 0) ctx.moveTo(p.x, p.y); else ctx.lineTo(p.x, p.y); });
          ctx.stroke();
        }
        ctx.setLineDash([]);
        ctx.globalAlpha = 1;
      };
    }

    function makeSphere(ctx, pc, prim, w, h, highlight, c) {
      var st = hlState(prim, highlight);
      var rs = Math.max(2.2, prim.r * (Math.min(w, h) * 1.72 * cam.zoom) / pc.z);
      return function () {
        var base = prim.color || c.ink2;
        var fill = st === 2 ? shadeColor(base, 1.25) : base;
        var grad = ctx.createRadialGradient(pc.x - rs * 0.35, pc.y - rs * 0.35, rs * 0.2, pc.x, pc.y, rs);
        grad.addColorStop(0, shadeColor(fill, 1.18));
        grad.addColorStop(1, shadeColor(fill, st === 1 ? 0.8 : 0.92));
        ctx.globalAlpha = st === 1 ? 0.5 : 1;
        ctx.fillStyle = grad;
        ctx.beginPath();
        ctx.arc(pc.x, pc.y, rs, 0, 6.2832);
        ctx.fill();
        ctx.strokeStyle = shadeColor(fill, 0.7);
        ctx.lineWidth = 0.8;
        ctx.stroke();
        ctx.globalAlpha = 1;
      };
    }

    function makeLabel(ctx, pl, prim, c) {
      return function () {
        ctx.globalAlpha = prim.dim ? 0.6 : 1;
        var x = pl.x + (prim.dx === undefined ? 5 : prim.dx);
        var y = pl.y + (prim.dy === undefined ? -4 : prim.dy);
        ctx.font = "bold 12px " + cssVar("--sans");
        /* 光晕：先用画布底色描一圈，文字压在连杆/网格上也读得清 */
        ctx.strokeStyle = c.surface || c.paper;
        ctx.lineWidth = 3;
        ctx.lineJoin = "round";
        ctx.strokeText(prim.text, x, y);
        ctx.fillStyle = prim.color || c.ink2;
        ctx.fillText(prim.text, x, y);
        ctx.globalAlpha = 1;
      };
    }

    /* ---- 交互：拖拽轨道 / 滚轮缩放 / 双指捏合 ---- */
    var pointers = new Map();
    var pinchDist = 0;
    canvas.classList.add("lab-3d");
    canvas.addEventListener("pointerdown", function (e) {
      pointers.set(e.pointerId, { x: e.clientX, y: e.clientY });
      canvas.setPointerCapture(e.pointerId);
      e.preventDefault();
    });
    canvas.addEventListener("pointermove", function (e) {
      if (!pointers.has(e.pointerId)) return;
      var prev = pointers.get(e.pointerId);
      pointers.set(e.pointerId, { x: e.clientX, y: e.clientY });
      if (pointers.size === 1) {
        cam.az += (e.clientX - prev.x) * 0.42;
        cam.elv = Math.max(-6, Math.min(86, cam.elv + (e.clientY - prev.y) * 0.3));
        view.onChange();
      } else if (pointers.size === 2) {
        var pts = Array.from(pointers.values());
        var d = Math.hypot(pts[0].x - pts[1].x, pts[0].y - pts[1].y);
        if (pinchDist > 0) {
          cam.zoom = Math.max(0.4, Math.min(4, cam.zoom * d / pinchDist));
          view.onChange();
        }
        pinchDist = d;
      }
    });
    function lift(e) {
      pointers.delete(e.pointerId);
      if (pointers.size < 2) pinchDist = 0;
    }
    canvas.addEventListener("pointerup", lift);
    canvas.addEventListener("pointercancel", lift);
    canvas.addEventListener("wheel", function (e) {
      e.preventDefault();
      cam.zoom = Math.max(0.4, Math.min(4, cam.zoom * (e.deltaY < 0 ? 1.12 : 0.89)));
      view.onChange();
    }, { passive: false });

    return view;
  }

  /* ================= 通用绘制：DH 链机构渲染 ================= */

  /* 从 fkChain 的 frames 画一台「胖乎乎」的机械臂。
     opt: { showAxes 关节轴线, triads DH 坐标架, triadSize, toolLen, toolR,
            baseH 基座高度, ws 工作空间提示, frameRange 显示哪些坐标架,
            hlFrame/hlTheta/hlA 悬停联动键 } */
  function drawChain(view, frames, opt) {
    opt = opt || {};
    var c = palette();
    var n = frames.length - 1;
    var i;

    /* 基座 */
    var baseH = opt.baseH !== undefined ? opt.baseH : 0.22;
    if (baseH > 0) {
      view.cyl([0, 0, -baseH], [0, 0, 0], 0.1, { color: c.neutral, seg: 10 });
      view.box([0, 0, -baseH - 0.02], [0.16, 0.16, 0.015], kernel.Tid().R, { color: c.neutral });
    }

    /* 连杆：相邻关节原点之间的圆柱 */
    var rLink = opt.linkR || 0.05;
    for (i = 1; i <= n; i++) {
      var a = frames[i - 1].o, b = frames[i].o;
      if (kernel.len(kernel.subv(b, a)) < 1e-6) continue;
      view.cyl(a, b, rLink * (1 - 0.12 * (i - 1)), { color: c.blue, hl: opt.hlA && opt.hlA + i });
    }

    /* 关节：原点处的短粗圆柱，轴线取 z_{i-1}（第 i 个关节的轴） */
    for (i = 0; i < n; i++) {
      var axis = frames[i].z;
      var o = frames[i].o;
      var jr = (opt.jointR || 0.075) * (1 - 0.06 * i);
      view.cyl(
        kernel.addv(o, kernel.sclv(axis, -jr * 0.9)),
        kernel.addv(o, kernel.sclv(axis, jr * 0.9)),
        jr, { color: c.green, hl: opt.hlTheta && opt.hlTheta + i, seg: 10 }
      );
    }

    /* 末端工具 */
    var end = frames[n];
    if (opt.toolLen) {
      var tipDir = end.x;
      var tip = kernel.addv(end.o, kernel.sclv(tipDir, opt.toolLen));
      view.cyl(end.o, tip, 0.028, { color: c.gold });
      view.sphere(tip, 0.036, { color: c.red });
    } else {
      view.sphere(end.o, 0.038, { color: c.red });
    }

    /* 关节轴线（虚线） */
    if (opt.showAxes !== false) {
      for (i = 0; i < n; i++) {
        var ax = frames[i].z, org = frames[i].o;
        var ext = 0.16 + (opt.span || 1.2) * 0.08;
        view.line(kernel.addv(org, kernel.sclv(ax, -ext)), kernel.addv(org, kernel.sclv(ax, ext)),
          { color: c.muted, width: 1.2, dash: [6, 4], hl: opt.hlTheta && opt.hlTheta + i });
      }
    }

    /* DH 坐标架 */
    if (opt.triads) {
      var lo = opt.frameRange ? opt.frameRange[0] : 0;
      var hi = opt.frameRange ? opt.frameRange[1] : n;
      var triadColors = [c.blue, c.green, c.gold];
      for (i = lo; i <= hi; i++) {
        if (opt.hiddenFrames && opt.hiddenFrames.indexOf(i) >= 0) continue;
        var R = [[frames[i].x[0], frames[i].y[0], frames[i].z[0]], [frames[i].x[1], frames[i].y[1], frames[i].z[1]], [frames[i].x[2], frames[i].y[2], frames[i].z[2]]];
        view.triad(frames[i].o, R, opt.triadSize || 0.22, ["x" + i, "y" + i, "z" + i], {
          colors: triadColors,
          dim: opt.dimFrame !== undefined && i < opt.dimFrame,
          hlPrefix: opt.hlFrame ? opt.hlFrame + i + "-" : null,
          originLabel: "o" + i
        });
      }
    }
    return c;
  }

  /* ================= 实验：zoo3d · 构形动物园（ch01 §1.2） ================= */

  function labZoo3D(host) {
    var HALF_PI = Math.PI / 2;
    var state = { kind: "anthro", q: [0, 40, -75, 0, 0, 0, 0], hover: null };

    /* 各构形定义：rows 为 DH 行（type: R/P，range: 关节范围，def: 默认值） */
    var KINDS = [
      {
        id: "cartesian", name: "笛卡儿型", seq: "移动 ×3（PPP）", ws: "长方体",
        rows: [
          { alpha: -HALF_PI, a: 0, d: 0, th: 0, type: "P", label: "d₁（立柱升降）", range: [-0.45, 0.45], def: 0.18 },
          { alpha: HALF_PI, a: 0, d: 0, th: 0, type: "P", label: "d₂（横梁平移）", range: [-0.35, 0.35], def: 0.22 },
          { alpha: 0, a: 0, d: 0, th: 0, type: "P", label: "d₃（主轴进给）", range: [-0.35, 0.35], def: -0.25 }
        ],
        note: "三根移动轴互相垂直：每关节独管一个笛卡儿坐标，像三维打印机；工作空间是长方体。"
      },
      {
        id: "cylindrical", name: "圆柱型", seq: "转动 + 移动 + 移动（RPP）", ws: "空心圆柱体",
        rows: [
          { alpha: -HALF_PI, a: 0, d: 0, th: 0, type: "R", label: "θ₁（底座回转）", range: [-150, 150], def: 30 },
          { alpha: HALF_PI, a: 0, d: 0, th: 0, type: "P", label: "d₂（径向伸缩）", range: [0.25, 0.95], def: 0.6 },
          { alpha: 0, a: 0, d: 0, th: 0, type: "P", label: "d₃（升降）", range: [-0.35, 0.45], def: 0.1 }
        ],
        note: "先回转定方位、再沿半径与竖直两个方向伸缩：工作空间是空心圆柱体的一角。"
      },
      {
        id: "spherical", name: "球型", seq: "转动 + 转动 + 移动（RRP）", ws: "中空球体",
        rows: [
          { alpha: -HALF_PI, a: 0, d: 0, th: 0, type: "R", label: "θ₁（底座回转）", range: [-150, 150], def: 25 },
          { alpha: HALF_PI, a: 0, d: 0.18, th: 0, type: "R", label: "θ₂（肩俯仰）", range: [-20, 95], def: 40 },
          { alpha: 0, a: 0, d: 0, th: 0, type: "P", label: "d₃（径向伸缩）", range: [0.3, 1.05], def: 0.7 }
        ],
        note: "与 2.9.3 球形臂同构：两转定方向、一移探距离；工作空间是中空球体的一部分（这里 d₂ 是肩部偏置）。"
      },
      {
        id: "scara", name: "SCARA", seq: "转动 + 转动 + 移动（三轴平行，RR:P）", ws: "扁形回转体",
        rows: [
          { alpha: 0, a: 0.5, d: 0, th: 0, type: "R", label: "θ₁", range: [-140, 140], def: 25 },
          { alpha: 0, a: 0.42, d: 0, th: 0, type: "R", label: "θ₂", range: [-150, 150], def: -45 },
          { alpha: 0, a: 0, d: 0, th: 0, type: "P", label: "d₃（竖直下压）", range: [-0.4, 0], def: -0.18 },
          { alpha: 0, a: 0, d: 0, th: 0, type: "R", label: "θ₄（腕回转）", range: [-180, 180], def: 0 }
        ],
        note: "三根轴全平行（都竖直）：水平面内两个转动定位、竖直方向移动下压——竖直刚、水平顺从，天生适合插装。"
      },
      {
        id: "planar3r", name: "平面三连杆", seq: "转动 ×3（三轴平行，RRR）", ws: "环形（平面）",
        rows: [
          { alpha: 0, a: 0.45, d: 0, th: 0, type: "R", label: "θ₁", range: [-160, 160], def: 35 },
          { alpha: 0, a: 0.36, d: 0, th: 0, type: "R", label: "θ₂", range: [-160, 160], def: -40 },
          { alpha: 0, a: 0.26, d: 0, th: 0, type: "R", label: "θ₃", range: [-160, 160], def: 30 }
        ],
        note: "2.9.1 的主角：三轴全平行、α=d=0，DH 表只剩三个 θ——整台臂躺在一个平面里。"
      },
      {
        id: "parallelogram", name: "平行四边形臂", seq: "闭链（两驱动关节都在基座）", ws: "环形（平面）",
        custom: "para",
        rows: [
          { alpha: 0, a: 0.45, d: 0, th: 0, type: "R", label: "θ₁′（曲柄）", range: [20, 130], def: 55 },
          { alpha: 0, a: 0.5, d: 0, th: 0, type: "R", label: "θ₁″（驱动杆）", range: [40, 150], def: 95 }
        ],
        note: "2.9.2 的闭链：O–A–B–C 构成平行四边形，两个驱动关节都装在基座（执行器不上臂）；与两连杆臂运动学等价，刚度更高。"
      },
      {
        id: "anthro", name: "拟人臂", seq: "转动 ×3（腰—肩—肘，RRR）", ws: "近似球体",
        rows: [
          { alpha: HALF_PI, a: 0, d: 0, th: 0, type: "R", label: "θ₁（腰）", range: [-150, 150], def: 20 },
          { alpha: 0, a: 0.62, d: 0, th: 0, type: "R", label: "θ₂（肩）", range: [-90, 90], def: 42 },
          { alpha: 0, a: 0.52, d: 0, th: 0, type: "R", label: "θ₃（肘）", range: [-140, 140], def: -70 }
        ],
        note: "2.9.4：腰轴竖直、肩肘轴水平平行，像人的胳膊；全转动关节、最灵活，工业界占比 59%。"
      },
      {
        id: "anthroWrist", name: "拟人臂 + 球形腕", seq: "转动 ×6（3R 臂 + 三轴共点腕）", ws: "近似球体",
        rows: [
          { alpha: HALF_PI, a: 0, d: 0, th: 0, type: "R", label: "θ₁（腰）", range: [-150, 150], def: 15 },
          { alpha: 0, a: 0.55, d: 0, th: 0, type: "R", label: "θ₂（肩）", range: [-70, 80], def: 35 },
          { alpha: HALF_PI, a: 0, d: 0, th: 0, type: "R", label: "θ₃（肘）", range: [-120, 120], def: -55 },
          { alpha: -HALF_PI, a: 0, d: 0.3, th: 0, type: "R", label: "θ₄（腕偏摆）", range: [-120, 120], def: 20 },
          { alpha: HALF_PI, a: 0, d: 0, th: 0, type: "R", label: "θ₅（腕俯仰）", range: [-110, 110], def: -35 },
          { alpha: 0, a: 0, d: 0.14, th: 0, type: "R", label: "θ₆（腕回转）", range: [-180, 180], def: 0 }
        ],
        note: "2.9.7 的六轴重建模：臂管定位（腕心）、三轴交于一点的腕管定向——转动 θ₄θ₅θ₆，腕心纹丝不动。"
      },
      {
        id: "stanford", name: "斯坦福臂", seq: "球型臂 + 球形腕（RRP + 3R）", ws: "中空球体",
        rows: [
          { alpha: -HALF_PI, a: 0, d: 0, th: 0, type: "R", label: "θ₁", range: [-150, 150], def: 25 },
          { alpha: HALF_PI, a: 0, d: 0.16, th: 0, type: "R", label: "θ₂", range: [-15, 95], def: 35 },
          { alpha: 0, a: 0, d: 0, th: 0, type: "P", label: "d₃（伸缩）", range: [0.3, 1.0], def: 0.66 },
          { alpha: -HALF_PI, a: 0, d: 0, th: 0, type: "R", label: "θ₄", range: [-150, 150], def: 15 },
          { alpha: HALF_PI, a: 0, d: 0, th: 0, type: "R", label: "θ₅", range: [-110, 110], def: -30 },
          { alpha: 0, a: 0, d: 0.13, th: 0, type: "R", label: "θ₆", range: [-180, 180], def: 0 }
        ],
        note: "2.9.6：球形臂（RRP）+ 球形腕（3R）接口对齐直接连乘——「先定方向再探距离」的经典组合。"
      }
    ];

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "构形动物园：九种机构，拖转起来数自由度"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "选一种构形，拖动关节滑杆、拖转视角（画布内按住拖动、滚轮缩放）。绿色圆柱 = 转动关节，金色 = 移动关节的导轨滑块；虚线 = 关节轴线。对照着「臂的关节序列 → 工作空间形状」这条判别主线看：三移 → 长方体；一转两移 → 空心圆柱；两转一移 → 中空球；三轴平行 → 扁形回转体；全转动 → 近似球。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    var kindGroup = el("div", "lab-controls");
    host.appendChild(kindGroup);

    toggleGroup(kindGroup, "构形", KINDS.map(function (k) { return { value: k.id, text: k.name }; }), state.kind, function (v) {
      state.kind = v;
      resetSliders();
      draw();
    });

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "所选构形的 3D 机械臂：可拖转视角、拖动关节");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);

    var view = null;
    var sliderRefs = [];

    function resetSliders() {
      sliderRefs.forEach(function (r) { if (r.input.parentNode) r.input.parentNode.parentNode.removeChild(r.input.parentNode); });
      sliderRefs = [];
      var kind = KINDS.find(function (k) { return k.id === state.kind; });
      kind.rows.forEach(function (row, i) {
        sliderRefs.push(slider(controls, row.label, row.range[0], row.range[1], row.type === "P" ? 0.01 : 1, row.def, function (v) {
          state.q[i] = v;
          draw();
        }, function (v) { return v.toFixed(v < 10 ? 2 : 0) + (row.type === "P" ? " m" : "°"); }));
      });
      state.q = kind.rows.map(function (row) { return row.def; });
    }

    function findKind() {
      return KINDS.find(function (k) { return k.id === state.kind; });
    }

    /* 平行四边形臂：闭链专用绘制（几何见 2.9.2） */
    function drawPara(v, kind) {
      var c = palette();
      var t1 = state.q[0] * DEG, t1b = state.q[1] * DEG;
      var a1 = 0.45, a1b = 0.5, a2 = 0.5, a3 = a1, a4 = 0.3;
      var O = [0, 0, 0];
      var e = function (ang) { return [Math.cos(ang), Math.sin(ang), 0]; };
      var A = kernel.sclv(e(t1), a1);
      var C = kernel.sclv(e(t1b), a1b);
      var B = kernel.addv(A, kernel.sclv(e(t1b), a2));
      var T4 = kernel.addv(C, kernel.sclv(e(t1), -a4));
      /* 基座 + 两个基装驱动关节 */
      v.cyl([0, 0, -0.16], O, 0.09, { color: c.neutral, seg: 10 });
      v.cyl(kernel.addv(O, [0, 0, -0.06]), kernel.addv(O, [0, 0, 0.06]), 0.085, { color: c.green, seg: 10 });
      v.cyl(kernel.addv(A, [0, 0, -0.05]), kernel.addv(A, [0, 0, 0.05]), 0.06, { color: c.green, seg: 10 });
      v.sphere(A, 0.045, { color: c.green });
      v.sphere(B, 0.045, { color: c.green });
      v.sphere(C, 0.045, { color: c.green });
      /* 四边形：O→A（曲柄 1′）、A→B（连杆 2′）、C→B（摇杆 3′）、O→C（驱动杆 1″） */
      v.cyl(O, A, 0.035, { color: c.blue });
      v.cyl(A, B, 0.03, { color: c.blue });
      v.cyl(C, B, 0.03, { color: c.blue });
      v.cyl(O, C, 0.035, { color: c.blue });
      v.cyl(B, T4, 0.028, { color: c.gold });
      v.sphere(T4, 0.034, { color: c.red });
      v.label(kernel.sclv(kernel.addv(O, A), 0.5), "1′", c.blue);
      v.label(kernel.sclv(kernel.addv(A, B), 0.5), "2′", c.blue);
      v.label(kernel.sclv(kernel.addv(C, B), 0.5), "3′", c.blue);
      v.label(kernel.sclv(kernel.addv(O, C), 0.5), "1″", c.blue);
      v.label(kernel.sclv(kernel.addv(B, T4), 0.5), "4", c.gold);
    }

    function draw() {
      if (!view) return;
      var kind = findKind();
      var rows = kind.rows;
      var q = state.q.slice(0, rows.length).map(function (v, i) {
        return rows[i].type === "P" ? v : v * DEG;
      });

      view.grid(0.95, 0.19, 0, { color: palette().line });

      if (kind.custom === "para") {
        drawPara(view, kind);
      } else {
        var frames = kernel.fkChain(rows, q);
        drawChain(view, frames, {
          toolLen: 0.14,
          jointR: kind.id === "cartesian" ? 0.06 : 0.07,
          baseH: 0.001
        });
        /* 移动关节画导轨示意：金色细杆沿轴向 */
        rows.forEach(function (row, i) {
          if (row.type !== "P") return;
          var f = frames[i];
          var dir = f.z;
          var near = kernel.addv(f.o, kernel.sclv(dir, row.range[0] > 0 ? row.range[0] - 0.08 : 0.05));
          var far = kernel.addv(f.o, kernel.sclv(dir, row.range[1] + 0.06));
          view.cyl(near, far, 0.02, { color: palette().gold });
        });
      }

      /* 工作空间虚线提示 */
      var wsColor = palette().purple;
      var endF = kind.custom === "para" ? null : kernel.fkChain(rows, q);
      if (kind.ws === "长方体") {
        var h = 0.5, rxy = 0.62;
        [[-rxy, -h / 2], [rxy, -h / 2], [rxy, h / 2], [-rxy, h / 2]].forEach(function (corner, i, arr) {
          var next = arr[(i + 1) % 4];
          view.path([
            [corner[0], corner[1], -0.02], [next[0], next[1], -0.02],
            [next[0], next[1], h], [corner[0], corner[1], h]
          ], { color: wsColor, width: 1.1, dash: [5, 4] });
        });
      } else if (kind.ws === "空心圆柱体") {
        [0.02, 0.62].forEach(function (z) {
          view.arc([0, 0, z], [1, 0, 0], [0, 1, 0], 0.85, 0, 2 * Math.PI, { color: wsColor, width: 1.1, dash: [5, 4] });
        });
        for (var k = 0; k < 4; k++) {
          var ang = k * Math.PI / 2;
          view.line([0.85 * Math.cos(ang), 0.85 * Math.sin(ang), 0.02], [0.85 * Math.cos(ang), 0.85 * Math.sin(ang), 0.62],
            { color: wsColor, width: 1.1, dash: [5, 4] });
        }
      } else if (kind.ws === "中空球体") {
        /* 用三个不同法面的大圆近似球壳 */
        view.arc([0, 0.25, 0.45], [1, 0, 0], [0, 0, 1], 0.85, 0, 2 * Math.PI, { color: wsColor, width: 1.1, dash: [5, 4] });
        view.arc([0, 0.25, 0.45], kernel.norm([0, 1, 1]), kernel.norm([1, -1, 0.2]), 0.85, 0, 2 * Math.PI, { color: wsColor, width: 1.1, dash: [5, 4] });
        view.arc([0, 0.25, 0.45], kernel.norm([0, 1, -1]), kernel.norm([1, 1, 0.2]), 0.85, 0, 2 * Math.PI, { color: wsColor, width: 1.1, dash: [5, 4] });
      } else if (kind.ws === "扁形回转体" || kind.ws === "环形（平面）") {
        var plane = kind.ws === "扁形回转体" ? 0.1 : 0.02;
        view.arc([0, 0, plane], [1, 0, 0], [0, 1, 0], kind.rows.reduce(function (s, r) { return s + (r.a || 0); }, 0) || 0.7, 0, 2 * Math.PI, { color: wsColor, width: 1.1, dash: [5, 4] });
      } else if (kind.ws === "近似球体") {
        var cr = kind.rows.reduce(function (s, r) { return s + (r.a || 0) + (r.type === "P" ? 0.6 : 0); }, 0.3);
        view.arc([0, 0.3, 0.45], [1, 0, 0], [0, 0, 1], 0.82, 0, 2 * Math.PI, { color: wsColor, width: 1.1, dash: [5, 4] });
        view.arc([0, 0.3, 0.45], kernel.norm([0, 1, 1]), kernel.norm([1, -1, 0.2]), 0.82, 0, 2 * Math.PI, { color: wsColor, width: 1.1, dash: [5, 4] });
      }

      view.render(state.hover);

      var dof = rows.length;
      var html = "<p><b>" + kind.name + "</b>：" + kind.seq + "，自由度 " + dof +
        (kind.custom === "para" ? "（独立驱动 2 个，闭链约束吃掉 2 个）" : "") +
        "；工作空间：" + kind.ws + "。</p>";
      html += "<p class='lab-note'>" + kind.note + "</p>";
      if (endF) {
        var p = endF[endF.length - 1].o;
        html += "<p class='lab-note'>末端原点当前位于 (" + p[0].toFixed(2) + ", " + p[1].toFixed(2) + ", " + p[2].toFixed(2) + ") m。</p>";
      }
      readout.innerHTML = texLite(html);
    }

    view = makeView(canvas, 0.66, {
      span: 1.35,
      center: [0, 0, 0.28],
      az: -34, elv: 20,
      onChange: draw
    });
    resetSliders();
    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* ================= 实验：euler3d · 欧拉角逐级复合（ch02 §2.4） ================= */

  function labEuler3D(host) {
    var state = { mode: "zyz", phi: 30, theta: 55, psi: 20, step: 3, hover: null };

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "欧拉角在三维里怎么转：ZYZ 与 RPY 的逐级复合"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "拖动画布转视角、拖 φ/ϑ/ψ 看动坐标架怎么动。步进滑杆把三次转动拆开：每一步只显示「转到这一步为止」的坐标架（浅色为中间结果），正在生效的旋转轴加粗高亮。悬停下方 R 矩阵的列，画布里对应的动系轴会跟着加粗——第 j 列就是动系第 j 根轴在参考系里的方向。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    toggleGroup(controls, "约定", [{ value: "zyz", text: "ZYZ" }, { value: "rpy", text: "RPY" }], "zyz", function (v) { state.mode = v; draw(); });
    slider(controls, "φ", -180, 180, 1, state.phi, function (v) { state.phi = v; draw(); }, function (v) { return v.toFixed(0) + "°"; });
    slider(controls, "ϑ", -180, 180, 1, state.theta, function (v) { state.theta = v; draw(); }, function (v) { return v.toFixed(0) + "°"; });
    slider(controls, "ψ", -180, 180, 1, state.psi, function (v) { state.psi = v; draw(); }, function (v) { return v.toFixed(0) + "°"; });
    slider(controls, "复合到第几步", 1, 3, 1, 3, function (v) { state.step = v; draw(); }, function (v) { return ["①", "②", "③"][v - 1]; });

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "欧拉角逐级复合的三维坐标架");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);

    bindHover(readout, function (key) {
      state.hover = key;
      draw();
    });

    /* 逐步复合的中间旋转。两种约定的「分解读法」不同：
       ZYZ = 当前轴约定：先绕 z₀ 转 φ，再绕新 y′ 转 ϑ，再绕新 z″ 转 ψ；
       RPY = 固定轴约定：先绕固定 x₀ 转 ψ，再绕固定 y₀ 转 ϑ，最后绕固定 z₀ 转 φ。 */
    function steps() {
      if (state.mode === "zyz") {
        return [
          kernel.rotZ(state.phi * DEG),
          kernel.mul3(kernel.rotZ(state.phi * DEG), kernel.rotY(state.theta * DEG)),
          kernel.zyzMatrix(state.phi, state.theta, state.psi)
        ];
      }
      return [
        kernel.rotX(state.psi * DEG),
        kernel.mul3(kernel.rotY(state.theta * DEG), kernel.rotX(state.psi * DEG)),
        kernel.rpyMatrix(state.phi, state.theta, state.psi)
      ];
    }
    /* 第 i 步的转轴（世界系）：ZYZ 里是「上一步坐标系里的轴」，RPY 里恒为固定轴 */
    function stepAxisWorld(i, Rs) {
      if (state.mode === "zyz") {
        var local = [[0, 0, 1], [0, 1, 0], [0, 0, 1]][i];
        var base = i === 0 ? kernel.Tid().R : Rs[i - 1];
        return kernel.Trot({ R: base, p: [0, 0, 0] }, local);
      }
      return [[1, 0, 0], [0, 1, 0], [0, 0, 1]][i];
    }
    function stepName(i) {
      return state.mode === "zyz"
        ? ["绕 z₀ 转 φ", "再绕新 y′ 转 ϑ", "再绕新 z″ 转 ψ"][i]
        : ["绕固定 x₀ 转 ψ（先转）", "绕固定 y₀ 转 ϑ", "绕固定 z₀ 转 φ（最后转）"][i];
    }

    var view = makeView(canvas, 0.6, { span: 1.5, center: [0, 0, 0], az: -30, elv: 18 });
    view.onChange = function () { draw(); };

    function draw() {
      var c = palette();
      view.grid(0.8, 0.2, -0.55, { color: c.line });

      var Rs = steps();
      var O = [0, 0, 0];
      /* 参考系（灰） */
      view.triad(O, kernel.Tid().R, 0.62, ["x₀", "y₀", "z₀"], { colors: [c.muted, c.muted, c.muted], width: 1.4 });
      /* 中间步骤坐标架（半透明淡色） */
      for (var i = 0; i < state.step - 1; i++) {
        view.triad(O, Rs[i], 0.46, null, { colors: [c.blue, c.green, c.gold], width: 1.6, dim: true });
      }
      /* 当前步坐标架（亮） */
      view.triad(O, Rs[state.step - 1], 0.56, ["x′", "y′", "z′"], { colors: [c.blue, c.green, c.gold], width: 2.6 });
      /* 正在生效的旋转轴：粗箭头 */
      var axWorld = stepAxisWorld(state.step - 1, Rs);
      var L = 0.85;
      view.line(kernel.sclv(axWorld, -L), kernel.addv(O, kernel.sclv(axWorld, L)),
        { color: c.red, width: 3 });
      view.label(kernel.addv(O, kernel.sclv(axWorld, L)), "当前转轴", c.red, 6, 2);

      view.render(state.hover);

      var R = Rs[2];
      var rows = [];
      for (var r = 0; r < 3; r++) {
        var row = [];
        for (var col = 0; col < 3; col++) row.push({ v: R[r][col], hl: "c" + col });
        rows.push(row);
      }
      var html = matrixHTML(rows, 3).replace("<table", "<span class='lab-matrix-label'>R =</span><table");
      html += "<p class='lab-note'>第 " + ["一", "二", "三"][state.step - 1] + " 步：" + stepName(state.step - 1) +
        "（" + (state.mode === "zyz" ? "ZYZ" : "RPY") + " 约定下当前步生效）。悬停 R 的第 j 列，画布里动系第 j 根轴会加粗——列向量 = 动系轴在参考系中的方向余弦。</p>";
      var other = state.mode === "zyz" ? kernel.extractRPY(R) : kernel.extractZYZ(R);
      var otherName = state.mode === "zyz" ? "RPY" : "ZYZ";
      if (other.ok) {
        html += "<p class='lab-note'><b>换用 " + otherName + " 反解同一个 R</b>：φ=" + other.phi.toFixed(1) + "°，ϑ=" + other.theta.toFixed(1) + "°，ψ=" + other.psi.toFixed(1) + "°。</p>";
      } else {
        html += "<p class='lab-warn'><b>" + otherName + " 反解奇异</b>：φ 与 ψ 只剩和 / 差组合，解不唯一。</p>";
      }
      readout.innerHTML = texLite(html);
    }

    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* ================= 实验：dh3d · 拟人臂 DH 建系（ch02 §2.8，替换 2D 版） ================= */

  function labDH3D(host) {
    var state = { stage: 0, q: [20, 42, -70], hover: null };
    var A2 = 0.62, A3 = 0.52;
    var rows = [
      { alpha: Math.PI / 2, a: 0, d: 0, type: "R" },
      { alpha: 0, a: A2, d: 0, type: "R" },
      { alpha: 0, a: A3, d: 0, type: "R" }
    ];

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "拟人臂 DH 建系：拖转着把四个坐标系「长」出来"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "按 ①→④ 分步构造，随意拖转视角、拖动 θ。关键看三件事：关节 i 转动只带动它下游的坐标系（系 0 纹丝不动）；无论姿态怎么变，α₁=90°、a₂=上臂长这些几何量不变——「3 常 1 变」；转到侧面看 z₁、z₂ 两根平行轴与公垂线（上臂）的立体关系。悬停下方 DH 表的单元格：θᵢ → 高亮关节轴，aᵢ → 高亮连杆，α₁ → 高亮扭角弧。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    toggleGroup(controls, "构造步骤", [
      { value: "0", text: "① 轴线" }, { value: "1", text: "② 系0" }, { value: "2", text: "③ 系1" }, { value: "3", text: "④ 系2·3" }
    ], "0", function (v) { state.stage = parseFloat(v); draw(); });
    ["θ₁", "θ₂", "θ₃"].forEach(function (label, i) {
      slider(controls, label, -180, 180, 1, state.q[i], function (v) { state.q[i] = v; draw(); }, function (v) { return v.toFixed(0) + "°"; });
    });

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "拟人臂 DH 分步建系的三维视图");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);

    bindHover(readout, function (key) {
      state.hover = key;
      draw();
    });

    var view = makeView(canvas, 0.64, { span: 1.5, center: [0, 0, 0.22], az: -32, elv: 20 });
    view.onChange = function () { draw(); };

    function draw() {
      var c = palette();
      var q = [state.q[0] * DEG, state.q[1] * DEG, state.q[2] * DEG];
      var frames = kernel.fkChain(rows, q);
      var S = frames[0].o;      /* 肩（= 系0/1 原点） */
      var E = frames[2].o;      /* 肘（系2 原点） */
      var W = frames[3].o;      /* 腕（系3 原点） */

      view.grid(0.85, 0.17, 0, { color: c.line });

      /* 机械本体 */
      view.cyl([0, 0, -0.24], S, 0.075, { color: c.neutral, seg: 10 });
      view.cyl(S, E, 0.045, { color: c.blue, hl: "a2" });
      view.cyl(E, W, 0.038, { color: c.blue, hl: "a3" });
      view.sphere(S, 0.05, { color: c.green });
      view.sphere(E, 0.045, { color: c.green });
      view.sphere(W, 0.035, { color: c.red });

      /* 关节轴线（虚线，随阶段淡出） */
      var axColor = state.stage === 0 ? c.ink2 : c.muted;
      var axes = [
        { at: S, dir: frames[0].z, ext: 0.55, name: "关节1轴（z₀）", hl: "th0" },
        { at: S, dir: frames[1].z, ext: 0.3, name: "关节2轴（z₁）", hl: "th1" },
        { at: E, dir: frames[2].z, ext: 0.3, name: "关节3轴（z₂）", hl: "th2" }
      ];
      axes.forEach(function (a, i) {
        view.line(kernel.addv(a.at, kernel.sclv(a.dir, -a.ext)), kernel.addv(a.at, kernel.sclv(a.dir, a.ext)),
          { color: axColor, width: state.stage === 0 ? 1.8 : 1.1, dash: [6, 4], hl: a.hl });
        if (state.stage === 0) view.label(kernel.addv(a.at, kernel.sclv(a.dir, a.ext)), a.name, c.ink2, 6, 0);
      });

      /* 坐标架 */
      var triadColors = [c.blue, c.green, c.gold];
      if (state.stage >= 1) {
        var put = function (idx, dim) {
          var f = frames[idx];
          var R = [[f.x[0], f.y[0], f.z[0]], [f.x[1], f.y[1], f.z[1]], [f.x[2], f.y[2], f.z[2]]];
          view.triad(f.o, R, idx === 0 ? 0.34 : 0.26, ["x" + idx, "y" + idx, "z" + idx], {
            colors: triadColors, width: idx === 0 && state.stage < 3 ? 2.6 : 2, dim: dim,
            hlPrefix: "f" + idx + "-"
          });
        };
        put(0, state.stage >= 3);
        if (state.stage >= 2) put(1, state.stage >= 3);
        if (state.stage >= 3) { put(2, false); put(3, false); }
      }

      /* α₁ 扭角弧（系1 阶段起）：z₀ → z₁ 绕 x₁ */
      if (state.stage >= 2) {
        var U = frames[0].z, V = kernel.subv(frames[1].z, kernel.sclv(frames[0].z, kernel.dot(frames[0].z, frames[1].z)));
        V = kernel.sclv(kernel.norm(V), 1);
        view.arc(S, U, V, 0.3, 0, Math.PI / 2, { color: c.purple, width: 2, hl: "al1" });
        view.label(kernel.addv(S, kernel.sclv(kernel.addv(kernel.sclv(U, 0.3 * Math.cos(Math.PI / 4)), kernel.sclv(V, 0.3 * Math.sin(Math.PI / 4))), 1)), "α₁ = 90°", c.purple, 8, 4);
      }
      /* a₂/a₃ 公垂线段（系2·3 阶段） */
      if (state.stage >= 3) {
        view.arc(S, frames[1].x, frames[1].y, 0.36, 0, q[1], { color: c.red, width: 1.6, dash: [4, 3], hl: "th1" });
        view.arc(E, frames[2].x, frames[2].y, 0.28, 0, q[2], { color: c.red, width: 1.6, dash: [4, 3], hl: "th2" });
      }

      view.render(state.hover);

      var stageNotes = [
        "第①步：只画三根关节轴线。关节1竖直过肩点；关节2水平过肩点；关节3过肘点、与关节2平行。轴线的两两关系（轴1⊥轴2 相交、轴2∥轴3）已经决定了整张参数表。",
        "第②步：放系 0。z₀ = 关节1轴（系 0 看守关节 1）；o₀ 取在轴1∩轴2（肩心）⇒ d₁ = 0；x₀ 水平任选。系 0 固连基座，任何关节都动不了它。",
        "第③步：放系 1。z₁ = 关节2轴。两轴相交 ⇒ a₁ = 0；从 z₀ 绕 x₁ 拧到 z₁ 顺着右手四指 ⇒ α₁ = π/2。紫色弧就是这 90°。拖 θ₁：整条臂带着系 1、2、3 一起绕 z₀ 转。",
        "第④步：放系 2、3。z₂ = 关节3轴 ∥ z₁ ⇒ α₂ = 0；公垂线就是上臂 ⇒ a₂；d₂ = 0，系 3 同理。红色弧是 θ₂、θ₃ 的定义角。拖 θ₂、θ₃：每个关节只带动它下游的坐标系，参数表里的常数纹丝不动。"
      ];
      var table = "<table class='lab-matrix'><thead><tr><th>i</th><th>αᵢ</th><th>aᵢ</th><th>dᵢ</th><th>θᵢ</th></tr></thead><tbody>" +
        "<tr><td>1</td><td data-hl='al1'>π/2</td><td data-hl='a1'>0</td><td>0</td><td data-hl='th0'>" + state.q[0].toFixed(0) + "°</td></tr>" +
        "<tr><td>2</td><td>0</td><td data-hl='a2'>" + A2.toFixed(2) + "</td><td>0</td><td data-hl='th1'>" + state.q[1].toFixed(0) + "°</td></tr>" +
        "<tr><td>3</td><td>0</td><td data-hl='a3'>" + A3.toFixed(2) + "</td><td>0</td><td data-hl='th2'>" + state.q[2].toFixed(0) + "°</td></tr>" +
        "</tbody></table>";
      readout.innerHTML = texLite("<p>" + stageNotes[state.stage] + "</p>" + table +
        "<p class='lab-note'>与 2.9.4 拟人臂的 DH 表逐字相同；连乘结果 T₃⁰ 见 2.9.4。</p>");
    }

    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* ================= 实验：anthro3d · 拟人臂 T₃⁰（ch02 §2.9.4） ================= */

  function labAnthro3D(host) {
    var A2 = 0.62, A3 = 0.52;
    var state = { q: [20, 42, -70], hover: null, showFrame: true };
    var rows = [
      { alpha: Math.PI / 2, a: 0, d: 0, type: "R" },
      { alpha: 0, a: A2, d: 0, type: "R" },
      { alpha: 0, a: A3, d: 0, type: "R" }
    ];

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "拟人臂：把 T₃⁰ 每一个元素都对上几何"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "拖 θ₁、θ₂、θ₃ 与视角。下方是原书式 2.66 的 T₃⁰ 数值，**悬停某一列**：第 1–3 列是动系三根轴在基座系里的方向余弦（高亮画布里对应的坐标架轴），第 4 列是腕心位置（高亮从肩心指向 o₃ 的位置矢量）。两个「结构性观察」在画面上直接可见：第 3 列 [s₁,-c₁,0]ᵀ **只含 θ₁**——转肩不改变 z₃ 的指向；z₃=z₂，故系 2、系 3 的 z 轴重合（画布里那两根平行箭头）。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    toggleGroup(controls, "坐标架", [{ value: "on", text: "显示系 0–3" }, { value: "off", text: "只看机械本体" }], "on",
      function (v) { state.showFrame = v === "on"; draw(); });
    ["θ₁（腰）", "θ₂（肩）", "θ₃（肘）"].forEach(function (label, i) {
      slider(controls, label, -180, 180, 1, state.q[i], function (v) { state.q[i] = v; draw(); },
        function (v) { return v.toFixed(0) + "°"; });
    });

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "拟人臂三自由度机构与 T₃⁰ 逐列读解");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);
    bindHover(readout, function (key) { state.hover = key; draw(); });

    var view = makeView(canvas, 0.62, { span: 1.45, center: [0, 0, 0.3], az: -34, elv: 19 });
    view.onChange = function () { draw(); };

    function draw() {
      var c = palette();
      var q = [state.q[0] * DEG, state.q[1] * DEG, state.q[2] * DEG];
      var frames = kernel.fkChain(rows, q);
      var T3 = kernel.anthroT3(q[0], q[1], q[2], A2, A3);

      view.grid(0.85, 0.17, 0, { color: c.line });
      drawChain(view, frames, {
        toolLen: 0.12,
        triads: state.showFrame,
        triadSize: 0.3,
        frameRange: [0, 3],
        hlFrame: "f"
      });
      /* 位置矢量（基座原点 → o₃）：悬停第 4 列时高亮 */
      var p3 = frames[3].o;
      view.line([0, 0, 0], p3, { color: c.red, width: 2, dash: [7, 4], hl: "pos" });
      view.label(kernel.sclv(p3, 0.55), "p₃ = 腕心", c.red, 8, 4);
      /* z₃ = z₂ 的提示：两根平行轴 */
      if (state.showFrame) {
        view.line(kernel.addv(frames[2].o, kernel.sclv(frames[2].z, 0.2)), kernel.addv(frames[2].o, kernel.sclv(frames[2].z, 0.42)),
          { color: c.gold, width: 1.6, hl: "f3-2" });
        view.line(kernel.addv(frames[3].o, kernel.sclv(frames[3].z, 0.2)), kernel.addv(frames[3].o, kernel.sclv(frames[3].z, 0.42)),
          { color: c.gold, width: 1.6, hl: "f3-2" });
      }

      view.render(state.hover);

      /* T₃⁰ 的 4×4 数值（前 3×3 为 R，第 4 列为位置） */
      var m = [
        [{ v: T3.R[0][0], hl: "f0-0" }, { v: T3.R[0][1], hl: "f0-1" }, { v: T3.R[0][2], hl: "f3-2" }, { v: T3.p[0], hl: "pos" }],
        [{ v: T3.R[1][0], hl: "f0-0" }, { v: T3.R[1][1], hl: "f0-1" }, { v: T3.R[1][2], hl: "f3-2" }, { v: T3.p[1], hl: "pos" }],
        [{ v: T3.R[2][0], hl: "f0-0" }, { v: T3.R[2][1], hl: "f0-1" }, { v: T3.R[2][2], hl: "f3-2" }, { v: T3.p[2], hl: "pos" }],
        [0, 0, 0, 1]
      ];
      var html = matrixHTML(m, 3).replace("<table", "<span class='lab-matrix-label'>T₃⁰ =</span><table");
      html += "<p class='lab-note'><b>逐列读法</b>：第 1 列 = x₃ 在系 0 中的方向余弦，第 2 列 = y₃，第 3 列 = z₃，" +
        "第 4 列 = 腕心位置。悬停任一格，画布里对应的轴或位置矢量会加粗。</p>";
      html += "<p class='lab-note'><b>结构性观察</b>：第 3 列 [s₁,-c₁,0]ᵀ 只含 θ₁——<b>转肩不改变 z₃ 的指向</b>（z₃ 永远躺在水平面里，且随腰一起转）；" +
        "第 3 列的第 3 个分量恒为 0，正是 z₃=z₂（系 2、系 3 的 z 轴重合）的代数痕迹。" +
        "第 4 列的三个分量就是 2.12.5 逆解的<b>腕心方程</b> pwₓ=c₁(a₂c₂+a₃c₂₃)、pwy=s₁(a₂c₂+a₃c₂₃)、pwz=a₂s₂+a₃s₂₃。</p>";
      readout.innerHTML = texLite(html);
    }

    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* ================= 实验：wrist3d · 球形腕解耦（ch02 §2.9.5） ================= */

  function labWrist3D(host) {
    var state = { q: [25, -40, 30], d6: 0.16, hover: null };

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "球形腕：三轴交于一点，腕心纹丝不动"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "只画腕部（系 3 固连在腕心上）：拖 θ₄、θ₅、θ₆ —— <b>红球标的腕心始终不动</b>，只有末端姿态在转；这正是 1.2.3 解耦原理的运动学落点。下方并排列出 R₆³ 与 ZYZ 合成矩阵：它们<b>逐元素相等</b>，悬停右矩阵的格子会同步高亮左边同一位置。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    ["θ₄（偏摆）", "θ₅（俯仰）", "θ₆（回转）"].forEach(function (label, i) {
      slider(controls, label, -180, 180, 1, state.q[i], function (v) { state.q[i] = v; draw(); },
        function (v) { return v.toFixed(0) + "°"; });
    });
    slider(controls, "工具长度 d₆", 0, 0.4, 0.01, state.d6, function (v) { state.d6 = v; draw(); },
      function (v) { return v.toFixed(2) + " m"; });

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "球形腕三轴共点，转腕不移动腕心");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);
    bindHover(readout, function (key) { state.hover = key; draw(); });

    var view = makeView(canvas, 0.6, { span: 0.82, center: [0, 0, 0.08], az: -30, elv: 18 });
    view.onChange = function () { draw(); };

    function draw() {
      var c = palette();
      var q = [state.q[0] * DEG, state.q[1] * DEG, state.q[2] * DEG];
      var rowsLocal = [
        { alpha: -Math.PI / 2, a: 0, d: 0, type: "R" },
        { alpha: Math.PI / 2, a: 0, d: 0, type: "R" },
        { alpha: 0, a: 0, d: state.d6, type: "R" }
      ];
      var frames = kernel.fkChain(rowsLocal, q);
      var R63 = frames[3].T.R;
      var ZYZ = kernel.zyzMatrix(state.q[0], state.q[1], state.q[2]);

      view.grid(0.7, 0.14, 0, { color: c.line });
      /* 腕心：系 3 的原点固定 */
      view.sphere([0, 0, 0], 0.05, { color: c.red });
      view.label([0, 0, 0], "腕心（三轴交点）", c.red, -52, 16);
      /* 系 3（固定） */
      view.triad([0, 0, 0], [[1, 0, 0], [0, 1, 0], [0, 0, 1]], 0.3, ["x₃", "y₃", "z₃"],
        { colors: [c.muted, c.muted, c.muted], width: 1.5 });
      /* 系 4、5、6 */
      [1, 2, 3].forEach(function (idx) {
        var f = frames[idx];
        var R = [[f.x[0], f.y[0], f.z[0]], [f.x[1], f.y[1], f.z[1]], [f.x[2], f.y[2], f.z[2]]];
        view.triad(f.o, R, 0.26, ["x" + (idx + 3), "y" + (idx + 3), "z" + (idx + 3)], {
          colors: [c.blue, c.green, c.gold], width: 2.2, hlPrefix: "f" + (idx + 3) + "-"
        });
        /* 关节轴线（三轴都过腕心） */
        view.line(kernel.sclv(f.z, -0.34), kernel.sclv(f.z, 0.34),
          { color: c.muted, width: 1.1, dash: [6, 4], hl: "f" + (idx + 3) + "-2" });
      });
      /* 工具末端 */
      var tip = frames[3].o;
      view.sphere(tip, 0.032, { color: c.gold });
      view.label(tip, "末端（沿 z₆ 外移 d₆）", c.gold, 14, 14);

      view.render(state.hover);

      var mL = [], mR = [], i, j;
      for (i = 0; i < 3; i++) {
        var rl = [], rr = [];
        for (j = 0; j < 3; j++) {
          rl.push({ v: R63[i][j], hl: "c" + j });
          rr.push({ v: ZYZ[i][j], hl: "c" + j });
        }
        mL.push(rl);
        mR.push(rr);
      }
      var maxDiff = 0;
      for (i = 0; i < 3; i++) for (j = 0; j < 3; j++) maxDiff = Math.max(maxDiff, Math.abs(R63[i][j] - ZYZ[i][j]));

      var html = "<span class='lab-matrix-label'>R₆³ =</span>" + matrixHTML(mL, 3) +
        "<span class='lab-matrix-label'>　ZYZ(θ₄,θ₅,θ₆) =</span>" + matrixHTML(mR, 3);
      html += "<p class='lab-note'><b>两个矩阵逐元素相等</b>（最大偏差 " + maxDiff.toExponential(1) + "）：" +
        "球形腕的三个转角 (θ₄,θ₅,θ₆) 恰是<b>相对系 3 的 ZYZ 角</b>。这正是 2.12.6「腕逆解 = ZYZ 反解」的全部伏笔——" +
        "腕的三轴交于一点（a₄=a₅=d₅=0），R₆³ 写成 R_z(θ₄)Rₓ(-/2)R_z(θ₅)Rₓ(/2)R_z(θ₆)，" +
        "而 Rₓ(-/2)R_z(θ₅)Rₓ(/2)⁻¹=R_y(θ₅)（共轭把绕 z 的转动搬到绕 y），整块塌成 ZYZ。</p>";
      html += "<p class='lab-note'>腕心位置 = 系 3 原点，<b>与 θ₄θ₅θ₆ 无关</b>（拖动三个滑杆时红球纹丝不动）；末端沿 z₆ 外移 d₆ = " + state.d6.toFixed(2) + " m。</p>";
      readout.innerHTML = texLite(html);
    }

    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* ================= 实验：ik3d · 拟人臂逆解四支（ch02 §2.12.5） ================= */

  function labIK3D(host) {
    var A2 = 0.62, A3 = 0.52;
    var state = { p: [0.55, 0.3, 0.35], shoulder: "right", hover: null };
    var rows = [
      { alpha: Math.PI / 2, a: 0, d: 0, type: "R" },
      { alpha: 0, a: A2, d: 0, type: "R" },
      { alpha: 0, a: A3, d: 0, type: "R" }
    ];

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "逆运动学：给定腕心，解出四支姿态"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "拖动目标点 p_w 的三个坐标（红球就是腕心目标），看四支解如何出现：肩右/肩左 × 肘上/肘下。粗线是当前选中肩支的两支解（肘上实、肘下细），极淡的是另一肩支。走到可达边界会出现告警——那是式 2.98 的容许性条件 |a₂-a₃|≤|p_w|≤ a₂+a₃ 被破坏；把目标放到肩轴上（pₓ=p_y=0）则 θ₁ 任意，是肩奇异。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    toggleGroup(controls, "肩支", [{ value: "right", text: "肩右" }, { value: "left", text: "肩左" }], "right",
      function (v) { state.shoulder = v; draw(); });
    slider(controls, "目标 p_x", -1, 1, 0.01, state.p[0], function (v) { state.p[0] = v; draw(); }, function (v) { return v.toFixed(2) + " m"; });
    slider(controls, "目标 p_y", -1, 1, 0.01, state.p[1], function (v) { state.p[1] = v; draw(); }, function (v) { return v.toFixed(2) + " m"; });
    slider(controls, "目标 p_z", -0.8, 0.8, 0.01, state.p[2], function (v) { state.p[2] = v; draw(); }, function (v) { return v.toFixed(2) + " m"; });

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "拟人臂逆运动学的四支解与目标腕心");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);
    bindHover(readout, function (key) { state.hover = key; draw(); });

    var view = makeView(canvas, 0.62, { span: 1.25, center: [0, 0, 0.28], az: -34, elv: 19 });
    view.onChange = function () { draw(); };

    function draw() {
      var c = palette();
      var ik = kernel.anthroIK(state.p, A2, A3);
      view.grid(0.85, 0.17, 0, { color: c.line });

      /* 目标点 */
      view.sphere(state.p, 0.045, { color: c.red });
      view.label(state.p, "目标腕心 p_w", c.red, -20, -16);
      view.line([0, 0, 0], state.p, { color: c.red, width: 1.4, dash: [6, 4] });

      if (ik.reachable) {
        ik.solutions.forEach(function (sol) {
          var isSel = sol.shoulder === state.shoulder;
          var frames = kernel.fkChain(rows, [sol.th1, sol.th2, sol.th3]);
          if (!isSel) {
            /* 另一肩支：极淡的细骨架 */
            for (var i = 1; i <= 3; i++) {
              view.line(frames[i - 1].o, frames[i].o, { color: c.muted, width: 1 });
            }
            view.sphere(frames[3].o, 0.028, { color: c.muted });
            return;
          }
          drawChain(view, frames, { toolLen: 0.1, triads: false, span: 1.2 });
          /* 肘上实、肘下细 */
          if (sol.elbow === "down") {
            for (var k = 1; k <= 3; k++) {
              view.line(frames[k - 1].o, frames[k].o, { color: c.green, width: 1.2, dash: [5, 3] });
            }
          }
          /* 肘支标签标在肘关节处（末端点被目标球占据，标那儿必然打架） */
          view.label(frames[2].o, sol.elbow === "up" ? "肘上" : "肘下", sol.elbow === "up" ? c.ink2 : c.muted,
            sol.elbow === "up" ? 12 : 12, sol.elbow === "up" ? -12 : 14);
        });
      }

      view.render(state.hover);

      var html = "";
      if (!ik.reachable) {
        html += "<p class='lab-warn'><b>无解</b>：" + ik.reason + "。容许性条件 |a₂-a₃|≤|p_w|≤ a₂+a₃（原书式 2.98）。</p>";
      } else {
        html += "<table class='lab-matrix'><thead><tr><th>支</th><th>θ₁</th><th>θ₂</th><th>θ₃</th><th>FK 校验</th></tr></thead><tbody>";
        ik.solutions.forEach(function (sol) {
          var frames = kernel.fkChain(rows, [sol.th1, sol.th2, sol.th3]);
          var p = frames[3].o;
          var err = Math.sqrt(Math.pow(p[0] - state.p[0], 2) + Math.pow(p[1] - state.p[1], 2) + Math.pow(p[2] - state.p[2], 2));
          var mark = sol.shoulder === state.shoulder ? "★ " : "";
          html += "<tr><td>" + mark + (sol.shoulder === "right" ? "肩右" : "肩左") + "/" + (sol.elbow === "up" ? "肘上" : "肘下") + "</td>" +
            "<td>" + (sol.th1 / DEG).toFixed(1) + "°</td><td>" + (sol.th2 / DEG).toFixed(1) + "°</td><td>" + (sol.th3 / DEG).toFixed(1) + "°</td>" +
            "<td>" + err.toExponential(1) + "</td></tr>";
        });
        html += "</tbody></table>";
        html += "<p class='lab-note'>四支解 = <b>肘双支</b>（s₃=±√(1-c₃²)，原书式 2.99–2.101）× <b>肩双支</b>" +
          "（ϑ₁mathrm I=operatorname{Atan2}(pwy,pwₓ)、ϑ₁^{mathrm{II}}=operatorname{Atan2}(-pwy,-pwₓ)，相差 ，原书式 2.109–2.110）。" +
          "「FK 校验」列是把这支解代回正运动学后与目标的偏差——应当是 1e-16 量级。</p>";
        if (ik.shoulderSingular) {
          html += "<p class='lab-warn'><b>肩奇异</b>：pₓ=p_y=0（腕心落在肩轴上），ϑ₁ <b>任意</b>——无穷多解，" +
            "无论腰怎么转，腕心都不动（3.3.1 第 2 类后果：解不唯一）。</p>";
        }
        if (Math.abs(ik.c3) > 0.999) {
          html += "<p class='lab-warn'><b>接近边界奇点</b>：c₃=±1（肘伸直或折回），s₃→0，雅可比趋近奇异。</p>";
        }
      }
      readout.innerHTML = texLite(html);
    }

    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* ================= 实验：jac3d · 雅可比逐列贡献（ch03 §3.2） ================= */

  function labJac3D(host) {
    var PLAN = { a1: 0.45, a2: 0.36, a3: 0.26 };
    var ANTH = { a2: 0.62, a3: 0.52 };
    var state = { kind: "planar", q: [35, -40, 30], dq: [0.6, -0.4, 0.5], hover: null };

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "雅可比的列：谁在出力，出多大力"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "拖动三个<b>关节速度</b>滑杆 ϑᵢ，看末端速度 vₑ=ᵢ Jᵢϑᵢ 怎么变。画布里三根彩箭头是**每一列单独贡献**的速度（Jᵢϑᵢ），粗红箭头是它们的和。悬停下方 J 矩阵的<b>某一列</b>，画布里该列的箭头会加粗、其余变淡——第 i 列的含义就是「只动关节 i、其余锁死时末端的贡献」（3.1.2）。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    toggleGroup(controls, "机构", [{ value: "planar", text: "三连杆平面臂" }, { value: "anthro", text: "拟人臂" }], "planar",
      function (v) { state.kind = v; draw(); });
    ["q̇₁", "q̇₂", "q̇₃"].forEach(function (label, i) {
      slider(controls, label, -1.5, 1.5, 0.05, state.dq[i], function (v) { state.dq[i] = v; draw(); },
        function (v) { return v.toFixed(2) + " rad/s"; });
    });
    ["θ₁", "θ₂", "θ₃"].forEach(function (label, i) {
      slider(controls, label, -180, 180, 1, state.q[i], function (v) { state.q[i] = v; draw(); },
        function (v) { return v.toFixed(0) + "°"; });
    });

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "雅可比逐列贡献的三维可视化");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);
    bindHover(readout, function (key) { state.hover = key; draw(); });

    var view = makeView(canvas, 0.6, { span: 1.5, center: [0, 0, 0.25], az: -32, elv: 20 });
    view.onChange = function () { draw(); };

    function currentRows() {
      if (state.kind === "planar") {
        return [
          { alpha: 0, a: PLAN.a1, d: 0, type: "R" },
          { alpha: 0, a: PLAN.a2, d: 0, type: "R" },
          { alpha: 0, a: PLAN.a3, d: 0, type: "R" }
        ];
      }
      return [
        { alpha: Math.PI / 2, a: 0, d: 0, type: "R" },
        { alpha: 0, a: ANTH.a2, d: 0, type: "R" },
        { alpha: 0, a: ANTH.a3, d: 0, type: "R" }
      ];
    }

    function draw() {
      var c = palette();
      var rows = currentRows();
      var q = [state.q[0] * DEG, state.q[1] * DEG, state.q[2] * DEG];
      var frames = kernel.fkChain(rows, q);
      var pe = frames[3].o;

      view.grid(0.85, 0.17, 0, { color: c.line });
      drawChain(view, frames, { toolLen: 0.1, span: 1.2 });

      /* 几何雅可比的位置块（3×3） */
      var Jp = kernel.geoJacPos(frames);
      /* 平面情形：第 3 行取 ω（[1,1,1]），与 3.2.1 的 J̄ 一致 */
      var J = state.kind === "planar"
        ? [[Jp[0][0], Jp[0][1], Jp[0][2]], [Jp[1][0], Jp[1][1], Jp[1][2]], [1, 1, 1]]
        : Jp;

      var colColors = [c.blue, c.green, c.gold];
      var total = [0, 0, 0];
      var parts = [];
      for (var i = 0; i < 3; i++) {
        var v = [J[0][i] * state.dq[i], J[1][i] * state.dq[i], state.kind === "planar" ? 0 : J[2][i] * state.dq[i]];
        parts.push(v);
        total[0] += v[0]; total[1] += v[1]; total[2] += v[2];
      }

      /* 速度箭头：从末端点出发 */
      var SC = 0.55; /* m/(rad/s) → m 的显示比例 */
      parts.forEach(function (v, i) {
        var tip = kernel.addv(pe, kernel.sclv(v, SC));
        view.line(pe, tip, { color: colColors[i], width: 2.2, hl: "c" + i });
        view.label(tip, "v" + (i + 1), colColors[i], 6, -4);
      });
      var tipT = kernel.addv(pe, kernel.sclv(total, SC));
      view.line(pe, tipT, { color: c.red, width: 3.4 });
      view.label(tipT, "v_e（合计）", c.red, 8, 4);

      view.render(state.hover);

      var rowsHtml = [];
      for (var r = 0; r < 3; r++) {
        var row = [];
        for (var col = 0; col < 3; col++) row.push({ v: J[r][col], hl: "c" + col });
        rowsHtml.push(row);
      }
      var html = matrixHTML(rowsHtml, 3).replace("<table", "<span class='lab-matrix-label'>" +
        (state.kind === "planar" ? "J̄ = [vₓ; v_y; ω]" : "J̄ = [vₓ; v_y; v_z]") + " =</span><table");
      html += "<p class='lab-note'><b>逐列读法</b>：第 i 列 = 「只动关节 i（其余锁死）时末端的贡献」" +
        "（Jᵢ= zᵢ₋₁×( pₑ- pᵢ₋₁)，3.1.2）。" +
        "悬停某一列，画布里该列对应的速度箭头加粗、其余变淡。</p>";
      var vmag = Math.sqrt(total[0] * total[0] + total[1] * total[1] + total[2] * total[2]);
      html += "<p class='lab-note'>当前合计末端速度 |v_e| = " + vmag.toFixed(3) + " m/s" +
        (state.kind === "planar" ? "，角速度 ω = " + (state.dq[0] + state.dq[1] + state.dq[2]).toFixed(3) + " rad/s" : "") + "。</p>";
      readout.innerHTML = texLite(html);
    }

    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* ================= 实验：sing3d · 可操作度椭球与奇点（ch03 §3.3） ================= */

  function labSing3D(host) {
    var A2 = 0.62, A3 = 0.52;
    var state = { q: [20, 42, -70], hover: null, showEll: true, scale: 0.28 };
    var rows = [
      { alpha: Math.PI / 2, a: 0, d: 0, type: "R" },
      { alpha: 0, a: A2, d: 0, type: "R" },
      { alpha: 0, a: A3, d: 0, type: "R" }
    ];

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "可操作度椭球：奇点就是它被压扁的那一刻"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "拟人臂的 J̇ 决定末端能把多大的速度「摊」到哪些方向。椭球是 JJᵀ 的特征方向与 √(λᵢ)：半轴越长 = 该方向上末端能出的速度越大。拖 θ₂、θ₃ 逼近两类奇点——<b>肘伸直/折回</b>（s₃=0，边界奇点）与 <b>腕点落到肩轴上</b>（a₂c₂+a₃c₂₃=0，内部奇点），看椭球怎么压扁到一条线。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    toggleGroup(controls, "椭球", [{ value: "on", text: "显示" }, { value: "off", text: "隐藏" }], "on",
      function (v) { state.showEll = v === "on"; draw(); });
    ["θ₁（腰）", "θ₂（肩）", "θ₃（肘）"].forEach(function (label, i) {
      slider(controls, label, -180, 180, 1, state.q[i], function (v) { state.q[i] = v; draw(); },
        function (v) { return v.toFixed(0) + "°"; });
    });
    slider(controls, "椭球显示比例", 0.1, 0.6, 0.02, state.scale, function (v) { state.scale = v; draw(); },
      function (v) { return v.toFixed(2) + " m/(rad/s)"; });

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "拟人臂的可操作度椭球随位形压扁");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);
    bindHover(readout, function (key) { state.hover = key; draw(); });

    var view = makeView(canvas, 0.62, { span: 1.5, center: [0, 0, 0.3], az: -34, elv: 19 });
    view.onChange = function () { draw(); };

    function draw() {
      var c = palette();
      var q = [state.q[0] * DEG, state.q[1] * DEG, state.q[2] * DEG];
      var frames = kernel.fkChain(rows, q);
      var pe = frames[3].o;
      var J = kernel.anthroJbar(q[0], q[1], q[2], A2, A3);
      var det = kernel.det3(J);
      var E = [[0, 0, 0], [0, 0, 0], [0, 0, 0]];
      for (var i = 0; i < 3; i++) for (var j = 0; j < 3; j++) {
        var s = 0;
        for (var k = 0; k < 3; k++) s += J[k][i] * J[k][j];
        E[i][j] = s;
      }
      var eig = kernel.symEig3(E);
      /* 特征值升序 → 主轴从短到长 */
      var order = [0, 1, 2].sort(function (a, b) { return eig.values[a] - eig.values[b]; });
      var axes = [], radii = [];
      order.forEach(function (idx) {
        axes.push([eig.vectors[0][idx], eig.vectors[1][idx], eig.vectors[2][idx]]);
        radii.push(Math.sqrt(Math.max(0, eig.values[idx])) * state.scale);
      });

      view.grid(0.85, 0.17, 0, { color: c.line });
      drawChain(view, frames, { toolLen: 0.08, span: 1.2 });

      if (state.showEll) {
        view.ellipsoid(pe, axes, radii, { color: c.purple, width: 1.6, axesToo: true });
        view.label(kernel.addv(pe, kernel.sclv(axes[2], radii[2])), "主轴（最快方向）", c.purple, 8, 2);
      }

      view.render(state.hover);

      var s3 = Math.sin(q[2]);
      var shoulderFactor = A2 * Math.cos(q[1]) + A3 * Math.cos(q[1] + q[2]);
      var w = Math.sqrt(Math.abs(det));
      var html = "<p><b>可操作度</b> w=√(det(J̄J̄ᵀ))=|det J̄|=" + w.toFixed(4) + "</p>";
      html += "<p class='lab-note'>̇=-a₂a₃ s₃ (a₂c₂+a₃c₂₃)（3.2.2）——两个因子各自归零即奇异：</p>";
      html += "<table class='lab-matrix'><thead><tr><th>因子</th><th>当前值</th><th>含义</th></tr></thead><tbody>" +
        "<tr><td>s₃</td><td>" + s3.toFixed(4) + "</td><td>肘角正弦：s₃=0 ⇒ 肘伸直/折回（<b>边界奇点</b>）</td></tr>" +
        "<tr><td>a₂c₂+a₃c₂₃</td><td>" + shoulderFactor.toFixed(4) + "</td><td>腕点距肩轴的投影：为 0 ⇒ 腕点落到 z₀ 轴上（<b>内部奇点</b>）</td></tr>" +
        "</tbody></table>";
      var warn = "";
      if (Math.abs(s3) < 0.08) warn += "<p class='lab-warn'><b>接近肘奇点</b>（边界）：椭球被压成一条线，末端在该方向上「给不出速度」。</p>";
      if (Math.abs(shoulderFactor) < 0.08) warn += "<p class='lab-warn'><b>接近肩奇点</b>（内部）：两列线性相关，逆解出现无穷多解。</p>";
      html += warn;
      html += "<p class='lab-note'>椭球半轴 = √(λᵢ(JJᵀ))（显示比例 " + state.scale.toFixed(2) + " m/(rad/s)）：" +
        "最长半轴 " + radii[2].toFixed(3) + " m，最短半轴 " + radii[0].toFixed(3) + " m。</p>";
      readout.innerHTML = texLite(html);
    }

    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* ================= 实验：cart3d · 两连杆笛卡儿臂（ch06 §6.3.1） ================= */

  function labCart3D(host) {
    /* 例 7.2 同款参数（教材 §7.3.1 的标准简化：转子质心在关节轴上） */
    var P = { m1: 50, m2: 50, mm1: 5, mm2: 5, I1: 10, I2: 10, Im1: 0.01, Im2: 0.01, kr1: 100, kr2: 100, g: 9.81 };
    var state = { d1: 0.45, d2: 0.35 };

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "笛卡儿臂：为什么它的惯性矩阵是常数"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "关节 1 沿 z₀ 竖直移动 d₁，关节 2 沿水平方向移动 d₂。**随便拖 d₁,d₂**：下方 B 的三个数<b>一动不动</b>——因为 B 里根本没有 d₁,d₂。这不是巧合，而是「全平动关节」的直接后果：连杆不做转动，动能只是 12mḋ²，与位形无关。于是 Ḃ=0、C=O——<b>既没有离心项，也没有科氏项</b>。这是 6.3.2 平面臂的对照组：那边的复杂性全部来自「转动关节 + 位形变化」。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    slider(controls, "d₁（沿 z₀ 升降）", 0, 0.9, 0.01, state.d1, function (v) { state.d1 = v; draw(); }, function (v) { return v.toFixed(2) + " m"; });
    slider(controls, "d₂（水平伸缩）", -0.6, 0.6, 0.01, state.d2, function (v) { state.d2 = v; draw(); }, function (v) { return v.toFixed(2) + " m"; });

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "两连杆笛卡儿臂：两个移动关节");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);

    var view = makeView(canvas, 0.58, { span: 1.35, center: [0, 0, 0.5], az: -36, elv: 16 });
    view.onChange = function () { draw(); };

    function draw() {
      var c = palette();
      var b11 = P.m1 + P.mm2 + P.kr1 * P.kr1 * P.Im1 + P.m2;
      var b22 = P.m2 + P.kr2 * P.kr2 * P.Im2;
      var g1 = (P.m1 + P.mm2 + P.m2) * P.g;

      view.grid(0.85, 0.17, 0, { color: c.line });
      /* 立柱（关节 1 沿 z 移动） */
      view.box([0, 0, 0.05], [0.07, 0.07, 0.06], kernel.Tid().R, { color: c.neutral });
      var carriage = [0, 0, state.d1];
      view.box(carriage, [0.1, 0.1, 0.05], kernel.Tid().R, { color: c.green });
      view.cyl([0, 0, 0.1], [0, 0, 0.92], 0.022, { color: c.muted, seg: 8 });
      /* 水平臂（关节 2 沿 x 移动） */
      var armEnd = [state.d2, 0, state.d1];
      view.cyl(carriage, armEnd, 0.04, { color: c.blue });
      view.sphere(armEnd, 0.05, { color: c.red });
      /* 载荷（连杆 2 + 转子 2） */
      view.box(kernel.addv(armEnd, [0.05, 0, 0]), [0.05, 0.05, 0.05], kernel.Tid().R, { color: c.gold });
      view.label(armEnd, "末端（连杆 2 末端）", c.red, 12, 4);
      view.label(carriage, "关节 1（移动）", c.green, 12, -4);
      /* 重力方向（z 竖直向上 → 重力沿 −z） */
      view.line([0, 0, 0.95], [0, 0, 0.75], { color: c.red, width: 2.2 });
      view.label([0, 0, 0.72], "重力", c.red, 8, 2);

      view.render(null);

      var html = "<table class='lab-matrix'><thead><tr><th>量</th><th>值</th><th>含义</th></tr></thead><tbody>" +
        "<tr><td>b₁₁</td><td>" + b11.toFixed(2) + "</td><td>关节 1 折算惯量：m₁+mₘ_₂+kᵣ_₁²Iₘ_₁+m₂（<b>不含 d₁,d₂</b>）</td></tr>" +
        "<tr><td>b₂₂</td><td>" + b22.toFixed(2) + "</td><td>关节 2 折算惯量：m₂+kᵣ_₂²Iₘ_₂</td></tr>" +
        "<tr><td>b₁₂</td><td>0</td><td>两轴完全解耦</td></tr>" +
        "<tr><td>C</td><td>O</td><td>Ḃ=0 ⇒ 无离心项、无科氏项</td></tr>" +
        "<tr><td>g₁</td><td>" + g1.toFixed(2) + " N</td><td>要托起「连杆 1 + 转子 2 + 连杆 2」的总重</td></tr>" +
        "<tr><td>g₂</td><td>0</td><td>关节 2 水平运动，重力不做功</td></tr>" +
        "</tbody></table>";
      html += "<p class='lab-note'>拖动 d₁,d₂ 时这些数<b>纹丝不动</b>——这就是「常数惯性矩阵」的含义。与 6.3.2 平面臂对照：那边 b₁₁ 含 2a₁ℓ₂cosϑ₂、b₂₂ 是常数，Cq̇ 里也长出了离心与科氏项。</p>";
      readout.innerHTML = texLite(html);
    }

    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* ================= 实验：dyn3d · 两连杆平面臂的动力学（ch06 §6.3.2） ================= */

  function labDyn3D(host) {
    /* 例 7.2 的参数（教材图 7.5–7.7 同款） */
    var P = {
      a1: 1.0, a2: 1.0, l1: 0.5, l2: 0.5,
      m1: 50, m2: 50, mm1: 5, mm2: 5,
      I1: 10, I2: 10, Im1: 0.01, Im2: 0.01,
      kr1: 100, kr2: 100, g: 9.81
    };
    var state = { th1: 60, th2: -40, dq1: 0, dq2: 0, run: false, t: 0, trail: [] };

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "平面臂动力学：B、C、g 各自在动"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "拖 ϑ₁,ϑ₂ 与角速度 ϑ₁,ϑ₂：下方 B 的三个元素随**位形**变（b₁₁ 里藏着 2a₁ℓ₂cosϑ₂），C 随位形与速度变，重力矩随姿态变；只有 b₂₂ 是常数。按「自由摆动」键则以**零输入力矩**做 RK4 积分——臂会自己摆下去，所有项都参与，画面上的弧线就是 B q+Cq̇+g=0 的结果。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    slider(controls, "ϑ₁", -180, 180, 1, state.th1, function (v) { state.th1 = v; draw(); }, function (v) { return v.toFixed(0) + "°"; });
    slider(controls, "ϑ₂", -180, 180, 1, state.th2, function (v) { state.th2 = v; draw(); }, function (v) { return v.toFixed(0) + "°"; });
    slider(controls, "ϑ̇₁", -2, 2, 0.05, state.dq1, function (v) { state.dq1 = v; draw(); }, function (v) { return v.toFixed(2) + " rad/s"; });
    slider(controls, "ϑ̇₂", -2, 2, 0.05, state.dq2, function (v) { state.dq2 = v; draw(); }, function (v) { return v.toFixed(2) + " rad/s"; });
    var runBtn = el("button", "lab-btn", "自由摆动（零输入力矩）");
    runBtn.type = "button";
    runBtn.addEventListener("click", function () {
      state.run = !state.run;
      runBtn.classList.toggle("on", state.run);
      runBtn.textContent = state.run ? "暂停" : "自由摆动（零输入力矩）";
      if (!state.run) { state.t = 0; state.trail = []; }
      if (state.run && timer === null) timer = setInterval(tick, 16);
      if (!state.run && timer !== null) { clearInterval(timer); timer = null; }
    });
    host.appendChild(runBtn);

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "两连杆平面臂的动力学仿真");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);

    var view = makeView(canvas, 0.6, { span: 1.5, center: [0, 0.35, 0], az: -22, elv: 12 });
    view.onChange = function () { draw(); };

    var timer = null;

    /* --- 动力学内核（严格按 6.3.2 的公式） --- */
    function B(q1, q2) {
      var c2 = Math.cos(q2);
      return [
        [P.I1 + P.m1 * P.l1 * P.l1 + P.kr1 * P.kr1 * P.Im1 + P.I2 + P.m2 * (P.a1 * P.a1 + P.l2 * P.l2 + 2 * P.a1 * P.l2 * c2) + P.Im2 + P.mm2 * P.a1 * P.a1,
          P.I2 + P.m2 * (P.l2 * P.l2 + P.a1 * P.l2 * c2) + P.kr2 * P.Im2],
        [P.I2 + P.m2 * (P.l2 * P.l2 + P.a1 * P.l2 * c2) + P.kr2 * P.Im2,
          P.I2 + P.m2 * P.l2 * P.l2 + P.kr2 * P.kr2 * P.Im2]
      ];
    }
    function gravity(q1, q2) {
      var c1 = Math.cos(q1), c12 = Math.cos(q1 + q2);
      return [
        (P.m1 * P.l1 + P.mm2 * P.a1 + P.m2 * P.a1) * P.g * c1 + P.m2 * P.l2 * P.g * c12,
        P.m2 * P.l2 * P.g * c12
      ];
    }
    function hOf(q2) { return -P.m2 * P.a1 * P.l2 * Math.sin(q2); }
    function Cmat(q2, dq1, dq2) {
      var h = hOf(q2);
      return [[h * dq2, h * (dq1 + dq2)], [-h * dq1, 0]];
    }
    /* q̈ = -B⁻¹ (C q̇ + g) */
    function accel(q1, q2, dq1, dq2) {
      var Bm = B(q1, q2), Cm = Cmat(q2, dq1, dq2), G = gravity(q1, q2);
      var r1 = Cm[0][0] * dq1 + Cm[0][1] * dq2 + G[0];
      var r2 = Cm[1][0] * dq1 + Cm[1][1] * dq2 + G[1];
      var det = Bm[0][0] * Bm[1][1] - Bm[0][1] * Bm[1][0];
      return [(Bm[1][1] * r1 - Bm[0][1] * r2) / det, (-Bm[1][0] * r1 + Bm[0][0] * r2) / det];
    }
    function deriv(y) {
      var a = accel(y[0], y[1], y[2], y[3]);
      return [y[2], y[3], a[0], a[1]];
    }
    function rk4(y, dt) {
      var k1 = deriv(y);
      var y2 = y.map(function (v, i) { return v + 0.5 * dt * k1[i]; });
      var k2 = deriv(y2);
      var y3 = y.map(function (v, i) { return v + 0.5 * dt * k2[i]; });
      var k3 = deriv(y3);
      var y4 = y.map(function (v, i) { return v + dt * k3[i]; });
      var k4 = deriv(y4);
      return y.map(function (v, i) { return v + dt / 6 * (k1[i] + 2 * k2[i] + 2 * k3[i] + k4[i]); });
    }
    function tick() {
      var y = [state.th1 * DEG, state.th2 * DEG, state.dq1, state.dq2];
      var dt = 1 / 120;
      for (var i = 0; i < 2; i++) y = rk4(y, dt);
      state.th1 = y[0] / DEG; state.th2 = y[1] / DEG;
      state.dq1 = y[2]; state.dq2 = y[3];
      state.t += dt * 2;
      draw();
    }

    function draw() {
      var c = palette();
      var q1 = state.th1 * DEG, q2 = state.th2 * DEG;
      var J1 = [0, 0, 0];
      var J2 = [P.a1 * Math.cos(q1), P.a1 * Math.sin(q1), 0];
      var E = [J2[0] + P.a2 * Math.cos(q1 + q2), J2[1] + P.a2 * Math.sin(q1 + q2), 0];
      var C1 = [P.l1 * Math.cos(q1), P.l1 * Math.sin(q1), 0];
      var C2 = [J2[0] + P.l2 * Math.cos(q1 + q2), J2[1] + P.l2 * Math.sin(q1 + q2), 0];

      view.grid(0.95, 0.19, 0, { color: c.line });
      /* 立柱 */
      view.box([0, 0, -0.06], [0.08, 0.08, 0.03], kernel.Tid().R, { color: c.neutral });
      /* 两根连杆（y 竖直向上，臂在 xy 平面内） */
      view.cyl(J1, J2, 0.045, { color: c.blue });
      view.cyl(J2, E, 0.038, { color: c.blue });
      /* 质心 */
      view.sphere(C1, 0.038, { color: c.gold });
      view.sphere(C2, 0.034, { color: c.gold });
      /* 关节 */
      view.sphere(J1, 0.055, { color: c.green });
      view.sphere(J2, 0.048, { color: c.green });
      view.sphere(E, 0.03, { color: c.red });
      view.label(J1, "关节 1", c.green, -46, 14);
      view.label(J2, "关节 2", c.green, 12, -6);
      view.label(C1, "连杆 1 质心", c.gold, 10, 4);
      view.label(C2, "连杆 2 质心", c.gold, 10, 4);
      /* 重力方向（y 向上 → 重力沿 −y） */
      view.line([0, 0.75, 0], [0, 0.55, 0], { color: c.red, width: 2.2 });
      view.label([0, 0.53, 0], "g", c.red, 8, 2);

      /* 重力力矩箭头：在关节处画弧 + 标注大小 */
      var G = gravity(q1, q2);
      view.arc(J1, [0, 0, 1], [0, 1, 0], 0.22, 0, Math.sign(G[0]) * 0.8, { color: c.purple, width: 1.8 });
      view.label(J1, "g₁ = " + G[0].toFixed(1) + " N·m", c.purple, 14, 8);
      view.arc(J2, [0, 0, 1], [0, 1, 0], 0.16, 0, Math.sign(G[1]) * 0.8, { color: c.purple, width: 1.8 });
      view.label(J2, "g₂ = " + G[1].toFixed(1) + " N·m", c.purple, 14, 10);

      /* 末端轨迹 */
      if (state.trail.length > 1) {
        view.path(state.trail, { color: c.accent, width: 1.6 });
      }

      view.render(null);

      var Bm = B(q1, q2), Cm = Cmat(q2, state.dq1, state.dq2);
      var html = "<table class='lab-matrix'><thead><tr><th>项</th><th>值</th><th>随什么变</th></tr></thead><tbody>" +
        "<tr><td>b₁₁</td><td>" + Bm[0][0].toFixed(1) + "</td><td>随 ϑ₂（含 2a₁ℓ₂c₂）</td></tr>" +
        "<tr><td>b₁₂=b₂₁</td><td>" + Bm[0][1].toFixed(1) + "</td><td>随 ϑ₂ ⇒ 两轴耦合</td></tr>" +
        "<tr><td>b₂₂</td><td>" + Bm[1][1].toFixed(1) + "</td><td><b>常数</b>（关节 2 看不见连杆 1）</td></tr>" +
        "<tr><td>h=-m₂a₁ℓ₂s₂</td><td>" + hOf(q2).toFixed(2) + "</td><td>随 ϑ₂</td></tr>" +
        "<tr><td>C₁₁</td><td>" + Cm[0][0].toFixed(2) + "</td><td>随 ϑ₂</td></tr>" +
        "<tr><td>C₁₂</td><td>" + Cm[0][1].toFixed(2) + "</td><td>随 ϑ₁+ϑ₂</td></tr>" +
        "<tr><td>C₂₁</td><td>" + Cm[1][0].toFixed(2) + "</td><td>随 ϑ₁</td></tr>" +
        "<tr><td>g₁</td><td>" + G[0].toFixed(1) + " N·m</td><td>随姿态（重力矩）</td></tr>" +
        "<tr><td>g₂</td><td>" + G[1].toFixed(1) + " N·m</td><td>随姿态</td></tr>" +
        "</tbody></table>";
      html += "<p class='lab-note'>" + (state.run ? "自由摆动中（t = " + state.t.toFixed(2) + " s，零输入力矩）" : "按「自由摆动」键看 τ=0 时的自由响应") +
        "：B 的<b>位形依赖</b>让同一条轨迹在不同姿态下走得不一样，C 的<b>速度项</b>在高速段显著（离心 ϑ₂² 与科氏 ϑ₁ϑ₂），重力项量级最小但不可忽略。</p>";
      readout.innerHTML = texLite(html);
    }

    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* ================= 实验：chassis3d · 轮系与底盘（ch01 §1.3） ================= */

  function labChassis3D(host) {
    var DEGR = Math.PI / 180;
    var LAYOUTS = [
      {
        id: "diff", name: "差动式", sub: "两同轴定轮 + 被动自位轮",
        note: "两驱动轮同轴、独立驱动；机身靠第三个被动自位轮保持平衡。v=(v₁+v₂)/2、ω=(v₂-v₁)/(2r) —— 想原地旋转就把两轮反向转。",
        wheels: [{ x: -0.32, y: 0.28, drive: true }, { x: -0.32, y: -0.28, drive: true }, { x: 0.42, y: 0, drive: false, caster: true }]
      },
      {
        id: "synchro", name: "同步驱动式", sub: "三个导向轮，牵引/转向机械耦合",
        note: "牵引与转向由机械耦合（如差动机构）分配给三个轮子，机身指向不变——推着走不拐弯，适合直行运输。",
        wheels: [{ x: 0.3, y: 0, drive: true }, { x: -0.15, y: 0.26, drive: true }, { x: -0.15, y: -0.26, drive: true }]
      },
      {
        id: "tricycle", name: "三轮式", sub: "后轴两定轮 + 前舵轮",
        note: "和汽车一样靠舵轮转向：ω=vtanδ/L。定轮不能侧滑，所以转向全靠前轮。",
        wheels: [{ x: -0.3, y: 0.26, drive: true }, { x: -0.3, y: -0.26, drive: true }, { x: 0.38, y: 0, drive: false, steer: true }]
      },
      {
        id: "car", name: "汽车式（阿克曼）", sub: "后定轮 + 两前转向轮",
        note: "阿克曼转向几何：两前轮转角**必须不等**——δᵢₙ=cot⁻¹ (cotδ-L/R)、δₒᵤₜ=cot⁻¹ (cotδ+L/R)，否则内轮会打滑。",
        wheels: [{ x: -0.3, y: 0.26, drive: true }, { x: -0.3, y: -0.26, drive: true }, { x: 0.38, y: 0.3, drive: false, steer: true, inner: true }, { x: 0.38, y: -0.3, drive: false, steer: true, inner: false }]
      },
      {
        id: "omni3", name: "三主动自位轮式", sub: "三个 120° 布置的主动自位轮",
        note: "三个轮子都装在自位支架上、各自能绕竖直轴自由转向，机身控制每个轮子的「速度 + 转向角」就能得到任意平面运动——全向。",
        wheels: [{ x: 0.3, y: 0, drive: true, omni: true }, { x: -0.15, y: 0.26, drive: true, omni: true }, { x: -0.15, y: -0.26, drive: true, omni: true }]
      }
    ];
    var state = { layout: "diff", vl: 0.5, vr: 0.5, delta: 20, mecanum: false };

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "轮系与底盘：轮子怎么转，机身就怎么走"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "选一种底盘布局，拖两个驱动轮的速度，看机身的速度 v 与角速度 ω（绿色箭头）。差速式能原地转、同步式只能直行、汽车式要靠舵轮、阿克曼几何让内外轮转角不等、三自位轮式能横着走。切到「麦克纳姆轮」看 45° 斜置滚子的特殊结构——它让轮子既能推又能横移。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    toggleGroup(controls, "底盘", LAYOUTS.map(function (l) { return { value: l.id, text: l.name }; }), "diff",
      function (v) { state.layout = v; draw(); });
    toggleGroup(controls, "特写", [{ value: "no", text: "整车" }, { value: "yes", text: "麦克纳姆轮" }], "no",
      function (v) { state.mecanum = v === "yes"; draw(); });
    slider(controls, "左轮速度", -1, 1, 0.05, state.vl, function (v) { state.vl = v; draw(); }, function (v) { return v.toFixed(2) + " m/s"; });
    slider(controls, "右轮速度", -1, 1, 0.05, state.vr, function (v) { state.vr = v; draw(); }, function (v) { return v.toFixed(2) + " m/s"; });
    slider(controls, "舵角 δ", -35, 35, 1, state.delta, function (v) { state.delta = v; draw(); }, function (v) { return v.toFixed(0) + "°"; });

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "五种底盘布局的 3D 视图与轮速运动");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);

    var view = makeView(canvas, 0.6, { span: 1.25, center: [0, 0, 0.12], az: -42, elv: 26 });
    view.onChange = function () { draw(); };

    function wheel(v, x, y, r, width, axis, color) {
      /* 轮子：轴向 axis（单位向量），用圆盘近似 */
      var seg = 16, i, ang;
      var u = kernel.norm(Math.abs(axis[0]) < 0.9 ? kernel.crs(axis, [1, 0, 0]) : kernel.crs(axis, [0, 1, 0]));
      var w = kernel.crs(axis, u);
      var c = [x, y, 0];
      for (i = 0; i < seg; i++) {
        var a1 = 2 * Math.PI * i / seg, a2 = 2 * Math.PI * (i + 1) / seg;
        var p1 = kernel.addv(c, kernel.sclv(kernel.addv(kernel.sclv(u, Math.cos(a1)), kernel.sclv(w, Math.sin(a1))), r));
        var p2 = kernel.addv(c, kernel.sclv(kernel.addv(kernel.sclv(u, Math.cos(a2)), kernel.sclv(w, Math.sin(a2))), r));
        var q1 = kernel.addv(p1, kernel.sclv(axis, width / 2));
        var q2 = kernel.addv(p2, kernel.sclv(axis, width / 2));
        var r1 = kernel.addv(p1, kernel.sclv(axis, -width / 2));
        var r2 = kernel.addv(p2, kernel.sclv(axis, -width / 2));
        v.poly([q1, q2, r2, r1], { color: color, both: true });
      }
      v.cyl(kernel.addv(c, kernel.sclv(axis, -width / 2)), kernel.addv(c, kernel.sclv(axis, width / 2)), r * 0.25, { color: color, seg: 8 });
    }

    function draw() {
      var c = palette();
      var layout = LAYOUTS.filter(function (l) { return l.id === state.layout; })[0];

      if (state.mecanum) {
        /* 麦克纳姆轮特写：一个轮 + 45° 斜置滚子 */
        view.grid(0.6, 0.12, -0.3, { color: c.line });
        var R = 0.3;
        var dir = [1, 0, 0];
        wheel(view, 0, 0, R, 0.12, [0, 1, 0], c.blue);
        /* 滚子：沿轮周分布、轴线与轮平面成 45° */
        for (var i = 0; i < 8; i++) {
          var ang = 2 * Math.PI * i / 8;
          var center = [0, 0, 0];
          var radial = [Math.cos(ang), 0, Math.sin(ang)];
          var rc = kernel.sclv(radial, R * 0.78);
          var rollerAxis = kernel.norm([radial[0] * Math.cos(Math.PI / 4), Math.sin(Math.PI / 4), radial[2] * Math.cos(Math.PI / 4)]);
          var half = R * 0.28;
          var A = kernel.addv(rc, kernel.sclv(rollerAxis, -half));
          var Bp = kernel.addv(rc, kernel.sclv(rollerAxis, half));
          view.cyl(A, Bp, 0.028, { color: c.gold, seg: 8 });
        }
        view.label([0, 0, R * 0.85], "轮体（绕 y 轴滚）", c.blue, 12, 0);
        view.label([R * 0.9, 0.12, R * 0.4], "滚子轴 45°", c.gold, 10, 2);
        view.render(null);
        readout.innerHTML = texLite("<p><b>麦克纳姆轮</b>：轮体绕自身轴（y）滚动，轮缘上的滚子轴与轮平面成 <b>45°</b> 斜置。</p>" +
          "<p class='lab-note'>斜置滚子的作用：轮子被驱动向前滚时，滚子与地面的接触线把驱动力分解成**沿轮平面**与**垂直轮平面**两个分量——所以这��轮子既能像普通轮那样推着走，又能横着平移（这正是「全向」的来源）。普通轮做不到横向平移，因为它只有一个滚动自由度。</p>");
        return;
      }

      view.grid(0.75, 0.15, 0, { color: c.line });
      /* 机身 */
      view.box([0, 0, 0.08], [0.42, 0.32, 0.04], kernel.Tid().R, { color: c.neutral });
      view.box([0.1, 0, 0.16], [0.14, 0.12, 0.06], kernel.Tid().R, { color: c.muted });

      /* 轮子 */
      layout.wheels.forEach(function (w) {
        var steer = w.steer ? state.delta * DEGR : 0;
        /* 转向轮：先绕竖直轴转 δ，再按轮轴方向摆 */
        var wheelAxis = [0, 1, 0];
        var axisPos = [0, 1, 0];
        if (w.steer) {
          var ca = Math.cos(steer), sa = Math.sin(steer);
          /* 舵轮绕 z 转 δ：轮轴（原本沿 x）转到 (cosδ, sinδ) */
          axisPos = [ca, sa, 0];
          wheelAxis = [ca, sa, 0];
        }
        var color = w.drive ? c.blue : c.gold;
        wheel(view, w.x, w.y, 0.1, 0.07, wheelAxis, color);
        if (w.caster) {
          /* 自位轮：小球 + 竖直轴 */
          view.sphere([w.x, w.y, 0], 0.05, { color: c.purple });
          view.line([w.x, w.y, 0], [w.x, w.y, 0.1], { color: c.purple, width: 1.4, dash: [4, 3] });
        }
        if (w.omni) {
          /* 自位支架 */
          view.line([w.x, w.y, 0], [w.x, w.y, 0.12], { color: c.purple, width: 1.4 });
        }
      });

      /* 速度与角速度 */
      var v = 0, omega = 0, kind = "";
      if (layout.id === "diff") {
        v = (state.vl + state.vr) / 2; omega = (state.vr - state.vl) / 0.56;
        kind = "差速：v=(v₁+v₂)/(2)，ω=(v₂-v₁)/(2r)";
      } else if (layout.id === "synchro") {
        v = (state.vl + state.vr) / 2; omega = 0;
        kind = "同步驱动：机身指向锁定，ω=0";
      } else if (layout.id === "tricycle" || layout.id === "car") {
        v = (state.vl + state.vr) / 2;
        omega = v * Math.tan(state.delta * DEGR) / 0.68;
        kind = "转向底盘：ω=(vtanδ)/(L)";
      } else {
        v = (state.vl + state.vr) / 2; omega = (state.vr - state.vl) / 0.56;
        kind = "全向：轮向自由，可合成任意 v,ω";
      }
      if (v > 1e-6) {
        view.line([0, 0, 0.25], [0, v, 0.25], { color: c.green, width: 3 });
        view.label([0, v, 0.25], "v = " + v.toFixed(2) + " m/s", c.green, 10, 4);
      }
      if (Math.abs(omega) > 1e-6) {
        view.arc([0, 0, 0.25], [1, 0, 0], [0, 1, 0], 0.34, 0, Math.max(-2.6, Math.min(2.6, omega * 0.6)),
          { color: c.red, width: 2.4 });
        view.label([0.34, 0, 0.25], "ω = " + omega.toFixed(2) + " rad/s", c.red, 10, 4);
      }

      view.render(null);

      var html = "<p><b>" + layout.name + "</b>：" + layout.sub + "。</p>";
      html += "<p class='lab-note'>" + layout.note + "</p>";
      html += "<p class='lab-note'>当前：" + kind + " ⇒ 机身线速度 " + v.toFixed(2) + " m/s、角速度 " + omega.toFixed(2) + " rad/s。" +
        "左右轮同速 = 直行；差速式左右轮反向 = <b>原地旋转</b>（扫地机器人的「转圈」就是它）。</p>";
      if (layout.id === "car") {
        var R = 0.5, L = 0.68, cot = 1 / Math.tan(Math.max(1, Math.abs(state.delta)) * DEGR);
        var din = Math.atan(1 / Math.max(0.05, cot - L / R)) / DEGR;
        var dout = Math.atan(1 / Math.max(0.05, cot + L / R)) / DEGR;
        html += "<p class='lab-note'><b>阿克曼几何</b>：转向半径 R = " + R.toFixed(2) + " m、轴距 L = " + L.toFixed(2) + " m、方向盘转角 δ = " + state.delta + "° ⇒ " +
          "内轮 " + din.toFixed(1) + "°、外轮 " + dout.toFixed(1) + "°（<b>两轮不等</b>）。若两轮都打 δ，内外轮的转弯半径不同，内轮必然侧滑。</p>";
      }
      readout.innerHTML = texLite(html);
    }

    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* ================= 主题 / 纸张配色变化 → 全部重绘（与 robot-labs.js 同一套） ================= */

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

  /* ================= 引导 ================= */

  var registry = {
    zoo3d: labZoo3D,
    euler3d: labEuler3D,
    dh3d: labDH3D,
    anthro3d: labAnthro3D,
    wrist3d: labWrist3D,
    ik3d: labIK3D,
    jac3d: labJac3D,
    sing3d: labSing3D,
    cart3d: labCart3D,
    dyn3d: labDyn3D,
    chassis3d: labChassis3D
  };

  function boot() {
    var hosts = document.querySelectorAll("[data-lab]");
    if (hosts.length === 0) return;
    Array.prototype.forEach.call(hosts, function (host) {
      var name = host.getAttribute("data-lab");
      var builder = registry[name];
      if (builder === undefined) return; /* 其余实验名归 robot-labs.js 管 */
      try {
        var draw = mount(host, builder);
        if (typeof draw === "function") redraws.push(draw);
      } catch (error) {
        host.hidden = true;
      }
    });
  }

  if (typeof document !== "undefined") {
    if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", boot);
    else boot();
    watchRepaint();
  }

  /* node 测试出口：数学内核（不碰 DOM） */
  if (typeof module !== "undefined" && module.exports) {
    module.exports = kernel;
    kernel.texLite = texLite;
  }
})();
