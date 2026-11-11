/* Exercise acceptance, including full-page overviews requested by the user. */
async (hostPage) => {
  const browser = hostPage.context().browser();
  const base = new URL(hostPage.url()).origin + '/robot/';
  const checks = [];
  const errors = [];
  const overviewSegments = [];
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
  const visit = page => page.goto(base + 'ch02/exercises.html');
  const scanPage = async page => {
    const size = await page.evaluate(() => ({ height: document.documentElement.scrollHeight, step: innerHeight * 0.8 }));
    for (let offset = 0; offset < size.height; offset += size.step) {
      await page.evaluate(offset => window.scrollTo(0, offset), offset);
      await page.waitForTimeout(25);
    }
    await page.evaluate(() => window.scrollTo(0, 0));
    await page.waitForTimeout(600);
  };
  const page = await newPage(true);
  for (const viewport of [{ width: 1440, height: 1050 }, { width: 1200, height: 950 }]) {
    await page.setViewportSize(viewport);
    await visit(page);
    check(await page.locator('main .box.ex').count() === 20, `${viewport.width}px all twenty exercise boxes mount`);
    check(await page.locator('main details.sol-box').count() === 20, `${viewport.width}px each exercise has one answer`);
    check(await page.locator('.katex-error').count() === 0, `${viewport.width}px no equation rendering errors`);
    check(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1), `${viewport.width}px no page overflow`);
    check(!await page.locator('main').innerText().then(text => text.includes('{{#include')), `${viewport.width}px program source includes are expanded`);
    await page.locator('main details.sol-box').evaluateAll(nodes => nodes.forEach(node => { node.open = true; }));
    await page.waitForTimeout(350);
    const overflowingFormulas = await page.locator('main .katex-display').evaluateAll(nodes => nodes
      .filter(node => node.scrollWidth > node.clientWidth + 1)
      .map(node => node.closest('.box.ex').querySelector('.box-tag').textContent));
    check(overflowingFormulas.length === 0, `${viewport.width}px every expanded display formula fits its box`, overflowingFormulas);
    await page.locator('main details.sol-box').evaluateAll(nodes => nodes.forEach(node => { node.open = false; }));
    await page.waitForTimeout(350);
  }
  for (const javaScriptEnabled of [true, false]) {
    const current = javaScriptEnabled ? page : await newPage(false);
    await current.setViewportSize({ width: 1440, height: 1050 });
    await visit(current);
    const exercises = current.locator('main .box.ex');
    const expectedLabels = ['A1','A2','A3','A4','B1','B2','B3','B4','B5','B6','C1','C2','C3','C4','C5','C6','D1','D2','D3','D4'];
    for (let index = 0; index < expectedLabels.length; index += 1) {
      const exercise = exercises.nth(index);
      const label = expectedLabels[index];
      check((await exercise.locator('.box-tag').first().innerText()).includes(label + ' ·'), `${label} question stays in order with JS=${javaScriptEnabled}`);
      const answer = exercise.locator('details.sol-box');
      const summary = answer.locator('summary');
      check(!await answer.evaluate(node => node.open), `${label} starts closed with JS=${javaScriptEnabled}`);
      await summary.focus();
      await current.keyboard.press('Enter');
      await current.waitForTimeout(350);
      check(await answer.evaluate(node => node.open) && await answer.locator('.sol-inner').isVisible(), `${label} keyboard opens readable answer with JS=${javaScriptEnabled}`);
      check(await current.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1), `${label} expanded answer has no page overflow with JS=${javaScriptEnabled}`);
      await current.keyboard.press('Space');
      check(!await answer.evaluate(node => node.open), `${label} keyboard closes answer with JS=${javaScriptEnabled}`);
    }
    check(await current.locator('.katex-error').count() === 0, `all answers have no rendering errors with JS=${javaScriptEnabled}`);
    for (const filename of ['ch02-planar-ik.py', 'ch02-calibration.py']) {
      const link = current.locator('main a[href$="' + filename + '"]');
      check(await link.count() === 1, `${filename} has one download link with JS=${javaScriptEnabled}`);
      const response = await current.request.get(await link.getAttribute('href').then(href => new URL(href, current.url()).href));
      const code = await response.text();
      check(response.ok() && code.includes('if __name__ == "__main__":') && code.includes('def main():'), `${filename} download contains the complete runnable file with JS=${javaScriptEnabled}`);
      const include = current.locator('main pre code').filter({ hasText: filename === 'ch02-planar-ik.py' ? 'def folded_family' : 'def local_covariance' });
      check(await include.count() === 1, `${filename} appears once as a code block with JS=${javaScriptEnabled}`);
      check((await include.textContent()).trim() === code.trim(), `${filename} displayed source matches download with JS=${javaScriptEnabled}`);
    }
    if (javaScriptEnabled) {
      await scanPage(current);
      await current.screenshot({ path: 'output/playwright/ch02-exercises-overview-closed.png', fullPage: true, animations: 'disabled' });
      for (const answer of await current.locator('main details.sol-box').all()) await answer.locator('summary').click();
      await current.waitForTimeout(600);
      await scanPage(current);
      check(await current.locator('main details.sol-box[open]').count() === 20, 'all twenty answers stay open for the whole-page overview');
      // Chrome can repeat the first 16384 rows in a taller fullPage capture.
      // Overlapping viewport captures keep every part of the expanded page observable.
      await current.setViewportSize({ width: 1440, height: 5000 });
      const expandedHeight = await current.evaluate(() => document.documentElement.scrollHeight);
      for (let offset = 0, index = 1; offset < expandedHeight; offset += 4500, index += 1) {
        await current.evaluate(offset => window.scrollTo(0, offset), offset);
        await current.waitForTimeout(350);
        const path = 'output/playwright/ch02-exercises-overview-open-' + String(index).padStart(2, '0') + '.png';
        overviewSegments.push(await current.evaluate(path => ({ path, top: scrollY, bottom: scrollY + innerHeight }), path));
        await current.screenshot({ path, animations: 'disabled' });
      }
      check(overviewSegments[0].top === 0 && overviewSegments.at(-1).bottom >= expandedHeight,
        'expanded overview captures cover the entire page', overviewSegments);
      check(overviewSegments.every((segment, index) => index === 0 || segment.top <= overviewSegments[index - 1].bottom),
        'expanded overview captures have no vertical gaps', overviewSegments);
      await current.setViewportSize({ width: 1440, height: 1050 });
      for (const id of ['exercise-2.C6', 'exercise-2.D1', 'exercise-2.D2']) {
        const exercise = current.locator('[id="' + id + '"]');
        await exercise.evaluate(node => window.scrollTo(0, node.getBoundingClientRect().top + window.scrollY - 85));
        await current.waitForTimeout(350);
        const box = await exercise.boundingBox();
        check(box !== null, id + ' has a rendered box');
        await current.screenshot({ path: 'output/playwright/ch02-' + id.replaceAll('.', '-') + '-detail.png', animations: 'disabled' });
      }
      for (const index of [2, 4, 8, 10, 11, 12, 13, 14, 19]) {
        const exercise = current.locator('main .box.ex').nth(index);
        await exercise.evaluate(node => window.scrollTo(0, node.getBoundingClientRect().top + window.scrollY - 85));
        await current.waitForTimeout(350);
        await current.screenshot({ path: 'output/playwright/ch02-' + expectedLabels[index] + '-detail.png', animations: 'disabled' });
      }
    } else {
      await scanPage(current);
      await current.screenshot({ path: 'output/playwright/ch02-exercises-nojs-overview.png', fullPage: true, animations: 'disabled' });
      await current.close();
    }
  }
  check(errors.length === 0, 'no page or robot resource errors', errors);
  await page.close();
  return { passed: checks.length, checks, overviewSegments };
}
