/* Optional skin adapter. Owns only its removable decorations; never changes
 * course content, navigation handlers, search, formula markup, or preferences.
 */
(function () {
  "use strict";
  var root = document.documentElement;
  var mounted = [];
  var lastSkin;
  function decorate() {
    var skin = root.getAttribute("data-skin");
    if (skin === lastSkin) return;
    lastSkin = skin;
    mounted.forEach(function (node) { node.remove(); });
    mounted = [];
    if (root.getAttribute("data-skin") !== "rhine") return;
    var main = document.querySelector(".content main");
    var heading = main && main.querySelector(":scope > h1");
    if (heading) {
      var strip = document.createElement("div");
      strip.className = "rhine-document-head";
      // Decorative metadata repeats the actual page title; omit from assistive reading.
      strip.setAttribute("aria-hidden", "true");
      var label = document.createElement("span");
      label.textContent = "COURSE ARCHIVE / 课程档案";
      var code = document.createElement("span");
      var anchor = heading.querySelector("a.header");
      var titleText = anchor ? anchor.textContent : document.title.split(" - ")[0];
      var index = titleText.match(/^\s*(\d+(?:\.\d+)*)/);
      code.textContent = index ? "SECTION / " + index[1] : "READING / 讲义";
      strip.appendChild(label);
      strip.appendChild(code);
      main.insertBefore(strip, heading);
      mounted.push(strip);
    }
  }
  document.addEventListener("tutorials:prefs", decorate);
  document.addEventListener("tutorials:skin", decorate);
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", decorate);
  else decorate();
})();
