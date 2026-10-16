/* 深度学习导论教程：本书配置
 * ---------------------------------------------------------------------------
 * 附加操作（进度条 / 页内目录 / 解答工具条 / 返回教程库 / 宽公式提示）的实现在
 * shared/theme/js/page-extras.js —— 四本共用一份，这里只声明本书要什么。
 */
(function () {
  "use strict";
  window.TUTORIALS_EXTRAS.boot({
    slug: "deeplearning",
    // 本书以 H2 分节（2.3 这种），H3 是盒内小标题，不进页内目录
    pageTocLevels: ["h2"],
    // 讲解页公式与推导较多，解答工具条放页首，进页面就能一键展开
    toolbarPlacement: "top",
    // 本书长公式多（注意力、扩散、损失函数），窄屏会横向溢出，开滚动提示
    formulaHint: true
  });
})();
