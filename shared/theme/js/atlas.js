/*
 * atlas.js — 教程库的「图鉴」交互层（四本共用一份）
 * ---------------------------------------------------------------------------
 * 职责（全部是渐进增强，禁用 JS 时页面仍然完整可读）：
 *   1. 识别当前书（html[data-book]），让页首印记与书脊色跟随本书。
 *   2. 给 Markdown 原生的 ![]() 插图自动套上图鉴卡片与图注（robot/matrix 的课堂原片）。
 *   3. 注入页首「书系 / 章节」眉标与阅读元信息（约 X 分钟 · 图 N · 式 N）。
 *   4. 菜单栏「图鉴」按钮 + 全页插图画廊（点击卡片跳回原图）。
 *   5. 书首页 3D 书封的鼠标视差。
 *
 * 设计约束：
 *   · 不请求网络、不依赖第三方库；
 *   · 所有节点都带可访问名称；图鉴画廊用原生 <dialog>，Esc / 焦点返回交给浏览器；
 *   · 不移动正文段落中的行内图片（只包裹独占一段的图片），避免改变阅读流。
 */
(function () {
  "use strict";

  var root = document.documentElement;
  var BOOKS = {
    robot: "机器人控制技术",
    matrix: "矩阵论",
    numerical: "数值分析",
    deeplearning: "深度学习导论",
    linux: "Linux 系统与内核",
    "agent-systems": "Agent 系统工程",
    distributed: "分布式系统与数据面",
    compilers: "编译器与程序分析"
  };
  var book = detectBook();
  if (book) root.setAttribute("data-book", book);

  function detectBook() {
    var segments = location.pathname.split("/").filter(Boolean);
    for (var i = segments.length - 1; i >= 0; i--) {
      if (Object.prototype.hasOwnProperty.call(BOOKS, segments[i])) return segments[i];
    }
    return null;
  }

  function text(node) {
    if (!node) return "";
    var clone = node.cloneNode(true);
    var mathml = clone.querySelectorAll(".katex-mathml");
    for (var i = 0; i < mathml.length; i++) {
      if (mathml[i].parentNode) mathml[i].parentNode.removeChild(mathml[i]);
    }
    return (clone.textContent || "").replace(/\s+/g, " ").trim();
  }

  function bookTitle() {
    if (book) return BOOKS[book];
    var menu = document.querySelector("#mdbook-menu-bar .menu-title");
    var title = text(menu ? (menu.querySelector(".menu-book") || menu) : null);
    if (title) return title.replace(/\s*·\s*定制教程$/, "");
    return text(document.title).split(/\s+-\s+/)[0] || "教程";
  }

  function partTitleFor(link) {
    /* mdBook 的目录是多层嵌套：
       ol.chapter > li.part-title + li.chapter-item > ol.section > li.chapter-item > a.active
       当前小节在 ol.section 里，所属章的标题在外层 li 的前一个兄弟 part-title。
       逐层向上找，比只检查直接前兄弟可靠。 */
    var li = link.closest("li");
    var section = li ? li.closest("ol.section") : null;
    while (section) {
      var holder = section.parentElement ? section.parentElement.closest("li") : null;
      if (!holder) break;
      var node = holder.previousElementSibling;
      while (node) {
        if (node.classList && node.classList.contains("part-title")) return text(node);
        node = node.previousElementSibling;
      }
      section = holder.closest("ol.section");
    }
    return "";
  }

  function chapterLabel() {
    var active = document.querySelector("#mdbook-sidebar a.active");
    if (!active) return "";
    return partTitleFor(active);
  }

  /* ------------------------------------------------------------------ *
   * 1  图注 & 卡片
   * ------------------------------------------------------------------ */
  var figureCount = 0;

  function wrapWideSvgs() {
    document.querySelectorAll("main figure > svg").forEach(function (svg) {
      var width = svg.viewBox && svg.viewBox.baseVal.width;
      if (width < 600 || !width) return;
      var figure = svg.parentElement;
      var scroll = document.createElement("div");
      scroll.className = "fig-scroll";
      scroll.tabIndex = 0;
      scroll.setAttribute("role", "region");
      scroll.setAttribute("aria-label", "插图，可左右滚动查看");
      scroll.addEventListener("keydown", function (event) {
        if (/^Arrow/.test(event.key)) event.stopPropagation();
      });
      figure.insertBefore(scroll, svg);
      scroll.appendChild(svg);
      figure.classList.add("has-fig-scroll");
    });
  }

  function imageBlock(img) {
    /* mdBook 0.5 把 Markdown 图片包成原生灯箱：
       p > label.checkbox-label > [input + img + span.img-wrapper > img]
       外层 img 是缩略图，span 里的 img 是放大层。整块 label 才是一张图。 */
    var label = img.closest("label.checkbox-label");
    if (label) return label;
    return img;
  }

  function isStandaloneImage(img) {
    if (img.closest(".img-wrapper")) return false;
    var block = imageBlock(img);
    var parent = block.parentElement;
    if (!parent) return false;
    if (parent.querySelector("figure")) return false;
    /* 大多数图在 p 里；少数经过自定义盒子的图会被 mdBook 输出成
       main 下的裸 <img>。裸图同样应该进图注/图鉴，否则图号统计为 0，
       也没有原生灯箱。 */
    if (parent.tagName !== "P") return parent.tagName === "MAIN" || parent.classList.contains("content");
    var clone = parent.cloneNode(true);
    clone.querySelectorAll("img,input,label.checkbox-label,span.img-wrapper").forEach(function (node) { node.remove(); });
    return text(clone) === "";
  }

  function captionFromAlt(alt) {
    var value = (alt || "").replace(/\s+/g, " ").trim();
    if (!value) return "";
    return value;
  }

  function wrapImages() {
    var main = document.querySelector("main");
    if (!main) return;
    var images = Array.prototype.slice.call(main.querySelectorAll("img"));
    images.forEach(function (img) {
      if (img.closest("figure")) return;
      if (img.closest(".katex, .katex-display, #mdbook-search-wrapper")) return;
      if (!isStandaloneImage(img)) return;

      var block = imageBlock(img);

      /* mdBook 原生灯箱是 CSS 的 fixed 层，但会被 .page-wrapper 的 isolation
         和进场 transform 夹在正文层里，压在侧栏/菜单下面。这里拆掉 label、
         只留一张图，统一交给 framework-media 的 <dialog> 灯箱（top layer）。 */
      if (block.tagName === "LABEL") {
        var direct = block.querySelector(":scope > img");
        if (!direct) return;
        block.replaceWith(direct);
        block = direct;
      }

      var container = block.parentElement;
      var figure = document.createElement("figure");
      figure.className = "fig-image figure-in";
      var src = img.getAttribute("src") || "";
      if (/\/assets\//.test(src)) figure.classList.add("fig-slide");

      var caption = captionFromAlt(img.getAttribute("alt"));

      if (container.tagName === "P") {
        container.parentNode.insertBefore(figure, container);
      } else {
        container.insertBefore(figure, block);
      }
      figure.appendChild(block);
      if (container.tagName === "P" && text(container) === "") container.remove();

      if (caption) {
        var cap = document.createElement("figcaption");
        cap.appendChild(document.createTextNode(caption));
        figure.appendChild(cap);
      }
    });
  }

  function decorateExistingFigures() {
    var main = document.querySelector("main");
    if (!main) return;
    var figures = main.querySelectorAll("figure");
    Array.prototype.forEach.call(figures, function (figure, index) {
      figure.dataset.figIndex = String(index + 1);
      if (!figure.id) figure.id = "fig-" + (index + 1);
      var cap = figure.querySelector("figcaption");
      if (!cap) {
        cap = document.createElement("figcaption");
        var alt = figure.querySelector("img");
        cap.textContent = alt ? (alt.getAttribute("alt") || "插图") : "插图";
        figure.appendChild(cap);
      }
      if (!cap.querySelector(".fig-index")) {
        var badge = document.createElement("span");
        badge.className = "fig-index";
        badge.textContent = figure.classList.contains("fig-slide") || figure.querySelector("img") ? "原片" : "图解";
        cap.insertBefore(badge, cap.firstChild);
      }
      // 让每张图都能被深链引用
      figure.dataset.zoomable = figure.dataset.zoomable || "0";
    });
    figureCount = figures.length;
  }

  /* ------------------------------------------------------------------ *
   * 2  页首眉标与阅读元信息
   * ------------------------------------------------------------------ */
  function countReading() {
    var main = document.querySelector("main");
    if (!main) return { chars: 0, minutes: 1, figures: 0, formulas: 0 };
    var clone = main.cloneNode(true);
    clone.querySelectorAll("script,style,figure,nav,.page-toc,.sol-toolbar,.continue-card,.lesson-brief,.box-tag,.proof,.katex-mathml").forEach(function (node) {
      node.remove();
    });
    var raw = (clone.textContent || "").replace(/\s+/g, "");
    var cjk = (raw.match(/[\u3400-\u9fff]/g) || []).length;
    var latin = (raw.match(/[A-Za-z0-9]+/g) || []).length;
    // 中文按 380 字/分钟，英文按 220 词/分钟；再加入公式/图的停顿。
    var minutes = Math.max(1, Math.round(cjk / 380 + latin / 220 + figureCount * 0.35));
    return {
      chars: cjk,
      minutes: minutes,
      figures: figureCount,
      formulas: main.querySelectorAll(".katex-display").length
    };
  }

  function sectionIndex(raw) {
    var value = (raw || "").trim();
    var numeric = value.match(/^(\d+(?:\.\d+){0,2})/);
    if (numeric) return numeric[1];
    var map = { "一":"01","二":"02","三":"03","四":"04","五":"05","六":"06","七":"07","八":"08","九":"09","十":"10" };
    var chinese = value.match(/第\s*([一二三四五六七八九十0-9]+)\s*[章讲]/);
    if (chinese) {
      var v = map[chinese[1]] || ("0" + chinese[1]).slice(-2);
      return v;
    }
    return "";
  }

  function injectPageMeta() {
    var main = document.querySelector("main");
    var h1 = main && main.querySelector(":scope > h1");
    if (!h1 || h1.dataset.atlasMeta === "1") return;
    h1.dataset.atlasMeta = "1";

    var bookLabel = bookTitle();
    var chapter = chapterLabel();
    // 目录里的部段标题常带「（第 1–2 周录播）」等排课信息；页首只保留章节名。
    chapter = chapter.replace(/（[^）]*）/g, "").replace(/\s+/g, " ").trim();

    var kicker = document.createElement("span");
    kicker.className = "h1-kicker";
    var bookSpan = document.createElement("span");
    bookSpan.textContent = bookLabel;
    kicker.appendChild(bookSpan);
    if (chapter) {
      var chapterSpan = document.createElement("span");
      chapterSpan.className = "h1-kicker-book";
      chapterSpan.textContent = " / " + chapter;
      kicker.appendChild(chapterSpan);
    }
    h1.insertBefore(kicker, h1.firstChild);

    var heading = h1.querySelector(".header");
    var indexText = sectionIndex(heading ? heading.textContent : h1.textContent);
    if (indexText) {
      var ghost = document.createElement("span");
      ghost.className = "h1-index";
      ghost.setAttribute("aria-hidden", "true");
      ghost.textContent = indexText;
      h1.appendChild(ghost);
    }

    var stats = countReading();
    var meta = document.createElement("span");
    meta.className = "h1-meta";
    var bits = [
      "约 " + stats.minutes + " 分钟",
      "图 " + stats.figures,
      "式 " + stats.formulas
    ];
    bits.forEach(function (label, index) {
      var span = document.createElement("span");
      span.textContent = label;
      if (index === 1) span.className = "h1-meta-fig";
      meta.appendChild(span);
    });
    h1.appendChild(meta);
  }

  /* ------------------------------------------------------------------ *
   * 3  图鉴画廊
   * ------------------------------------------------------------------ */
  var ATLAS_ICON = '<svg viewBox="0 0 24 24" aria-hidden="true"><rect x="3.5" y="4.5" width="7" height="7" rx="1.5"></rect><rect x="13.5" y="4.5" width="7" height="7" rx="1.5"></rect><rect x="3.5" y="14.5" width="7" height="5" rx="1.5"></rect><rect x="13.5" y="14.5" width="7" height="5" rx="1.5"></rect></svg>';

  function cloneArt(figure) {
    var svg = figure.querySelector("svg");
    if (svg) {
      var clone = window.TUTORIALS_CORE.cloneForDisplay(svg);
      return clone;
    }
    var img = figure.querySelector("img");
    if (img) {
      var copy = document.createElement("img");
      copy.src = img.currentSrc || img.src;
      copy.alt = img.alt || "";
      copy.loading = "lazy";
      return copy;
    }
    return null;
  }

  function figureTitle(figure, fallback) {
    var svgTitle = figure.querySelector("svg title");
    if (svgTitle) {
      var fromSvg = text(svgTitle);
      if (fromSvg) return fromSvg;
    }
    var cap = figure.querySelector("figcaption");
    if (cap) {
      var copy = cap.cloneNode(true);
      copy.querySelectorAll(".fig-index,.fig-kind,.katex-mathml").forEach(function (node) { node.remove(); });
      var value = text(copy)
        .replace(/^图解\s*/, "")
        .replace(/^读图[:：]?\s*/, "");
      if (value) return value.length > 96 ? value.slice(0, 94) + "…" : value;
    }
    return fallback;
  }

  function buildAtlas() {
    var main = document.querySelector("main");
    var figures = main ? Array.prototype.slice.call(main.querySelectorAll("figure")) : [];
    if (figures.length < 1 || !document.createElement("dialog").showModal) return;
    var bar = document.querySelector("#mdbook-menu-bar .right-buttons");
    if (!bar || bar.querySelector(".atlas-toggle")) return;

    var button = document.createElement("button");
    button.type = "button";
    button.className = "atlas-toggle";
    button.setAttribute("aria-haspopup", "dialog");
    button.setAttribute("aria-label", "打开本页图鉴");
    button.setAttribute("title", "打开本页图鉴");
    button.innerHTML = ATLAS_ICON + '<span class="atlas-label">图鉴</span><span class="atlas-count">' + figures.length + "</span>";
    bar.insertBefore(button, bar.firstChild);

    var dialog = document.createElement("dialog");
    dialog.className = "atlas-dialog";
    dialog.setAttribute("aria-label", "本页图鉴");
    dialog.innerHTML =
      '<div class="atlas-shell">' +
      '<header class="atlas-head">' +
      '<div><div class="atlas-eyebrow">FIGURE ATLAS · 本页图鉴</div>' +
      '<h2></h2>' +
      '<div class="atlas-sub">共 ' + figures.length + ' 张 · 点击图版跳回正文位置</div></div>' +
      '<button type="button" class="atlas-close" aria-label="关闭图鉴">×</button>' +
      "</header>" +
      '<div class="atlas-list"></div>' +
      "</div>";
    dialog.querySelector("h2").textContent = text(main.querySelector(":scope > h1 .header")) || document.title.split(" - ")[0] || "插图总览";

    var list = dialog.querySelector(".atlas-list");
    var built = false;

    function fillList() {
      if (built) return;
      built = true;

    figures.forEach(function (figure, index) {
      var plate = document.createElement("button");
      plate.type = "button";
      plate.className = "atlas-entry";
      var titleText = figureTitle(figure, "插图 " + (index + 1));
      plate.setAttribute("aria-label", "跳到第 " + (index + 1) + " 张插图：" + titleText);

      var no = document.createElement("span");
      no.className = "atlas-entry-no";
      no.textContent = "FIG. " + ("0" + (index + 1)).slice(-2);

      var art = document.createElement("span");
      art.className = "atlas-entry-art";
      var cloned = cloneArt(figure);
      if (cloned) art.appendChild(cloned);

      var main = document.createElement("span");
      main.className = "atlas-entry-main";
      var title = document.createElement("span");
      title.className = "atlas-entry-title";
      title.textContent = titleText;
      var meta = document.createElement("span");
      meta.className = "atlas-entry-meta";
      var kind = figure.querySelector(".fig-kind") || figure.querySelector(".fig-index");
      meta.textContent = kind ? text(kind) : "本页插图";
      main.appendChild(title);
      main.appendChild(meta);

      var arrow = document.createElement("span");
      arrow.className = "atlas-entry-arrow";
      arrow.setAttribute("aria-hidden", "true");
      arrow.textContent = "↗";

      plate.appendChild(no);
      plate.appendChild(art);
      plate.appendChild(main);
      plate.appendChild(arrow);
      plate.addEventListener("click", function () {
        var target = figure;
        for (var parent = target.parentElement; parent; parent = parent.parentElement) {
          if (parent.tagName === "DETAILS") parent.open = true;
        }
        dialog.close();
        target.scrollIntoView({ behavior: window.matchMedia("(prefers-reduced-motion: reduce)").matches ? "auto" : "smooth", block: "center" });
        target.classList.add("atlas-flash");
        window.setTimeout(function () { target.classList.remove("atlas-flash"); }, 1400);
        if (!target.hasAttribute("tabindex")) target.setAttribute("tabindex", "-1");
        target.focus({ preventScroll: true });
      });
      list.appendChild(plate);
    });

    }

    var close = dialog.querySelector(".atlas-close");
    close.addEventListener("click", function () { dialog.close(); });
    dialog.addEventListener("click", function (event) {
      if (event.target === dialog) dialog.close();
    });
    dialog.addEventListener("keydown", function (event) {
      if (event.key === "Escape") { event.preventDefault(); event.stopPropagation(); dialog.close(); }
    });
    document.body.appendChild(dialog);
    button.addEventListener("click", function () {
      fillList();
      dialog.showModal();
      close.focus();
    });
  }

  /* ------------------------------------------------------------------ *
   * 5  启动
   * ------------------------------------------------------------------ */
  function boot() {
    try { wrapImages(); } catch (error) { /* 纯增益 */ }
    try { wrapWideSvgs(); } catch (error) { /* 纯增益 */ }
    try { decorateExistingFigures(); } catch (error) { /* 纯增益 */ }
    try { injectPageMeta(); } catch (error) { /* 纯增益 */ }
    try { buildAtlas(); } catch (error) { /* 纯增益 */ }
    root.classList.add("atlas-ready");
  }

  // 图片包裹必须尽早：framework-media 在 DOMContentLoaded 时才给 figure 绑灯箱，
  // 这里在脚本执行时（body 末尾）先完成包裹，灯箱与图鉴就都能看到它。
  try { wrapImages(); } catch (error) { /* 纯增益 */ }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }
  // 侧栏由 mdBook 在 DOMContentLoaded 后填充；眉标里的章节名要等它。
  function appendChapter(chapter) {
    var kicker = document.querySelector(".h1-kicker");
    if (!kicker || !chapter || kicker.querySelector(".h1-kicker-book")) return;
    // 目录里的部段标题常带「（第 1–2 周录播）」等排课信息；页首只保留章节名。
    chapter = chapter.replace(/（[^）]*）/g, "").replace(/\s+/g, " ").trim();
    if (!chapter) return;
    var span = document.createElement("span");
    span.className = "h1-kicker-book";
    span.textContent = " / " + chapter;
    kicker.appendChild(span);
  }

  function ensureChapterKicker() {
    appendChapter(chapterLabel());
  }

  // toc.html 是 mdBook 构建出的静态目录；比等侧栏 DOM 更可靠（也不受 UI 版本影响）。
  function chapterFromToc() {
    if (!book) return;
    // The rendered sidebar already contains the chapter in normal builds.
    // Avoid downloading and parsing a second copy of the complete TOC.
    ensureChapterKicker();
    if (!document.querySelector(".h1-kicker") || document.querySelector(".h1-kicker-book, #mdbook-sidebar .chapter-item")) return;
    var marker = "/" + book + "/";
    var at = location.pathname.indexOf(marker);
    if (at < 0) return;
    var tocUrl = location.origin + location.pathname.slice(0, at + marker.length) + "toc.html";
    var here = location.pathname.replace(/index\.html$/, "");
    fetch(tocUrl).then(function (response) { return response.ok ? response.text() : ""; }).then(function (html) {
      if (!html) return;
      var doc = new DOMParser().parseFromString(html, "text/html");
      var links = doc.querySelectorAll("a[href]");
      for (var i = 0; i < links.length; i++) {
        var href = new URL(links[i].getAttribute("href"), tocUrl).pathname.replace(/index\.html$/, "");
        if (href !== here) continue;
        appendChapter(partTitleFor(links[i]));
        return;
      }
    }).catch(function () { /* 纯增益 */ });
  }

  window.addEventListener("load", ensureChapterKicker);
  [0, 200, 600, 1200, 2400].forEach(function (delay) {
    window.setTimeout(ensureChapterKicker, delay);
  });
  window.setTimeout(chapterFromToc, 900);
})();
