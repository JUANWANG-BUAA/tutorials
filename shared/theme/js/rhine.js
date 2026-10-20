/* Optional skin adapter. Owns only its removable decorations; never changes
 * course content, navigation handlers, search, formula markup, or preferences.
 */
(function () {
  "use strict";
  var root = document.documentElement;
  var mounted = [];
  var hiddenCover = null;
  var lastSkin;
  function decorate() {
    var skin = root.getAttribute("data-skin");
    if (skin === lastSkin) return;
    lastSkin = skin;
    mounted.forEach(function (node) { node.remove(); });
    mounted = [];
    if (hiddenCover) { hiddenCover.hidden = false; hiddenCover = null; }
    if (root.getAttribute("data-skin") !== "rhine") return;
    var main = document.querySelector(".content main");
    var heading = main && main.querySelector(":scope > h1");
    var cover = main && main.querySelector(".chapter-cover .cover-object");
    if (cover) {
      // The course slug comes from the book root, not the translated title.
      var slug = location.pathname.split("/").filter(Boolean).find(function (part) {
        return ["robot","matrix","numerical","deeplearning","linux","agent-systems","distributed","compilers"].indexOf(part) !== -1;
      });
      if (slug) {
        var plate = document.createElement("div");
        plate.className = "rhine-cover-plate";
        plate.setAttribute("aria-hidden", "true");
        var image = document.createElement("img");
        var bookRoot = location.pathname.slice(0, location.pathname.indexOf("/" + slug + "/"));
        image.src = bookRoot + "/shared/theme/assets/rhine-" + slug + ".svg";
        image.alt = "";
        image.addEventListener("error", function () { plate.remove(); cover.hidden = false; });
        plate.appendChild(image);
        cover.insertAdjacentElement("afterend", plate);
        cover.hidden = true; hiddenCover = cover; mounted.push(plate);
      }
    }
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
