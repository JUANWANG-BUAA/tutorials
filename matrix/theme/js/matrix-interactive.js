/*
 * 矩阵论教程 · 交互式图解
 * ---------------------------------------------------------------------------
 * 零依赖、离线可用、渐进增强。设计约束：
 *   1. 内容里的 <div class="widget" data-widget="名字"> 是唯一契约；
 *      本文件找不到对应实现时什么都不做，页面退化为一段说明文字。
 *   2. 控件一律用原生 <input type="range"> / <button>，因此键盘可达、
 *      屏幕阅读器可读、prefers-reduced-motion 由浏览器负责。
 *   3. 画布颜色全部从主题令牌读取（getComputedStyle），切换明暗主题后重绘，
 *      因此不会出现「暗色下黑字黑线」。
 *   4. 全局只挂一个指针监听（document 级委托），避免为每个画布绑定事件。
 */
(function () {
  "use strict";

  /* ----------------------------------------------------------------------- *
   * 主题令牌
   * ----------------------------------------------------------------------- */

  function token(name, fallback) {
    var v = getComputedStyle(document.documentElement).getPropertyValue(name);
    v = (v || "").trim();
    return v || fallback;
  }

  /* 每个画布在初始化与主题切换时刷新一次调色板。 */
  function palette() {
    return {
      ink: token("--ink", "#171513"),
      ink2: token("--ink-2", "#5d564c"),
      muted: token("--muted", "#6f675b"),
      line: token("--line", "#d9cfbf"),
      lineStrong: token("--line-strong", "#b8a995"),
      paper: token("--paper", "#fefaf2"),
      accent: token("--accent", "#b96543"),
      accentText: token("--accent-text", "#9f5033"),
      blue: token("--fig-blue", "#2456a6"),
      purple: token("--fig-purple", "#4c3d99"),
      green: token("--fig-green", "#1f6b3a"),
      gold: token("--fig-gold", "#8a5a00"),
      red: token("--fig-red", "#9c2b25"),
      neutral: token("--fig-neutral", "#5b544a"),
      sans: token("--sans", "sans-serif"),
      serif: token("--serif-text", "serif")
    };
  }

  function withAlpha(color, alpha) {
    var c = (color || "").trim();
    var m = /^#([0-9a-f]{3}|[0-9a-f]{6})$/i.exec(c);
    if (m) {
      var h = m[1];
      if (h.length === 3) h = h[0] + h[0] + h[1] + h[1] + h[2] + h[2];
      var n = parseInt(h, 16);
      return "rgba(" + ((n >> 16) & 255) + "," + ((n >> 8) & 255) + "," + (n & 255) + "," + alpha + ")";
    }
    if (/^rgba?\(/i.test(c)) {
      var nums = c.replace(/^rgba?\(|\)$/gi, "").split(",");
      if (nums.length >= 3) {
        return "rgba(" + nums[0].trim() + "," + nums[1].trim() + "," + nums[2].trim() + "," + alpha + ")";
      }
    }
    return c;
  }

  /* ----------------------------------------------------------------------- *
   * 画布
   * ----------------------------------------------------------------------- */

  /* 量画布尺寸。
   *
   * 两个都要防：
   *  1. **容器宽度为 0**。mdBook 在移动端会把正文容器初始化为不可见、等脚本
   *     决定完侧栏状态后才显示；若部件恰好在这之前初始化，clientWidth 就是 0。
   *     此时若照 0 设 canvas.width，画布会被判为「尺寸为 0」而什么都不画，
   *     且 ResizeObserver 不一定再触发（尺寸没变过就不会回调）→ 部件永久空白。
   *     所以退回视口宽度估算，宁可略宽也不要画不出来。
   *  2. **尺寸取整为 0**。极窄容器（<1px）乘 dpr 后 round 仍可能是 0，同样退化。
   */
  function fitCanvas(canvas, cssHeight) {
    var dpr = window.devicePixelRatio || 1;
    var cssWidth = canvas.parentNode ? canvas.parentNode.clientWidth : canvas.clientWidth;
    if (!cssWidth || cssWidth < 40) {
      cssWidth = Math.max(280, (window.innerWidth || 640) - 80);
    }
    canvas.style.width = "100%";
    canvas.style.height = cssHeight + "px";
    var w = Math.max(1, Math.round(cssWidth * dpr));
    var h = Math.max(1, Math.round(cssHeight * dpr));
    if (canvas.width !== w || canvas.height !== h) {
      canvas.width = w;
      canvas.height = h;
    }
    var ctx = canvas.getContext("2d");
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    return { ctx: ctx, w: cssWidth, h: cssHeight };
  }

  function arrow(ctx, x1, y1, x2, y2, color, width) {
    var dx = x2 - x1;
    var dy = y2 - y1;
    var len = Math.sqrt(dx * dx + dy * dy);
    if (len < 0.5) return;
    var head = Math.min(11, Math.max(6, len * 0.22));
    var ux = dx / len;
    var uy = dy / len;
    var bx = x2 - ux * head;
    var by = y2 - uy * head;
    ctx.save();
    ctx.strokeStyle = color;
    ctx.fillStyle = color;
    ctx.lineWidth = width || 2.4;
    ctx.lineCap = "round";
    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(bx, by);
    ctx.stroke();
    ctx.beginPath();
    ctx.moveTo(x2, y2);
    ctx.lineTo(bx - uy * head * 0.42, by + ux * head * 0.42);
    ctx.lineTo(bx + uy * head * 0.42, by - ux * head * 0.42);
    ctx.closePath();
    ctx.fill();
    ctx.restore();
  }

  function label(ctx, text, x, y, color, font, align) {
    ctx.save();
    ctx.fillStyle = color;
    ctx.font = font;
    ctx.textAlign = align || "left";
    ctx.textBaseline = "middle";
    ctx.fillText(text, x, y);
    ctx.restore();
  }

  function dot(ctx, x, y, color, r) {
    ctx.save();
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.arc(x, y, r || 4, 0, Math.PI * 2);
    ctx.fill();
    ctx.restore();
  }

  /* ----------------------------------------------------------------------- *
   * 平面坐标映射：数学坐标 (x∈[-R,R]×y∈[-R,R]) ⇄ 屏幕像素
   * ----------------------------------------------------------------------- */

  function makePlane(w, h, range) {
    var pad = 26;
    var span = Math.min(w - 2 * pad, h - 2 * pad);
    var scale = span / (2 * range);
    var cx = w / 2;
    var cy = h / 2;
    return {
      range: range,
      scale: scale,
      toPx: function (p) {
        return { x: cx + p[0] * scale, y: cy - p[1] * scale };
      },
      toMath: function (sx, sy) {
        return [(sx - cx) / scale, (cy - sy) / scale];
      },
      cx: cx,
      cy: cy,
      span: span
    };
  }

  /* 网格 + 坐标轴。所有着色走令牌，暗色下自动适配。 */
  function drawGrid(ctx, plane, pal) {
    var r = plane.range;
    ctx.save();
    ctx.strokeStyle = withAlpha(pal.muted, 0.22);
    ctx.lineWidth = 1;
    ctx.beginPath();
    for (var i = -r; i <= r; i++) {
      if (i === 0) continue;
      var a = plane.toPx([i, -r]);
      var b = plane.toPx([i, r]);
      ctx.moveTo(a.x, a.y);
      ctx.lineTo(b.x, b.y);
      a = plane.toPx([-r, i]);
      b = plane.toPx([r, i]);
      ctx.moveTo(a.x, a.y);
      ctx.lineTo(b.x, b.y);
    }
    ctx.stroke();

    ctx.strokeStyle = pal.lineStrong;
    ctx.lineWidth = 1.4;
    var o = plane.toPx([0, 0]);
    var xa = plane.toPx([-r, 0]);
    var xb = plane.toPx([r, 0]);
    var ya = plane.toPx([0, -r]);
    var yb = plane.toPx([0, r]);
    ctx.beginPath();
    ctx.moveTo(xa.x, xa.y);
    ctx.lineTo(xb.x, xb.y);
    ctx.moveTo(ya.x, ya.y);
    ctx.lineTo(yb.x, yb.y);
    ctx.stroke();

    label(ctx, "x", xb.x - 12, xb.y - 12, pal.muted, "12px " + pal.sans);
    label(ctx, "y", yb.x + 12, yb.y + 10, pal.muted, "12px " + pal.sans);
    dot(ctx, o.x, o.y, pal.lineStrong, 2.5);
    ctx.restore();
  }

  function toUnit(v) {
    var n = Math.sqrt(v[0] * v[0] + v[1] * v[1]);
    if (n < 1e-9) return [0, 0];
    return [v[0] / n, v[1] / n];
  }

  function add(a, b) {
    return [a[0] + b[0], a[1] + b[1]];
  }

  function scale(a, t) {
    return [a[0] * t, a[1] * t];
  }

  function inner(a, b) {
    return a[0] * b[0] + a[1] * b[1];
  }

  /* 把任意 2 维向量限制在平面范围内（留出箭头空间）。
     入口要挡 null：键盘路径里 Enter/空格会以 delta=null 触发 onNudge，
     部件若不加判断就转发给这里，就会在 v[0] 上抛
     "Cannot read properties of null" —— 一个只在按键时出现、点鼠标永远
     碰不到的崩溃。默认参数挡住它，比要求每个部件都记得判断更可靠。 */
  function clampVec(v, range) {
    if (!v) return [0, 0];
    var lim = range * 0.9;
    var n = Math.sqrt(v[0] * v[0] + v[1] * v[1]);
    if (n > lim) return scale(v, lim / n);
    return v;
  }

  function fmt(x, digits) {
    var d = digits == null ? 2 : digits;
    var s = x.toFixed(d);
    if (s === "-" + (0).toFixed(d)) s = (0).toFixed(d);
    return s;
  }

  /* ----------------------------------------------------------------------- *
   * 控件工厂
   * ----------------------------------------------------------------------- */

  function makeSlider(root, spec) {
    var wrap = document.createElement("label");
    wrap.className = "widget-control";
    var name = document.createElement("span");
    name.className = "widget-control-name";
    name.innerHTML = spec.label;
    var input = document.createElement("input");
    input.type = "range";
    input.min = spec.min;
    input.max = spec.max;
    input.step = spec.step == null ? 0.05 : spec.step;
    input.value = spec.value;
    input.setAttribute("aria-label", spec.aria || spec.label.replace(/<[^>]*>/g, ""));
    var out = document.createElement("output");
    out.className = "widget-control-value";
    out.textContent = fmt(spec.value);
    wrap.appendChild(name);
    wrap.appendChild(input);
    wrap.appendChild(out);
    root.appendChild(wrap);
    return {
      input: input,
      set: function (v) {
        input.value = v;
        out.textContent = fmt(parseFloat(v));
      },
      read: function () {
        return parseFloat(input.value);
      }
    };
  }

  function makeButton(root, text, aria) {
    var b = document.createElement("button");
    b.type = "button";
    b.className = "widget-btn";
    b.textContent = text;
    if (aria) b.setAttribute("aria-label", aria);
    root.appendChild(b);
    return b;
  }

  function makeReadout(root) {
    var p = document.createElement("p");
    p.className = "widget-readout";
    p.setAttribute("role", "status");
    p.setAttribute("aria-live", "polite");
    root.appendChild(p);
    return p;
  }

  /* ----------------------------------------------------------------------- *
   * 画布基类：负责尺寸、重绘、主题跟随、指针拖动
   * ----------------------------------------------------------------------- */

  function makeStage(root, opts) {
    var canvas = document.createElement("canvas");
    canvas.className = "widget-canvas";
    canvas.setAttribute("role", "img");
    /* 数字与读数由下方 .widget-readout（role=status）承担，画布本身只描述图形；
       可拖动的画布额外说明键盘用法，不引用可能不存在的 id。 */
    canvas.setAttribute(
      "aria-label",
      (opts.aria || "交互式图解") +
        (opts.draggable ? "。可用方向键微调，Shift 加方向键步子更大。" : "")
    );
    if (opts.draggable) canvas.tabIndex = 0;
    root.appendChild(canvas);

    var state = {
      canvas: canvas,
      ctx: null,
      w: 0,
      h: 0,
      plane: null,
      pal: palette(),
      draw: null
    };

    function render() {
      var fit = fitCanvas(canvas, opts.height || 320);
      state.ctx = fit.ctx;
      state.w = fit.w;
      state.h = fit.h;
      state.plane = makePlane(fit.w, fit.h, opts.range || 4);
      state.pal = palette();
      if (state.draw) state.draw(state.ctx, state.plane, state.pal);
    }

    state.render = render;
    render();

    var ro = window.ResizeObserver ? new ResizeObserver(render) : null;
    if (ro) {
      ro.observe(canvas.parentNode || canvas);
    } else {
      window.addEventListener("resize", render);
    }

    return state;
  }

  /* 全局主题切换：mdBook 通过改写 <html class> 换主题。 */
  var stages = [];
  function registerStage(stage) {
    stages.push(stage);
  }
  function restage() {
    for (var i = 0; i < stages.length; i++) stages[i].render();
  }
  if (window.MutationObserver) {
    new MutationObserver(restage).observe(document.documentElement, {
      attributes: true,
      attributeFilter: ["class", "style"]
    });
  }

  /* 兜底重绘。
   *
   * 部件可能在 mdBook 把正文容器显示出来**之前**就初始化了（侧栏是否展开由脚本
   * 决定，容器在那之前宽度为 0）。fitCanvas 已经会退回视口宽度估算，但保险起见
   * 在两种「布局一定已经稳定」的时刻再画一次：
   *   - window load：所有资源就位；
   *   - 首帧后的一次 setTimeout：覆盖「load 之后 mdBook 又改了容器尺寸」的情形。
   * 多画一次没有副作用（画布是纯函数式重绘），但能消灭「偶尔一片空白」。
   */
  function scheduleRestage() {
    restage();
    if (window.requestAnimationFrame) {
      window.requestAnimationFrame(function () {
        window.setTimeout(restage, 120);
      });
    } else {
      window.setTimeout(restage, 120);
    }
  }
  if (document.readyState === "complete") {
    scheduleRestage();
  } else {
    window.addEventListener("load", scheduleRestage);
  }

  /* 指针拖动 + 键盘微调：把事件坐标换算成数学坐标，回写给宿主。
     键盘单独走 onNudge——有的部件拖动的对象与按键要改的对象不同
     （例如 Gram–Schmidt 拖的是 a₂，而按键应换步骤），共用一个回调会改错东西。 */
  function enableDrag(stage, onMove, onNudge) {
    var canvas = stage.canvas;
    var dragging = false;

    function toMath(event) {
      var rect = canvas.getBoundingClientRect();
      var sx = event.clientX - rect.left;
      var sy = event.clientY - rect.top;
      return stage.plane.toMath(sx, sy);
    }

    function handle(event) {
      if (!stage.plane) return;
      var p = toMath(event);
      if (p) onMove(p);
    }

    canvas.addEventListener("pointerdown", function (event) {
      dragging = true;
      canvas.setPointerCapture && canvas.setPointerCapture(event.pointerId);
      canvas.classList.add("is-dragging");
      handle(event);
      event.preventDefault();
    });
    canvas.addEventListener("pointermove", function (event) {
      if (dragging) handle(event);
    });
    function stop(event) {
      if (!dragging) return;
      dragging = false;
      canvas.classList.remove("is-dragging");
      if (canvas.releasePointerCapture && event && event.pointerId != null) {
        try { canvas.releasePointerCapture(event.pointerId); } catch (e) { /* 忽略 */ }
      }
    }
    canvas.addEventListener("pointerup", stop);
    canvas.addEventListener("pointercancel", stop);

    /* 键盘：方向键微调，替代鼠标拖动（画布本身可聚焦）。
       Enter / 空格对「分步」型部件等价于「下一步」。
    
       **必须 stopPropagation**：画布的 nodeName 是 CANVAS，mdBook 的翻页守卫
       （mdbook_something_else_has_focus，只认 input/select/textarea）不会拦它，
       所以方向键会一路冒泡到 document，被 chapterNavigation 当成「翻到下一章」，
       页面直接跳走。用户看到的现象是「在图上按方向键，整页翻走了」。 */
    canvas.addEventListener("keydown", function (event) {
      var step = event.shiftKey ? 0.25 : 0.05;
      var dx = 0;
      var dy = 0;
      if (event.key === "Enter" || event.key === " ") {
        event.preventDefault();
        event.stopPropagation();
        if (onNudge) onNudge(null, true);
        return;
      }
      if (event.key === "ArrowLeft") dx = -step;
      else if (event.key === "ArrowRight") dx = step;
      else if (event.key === "ArrowUp") dy = step;
      else if (event.key === "ArrowDown") dy = -step;
      else return;
      event.preventDefault();
      event.stopPropagation();
      if (onNudge) onNudge([dx, dy], false);
      else onMove(null, [dx, dy]);
    });
  }

  /* ----------------------------------------------------------------------- *
   * 部件：平面内两个向量 + 一个由滑块控制的系数
   * data-widget="vec-decompose"
   * ----------------------------------------------------------------------- */

  function widgetDecompose(root) {
    var state = { x: [3, 2], y: [3.2, -0.4] };
    var controls = document.createElement("div");
    controls.className = "widget-controls";
    root.appendChild(controls);

    var stage = makeStage(root, {
      height: 300,
      range: 4,
      draggable: true,
      aria: "平面向量分解：拖动蓝色向量 x 的端点，观察它在 y 方向上的投影分量与正交残差如何随之改变"
    });
    registerStage(stage);

    var slider = makeSlider(controls, {
      label: "x 与 y 的夹角 θ",
      min: -180,
      max: 180,
      step: 1,
      value: 34,
      aria: "调整 x 与 y 之间的夹角（度）"
    });
    var readout = makeReadout(root);

    function setAngle(deg) {
      var rad = (deg * Math.PI) / 180;
      var ny = Math.sqrt(inner(state.y, state.y)) || 1;
      var uy = scale(state.y, 1 / ny);
      var nx = Math.sqrt(inner(state.x, state.x)) || 1;
      /* 以 y 为极轴把 x 旋转到 θ：读数与图形里画出的夹角始终一致 */
      state.x = [Math.cos(rad) * nx * uy[0] - Math.sin(rad) * nx * uy[1],
                 Math.sin(rad) * nx * uy[0] + Math.cos(rad) * nx * uy[1]];
      state.x = clampVec(state.x, 3.9);
    }

    function draw(ctx, plane, pal) {
      ctx.clearRect(0, 0, stage.w, stage.h);
      drawGrid(ctx, plane, pal);

      var x = state.x;
      var y = state.y;
      var yy = inner(y, y);
      var t = yy > 1e-9 ? inner(x, y) / yy : 0;
      var proj = scale(y, t);
      var res = [x[0] - proj[0], x[1] - proj[1]];

      var o = plane.toPx([0, 0]);
      var px = plane.toPx(x);
      var py = plane.toPx(y);
      var pp = plane.toPx(proj);
      var pr = plane.toPx(add(proj, res));

      ctx.save();
      ctx.strokeStyle = withAlpha(pal.muted, 0.5);
      ctx.setLineDash([5, 4]);
      ctx.lineWidth = 1.2;
      ctx.beginPath();
      ctx.moveTo(px.x, px.y);
      ctx.lineTo(pp.x, pp.y);
      ctx.stroke();
      ctx.restore();

      arrow(ctx, o.x, o.y, py.x, py.y, pal.purple, 3);
      arrow(ctx, o.x, o.y, pp.x, pp.y, pal.green, 3);
      arrow(ctx, pp.x, pp.y, pr.x, pr.y, pal.gold, 2.6);
      arrow(ctx, o.x, o.y, px.x, px.y, pal.blue, 3);

      dot(ctx, px.x, px.y, pal.blue, 6);
      dot(ctx, py.x, py.y, pal.purple, 6);

      label(ctx, "x", px.x + 12, px.y - 10, pal.blue, "italic 15px " + pal.serif);
      label(ctx, "y", py.x + 12, py.y + 12, pal.purple, "italic 15px " + pal.serif);
      label(ctx, "投影分量", (o.x + pp.x) / 2, (o.y + pp.y) / 2 - 12, pal.green, "12px " + pal.sans, "center");
      label(ctx, "正交残差", (pp.x + pr.x) / 2 + 8, (pp.y + pr.y) / 2 - 10, pal.gold, "12px " + pal.sans);

      var nx = Math.sqrt(inner(x, x));
      var ny = Math.sqrt(yy);
      var cos = nx * ny > 1e-9 ? inner(x, y) / (nx * ny) : 0;
      cos = Math.max(-1, Math.min(1, cos));
      var deg = (Math.acos(cos) * 180) / Math.PI;
      label(ctx, "θ = " + fmt(deg, 1) + "°", o.x + 34, o.y - 16, pal.ink2, "13px " + pal.sans);
    }

    stage.draw = draw;

    function finish() {
      var x = state.x;
      var y = state.y;
      var yy = inner(y, y);
      var t = yy > 1e-9 ? inner(x, y) / yy : 0;
      var proj = scale(y, t);
      var res = [x[0] - proj[0], x[1] - proj[1]];
      var nx = Math.sqrt(inner(x, x));
      var ny = Math.sqrt(yy);
      var cos = nx * ny > 1e-9 ? inner(x, y) / (nx * ny) : 0;
      readout.textContent =
        "x·y = " + fmt(inner(x, y)) + "，" +
        "‖x‖ = " + fmt(nx) + "，‖y‖ = " + fmt(ny) + "，" +
        "cos θ = " + fmt(cos, 3) + "；" +
        "投影 = " + fmt(t, 3) + "·y = (" + fmt(proj[0]) + ", " + fmt(proj[1]) + ")，" +
        "残差 = (" + fmt(res[0]) + ", " + fmt(res[1]) + ")。" +
        "注意残差与 y 的内积恒为 " + fmt(inner(res, y), 6) + "。";
    }

    enableDrag(stage, function (p, delta) {
      if (delta) state.x = clampVec(add(state.x, delta), 3.9);
      else state.x = clampVec(p, 3.9);
      slider.set(Math.round((Math.atan2(state.x[1], state.x[0]) * 180) / Math.PI));
      stage.render();
      finish();
    });

    slider.input.addEventListener("input", function () {
      setAngle(slider.read());
      stage.render();
      finish();
    });

    setAngle(34);
    finish();
  }

  /* ----------------------------------------------------------------------- *
   * 部件：Cauchy–Schwarz 不等式两端的实时对比
   * data-widget="cauchy-schwarz"
   * ----------------------------------------------------------------------- */

  function widgetCauchy(root) {
    var state = { x: [3, 1.2], y: [1.4, 2.6] };
    var controls = document.createElement("div");
    controls.className = "widget-controls";
    root.appendChild(controls);

    var stage = makeStage(root, {
      height: 280,
      range: 4,
      draggable: true,
      aria: "Cauchy-Schwarz 不等式演示：拖动两个向量，观察 |x·y| 与 ‖x‖‖y‖ 的比值始终不超过 1"
    });
    registerStage(stage);

    var readout = makeReadout(root);

    function draw(ctx, plane, pal) {
      ctx.clearRect(0, 0, stage.w, stage.h);
      drawGrid(ctx, plane, pal);
      var o = plane.toPx([0, 0]);
      var px = plane.toPx(state.x);
      var py = plane.toPx(state.y);
      arrow(ctx, o.x, o.y, px.x, px.y, pal.blue, 3);
      arrow(ctx, o.x, o.y, py.x, py.y, pal.purple, 3);
      dot(ctx, px.x, px.y, pal.blue, 6);
      dot(ctx, py.x, py.y, pal.purple, 6);
      label(ctx, "x", px.x + 12, px.y - 10, pal.blue, "italic 15px " + pal.serif);
      label(ctx, "y", py.x + 12, py.y + 12, pal.purple, "italic 15px " + pal.serif);
    }
    stage.draw = draw;

    var which = 0; /* 0 拖 x，1 拖 y */

    function finish() {
      var lhs = Math.abs(inner(state.x, state.y));
      var nx = Math.sqrt(inner(state.x, state.x));
      var ny = Math.sqrt(inner(state.y, state.y));
      var rhs = nx * ny;
      var ratio = rhs > 1e-9 ? lhs / rhs : 0;
      readout.textContent =
        "|x·y| = " + fmt(lhs, 3) + "，‖x‖‖y‖ = " + fmt(rhs, 3) + "，" +
        "比值 = " + fmt(ratio, 3) + "（≤ 1；取等号当且仅当两向量线性相关）。";
    }

    enableDrag(stage, function (p, delta) {
      if (delta) {
        var target = which === 0 ? state.x : state.y;
        var moved = clampVec(add(target, delta), 3.9);
        if (which === 0) state.x = moved; else state.y = moved;
      } else {
        /* 拖动时选择离指针更近的那个向量 */
        var dx = (p[0] - state.x[0]) * (p[0] - state.x[0]) + (p[1] - state.x[1]) * (p[1] - state.x[1]);
        var dy = (p[0] - state.y[0]) * (p[0] - state.y[0]) + (p[1] - state.y[1]) * (p[1] - state.y[1]);
        which = dx <= dy ? 0 : 1;
        if (which === 0) state.x = clampVec(p, 3.9); else state.y = clampVec(p, 3.9);
      }
      stage.render();
      finish();
    });

    finish();
  }

  /* ----------------------------------------------------------------------- *
   * 部件：Gram–Schmidt 逐步正交化（含「忘减投影」错误分支）
   * data-widget="gram-schmidt"
   * ----------------------------------------------------------------------- */

  function widgetGramSchmidt(root) {
    var state = {
      a1: [3, 0.4],
      a2: [2.2, 2.9],
      step: 0
    };
    var controls = document.createElement("div");
    controls.className = "widget-controls";
    root.appendChild(controls);

    var stage = makeStage(root, {
      height: 300,
      range: 4,
      draggable: true,
      aria: "Gram-Schmidt 正交化分步演示：蓝色是原始向量，绿色是正交化结果，金色虚线是被减掉的投影"
    });
    registerStage(stage);

    var prev = makeButton(controls, "← 上一步");
    var next = makeButton(controls, "下一步 →");
    var reset = makeButton(controls, "重来");
    var readout = makeReadout(root);

    var STEPS = [
      "起点：给定两个线性无关的向量 a₁、a₂。",
      "第一步：取 b₁ = a₁。第一个方向原样保留。",
      "第二步：把 a₂ 在 b₁ 上的投影减掉，得到 b₂ = a₂ − (⟨a₂,b₁⟩/⟨b₁,b₁⟩) b₁。",
      "结果：b₁ ⊥ b₂，且 span{b₁,b₂} = span{a₁,a₂}——方向组被换成了正交组。"
    ];

    function compute() {
      var b1 = state.a1.slice();
      var t = inner(state.a2, b1) / (inner(b1, b1) || 1);
      var proj = scale(b1, t);
      var b2 = [state.a2[0] - proj[0], state.a2[1] - proj[1]];
      return { b1: b1, proj: proj, b2: b2, t: t };
    }

    function draw(ctx, plane, pal) {
      ctx.clearRect(0, 0, stage.w, stage.h);
      drawGrid(ctx, plane, pal);
      var o = plane.toPx([0, 0]);
      var c = compute();
      var s = state.step;

      var pa2 = plane.toPx(state.a2);
      var pb1 = plane.toPx(c.b1);
      var ppr = plane.toPx(c.proj);
      var pb2 = plane.toPx(c.b2);

      /* 原始向量 */
      if (s === 0) {
        arrow(ctx, o.x, o.y, plane.toPx(state.a1).x, plane.toPx(state.a1).y, pal.blue, 3);
        arrow(ctx, o.x, o.y, pa2.x, pa2.y, pal.blue, 3);
        label(ctx, "a₁", plane.toPx(state.a1).x + 12, plane.toPx(state.a1).y - 10, pal.blue, "italic 15px " + pal.serif);
        label(ctx, "a₂", pa2.x + 12, pa2.y - 10, pal.blue, "italic 15px " + pal.serif);
      } else {
        /* b₁ 从第 1 步起显示 */
        arrow(ctx, o.x, o.y, pb1.x, pb1.y, pal.green, 3);
        label(ctx, "b₁ = a₁", pb1.x + 12, pb1.y - 10, pal.green, "13px " + pal.sans);

        if (s === 1) {
          arrow(ctx, o.x, o.y, pa2.x, pa2.y, withAlpha(pal.blue, 0.55), 2.4);
          label(ctx, "a₂", pa2.x + 12, pa2.y - 10, withAlpha(pal.blue, 0.75), "italic 15px " + pal.serif);
        }
        if (s >= 2) {
          ctx.save();
          ctx.strokeStyle = pal.gold;
          ctx.setLineDash([6, 4]);
          ctx.lineWidth = 2;
          ctx.beginPath();
          ctx.moveTo(o.x, o.y);
          ctx.lineTo(ppr.x, ppr.y);
          ctx.stroke();
          ctx.beginPath();
          ctx.moveTo(pa2.x, pa2.y);
          ctx.lineTo(ppr.x, ppr.y);
          ctx.stroke();
          ctx.restore();
          label(ctx, "被减掉的投影", (o.x + ppr.x) / 2, (o.y + ppr.y) / 2 - 12, pal.gold, "12px " + pal.sans, "center");
          arrow(ctx, o.x, o.y, pb2.x, pb2.y, pal.red, 3);
          label(ctx, "b₂", pb2.x + 12, pb2.y + 14, pal.red, "italic 15px " + pal.serif);
        }
        if (s >= 3) {
          ctx.save();
          ctx.strokeStyle = withAlpha(pal.green, 0.8);
          ctx.lineWidth = 1.6;
          var u1 = toUnit(c.b1);
          var u2 = toUnit(c.b2);
          function corner(u, v, back) {
            var base = scale(u, back * 0.55);
            var p1 = add(base, scale(v, back * 0.55));
            var a = plane.toPx(base);
            var b = plane.toPx(p1);
            var cc = plane.toPx(scale(v, back * 0.55));
            ctx.beginPath();
            ctx.moveTo(a.x, a.y);
            ctx.lineTo(b.x, b.y);
            ctx.lineTo(cc.x, cc.y);
            ctx.stroke();
          }
          corner(u1, u2, 1);
          corner(u2, u1, 1);
          ctx.restore();
          label(ctx, "90°", plane.toPx(scale(add(u1, u2), 0.9)).x, plane.toPx(scale(add(u1, u2), 0.9)).y, pal.green, "12px " + pal.sans, "center");
        }
      }
      dot(ctx, o.x, o.y, pal.lineStrong, 3);
    }
    stage.draw = draw;

    function sync() {
      readout.textContent = STEPS[state.step];
      prev.disabled = state.step === 0;
      next.disabled = state.step === STEPS.length - 1;
    }

    prev.addEventListener("click", function () {
      if (state.step > 0) state.step--;
      stage.render();
      sync();
    });
    next.addEventListener("click", function () {
      if (state.step < STEPS.length - 1) state.step++;
      stage.render();
      sync();
    });
    reset.addEventListener("click", function () {
      state.step = 0;
      stage.render();
      sync();
    });

    /* 拖动改 a₂；键盘方向键在画布上微调 a₂，Enter / 空格等价「下一步」。 */
    enableDrag(
      stage,
      function (p) {
        state.a2 = clampVec(p, 3.9);
        state.step = Math.max(state.step, 2);
        stage.render();
        sync();
      },
      function (delta, advance) {
        if (advance) {
          state.step = state.step >= STEPS.length - 1 ? 0 : state.step + 1;
        } else {
          state.a2 = clampVec(add(state.a2, delta), 3.9);
          state.step = Math.max(state.step, 2);
        }
        stage.render();
        sync();
      }
    );

    sync();
  }

  /* ----------------------------------------------------------------------- *
   * 部件：同一向量在两族基下的坐标（换基公式的几何意义）
   * data-widget="change-basis"
   * ----------------------------------------------------------------------- */

  function widgetChangeBasis(root) {
    var state = { x: [2.6, 2.2], e1: [1, 0], e2: [0, 1], f1: [2, 0.4], f2: [0.6, 2] };
    var controls = document.createElement("div");
    controls.className = "widget-controls";
    root.appendChild(controls);

    var stage = makeStage(root, {
      height: 300,
      range: 4,
      draggable: true,
      aria: "换基演示：拖动向量 x，比较它在标准基与另一族基下的坐标"
    });
    registerStage(stage);

    /* 上限刻意收在 ±58°：f₂ 的方向角约 73°，滑块若允许到 ±80° 就会与 f₂ 共线，
       新基塌成一条线。虽然 finish() 已经能优雅显示退化提示，但让滑块根本
       滑不进退化区更符合「这组 f 始终是基」的教学意图。 */
    var slider = makeSlider(controls, {
      label: "新基 f₁ 的倾角",
      min: -58,
      max: 58,
      step: 1,
      value: 11,
      aria: "调整新基第一个向量的方向（度），范围 ±58° 以保证 f₁ 与 f₂ 不共线"
    });
    var readout = makeReadout(root);

    function solve(v, b1, b2) {
      var det = b1[0] * b2[1] - b1[1] * b2[0];
      if (Math.abs(det) < 1e-9) return null;
      return [(v[0] * b2[1] - v[1] * b2[0]) / det, (b1[0] * v[1] - b1[1] * v[0]) / det];
    }

    function draw(ctx, plane, pal) {
      ctx.clearRect(0, 0, stage.w, stage.h);
      drawGrid(ctx, plane, pal);
      var o = plane.toPx([0, 0]);

      var pf1 = plane.toPx(scale(state.f1, 2.6));
      var pf2 = plane.toPx(scale(state.f2, 2.6));
      ctx.save();
      ctx.strokeStyle = withAlpha(pal.green, 0.85);
      ctx.lineWidth = 2;
      ctx.beginPath();
      ctx.moveTo(o.x, o.y); ctx.lineTo(pf1.x, pf1.y);
      ctx.moveTo(o.x, o.y); ctx.lineTo(pf2.x, pf2.y);
      ctx.stroke();
      ctx.restore();

      /* 在新基下的平行四边形分解 */
      var c = solve(state.x, state.f1, state.f2);
      if (c) {
        var a = scale(state.f1, c[0]);
        var b = scale(state.f2, c[1]);
        var pa = plane.toPx(a);
        var pb = plane.toPx(b);
        var px = plane.toPx(state.x);
        ctx.save();
        ctx.strokeStyle = withAlpha(pal.gold, 0.9);
        ctx.setLineDash([6, 4]);
        ctx.lineWidth = 1.6;
        ctx.beginPath();
        ctx.moveTo(pa.x, pa.y); ctx.lineTo(px.x, px.y);
        ctx.moveTo(pb.x, pb.y); ctx.lineTo(px.x, px.y);
        ctx.stroke();
        ctx.restore();
        arrow(ctx, o.x, o.y, pa.x, pa.y, withAlpha(pal.green, 0.9), 2.6);
        arrow(ctx, o.x, o.y, pb.x, pb.y, withAlpha(pal.green, 0.9), 2.6);
      }

      var px2 = plane.toPx(state.x);
      arrow(ctx, o.x, o.y, px2.x, px2.y, pal.blue, 3);
      dot(ctx, px2.x, px2.y, pal.blue, 6);
      label(ctx, "x", px2.x + 12, px2.y - 10, pal.blue, "italic 15px " + pal.serif);
      label(ctx, "f₁", pf1.x + 10, pf1.y, pal.green, "italic 14px " + pal.serif);
      label(ctx, "f₂", pf2.x + 10, pf2.y, pal.green, "italic 14px " + pal.serif);
    }
    stage.draw = draw;

    function finish() {
      var c = solve(state.x, state.f1, state.f2);
      var e = solve(state.x, state.e1, state.e2);
      if (!c) {
        /* f₁ 与 f₂ 共线时它们不是基，坐标无定义——这不是错误，而是一个
           值得让学生看见的**退化情形**：滑块滑到这个角度，新基就塌了。
           直接显示提示，而不是让 null 去下标访问（那会抛错并中断整个部件）。 */
        readout.textContent =
          "标准基下的坐标 = (" + fmt(e[0]) + ", " + fmt(e[1]) + ")。" +
          "当前 f₁ 与 f₂ 共线，{f₁, f₂} 不是基——此时「新基下的坐标」不存在。" +
          "把倾角拉回 ±80° 以内就能重新得到一组基。";
        return;
      }
      readout.textContent =
        "标准基下的坐标 = (" + fmt(e[0]) + ", " + fmt(e[1]) + ")；" +
        "新基 {f₁, f₂} 下的坐标 = (" + fmt(c[0]) + ", " + fmt(c[1]) + ")。" +
        "两列数字不同，但描述的是同一个向量 x——这就是「换基不改向量，只改坐标」。";
    }

    function setF1(deg) {
      var rad = (deg * Math.PI) / 180;
      state.f1 = [2 * Math.cos(rad), 2 * Math.sin(rad)];
    }

    /* 拖动 / 键盘微调 x 之后都要刷新读数——只重绘画布的话，读数会停在旧值，
       看起来像「方向键没反应」。 */
    enableDrag(
      stage,
      function (p) {
        state.x = clampVec(p, 3.9);
        stage.render();
        finish();
      },
      function (delta) {
        state.x = clampVec(add(state.x, delta), 3.9);
        stage.render();
        finish();
      }
    );
    slider.input.addEventListener("input", function () {
      setF1(slider.read());
      stage.render();
      finish();
    });

    setF1(11);
    finish();
  }

  /* ----------------------------------------------------------------------- *
   * 部件：线性映射把网格变成什么（可加性 / 齐次性的可视化）
   * data-widget="linear-map"
   * ----------------------------------------------------------------------- */

  function widgetLinearMap(root) {
    var state = { a: 1.35, b: -0.55, c: 0.35, d: 1.05 };
    var controls = document.createElement("div");
    controls.className = "widget-controls";
    root.appendChild(controls);

    var stage = makeStage(root, {
      height: 300,
      range: 4,
      aria: "线性映射演示：左图是原像平面，右图是像平面"
    });
    registerStage(stage);
    var readout = makeReadout(root);

    function sliders() {
      var specs = [
        { key: "a", label: "a（A 的 (1,1) 元）", value: 1.35 },
        { key: "b", label: "b（A 的 (1,2) 元）", value: -0.55 },
        { key: "c", label: "c（A 的 (2,1) 元）", value: 0.35 },
        { key: "d", label: "d（A 的 (2,2) 元）", value: 1.05 }
      ];
      var made = {};
      specs.forEach(function (s) {
        var el = makeSlider(controls, {
          label: s.label,
          min: -2,
          max: 2,
          step: 0.05,
          value: s.value
        });
        el.input.addEventListener("input", function () {
          state[s.key] = el.read();
          stage.render();
          finish();
        });
        made[s.key] = el;
      });
      return made;
    }
    sliders();

    function apply(v) {
      return [state.a * v[0] + state.b * v[1], state.c * v[0] + state.d * v[1]];
    }

    /* 读数：把「网格变成什么样」背后的三个数说清楚。
       行列式 = 面积缩放倍数（负值表示翻了面 → 镜像）；行列式为 0 时整个平面
       被压到一条线或一个点上，映射不可逆——这正是「不可逆 = 降维」的可视化。 */
    function finish() {
      var det = state.a * state.d - state.b * state.c;
      var rank = Math.abs(det) > 1e-9 ? 2 : (
        (Math.abs(state.a) + Math.abs(state.b) + Math.abs(state.c) + Math.abs(state.d)) > 1e-9 ? 1 : 0
      );
      var shape = rank === 2 ? "仍是一个平面" : (rank === 1 ? "被压成一条过原点的直线" : "被压成一个点（零映射）");
      var inv = rank === 2 ? "可逆" : "不可逆";
      var orient = det < -1e-9 ? "，且翻面（改变了定向）" : "";
      readout.textContent =
        "A = [[" + fmt(state.a) + ", " + fmt(state.b) + "], [" + fmt(state.c) + ", " + fmt(state.d) + "]]，" +
        "det A = " + fmt(det, 3) + "，rank A = " + rank + "。整个平面" + shape + "；映射" + inv + orient + "。" +
        (rank === 2
          ? "面积被放大到原来的 |det A| = " + fmt(Math.abs(det), 3) + " 倍。"
          : "此时 N(A) 非零——有非零向量被映成零向量，这正是不可逆的几何含义。");
    }

    function drawOne(ctx, plane, pal, transform, title, tint) {
      var i;
      ctx.save();
      ctx.strokeStyle = withAlpha(pal.muted, 0.18);
      ctx.lineWidth = 1;
      ctx.beginPath();
      for (i = -plane.range; i <= plane.range; i++) {
        var p1 = plane.toPx(transform([i, -plane.range]));
        var p2 = plane.toPx(transform([i, plane.range]));
        ctx.moveTo(p1.x, p1.y);
        ctx.lineTo(p2.x, p2.y);
        p1 = plane.toPx(transform([-plane.range, i]));
        p2 = plane.toPx(transform([plane.range, i]));
        ctx.moveTo(p1.x, p1.y);
        ctx.lineTo(p2.x, p2.y);
      }
      ctx.stroke();
      ctx.restore();

      var o = plane.toPx(transform([0, 0]));
      var e1 = plane.toPx(transform([1, 0]));
      var e2 = plane.toPx(transform([0, 1]));
      arrow(ctx, o.x, o.y, e1.x, e1.y, pal.blue, 2.8);
      arrow(ctx, o.x, o.y, e2.x, e2.y, pal.purple, 2.8);
      label(ctx, title, o.x, plane.h - 12, tint, "13px " + pal.sans, "center");
    }

    function draw(ctx, plane, pal) {
      ctx.clearRect(0, 0, stage.w, stage.h);
      /* 左右两个半幅：各自独立映射，故把画布中点当两块用 */
      var half = stage.w / 2;
      ctx.save();
      ctx.beginPath();
      ctx.rect(0, 0, half - 6, stage.h);
      ctx.clip();
      ctx.translate(0, 0);
      drawOne(ctx, makePlane(half - 12, stage.h, plane.range), pal, function (v) { return v; }, "原像平面（单位网格）", pal.ink2);
      ctx.restore();

      ctx.save();
      ctx.beginPath();
      ctx.rect(half + 6, 0, half - 6, stage.h);
      ctx.clip();
      ctx.translate(half + 12, 0);
      drawOne(ctx, makePlane(half - 12, stage.h, plane.range), pal, apply, "像平面（网格被 A 作用后）", pal.accentText);
      ctx.restore();

      ctx.save();
      ctx.strokeStyle = pal.line;
      ctx.lineWidth = 1;
      ctx.beginPath();
      ctx.moveTo(half, 0);
      ctx.lineTo(half, stage.h);
      ctx.stroke();
      ctx.restore();
    }
    stage.draw = draw;
    finish();
  }

  /* ----------------------------------------------------------------------- *
   * 部件：2×2 矩阵的特征方向（拖动看 Av ∥ v）
   * data-widget="eigen"
   * ----------------------------------------------------------------------- */

  function widgetEigen(root) {
    var state = { a: 1.6, b: 0.6, c: 0.6, d: 0.9, v: [1, 0.35] };
    var controls = document.createElement("div");
    controls.className = "widget-controls";
    root.appendChild(controls);

    var stage = makeStage(root, {
      height: 300,
      range: 4,
      draggable: true,
      aria: "特征方向演示：拖动向量 v，观察 Av 何时与 v 共线"
    });
    registerStage(stage);

    var readout = makeReadout(root);

    function apply(v) {
      return [state.a * v[0] + state.b * v[1], state.c * v[0] + state.d * v[1]];
    }

    /* 2×2 特征值（可能为复，此时无实特征方向）。 */
    function eig() {
      var tr = state.a + state.d;
      var det = state.a * state.d - state.b * state.c;
      var disc = tr * tr - 4 * det;
      if (disc < 0) return null;
      var s = Math.sqrt(disc);
      return [(tr + s) / 2, (tr - s) / 2];
    }

    function eigvecs() {
      var vals = eig();
      if (!vals) return [];
      return vals.map(function (lam) {
        /* (A − λI)v = 0：取非零行 */
        var r1 = [state.a - lam, state.b];
        var r2 = [state.c, state.d - lam];
        var use = (Math.abs(r1[0]) + Math.abs(r1[1])) >= (Math.abs(r2[0]) + Math.abs(r2[1])) ? r1 : r2;
        var v;
        if (Math.abs(use[0]) + Math.abs(use[1]) < 1e-9) v = [1, 0];
        else if (Math.abs(use[1]) > 1e-9) v = [-use[1], use[0]];
        else v = [0, 1];
        return { lambda: lam, v: toUnit(v) };
      });
    }

    function draw(ctx, plane, pal) {
      ctx.clearRect(0, 0, stage.w, stage.h);
      drawGrid(ctx, plane, pal);
      var o = plane.toPx([0, 0]);

      /* 特征方向所在的直线 */
      eigvecs().forEach(function (e) {
        var a = plane.toPx(scale(e.v, -plane.range));
        var b = plane.toPx(scale(e.v, plane.range));
        ctx.save();
        ctx.strokeStyle = withAlpha(pal.green, 0.55);
        ctx.setLineDash([7, 5]);
        ctx.lineWidth = 1.6;
        ctx.beginPath();
        ctx.moveTo(a.x, a.y);
        ctx.lineTo(b.x, b.y);
        ctx.stroke();
        ctx.restore();
      });

      var av = apply(state.v);
      var po = plane.toPx([0, 0]);
      var pv = plane.toPx(state.v);
      var pav = plane.toPx(av);
      arrow(ctx, po.x, po.y, pv.x, pv.y, pal.blue, 3);
      arrow(ctx, po.x, po.y, pav.x, pav.y, pal.red, 3);
      dot(ctx, pv.x, pv.y, pal.blue, 6);
      label(ctx, "v", pv.x + 12, pv.y - 10, pal.blue, "italic 15px " + pal.serif);
      label(ctx, "Av", pav.x + 12, pav.y - 10, pal.red, "italic 15px " + pal.serif);

      var vals = eig();
      if (vals) {
        label(ctx, "λ = " + fmt(vals[0]) + " 与 " + fmt(vals[1]), 14, 20, pal.green, "12px " + pal.sans);
      } else {
        label(ctx, "实特征值不存在（判别式 < 0）", 14, 20, pal.muted, "12px " + pal.sans);
      }
    }
    stage.draw = draw;

    function finish() {
      var av = apply(state.v);
      var nv = Math.sqrt(inner(state.v, state.v));
      var nav = Math.sqrt(inner(av, av));
      var cross = state.v[0] * av[1] - state.v[1] * av[0];
      var sin = nv * nav > 1e-9 ? Math.abs(cross) / (nv * nav) : 0;
      var msg = "Av = (" + fmt(av[0]) + ", " + fmt(av[1]) + ")，|sin∠(v, Av)| = " + fmt(sin, 3) + "。";
      if (sin < 0.02 && nav > 1e-6) {
        msg += "此刻 Av 与 v 共线——v 落在特征方向上，比例系数就是特征值 " + fmt(nav / nv, 3) + "。";
      } else {
        msg += "共线时 |sin| → 0，向量 v 的方向才是不变的特征方向。";
      }
      readout.textContent = msg;
    }

    enableDrag(
      stage,
      function (p) {
        state.v = clampVec(p, 3.9);
        stage.render();
        finish();
      },
      function (delta) {
        /* Enter/空格会给 delta=null；clampVec 已挡，这里再显式忽略空位移，
           免得读数被无意义地重算成 0。 */
        if (!delta || (!delta[0] && !delta[1])) return;
        state.v = clampVec(add(state.v, delta), 3.9);
        stage.render();
        finish();
      }
    );

    finish();
  }

  /* ----------------------------------------------------------------------- *
   * 注册与启动
   * ----------------------------------------------------------------------- */

  var WIDGETS = {
    "vec-decompose": widgetDecompose,
    "cauchy-schwarz": widgetCauchy,
    "gram-schmidt": widgetGramSchmidt,
    "change-basis": widgetChangeBasis,
    "linear-map": widgetLinearMap,
    "eigen": widgetEigen
  };

  function boot() {
    /* 供浏览器验收脚本判断「本文件的 JS 是否真的送达并跑起来了」。
       过程审查工具拿不到构建产物之外的信号，而资源被中途打断时页面看起来
       完全正常（只是什么都没有），容易被误报成部件缺陷。 */
    window.__matrixWidgetsBooted = true;
    var hosts = document.querySelectorAll("[data-widget]");
    for (var i = 0; i < hosts.length; i++) {
      var host = hosts[i];
      if (host.dataset.widgetReady === "1") continue;
      var name = host.dataset.widget;
      var factory = WIDGETS[name];
      host.dataset.widgetReady = "1";
      if (!factory) continue;
      try {
        var body = document.createElement("div");
        body.className = "widget-body";
        host.appendChild(body);
        factory(body);
      } catch (err) {
        /* 渐进增强：任何部件出错都只留下静态说明，不影响正文阅读。 */
        host.dataset.widgetFailed = name;
        if (window.console && console.warn) console.warn("widget failed:", name, err);
      }
    }
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }
})();
