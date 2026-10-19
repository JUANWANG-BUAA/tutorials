/* 分布式系统与数据面：本书配置
 * ---------------------------------------------------------------------------
 * 附加操作（进度条 / 页内目录 / 解答工具条 / 返回教程库 / 宽公式提示）的实现在
 * shared/theme/js/page-extras.js —— 多本共用一份，这里只声明本书要什么。
 */
(function () {
  "use strict";
  window.TUTORIALS_EXTRAS.boot({
    slug: "distributed",
    // 本书以 H2 分节（12.3.1 这种），H3 是小节；页内目录只收 H2。
    pageTocLevels: ["h2"],
    toolbarPlacement: "inline",
    // 分布式书里的公式以排队论、概率和复杂度为主，短式居多。
    formulaHint: false
  });
})();
