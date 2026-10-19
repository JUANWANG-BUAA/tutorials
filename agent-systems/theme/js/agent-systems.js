/* Agent 系统工程：本书配置
 * ---------------------------------------------------------------------------
 * 附加操作（进度条 / 页内目录 / 解答工具条 / 返回教程库 / 宽公式提示）的实现在
 * shared/theme/js/page-extras.js —— 各本共用一份，这里只声明本书要什么。
 */
(function () {
  "use strict";
  window.TUTORIALS_EXTRAS.boot({
    slug: "agent-systems",
    // 本书以 H2 分节（1.1 / 5.3 这种），页内目录只收 H2。
    pageTocLevels: ["h2"],
    // 自测与折叠解答较多，工具条贴在第一个解答框旁。
    toolbarPlacement: "inline",
    // 公式以概率、预算、复杂度为主，短式居多；不开横向溢出提示。
    formulaHint: false
  });
})();
