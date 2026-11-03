/**
 * mlm.js — 《马克思主义原理》页面增强脚本
 *
 * 功能：
 * 1. 公式横向滚动提示（宽公式左右渐隐提示）
 * 2. 回到顶部按钮（滚动超过一屏后显示）
 * 3. 页内目录生成（H2 小节数 ≥ 3 时自动生成）
 * 4. 表格响应式增强（移动端自动横向滚动）
 */

(function() {
  'use strict';

  // ========================================================================
  // §1 公式横向滚动提示
  // ========================================================================
  function enhanceFormulaScroll() {
    const displays = document.querySelectorAll('.katex-display');
    displays.forEach(el => {
      const checkScroll = () => {
        const canScroll = el.scrollWidth > el.clientWidth;
        const isAtStart = el.scrollLeft <= 2;
        const isAtEnd = el.scrollLeft + el.clientWidth >= el.scrollWidth - 2;

        el.classList.toggle('can-scroll', canScroll && isAtEnd);
        el.classList.toggle('scrolled-start', canScroll && !isAtStart);
      };

      checkScroll();
      el.addEventListener('scroll', checkScroll, { passive: true });
      window.addEventListener('resize', checkScroll, { passive: true });
    });
  }

  // ========================================================================
  // §2 回到顶部按钮
  // ========================================================================
  function setupBackToTop() {
    const btn = document.createElement('button');
    btn.id = 'back-to-top';
    btn.innerHTML = '↑';
    btn.setAttribute('aria-label', '回到顶部');
    btn.title = '回到顶部';
    document.body.appendChild(btn);

    let ticking = false;
    const onScroll = () => {
      if (!ticking) {
        window.requestAnimationFrame(() => {
          const shouldShow = window.scrollY > window.innerHeight * 1.2;
          btn.classList.toggle('visible', shouldShow);
          ticking = false;
        });
        ticking = true;
      }
    };

    window.addEventListener('scroll', onScroll, { passive: true });
    btn.addEventListener('click', () => {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
  }

  // ========================================================================
  // §3 页内目录生成
  // ========================================================================
  function generatePageTOC() {
    const content = document.querySelector('.content');
    if (!content) return;

    const headings = Array.from(content.querySelectorAll('h2'));
    // 只在 H2 数量 ≥ 3 时生成目录
    if (headings.length < 3) return;

    const firstH2 = headings[0];
    const toc = document.createElement('nav');
    toc.className = 'page-toc';
    toc.setAttribute('aria-label', '页内目录');

    headings.forEach(h => {
      const link = document.createElement('a');
      link.href = '#' + (h.id || '');
      link.textContent = h.textContent.replace(/^[\d\.\s]+/, ''); // 移除前导编号
      link.className = 'page-toc-link';
      toc.appendChild(link);
    });

    // 插入到第一个 H2 之前
    firstH2.parentNode.insertBefore(toc, firstH2);
  }

  // ========================================================================
  // §4 表格响应式增强
  // ========================================================================
  function enhanceTables() {
    const tables = document.querySelectorAll('.content table');
    tables.forEach(table => {
      // 为超宽表格添加滚动容器
      if (table.scrollWidth > table.clientWidth) {
        const wrapper = document.createElement('div');
        wrapper.style.overflowX = 'auto';
        wrapper.style.webkitOverflowScrolling = 'touch';
        table.parentNode.insertBefore(wrapper, table);
        wrapper.appendChild(table);
      }
    });
  }

  // ========================================================================
  // §5 引用标注增强（为 blockquote.cite 添加交互）
  // ========================================================================
  function enhanceCitations() {
    const cites = document.querySelectorAll('blockquote.cite');
    cites.forEach(cite => {
      // 为引文添加可访问性标注
      if (!cite.hasAttribute('role')) {
        cite.setAttribute('role', 'blockquote');
      }
    });
  }

  // ========================================================================
  // §6 初始化
  // ========================================================================
  function init() {
    enhanceFormulaScroll();
    setupBackToTop();
    generatePageTOC();
    enhanceTables();
    enhanceCitations();
  }

  // DOM 就绪后执行
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  // 监听页面切换（mdBook 的 SPA 导航）
  window.addEventListener('hashchange', () => {
    setTimeout(init, 100);
  });

})();
