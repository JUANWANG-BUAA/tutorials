/*
 * 阅读偏好层 — 三本书共用（robot / numerical / matrix 三份内容逐字相同）
 * ---------------------------------------------------------------------------
 * 面板给读者四项可调：字体 / 字号 / 行距间距 / 版心宽度。状态存 localStorage，
 * 并写到 <html> 的 data-* 属性上；真正的样式规则在 theme/css/prefs.css（本文件
 * 只负责取值、落属性与面板 UI），这样「看」与「控」分离，关掉 JS 时页面就是
 * 默认外观，不会缺内容。
 *
 * 配色**不在**本层：明暗与配色只有菜单栏的 mdBook 原生主题弹层一个入口，
 * 避免同一件事出现两套状态。
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
    palette: "theme",
    bg: "theme"
  };

  /* 六个轴与 prefs.css 的选择器一一对应；改选项请同时改三处：
     这里 / prefs.css 的 §1–§5.6 / head.hbs 的 KEYS。 */
  var OPTIONS = [
    {
      key: "font", label: "字体", attr: "data-font",
      choices: [
        { value: "serif", label: "衬线" },
        { value: "sans", label: "黑体" },
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
      key: "palette", label: "纸张配色", attr: "data-palette",
      choices: [
        { value: "theme", label: "随主题" },
        { value: "neutral", label: "中性", swatch: "#9aa0a6" },
        { value: "cool", label: "冷灰", swatch: "#4a6f96" },
        { value: "sage", label: "苔绿", swatch: "#4f7a52" },
        { value: "contrast", label: "高对比", swatch: "#111111" }
      ]
    },
    {
      key: "bg", label: "背景纹理", attr: "data-bg",
      choices: [
        { value: "theme", label: "随主题" },
        { value: "wash", label: "暖光网格" },
        { value: "plain", label: "纯净" },
        { value: "grid", label: "细网格" },
        { value: "graph", label: "方格纸" },
        { value: "ruled", label: "横线稿纸" },
        { value: "dots", label: "点阵" },
        { value: "paper", label: "纸张纤维" }
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
    /* 版心宽度会改变正文右缘，右侧粘性大纲（framework.js）要靠它重算余量 */
    try { document.dispatchEvent(new CustomEvent("tutorials:prefs")); } catch (error) { /* 老内核无 CustomEvent 时忽略 */ }
  }

  function persistPrefs(prefs) {
    OPTIONS.forEach(function (group) { writeStored(group.key, prefs[group.key]); });
  }

  function buildToggle() {
    var button = document.createElement("button");
    button.type = "button";
    /* 与菜单栏原生图标按钮同一套盒子（height:100%、padding:0 8px、hover/按下反馈
       都来自 .icon-button）——自绘一个 34px 的小盒子会让 Aa 比邻居高一截、hover 也不同。 */
    button.className = "icon-button prefs-toggle";
    button.id = "prefs-toggle";
    button.setAttribute("aria-haspopup", "true");
    button.setAttribute("aria-expanded", "false");
    button.setAttribute("aria-controls", "prefs-panel");
    button.setAttribute("title", "阅读偏好：字体、字号、间距与版心");
    button.setAttribute("aria-label", "阅读偏好");
    button.innerHTML = '<span class="prefs-aa" aria-hidden="true">Aa</span>';
    return button;
  }

  function buildPanel(prefs, onChange) {
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
        if (choice.swatch) {
          var swatch = document.createElement("span");
          swatch.className = "prefs-swatch";
          swatch.setAttribute("aria-hidden", "true");
          swatch.style.setProperty("--swatch", choice.swatch);
          btn.appendChild(swatch);
        }
        btn.appendChild(document.createTextNode(choice.label));
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
      OPTIONS.forEach(function (group) { prefs[group.key] = DEFAULT_PREFS[group.key]; });
      applyPrefs(prefs);
      persistPrefs(prefs);
      OPTIONS.forEach(function (group) {
        inputs[group.key].forEach(function (btn, index) {
          btn.setAttribute("aria-pressed", String(group.choices[index].value === prefs[group.key]));
        });
      });
    });
    foot.appendChild(note);
    foot.appendChild(reset);
    panel.appendChild(foot);

    return panel;
  }

  /* 原生主题弹层与本面板同属「外观」，同时开着会挡住彼此。
     打开本面板时顺手收起它——mdBook 用 style.display 控制该弹层，这里同样处理。 */
  function closeThemePopup() {
    var list = document.getElementById("mdbook-theme-list");
    var toggle = document.getElementById("mdbook-theme-toggle");
    if (list) list.style.display = "none";
    if (toggle) toggle.setAttribute("aria-expanded", "false");
  }

  function bootPrefs() {
    var bar = document.getElementById(MENU_BAR_ID);
    if (!bar || document.getElementById("prefs-toggle")) return;

    var prefs = currentPrefs();
    applyPrefs(prefs);

    var toggle = buildToggle();
    var panel = buildPanel(prefs, function () { applyPrefs(prefs); persistPrefs(prefs); });

    function closePanel() {
      panel.hidden = true;
      toggle.setAttribute("aria-expanded", "false");
      document.removeEventListener("click", onDocumentClick, true);
      document.removeEventListener("keydown", onKeydown, true);
      window.removeEventListener("resize", positionPanel);
    }

    /* 面板挂在按钮正下方（而不是菜单栏左缘）：这是它与原生主题弹层唯一有意分歧的
       一处——读者点的是 Aa，弹出的面板就该从 Aa 开始。左右做视口夹紧，窄屏贴边。 */
    function positionPanel() {
      var bar = document.getElementById(MENU_BAR_ID);
      if (!bar) return;
      var barRect = bar.getBoundingClientRect();
      var toggleRect = toggle.getBoundingClientRect();
      var width = panel.offsetWidth || 336;
      var maxLeft = Math.max(8, bar.clientWidth - width - 8);
      var left = Math.max(8, Math.min(toggleRect.left - barRect.left, maxLeft));
      panel.style.left = Math.round(left) + "px";
    }

    function openPanel() {
      closeThemePopup();
      panel.hidden = false;
      positionPanel();
      toggle.setAttribute("aria-expanded", "true");
      // 捕获阶段：点面板内不关，点外面才关；先挂监听再让它收到本次点击
      document.addEventListener("click", onDocumentClick, true);
      document.addEventListener("keydown", onKeydown, true);
      window.addEventListener("resize", positionPanel);
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

    /* 插入点：原生主题钮右侧（两处外观设置挨着），找不到就退回按钮组/菜单栏。 */
    var themeToggle = document.getElementById("mdbook-theme-toggle");
    var leftButtons = bar.querySelector(".left-buttons");
    if (themeToggle && themeToggle.parentElement) {
      themeToggle.parentElement.insertBefore(toggle, themeToggle.nextSibling);
    } else if (leftButtons) {
      leftButtons.appendChild(toggle);
    } else {
      bar.insertBefore(toggle, bar.firstChild);
    }
    bar.appendChild(panel);
  }

  function boot() {
    try { bootPrefs(); } catch (error) { /* 偏好层是纯增益，自身出错不能拖垮页面 */ }
  }

  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", boot);
  else boot();
})();
