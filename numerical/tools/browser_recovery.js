/** Run with playwright-cli run-code --filename numerical/tools/browser_recovery.js.
 * The browser must already be open on a freshly built numerical book.
 */
async (page) => {
  // Accept any existing page depth: derive the deployed book prefix explicitly.
  const prefix = page.url().split('/numerical/')[0] + '/numerical/';
  const targets = [
    ['ch01/sec11.html', 'intro-three-problems'],
    ['course/ch02/sec24.html', 'thm-2.8'],
    ['course/ch03/overview.html', null],
    ['course/ch03/mock-exam.html', 'extra-energy-order'],
    ['course/ch03/recall-cards.html', 'recall-power-expansion'],
    ['course/ch04/overview.html', null],
    ['course/ch04/recall-cards.html', 'recall-secant-order'],
    ['course/ch04/checklist.html', null],
    ['training/exam-sprint.html', 'application-spd-iteration'],
    ['training/exam-foundations.html', null],
    ['ch01/sec12.html', 'sec-1.2.3'],
    ['ch01/sec13.html', 'thm-1.3.6'],
    ['ch01/exercises.html', 'hw-1-2'],
    ['course/ch02/exercises.html', 'hw-2-5'],
    ['course/ch03/sec31.html', 'note-power-initial'],
    ['course/ch03/exercises.html', 'editor-eigen-shift'],
    ['course/ch04/sec41b.html', 'thm-4.9'],
    ['course/ch04/exercises.html', 'editor-fixed-point-equivalence'],
    ['course/ch04/mock-exam.html', null],
    ['course/ch05/overview.html', null],
    ['course/ch07/sec73.html', null],
    ['course/ch07/sec74.html', null],
    ['supplement/sec23.html', null],
    ['supplement/sec24.html', 'thm-sup-2.4.4'],
    ['appendix/derivations.html', 'app-a-2-2'],
    ['ch01/application.html', 'ex-case-gps'],
    ['course/ch05/sec55.html', 'ex-5.6.9'],
    ['course/ch06/recall-cards.html', null],
    ['course/ch06/sec64.html', null],
    ['course/ch06/sec65.html', null],
    ['lectures/lec05.html', null],
    ['appendix/connections.html', 'app-c-2-1'],
    ['supplement/sec27.html', 'sup-2.7.4'],
    ['supplement/sec28.html', null],
    ['supplement/mock-exam.html', null],
    ['supplement/recall-cards.html', null],
    ['review/contrast-cards.html', null],
  ];
  await page.evaluate(() => localStorage.removeItem('na-core-only'));
  const errors = [];
  page.on('pageerror', error => errors.push({url: page.url(), stack: error.stack || String(error)}));
  const results = [];
  for (const viewport of [{width: 1440, height: 1000}, {width: 390, height: 844}]) {
    await page.setViewportSize(viewport);
    for (const [path, anchor] of targets) {
      const response = await page.goto(prefix + path, {waitUntil: 'load'});
      if (!response || response.status() !== 200) throw new Error(`Load failed: ${path}`);
      await page.locator('main').waitFor();
      await page.evaluate(async () => { await document.fonts.ready; });
      const details = page.locator('details.sol-box');
      const solutions = await details.count();
      if (solutions) {
        if (await page.locator('details.sol-box:not([open])').count()) {
          await page.getByRole('button', {name: '展开全部解答', exact: true}).click();
        }
        if (await page.locator('details.sol-box:not([open])').count()) {
          throw new Error(`Answers did not open: ${path}`);
        }
        await page.waitForFunction(() =>
          Array.from(document.querySelectorAll('details.sol-box')).every(node => {
            const inner = node.querySelector('.sol-inner');
            const summary = node.querySelector('summary');
            return inner && inner.textContent.trim().length > 0 &&
              node.getBoundingClientRect().height > summary.getBoundingClientRect().height + 8;
          }));
        await page.evaluate(async () => {
          // Reading geometry above flushes style before collecting transitions.
          const animations = document.getAnimations().filter(animation =>
            animation.effect.getTiming().iterations !== Infinity);
          await Promise.all(animations.map(animation => animation.finished.catch(() => {})));
        });
      }
      const state = await page.evaluate(() => ({
        math: document.querySelectorAll('main .katex').length,
        mathErrors: document.querySelectorAll('.katex-error').length,
        rawBoxes: /^\s*:::/m.test(document.querySelector('main').innerText),
        overflow: document.documentElement.scrollWidth - document.documentElement.clientWidth,
      }));
      if (!state.math || state.mathErrors || state.rawBoxes || state.overflow > 2) {
        throw new Error(`Content/layout failed: ${path} ${JSON.stringify(state)}`);
      }
      if (anchor && await page.locator(`[id="${anchor}"]`).count() !== 1) {
        throw new Error(`Anchor missing or duplicated: ${path}#${anchor}`);
      }
      const core = page.getByRole('button', {name: '只看核心', exact: true});
      let coreChecked = false;
      if (await core.count()) {
        await core.click();
        if (!await page.locator('html').evaluate(el => el.classList.contains('core-only'))) {
          throw new Error(`Core toggle failed: ${path}`);
        }
        const hidden = await page.locator('main .p-skip').evaluateAll(nodes =>
          nodes.every(node => getComputedStyle(node).display === 'none'));
        if (!hidden) throw new Error(`Proofs not hidden: ${path}`);
        await page.getByRole('button', {name: '显示全部', exact: true}).click();
        if (await page.locator('html').evaluate(el => el.classList.contains('core-only'))) {
          throw new Error(`Full content not restored: ${path}`);
        }
        coreChecked = true;
      }
      if (solutions) {
        await page.getByRole('button', {name: '折叠全部解答', exact: true}).click();
        if (await page.locator('details.sol-box[open]').count()) {
          throw new Error(`Answers did not close: ${path}`);
        }
      }
      results.push({path, width: viewport.width, solutions, coreChecked, math: state.math});
    }
  }
  if (errors.length) throw new Error(`Browser errors: ${JSON.stringify(errors)}`);
  return {passed: results.length, errors, results};
}
