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
  if (toggle) toggle.addEventListener("click", function () {
    var next = root.getAttribute("data-theme") === "light" ? "dark" : "light";
    root.setAttribute("data-theme", next);
    try { localStorage.setItem("atlas-portal-theme", next); } catch (error) { /* Storage optional. */ }
  });
})();
