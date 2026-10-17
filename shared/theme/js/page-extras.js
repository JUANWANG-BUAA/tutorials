/*
 * page-extras — 三本书共用的「附加操作」实现（**一份**）
 * ---------------------------------------------------------------------------
 * 这些操作原先在 robot.js / na.js / matrix.js 里各写一遍，三份逐渐分叉（页内目录
 * 收 H2 还是 H2+H3、解答工具条放页首还是埋在解答框旁、宽公式提示只有一本有）。
 * 现在实现收在这里，各书的 <book>.js 只声明配置：
 *
 *   window.TUTORIALS_EXTRAS.boot({
 *     slug: "matrix",                     // 推导「返回教程库」的目标
 *     pageTocLevels: ["h2", "h3"],        // 页内目录收集哪几级标题
 *     toolbarPlacement: "top" | "inline", // 解答工具条：页首 / 第一个解答框旁
 *     formulaHint: true                   // 宽公式横向滚动提示
 *   });
 *
 * 为什么由各书显式调用而不是自己找时机启动：数值分析要在页内目录**之后**插「阅读
 * 分层」图例，matrix 要在目录之后放工具条——顺序是各书的编排，由书脚本来决定最清楚。
 * 本文件只提供函数与一个 boot() 组合，不假设 DOM 时机（脚本在 body 末尾，DOM 已就绪）。
 *
 * 加载顺序：book.toml 的 additional-js 里排在各书脚本**之前**（见 shared/README.md）。
 */
(function () {
  "use strict";

  var root = document.documentElement;
  var HOME_ICON = '<svg viewBox="0 0 576 512" aria-hidden="true"><path d="M575.8 255.5c0 18-15 32.1-32 32.1h-32l.7 160.2c0 2.7-.2 5.4-.5 8.1V472c0 22.1-17.9 40-40 40H456c-1.1 0-2.2 0-3.3-.1c-1.4 .1-2.8 .1-4.2 .1H416 392c-22.1 0-40-17.9-40-40V448 384c0-17.7-14.3-32-32-32H256c-17.7 0-32 14.3-32 32v64 16c0 22.1-17.9 40-40 40H160 128.1c-1.5 0-3-.1-4.5-.2c-1.2 .1-2.4 .2-3.6 .2H104c-22.1 0-40-17.9-40-40V360c0-.9 0-1.9 .1-2.8V287.6H32c-18 0-32-14-32-32.1c0-9 3-17 10-24L266.4 8c7-7 15-8 22-8s15 2 21 7L564.8 231.5c8 7 12 15 11 24z"/></svg>';

  /* ------------------------------------------------------------------ *
   * 阅读进度条（页顶一条细线）
   * ------------------------------------------------------------------ */
  function mountProgress() {
    if (document.getElementById("progress")) return;
    var framePending = false;
    var bar = document.createElement("div");
    bar.id = "progress";
    bar.setAttribute("aria-hidden", "true");
    document.body.appendChild(bar);

    function update() {
      var maximum = root.scrollHeight - root.clientHeight;
      bar.style.width = (maximum > 0 ? (root.scrollTop / maximum) * 100 : 0) + "%";
      framePending = false;
    }

    function schedule() {
      if (framePending) return;
      framePending = true;
      requestAnimationFrame(update);
    }

    window.addEventListener("scroll", schedule, { passive: true });
    window.addEventListener("resize", schedule, { passive: true });
    update();
  }

  /* ------------------------------------------------------------------ *
   * 页内目录（H2 / H3，跳过折叠块与语义盒里的标题；少于 3 条不建）
   * ------------------------------------------------------------------ */
  function headingText(heading) {
    if (!heading) return "";
    var clone = heading.cloneNode(true);
    var mathml = clone.querySelectorAll(".katex-mathml");
    for (var i = 0; i < mathml.length; i++) {
      if (mathml[i].parentNode) mathml[i].parentNode.removeChild(mathml[i]);
    }
    return (clone.textContent || "").replace(/\s+/g, " ").trim();
  }

  function buildPageToc(levels) {
    var main = document.querySelector("main");
    if (!main || main.querySelector(":scope > .page-toc")) return;
    var selector = (levels && levels.length ? levels : ["h2"]).join(", ");

    var headings = Array.prototype.filter.call(main.querySelectorAll(selector), function (heading) {
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

  /* ------------------------------------------------------------------ *
   * 解答工具条（展开 / 折叠全部解答）
   *   placement = "inline"：贴在第一个解答框旁（解答少、想就近操作）
   *   placement = "top"   ：放页首（页内目录或 H1 之后），进页面即可见
   * ------------------------------------------------------------------ */
  function buildSolutionToolbar(placement) {
    var solutions = document.querySelectorAll("details.sol-box");
    if (!solutions.length || document.querySelector(".sol-toolbar")) return;

    var toolbar = document.createElement("div");
    var button = document.createElement("button");
    var pending = false;
    toolbar.className = "sol-toolbar";
    button.type = "button";
    button.textContent = "展开全部解答";
    button.setAttribute("aria-pressed", "false");

    function sync() {
      var allOpen = Array.prototype.every.call(solutions, function (details) { return details.open; });
      button.textContent = allOpen ? "折叠全部解答" : "展开全部解答";
      button.setAttribute("aria-pressed", allOpen ? "true" : "false");
      pending = false;
    }

    function schedule() {
      if (pending) return;
      pending = true;
      requestAnimationFrame(sync);
    }

    button.addEventListener("click", function () {
      var shouldOpen = Array.prototype.some.call(solutions, function (details) { return !details.open; });
      solutions.forEach(function (details) { details.open = shouldOpen; });
      sync();
    });

    solutions.forEach(function (details) { details.addEventListener("toggle", schedule); });
    toolbar.appendChild(button);

    if (placement === "top") {
      var main = document.querySelector("main");
      var pageToc = main && main.querySelector(":scope > .page-toc");
      if (pageToc) { pageToc.insertAdjacentElement("afterend", toolbar); return; }
      var first = main && main.firstElementChild;
      if (first && first.tagName === "H1") { first.insertAdjacentElement("afterend", toolbar); return; }
      if (main) { main.insertBefore(toolbar, first); return; }
    }
    solutions[0].parentNode.insertBefore(toolbar, solutions[0]);
  }

  /* ------------------------------------------------------------------ *
   * 返回教程库（菜单栏右侧）
   *
   * 首页地址由当前路径推出，不写死域名：mdBook 把每本书发布在 /<slug>/ 之下，
   * 去掉本书 slug 及其后的所有片段就是导览首页；本地 `mdbook serve` 服务在站点根、
   * 路径里没有 slug 时返回 null（不插按钮，免得点出 404）。
   * ------------------------------------------------------------------ */
  function portalUrl(slug) {
    var segments = location.pathname.split("/").filter(Boolean);
    var index = segments.lastIndexOf(slug);
    if (index < 0) return null;
    return "/" + segments.slice(0, index).join("/") + (index > 0 ? "/" : "");
  }

  function buildPortalHome(slug) {
    var bar = document.getElementById("mdbook-menu-bar");
    var right = bar && bar.querySelector(".right-buttons");
    if (!right || right.querySelector(".portal-home")) return;
    var url = portalUrl(slug);
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

  /* ------------------------------------------------------------------ *
   * 宽公式横向滚动提示
   *   窄屏（或版心很宽时）行间公式会在 .katex-display 里横向滚动，却没有视觉线索。
   *   给可滚动的公式加 can-scroll / scrolled-start 两个类，CSS 画右缘渐隐与左缘
   *   渐显；滚到末端后去掉提示，避免「还有内容」的误导。
   * ------------------------------------------------------------------ */
  function monitorFormulaScroll() {
    function mark() {
      document.querySelectorAll(".katex-display").forEach(function (el) {
        var scrollable = el.scrollWidth > el.clientWidth + 4;
        el.classList.toggle("can-scroll", scrollable && el.scrollLeft + el.clientWidth < el.scrollWidth - 4);
        el.classList.toggle("scrolled-start", scrollable && el.scrollLeft > 4);
      });
    }

    function watch(event) {
      var el = event.target && event.target.closest ? event.target.closest(".katex-display") : null;
      if (!el) return;
      var scrollable = el.scrollWidth > el.clientWidth + 4;
      el.classList.toggle("can-scroll", scrollable && el.scrollLeft + el.clientWidth < el.scrollWidth - 4);
      el.classList.toggle("scrolled-start", scrollable && el.scrollLeft > 4);
    }

    mark();
    // 公式宽度在字体就绪、折叠解答展开后才会定型，两处都补测一次
    if (document.fonts && document.fonts.ready) document.fonts.ready.then(mark);
    document.addEventListener("toggle", function (event) {
      if (event.target && event.target.tagName === "DETAILS") setTimeout(mark, 0);
    }, true);
    document.addEventListener("scroll", watch, { passive: true, capture: true });
    var resizePending = false;
    window.addEventListener("resize", function () {
      if (resizePending) return;
      resizePending = true;
      requestAnimationFrame(function () { resizePending = false; mark(); });
    }, { passive: true });
  }

  /* ------------------------------------------------------------------ *
   * 组合启动：按配置跑一遍，最后摘掉「冷启动守卫」
   * ------------------------------------------------------------------ */
  function markReady() {
    requestAnimationFrame(function () {
      requestAnimationFrame(function () { root.classList.add("tutorials-ready"); });
    });
  }

  function boot(config) {
    var options = config || {};
    if (root.dataset.tutorialsBooted) return;
    root.dataset.tutorialsBooted = "true";
    try { mountProgress(); } catch (error) { /* 纯增益，出错不拖垮页面 */ }
    try { buildPageToc(options.pageTocLevels); } catch (error) { /* 同上 */ }
    try { buildSolutionToolbar(options.toolbarPlacement || "inline"); } catch (error) { /* 同上 */ }
    try { buildPortalHome(options.slug); } catch (error) { /* 同上 */ }
    if (options.formulaHint) {
      try { monitorFormulaScroll(); } catch (error) { /* 同上 */ }
    }
    markReady();
  }

  window.TUTORIALS_EXTRAS = {
    boot: boot,
    mountProgress: mountProgress,
    buildPageToc: buildPageToc,
    buildSolutionToolbar: buildSolutionToolbar,
    buildPortalHome: buildPortalHome,
    monitorFormulaScroll: monitorFormulaScroll,
    markReady: markReady
  };
})();
