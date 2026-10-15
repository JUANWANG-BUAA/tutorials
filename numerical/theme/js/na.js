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

  /* 打印前展开 / 打印后复原、界面文案汉化、搜索面板、回到顶部、折叠记忆：
     自 2026-10 起统一收进 theme/js/framework.js（三本书共用）。 */

  /* 这里**不再**自建 ←/→ 护栏（详见 robot.js 同处注释）：mdBook 的
     chapterNavigation 已内置「焦点在交互元素里就不翻页」的保护，此前本文件
     额外加的一层会吞掉方向键、让页面翻不动。 */

  /* 侧栏（折叠、编号分列、本页大纲、跟随当前小节）自 2026-10 起收进
     theme/js/sidebar.js，三本书共用同一份实现——此前各书一份、行为不一致，
     且与 mdBook 自带的大纲折叠钮互相打架（同一 chevron 改两个 li，点击看起来
     「只展开、折不动」）。本文件不再处理侧栏。 */

  /* 侧栏（折叠、编号分列、本页大纲、跟随当前小节）自 2026-10 起收进
     theme/js/sidebar.js，三本书共用同一份实现——此前各书一份、行为不一致，
     且与 mdBook 自带的大纲折叠钮互相打架（同一 chevron 改两个 li，点击看起来
     「只展开、折不动」）。本文件不再处理侧栏。 */


  /* 界面文案汉化、搜索面板、回到顶部、折叠记忆统一收进 theme/js/framework.js。 */

  /* ------------------------------------------------------------------ *
   * 返回教程库
   *
   * 三本书各自是独立站点：读者从导览首页（/tutorials/）点进来后，书里只有本书
   * 目录，翻到最后一章也没有回首页的入口，只能改地址栏或依赖浏览器后退。
   * 菜单栏右侧补一个「教程库」按钮，回到本书所在目录的上一级。
   *
   * 首页地址由当前路径推出，不写死域名：mdBook 把每本书发布在 /<slug>/ 之下，
   * 去掉本书 slug 及其后的所有片段，剩下的就是导览首页。于是 gh-pages 的
   * /tutorials/numerical/ 与自定义域名根目录下的 /numerical/ 都成立。
   * 本地 `mdbook serve` 预览时服务在站点根、路径里没有 slug，此时不插入按钮，
   * 免得点出一个 404。
   * ------------------------------------------------------------------ */
  var BOOK_SLUG = "numerical";
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
    if (getStoredValue(CORE_ONLY_KEY) === "1") root.classList.add("core-only");
    buildPageToc();
    buildLayerToggle();
    buildSolutionToolbar();
    buildPortalHome();
    updateProgress();

    requestAnimationFrame(function () {
      requestAnimationFrame(function () { root.classList.add("matrix-ready"); });
    });
  }

  boot();
})();
