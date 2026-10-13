/* 矩阵论教程主题：可降级的阅读与导航增强。 */
(function () {
  "use strict";

  var root = document.documentElement;
  var framePending = false;
  var printSolutionState = null;
  var pageNavigationLocked = false;

  root.setAttribute("data-theme-style", "ink");
  root.setAttribute("data-density", "standard");

  function getStoredValue(key) {
    try { return localStorage.getItem(key); } catch (error) { return null; }
  }

  function setStoredValue(key, value) {
    try { localStorage.setItem(key, value); } catch (error) { /* Storage may be disabled. */ }
  }

  var progressBar = document.createElement("div");
  progressBar.id = "progress";
  progressBar.setAttribute("aria-hidden", "true");
  document.body.appendChild(progressBar);

  function updateProgress() {
    var maximum = root.scrollHeight - root.clientHeight;
    progressBar.style.width = (maximum > 0 ? root.scrollTop / maximum * 100 : 0) + "%";
    framePending = false;
  }

  function scheduleProgressUpdate() {
    if (framePending) return;
    framePending = true;
    requestAnimationFrame(updateProgress);
  }

  window.addEventListener("scroll", scheduleProgressUpdate, { passive: true });
  window.addEventListener("resize", scheduleProgressUpdate, { passive: true });

  function buildPageToc() {
    var main = document.querySelector("main");
    if (!main || main.querySelector(":scope > .page-toc")) return;

    var headings = Array.prototype.filter.call(main.querySelectorAll("h2"), function (heading) {
      return !heading.closest("details, .box") && heading.querySelector("a.header");
    });
    if (headings.length < 3) return;

    var nav = document.createElement("nav");
    var title = document.createElement("span");
    nav.className = "page-toc";
    nav.setAttribute("aria-label", "本页内容");
    title.className = "page-toc-title";
    title.textContent = "本页内容";
    nav.appendChild(title);

    headings.forEach(function (heading) {
      var anchor = heading.querySelector("a.header");
      var link = document.createElement("a");
      link.href = anchor.getAttribute("href");
      link.textContent = heading.textContent.trim();
      nav.appendChild(link);
    });

    var first = main.firstElementChild;
    if (first && first.tagName === "H1") first.insertAdjacentElement("afterend", nav);
    else main.insertBefore(nav, first);
  }

  var CORE_ONLY_KEY = "na-core-only";

  /* 阅读分层：正文里的盒子分 core / main / skip 三层（类名由 mathbook 生成）。
     「只看核心」把 skip 层（证明、课程预告、拓展思考）折叠，留下一张
     定义 + 定理 + 速查表 + 错误清单的复习骨架。状态记在 localStorage。 */
  function buildLayerToggle() {
    var coreOnly = root.classList.contains("core-only");
    // 只有真正分了层的页面才出现：404、目录这类没有语义盒子的页面不显示
    if (!document.querySelector(".box, .proof, .note, .preview, details.sol-box")) return;
    // 本页没有可跳层、也没开着「只看核心」时不必出现
    if (!document.querySelector(".p-skip") && !coreOnly) return;
    var main = document.querySelector("main");
    if (!main || main.querySelector(".layer-legend")) return;

    var box = document.createElement("div");
    box.className = "layer-legend";
    box.innerHTML =
      '<div class="layer-legend-head"><span class="layer-legend-title">阅读分层</span></div>' +
      '<ul>' +
      '<li><span class="swatch core"></span><b>必记骨架</b><span class="desc">定义、定理、速查表、错误清单</span></li>' +
      '<li><span class="swatch"></span><b>主体</b><span class="desc">例题、方法、直觉</span></li>' +
      '<li><span class="swatch skip"></span><b>第一遍可跳</b><span class="desc">证明、课程预告、拓展思考</span></li>' +
      '</ul>';

    var button = document.createElement("button");
    button.type = "button";
    // 初始状态必须与 boot() 从 localStorage 恢复的状态一致，
    // 否则页面已经折叠、按钮却显示「只看核心」，点一下反而把它打开。
    button.setAttribute("aria-pressed", coreOnly ? "true" : "false");
    button.textContent = coreOnly ? "显示全部" : "只看核心";
    button.addEventListener("click", function () {
      var on = root.classList.toggle("core-only");
      button.setAttribute("aria-pressed", on ? "true" : "false");
      button.textContent = on ? "显示全部" : "只看核心";
      setStoredValue(CORE_ONLY_KEY, on ? "1" : "0");
    });
    box.querySelector(".layer-legend-head").appendChild(button);

    var anchor = main.querySelector(":scope > .page-toc");
    if (!anchor) {
      // 首页没有 H1，首个子元素是 .chapter-cover；若直接插在它前面，
      // 图例就会浮在封面之上。挂到封面之后。
      var first = main.firstElementChild;
      if (first && (first.tagName === "H1" || first.classList.contains("chapter-cover"))) anchor = first;
    }
    if (anchor) anchor.insertAdjacentElement("afterend", box);
    else main.insertBefore(box, main.firstElementChild);
  }

  function buildSolutionToolbar() {
    var solutions = document.querySelectorAll("details.sol-box");
    if (!solutions.length || document.querySelector(".sol-toolbar")) return;

    var toolbar = document.createElement("div");
    var button = document.createElement("button");
    var solutionSyncPending = false;
    toolbar.className = "sol-toolbar";
    button.type = "button";
    button.textContent = "展开全部解答";
    button.setAttribute("aria-pressed", "false");

    function syncButton() {
      var allOpen = Array.prototype.every.call(solutions, function (details) { return details.open; });
      button.textContent = allOpen ? "折叠全部解答" : "展开全部解答";
      button.setAttribute("aria-pressed", allOpen ? "true" : "false");
      solutionSyncPending = false;
    }

    function scheduleButtonSync() {
      if (solutionSyncPending) return;
      solutionSyncPending = true;
      requestAnimationFrame(syncButton);
    }

    button.addEventListener("click", function () {
      var shouldOpen = Array.prototype.some.call(solutions, function (details) { return !details.open; });
      solutions.forEach(function (details) { details.open = shouldOpen; });
      syncButton();
    });

    solutions.forEach(function (details) { details.addEventListener("toggle", scheduleButtonSync); });
    toolbar.appendChild(button);
    solutions[0].parentNode.insertBefore(toolbar, solutions[0]);
  }

  window.addEventListener("beforeprint", function () {
    printSolutionState = Array.prototype.map.call(document.querySelectorAll("details.sol-box"), function (details) {
      return details.open;
    });
    document.querySelectorAll("details.sol-box").forEach(function (details) { details.open = true; });
  });

  window.addEventListener("afterprint", function () {
    if (!printSolutionState) return;
    document.querySelectorAll("details.sol-box").forEach(function (details, index) {
      details.open = Boolean(printSolutionState[index]);
    });
    printSolutionState = null;
  });

  window.addEventListener("keydown", function (event) {
    if (event.key !== "ArrowLeft" && event.key !== "ArrowRight") return;
    var target = event.target;
    var activeElement = document.activeElement;
    var interactiveSelector = "input, textarea, select, button, summary, [contenteditable='true'], [role='textbox']";
    var targetIsInteractive = Boolean(target && target.closest && target.closest(interactiveSelector));
    var focusIsInteractive = Boolean(activeElement && activeElement.closest && activeElement.closest(interactiveSelector));
    if (!targetIsInteractive && !focusIsInteractive && !pageNavigationLocked) return;
    event.preventDefault();
    event.stopImmediatePropagation();
  }, true);

  var sidebarBox = document.querySelector("mdbook-sidebar-scrollbox");

  function makeChevron() {
    var svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    var path = document.createElementNS("http://www.w3.org/2000/svg", "path");
    svg.setAttribute("viewBox", "0 0 12 12");
    svg.setAttribute("aria-hidden", "true");
    path.setAttribute("d", "M4 2.5 7.5 6 4 9.5");
    svg.appendChild(path);
    return svg;
  }

  /* 编号与标题分成两列（样式见 na.css §6.5）：
     中文标题在 300px 栏内常折行，若与编号同处一个行内流，第二行会顶回最左，
     出现「…第三种研究方 / 法」这种孤立字。toc.js 要到 DOMContentLoaded 才插入
     「本页大纲」，所以这个函数会跑两次（幂等）。 */
  function decorateSidebarLabels() {
    if (!sidebarBox) return;
    sidebarBox.querySelectorAll(".chapter-link-wrapper > a").forEach(function (link) {
      if (link.classList.contains("active")) link.setAttribute("aria-current", "page");
      if (link.querySelector(".sec-no, .sec-label")) return;
      var match = link.textContent.trim().match(/^(\d+(?:\.\d+)*)\s+(.+)$/);
      if (!match) return;
      var number = document.createElement("strong");
      var label = document.createElement("span");
      number.className = "sec-no";
      number.setAttribute("aria-hidden", "true");
      number.textContent = match[1];
      label.className = "sec-label";
      label.textContent = match[2];
      link.replaceChildren(number, label);
    });
  }

  /* 「本页大纲」是 mdBook 0.5 的行为：把当前页的 h2/h3 树插到活动条目下方。
     它默认与页面导航同字号同色，读者分不清点击是换页还是页内跳转；折叠钮
     也用的是 mdBook 的 ❱ 字符，与页面导航注入的 SVG 箭头不一致。这里补一个
     标题、把 ❱ 换成同一枚箭头（展开旋转沿用页面导航的规则）。 */
  function decorateSidebarOutline() {
    if (!sidebarBox) return;
    sidebarBox.querySelectorAll(".on-this-page").forEach(function (block) {
      if (!block.querySelector(".otp-label")) {
        var label = document.createElement("div");
        label.className = "otp-label";
        label.textContent = "本页大纲";
        block.insertBefore(label, block.firstChild);
      }
      block.querySelectorAll(".header-toggle").forEach(function (toggle) {
        if (!toggle.querySelector("svg")) toggle.replaceChildren(makeChevron());
      });
    });
    decorateSidebarLabels();
  }

  /* 阅读时跟随当前小节：大纲比侧栏视口长时，当前小节会滚出视野，大纲就失去
     「我在哪」的作用。只在当前小节完全离开视野时补滚，并在读者手动滚动侧栏
     后暂停 2.5 秒，避免和读者抢滚动条。 */
  var manualSidebarScrollAt = 0;
  var followPending = false;

  function followCurrentHeader() {
    if (followPending || !sidebarBox) return;
    followPending = true;
    requestAnimationFrame(function () {
      followPending = false;
      if (Date.now() - manualSidebarScrollAt < 2500) return;
      var current = sidebarBox.querySelector("a.current-header");
      if (!current) return;
      var viewport = sidebarBox.getBoundingClientRect();
      var bounds = current.getBoundingClientRect();
      var margin = 28;
      if (bounds.top < viewport.top + margin) sidebarBox.scrollTop -= viewport.top + margin - bounds.top;
      else if (bounds.bottom > viewport.bottom - margin) sidebarBox.scrollTop += bounds.bottom - viewport.bottom + margin;
    });
  }

  function enhanceSidebar() {
    if (!sidebarBox || sidebarBox.dataset.enhanced) return;

    sidebarBox.querySelectorAll("li.chapter-item").forEach(function (item, index) {
      var wrapper = item.querySelector(":scope > .chapter-link-wrapper");
      var section = item.querySelector(":scope > ol.section");
      if (!wrapper || !section || wrapper.querySelector(".chapter-fold-toggle")) return;

      var toggle = document.createElement("button");
      var groupLink = wrapper.querySelector(":scope > a[href]");
      var groupIdentity = groupLink ? new URL(groupLink.getAttribute("href"), location.href).pathname : "group-" + index;
      var storageKey = "matrix-sidebar-group:" + groupIdentity;
      var sectionId = "matrix-sidebar-section-" + index;
      var savedState = getStoredValue(storageKey);
      if (savedState === "open") item.classList.add("expanded");
      if (savedState === "closed" && !item.querySelector("a.active")) item.classList.remove("expanded");

      section.id = section.id || sectionId;
      toggle.type = "button";
      toggle.className = "chapter-fold-toggle";
      toggle.setAttribute("aria-label", "展开或折叠本章小节");
      toggle.setAttribute("aria-expanded", item.classList.contains("expanded"));
      toggle.setAttribute("aria-controls", section.id);
      toggle.dataset.storageKey = storageKey;
      toggle.appendChild(makeChevron());
      wrapper.appendChild(toggle);
    });

    decorateSidebarLabels();

    var activeLink = sidebarBox.querySelector("a.active");
    sidebarBox.dataset.enhanced = "1";

    if (activeLink) {
      var viewport = sidebarBox.getBoundingClientRect();
      var activeBounds = activeLink.getBoundingClientRect();
      if (activeBounds.top < viewport.top + 10) sidebarBox.scrollTop -= viewport.top + 10 - activeBounds.top;
      else if (activeBounds.bottom > viewport.bottom - 10) sidebarBox.scrollTop += activeBounds.bottom - viewport.bottom + 10;
    }
  }

  if (sidebarBox) {
    sidebarBox.addEventListener("click", function (event) {
      var toggle = event.target.closest(".chapter-fold-toggle");
      if (!toggle || !sidebarBox.contains(toggle)) return;
      var item = toggle.closest("li.chapter-item");
      if (!item) return;
      var isOpen = item.classList.toggle("expanded");
      toggle.setAttribute("aria-expanded", isOpen ? "true" : "false");
      setStoredValue(toggle.dataset.storageKey, isOpen ? "open" : "closed");
    });
  }

  document.addEventListener("pointerup", function (event) {
    pageNavigationLocked = Boolean(
      event.target && event.target.closest &&
      event.target.closest("button, summary, input, textarea, select, [contenteditable='true'], [role='textbox']")
    );
  }, { passive: true });

  /* ======================================================================== *
   * 界面文案汉化
   *   mdBook 的框架文案（菜单栏提示、搜索框占位符、搜索结果统计、主题名）都写
   *   死在模板与 searcher.js 里，没有配置项，只能运行时改写。正文一个字不改。
   * ======================================================================== */

  var CHROME_LABELS = [
    ["#mdbook-sidebar-toggle", "切换目录"],
    ["#mdbook-theme-toggle", "切换主题"],
    ["#mdbook-search-toggle", "搜索（按 / 键）"],
    ["#mdbook-menu-bar a[aria-label='Print this book']", "打印本书"],
  ];

  /* 主题名：mdBook 给的是 Auto / Light / Rust / Coal / Navy / Ayu。
     本书只有两套外观（浅色一套、深色一套），三个深色主题的区别仅在代码高亮
     配色，所以按「浅色 / 深色 · 代码配色名」标注，读者才知道该怎么选。 */
  var THEME_LABELS = {
    "mdbook-theme-default_theme": ["跟随系统", "按系统外观自动选择"],
    "mdbook-theme-light": ["浅色", "浅色外观"],
    "mdbook-theme-rust": ["浅色 · Rust", "浅色外观，Rust 代码高亮"],
    "mdbook-theme-coal": ["深色 · Coal", "深色外观，Coal 代码高亮"],
    "mdbook-theme-navy": ["深色 · Navy", "深色外观，Navy 代码高亮"],
    "mdbook-theme-ayu": ["深色 · Ayu", "深色外观，Ayu 代码高亮"],
  };

  /* searcher.js 的 formatSearchMetric() 生成的结果统计行 */
  var METRIC_PATTERNS = [
    [/^(\d+) search results? for ['‘’"「]?(.*?)['‘’"」]?:?$/, function (m) { return "「" + m[2] + "」· 命中 " + m[1] + " 条"; }],
    [/^No search results for ['‘’"「]?(.*?)['‘’"」]?\.?$/, function (m) { return "「" + m[1] + "」· 没有命中"; }],
  ];

  function localizeChrome() {
    CHROME_LABELS.forEach(function (pair) {
      var el = document.querySelector(pair[0]);
      if (!el) return;
      el.setAttribute("title", pair[1]);
      el.setAttribute("aria-label", pair[1]);
    });

    var bar = document.getElementById("mdbook-searchbar");
    if (bar) {
      bar.setAttribute("placeholder", "搜索本书内容…");
      bar.setAttribute("aria-label", "搜索本书内容");
    }

    // 目录开关本体是个隐藏 checkbox，只靠外面那个 label 关联，本身没有可读名字
    var sidebarAnchor = document.getElementById("mdbook-sidebar-toggle-anchor");
    if (sidebarAnchor) sidebarAnchor.setAttribute("aria-label", "切换目录");

    // 代码块右上角的复制按钮（book.js 运行时插入，title 写死为 Copy to clipboard）
    document.querySelectorAll(".clip-button").forEach(function (button) {
      button.setAttribute("title", "复制代码");
      button.setAttribute("aria-label", "复制代码");
    });

    Object.keys(THEME_LABELS).forEach(function (id) {
      var el = document.getElementById(id);
      if (!el) return;
      el.textContent = THEME_LABELS[id][0];
      el.setAttribute("title", THEME_LABELS[id][1]);
    });
  }

  function translateMetric(text) {
    for (var i = 0; i < METRIC_PATTERNS.length; i++) {
      var match = text.match(METRIC_PATTERNS[i][0]);
      if (match) return METRIC_PATTERNS[i][1](match);
    }
    return null;
  }

  /* 搜索结果面板：统计行汉化 + 结果区限高后补齐键盘导航的滚动。
     结果列表每次搜索都被整体重建，所以用 MutationObserver 而不是一次性改写。 */
  function watchSearchResults() {
    var header = document.getElementById("mdbook-searchresults-header");
    if (header && !header.dataset.naLocalized) {
      header.dataset.naLocalized = "1";
      var translateHeader = function () {
        var translated = translateMetric(header.textContent.trim());
        if (translated !== null) header.textContent = translated;
      };
      new MutationObserver(translateHeader).observe(header, { childList: true, characterData: true, subtree: true });
      translateHeader();
    }

    var list = document.getElementById("mdbook-searchresults");
    if (!list || list.dataset.naWatched) return;
    list.dataset.naWatched = "1";
    new MutationObserver(function (records) {
      records.forEach(function (record) {
        if (record.type === "childList") {
          // 摘要的无障碍标签也是英文的
          list.querySelectorAll("span.teaser[aria-label]").forEach(function (teaser) {
            teaser.setAttribute("aria-label", "结果摘要");
          });
          return;
        }
        // 结果区限高内滚后，上下键移动高亮要把条目带进视野（mdBook 自己不做）
        var item = record.target;
        if (!item.classList || !item.classList.contains("focus")) return;
        var box = list.getBoundingClientRect();
        var bounds = item.getBoundingClientRect();
        if (bounds.top < box.top) list.scrollTop -= box.top - bounds.top;
        else if (bounds.bottom > box.bottom) list.scrollTop += bounds.bottom - box.bottom;
      });
    }).observe(list, { childList: true, subtree: true, attributes: true, attributeFilter: ["class"] });
  }

  function boot() {
    if (root.dataset.matrixBooted) return;
    root.dataset.matrixBooted = "true";
    if (getStoredValue(CORE_ONLY_KEY) === "1") root.classList.add("core-only");
    buildPageToc();
    buildLayerToggle();
    buildSolutionToolbar();
    enhanceSidebar();
    localizeChrome();
    watchSearchResults();
    updateProgress();

    // 「本页大纲」由 toc.js 在 DOMContentLoaded 里插入，而 toc.js 的监听器
    // 注册在本文件之前，所以这个回调一定跑在它之后。
    if (document.readyState === "loading") {
      document.addEventListener("DOMContentLoaded", decorateSidebarOutline);
    } else {
      decorateSidebarOutline();
    }
    window.addEventListener("scroll", followCurrentHeader, { passive: true });
    if (sidebarBox) {
      ["wheel", "touchstart", "pointerdown"].forEach(function (type) {
        sidebarBox.addEventListener(type, function () { manualSidebarScrollAt = Date.now(); }, { passive: true });
      });
    }

    requestAnimationFrame(function () {
      requestAnimationFrame(function () { root.classList.add("matrix-ready"); });
    });
  }

  boot();
})();
