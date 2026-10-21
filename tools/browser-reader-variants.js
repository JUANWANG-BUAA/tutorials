/* Optional second browser pass; invoke with playwright-cli run-code --filename. */
async (hostPage) => {
  const url = new URL(hostPage.url());
  const prefix = url.pathname.replace(/\/(robot|matrix|numerical|deeplearning|linux|agent-systems|distributed|compilers)\/.*$/, '/').replace(/index\.html$/, '');
  const origin = url.origin + prefix.replace(/\/$/, '');
  const page = await hostPage.context().browser().newPage({ serviceWorkers: 'block' });
  const results = [];
  const errors = [];
  page.on('pageerror', error => errors.push(error.stack || error.message));
  await page.route('**/*', route => route.continue());
  const check = (ok, name) => { if (!ok) throw new Error(name); results.push(name); };
  await page.setViewportSize({ width: 1280, height: 800 });
  await page.goto(origin + '/matrix/ch01/sec16.html');
  const canvas = page.locator('.widget-canvas').first();
  await canvas.focus();
  const before = await page.locator('.widget-readout').first().textContent();
  const chapterUrl = page.url();
  await page.keyboard.press('ArrowRight');
  check(await page.locator('.widget-readout').first().textContent() !== before && page.url() === chapterUrl, 'vector keyboard controls update the diagram and retain the chapter');
  const readout = await page.locator('.widget-readout').first().textContent();
  await canvas.dispatchEvent('pointerdown', { button: 2, pointerId: 2, isPrimary: true, clientX: 20, clientY: 20 });
  check(await page.locator('.widget-readout').first().textContent() === readout, 'secondary-button clicks do not drag a vector');
  await page.screenshot({ path: 'output/playwright/ux-vector-desktop.png' });

  await page.addInitScript(() => {
    if (!location.pathname.endsWith('/robot/ch02/sec2-1.html')) return;
    document.addEventListener('DOMContentLoaded', () => {
      const figure = document.querySelector('main figure');
      const fold = document.createElement('details');
      fold.id = 'qa-hidden-figure';
      const summary = document.createElement('summary');
      summary.textContent = 'Hidden image regression fixture';
      fold.appendChild(summary);
      figure.before(fold);
      fold.appendChild(figure);
    }, { once: true });
  });
  await page.goto(origin + '/robot/ch02/sec2-1.html');
  check(await page.locator('#qa-hidden-figure').evaluate(el => !el.open), 'the figure starts inside a closed disclosure');
  await page.locator('#qa-hidden-figure summary').click();
  await page.waitForFunction(() => document.querySelector('#qa-hidden-figure figure').dataset.zoomable === '1');
  results.push('expanding a hidden figure enables zoom without reloading');

  for (const theme of ['light', 'rust', 'coal', 'navy', 'ayu']) {
    await page.evaluate(theme => {
      document.documentElement.classList.remove('light', 'rust', 'coal', 'navy', 'ayu');
      document.documentElement.classList.add(theme);
    }, theme);
    check(await page.locator('main').evaluate(el => getComputedStyle(el).visibility !== 'hidden'), theme + ' retains visible reading content');
  }
  await page.getByRole('button', { name: '阅读偏好', exact: true }).click();
  await page.getByRole('button', { name: '莱茵档案', exact: true }).click();
  await page.keyboard.press('Escape');
  check(await page.locator('.rhine-document-head').count() === 1, 'reader skin changes retain a single chapter header');
  await page.setViewportSize({ width: 390, height: 600 });
  await page.getByRole('button', { name: '阅读偏好', exact: true }).click();
  check(await page.locator('#prefs-panel').evaluate(el => { const r = el.getBoundingClientRect(); return r.left >= 0 && r.right <= innerWidth && r.bottom <= innerHeight; }), 'Rhine preferences fit with the mobile sidebar expanded');
  await page.waitForFunction(() => getComputedStyle(document.querySelector('#prefs-panel')).opacity === '1');
  await page.screenshot({ path: 'output/playwright/ux-mobile-preferences.png' });
  await page.getByRole('button', { name: '原有图鉴', exact: true }).click();
  await page.keyboard.press('Escape');

  await page.emulateMedia({ reducedMotion: 'reduce', colorScheme: 'dark' });
  await page.goto(origin + '/');
  await page.getByLabel('界面外观').selectOption('rhine');
  check(await page.locator('.rh-boot').count() === 0, 'reduced motion skips the portal loading animation');
  await page.getByLabel('界面外观').selectOption('classic');
  await page.getByLabel('界面外观').selectOption('rhine');
  check(await page.locator('.rhine-portal').count() === 1, 'portal skin round trips retain one course catalogue');
  await page.getByLabel('界面外观').selectOption('classic');
  await page.emulateMedia({ reducedMotion: 'no-preference', colorScheme: 'light' });

  await page.addInitScript(() => {
    if (!new URLSearchParams(location.search).has('deny-storage')) return;
    window.addEventListener('error', event => { window.qaStorageError = { filename: event.filename, line: event.lineno, column: event.colno }; });
    for (const method of ['getItem', 'setItem', 'removeItem']) Storage.prototype[method] = () => { throw new Error('Storage denied'); };
  });
  await page.goto(origin + '/matrix/ch01/sec11.html?deny-storage');
  check(await page.locator('#prefs-toggle').count() === 1 && await page.locator('main figure[data-zoomable="1"]').count() > 0, 'blocked storage preserves reader controls and figure zoom');
  await page.locator('#mdbook-theme-toggle').click();
  await page.locator('#mdbook-theme-default_theme').click();
  await page.locator('#mdbook-sidebar a.active').first().evaluate(el => {
    el.addEventListener('click', event => event.preventDefault(), { once: true });
    el.click();
  });
  check(errors.length === 0, 'variant checks produce no uncaught JavaScript errors: ' + JSON.stringify({ errors, at: await page.evaluate(() => window.qaStorageError) }));
  await page.close();
  return { passed: results.length, checks: results };
}
