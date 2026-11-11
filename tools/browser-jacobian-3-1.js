async (hostPage) => {
  const browser = hostPage.context().browser();
  const page = await browser.newPage({ serviceWorkers: 'block' });
  const base = new URL(hostPage.url()).origin + '/robot/';
  const checks = [];
  const errors = [];
  const check = (condition, name, detail) => {
    if (!condition) throw new Error(name + ': ' + JSON.stringify(detail));
    checks.push(name);
  };
  const near = (actual, expected, tolerance = 1e-7) => Math.abs(actual - expected) < tolerance;
  page.on('pageerror', error => errors.push(error.message));
  const visit = () => page.goto(base + 'ch03/sec3-1.html');
  const lab = page.locator('[data-lab="jacobian2d"]');
  const read = () => lab.evaluate(node => JSON.parse(node.getAttribute('data-jacobian-values')));
  const verifyIndependent = (values, name) => {
    const { q1, q2, tool, rate1, rate2 } = values.state;
    const angles = [q1 * Math.PI / 180, q2 * Math.PI / 180];
    const endpoint = angles => [Math.cos(angles[0]) + (1 + tool) * Math.cos(angles[0] + angles[1]),
      Math.sin(angles[0]) + (1 + tool) * Math.sin(angles[0] + angles[1])];
    const step = 1e-5;
    const columns = angles.map((angle, joint) => {
      const plus = [...angles], minus = [...angles];
      plus[joint] += step;
      minus[joint] -= step;
      return endpoint(plus).map((coordinate, axis) => (coordinate - endpoint(minus)[axis]) / (2 * step));
    });
    const velocity = columns[0].map((value, axis) => value * rate1 + columns[1][axis] * rate2);
    check(columns.every((column, joint) => column.every((value, axis) => near(value, values.columns[joint][axis]))) &&
      velocity.every((value, axis) => near(value, values.total[axis])) && near(values.omega, rate1 + rate2) &&
      values.error < 1e-7, name, values);
  };
  for (const size of [{ width: 1440, height: 1050 }, { width: 1200, height: 950 }]) {
    await page.setViewportSize(size);
    await visit();
    await lab.locator('canvas').waitFor();
    check(await lab.isVisible(), `${size.width}px lab mounts`);
    check(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1), `${size.width}px page has no overflow`);
    verifyIndependent(await read(), `${size.width}px default velocity agrees with independent FK differences`);
    const geometry = await page.locator('main svg[role="img"]').evaluateAll(svgs => svgs.map(svg => {
      const bounds = svg.viewBox.baseVal;
      const labels = [...svg.querySelectorAll('text')].map(node => {
        const box = node.getBBox();
        return { text: node.textContent, left: box.x, top: box.y, right: box.x + box.width, bottom: box.y + box.height };
      });
      const overlaps = [];
      for (let first = 0; first < labels.length; first += 1) for (let second = first + 1; second < labels.length; second += 1) {
        const firstLabel = labels[first], secondLabel = labels[second];
        if (firstLabel.right > secondLabel.left + 2 && secondLabel.right > firstLabel.left + 2 && firstLabel.bottom > secondLabel.top + 2 && secondLabel.bottom > firstLabel.top + 2) overlaps.push([firstLabel.text, secondLabel.text]);
      }
      return { bounds: [bounds.x, bounds.y, bounds.width, bounds.height], labels, overlaps };
    }));
    check(geometry.length === 2 && geometry.every(svg => svg.labels.every(label => label.left >= svg.bounds[0] && label.right <= svg.bounds[0] + svg.bounds[2] && label.top >= svg.bounds[1] && label.bottom <= svg.bounds[1] + svg.bounds[3])), `${size.width}px SVG labels stay inside bounds`, geometry);
    check(geometry.every(svg => svg.overlaps.length === 0), `${size.width}px SVG labels do not overlap`, geometry.map(svg => svg.overlaps));
  }
  const tangent = await page.locator('[data-jacobian-tangent]').evaluate(node => {
    const dx = Number(node.getAttribute('x2')) - Number(node.getAttribute('x1'));
    const dy = -(Number(node.getAttribute('y2')) - Number(node.getAttribute('y1')));
    return { dx, dy, dot: 258 * dx + 182 * dy, cross: 258 * dy - 182 * dx };
  });
  check(Math.abs(tangent.dot) < 1e-8 && tangent.cross > 0 && tangent.dx < 0 && tangent.dy > 0, 'positive joint-2 tangent follows the right-hand rule', tangent);
  let values = await read();
  check(near(values.total[0], -1) && near(values.total[1], 0) && values.omega === 1, 'only joint 2 moves tip left');
  await lab.getByRole('button', { name: '角速度抵消', exact: true }).click();
  values = await read();
  check(near(values.first[0], -1) && near(values.first[1], 1) && near(values.second[0], 1) && near(values.total[0], 0) && near(values.total[1], 1) && values.omega === 0, 'opposite joint rates cancel orientation but preserve upward tip velocity', values);
  await lab.getByRole('slider', { name: '工具长度', exact: true }).fill('0.5');
  values = await read();
  verifyIndependent(values, 'tool offset changes position columns with unchanged angular rows');
  check(near(values.columns[0][0], -1.5) && near(values.columns[1][0], -1.5) && near(values.total[1], 1) && values.omega === 0, 'tool offset contributions cancel for the worked input', values);
  await lab.getByRole('button', { name: '只动关节 2', exact: true }).click();
  await lab.getByRole('slider', { name: '工具长度', exact: true }).fill('0.5');
  values = await read();
  check(near(values.total[0], -1.5) && values.omega === 1, 'extended tool increases single-joint linear velocity');
  await lab.getByRole('button', { name: '伸直位形', exact: true }).click();
  values = await read();
  check(values.columns.every(column => near(column[0], 0)) && near(values.total[1], 1) && values.omega === 0, 'straight configuration cannot create instantaneous x velocity');
  const specs = [
    ['关节角 q₁', 'q1'], ['关节角 q₂', 'q2'], ['关节速度 q̇₁', 'rate1'], ['关节速度 q̇₂', 'rate2'], ['工具长度', 'tool']
  ];
  for (const spec of specs) {
    const control = lab.getByRole('slider', { name: spec[0], exact: true });
    for (const key of ['Home', 'End']) {
      await control.focus();
      await page.keyboard.press(key);
      values = await read();
      check(near(values.state[spec[1]], Number(await control.getAttribute(key === 'Home' ? 'min' : 'max'))), spec[1] + ' supports keyboard ' + key);
      verifyIndependent(values, spec[1] + ' ' + key + ' agrees with independent differences');
    }
  }
  for (const [label, value] of [['关节角 q₁', '37'], ['关节角 q₂', '-63'], ['关节速度 q̇₁', '0.7'], ['关节速度 q̇₂', '-1.2'], ['工具长度', '0.35']]) {
    await lab.getByRole('slider', { name: label, exact: true }).fill(value);
  }
  verifyIndependent(await read(), 'arbitrary oblique configuration and negative rate agree with differences');
  for (const label of ['关节速度 q̇₁', '关节速度 q̇₂']) await lab.getByRole('slider', { name: label, exact: true }).fill('0');
  values = await read();
  check(values.total.every(value => near(value, 0)) && values.omega === 0 && values.error === 0, 'zero rates produce zero velocities and zero error');
  await lab.getByRole('button', { name: '重置', exact: true }).click();
  values = await read();
  check(JSON.stringify(values.state) === JSON.stringify({ q1: 0, q2: 90, rate1: 0, rate2: 1, tool: 0 }), 'reset restores every input');
  const before = await lab.locator('canvas').evaluate(canvas => canvas.toDataURL());
  const originalClasses = await page.evaluate(() => {
    const root = document.documentElement;
    const original = root.className;
    root.classList.remove('light', 'rust', 'navy', 'ayu', 'dark');
    root.classList.add('coal');
    return original;
  });
  await page.waitForTimeout(100);
  const after = await lab.locator('canvas').evaluate(canvas => canvas.toDataURL());
  check(before !== after && near((await read()).total[0], -1), 'theme change repaints canvas and preserves state');
  await page.evaluate(original => { document.documentElement.className = original; }, originalClasses);
  await lab.getByRole('button', { name: '角速度抵消', exact: true }).click();
  await page.setViewportSize({ width: 1440, height: 1050 });
  await lab.scrollIntoViewIfNeeded();
  await lab.screenshot({ path: 'output/playwright/robot-sec3-1-lab.png' });
  await page.locator('main svg[role="img"]').first().screenshot({ path: 'output/playwright/robot-sec3-1-overview.png' });
  await page.locator('main svg[role="img"]').last().scrollIntoViewIfNeeded();
  await page.waitForTimeout(600);
  await page.locator('main svg[role="img"]').last().screenshot({ path: 'output/playwright/robot-sec3-1-columns.png', animations: 'disabled' });
  const trainingLink = page.getByRole('link', { name: '两连杆第二关', exact: true });
  check(await trainingLink.getAttribute('href') === '../training/two-link.html#mission-velocity', 'section links to the velocity mission');
  await trainingLink.click();
  check(await page.locator('main').getByRole('heading', { name: '第二关 · 瞬时运动：雅可比', level: 2 }).isVisible(), 'velocity mission opens');
  await page.goBack();
  const answer = page.locator('details.sol-box').first();
  await answer.locator('summary').focus();
  await page.keyboard.press('Enter');
  check(await answer.evaluate(node => node.open), 'self-check opens with keyboard Enter');
  await page.keyboard.press('Space');
  check(!await answer.evaluate(node => node.open), 'self-check closes with keyboard Space');
  check(await page.locator('.katex-error').count() === 0, 'section has no KaTeX rendering errors');
  const noScript = await browser.newPage({ javaScriptEnabled: false, serviceWorkers: 'block' });
  await noScript.goto(base + 'ch03/sec3-1.html');
  check(await noScript.locator('[data-lab="jacobian2d"]').isHidden(), 'lab stays hidden without JavaScript');
  check(await noScript.locator('[data-lab="rotationDerivative"]').isHidden(), 'rotation derivative lab stays hidden without JavaScript');
  check(await noScript.locator('main').getByText('转动关节的距离参数', { exact: false }).isVisible(), 'DH explanation stays readable without JavaScript');
  check(await noScript.locator('main').getByText('几何雅可比的逐列构造', { exact: false }).first().isVisible(), 'column formula stays readable without JavaScript');
  const staticAnswer = noScript.locator('details.sol-box').first();
  await staticAnswer.locator('summary').click();
  check(await staticAnswer.evaluate(node => node.open), 'native answer disclosure works without JavaScript');
  await noScript.locator('main img').evaluateAll(nodes => nodes.forEach(node => { node.loading = 'eager'; }));
  await noScript.waitForFunction(() => [...document.querySelectorAll('main img')].every(node => node.complete && node.naturalWidth > 0));
  await noScript.screenshot({ path: 'output/playwright/robot-sec3-1-no-script.png', fullPage: true, animations: 'disabled' });
  check(errors.length === 0, 'no uncaught page errors', errors);
  await noScript.close();
  await visit();
  await page.evaluate(() => document.fonts.ready);
  const rotationLab = page.locator('[data-lab="rotationDerivative"]');
  const readRotation = () => rotationLab.evaluate(node => JSON.parse(node.getAttribute('data-rotation-values')));
  check(await rotationLab.isVisible(), 'rotation derivative lab mounts');
  const verifyRotation = (values, label) => {
    const angle = values.state.angle * Math.PI / 180;
    const rate = values.state.rate;
    const step = values.state.step;
    const epsilon = 1e-5;
    const position = time => [Math.cos(angle + rate * time), Math.sin(angle + rate * time)];
    const numerical = position(epsilon).map((value, axis) => (value - position(-epsilon)[axis]) / (2 * epsilon));
    const exact = position(step);
    const tangent = position(0).map((value, axis) => value + step * numerical[axis]);
    check(numerical.every((value, axis) => near(value, values.derivative[axis])) &&
      exact.every((value, axis) => near(value, values.exact[axis])) &&
      tangent.every((value, axis) => near(value, values.tangent[axis])) &&
      near(values.orthogonalityError, (rate * step) ** 2), label, values);
    const computedSkew = values.rotationDerivative.map(row => values.rotation.map(rotationRow =>
      row.reduce((sum, value, axis) => sum + value * rotationRow[axis], 0)));
    check(computedSkew.every((row, index) => row.every((value, axis) => near(value, values.skew[index][axis]))), label + ' matrix product matches angular velocity', values);
  };
  let rotationValues = await readRotation();
  verifyRotation(rotationValues, 'rotation default agrees with independent time differences');
  check(near(rotationValues.derivative[0], -2) && near(rotationValues.derivative[1], 0) &&
    near(rotationValues.exact[0], -Math.sin(1)) && near(rotationValues.exact[1], Math.cos(1)) &&
    near(rotationValues.tangent[0], -1) && near(rotationValues.tangent[1], 1), 'rotation numeric example matches the text');
  const coarseError = rotationValues.error;
  await rotationLab.getByRole('slider', { name: '步长 h', exact: true }).fill('0.01');
  rotationValues = await readRotation();
  verifyRotation(rotationValues, 'short rotation step agrees with independent differences');
  check(rotationValues.error < coarseError / 1000 && near(rotationValues.derivative[0], -2) && near(rotationValues.orthogonalityError, 0.0004), 'shorter step reduces finite update error without changing derivative');
  for (const label of ['当前角度', '角速度', '步长 h']) {
    const control = rotationLab.getByRole('slider', { name: label, exact: true });
    for (const key of ['Home', 'End']) {
      await control.focus();
      await page.keyboard.press(key);
      verifyRotation(await readRotation(), label + ' keyboard ' + key);
    }
  }
  await rotationLab.getByRole('slider', { name: '角速度', exact: true }).fill('0');
  rotationValues = await readRotation();
  check(rotationValues.error === 0 && rotationValues.normError < 1e-12 && rotationValues.derivative.every(value => value === 0), 'stationary rotation has zero derivative and coincident endpoints');
  await rotationLab.getByRole('button', { name: '重置', exact: true }).click();
  rotationValues = await readRotation();
  check(JSON.stringify(rotationValues.state) === JSON.stringify({ angle: 90, rate: 2, step: 0.5 }), 'rotation reset restores all inputs');
  const rotationBefore = await rotationLab.locator('canvas').evaluate(canvas => canvas.toDataURL());
  const classes = await page.evaluate(() => {
    const root = document.documentElement;
    const previous = root.className;
    root.classList.remove('light', 'rust', 'navy', 'ayu');
    root.classList.add('coal');
    return previous;
  });
  await page.waitForTimeout(150);
  check(rotationBefore !== await rotationLab.locator('canvas').evaluate(canvas => canvas.toDataURL()), 'rotation canvas repaints for Coal theme');
  await rotationLab.screenshot({ path: 'output/playwright/robot-sec3-1-rotation-coal.png', animations: 'disabled' });
  await page.evaluate(previous => { document.documentElement.className = previous; }, classes);
  for (const width of [1440, 1200]) {
    await page.setViewportSize({ width, height: 1050 });
    await page.locator('main details.sol-box').evaluateAll(nodes => nodes.forEach(node => { node.open = true; }));
    await page.waitForTimeout(350);
    const overflow = await page.locator('main .katex-display').evaluateAll(nodes => nodes
      .filter(node => node.scrollWidth > node.clientWidth + 1)
      .map(node => node.querySelector('annotation').textContent));
    check(overflow.length === 0, width + 'px all expanded display formulas fit', overflow);
    check(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth + 1), width + 'px expanded section has no page overflow');
  }
  await page.setViewportSize({ width: 1440, height: 1800 });
  await page.locator('main img').evaluateAll(nodes => nodes.forEach(node => { node.loading = 'eager'; }));
  await page.waitForFunction(() => [...document.querySelectorAll('main img')].every(node => node.complete && node.naturalWidth > 0));
  const expectedImages = [
    ['jac-def.jpg', '第 6 页'], ['rot-derivation.jpg', '第 7 页'], ['skew-omega.jpg', '第 8 页'],
    ['rz-example.jpg', '第 9 页'], ['point-velocity.jpg', '第 10 页'], ['link-pdot.jpg', '第 11 页'],
    ['link-omega.jpg', '第 12 页'], ['jac-greenbox.jpg', '第 17 页'], ['jac-columns.jpg', '第 16 页'], ['jac-frame-u.jpg', '第 18 页']
  ];
  for (const [filename, caption] of expectedImages) {
    const illustration = page.locator('main img[src$="' + filename + '"]');
    check(await illustration.count() === 1 && (await illustration.getAttribute('alt')).includes(caption), filename + ' carries its inspected source page');
  }
  const malformedCaptions = await page.locator('main img, main figcaption').evaluateAll(nodes => nodes
    .map(node => node.tagName === 'IMG' ? node.alt : node.textContent)
    .filter(text => /<\/?(?:span|math|annotation)\b/.test(text)));
  check(malformedCaptions.length === 0, 'image descriptions and captions contain no escaped formula HTML', malformedCaptions);
  const overviewSegments = [];
  for (const expanded of [false, true]) {
    await page.locator('main details.sol-box').evaluateAll((nodes, open) => nodes.forEach(node => { node.open = open; }), expanded);
    await page.waitForTimeout(400);
    const height = await page.evaluate(() => document.documentElement.scrollHeight);
    const state = expanded ? 'open' : 'closed';
    const segmentGroup = [];
    for (let top = 0, index = 1; top < height; top += 1600, index += 1) {
      await page.evaluate(top => window.scrollTo(0, top), top);
      await page.waitForTimeout(150);
      const path = 'output/playwright/robot-sec3-1-' + state + '-' + String(index).padStart(2, '0') + '.png';
      await page.screenshot({ path, animations: 'disabled' });
      segmentGroup.push(await page.evaluate(path => ({ path, top: scrollY, bottom: scrollY + innerHeight }), path));
    }
    check(segmentGroup[0].top === 0 && segmentGroup.at(-1).bottom >= height &&
      segmentGroup.every((segment, index) => index === 0 || segment.top <= segmentGroup[index - 1].bottom), state + ' overview covers entire section without gaps', segmentGroup);
    overviewSegments.push(...segmentGroup);
    await page.evaluate(() => window.scrollTo(0, 0));
    await page.screenshot({ path: 'output/playwright/robot-sec3-1-full-' + state + '.png', fullPage: true, animations: 'disabled' });
  }
  await rotationLab.screenshot({ path: 'output/playwright/robot-sec3-1-rotation-lab.png', animations: 'disabled' });
  check(await page.locator('.katex-error').count() === 0, 'final expanded section has no KaTeX errors');
  check(errors.length === 0, 'final section has no uncaught page errors', errors);
  await page.close();
  return { passed: checks.length, checks, overviewSegments };
}
