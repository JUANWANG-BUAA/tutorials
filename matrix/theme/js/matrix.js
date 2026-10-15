/* 矩阵论教程：本书配置
 * ---------------------------------------------------------------------------
 * 附加操作（进度条 / 页内目录 / 解答工具条 / 返回教程库 / 宽公式提示）的实现在
 * shared/theme/js/page-extras.js —— 三本共用一份，这里只声明本书要什么。
 * 本书专属的交互图在 theme/js/matrix-interactive.js。
 *
 * 历史教训（留在本书，因为最先在这里踩到）：不要重复实现框架已有的可访问性行为。
 * mdBook 的 chapterNavigation 已内置「焦点在输入控件里就不翻页」的保护，此前本书
 * 又加了一层、把 button / summary 也算交互元素并用 pointerup 记标志，结果是点过任意
 * 折叠块后 ←/→ 再也翻不动页面。
 */
(function () {
  "use strict";
  window.TUTORIALS_EXTRAS.boot({
    slug: "matrix",
    // 本书正文以 H2 分节（1.3 这种），H3 是盒内小标题，不进页内目录
    pageTocLevels: ["h2"],
    // 解答多（一章上百个），工具条放页首，进页面就能一键展开
    toolbarPlacement: "top",
    // 本书长公式多，窄屏会横向溢出，开滚动提示
    formulaHint: true
  });
})();
