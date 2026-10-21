/*
 * framework-nav — 导航与进度：侧栏折叠 / 左侧幽灵大纲 / 已读与继续阅读
 * ---------------------------------------------------------------------------
 * 本文件是 shared/theme/js/framework-*.js 之一：framework.js 原先 1050 行、十项职责
 * 挤在一个 IIFE 里，现按内聚拆为四份（core / nav / media / text），共享工具由 core 通过
 * window.TUTORIALS_CORE 暴露，各模块用 CORE.register(boot) 注册自己的启动钩子。
 * 导航与进度：侧栏折叠 / 左侧幽灵大纲 / 已读与继续阅读
 */
(function () {
  "use strict";

  var CORE = window.TUTORIALS_CORE;
  if (!CORE) return;      /* core 必须先加载（book.toml 的 additional-js 顺序保证） */

  /* ------------------------------------------------------------------ *
   * 侧栏章节树的折叠
   *
   * mdBook 0.5 的 toc.js 把折叠阈值写死成 foldLevel = 3，且只在「本页大纲」里
   * 给「H3 后面跟着 H4」这类深层嵌套生成折叠钮；章节树本身没有任何折叠入口。
   * 三本书的 H4 一共 4 个（章节树一个也用不上），于是侧栏永远是摊开的一整墙，
   * 读者点第二下也无处可点。
   *
   * 这里给带子目录的章节条目补一枚 chevron，复用 mdBook 的
   * `.chapter li:not(.expanded) > ol{display:none}` 折叠机制。按钮用原生 button，
   * 由 base.css 清掉浏览器默认控件皮肤，再沿用 mdBook 的箭头旋转与右对齐。
   * 状态按本书与章节的规范化 URL 存 localStorage，默认展开。
   *
   * 与原生大纲钮的关系：mdBook 自己的处理器用 ev.currentTarget.parentElement
   * .parentElement 找目标，且在侧栏元素升级时就一次性绑好（那时我们的钮还不
   * 存在），所以两者互不触发；这里也只接管章节条目上的钮，.header-toggle 一律放过。
   * ------------------------------------------------------------------ */
  var SIDEBAR_FOLD_PREFIX = "tutorials-sidebar:";

  function chapterGroups() {
    var box = document.getElementById("mdbook-sidebar");
    if (!box) return [];
    return Array.prototype.filter.call(box.querySelectorAll("li.chapter-item"), function (li) {
      return li.querySelector(":scope > .chapter-link-wrapper > a[href]") &&
        li.querySelector(":scope > ol.section");
    });
  }

  function chapterFoldKey(li) {
    var a = li.querySelector(":scope > .chapter-link-wrapper > a[href]");
    var href = a ? a.getAttribute("href") : "";
    var path = href;
    try { path = new URL(href || ".", location.href).pathname; } catch (e) { /* 用相对路径回落 */ }
    var root = bookRoot();
    var relative = path.indexOf(root) === 0 ? path.slice(root.length) : path;
    return SIDEBAR_FOLD_PREFIX + root + relative;
  }

  function chapterChevron() {
    var button = document.createElement("button");
    button.type = "button";
    button.className = "chapter-fold-toggle";
    var icon = document.createElement("div");
    icon.setAttribute("aria-hidden", "true");
    icon.textContent = "❱";
    button.appendChild(icon);
    return button;
  }

  function syncChevron(li, toggle) {
    var open = li.classList.contains("expanded");
    toggle.setAttribute("aria-expanded", open ? "true" : "false");
    toggle.setAttribute("aria-label", open ? "折叠此章节的子目录" : "展开此章节的子目录");
    toggle.setAttribute("title", open ? "折叠" : "展开");
  }

  function injectChapterChevrons() {
    chapterGroups().forEach(function (li) {
      var wrapper = li.querySelector(":scope > .chapter-link-wrapper");
      if (!wrapper) return;
      var section = li.querySelector(":scope > ol.section");
      var toggle = wrapper.querySelector(":scope > .chapter-fold-toggle");
      if (!toggle) {
        toggle = chapterChevron();
        wrapper.appendChild(toggle);
      }
      if (section) {
        if (!section.id) {
          var sectionId = chapterFoldKey(li).replace(/[^a-z0-9_-]+/gi, "-").replace(/^-+|-+$/g, "");
          section.id = "sidebar-section-" + sectionId;
        }
        toggle.setAttribute("aria-controls", section.id);
      }
      var saved = CORE.store(chapterFoldKey(li));
      var currentPage = Boolean(li.querySelector("a.active"));
      /* mdBook expands the active page's ancestors before this module runs. Keep that
         guarantee even when an older saved state says "closed", so the active entry
         cannot disappear from the sidebar after navigation. */
      if (currentPage) li.classList.add("expanded");
      else if (saved === "0") li.classList.remove("expanded");
      else if (saved === "1") li.classList.add("expanded");
      syncChevron(li, toggle);
    });
  }

  function wireChapterFold() {
    var box = document.getElementById("mdbook-sidebar");
    if (!box || box.dataset.foldWired === "1") return;
    box.dataset.foldWired = "1";

    /* 捕获阶段统一处理：mdBook 的处理器在目标阶段，这里先判定并停住，
       避免两套折叠逻辑各自改不同的 li。只认章节条目，放过 .header-toggle。 */
    box.addEventListener("click", function (event) {
      var toggle = event.target.closest ? event.target.closest(".chapter-fold-toggle") : null;
      if (!toggle || toggle.classList.contains("header-toggle")) return;
      var li = toggle.closest("li.chapter-item");
      if (!li) return;
      event.preventDefault();
      event.stopPropagation();
      var open = li.classList.toggle("expanded");
      syncChevron(li, toggle);
      if (open) CORE.save(chapterFoldKey(li), "1");
      else CORE.save(chapterFoldKey(li), "0");
    }, true);
  }

  function bootChapterFold() {
    try {
      injectChapterChevrons();
      wireChapterFold();
    } catch (e) { /* 侧栏结构升级后静默降级，不影响阅读 */ }
  }

  /* ------------------------------------------------------------------ *
   * 已读进度与「继续阅读」
   *
   * 课程型教程不像手册那样随便翻：读者需要知道「哪几节读过、上次读到哪」。
   * 按本书分别存 localStorage：
   *   tutorials-read:<本书根路径>  已访问页面路径集合（侧栏条目上点一颗小圆点）
   *   tutorials-last:<本书根路径>  最后一页的路径与标题（导览页的「继续阅读」卡片）
   * 书籍根路径取自 mdBook 注入的 path_to_root，故 gh-pages（/tutorials/matrix/）
   * 与本地 serve（/matrix/）都不写死。
   * ------------------------------------------------------------------ */
  function bookRoot() {
    try {
      if (typeof path_to_root === "string") return new URL(path_to_root || "./", location.href).pathname;
    } catch (e) { /* 老版本没有该变量时回落到路径推推 */ }
    return location.pathname.replace(/[^/]*$/, "");
  }

  function readStore(key) {
    try {
      var value = JSON.parse(CORE.store(key) || "{}");
      return value && typeof value === "object" && !Array.isArray(value) ? value : {};
    } catch (e) { return {}; }
  }

  function pageTitle() {
    var h1 = document.querySelector(".content h1");
    if (h1) return (h1.querySelector("a.header") || h1).textContent.trim();
    var active = document.querySelector("#mdbook-sidebar a.active");
    return active ? active.textContent.trim() : document.title;
  }

  function markVisited() {
    var key = "tutorials-read:" + bookRoot();
    var seen = readStore(key);
    if (seen[location.pathname] !== 1) {
      seen[location.pathname] = 1;
      CORE.save(key, JSON.stringify(seen));
    }
    /* 导览页（本书根）不当「上次读到哪」：它是入口，进本页就会把记录覆盖成自己，
       于是「继续阅读」永远指向导览页。 */
    if (!/(\/|index\.html)$/.test(location.pathname)) {
      CORE.save("tutorials-last:" + bookRoot(), JSON.stringify({ path: location.pathname, title: pageTitle() }));
    }
  }

  function paintReadDots() {
    var box = document.getElementById("mdbook-sidebar");
    if (!box) return;
    var seen = readStore("tutorials-read:" + bookRoot());
    box.querySelectorAll("li.chapter-item > .chapter-link-wrapper > a[href]").forEach(function (a) {
      var path;
      try { path = new URL(a.getAttribute("href"), location.href).pathname; } catch (e) { return; }
      var li = a.closest("li.chapter-item");
      if (li && seen[path] === 1) li.classList.add("is-read");
    });
  }

  function buildContinueCard() {
    var main = document.querySelector("main");
    if (!main || main.querySelector(".continue-card")) return;
    var here = location.pathname;
    if (!/(\/|index\.html)$/.test(here)) return;      /* 只在本书导览页出现 */
    var last = readStore("tutorials-last:" + bookRoot());
    if (typeof last.path !== "string" || last.path === here) return;
    var seen = readStore("tutorials-read:" + bookRoot());
    var box = document.getElementById("mdbook-sidebar");
    var paths = new Set();
    if (box) box.querySelectorAll("li.chapter-item > .chapter-link-wrapper > a[href]").forEach(function (a) {
      paths.add(new URL(a.getAttribute("href"), location.href).pathname);
    });
    if (!paths.has(last.path)) return;
    var total = paths.size;
    var readCount = Array.from(paths).filter(function (path) { return seen[path] === 1; }).length;

    var card = document.createElement("aside");
    card.className = "continue-card";
    var kicker = document.createElement("span");
    kicker.className = "continue-kicker";
    kicker.textContent = "继续阅读";
    var link = document.createElement("a");
    link.className = "continue-link";
    link.href = last.path + (typeof last.hash === "string" && last.hash[0] === "#" ? last.hash : "");
    link.textContent = last.title || "上次读到的那一节";
    card.appendChild(kicker);
    card.appendChild(link);
    if (total > 0) {
      var meta = document.createElement("span");
      meta.className = "continue-meta";
      meta.textContent = "已读 " + readCount + " / " + total + " 节";
      var bar = document.createElement("span");
      bar.className = "continue-bar";
      var fill = document.createElement("i");
      fill.style.width = Math.min(100, Math.round(readCount / total * 100)) + "%";
      bar.appendChild(fill);
      card.appendChild(meta);
      card.appendChild(bar);
    }
    // 放在封面区块之后、正文第一节之前
    var anchor = main.querySelector(":scope > h2");
    if (anchor && anchor.parentElement === main) main.insertBefore(card, anchor);
    else main.appendChild(card);
  }

  /* 导览页的入口卡片同样标「已读」：与侧栏小圆点同一份数据，读者一眼能看出
     哪几张卡已经走过（不占位，绝对定位在卡片右上角）。 */
  function paintReadBadges() {
    var seen = readStore("tutorials-read:" + bookRoot());
    document.querySelectorAll(".index-cards a[href]").forEach(function (a) {
      var path;
      try { path = new URL(a.getAttribute("href"), location.href).pathname; } catch (e) { return; }
      if (seen[path] === 1) a.classList.add("is-read");
    });
  }

  function bootReadingProgress() {
    if (/\/(print|404)\.html$/.test(location.pathname)) return;
    markVisited();
    paintReadDots();
    paintReadBadges();
    buildContinueCard();
    if (!/(\/|index\.html)$/.test(location.pathname)) {
      var remember = function () {
        var hash = location.hash;
        document.querySelectorAll("main h2[id], main h3[id]").forEach(function (heading) {
          if (heading.getBoundingClientRect().top <= 120 && !heading.closest("details:not([open])")) hash = "#" + encodeURIComponent(heading.id);
        });
        CORE.save("tutorials-last:" + bookRoot(), JSON.stringify({ path: location.pathname, title: pageTitle(), hash: hash }));
      };
      window.addEventListener("pagehide", remember);
      document.addEventListener("visibilitychange", function () { if (document.hidden) remember(); });
    }
  }

  /* ------------------------------------------------------------------ *
   * 右侧粘性「本页大纲」
   *
   * mdBook 的大纲在侧栏里（跟着整本书的树），长文往下滚时看不见；VitePress、
   * bevy-cheatbook、官方 rust-book 都是右栏跟随。这里补一条左栏：
   *   · 条目取自正文 h2 / h3（跳过折叠块与语义盒里的标题，与「本页内容」同规则）；
   *   · **仅在左侧目录收起、且正文左侧真有空余时出现**（≥600px 视口高）——版心调宽、
   *     侧栏切换、窗口变窄都会重算，不够就整条让位，不挤正文；
   *   · 出现时正文顶部的「本页内容」隐藏（同一个信息不要两处），收起时回来；
   *   · 滚动跟随高亮用 rAF 节流，不用 IntersectionObserver 的多次触发（长页更稳）。
   * ------------------------------------------------------------------ */
  /* 左栏的「实际占地」= 自身宽度 + 距视口左缘的距离 + 与正文之间的间距。
     必须按实际占地判断余量；CSS 采用 border-box，避免 padding 额外撑开左栏，
     余量不足时整栏隐藏，避免压住正文或贴到屏幕边缘。
     宽度的唯一来源是 CSS 里的 #page-rail（--rail-width），这里只读它，不再硬编码。 */
  var RAIL_MIN_HEIGHT = 600;

  /* 左栏的「实际占地」= --rail-width + --rail-left-gap + --rail-text-gap，三个值都由
     framework.css 声明（唯一来源）。**不能**去量元素宽度：左栏隐藏时 display:none，
     量出来是 0，余量判定会退化成 46px，于是在 1280px 这种「差一点点」的宽度上
     照样显示、压住正文——这正是「大纲遮挡正文、右端顶到屏幕」的成因。 */
  function railFootprint() {
    var cs = getComputedStyle(document.documentElement);
    var px = function (name, fallback) {
      var raw = parseFloat(cs.getPropertyValue(name));
      return isNaN(raw) ? fallback : raw;
    };
    return px("--rail-width", 190) + px("--rail-left-gap", 24) + px("--rail-text-gap", 24);
  }
  var railFrame = false;
  var railLayoutTimer = 0;

  function railHeadings() {
    var main = document.querySelector("main");
    if (!main) return [];
    return Array.prototype.filter.call(main.querySelectorAll("h2, h3"), function (heading) {
      if (heading.closest("details, .box")) return false;
      var anchor = heading.querySelector("a.header");
      if (!anchor) return false;
      return Boolean(heading.id || anchor.getAttribute("href"));
    });
  }

  function sidebarIsCollapsed() {
    var toggle = document.getElementById("mdbook-sidebar-toggle-anchor");
    return Boolean(toggle && !toggle.checked);
  }

  function railHasRoom() {
    var main = document.querySelector("main");
    if (!main || !sidebarIsCollapsed()) return false;
    if (window.innerHeight < RAIL_MIN_HEIGHT) return false;
    return main.getBoundingClientRect().left >= railFootprint();
  }

  function headingText(heading) {
    if (!heading) return "";
    var clone = heading.cloneNode(true);
    var mathml = clone.querySelectorAll(".katex-mathml");
    for (var i = 0; i < mathml.length; i++) {
      if (mathml[i].parentNode) mathml[i].parentNode.removeChild(mathml[i]);
    }
    return (clone.textContent || "").replace(/\s+/g, " ").trim();
  }

  function buildPageRail() {
    var headings = railHeadings();
    if (headings.length < 3) return;
    var rail = document.getElementById("page-rail");
    if (!rail) {
      rail = document.createElement("nav");
      rail.id = "page-rail";
      rail.className = "page-rail";
      rail.setAttribute("aria-label", "本页大纲");
      var title = document.createElement("span");
      title.className = "page-rail-title";
      title.textContent = "ON THIS PAGE / 本节";
      rail.appendChild(title);
      document.body.appendChild(rail);
    }
    Array.prototype.forEach.call(rail.querySelectorAll("a"), function (a) { a.remove(); });
    headings.forEach(function (heading) {
      var anchor = heading.querySelector("a.header");
      var target = heading.id || (anchor.getAttribute("href") || "").replace(/^#/, "");
      var link = document.createElement("a");
      link.href = anchor.getAttribute("href");
      link.textContent = headingText(heading);
      if (heading.tagName === "H3") link.className = "page-rail-h3";
      link.dataset.railTarget = target;
      rail.appendChild(link);
    });
    syncPageRail();
  }

  function railTrigger() {
    var toc = document.querySelector(".page-toc");
    if (!toc) return 240;
    var rect = toc.getBoundingClientRect();
    return window.scrollY + rect.bottom - 80;
  }

  function syncRailVisibility() {
    document.documentElement.classList.toggle("rail-visible", window.scrollY > railTrigger());
  }

  function paintRailCurrent() {
    var rail = document.getElementById("page-rail");
    if (!rail) return;
    var links = Array.prototype.slice.call(rail.querySelectorAll("a"));
    if (!links.length) return;
    var current = null;
    links.forEach(function (link) {
      var heading = link.dataset.railTarget ? document.getElementById(link.dataset.railTarget) : null;
      if (!heading) return;
      if (heading.getBoundingClientRect().top <= 120) current = link;
    });
    links.forEach(function (link) { link.classList.toggle("is-current", link === current); });
  }

  function syncPageRail() {
    var rail = document.getElementById("page-rail");
    if (!rail) return;
    var room = railHasRoom();
    if (room) {
      var main = document.querySelector("main");
      var cs = getComputedStyle(document.documentElement);
      var width = parseFloat(cs.getPropertyValue("--rail-width")) || 190;
      var gap = parseFloat(cs.getPropertyValue("--rail-left-gap")) || 24;
      var left = Math.max(gap, main.getBoundingClientRect().left - width - gap);
      document.documentElement.style.setProperty("--rail-left", left + "px");
      document.documentElement.classList.add("has-page-rail");
      syncRailVisibility();
      paintRailCurrent();
    } else {
      document.documentElement.classList.remove("has-page-rail");
      document.documentElement.classList.remove("rail-visible");
    }
  }

  function bootPageRail() {
    if (!document.querySelector("main")) return;
    buildPageRail();
    syncPageRail();
    if (window.__railBound) return;
    window.__railBound = true;
    window.addEventListener("scroll", function () {
      if (!document.documentElement.classList.contains("has-page-rail")) return;
      if (railFrame) return;
      railFrame = true;
      requestAnimationFrame(function () { railFrame = false; syncRailVisibility(); paintRailCurrent(); });
    }, { passive: true });
    window.addEventListener("resize", syncPageRail, { passive: true });
    // 版心宽度等偏好变化后重新算余量（prefs.js 在应用后派发该事件）
    document.addEventListener("tutorials:prefs", syncPageRail);
    // mdBook 的侧栏由隐藏 checkbox 驱动。监听 change 修复「收起后本页大纲仍不出现」；
    // 动画结束后再测一次，避免按过渡中的正文右缘作出错误空间判断。
    var sidebarToggle = document.getElementById("mdbook-sidebar-toggle-anchor");
    if (sidebarToggle) sidebarToggle.addEventListener("change", function () {
      window.clearTimeout(railLayoutTimer);
      syncPageRail();
      railLayoutTimer = window.setTimeout(syncPageRail, 360);
    });
  }

  function bootMenuCurrent() {
    var title = document.querySelector("#mdbook-menu-bar .menu-title");
    if (!title || title.querySelector(".menu-book")) return;
    var headings = railHeadings();
    if (!headings.length) return;

    var bookText = (title.textContent || "").replace(/\s+/g, " ").trim();
    title.textContent = "";
    var book = document.createElement("span");
    book.className = "menu-book";
    book.textContent = bookText;
    var current = document.createElement("span");
    current.className = "menu-current";
    var no = document.createElement("span");
    no.className = "mc-no";
    var txt = document.createElement("span");
    txt.className = "mc-text";
    current.appendChild(no);
    current.appendChild(txt);
    title.appendChild(book);
    title.appendChild(current);

    var last = "";
    function paint() {
      var active = null;
      headings.forEach(function (heading) {
        if (heading.getBoundingClientRect().top <= 140) active = heading;
      });
      if (!active) {
        if (last !== "") {
          document.documentElement.classList.remove("has-menu-current");
          last = "";
        }
        return;
      }
      var label = headingText(active);
      if (!label || label === last) return;
      last = label;
      var m = label.match(/^(\d+(?:\.\d+)+)\s+(.*)$/);
      no.textContent = m ? "§ " + m[1] : "";
      txt.textContent = m ? m[2] : label;
      document.documentElement.classList.add("has-menu-current");
    }

    var frame = false;
    function schedule() {
      if (frame) return;
      frame = true;
      requestAnimationFrame(function () { frame = false; paint(); });
    }
    window.addEventListener("scroll", schedule, { passive: true });
    window.addEventListener("resize", schedule, { passive: true });
    document.addEventListener("tutorials:prefs", schedule);
    var toggle = document.getElementById("mdbook-sidebar-toggle-anchor");
    if (toggle) toggle.addEventListener("change", function () {
      window.setTimeout(schedule, 360);
    });
    paint();
  }

  function bootForeEdgeTabs() {
    var sidebar = document.getElementById("mdbook-sidebar");
    if (!sidebar) return;
    var links = Array.prototype.filter.call(
      sidebar.querySelectorAll("ol.chapter > li.chapter-item > .chapter-link-wrapper > a"),
      function (a) {
        var t = (a.textContent || "").replace(/\s+/g, " ").trim();
        return /^第/.test(t) && !/章末|讲末/.test(t);
      }
    );
    if (links.length < 2) return;
    var nav = document.createElement("nav");
    nav.className = "fore-edge-tabs";
    nav.setAttribute("aria-label", "章目录");
    var active = sidebar.querySelector("a.active");
    links.forEach(function (a, i) {
      var tab = document.createElement("a");
      tab.className = "fore-edge-tab";
      tab.href = a.getAttribute("href");
      var label = (a.textContent || "").replace(/\s+/g, " ").trim();
      tab.textContent = ("0" + (i + 1)).slice(-2);
      tab.title = label;
      tab.setAttribute("aria-label", label);
      var holder = a.closest("li");
      if (active && holder && holder.contains(active)) tab.classList.add("is-current");
      nav.appendChild(tab);
    });
    document.body.appendChild(nav);
    function sync() {
      var show = sidebarIsCollapsed() && window.innerWidth >= 1200;
      document.documentElement.classList.toggle("has-fore-edge-tabs", show);
    }
    window.addEventListener("resize", sync, { passive: true });
    var toggle = document.getElementById("mdbook-sidebar-toggle-anchor");
    if (toggle) toggle.addEventListener("change", function () {
      window.setTimeout(sync, 360);
    });
    sync();
  }

  function bootThemeOverlay() {
    var list = document.getElementById("mdbook-theme-list");
    if (!list) return;
    function sync() {
      var open = getComputedStyle(list).display !== "none";
      document.documentElement.classList.toggle("theme-popup-open", open);
      if (!open || !toggle) return;
      var bar = document.getElementById("mdbook-menu-bar");
      var rect = toggle.getBoundingClientRect();
      var width = list.offsetWidth || 100;
      var left = Math.max(8, Math.min(rect.left + rect.width / 2 - width / 2, window.innerWidth - width - 8));
      // This function observes style mutations: only write actual changes.
      var placement = { position: "fixed", right: "auto", left: Math.round(left) + "px",
        top: Math.round((bar ? bar.getBoundingClientRect().bottom : 58) + 2) + "px" };
      Object.keys(placement).forEach(function (key) {
        if (list.style[key] !== placement[key]) list.style[key] = placement[key];
      });
    }
    var toggle = document.getElementById("mdbook-theme-toggle");
    if (toggle) toggle.addEventListener("click", function () { window.setTimeout(sync, 0); });
    window.addEventListener("resize", function () { if (getComputedStyle(list).display !== "none") sync(); }, { passive: true });
    if (window.MutationObserver) new MutationObserver(sync).observe(list, { attributes: true, attributeFilter: ["style", "class", "hidden"] });
    document.addEventListener("click", function (event) {
      window.setTimeout(sync, 0);
      if (getComputedStyle(list).display === "none") return;
      if (list.contains(event.target) || (toggle && toggle.contains(event.target))) return;
      list.style.display = "none";
      if (toggle) toggle.setAttribute("aria-expanded", "false");
    }, true);
    sync();
  }

  function bootUiSuppression() {
    var root = document.documentElement;
    var prefs = document.getElementById("prefs-toggle");
    var search = document.getElementById("mdbook-searchbar");
    function sync() {
      var open = false;
      var currentPrefs = document.getElementById("prefs-toggle");
      var currentSearch = document.getElementById("mdbook-searchbar");
      if (currentPrefs && currentPrefs.getAttribute("aria-expanded") === "true") open = true;
      if (document.querySelector("dialog[open]")) open = true;
      if (currentSearch && currentSearch.contains(document.activeElement)) open = true;
      root.classList.toggle("ui-suppressed", open);
    }
    document.addEventListener("click", function () { window.setTimeout(sync, 0); });
    document.addEventListener("focusin", function () { window.setTimeout(sync, 0); });
    document.addEventListener("focusout", function () { window.setTimeout(sync, 0); });
    document.addEventListener("toggle", sync, true);
    if (window.MutationObserver && prefs) new MutationObserver(sync).observe(prefs, { attributes: true, attributeFilter: ["aria-expanded"] });
    sync();
  }

  CORE.register(function () {
    try { bootChapterFold(); } catch (e) { /* 纯增益 */ }
    try { bootReadingProgress(); } catch (e) { /* 纯增益 */ }
    try { bootPageRail(); } catch (e) { /* 纯增益 */ }
    try { bootMenuCurrent(); } catch (e) { /* 纯增益 */ }
    try { bootForeEdgeTabs(); } catch (e) { /* 纯增益 */ }
    try { bootThemeOverlay(); } catch (e) { /* 纯增益 */ }
    try { bootUiSuppression(); } catch (e) { /* 纯增益 */ }
  });
})();
