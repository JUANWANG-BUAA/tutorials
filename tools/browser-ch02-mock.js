/* Acceptance of the complete chapter-2 exam and its native answer folds. */
async (hostPage) => {
  const browser = hostPage.context().browser();
  const base = new URL(hostPage.url()).origin + '/robot/';
  const checks = [];
  const errors = [];
  const segments = [];
  const check = (condition, name, detail) => {
    if (!condition) throw new Error(name + ': ' + JSON.stringify(detail));
    checks.push(name);
  };
  const newPage = async javaScriptEnabled => {
    const page = await browser.newPage({ javaScriptEnabled, serviceWorkers: 'block' });
    page.on('pageerror', error => errors.push(error.message));
    page.on('response', response => {
      if (response.url().startsWith(base) && response.status() >= 400) errors.push(response.status() + ' ' + response.url());
    });
    return page;
  };
  const visit = page => page.goto(base + 'ch02/mock-exam.html');
  const checkFormulas = async (page, label) => {
    const failures = await page.locator('main .katex-display').evaluateAll(nodes => nodes
      .filter(node => node.scrollWidth > node.clientWidth + 1)
      .map(node => node.querySelector('annotation').textContent));
    check(failures.length === 0, label + ' every display formula fits', failures);
    check(await page.locator('.katex-error').count() === 0, label + ' no equation render errors');
    check(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1), label + ' no page overflow');
  };
  const page = await newPage(true);
  for (const width of [1440, 1200]) {
    await page.setViewportSize({ width, height: 1050 });
    await visit(page);
    check(await page.locator('main details.sol-box').count() === 4, width + 'px four native answer groups mount');
    await page.locator('main details.sol-box').evaluateAll(nodes => nodes.forEach(node => { node.open = true; }));
    await page.waitForTimeout(400);
    await checkFormulas(page, width + 'px expanded exam');
    await page.locator('main details.sol-box').evaluateAll(nodes => nodes.forEach(node => { node.open = false; }));
    await page.waitForTimeout(400);
  }
  for (const javaScriptEnabled of [true, false]) {
    const current = javaScriptEnabled ? page : await newPage(false);
    await current.setViewportSize({ width: 1440, height: 1050 });
    await visit(current);
    const numbers = await current.locator('main p > strong:first-child').evaluateAll(nodes => nodes
      .filter(node => !node.closest('details') && /^\d+\./.test(node.textContent))
      .map(node => Number(node.textContent.match(/^(\d+)\./)[1])));
    check(JSON.stringify(numbers) === JSON.stringify(Array.from({ length: 20 }, (_, index) => index + 1)),
      'all twenty questions remain in order with JS=' + javaScriptEnabled, numbers);
    const answerLabels = [
      Array.from({ length: 10 }, (_, index) => '（' + (index + 1) + '）'),
      ['11.', '12.', '13.', '14.', '15.'],
      ['16.（1）', '17.（1）', '18.（1）'],
      ['19.（10 分）', '20.（10 分）']
    ];
    const answers = current.locator('main details.sol-box');
    for (let index = 0; index < 4; index += 1) {
      const answer = answers.nth(index);
      const summary = answer.locator('summary');
      check(!await answer.evaluate(node => node.open), `answer group ${index + 1} starts closed with JS=${javaScriptEnabled}`);
      await summary.focus();
      await current.keyboard.press('Enter');
      await current.waitForTimeout(350);
      check(await answer.evaluate(node => node.open) && await answer.locator('.sol-inner').isVisible(),
        `answer group ${index + 1} opens by keyboard with JS=${javaScriptEnabled}`);
      const text = await answer.locator('.sol-inner').innerText();
      for (const label of answerLabels[index]) check(text.includes(label), `answer ${label} is readable with JS=${javaScriptEnabled}`);
      await checkFormulas(current, `answer group ${index + 1} with JS=${javaScriptEnabled}`);
      await current.keyboard.press('Space');
      await current.waitForTimeout(400);
      check(!await answer.evaluate(node => node.open), `answer group ${index + 1} closes by keyboard with JS=${javaScriptEnabled}`);
      check(!await answer.locator('.sol-inner').isVisible(), `answer group ${index + 1} content hides after closing with JS=${javaScriptEnabled}`);
    }
    if (javaScriptEnabled) {
      await current.evaluate(() => window.scrollTo(0, 0));
      await current.screenshot({ path: 'output/playwright/ch02-mock-overview-closed.png', fullPage: true, animations: 'disabled' });
      await answers.evaluateAll(nodes => nodes.forEach(node => { node.open = true; }));
      await current.waitForTimeout(400);
      await current.setViewportSize({ width: 1440, height: 5000 });
      const height = await current.evaluate(() => document.documentElement.scrollHeight);
      for (let top = 0, index = 1; top < height; top += 4500, index += 1) {
        await current.evaluate(top => window.scrollTo(0, top), top);
        await current.waitForTimeout(350);
        const path = 'output/playwright/ch02-mock-overview-open-' + String(index).padStart(2, '0') + '.png';
        segments.push(await current.evaluate(path => ({ path, top: scrollY, bottom: scrollY + innerHeight }), path));
        await current.screenshot({ path, animations: 'disabled' });
      }
      check(segments[0].top === 0 && segments.at(-1).bottom >= height, 'expanded overview covers the entire page', segments);
      check(segments.every((segment, index) => index === 0 || segment.top <= segments[index - 1].bottom), 'expanded overview has no gaps', segments);
      await current.setViewportSize({ width: 1440, height: 1050 });
      for (const label of ['14.', '15.', '16.（1）', '17.（1）', '18.（1）', '19.（10 分）', '20.（10 分）', 'ZYZ 的依据（2 分）。']) {
        const target = current.locator('main details').getByText(label, { exact: true });
        check(await target.count() === 1, label + ' has a unique detailed review target');
        await target.evaluate(node => window.scrollTo(0, node.getBoundingClientRect().top + scrollY - 85));
        await current.waitForTimeout(350);
        const name = label.startsWith('ZYZ') ? '20-wrist' : label.match(/^\d+/)[0];
        await current.screenshot({ path: 'output/playwright/ch02-mock-' + name + '-detail.png', animations: 'disabled' });
      }
    } else {
      await current.evaluate(() => window.scrollTo(0, 0));
      await current.screenshot({ path: 'output/playwright/ch02-mock-nojs-overview.png', fullPage: true, animations: 'disabled' });
      await current.close();
    }
  }
  const urls = await page.locator('main a[href]').evaluateAll(nodes => [...new Set(nodes.map(node => node.href))]);
  const target = await newPage(true);
  let linkedTargets = 0;
  for (const href of urls.filter(href => href.startsWith(base) && new URL(href).pathname.endsWith('.html'))) {
    const previous = new URL(target.url());
    const response = await target.goto(href);
    const destination = new URL(href);
    check(response ? response.ok() : previous.origin === destination.origin && previous.pathname === destination.pathname,
      'review link opens ' + href);
    const hash = decodeURIComponent(new URL(href).hash.slice(1));
    if (hash) check(await target.evaluate(id => document.getElementById(id) !== null, hash), 'review anchor exists ' + href);
    linkedTargets += 1;
  }
  await target.goto(base + 'ch02/sec2-12.html#thm-2.12.C');
  const branchCondition = await target.locator('[id="thm-2.12.C"]').innerText();
  check(branchCondition.includes('忽略限位') && branchCondition.includes('离开肩轴'), 'anthropomorphic four-branch theorem states its domain');
  check(branchCondition.includes('连续族'), 'anthropomorphic four-branch theorem links boundary classification');
  await target.close();
  check(errors.length === 0, 'no page or robot resource errors', errors);
  await page.close();
  return { passed: checks.length, linkedTargets, checks, overviewSegments: segments };
}
