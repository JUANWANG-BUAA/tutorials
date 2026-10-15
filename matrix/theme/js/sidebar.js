/*
 * 侧栏 — 三本书共用（robot / numerical / matrix 三份内容逐字相同）
 * ---------------------------------------------------------------------------
 * mdBook 0.5 自带的侧栏折叠有两个问题，且三本书各自实现过一版，行为还不一致：
 *
 *   ① **同一个 chevron 上有两个处理器在改两个不同的 <li>。**
 *      mdBook 的 toc.js 会给「本页大纲」的折叠钮（.header-toggle）绑定自己的
 *      toggleSection，切换的是该 header 自己的 li；而各书脚本又按
 *      `closest('li.chapter-item')` 找目标——大纲钮不是 chapter-item，于是这一路
 *      找到的是**它所属的整个章节**。一次点击：章节被折叠、大纲小节被展开，
 *      看起来就是「点了只展开、再点折不动」。
 *
 *   ② **默认全展开。** toc.js 把所有 li 都标成 expanded，本书 70+ 条目（章 → 节 →
 *      小节三层）会铺成一整面墙，既不美观也难定位。
 *
 * 本模块用**一个捕获阶段的监听器**统一接管：先于 mdBook 的目标阶段监听器触发，
 * 自己算出「真正拥有这段 ol.section 的 li」再切换，然后 stopPropagation 掉，
 * mdBook 的处理器不再参与，两个 li 各自为政的问题消失。并把默认态改成
 * 「只展开通向当前页的那条路径」，其余收起（阅读时随滚动展开当前所在分支，
 * 但不会覆盖读者手动折叠过的分组）。状态存 localStorage。
 *
 * 加载位置：必须排在 toc.js 之后（book.toml 的 additional-js 在框架脚本之后，
 * 天然满足）。toc.js 会在 DOMContentLoaded 时重建侧栏，故这里既在 boot 时处理，
 * 也监听一次 DOMContentLoaded 兜底，函数幂等。
 */
(function () {
  "use strict";

  var STORE_PREFIX = "tutorials-sidebar:";
  var CHEVRON_NS = "http://www.w3.org/2000/svg";

  function store(key) { return STORE_PREFIX + key; }

  function readState(key) {
    try { return localStorage.getItem(store(key)); } catch (error) { return null; }
  }

  function writeState(key, value) {
    try { localStorage.setItem(store(key), value); } catch (error) { /* 隐私模式静默降级 */ }
  }

  function makeChevron() {
    var svg = document.createElementNS(CHEVRON_NS, "svg");
    var path = document.createElementNS(CHEVRON_NS, "path");
    svg.setAttribute("viewBox", "0 0 12 12");
    svg.setAttribute("aria-hidden", "true");
    path.setAttribute("d", "M4 2.5 7.5 6 4 9.5");
    svg.appendChild(path);
    return svg;
  }

  /* 侧栏里真正可折叠的分组 = 直接挂着 ol.section 的 li（章节条目与大纲 header）。
     注意选择器必须用 :scope，否则会匹配到深层嵌套的 li。 */
  function groupsOf(box) {
    return Array.prototype.filter.call(box.querySelectorAll("li"), function (li) {
      return li.querySelector(":scope > ol.section");
    });
  }

  function sectionOf(li) { return li.querySelector(":scope > ol.section"); }

  function wrapperOf(li) { return li.querySelector(":scope > .chapter-link-wrapper"); }

  /* 分组的稳定标识：优先用它自己的链接路径（章节页 / 页内锚点），
     没有链接时退回它在侧栏中的序号。 */
  function groupKey(li, index) {
    var link = li.querySelector(":scope > .chapter-link-wrapper > a[href]");
    if (link) {
      var href = link.getAttribute("href");
      if (href) return href;
    }
    return "g" + index;
  }

  function linkOf(li) {
    return li.querySelector(":scope > .chapter-link-wrapper > a[href]");
  }

  function isActiveBranch(li) {
    if (li.querySelector("a.active, a.current-header")) return true;
    var link = linkOf(li);
    return Boolean(link && (link.classList.contains("active") || link.classList.contains("current-header")));
  }

  function ancestorsExpanded(li, box) {
    var parent = li.parentElement;
    while (parent && parent !== box) {
      if (parent.tagName === "LI" && parent.querySelector(":scope > ol.section")) parent.classList.add("expanded");
      parent = parent.parentElement;
    }
  }

  function syncButton(li, toggle) {
    var open = li.classList.contains("expanded");
    toggle.setAttribute("aria-expanded", open ? "true" : "false");
    // 大纲钮由 mdBook 生成，标题写死；统一改成中文并补可访问名
    toggle.setAttribute("aria-label", open ? "折叠此组" : "展开此组");
  }

  /* 注入/规整折叠钮。
     mdBook 已经给「本页大纲」的 header 生成过 .chapter-fold-toggle（内含 ❱），
     这里把它的内容换成与页面导航同一枚箭头并复用；章节条目没有钮，自己建一个。 */
  function ensureToggle(li) {
    var wrapper = wrapperOf(li);
    if (!wrapper) return null;

    var toggle = wrapper.querySelector(":scope > .chapter-fold-toggle");
    if (!toggle) {
      toggle = document.createElement("button");
      toggle.type = "button";
      toggle.className = "chapter-fold-toggle";
      wrapper.appendChild(toggle);
    } else if (toggle.tagName === "A") {
      // mdBook 给「本页大纲」生成的是无 href 的 <a>（不可聚焦、无按钮语义），
      // 补上按钮语义与键盘可达性。
      toggle.setAttribute("role", "button");
      toggle.setAttribute("tabindex", "0");
    }
    if (!toggle.querySelector("svg")) toggle.replaceChildren(makeChevron());
    if (!toggle.dataset.bookFold) toggle.dataset.bookFold = "1";
    syncButton(li, toggle);
    return toggle;
  }

  /* 目标 li：拥有这段 section 的那一个。用 parentElement 两跳（与 mdBook 一致），
     而不是 closest('li.chapter-item')——后者在大纲钮上会指到整个章节。 */
  function owningGroup(toggle, box) {
    var li = toggle.closest("li");
    while (li && li !== box) {
      if (li.querySelector(":scope > ol.section")) return li;
      li = li.parentElement ? li.parentElement.closest("li") : null;
    }
    return null;
  }

  function decorateLabels(box) {
    box.querySelectorAll(".chapter-link-wrapper > a").forEach(function (link) {
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

  /* 大纲补齐标题与箭头（toc.js 在 DOMContentLoaded 里插 .on-this-page，晚于本模块
     的 boot；故这里每次处理都对 .on-this-page 做一次幂等修饰）。 */
  function decorateOutline(box) {
    box.querySelectorAll(".on-this-page").forEach(function (block) {
      if (!block.querySelector(".otp-label")) {
        var label = document.createElement("div");
        label.className = "otp-label";
        label.textContent = "本页大纲";
        block.insertBefore(label, block.firstChild);
      }
    });
  }

  function scrollActiveIntoView(box) {
    var active = box.querySelector("a.active") || box.querySelector("a.current-header");
    if (!active) return;
    var viewport = box.getBoundingClientRect();
    var bounds = active.getBoundingClientRect();
    if (bounds.top < viewport.top + 10) box.scrollTop -= viewport.top + 10 - bounds.top;
    else if (bounds.bottom > viewport.bottom - 10) box.scrollTop += bounds.bottom - viewport.bottom + 10;
  }

  function enhance(box) {
    if (!box) return;
    decorateOutline(box);
    var groups = groupsOf(box);

    groups.forEach(function (li, index) {
      var key = groupKey(li, index);
      var toggle = ensureToggle(li);
      if (!toggle) return;
      toggle.dataset.foldKey = key;

      // 默认折叠只作用于**页面导航**（li.chapter-item），且仅首次增强时决定：
      //   读者存过 open/closed → 听读者的；
      //   否则只展开「通向当前页的那条路径」，其余收起（70+ 条目不再铺成一面墙）。
      // 「本页大纲」（.on-this-page 里的 li.header-item）不动——mdBook 自己按当前
      // 小节维护其展开态，强行折叠会让读者一进页面就看不见自己读到哪。
      var isOutline = li.classList.contains("header-item") || li.closest(".on-this-page");
      if (!isOutline && li.classList.contains("chapter-item") && !li.dataset.bookFoldInit) {
        li.dataset.bookFoldInit = "1";
        var saved = readState(key);
        var shouldOpen;
        if (saved === "open") shouldOpen = true;
        else if (saved === "closed") shouldOpen = false;
        else shouldOpen = isActiveBranch(li);
        li.classList.toggle("expanded", shouldOpen);
      }
      syncButton(li, toggle);
    });

    // 当前页所在路径整条展开，避免读者找不到「我在哪」
    var activeLink = box.querySelector("a.active") || box.querySelector("a.current-header");
    if (activeLink) {
      var activeLi = activeLink.closest("li");
      if (activeLi) ancestorsExpanded(activeLi, box);
    }

    decorateLabels(box);
    scrollActiveIntoView(box);
    box.dataset.bookSidebar = "1";
  }

  /* mdBook 的大纲折叠钮是没有 href 的 <a>，键盘不可达；补 Enter / Space。
     事件按目标最内层元素判定，避免冒泡到外层按钮。 */
  function bindToggleKeyboard(box) {
    if (box.dataset.bookFoldKeys) return;
    box.dataset.bookFoldKeys = "1";
    box.addEventListener("keydown", function (event) {
      if (event.key !== "Enter" && event.key !== " " && event.key !== "Spacebar") return;
      var toggle = event.target.closest && event.target.closest(".chapter-fold-toggle");
      if (!toggle || !box.contains(toggle)) return;
      event.preventDefault();
      toggle.click();
    });
  }

  function boot() {
    var box = document.querySelector("mdbook-sidebar-scrollbox");
    if (!box) return;
    // 捕获阶段先于 mdBook 的目标阶段处理器；拦下后 mdBook 那一路不再执行，
    // 避免「同一 chevron 改两个 li」。只有本模块自己决定折叠谁。
    if (!box.dataset.bookFoldBound) {
      box.dataset.bookFoldBound = "1";
      box.addEventListener("click", function (event) {
        var toggle = event.target.closest && event.target.closest(".chapter-fold-toggle");
        if (!toggle || !box.contains(toggle)) return;
        var li = owningGroup(toggle, box);
        if (!li) return;
        event.preventDefault();
        event.stopPropagation();
        if (event.stopImmediatePropagation) event.stopImmediatePropagation();
        var open = li.classList.toggle("expanded");
        syncButton(li, toggle);
        if (toggle.dataset.foldKey) writeState(toggle.dataset.foldKey, open ? "open" : "closed");
      }, true);
    }
    bindToggleKeyboard(box);
    enhance(box);
  }

  // toc.js 在 DOMContentLoaded 里重建侧栏内容，故此后必须再处理一次。
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", boot);
  else boot();
  document.addEventListener("DOMContentLoaded", boot);
})();
