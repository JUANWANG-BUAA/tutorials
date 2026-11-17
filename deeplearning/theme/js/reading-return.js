/* Return from a textbook reference without changing the link's native behavior. */
(function () {
  "use strict";

  function boot() {
    const main = document.querySelector("main");
    if (!main || typeof path_to_root !== "string") return;
    const root = new URL(path_to_root || "./", location.href);
    const storageKey = "deeplearning-reading-return:" + root.pathname;
    const stateKey = "__deeplearningReadingReturn";
    const maxEntries = 30;
    let button;

    function readData() {
      try {
        const data = JSON.parse(sessionStorage.getItem(storageKey) || "{}");
        return { entries: Array.isArray(data.entries) ? data.entries : [], pending: data.pending || null };
      } catch (_) { return null; }
    }

    function saveData(data) {
      try {
        sessionStorage.setItem(storageKey, JSON.stringify(data));
        return true;
      } catch (_) { return false; }
    }

    function reference(url) { return url.pathname + url.hash; }
    function currentReference() { return location.pathname + location.hash; }
    function inBook(url) {
      return url.origin === root.origin && url.pathname.startsWith(root.pathname) &&
        /\.html$/i.test(url.pathname) && !url.search;
    }
    function currentMarker() {
      const state = history.state;
      return state && typeof state === "object" && !Array.isArray(state) ? state[stateKey] : null;
    }
    function markedState(marker) {
      const state = history.state;
      if (state !== null && (typeof state !== "object" || Array.isArray(state))) return null;
      const next = Object.assign({}, state || {});
      if (marker) next[stateKey] = marker;
      else delete next[stateKey];
      return next;
    }
    function setMarker(marker) {
      const state = markedState(marker);
      if (!state) return false;
      try { history.replaceState(state, ""); return true; }
      catch (_) { return false; }
    }
    function validSource(source) {
      if (!source || typeof source.url !== "string" || !Number.isFinite(source.x) || !Number.isFinite(source.y)) return false;
      try { return inBook(new URL(source.url, location.origin)); }
      catch (_) { return false; }
    }
    function findEntry(data) {
      const marker = currentMarker();
      return data && data.entries.find(function (entry) {
        return entry.id === marker && entry.target === currentReference() && validSource(entry.source);
      });
    }
    function showButton() {
      const entry = !location.search && findEntry(readData());
      if (!entry) {
        if (button) button.hidden = true;
        return;
      }
      if (!button) {
        button = document.createElement("button");
        button.type = "button";
        button.className = "dl-reading-return";
        button.textContent = "← 返回阅读位置";
        button.addEventListener("click", returnToSource);
        document.body.appendChild(button);
      }
      button.hidden = false;
    }
    function restorePosition(source) {
      const restore = function () { window.scrollTo({ left: source.x, top: source.y, behavior: "instant" }); };
      requestAnimationFrame(function () { requestAnimationFrame(restore); });
      if (document.readyState !== "complete") window.addEventListener("load", restore, { once: true });
    }
    function returnToSource() {
      const data = readData();
      const entry = findEntry(data);
      if (!entry) { showButton(); return; }
      const source = entry.source;
      const url = new URL(source.url, location.origin);
      const parent = typeof source.parent === "string" ? source.parent : null;
      if (url.pathname === location.pathname) {
        const state = markedState(parent);
        if (!state) return;
        try { history.pushState(state, "", source.url); }
        catch (_) { return; }
        if (button) button.blur();
        restorePosition(source);
        showButton();
      } else {
        data.pending = { kind: "return", target: source.url, source: source };
        if (saveData(data)) location.assign(source.url);
      }
    }
    function arrive() {
      const data = readData();
      if (!data) return;
      const pending = data.pending;
      if (pending && pending.target === currentReference() && !location.search) {
        data.pending = null;
        if (pending.kind === "jump" && validSource(pending.source)) {
          const id = Date.now().toString(36) + "-" + Math.random().toString(36).slice(2);
          if (setMarker(id)) {
            data.entries.push({ id: id, target: pending.target, source: pending.source });
            data.entries = data.entries.slice(-maxEntries);
          }
        } else if (pending.kind === "return" && validSource(pending.source)) {
          setMarker(typeof pending.source.parent === "string" ? pending.source.parent : null);
          restorePosition(pending.source);
        }
        saveData(data);
      } else if (pending) {
        data.pending = null;
        saveData(data);
      }
      showButton();
    }

    document.addEventListener("click", function (event) {
      if (event.defaultPrevented || event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey || location.search) return;
      const link = event.target instanceof Element ? event.target.closest("a[href]") : null;
      const glossaryLink = link && link.matches("#term-popover a.term-popover-link");
      if (!link || (!main.contains(link) && !glossaryLink) || link.closest("nav, .header, .term, .page-toc, [role='navigation'], [contenteditable='true']") ||
          link.hasAttribute("download") || (link.target && link.target.toLowerCase() !== "_self")) return;
      let url;
      try { url = new URL(link.href, location.href); } catch (_) { return; }
      if (!inBook(url) || reference(url) === currentReference()) return;
      const data = readData();
      if (!data) return;
      data.pending = {
        kind: "jump",
        target: reference(url),
        source: { url: currentReference(), x: window.scrollX, y: window.scrollY, parent: currentMarker() }
      };
      saveData(data);
    });
    window.addEventListener("hashchange", arrive);
    window.addEventListener("popstate", arrive);
    window.addEventListener("pageshow", arrive);
    arrive();
  }

  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", boot, { once: true });
  else boot();
})();
