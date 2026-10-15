/*
 * framework-core — 框架层基础设施（三本书共用，见 shared/README.md）
 * ---------------------------------------------------------------------------
 * 原 framework.js 是单文件 1050 行、十项职责；现按内聚拆四份：
 *   framework-core.js   共享工具（localStorage / 精简动效判断 / 吐司 / 剪贴板）、界面文案汉化、
 *                       搜索结果面板汉化、回到顶部、折叠状态记忆，以及启动注册表
 *   framework-nav.js    侧栏章节折叠、右侧「本页大纲」、已读标记与「继续阅读」
 *   framework-media.js  插图灯箱、插图进场
 *   framework-text.js   公式复制 LaTeX、术语悬挂提示
 * 其它模块用 CORE.register(boot) 注册；这里负责在 DOMContentLoaded 依次跑一遍，
 * 并把共享工具挂在 window.TUTORIALS_CORE 上（各模块只依赖这个小接口，不互相依赖）。
 */
(function () {
  "use strict";

  var root = document.documentElement;

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
    ["#mdbook-menu-bar a[href='print.html']", "打印本书"],
    /* 仓库与「编辑此页」是 mdBook 原生入口（book.toml 的 git-repository-url /
       edit-url-template），文案仅为它们补中文名。 */
    ["#mdbook-menu-bar a[aria-label='Git repository']", "代码仓库"],
    ["#mdbook-menu-bar a[aria-label='Suggest an edit']", "编辑此页"]
  ];

  /* mdBook 的主题名是 Auto / Light / Rust / Coal / Navy / Ayu，对应 §1.1 里的五套
     独立调色板：两颗亮色（中性白纸 / 暖纸）+ 三颗深色（中性灰 / 蓝黑 / 琥珀）。
     注意与代码高亮无关——代码配色由 highlight.js 自己的一套主题决定，不要写成
     「只差代码配色」（那是 2026-10 之前五个主题只有两套外观时的说法）。*/
  var THEME_LABELS = {
    "mdbook-theme-default_theme": ["跟随系统", "按系统外观自动选择：浅色用暖纸，深色用琥珀"],
    "mdbook-theme-light": ["浅色 · Light", "中性白纸，蓝灰强调"],
    "mdbook-theme-rust": ["浅色 · Rust", "暖纸底色，赭红强调"],
    "mdbook-theme-coal": ["深色 · Coal", "中性深灰，冷灰蓝强调"],
    "mdbook-theme-navy": ["深色 · Navy", "蓝黑底色，青蓝强调"],
    "mdbook-theme-ayu": ["深色 · Ayu（默认）", "琥珀强调的深色"]
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
   *   滚过约一屏半后出现，右下角小圆钮。
   * ======================================================================== */
  function buildBackToTop() {
    if (document.getElementById("back-to-top")) return;
    var root = document.documentElement;
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

  function legacyCopy(text) {
    var area = document.createElement("textarea");
    area.value = text;
    area.setAttribute("readonly", "readonly");
    area.style.position = "fixed";
    area.style.top = "-1000px";
    document.body.appendChild(area);
    area.select();
    var ok = false;
    try { ok = document.execCommand("copy"); } catch (e) { ok = false; }
    area.remove();
    return ok ? Promise.resolve() : Promise.reject(new Error("copy failed"));
  }

  function copyText(text) {
    if (navigator.clipboard && navigator.clipboard.writeText) {
      return navigator.clipboard.writeText(text).catch(function () { return legacyCopy(text); });
    }
    return legacyCopy(text);
  }

  function toast(message) {
    var el = document.getElementById("tutorials-toast");
    if (!el) {
      el = document.createElement("div");
      el.id = "tutorials-toast";
      el.className = "tutorials-toast";
      el.setAttribute("role", "status");
      el.setAttribute("aria-live", "polite");
      document.body.appendChild(el);
    }
    el.textContent = message;
    el.classList.add("is-visible");
    window.clearTimeout(toast.timer);
    toast.timer = window.setTimeout(function () { el.classList.remove("is-visible"); }, 1800);
  }


  /* ------------------------------------------------------------------ *
   * 启动注册表：各模块用 CORE.register 注册自己的启动钩子，
   * 由这里在 DOMContentLoaded（或已就绪时立刻）依次执行，单个模块出错不影响其余。
   * ------------------------------------------------------------------ */
  var boots = [];
  function register(fn) { if (typeof fn === "function") boots.push(fn); }

  function runBoots() {
    for (var i = 0; i < boots.length; i++) {
      try { boots[i](); } catch (error) { /* 纯增益模块，出错静默降级 */ }
    }
  }

  function boot() {
    try { localizeChrome(); } catch (e) { /* 升级后 id 变了等情形，静默降级 */ }
    try { watchSearchResults(); } catch (e) { /* 同上 */ }
    try { buildBackToTop(); } catch (e) { /* 纯增益 */ }
    try { wireFoldMemory(); } catch (e) { /* 纯增益 */ }
    runBoots();
  }

  window.TUTORIALS_CORE = {
    store: store,
    save: save,
    prefersReducedMotion: prefersReducedMotion,
    toast: toast,
    copyText: copyText,      /* 名字必须与各模块里的调用一致（CORE.copyText） */
    copy: copyText,
    register: register
  };

  /* toc.js 在 <head> 就定义了侧栏自定义元素，章节树是解析到该元素时同步填充的，
     故 boot() 时已可注入；再绑一次 DOMContentLoaded 兜底（函数幂等）。 */
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", boot);
  else boot();
})();
