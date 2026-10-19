/* Linux 系统与内核教程：本书配置
 * ---------------------------------------------------------------------------
 * 附加操作（进度条 / 页内目录 / 解答工具条 / 返回教程库 / 宽公式提示）的实现在
 * shared/theme/js/page-extras.js —— 五本共用一份，这里只声明本书要什么。
 */
(function () {
  "use strict";
  window.TUTORIALS_EXTRAS.boot({
    slug: "linux",
    // 本书以 H2 分节（2.2.1 这种），H3 是小节；页内目录只收 H2，避免顶部目录过长
    pageTocLevels: ["h2"],
    // 习题与自测的折叠解答较多，工具条贴在第一个解答框旁最顺手
    toolbarPlacement: "inline",
    // 本书公式以位运算、地址换算、复杂度为主，短式居多；不开横向溢出提示
    formulaHint: false
  });
})();
