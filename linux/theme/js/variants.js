/* 架构 × 语言切换器：页面级，选择持久化到 localStorage。
 *
 * 约定（Markdown 里直接写）：
 *   <div class="variant" data-arch="x86-64" data-lang="asm">
 *
 *   ```asm
 *   ...
 *   ```
 *
 *   </div>
 *
 * data-arch: x86-64 | arm64 | riscv64 | all
 * data-lang: c | rust | asm | all
 *
 * 同一页可有多组；切换器统一控制。没有 .variant 的页面不注入工具栏。
 */
(function () {
  "use strict";

  var ARCH_KEY = "linux.variant.arch";
  var LANG_KEY = "linux.variant.lang";
  var ARCHES = [
    ["x86-64", "x86-64"],
    ["arm64", "ARM64"],
    ["riscv64", "RISC-V 64"]
  ];
  var LANGS = [
    ["c", "C"],
    ["rust", "Rust"],
    ["asm", "汇编"]
  ];

  function read(key, fallback) {
    try {
      var value = localStorage.getItem(key);
      var choices = key === ARCH_KEY ? ARCHES : LANGS;
      return choices.some(function (choice) { return choice[0] === value; }) ? value : fallback;
    } catch (e) {
      return fallback;
    }
  }

  function write(key, value) {
    try {
      localStorage.setItem(key, value);
    } catch (e) {
      /* 隐私模式忽略 */
    }
  }

  function hasVariants() {
    return document.querySelector(".variant[data-arch][data-lang]") !== null;
  }

  function apply(arch, lang) {
    var variants = document.querySelectorAll(".variant[data-arch][data-lang]");
    var visible = 0;
    for (var i = 0; i < variants.length; i++) {
      var v = variants[i];
      var va = v.getAttribute("data-arch");
      var vl = v.getAttribute("data-lang");
      var ok = (va === "all" || va === arch) && (vl === "all" || vl === lang);
      if (ok) {
        v.removeAttribute("hidden");
        visible++;
      } else {
        v.setAttribute("hidden", "");
      }
    }
    var note = document.querySelector(".variant-note");
    if (note) {
      note.textContent = visible === 0
        ? "本页暂无「" + labelOf(ARCHES, arch) + " · " + labelOf(LANGS, lang) + "」版本，试试其它组合。"
        : "";
    }
    var buttons = document.querySelectorAll(".variant-switcher button");
    for (var j = 0; j < buttons.length; j++) {
      var b = buttons[j];
      var kind = b.getAttribute("data-kind");
      var val = b.getAttribute("data-value");
      var on = (kind === "arch" && val === arch) || (kind === "lang" && val === lang);
      b.classList.toggle("is-active", on);
      b.setAttribute("aria-pressed", on ? "true" : "false");
    }
  }

  function labelOf(list, value) {
    for (var i = 0; i < list.length; i++) {
      if (list[i][0] === value) return list[i][1];
    }
    return value;
  }

  function button(kind, value, text, state) {
    var b = document.createElement("button");
    b.type = "button";
    b.setAttribute("data-kind", kind);
    b.setAttribute("data-value", value);
    b.setAttribute("aria-pressed", "false");
    b.textContent = text;
    b.addEventListener("click", function () {
      if (kind === "arch") {
        state.arch = value;
        write(ARCH_KEY, state.arch);
      } else {
        state.lang = value;
        write(LANG_KEY, state.lang);
      }
      apply(state.arch, state.lang);
    });
    return b;
  }


  function addCopyButtons() {
    var blocks = document.querySelectorAll("pre > code");
    for (var i = 0; i < blocks.length; i++) {
      var code = blocks[i];
      var pre = code.parentNode;
      if (!pre || pre.querySelector(".copy-code, .clip-button")) continue;
      var btn = document.createElement("button");
      btn.type = "button";
      btn.className = "copy-code";
      btn.textContent = "复制";
      btn.setAttribute("aria-label", "复制代码");
      btn.addEventListener("click", function (ev) {
        var b = ev.currentTarget;
        var c = b.parentNode.querySelector("code");
        if (!c) return;
        var core = window.TUTORIALS_CORE;
        if (!core) return;
        core.copyText(c.textContent).then(function () {
          b.textContent = "已复制";
          b.classList.add("is-copied");
          core.toast("已复制代码");
        }, function () { b.textContent = "复制失败"; core.toast("复制失败，请手动选中代码"); }).finally(function () {
          setTimeout(function () { b.textContent = "复制"; b.classList.remove("is-copied"); }, 1400);
        });
      });
      pre.appendChild(btn);
    }
  }

  function inject() {
    if (!hasVariants() || document.querySelector(".variant-switcher")) return;

    var host = document.querySelector("main") || document.querySelector("#content") || document.body;
    var box = document.createElement("div");
    box.className = "variant-switcher";
    box.setAttribute("role", "group");
    box.setAttribute("aria-label", "切换架构与系统编程语言");

    var state = {
      arch: read(ARCH_KEY, "x86-64"),
      lang: read(LANG_KEY, "c")
    };

    var labA = document.createElement("span");
    labA.className = "variant-kicker";
    labA.textContent = "架构";
    box.appendChild(labA);
    ARCHES.forEach(function (a) {
      box.appendChild(button("arch", a[0], a[1], state));
    });

    var sep = document.createElement("span");
    sep.className = "variant-sep";
    box.appendChild(sep);

    var labL = document.createElement("span");
    labL.className = "variant-kicker";
    labL.textContent = "语言";
    box.appendChild(labL);
    LANGS.forEach(function (l) {
      box.appendChild(button("lang", l[0], l[1], state));
    });

    var note = document.createElement("span");
    note.className = "variant-note";
    note.setAttribute("role", "status");
    box.appendChild(note);

    host.insertBefore(box, host.firstChild);
    apply(state.arch, state.lang);
  }

  function boot() {
    addCopyButtons();
    inject();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }
})();
