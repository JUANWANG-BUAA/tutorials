/* Focused browser acceptance for robot §2.11. */
async (hostPage) => {
  const browser = hostPage.context().browser();
  const page = await browser.newPage({ serviceWorkers: 'block' });
  const base = new URL(hostPage.url()).origin + '/robot/';
  const results = [];
  const errors = [];
  const check = (condition, name, detail) => {
    if (!condition) throw new Error(name + ': ' + JSON.stringify(detail));
    results.push(name);
  };
  page.on('pageerror', error => errors.push(error.message));
  const visit = () => page.goto(base + 'ch02/sec2-11.html');
  const readValues = () => page.locator('.lab[data-lab="calibration2d"]').evaluate(el => JSON.parse(el.getAttribute('data-calibration-values')));

  for (const size of [{ width: 1440, height: 1050 }, { width: 1200, height: 950 }]) {
    await page.setViewportSize(size);
    await visit();
    await page.locator('.lab[data-lab="calibration2d"] canvas').waitFor();
    const lab = page.locator('.lab[data-lab="calibration2d"]');
    check(await lab.isVisible(), `${size.width}px lab is visible`);
    check(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1), `${size.width}px page has no horizontal overflow`);
    const values = await readValues();
    check(values.rank === 2 && Math.abs(values.estimate[0] - .04) < 1e-10 && Math.abs(values.estimate[1] + .03) < 1e-10, `${size.width}px wide distribution recovers truth`, values);
    const svgGeometry = await page.locator('main svg[aria-labelledby="fig-211-t fig-211-d"]').evaluate(svg => {
      const viewBox = svg.viewBox.baseVal;
      const texts = [...svg.querySelectorAll('text')].map(node => {
        const box = node.getBBox();
        return { text: node.textContent.trim(), left: box.x, top: box.y, right: box.x + box.width, bottom: box.y + box.height };
      });
      const overlaps = [];
      for (let first = 0; first < texts.length; first += 1) for (let second = first + 1; second < texts.length; second += 1) {
        const a = texts[first], b = texts[second];
        if (a.right > b.left + 2 && b.right > a.left + 2 && a.bottom > b.top + 2 && b.bottom > a.top + 2) overlaps.push([a.text, b.text]);
      }
      return { viewBox: [viewBox.x, viewBox.y, viewBox.width, viewBox.height], texts, overlaps };
    });
    check(svgGeometry.texts.every(text => text.left >= svgGeometry.viewBox[0] && text.right <= svgGeometry.viewBox[0] + svgGeometry.viewBox[2] && text.top >= svgGeometry.viewBox[1] && text.bottom <= svgGeometry.viewBox[1] + svgGeometry.viewBox[3]), `${size.width}px SVG labels stay inside bounds`, svgGeometry);
    check(svgGeometry.overlaps.length === 0, `${size.width}px SVG labels do not overlap`, svgGeometry.overlaps);
  }

  const lab = page.locator('.lab[data-lab="calibration2d"]');
  await lab.getByRole('button', { name: '集中分布', exact: true }).click();
  let values = await readValues();
  check(values.spread === 'narrow' && values.condition > 100, 'concentrated distribution exposes ill conditioning', values);
  await lab.getByRole('slider', { name: '训练样本数' }).fill('12');
  values = await readValues();
  check(values.count === 12 && values.condition > 100, 'more concentrated samples do not cure geometry', values);
  await lab.getByRole('slider', { name: '噪声 σ' }).fill('1');
  values = await readValues();
  check(values.noise === 1 && values.trainingRms > 0 && values.validationError > 0, 'noise updates training and validation readouts', values);
  const countSlider = lab.getByRole('slider', { name: '训练样本数' });
  await countSlider.focus();
  await page.keyboard.press('Home');
  values = await readValues();
  check(values.count === 2, 'training slider supports keyboard Home', values);
  await lab.getByRole('button', { name: '重置', exact: true }).click();
  values = await readValues();
  check(values.spread === 'wide' && values.count === 6 && values.noise === 0, 'reset restores the teaching baseline', values);
  await page.evaluate(() => document.documentElement.classList.toggle('dark'));
  await page.waitForTimeout(50);
  check(await lab.isVisible() && (await readValues()).spread === 'wide', 'theme changes keep the lab mounted and redrawn');
  await page.screenshot({ path: 'output/playwright/robot-sec2-11-desktop.png', fullPage: false });

  const noScript = await browser.newPage({ javaScriptEnabled: false });
  await noScript.setViewportSize({ width: 1440, height: 1050 });
  await noScript.goto(base + 'ch02/sec2-11.html');
  check(await noScript.locator('.lab[data-lab="calibration2d"]').isHidden(), 'without JavaScript the calibration tool stays hidden');
  check(await noScript.locator('main').getByText('不运行脚本也能核对').isVisible(), 'without JavaScript the static derivation remains readable');
  const details = noScript.locator('details').last();
  await details.click();
  check(await details.evaluate(el => el.open), 'without JavaScript native exercise disclosure opens');

  check(errors.length === 0, 'section browser checks produce no uncaught JavaScript errors', errors);
  await noScript.close();
  await page.close();
  return { passed: results.length, checks: results };
}
