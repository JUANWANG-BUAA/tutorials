// Playwright CLI: open the robot book, then run-code --filename robot/tools/browser_recall.js
async (page) => {
  const script = await page.locator('script[src*="robot-recall"]').first().getAttribute('src');
  const base = new URL('../../', new URL(script, page.url())).href;
  const browser = page.context().browser();
  const contexts = [];
  const checks = [];
  const assert = (condition, message) => { if (!condition) throw new Error(message); };
  async function check(name, action) {
    try {
      await action();
      checks.push({ name, passed: true });
    } catch (error) {
      checks.push({ name, passed: false, error: error.message });
    }
  }
  async function context(options) {
    const result = await browser.newContext(options);
    contexts.push(result);
    return result;
  }
  async function section(ctx, path = 'ch03/sec3-1.html') {
    const result = await ctx.newPage();
    await result.goto(new URL(path, base).href, { waitUntil: 'networkidle' });
    return result;
  }
  try {
    const desktop = await section(await context({ viewport: { width: 1440, height: 1000 } }));
    const errors = [];
    desktop.on('pageerror', error => errors.push(error.message));
    const trigger = desktop.locator('a.recall-link').first();
    const popup = desktop.locator('#recall-popover');
    await check('hover survives automatic scrolling and renders the matching formulas', async () => {
      await trigger.hover();
      await desktop.waitForTimeout(650);
      assert(await popup.isVisible(), 'Hover did not open');
      assert((await popup.innerText()).includes('链式法则'), 'Wrong entry');
      assert(await popup.locator('.katex').count() > 0, 'Missing rendered formula');
      assert(await popup.locator('.katex-error').count() === 0, 'Formula rendering error');
    });
    await check('the pointer can enter the explanation', async () => {
      await popup.hover();
      await desktop.waitForTimeout(250);
      assert(await popup.isVisible(), 'Moving into the popup closed it');
    });
    await check('close restores focus and stays closed', async () => {
      await popup.locator('.recall-close').click();
      await desktop.waitForTimeout(350);
      assert(!(await popup.isVisible()), 'Close reopened the popup');
      assert(await trigger.evaluate(node => document.activeElement === node), 'Trigger lost focus');
    });
    await check('Enter opens, Escape closes and restores focus', async () => {
      await trigger.press('Enter');
      await desktop.waitForTimeout(100);
      assert(await popup.isVisible(), 'Enter did not open');
      assert(await popup.locator('.term-popover-link').evaluate(node => document.activeElement === node),
        'The full explanation link did not receive focus');
      await desktop.keyboard.press('Escape');
      await desktop.waitForTimeout(350);
      assert(!(await popup.isVisible()), 'Escape did not close');
      assert(await trigger.evaluate(node => document.activeElement === node), 'Escape lost focus');
    });
    await check('Space opens the explanation', async () => {
      await trigger.press('Space');
      await desktop.waitForTimeout(100);
      assert(await popup.isVisible(), 'Space did not open');
      await desktop.keyboard.press('Escape');
    });
    await check('copied relative links resolve from the recall page', async () => {
      await trigger.press('Enter');
      await desktop.waitForTimeout(100);
      const links = await popup.locator('a[href]').evaluateAll(nodes => nodes.map(node => node.href));
      assert(links.includes(new URL('ch03/sec3-1.html', base).href), 'Wrong derivation target');
      assert(links.includes(new URL('recall.html#chain-rule', base).href), 'Wrong full entry target');
      await desktop.keyboard.press('Escape');
    });
    await check('rendered mathematics is retained in popup headings', async () => {
      await desktop.goto(new URL('ch03/sec3-3.html', base).href, { waitUntil: 'networkidle' });
      await desktop.locator('a.recall-link[href$="#jacobian"]').first().focus();
      await desktop.waitForTimeout(100);
      assert(await desktop.locator('#recall-popover-title .katex').count() === 1, 'Heading lost rendered math');
      assert(await desktop.locator('#recall-popover-title .header').count() === 0, 'Heading copied its anchor');
      await desktop.keyboard.press('Escape');
    });
    const mobile = await section(await context({ viewport: { width: 390, height: 844 }, hasTouch: true, isMobile: true }),
      'ch04/sec4-2-1.html');
    await check('touch opens a popup within the narrow viewport', async () => {
      await mobile.locator('a.recall-link').first().tap();
      await mobile.locator('#recall-popover').waitFor({ state: 'visible', timeout: 5000 });
      const box = await mobile.locator('#recall-popover').boundingBox();
      assert(box, 'Touch did not open');
      assert(box.x >= 7 && box.x + box.width <= 383, 'Horizontal overflow');
      assert(box.y >= 7 && box.y + box.height <= 837, 'Vertical overflow');
      assert(await mobile.locator('#recall-popover .katex').count() > 0, 'Missing mobile formulas');
    });
    const retryContext = await context();
    let failures = 0;
    await retryContext.route('**/recall.html', route => failures++ === 0 ? route.abort() : route.continue());
    const retry = await section(retryContext);
    await check('a failed fetch can retry', async () => {
      const link = retry.locator('a.recall-link').first();
      await link.focus();
      await retry.waitForTimeout(200);
      assert(!(await retry.locator('#recall-popover').isVisible()), 'Failure opened invalid content');
      await link.click();
      await retry.waitForTimeout(350);
      assert(await retry.locator('#recall-popover').isVisible(), 'Retry did not open');
    });
    const fallbackContext = await context();
    await fallbackContext.route('**/recall.html', route => route.request().isNavigationRequest() ? route.continue() : route.abort());
    const fallback = await section(fallbackContext);
    await check('a persistent fetch failure navigates to the static explanation', async () => {
      await fallback.locator('a.recall-link').first().click();
      await fallback.waitForURL('**/recall.html#chain-rule');
      assert(await fallback.locator('#chain-rule').count() === 1, 'Missing fallback entry');
    });
    const disabled = await section(await context({ javaScriptEnabled: false }));
    await check('navigation and formulas work without JavaScript', async () => {
      await disabled.locator('main a[href*="recall.html#"]').first().click();
      await disabled.waitForURL('**/recall.html#chain-rule');
      assert(await disabled.locator('#chain-rule .katex').count() > 0, 'Missing static formulas');
    });
    await check('a late response cannot reopen a dismissed popup', async () => {
      const delayedContext = await context();
      let release;
      let observed;
      const gate = new Promise(resolve => { release = resolve; });
      const requested = new Promise(resolve => { observed = resolve; });
      await delayedContext.route('**/recall.html', async route => {
        observed();
        await gate;
        await route.continue();
      });
      const delayed = await section(delayedContext);
      await delayed.locator('a.recall-link').first().focus();
      await requested;
      await delayed.keyboard.press('Escape');
      release();
      await delayed.waitForTimeout(400);
      assert(!(await delayed.locator('#recall-popover').isVisible()), 'Late fetch reopened the popup');
    });
    await check('the recall page contains 33 rendered entries', async () => {
      const recall = await section(await context(), 'recall.html');
      assert(await recall.locator('.recall-entry').count() === 33, 'Entry count changed');
      assert(await recall.locator('.katex-error').count() === 0, 'Recall contains invalid mathematics');
      assert(await recall.locator('#jacobian-column .katex').count() > 0, 'Column formula was not rendered');
    });
    await check('the desktop interactions produce no JavaScript errors', async () => {
      assert(errors.length === 0, errors.join('; '));
    });
  } finally {
    for (const ctx of contexts) await ctx.close();
  }
  return { passed: checks.filter(result => result.passed).length, checks };
}
