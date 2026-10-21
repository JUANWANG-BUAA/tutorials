/* Run against ./build.sh serve using the Playwright skill CLI:
 * playwright-cli open http://127.0.0.1:8000/
 * playwright-cli run-code --filename tools/browser-interactions.js
 * This exercises built pages; no Playwright dependency is added to the site.
 */
async (hostPage) => {
  const url = new URL(hostPage.url());
  const page = await hostPage.context().browser().newPage({ serviceWorkers: 'block' });
  const prefix = url.pathname.replace(/\/(robot|matrix|numerical|deeplearning|linux|agent-systems|distributed|compilers)\/.*$/, '/');
  const base = url.origin + (prefix.endsWith('/') ? prefix : '/');
  const results = [];
  const errors = [];
  const check = (condition, name, detail) => {
    if (!condition) throw new Error(name + ': ' + JSON.stringify(detail));
    results.push(name);
  };
  page.on('pageerror', error => errors.push(error.message));
  await page.route('**/*', route => route.continue()); // Rebuilt fingerprinted pages must bypass an older preview cache.
  const visit = path => page.goto(base + path);

  await page.setViewportSize({ width: 1280, height: 800 });
  await visit('matrix/ch01/sec11.html');
  await page.waitForFunction(() => document.documentElement.classList.contains('atlas-ready'));
  check(await page.locator('.fig-scroll').count() > 0, 'wide figures have scroll containers');
  const figure = page.locator('main figure[data-zoomable="1"]').first();
  await figure.focus();
  const readingURL = page.url();
  await page.keyboard.press('ArrowRight');
  check(page.url() === readingURL, 'arrows on a figure do not navigate chapters');
  await page.keyboard.press('Enter');
  check(await page.locator('#figure-zoom').evaluate(el => el.open), 'Enter opens figure zoom');
  check(await page.locator('.figure-zoom-close').evaluate(el => el === document.activeElement), 'zoom initially focuses its close control');
  check(await page.evaluate(() => {
    const ids = [...document.querySelectorAll('[id]')].map(el => el.id);
    return ids.length === new Set(ids).size;
  }), 'zoom clones do not duplicate SVG or caption IDs');
  await page.keyboard.press('Escape');
  check(await figure.evaluate(el => el === document.activeElement), 'zoom returns focus to its figure');

  await page.getByRole('button', { name: '打开本页图鉴', exact: true }).click();
  check(await page.evaluate(() => {
    const ids = [...document.querySelectorAll('[id]')].map(el => el.id);
    return ids.length === new Set(ids).size;
  }), 'gallery and zoom can coexist without duplicate SVG IDs');
  await page.keyboard.press('Escape');
  await page.setViewportSize({ width: 390, height: 600 });
  const pan = page.locator('.fig-scroll').first();
  check(await pan.evaluate(el => el.scrollWidth > el.clientWidth), 'mobile diagrams retain readable size and pan horizontally');
  check(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1), 'mobile figures do not widen the document');

  await visit('robot/ch02/sec2-1.html');
  const imageFigure = page.locator('main figure[data-zoomable="1"]').filter({ has: page.locator('img') }).first();
  await imageFigure.focus();
  await page.keyboard.press('Enter');
  check(await page.locator('#figure-zoom img').getAttribute('loading') === 'eager', 'image zoom loads its full image immediately');
  await page.keyboard.press('Escape');

  await page.getByRole('button', { name: '阅读偏好', exact: true }).click();
  check(await page.locator('#prefs-panel').evaluate(el => { const r = el.getBoundingClientRect(); return r.left >= 0 && r.right <= innerWidth && r.bottom <= innerHeight; }), 'preferences stay inside the mobile viewport');
  await page.keyboard.press('Escape');
  check(await page.locator('#prefs-toggle').evaluate(el => el === document.activeElement), 'preferences restore keyboard focus');

  const term = page.locator('main .term').first();
  await term.waitFor();
  await term.focus();
  await page.keyboard.press('Enter');
  check(await page.locator('#term-popover a').evaluate(el => el === document.activeElement), 'a term definition link is reachable directly by keyboard');
  await page.keyboard.press('Escape');
  check(await page.locator('#term-popover').isHidden() && await term.evaluate(el => el === document.activeElement), 'closing a term returns focus without reopening it');

  await visit('matrix/ch01/sec11.html');

  check(await page.evaluate(() => {
    let called = 0;
    window.TUTORIALS_CORE.register(() => called++);
    return called === 1;
  }), 'modules registered after page initialization run once');

  const folds = await page.evaluate(async () => {
    const solutions = [...document.querySelectorAll('details.sol-box')];
    solutions.forEach((el, index) => { el.open = index === 0; });
    await new Promise(resolve => setTimeout(resolve, 100));
    const before = localStorage.getItem('tutorials-open-folds');
    window.dispatchEvent(new Event('beforeprint'));
    window.dispatchEvent(new Event('beforeprint'));
    await new Promise(resolve => setTimeout(resolve, 100));
    const during = localStorage.getItem('tutorials-open-folds');
    window.dispatchEvent(new Event('afterprint'));
    await new Promise(resolve => setTimeout(resolve, 100));
    return { count: solutions.length, saved: before === during && before === localStorage.getItem('tutorials-open-folds'), restored: solutions.every((el, i) => el.open === (i === 0)) };
  });
  check(folds.count > 0 && folds.saved && folds.restored, 'printing preserves saved solution folds even with repeated beforeprint', folds);

  await page.keyboard.press('Control+k');
  check(await page.locator('#mdbook-searchbar').evaluate(el => el === document.activeElement), 'Ctrl+K opens and focuses search');
  const ime = await page.locator('#mdbook-searchbar').evaluate(el => {
    let events = 0;
    const count = () => events++;
    el.addEventListener('keyup', count);
    el.dispatchEvent(new CompositionEvent('compositionstart', { bubbles: true }));
    el.value = '线';
    el.dispatchEvent(new InputEvent('input', { bubbles: true, isComposing: true }));
    el.dispatchEvent(new KeyboardEvent('keyup', { bubbles: true, isComposing: true, keyCode: 229 }));
    const intermediate = events;
    el.value = '线性空间';
    el.dispatchEvent(new CompositionEvent('compositionend', { bubbles: true }));
    el.removeEventListener('keyup', count);
    return { intermediate, committed: events };
  });
  check(ime.intermediate === 0 && ime.committed === 1, 'IME searches committed text instead of partial candidates', ime);
  await page.waitForFunction(() => document.querySelectorAll('#mdbook-searchresults li').length > 0);
  results.push('Chinese search returns results');
  await page.keyboard.press('Escape');
  await visit('matrix/ch01/sec11.html?search=zzzzqxxxyyy987654321');
  await page.waitForFunction(() => document.querySelector('#mdbook-searchresults-header').textContent.includes('没有命中'));
  await page.keyboard.press('Escape');
  await page.waitForTimeout(700);
  check(!new URL(page.url()).searchParams.has('search'), 'closing an empty-result deep search does not resurrect its query');

  await page.route('**/searchindex-*.js', async route => {
    await route.abort();
  });
  await visit('distributed/index.html');
  await page.keyboard.press('Control+k');
  await page.getByRole('button', { name: '重试', exact: true }).waitFor();
  check(await page.locator('#mdbook-searchbar-outer').getAttribute('aria-busy') === 'false', 'search download failures expose an actionable retry');
  await page.unroute('**/searchindex-*.js');
  await page.getByRole('button', { name: '重试', exact: true }).click();
  await page.locator('#mdbook-searchbar').fill('复制');
  await page.waitForFunction(() => document.querySelectorAll('#mdbook-searchresults li').length > 0);
  results.push('search recovers after a failed index download');

  await visit('numerical/training/arena.html');
  await page.locator('.arena-level:not(:disabled)').first().click();
  const firstQuestion = await page.locator('.arena-stage').getAttribute('data-qid');
  const questionID = firstQuestion;
  const correct = await page.locator('#arena-bank .arena-q').evaluateAll((items, id) => Number(items.find(el => el.dataset.id === id).dataset.a), questionID);
  await page.locator('.arena-stage .arena-opts li').nth(correct).focus();
  await page.keyboard.press('Enter');
  await page.waitForTimeout(1100);
  check(await page.locator('.arena-stage').getAttribute('data-qid') === firstQuestion, 'keyboard answer keeps its explanation until explicit next');
  check(await page.locator('.arena-feedback').isVisible(), 'answer feedback remains visible for reading');
  await page.getByRole('button', { name: '退出本关', exact: true }).focus();
  await page.keyboard.press('Enter');
  check(await page.locator('.arena-panel').isVisible(), 'Enter on quit exits instead of answering or advancing');
  await page.locator('.arena-level:not(:disabled)').first().click();
  await page.evaluate(() => {
    const now = Date.now.bind(Date);
    Date.now = () => now() + 60 * 60 * 1000;
    document.dispatchEvent(new Event('visibilitychange'));
  });
  check(await page.locator('.arena-result').isVisible(), 'arena expires by elapsed time after a throttled interval');

  await visit('numerical/ch01/mock-exam.html');
  await page.getByRole('button', { name: '开始计时', exact: true }).click();
  await page.evaluate(() => {
    const now = Date.now.bind(Date);
    Date.now = () => now() + 24 * 60 * 60 * 1000;
    document.dispatchEvent(new Event('visibilitychange'));
  });
  check(await page.getByRole('button', { name: '时间到', exact: true }).isDisabled(), 'exam timer also uses elapsed time');

  await visit('linux/part1/ch18.html');
  check(await page.locator('pre').evaluateAll(pres => pres.every(pre => pre.querySelectorAll('.clip-button, .copy-code').length <= 1)), 'Linux code blocks have a single copy action');
  check(await page.locator('pre code.language-asm .hljs-keyword, pre code.language-asm .hljs-built_in').count() > 0, 'assembly examples have actual syntax highlighting');

  await visit('matrix/ch01/sec13.html');
  const destination = await page.locator('main h2[id]').nth(1).getAttribute('id');
  await page.locator('main h2[id]').nth(1).scrollIntoViewIfNeeded();
  await page.evaluate(id => {
    const el = document.getElementById(id);
    window.scrollTo({ top: el.getBoundingClientRect().top + scrollY - 90, behavior: 'instant' });
  }, destination);
  await page.waitForFunction(id => Math.abs(document.getElementById(id).getBoundingClientRect().top - 90) < 3, destination);
  await visit('matrix/index.html');
  const resumeHref = await page.locator('.continue-link').getAttribute('href');
  check(resumeHref.endsWith('#' + encodeURIComponent(destination)), 'continue reading resumes at the last visible section', resumeHref);

  await page.setViewportSize({ width: 1280, height: 800 });
  for (const book of ['robot', 'matrix', 'numerical', 'deeplearning', 'linux', 'agent-systems', 'distributed', 'compilers']) {
    await visit(book + '/index.html');
    check(await page.locator('html').getAttribute('data-book') === book && await page.locator('#prefs-toggle').count() === 1, book + ' initializes the shared reader');
    await page.keyboard.press('Control+k');
    await page.locator('#mdbook-searchbar').fill({ robot: '机械手', matrix: '线性', numerical: '误差', deeplearning: '梯度', linux: '进程', 'agent-systems': '工具', distributed: '一致性', compilers: '编译' }[book]);
    await page.waitForFunction(() => document.querySelectorAll('#mdbook-searchresults li').length > 0);
    results.push(book + ' searches its compact Chinese index');
  }
  check(errors.length === 0, 'no uncaught JavaScript errors during the reader checks', errors);
  await page.close();
  return { passed: results.length, checks: results };
}
