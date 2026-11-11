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
    return String(s).replace(/[]([^]+)[$]/g, function (_, inner) { return texInline(inner); });
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

  kernel.axisDirection = function (direction) {
    if (!Array.isArray(direction) || direction.length !== 3 || !direction.every(Number.isFinite)) throw new Error("轴必须包含三个有限实数");
    var length = Math.hypot.apply(null, direction);
    if (!(length > 0) || !Number.isFinite(length)) throw new Error("零向量不能作为旋转轴");
    return direction.map(function (value) { return value / length; });
  };

  kernel.axisAngleMatrix = function (direction, angle) {
    if (!Number.isFinite(angle)) throw new Error("转角必须是有限实数");
    var axis = kernel.axisDirection(direction);
    var columns = [[1, 0, 0], [0, 1, 0], [0, 0, 1]].map(function (vector) { return kernel.rotAxis(axis, vector, angle); });
    return columns[0].map(function (unused, row) { return columns.map(function (column) { return column[row]; }); });
  };

  kernel.axisAngleSteps = function (direction, angle) {
    if (!Number.isFinite(angle)) throw new Error("转角必须是有限实数");
    var axis = kernel.axisDirection(direction);
    var radius = Math.hypot(axis[0], axis[1]);
    var alpha = radius === 0 ? 0 : Math.atan2(axis[1], axis[0]);
    var beta = Math.atan2(radius, axis[2]);
    var stages = [
      { name: "z", axis: [0, 0, 1], angle: -alpha },
      { name: "y", axis: [0, 1, 0], angle: -beta },
      { name: "z", axis: [0, 0, 1], angle: angle },
      { name: "y", axis: [0, 1, 0], angle: beta },
      { name: "z", axis: [0, 0, 1], angle: alpha }
    ];
    var steps = [{ R: [[1, 0, 0], [0, 1, 0], [0, 0, 1]], axis: null, angle: 0 }];
    stages.forEach(function (stage) {
      var elementary = stage.name === "z" ? kernel.rotZ(stage.angle) : kernel.rotY(stage.angle);
      steps.push({ R: kernel.mul3(elementary, steps[steps.length - 1].R), axis: stage.axis, name: stage.name, angle: stage.angle });
    });
    return { axis: axis, alpha: alpha, beta: beta, steps: steps };
  };

  kernel.rotationQuality = function (rotation) {
    if (!Array.isArray(rotation) || rotation.length !== 3 || !rotation.every(function (row) {
      return Array.isArray(row) && row.length === 3 && row.every(Number.isFinite);
    })) throw new Error("输入必须是有限的 3×3 矩阵");
    var orthogonalError = 0;
    for (var first = 0; first < 3; first++) for (var second = 0; second < 3; second++) {
      var product = 0;
      for (var row = 0; row < 3; row++) product += rotation[row][first] * rotation[row][second];
      orthogonalError = Math.max(orthogonalError, Math.abs(product - (first === second ? 1 : 0)));
    }
    var determinant = kernel.det3(rotation);
    if (orthogonalError > 1e-8 || Math.abs(determinant - 1) > 1e-8) throw new Error("输入不满足旋转矩阵的正交性或 det=1");
    return { orthogonalError: orthogonalError, determinant: determinant };
  };

  kernel.extractAxisAngle = function (rotation) {
    var quality = kernel.rotationQuality(rotation);
    var orthogonalError = quality.orthogonalError, determinant = quality.determinant;
    var skew = [(rotation[2][1] - rotation[1][2]) / 2, (rotation[0][2] - rotation[2][0]) / 2, (rotation[1][0] - rotation[0][1]) / 2];
    var sine = Math.hypot.apply(null, skew);
    var cosine = Math.max(-1, Math.min(1, (rotation[0][0] + rotation[1][1] + rotation[2][2] - 1) / 2));
    var angle = Math.atan2(sine, cosine);
    if (sine < 1e-12 && cosine > 0) return { angle: 0, axis: null, vector: [0, 0, 0], branch: "zero", orthogonalError: orthogonalError, determinant: determinant };
    var axis;
    var branch = "regular";
    if (cosine < -0.999999) {
      var symmetric = rotation.map(function (values, rowIndex) {
        return values.map(function (value, column) {
          return ((value + rotation[column][rowIndex]) / 2 - (rowIndex === column ? cosine : 0)) / (1 - cosine);
        });
      });
      var pivot = symmetric[1][1] > symmetric[0][0] ? 1 : 0;
      if (symmetric[2][2] > symmetric[pivot][pivot]) pivot = 2;
      var component = Math.sqrt(Math.max(0, symmetric[pivot][pivot]));
      axis = kernel.axisDirection(symmetric.map(function (values) { return values[pivot] / component; }));
      if (sine >= 1e-12 && kernel.dot(axis, skew) < 0) axis = kernel.sclv(axis, -1);
      branch = sine < 1e-12 ? "pi" : "near-pi";
    } else {
      axis = kernel.sclv(skew, 1 / sine);
    }
    return { angle: angle, axis: axis, vector: kernel.sclv(axis, angle), branch: branch, orthogonalError: orthogonalError, determinant: determinant };
  };

  kernel.unitQuaternion = function (quaternion) {
    if (!Array.isArray(quaternion) || quaternion.length !== 4 || !quaternion.every(Number.isFinite)) throw new Error("四元数须为标量在前的四个有限实数");
    var length = Math.hypot.apply(null, quaternion);
    if (!(length > 0) || !Number.isFinite(length)) throw new Error("零四元数不能归一化");
    return quaternion.map(function (value) { return value / length; });
  };

  function requireUnitQuaternion(quaternion) {
    var normalized = kernel.unitQuaternion(quaternion);
    if (Math.abs(Math.hypot.apply(null, quaternion) - 1) > 1e-8) throw new Error("输入须满足单位四元数约束");
    return normalized;
  }

  kernel.quaternionFromAxis = function (direction, angle) {
    if (!Number.isFinite(angle)) throw new Error("转角必须是有限实数");
    var axis = kernel.axisDirection(direction);
    return [Math.cos(angle / 2)].concat(kernel.sclv(axis, Math.sin(angle / 2)));
  };

  kernel.quaternionMatrix = function (quaternion) {
    var values = requireUnitQuaternion(quaternion);
    var scalar = values[0], horizontal = values[1], vertical = values[2], depth = values[3];
    return [
      [2 * (scalar * scalar + horizontal * horizontal) - 1, 2 * (horizontal * vertical - scalar * depth), 2 * (horizontal * depth + scalar * vertical)],
      [2 * (horizontal * vertical + scalar * depth), 2 * (scalar * scalar + vertical * vertical) - 1, 2 * (vertical * depth - scalar * horizontal)],
      [2 * (horizontal * depth - scalar * vertical), 2 * (vertical * depth + scalar * horizontal), 2 * (scalar * scalar + depth * depth) - 1]
    ];
  };

  kernel.quaternionProduct = function (first, second) {
    var left = requireUnitQuaternion(first), right = requireUnitQuaternion(second);
    var leftVector = left.slice(1), rightVector = right.slice(1);
    return [left[0] * right[0] - kernel.dot(leftVector, rightVector)].concat(
      kernel.addv(kernel.addv(kernel.sclv(rightVector, left[0]), kernel.sclv(leftVector, right[0])), kernel.crs(leftVector, rightVector))
    );
  };

  kernel.quaternionInverse = function (quaternion) {
    var values = requireUnitQuaternion(quaternion);
    return [values[0], -values[1], -values[2], -values[3]];
  };

  kernel.quaternionExtract = function (rotation) {
    var quality = kernel.rotationQuality(rotation);
    var horizontal = rotation[0][0], vertical = rotation[1][1], depth = rotation[2][2];
    var crossX = rotation[2][1] - rotation[1][2];
    var crossY = rotation[0][2] - rotation[2][0];
    var crossZ = rotation[1][0] - rotation[0][1];
    var sumXY = rotation[0][1] + rotation[1][0];
    var sumXZ = rotation[0][2] + rotation[2][0];
    var sumYZ = rotation[1][2] + rotation[2][1];
    var symmetric = [
      [1 + horizontal + vertical + depth, crossX, crossY, crossZ],
      [crossX, 1 + horizontal - vertical - depth, sumXY, sumXZ],
      [crossY, sumXY, 1 - horizontal + vertical - depth, sumYZ],
      [crossZ, sumXZ, sumYZ, 1 - horizontal - vertical + depth]
    ];
    var pivot = 0;
    for (var index = 1; index < 4; index++) if (symmetric[index][index] > symmetric[pivot][pivot]) pivot = index;
    var component = Math.sqrt(Math.max(0, symmetric[pivot][pivot])) / 2;
    var quaternion = kernel.unitQuaternion(symmetric.map(function (row) { return row[pivot] / (4 * component); }));
    return { quaternion: quaternion, pivot: pivot, orthogonalError: quality.orthogonalError, determinant: quality.determinant };
  };

  kernel.quaternionSignCandidate = function (rotation) {
    kernel.rotationQuality(rotation);
    var horizontal = rotation[0][0], vertical = rotation[1][1], depth = rotation[2][2];
    var signs = [rotation[2][1] - rotation[1][2], rotation[0][2] - rotation[2][0], rotation[1][0] - rotation[0][1]];
    var squares = [1 + horizontal + vertical + depth, 1 + horizontal - vertical - depth, 1 - horizontal + vertical - depth, 1 - horizontal - vertical + depth];
    return squares.map(function (value, index) { return Math.sqrt(Math.max(0, value)) / 2 * (index === 0 || signs[index - 1] >= 0 ? 1 : -1); });
  };

  kernel.compositionSteps = function (angleY, angleZ, mode, order, initial) {
    var rotations = { y: kernel.rotY(angleY * DEG), z: kernel.rotZ(angleZ * DEG) };
    var directions = { y: [0, 1, 0], z: [0, 0, 1] };
    var steps = [{ R: initial, axis: null }];
    order.split("").forEach(function (name) {
      var previous = steps[steps.length - 1].R;
      var axis = mode === "fixed" ? directions[name] : kernel.Trot({ R: previous }, directions[name]);
      var rotation = rotations[name];
      steps.push({
        R: mode === "fixed" ? kernel.mul3(rotation, previous) : kernel.mul3(previous, rotation),
        axis: axis
      });
    });
    return steps;
  };

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

  function requirePose(pose) {
    if (!pose || !Array.isArray(pose.p) || pose.p.length !== 3 || !pose.p.every(Number.isFinite)) throw new Error("位姿平移须含三个有限实数");
    kernel.rotationQuality(pose.R);
    return pose;
  }

  kernel.Tmatrix = function (pose) {
    requirePose(pose);
    return pose.R.map(function (row, index) { return row.concat(pose.p[index]); }).concat([[0, 0, 0, 1]]);
  };

  kernel.Tinverse = function (pose) {
    requirePose(pose);
    var transpose = pose.R[0].map(function (unused, column) { return pose.R.map(function (row) { return row[column]; }); });
    return { R: transpose, p: kernel.sclv(kernel.Trot({ R: transpose }, pose.p), -1) };
  };

  kernel.homogeneousSteps = function (firstAngle, secondAngle, origin, offset) {
    if (![firstAngle, secondAngle, offset].every(Number.isFinite)) throw new Error("转角和位移必须是有限实数");
    var first = requirePose({ R: kernel.rotZ(firstAngle * DEG), p: origin });
    var second = { R: kernel.rotX(secondAngle * DEG), p: [offset, 0, 0] };
    var combined = kernel.Tmul(first, second);
    var input = [0, 1, 0];
    var intermediatePoint = kernel.Tvec(second, input);
    var intermediateDirection = kernel.Trot(second, input);
    return {
      first: first, second: second, combined: combined, inverse: kernel.Tinverse(combined),
      wrong: kernel.Tmul(second, first),
      points: [input.slice(), intermediatePoint, kernel.Tvec(first, intermediatePoint)],
      directions: [input.slice(), intermediateDirection, kernel.Trot(first, intermediateDirection)],
      frames: [combined, first, kernel.Tid()]
    };
  };

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
    var sb = Math.hypot(R[0][2], R[1][2]);
    if (sb < 1e-12) {
      var parallel = R[2][2] > 0;
      var combined = Math.atan2(parallel ? R[1][0] : -R[1][0], parallel ? R[0][0] : -R[0][0]) / DEG;
      return { ok: false, phi: combined, theta: parallel ? 0 : 180, psi: 0, radius: sb, combination: parallel ? "φ+ψ" : "φ−ψ" };
    }
    return { ok: true, phi: Math.atan2(R[1][2], R[0][2]) / DEG, theta: Math.atan2(sb, R[2][2]) / DEG, psi: Math.atan2(R[2][1], -R[2][0]) / DEG, radius: sb };
  };
  kernel.extractRPY = function (R) {
    var cb = Math.hypot(R[0][0], R[1][0]);
    if (cb < 1e-12) {
      var positive = R[2][0] < 0;
      return { ok: false, phi: Math.atan2(-R[0][1], R[1][1]) / DEG, theta: positive ? 90 : -90, psi: 0, radius: cb, combination: positive ? "φ−ψ" : "φ+ψ" };
    }
    return { ok: true, phi: Math.atan2(R[1][0], R[0][0]) / DEG, theta: Math.atan2(-R[2][0], cb) / DEG, psi: Math.atan2(R[2][1], R[2][2]) / DEG, radius: cb };
  };
  kernel.eulerSteps = function (mode, phi, theta, psi) {
    var names = mode === "zyz" ? ["z", "y", "z"] : ["x", "y", "z"];
    var angles = mode === "zyz" ? [phi, theta, psi] : [psi, theta, phi];
    var directions = { x: [1, 0, 0], y: [0, 1, 0], z: [0, 0, 1] };
    var rotations = { x: kernel.rotX, y: kernel.rotY, z: kernel.rotZ };
    var steps = [{ R: kernel.Tid().R, axis: null }];
    names.forEach(function (name, index) {
      var previous = steps[steps.length - 1].R;
      var rotation = rotations[name](angles[index] * DEG);
      steps.push({
        R: mode === "zyz" ? kernel.mul3(previous, rotation) : kernel.mul3(rotation, previous),
        axis: mode === "zyz" ? kernel.Trot({ R: previous }, directions[name]) : directions[name],
        name: name,
        angle: angles[index]
      });
    });
    return steps;
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
  // Output-space velocity set: directions are eigenvectors of J Jᵀ.
  kernel.velocityEllipsoid = function (J) {
    var E = J.map(function (row) {
      return J.map(function (other) {
        return row.reduce(function (sum, value, k) { return sum + value * other[k]; }, 0);
      });
    });
    var eig = kernel.symEig3(E);
    var order = [0, 1, 2].sort(function (a, b) { return eig.values[a] - eig.values[b]; });
    return {
      axes: order.map(function (idx) { return [eig.vectors[0][idx], eig.vectors[1][idx], eig.vectors[2][idx]]; }),
      sigma: order.map(function (idx) { return Math.sqrt(Math.max(0, eig.values[idx])); }),
      w: Math.abs(kernel.det3(J))
    };
  };

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
    /* 行数恒为 3，列数必须随关节数 n 走：写死三列会让 7 自由度（DLR）这类
       非三关节机构拿到带空洞的矩阵，读数里出现 undefined → NaN。 */
    var J = [[], [], []];
    for (var r = 0; r < 3; r++) for (var c0 = 0; c0 < n; c0++) J[r][c0] = 0;
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
    var c3raw = (norm2 - a2 * a2 - a3 * a3) / (2 * a2 * a3);
    /* 边界容差：臂恰好伸直/折回时 ‖p‖=a₂±a₃，浮点舍入会让 c₃ 略大于 1，
       若直接判 >1 不可达，会在可达边界上误报「无解」。夹到 [-1,1] 再算 s₃。 */
    var c3 = Math.max(-1, Math.min(1, c3raw));
    var out = { reachable: Math.abs(c3raw) <= 1 + 1e-12, c3: c3, R: R, shoulderSingular: R < 1e-9, solutions: [] };
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
      view.prims.push({ kind: o.arrow ? "axis" : "path", a: a, b: b, pts: [a, b], color: o.color, width: o.width || 1.6, dash: o.dash, hl: o.hl, noDim: o.noDim });
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
        jr, { color: opt.jointTypes && opt.jointTypes[i] === "P" ? c.gold : c.green, hl: opt.hlTheta && opt.hlTheta + i, seg: 10 }
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

  kernel.zooKinds = function () {
    var HALF_PI = Math.PI / 2;

    /* 各构形定义：rows 为 DH 行（type: R/P，range: 关节范围，def: 默认值） */
    var KINDS = [
      {
        id: "cartesian", name: "笛卡儿型", seq: "移动 ×3（PPP）", ws: "长方体",
        rows: [
          { alpha: -HALF_PI, a: 0, d: 0, th: 0, type: "P", label: "d₁（立柱升降）", range: [-0.45, 0.45], def: 0.18 },
          { alpha: HALF_PI, a: 0, d: 0, th: HALF_PI, type: "P", label: "d₂（横梁平移）", range: [-0.35, 0.35], def: 0.22 },
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
        id: "scara", name: "SCARA", seq: "转动 + 转动 + 移动（臂 RRP + 腕 R，整体 RRPR）", ws: "扁形回转体",
        rows: [
          { alpha: 0, a: 0.5, d: 0, th: 0, type: "R", label: "θ₁", range: [-140, 140], def: 25 },
          { alpha: 0, a: 0.42, d: 0, th: 0, type: "R", label: "θ₂", range: [-150, 150], def: -45 },
          { alpha: 0, a: 0, d: 0, th: 0, type: "P", label: "d₃（竖直下压）", range: [-0.4, 0], def: -0.18 },
          { alpha: 0, a: 0, d: 0, th: 0, type: "R", label: "θ₄（腕回转）", range: [-180, 180], def: 0 }
        ],
        note: "四根关节轴全平行（都竖直）：水平面内两个转动定位、竖直方向移动下压——竖直刚、水平顺从，天生适合插装。"
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
        note: "2.9.2 的闭链：O–A–B–C 构成平行四边形，两个驱动关节都装在基座（执行器不上臂）；本图只表示几何约束，不计算承载或刚度。"
      },
      {
        id: "anthro", name: "拟人臂", seq: "转动 ×3（腰—肩—肘，RRR）", ws: "近似球体",
        rows: [
          { alpha: HALF_PI, a: 0, d: 0, th: 0, type: "R", label: "θ₁（腰）", range: [-150, 150], def: 20 },
          { alpha: 0, a: 0.62, d: 0, th: 0, type: "R", label: "θ₂（肩）", range: [-90, 90], def: 42 },
          { alpha: 0, a: 0.52, d: 0, th: 0, type: "R", label: "θ₃（肘）", range: [-140, 140], def: -70 }
        ],
        note: "2.9.4：腰轴竖直、肩肘轴水平平行，像人的胳膊；关节角与末端坐标通常相互耦合。"
      },
      {
        id: "anthroWrist", name: "拟人臂 + 球形腕", seq: "转动 ×6（3R 臂 + 三轴共点腕）", ws: "近似球体",
        rows: [
          { alpha: HALF_PI, a: 0, d: 0, th: 0, type: "R", label: "θ₁（腰）", range: [-150, 150], def: 15 },
          { alpha: 0, a: 0.55, d: 0, th: 0, type: "R", label: "θ₂（肩）", range: [-70, 80], def: 35 },
          { alpha: HALF_PI, a: 0, d: 0, th: 0, type: "R", label: "θ₃（肘）", range: [-120, 120], def: 35 },
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
    /* ---- 第二轮补充：DLR 七自由度冗余臂（2.9.8）与并联机构（1.2.3） ---- */
    var KINDS_EXTRA = [
      {
        id: "dlr", name: "DLR 七自由度", seq: "转动 ×7（7R）", ws: "近似球体",
        rows: [
          { alpha: HALF_PI, a: 0, d: 0, th: 0, type: "R", label: "θ₁", range: [-140, 140], def: 20 },
          { alpha: HALF_PI, a: 0, d: 0, th: 0, type: "R", label: "θ₂", range: [-180, 180], def: 150 },
          { alpha: HALF_PI, a: 0, d: 0.22, th: 0, type: "R", label: "θ₃", range: [-180, 180], def: 45 },
          { alpha: HALF_PI, a: 0, d: 0, th: 0, type: "R", label: "θ₄", range: [-180, 180], def: 140 },
          { alpha: HALF_PI, a: 0, d: 0.2, th: 0, type: "R", label: "θ₅", range: [-180, 180], def: 35 },
          { alpha: HALF_PI, a: 0, d: 0, th: 0, type: "R", label: "θ₆", range: [-180, 180], def: 40 },
          { alpha: 0, a: 0, d: 0.12, th: 0, type: "R", label: "θ₇", range: [-180, 180], def: 15 }
        ],
        note: "2.9.8：DLR 机械手全表 aᵢ=0、αᵢ=π/2（i=1…6）、α₇=0，七个变量都是转角 θ₁…θ₇；d₃、d₅、d₇ 是固定连杆尺寸。七个自由度对六维位姿是<b>本质冗余</b>（见 2.10.3）——在满秩的可达位形附近，同一末端位姿通常有一族关节解。"
      },
      {
        id: "parallel", name: "并联升降示意", seq: "四条伸缩支链连接固定基座与平台", ws: "竖直线段",
        custom: "parallel",
        rows: [{ alpha: 0, a: 0, d: 0, th: 0, type: "P", label: "平台高度 h", range: [0.25, 0.7], def: 0.45 }],
        note: "本教学示意假定中央导向柱只允许平台竖直平移，四条伸缩支链同步伸长。支链通过基座和平台共同构成回路；单独一条支链并不是闭链。这是 1 自由度升降机构，不是 FlexPicker 的结构模型；图中不计算刚度或速度。"
      }
    ];

    return KINDS.concat(KINDS_EXTRA);
  };

  kernel.zooParallelGeometry = function (h) {
    var phis = [Math.PI / 4, 3 * Math.PI / 4, 5 * Math.PI / 4, 7 * Math.PI / 4];
    return phis.map(function (phi) {
      var B = [0.4 * Math.cos(phi), 0.4 * Math.sin(phi), 0];
      var P = [0.2 * Math.cos(phi), 0.2 * Math.sin(phi), h];
      return { base: B, platform: P, length: kernel.len(kernel.subv(P, B)) };
    });
  };

  function labZoo3D(host) {
    var KINDS = kernel.zooKinds();
    var state = { kind: "anthro", q: [], hover: null };

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "构形动物园：比较关节轴与工具点运动"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "选择构形，再逐个调整关节。绿色为转动关节、金色为移动关节；虚线是关节轴，红点 P 是读数对应的末端原点。末端坐标轴显示朝向。球形腕另用蓝点 W 标出腕心。画布可拖转、滚轮缩放；本演示未计算可达边界，工作空间应结合正文的轴几何与限位理解。"));

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
    var resetButton = el("button", "lab-btn", "重置当前关节");
    resetButton.type = "button";
    resetButton.addEventListener("click", function () { resetSliders(); draw(); });
    controls.appendChild(resetButton);

    function resetSliders() {
      sliderRefs.forEach(function (r) {
        /* 容错：重复切换构形时控件可能已被移除，硬取 parentNode 会空指针 */
        var wrap = r.input && r.input.parentNode;
        if (wrap && wrap.parentNode) wrap.parentNode.removeChild(wrap);
      });
      sliderRefs = [];
      var kind = KINDS.find(function (k) { return k.id === state.kind; });
      kind.rows.forEach(function (row, i) {
        sliderRefs.push(slider(controls, row.label, row.range[0], row.range[1], row.type === "P" ? 0.01 : 1, row.def, function (v) {
          state.q[i] = v;
          draw();
        }, function (v) { return v.toFixed(row.type === "P" ? 2 : 0) + (row.type === "P" ? " m" : "°"); }));
      });
      state.q = kind.rows.map(function (row) { return row.def; });
      if (view) {
        view.cam.zoom = kind.id === "dlr" ? 2 : 1.3;
        view.center[0] = kind.id === "anthroWrist" ? 0.35 : 0;
        view.center[2] = kind.id === "dlr" ? 0.18 : 0.28;
      }
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

    function drawParallel(v, kind, h) {
      var c = palette();
      v.box([0, 0, -0.03], [0.5, 0.5, 0.025], kernel.Tid().R, { color: c.neutral });
      v.cyl([0, 0, 0], [0, 0, 0.76], 0.035, { color: c.muted });
      v.box([0, 0, h], [0.18, 0.18, 0.025], kernel.Tid().R, { color: c.gold });
      kernel.zooParallelGeometry(h).forEach(function (leg) {
        var midpoint = kernel.sclv(kernel.addv(leg.base, leg.platform), 0.5);
        v.cyl(leg.base, midpoint, 0.032, { color: c.blue });
        v.cyl(midpoint, leg.platform, 0.019, { color: c.gold });
        v.sphere(leg.base, 0.035, { color: c.green });
        v.sphere(leg.platform, 0.028, { color: c.green });
      });
      v.sphere([0, 0, h], 0.03, { color: c.red });
      v.label([0, 0, h], "平台中心 P", c.red, 12, -18);
      v.label([0, 0, 0.76], "竖直导向", c.muted, -90, -20);
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
      } else if (kind.custom === "parallel") {
        drawParallel(view, kind, state.q[0]);
      } else {
        var frames = kernel.fkChain(rows, q);
        drawChain(view, frames, {
          toolLen: 0,
          triads: true, frameRange: [rows.length, rows.length], triadSize: 0.16,
          jointTypes: rows.map(function (row) { return row.type; }),
          jointR: kind.id === "dlr" ? 0.035 : 0.06,
          linkR: kind.id === "dlr" ? 0.025 : 0.04,
          baseH: 0.001
        });
        if (kind.id === "anthroWrist" || kind.id === "stanford") {
          var wrist = frames[4].o;
          view.sphere(wrist, 0.042, { color: palette().blue });
          view.label(wrist, "腕心 W", palette().blue, 12, -16);
          view.label(frames[rows.length].o, "工具点 P", palette().red, 12, 16);
        }
        /* 移动关节画导轨示意：金色细杆沿轴向 */
        rows.forEach(function (row, i) {
          if (row.type !== "P") return;
          var f = frames[i];
          var dir = f.z;
          var near = kernel.addv(f.o, kernel.sclv(dir, row.range[0] - 0.06));
          var far = kernel.addv(f.o, kernel.sclv(dir, row.range[1] + 0.06));
          view.cyl(near, far, 0.02, { color: palette().gold });
        });
      }

      var endF = kind.custom ? null : kernel.fkChain(rows, q);
      view.render(state.hover);

      var dofText = kind.custom === "para"
        ? "独立驱动变量 2 个（其余关节运动受闭链几何约束）"
        : (kind.custom === "parallel" ? "在竖直导向与四腿同步假设下，自由度 1" : "自由度 " + rows.length);
      var html = "<p><b>" + kind.name + "</b>：" + kind.seq + "；" + dofText + "。</p>";
      html += "<p class='lab-note'>" + kind.note + "</p>";
      html += "<p class='lab-note'>长度和滑杆范围为教学设定，不代表实机尺寸、限位或无碰撞范围。</p>";
      function xyz(p) { return "(" + p.map(function (x) { return x.toFixed(3); }).join(", ") + ") m"; }
      if (endF) {
        var last = endF[endF.length - 1];
        html += "<p data-zoo-point='P'>红点 P：" + xyz(last.o) + "。</p>";
        html += "<p data-zoo-axis='x'>工具 x 轴方向（无量纲）：(" + last.x.map(function (x) { return x.toFixed(3); }).join(", ") + ")。</p>";
        if (kind.id === "anthroWrist" || kind.id === "stanford") {
          var W = endF[4].o;
          html += "<p data-zoo-point='W'>蓝点 W（腕心）：" + xyz(W) + "；工具偏置 |P−W| = " + kernel.len(kernel.subv(last.o, W)).toFixed(3) + " m。只转腕时 W 不动，P 可以移动；末端绝对朝向同时取决于臂与腕。</p>";
        }
      } else if (kind.custom === "parallel") {
        html += "<p data-zoo-point='P'>平台中心 P：" + xyz([0, 0, state.q[0]]) + "；每条支链长 " + kernel.zooParallelGeometry(state.q[0])[0].length.toFixed(3) + " m。</p>";
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

  function labComposition3D(host) {
    var state = { angleY: 90, angleZ: 90, mode: "fixed", order: "yz", initial: "identity", step: 2 };
    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "两次旋转：轴在哪里，因子就接在哪里"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "蓝、绿、金色为工具 x′、y′、z′ 轴，灰色为固定轴；红线标出所选步骤使用的转轴。拖动画布改变观察方向，滚轮缩放。矩阵、三轴坐标和画布始终对应同一步；第 0 步尚未转动。"));
    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    var modeButtons = toggleGroup(controls, "轴的约定", [
      { value: "fixed", text: "固定轴 · 左乘" }, { value: "current", text: "当前轴 · 右乘" }
    ], state.mode, function (value) { state.mode = value; draw(); });
    var orderButtons = toggleGroup(controls, "发生顺序", [
      { value: "yz", text: "先 y 后 z" }, { value: "zy", text: "先 z 后 y" }
    ], state.order, function (value) { state.order = value; draw(); });
    var initialButtons = toggleGroup(controls, "初始姿态", [
      { value: "identity", text: "初始 I" }, { value: "tilted", text: "初始 Rx(45°)" }
    ], state.initial, function (value) { state.initial = value; draw(); });
    var angleY = slider(controls, "绕 y 的角 α", -180, 180, 1, 90, function (value) { state.angleY = value; draw(); }, degrees);
    var angleZ = slider(controls, "绕 z 的角 β", -180, 180, 1, 90, function (value) { state.angleZ = value; draw(); }, degrees);
    var step = slider(controls, "显示到第几步", 0, 2, 1, 2, function (value) { state.step = value; draw(); });
    var reset = el("button", "lab-btn", "重置旋转与视角");
    reset.type = "button";
    controls.appendChild(reset);
    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "两步旋转合成的三维坐标架，精确方向见下方读数");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    readout.setAttribute("aria-atomic", "true");
    host.appendChild(readout);
    var view = makeView(canvas, 0.6, { span: 1.5, center: [0, 0, 0], az: -30, elv: 18 });
    view.onChange = draw;

    function degrees(value) { return value + "°"; }
    function vectorText(vector) {
      return "(" + vector.map(function (value) { return (Math.abs(value) < 0.0005 ? 0 : value).toFixed(3); }).join(", ") + ")";
    }
    function roundedMatrix(matrix) {
      return matrix.map(function (row) { return row.map(function (value) { return Math.abs(value) < 0.0005 ? 0 : value; }); });
    }
    function expression(order) {
      var factors = order.slice(0, state.step).split("").map(function (axis) {
        return axis === "y" ? "Ry(" + degrees(state.angleY) + ")" : "Rz(" + degrees(state.angleZ) + ")";
      });
      var start = state.initial === "identity" ? "I" : "Rx(45°)";
      return state.mode === "fixed" ? factors.reverse().concat([start]).join(" · ") : [start].concat(factors).join(" · ");
    }
    function difference(first, second) {
      return Math.max.apply(null, first.map(function (row, rowIndex) {
        return Math.max.apply(null, row.map(function (value, column) { return Math.abs(value - second[rowIndex][column]); }));
      }));
    }
    function draw() {
      var colors = palette();
      var initial = state.initial === "identity" ? kernel.Tid().R : kernel.rotX(45 * DEG);
      var swapped = state.order === "yz" ? "zy" : "yz";
      var steps = kernel.compositionSteps(state.angleY, state.angleZ, state.mode, state.order, initial);
      var selected = steps[state.step];
      var comparison = kernel.compositionSteps(state.angleY, state.angleZ, state.mode, swapped, initial)[state.step];
      var reverseOther = kernel.compositionSteps(state.angleY, state.angleZ, state.mode === "fixed" ? "current" : "fixed", swapped, initial)[2];
      view.grid(0.8, 0.2, -0.55, { color: colors.line });
      view.triad([0, 0, 0], kernel.Tid().R, 0.78, ["x₀", "y₀", "z₀"], { colors: [colors.muted, colors.muted, colors.muted], width: 1.3 });
      view.box([0, 0, 0], [0.14, 0.1, 0.2], selected.R, { color: colors.neutral });
      view.triad([0, 0, 0], selected.R, 0.56, ["x′", "y′", "z′"], { colors: [colors.blue, colors.green, colors.gold], width: 2.8 });
      if (selected.axis) {
        view.line(kernel.sclv(selected.axis, -0.7), kernel.sclv(selected.axis, 0.7), { color: colors.red, width: 3 });
      }
      view.render();
      var axes = [0, 1, 2].map(function (column) { return selected.R.map(function (row) { return row[column]; }); });
      var axisName = state.step === 0 ? "尚无新增转轴" : "本步绕" + (state.mode === "fixed" ? "固定 " : "上一步工具系的 ") + state.order[state.step - 1] + " 轴；其固定系方向 " + vectorText(selected.axis);
      readout.innerHTML = "";
      readout.appendChild(el("p", null, "第 " + state.step + " 步 / 共 2 步。" + axisName + "。"));
      readout.appendChild(el("p", null, "本序 R = " + expression(state.order)));
      var matrix = el("div");
      matrix.setAttribute("data-composition-matrix", "selected");
      matrix.innerHTML = matrixHTML(roundedMatrix(selected.R), 3);
      readout.appendChild(matrix);
      readout.appendChild(el("p", null, "工具轴在固定系的坐标：x′ = " + vectorText(axes[0]) + "；y′ = " + vectorText(axes[1]) + "；z′ = " + vectorText(axes[2]) + "。"));
      readout.appendChild(el("p", null, "交换发生顺序、保持轴约定和初始姿态，同样显示第 " + state.step + " 步：R = " + expression(swapped)));
      var otherMatrix = el("div");
      otherMatrix.setAttribute("data-composition-matrix", "swapped");
      otherMatrix.innerHTML = matrixHTML(roundedMatrix(comparison.R), 3);
      readout.appendChild(otherMatrix);
      readout.appendChild(el("p", null, "同一步两矩阵的最大元素差 = " + difference(selected.R, comparison.R).toFixed(3) + (state.step < 2 ? "；尚未完成两步，不能据此判断最终是否可交换。" : "；读数保留三位小数，接近 0 时应结合精确公式判断是否相同。")));
      readout.appendChild(el("p", null, "另作完整两步比较：改用另一轴约定并倒序，终态最大元素差 = " + difference(steps[2].R, reverseOther.R).toFixed(3) + "。从 I 出发恒为 0；初始倾斜后一般不为 0。"));
    }
    reset.addEventListener("click", function () {
      state.angleY = 90;
      state.angleZ = 90;
      state.mode = "fixed";
      state.order = "yz";
      state.initial = "identity";
      state.step = 2;
      [[angleY, 90, "90°"], [angleZ, 90, "90°"], [step, 2, "2"]].forEach(function (entry) {
        entry[0].input.value = entry[1];
        entry[0].out.textContent = entry[2];
      });
      [modeButtons, orderButtons, initialButtons].forEach(function (buttons) {
        buttons.forEach(function (button, index) {
          button.classList.toggle("on", index === 0);
          button.setAttribute("aria-pressed", index === 0 ? "true" : "false");
        });
      });
      view.cam.az = -30;
      view.cam.elv = 18;
      view.cam.zoom = 1;
      draw();
    });
    host.hidden = false;
    draw();
    return draw;
  }

  function labEuler3D(host) {
    var state = { mode: "zyz", phi: 30, theta: 55, psi: 20, step: 3 };
    var message = "";
    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "欧拉角：逐步合成，或保持姿态换一套角"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "灰色为固定轴，蓝/绿/金色为工具三轴，红线为本步转轴。矩阵与方向读数始终对应同一步。普通约定按钮保留三个数并重算姿态；同姿态转换按钮对当前显示矩阵反解。拖动画布和滚轮只改变视角。"));
    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    var modeButtons = toggleGroup(controls, "约定（保留三个数）", [
      { value: "zyz", text: "ZYZ" }, { value: "rpy", text: "RPY" }
    ], state.mode, function (value) { state.mode = value; message = ""; draw(); });
    function degrees(value) { return value.toFixed(6).replace(/\.?0+$/, "") + "°"; }
    var phi = slider(controls, "φ", -180, 180, "any", state.phi, function (value) { state.phi = value; message = ""; draw(); }, degrees);
    var theta = slider(controls, "ϑ", -180, 180, "any", state.theta, function (value) { state.theta = value; message = ""; draw(); }, degrees);
    var psi = slider(controls, "ψ", -180, 180, "any", state.psi, function (value) { state.psi = value; message = ""; draw(); }, degrees);
    var step = slider(controls, "显示到第几步", 0, 3, 1, state.step, function (value) { state.step = value; message = ""; draw(); });
    var convert = el("button", "lab-btn", "同一姿态换成另一套角");
    convert.type = "button";
    controls.appendChild(convert);
    var reset = el("button", "lab-btn", "重置旋转与视角");
    reset.type = "button";
    controls.appendChild(reset);
    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "所选步骤的三维坐标架；精确方向和转轴见下方读数");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    readout.setAttribute("aria-atomic", "true");
    host.appendChild(readout);
    var view = makeView(canvas, 0.6, { span: 1.5, center: [0, 0, 0], az: -30, elv: 18 });
    view.onChange = draw;

    function vectorText(vector) {
      return "(" + vector.map(function (value) { return (Math.abs(value) < 0.0000005 ? 0 : value).toFixed(6); }).join(", ") + ")";
    }
    function difference(first, second) {
      return Math.max.apply(null, first.map(function (row, rowIndex) {
        return Math.max.apply(null, row.map(function (value, column) { return Math.abs(value - second[rowIndex][column]); }));
      }));
    }
    function selected() { return kernel.eulerSteps(state.mode, state.phi, state.theta, state.psi)[state.step]; }
    function inverse(mode, rotation) { return mode === "zyz" ? kernel.extractZYZ(rotation) : kernel.extractRPY(rotation); }
    function forward(mode, angles) { return mode === "zyz" ? kernel.zyzMatrix(angles.phi, angles.theta, angles.psi) : kernel.rpyMatrix(angles.phi, angles.theta, angles.psi); }
    function syncControls() {
      [[phi, state.phi], [theta, state.theta], [psi, state.psi], [step, state.step]].forEach(function (entry, index) {
        entry[0].input.value = entry[1];
        entry[0].out.textContent = index < 3 ? degrees(entry[1]) : String(entry[1]);
      });
      modeButtons.forEach(function (button, index) {
        var active = index === (state.mode === "zyz" ? 0 : 1);
        button.classList.toggle("on", active);
        button.setAttribute("aria-pressed", active ? "true" : "false");
      });
    }
    function draw() {
      var colors = palette();
      var current = selected();
      var rotation = current.R;
      view.grid(0.8, 0.2, -0.55, { color: colors.line });
      view.triad([0, 0, 0], kernel.Tid().R, 0.78, ["x₀", "y₀", "z₀"], { colors: [colors.muted, colors.muted, colors.muted], width: 1.3 });
      view.box([0, 0, 0], [0.14, 0.1, 0.2], rotation, { color: colors.neutral });
      view.triad([0, 0, 0], rotation, 0.56, ["x′", "y′", "z′"], { colors: [colors.blue, colors.green, colors.gold], width: 2.8 });
      if (current.axis) {
        view.line(kernel.sclv(current.axis, -0.7), kernel.sclv(current.axis, 0.7), { color: colors.red, width: 3 });
      }
      view.render();
      readout.innerHTML = "";
      readout.appendChild(el("p", null, state.mode.toUpperCase() + " 第 " + state.step + " 步 / 共 3 步：" + (current.axis
        ? "本步绕" + (state.mode === "zyz" ? "上一步工具系的 " : "固定 ") + current.name + " 轴转 " + degrees(current.angle) + "；转轴的固定系方向 " + vectorText(current.axis)
        : "初始姿态 I，尚无新增转轴") + "。"));
      readout.appendChild(el("p", "lab-note", state.mode === "zyz" ? "发生顺序：当前 z(φ) → 新 y(ϑ) → 新 z(ψ)，逐次右乘。" : "发生顺序：固定 x(ψ) → 固定 y(ϑ) → 固定 z(φ)，逐次左乘。"));
      var matrix = el("div");
      matrix.setAttribute("data-euler-matrix", "selected");
      matrix.innerHTML = matrixHTML(rotation.map(function (row) { return row.map(function (value) { return Math.abs(value) < 0.0000005 ? 0 : value; }); }), 6);
      readout.appendChild(matrix);
      ["x′", "y′", "z′"].forEach(function (name, column) {
        var axis = el("p", null, name + " 在固定系中的方向 = " + vectorText(rotation.map(function (row) { return row[column]; })) + "。");
        axis.setAttribute("data-euler-axis", String(column));
        readout.appendChild(axis);
      });
      ["zyz", "rpy"].forEach(function (mode) {
        var angles = inverse(mode, rotation);
        var residual = difference(rotation, forward(mode, angles));
        var result = el("p", angles.ok ? "lab-note" : "lab-warn",
          mode.toUpperCase() + " 反解当前矩阵：φ=" + degrees(angles.phi) + "，ϑ=" + degrees(angles.theta) + "，ψ=" + degrees(angles.psi) +
          "；输入半径 ρ=" + angles.radius.toExponential(3) + "；重建最大元素差=" + residual.toExponential(2) + "。" +
          (angles.ok ? (angles.radius < 0.05 ? " 接近表示奇点，但仍可分离；角度对扰动较敏感。" : " 非奇点，取第一支。")
            : " 数值奇点：只能确定 " + angles.combination + "，这里选 ψ=0 的代表，解不唯一。"));
        result.setAttribute("data-euler-inverse", mode);
        readout.appendChild(result);
      });
      if (message) readout.appendChild(el("p", "lab-note", message));
    }
    convert.addEventListener("click", function () {
      var before = selected().R;
      var target = state.mode === "zyz" ? "rpy" : "zyz";
      var angles = inverse(target, before);
      state.mode = target;
      state.phi = angles.phi;
      state.theta = angles.theta;
      state.psi = angles.psi;
      state.step = 3;
      message = "已把原先显示的姿态转成 " + target.toUpperCase() + " 第 3 步；转换前后最大元素差=" + difference(before, forward(target, angles)).toExponential(2) + "。";
      syncControls();
      draw();
    });
    reset.addEventListener("click", function () {
      state.mode = "zyz";
      state.phi = 30;
      state.theta = 55;
      state.psi = 20;
      state.step = 3;
      message = "";
      view.cam.az = -30;
      view.cam.elv = 18;
      view.cam.zoom = 1;
      syncControls();
      draw();
    });
    host.hidden = false;
    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* ================= 实验：dh3d · 拟人臂 DH 建系（ch02 §2.8，替换 2D 版） ================= */

  function labAxisAngle3D(host) {
    var state = { direction: [1, 1, 1], angle: 120, mode: "net", step: 5 };
    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "角和轴：净旋转与五步辅助构造"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "输入三个方向分量后自动归一化；零向量报错。灰色为固定三轴，蓝/绿/金色为当前三轴；虚线为原轴 r，紫线为当前 P r，红线为本步固定转轴。画面、矩阵、向量读数始终对应同一步。拖动或滚轮仅改变相机。"));
    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    var modes = toggleGroup(controls, "显示方式", [
      { value: "net", text: "净旋转" }, { value: "construction", text: "五步构造" }
    ], state.mode, function (value) { state.mode = value; sync(); draw(); });
    function number(value) { return value.toFixed(6).replace(/\.?0+$/, "") || "0"; }
    var directionControls = ["轴输入 x", "轴输入 y", "轴输入 z"].map(function (name, index) {
      return slider(controls, name, -1, 1, "any", state.direction[index], function (value) { state.direction[index] = value; draw(); }, number);
    });
    var angleControl = slider(controls, "净旋转角 ϑ", -360, 360, "any", state.angle, function (value) { state.angle = value; draw(); }, function (value) { return number(value) + "°"; });
    var stepControl = slider(controls, "构造显示步数", 0, 5, 1, state.step, function (value) { state.step = value; draw(); });
    var presets = [
      { text: "循环换位 120°", direction: [1, 1, 1], angle: 120 },
      { text: "混合符号半圈", direction: [1, -1, 0], angle: 180 },
      { text: "负 z 轴", direction: [0, 0, -1], angle: 90 }
    ];
    presets.forEach(function (preset) {
      var button = el("button", "lab-btn", preset.text);
      button.type = "button";
      button.addEventListener("click", function () {
        state.direction = preset.direction.slice();
        state.angle = preset.angle;
        state.mode = "net";
        state.step = 5;
        sync();
        draw();
      });
      controls.appendChild(button);
    });
    var reset = el("button", "lab-btn", "重置角轴与视角");
    reset.type = "button";
    controls.appendChild(reset);
    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "角轴净旋转或当前辅助步骤的坐标架；精确方向见下方读数");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    readout.setAttribute("aria-atomic", "true");
    host.appendChild(readout);
    var view = makeView(canvas, 0.6, { span: 1.7, center: [0, 0, 0], az: -30, elv: 18 });
    view.onChange = draw;
    function vectorText(vector) {
      return "(" + vector.map(function (value) { return (Math.abs(value) < 0.0000005 ? 0 : value).toFixed(6); }).join(", ") + ")";
    }
    function vectorReadout(key, text, vector) {
      var paragraph = el("p", null, text + vectorText(vector));
      paragraph.setAttribute("data-angle-vector", key);
      readout.appendChild(paragraph);
    }
    function sync() {
      directionControls.forEach(function (control, index) {
        control.input.value = state.direction[index];
        control.out.textContent = number(state.direction[index]);
      });
      angleControl.input.value = state.angle;
      angleControl.out.textContent = number(state.angle) + "°";
      stepControl.input.value = state.step;
      stepControl.out.textContent = String(state.step);
      stepControl.input.disabled = state.mode === "net";
      modes.forEach(function (button, index) {
        var active = index === (state.mode === "net" ? 0 : 1);
        button.classList.toggle("on", active);
        button.setAttribute("aria-pressed", active ? "true" : "false");
      });
    }
    function draw() {
      var colors = palette();
      readout.innerHTML = "";
      var construction;
      try {
        construction = kernel.axisAngleSteps(state.direction, state.angle * DEG);
      } catch (error) {
        view.render();
        readout.appendChild(el("p", "lab-warn", error.message + "。请调节轴输入或重置；当前没有可显示的旋转。"));
        host.setAttribute("data-angle-valid", "false");
        return;
      }
      host.setAttribute("data-angle-valid", "true");
      var finalRotation = kernel.axisAngleMatrix(construction.axis, state.angle * DEG);
      var current = state.mode === "net" ? { R: finalRotation, axis: construction.axis, angle: state.angle * DEG } : construction.steps[state.step];
      var rotation = current.R;
      var movedAxis = kernel.Trot({ R: rotation }, construction.axis);
      view.grid(0.9, 0.2, -0.65, { color: colors.line });
      view.triad([0, 0, 0], kernel.Tid().R, 0.78, ["x₀", "y₀", "z₀"], { colors: [colors.muted, colors.muted, colors.muted], width: 1.2 });
      view.box([0, 0, 0], [0.14, 0.1, 0.2], rotation, { color: colors.neutral });
      view.triad([0, 0, 0], rotation, 0.56, ["x′", "y′", "z′"], { colors: [colors.blue, colors.green, colors.gold], width: 2.8 });
      view.line(kernel.sclv(construction.axis, -0.95), kernel.sclv(construction.axis, 0.95), { color: colors.muted, width: 2, dash: [5, 4] });
      view.line([0, 0, 0], kernel.sclv(movedAxis, 0.9), { color: colors.purple, width: 3 });
      if (current.axis) view.line(kernel.sclv(current.axis, -0.72), kernel.sclv(current.axis, 0.72), { color: colors.red, width: 2 });
      view.render();
      readout.appendChild(el("p", null, state.mode === "net"
        ? "当前为净旋转 P=R，绕原轴转 " + number(state.angle) + "°。构造步数控件暂不可用。"
        : "五步构造：第 " + state.step + " 步 / 共 5 步；" + (current.axis ? "本步绕固定 " + current.name + " 转 " + number(current.angle / DEG) + "°。" : "初始矩阵 I。") +
          (state.step === 5 ? "此时 P=R，完成净角轴旋转。" : "当前 P 是辅助步骤的累积矩阵，尚未完成净角轴旋转。")));
      vectorReadout("input-axis", "归一化后的原轴 r = ", construction.axis);
      vectorReadout("moved-axis", "当前 P r = ", movedAxis);
      readout.appendChild(el("p", "lab-note", "α=" + number(construction.alpha / DEG) + "°，β=" + number(construction.beta / DEG) + "°（从 +z 量起；r=±z 时约定 α=0）。"));
      var matrix = el("div");
      matrix.setAttribute("data-angle-matrix", "selected");
      matrix.innerHTML = matrixHTML(rotation.map(function (row) { return row.map(function (value) { return Math.abs(value) < 0.0000005 ? 0 : value; }); }), 6);
      readout.appendChild(matrix);
      vectorReadout("point", "p=(1,2,3)，当前 P p = ", kernel.Trot({ R: rotation }, [1, 2, 3]));
      var inverse = kernel.extractAxisAngle(rotation);
      var rebuilt = inverse.axis ? kernel.axisAngleMatrix(inverse.axis, inverse.angle) : kernel.Tid().R;
      var residual = 0;
      rotation.forEach(function (row, rowIndex) { row.forEach(function (value, column) { residual = Math.max(residual, Math.abs(value - rebuilt[rowIndex][column])); }); });
      readout.appendChild(el("p", "lab-note", "反解当前 P：主角=" + number(inverse.angle / DEG) + "°；" +
        (inverse.axis ? "主轴=" + vectorText(inverse.axis) : "轴任意，主旋转向量为零") +
        "；分支=" + inverse.branch + "；重建最大元素差=" + residual.toExponential(2) + "。"));
      vectorReadout("log", "当前主旋转向量 φ（弧度）= ", inverse.vector);
      readout.appendChild(el("p", "lab-note", "正交误差=" + inverse.orthogonalError.toExponential(2) + "；det P=" + inverse.determinant.toFixed(6) + "。数值端点阈值为 |sin ϑ|<10⁻¹²；近零轴不稳定，近半圈从对称部分求轴，精确半圈选最大分量为正的代表。"));
    }
    reset.addEventListener("click", function () {
      state.direction = [1, 1, 1];
      state.angle = 120;
      state.mode = "net";
      state.step = 5;
      view.cam.az = -30;
      view.cam.elv = 18;
      view.cam.zoom = 1;
      sync();
      draw();
    });
    host.hidden = false;
    sync();
    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  function labQuaternion3D(host) {
    var state = { direction: [1, -1, 0], angle: 180, sign: 1, exact: true };
    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "四元数：半圈提取与双重覆盖"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "灰色是固定三轴，彩色是旋转后三轴，虚线是旋转轴。切换 Q 与 −Q 时画面和矩阵相同。默认直接载入精确半圈矩阵，用两种提取法的重建误差检查结果；调节角轴后改用角轴生成矩阵。"));
    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    function number(value) { return value.toFixed(6).replace(/\.?0+$/, "") || "0"; }
    function vectorText(vector) {
      return "(" + vector.map(function (value) { return (Math.abs(value) < 0.0000005 ? 0 : value).toFixed(6); }).join(", ") + ")";
    }
    var directionControls = ["轴输入 x", "轴输入 y", "轴输入 z"].map(function (name, index) {
      return slider(controls, name, -1, 1, "any", state.direction[index], function (value) { state.direction[index] = value; state.exact = false; draw(); }, number);
    });
    var angleControl = slider(controls, "旋转角 ϑ", -720, 720, "any", state.angle, function (value) { state.angle = value; state.exact = false; draw(); }, function (value) { return number(value) + "°"; });
    var signs = toggleGroup(controls, "四元数符号", [{ value: "1", text: "Q" }, { value: "-1", text: "−Q" }], "1", function (value) { state.sign = Number(value); draw(); });
    var exact = el("button", "lab-btn", "精确半圈反例");
    exact.type = "button";
    controls.appendChild(exact);
    var reset = el("button", "lab-btn", "重置四元数与视角");
    reset.type = "button";
    controls.appendChild(reset);
    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "单位四元数对应的三维旋转；矩阵和提取结果见下方读数");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    readout.setAttribute("aria-atomic", "true");
    host.appendChild(readout);
    var view = makeView(canvas, 0.6, { span: 1.7, center: [0, 0, 0], az: -30, elv: 18 });
    view.onChange = draw;
    function sync() {
      directionControls.forEach(function (control, index) {
        control.input.value = state.direction[index];
        control.out.textContent = number(state.direction[index]);
      });
      angleControl.input.value = state.angle;
      angleControl.out.textContent = number(state.angle) + "°";
      signs.forEach(function (button, index) {
        var active = index === (state.sign === 1 ? 0 : 1);
        button.classList.toggle("on", active);
        button.setAttribute("aria-pressed", active ? "true" : "false");
      });
    }
    function report(key, label, vector) {
      var paragraph = el("p", null, label + vectorText(vector));
      paragraph.setAttribute("data-quaternion-vector", key);
      readout.appendChild(paragraph);
    }
    function residual(first, second) {
      return Math.max.apply(null, first.map(function (row, rowIndex) {
        return Math.max.apply(null, row.map(function (value, column) { return Math.abs(value - second[rowIndex][column]); }));
      }));
    }
    function draw() {
      readout.innerHTML = "";
      var axis, quaternion, rotation;
      try {
        axis = kernel.axisDirection(state.direction);
        quaternion = state.exact ? [0, Math.SQRT1_2, -Math.SQRT1_2, 0] : kernel.quaternionFromAxis(axis, state.angle * DEG);
        rotation = state.exact ? [[0, -1, 0], [-1, 0, 0], [0, 0, -1]] : kernel.quaternionMatrix(quaternion);
      } catch (error) {
        view.render();
        host.setAttribute("data-quaternion-valid", "false");
        readout.appendChild(el("p", "lab-warn", error.message + "。请调节轴输入或重置；当前没有可显示的旋转。"));
        return;
      }
      host.setAttribute("data-quaternion-valid", "true");
      host.setAttribute("data-quaternion-source", state.exact ? "exact" : "axis");
      var colors = palette();
      view.grid(0.9, 0.2, -0.65, { color: colors.line });
      view.triad([0, 0, 0], kernel.Tid().R, 0.78, ["x₀", "y₀", "z₀"], { colors: [colors.muted, colors.muted, colors.muted], width: 1.2 });
      view.box([0, 0, 0], [0.14, 0.1, 0.2], rotation, { color: colors.neutral });
      view.triad([0, 0, 0], rotation, 0.56, ["x′", "y′", "z′"], { colors: [colors.blue, colors.green, colors.gold], width: 2.8 });
      view.line(kernel.sclv(axis, -0.95), kernel.sclv(axis, 0.95), { color: colors.purple, width: 2, dash: [5, 4] });
      view.render();
      var displayed = quaternion.map(function (value) { return state.sign * value; });
      readout.appendChild(el("p", null, state.exact ? "来源：精确给定矩阵（反对称差严格为零）。" : "来源：角轴生成，ϑ=" + number(state.angle) + "°。"));
      report("input", "当前 q（标量在前）= ", displayed);
      report("opposite", "同姿态的 −q = ", displayed.map(function (value) { return -value; }));
      report("axis", "单位轴 r = ", axis);
      var matrix = el("div");
      matrix.setAttribute("data-quaternion-matrix", "rotation");
      matrix.innerHTML = matrixHTML(rotation.map(function (row) { return row.map(function (value) { return Math.abs(value) < 0.0000005 ? 0 : value; }); }), 6);
      readout.appendChild(matrix);
      report("point", "p=(1,2,3)，R p = ", kernel.Trot({ R: rotation }, [1, 2, 3]));
      var stable = kernel.quaternionExtract(rotation);
      var candidate = kernel.quaternionSignCandidate(rotation);
      var stableError = residual(rotation, kernel.quaternionMatrix(stable.quaternion));
      var candidateError = residual(rotation, kernel.quaternionMatrix(candidate));
      report("stable", "最大分量法提取 q = ", stable.quaternion);
      report("candidate", "原书符号法候选 q = ", candidate);
      var errors = el("p", candidateError > 1e-8 ? "lab-warn" : "lab-note", "稳定法重建最大元素差=" + stableError.toExponential(2) + "；原书符号法重建最大元素差=" + candidateError.toExponential(2) + "。" + (candidateError > 1e-8 ? "候选不能重建输入矩阵：半圈须用交叉项恢复相对符号。" : "本次数值候选可以重建；这不能证明符号法在精确半圈总有效。"));
      errors.setAttribute("data-quaternion-errors", "");
      readout.appendChild(errors);
      readout.appendChild(el("p", "lab-note", "提取主元 k=" + stable.pivot + "（0=η，1=εx，2=εy，3=εz），取最大分量为正；单位约束=" + displayed.reduce(function (sum, value) { return sum + value * value; }, 0).toFixed(6) + "；正交误差=" + stable.orthogonalError.toExponential(2) + "；det R=" + stable.determinant.toFixed(6) + "。"));
    }
    function restore() {
      state.direction = [1, -1, 0];
      state.angle = 180;
      state.sign = 1;
      state.exact = true;
      sync();
    }
    exact.addEventListener("click", function () { restore(); draw(); });
    reset.addEventListener("click", function () {
      restore();
      view.cam.az = -30;
      view.cam.elv = 18;
      view.cam.zoom = 1;
      draw();
    });
    host.hidden = false;
    sync();
    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  function labHomogeneous3D(host) {
    var state = { firstAngle: 90, secondAngle: 0, origin: [2, 1, 0], offset: 1, kind: "point", mode: "steps", step: 0, showMatrices: false };
    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "齐次变换：同一点逐系换坐标"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "系 0 是固定参考系；彩色三轴表示当前读数所在的系，其余三轴为灰色。红点 P 是同一个物理点，换系步骤不会移动它；紫线从当前系原点指向 P。自由方向用紫色箭头表示，可移到不同原点。长度单位 m；拖动或滚轮只改变视角。"));
    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    function number(value) { return value.toFixed(6).replace(/\.?0+$/, "") || "0"; }
    var kindButtons = toggleGroup(controls, "输入含义", [{ value: "point", text: "点：w=1" }, { value: "direction", text: "自由方向：w=0" }], state.kind, function (value) { state.kind = value; draw(); });
    var modeButtons = toggleGroup(controls, "计算方式", [{ value: "steps", text: "逐级换系" }, { value: "combined", text: "直接合成" }], state.mode, function (value) { state.mode = value; sync(); draw(); });
    var firstControl = slider(controls, "系 1 绕系 0 的 z 角", -180, 180, "any", 90, function (value) { state.firstAngle = value; draw(); }, function (value) { return number(value) + "°"; });
    var secondControl = slider(controls, "系 2 绕系 1 的 x 角", -180, 180, "any", 0, function (value) { state.secondAngle = value; draw(); }, function (value) { return number(value) + "°"; });
    var originControls = ["系 1 原点 x", "系 1 原点 y", "系 1 原点 z"].map(function (name, index) {
      return slider(controls, name, -3, 3, "any", state.origin[index], function (value) { state.origin[index] = value; draw(); }, number);
    });
    var offsetControl = slider(controls, "系 2 沿系 1 的 x 偏移", -2, 2, "any", 1, function (value) { state.offset = value; draw(); }, number);
    var stepControl = slider(controls, "换系步数", 0, 2, 1, 0, function (value) { state.step = value; draw(); });
    var example = el("button", "lab-btn", "两段转动例题");
    example.type = "button";
    controls.appendChild(example);
    var reset = el("button", "lab-btn", "重置齐次变换与视角");
    reset.type = "button";
    controls.appendChild(reset);
    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "同一点在三套坐标系中的表示；精确坐标、矩阵与逆变换见下方读数");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    readout.setAttribute("aria-atomic", "true");
    host.appendChild(readout);
    var view = makeView(canvas, 0.64, { span: 1.1, center: [0, 0, 0], az: -30, elv: 24 });
    view.onChange = draw;
    function syncButtons(buttons, activeIndex) {
      buttons.forEach(function (button, index) {
        button.classList.toggle("on", index === activeIndex);
        button.setAttribute("aria-pressed", index === activeIndex ? "true" : "false");
      });
    }
    function sync() {
      [[firstControl, state.firstAngle], [secondControl, state.secondAngle], [offsetControl, state.offset], [stepControl, state.step]].forEach(function (pair, index) {
        pair[0].input.value = pair[1];
        pair[0].out.textContent = number(pair[1]) + (index < 2 ? "°" : "");
      });
      originControls.forEach(function (control, index) { control.input.value = state.origin[index]; control.out.textContent = number(state.origin[index]); });
      stepControl.input.disabled = state.mode === "combined";
      syncButtons(kindButtons, state.kind === "point" ? 0 : 1);
      syncButtons(modeButtons, state.mode === "steps" ? 0 : 1);
    }
    function report(key, label, vector) {
      var paragraph = el("p", null, label + "(" + vector.map(function (value) { return (Math.abs(value) < 0.0000005 ? 0 : value).toFixed(6); }).join(", ") + ")");
      paragraph.setAttribute("data-homogeneous-vector", key);
      readout.appendChild(paragraph);
    }
    function matrixBlock(parent, key, label, pose) {
      parent.appendChild(el("p", "lab-note", label));
      var matrix = el("div");
      matrix.setAttribute("data-homogeneous-matrix", key);
      matrix.innerHTML = matrixHTML(kernel.Tmatrix(pose).map(function (row) { return row.map(function (value) { return Math.abs(value) < 0.0000005 ? 0 : value; }); }), 6);
      parent.appendChild(matrix);
    }
    function draw() {
      readout.innerHTML = "";
      var scene;
      try { scene = kernel.homogeneousSteps(state.firstAngle, state.secondAngle, state.origin, state.offset); }
      catch (error) {
        view.render();
        readout.appendChild(el("p", "lab-warn", error.message));
        return;
      }
      var colors = palette();
      var step = state.mode === "combined" ? 2 : state.step;
      var pointMode = state.kind === "point";
      var values = pointMode ? scene.points : scene.directions;
      var selectedFrame = scene.frames[step];
      var worldPoint = scene.points[2], worldDirection = scene.directions[2];
      canvas.setAttribute("data-world-point", JSON.stringify(worldPoint));
      var extents = scene.frames.map(function (frame) { return frame.p; }).concat([worldPoint]);
      scene.frames.forEach(function (frame) { extents.push(kernel.addv(frame.p, worldDirection)); });
      var center = [0, 1, 2].map(function (index) {
        var coordinates = extents.map(function (point) { return point[index]; });
        return (Math.min.apply(null, coordinates) + Math.max.apply(null, coordinates)) / 2;
      });
      var scale = Math.max(1.7, Math.max.apply(null, extents.map(function (point) { return kernel.len(kernel.subv(point, center)); })) + 0.65);
      function position(point) { return kernel.sclv(kernel.subv(point, center), 1 / scale); }
      [0, 1, 2].filter(function (index) { return index !== step; }).concat([step]).forEach(function (index) {
        var frame = scene.frames[index];
        var frameIndex = 2 - index;
        var showLabels = index === step || kernel.len(kernel.subv(frame.p, selectedFrame.p)) > 1e-9;
        view.triad(position(frame.p), frame.R, 0.5 / scale, showLabels ? ["x" + frameIndex, "y" + frameIndex, "z" + frameIndex] : null, {
          colors: index === step ? [colors.blue, colors.green, colors.gold] : [colors.muted, colors.muted, colors.muted],
          width: index === step ? 2.8 : 1.2, originLabel: showLabels ? "O" + frameIndex : null
        });
      });
      if (pointMode) {
        var connector = kernel.subv(worldPoint, selectedFrame.p), connectorLength = kernel.len(connector);
        if (connectorLength > 0.075) {
          var connectorEnd = kernel.subv(worldPoint, kernel.sclv(connector, 0.075 / connectorLength));
          view.line(position(selectedFrame.p), position(connectorEnd), { color: colors.purple, width: 2, dash: [5, 4] });
        }
        view.sphere(position(worldPoint), 0.065 / scale, { color: colors.red });
        view.label(position(worldPoint), "P", colors.red, -16, -10);
      } else {
        var start = position(selectedFrame.p), end = position(kernel.addv(selectedFrame.p, worldDirection));
        view.prims.push({ kind: "axis", a: start, b: end, color: colors.purple, width: 3 });
        view.label(end, "d（自由方向）", colors.purple, 9, -10);
      }
      view.render();
      readout.appendChild(el("p", null, (state.mode === "combined" ? "直接合成 2→0" : "逐级换系：第 " + step + " 步 / 共 2 步，当前系 " + (2 - step)) + "；末分量 w=" + (pointMode ? "1，点的位置受平移影响。" : "0，方向只受旋转影响。")));
      report("input", "输入（系 2）= ", values[0]);
      report("intermediate", "换到系 1 = ", values[1]);
      report("final", "换到系 0 = ", values[2]);
      report("selected", "当前所读的齐次坐标 = ", values[step].concat(pointMode ? 1 : 0));
      report("origin", "系 2 原点在系 0 中的位置 = ", scene.combined.p);
      var selected = step === 0 ? kernel.Tid() : step === 1 ? scene.second : scene.combined;
      matrixBlock(readout, "selected", step === 0 ? "尚未换系：I₄" : step === 1 ? "当前累计矩阵 A₂¹" : "当前累计矩阵 A₂⁰=A₁⁰ A₂¹", selected);
      var returned = pointMode ? kernel.Tvec(scene.inverse, values[2]) : kernel.Trot(scene.inverse, values[2]);
      report("returned", "由系 0 逆变换返回系 2 = ", returned);
      var wrong = pointMode ? kernel.Tvec(scene.wrong, values[0]) : kernel.Trot(scene.wrong, values[0]);
      report("wrong", "交换两矩阵的数值结果（不是合法的 2→0 换系链）= ", wrong);
      var difference = Math.max.apply(null, wrong.map(function (value, index) { return Math.abs(value - values[2][index]); }));
      var roundtrip = Math.max.apply(null, returned.map(function (value, index) { return Math.abs(value - values[0][index]); }));
      var full = kernel.Tmatrix(scene.combined), orthogonalError = 0;
      full.forEach(function (unused, row) {
        full.forEach(function (other, column) {
          var product = full.reduce(function (sum, current) { return sum + current[row] * current[column]; }, 0);
          orthogonalError = Math.max(orthogonalError, Math.abs(product - (row === column ? 1 : 0)));
        });
      });
      var quality = kernel.rotationQuality(scene.combined.R);
      var diagnostic = el("p", "lab-note", "逆变换往返最大分量差=" + roundtrip.toExponential(2) + "；交换顺序的输出差=" + difference.toExponential(2) + "；整体正交误差=" + orthogonalError.toExponential(2) + "；det A=" + quality.determinant.toFixed(6) + "。方向不受平移，但两个旋转的次序仍可能改变方向；某个输入结果偶然相同也不能证明矩阵相同。");
      diagnostic.setAttribute("data-homogeneous-diagnostics", "");
      readout.appendChild(diagnostic);
      var details = el("details");
      details.open = state.showMatrices;
      details.addEventListener("toggle", function () { if (details.isConnected) state.showMatrices = details.open; });
      details.appendChild(el("summary", null, "展开两段矩阵与逆矩阵"));
      matrixBlock(details, "first", "第一段 A₁⁰", scene.first);
      matrixBlock(details, "second", "第二段 A₂¹", scene.second);
      matrixBlock(details, "inverse", "合成的逆 A₀²=(A₂⁰)⁻¹", scene.inverse);
      readout.appendChild(details);
    }
    function restore(secondAngle, step) {
      state.firstAngle = 90;
      state.secondAngle = secondAngle;
      state.origin = [2, 1, 0];
      state.offset = 1;
      state.kind = "point";
      state.mode = "steps";
      state.step = step;
      state.showMatrices = false;
      sync();
    }
    example.addEventListener("click", function () { restore(90, 2); draw(); });
    reset.addEventListener("click", function () {
      restore(0, 0);
      view.cam.az = -30;
      view.cam.elv = 24;
      view.cam.zoom = 1;
      draw();
    });
    host.hidden = false;
    sync();
    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  function labDH3D(host) {
    var state = { stage: 0, q: [20, 42, -70], hover: null, showMatrices: false };
    var A2 = 0.62, A3 = 0.52;
    var rows = [
      { alpha: Math.PI / 2, a: 0, d: 0, type: "R" },
      { alpha: 0, a: A2, d: 0, type: "R" },
      { alpha: 0, a: A3, d: 0, type: "R" }
    ];

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "拟人臂 DH：建系、参数与数值连乘"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "长度 m，滑条角度为度，计算用 rad。先预测哪个坐标系会动，再改变一个关节角；下方坐标与矩阵可核对。彩色轴按 x/y/z 排列，系 0 固定；按①到④显示建系过程。用几何高亮按钮定位参数，拖动画布只改变视角。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    var stageButtons = toggleGroup(controls, "构造步骤", [
      { value: "0", text: "① 轴线" }, { value: "1", text: "② 系0" }, { value: "2", text: "③ 系1" }, { value: "3", text: "④ 系2·3" }
    ], "0", function (v) { state.stage = parseFloat(v); draw(); });
    var jointControls = ["θ₁", "θ₂", "θ₃"].map(function (label, index) {
      return slider(controls, label, -180, 180, 1, state.q[index], function (value) { state.q[index] = value; draw(); }, function (value) { return value.toFixed(0) + "°"; });
    });
    var highlightButtons = toggleGroup(controls, "几何高亮", [
      { value: "none", text: "全部几何" }, { value: "th0", text: "关节 1 轴" },
      { value: "th1", text: "关节 2 轴" }, { value: "th2", text: "关节 3 轴" },
      { value: "a2", text: "上臂 a₂" }, { value: "a3", text: "前臂 a₃" }, { value: "al1", text: "扭角 α₁" }
    ], "none", function (value) { state.hover = value === "none" ? null : value; draw(); });
    var zero = el("button", "lab-btn", "载入 DH 零位");
    zero.type = "button";
    controls.appendChild(zero);
    var reset = el("button", "lab-btn", "重置 DH 模型与视角");
    reset.type = "button";
    controls.appendChild(reset);

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "拟人臂 DH 分步建系的三维视图");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    readout.setAttribute("aria-atomic", "true");
    host.appendChild(readout);

    var view = makeView(canvas, 0.64, { span: 1.5, center: [0, 0, 0.22], az: -32, elv: 20 });
    view.onChange = function () { draw(); };

    function draw() {
      var c = palette();
      var q = [state.q[0] * DEG, state.q[1] * DEG, state.q[2] * DEG];
      var frames = kernel.fkChain(rows, q);
      var S = frames[0].o;      /* 肩（= 系0/1 原点） */
      var E = frames[2].o;      /* 肘（系2 原点） */
      canvas.setAttribute("data-dh-frames", JSON.stringify(frames.map(function (frame) { return kernel.Tmatrix(frame.T); })));
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
          var size = idx === 0 ? 0.34 : 0.26;
          view.triad(f.o, R, size, idx >= 2 ? ["x" + idx, "y" + idx, "z" + idx] : null, {
            colors: triadColors, width: idx === 0 && state.stage < 3 ? 2.6 : 2, dim: dim,
            hlPrefix: "f" + idx + "-"
          });
          if (idx < 2) {
            var sharedX = state.stage >= 2 && kernel.len(kernel.subv(frames[0].x, frames[1].x)) < 1e-9;
            if (idx === 0 || !sharedX) view.label(kernel.addv(f.o, kernel.sclv(f.x, size)), sharedX ? "x0=x1" : "x" + idx, c.blue, 8, idx === 0 ? 12 : -8);
            if (idx === 0) {
              view.label(kernel.addv(f.o, kernel.sclv(f.y, size)), "y0", c.green, 8, 12);
              view.label(kernel.addv(f.o, kernel.sclv(f.z, size)), state.stage >= 2 ? "z0=y1" : "z0", c.gold, -48, -10);
            } else view.label(kernel.addv(f.o, kernel.sclv(f.z, size)), "z1", c.gold, 8, -8);
          }
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
        "第①步：只画三根关节轴线。关节1竖直过肩点；关节2水平过肩点；关节3过肘点、与关节2平行。轴1与轴2相交，轴2与轴3平行；还须确定杆长、正轴、固连原点与关节零位才能填表。",
        "第②步：放系 0。z₀ = 关节1轴（系 0 看守关节 1）；o₀ 取在轴1∩轴2（肩心）⇒ d₁ = 0；x₀ 水平任选。系 0 固连基座，任何关节都动不了它。",
        "第③步：放系 1。z₁ = 关节2轴。两轴相交 ⇒ a₁ = 0；从 z₀ 绕 x₁ 拧到 z₁ 顺着右手四指 ⇒ α₁ = π/2。紫色弧就是这 90°。拖 θ₁：整条臂带着系 1、2、3 一起绕 z₀ 转。",
        "第④步：放系 2、3。z₂ = 关节3轴 ∥ z₁ ⇒ α₂ = 0；公垂线就是上臂 ⇒ a₂；d₂ = 0，系 3 同理。红色弧是 θ₂、θ₃ 的定义角。拖 θ₂、θ₃：每个关节只带动它下游的坐标系，参数表里的常数纹丝不动。"
      ];
      var table = "<table class='lab-matrix'><thead><tr><th>i</th><th>αᵢ</th><th>aᵢ</th><th>dᵢ</th><th>θᵢ</th></tr></thead><tbody>" +
        "<tr><td>1</td><td data-hl='al1'>π/2</td><td data-hl='a1'>0</td><td>0</td><td data-hl='th0'>" + state.q[0].toFixed(0) + "°</td></tr>" +
        "<tr><td>2</td><td>0</td><td data-hl='a2'>" + A2.toFixed(2) + "</td><td>0</td><td data-hl='th1'>" + state.q[1].toFixed(0) + "°</td></tr>" +
        "<tr><td>3</td><td>0</td><td data-hl='a3'>" + A3.toFixed(2) + "</td><td>0</td><td data-hl='th2'>" + state.q[2].toFixed(0) + "°</td></tr>" +
        "</tbody></table>";
      readout.innerHTML = texLite("<p>" + stageNotes[state.stage] + "</p>" + table);
      function vector(key, label, values) {
        var paragraph = el("p", null, label + " = (" + values.map(function (value) { return (Math.abs(value) < 0.0000005 ? 0 : value).toFixed(6); }).join(", ") + ")");
        paragraph.setAttribute("data-dh-vector", key);
        readout.appendChild(paragraph);
      }
      vector("shoulder", "肩心 O₀=O₁（系 0）", S);
      vector("elbow", "肘 O₂（系 0）", E);
      vector("wrist", "腕 O₃（系 0）", W);
      function matrix(parent, key, label, pose) {
        parent.appendChild(el("p", "lab-note", label));
        var block = el("div");
        block.setAttribute("data-dh-matrix", key);
        block.innerHTML = matrixHTML(kernel.Tmatrix(pose).map(function (row) { return row.map(function (value) { return Math.abs(value) < 0.0000005 ? 0 : value; }); }), 6);
        parent.appendChild(block);
      }
      matrix(readout, "combined", "T₃⁰=A₁⁰A₂¹A₃²；此演示取基座系=系 0、工具系=系 3", frames[3].T);
      var diagnostics = el("p", "lab-note", "上臂长度=" + kernel.len(kernel.subv(E, S)).toFixed(6) + " m；前臂长度=" + kernel.len(kernel.subv(W, E)).toFixed(6) + " m；轴 1·轴 2=" + kernel.dot(frames[0].z, frames[1].z).toFixed(6) + "；轴 2·轴 3=" + kernel.dot(frames[1].z, frames[2].z).toFixed(6) + "。零位腕心应为 (1.14, 0, 0)，扭角仍为 +90°。");
      diagnostics.setAttribute("data-dh-diagnostics", "");
      readout.appendChild(diagnostics);
      var details = el("details");
      details.open = state.showMatrices;
      details.addEventListener("toggle", function () { if (details.isConnected) state.showMatrices = details.open; });
      details.appendChild(el("summary", null, "展开逐行 DH 矩阵"));
      rows.forEach(function (row, index) { matrix(details, "joint-" + (index + 1), "A" + (index + 1) + "（仅随 θ" + (index + 1) + " 变化）", kernel.dhA(row.alpha, row.a, row.d, q[index])); });
      readout.appendChild(details);
      host.hidden = false;
    }

    function load(angles, stage, resetCamera) {
      state.q = angles.slice();
      state.stage = stage;
      state.hover = null;
      state.showMatrices = false;
      jointControls.forEach(function (control, index) { control.input.value = angles[index]; control.out.textContent = angles[index] + "°"; });
      stageButtons.forEach(function (button, index) { button.classList.toggle("on", index === stage); button.setAttribute("aria-pressed", index === stage ? "true" : "false"); });
      highlightButtons.forEach(function (button, index) { button.classList.toggle("on", index === 0); button.setAttribute("aria-pressed", index === 0 ? "true" : "false"); });
      if (resetCamera) { view.cam.az = -32; view.cam.elv = 20; view.cam.zoom = 1; }
      draw();
    }
    zero.addEventListener("click", function () { load([0, 0, 0], 3, false); });
    reset.addEventListener("click", function () { load([20, 42, -70], 0, true); });
    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* ================= 实验：anthro3d · 拟人臂 T₃⁰（ch02 §2.9.4） ================= */

  function mechanismActions(host, controls, state, view, draw, zeroAngles) {
    var initial = { q: state.q.slice(), d6: state.d6, az: view.cam.az, elv: view.cam.elv, zoom: view.cam.zoom };
    var buttons = toggleGroup(controls, "矩阵列高亮", [
      { value: "none", text: "全部几何" }, { value: "end-0", text: "第 1 列 · x" },
      { value: "end-1", text: "第 2 列 · y" }, { value: "end-2", text: "第 3 列 · z" },
      { value: "pos", text: "第 4 列 · 位置" }
    ], "none", function (value) { state.hover = value === "none" ? null : value; draw(); });
    function load(zero) {
      state.q = zero ? zeroAngles.slice() : initial.q.slice();
      if (!zero) state.d6 = initial.d6;
      state.hover = null;
      buttons.forEach(function (button, index) {
        button.classList.toggle("on", index === 0);
        button.setAttribute("aria-pressed", index === 0 ? "true" : "false");
      });
      if (!zero) { view.cam.az = initial.az; view.cam.elv = initial.elv; view.cam.zoom = initial.zoom; }
      Array.prototype.forEach.call(controls.querySelectorAll("input[type=range]"), function (input, index) {
        input.value = index < state.q.length ? state.q[index] : state.d6;
        input.dispatchEvent(new Event("input", { bubbles: true }));
      });
      draw();
    }
    var referenceLabel = zeroAngles.some(function (value) { return value !== 0; }) ? "转角归零（行程 0.20 m）" : "载入 DH 零位";
    [[referenceLabel, true], ["重置关节、工具与视角", false]].forEach(function (action) {
      var button = el("button", "lab-btn", action[0]);
      button.type = "button";
      button.addEventListener("click", function () { load(action[1]); });
      controls.appendChild(button);
    });
    host.hidden = false;
  }

  function mechanismReadout(host, readout, state, transform, extra) {
    host.setAttribute("data-mechanism-values", JSON.stringify({ q: state.q, d6: state.d6, matrix: kernel.Tmatrix(transform), extra: extra }));
    Array.prototype.forEach.call(readout.querySelectorAll("table[data-mechanism-matrix] tr"), function (row) {
      Array.prototype.forEach.call(row.cells, function (cell, column) {
        var active = state.hover === (column === 3 ? "pos" : "end-" + column);
        cell.style.background = active ? "var(--accent-soft)" : "";
        cell.style.fontWeight = active ? "700" : "";
      });
    });
  }

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
    host.appendChild(el("p", "lab-note", "固定腰角，只动肩肘，先预测哪一列不变，再核对矩阵。长度 m，转角滑杆用度。图中彩色坐标架为系 3，金色虚线分别过 o₂ 与 o₃，表示同向但不重合的 z₂、z₃。按钮可用键盘选择高亮。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
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
    var view = makeView(canvas, 0.62, { span: 1.45, center: [0, 0, 0.3], az: -34, elv: 19 });
    view.onChange = function () { draw(); };
    mechanismActions(host, controls, state, view, draw, [0, 0, 0]);

    function draw() {
      var c = palette();
      var q = [state.q[0] * DEG, state.q[1] * DEG, state.q[2] * DEG];
      var frames = kernel.fkChain(rows, q);
      var T3 = kernel.anthroT3(q[0], q[1], q[2], A2, A3);

      view.grid(0.85, 0.17, 0, { color: c.line });
      drawChain(view, frames, {
        toolLen: 0,
        triads: false,
        triadSize: 0.3,
        frameRange: [3, 3],
        hlFrame: "f"
      });
      view.triad(frames[3].o, T3.R, 0.3, ["x₃", "y₃", "z₃"], { colors: [c.blue, c.green, c.gold], width: 2.2, hlPrefix: "end-" });
      /* 位置矢量（基座原点 → o₃）：悬停第 4 列时高亮 */
      var p3 = frames[3].o;
      view.line([0, 0, 0], p3, { color: c.red, width: 2, dash: [7, 4], hl: "pos" });
      view.label(kernel.sclv(p3, 0.55), "p₃（定位点）", c.red, 8, 4);
      /* z₃ = z₂ 的提示：两根平行轴 */
      if (state.showFrame) {
        view.line(kernel.addv(frames[2].o, kernel.sclv(frames[2].z, 0.2)), kernel.addv(frames[2].o, kernel.sclv(frames[2].z, 0.42)),
          { color: c.gold, width: 1.6, hl: "end-2" });
        view.line(kernel.addv(frames[3].o, kernel.sclv(frames[3].z, 0.2)), kernel.addv(frames[3].o, kernel.sclv(frames[3].z, 0.42)),
          { color: c.gold, width: 1.6, hl: "end-2" });
      }

      view.render(state.hover);

      /* T₃⁰ 的 4×4 数值（前 3×3 为 R，第 4 列为位置） */
      var m = [
        [{ v: T3.R[0][0], hl: "f0-0" }, { v: T3.R[0][1], hl: "f0-1" }, { v: T3.R[0][2], hl: "f3-2" }, { v: T3.p[0], hl: "pos" }],
        [{ v: T3.R[1][0], hl: "f0-0" }, { v: T3.R[1][1], hl: "f0-1" }, { v: T3.R[1][2], hl: "f3-2" }, { v: T3.p[1], hl: "pos" }],
        [{ v: T3.R[2][0], hl: "f0-0" }, { v: T3.R[2][1], hl: "f0-1" }, { v: T3.R[2][2], hl: "f3-2" }, { v: T3.p[2], hl: "pos" }],
        [0, 0, 0, 1]
      ];
      var html = matrixHTML(m, 3).replace("<table", "<span class='lab-matrix-label'>T₃⁰（位置单位 m）=</span><table data-mechanism-matrix");
      html += "<p class='lab-note'><b>逐列读法</b>：第 1 列 = x₃ 在系 0 中的方向余弦，第 2 列 = y₃，第 3 列 = z₃，" +
        "第 4 列 = o₃ 的位置。用按钮逐列核对。</p>";
      html += "<p class='lab-note'><b>结构性观察</b>：第 3 列 [s₁,-c₁,0]ᵀ 只含 θ₁——<b>转肩不改变 z₃ 的指向</b>（z₃ 永远躺在水平面里，且随腰一起转）；" +
        "肩肘轴与末系 z 轴同向水平；z₂、z₃ 相隔 a₃=0.52 m，并不重合。" +
        "第 4 列的三个分量就是 2.12.5 逆解的<b>腕心方程</b> pwₓ=c₁(a₂c₂+a₃c₂₃)、pwy=s₁(a₂c₂+a₃c₂₃)、pwz=a₂s₂+a₃s₂₃。</p>";
      readout.innerHTML = texLite(html);
      mechanismReadout(host, readout, state, T3, { position: p3, z2: frames[2].z, z3: frames[3].z, separation: A3 });
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
    host.appendChild(el("p", "lab-note", "先预测再操作：腕心在原点；有长度的工具尖端会随前两个腕角移动，只转最后一角则尖端不动。实际关节轴是 z₃、z₄、z₅，虚线均过腕心。两矩阵按本表扭角与零位应逐元素相等；按钮高亮系 6 的同一列。"));

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
    var view = makeView(canvas, 0.6, { span: 0.82, center: [0, 0, 0.08], az: -30, elv: 18 });
    view.onChange = function () { draw(); };
    mechanismActions(host, controls, state, view, draw, [0, 0, 0]);

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
      [3].forEach(function (idx) {
        var f = frames[idx];
        var R = [[f.x[0], f.y[0], f.z[0]], [f.x[1], f.y[1], f.z[1]], [f.x[2], f.y[2], f.z[2]]];
        view.triad(f.o, R, 0.26, ["x" + (idx + 3), "y" + (idx + 3), "z" + (idx + 3)], {
          colors: [c.blue, c.green, c.gold], width: 2.2, hlPrefix: "end-"
        });
      });
      frames.slice(0, 3).forEach(function (frame, index) {
        view.line(kernel.sclv(frame.z, -0.34), kernel.sclv(frame.z, 0.34), { color: c.muted, width: 1.5, dash: [6, 4] });
        if (index === 0 || Math.abs(kernel.dot(frame.z, frames[0].z)) < 1 - 1e-9) {
          view.label(kernel.sclv(frame.z, -0.36), "关节" + (index + 4) + "轴 z" + (index + 3), c.muted, 8, index * 12);
        } else {
          view.label(kernel.sclv(frame.z, 0.38), "关节4、6轴共线", c.muted, 8, -14);
        }
      });
      /* 工具末端 */
      var tip = frames[3].o;
      view.sphere(tip, 0.032, { color: c.gold });
      view.line([0, 0, 0], tip, { color: c.gold, width: 3, hl: "pos" });
      view.label(tip, "工具尖端", c.gold, -82, -14);

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

      var html = "<span class='lab-matrix-label'>R₆³ =</span>" + matrixHTML(mL, 3).replace("<table", "<table data-mechanism-matrix") +
        "<span class='lab-matrix-label'>　ZYZ(θ₄,θ₅,θ₆) =</span>" + matrixHTML(mR, 3).replace("<table", "<table data-mechanism-matrix");
      html += "<p class='lab-note'><b>两个矩阵逐元素相等</b>（最大偏差 " + maxDiff.toExponential(1) + "）：" +
        "球形腕的三个转角 (θ₄,θ₅,θ₆) 恰是<b>相对系 3 的 ZYZ 角</b>。这正是 2.12.6「腕逆解 = ZYZ 反解」的全部伏笔——" +
        "本表取 α₄=−π/2、α₅=π/2，令 Q=Rₓ(−π/2)，则 Q R_z(θ₅) Q⁻¹=R_y(θ₅)。共点本身并不保证任意选系的角都等于 ZYZ。</p>";
      html += "<p class='lab-note'>腕心位置 = 系 3 原点，<b>与 θ₄θ₅θ₆ 无关</b>（拖动三个滑杆时红球纹丝不动）；末端沿 z₆ 外移 d₆ = " + state.d6.toFixed(2) + " m。</p>";
      readout.innerHTML = texLite(html);
      readout.appendChild(el("p", "lab-note", "工具尖端 p₆³ = (" + tip.map(function (value) { return value.toFixed(3); }).join(", ") + ") m；腕心 = (0, 0, 0) m；到腕心距离 = " + kernel.len(tip).toFixed(3) + " m。"));
      if (Math.abs(Math.sin(q[1])) < 1e-9) readout.appendChild(el("p", "lab-warn", "腕部奇异：第一、第三腕轴共线，角度解不唯一。"));
      mechanismReadout(host, readout, state, frames[3].T, { wrist: [0, 0, 0], tip: tip, axes: frames.slice(0, 3).map(function (frame) { return frame.z; }), zyz: ZYZ, maxDiff: maxDiff });
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
          "（θ₁ I = Atan2(pᵧ,pₓ)、θ₁ II = Atan2(−pᵧ,−pₓ)，相差 π，原书式 2.109–2.110）。" +
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
    head.appendChild(el("b", null, "雅可比的列：各关节怎样贡献末端速度"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "调节关节速度 q̇ᵢ（rad/s），观察 vₑ = Σ Jₚ,ᵢ q̇ᵢ。三根彩色箭头表示各关节的线速度贡献，红色箭头表示合计。角度滑杆决定当前位形，不是播放时间。悬停矩阵列可高亮对应贡献。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    toggleGroup(controls, "机构", [{ value: "planar", text: "三连杆平面臂" }, { value: "anthro", text: "拟人臂" }], "planar",
      function (v) { state.kind = v; draw(); });
    var sliders = [];
    ["q̇₁", "q̇₂", "q̇₃"].forEach(function (label, i) {
      sliders.push(slider(controls, label, -1.5, 1.5, 0.05, state.dq[i], function (v) { state.dq[i] = v; draw(); },
        function (v) { return v.toFixed(2) + " rad/s"; }));
    });
    ["θ₁", "θ₂", "θ₃"].forEach(function (label, i) {
      sliders.push(slider(controls, label, -180, 180, 1, state.q[i], function (v) { state.q[i] = v; draw(); },
        function (v) { return v.toFixed(0) + "°"; }));
    });

    var reset = el("button", "lab-btn", "重置参数与视角");
    reset.type = "button";
    reset.addEventListener("click", function () {
      [0.6, -0.4, 0.5, 35, -40, 30].forEach(function (value, i) {
        sliders[i].input.value = value;
        sliders[i].input.dispatchEvent(new Event("input"));
      });
      state.hover = null;
      view.cam.az = 35; view.cam.elv = 28; view.cam.zoom = 1;
      draw();
    });
    controls.appendChild(reset);

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "雅可比逐列贡献的三维可视化");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);
    bindHover(readout, function (key) { state.hover = key; draw(); });

    var view = makeView(canvas, 0.6, { span: 1.5, center: [0.25, 0.15, 0.25], az: 35, elv: 28 });
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
      drawChain(view, frames, { toolLen: 0, span: 1.2 });

      /* 几何雅可比的位置块（3×3） */
      var Jp = kernel.geoJacPos(frames);
      /* 平面情形：第 3 行取 ω（[1,1,1]），与 3.2.1 的 J̄ 一致 */
      var J = state.kind === "planar"
        ? [[Jp[0][0], Jp[0][1], Jp[0][2]], [Jp[1][0], Jp[1][1], Jp[1][2]], [1, 1, 1]]
        : Jp;

      var colColors = [c.blue, c.green, c.gold];
      var total = [0, 0, 0];
      var omega = [0, 0, 0];
      var parts = [];
      for (var i = 0; i < 3; i++) {
        var v = [J[0][i] * state.dq[i], J[1][i] * state.dq[i], state.kind === "planar" ? 0 : J[2][i] * state.dq[i]];
        parts.push(v);
        total[0] += v[0]; total[1] += v[1]; total[2] += v[2];
        for (var axis = 0; axis < 3; axis++) omega[axis] += frames[i].z[axis] * state.dq[i];
      }

      /* 速度箭头：从末端点出发 */
      var SC = 0.28; /* 速度乘以 0.28 s，得到画布中的示意长度 */
      parts.forEach(function (v, i) {
        if (kernel.len(v) < 1e-10) return;
        var tip = kernel.addv(pe, kernel.sclv(v, SC));
        view.line(pe, tip, { color: colColors[i], width: 2.2, hl: "c" + i, arrow: true });
        view.label(tip, "v" + (i + 1), colColors[i], 6, -12 - 14 * i);
      });
      var tipT = kernel.addv(pe, kernel.sclv(total, SC));
      if (kernel.len(total) >= 1e-10) {
        view.line(pe, tipT, { color: c.red, width: 3.4, arrow: true });
        view.label(tipT, "vₑ（合计）", c.red, 8, 18);
      }
      view.label(pe, "pₑ", c.ink, -20, 16);

      view.render(state.hover);

      var rowsHtml = [];
      for (var r = 0; r < 3; r++) {
        var row = [];
        for (var col = 0; col < 3; col++) row.push({ v: J[r][col], hl: "c" + col });
        rowsHtml.push(row);
      }
      var html = matrixHTML(rowsHtml, 3).replace("<table", "<span class='lab-matrix-label'>" +
        (state.kind === "planar" ? "J̄（行：vₓ、vᵧ、ω_z）" : "Jₚ（行：vₓ、vᵧ、v_z）") + " =</span><table");
      html += "<p class='lab-note'><b>逐列读法</b>：第 i 列 = 「只动关节 i（其余锁死）时末端的贡献」" +
        "（Jₚ,ᵢ= zᵢ₋₁×( pₑ- pᵢ₋₁)，3.1.3）。" +
        "悬停某一列，画布里该列对应的速度箭头加粗、其余变淡。</p>";
      html += "<p class='lab-note'>杆长（m）：" + (state.kind === "planar" ? "a₁=0.45，a₂=0.36，a₃=0.26" : "a₂=0.62，a₃=0.52") +
        "。线速度 vₑ = [" + total.map(function (v) { return v.toFixed(3); }).join(", ") + "] m/s。箭头按速度乘 0.28 s 绘制，不是运动后的轨迹。</p>";
      html += "<table class='lab-table'><thead><tr><th>贡献</th><th>vₓ（m/s）</th><th>vᵧ（m/s）</th><th>v_z（m/s）</th></tr></thead><tbody>";
      parts.forEach(function (part, i) {
        html += "<tr><td>关节 " + (i + 1) + "</td>" + part.map(function (value) { return "<td>" + value.toFixed(3) + "</td>"; }).join("") + "</tr>";
      });
      html += "<tr><td>合计</td>" + total.map(function (value) { return "<td>" + value.toFixed(3) + "</td>"; }).join("") + "</tr></tbody></table>";
      html += "<p class='lab-note'>角速度向量 ω = [" + omega.map(function (value) { return value.toFixed(3); }).join(", ") + "] rad/s。画布不把角速度画成线速度箭头；pₑ 是第三系原点，未加额外工具偏置。零线速度不画方向箭头，可从表格读零值。</p>";
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
    host.appendChild(el("p", "lab-note", "拟人臂的位置雅可比 Jₚ 决定末端能把多大的速度「摊」到哪些方向。总关节速度模上限为 1 rad/s；椭球来自 JₚJₚᵀ 的特征方向与 √(λᵢ)：半轴越长 = 该方向上末端能出的速度越大。拖 θ₂、θ₃ 逼近两类奇点——<b>肘伸直/折回</b>（s₃=0，边界奇点）与 <b>腕点落到肩轴上</b>（a₂c₂+a₃c₂₃=0，内部奇点），单一奇点通常压扁为面；两种奇点同时发生时可退化为线。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    toggleGroup(controls, "椭球", [{ value: "on", text: "显示" }, { value: "off", text: "隐藏" }], "on",
      function (v) { state.showEll = v === "on"; draw(); });
    var sliders = [];
    ["θ₁（腰）", "θ₂（肩）", "θ₃（肘）"].forEach(function (label, i) {
      sliders.push(slider(controls, label, -180, 180, 1, state.q[i], function (v) { state.q[i] = v; draw(); },
        function (v) { return v.toFixed(0) + "°"; }));
    });
    sliders.push(slider(controls, "椭球显示比例", 0.1, 0.6, 0.02, state.scale, function (v) { state.scale = v; draw(); },
      function (v) { return v.toFixed(2) + " s"; }));

    var reset = el("button", "lab-btn", "重置关节与视角");
    reset.type = "button";
    reset.addEventListener("click", function () {
      [20, 42, -70, 0.28].forEach(function (value, i) {
        sliders[i].input.value = value;
        sliders[i].input.dispatchEvent(new Event("input"));
      });
      state.hover = null;
      view.cam.az = -34; view.cam.elv = 19; view.cam.zoom = 1;
      draw();
    });
    controls.appendChild(reset);

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
      var velocitySet = kernel.velocityEllipsoid(J);
      var axes = velocitySet.axes;
      var radii = velocitySet.sigma.map(function (sigma) { return sigma * state.scale; });

      view.grid(0.85, 0.17, 0, { color: c.line });
      drawChain(view, frames, { toolLen: 0.08, span: 1.2 });

      if (state.showEll) {
        view.ellipsoid(pe, axes, radii, { color: c.purple, width: 1.6, axesToo: true });
        view.label(kernel.addv(pe, kernel.sclv(axes[2], radii[2])), "主轴（最快方向）", c.purple, 8, 2);
      }

      view.render(state.hover);

      var s3 = Math.sin(q[2]);
      var shoulderFactor = A2 * Math.cos(q[1]) + A3 * Math.cos(q[1] + q[2]);
      var w = velocitySet.w;
      var html = "<p><b>可操作度</b> w=√(det(J̄J̄ᵀ))=|det J̄|=" + w.toFixed(4) + "</p>";
      html += "<p class='lab-note'>det Jₚ=-a₂a₃ s₃ (a₂c₂+a₃c₂₃)（3.2.2）——两个因子各自归零即奇异：</p>";
      html += "<table class='lab-matrix'><thead><tr><th>因子</th><th>当前值</th><th>含义</th></tr></thead><tbody>" +
        "<tr><td>s₃</td><td>" + s3.toFixed(4) + "</td><td>肘角正弦：s₃=0 ⇒ 肘伸直/折回（<b>边界奇点</b>）</td></tr>" +
        "<tr><td>a₂c₂+a₃c₂₃</td><td>" + shoulderFactor.toFixed(4) + "</td><td>腕点距肩轴的投影：为 0 ⇒ 腕点落到 z₀ 轴上（<b>内部奇点</b>）</td></tr>" +
        "</tbody></table>";
      var warn = "";
      if (Math.abs(s3) < 0.08) warn += "<p class='lab-warn'><b>接近肘奇点</b>（边界）：最短半轴接近零；完全奇异时会失去一个或多个瞬时位置速度方向。</p>";
      if (Math.abs(shoulderFactor) < 0.08) warn += "<p class='lab-warn'><b>接近肩奇点</b>（内部）：腰关节的线速度贡献接近零；是否可实现指定速度还须检查列空间。</p>";
      html += "<p class='lab-note'>奇异值 σ（m/rad）：[" + velocitySet.sigma.map(function (v) { return v.toFixed(4); }).join(", ") + "]。杆长 a₂=0.62 m，a₃=0.52 m；w 的单位为 m³/rad³。</p>";
      html += warn;
      html += "<p class='lab-note'>椭球半轴 = σᵢ(Jₚ) × 1 rad/s（箭头示意长度再乘 " + state.scale.toFixed(2) + " s）：" +
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

  kernel.chassisLayouts = function () {
    return [
      {
        id: "diff", name: "差动式", sub: "两同轴定轮 + 被动自位轮",
        note: "车体 x 轴向前、y 轴向左；参考点在两驱动轮轴中点。轮距 b=0.56 m，v=(v左+v右)/2，ω=(v右−v左)/b；正角速度为左转。输入是轮缘线速度，不是电机转速。",
        wheels: [{ x: -0.32, y: 0.28, drive: true }, { x: -0.32, y: -0.28, drive: true }, { x: 0.42, y: 0, drive: false, caster: true }]
      },
      {
        id: "synchro", name: "同步驱动式", sub: "三个导向轮，牵引/转向机械耦合",
        note: "三个轮子具有相同的滚动方向与速度，底盘只平移，ω=0。改变共同转向角可改变平移方向，但不会改变车身朝向；这里比较的是保持该轮向的瞬时运动。",
        wheels: [{ x: 0.3, y: 0, drive: true }, { x: -0.15, y: 0.26, drive: true }, { x: -0.15, y: -0.26, drive: true }]
      },
      {
        id: "tricycle", name: "三轮式", sub: "后轴两定轮 + 前舵轮",
        note: "参考点在后轴中点，轴距 L=0.68 m。前轮转角 δ 和后轴中心速度 v 决定 ω=v tanδ/L；左右后轮须以不同轮缘速度通过弯道，可由机械差速器分配。",
        wheels: [{ x: -0.3, y: 0.26, drive: true }, { x: -0.3, y: -0.26, drive: true }, { x: 0.38, y: 0, drive: false, steer: true }]
      },
      {
        id: "car", name: "汽车式（阿克曼）", sub: "后定轮 + 两前转向轮",
        note: "参考点在后轴中点。轴距 L=0.68 m，前轮距 t=0.60 m；δ 是等效前轮转角，不是方向盘转角。R=L/tanδ，左右前轮分别满足 tanδ左=L/(R−t/2)、tanδ右=L/(R+t/2)。右转时右轮是内轮；直行时两角均为零。",
        wheels: [{ x: -0.3, y: 0.26, drive: true }, { x: -0.3, y: -0.26, drive: true }, { x: 0.38, y: 0.3, drive: false, steer: true, inner: true }, { x: 0.38, y: -0.3, drive: false, steer: true, inner: false }]
      },
      {
        id: "omni3", name: "三主动自位轮式", sub: "三个 120° 布置的主动自位轮",
        note: "这里先给定底盘目标速度，再计算三个偏置自位轮的瞬时滚动速度和被动转向速率。竖直支点与接触点沿轮向相距 e=0.06 m，转向未被当作电机输入。此速度分配示意不模拟对齐过程、力矩或轮地打滑，也不验证所有轮向下的驱动可控性。",
        wheels: [{ x: 0.42, y: 0, drive: true, omni: true }, { x: -0.21, y: 0.364, drive: true, omni: true }, { x: -0.21, y: -0.364, drive: true, omni: true }]
      }
    ];
  };

  kernel.chassisMotion = function (layoutId, input) {
    var layout = kernel.chassisLayouts().find(function (item) { return item.id === layoutId; });
    var delta = input.delta * DEG;
    var vx = input.speed, vy = 0, omega = 0;
    var reference = [-0.3, 0, 0];
    if (layoutId === "diff") {
      vx = (input.vl + input.vr) / 2;
      omega = (input.vr - input.vl) / 0.56;
      reference = [-0.32, 0, 0];
    } else if (layoutId === "synchro") {
      vx = input.speed * Math.cos(delta);
      vy = input.speed * Math.sin(delta);
      reference = [0, 0, 0];
    } else if (layoutId === "car" || layoutId === "tricycle") {
      omega = input.speed * Math.tan(delta) / 0.68;
    } else if (layoutId === "omni3") {
      vy = input.side;
      omega = input.yaw;
      reference = [0, 0, 0];
    }
    var wheels = layout.wheels.map(function (wheel, index) {
      var heading = 0;
      if (layoutId === "synchro" || wheel.steer) heading = delta;
      if (layoutId === "car" && wheel.steer) {
        heading = Math.atan2(0.68 * Math.tan(delta), 0.68 - wheel.y * Math.tan(delta));
      }
      if (wheel.omni) heading = index * Math.PI * 2 / 3;
      var pivot = [wheel.x, wheel.y, 0];
      var contact = pivot.slice();
      var pivotVelocity = [vx - omega * (wheel.y - reference[1]), vy + omega * (wheel.x - reference[0]), 0];
      var direction = [Math.cos(heading), Math.sin(heading), 0];
      var normal = [-direction[1], direction[0], 0];
      var swivel = 0;
      if (wheel.omni || wheel.caster) {
        contact = kernel.subv(pivot, kernel.sclv(direction, 0.06));
        swivel = kernel.dot(normal, pivotVelocity) / 0.06 - omega;
      }
      return {
        x: contact[0], y: contact[1], heading: heading, pivot: pivot,
        drive: wheel.drive, caster: wheel.caster || wheel.omni,
        speed: kernel.dot(direction, pivotVelocity), swivel: swivel,
        velocity: wheel.omni || wheel.caster
          ? kernel.subv(pivotVelocity, kernel.sclv(normal, 0.06 * (omega + swivel))) : pivotVelocity
      };
    });
    return { vx: vx, vy: vy, omega: omega, reference: reference, wheels: wheels,
      radius: Math.abs(Math.tan(delta)) < 1e-12 ? null : 0.68 / Math.tan(delta) };
  };

  function labChassis3D(host) {
    var LAYOUTS = kernel.chassisLayouts();
    var state = { layout: "diff", vl: 0.5, vr: 0.5, speed: 0.5, delta: 20, side: 0, yaw: 0, mecanum: false };

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "轮系与底盘：轮子怎么转，机身就怎么走"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "比较不同布局允许的瞬时速度。车体 x 向前、y 向左；蓝轮表示牵引驱动、金轮为从动轮、紫色支架表示偏置自位轮。绿色线段显示平移速度方向与大小，红弧表示角速度；模型不会沿轨迹行驶。每种布局使用自己的输入与公式，麦克纳姆特写只展示滚子几何。尺寸和范围均为教学设定。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    toggleGroup(controls, "底盘", LAYOUTS.map(function (l) { return { value: l.id, text: l.name }; }), "diff",
      function (v) { state.layout = v; resetControls(); draw(); });
    toggleGroup(controls, "特写", [{ value: "no", text: "整车" }, { value: "yes", text: "麦克纳姆轮" }], "no",
      function (v) { state.mecanum = v === "yes"; resetControls(); draw(); });
    var inputs = el("div", "lab-controls");
    host.appendChild(inputs);
    function resetControls() {
      inputs.textContent = "";
      if (state.mecanum) return;
      var reset = el("button", "lab-btn", "重置当前底盘");
      reset.type = "button";
      reset.addEventListener("click", function () { resetControls(); draw(); });
      inputs.appendChild(reset);
      function add(label, key, min, max, step, value, unit) {
        state[key] = value;
        slider(inputs, label, min, max, step, value, function (next) { state[key] = next; draw(); },
          function (next) { return next.toFixed(unit === "°" ? 0 : 2) + " " + unit; });
      }
      if (state.layout === "diff") {
        add("左轮轮缘速度", "vl", -1, 1, 0.05, 0.5, "m/s");
        add("右轮轮缘速度", "vr", -1, 1, 0.05, 0.5, "m/s");
      } else {
        add(state.layout === "synchro" ? "共同轮缘速度" : "参考点前向速度", "speed", -1, 1, 0.05, 0.5, "m/s");
        if (state.layout === "omni3") {
          add("参考点左向速度", "side", -1, 1, 0.05, 0, "m/s");
          add("底盘角速度", "yaw", -1, 1, 0.05, 0, "rad/s");
        } else {
          add(state.layout === "synchro" ? "共同轮向角" : "等效前轮转角 δ", "delta", -35, 35, 1, 20, "°");
        }
      }
    }

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "五种底盘布局的 3D 视图与轮速运动");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);

    var view = makeView(canvas, 0.6, { span: 1.1, center: [0, 0, 0.12], az: -42, elv: 42 });
    view.onChange = function () { draw(); };

    function wheel(v, x, y, r, width, axis, color) {
      /* 轮子：轴向 axis（单位向量），用圆盘近似 */
      var seg = 16, i, ang;
      var u = kernel.norm(Math.abs(axis[0]) < 0.9 ? kernel.crs(axis, [1, 0, 0]) : kernel.crs(axis, [0, 1, 0]));
      var w = kernel.crs(axis, u);
      var c = [x, y, 0];
      var frontFace = [], backFace = [];
      for (i = 0; i < seg; i++) {
        var a1 = 2 * Math.PI * i / seg, a2 = 2 * Math.PI * (i + 1) / seg;
        var p1 = kernel.addv(c, kernel.sclv(kernel.addv(kernel.sclv(u, Math.cos(a1)), kernel.sclv(w, Math.sin(a1))), r));
        var p2 = kernel.addv(c, kernel.sclv(kernel.addv(kernel.sclv(u, Math.cos(a2)), kernel.sclv(w, Math.sin(a2))), r));
        var q1 = kernel.addv(p1, kernel.sclv(axis, width / 2));
        var q2 = kernel.addv(p2, kernel.sclv(axis, width / 2));
        var r1 = kernel.addv(p1, kernel.sclv(axis, -width / 2));
        var r2 = kernel.addv(p2, kernel.sclv(axis, -width / 2));
        v.poly([q1, q2, r2, r1], { color: color, both: true });
        frontFace.push(q1);
        backFace.unshift(r1);
      }
      v.poly(frontFace, { color: color, both: true });
      v.poly(backFace, { color: color, both: true });
      v.cyl(kernel.addv(c, kernel.sclv(axis, -width / 2)), kernel.addv(c, kernel.sclv(axis, width / 2)), r * 0.25, { color: color, seg: 8 });
    }

    function draw() {
      var c = palette();
      var layout = LAYOUTS.filter(function (l) { return l.id === state.layout; })[0];

      if (state.mecanum) {
        /* 麦克纳姆轮特写：一个轮 + 45° 斜置滚子 */
        view.grid(0.6, 0.12, -0.3, { color: c.line });
        var R = 0.3;
        wheel(view, 0, 0, R * 0.65, 0.12, [0, 1, 0], c.blue);
        /* 滚子：沿轮周分布、轴线与轮平面成 45° */
        for (var i = 0; i < 8; i++) {
          var ang = 2 * Math.PI * i / 8;
          var radial = [Math.cos(ang), 0, Math.sin(ang)];
          var rc = kernel.sclv(radial, R * 0.9);
          var rollerAxis = kernel.norm([-Math.sin(ang), 1, Math.cos(ang)]);
          var half = R * 0.28;
          var A = kernel.addv(rc, kernel.sclv(rollerAxis, -half));
          var Bp = kernel.addv(rc, kernel.sclv(rollerAxis, half));
          view.cyl(kernel.sclv(radial, R * 0.6), rc, 0.014, { color: c.blue, seg: 6 });
          view.cyl(A, Bp, 0.028, { color: c.gold, seg: 8 });
        }
        view.label([0, 0, -R * 0.6], "轮体（绕 y 轴滚）", c.blue, -105, 24);
        view.label([0, 0, R], "滚子轴 45°", c.gold, 12, -20);
        view.render(null);
        readout.innerHTML = texLite("<p><b>麦克纳姆轮</b>：轮体绕自身轴（y）滚动，轮缘上的滚子轴与轮平面成 <b>45°</b> 斜置。</p>" +
          "<p class='lab-note'>滚子沿轮缘切向斜置，与轮平面成 45°；接触处可沿滚子允许的方向被动运动。四个适当布置、独立驱动的轮子可合成前进、横移与旋转。单个轮子的特写不能单独证明整车全向性，本图不模拟受力。</p>");
        return;
      }

      var motion = kernel.chassisMotion(layout.id, state);
      view.grid(0.75, 0.15, -0.1, { color: c.line });
      /* 机身 */
      var casterLayout = layout.id === "omni3";
      view.box([0, 0, 0.18], [0.22, 0.16, 0.025], kernel.Tid().R, { color: c.neutral });

      /* 轮子 */
      motion.wheels.forEach(function (w, index) {
        var wheelAxis = [-Math.sin(w.heading), Math.cos(w.heading), 0];
        var color = w.drive ? c.blue : c.gold;
        view.line([0, 0, 0.18], [w.pivot[0], w.pivot[1], 0.18], { color: c.neutral, width: 6 });
        if (!w.caster) view.line([w.x, w.y, 0.18], [w.x, w.y, 0], { color: c.neutral, width: 3 });
        wheel(view, w.x, w.y, 0.1, 0.07, wheelAxis, color);
        if (w.caster) {
          view.line([w.pivot[0], w.pivot[1], 0.18], [w.pivot[0], w.pivot[1], 0], { color: c.purple, width: 2 });
          view.line([w.pivot[0], w.pivot[1], 0.14], [w.x, w.y, 0.14], { color: c.purple, width: 3 });
          view.line([w.x, w.y, 0.14], [w.x, w.y, 0], { color: c.purple, width: 2 });
          if (casterLayout && index === 2) view.label([w.x, w.y, 0.18], "偏置 e", c.purple, -25, -8);
        }
        view.label([w.x, w.y, -0.1], "轮" + (index + 1), color, 5, 16);
      });

      /* 速度与角速度 */
      var origin = [motion.reference[0], motion.reference[1], 0.28];
      view.triad([0.55, -0.5, 0], kernel.Tid().R, 0.16, ["x 前", "y 左", "z 上"], {colors:[c.muted,c.muted,c.muted]});
      if (Math.hypot(motion.vx, motion.vy) > 1e-6) {
        var velocityTip = kernel.addv(origin, [motion.vx * 0.5, motion.vy * 0.5, 0]);
        view.line(origin, velocityTip, { color: c.green, width: 3 });
        view.sphere(velocityTip, 0.018, { color: c.green });
      }
      if (Math.abs(motion.omega) > 1e-6) {
        view.arc(origin, [1, 0, 0], [0, 1, 0], 0.34, 0, Math.max(-2.6, Math.min(2.6, motion.omega * 0.6)),
          { color: c.red, width: 2.4 });
      }

      view.render(null);

      var html = "<p><b>" + layout.name + "</b>：" + layout.sub + "。</p>";
      html += "<p class='lab-note'>" + layout.note + "</p>";
      html += "<p data-chassis-motion>车体坐标速度：vₓ = " + motion.vx.toFixed(3) + " m/s；vᵧ = " + motion.vy.toFixed(3) + " m/s；ω = " + motion.omega.toFixed(3) + " rad/s。</p>";
      html += "<p>各轮轮缘速度（轮 1…" + motion.wheels.length + "）：" + motion.wheels.map(function (w) {return w.speed.toFixed(3);}).join("，") + " m/s。</p>";
      if (layout.id === "car") {
        html += "<p data-chassis-steering>左前轮 δ左 = " + (motion.wheels[2].heading / DEG).toFixed(2) + "°；右前轮 δ右 = " + (motion.wheels[3].heading / DEG).toFixed(2) + "°；" + (motion.radius === null ? "直行，转弯半径趋于无穷。" : "后轴中心有符号转弯半径 R = " + motion.radius.toFixed(3) + " m。") + "</p>";
      }
      if (layout.id === "omni3") {
        html += "<p>当前轮向 β = 0°、120°、240°，被动转向速率 β̇（相对底盘）：" + motion.wheels.map(function (w) {return w.swivel.toFixed(3);}).join("，") + " rad/s。该数值由偏置处的无侧滑条件计算，并非三个转向电机指令。</p>";
      }
      readout.innerHTML = texLite(html);
    }

    resetControls();
    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* ================= 实验：drive3d · 三种传动装置（ch05 §5.1.1.2 / §5.2.3） ================= */

  function labDrive3D(host) {
    var state = { mode: "gear", theta: 0, kr: 10, lead: 0.02, rIn: 0.12, rOut: 0.3 };
    var RAD = 2 * Math.PI;

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "三种传动装置：旋转怎么变成另一样东西"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "拖「输入转角」看传动结果。**齿轮副**：小齿轮（电机）带大齿轮（关节），<b>转向相反</b>、转速按半径比缩小；**滚珠丝杠**：转动变成沿轴的<b>平移</b>，位移 = 转角 × 导程 / 2π；**同步带**：两轮靠带传动，同样是旋转→旋转，但可把电机<b>远置</b>。下方给出 5.2.3 的三个折算因子：转速 ×k_r、力矩 ÷k_r、惯量 ÷k_r²。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    toggleGroup(controls, "装置", [
      { value: "gear", text: "圆柱齿轮副" },
      { value: "screw", text: "滚珠丝杠" },
      { value: "belt", text: "同步带" }
    ], "gear", function (v) { state.mode = v; draw(); });
    slider(controls, "输入转角 θ_m", -180, 180, 1, state.theta, function (v) { state.theta = v; draw(); },
      function (v) { return v.toFixed(0) + "°"; });
    slider(controls, "减速比 k_r", 2, 100, 1, state.kr, function (v) { state.kr = v; draw(); },
      function (v) { return v.toFixed(0); });
    slider(controls, "导程 l（丝杠）", 0.005, 0.05, 0.001, state.lead, function (v) { state.lead = v; draw(); },
      function (v) { return (v * 1000).toFixed(0) + " mm"; });

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "齿轮副、滚珠丝杠与同步带的三维演示");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);

    var view = makeView(canvas, 0.58, { span: 1.25, center: [0, 0, 0], az: -36, elv: 24 });
    view.onChange = function () { draw(); };

    /* 齿轮：齿数随半径，齿沿圆周分布 */
    function gear(v, center, r, teeth, angle, color, axis) {
      var rot = kernel.rotAxis(axis, angle);
      var toothH = r * 0.16, toothW = r * 0.13;
      for (var i = 0; i < teeth; i++) {
        var a = 2 * Math.PI * i / teeth + angle;
        var dir = [Math.cos(a), Math.sin(a), 0];
        var tip = kernel.addv(center, kernel.sclv(dir, r + toothH * 0.5));
        var R = [[rot[0][0], rot[1][0], rot[2][0]], [rot[0][1], rot[1][1], rot[2][1]], [rot[0][2], rot[1][2], rot[2][2]]];
        var local = [r + toothH * 0.2, 0, 0];
        var off = kernel.Trot({ R: R, p: [0, 0, 0] }, local);
        var p = kernel.addv(center, off);
        view.box(p, [toothH * 0.5, toothW * 0.5, r * 0.7], R, { color: color });
      }
      view.cyl(kernel.addv(center, kernel.sclv(axis, -r * 0.55)), kernel.addv(center, kernel.sclv(axis, r * 0.55)), r * 0.82,
        { color: color, seg: 20 });
    }

    function draw() {
      var c = palette();
      view.grid(0.7, 0.14, -0.28, { color: c.line });
      var th = state.theta * Math.PI / 180;
      var kr = state.kr;
      var outTh = th / kr;
      var html = "";

      if (state.mode === "gear") {
        /* 小齿轮（电机）在左，大齿轮（关节）在右，轴平行于 z */
        var rM = 0.11, rJ = rM * kr;
        var rm = Math.min(0.16, rM), rj = Math.min(0.26, rM * Math.min(kr, 12) / 6);
        var cM = [-rj - rm - 0.03, 0, 0], cJ = [0, 0, 0];
        /* 轴线 */
        view.cyl(kernel.addv(cM, [0, 0, -0.3]), kernel.addv(cM, [0, 0, 0.16]), 0.022, { color: c.muted, seg: 8 });
        view.cyl(kernel.addv(cJ, [0, 0, -0.3]), kernel.addv(cJ, [0, 0, 0.16]), 0.022, { color: c.muted, seg: 8 });
        gear(view, cM, rm, Math.max(8, Math.round(rm * 60)), th, c.blue, [0, 0, 1]);
        gear(view, cJ, rj, Math.max(10, Math.round(rj * 60)), -outTh, c.gold, [0, 0, 1]);
        /* 啮合点标记 */
        view.sphere([cJ[0] - rj, cJ[1], cJ[2]], 0.02, { color: c.red });
        view.label(cM, "电机小齿轮 r_m", c.blue, -46, 16);
        view.label(cJ, "关节大齿轮 r", c.gold, 12, -8);
        html += "<p><b>齿轮副</b>：旋转 → 旋转，<b>转向相反</b>（外啮合）；转速比 = 半径比 = 齿数比。</p>";
        html += "<p class='lab-note'>减速比 kᵣ=r/rₘ=" + kr + "：关节转 " + (outTh * 180 / Math.PI).toFixed(1) +
          "°，电机转 " + state.theta.toFixed(0) + "°。<b>力矩按 1/k_r 放大、惯量按 1/k_r² 缩小</b>（5.2.3）。" +
          (kr >= 20 ? "大减速比还让<b>非线性耦合项相对线性化</b>——这正是 5.2.3 的结论。" : "减速比还小，负载的非线性项在电机端仍占相当比重。") + "</p>";
      } else if (state.mode === "screw") {
        /* 丝杠轴沿 x，螺母沿轴移动 */
        var L = 0.62;
        view.cyl([-L / 2, 0, 0], [L / 2, 0, 0], 0.05, { color: c.neutral, seg: 16 });
        /* 螺旋线 */
        var turns = 7, pts = [], i;
        for (i = 0; i <= turns * 24; i++) {
          var f = i / (turns * 24);
          var a = f * turns * RAD + th;
          pts.push([-L / 2 + f * L, 0.065 * Math.cos(a), 0.065 * Math.sin(a)]);
        }
        view.path(pts, { color: c.gold, width: 1.8 });
        /* 滚珠 */
        for (i = 0; i < 6; i++) {
          var fb = (i + 0.5) / 6;
          var ab = fb * turns * RAD + th;
          view.sphere([-L / 2 + fb * L, 0.065 * Math.cos(ab), 0.065 * Math.sin(ab)], 0.018, { color: c.blue });
        }
        /* 螺母 */
        var disp = th * state.lead / RAD;
        var xN = Math.max(-L / 2 + 0.05, Math.min(L / 2 - 0.05, disp));
        view.box([xN, 0, 0], [0.05, 0.11, 0.11], kernel.Tid().R, { color: c.green });
        view.label([xN, 0.14, 0], "螺母（移动关节）", c.green, 10, 4);
        view.label([L / 2, 0, 0], "丝杠（固定）", c.neutral, -30, 18);
        html += "<p><b>滚珠丝杠</b>：旋转 → <b>平移</b>，用于移动关节（棱柱关节）。</p>";
        html += "<p class='lab-note'>导程 l=" + (state.lead * 1000).toFixed(0) + " mm/圈 ⇒ 电机转 " + state.theta.toFixed(0) +
          "° 时螺母移动 " + (disp * 1000).toFixed(1) + " mm（= 转角 × 导程 / 2π）。" +
          "滚珠把滑动摩擦变成滚动摩擦，**刚度高、间隙小**——代价是结构复杂、成本高。</p>";
      } else {
        /* 同步带：两轮 + 带 */
        var r1 = 0.1, r2 = 0.2, d = 0.52;
        var c1 = [-d / 2, 0, 0], c2 = [d / 2, 0, 0];
        view.cyl(kernel.addv(c1, [0, 0, -0.05]), kernel.addv(c1, [0, 0, 0.05]), r1, { color: c.blue, seg: 16 });
        view.cyl(kernel.addv(c2, [0, 0, -0.05]), kernel.addv(c2, [0, 0, 0.05]), r2, { color: c.gold, seg: 16 });
        /* 带：两条外公切线 + 两段包角弧 */
        var ang = Math.asin((r2 - r1) / d);
        var u1 = [Math.cos(Math.PI / 2 + ang), Math.sin(Math.PI / 2 + ang), 0];
        var u2 = [Math.cos(-Math.PI / 2 - ang), Math.sin(-Math.PI / 2 - ang), 0];
        view.line(kernel.addv(c1, kernel.sclv(u1, r1)), kernel.addv(c2, kernel.sclv(u1, r2)), { color: c.red, width: 3 });
        view.line(kernel.addv(c1, kernel.sclv(u2, r1)), kernel.addv(c2, kernel.sclv(u2, r2)), { color: c.red, width: 3 });
        view.arc(c1, [0, 0, 1], [Math.cos(Math.PI / 2 + ang), Math.sin(Math.PI / 2 + ang), 0], r1,
          Math.PI / 2 + ang, -Math.PI / 2 - ang, { color: c.red, width: 3 });
        view.arc(c2, [0, 0, 1], [Math.cos(-Math.PI / 2 - ang), Math.sin(-Math.PI / 2 - ang), 0], r2,
          -Math.PI / 2 - ang, Math.PI / 2 + ang, { color: c.red, width: 3 });
        /* 轮上的辐条标出转动 */
        for (var i = 0; i < 4; i++) {
          var a1 = th + i * Math.PI / 2;
          view.line(c1, kernel.addv(c1, [Math.cos(a1) * r1 * 0.9, Math.sin(a1) * r1 * 0.9, 0.06]), { color: c.blue, width: 1.4 });
          var a2 = -outTh + i * Math.PI / 2;
          view.line(c2, kernel.addv(c2, [Math.cos(a2) * r2 * 0.9, Math.sin(a2) * r2 * 0.9, 0.06]), { color: c.gold, width: 1.4 });
        }
        view.label(c1, "主动轮（电机）", c.blue, -46, 14);
        view.label(c2, "从动轮（关节）", c.gold, 12, -8);
        html += "<p><b>同步带</b>：旋转 → 旋转，<b>同向</b>；作用是<b>把电机远置</b>（远离关节，减小惯量与结构约束）。</p>";
        html += "<p class='lab-note'>带速相等 ⇒ R₁ω₁=R₂ω₂，从动轮转速按半径比缩放。" +
          "带轻（高速低矩），但橡胶带<b>力矩太大就变形</b>；正时链是钢的、能扛大力矩，但重、高速会颤动——" +
          "<b>要快要轻用带，要重耐操用链</b>（5.1.1.2）。</p>";
      }

      view.render(null);

      html += "<table class='lab-matrix'><thead><tr><th>量</th><th>折算关系</th><th>k_r = " + kr + " 时</th></tr></thead><tbody>" +
        "<tr><td>关节转速</td><td>÷ k_r</td><td>" + (1 / kr).toFixed(4) + " 倍</td></tr>" +
        "<tr><td>关节力矩</td><td>× k_r</td><td>" + kr + " 倍</td></tr>" +
        "<tr><td>负载惯量（折到电机侧）</td><td>÷ k_r²</td><td>" + (1 / (kr * kr)).toExponential(2) + " 倍</td></tr>" +
        "</tbody></table>";
      html += "<p class='lab-note'>这三行就是 5.2.3 的核心：<b>大减速比让电机侧的惯量与黏滞摩擦按 1/k_r² 缩小，负载力矩按 1/k_r 减小</b>。" +
        "同一条曲线的另一面：直驱虽然省掉了传动装置的间隙与弹性，却<b>省不掉这些折算</b>——电机得直接扛负载惯量。</p>";
      readout.innerHTML = html;
    }

    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* ================= 实验：motor3d · 伺服电机的内部结构（ch05 §5.1.2） ================= */

  function labMotor3D(host) {
    var state = { mode: "brushed", theta: 0, cut: true };

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "伺服电机里面长什么样：换向器为什么必须转"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "两台电机剖开来对比。**永磁直流（有刷）**：磁极固定在定子上，电枢绕组在转子上，靠**换向器 + 电刷**机械换向——拖动转子，看**换向器跟着转、电刷固定不动**。**无刷直流**：永磁体搬到转子上，定子是多相绕组，轴上加**位置传感器**，由电子模块按转子位置依次给相绕组通电——**没有换向器，也没有电刷**。两者的「换向装置」位置正好互换，这是 5.1.2 的关键对照。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    toggleGroup(controls, "类型", [{ value: "brushed", text: "永磁直流（有刷）" }, { value: "brushless", text: "无刷直流（BLDC）" }], "brushed",
      function (v) { state.mode = v; draw(); });
    slider(controls, "转子转角", -180, 180, 1, state.theta, function (v) { state.theta = v; draw(); },
      function (v) { return v.toFixed(0) + "°"; });

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "伺服电机剖面：定子、转子、换向器与电刷");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);

    var view = makeView(canvas, 0.62, { span: 0.92, center: [0, 0, 0], az: -42, elv: 24 });
    view.onChange = function () { draw(); };

    /* 以 z 为轴的电机剖面：外壳半径 R，转子半径 r */
    function shell(v, z0, z1, R, color, seg, gapFrom, gapTo) {
      var i, ang, a0 = gapFrom || 0, a1 = gapTo === undefined ? 2 * Math.PI : gapTo;
      var N = seg || 18;
      for (i = 0; i < N; i++) {
        var t0 = a0 + (a1 - a0) * i / N, t1 = a0 + (a1 - a0) * (i + 1) / N;
        var p1 = [R * Math.cos(t0), R * Math.sin(t0), z0];
        var p2 = [R * Math.cos(t1), R * Math.sin(t1), z0];
        var p3 = [p2[0], p2[1], z1];
        var p4 = [p1[0], p1[1], z1];
        v.poly([p1, p2, p3, p4], { color: color, both: true });
      }
    }
    function disc(v, z, R, color, seg) {
      var pts = [], i;
      for (i = 0; i < (seg || 18); i++) {
        var a = 2 * Math.PI * i / (seg || 18);
        pts.push([R * Math.cos(a), R * Math.sin(a), z]);
      }
      v.poly(pts, { color: color });
    }

    function draw() {
      var c = palette();
      var th = state.theta * Math.PI / 180;
      var R = 0.26, r = 0.15, L = 0.34;
      var cut = state.cut;

      view.grid(0.42, 0.14, -0.34, { color: c.line });
      /* 外壳（剖开：只画 2/3，留缺口露出内部） */
      shell(view, -L / 2, L / 2, R, c.neutral, 16, cut ? -Math.PI * 0.35 : 0, cut ? Math.PI * 1.05 : 2 * Math.PI);

      if (state.mode === "brushed") {
        /* 永磁体（定子磁极）：两段弧 */
        shell(view, -L / 2 + 0.03, L / 2 - 0.03, r * 0.98, c.purple, 10, Math.PI * 0.18, Math.PI * 0.82);
        shell(view, -L / 2 + 0.03, L / 2 - 0.03, r * 0.98, c.purple, 10, Math.PI * 1.18, Math.PI * 1.82);
        /* 电枢（转子 + 绕组） */
        view.cyl([0, 0, -L / 2 + 0.02], [0, 0, L / 2 - 0.02], r * 0.6, { color: c.blue, seg: 14 });
        for (var i = 0; i < 6; i++) {
          var a = th + i * Math.PI / 3;
          var px = r * 0.82 * Math.cos(a), py = r * 0.82 * Math.sin(a);
          view.box([px, py, 0], [0.028, 0.028, L / 2 - 0.08],
            [[Math.cos(a), -Math.sin(a), 0], [Math.sin(a), Math.cos(a), 0], [0, 0, 1]], { color: c.gold });
        }
        /* 换向器：轴上分段圆柱，随转子转 */
        var segs = 6;
        for (i = 0; i < segs; i++) {
          var a0 = th + i * 2 * Math.PI / segs, a1 = th + (i + 1) * 2 * Math.PI / segs;
          var pts = [];
          for (var j = 0; j <= 3; j++) {
            var aa = a0 + (a1 - a0) * j / 3;
            pts.push([r * 0.5 * Math.cos(aa), r * 0.5 * Math.sin(aa), -L / 2 + 0.02]);
          }
          for (j = 3; j >= 0; j--) {
            var ab = a0 + (a1 - a0) * j / 3;
            pts.push([r * 0.5 * Math.cos(ab), r * 0.5 * Math.sin(ab), -L / 2 + 0.09]);
          }
          view.poly(pts, { color: i % 2 ? c.green : c.red, both: true });
        }
        /* 电刷：固定，压在换向器上 */
        view.box([0, r * 0.62, -L / 2 + 0.055], [0.035, 0.03, 0.045], kernel.Tid().R, { color: c.ink2 });
        view.box([0, -r * 0.62, -L / 2 + 0.055], [0.035, 0.03, 0.045], kernel.Tid().R, { color: c.ink2 });
        view.label([0, r * 0.62, -L / 2 + 0.12], "电刷（固定）", c.ink2, 10, 4);
        view.label([0, -r * 0.62, -L / 2 + 0.12], "电刷（固定）", c.ink2, 10, 4);
        view.label([0, 0, L / 2 + 0.03], "换向器（随转子转）", c.green, 10, 2);
        view.label([0, r * 0.98, 0], "永磁体（定子）", c.purple, 12, 0);
        view.label([0, 0, -L / 2 - 0.06], "转子电枢绕组（随转子转）", c.gold, -70, 8);
      } else {
        /* 无刷：永磁转子（3 极）+ 多相定子绕组 + 位置传感器 + 静态整流器 */
        var pole = 0.11;
        for (i = 0; i < 3; i++) {
          var ap = th + i * 2 * Math.PI / 3;
          var p1 = [pole * Math.cos(ap), pole * Math.sin(ap), -L / 2 + 0.03];
          var p2 = [pole * Math.cos(ap + 0.5), pole * Math.sin(ap + 0.5), -L / 2 + 0.03];
          var p3 = [p2[0], p2[1], L / 2 - 0.03];
          var p4 = [p1[0], p1[1], L / 2 - 0.03];
          view.poly([p1, p2, p3, p4], { color: i === 1 ? c.red : c.purple, both: true });
        }
        view.cyl([0, 0, -L / 2 + 0.05], [0, 0, L / 2 - 0.05], pole * 0.55, { color: c.blue, seg: 12 });
        /* 三相定子绕组（6 个线圈块） */
        var phases = ["A", "B", "C"], phaseCol = [c.blue, c.green, c.gold];
        for (i = 0; i < 6; i++) {
          var ag = i * Math.PI / 3 + Math.PI / 6;
          var ph = Math.floor(i / 2) % 3;
          view.box([r * 0.86 * Math.cos(ag), r * 0.86 * Math.sin(ag), 0], [0.032, 0.032, L / 2 - 0.1],
            [[Math.cos(ag), -Math.sin(ag), 0], [Math.sin(ag), Math.cos(ag), 0], [0, 0, 1]], { color: phaseCol[ph] });
        }
        /* 轴上位置传感器 */
        view.box([0, 0, L / 2 + 0.05], [0.05, 0.05, 0.025], kernel.Tid().R, { color: c.gold });
        view.label([0, 0, L / 2 + 0.1], "位置传感器（轴上）", c.gold, 12, 2);
        /* 静态整流器 */
        view.box([0.42, 0, -0.18], [0.1, 0.07, 0.05], kernel.Tid().R, { color: c.ink2 });
        view.label([0.42, 0, -0.26], "静态整流器 / 电子模块", c.ink2, -40, 4);
        phases.forEach(function (nm, k) {
          view.line([0.34, 0, -0.18], [r * 0.86 * Math.cos(k * 2 * Math.PI / 3 + Math.PI / 6), r * 0.86 * Math.sin(k * 2 * Math.PI / 3 + Math.PI / 6), 0],
            { color: phaseCol[k], width: 1.4 });
        });
        view.label([0, r * 0.98, 0], "多相定子绕组", c.ink2, 12, 0);
        view.label([0, 0, -L / 2 - 0.06], "永磁转子（随转子转）", c.purple, -70, 8);
      }

      view.render(null);

      var html = state.mode === "brushed"
        ? "<p><b>永磁直流（有刷）</b>：① <b>定子</b>由永磁体（铁磁陶瓷或稀土）产生磁通量；② <b>电枢</b>是绕在旋转磁心上的通电绕组；③ <b>换向器</b>按转子运动决定换向逻辑，并通过<b>电刷</b>给旋转的电枢线圈供电。</p>" +
          "<p class='lab-note'>拖转子时注意：<b>换向器与电枢一起转，电刷固定不动</b>——机械换向就发生在这个错位里：线圈转到某个位置时，换向器把它的接点反接到另一极，于是力矩方向自动跟着反转，不用外部开关。<b>代价</b>是电刷与换向器的接触压降（电损耗）、摩擦发热与磨损、以及换向器限制的转速上限。</p>"
        : "<p><b>无刷直流（BLDC）</b>：① <b>永磁转子</b>；② <b>多相定子绕组</b>；③ <b>静态整流器</b>——根据轴上位置传感器的信号，按转子位置生成各相绕组的馈入序列。</p>" +
          "<p class='lab-note'>换相原理：先由位置传感器找到<b>与磁场正交的线圈</b>，磁场作用其上使转子转动；转子转过之后，电子模块让磁场依次与各相定子绕组作用，<b>电枢磁场始终与定子磁场正交</b>——与有刷电机里「电刷位于激磁磁场 π/2 角处」的工作方式相似。好处是定转子功能互换带来的四条：散热更好（绕组在定子上）、转子紧凑（无绕组，可用稀土永磁）、<b>转动惯量更小</b>（呼应六条要求第 1 条）、无电刷磨损与电损耗。</p>";
      html += "<p class='lab-note'><b>一句话对照</b>：有刷电机里的<b>电刷 + 换向器</b>，与无刷电机里的<b>位置传感器 + 电子控制模块</b>，所起的作用是类似的——一个用机械方式换向，一个用电子方式换向。</p>";
      readout.innerHTML = html;
    }

    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* ================= 实验：sensor3d · 传感器装在哪、怎么测（ch05 §5.3 / §5.4） ================= */

  function labSensor3D(host) {
    var state = { mode: "where", show: { enc: true, tach: true, strain: true, force: true, dist: true, cam: true } };

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "传感器：装在哪儿，测的是什么"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "模式①把传感器摆到机械臂的真实位置：<b>本体传感器</b>测关节内部的三个量——位置（编码器，装在关节电机轴上）、速度（测速反馈）、力矩（关节应变片）；<b>外部传感器</b>测与环境的交互——腕力传感器在腕部、距离传感器（超声/激光）在腕部朝外、视觉相机在腕部或头部。模式②把关节剖开，看**增量式编码器**怎么把角位置变成数字：码盘随轴转、遮光槽让光电开关输出脉冲。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    toggleGroup(controls, "模式", [{ value: "where", text: "① 传感器装在哪" }, { value: "encoder", text: "② 编码器怎么测角" }], "where",
      function (v) { state.mode = v; draw(); });

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "机器人上的传感器布置与编码器结构");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);

    var view = makeView(canvas, 0.6, { span: 1.5, center: [0, 0, 0.28], az: -36, elv: 19 });
    view.onChange = function () { draw(); };

    /* 增量式编码器：码盘（带 N 条遮光槽）+ 光电开关 */
    function encoder(v, z0, z1, N) {
      var c = palette();
      var R = 0.16;
      /* 码盘 */
      v.cyl([0, 0, z0], [0, 0, z0 + 0.02], R, { color: c.neutral, seg: 18 });
      var i, j;
      for (i = 0; i < N; i++) {
        var a0 = 2 * Math.PI * i / N, a1 = 2 * Math.PI * (i + 0.55) / N;
        var pts = [];
        for (j = 0; j <= 3; j++) {
          var aa = a0 + (a1 - a0) * j / 3;
          pts.push([R * Math.cos(aa), R * Math.sin(aa), z0 + 0.02]);
        }
        for (j = 3; j >= 0; j--) {
          var ab = a0 + (a1 - a0) * j / 3;
          pts.push([R * Math.cos(ab), R * Math.sin(ab), z0 - 0.015]);
        }
        v.poly(pts, { color: c.ink2, both: true });
      }
      /* 两只光电开关（固定） */
      [-1, 1].forEach(function (sgn) {
        var y = sgn * (R + 0.05);
        v.box([0, y, z0 + 0.002], [0.03, 0.022, 0.028], kernel.Tid().R, { color: c.gold });
        v.line([0, y, z0 + 0.002], [0, sgn * R * 0.99, z0 + 0.002], { color: c.gold, width: 1.2, dash: [3, 3] });
      });
      /* 电机轴 */
      v.cyl([0, 0, z0 - 0.09], [0, 0, z1], 0.035, { color: c.blue, seg: 12 });
    }

    function draw() {
      var c = palette();
      if (state.mode === "encoder") {
        view.grid(0.4, 0.08, -0.34, { color: c.line });
        encoder(view, -0.05, 0.34, 16);
        view.label([0, 0.22, -0.05], "码盘（随轴转，16 条槽）", c.ink2, 12, 2);
        view.label([0.06, 0.21, -0.05], "光电开关（固定）", c.gold, 10, 4);
        view.label([0, -0.1, -0.14], "电机轴（被测转角）", c.blue, 12, 2);
        view.render(null);
        readout.innerHTML = "<p><b>增量式编码器</b>：码盘固定在电机轴上，盘上开 N 条等距遮光槽；两只<b>光电开关</b>固定在机壳上，对准槽区。" +
          "轴每转过一个槽距，开关输出一个脉冲——<b>数脉冲的个数就知道转了多少</b>，再由两路信号的先后关系定出方向。这就是「角位置 → 数字」的空间实现。</p>" +
          "<p class='lab-note'>分辨率 = 360°/N（16 槽即 22.5°/脉冲，实际靠细分到 1/1000 rad 量级）。" +
          "代价是<b>必须知道初始位置</b>（上电找零），而绝对式编码器（磁式/光电式）直接读出绝对位置、无需归零。</p>";
        return;
      }

      /* 模式①：传感器布置 */
      view.grid(0.85, 0.17, 0, { color: c.line });
      /* 机械臂本体（拟人臂三自由度） */
      var J1 = [0, 0, 0.18], J2 = [0.42, 0, 0.62], W = [0.78, 0, 0.5];
      view.cyl([0, 0, 0], J1, 0.06, { color: c.neutral, seg: 10 });
      view.cyl(J1, J2, 0.045, { color: c.blue });
      view.cyl(J2, W, 0.04, { color: c.blue });
      view.sphere(J1, 0.06, { color: c.green });
      view.sphere(J2, 0.05, { color: c.green });
      /* 腕与末端 */
      view.box(W, [0.05, 0.05, 0.05], kernel.Tid().R, { color: c.gold });
      view.cyl([W[0] + 0.05, 0, W[2]], [W[0] + 0.16, 0, W[2]], 0.018, { color: c.neutral, seg: 8 });

      function mark(p, name, color, offset) {
        view.sphere(p, 0.032, { color: color });
        view.label(p, name, color, offset ? offset[0] : 10, offset ? offset[1] : -4);
        view.line(p, kernel.addv(p, [0, 0, 0.09]), { color: color, width: 1, dash: [3, 3] });
      }
      if (state.show.enc) mark([J2[0] - 0.12, 0, J2[2] - 0.07], "编码器（位置）", c.purple, [-70, 10]);
      if (state.show.tach) mark([J2[0] - 0.2, 0, J2[2] - 0.11], "测速（速度）", c.blue, [-70, 26]);
      if (state.show.strain) mark([J1[0] + 0.18, 0, J1[2] + 0.05], "应变片（力矩）", c.green, [8, -10]);
      if (state.show.force) mark([W[0] + 0.1, 0, W[2]], "腕力传感器", c.red, [10, 6]);
      if (state.show.dist) mark([W[0] + 0.16, 0.02, W[2] + 0.05], "距离（超声/激光）", c.gold, [10, -10]);
      if (state.show.cam) mark([W[0] + 0.02, 0.08, W[2] + 0.12], "视觉相机", c.neutral, [10, -12]);
      /* 视场锥（视觉/距离） */
      view.arc([W[0] + 0.17, 0, W[2]], [0, 1, 0], [1, 0, 0], 0.12, -0.5, 0.5, { color: c.gold, width: 1.2, dash: [4, 3] });
      view.path([
        [W[0] + 0.17, 0, W[2]], [W[0] + 0.55, -0.16, W[2] + 0.1], [W[0] + 0.55, 0.16, W[2] + 0.1], [W[0] + 0.17, 0, W[2]]
      ], { color: c.gold, width: 1.1, dash: [4, 3] });

      view.render(null);

      var html = "<p><b>本体传感器</b>（测关节内部的三个状态量）与<b>外部传感器</b>（测与环境交互）装在完全不同的位置：</p>";
      html += "<table class='lab-matrix'><thead><tr><th>传感器</th><th>装在哪</th><th>测什么</th></tr></thead><tbody>" +
        "<tr><td>编码器 / 旋转变压器</td><td>关节电机轴上</td><td>关节位置（外环反馈，最常用）</td></tr>" +
        "<tr><td>测速反馈</td><td>电机侧</td><td>关节速度（内环反馈，也可由编码器微分间接得到）</td></tr>" +
        "<tr><td>应变片</td><td>关节/连杆根部</td><td>关节力矩</td></tr>" +
        "<tr><td>腕力传感器</td><td>腕部（外链与末端之间）</td><td>3 力分量 + 3 力矩分量（六维）</td></tr>" +
        "<tr><td>距离传感器</td><td>腕部朝外</td><td>障碍物距离（超声传播时间 / 激光三角测量）</td></tr>" +
        "<tr><td>视觉传感器</td><td>腕部或头部</td><td>目标特征（CCD 积分转移 / CMOS 每像素放大）</td></tr>" +
        "</tbody></table>";
      html += "<p class='lab-note'>位置、速度、力矩是<b>三个</b>量——「有了编码器就不需要别的传感器」是常见误解；而速度还有两条测法：直接测（测速反馈）与间接测（编码器角位置对时间微分），精度与带宽各有权衡。外部传感器的共同点是<b>与环境交互</b>，且不一定装在机器人本体上（也可以装在空间里）。</p>";
      readout.innerHTML = html;
      return;
    }

    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* ================= 实验：hyd3d · 液压驱动：缸体、活塞与三支流路（ch05 §5.2.2） ================= */

  function labHyd3D(host) {
    var state = { d: 0.32, qm: 0.5, leak: 0.12, comp: 0.08 };

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "液压驱动：缸筒、活塞，以及流量的三条去路"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "液压缸 = 缸体 + 活塞杆：<b>推动伸缩 d</b> 就是移动关节的位移（教材 §7.3 的两连杆笛卡儿臂就是它驱动的，见 6.3.1）。泵送来的体积流速 Q 并不全用来推活塞——它分成三条去路：<b>Qₘ 有用流量</b>（推活塞）、<b>Q_l 泄漏</b>（缸壁间隙漏回储液池）、<b>Q_c 压缩</b>（油液被压缩储存在缸里）。拖活塞看这三条支路如何随速度与位置变化——这正是液压与电气最本质的差别。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    slider(controls, "活塞位移 d", 0.05, 0.55, 0.005, state.d, function (v) { state.d = v; draw(); },
      function (v) { return (v * 1000).toFixed(0) + " mm"; });
    slider(controls, "泵流量 Q", 0.1, 1, 0.05, state.qm, function (v) { state.qm = v; draw(); },
      function (v) { return v.toFixed(2) + " L/s"; });
    slider(controls, "泄漏 Q_l", 0, 0.4, 0.01, state.leak, function (v) { state.leak = v; draw(); },
      function (v) { return v.toFixed(2); });
    slider(controls, "压缩 Q_c", 0, 0.4, 0.01, state.comp, function (v) { state.comp = v; draw(); },
      function (v) { return v.toFixed(2); });

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "液压缸结构与流量的三条去路");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);

    var view = makeView(canvas, 0.58, { span: 1.15, center: [0, 0, 0.18], az: -38, elv: 20 });
    view.onChange = function () { draw(); };

    function draw() {
      var c = palette();
      var R = 0.11, L = 0.62;
      /* 缸体（剖开一半，露出活塞） */
      var segs = 14, i, j;
      for (i = 0; i < segs; i++) {
        var a0 = Math.PI * 0.1 + (Math.PI * 0.8) * i / segs;
        var a1 = Math.PI * 0.1 + (Math.PI * 0.8) * (i + 1) / segs;
        var p1 = [R * Math.cos(a0), R * Math.sin(a0), 0];
        var p2 = [R * Math.cos(a1), R * Math.sin(a1), 0];
        var p3 = [p2[0], p2[1], L];
        var p4 = [p1[0], p1[1], L];
        view.poly([p1, p2, p3, p4], { color: c.neutral, both: true });
      }
      /* 缸底与杆端盖 */
      view.box([0, 0, -0.02], [R, R, 0.02], kernel.Tid().R, { color: c.neutral });
      /* 活塞 + 活塞杆 */
      view.cyl([0, 0, -0.02], [0, 0, state.d], R * 0.92, { color: c.green, seg: 14 });
      view.cyl([0, 0, state.d], [0, 0, L + 0.12], 0.026, { color: c.blue, seg: 10 });
      /* 油液 */
      view.cyl([0, 0, 0.005], [0, 0, Math.max(0.01, state.d - 0.005)], R * 0.86, { color: c.gold, seg: 12 });
      view.label([0, 0, state.d + 0.16], "活塞杆（连到移动关节）", c.blue, 12, 2);
      view.label([0, 0, 0.01], "油液（可压缩）", c.gold, -46, 14);
      view.label([0, R * 0.9, L * 0.6], "缸体", c.neutral, 10, 0);
      view.label([0, 0, state.d * 0.5], "活塞", c.green, 10, -6);

      /* 流路：泵 → 分布器 → 三条支路 */
      var src = [-0.42, 0, L * 0.75];
      view.box(src, [0.06, 0.05, 0.05], kernel.Tid().R, { color: c.ink2 });
      view.label(src, "泵 + 分布器", c.ink2, -30, -14);
      var junction = [-0.22, 0, L * 0.75];
      view.line(src, junction, { color: c.ink2, width: 2.4 });
      var Q = state.qm + state.leak + state.comp;
      var qm = state.qm / Q, ql = state.leak / Q, qc = state.comp / Q;
      var outP = [junction[0] - 0.12, 0, junction[2]];
      var outL = [junction[0], 0.28, junction[2] + 0.06];
      var outC = [junction[0], -0.28, junction[2] + 0.06];
      view.line(junction, outP, { color: c.green, width: 2 + 5 * qm });
      view.line(junction, outL, { color: c.red, width: 2 + 5 * ql });
      view.line(junction, outC, { color: c.gold, width: 2 + 5 * qc });
      view.label(outP, "Q_m 有用（推活塞）", c.green, -70, 4);
      view.label(outL, "Q_l 泄漏", c.red, 8, -4);
      view.label(outC, "Q_c 压缩", c.gold, 8, 10);
      /* 有用流量的终点：缸腔 */
      view.line(outP, [0, 0, state.d * 0.5], { color: c.green, width: 1.6, dash: [4, 3] });

      view.render(null);

      var html = "<p><b>流速平衡</b>：分布器送出的体积流速 Q 分成三份——" +
        "Qₘ 推活塞（有用）、Q_l 经缸壁间隙漏回储液池（<b>渗漏</b>）、Q_c 把油液压扁储存在缸里（<b>可压缩性</b>）。</p>";
      html += "<table class='lab-matrix'><thead><tr><th>支路</th><th>当前流量</th><th>占比</th><th>物理</th></tr></thead><tbody>" +
        "<tr><td>Q_m 有用</td><td>" + state.qm.toFixed(2) + "</td><td>" + (qm * 100).toFixed(0) + "%</td><td>推活塞做功</td></tr>" +
        "<tr><td>Q_l 泄漏</td><td>" + state.leak.toFixed(2) + "</td><td>" + (ql * 100).toFixed(0) + "%</td><td>缸壁间隙漏回储液池，效率损失</td></tr>" +
        "<tr><td>Q_c 压缩</td><td>" + state.comp.toFixed(2) + "</td><td>" + (qc * 100).toFixed(0) + "%</td><td>油液压缩，位置越靠后越难压缩（储能）</td></tr>" +
        "</tbody></table>";
      html += "<p class='lab-note'>这两项（渗漏与可压缩性）是液压与电气最本质的动态差别：电气侧只有电流一个方程，液压侧要拆成渗漏 + 可压缩性两项，" +
        "而且<b>压力反馈层是液压的固有结构、拆不掉</b>（不像电流反馈那样可选）。所以液压建模的路线是「<b>照着电气再做一遍</b>」，只把差别记牢。</p>";
      readout.innerHTML = html;
    }

    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* ================= 实验：ctrl3d · 关节空间 vs 操作空间：同一条直线任务走成两种样（ch07 §7.1.4 / §7.4.3） ================= */

  function labCtrl3D(host) {
    var A2 = 0.62, A3 = 0.52;
    var rows = [
      { alpha: Math.PI / 2, a: 0, d: 0, type: "R" },
      { alpha: 0, a: A2, d: 0, type: "R" },
      { alpha: 0, a: A3, d: 0, type: "R" }
    ];
    var P0 = [0.55, 0, 0.35], P1 = [0.85, 0, 0.25];
    var state = { mode: "joint", t: 0.5, showBoth: true };

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, "同一条笛卡尔直线任务，两种控制方案走出两种轨迹"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "虚线是末端要走的<b>直线</b>（任务定义在操作空间）。**关节空间控制**：每个关节各自插值，末端实际走成一条<b>弧线</b>——离直线有偏差；**操作空间控制**：逐点用逆雅可比反解关节角，末端<b>贴着直线走</b>。拖「任务进度」看两端重合、中段分离。这正是 7.1.4 两套方案的区别在空间上的样子，也是 7.4.3「先翻译，再关节控制」的意义所在。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    toggleGroup(controls, "方案", [{ value: "joint", text: "关节空间控制" }, { value: "task", text: "操作空间控制" }], "joint",
      function (v) { state.mode = v; draw(); });
    slider(controls, "任务进度 t", 0, 1, 0.01, state.t, function (v) { state.t = v; draw(); },
      function (v) { return (v * 100).toFixed(0) + "%"; });

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", "关节空间与操作空间控制的笛卡尔路径跟踪对比");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);

    var view = makeView(canvas, 0.62, { span: 1.45, center: [0.25, 0, 0.3], az: -40, elv: 22 });
    view.onChange = function () { draw(); };

    /* 末端（腕心）位置：由关节角算 */
    function fk(q) {
      var fr = kernel.fkChain(rows, q);
      return { p: fr[3].o, frames: fr };
    }
    /* 逆解：取肩右/肘上支 */
    function ik(p) {
      var sol = kernel.anthroIK(p, A2, A3);
      if (!sol.reachable) return null;
      var pick = sol.solutions.filter(function (s) { return s.shoulder === "right" && s.elbow === "up"; })[0];
      return pick ? [pick.th1, pick.th2, pick.th3] : [sol.solutions[0].th1, sol.solutions[0].th2, sol.solutions[0].th3];
    }

    function draw() {
      var c = palette();
      var qA = ik(P0), qB = ik(P1);
      if (!qA || !qB) { readout.innerHTML = "<p class='lab-warn'>目标点不可达。</p>"; return; }

      /* 关节空间：关节角线性插值 */
      var qj = [0, 1, 2].map(function (i) { return qA[i] + state.t * (qB[i] - qA[i]); });
      var pJoint = fk(qj).p;
      /* 操作空间：沿直线取点，逐点逆解 */
      var pTask = [0, 1, 2].map(function (i) { return P0[i] + state.t * (P1[i] - P0[i]); });
      var qTask = ik(pTask);
      var pTaskActual = qTask ? fk(qTask).p : pTask;

      /* 轨迹：两种方案的完整路径 */
      function pathOf(kind) {
        var pts = [], i2;
        for (i2 = 0; i2 <= 40; i2++) {
          var t = i2 / 40;
          if (kind === "joint") {
            var q = [0, 1, 2].map(function (i) { return qA[i] + t * (qB[i] - qA[i]); });
            pts.push(fk(q).p);
          } else {
            var p = [0, 1, 2].map(function (i) { return P0[i] + t * (P1[i] - P0[i]); });
            var qq = ik(p);
            if (qq) pts.push(fk(qq).p);
          }
        }
        return pts;
      }

      view.grid(0.9, 0.18, 0, { color: c.line });
      /* 理想直线（任务） */
      view.path([P0, P1], { color: c.muted, width: 1.6, dash: [8, 5] });
      view.sphere(P0, 0.028, { color: c.neutral });
      view.sphere(P1, 0.028, { color: c.neutral });
      view.label(P0, "起点", c.neutral, 8, 4);
      view.label(P1, "终点", c.neutral, 8, 4);
      /* 关节空间轨迹（弯曲） */
      view.path(pathOf("joint"), { color: c.blue, width: 2 });
      /* 操作空间轨迹（贴合直线） */
      view.path(pathOf("task"), { color: c.red, width: 2 });
      /* 当前末端 */
      var cur = state.mode === "joint" ? pJoint : pTaskActual;
      var curQ = state.mode === "joint" ? qj : qTask;
      var fr = fk(curQ).frames;
      drawChain(view, fr, { toolLen: 0.12, span: 1.2 });
      view.sphere(cur, 0.032, { color: state.mode === "joint" ? c.blue : c.red });
      /* 偏差：当前末端到直线的距离 */
      var dvec = [P1[0] - P0[0], P1[1] - P0[1], P1[2] - P0[2]];
      var L2 = kernel.dot(dvec, dvec);
      var w = [cur[0] - P0[0], cur[1] - P0[1], cur[2] - P0[2]];
      var s = kernel.dot(w, dvec) / L2;
      var proj = [P0[0] + s * dvec[0], P0[1] + s * dvec[1], P0[2] + s * dvec[2]];
      var dev = kernel.len(kernel.subv(cur, proj));
      view.line(cur, proj, { color: c.purple, width: 1.8, dash: [4, 3] });
      if (dev > 0.004) view.label(proj, "偏差 " + (dev * 1000).toFixed(1) + " mm", c.purple, 8, -6);

      view.render(null);

      /* 两种方案的最大偏差 */
      var maxJoint = 0, maxTask = 0, i3;
      for (i3 = 0; i3 <= 40; i3++) {
        var tt = i3 / 40;
        var qq = [0, 1, 2].map(function (i) { return qA[i] + tt * (qB[i] - qA[i]); });
        var pj = fk(qq).p;
        var pp = [0, 1, 2].map(function (i) { return P0[i] + tt * (P1[i] - P0[i]); });
        var qt = ik(pp);
        var pt = qt ? fk(qt).p : pp;
        maxJoint = Math.max(maxJoint, kernel.len(kernel.subv(pj, pp)));
        maxTask = Math.max(maxTask, kernel.len(kernel.subv(pt, pp)));
      }

      var html = "<p><b>当前方案</b>：" + (state.mode === "joint" ? "关节空间控制（各关节各自插值）" : "操作空间控制（逐点逆雅可比反解）") +
        "；末端到任务直线的偏差 <b>" + (dev * 1000).toFixed(1) + " mm</b>。</p>";
      html += "<table class='lab-matrix'><thead><tr><th>方案</th><th>全程最大偏差</th><th>原因</th></tr></thead><tbody>" +
        "<tr><td>关节空间</td><td>" + (maxJoint * 1000).toFixed(1) + " mm</td><td>各关节运动不成比例，末端在笛卡尔空间走成弧线</td></tr>" +
        "<tr><td>操作空间</td><td>" + (maxTask * 1000).toFixed(1) + " mm</td><td>逐点反解 + 逆雅可比修正，误差只来自离散与奇点附近</td></tr>" +
        "</tbody></table>";
      html += "<p class='lab-note'>这就是 7.1.4 的对照在空间上的样子：**任务提在操作空间，控制动作却落在关节空间**（7.1.4）。" +
        "关节空间控制不需要逆运动学、实时性好，代价是<b>笛卡尔直线任务走不成直线</b>；操作空间控制（7.4.3）先用逆雅可比把笛卡尔增量翻译成关节增量，" +
        "再交给内层的关节控制执行，末端才真正贴着直线走——但它需要逆雅可比，在<b>奇点附近不可用</b>（7.4.3.2 会讲转置雅可比的替代）。</p>";
      readout.innerHTML = html;
    }

    draw();
    window.addEventListener("resize", draw);
    return draw;
  }

  /* ================= 实验：mech3d · 2.9 各类机械手：逐种把 DH 表连乘成一条手臂 =================
     一个通用实验，按宿主容器的 data-mech 取机构定义：每个实例渲染该机构的
     DH 坐标架、关节滑杆与连乘矩阵 T，并把矩阵的列与画布里的几何量联动。 */

  function labMech3D(host) {
    var which = host.getAttribute("data-mech") || "planar3r";
    var HALF_PI = Math.PI / 2;
    var DEFS = {
      planar3r: {
        name: "三连杆平面臂", sec: "2.9.1",
        rows: [
          { alpha: 0, a: 0.45, d: 0, type: "R", label: "ϑ₁" },
          { alpha: 0, a: 0.36, d: 0, type: "R", label: "ϑ₂" },
          { alpha: 0, a: 0.26, d: 0, type: "R", label: "ϑ₃" }
        ],
        note: "有向关节轴同向平行给出 αᵢ=0，各原点选在同一运动平面才给出 dᵢ=0。长度 m，角度滑杆用度；矩阵报告系 3，没有额外工具长度。",
        extra: "z₃⁰=[0 0 1]ᵀ 固定，但平面朝向 φ=θ₁+θ₂+θ₃ 仍会变。工具约定 aₑ=x₃ 时还需右乘正文的常值旋转。",
        tLabel: "T₃⁰（原书式 2.63）", tfn: "planar"
      },
      para: {
        name: "平行四边形臂", sec: "2.9.2",
        custom: "para",
        rows: [
          { alpha: 0, a: 0.45, d: 0, type: "R", label: "ϑ₁′（曲柄）" },
          { alpha: 0, a: 0.5, d: 0, type: "R", label: "ϑ₁″（驱动杆）" }
        ],
        note: "闭链机构：选关节 4 为断开关节后建系，约束方程 ϑ₂′=ϑ₁″−ϑ₁′、ϑ₃′=π−ϑ₂′ 把两条支链绑在一起，**独立变量只剩基座上的两个驱动关节**。",
        extra: "算式里的细节：连杆 1′ 的长度 a₁′ 对末端位置的贡献**恰好相消**——位置只由 a₁″ 与 a₄ 决定。",
        tLabel: "T₄⁰（原书式 2.64）", tfn: "para"
      },
      spherical: {
        name: "球形臂", sec: "2.9.3",
        rows: [
          { alpha: -HALF_PI, a: 0, d: 0, type: "R", label: "ϑ₁" },
          { alpha: HALF_PI, a: 0, d: 0.18, type: "R", label: "ϑ₂" },
          { alpha: 0, a: 0, d: 0, type: "P", label: "d₃" }
        ],
        note: "两转动加一移动。前两对相邻轴相交，末对 z₂、z₃ 同轴，因此 aᵢ=0；仅有平行不足以推出 a=0。",
        extra: "结构性观察：**移动关节 d₃ 不影响旋转块**——伸缩不改变姿态；单位向量 y₃⁰=[−s₁\\ c₁\\ 0]ᵀ 的方向**只由第一关节**决定（第二关节的转轴 z₁ 恰与 y₃ 平行）。",
        tLabel: "T₃⁰（原书式 2.65）", tfn: "spherical"
      },
      stanford: {
        name: "斯坦福机械手", sec: "2.9.6",
        rows: [
          { alpha: -HALF_PI, a: 0, d: 0, type: "R", label: "ϑ₁" },
          { alpha: HALF_PI, a: 0, d: 0.16, type: "R", label: "ϑ₂" },
          { alpha: 0, a: 0, d: 0, type: "P", label: "d₃" },
          { alpha: -HALF_PI, a: 0, d: 0, type: "R", label: "ϑ₄" },
          { alpha: HALF_PI, a: 0, d: 0, type: "R", label: "ϑ₅" },
          { alpha: 0, a: 0, d: 0.13, type: "R", label: "ϑ₆" }
        ],
        note: "球形臂 + 球形腕，**两者的坐标系 3 一致——接口对齐，可以直接连乘**。末端位置比纯球形臂多出一项：沿 a₆⁰ 方向外移 d₆。",
        extra: "把 d₆ 拖到 0，末端位置与单一球形臂**完全相同**——这一点对 2.12.2 的解耦逆解至关重要。",
        tLabel: "T₆⁰（原书式 2.68–2.69）", tfn: "stanford"
      },
      anthroWrist: {
        name: "带球形腕的拟人臂（重建系）", sec: "2.9.7",
        rows: [
          { alpha: HALF_PI, a: 0, d: 0, type: "R", label: "ϑ₁" },
          { alpha: 0, a: 0.55, d: 0, type: "R", label: "ϑ₂" },
          { alpha: HALF_PI, a: 0, d: 0, type: "R", label: "ϑ₃" },
          { alpha: -HALF_PI, a: 0, d: 0.3, type: "R", label: "ϑ₄" },
          { alpha: HALF_PI, a: 0, d: 0, type: "R", label: "ϑ₅" },
          { alpha: 0, a: 0, d: 0.14, type: "R", label: "ϑ₆" }
        ],
        note: "对整臂重建系后，第 3 行 a₃=0、α₃=π/2；第 4 行 d₄=0.30 m、α₄=−π/2。前臂长度改用 d₄ 表示，旧肘角=新肘角−90°。",
        extra: "矩阵报告工具尖端；腕心在 o₄，p_w=p₆−d₆a₆，只转腕角不移动腕心。将工具长度调为零核对两点重合。",
        tLabel: "T₆⁰（位置见原书式 2.70）", tfn: "pos"
      },
      dlr: {
        name: "DLR 机械手", sec: "2.9.8",
        rows: kernel.zooKinds().find(function (kind) { return kind.id === "dlr"; }).rows,
        note: "七个关节均为转动关节，变量为 θ₁…θ₇；d₃、d₅、d₇ 是固定几何尺寸，不是移动关节变量。",
        extra: "七自由度相对一般六维位姿任务具有运动学冗余；在可达且满秩的位形附近，同一末端位姿通常有一族关节解。",
        tLabel: "T₇⁰（连乘结果，原书式 2.72–2.76）", tfn: "num"
      }
    };
    var def = DEFS[which] || DEFS.planar3r;
    var initialAngles = {
      planar3r: [20, 35, -65], para: [15, 100], spherical: [30, 50, 0.30],
      stanford: [20, 45, 0.30, 25, 50, -30], anthroWrist: [20, 35, 40, 25, 40, -30],
      dlr: def.rows.map(function (row) { return row.def; })
    };
    var state = { q: initialAngles[which] ? initialAngles[which].slice() : [20, 35, -65], d6: def.rows.length === 6 ? def.rows[5].d : undefined, hover: null };

    var head = el("div", "lab-head");
    head.appendChild(el("span", "lab-tag", "交互实验 · 3D"));
    head.appendChild(el("b", null, def.name + "：把 DH 表连乘成一条手臂"));
    host.appendChild(head);
    host.appendChild(el("p", "lab-note", "先按正文预测位置，再改变一个变量核对。长度 m，转角用度；绿色短圆柱表示 R，金色表示 P；基座灰色短轴与彩色末端坐标架供对照。矩阵的前三列为末系轴向，末列为红色端点位置，没有另加未计入矩阵的工具杆。用按钮逐列高亮，拖动画布只改变视角。"));

    var controls = el("div", "lab-controls");
    host.appendChild(controls);
    def.rows.forEach(function (row, i) {
      if (row.type === "P") {
        slider(controls, row.label, 0.04, 0.5, 0.005, state.q[i], function (v) { state.q[i] = v; draw(); },
          function (v) { return (v * 1000).toFixed(0) + " mm"; });
      } else {
        slider(controls, row.label, -180, 180, 1, state.q[i], function (v) { state.q[i] = v; draw(); },
          function (v) { return v.toFixed(0) + "°"; });
      }
    });
    if (state.d6 !== undefined) {
      slider(controls, "工具长度 d₆", 0, 0.4, 0.01, state.d6, function (value) { state.d6 = value; draw(); }, function (value) { return value.toFixed(2) + " m"; });
    }

    var canvas = el("canvas", "lab-canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", def.name + "的三维机构与连乘矩阵");
    host.appendChild(canvas);
    var readout = el("div", "lab-readout");
    readout.setAttribute("aria-live", "polite");
    host.appendChild(readout);
    var view = makeView(canvas, 0.62, { span: 1.4, center: [0, 0, 0.25], az: -65, elv: 28 });
    view.cam.zoom = which === "dlr" ? 1.8 : 1.3;
    view.onChange = function () { draw(); };
    mechanismActions(host, controls, state, view, draw, def.rows.map(function (row) { return row.type === "P" ? 0.20 : 0; }));

    function draw() {
      var c = palette();
      var q = state.q.map(function (v, i) {
        return def.rows[i].type === "P" ? v : v * DEG;
      });
      view.grid(0.85, 0.17, 0, { color: c.line });

      var frames = null, T = null, extra = {};
      var activeRows = def.rows.map(function (row, index) {
        return { alpha: row.alpha, a: row.a, d: index === 5 && state.d6 !== undefined ? state.d6 : row.d, type: row.type, label: row.label };
      });
      if (def.custom === "para") {
        /* 平行四边形臂：闭链，按约束方程构造 */
        var t1 = q[0], t1b = q[1];
        var a1 = 0.45, a1b = 0.5, a2 = 0.5, a4 = 0.3;
        var e = function (ang) { return [Math.cos(ang), Math.sin(ang), 0]; };
        var A = kernel.sclv(e(t1), a1);
        var C = kernel.sclv(e(t1b), a1b);
        var B = kernel.addv(A, kernel.sclv(e(t1b), a2));
        var T4 = kernel.addv(C, kernel.sclv(e(t1), -a4));
        view.cyl([0, 0, -0.16], [0, 0, 0], 0.09, { color: c.neutral, seg: 10 });
        view.cyl([-0.05, 0, -0.06], [0.05, 0, 0.06], 0.085, { color: c.green, seg: 10 });
        view.cyl(A, B, 0.032, { color: c.blue });
        view.cyl(C, B, 0.032, { color: c.blue });
        view.cyl([0, 0, 0], A, 0.032, { color: c.blue });
        view.cyl([0, 0, 0], C, 0.032, { color: c.blue });
        view.cyl(C, T4, 0.026, { color: c.gold });
        view.sphere(B, 0.032, { color: c.green });
        view.sphere(T4, 0.03, { color: c.red });
        [["O", [0, 0, 0]], ["A", A], ["B", B], ["C", C]].forEach(function (point) { view.label(point[1], point[0], c.muted, 8, -16); });
        var c1 = Math.cos(t1), s1 = Math.sin(t1), c1b = Math.cos(t1b), s1b = Math.sin(t1b);
        T = {
          R: [[-c1, s1, 0], [-s1, -c1, 0], [0, 0, 1]],
          p: [a1b * c1b - a4 * c1, a1b * s1b - a4 * s1, 0]
        };
        extra = { passive: [t1b - t1, Math.PI - t1b + t1], points: [A, B, C, T4], closure: kernel.len(kernel.subv(kernel.addv(A, C), B)) };
        view.line([0, 0, 0], T.p, { color: c.red, width: 2, dash: [7, 4], hl: "pos" });
      } else {
        frames = kernel.fkChain(activeRows, q);
        drawChain(view, frames, {
          toolLen: 0, triads: false, span: 1.2, jointTypes: activeRows.map(function (row) { return row.type; })
        });
        var last = frames[frames.length - 1];
        view.line([0, 0, 0], last.o, { color: c.red, width: 1.8, dash: [7, 4], hl: "pos" });
        T = last.T;
        if (state.d6 !== undefined) {
          extra.wrist = frames[which === "stanford" ? 3 : 4].o;
          extra.distance = kernel.len(kernel.subv(T.p, extra.wrist));
          view.sphere(extra.wrist, 0.028, { color: c.purple });
          view.label(extra.wrist, "腕心", c.purple, -40, 22);
        }
        extra.frames = frames.map(function (frame) { return kernel.Tmatrix(frame.T); });
      }
      view.triad([0, 0, 0], kernel.Tid().R, 0.18, ["x₀", "y₀", "z₀"], { colors: [c.muted, c.muted, c.muted], width: 1 });
      view.triad(T.p, T.R, 0.24, ["x" + (which === "para" ? "₄" : subText(String(def.rows.length))), "y" + (which === "para" ? "₄" : subText(String(def.rows.length))), "z" + (which === "para" ? "₄" : subText(String(def.rows.length)))], { colors: [c.blue, c.green, c.gold], width: 2.2, hlPrefix: "end-" });
      if (which === "planar3r") view.label(kernel.addv(T.p, kernel.sclv([T.R[0][0], T.R[1][0], T.R[2][0]], 0.25)), "工具接近 aₑ=x₃", c.blue, 8, -12);
      view.render(state.hover);

      /* DH 参数表（悬停联动） */
      var tableRows = which === "para" ? [
        { alpha: 0, a: 0.45, d: 0, theta: q[0], id: "1′", type: "R" },
        { alpha: 0, a: 0.5, d: 0, theta: extra.passive[0], id: "2′", type: "被动" },
        { alpha: 0, a: 0.45, d: 0, theta: extra.passive[1], id: "3′", type: "被动" },
        { alpha: 0, a: 0.5, d: 0, theta: q[1], id: "1″", type: "R" },
        { alpha: 0, a: 0.3, d: 0, theta: 0, id: "4", type: "固定末杆" }
      ] : activeRows.map(function (row, index) {
        return { alpha: row.alpha, a: row.a, d: row.type === "P" ? q[index] : row.d, theta: row.type === "P" ? 0 : q[index], id: index + 1, type: row.type };
      });
      var tbl = "<table class='lab-matrix' data-mechanism-dh><thead><tr><th>i</th><th>类型</th><th>aᵢ (m)</th><th>αᵢ</th><th>dᵢ (m)</th><th>θᵢ</th></tr></thead><tbody>";
      tableRows.forEach(function (row) {
        var alphaTxt = Math.abs(row.alpha - HALF_PI) < 1e-6 ? "π/2" : (Math.abs(row.alpha + HALF_PI) < 1e-6 ? "−π/2" : "0");
        tbl += "<tr><td>" + row.id + "</td><td>" + row.type + "</td><td>" + row.a.toFixed(2) + "</td><td>" + alphaTxt + "</td><td>" + row.d.toFixed(3) + "</td><td>" + (row.theta / DEG).toFixed(1) + "°</td></tr>";
      });
      tbl += "</tbody></table>";

      /* 连乘矩阵 */
      var mat = [];
      for (var r = 0; r < 4; r++) {
        var rowArr = [];
        for (var cc = 0; cc < 4; cc++) {
          var v = (r === 3) ? (cc === 3 ? 1 : 0) : (cc === 3 ? T.p[r] : T.R[r][cc]);
          var key = cc === 3 ? "pos" : "end-" + cc;
          rowArr.push({ v: v, hl: key });
        }
        mat.push(rowArr);
      }
      var html = "<span class='lab-matrix-label'>" + def.tLabel + "（位置 m）=</span>" + matrixHTML(mat, 3).replace("<table", "<table data-mechanism-matrix");
      html += "<p class='lab-note'>" + def.note + "</p>";
      html += "<p class='lab-note'>" + def.extra + "</p>";
      html += tbl;
      html += "<p class='lab-note'>R 的每列是末系一根轴在基座系中的方向；第四列为图中红色端点位置。P 行只有 d 是活动量，R 行只有 θ 是活动量；工具长度是独立演示的固定几何参数。</p>";
      readout.innerHTML = texLite(html).replace(/\*\*([^*]+)\*\*/g, "<b>$1</b>");
      readout.appendChild(el("p", "lab-note", "端点位置 = (" + T.p.map(function (value) { return value.toFixed(3); }).join(", ") + ") m。"));
      if (extra.wrist) readout.appendChild(el("p", "lab-note", "腕心 = (" + extra.wrist.map(function (value) { return value.toFixed(3); }).join(", ") + ") m；尖端到腕心距离 = " + extra.distance.toFixed(3) + " m = d₆。"));
      if (which === "para") readout.appendChild(el("p", "lab-note", "闭合误差 |OA+OC−OB| = " + extra.closure.toExponential(1) + " m。被动角由两驱动角决定，五行表属于带分支的树，不是五行串联。"));
      if (which === "planar3r") readout.appendChild(el("p", "lab-note", "平面朝向 φ = " + state.q.reduce(function (sum, value) { return sum + value; }, 0).toFixed(1) + "°（按模 360° 理解）。"));
      mechanismReadout(host, readout, state, T, extra);
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
    composition3d: labComposition3D,
    euler3d: labEuler3D,
    axisangle3d: labAxisAngle3D,
    quaternion3d: labQuaternion3D,
    homogeneous3d: labHomogeneous3D,
    dh3d: labDH3D,
    anthro3d: labAnthro3D,
    wrist3d: labWrist3D,
    ik3d: labIK3D,
    jac3d: labJac3D,
    sing3d: labSing3D,
    cart3d: labCart3D,
    dyn3d: labDyn3D,
    chassis3d: labChassis3D,
    drive3d: labDrive3D,
    motor3d: labMotor3D,
    sensor3d: labSensor3D,
    hyd3d: labHyd3D,
    ctrl3d: labCtrl3D,
    mech3d: labMech3D
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
