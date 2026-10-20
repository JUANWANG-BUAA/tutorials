/* Shared preference schema + pre-paint restore. No DOM UI dependencies.
 * Loaded in <head> by both mdBook and the portal; additional-js also registers
 * this resource for mdBook fingerprinting. The second load is intentionally inert.
 */
(function () {
  "use strict";
  if (window.TUTORIALS_PREFS) return;
  var DEFAULT_PREFS = {
    skin: "classic",
    font: "sans",
    size: "m",
    density: "standard",
    width: "standard",
    palette: "theme",
    bg: "theme"
  };

  /* 六个轴与 prefs.css 的选择器一一对应；改选项请同时改三处：
     这里 / prefs.css 的 §1–§5.6 / head.hbs 的 KEYS。 */
  var OPTIONS = [
    {
      key: "skin", label: "界面外观", attr: "data-skin",
      choices: [
        { value: "classic", label: "原有图鉴" },
        { value: "rhine", label: "莱茵档案", swatch: "#a67d48" }
      ]
    },
    {
      key: "font", label: "字体", attr: "data-font",
      choices: [
        { value: "serif", label: "衬线" },
        { value: "sans", label: "无衬线" },
        { value: "kai", label: "楷体" },
        { value: "system", label: "系统" }
      ]
    },
    {
      key: "size", label: "字号", attr: "data-size",
      choices: [
        { value: "s", label: "小" },
        { value: "m", label: "中" },
        { value: "l", label: "大" },
        { value: "xl", label: "特大" }
      ]
    },
    {
      key: "density", label: "行距间距", attr: "data-density",
      choices: [
        { value: "compact", label: "紧凑" },
        { value: "standard", label: "标准" },
        { value: "loose", label: "宽松" },
        { value: "roomy", label: "超宽" }
      ]
    },
    {
      key: "width", label: "版心宽度", attr: "data-width",
      choices: [
        { value: "narrow", label: "窄" },
        { value: "standard", label: "标准" },
        { value: "wide", label: "宽" },
        { value: "full", label: "超宽" }
      ]
    },
    {
      key: "palette", label: "主题色", attr: "data-palette",
      choices: [
        { value: "theme", label: "随主题" },
        { value: "blue", label: "海蓝", swatch: "#2f74b8" },
        { value: "teal", label: "青绿", swatch: "#287d82" },
        { value: "green", label: "松绿", swatch: "#4f7a52" },
        { value: "amber", label: "琥珀", swatch: "#a65d2c" },
        { value: "contrast", label: "高对比", swatch: "#8a2c0b" },
        { value: "archive", label: "档案红", swatch: "#8b3a2a" },
        { value: "blueprint", label: "工程蓝", swatch: "#2f6f8f" },
        { value: "endfield", label: "酸性黄", swatch: "#8a9b00" }
      ]
    },
    {
      key: "bg", label: "背景纹理", attr: "data-bg",
      choices: [
        { value: "theme", label: "随主题" },
        { value: "wash", label: "柔和光感" },
        { value: "plain", label: "纯净" },
        { value: "grid", label: "细网格" },
        { value: "graph", label: "方格纸" },
        { value: "ruled", label: "横线稿纸" },
        { value: "dots", label: "点阵" },
        { value: "paper", label: "纸张纤维" },
        { value: "blueprint", label: "蓝图网格" },
        { value: "laid", label: "帘纹纸" }
      ]
    }
  ];

  function read(key) {
    try { return localStorage.getItem("tutorials-prefs:" + key); }
    catch (error) { return null; }
  }
  function applyStored() {
    OPTIONS.forEach(function (group) {
      var value = read(group.key);
      if (value !== DEFAULT_PREFS[group.key] && group.choices.some(function (choice) { return choice.value === value; })) {
        document.documentElement.setAttribute(group.attr, value);
      }
    });
  }
  window.TUTORIALS_PREFS = { defaults: DEFAULT_PREFS, options: OPTIONS, read: read };
  applyStored();
})();
