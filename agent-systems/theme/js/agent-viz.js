/*
 * agent-viz.js — 《Agent 系统工程》的循环画布
 * ---------------------------------------------------------------------------
 * 用途：把「观察 → 决策 → 行动 → 更新」画成一个有方向的环，并让一个脉冲沿环
 * 前进，表示一次 step。只在页面存在 #agent-loop-canvas 时启动。
 *
 * 无障碍与省电：
 *   - prefers-reduced-motion: reduce 时**不启动 rAF**，只画一帧静态图；
 *   - 页面隐藏（document.hidden）时暂停，回到可见再恢复；
 *   - 画布尺寸随容器宽度，DPR 上限 2，避免 4K 屏上过度绘制；
 *   - 颜色全部从当前主题的 CSS 变量读取，主题切换时重画。
 */
(function () {
  "use strict";

  var STEPS = [
    { key: "observe", label: "观察", sub: "tool result / env" },
    { key: "decide", label: "决策", sub: "policy / LLM" },
    { key: "act", label: "行动", sub: "tool call" },
    { key: "update", label: "更新", sub: "state / budget" }
  ];

  function token(name, fallback) {
    var v = getComputedStyle(document.documentElement).getPropertyValue(name).trim();
    return v || fallback;
  }

  function setup(canvas) {
    var ctx = canvas.getContext("2d");
    if (!ctx) return null;
    var reduce = window.matchMedia &&
      window.matchMedia("(prefers-reduced-motion: reduce)");
    var state = { t: 0, raf: 0, running: false, w: 0, h: 0, dpr: 1 };

    function resize() {
      var rect = canvas.getBoundingClientRect();
      var dpr = Math.min(window.devicePixelRatio || 1, 2);
      state.w = Math.max(320, Math.round(rect.width));
      state.h = Math.max(180, Math.round(rect.height || state.w * 0.4));
      state.dpr = dpr;
      canvas.width = Math.round(state.w * dpr);
      canvas.height = Math.round(state.h * dpr);
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    }

    function geom() {
      var w = state.w, h = state.h;
      var cx = w / 2, cy = h / 2 + 4;
      var rx = Math.max(110, Math.min(w * 0.31, 230));
      var ry = Math.max(58, Math.min(h * 0.28, 92));
      return { w: w, h: h, cx: cx, cy: cy, rx: rx, ry: ry };
    }

    function draw() {
      var g = geom();
      var accent = token("--accent", "#4c58c8");
      var strong = token("--accent-strong", "#3944a8");
      var ink = token("--ink", "#1d2433");
      var muted = token("--muted", "#68707f");
      var paper = token("--paper", "#ffffff");
      var line = token("--line-strong", "#cfd4dd");
      ctx.clearRect(0, 0, g.w, g.h);

      var pts = STEPS.map(function (s, i) {
        var a = -Math.PI / 2 + (i * Math.PI * 2) / STEPS.length;
        return {
          x: g.cx + Math.cos(a) * g.rx,
          y: g.cy + Math.sin(a) * g.ry,
          s: s
        };
      });

      // 椭圆轨道
      ctx.save();
      ctx.beginPath();
      ctx.ellipse(g.cx, g.cy, g.rx, g.ry, 0, 0, Math.PI * 2);
      ctx.strokeStyle = line;
      ctx.lineWidth = 1;
      ctx.setLineDash([3, 5]);
      ctx.stroke();
      ctx.restore();

      // 方向箭头（每段中点）
      for (var i = 0; i < pts.length; i++) {
        var a = pts[i], b = pts[(i + 1) % pts.length];
        var mx = (a.x + b.x) / 2, my = (a.y + b.y) / 2;
        var ang = Math.atan2(b.y - a.y, b.x - a.x);
        ctx.save();
        ctx.translate(mx, my);
        ctx.rotate(ang);
        ctx.beginPath();
        ctx.moveTo(5, 0);
        ctx.lineTo(-4, 4);
        ctx.lineTo(-4, -4);
        ctx.closePath();
        ctx.fillStyle = muted;
        ctx.globalAlpha = 0.55;
        ctx.fill();
        ctx.restore();
      }

      // 脉冲：沿椭圆环运动
      var p = (state.t % 1);
      var pa = -Math.PI / 2 + p * Math.PI * 2;
      var px = g.cx + Math.cos(pa) * g.rx;
      var py = g.cy + Math.sin(pa) * g.ry;
      var grad = ctx.createRadialGradient(px, py, 0, px, py, 18);
      grad.addColorStop(0, accent);
      grad.addColorStop(1, "rgba(0,0,0,0)");
      ctx.save();
      ctx.globalAlpha = 0.35;
      ctx.fillStyle = grad;
      ctx.beginPath();
      ctx.arc(px, py, 18, 0, Math.PI * 2);
      ctx.fill();
      ctx.restore();
      ctx.beginPath();
      ctx.arc(px, py, 4, 0, Math.PI * 2);
      ctx.fillStyle = accent;
      ctx.fill();

      // 节点
      pts.forEach(function (pt, idx) {
        var active = Math.abs(((p * 4) % 4) - idx) < 0.5;
        var label = pt.s.label, sub = pt.s.sub;
        ctx.save();
        ctx.font = "600 13px " + token("--sans", "system-ui, sans-serif");
        var tw = Math.max(76, ctx.measureText(label).width + 30);
        var bw = tw, bh = 42;
        var x = pt.x - bw / 2, y = pt.y - bh / 2;
        ctx.beginPath();
        ctx.roundRect ? ctx.roundRect(x, y, bw, bh, 3) : ctx.rect(x, y, bw, bh);
        ctx.fillStyle = paper;
        ctx.fill();
        ctx.lineWidth = active ? 2 : 1;
        ctx.strokeStyle = active ? accent : line;
        ctx.stroke();
        ctx.fillStyle = active ? strong : ink;
        ctx.textAlign = "center";
        ctx.textBaseline = "middle";
        ctx.fillText(label, pt.x, pt.y - 6);
        ctx.font = "10px " + token("--mono", "ui-monospace, monospace");
        ctx.fillStyle = muted;
        ctx.fillText(sub, pt.x, pt.y + 11);
        ctx.restore();
      });

      // 中央状态
      ctx.save();
      ctx.textAlign = "center";
      ctx.textBaseline = "middle";
      ctx.font = "700 11px " + token("--mono", "ui-monospace, monospace");
      ctx.fillStyle = muted;
      ctx.fillText("STATE + BUDGET", g.cx, g.cy - 7);
      ctx.font = "600 12px " + token("--sans", "system-ui, sans-serif");
      ctx.fillStyle = strong;
      ctx.fillText(reduce && reduce.matches ? "静态示意（减少动态）" : "一次 step", g.cx, g.cy + 12);
      ctx.restore();
    }

    function loop(ts) {
      if (!state.running) return;
      if (!state.last) state.last = ts;
      var dt = Math.min(64, ts - state.last);
      state.last = ts;
      state.t += dt / 3600;              // 约 3.6 s 一圈
      draw();
      state.raf = requestAnimationFrame(loop);
    }

    function start() {
      if (reduce && reduce.matches) { draw(); return; }
      if (state.running) return;
      state.running = true;
      state.last = 0;
      state.raf = requestAnimationFrame(loop);
    }

    function stop() {
      state.running = false;
      if (state.raf) cancelAnimationFrame(state.raf);
      state.raf = 0;
    }

    resize();
    draw();
    start();

    var ro = null;
    if (window.ResizeObserver) {
      ro = new ResizeObserver(function () { resize(); draw(); });
      ro.observe(canvas);
    } else {
      window.addEventListener("resize", function () { resize(); draw(); });
    }
    document.addEventListener("visibilitychange", function () {
      if (document.hidden) stop();
      else start();
    });
    if (reduce && reduce.addEventListener) {
      reduce.addEventListener("change", function () {
        stop();
        draw();
        start();
      });
    }
    window.addEventListener("dsh:themechange", function () { draw(); });
    return { stop: stop, start: start, draw: draw };
  }

  function boot() {
    var canvas = document.getElementById("agent-loop-canvas");
    if (!canvas) return;
    setup(canvas);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }
})();
