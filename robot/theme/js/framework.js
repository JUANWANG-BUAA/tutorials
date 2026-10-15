/*
 * 框架界面层 — 三本书共用（robot / numerical / matrix 三份内容逐字相同）
 * ---------------------------------------------------------------------------
 * 职责两层：
 *   ① 修补 mdBook 自带界面：菜单栏 / 搜索 / 帮助弹窗文案汉化、搜索结果面板、
 *      回到顶部、折叠状态记忆、打印前展开；
 *   ② 附加操作：阅读进度条、页内目录、解答工具条、宽公式滚动提示、返回教程库。
 *      这五项此前分散在三本书各自的书名脚本里，行为与位置各不相同（解答工具条
 *      在矩阵论固定在页首、在另两本埋在第一个解答框旁；页内目录只有机器人控制
 *      技术收 H3；公式滚动提示只有矩阵论有），现在统一到这里一份实现。
 *
 * 每本书只在自己的脚本（matrix.js / na.js / robot.js）里声明本书配置：
 *   window.TUTORIALS = { slug: "matrix", onReady: function () { … } };
 * 本文件读取它——没有声明时按「无本书 slug」降级（例如本地预览不插返回教程库
 * 按钮）。onReady 在共用部件全部插入后调用，书内专属部件（如数值分析的「只看
 * 核心」图例）需要排在它们之后就写在那里。
 *
 * 本文件只做「框架 UI 的修补与增强」，不碰正文、不碰侧栏。全部按元素存在性
 * 防御：升级后 id/结构变了只是这一项不生效，不报错、不影响其余部分。
 */
(function () {
  "use strict";

  var root = document.documentElement;
  var CONFIG = window.TUTORIALS || {};
  var OPEN_FOLDS_KEY = "tutorials-open-folds";

  function store(key) { try { return localStorage.getItem(key); } catch (e) { return null; } }
  function save(key, value) { try { localStorage.setItem(key, value); } catch (e) { /* 隐私模式静默降级 */ } }
  function prefersReducedMotion() {
    return window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  }

  /* ======================================================================== *
   * 1  界面文案汉化
   * ======================================================================== */
  var CHROME_LABELS = [
    ["#mdbook-sidebar-toggle", "切换目录"],
    ["#mdbook-theme-toggle", "切换主题"],
    ["#mdbook-search-toggle", "搜索（按 / 键）"],
    ["#mdbook-menu-bar a[aria-label='Print this book']", "打印本书"],
    ["#mdbook-menu-bar a[href='print.html']", "打印本书"]
  ];

  /* mdBook 的主题名是 Auto / Light / Rust / Coal / Navy / Ayu。三本书都只提供
     浅色与深色两套外观，三个深色主题的差别仅在代码高亮配色，故按「浅色 / 深色 ·
     代码配色名」标注，读者才知道该怎么选。 */
  var THEME_LABELS = {
    "mdbook-theme-default_theme": ["跟随系统", "按系统外观自动选择"],
    "mdbook-theme-light": ["浅色", "浅色外观"],
    "mdbook-theme-rust": ["浅色 · Rust", "浅色外观，Rust 代码高亮"],
    "mdbook-theme-coal": ["深色 · Coal", "深色外观，Coal 代码高亮"],
    "mdbook-theme-navy": ["深色 · Navy", "深色外观，Navy 代码高亮"],
    "mdbook-theme-ayu": ["深色 · Ayu", "深色外观，Ayu 代码高亮"]
  };

  function setAttrs(id, attrs) {
    var el = document.getElementById(id);
    if (!el) return;
    Object.keys(attrs).forEach(function (key) { el.setAttribute(key, attrs[key]); });
  }

  function localizeChrome() {
    CHROME_LABELS.forEach(function (pair) {
      var el = document.querySelector(pair[0]);
      if (!el) return;
      el.setAttribute("title", pair[1]);
      el.setAttribute("aria-label", pair[1]);
    });

    setAttrs("mdbook-searchbar", { placeholder: "搜索本书内容…", "aria-label": "搜索本书内容" });
    setAttrs("mdbook-theme-list", { "aria-label": "主题" });
    setAttrs("mdbook-sidebar", { "aria-label": "目录" });

    // 目录开关本体是隐藏 checkbox，靠外层 label 关联，自身没有可读名字
    setAttrs("mdbook-sidebar-toggle-anchor", { "aria-label": "切换目录" });

    // 翻页箭头：桌面 .nav-chapters 与移动 .mobile-nav-chapters 各一对
    var NAV_TEXT = { previous: "上一页", next: "下一页" };
    document.querySelectorAll(".nav-chapters, .mobile-nav-chapters").forEach(function (a) {
      var kind = a.classList.contains("previous") ? "previous" : "next";
      a.setAttribute("title", NAV_TEXT[kind]);
      a.setAttribute("aria-label", NAV_TEXT[kind]);
    });

    // 代码块右上角的复制按钮（book.js 运行时插入，title 写死为 Copy to clipboard）
    document.querySelectorAll(".clip-button").forEach(function (button) {
      button.setAttribute("title", "复制代码");
      button.setAttribute("aria-label", "复制代码");
    });

    // 帮助弹窗（按 ? 呼出）：保留 <kbd> 视觉，整体换成中文句子
    var helpPopup = document.getElementById("mdbook-help-popup");
    if (helpPopup && /Keyboard shortcuts/.test(helpPopup.textContent)) {
      var helpTitle = helpPopup.querySelector(".mdbook-help-title");
      if (helpTitle) helpTitle.textContent = "键盘快捷键";
      var helpBody = helpPopup.querySelector("div");
      if (helpBody) {
        var HELP_LINES = [
          [["按 ", 0], ["←", 1], [" / ", 0], ["→", 1], [" 在章节间翻页", 0]],
          [["按 ", 0], ["S", 1], [" 或 ", 0], ["/", 1], [" 搜索全书", 0]],
          [["按 ", 0], ["?", 1], [" 显示本帮助", 0]],
          [["按 ", 0], ["Esc", 1], [" 关闭本帮助", 0]]
        ];
        helpBody.textContent = "";
        HELP_LINES.forEach(function (line) {
          var p = document.createElement("p");
          line.forEach(function (seg) {
            if (seg[1]) {
              var kbd = document.createElement("kbd");
              kbd.textContent = seg[0];
              p.appendChild(kbd);
            } else {
              p.appendChild(document.createTextNode(seg[0]));
            }
          });
          helpBody.appendChild(p);
        });
      }
    }

    Object.keys(THEME_LABELS).forEach(function (id) {
      var el = document.getElementById(id);
      if (!el) return;
      el.textContent = THEME_LABELS[id][0];
      el.setAttribute("title", THEME_LABELS[id][1]);
    });

    // 中文输入法加固：mdBook 的搜索只在 keyup 上触发，而 IME「点击候选词提交」
    // 不产生 keyup，输入内容会静默不搜索。input/compositionend 上补发一次 keyup；
    // doSearch 对相同词有去重，正常敲键不会重复查询。
    var searchbar = document.getElementById("mdbook-searchbar");
    if (searchbar && !searchbar.dataset.chromeIme) {
      searchbar.dataset.chromeIme = "1";
      ["input", "compositionend"].forEach(function (type) {
        searchbar.addEventListener(type, function () {
          searchbar.dispatchEvent(new KeyboardEvent("keyup"));
        });
      });
    }
  }

  /* ======================================================================== *
   * 2  搜索结果面板
   *   · 统计行汉化（searcher.js 的 formatSearchMetric 每次查询都写回英文）
   *   · 结果区限高内滚后，上下键移动高亮要把条目带进视野（mdBook 自己不做）
   * ======================================================================== */
  var METRIC_PATTERNS = [
    [/^(\d+) search results? for ['‘’"「]?(.*?)['‘’"」]?:?$/, function (m) { return "「" + m[2] + "」· 命中 " + m[1] + " 条"; }],
    [/^(?:No search results for ['‘’"「]?(.*?)['‘’"」]?\.?|No results found\.?)$/, function (m) {
      return m[1] ? "「" + m[1] + "」· 没有命中" : "没有命中";
    }]
  ];

  function translateMetric(text) {
    for (var i = 0; i < METRIC_PATTERNS.length; i++) {
      var match = text.match(METRIC_PATTERNS[i][0]);
      if (match) return METRIC_PATTERNS[i][1](match);
    }
    return null;
  }

  function watchSearchResults() {
    var header = document.getElementById("mdbook-searchresults-header");
    if (header && !header.dataset.chromeLocalized) {
      header.dataset.chromeLocalized = "1";
      var translateHeader = function () {
        var translated = translateMetric(header.textContent.trim());
        if (translated !== null) header.textContent = translated;
      };
      new MutationObserver(translateHeader).observe(header, { childList: true, characterData: true, subtree: true });
      translateHeader();
    }

    var list = document.getElementById("mdbook-searchresults");
    if (!list || list.dataset.chromeWatched) return;
    list.dataset.chromeWatched = "1";
    new MutationObserver(function (records) {
      records.forEach(function (record) {
        if (record.type === "childList") {
          // 摘要的无障碍标签也是英文的
          list.querySelectorAll("span.teaser[aria-label]").forEach(function (teaser) {
            teaser.setAttribute("aria-label", "结果摘要");
          });
          return;
        }
        var item = record.target;
        if (!item.classList || !item.classList.contains("focus")) return;
        var box = list.getBoundingClientRect();
        var bounds = item.getBoundingClientRect();
        if (bounds.top < box.top) list.scrollTop -= box.top - bounds.top;
        else if (bounds.bottom > box.bottom) list.scrollTop += bounds.bottom - box.bottom;
      });
    }).observe(list, { childList: true, subtree: true, attributes: true, attributeFilter: ["class"] });
  }

  /* ======================================================================== *
   * 3  回到顶部
   *   正文页普遍超过一万像素高，菜单栏滚动后又隐藏，长读之后回页首的成本高。
   *   滚过约一屏半后出现，右下角小圆钮；位置在 framework.css §4。
   * ======================================================================== */
  function buildBackToTop() {
    if (document.getElementById("back-to-top")) return;
    var button = document.createElement("button");
    var visible = false;
    button.id = "back-to-top";
    button.type = "button";
    button.setAttribute("aria-label", "回到顶部");
    button.setAttribute("title", "回到顶部");
    button.textContent = "↑";
    button.addEventListener("click", function () {
      window.scrollTo({ top: 0, behavior: prefersReducedMotion() ? "auto" : "smooth" });
    });
    document.body.appendChild(button);

    function sync() {
      var shouldShow = root.scrollTop > root.clientHeight * 1.5;
      if (shouldShow === visible) return;
      visible = shouldShow;
      button.classList.toggle("visible", visible);
    }
    window.addEventListener("scroll", sync, { passive: true });
    sync();
  }

  /* ======================================================================== *
   * 4  记住折叠状态（解答 / 提示）
   *   习题集一页几十个折叠块，学生是分批做：做几题、展开核对、再回来做后面的。
   *   此前一刷新或翻页再回来，展开状态全丢。按「页面路径 + 组序号 + 组内下标」
   *   只记**已展开**的那些（默认折叠），存储量最小、缺失即默认。
   * ======================================================================== */
  var PRINT_FOLDS = ["details.sol-box", "details.hint-box"];
  var printFoldState = null;

  function foldGroups() {
    return PRINT_FOLDS.map(function (sel) {
      return Array.prototype.slice.call(document.querySelectorAll(sel));
    });
  }

  function saveFoldState() {
    var groups = foldGroups();
    var page = location.pathname;
    var map = {};
    var raw = store(OPEN_FOLDS_KEY);
    if (raw) { try { map = JSON.parse(raw) || {}; } catch (e) { map = {}; } }
    var entry = {};
    groups.forEach(function (items, group) {
      items.forEach(function (item, index) {
        if (!item.open) return;
        (entry[group] || (entry[group] = [])).push(index);
      });
    });
    if (Object.keys(entry).length) map[page] = entry; else delete map[page];
    save(OPEN_FOLDS_KEY, JSON.stringify(map));
  }

  function restoreFoldState() {
    var page = location.pathname;
    var raw = store(OPEN_FOLDS_KEY);
    if (!raw) return;
    var map; try { map = JSON.parse(raw) || {}; } catch (e) { return; }
    var entry = map[page];
    if (!entry) return;
    var groups = foldGroups();
    Object.keys(entry).forEach(function (group) {
      var items = groups[Number(group)] || [];
      entry[group].forEach(function (index) { if (items[index]) items[index].open = true; });
    });
  }

  function wireFoldMemory() {
    // 先恢复上次展开过的解答，再挂监听——顺序反了会把恢复动作也当成用户操作
    try { restoreFoldState(); } catch (e) { /* 记忆功能可降级 */ }
    document.addEventListener("toggle", function (event) {
      if (event.target && event.target.tagName === "DETAILS") {
        try { saveFoldState(); } catch (e) { /* 记忆功能可降级 */ }
      }
    }, true);
  }

  // 打印时把「提示」与「解答」全部展开，免得纸面上只剩一排折叠标题。
  window.addEventListener("beforeprint", function () {
    printFoldState = foldGroups().map(function (items) {
      return items.map(function (d) { return d.open; });
    });
    document.querySelectorAll(PRINT_FOLDS.join(",")).forEach(function (d) { d.open = true; });
  });

  window.addEventListener("afterprint", function () {
    if (!printFoldState) return;
    PRINT_FOLDS.forEach(function (sel, group) {
      document.querySelectorAll(sel).forEach(function (d, index) {
        d.open = Boolean(printFoldState[group] && printFoldState[group][index]);
      });
    });
    printFoldState = null;
  });

  /* ======================================================================== *
   * 5  附加操作
   *   进度条 / 页内目录 / 解答工具条 / 公式滚动提示 / 返回教程库。此前三本书各
   *   写各的，行为与位置不一致；这里一份实现，三本行为逐项相同。
   * ======================================================================== */

  /* —— 5.1 阅读进度条：页顶 2px 随滚动推进，rAF 节流；从 bfcache 返回补算 —— */
  function buildProgressBar() {
    if (document.getElementById("progress")) return;
    var bar = document.createElement("div");
    var pending = false;
    bar.id = "progress";
    bar.setAttribute("aria-hidden", "true");
    document.body.appendChild(bar);

    function update() {
      pending = false;
      var maximum = root.scrollHeight - root.clientHeight;
      bar.style.width = (maximum > 0 ? root.scrollTop / maximum * 100 : 0) + "%";
    }
    function schedule() {
      if (pending) return;
      pending = true;
      requestAnimationFrame(update);
    }
    window.addEventListener("scroll", schedule, { passive: true });
    window.addEventListener("resize", schedule, { passive: true });
    window.addEventListener("pageshow", schedule);
    update();
  }

  /* —— 5.2 页内目录：H2 / H3 ≥ 3 个的页面在 H1 之后插入一张两列目录。
     标题里的 KaTeX 会带一份给屏幕阅读器的 MathML 副本，取值前先剔掉，
     否则同一条目录会把公式读两遍。 —— */
  function headingText(heading) {
    var clone = heading.cloneNode(true);
    Array.prototype.forEach.call(clone.querySelectorAll(".katex-mathml"), function (el) {
      el.parentNode.removeChild(el);
    });
    return clone.textContent.replace(/\s+/g, " ").trim();
  }

  function buildPageToc() {
    var main = document.querySelector("main");
    if (!main || main.querySelector(":scope > .page-toc")) return;
    var headings = Array.prototype.filter.call(main.querySelectorAll("h2, h3"), function (heading) {
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
      link.textContent = headingText(heading);
      if (heading.tagName === "H3") link.classList.add("page-toc-h3");
      nav.appendChild(link);
    });

    var first = main.firstElementChild;
    if (first && first.tagName === "H1") first.insertAdjacentElement("afterend", nav);
    else main.insertBefore(nav, first);
  }

  /* —— 5.3 解答工具条：固定在页首（页内目录 / H1 之后），进入页面即可见，
     不埋在第一个解答框旁边。按钮文案跟随实际开合状态。 —— */
  function buildSolutionToolbar() {
    var main = document.querySelector("main");
    var solutions = document.querySelectorAll("details.sol-box");
    if (!main || !solutions.length || document.querySelector(".sol-toolbar")) return;

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
    var pageToc = main.querySelector(":scope > .page-toc");
    if (pageToc) pageToc.insertAdjacentElement("afterend", toolbar);
    else {
      var first = main.firstElementChild;
      if (first && first.tagName === "H1") first.insertAdjacentElement("afterend", toolbar);
      else main.insertBefore(toolbar, first);
    }
  }

  /* —— 5.4 宽公式滚动提示：窄窗口里 .katex-display 可横向滚动但没有视觉线索，
     给它加 can-scroll / scrolled-start，CSS 画左右缘渐隐；滚到尽头撤下提示。
     字体就绪、折叠展开、窗口缩放都会改变公式宽度，三处都重测。 —— */
  function syncDisplayScrollState(el) {
    var scrollable = el.scrollWidth > el.clientWidth + 4;
    el.classList.toggle("can-scroll", scrollable && el.scrollLeft + el.clientWidth < el.scrollWidth - 4);
    el.classList.toggle("scrolled-start", scrollable && el.scrollLeft > 4);
  }
  function markScrollableDisplays() {
    Array.prototype.forEach.call(document.querySelectorAll(".katex-display"), syncDisplayScrollState);
  }
  function onDisplayScroll(event) {
    var el = event.target;
    if (!el || !el.closest) return;
    var display = el.classList && el.classList.contains("katex-display") ? el : el.closest(".katex-display");
    if (display) syncDisplayScrollState(display);
  }
  function wireFormulaHints() {
    markScrollableDisplays();
    if (document.fonts && document.fonts.ready) document.fonts.ready.then(markScrollableDisplays);
    document.addEventListener("toggle", function (event) {
      if (event.target && event.target.tagName === "DETAILS") setTimeout(markScrollableDisplays, 0);
    }, true);
    document.addEventListener("scroll", onDisplayScroll, { passive: true, capture: true });
    var pending = false;
    window.addEventListener("resize", function () {
      if (pending) return;
      pending = true;
      requestAnimationFrame(function () { pending = false; markScrollableDisplays(); });
    }, { passive: true });
  }

  /* —— 5.5 返回教程库：三本书各自是独立站点，书内没有回导览首页的入口。
     地址由本书 slug 推出，不写死域名：gh-pages 的 /tutorials/matrix/ 与自定义
     域名下的 /matrix/ 都成立。本地 mdbook serve 路径里没有 slug，此时不插按钮，
     免得点出一个 404。 —— */
  var HOME_ICON = '<svg viewBox="0 0 576 512" aria-hidden="true"><path d="M575.8 255.5c0 18-15 32.1-32 32.1h-32l.7 160.2c0 2.7-.2 5.4-.5 8.1V472c0 22.1-17.9 40-40 40H456c-1.1 0-2.2 0-3.3-.1c-1.4 .1-2.8 .1-4.2 .1H416 392c-22.1 0-40-17.9-40-40V448 384c0-17.7-14.3-32-32-32H256c-17.7 0-32 14.3-32 32v64 16c0 22.1-17.9 40-40 40H160 128.1c-1.5 0-3-.1-4.5-.2c-1.2 .1-2.4 .2-3.6 .2H104c-22.1 0-40-17.9-40-40V360c0-.9 0-1.9 .1-2.8V287.6H32c-18 0-32-14-32-32.1c0-9 3-17 10-24L266.4 8c7-7 15-8 22-8s15 2 21 7L564.8 231.5c8 7 12 15 11 24z"/></svg>';

  function portalUrl() {
    if (!CONFIG.slug) return null;
    var segments = location.pathname.split("/").filter(Boolean);
    var index = segments.lastIndexOf(CONFIG.slug);
    if (index < 0) return null;
    return "/" + segments.slice(0, index).join("/") + (index > 0 ? "/" : "");
  }

  function buildPortalHome() {
    var bar = document.getElementById("mdbook-menu-bar");
    var right = bar && bar.querySelector(".right-buttons");
    if (!right || right.querySelector(".portal-home")) return;
    var url = portalUrl();
    if (!url) return;

    var link = document.createElement("a");
    link.className = "portal-home";
    link.href = url;
    link.setAttribute("title", "返回教程库");
    link.setAttribute("aria-label", "返回教程库");

    var icon = document.createElement("span");
    icon.className = "portal-home-icon";
    icon.innerHTML = HOME_ICON;
    var label = document.createElement("span");
    label.className = "portal-home-label";
    label.textContent = "教程库";

    link.appendChild(icon);
    link.appendChild(label);
    right.insertBefore(link, right.firstChild);
  }

  function boot() {
    if (root.dataset.tutorialsBooted) return;
    root.dataset.tutorialsBooted = "true";
    try { localizeChrome(); } catch (e) { /* 升级后 id 变了等情形，静默降级 */ }
    try { watchSearchResults(); } catch (e) { /* 同上 */ }
    try { buildProgressBar(); } catch (e) { /* 纯增益 */ }
    try { buildPageToc(); } catch (e) { /* 纯增益 */ }
    try { buildSolutionToolbar(); } catch (e) { /* 纯增益 */ }
    try { buildPortalHome(); } catch (e) { /* 纯增益 */ }
    try { buildBackToTop(); } catch (e) { /* 纯增益 */ }
    try { wireFoldMemory(); } catch (e) { /* 纯增益 */ }
    try { wireFormulaHints(); } catch (e) { /* 纯增益 */ }
    // 书内专属部件：数值分析的「只看核心」图例要挂在页内目录之后
    if (typeof CONFIG.onReady === "function") {
      try { CONFIG.onReady(); } catch (e) { /* 单本书的增强出错不拖垮共用层 */ }
    }
    // 冷启动期禁过渡（各书 CSS 的 html:not(.tutorials-ready) 段）到此解除
    requestAnimationFrame(function () {
      requestAnimationFrame(function () { root.classList.add("tutorials-ready"); });
    });
  }

  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", boot);
  else boot();
})();
