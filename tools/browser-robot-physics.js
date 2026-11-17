/* Focused browser regression for robot transmission, sensors and passive dynamics. */
async (hostPage) => {
  const base = new URL('robot/', hostPage.url()).href;
  const page = await hostPage.context().browser().newPage({ serviceWorkers: 'block' });
  const results = [], errors = [];
  const check = (condition, name, detail) => {
    if (!condition) throw new Error(name + ': ' + JSON.stringify(detail));
    results.push(name);
  };
  page.on('pageerror', error => errors.push(error.message));
  await page.addInitScript(() => {
    const ctx = CanvasRenderingContext2D.prototype;
    const begin = ctx.beginPath, line = ctx.lineTo, stroke = ctx.stroke;
    ctx.beginPath = function () { this.robotSegments = 0; return begin.call(this); };
    ctx.lineTo = function (x, y) {
      if (this.canvas.closest('[data-lab="drive3d"]') && (!Number.isFinite(x) || !Number.isFinite(y))) {
        window.robotInvalidGearCoordinates = (window.robotInvalidGearCoordinates || 0) + 1;
      }
      this.robotSegments = (this.robotSegments || 0) + 1;
      return line.call(this, x, y);
    };
    ctx.stroke = function () {
      if (this.canvas.closest('[data-lab="dyn3d"]') && this.robotSegments > 30) window.robotTrailDrawn = true;
      return stroke.call(this);
    };
  });
  await page.setViewportSize({ width: 1280, height: 800 });

  await page.goto(base + 'ch05/sec5-1.html');
  const drive = page.locator('[data-lab="drive3d"]');
  const angle = drive.getByRole('slider', { name: '输入转角 θ_m', exact: true });
  await angle.waitFor();
  await angle.press('End');
  let text = await drive.locator('.lab-readout').innerText();
  check(text.includes('关节转 -18.0°') && text.includes('电机力矩的 kᵣ 倍'), 'external gear direction and ideal torque magnitude', text);
  check(await page.evaluate(() => !window.robotInvalidGearCoordinates), 'gear teeth have finite canvas coordinates');
  await drive.getByRole('button', { name: '同步带', exact: true }).click();
  text = await drive.locator('.lab-readout').innerText();
  check(text.includes('从动轮同向转 18.0°'), 'open belt has the same rotation direction', text);
  await drive.getByRole('button', { name: '滚珠丝杠', exact: true }).click();
  text = await drive.locator('.lab-readout').innerText();
  check(text.includes('螺母移动 10.0 mm') && await drive.locator('.lab-readout table').count() === 0,
    'screw converts angle to linear displacement without a rotational-torque table', text);

  const motor = page.locator('[data-lab="motor3d"]');
  check((await motor.locator('.lab-readout').innerText()).includes('电磁转矩继续沿原来的方向'), 'commutator preserves the torque direction');
  await motor.getByRole('button', { name: '无刷直流（BLDC）', exact: true }).click();
  text = await motor.locator('.lab-readout').innerText();
  check(text.includes('不必始终正交') && text.includes('无位置传感器方案'), 'brushless commutation states its assumptions', text);

  await page.goto(base + 'ch05/sec5-3.html');
  const sensor = page.locator('[data-lab="sensor3d"]');
  await sensor.getByRole('button', { name: '② 编码器怎么测角', exact: true }).click();
  text = await sensor.locator('.lab-readout').innerText();
  check(text.includes('4N 个计数/转') && text.includes('计数掉电丢失后'), 'encoder decoding and lost-reference conditions', text);

  await page.goto(base + 'ch06/sec6-3.html');
  const dyn = page.locator('[data-lab="dyn3d"]');
  const setRange = async (label, value) => {
    await dyn.getByRole('slider', { name: label, exact: true }).evaluate((input, next) => {
      input.value = String(next);
      input.dispatchEvent(new Event('input', { bubbles: true }));
    }, value);
  };
  await setRange('ϑ₁', 0);
  await setRange('ϑ₂', 0);
  await setRange('ϑ̇₁', 0);
  await setRange('ϑ̇₂', 0);
  await dyn.getByRole('button', { name: '自由摆动（零输入力矩）', exact: true }).click();
  await page.waitForFunction(() => {
    const p = document.querySelector('[data-lab="dyn3d"] .lab-readout p');
    const time = p && p.textContent.match(/t = ([\d.]+) s/);
    return time && Number(time[1]) >= 0.8;
  });
  await dyn.getByRole('button', { name: '暂停', exact: true }).click();
  const values = await dyn.locator('.lab-ctl output').allTextContents();
  const displayed = values.map(parseFloat);
  const halfWidths = values.map((value, index) => {
    const decimals = value.match(/\.(\d+)/)?.[1].length ?? 0;
    const halfUnit = 0.5 / (10 ** decimals);
    return index < 2 ? halfUnit * Math.PI / 180 : halfUnit;
  });
  const energy = ([degrees1, degrees2, d1, d2]) => {
    const q1 = degrees1 * Math.PI / 180, q2 = degrees2 * Math.PI / 180;
    const b11 = 200.01 + 50 * Math.cos(q2), b12 = 23.5 + 25 * Math.cos(q2), b22 = 122.5;
    const kinetic = (b11 * d1 * d1 + 2 * b12 * d1 * d2 + b22 * d2 * d2) / 2;
    const potential = 784.8 * Math.sin(q1) + 245.25 * Math.sin(q1 + q2);
    return kinetic + potential;
  };
  const energyRange = [Infinity, -Infinity];
  for (let mask = 0; mask < 16; mask++) {
    const state = displayed.map((value, index) => value + ((mask >> index) & 1 ? 1 : -1) * halfWidths[index]);
    const total = energy(state);
    energyRange[0] = Math.min(energyRange[0], total);
    energyRange[1] = Math.max(energyRange[1], total);
  }
  check(displayed[0] < 0 && displayed[2] < 0 && energyRange[0] <= 0 && energyRange[1] >= 0,
    'zero-torque arm falls and keeps zero energy inside the displayed-value rounding interval', { values, energyRange });
  check(await page.evaluate(() => !!window.robotTrailDrawn), 'free motion paints a visible multi-point end-effector trail');
  check(errors.length === 0, 'no page JavaScript errors', errors);
  await page.close();
  return { passed: results.length, checks: results };
}
