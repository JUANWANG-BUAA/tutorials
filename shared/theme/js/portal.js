/* Portal controls consume the same skin registry as the reading preferences.
 * Brightness remains the portal's own existing preference.
 */
(function () {
  "use strict";
  var root = document.documentElement;
  var config = window.TUTORIALS_PREFS;
  var select = document.getElementById("skinSelect");
  if (select && config) {
    var group = config.options.filter(function (option) { return option.key === "skin"; })[0];
    group.choices.forEach(function (choice) {
      var option = document.createElement("option");
      option.value = choice.value;
      option.textContent = choice.label;
      select.appendChild(option);
    });
    select.value = root.getAttribute(group.attr) || config.defaults.skin;
    select.addEventListener("change", function () {
      if (select.value === config.defaults.skin) root.removeAttribute(group.attr);
      else root.setAttribute(group.attr, select.value);
      document.dispatchEvent(new CustomEvent("tutorials:skin"));
      try { localStorage.setItem("tutorials-prefs:skin", select.value); } catch (error) { /* Storage optional. */ }
    });
  }
  var toggle = document.getElementById("themeToggle");
  function syncThemeLabel() {
    if (!toggle) return;
    var label = root.getAttribute("data-theme") === "dark" ? "切换为浅色" : "切换为深色";
    toggle.setAttribute("aria-label", label);
    toggle.title = label;
  }
  syncThemeLabel();
  if (toggle) toggle.addEventListener("click", function () {
    var next = root.getAttribute("data-theme") === "light" ? "dark" : "light";
    root.setAttribute("data-theme", next);
    syncThemeLabel();
    try { localStorage.setItem("atlas-portal-theme", next); } catch (error) { /* Storage optional. */ }
  });
})();

/* Course discovery is shared by both portal compositions. Course rows remain the
 * source of truth, and every control is optional when JavaScript/storage is off. */
(function () {
  "use strict";
  var filter = { query: "", topic: "all" };
  var sequence = 0;
  var catalogue = Array.from(document.querySelectorAll(".index-row"));
  var topics = [["all", "全部课程"], ["math", "数学与控制"], ["systems", "系统工程"], ["ai", "人工智能"]];

  function normalize(value) { return value.normalize("NFKC").toLocaleLowerCase().replace(/\s+/g, " ").trim(); }

  function enhanceCatalogue(container, selector) {
    if (!container || container.querySelector(".course-tools")) return;
    var rows = Array.from(container.querySelectorAll(selector));
    var entries = rows.map(function (row) {
      return { row: row, text: normalize(row.textContent), topics: (row.dataset.topics || "").split(" ") };
    });
    var tools = document.createElement("div");
    tools.className = "course-tools";
    tools.setAttribute("role", "search");
    tools.setAttribute("aria-label", "筛选课程目录");
    var inputId = "course-query-" + (++sequence);
    tools.innerHTML = '<label class="course-search-label" for="'+inputId+'">查找课程</label>' +
      '<div class="course-search-row"><input id="'+inputId+'" type="search" placeholder="输入课程名或关键词，如：矩阵、Linux、编译器" autocomplete="off" enterkeyhint="search"><button class="course-reset" type="button">重置筛选</button></div>' +
      '<div class="course-filters" role="group" aria-label="课程方向"></div><p class="course-count" role="status" aria-live="polite" aria-atomic="true"></p>';
    var input = tools.querySelector("input");
    var count = tools.querySelector(".course-count");
    input.setAttribute("aria-describedby", inputId + "-count");
    count.id = inputId + "-count";
    input.value = filter.query;
    var empty = document.createElement("p");
    empty.className = "course-empty";
    empty.textContent = "没有找到匹配的课程。试试更短的关键词，或重置筛选查看全部课程。";
    empty.hidden = true;
    var group = tools.querySelector(".course-filters");
    topics.forEach(function (topic) {
      var button = document.createElement("button");
      button.type = "button";
      button.className = "course-filter";
      button.textContent = topic[1];
      button.dataset.topic = topic[0];
      button.addEventListener("click", function () { filter.topic = topic[0]; update(); });
      group.appendChild(button);
    });
    function update() {
      var terms = normalize(filter.query).split(" ").filter(Boolean);
      var shown = 0;
      entries.forEach(function (entry) {
        var matches = (filter.topic === "all" || entry.topics.indexOf(filter.topic) !== -1) &&
          terms.every(function (term) { return entry.text.indexOf(term) !== -1; });
        entry.row.hidden = !matches;
        if (matches) shown++;
      });
      group.querySelectorAll("button").forEach(function (button) {
        button.setAttribute("aria-pressed", String(button.dataset.topic === filter.topic));
      });
      count.textContent = "显示 " + shown + " / " + rows.length + " 门课程 · 按课程名或简介筛选，全文搜索请进入对应课程";
      empty.hidden = shown !== 0;
    }
    var composing = false;
    input.addEventListener("compositionstart", function () { composing = true; });
    input.addEventListener("compositionend", function () { composing = false; filter.query = input.value; update(); });
    input.addEventListener("input", function () {
      if (composing) return;
      filter.query = input.value;
      update();
    });
    input.addEventListener("keydown", function (event) {
      if (event.key !== "Escape" || composing || event.isComposing) return;
      event.preventDefault();
      input.value = filter.query = "";
      update();
    });
    tools.querySelector(".course-reset").addEventListener("click", function () {
      input.value = filter.query = "";
      filter.topic = "all";
      update();
      input.focus();
    });
    container.refreshCatalogue = function () { input.value = filter.query; update(); };
    container.insertBefore(tools, container.firstChild);
    container.appendChild(empty);
    update();
  }

  function renderRecent() {
    var previous = document.querySelector(".portal-recent");
    if (previous) previous.remove();
    var records = [];
    catalogue.forEach(function (row) {
      var root = new URL(row.getAttribute("href"), location.href);
      try {
        var last = JSON.parse(localStorage.getItem("tutorials-last:" + root.pathname) || "null");
        if (!last || typeof last.path !== "string" || typeof last.title !== "string" || !last.title.trim()) return;
        var url = new URL(last.path, location.href);
        if (url.origin !== location.origin || url.pathname !== last.path || !url.pathname.startsWith(root.pathname) ||
          !/\.html$/.test(url.pathname) || /\/(index|print|404)\.html$/.test(url.pathname) || url.search || url.hash) return;
        if (typeof last.hash === "string" && last.hash[0] === "#") url.hash = last.hash;
        records.push({ url: url, title: last.title, course: row.querySelector(".row-title").textContent,
          updatedAt: Number.isFinite(last.updatedAt) ? last.updatedAt : 0 });
      } catch (error) { /* Invalid records and denied storage leave the catalogue usable. */ }
    });
    records.sort(function (a, b) { return b.updatedAt - a.updatedAt; });
    if (!records.length) return;
    var recent = document.createElement("aside");
    recent.className = "portal-recent wrap";
    recent.setAttribute("aria-label", "继续阅读");
    recent.innerHTML = '<div class="portal-recent-head"><h2>继续阅读</h2><p>回到上次浏览的位置 · 记录保存在当前浏览器</p></div><div class="portal-recent-links"></div>';
    records.slice(0, 3).forEach(function (record) {
      var link = document.createElement("a");
      link.className = "portal-resume";
      link.href = record.url.pathname + record.url.hash;
      var course = document.createElement("span");
      course.textContent = record.course;
      var title = document.createElement("b");
      title.textContent = record.title;
      link.appendChild(course);
      link.appendChild(title);
      recent.lastChild.appendChild(link);
    });
    document.querySelector(".topbar").insertAdjacentElement("afterend", recent);
  }

  function syncSkipLink() {
    document.querySelectorAll(".course-tools").forEach(function (tools) {
      tools.parentElement.refreshCatalogue();
    });
    var target = document.querySelector(".rhine-portal") || document.getElementById("main-content");
    var link = document.querySelector(".skip-link");
    if (link && target) {
      if (!target.id) target.id = "rhine-main-content";
      target.tabIndex = -1;
      link.href = "#" + target.id;
    }
  }
  window.TUTORIALS_PORTAL = { enhanceCatalogue: enhanceCatalogue };
  enhanceCatalogue(document.querySelector(".index-list"), ".index-row");
  renderRecent();
  window.addEventListener("pageshow", renderRecent);
  window.addEventListener("storage", renderRecent);
  document.addEventListener("tutorials:skin", function () { queueMicrotask(syncSkipLink); });
  document.addEventListener("DOMContentLoaded", function () { queueMicrotask(syncSkipLink); });
})();
