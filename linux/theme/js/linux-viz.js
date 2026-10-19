/* linux-viz.js — 轻量 canvas 教学动画（无依赖）
 * 用法：<div class="viz" data-viz="process|pagewalk|tcp|epoll" data-height="260"></div>
 * 渐进增强：没有 JS 时只显示 .viz-fallback 文字；prefers-reduced-motion 时不自动播放。
 */
(function () {
  "use strict";

  var REDUCED = window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  function css(el, name, fallback) {
    var v = getComputedStyle(el).getPropertyValue(name).trim();
    return v || fallback;
  }

  function rr(ctx, x, y, w, h, r) {
    r = Math.min(r || 6, w / 2, h / 2);
    ctx.beginPath();
    ctx.moveTo(x + r, y);
    ctx.arcTo(x + w, y, x + w, y + h, r);
    ctx.arcTo(x + w, y + h, x, y + h, r);
    ctx.arcTo(x, y + h, x, y, r);
    ctx.arcTo(x, y, x + w, y, r);
    ctx.closePath();
  }

  function label(ctx, text, x, y, color, size, align) {
    ctx.fillStyle = color;
    ctx.font = (size || 12) + "px ui-sans-serif, -apple-system, 'PingFang SC', sans-serif";
    ctx.textAlign = align || "center";
    ctx.textBaseline = "middle";
    ctx.fillText(text, x, y);
  }

  function arrow(ctx, x1, y1, x2, y2, color, dashed) {
    ctx.save();
    ctx.strokeStyle = color;
    ctx.fillStyle = color;
    ctx.lineWidth = 1.4;
    if (dashed) ctx.setLineDash([4, 4]);
    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();
    ctx.setLineDash([]);
    var a = Math.atan2(y2 - y1, x2 - x1), s = 7;
    ctx.beginPath();
    ctx.moveTo(x2, y2);
    ctx.lineTo(x2 - s * Math.cos(a - 0.4), y2 - s * Math.sin(a - 0.4));
    ctx.lineTo(x2 - s * Math.cos(a + 0.4), y2 - s * Math.sin(a + 0.4));
    ctx.closePath();
    ctx.fill();
    ctx.restore();
  }

  function dot(ctx, x, y, color) {
    ctx.save();
    ctx.shadowColor = color;
    ctx.shadowBlur = 8;
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.arc(x, y, 4.5, 0, Math.PI * 2);
    ctx.fill();
    ctx.restore();
  }

  function init(host) {
    var type = host.getAttribute("data-viz");
    var W = 720, H = parseInt(host.getAttribute("data-height") || "260", 10);
    var card = document.createElement("div");
    card.className = "viz-card";
    var canvas = document.createElement("canvas");
    canvas.setAttribute("role", "img");
    canvas.setAttribute("aria-label", host.getAttribute("data-label") || "教学示意图");
    var controls = document.createElement("div");
    controls.className = "viz-controls";
    var btnPlay = document.createElement("button");
    btnPlay.type = "button";
    btnPlay.textContent = "播放";
    var btnStep = document.createElement("button");
    btnStep.type = "button";
    btnStep.textContent = "下一步";
    var btnReset = document.createElement("button");
    btnReset.type = "button";
    btnReset.textContent = "重置";
    var status = document.createElement("span");
    status.className = "viz-status";
    controls.append(btnPlay, btnStep, btnReset, status);
    card.append(canvas, controls);
    host.textContent = "";
    host.appendChild(card);

    var ctx = canvas.getContext("2d");
    var step = 0, timer = null;
    var maxStep = type === "pagewalk" ? 3 : type === "tcp" ? 3 : type === "epoll" ? 3 : 6;

    function size() {
      var rect = host.getBoundingClientRect();
      var w = Math.max(280, Math.min(W, Math.floor(rect.width)));
      var dpr = window.devicePixelRatio || 1;
      canvas.style.width = w + "px";
      canvas.style.height = H + "px";
      canvas.width = Math.floor(w * dpr);
      canvas.height = Math.floor(H * dpr);
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
      draw();
    }

    function palette() {
      return {
        fg: css(canvas, "--fg", "#1d232b"),
        muted: css(canvas, "--muted", "#6b7280"),
        line: css(canvas, "--control-line", "#d6dbe1"),
        accent: css(canvas, "--accent", "#2f6feb"),
        gold: css(canvas, "--atlas-gold", "#b8860b"),
        cyan: css(canvas, "--atlas-cyan", "#0e7490"),
        red: css(canvas, "--fig-red", "#b4473f"),
        bg: css(canvas, "--bg", "#ffffff")
      };
    }

    function draw() {
      var c = palette(), w = canvas.clientWidth, h = H;
      ctx.clearRect(0, 0, w, h);
      ctx.fillStyle = c.bg;
      ctx.fillRect(0, 0, w, h);
      if (type === "process") drawProcess(c, w, h);
      else if (type === "pagewalk") drawPagewalk(c, w, h);
      else if (type === "tcp") drawTcp(c, w, h);
      else drawEpoll(c, w, h);
      status.textContent = "步骤 " + (step + 1) + " / " + (maxStep + 1);
      btnStep.disabled = step >= maxStep;
    }

    function box(c, x, y, bw, bh, title, sub, active, color) {
      rr(ctx, x, y, bw, bh, 8);
      ctx.fillStyle = active ? color + "18" : c.bg;
      ctx.fill();
      ctx.strokeStyle = active ? color : c.line;
      ctx.lineWidth = active ? 2 : 1;
      ctx.stroke();
      label(ctx, title, x + bw / 2, y + (sub ? bh / 2 - 8 : bh / 2), c.fg, 12.5);
      if (sub) label(ctx, sub, x + bw / 2, y + bh / 2 + 10, c.muted, 10.5);
    }

    function drawProcess(c, w, h) {
      var xs = [0.08, 0.30, 0.52, 0.74, 0.92].map(function (p) { return p * w; });
      var y = h * 0.34, bw = 86, bh = 58;
      var names = ["新建", "就绪", "运行", "阻塞", "退出"];
      var subs = ["fork", "runqueue", "CPU", "wait", "exit"];
      var colors = [c.muted, c.accent, c.gold, c.red, c.muted];
      var seq = [0, 1, 2, 3, 1, 2, 4];
      var cur = seq[Math.min(step, seq.length - 1)];
      for (var i = 0; i < 5; i++) {
        box(c, xs[i] - bw / 2, y, bw, bh, names[i], subs[i], i === cur, colors[i]);
      }
      arrow(ctx, xs[0] + bw / 2, y + bh / 2, xs[1] - bw / 2, y + bh / 2, c.line);
      arrow(ctx, xs[1] + bw / 2, y + bh / 2, xs[2] - bw / 2, y + bh / 2, c.accent);
      arrow(ctx, xs[2] + bw / 2, y + bh / 2 - 8, xs[3] - bw / 2, y + bh / 2 - 8, c.red);
      arrow(ctx, xs[3] - bw / 2, y + bh / 2 + 16, xs[1] + bw / 2, y + bh / 2 + 16, c.cyan);
      arrow(ctx, xs[2] + bw / 2, y + bh + 8, xs[4] - bw / 2, y + bh + 8, c.muted);
      // 当前 token
      dot(ctx, xs[cur], y - 16, colors[cur]);
      var notes = [
        "fork() 创建 task_struct，状态 TASK_NEW",
        "TASK_RUNNING 且不在 CPU 上：等调度器",
        "正在 CPU 上执行；时间片用完回就绪",
        "等 I/O / 锁 / 信号：TASK_INTERRUPTIBLE 或 UNINTERRUPTIBLE",
        "exit() 后成为僵尸，等父进程 wait"
      ];
      label(ctx, notes[Math.min(step, notes.length - 1)], w / 2, h - 28, c.fg, 12.5);
      label(ctx, "状态迁移由调度器、I/O 完成与信号共同驱动", w / 2, h - 8, c.muted, 10.5);
    }

    function drawPagewalk(c, w, h) {
      var va = "0x00007f2c40001234";
      var idx = ["0x0fe", "0x0b1", "0x000", "0x001"];
      var names = ["PGD", "PUD", "PMD", "PTE"];
      var off = "0x234";
      var boxW = 118, boxH = 54, gap = (w - 40 - boxW * 4) / 3;
      var y = h * 0.30;
      for (var i = 0; i < 4; i++) {
        var x = 20 + i * (boxW + gap);
        box(c, x, y, boxW, boxH, names[i], "[" + (47 - i * 9) + ":" + (39 - i * 9) + "] = " + idx[i], i <= step, i === step ? c.accent : c.cyan);
        if (i < 3) arrow(ctx, x + boxW, y + boxH / 2, x + boxW + gap, y + boxH / 2, c.line);
      }
      // 地址位条
      var bits = ["47:39", "38:30", "29:21", "20:12", "11:0"];
      var values = [idx[0], idx[1], idx[2], idx[3], off];
      var bw = (w - 40) / 5;
      for (var j = 0; j < 5; j++) {
        var bx = 20 + j * bw;
        rr(ctx, bx + 2, h - 78, bw - 4, 34, 5);
        ctx.fillStyle = j <= step ? c.accent + "14" : c.bg;
        ctx.fill();
        ctx.strokeStyle = j <= step ? c.accent : c.line;
        ctx.lineWidth = 1;
        ctx.stroke();
        label(ctx, bits[j], bx + bw / 2, h - 68, c.muted, 10);
        label(ctx, values[j], bx + bw / 2, h - 52, c.fg, 11);
      }
      label(ctx, "VA " + va + "  →  " + (step >= 3 ? "PA 0x80000234" : "逐级查表…"), w / 2, 22, c.muted, 11);
    }

    function drawTcp(c, w, h) {
      var lx = w * 0.22, rx = w * 0.78, top = 42, bottom = h - 34;
      label(ctx, "客户端", lx, top, c.fg, 13);
      label(ctx, "服务端", rx, top, c.fg, 13);
      ctx.strokeStyle = c.line; ctx.lineWidth = 1;
      ctx.beginPath(); ctx.moveTo(lx, top + 12); ctx.lineTo(lx, bottom); ctx.stroke();
      ctx.beginPath(); ctx.moveTo(rx, top + 12); ctx.lineTo(rx, bottom); ctx.stroke();
      var rows = [
        ["SYN  seq=x", lx, rx, c.accent],
        ["SYN+ACK  seq=y ack=x+1", rx, lx, c.cyan],
        ["ACK  ack=y+1", lx, rx, c.accent],
        ["数据 + ACK（全双工）", lx, rx, c.gold]
      ];
      for (var i = 0; i < rows.length; i++) {
        var yy = top + 44 + i * 42;
        var active = i <= step;
        arrow(ctx, rows[i][1], yy, rows[i][2], yy, active ? rows[i][3] : c.line, !active);
        label(ctx, (i + 1) + ". " + rows[i][0], w / 2, yy - 10, active ? c.fg : c.muted, 11);
        if (i === step) dot(ctx, (lx + rx) / 2, yy, rows[i][3]);
      }
      var notes = [
        "客户端选初始序号 x，进入 SYN_SENT",
        "服务端回 SYN+ACK，分配半连接 request_sock，进入 SYN_RECV",
        "客户端 ACK，双方进入 ESTABLISHED；服务端连接进 accept 队列",
        "握手完成后才是字节流；数据段也携带 ACK"
      ];
      label(ctx, notes[Math.min(step, notes.length - 1)], w / 2, h - 14, c.muted, 11);
    }

    function drawEpoll(c, w, h) {
      var fds = ["fd 3  socket", "fd 4  socket", "fd 5  eventfd"];
      var ready = [false, false, false];
      for (var i = 0; i <= step && i < 3; i++) ready[i] = true;
      var x = 18, y = 36, bw = 150, bh = 42, gap = 16;
      label(ctx, "注册的兴趣集合", x + bw / 2, 18, c.muted, 11);
      for (var j = 0; j < 3; j++) {
        var yy = y + j * (bh + gap);
        box(c, x, yy, bw, bh, fds[j], ready[j] ? "就绪" : "未就绪", ready[j], ready[j] ? c.accent : c.cyan);
        if (ready[j]) arrow(ctx, x + bw, yy + bh / 2, w * 0.48, yy + bh / 2, c.accent, false);
      }
      var cx = w * 0.48, cy = h * 0.40;
      rr(ctx, cx, cy, 168, 86, 10);
      ctx.fillStyle = c.accent + "12"; ctx.fill();
      ctx.strokeStyle = c.accent; ctx.lineWidth = 1.6; ctx.stroke();
      label(ctx, "epoll 实例", cx + 84, cy + 24, c.fg, 13);
      label(ctx, "rbr 红黑树 + rdllist 就绪链表", cx + 84, cy + 48, c.muted, 10.5);
      label(ctx, "epoll_wait() 只取就绪链表", cx + 84, cy + 66, c.muted, 10.5);
      var ax = w - 178, ay = h * 0.26;
      box(c, ax, ay, 156, 92, "应用", "epoll_wait 返回 n 个 fd", step >= 1, c.gold);
      if (step >= 1) arrow(ctx, cx + 168, cy + 44, ax, ay + 46, c.gold, false);
      label(ctx, "O(就绪 fd 数)，不是 O(注册 fd 数)", w / 2, h - 18, c.muted, 11);
    }

    function stop() {
      if (timer) { clearInterval(timer); timer = null; }
      btnPlay.textContent = "播放";
    }
    function play() {
      if (timer) { stop(); return; }
      if (step >= maxStep) step = 0;
      btnPlay.textContent = "暂停";
      timer = setInterval(function () {
        step++;
        if (step >= maxStep) { step = maxStep; stop(); }
        draw();
      }, 1100);
    }

    btnPlay.addEventListener("click", play);
    btnStep.addEventListener("click", function () { stop(); if (step < maxStep) step++; draw(); });
    btnReset.addEventListener("click", function () { stop(); step = 0; draw(); });

    if ("ResizeObserver" in window) new ResizeObserver(size).observe(host);
    else window.addEventListener("resize", size);
    size();
    if (!REDUCED && "IntersectionObserver" in window) {
      var seen = false;
      new IntersectionObserver(function (entries) {
        entries.forEach(function (e) {
          if (e.isIntersecting && !seen) { seen = true; setTimeout(play, 350); }
          else if (!e.isIntersecting) stop();
        });
      }, { threshold: 0.35 }).observe(host);
    }
  }

  function boot() {
    document.querySelectorAll(".viz[data-viz]").forEach(function (host) {
      if (!host.dataset.vizReady) { host.dataset.vizReady = "1"; init(host); }
    });
  }
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", boot);
  else boot();
})();
