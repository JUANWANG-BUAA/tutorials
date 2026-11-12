/* Explicit, authored prerequisite links. The source page also works without JS. */
(function () {
  "use strict";
  var CORE = window.TUTORIALS_CORE;
  if (!CORE) return;

  CORE.register(function () {
    var main = document.querySelector("main");
    if (!main || /\/recall\.html$/.test(location.pathname)) return;
    var links = Array.from(main.querySelectorAll('a[href*="recall.html#"]')).filter(function (link) {
      var url = new URL(link.href, location.href);
      return url.origin === location.origin && /\/recall\.html$/.test(url.pathname);
    });
    if (!links.length) return;

    var popover = document.createElement("div");
    popover.id = "recall-popover";
    popover.className = "term-popover recall-popover";
    popover.setAttribute("role", "dialog");
    popover.setAttribute("aria-label", "公式与符号回忆");
    popover.hidden = true;
    document.body.appendChild(popover);
    var active = null;
    var pending = null;
    var request = 0;
    var openTimer = 0;
    var closeTimer = 0;
    var suppressFocus = false;
    var pages = new Map();

    function close() {
      window.clearTimeout(openTimer);
      window.clearTimeout(closeTimer);
      request++;
      pending = null;
      if (active) active.setAttribute("aria-expanded", "false");
      active = null;
      popover.hidden = true;
    }

    function restoreFocus(link) {
      if (!link) return;
      suppressFocus = true;
      link.focus({ preventScroll: true });
      suppressFocus = false;
    }

    function position(link) {
      var rect = link.getBoundingClientRect();
      var width = popover.offsetWidth;
      var height = popover.offsetHeight;
      var left = Math.max(8, Math.min(rect.left, window.innerWidth - width - 8));
      var above = rect.top - height - 10;
      var top = above >= 8 ? above : Math.max(8, Math.min(rect.bottom + 10, window.innerHeight - height - 8));
      popover.style.left = Math.round(left) + "px";
      popover.style.top = Math.round(top) + "px";
    }

    function load(url) {
      var pageUrl = new URL(url.href);
      pageUrl.hash = "";
      var key = pageUrl.href;
      if (!pages.has(key)) {
        var promise = fetch(key).then(function (response) {
          if (!response.ok) throw new Error("Recall page unavailable");
          return response.text();
        }).then(function (html) {
          return new DOMParser().parseFromString(html, "text/html");
        }).catch(function (error) {
          pages.delete(key); // A transient failure must not disable the links for the session.
          throw error;
        });
        pages.set(key, promise);
      }
      return pages.get(key);
    }

    function show(link, source, url, focusLink) {
      if (active) active.setAttribute("aria-expanded", "false");
      active = link;
      pending = null;
      link.setAttribute("aria-expanded", "true");
      popover.replaceChildren();
      var title = source.querySelector("h2");
      var head = document.createElement("div");
      head.className = "term-popover-head";
      var heading = document.createElement("b");
      heading.id = "recall-popover-title";
      if (title) {
        var titleContent = title.querySelector("a.header") || title;
        Array.from(titleContent.childNodes).forEach(function (node) {
          heading.appendChild(node.cloneNode(true));
        });
        heading.querySelectorAll("[id]").forEach(function (node) { node.removeAttribute("id"); });
      } else {
        heading.textContent = link.textContent;
      }
      head.appendChild(heading);
      var dismiss = document.createElement("button");
      dismiss.type = "button";
      dismiss.className = "recall-close";
      dismiss.textContent = "×";
      dismiss.setAttribute("aria-label", "关闭回忆提示");
      dismiss.addEventListener("click", function () { close(); restoreFocus(link); });
      head.appendChild(dismiss);
      popover.appendChild(head);
      popover.setAttribute("aria-labelledby", heading.id);
      var body = document.createElement("div");
      body.className = "term-popover-def";
      Array.from(source.children).forEach(function (child) {
        if (child === title || /^(SCRIPT|STYLE)$/.test(child.tagName)) return;
        var clone = child.cloneNode(true);
        clone.querySelectorAll("script, style, .header, .katex-copy").forEach(function (node) { node.remove(); });
        clone.querySelectorAll("[id]").forEach(function (node) { node.removeAttribute("id"); });
        clone.removeAttribute("id");
        clone.querySelectorAll("a[href]").forEach(function (anchor) {
          anchor.href = new URL(anchor.getAttribute("href"), url.href).href;
        });
        body.appendChild(clone);
      });
      popover.appendChild(body);
      var full = document.createElement("a");
      full.className = "term-popover-link";
      full.href = url.href;
      full.textContent = "打开完整解释 →";
      popover.appendChild(full);
      popover.hidden = false;
      popover.scrollTop = 0;
      position(link);
      if (focusLink) full.focus({ preventScroll: true });
    }

    function open(link, focusLink, navigateOnFailure) {
      window.clearTimeout(openTimer);
      window.clearTimeout(closeTimer);
      if (active === link && !popover.hidden) {
        if (focusLink) popover.querySelector(".term-popover-link").focus({ preventScroll: true });
        return;
      }
      pending = link;
      var ticket = ++request;
      var url = new URL(link.href, location.href);
      load(url).then(function (doc) {
        if (ticket !== request || pending !== link) return;
        var entry = doc.getElementById(decodeURIComponent(url.hash.slice(1)));
        if (!entry || !entry.classList.contains("recall-entry")) throw new Error("Recall entry unavailable");
        show(link, entry, url, focusLink);
      }).catch(function () {
        if (ticket !== request) return;
        pending = null;
        // Click/Enter still provide a working destination if the enhancement fails.
        if (navigateOnFailure) location.assign(url.href);
      });
    }

    function leave(link, event) {
      window.clearTimeout(openTimer);
      if (pending === link) { request++; pending = null; }
      var target = event.relatedTarget;
      if (target && (popover.contains(target) || link.contains(target))) return;
      if (active !== link) return;
      closeTimer = window.setTimeout(function () {
        if (!popover.contains(document.activeElement) && document.activeElement !== link && !popover.matches(":hover")) close();
      }, 180);
    }

    links.forEach(function (link) {
      if (link.dataset.recallReady === "1") return;
      link.dataset.recallReady = "1";
      link.classList.add("recall-link");
      link.setAttribute("aria-haspopup", "dialog");
      link.setAttribute("aria-controls", popover.id);
      link.setAttribute("aria-expanded", "false");
      link.addEventListener("mouseenter", function () {
        window.clearTimeout(closeTimer);
        window.clearTimeout(openTimer);
        openTimer = window.setTimeout(function () { open(link, false, false); }, 280);
      });
      link.addEventListener("mouseleave", function (event) { leave(link, event); });
      link.addEventListener("focus", function () { if (!suppressFocus) open(link, false, false); });
      link.addEventListener("blur", function (event) { leave(link, event); });
      link.addEventListener("click", function (event) {
        if (event.ctrlKey || event.metaKey || event.shiftKey || event.altKey || event.button !== 0) return;
        event.preventDefault();
        open(link, false, true);
      });
      link.addEventListener("keydown", function (event) {
        if (event.key !== "Enter" && event.key !== " ") return;
        if (event.ctrlKey || event.metaKey || event.shiftKey || event.altKey) return;
        event.preventDefault();
        open(link, true, true);
      });
    });
    popover.addEventListener("mouseenter", function () { window.clearTimeout(closeTimer); });
    popover.addEventListener("mouseleave", function (event) {
      if (active) leave(active, event);
    });
    popover.addEventListener("focusin", function () { window.clearTimeout(closeTimer); });
    popover.addEventListener("focusout", function (event) {
      if (!popover.contains(event.relatedTarget) && event.relatedTarget !== active) close();
    });
    document.addEventListener("keydown", function (event) {
      if (event.key !== "Escape" || (popover.hidden && !pending)) return;
      var trigger = active || pending;
      var returnFocus = popover.contains(document.activeElement);
      close();
      if (returnFocus) restoreFocus(trigger);
    });
    document.addEventListener("pointerdown", function (event) {
      if (!popover.contains(event.target) && !(active && active.contains(event.target)) && !(pending && pending.contains(event.target))) close();
    });
    window.addEventListener("scroll", function (event) {
      if (popover.contains(event.target) || !active || popover.hidden) return;
      var rect = active.getBoundingClientRect();
      if (rect.bottom < 0 || rect.top > window.innerHeight) close();
      else position(active);
    }, { passive: true, capture: true });
    window.addEventListener("resize", close, { passive: true });
  });
})();
