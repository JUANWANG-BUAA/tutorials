/* Optional portal composition. Data comes from the existing course catalogue.
 * Owns a removable subtree, its listeners and renderer; classic DOM is untouched.
 */
(function () {
  "use strict";
  var source = document.currentScript;
  var sceneURL = source && source.getAttribute("data-scene");
  var root = document.documentElement;
  var dispose = null;
  var generation = 0;
  var loader = null;
  function escape(value) {
    return String(value).replace(/[&<>"']/g, function (c) { return {"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]; });
  }
  function text(node, selector) { var el = node.querySelector(selector); return el ? el.textContent.trim() : ""; }
  function loadScene() {
    if (window.TUTORIALS_RHINE_SCENE) return Promise.resolve(window.TUTORIALS_RHINE_SCENE);
    if (!loader) loader = new Promise(function (resolve, reject) {
      var script = document.createElement("script");
      script.src = sceneURL;
      script.onload = function () { resolve(window.TUTORIALS_RHINE_SCENE); };
      script.onerror = function () { script.remove(); loader = null; reject(new Error("Scene unavailable")); };
      document.head.appendChild(script);
    });
    return loader;
  }

  var bootShown = false;
  function startBoot() {
    if (bootShown) return null;
    bootShown = true;
    try { if (sessionStorage.getItem("rhine-booted") === "1") return null; } catch (error) { /* storage optional */ }
    if (window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches) return null;
    var overlay = document.createElement("div");
    overlay.className = "rh-boot";
    overlay.setAttribute("role", "status");
    overlay.setAttribute("aria-live", "polite");
    overlay.setAttribute("aria-label", "正在载入档案终端");
    overlay.innerHTML = '<div class="rh-boot-status"><span>正在准备课程档案</span><span data-boot-progress>00</span><button type="button" class="rh-boot-skip">跳过</button></div><div class="rh-boot-track"><i></i></div>';
    document.body.appendChild(overlay);
    document.documentElement.classList.add("rhine-booting");
    var fill = overlay.querySelector(".rh-boot-track i");
    var number = overlay.querySelector("[data-boot-progress]");
    var done = false, raf = 0, timer = 0, start = performance.now();
    var duration = 1050;
    function cleanup() {
      cancelAnimationFrame(raf);
      clearTimeout(timer);
      overlay.removeEventListener("keydown", onKey);
      overlay.removeEventListener("click", onClick);
      document.documentElement.classList.remove("rhine-booting");
      if (overlay.parentNode) overlay.remove();
    }
    function finish() {
      if (done) return;
      done = true;
      cancelAnimationFrame(raf);
      clearTimeout(timer);
      document.documentElement.classList.remove("rhine-booting");
      try { sessionStorage.setItem("rhine-booted", "1"); } catch (error) { /* storage optional */ }
      overlay.classList.add("rh-boot-out");
      overlay.removeEventListener("keydown", onKey);
      timer = window.setTimeout(cleanup, 620);
    }
    function tick(now) {
      if (done) return;
      var pct = Math.min(100, ((now - start) / duration) * 100);
      fill.style.width = pct.toFixed(1) + "%";
      number.textContent = String(Math.round(pct)).padStart(2, "0");
      if (pct < 100) raf = requestAnimationFrame(tick);
      else timer = window.setTimeout(finish, 140);
    }
    function onKey(event) {
      if (event.key === "Escape" || event.key === "Enter" || event.key === " ") {
        event.preventDefault();
        finish();
      }
    }
    function onClick() { finish(); }
    overlay.addEventListener("click", onClick);
    overlay.addEventListener("keydown", onKey);
    raf = requestAnimationFrame(tick);
    return {
      dispose: function () {
        if (done) { cleanup(); return; }
        done = true;
        cleanup();
      }
    };
  }

  function mount() {
    generation += 1;
    if (dispose) { dispose(); dispose = null; }
    if (root.getAttribute("data-skin") !== "rhine") return;
    var original = document.querySelector("body > main");
    if (!original) return;
    /* The classic catalogue is the single source of truth. Read its semantic
       rows instead of duplicating course data; if the catalogue changes size
       or a course is added, this composition follows it. */
    var books = Array.from(original.querySelectorAll(".index-row")).map(function (row, index) {
      var slug = (row.getAttribute("href") || "").replace(/\/$/, "");
      var ownCover = row.querySelector(".row-cover");
      var fallbackCover = ownCover ? ownCover.getAttribute("src") : "";
      return {
        no: String(index + 1).padStart(2, "0"), title: text(row, ".row-title"), en: text(row, ".row-en"),
        description: text(row, ".row-desc"),
        meta: Array.from(row.querySelectorAll(".row-meta > span")).map(function (node) { return node.textContent.trim(); }).join(" · "),
        href: row.getAttribute("href"), fallbackCover: fallbackCover,
        cover: "shared/theme/assets/rhine-" + slug + ".svg"
      };
    });
    if (!books.length) return;
    var total = String(books.length).padStart(2, "0");
    var countWord = books.length === 8 ? "八" : (books.length === 7 ? "七" : String(books.length));
    var routeCount = String(original.querySelectorAll(".path-card").length).padStart(2, "0");
    var featureLink = original.querySelector(".feature-link");
    var atlasHref = featureLink ? featureLink.getAttribute("href") : "#rhine-books";
    var atlasLabel = featureLink ? featureLink.textContent.trim().replace(/^进入\s*/, "").replace(/\s*↗\s*$/, "") : "教学图版";
    var main = document.createElement("main");
    main.className = "rhine-portal";
    main.innerHTML = '<section class="rh-stage">' +
      '<div class="rh-graphic" aria-hidden="true"><i class="rh-graphic-band"></i><i class="rh-graphic-ring"></i><i class="rh-graphic-cross"></i></div>' +
      '<span class="rh-rail" aria-hidden="true">ATLAS / GRADUATE TEACHING LIBRARY / 2026</span>' +
      '<i class="rh-scanband" aria-hidden="true"></i>' +
      '<div class="rh-scene" aria-hidden="true"><div class="rh-scene-fallback"><img alt="" src="'+escape(books[0].cover)+'" data-fallback="'+escape(books[0].fallbackCover)+'"></div></div>' +
      '<div class="rh-stage-top rh-shell"><span>ATLAS / RESEARCH LIBRARY</span><span>'+total+' RECORDS · BUAA / 2026</span></div>' +
      '<div class="rh-hero rh-shell">' +
        '<div class="rh-hero-copy"><div class="rh-eyebrow"><i></i>GRADUATE COURSE ARCHIVE / 课程档案</div>' +
        '<h1 class="rh-brandmark">课程档案<span>COURSE ARCHIVE</span></h1>' +
        '<p class="rh-lede">研究生课程，一套可检索的知识档案。<br>数学 / 系统 / 智能，在讲义与图版之间建立坐标。</p></div>' +
        '<aside class="rh-file" aria-live="polite" aria-atomic="true"><div class="rh-file-top"><span data-selected-en></span><span>FILE <b data-selected-no>01</b> / '+total+'</span></div>' +
        '<h2 data-selected-title></h2><p data-selected-description></p><div class="rh-file-meta" data-selected-meta></div>' +
        '<a class="rh-access" data-access><span>读取档案</span><b>↗</b></a></aside>' +
      '</div>' +
      '<div class="rh-index rh-shell"><span class="rh-index-label">ARCHIVE / 01—'+total+'</span>' +
        '<div class="rh-index-list" role="group" aria-label="选择课程档案">'+books.map(function (book, index) {
          return '<button type="button" data-book="'+index+'" aria-pressed="'+(index===0)+'"><span>'+book.no+'</span><b>'+escape(book.title)+'</b></button>';
        }).join("")+'</div><a class="rh-scroll" href="#rhine-books">SCROLL <span>↓</span></a></div>' +
      '<div class="rh-stage-bottom rh-shell"><span>ATLAS / 研究生课程资料库</span><span>SELECT A FILE / 读取档案</span></div></section>' +
      '<section id="rhine-books" class="rh-collection rh-shell"><div class="rh-section-head"><div><div class="rh-eyebrow">01 / COURSE COLLECTION</div><h2>知识，分门归档。</h2></div><p>选择一门课程，<br>从导览、正文到章末练习逐步展开。</p></div>' +
      '<div class="rh-catalogue">'+books.map(function (book) {
        return '<a class="rh-course" href="'+escape(book.href)+'" data-no="'+book.no+'"><div class="rh-course-top"><span>ARCHIVE / '+book.no+'</span><span>↗</span></div>' +
          '<div class="rh-course-body"><div class="rh-course-cover"><img loading="lazy" src="'+escape(book.cover)+'" data-fallback="'+escape(book.fallbackCover)+'" alt=""></div><div class="rh-course-copy"><span>'+escape(book.en)+'</span><h3>'+escape(book.title)+'</h3><p>'+escape(book.description)+'</p></div></div>' +
          '<div class="rh-course-foot"><span>'+escape(book.meta)+'</span><b>进入课程 →</b></div></a>';
      }).join("")+'</div><p class="rh-catalogue-note">'+escape(text(original,".index-note"))+'</p></section>' +
      '<section class="rh-atlas-section"><div class="rh-shell rh-atlas-layout"><div class="rh-atlas-copy"><div class="rh-eyebrow">02 / VISUAL ANALYSIS</div><h2>看见结构。<br>理解关系。</h2><p>把抽象概念放回可以观察的坐标系。结构图、公式与读图提示，构成讲义的另一种语言。</p><a class="rh-text-link" href="'+escape(atlasHref)+'">查阅图版：'+escape(atlasLabel)+' <span>↗</span></a><dl><div><dt>FIGURE / R—02</dt><dd>位置 + 姿态 = 位姿</dd></div><div><dt>READING METHOD</dt><dd>观察 · 推导 · 验证</dd></div></dl></div><div class="rh-atlas-art"><div class="rh-plate-head"><span>ROBOTICS / SPATIAL ANALYSIS</span><span>PLATE 02</span></div><div data-atlas-art></div><div class="rh-plate-foot"><span>O → O′ / POSITION & ORIENTATION</span><span>6 DOF</span></div></div></div></section>' +
      '<section id="rhine-paths" class="rh-routes rh-shell"><div class="rh-section-head"><div><div class="rh-eyebrow">03 / RESEARCH PATHWAYS</div><h2>知识在此交汇。</h2></div><p>依前置知识建立连接，<br>也可以从任意一门课程开始。</p></div><div class="rh-route-grid"></div></section>' +
      '<section id="rhine-about" class="rh-about"><div class="rh-shell rh-about-layout"><div><div class="rh-eyebrow">04 / OPEN KNOWLEDGE</div><h2>保持好奇。<br>持续构建。</h2></div><div><p>'+escape(text(original,".about-main p"))+'</p><div class="rh-about-links"></div><div class="rh-about-mark">ATLAS <span>KNOWLEDGE ARCHIVE / BUAA</span></div></div></div></section>';
    main.style.setProperty("--rh-count", books.length);
    main.addEventListener("error", function (event) {
      var image = event.target;
      if (!image || image.tagName !== "IMG" || !image.getAttribute("data-fallback")) return;
      var fallback = image.getAttribute("data-fallback");
      image.removeAttribute("data-fallback");
      image.src = fallback;
    }, true);
    original.insertAdjacentElement("afterend", main);
    root.setAttribute("data-rhine-portal-ready", "true");
    var boot = startBoot();
    main.querySelector("[data-atlas-art]").innerHTML = `
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 480" role="img" aria-label="刚体位姿图解：从参考系 O 到本体系 O′ 的位置向量，以及两套坐标轴的姿态关系">
        <defs><pattern id="rhine-pose-grid" width="28" height="28" patternUnits="userSpaceOnUse"><path d="M28 0H0V28" fill="none" stroke="var(--line)" stroke-width=".6"/></pattern>
        <marker id="rhine-pose-arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M0 0L10 5L0 10Z" fill="context-stroke"/></marker></defs>
        <rect x="0" y="0" width="800" height="480" fill="url(#rhine-pose-grid)"/>
        <text x="28" y="38" class="rh-diagram-mono">REFERENCE FRAME → BODY FRAME</text>
        <text x="28" y="74" class="rh-diagram-title">位姿 = 位置 + 姿态</text>
        <ellipse cx="490" cy="231" rx="142" ry="48" transform="rotate(-24 490 231)" fill="var(--accent-soft)" stroke="var(--line-strong)" stroke-dasharray="4 6"/>
        <ellipse cx="490" cy="231" rx="70" ry="142" transform="rotate(30 490 231)" fill="none" stroke="var(--line)"/>
        <g fill="none" stroke="var(--ink-2)" stroke-width="2" marker-end="url(#rhine-pose-arrow)">
          <path d="M196 352L344 389"/><path d="M196 352L76 420"/><path d="M196 352V184"/>
        </g>
        <g fill="none" stroke="var(--atlas-cyan)" stroke-width="2" marker-end="url(#rhine-pose-arrow)">
          <path d="M490 231L660 270"/><path d="M490 231L361 336"/><path d="M490 231V88"/>
        </g>
        <path d="M196 352L490 231" fill="none" stroke="var(--accent)" stroke-width="2.5" marker-end="url(#rhine-pose-arrow)"/>
        <circle cx="196" cy="352" r="5" fill="var(--ink)"/><circle cx="490" cy="231" r="5" fill="var(--accent)"/>
        <g class="rh-diagram-label"><text x="176" y="374">O</text><text x="349" y="406">x</text><text x="61" y="439">y</text><text x="185" y="173">z</text>
          <text x="498" y="224">O′</text><text x="670" y="280">x′</text><text x="344" y="351">y′</text><text x="499" y="80">z′</text>
          <text x="285" y="270" fill="var(--accent-text)">位置向量 p</text></g>
        <text x="48" y="306" class="rh-diagram-mono">WORLD</text><text x="540" y="198" class="rh-diagram-mono">BODY</text>
        <path d="M538 366H754" stroke="var(--line-strong)"/>
        <text x="538" y="395" class="rh-diagram-label">位置 p · 三个坐标</text>
        <text x="538" y="423" class="rh-diagram-label">姿态 R · 三个独立角</text>
        <text x="28" y="460" class="rh-diagram-mono">TRANSLATION / 3 DOF</text><text x="540" y="460" class="rh-diagram-mono">ROTATION / 3 DOF</text>
      </svg>`;
    var routes = main.querySelector(".rh-route-grid");
    original.querySelectorAll(".path-card").forEach(function (card, index) {
      var article=document.createElement("article");article.className="rh-route";
      article.innerHTML='<span class="rh-route-number">'+String(index+1).padStart(2,"0")+'</span><div class="rh-eyebrow">'+escape(text(card,".path-tag"))+'</div><h3>'+escape(text(card,"h3"))+'</h3><p>'+escape(text(card,"p"))+'</p><div class="rh-route-links"></div><small>'+escape(text(card,".path-basis"))+'</small>';
      card.querySelectorAll(".path-chain a").forEach(function (link) { article.querySelector(".rh-route-links").appendChild(link.cloneNode(true)); });
      routes.appendChild(article);
    });
    original.querySelectorAll(".about-links a").forEach(function (link) { main.querySelector(".rh-about-links").appendChild(link.cloneNode(true)); });
    var navLinks=[];
    document.querySelectorAll('.topnav a[href^="#"]').forEach(function(link) {
      var old=link.getAttribute("href"); navLinks.push([link,old]);link.setAttribute("href",old.replace("#","#rhine-"));
    });
    var selected=0;
    var engaged=false;
    var titleMotion=null;

    var scene=null;
    var buttons=Array.from(main.querySelectorAll("[data-book]"));
    function select(index) {
      var next=(index+books.length)%books.length;
      if(engaged && next===selected)return;
      selected=next;
      var book=books[selected];
      main.querySelectorAll("[data-selected-no]").forEach(function(node){node.textContent=book.no;});
      main.querySelectorAll("[data-selected-en]").forEach(function(node){node.textContent=book.en;});
      main.querySelectorAll("[data-selected-title]").forEach(function(node){node.textContent=book.title;});
      main.querySelectorAll("[data-selected-description]").forEach(function(node){node.textContent=book.description;});
      main.querySelector("[data-selected-meta]").textContent=book.meta;
      main.querySelector("[data-access]").setAttribute("href",book.href);
      main.querySelector("[data-access]").setAttribute("aria-label","读取档案："+book.title);
      if(titleMotion){titleMotion.cancel();titleMotion=null;}
      var title=main.querySelector('.rh-file h2');
      if(title && title.animate && engaged && !window.matchMedia('(prefers-reduced-motion: reduce)').matches){
        titleMotion=title.animate([{opacity:.65},{opacity:1}],{duration:160,easing:'ease-out'});
      }
      var fallbackImage=main.querySelector(".rh-scene-fallback img");
      fallbackImage.src=book.cover;
      fallbackImage.setAttribute("data-fallback",book.fallbackCover || book.cover);
      buttons.forEach(function(button,i){button.setAttribute("aria-pressed",String(i===selected));});
      if(scene)scene.select(selected);
    }
    buttons.forEach(function(button,index){
      button.addEventListener("click",function(){select(index);});
      button.addEventListener("keydown",function(event){
        var next;
        if(event.key==="ArrowRight")next=selected+1;
        else if(event.key==="ArrowLeft")next=selected-1;
        else if(event.key==="Home")next=0;
        else if(event.key==="End")next=books.length-1;
        else return;
        event.preventDefault();select(next);buttons[selected].focus({preventScroll:true});buttons[selected].scrollIntoView({block:"nearest",inline:"nearest"});
      });
    });
    select(0);
    engaged=true;
    var ownGeneration=generation;
    loadScene().then(function(create){
      if(ownGeneration!==generation || !main.isConnected || !create)return;
      try { scene=create(main.querySelector(".rh-scene"),books,select);scene.select(selected); }
      catch(error) {
        main.dataset.sceneError=error instanceof Error ? error.message : String(error);
        console.error("Rhine scene initialization failed", error);
        main.classList.add("rh-scene-unavailable");
      }
    }).catch(function(){ if(main.isConnected)main.classList.add("rh-scene-unavailable"); });
    dispose=function(){
      if(titleMotion)titleMotion.cancel();
      if(boot){boot.dispose();boot=null;}
      if(scene)scene.dispose();
      navLinks.forEach(function(pair){pair[0].setAttribute("href",pair[1]);});
      main.remove();
      root.removeAttribute("data-rhine-portal-ready");
    };
  }
  document.addEventListener("tutorials:skin",mount);
  if(document.readyState==="loading")document.addEventListener("DOMContentLoaded",mount);else mount();
})();
