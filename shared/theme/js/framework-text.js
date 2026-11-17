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
   * KaTeX 的 TeX 注释可内嵌，也可由 data: URI 给出；后一种避免 mdBook
   * 把注释作为第二份公式文本加入搜索索引。启动时将 URI 还原为注释文本。
   * 只在**行间公式**上挂一个悬停浮现的按钮（行内符号不抢注意力）；
   * 按钮放在公式所在的 <p> 里做绝对定位，这样宽公式横向滚动时按钮不跟着跑。
   * ------------------------------------------------------------------ */
  function formulaTex(display) {
    var annotation = display.querySelector('annotation[encoding="application/x-tex"]');
    return annotation ? annotation.textContent.trim() : "";
  }

  function restoreFormulaAnnotations() {
    var prefix = "data:application/x-tex,";
    document.querySelectorAll('.katex annotation[encoding="application/x-tex"][src]').forEach(function (annotation) {
      var src = annotation.getAttribute("src");
      if (!src || !src.startsWith(prefix)) return;
      annotation.textContent = decodeURIComponent(src.slice(prefix.length));
      annotation.removeAttribute("src");
    });
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
    restoreFormulaAnnotations();
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
      if (host !== display && host.querySelectorAll(".katex-display").length > 1) host = display;
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
   *   · 默认每页每词一处、每文本节点一条，出现次数 >12 的词不标注；
   *   · glossary options 可调整页内数量、节点数量、频次限制与直接定义链接；
   *   · 跳过公式、代码、链接、标题、已有标注的地方；
   *   · 提示里给「一句话」+（若有）「最容易漏」+ 跳到定义处的链接；
   *   · 无数据 / 无 JS / 打印 → 正文原样，不受影响。
   * ------------------------------------------------------------------ */
  var TERM_MAX_PER_PAGE = 40;
  var TERM_TOO_FREQUENT = 12;
  var TERM_SKIP_SELECTOR = "pre, code, a, svg, math, mjx-container, .MathJax, h1, h2, h3, h4, h5, h6, script, style, .katex, .term, .box-tag, .page-toc, #page-rail, #term-popover, summary, button, input, textarea, select, [contenteditable]:not([contenteditable='false'])";
  var termPopover = null;
  var termHideTimer = 0;
  var activeTerm = null;
  var suppressTermFocus = false;

  function glossaryUrl() {
    var versioned = document.documentElement.getAttribute("data-glossary");
    if (versioned && versioned !== "1") return new URL(versioned, location.href).href;
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

  function isWordChar(ch) { return Boolean(ch) && /[0-9A-Za-z_]/.test(ch); }

  function ensureTermPopover() {
    if (termPopover) return termPopover;
    termPopover = document.createElement("div");
    termPopover.id = "term-popover";
    termPopover.className = "term-popover";
    termPopover.setAttribute("role", "dialog");
    termPopover.setAttribute("aria-label", "术语释义");
    termPopover.hidden = true;
    termPopover.addEventListener("mouseenter", function () { window.clearTimeout(termHideTimer); });
    termPopover.addEventListener("mouseleave", function () {
      if (!termPopover.contains(document.activeElement) && document.activeElement !== activeTerm) hideTermPopover();
    });
    termPopover.addEventListener("focusin", function () { window.clearTimeout(termHideTimer); });
    termPopover.addEventListener("focusout", function (event) {
      if (!termPopover.contains(event.relatedTarget) && event.relatedTarget !== activeTerm) hideTermPopover();
    });
    termPopover.addEventListener("keydown", function (event) {
      if (event.key === "Tab" && event.shiftKey && activeTerm && document.activeElement === termPopover.querySelector("a")) {
        event.preventDefault();
        activeTerm.focus({ preventScroll: true });
      }
    });
    document.body.appendChild(termPopover);
    document.addEventListener("keydown", function (event) {
      if (event.key !== "Escape" || termPopover.hidden) return;
      var trigger = activeTerm;
      var returnFocus = termPopover.contains(document.activeElement);
      hideTermPopover();
      if (returnFocus && trigger) {
        suppressTermFocus = true;
        trigger.focus({ preventScroll: true });
        suppressTermFocus = false;
      }
    });
    document.addEventListener("pointerdown", function (event) {
      if (activeTerm && !activeTerm.contains(event.target) && !termPopover.contains(event.target)) hideTermPopover();
    });
    window.addEventListener("scroll", hideTermPopover, { passive: true });
    window.addEventListener("resize", hideTermPopover, { passive: true });
    if (window.visualViewport) {
      window.visualViewport.addEventListener("resize", hideTermPopover, { passive: true });
      window.visualViewport.addEventListener("scroll", hideTermPopover, { passive: true });
    }
    return termPopover;
  }

  function hideTermPopover() {
    window.clearTimeout(termHideTimer);
    if (termPopover) termPopover.hidden = true;
    if (activeTerm) activeTerm.setAttribute("aria-expanded", "false");
    activeTerm = null;
  }

  function setTermHtml(element, html) {
    element.innerHTML = html;
    element.querySelectorAll("a[href]").forEach(function (link) {
      var href = link.getAttribute("href");
      if (href && !/^(?:[a-z][a-z0-9+.-]*:|\/|#)/i.test(href)) link.href = bookRelativeUrl(href);
    });
  }

  function showTermPopover(span, entry) {
    var popover = ensureTermPopover();
    if (activeTerm === span && !popover.hidden) return;
    if (activeTerm) activeTerm.setAttribute("aria-expanded", "false");
    activeTerm = span;
    span.setAttribute("aria-expanded", "true");
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
    setTermHtml(def, entry.def);                    /* 构建时保留行内标记和书内链接 */
    popover.appendChild(def);

    if (entry.extra) {
      var extra = document.createElement("div");
      extra.className = "term-popover-extra";
      var label = document.createElement("span");
      label.textContent = "最容易漏";
      extra.appendChild(label);
      var text = document.createElement("div");
      setTermHtml(text, entry.extra);
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

    var viewport = window.visualViewport;
    var viewportLeft = viewport ? viewport.offsetLeft : 0;
    var viewportTop = viewport ? viewport.offsetTop : 0;
    var viewportWidth = viewport ? viewport.width : document.documentElement.clientWidth;
    var viewportHeight = viewport ? viewport.height : window.innerHeight;
    popover.style.maxWidth = Math.max(0, viewportWidth - 16) + "px";
    popover.style.maxHeight = Math.max(0, viewportHeight - 16) + "px";
    popover.scrollTop = 0;
    popover.hidden = false;
    var spanBox = span.getBoundingClientRect();
    var width = popover.offsetWidth;
    var height = popover.offsetHeight;
    var left = Math.max(viewportLeft + 8, Math.min(spanBox.left + spanBox.width / 2 - width / 2, viewportLeft + viewportWidth - width - 8));
    var above = spanBox.top - height - 10;
    var top = above >= viewportTop + 8 ? above : Math.max(viewportTop + 8, Math.min(spanBox.bottom + 10, viewportTop + viewportHeight - height - 8));
    popover.style.left = Math.round(left) + "px";
    popover.style.top = Math.round(top) + "px";
  }

  function bindTerm(span, entry, directLink) {
    span.setAttribute("aria-haspopup", "dialog");
    span.setAttribute("aria-controls", "term-popover");
    span.setAttribute("aria-expanded", "false");
    var open = function () { window.clearTimeout(termHideTimer); showTermPopover(span, entry); };
    var close = function () { termHideTimer = window.setTimeout(function () {
      if (activeTerm === span && (!termPopover || !termPopover.contains(document.activeElement)) && document.activeElement !== span) hideTermPopover();
    }, 160); };
    span.addEventListener("mouseenter", open);
    span.addEventListener("mouseleave", close);
    span.addEventListener("focus", function () { if (!suppressTermFocus) open(); });
    span.addEventListener("blur", close);
    if (!directLink) span.addEventListener("click", function (event) { event.preventDefault(); open(); });
    span.addEventListener("keydown", function (event) {
      var enterCard = event.key === "ArrowDown" || (event.key === "Tab" && !event.shiftKey && activeTerm === span);
      var activate = !directLink && (event.key === "Enter" || event.key === " ");
      if (enterCard || activate) {
        if (enterCard && !entry.href) return;
        event.preventDefault(); event.stopPropagation(); open();
        var link = termPopover.querySelector("a");
        if (link) link.focus({ preventScroll: true });
      }
      if (event.key === "Escape") { event.stopPropagation(); hideTermPopover(); }
    });
  }

  function applyTermTips(main, data) {
    var entries = data.terms || [];
    if (!entries.length) return;
    var options = data.options || {};
    var maxPerPage = Number.isInteger(options.maxPerPage) && options.maxPerPage >= 0 ? options.maxPerPage : TERM_MAX_PER_PAGE;
    var maxPerTextNode = Number.isInteger(options.maxPerTextNode) && options.maxPerTextNode >= 0 ? options.maxPerTextNode : 1;
    var frequencyLimit = Number.isInteger(options.frequencyLimit) && options.frequencyLimit >= 0 ? options.frequencyLimit : TERM_TOO_FREQUENT;
    if (!maxPerPage || !maxPerTextNode) return;
    var nodes = collectTermTextNodes(main);
    if (!nodes.length) return;
    var pageText = frequencyLimit ? nodes.map(function (n) { return n.nodeValue; }).join("\u0000") : "";
    // 长名优先；频次不合适的别名不占用该术语的每页名额。
    var index = [];
    entries.forEach(function (entry) {
      (entry.terms || []).forEach(function (name) {
        if (!name) return;
        if (frequencyLimit) {
          var count = 0, from = 0, found;
          while ((found = pageText.indexOf(name, from)) !== -1) {
            count++;
            if (count > frequencyLimit) return;
            from = found + name.length;
          }
        }
        index.push({ name: name, entry: entry });
      });
    });
    index.sort(function (a, b) { return b.name.length - a.name.length; });

    var used = new Set(), placed = 0;
    nodes.forEach(function (node) {
      if (placed >= maxPerPage) return;
      var value = node.nodeValue;
      var matches = [];
      index.forEach(function (item) {
        if (used.has(item.entry.terms[0])) return;
        var from = 0, pos;
        while ((pos = value.indexOf(item.name, from)) !== -1) {
          from = pos + item.name.length;
          if (isWordChar(value.charAt(pos - 1)) || isWordChar(value.charAt(from))) continue;
          matches.push({ pos: pos, item: item });
          if (maxPerTextNode === 1) break; // 默认节点只取每个别名的第一处。
        }
      });
      // 默认保留旧版“节点内最长词优先”；多词模式按正文顺序，同起点取长词。
      if (maxPerTextNode > 1) matches.sort(function (a, b) {
        return a.pos - b.pos || b.item.name.length - a.item.name.length;
      });
      var fragment = document.createDocumentFragment();
      var offset = 0, nodePlaced = 0;
      matches.forEach(function (match) {
        var item = match.item;
        if (nodePlaced >= maxPerTextNode || placed >= maxPerPage || used.has(item.entry.terms[0]) || match.pos < offset) return;
        fragment.appendChild(document.createTextNode(value.slice(offset, match.pos)));
        var directLink = options.directLinks === true && Boolean(item.entry.href);
        var span = document.createElement(directLink ? "a" : "span");
        span.className = "term";
        if (directLink) {
          span.href = bookRelativeUrl(item.entry.href);
          span.setAttribute("aria-label", "术语：" + item.name + "，查看定义；向下键查看释义");
        } else {
          span.tabIndex = 0;
          span.setAttribute("role", "button");
          span.setAttribute("aria-label", "术语：" + item.name + "，回车查看释义");
        }
        span.textContent = item.name;
        fragment.appendChild(span);
        bindTerm(span, item.entry, directLink);
        used.add(item.entry.terms[0]);
        offset = match.pos + item.name.length;
        nodePlaced++;
        placed++;
      });
      if (nodePlaced) {
        fragment.appendChild(document.createTextNode(value.slice(offset)));
        node.parentNode.replaceChild(fragment, node);
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
