/* 矩阵论教程主题：可降级的阅读与导航增强。 */
(function () {
  "use strict";

  var root = document.documentElement;
  var framePending = false;


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
    buildPageToc();
    buildSolutionToolbar();
    buildPortalHome();
    updateProgress();
    markScrollableDisplays();

    // 公式宽度在 KaTeX 字体就绪与折叠解答展开后才会定型，两处都补测一次
    if (document.fonts && document.fonts.ready) {
      document.fonts.ready.then(function () { markScrollableDisplays(); });
    }
    // 折叠状态记忆在 framework.js；这里只负责展开后重测公式宽度
    document.addEventListener("toggle", function (event) {
      if (event.target && event.target.tagName === "DETAILS") {
        setTimeout(markScrollableDisplays, 0);
        event.target.dataset.matrixOpen = event.target.open ? "1" : "0";
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
