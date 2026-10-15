/* 机器人控制技术教程：本书配置
 * ---------------------------------------------------------------------------
 * 附加操作（进度条 / 页内目录 / 解答工具条 / 返回教程库 / 宽公式提示）的实现在
 * shared/theme/js/page-extras.js —— 三本共用一份，这里只声明本书要什么。
 * 本书专属的交互实验在 theme/js/robot-labs.js。
 */
(function () {
  "use strict";
  window.TUTORIALS_EXTRAS.boot({
    slug: "robot",
    // 本书章节细分到 H3（1.2.3 这种），页内目录跟着收，读者能直接跳到小节
    pageTocLevels: ["h2", "h3"],
    // 解答数量少且分散，工具条贴在第一个解答框旁最顺手
    toolbarPlacement: "inline",
    // 本书公式以短式为主，少见横向溢出，不开滚动提示
    formulaHint: false
  });
})();
