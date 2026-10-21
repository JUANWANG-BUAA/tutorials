/* Run against a project subpath, e.g. http://127.0.0.1:8878/tutorials/.
 * Separate context deliberately allows real service workers and HTTP caching.
 */
async (hostPage) => {
  const url = new URL(hostPage.url());
  const prefix = url.pathname.replace(/\/(robot|matrix|numerical|deeplearning|linux|agent-systems|distributed|compilers)\/.*$/, '/').replace(/index\.html$/, '');
  const base = url.origin + prefix;
  const context = await hostPage.context().browser().newContext({ serviceWorkers: 'allow' });
  const page = await context.newPage();
  const checks = [];
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  const check = (ok, message) => { if (!ok) throw new Error(message); checks.push(message); };
  try {
    await page.goto(base + 'matrix/ch01/sec11.html');
    await page.waitForFunction(() => navigator.serviceWorker.controller, { timeout: 15000 });
    check(await page.evaluate(() => navigator.serviceWorker.controller.scriptURL.endsWith('/cache-worker.js')), 'project-subpath worker activates without a root-scope override');
    const assets = await page.evaluate(() => ({
      prefs: document.querySelector('script[src*="prefs-config-"]').src,
      highlight: document.querySelector('script[src*="highlight-"]').src,
      css: document.querySelector('link[href*="framework-"]').href,
      glossary: new URL(document.documentElement.dataset.glossary, location.href).href
    }));
    const texts = await page.evaluate(async assets => {
      const out = {};
      for (const [key, url] of Object.entries(assets)) out[key] = await (await fetch(url)).text();
      return out;
    }, assets);
    await page.waitForFunction(async assets => {
      const cache = await caches.open('tutorials-assets:' + new URL(navigator.serviceWorker.controller.scriptURL).pathname.replace('cache-worker.js', '') + ':v1');
      return (await Promise.all(Object.values(assets).map(url => cache.match(url)))).every(Boolean);
    }, assets);
    await context.setOffline(true);
    check(await page.evaluate(async ({ assets, texts }) => {
      for (const [key, url] of Object.entries(assets)) if (await (await fetch(url)).text() !== texts[key]) return false;
      return true;
    }, { assets, texts }), 'cached scripts, stylesheet and glossary are readable with the network offline');
    check(await page.evaluate(async () => {
      try { await fetch(location.href, { cache: 'no-store' }); return false; } catch { return true; }
    }), 'HTML is not silently pinned in the resource cache');
    await context.setOffline(false);
    await page.goto(base + 'robot/ch02/sec2-1.html');
    const robotPrefs = await page.locator('script[src*="prefs-config-"]').getAttribute('src');
    check(new URL(robotPrefs, page.url()).href === assets.prefs, 'switching books reuses exactly the same preference resource URL');
    await page.waitForLoadState('networkidle');
    const resourceResponses = [];
    const workerRequests = [];
    context.on('request', request => {
      if (request.serviceWorker() && request.url().includes('/shared/cache/')) workerRequests.push(request.url());
    });
    page.on('response', response => {
      if (response.url().includes('/shared/cache/')) resourceResponses.push({ url: response.url(), cached: response.fromServiceWorker() });
    });
    await page.reload();
    await page.waitForLoadState('networkidle');
    check(resourceResponses.length > 15 && resourceResponses.every(response => response.cached), 'return visits serve fingerprinted page resources through the service worker');
    check(workerRequests.length === 0, 'a warm return visit makes zero network requests for fingerprinted page resources');
    const requested = [];
    page.on('request', request => requested.push(request.url()));
    await page.waitForTimeout(2800);
    check(!requested.some(url => /searchindex-|toc\.html/.test(url)), 'normal reading does not fetch a search index or duplicate TOC');
    await page.keyboard.press('Control+k');
    await page.locator('#mdbook-searchbar').fill('机械手');
    await page.waitForFunction(() => document.querySelectorAll('#mdbook-searchresults li').length > 0);
    check(requested.some(url => /searchindex-/.test(url)), 'the Chinese search index loads on demand and remains searchable');
    check(errors.length === 0, 'cached pages have no uncaught JavaScript errors');
    return { passed: checks.length, cachedResources: resourceResponses.length, checks };
  } finally { await context.close(); }
}
