/*
 * framework-media — 插图：灯箱与进场
 * ---------------------------------------------------------------------------
 * 本文件是 shared/theme/js/framework-*.js 之一：framework.js 原先 1050 行、十项职责
 * 挤在一个 IIFE 里，现按内聚拆为四份（core / nav / media / text），共享工具由 core 通过
 * window.TUTORIALS_CORE 暴露，各模块用 CORE.register(boot) 注册自己的启动钩子。
 * 插图：灯箱与进场
 */
(function () {
  "use strict";

  var CORE = window.TUTORIALS_CORE;
  if (!CORE) return;      /* core 必须先加载（book.toml 的 additional-js 顺序保证） */

  /* ------------------------------------------------------------------ *
   * 插图灯箱
   *
   * 本书的图是内联 SVG（tools/mathbook.py 生成 figure.concept-figure），不是 <img>，
   * 所以直接克隆节点进 <dialog>：viewBox 自带缩放，不必另存一份大图。
   * 只为「渲染宽度 ≥ 200px」的图开启（小图标不抢焦点），键盘可达（Enter / Space），
   * Esc 由 <dialog> 原生处理，关闭后焦点回到原图。
   * ------------------------------------------------------------------ */
  var ZOOM_MIN_WIDTH = 200;
  var lastZoomTrigger = null;

  function zoomDialog() {
    var dialog = document.getElementById("figure-zoom");
    if (dialog) return dialog;
    dialog = document.createElement("dialog");
    dialog.id = "figure-zoom";
    dialog.className = "figure-zoom";
    dialog.setAttribute("aria-label", "放大查看插图（Esc 关闭）");
    var stage = document.createElement("div");
    stage.className = "figure-zoom-stage";
    var close = document.createElement("button");
    close.type = "button";
    close.className = "figure-zoom-close";
    close.textContent = "关闭";
    dialog.appendChild(stage);
    dialog.appendChild(close);
    document.body.appendChild(dialog);
    close.addEventListener("click", function () { dialog.close(); });
    dialog.addEventListener("click", function (event) {
      if (event.target === dialog || event.target === stage) dialog.close();
    });
    /* Esc 自己接管：mdBook 的全局键位处理会对 Escape 调 preventDefault，
       而「Esc 关闭模态」是 keydown 的默认动作，一旦被拦就不会发生。 */
    dialog.addEventListener("keydown", function (event) {
      if (event.key === "Escape") { event.preventDefault(); dialog.close(); }
    });
    dialog.addEventListener("cancel", function (event) { event.preventDefault(); dialog.close(); });
    /* 关闭后焦点回到触发的那张图：监听挂在创建处（对话框是首次打开时才建的，
       挂在 boot 里会永远绑不上）。 */
    dialog.addEventListener("close", function () {
      if (lastZoomTrigger && document.contains(lastZoomTrigger)) lastZoomTrigger.focus();
      lastZoomTrigger = null;
    });
    return dialog;
  }

  function openZoom(figure) {
    var dialog = zoomDialog();
    var stage = dialog.querySelector(".figure-zoom-stage");
    var art = figure.querySelector("svg, img");
    if (!art) return;
    var clone = art.cloneNode(true);
    /* 只摘掉根节点 id。SVG 内部的 gradient / marker / clipPath 都被
       fill="url(#…)" 引用，逐个删除会让放大后的图失去底色与箭头。 */
    clone.removeAttribute("id");
    var caption = figure.querySelector("figcaption");
    if (caption) {
      var captionClone = caption.cloneNode(true);
      captionClone.className = "figure-zoom-caption";
      stage.replaceChildren(clone, captionClone);
    } else {
      stage.replaceChildren(clone);
    }
    lastZoomTrigger = figure;
    dialog.showModal();
  }

  function bootFigureZoom() {
    var main = document.querySelector("main");
    if (!main || !document.createElement("dialog").showModal) return;
    main.querySelectorAll("figure").forEach(function (figure) {
      if (figure.dataset.zoomable === "1") return;
      var art = figure.querySelector("svg, img");
      if (!art || art.getBoundingClientRect().width < ZOOM_MIN_WIDTH) return;
      figure.dataset.zoomable = "1";
      figure.setAttribute("tabindex", "0");
      figure.setAttribute("role", "button");
      figure.setAttribute("aria-label", "放大查看插图");
      figure.addEventListener("click", function (event) {
        if (event.target.closest("a, button")) return;
        event.preventDefault();
        openZoom(figure);
      });
      figure.addEventListener("keydown", function (event) {
        if (event.key !== "Enter" && event.key !== " ") return;
        event.preventDefault();
        openZoom(figure);
      });
    });
    var dialog = document.getElementById("figure-zoom");
    if (dialog) dialog.addEventListener("close", function () {
      if (lastZoomTrigger && document.contains(lastZoomTrigger)) lastZoomTrigger.focus();
      lastZoomTrigger = null;
    });
  }

  /* ------------------------------------------------------------------ *
   * 插图进场：只对 figure 做一次极轻的上浮淡入（6px / 0.5 不透明度起）
   * 只有在 JS 跑起来、且浏览器支持 IntersectionObserver 时才加 figure-reveal 类，
   * 因此无 JS、打印、reduced-motion 三种情形下页面就是静止可见的。
   * ------------------------------------------------------------------ */
  function bootFigureReveal() {
    if (!"IntersectionObserver" in window || CORE.prefersReducedMotion()) return;
    var figures = document.querySelectorAll(".content figure");
    if (!figures.length) return;
    document.documentElement.classList.add("figure-reveal");
    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (!entry.isIntersecting) return;
        entry.target.classList.add("figure-in");
        observer.unobserve(entry.target);
      });
    }, { rootMargin: "0px 0px -8% 0px", threshold: 0.01 });
    figures.forEach(function (figure) {
      // 首屏内的图直接置为已进，不要一闪
      if (figure.getBoundingClientRect().top < window.innerHeight) figure.classList.add("figure-in");
      else observer.observe(figure);
    });
  }

  CORE.register(function () {
    try { bootFigureZoom(); } catch (e) { /* 纯增益 */ }
    try { bootFigureReveal(); } catch (e) { /* 纯增益 */ }
  });
})();
