/* Readiness acceptance: overview, summary, checklist, recall cards. Other pages remain pending. */
async (hostPage) => {
  const browser = hostPage.context().browser();
  const base = new URL(hostPage.url()).origin + '/robot/';
  const results = [];
  const errors = [];
  const check = (condition, name, detail) => {
    if (!condition) throw new Error(name + ': ' + JSON.stringify(detail));
    results.push(name);
  };
  const routeFor = name => base + 'ch02/' + name + '.html';
  const createPage = async javaScriptEnabled => {
    const page = await browser.newPage({ javaScriptEnabled, serviceWorkers: 'block' });
    page.on('pageerror', error => errors.push(error.message));
    page.on('response', response => {
      if (response.status() >= 400 && response.url().startsWith(base)) errors.push(response.status() + ' ' + response.url());
    });
    return page;
  };
  const page = await createPage(true);
  for (const viewport of [{ width: 1440, height: 1050 }, { width: 1200, height: 950 }]) {
    await page.setViewportSize(viewport);
    for (const name of ['overview', 'summary', 'checklist', 'recall-cards']) {
      await page.goto(routeFor(name));
      check(await page.locator('main h1').count() === 1, `${name} ${viewport.width}px has a main heading`);
      check(await page.locator('.katex-error').count() === 0, `${name} ${viewport.width}px has no equation rendering errors`);
      check(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1), `${name} ${viewport.width}px has no page overflow`);
    }
  }
  for (const javaScriptEnabled of [true, false]) {
    const current = javaScriptEnabled ? page : await createPage(false);
    await current.setViewportSize({ width: 1440, height: 1050 });
    await current.goto(routeFor('overview'));
    const checkpoints = current.locator('[id^="checkpoint-2."]');
    check(await checkpoints.count() === 3, `three readiness checkpoints exist with JavaScript=${javaScriptEnabled}`);
    for (const checkpoint of await checkpoints.all()) {
      const id = await checkpoint.getAttribute('id');
      const answer = checkpoint.locator('details.sol-box');
      check(await answer.count() === 1 && !await answer.evaluate(node => node.open), `${id} answer starts closed with JavaScript=${javaScriptEnabled}`);
      const summary = answer.locator('summary');
      await summary.focus();
      await current.keyboard.press('Enter');
      check(await answer.evaluate(node => node.open), `${id} Enter opens answer with JavaScript=${javaScriptEnabled}`);
      await current.waitForTimeout(400);
      check(await answer.locator('.sol-inner').isVisible() && await answer.locator('.sol-inner').evaluate(node => node.getBoundingClientRect().height > 30), `${id} opened reasoning is readable with JavaScript=${javaScriptEnabled}`);
      await current.keyboard.press('Space');
      check(!await answer.evaluate(node => node.open), `${id} Space closes answer with JavaScript=${javaScriptEnabled}`);
    }
    await current.goto(routeFor('summary'));
    const sectionLinks = current.locator('main table tbody tr td:first-child a');
    const numbers = (await sectionLinks.allTextContents()).map(text => text.trim());
    check(numbers.length === 12 && numbers.every((number, index) => number === '2.' + (index + 1)), `summary orders all twelve sections with JavaScript=${javaScriptEnabled}`, numbers);
    const exitLink = current.locator('main').getByRole('link', { name: '导览的三项自检', exact: true });
    await exitLink.click();
    check(new URL(current.url()).hash === '#checkpoint-2' && await current.locator('[id="checkpoint-2.orientation"]').isVisible(), `summary leads to readiness questions with JavaScript=${javaScriptEnabled}`);
    await current.goto(routeFor('checklist'));
    const rows = current.locator('main table tbody tr');
    check(await rows.count() === 20, `checklist has twenty goals with JavaScript=${javaScriptEnabled}`);
    const goalIds = (await rows.locator('td:first-child').allTextContents()).map(text => text.split(' ')[0]);
    check(new Set(goalIds).size === 20 && goalIds.includes('K2.5b') && !goalIds.includes('K2.1b'), `goal identifiers match canonical quaternion goal with JavaScript=${javaScriptEnabled}`, goalIds);
    for (const row of await rows.all()) {
      const goal = (await row.locator('td:first-child').innerText()).split(' ')[0];
      check(await row.locator('td').nth(2).locator('a[href*="#"]').count() > 0, `${goal} has a direct task or evidence link with JavaScript=${javaScriptEnabled}`);
    }
    const targets = await current.locator('main a[href]').evaluateAll(links => [...new Set(links.map(link => link.href))]);
    const targetPage = await createPage(javaScriptEnabled);
    for (const target of targets) {
      const url = new URL(target);
      if (!url.href.startsWith(base)) continue;
      const response = await targetPage.goto(target);
      const fragment = decodeURIComponent(url.hash.slice(1));
      check(response ? response.ok() : targetPage.url() === target, `checklist target responds ${url.pathname} ${fragment} JavaScript=${javaScriptEnabled}`);
      if (fragment) {
        check(await targetPage.evaluate(id => document.getElementById(id) !== null, fragment), `checklist fragment resolves ${fragment} JavaScript=${javaScriptEnabled}`);
      }
    }
    await targetPage.close();
    await current.goto(routeFor('recall-cards'));
    const cards = current.locator('main details.sol-box');
    check(await cards.count() === 33, `all thirty-three recall answers exist with JavaScript=${javaScriptEnabled}`);
    for (const card of await cards.all()) {
      const label = (await card.locator('summary').innerText()).trim();
      check(!await card.evaluate(node => node.open), `${label} starts closed with JavaScript=${javaScriptEnabled}`);
      await card.locator('summary').focus();
      await current.keyboard.press('Enter');
      await current.waitForTimeout(350);
      check(await card.evaluate(node => node.open) && await card.locator('.sol-inner').isVisible() && await card.locator('.sol-inner').evaluate(node => node.getBoundingClientRect().height > 25), `${label} keyboard reveals readable answer with JavaScript=${javaScriptEnabled}`);
      check(await current.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1), `${label} open answer has no page overflow with JavaScript=${javaScriptEnabled}`);
      await current.keyboard.press('Space');
      check(!await card.evaluate(node => node.open), `${label} keyboard closes answer with JavaScript=${javaScriptEnabled}`);
    }
    if (!javaScriptEnabled) await current.close();
  }
  await page.goto(routeFor('overview'));
  const second = page.locator('[id="checkpoint-2.chain"]');
  await second.locator('summary').click();
  await second.scrollIntoViewIfNeeded();
  await page.waitForTimeout(600);
  await second.screenshot({ path: 'output/playwright/ch02-overview-tool-check.png', animations: 'disabled' });
  await page.setViewportSize({ width: 1440, height: 1800 });
  await page.goto(routeFor('checklist'));
  await page.locator('main table').scrollIntoViewIfNeeded();
  await page.waitForTimeout(600);
  await page.locator('main table').screenshot({ path: 'output/playwright/ch02-checklist-tasks.png', animations: 'disabled' });
  await page.goto(routeFor('recall-cards'));
  const shift = page.locator('main details.sol-box').filter({ has: page.locator('summary').getByText('D7 核对', { exact: true }) });
  await shift.locator('summary').click();
  await shift.scrollIntoViewIfNeeded();
  await page.waitForTimeout(600);
  await shift.screenshot({ path: 'output/playwright/ch02-recall-wrist-shift.png', animations: 'disabled' });
  const calibration = page.locator('main details.sol-box').filter({ has: page.locator('summary').getByText('C8 核对', { exact: true }) });
  await calibration.locator('summary').click();
  await calibration.scrollIntoViewIfNeeded();
  await page.waitForTimeout(600);
  await calibration.screenshot({ path: 'output/playwright/ch02-recall-calibration.png', animations: 'disabled' });
  check(errors.length === 0, 'no page or robot resource errors', errors);
  await page.close();
  return { passed: results.length, checks: results };
}
