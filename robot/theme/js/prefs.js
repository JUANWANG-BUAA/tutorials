/*
 * 阅读偏好层 — 三本书共用（robot / numerical / matrix 三份内容逐字相同）
 * ---------------------------------------------------------------------------
 * 给读者五个可调项：字体 / 字号 / 行距间距 / 版心宽度 / 配色主题。
 * 状态存在 localStorage，并写到 <html> 的 data-* 属性上；真正的样式规则在
 * theme/css/prefs.css（本文件只负责取值、落属性与面板 UI），这样「看」与「控」
 * 分离，关掉 JS 时页面就是默认外观，不会缺内容。
 *
 * 首屏防闪：属性由 theme/head.hbs 里的内联脚本在 <head> 阶段就写好（早于首次
 * 绘制），本文件只在末尾补面板。因此这里的 apply() 对首屏是「幂等重放」。
 *
 * 面板的取值必须与 prefs.css 的选择器一一对应；改选项请同时改两处，
 * 并把 DEFAULT_PREFS 与 head.hbs 里的默认集合保持一致。
 */
(function () {
  "use strict";

  var root = document.documentElement;
  var STORE_PREFIX = "tutorials-prefs:";
  var MENU_BAR_ID = "mdbook-menu-bar";

  /* 默认值刻意都是「不写属性」的那一档：设置层出现之前的样子就是默认外观，
     升级不会改变任何老读者的观感。 */
  var DEFAULT_PREFS = {
    font: "serif",
    size: "m",
    density: "standard",
    width: "standard",
    palette: "warm"
  };

  var OPTIONS = [
    {
      key: "font", label: "字体", attr: "data-font",
      choices: [
        { value: "serif", label: "衬线" },
        { value: "sans", label: "黑体" },
        { value: "system", label: "系统" }
      ]
    },
    {
      key: "size", label: "字号", attr: "data-size",
      choices: [
        { value: "s", label: "小" },
        { value: "m", label: "中" },
        { value: "l", label: "大" }
      ]
    },
    {
      key: "density", label: "行距间距", attr: "data-density",
      choices: [
        { value: "compact", label: "紧凑" },
        { value: "standard", label: "标准" },
        { value: "loose", label: "宽松" }
      ]
    },
    {
      key: "width", label: "版心宽度", attr: "data-width",
      choices: [
        { value: "narrow", label: "窄" },
        { value: "standard", label: "标准" },
        { value: "wide", label: "宽" }
      ]
    },
    {
      key: "palette", label: "配色主题", attr: "data-palette",
      choices: [
        { value: "warm", label: "暖纸", swatch: "#f8f4ec" },
        { value: "cool", label: "冷灰", swatch: "#43648f" },
        { value: "sage", label: "苔绿", swatch: "#4f7a52" },
        { value: "contrast", label: "高对比", swatch: "#000000" }
      ]
    }
  ];

  function readStored(key) {
    try {
      var raw = localStorage.getItem(STORE_PREFIX + key);
      return raw === null ? null : raw;
    } catch (error) { return null; }
  }

  function writeStored(key, value) {
    try { localStorage.setItem(STORE_PREFIX + key, value); } catch (error) { /* 隐私模式静默降级 */ }
  }

  /* 收集当前生效值：以已落地的属性为准（head.hbs 可能已先行写入），
     属性缺失或取值非法时回落到默认档。 */
  function currentPrefs() {
    var prefs = {};
    OPTIONS.forEach(function (group) {
      var allowed = group.choices.map(function (c) { return c.value; });
      var fromAttr = root.getAttribute(group.attr);
      if (fromAttr && allowed.indexOf(fromAttr) !== -1) { prefs[group.key] = fromAttr; return; }
      var fromStore = readStored(group.key);
      if (fromStore && allowed.indexOf(fromStore) !== -1) { prefs[group.key] = fromStore; return; }
      prefs[group.key] = DEFAULT_PREFS[group.key];
    });
    return prefs;
  }

  /* 默认档不落属性（外观 = 权威样式表），非默认档落属性（外观 = prefs.css）。 */
  function applyPrefs(prefs) {
    OPTIONS.forEach(function (group) {
      var value = prefs[group.key];
      if (value === DEFAULT_PREFS[group.key]) root.removeAttribute(group.attr);
      else root.setAttribute(group.attr, value);
    });
  }

  function persistPrefs(prefs) {
    OPTIONS.forEach(function (group) { writeStored(group.key, prefs[group.key]); });
  }

  function buildToggle() {
    var button = document.createElement("button");
    button.type = "button";
    button.className = "prefs-toggle";
    button.id = "prefs-toggle";
    button.setAttribute("aria-haspopup", "true");
    button.setAttribute("aria-expanded", "false");
    button.setAttribute("title", "阅读偏好：字体、字号、间距与配色");
    button.setAttribute("aria-label", "阅读偏好");
    button.innerHTML = '<span class="prefs-aa" aria-hidden="true">Aa</span>';
    return button;
  }

  function buildPanel(prefs, onChange, onReset) {
    var panel = document.createElement("div");
    panel.className = "prefs-panel";
    panel.id = "prefs-panel";
    panel.setAttribute("role", "group");
    panel.setAttribute("aria-label", "阅读偏好设置");
    panel.hidden = true;

    var head = document.createElement("div");
    head.className = "prefs-head";
    head.innerHTML = '<b>阅读偏好</b><span>本地保存，仅本机生效</span>';
    panel.appendChild(head);

    var inputs = {};

    OPTIONS.forEach(function (group) {
      var row = document.createElement("div");
      row.className = "prefs-row";

      var label = document.createElement("span");
      label.className = "prefs-label";
      label.textContent = group.label;
      row.appendChild(label);

      var opts = document.createElement("div");
      opts.className = "prefs-opts";
      opts.setAttribute("role", "group");
      opts.setAttribute("aria-label", group.label);

      var buttons = [];
      group.choices.forEach(function (choice) {
        var btn = document.createElement("button");
        btn.type = "button";
        btn.className = "prefs-opt";
        btn.textContent = choice.label;
        if (choice.swatch) {
          var swatch = document.createElement("span");
          swatch.className = "prefs-swatch";
          swatch.style.background = choice.swatch;
          btn.insertBefore(swatch, btn.firstChild);
        }
        btn.setAttribute("aria-pressed", String(prefs[group.key] === choice.value));
        btn.addEventListener("click", function () {
          prefs[group.key] = choice.value;
          buttons.forEach(function (other) {
            other.setAttribute("aria-pressed", String(other === btn));
          });
          onChange();
        });
        buttons.push(btn);
        opts.appendChild(btn);
      });

      row.appendChild(opts);
      panel.appendChild(row);
      inputs[group.key] = buttons;
    });

    var foot = document.createElement("div");
    foot.className = "prefs-foot";
    var note = document.createElement("span");
    note.className = "prefs-note";
    note.textContent = "打印时沿用字体与间距";
    var reset = document.createElement("button");
    reset.type = "button";
    reset.className = "prefs-reset";
    reset.textContent = "恢复默认";
    reset.addEventListener("click", function () {
      Object.keys(DEFAULT_PREFS).forEach(function (key) { prefs[key] = DEFAULT_PREFS[key]; });
      onReset();
      inputs && Object.keys(inputs).forEach(function (key) {
        inputs[key].forEach(function (btn, index) {
          var group = OPTIONS.filter(function (g) { return g.key === key; })[0];
          btn.setAttribute("aria-pressed", String(group.choices[index].value === prefs[key]));
        });
      });
    });
    foot.appendChild(note);
    foot.appendChild(reset);
    panel.appendChild(foot);

    return panel;
  }

  function bootPrefs() {
    var bar = document.getElementById(MENU_BAR_ID);
    if (!bar || document.getElementById("prefs-toggle")) return;

    var prefs = currentPrefs();
    applyPrefs(prefs);

    var toggle = buildToggle();
    var panel = buildPanel(
      prefs,
      function () { applyPrefs(prefs); persistPrefs(prefs); },
      function () { applyPrefs(prefs); persistPrefs(prefs); }
    );

    function closePanel() {
      panel.hidden = true;
      toggle.setAttribute("aria-expanded", "false");
      document.removeEventListener("click", onDocumentClick, true);
      document.removeEventListener("keydown", onKeydown, true);
    }

    function openPanel() {
      panel.hidden = false;
      toggle.setAttribute("aria-expanded", "true");
      // 捕获阶段：点面板内不关，点外面才关；先挂监听再让它收到本次点击
      document.addEventListener("click", onDocumentClick, true);
      document.addEventListener("keydown", onKeydown, true);
    }

    function onDocumentClick(event) {
      if (panel.contains(event.target) || toggle.contains(event.target)) return;
      closePanel();
    }

    function onKeydown(event) {
      if (event.key === "Escape") { closePanel(); toggle.focus(); }
    }

    toggle.addEventListener("click", function () {
      if (panel.hidden) openPanel(); else closePanel();
    });

    // 面板与按钮的插入点：菜单栏右侧按钮组；找不到就退回菜单栏本身
    var anchor = bar.querySelector(".right-buttons") || bar;
    anchor.insertBefore(toggle, anchor.firstChild);
    bar.appendChild(panel);
  }

  function boot() {
    try { bootPrefs(); } catch (error) { /* 偏好层是纯增益，自身出错不能拖垮页面 */ }
  }

  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", boot);
  else boot();
})();
