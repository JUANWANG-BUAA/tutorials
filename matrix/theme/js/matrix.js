/* 矩阵论教程主题：可降级的阅读与导航增强。 */
(function () {
  "use strict";

  var root = document.documentElement;
  var framePending = false;
  var printSolutionState = null;


  /* ------------------------------------------------------------------ *
   * 界面文案中文化：mdBook 自带的 chrome 文案（搜索框、帮助弹窗、翻页
   * 按钮等）没有本地化配置，且会随版本升级改变，因此在这里运行时替换。
   * 所有定位都按元素存在性防御：升级后 id 或结构变了只是不翻译，不报错。
   * ------------------------------------------------------------------ */
  function setAttrs(id, attrs) {
    var el = document.getElementById(id);
    if (!el) return;
    for (var key in attrs) {
      if (attrs.hasOwnProperty(key)) el.setAttribute(key, attrs[key]);
    }
  }

  function localizeChrome() {
    setAttrs("mdbook-searchbar", { placeholder: "搜索本教程…", "aria-label": "搜索本教程" });
    setAttrs("mdbook-search-toggle", { title: "搜索（按 /）", "aria-label": "打开搜索" });
    setAttrs("mdbook-sidebar-toggle", { title: "展开或收起目录", "aria-label": "展开或收起目录" });
    setAttrs("mdbook-theme-toggle", { title: "切换主题", "aria-label": "切换主题" });
    setAttrs("mdbook-theme-list", { "aria-label": "主题" });
    setAttrs("mdbook-sidebar", { "aria-label": "目录" });

    var printLink = document.querySelector('a[href="print.html"]');
    if (printLink) {
      printLink.setAttribute("title", "打印全书（自动展开全部解答）");
      printLink.setAttribute("aria-label", "打印全书");
    }

    // 翻页箭头：桌面 .nav-chapters 与移动 .mobile-nav-chapters 各一对
    var NAV_TEXT = { previous: "上一页", next: "下一页" };
    document.querySelectorAll(".nav-chapters, .mobile-nav-chapters").forEach(function (a) {
      var kind = a.classList.contains("previous") ? "previous" : "next";
      a.setAttribute("title", NAV_TEXT[kind]);
      a.setAttribute("aria-label", NAV_TEXT[kind]);
    });

    // 帮助弹窗（按 ? 呼出）：保留 <kbd> 视觉，整体换成中文句子
    var helpPopup = document.getElementById("mdbook-help-popup");
    if (helpPopup && /Keyboard shortcuts/.test(helpPopup.textContent)) {
      var helpTitle = helpPopup.querySelector(".mdbook-help-title");
      if (helpTitle) helpTitle.textContent = "键盘快捷键";
      var helpBody = helpPopup.querySelector("div");
      if (helpBody) {
        // 每行是 (文本, 是否加 kbd 样式) 的序列，如 ["按 ",0],["←",1]
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

    // 主题菜单第一项 Auto → 自动（其余 Light/Rust/… 是专有名词，保留）
    var autoTheme = document.getElementById("mdbook-theme-default_theme");
    if (autoTheme && autoTheme.textContent.trim() === "Auto") autoTheme.textContent = "自动";

    // 搜索结果统计行由 searcher.js 在每次查询后写回英文，用观察器接力翻译
    var resultsHeader = document.getElementById("mdbook-searchresults-header");
    if (resultsHeader && !resultsHeader.dataset.matrixLocalized) {
      resultsHeader.dataset.matrixLocalized = "1";
      var translateMetric = function () {
        var text = resultsHeader.textContent || "";
        var m = text.match(/^(?:(\d+) search results? for '(.*)'|No search results for '(.*)')[:.]$/);
        if (!m) return;
        resultsHeader.textContent = m[3] !== undefined
          ? "没有与「" + m[3] + "」匹配的内容"
          : "「" + m[2] + "」· " + m[1] + " 条结果";
      };
      translateMetric();
      new MutationObserver(translateMetric).observe(resultsHeader, { childList: true, characterData: true, subtree: true });
    }

    // 中文输入法加固：mdBook 的搜索只在 keyup 上触发，而 IME「点击候选词
    // 提交」不产生 keyup，输入内容会静默不搜索。input/compositionend 事件
    // 上补发一次 keyup；doSearch 对相同词有去重，正常敲键不会重复查询。
    var searchbar = document.getElementById("mdbook-searchbar");
    if (searchbar && !searchbar.dataset.matrixImeHardened) {
      searchbar.dataset.matrixImeHardened = "1";
      ["input", "compositionend"].forEach(function (type) {
        searchbar.addEventListener(type, function () {
          searchbar.dispatchEvent(new KeyboardEvent("keyup"));
        });
      });
    }
  }

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

  /* 宽公式横向滚动提示：移动端（或窄窗口）里 .katex-display 内部可横向滚动，
   * 但没有任何视觉线索。给可滚动的公式加 can-scroll 类，CSS 画右缘渐隐；
   * 滚到末端后去掉提示，避免「还有内容」的误导。 */
  function markScrollableDisplays() {
    document.querySelectorAll(".katex-display").forEach(function (el) {
      var scrollable = el.scrollWidth > el.clientWidth + 4;
      el.classList.toggle("can-scroll", scrollable && el.scrollLeft + el.clientWidth < el.scrollWidth - 4);
      el.classList.toggle("scrolled-start", scrollable && el.scrollLeft > 4);
    });
  }

  function watchDisplayScroll(event) {
    var el = event.target && event.target.closest ? event.target.closest(".katex-display") : null;
    if (!el) return;
    var scrollable = el.scrollWidth > el.clientWidth + 4;
    el.classList.toggle("can-scroll", scrollable && el.scrollLeft + el.clientWidth < el.scrollWidth - 4);
    el.classList.toggle("scrolled-start", scrollable && el.scrollLeft > 4);
  }

  /* 回到顶部：正文页普遍超过一万像素高，菜单栏滚动后又隐藏，
   * 长读之后回页首的成本高。滚过约一屏半后出现，右下角小圆钮。 */
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

  function prefersReducedMotion() {
    return window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  }

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

  function buildSolutionToolbar() {
    var solutions = document.querySelectorAll("details.sol-box");
    var main = document.querySelector("main");
    if (!solutions.length || !main || document.querySelector(".sol-toolbar")) return;

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
    // 固定放在页首（页内目录或 H1 之后），保证进入页面即可见，而不是埋在某个解答框旁边。
    var pageToc = main.querySelector(":scope > .page-toc");
    if (pageToc) {
      pageToc.insertAdjacentElement("afterend", toolbar);
    } else {
      var first = main.firstElementChild;
      if (first && first.tagName === "H1") first.insertAdjacentElement("afterend", toolbar);
      else main.insertBefore(toolbar, first);
    }
  }

  // 打印时把「提示」与「解答」全部展开，免得纸面上只剩下一排折叠标题。
  /* ------------------------------------------------------------------ *
   * 记住「哪些解答已经展开」
   *
   * 习题集一页 63 个折叠块、自测卷 40 多个，学生是**分批做**的：做几题、
   * 展开核对、再回来做后面的。此前一刷新或翻页再回来，展开状态全丢，
   * 得重新找自己做到哪一题——这是使用中最实际的摩擦之一。
   *
   * 用 localStorage 按「页面路径 + 组序号 + 组内下标」记录**已展开**的那些，
   * 不记折叠的：默认就是折叠，只存开着的可以让记录尽量小。
   * 任何存储异常都静默降级（隐私模式下 localStorage 会抛错），
   * 退化成「不记忆」而不是报错。
   * ------------------------------------------------------------------ */
  var OPEN_FOLDS_KEY = "matrix-open-folds";

  function foldKey() {
    // 路径 + 组序号，保证不同页、不同折叠组互不干扰
    return location.pathname;
  }

  function readOpenFolds() {
    var raw = getStoredValue(OPEN_FOLDS_KEY);
    if (!raw) return {};
    try {
      var parsed = JSON.parse(raw);
      return parsed && typeof parsed === "object" ? parsed : {};
    } catch (error) {
      return {};
    }
  }

  function writeOpenFolds(map) {
    try { setStoredValue(OPEN_FOLDS_KEY, JSON.stringify(map)); } catch (error) { /* 忽略 */ }
  }

  function saveFoldState(details) {
    var groups = PRINT_FOLDS.map(function (sel) {
      return Array.prototype.slice.call(document.querySelectorAll(sel));
    });
    var page = foldKey();
    var map = readOpenFolds();
    var entry = map[page] || {};
    groups.forEach(function (items, group) {
      items.forEach(function (item, index) {
        if (!item.open) return;
        var bucket = entry[group] || (entry[group] = []);
        if (bucket.indexOf(index) === -1) bucket.push(index);
      });
    });
    // 清掉已经不存在的下标，避免记录无限增长
    Object.keys(entry).forEach(function (group) {
      var items = groups[Number(group)] || [];
      entry[group] = entry[group].filter(function (i) { return i < items.length; });
      if (!entry[group].length) delete entry[group];
    });
    if (Object.keys(entry).length) map[page] = entry; else delete map[page];
    writeOpenFolds(map);
  }

  function restoreFoldState() {
    var page = foldKey();
    var entry = readOpenFolds()[page];
    if (!entry) return 0;
    var groups = PRINT_FOLDS.map(function (sel) {
      return Array.prototype.slice.call(document.querySelectorAll(sel));
    });
    var restored = 0;
    Object.keys(entry).forEach(function (group) {
      var items = groups[Number(group)] || [];
      entry[group].forEach(function (index) {
        if (items[index]) { items[index].open = true; restored++; }
      });
    });
    return restored;
  }

  var PRINT_FOLDS = ["details.sol-box", "details.hint-box"];
  window.addEventListener("beforeprint", function () {
    printSolutionState = PRINT_FOLDS.map(function (selector) {
      return Array.prototype.map.call(document.querySelectorAll(selector), function (details) {
        return details.open;
      });
    });
    PRINT_FOLDS.forEach(function (selector) {
      document.querySelectorAll(selector).forEach(function (details) { details.open = true; });
    });
  });

  window.addEventListener("afterprint", function () {
    if (!printSolutionState) return;
    PRINT_FOLDS.forEach(function (selector, group) {
      document.querySelectorAll(selector).forEach(function (details, index) {
        details.open = Boolean(printSolutionState[group][index]);
      });
    });
    printSolutionState = null;
  });

  /* 这里**不再**自建 ←/→ 护栏。原因值得记下来，因为曾经写错过：
   *
   * mdBook 的 chapterNavigation 已经内置了等价保护——
   *   `window.search.hasFocus() || mdbook_something_else_has_focus(e)`
   * 后者判断事件目标是不是 input / select / textarea（并特判 checkbox-img）。
   * 也就是说「输入框里按方向键要移动光标、不能翻页」这件事，上游已经处理好，
   * 且随版本维护。
   *
   * 本文件曾额外加一层守卫，把 button / summary 也算作「交互元素」，并用
   * pointerup 记一个 pageNavigationLocked 标志。后果是：点过任意一个「解答」
   * 折叠块或工具条按钮后，标志留在 true，←/→ 被这一层吞掉而 mdBook 收不到，
   * 页面再也翻不动——偏偏界面上还写着「按 ← / → 翻页」。
   * 实测复现：点折叠块后 activeElement 是 <summary>，按 → 无任何反应。
   *
   * 教训：**不要重复实现框架已有的可访问性行为**。少一层拦截，少一处 bug。
   */

  /* 侧栏（折叠、编号分列）自 2026-10 起收进 theme/js/sidebar.js，三本书共用
     同一份实现——此前各书一份、行为不一致，且与 mdBook 自带的大纲折叠钮互相
     打架（同一 chevron 改两个 li，点击看起来「只展开、折不动」）。本文件不再
     处理侧栏。 */

  /* ------------------------------------------------------------------ *
   * 返回教程库
   *
   * 三本书各自是独立站点：读者从导览首页（/tutorials/）点进来后，书里只有本书
   * 目录，翻到最后一章也没有回首页的入口，只能改地址栏或依赖浏览器后退。
   * 菜单栏右侧补一个「教程库」按钮，回到本书所在目录的上一级。
   *
   * 首页地址由当前路径推出，不写死域名：mdBook 把每本书发布在 /<slug>/ 之下，
   * 去掉本书 slug 及其后的所有片段，剩下的就是导览首页。于是 gh-pages 的
   * /tutorials/matrix/ 与自定义域名根目录下的 /matrix/ 都成立。
   * 本地 `mdbook serve` 预览时服务在站点根、路径里没有 slug，此时不插入按钮，
   * 免得点出一个 404。
   * ------------------------------------------------------------------ */
  var BOOK_SLUG = "matrix";
  var HOME_ICON = '<svg viewBox="0 0 576 512" aria-hidden="true"><path d="M575.8 255.5c0 18-15 32.1-32 32.1h-32l.7 160.2c0 2.7-.2 5.4-.5 8.1V472c0 22.1-17.9 40-40 40H456c-1.1 0-2.2 0-3.3-.1c-1.4 .1-2.8 .1-4.2 .1H416 392c-22.1 0-40-17.9-40-40V448 384c0-17.7-14.3-32-32-32H256c-17.7 0-32 14.3-32 32v64 16c0 22.1-17.9 40-40 40H160 128.1c-1.5 0-3-.1-4.5-.2c-1.2 .1-2.4 .2-3.6 .2H104c-22.1 0-40-17.9-40-40V360c0-.9 0-1.9 .1-2.8V287.6H32c-18 0-32-14-32-32.1c0-9 3-17 10-24L266.4 8c7-7 15-8 22-8s15 2 21 7L564.8 231.5c8 7 12 15 11 24z"/></svg>';

  function portalUrl() {
    var segments = location.pathname.split("/").filter(Boolean);
    var index = segments.lastIndexOf(BOOK_SLUG);
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
    if (root.dataset.matrixBooted) return;
    root.dataset.matrixBooted = "true";
    // 本地化是纯增益层：自身出错不能拖垮进度条、目录等核心增强
    try { localizeChrome(); } catch (error) { /* 升级后 id 变了等情形，静默降级 */ }
    buildPageToc();
    buildSolutionToolbar();
    buildBackToTop();
    buildPortalHome();
    updateProgress();
    markScrollableDisplays();

    // 公式宽度在 KaTeX 字体就绪与折叠解答展开后才会定型，两处都补测一次
    if (document.fonts && document.fonts.ready) {
      document.fonts.ready.then(function () { markScrollableDisplays(); });
    }
    // 先恢复上次展开过的解答，再挂监听——顺序反了会把恢复动作也当成用户操作
    try { restoreFoldState(); } catch (error) { /* 记忆功能可降级 */ }
    document.addEventListener("toggle", function (event) {
      var details = event.target;
      if (details.tagName === "DETAILS") {
        setTimeout(markScrollableDisplays, 0);
        // expanded 标志用于让工具条知道「当前有内容展开」
        details.dataset.matrixOpen = details.open ? "1" : "0";
        try { saveFoldState(details); } catch (error) { /* 记忆功能可降级 */ }
      }
    }, true);
    document.addEventListener("scroll", watchDisplayScroll, { passive: true, capture: true });
    var resizeDisplayPending = false;
    window.addEventListener("resize", function () {
      if (resizeDisplayPending) return;
      resizeDisplayPending = true;
      requestAnimationFrame(function () { resizeDisplayPending = false; markScrollableDisplays(); });
    }, { passive: true });

    requestAnimationFrame(function () {
      requestAnimationFrame(function () { root.classList.add("matrix-ready"); });
    });
  }

  boot();
})();
