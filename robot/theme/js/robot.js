/* 矩阵论教程主题：可降级的阅读与导航增强。 */
(function () {
  "use strict";

  var root = document.documentElement;
  var framePending = false;
  var printSolutionState = null;


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
      link.textContent = heading.textContent.trim();
      if (heading.tagName === "H3") link.classList.add("page-toc-h3");
      nav.appendChild(link);
    });

    var first = main.firstElementChild;
    if (first && first.tagName === "H1") first.insertAdjacentElement("afterend", nav);
    else main.insertBefore(nav, first);
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

  /* 这里**不再**自建 ←/→ 护栏，也不再处理侧栏。
   *
   * ① 方向键：mdBook 的 chapterNavigation 已内置等价保护（判断事件目标与当前
   *    焦点是否在 input/select/textarea 等交互元素里），且随版本维护。此前本文件
   *    额外加一层守卫、把 button / summary 也算作交互元素并用 pointerup 记一个
   *    pageNavigationLocked 标志，后果是点过任意折叠块或按钮后 ←/→ 被吞掉、页面
   *    再也翻不动。教训：**不要重复实现框架已有的可访问性行为**。
   *
   * ② 侧栏折叠：收进 theme/js/sidebar.js，三本书共用一份（此前各书一份、行为
   *    不一致，且与 mdBook 自带的大纲折叠钮互相打架，见该文件顶部说明）。 */

  /* ------------------------------------------------------------------ *
   * 返回教程库
   *
   * 三本书各自是独立站点：读者从导览首页（/tutorials/）点进来后，书里只有本书
   * 目录，翻到最后一章也没有回首页的入口，只能改地址栏或依赖浏览器后退。
   * 菜单栏右侧补一个「教程库」按钮，回到本书所在目录的上一级。
   *
   * 首页地址由当前路径推出，不写死域名：mdBook 把每本书发布在 /<slug>/ 之下，
   * 去掉本书 slug 及其后的所有片段，剩下的就是导览首页。于是 gh-pages 的
   * /tutorials/robot/ 与自定义域名根目录下的 /robot/ 都成立。
   * 本地 `mdbook serve` 预览时服务在站点根、路径里没有 slug，此时不插入按钮，
   * 免得点出一个 404。
   * ------------------------------------------------------------------ */
  var BOOK_SLUG = "robot";
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

    requestAnimationFrame(function () {
      requestAnimationFrame(function () { root.classList.add("matrix-ready"); });
    });
  }

  boot();
})();
