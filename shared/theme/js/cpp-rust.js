/* 《Rust 底层性能工程》：本书配置
 * ---------------------------------------------------------------------------
 * 附加操作（进度条 / 页内目录 / 解答工具条 / 返回教程库 / 宽公式提示）的实现在
 * shared/theme/js/page-extras.js —— 多本共用一份，这里只声明本书要什么。
 *
 * 参数口径（与 matrix.js / linux.js 同一契约）：
 *   slug             本书在站点里的路径段，用于「返回教程库」按钮；
 *   pageTocLevels    进页内目录的标题层级——本书 H2 是「1.1」这种分节，
 *                    H3 是「1.1.1」小节（一章多至 70 个），全收会把
 *                    页内目录顶得过长，故只收 H2；
 *   toolbarPlacement 解答折叠框（details.sol-box）多，工具条放页首，
 *                    进页面就能一键展开；
 *   formulaHint      全书 238 处行内公式，ch11/ch17 有长式，开横向溢出提示。
 */
(function () {
  "use strict";
  window.TUTORIALS_EXTRAS.boot({
    slug: "cpp-rust",
    pageTocLevels: ["h2"],
    toolbarPlacement: "top",
    formulaHint: true
  });
})();
