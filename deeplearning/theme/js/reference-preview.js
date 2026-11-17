/* Book-local reference excerpts. Native links remain the only navigation action. */
(function () {
  "use strict";

  function boot() {
    const main = document.querySelector("main");
    if (!main || typeof fetch !== "function" || typeof DOMParser !== "function") return;
    // mdBook defines this lexical binding even when the book is hosted below a prefix.
    if (typeof path_to_root !== "string") return;
    const root = new URL(path_to_root || "./", location.href);
    const cache = new Map();
    const pending = new Map();
    let active = null;
    let hovered = null;
    let overCard = false;
    let touchFocus = false;
    let showTimer = 0;
    let hideTimer = 0;
    let generation = 0;
    let card = null;
    const excluded = "nav, .header, .term, .page-toc, #page-rail, .chapter-nav, .nav-chapters, .buttons, [role='navigation'], [role='button'], [download], [contenteditable='true']";

    function insideBook(url) {
      return url.origin === root.origin && url.pathname.startsWith(root.pathname) && /\.html$/i.test(url.pathname);
    }

    function reference(node) {
      if (!(node instanceof Element)) return null;
      const link = node.closest("a[href]");
      if (!link || !main.contains(link) || link.closest(excluded) || link.hasAttribute("aria-haspopup") || link.querySelector(".term")) return null;
      try {
        const url = new URL(link.getAttribute("href"), location.href);
        if (!insideBook(url) || url.search || /\/(?:print|404)\.html$/i.test(url.pathname)) return null;
        // Empty local links and chapter headings are navigation controls, not references.
        if (!url.hash && url.pathname === location.pathname) return null;
        return { link: link, url: url };
      } catch (_) { return null; }
    }

    async function targetDocument(url) {
      if (url.pathname === location.pathname) return document;
      const key = url.origin + url.pathname;
      if (cache.has(key)) {
        const value = cache.get(key);
        cache.delete(key);
        cache.set(key, value);
        return value;
      }
      if (pending.has(key)) return pending.get(key);
      if (pending.size >= 2) return null;
      const controller = new AbortController();
      const timeout = window.setTimeout(function () { controller.abort(); }, 8000);
      const request = (async function () {
        try {
          const response = await fetch(key, { signal: controller.signal, credentials: "same-origin", redirect: "error" });
          if (!response.ok || !/text\/html/i.test(response.headers.get("content-type") || "")) return null;
          if (Number(response.headers.get("content-length")) > 2000000) return null;
          const html = await response.text();
          if (html.length > 2000000) return null;
          // Parsed documents stay detached. Only allowlisted, newly created nodes enter the page.
          const parsed = new DOMParser().parseFromString(html, "text/html");
          if (!parsed.querySelector("main")) return null;
          cache.set(key, parsed);
          while (cache.size > 8) cache.delete(cache.keys().next().value);
          return parsed;
        } catch (_) { return null; }
        finally { window.clearTimeout(timeout); pending.delete(key); }
      })();
      pending.set(key, request);
      return request;
    }

    const htmlTags = new Set("p span strong em b i u s sub sup code pre br ul ol li blockquote table thead tbody tr th td".split(" "));
    const mathTags = new Set("math semantics mrow mi mo mn ms mtext mspace msup msub msubsup mfrac msqrt mroot munder mover munderover mtable mtr mtd menclose mpadded mphantom mmultiscripts mprescripts none annotation".split(" "));
    const mathAttributes = new Set("display mathvariant stretchy fence separator form accent accentunder largeop movablelimits lspace rspace minsize maxsize width height depth columnalign columnspacing rowspacing rowalign notation mathsize encoding".split(" "));
    const mathStyle = /^(?:height|width|min-width|max-width|top|bottom|left|right|margin(?:-left|-right|-top|-bottom)?|padding(?:-left|-right|-top|-bottom)?|vertical-align|font-size|border(?:-top|-bottom|-left|-right)?-width|position)$/;

    function copySafe(node, inMath) {
      if (node.nodeType === Node.TEXT_NODE) return document.createTextNode(node.nodeValue);
      if (node.nodeType !== Node.ELEMENT_NODE) return null;
      const tag = node.localName.toLowerCase();
      if (/^(script|style|iframe|object|embed|img|video|audio|button|input|select|textarea|form|summary|annotation-xml)$/.test(tag)) return null;
      const isMath = inMath || node.classList.contains("katex") || node.classList.contains("katex-display");
      const isMathML = node.namespaceURI === "http://www.w3.org/1998/Math/MathML" && mathTags.has(tag);
      const isSvg = isMath && node.namespaceURI === "http://www.w3.org/2000/svg" && /^(svg|path|line)$/.test(tag);
      let result;
      if (isMathML || isSvg) result = document.createElementNS(node.namespaceURI, tag);
      else if (htmlTags.has(tag)) result = document.createElement(tag);
      else result = document.createDocumentFragment(); // Links become ordinary, non-clickable text.
      if (result.nodeType === Node.ELEMENT_NODE) {
        if (isMath && !isMathML && !isSvg) {
          result.className = node.className;
          for (const property of node.style) {
            const value = node.style.getPropertyValue(property);
            if (mathStyle.test(property) && !/url|expression|var\(/i.test(value)) result.style.setProperty(property, value);
          }
        }
        if (node.getAttribute("aria-hidden") === "true" && isMath) result.setAttribute("aria-hidden", "true");
        for (const attribute of node.attributes) {
          if (isMathML && mathAttributes.has(attribute.name)) result.setAttribute(attribute.name, attribute.value);
          if (isSvg && /^(viewBox|viewbox|width|height|d|x1|x2|y1|y2|preserveAspectRatio)$/.test(attribute.name)) result.setAttribute(attribute.name, attribute.value);
        }
      }
      for (const child of node.childNodes) {
        const safe = copySafe(child, isMath);
        if (safe) result.appendChild(safe);
      }
      return result;
    }

    function extract(doc, url) {
      const content = doc.querySelector("main");
      if (!content) return null;
      let target;
      try { target = url.hash ? doc.getElementById(decodeURIComponent(url.hash.slice(1))) : content.querySelector("h1"); }
      catch (_) { return null; }
      if (!target || !content.contains(target)) return null;
      const box = target.closest(".box, .note, .proof, details");
      let titleNode = box && box.querySelector(".box-tag, summary");
      let blocks = [];
      if (box) {
        blocks = Array.from(box.children).filter(function (child) { return child !== titleNode && child.matches("p, ul, ol, table, pre, blockquote"); });
      } else if (/^H[1-6]$/.test(target.tagName)) {
        titleNode = target;
        let sibling = target.nextElementSibling;
        while (sibling && !/^H[1-6]$/.test(sibling.tagName)) {
          if (sibling.matches("p, ul, ol, table, pre, blockquote")) blocks.push(sibling);
          else if (sibling.matches(".box, .note, .proof")) blocks.push(...sibling.querySelectorAll(":scope > p, :scope > ul, :scope > ol"));
          if (blocks.length >= 3) break;
          sibling = sibling.nextElementSibling;
        }
      } else {
        const block = target.closest("p, li, table, pre, blockquote") || target;
        blocks = [block];
      }
      if (!titleNode) {
        const headings = content.querySelectorAll("h1, h2, h3, h4, h5, h6");
        for (const heading of headings) {
          if (heading.compareDocumentPosition(target) & Node.DOCUMENT_POSITION_FOLLOWING) titleNode = heading;
        }
      }
      if (!titleNode) return null;
      const excerpt = document.createDocumentFragment();
      let length = 0;
      let count = 0;
      for (const block of blocks) {
        if (!block.textContent.trim()) continue;
        if (count && (count >= 3 || length + block.textContent.length > 1200)) break;
        excerpt.appendChild(copySafe(block, false));
        length += block.textContent.length;
        count++;
      }
      if (!count) return null;
      // Do not include hidden KaTeX source/visual duplicates in the plain-text title.
      const titleCopy = titleNode.cloneNode(true);
      titleCopy.querySelectorAll(".katex-html, annotation").forEach(function (node) { node.remove(); });
      return { title: titleCopy.textContent.trim(), excerpt: excerpt };
    }

    function ensureCard() {
      if (card) return card;
      card = document.createElement("aside");
      card.id = "dl-reference-preview";
      card.className = "dl-reference-preview";
      card.setAttribute("role", "tooltip");
      card.hidden = true;
      card.addEventListener("pointerenter", function (event) {
        if (event.pointerType === "touch") return;
        overCard = true;
        window.clearTimeout(hideTimer);
      });
      card.addEventListener("pointerleave", function () { overCard = false; closeSoon(); });
      document.body.appendChild(card);
      return card;
    }

    function describe(link, add) {
      const ids = (link.getAttribute("aria-describedby") || "").split(/\s+/).filter(Boolean).filter(function (id) { return id !== "dl-reference-preview"; });
      if (add) ids.push("dl-reference-preview");
      if (ids.length) link.setAttribute("aria-describedby", ids.join(" "));
      else link.removeAttribute("aria-describedby");
    }

    function hide() {
      generation++;
      window.clearTimeout(showTimer);
      window.clearTimeout(hideTimer);
      if (active) describe(active, false);
      active = null;
      overCard = false;
      if (card) card.hidden = true;
    }

    function closeSoon() {
      window.clearTimeout(hideTimer);
      hideTimer = window.setTimeout(function () {
        if (!overCard && active !== hovered && document.activeElement !== active) hide();
      }, 220);
    }

    function position() {
      if (!card || card.hidden || !active) return;
      const viewport = window.visualViewport;
      const leftEdge = viewport ? viewport.offsetLeft : 0;
      const topEdge = viewport ? viewport.offsetTop : 0;
      const width = viewport ? viewport.width : document.documentElement.clientWidth;
      const height = viewport ? viewport.height : window.innerHeight;
      card.style.maxWidth = Math.max(0, width - 16) + "px";
      card.style.maxHeight = Math.max(0, height - 16) + "px";
      const anchor = active.getBoundingClientRect();
      const rect = card.getBoundingClientRect();
      const left = Math.max(leftEdge + 8, Math.min(anchor.left, leftEdge + width - rect.width - 8));
      const below = anchor.bottom + 8;
      const top = below + rect.height <= topEdge + height - 8 ? below : Math.max(topEdge + 8, anchor.top - rect.height - 8);
      card.style.left = Math.round(left) + "px";
      card.style.top = Math.round(top) + "px";
    }

    function schedule(item, delay) {
      if (active === item.link && card && !card.hidden) return;
      hide();
      active = item.link;
      const token = generation;
      showTimer = window.setTimeout(async function () {
        const doc = await targetDocument(item.url);
        if (!doc || generation !== token || active !== item.link) return;
        const result = extract(doc, item.url);
        if (!result) return;
        const preview = ensureCard();
        const label = document.createElement("div");
        label.className = "dl-reference-preview__label";
        label.textContent = (doc === document ? "本页" : "书内引用") + " · 原文摘录（非完整内容）";
        const title = document.createElement("div");
        title.className = "dl-reference-preview__title";
        title.textContent = result.title;
        const body = document.createElement("div");
        body.className = "dl-reference-preview__excerpt";
        body.appendChild(result.excerpt);
        const hint = document.createElement("div");
        hint.className = "dl-reference-preview__hint";
        hint.textContent = "跟随原链接查看全文 · Esc 关闭";
        preview.replaceChildren(label, title, body, hint);
        preview.hidden = false;
        preview.scrollTop = 0;
        describe(item.link, true);
        position();
      }, delay);
    }

    main.addEventListener("pointerover", function (event) {
      if (event.pointerType === "touch") return;
      const item = reference(event.target);
      if (!item || item.link.contains(event.relatedTarget)) return;
      hovered = item.link;
      window.clearTimeout(hideTimer);
      schedule(item, 280);
    });
    main.addEventListener("pointerout", function (event) {
      if (hovered && hovered.contains(event.target) && !hovered.contains(event.relatedTarget)) {
        hovered = null;
        closeSoon();
      }
    });
    document.addEventListener("pointerdown", function (event) {
      touchFocus = event.pointerType === "touch";
      if (touchFocus) hide();
    }, true);
    main.addEventListener("focusin", function (event) {
      const item = reference(event.target);
      if (item && !touchFocus) schedule(item, 0);
    });
    main.addEventListener("focusout", closeSoon);
    document.addEventListener("keydown", function (event) {
      touchFocus = false;
      if (event.key === "Escape") hide();
    });
    // No click is cancelled, including modifier-clicks and native hash navigation.
    main.addEventListener("click", hide);
    window.addEventListener("hashchange", hide);
    window.addEventListener("pagehide", hide);
    window.addEventListener("blur", hide);
    window.addEventListener("resize", position);
    window.addEventListener("scroll", function (event) {
      if (card && card.contains(event.target)) return;
      // Focusing an off-screen link scrolls it into view after focusin; keep its preview.
      if (active && document.activeElement === active) position();
      else hide();
    }, true);
    if (window.visualViewport) {
      window.visualViewport.addEventListener("resize", position);
      window.visualViewport.addEventListener("scroll", position);
    }
  }

  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", boot, { once: true });
  else boot();
})();
