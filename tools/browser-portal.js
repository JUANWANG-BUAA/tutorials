/* Real portal workflows, including Pages subpaths and optional storage. */
async (hostPage) => {
  const base = new URL('./', hostPage.url()).href;
  const browser = hostPage.context().browser();
  const context = await browser.newContext({ serviceWorkers: 'block', reducedMotion: 'reduce' });
  const page = await context.newPage();
  const errors = [];
  const checks = [];
  const check = (ok, label) => { if (!ok) throw new Error(label); checks.push(label); };
  page.on('pageerror', error => errors.push(error.message));
  try {
    await page.goto(base);
    await page.keyboard.press('Tab');
    check(await page.locator('.skip-link').evaluate(el => el === document.activeElement), 'keyboard starts at the portal skip link');
    await page.keyboard.press('Enter');
    check(await page.locator('#main-content').evaluate(el => el === document.activeElement), 'skip link moves focus into course content');
    const tools = () => page.locator('.course-tools:visible');
    const rows = () => page.locator('.index-row:visible, .rh-course:visible');
    check(await rows().count() === 8, 'all eight courses are available initially');
    await tools().getByRole('searchbox').fill('ＬＩＮＵＸ');
    check(await rows().count() === 1 && (await rows().textContent()).includes('Linux 系统与内核'), 'full-width mixed-case course keywords normalize correctly');
    await tools().getByRole('searchbox').press('Escape');
    check(await rows().count() === 8, 'Escape clears the course query');
    await tools().getByRole('button', { name: '人工智能', exact: true }).click();
    check(await rows().count() === 2, 'direction filters select deep learning and Agent courses');
    await tools().getByRole('searchbox').fill('不存在的课程xyz');
    check(await rows().count() === 0 && await page.locator('.course-empty:visible').count() === 1, 'an empty catalogue explains how to recover');
    await tools().getByRole('button', { name: '重置筛选' }).click();
    check(await rows().count() === 8 && await tools().getByRole('searchbox').evaluate(el => el === document.activeElement), 'reset restores the full catalogue and input focus');
    await tools().getByRole('searchbox').fill('矩阵 分解');
    check(await rows().count() === 1, 'multiple keywords match across course copy');
    await page.getByLabel('界面外观').selectOption('rhine');
    check(await rows().count() === 1 && await tools().getByRole('searchbox').inputValue() === '矩阵 分解', 'the optional skin retains course filter state');
    check(await page.locator('.skip-link').getAttribute('href') === '#rhine-main-content', 'the skip link targets the active portal composition');
    await tools().getByRole('button', { name: '重置筛选' }).click();
    await tools().getByRole('button', { name: '系统工程', exact: true }).click();
    check(await rows().count() === 4, 'Rhine filters the same system courses');
    await page.getByLabel('界面外观').selectOption('classic');
    check(await rows().count() === 4 && await tools().getByRole('button', { name: '系统工程', exact: true }).getAttribute('aria-pressed') === 'true', 'returning to classic synchronizes filter controls and results');
    await page.getByRole('button', { name: '切换为深色', exact: true }).click();
    check(await page.getByRole('button', { name: '切换为浅色', exact: true }).count() === 1, 'brightness control names the next action');

    await page.goto(base + 'matrix/ch01/sec13.html');
    const heading = page.locator('main h2[id]').nth(1);
    const headingId = await heading.getAttribute('id');
    await heading.evaluate(el => window.scrollTo({ top: el.getBoundingClientRect().top + scrollY - 90, behavior: 'instant' }));
    check((await page.locator('.mobile-nav-chapters.next .chapter-nav-copy').textContent()).includes('1.4'), 'reading footer identifies the destination chapter');
    check((await page.locator('.nav-chapters.next').getAttribute('aria-label')).includes('1.4'), 'desktop chapter arrows announce their destination');
    check(await page.locator('.nav-wrapper').evaluate(el => {
      const links = [...el.querySelectorAll('a')].map(a => a.getBoundingClientRect());
      return getComputedStyle(el).display === 'flex' && links.length === 2 &&
        Math.abs(links[0].top - links[1].top) < 2 && links.every(r => r.width > 200);
    }), 'desktop chapter cards share a full-width row');
    await page.goto(base);
    const resume = page.locator('.portal-resume').first();
    check((await resume.getAttribute('href')).endsWith('matrix/ch01/sec13.html#' + encodeURIComponent(headingId)), 'portal resume preserves the last visible heading');
    await resume.click();
    check(new URL(page.url()).hash === '#' + encodeURIComponent(headingId), 'resume opens the saved section under the deployment subpath');
    await page.goto(base + 'matrix/');
    check((await page.locator('.continue-meta').textContent()).includes('已浏览') && (await page.locator('.continue-meta').textContent()).includes('页'), 'reading history describes page visits without implying completion');

    await page.goto(base);
    await page.evaluate(() => {
      const root = new URL('matrix/', location.href).pathname;
      localStorage.setItem('tutorials-last:' + root, JSON.stringify({ path: 'https://example.com/matrix/attack.html', title: '<img src=x onerror=alert(1)>' }));
      localStorage.setItem('tutorials-last:' + new URL('linux/', location.href).pathname, 'null');
    });
    await page.reload();
    check(await page.locator('.portal-resume').count() === 0, 'invalid and external saved locations are ignored');
    await page.setViewportSize({ width: 390, height: 600 });
    check(await page.getByRole('link', { name: '课程目录', exact: true }).isVisible(), 'mobile navigation retains a direct catalogue link');
    check(await page.locator('.hero-visual').isHidden(), 'mobile course discovery is not displaced by a decorative cover');
    await page.getByLabel('界面外观').selectOption('rhine');
    await page.getByRole('link', { name: '课程目录', exact: true }).click();
    check(new URL(page.url()).hash === '#rhine-books', 'mobile catalogue navigation follows the selected skin');
    check(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1), 'the mobile portal fits its viewport');
    await page.screenshot({ path: 'output/playwright/ux-portal-mobile.png' });

    await page.addInitScript(() => {
      for (const method of ['getItem', 'setItem', 'removeItem']) Storage.prototype[method] = () => { throw new Error('Storage denied'); };
    });
    await page.goto(base);
    await tools().getByRole('searchbox').fill('编译器');
    check(await rows().count() === 1, 'course discovery works with storage denied');
    check(errors.length === 0, 'portal workflows have no uncaught errors: ' + errors.join('; '));
  } finally {
    await context.close();
  }
  const plain = await browser.newContext({ javaScriptEnabled: false });
  try {
    const fallback = await plain.newPage();
    await fallback.goto(base);
    check(await fallback.locator('.index-row').count() === 8 && await fallback.locator('.index-row').first().isVisible(), 'all course links remain accessible without JavaScript');
  } finally { await plain.close(); }
  return { passed: checks.length, checks };
}
