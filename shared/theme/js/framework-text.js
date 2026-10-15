/*
 * framework-text — 公式与术语：复制 LaTeX / 术语悬挂提示
 * ---------------------------------------------------------------------------
 * 本文件是 shared/theme/js/framework-*.js 之一：framework.js 原先 1050 行、十项职责
 * 挤在一个 IIFE 里，现按内聚拆为四份（core / nav / media / text），共享工具由 core 通过
 * window.TUTORIALS_CORE 暴露，各模块用 CORE.register(boot) 注册自己的启动钩子。
 * 公式与术语：复制 LaTeX / 术语悬挂提示
 */
(function () {
  "use strict";

  var CORE = window.TUTORIALS_CORE;
  if (!CORE) return;      /* core 必须先加载（book.toml 的 additional-js 顺序保证） */

  /* ------------------------------------------------------------------ *
   * 公式复制 LaTeX
   *
   * KaTeX 现在以 output = htmlAndMathml 渲染，每个公式都带
   * <annotation encoding="application/x-tex">（原始 TeX），抄公式时直接取它。
   * 只在**行间公式**上挂一个悬停浮现的按钮（行内符号不抢注意力）；
   * 按钮放在公式所在的 <p> 里做绝对定位，这样宽公式横向滚动时按钮不跟着跑。
   * ------------------------------------------------------------------ */
  function formulaTex(display) {
    var annotation = display.querySelector('annotation[encoding="application/x-tex"]');
    return annotation ? annotation.textContent.trim() : "";
  }

  /* 行内公式通道：Alt/Option + 点击即复制。
     公式卡片页（如 review/formula-cards）整页都是行内公式，没有行间块，
     不给通道就一个也复制不了；但给每个行内公式挂按钮会把正文挤满，故用显式手势
     + 按住修饰键时的高亮提示（见 framework.css 的 .katex-alt）。 */
  var inlineFormulaWired = false;
  function wireInlineFormulaCopy() {
    if (inlineFormulaWired || !document.querySelector("main .katex annotation")) return;
    inlineFormulaWired = true;
    var altHeld = false;
    document.addEventListener("keydown", function (event) {
      if (event.key !== "Alt") return;
      altHeld = true;
      document.documentElement.classList.add("katex-alt");
    }, true);
    document.addEventListener("keyup", function (event) {
      if (event.key !== "Alt") return;
      altHeld = false;
      document.documentElement.classList.remove("katex-alt");
    }, true);
    window.addEventListener("blur", function () {
      altHeld = false;
      document.documentElement.classList.remove("katex-alt");
    });
    document.addEventListener("click", function (event) {
      if (!event.altKey || !altHeld) return;
      var katex = event.target.closest ? event.target.closest(".katex") : null;
      if (!katex || katex.closest(".katex-display") || katex.closest("a")) return;
      var annotation = katex.querySelector('annotation[encoding="application/x-tex"]');
      if (!annotation || !annotation.textContent.trim()) return;
      event.preventDefault();
      CORE.copyText(annotation.textContent.trim()).then(function () { CORE.toast("已复制 LaTeX"); },
        function () { CORE.toast("复制失败，请手动选中"); });
    }, true);
  }

  function bootFormulaCopy() {
    if (!document.querySelector("main .katex annotation")) return;
    wireInlineFormulaCopy();
    var displays = document.querySelectorAll("main .katex-display");
    if (!displays.length) return;
    displays.forEach(function (display) {
      if (display.dataset.copyReady === "1") return;
      var tex = formulaTex(display);
      if (!tex) return;
      display.dataset.copyReady = "1";
      var host = display.parentElement && display.parentElement.tagName === "P" ? display.parentElement : display;
      if (host === display) display.classList.add("katex-copy-host");
      var button = document.createElement("button");
      button.type = "button";
      button.className = "katex-copy";
      button.textContent = "复制 LaTeX";
      button.setAttribute("aria-label", "复制此公式的 LaTeX 源码");
      button.setAttribute("title", "复制 LaTeX（行内公式可按 Alt/Option 点击）");
      button.addEventListener("click", function () {
        CORE.copyText(tex).then(function () { CORE.toast("已复制 LaTeX"); }, function () { CORE.toast("复制失败，请手动选中"); });
      });
      host.appendChild(button);
    });

  }

  /* ------------------------------------------------------------------ *
   * 术语悬挂提示
   *
   * 数据由 tools/build_glossary.py 从各书已有的索引页（速查背记卡 / 术语索引）
   * 在**构建后**生成 book/glossary.json，本模块只负责取用：
   *   · 每页每个术语只挂第一处（多了就是噪声），且同一文本节点只挂一条；
   *   · 出现次数 >12 次的词说明本页到处在用，不再标注；
   *   · 跳过公式、代码、链接、标题、已有标注的地方；
   *   · 提示里给「一句话」+（若有）「最容易漏」+ 跳到定义处的链接；
   *   · 无数据 / 无 JS / 打印 → 正文原样，不受影响。
   * ------------------------------------------------------------------ */
  var TERM_MAX_PER_PAGE = 40;
  var TERM_TOO_FREQUENT = 12;
  var TERM_SKIP_SELECTOR = "pre, code, a, h1, h2, h3, h4, h5, h6, script, style, .katex, .term, .box-tag, .page-toc, #page-rail, #term-popover, summary, button";
  var termPopover = null;
  var termHideTimer = 0;

  function glossaryUrl() {
    var base = "./";
    try { if (typeof path_to_root === "string") base = path_to_root || "./"; } catch (e) { /* 同上 */ }
    return new URL(base + "glossary.json", location.href).href;
  }

  function bookRelativeUrl(path) {
    var base = "./";
    try { if (typeof path_to_root === "string") base = path_to_root || "./"; } catch (e) { /* 同上 */ }
    return new URL(base + path, location.href).href;
  }

  function collectTermTextNodes(root) {
    var walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, {
      acceptNode: function (node) {
        if (!node.nodeValue || !node.nodeValue.trim()) return NodeFilter.FILTER_REJECT;
        var parent = node.parentElement;
        if (!parent || parent.closest(TERM_SKIP_SELECTOR)) return NodeFilter.FILTER_REJECT;
        return NodeFilter.FILTER_ACCEPT;
      }
    });
    var nodes = [];
    while (walker.nextNode()) nodes.push(walker.currentNode);
    return nodes;
  }

  function isWordChar(ch) { return Boolean(ch) && /[0-9A-Za-z]/.test(ch); }

  function ensureTermPopover() {
    if (termPopover) return termPopover;
    termPopover = document.createElement("div");
    termPopover.id = "term-popover";
    termPopover.className = "term-popover";
    termPopover.setAttribute("role", "tooltip");
    termPopover.hidden = true;
    termPopover.addEventListener("mouseenter", function () { window.clearTimeout(termHideTimer); });
    termPopover.addEventListener("mouseleave", hideTermPopover);
    document.body.appendChild(termPopover);
    document.addEventListener("keydown", function (event) {
      if (event.key === "Escape") hideTermPopover();
    });
    window.addEventListener("scroll", hideTermPopover, { passive: true });
    return termPopover;
  }

  function hideTermPopover() {
    if (termPopover) termPopover.hidden = true;
  }

  function showTermPopover(span, entry) {
    var popover = ensureTermPopover();
    popover.replaceChildren();
    var head = document.createElement("div");
    head.className = "term-popover-head";
    var title = document.createElement("b");
    title.textContent = entry.title || span.textContent;
    head.appendChild(title);
    if (entry.en) {
      var en = document.createElement("span");
      en.className = "term-popover-en";
      en.textContent = entry.en;
      head.appendChild(en);
    }
    popover.appendChild(head);

    var def = document.createElement("div");
    def.className = "term-popover-def";
    def.innerHTML = entry.def;                     /* 已在构建期净化（只保留行内标记）*/
    popover.appendChild(def);

    if (entry.extra) {
      var extra = document.createElement("div");
      extra.className = "term-popover-extra";
      var label = document.createElement("span");
      label.textContent = "最容易漏";
      extra.appendChild(label);
      var text = document.createElement("div");
      text.innerHTML = entry.extra;
      extra.appendChild(text);
      popover.appendChild(extra);
    }

    if (entry.href) {
      var link = document.createElement("a");
      link.className = "term-popover-link";
      link.href = bookRelativeUrl(entry.href);
      link.textContent = "看定义 →";
      popover.appendChild(link);
    }

    popover.hidden = false;
    var spanBox = span.getBoundingClientRect();
    var width = popover.offsetWidth;
    var height = popover.offsetHeight;
    var left = Math.max(12, Math.min(spanBox.left + spanBox.width / 2 - width / 2, window.innerWidth - width - 12));
    var above = spanBox.top - height - 10;
    var top = above > 8 ? above : spanBox.bottom + 10;
    popover.style.left = Math.round(left) + "px";
    popover.style.top = Math.round(top) + "px";
  }

  function bindTerm(span, entry) {
    var open = function () { window.clearTimeout(termHideTimer); showTermPopover(span, entry); };
    var close = function () { termHideTimer = window.setTimeout(hideTermPopover, 160); };
    span.addEventListener("mouseenter", open);
    span.addEventListener("mouseleave", close);
    span.addEventListener("focus", open);
    span.addEventListener("blur", close);
    span.addEventListener("click", function (event) { event.preventDefault(); open(); });
    span.addEventListener("keydown", function (event) {
      if (event.key === "Enter" || event.key === " ") { event.preventDefault(); open(); }
      if (event.key === "Escape") hideTermPopover();
    });
  }

  function applyTermTips(main, data) {
    var entries = data.terms || [];
    if (!entries.length) return;
    var nodes = collectTermTextNodes(main);
    if (!nodes.length) return;
    var pageText = nodes.map(function (n) { return n.nodeValue; }).join("\u0000");
    // 长名优先：先匹配「极大无关组」再匹配「无关组」
    var index = [];
    entries.forEach(function (entry) {
      (entry.terms || []).forEach(function (name) { index.push({ name: name, entry: entry }); });
    });
    index.sort(function (a, b) { return b.name.length - a.name.length; });

    var used = {}, placed = 0;
    nodes.forEach(function (node) {
      if (placed >= TERM_MAX_PER_PAGE) return;
      var value = node.nodeValue;
      for (var i = 0; i < index.length; i++) {
        var item = index[i];
        var key = item.entry.terms[0];
        if (used[key]) continue;
        var pos = value.indexOf(item.name);
        if (pos < 0) continue;
        if (isWordChar(value.charAt(pos - 1)) || isWordChar(value.charAt(pos + item.name.length))) continue;
        used[key] = 1;
        if (pageText.split(item.name).length - 1 > TERM_TOO_FREQUENT) continue;
        var span = document.createElement("span");
        span.className = "term";
        span.tabIndex = 0;
        span.setAttribute("role", "button");
        span.setAttribute("aria-label", "术语：" + item.name + "，回车查看释义");
        span.textContent = item.name;
        var rest = node.splitText(pos);
        rest.nodeValue = rest.nodeValue.slice(item.name.length);
        node.parentNode.insertBefore(span, rest);
        bindTerm(span, item.entry);
        placed++;
        break;                       /* 一个文本节点只挂一条，避免行内堆满 */
      }
    });
  }

  var termTipsStarted = false;
  function bootTermTips() {
    var main = document.querySelector("main");
    if (!main || main.querySelector(".term")) return;
    /* 数据是构建后产物：没有标记说明这次构建没跑 build_glossary.py，
       此时**不要**去请求，否则每页都会多一个 404（术语气泡本来也只是增强）。 */
    if (!document.documentElement.hasAttribute("data-glossary")) return;
    if (termTipsStarted) return;      /* boot() 与 DOMContentLoaded 兜底都会调用，这里只放行一次 */
    termTipsStarted = true;
    var load = function () {
      fetch(glossaryUrl()).then(function (response) {
        return response.ok ? response.json() : null;
      }).then(function (data) {
        if (!data) return;
        /* 术语源页自己（速查背记卡 / 术语索引）不挂提示：那里是密集表格，
           挂上去只会满屏虚线，而且读者本来就在看定义。 */
        if (data.page && location.pathname.endsWith(data.page)) return;
        applyTermTips(main, data);
      }).catch(function () { /* 本地未生成 glossary.json 时不增强 */ });
    };
    /* 等页面空下来再取：它只是阅读辅助，不该与首屏抢带宽 */
    if (window.requestIdleCallback) window.requestIdleCallback(load, { timeout: 2500 });
    else window.setTimeout(load, 400);
  }

  CORE.register(function () {
    try { bootFormulaCopy(); } catch (e) { /* 纯增益 */ }
    try { bootTermTips(); } catch (e) { /* 纯增益 */ }
  });
})();
