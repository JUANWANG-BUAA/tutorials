/* Linux 系统与内核教程：本书配置 + 「只看核心」阅读分层开关
 * ---------------------------------------------------------------------------
 * 附加操作（进度条 / 页内目录 / 解答工具条 / 返回教程库 / 宽公式提示）的实现在
 * shared/theme/js/page-extras.js —— 多本共用一份，这里只声明本书要什么。
 * 阅读分层图例是本书专属：正文盒子分 core / main / skip 三层（类名由
 * tools/mathbook.py 生成，样式见 linux.css §阅读分层），读者需要一个开关。
 */
(function () {
  "use strict";

  var root = document.documentElement;

  function getStoredValue(key) {
    try { return localStorage.getItem(key); } catch (error) { return null; }
  }

  function setStoredValue(key, value) {
    try { localStorage.setItem(key, value); } catch (error) { /* Storage may be disabled. */ }
  }

  /* 先恢复上次的「只看核心」状态，再建开关——顺序反了会出现
     「页面已折叠、按钮却显示只看核心」的错位（数值分析版踩过这个坑）。 */
  var CORE_ONLY_KEY = "linux-core-only";
  var saved = getStoredValue(CORE_ONLY_KEY);
  if (saved === "1") root.classList.add("core-only");

  window.TUTORIALS_EXTRAS.boot({
    slug: "linux",
    // 本书以 H2 分节（2.2.1 这种），H3 是小节；页内目录只收 H2，避免顶部目录过长
    pageTocLevels: ["h2"],
    // 习题与自测的折叠解答较多，工具条贴在第一个解答框旁最顺手
    toolbarPlacement: "inline",
    // 本书公式以位运算、地址换算、复杂度为主，短式居多；不开横向溢出提示
    formulaHint: false
  });

  /* 阅读分层：把 skip 层（证明、课程预告、拓展思考）折叠，留下一张
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
      '<li><span class="swatch"></span><b>主体</b><span class="desc">例题、方法、自测、陷阱</span></li>' +
      '<li><span class="swatch skip"></span><b>第一遍可跳</b><span class="desc">证明、课程预告、拓展思考</span></li>' +
      '</ul>';

    var button = document.createElement("button");
    button.type = "button";
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
      // 首页没有 H1，首个子元素可能是封面；挂在它之后，别让图例浮在封面之上。
      var first = main.firstElementChild;
      if (first && (first.tagName === "H1" || first.classList.contains("chapter-cover"))) anchor = first;
    }
    if (anchor) anchor.insertAdjacentElement("afterend", box);
    else main.insertBefore(box, main.firstElementChild);
  }

  /* 图例要在页内目录之后插入（上面的 boot() 已同步建好目录），故在此调用 */
  buildLayerToggle();
})();
