/*
 * 数值分析 · 本书配置 + 专属的「阅读分层」开关
 * ---------------------------------------------------------------------------
 * 附加操作（进度条 / 页内目录 / 解答工具条 / 宽公式滚动提示 / 返回教程库 / 回到
 * 顶部 / 折叠记忆 / 界面文案汉化）统一在 theme/js/framework.js，三本书共用一份；
 * framework.js 读取这里的 window.TUTORIALS.slug 来定位本书在教程库里的位置。
 *
 * 本文件只留数值分析独有的分层阅读：正文盒子分 core / main / skip 三层（类名由
 * tools/mathbook.py 生成）。「只看核心」把 skip 层（证明、课程预告、拓展思考）
 * 折叠，留下一张定义 + 定理 + 速查表 + 错误清单的复习骨架，状态记在 localStorage。
 * 图例要挂在页内目录之后，因此放在 TUTORIALS.onReady 里等 framework.js 把目录
 * 插好；core-only 类在解析阶段先落上，避免首帧先画出被折叠层再收起。
 */
(function () {
  "use strict";

  var root = document.documentElement;
  var CORE_ONLY_KEY = "na-core-only";

  function getStoredValue(key) {
    try { return localStorage.getItem(key); } catch (error) { return null; }
  }

  function setStoredValue(key, value) {
    try { localStorage.setItem(key, value); } catch (error) { /* Storage may be disabled. */ }
  }

  if (getStoredValue(CORE_ONLY_KEY) === "1") root.classList.add("core-only");

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
    // 初始状态必须与 boot 时从 localStorage 恢复的状态一致，
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

  window.TUTORIALS = { slug: "numerical", onReady: buildLayerToggle };
})();
