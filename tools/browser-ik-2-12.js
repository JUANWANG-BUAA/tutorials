/* Focused browser acceptance for robot §2.12. */
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
  const visit = () => page.goto(base + 'ch02/sec2-12.html');

  for (const size of [{ width: 1440, height: 1050 }, { width: 1200, height: 950 }]) {
    await page.setViewportSize(size);
    await visit();
    await page.locator('.lab[data-lab="ik3d"] canvas').waitFor();
    check(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1), `${size.width}px page has no horizontal overflow`);
    const ikLab = page.locator('.lab[data-lab="ik3d"]');
    const rows = ikLab.locator('table tbody tr');
    check(await rows.count() === 4, `${size.width}px 3D lab shows four branches`);
    const errors3d = await rows.evaluateAll(rows => rows.map(row => row.cells[4].textContent.trim()));
    check(errors3d.length === 4 && errors3d.every(text => text !== '' && Number.isFinite(Number(text)) && Number(text) < 1e-12), `${size.width}px four branches pass FK validation`, errors3d);
    const svgBounds = await page.locator('main svg.figure-svg').evaluateAll(svgs => svgs.map(svg => {
      const viewBox = svg.viewBox.baseVal;
      const texts = [...svg.querySelectorAll('text')].map(node => { const box = node.getBBox(); return { text: node.textContent.trim(), left: box.x, top: box.y, right: box.x + box.width, bottom: box.y + box.height }; });
      return { viewBox: [viewBox.x, viewBox.y, viewBox.width, viewBox.height], texts };
    }));
    check(svgBounds.every(item => item.texts.every(text => text.left >= item.viewBox[0] && text.right <= item.viewBox[0] + item.viewBox[2] && text.top >= item.viewBox[1] && text.bottom <= item.viewBox[1] + item.viewBox[3])), `${size.width}px SVG labels stay inside bounds`, svgBounds);
  }

  const ikLab = page.locator('.lab[data-lab="ik3d"]');
  await ikLab.getByRole('slider', { name: '目标 p_x' }).fill('1');
  await ikLab.getByRole('slider', { name: '目标 p_z' }).fill('0.8');
  check(await ikLab.getByText('无解', { exact: false }).isVisible(), '3D lab reports unreachable wrist centers');
  await ikLab.getByRole('slider', { name: '目标 p_z' }).fill('0.35');
  await ikLab.getByRole('slider', { name: '目标 p_x' }).fill('0');
  await ikLab.getByRole('slider', { name: '目标 p_y' }).fill('0');
  check(await ikLab.getByText('肩奇异', { exact: true }).isVisible(), '3D lab reports shoulder-axis singularity');
  await page.evaluate(() => {
    document.documentElement.classList.remove('light', 'rust', 'navy', 'ayu');
    document.documentElement.classList.add('coal');
  });
  await page.waitForTimeout(50);
  check(await ikLab.locator('canvas').isVisible(), 'theme change keeps 3D IK lab mounted');

  const arm = page.locator('figure.arm-lab');
  const joint2 = arm.locator('#alab-t2');
  await joint2.fill('0');
  check(await arm.getByText('接近两杆共线', { exact: false }).isVisible(), 'planar arm warns at the straight singularity');
  await joint2.focus();
  await page.keyboard.press('ArrowUp');
  check(await arm.locator('#alab-t2v').textContent() === '1°', 'planar arm slider responds to keyboard arrows');

  const noScript = await browser.newPage({ javaScriptEnabled: false });
  await noScript.setViewportSize({ width: 1440, height: 1050 });
  await noScript.goto(base + 'ch02/sec2-12.html');
  check(await noScript.getByText('双支 = 三角形镜像', { exact: false }).first().isVisible(), 'without JavaScript static planar explanation remains readable');
  check(await noScript.getByText('闭合解的充分条件', { exact: false }).first().isVisible(), 'without JavaScript static decoupling theorem remains readable');
  const details = noScript.locator('details').last();
  await details.click();
  check(await details.evaluate(el => el.open), 'without JavaScript native exercise disclosure opens');

  check(errors.length === 0, 'section browser checks produce no uncaught JavaScript errors', errors);
  await noScript.close();
  await page.close();
  return { passed: results.length, checks: results };
}
