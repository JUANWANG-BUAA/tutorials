async (hostPage) => {
  const url = new URL(hostPage.url());
  const prefix = url.pathname.replace(/\/(robot|matrix|numerical|deeplearning|linux|agent-systems|distributed|compilers|algorithms|embodied|cpp-rust|edge|mlm)\/.*$/, '/').replace(/index\.html$/, '');
  const base = url.origin + prefix.replace(/\/$/, '');
  const page = await hostPage.context().browser().newPage({ serviceWorkers: 'block' });
  const checks = [];
  const errors = [];
  const failedImages = [];
  const check = (condition, name, detail) => {
    if (!condition) throw new Error(name + ': ' + JSON.stringify(detail));
    checks.push(name);
  };
  const visit = path => page.goto(base + path);
  const settle = () => page.evaluate(() => new Promise(resolve => requestAnimationFrame(() => requestAnimationFrame(resolve))));
  const emulateMedium = async media => {
    await page.emulateMedia({ media, reducedMotion: 'reduce', colorScheme: 'light' });
    await page.waitForFunction(value => matchMedia(value).matches, media);
    await page.evaluate(async () => {
      const surfaces = [document.documentElement, document.body, document.querySelector('.page-wrapper')].filter(Boolean);
      const animations = surfaces.flatMap(element => element.getAnimations()).filter(animation => Number.isFinite(animation.effect.getComputedTiming().endTime));
      await Promise.all(animations.map(animation => animation.finished.catch(() => {})));
    });
    await settle();
  };
  const chooseTheme = async theme => {
    await page.locator('#mdbook-theme-toggle').click();
    await page.locator('#mdbook-theme-' + theme).click();
    await page.waitForFunction(value => document.documentElement.classList.contains(value), theme);
    await page.waitForFunction(() => document.querySelector('#mdbook-theme-list').style.display === 'none');
  };
  const choosePreferences = async values => {
    await page.getByRole('button', { name: '阅读偏好', exact: true }).click();
    for (const [group, label] of Object.entries(values)) {
      await page.locator('#prefs-panel [data-pref="' + group + '"]').getByRole('button', { name: label, exact: true }).click();
    }
    await page.keyboard.press('Escape');
    await settle();
  };
  const contrast = element => {
    const canvas = document.createElement('canvas');
    canvas.width = canvas.height = 1;
    const context = canvas.getContext('2d', { willReadFrequently: true });
    const rgba = value => {
      context.clearRect(0, 0, 1, 1);
      context.fillStyle = value;
      context.fillRect(0, 0, 1, 1);
      return Array.from(context.getImageData(0, 0, 1, 1).data);
    };
    const composite = (foreground, background) => foreground.slice(0, 3).map((channel, index) => channel * foreground[3] / 255 + background[index] * (1 - foreground[3] / 255)).concat(255);
    const ancestors = [];
    for (let parent = element; parent; parent = parent.parentElement) ancestors.unshift(parent);
    const background = ancestors.reduce((under, node) => composite(rgba(getComputedStyle(node).backgroundColor), under), [255, 255, 255, 255]);
    const foreground = composite(rgba(getComputedStyle(element).color), background);
    const luminance = color => color.slice(0, 3).map(channel => {
      const normalized = channel / 255;
      return normalized <= 0.04045 ? normalized / 12.92 : ((normalized + 0.055) / 1.055) ** 2.4;
    }).reduce((total, value, index) => total + value * [0.2126, 0.7152, 0.0722][index], 0);
    const foregroundLight = luminance(foreground);
    const backgroundLight = luminance(background);
    return { ratio: (Math.max(foregroundLight, backgroundLight) + 0.05) / (Math.min(foregroundLight, backgroundLight) + 0.05), foreground, background };
  };
  const svgStyles = svg => {
    return ['.diagram-text', '.diagram-note', '.diagram-axis', '.sb'].flatMap(selector => Array.from(svg.querySelectorAll(selector), node => {
      const style = getComputedStyle(node);
      const properties = selector === '.diagram-axis' ? ['fill', 'stroke', 'strokeWidth'] : ['fill', 'fontFamily', 'fontSize', 'fontWeight', 'baselineShift'];
      return { selector, text: node.textContent, styles: Object.fromEntries(properties.map(property => [property, style[property]])) };
    }));
  };
  const backgroundSnapshot = () => page.evaluate(() => {
    const root = document.documentElement;
    const style = getComputedStyle(document.querySelector('.page-wrapper'));
    const probe = document.createElement('span');
    probe.style.color = 'var(--page)';
    root.appendChild(probe);
    const pageColor = getComputedStyle(probe).color;
    probe.remove();
    return { skin: root.getAttribute('data-skin'), palette: root.getAttribute('data-palette'), background: root.getAttribute('data-bg'), color: style.backgroundColor, image: style.backgroundImage, pageColor };
  });
  const firstScreen = () => page.evaluate(() => {
    const paragraph = document.querySelector('main > p');
    const rect = paragraph && paragraph.getBoundingClientRect();
    const disclosure = document.querySelector('details.page-toc-disclosure');
    return { closed: disclosure && !disclosure.open, paragraphVisible: !!rect && rect.top >= 0 && rect.top < innerHeight - 24 && rect.height > 0, overflow: document.documentElement.scrollWidth > innerWidth + 1 };
  });
  const readingContent = () => page.locator('main').evaluate(main => ({
    heading: main.querySelector('h1 .header').textContent,
    paragraphs: Array.from(main.querySelectorAll(':scope > p'), element => element.textContent),
    formulas: Array.from(main.querySelectorAll('annotation[encoding="application/x-tex"]'), element => element.textContent),
    widgets: main.querySelectorAll('.widget-canvas').length
  }));
  page.on('pageerror', error => errors.push(error.message));
  page.on('response', response => {
    if (response.request().resourceType() === 'image' && response.status() >= 400) failedImages.push({ url: response.url(), status: response.status() });
  });
  await page.route('**/*', route => route.continue());

  try {
    await page.setViewportSize({ width: 1280, height: 850 });
    await page.emulateMedia({ reducedMotion: 'reduce', colorScheme: 'light' });
    await visit('/matrix/ch01/sec16.html');
    await page.locator('#prefs-toggle').waitFor();
    const defaultBackgrounds = [];
    for (const theme of ['light', 'coal']) {
      await chooseTheme(theme);
      defaultBackgrounds.push(await backgroundSnapshot());
    }
    check(defaultBackgrounds.every(state => state.image === 'none' && state.color === state.pageColor && state.color !== 'rgba(0, 0, 0, 0)'), 'new readers get an opaque plain surface in both light and dark themes', defaultBackgrounds);

    const selectedBackgrounds = [];
    const toolbarContrasts = [];
    const toolbarFocusContrasts = [];
    const originalContent = await readingContent();
    for (const theme of ['light', 'coal']) {
      await chooseTheme(theme);
      for (const skin of ['原有图鉴', '莱茵档案']) {
        await choosePreferences({ skin, palette: theme === 'light' ? '海蓝' : '工程蓝', bg: '纯净' });
        selectedBackgrounds.push(await backgroundSnapshot());
        await page.locator('#mdbook-theme-toggle').hover();
        await settle();
        toolbarContrasts.push(await page.locator('#mdbook-theme-toggle').evaluate(contrast));
        await page.mouse.move(0, 0);
        await page.locator('#mdbook-theme-toggle').focus();
        await page.keyboard.press('Tab');
        await page.keyboard.press('Shift+Tab');
        await settle();
        toolbarFocusContrasts.push({ visible: await page.locator('#mdbook-theme-toggle').evaluate(element => element.matches(':focus-visible')), ...await page.locator('#mdbook-theme-toggle').evaluate(contrast) });
      }
    }
    check(selectedBackgrounds.every(state => state.image === 'none' && state.color === state.pageColor && state.color !== 'rgba(0, 0, 0, 0)'), 'skin and palette choices preserve the selected opaque plain background', selectedBackgrounds);
    check(toolbarContrasts.every(state => state.ratio >= 3), 'toolbar icons remain distinguishable when hovered in each skin and brightness', toolbarContrasts);
    check(toolbarFocusContrasts.every(state => state.visible && state.ratio >= 3), 'toolbar icons remain distinguishable with keyboard focus in each skin and brightness', toolbarFocusContrasts);
    await choosePreferences({ skin: '原有图鉴', palette: '随主题' });
    await chooseTheme('light');
    check(JSON.stringify(originalContent) === JSON.stringify(await readingContent()), 'theme and skin round trips preserve paragraphs, formulas and interactive widgets');

    await choosePreferences({ skin: '莱茵档案', palette: '工程蓝', bg: '纸张纤维' });
    const selected = await backgroundSnapshot();
    const runtimePattern = /\/prefs(?:-[a-f0-9]+)?\.js(?:\?|$)/;
    let releaseRuntime;
    let markRuntimeRequested;
    const runtimeGate = new Promise(resolve => { releaseRuntime = resolve; });
    const runtimeRequested = new Promise(resolve => { markRuntimeRequested = resolve; });
    await page.route(runtimePattern, async route => {
      markRuntimeRequested();
      await runtimeGate;
      await route.continue();
    });
    let beforeRuntime;
    try {
      await page.reload({ waitUntil: 'commit' });
      await Promise.race([runtimeRequested, new Promise((resolve, reject) => setTimeout(() => reject(new Error('Reading preference runtime was not requested')), 10000))]);
      await page.locator('.page-wrapper').waitFor({ state: 'attached' });
      beforeRuntime = await backgroundSnapshot();
    } finally {
      releaseRuntime();
      await page.waitForLoadState('load');
      await page.unroute(runtimePattern);
    }
    const restored = await backgroundSnapshot();
    check(selected.image !== 'none' && JSON.stringify(selected) === JSON.stringify(beforeRuntime) && JSON.stringify(selected) === JSON.stringify(restored), 'explicit paper texture restores before preference controls boot and survives reload', { selected, beforeRuntime, restored });

    const galleryContrasts = [];
    const galleryMetaContrasts = [];
    const galleryFocusContrasts = [];
    for (const chapter of ['/matrix/ch01/sec16.html', '/robot/ch03/sec3-2.html']) {
      await visit(chapter);
      const figure = chapter.startsWith('/robot/') ? page.locator('main figure').filter({ has: page.locator('.diagram-axis') }).filter({ has: page.locator('.sb') }).first() : page.locator('main figure').filter({ has: page.locator('.diagram-text') }).first();
      const figureIndex = await figure.evaluate(element => Array.from(document.querySelectorAll('main figure')).indexOf(element));
      const styles = [];
      for (const theme of ['light', 'coal']) {
        await chooseTheme(theme);
        for (const skin of ['原有图鉴', '莱茵档案']) {
          await choosePreferences({ skin, palette: '随主题', bg: '纯净' });
          const source = await figure.locator('svg').evaluate(svgStyles);
          await figure.focus();
          await page.keyboard.press('Enter');
          const enlarged = await page.locator('#figure-zoom svg').evaluate(svgStyles);
          await page.keyboard.press('Escape');
          await page.getByRole('button', { name: '打开本页图鉴', exact: true }).click();
          const entry = page.locator('.atlas-entry').nth(figureIndex);
          const thumbnail = await entry.locator('svg').evaluate(svgStyles);
          styles.push({ theme, skin, source, enlarged, thumbnail });
          await entry.hover();
          await settle();
          galleryContrasts.push(await entry.locator('.atlas-entry-title').evaluate(contrast));
          galleryMetaContrasts.push(await entry.locator('.atlas-entry-meta').evaluate(contrast));
          await page.mouse.move(0, 0);
          await entry.focus();
          await page.keyboard.press('Tab');
          await page.keyboard.press('Shift+Tab');
          await settle();
          galleryFocusContrasts.push({ visible: await entry.evaluate(element => element.matches(':focus-visible')), title: await entry.locator('.atlas-entry-title').evaluate(contrast), metadata: await entry.locator('.atlas-entry-meta').evaluate(contrast) });
          await page.keyboard.press('Escape');
        }
      }
      check(styles.every(state => state.source.length > 0 && JSON.stringify(state.source) === JSON.stringify(state.enlarged) && JSON.stringify(state.source) === JSON.stringify(state.thumbnail)), chapter + ' preserves SVG text, axes and subscript styles across reader, lightbox and gallery', styles);
    }
    check(galleryContrasts.every(state => state.ratio >= 4.5), 'gallery titles remain readable on hover in both themes and skins', galleryContrasts);
    check(galleryMetaContrasts.every(state => state.ratio >= 4.5), 'gallery metadata remains readable on hover in both themes and skins', galleryMetaContrasts);
    check(galleryFocusContrasts.every(state => state.visible && state.title.ratio >= 4.5 && state.metadata.ratio >= 4.5), 'gallery titles and metadata retain readable contrast with keyboard focus', galleryFocusContrasts);

    const printStates = [];
    for (const theme of ['light', 'coal']) {
      await chooseTheme(theme);
      for (const skin of ['原有图鉴', '莱茵档案']) {
        await choosePreferences({ skin, palette: '工程蓝', bg: '方格纸' });
        await emulateMedium('print');
        printStates.push(await page.locator('body').evaluate(element => {
          const style = getComputedStyle(element);
          const wrapper = getComputedStyle(document.querySelector('.page-wrapper'));
          const foreground = style.color.match(/[\d.]+/g).slice(0, 3).map(Number);
          return { foreground, background: style.backgroundColor, bodyImage: style.backgroundImage, wrapperImage: wrapper.backgroundImage };
        }));
        await emulateMedium('screen');
      }
    }
    check(printStates.every(state => state.background === 'rgb(255, 255, 255)' && state.foreground.every(channel => channel <= 60) && state.bodyImage === 'none' && state.wrapperImage === 'none'), 'printing uses white paper and dark text without screen palettes or textures', printStates);

    await visit('/robot/ch07/homework07.html');
    const matlabCode = page.locator('pre code.language-matlab').first();
    await matlabCode.waitFor();
    const matlabSource = await matlabCode.textContent();
    const matlabTokens = await matlabCode.locator('.hljs-comment').allTextContents();
    check(await matlabCode.evaluate(element => element.classList.contains('hljs')) && matlabTokens.length >= 3 && matlabTokens.every(token => token.startsWith('%')), 'the published MATLAB example highlights its comments with the registered grammar', matlabTokens);
    const matlabColors = [];
    for (const theme of ['light', 'coal']) {
      await chooseTheme(theme);
      for (const skin of ['原有图鉴', '莱茵档案']) {
        await choosePreferences({ skin, palette: '随主题', bg: '纯净' });
        const plainColor = await matlabCode.evaluate(element => getComputedStyle(element).color);
        const comments = matlabCode.locator('.hljs-comment');
        const commentColors = await comments.evaluateAll(elements => elements.map(element => getComputedStyle(element).color));
        const commentContrasts = [];
        for (const comment of await comments.all()) commentContrasts.push(await comment.evaluate(contrast));
        matlabColors.push({ theme, skin, plainColor, commentColors, commentContrasts });
      }
    }
    check(matlabColors.every(state => state.commentColors.every(color => color !== state.plainColor) && state.commentContrasts.every(value => value.ratio >= 4.5)) && await matlabCode.textContent() === matlabSource, 'MATLAB comments remain distinct from code and readable across light, coal and both skins without changing source text', matlabColors);

    await page.setViewportSize({ width: 390, height: 844 });
    const mobileStates = [];
    for (const chapter of ['/matrix/ch01/sec16.html', '/robot/ch02/sec2-4.html']) {
      await visit(chapter);
      await choosePreferences({ skin: '莱茵档案', palette: '随主题', bg: '纯净' });
      await page.evaluate(() => window.scrollTo({ top: 0, behavior: 'instant' }));
      mobileStates.push(await firstScreen());
    }
    check(mobileStates.every(state => state.closed && state.paragraphVisible && !state.overflow), 'mobile chapters collapse the page contents and show teaching text in the first screen', mobileStates);

    const disclosure = page.locator('details.page-toc-disclosure');
    await disclosure.locator('summary').focus();
    await page.keyboard.press('Enter');
    check(await disclosure.evaluate(element => element.open) && await disclosure.locator('nav a').first().isVisible(), 'the mobile page contents opens by keyboard and exposes chapter links');
    await page.setViewportSize({ width: 1280, height: 850 });
    await page.setViewportSize({ width: 390, height: 844 });
    await settle();
    check(await disclosure.evaluate(element => element.open), 'a reader-selected page contents state survives viewport changes');

    await page.setViewportSize({ width: 1280, height: 850 });
    await visit('/matrix/ch01/sec16.html');
    const desktopOpen = await page.locator('details.page-toc-disclosure').evaluate(element => element.open);
    await page.setViewportSize({ width: 390, height: 844 });
    await settle();
    const mobileClosed = await page.locator('details.page-toc-disclosure').evaluate(element => !element.open);
    check(desktopOpen && mobileClosed, 'untouched page contents adapts from open on desktop to closed on mobile');

    await page.setViewportSize({ width: 1600, height: 1000 });
    await visit('/matrix/ch01/sec16.html');
    await choosePreferences({ skin: '原有图鉴', size: '中', width: '标准' });
    if (await page.locator('#mdbook-sidebar-toggle-anchor').isChecked()) await page.locator('#mdbook-sidebar-toggle').click();
    await page.waitForFunction(() => document.documentElement.classList.contains('has-page-rail'));
    await page.evaluate(() => window.scrollTo({ top: 0, behavior: 'instant' }));
    const railContents = page.locator('details.page-toc-disclosure');
    const railSummary = railContents.locator('summary');
    if (await railContents.evaluate(element => element.open)) await railSummary.click();
    await settle();
    const railState = () => page.evaluate(() => {
      const root = document.documentElement;
      const contents = document.querySelector('details.page-toc-disclosure');
      return { available: root.classList.contains('has-page-rail'), visible: root.classList.contains('rail-visible'), open: contents.open, bottom: contents.getBoundingClientRect().bottom, scroll: scrollY };
    });
    const topRail = await railState();
    await page.evaluate(() => {
      const bottom = document.querySelector('details.page-toc-disclosure').getBoundingClientRect().bottom + scrollY;
      window.scrollTo({ top: bottom - 70, behavior: 'instant' });
    });
    await page.waitForFunction(() => document.documentElement.classList.contains('rail-visible'));
    const scrolledRail = await railState();
    const summaryBounds = await railSummary.boundingBox();
    await railSummary.click({ position: { x: 20, y: summaryBounds.height - 4 } });
    await settle();
    const expandedRail = await railState();
    check(topRail.available && !topRail.visible && !topRail.open && scrolledRail.visible && expandedRail.open && !expandedRail.visible && expandedRail.bottom > scrolledRail.bottom && Math.abs(expandedRail.scroll - scrolledRail.scroll) <= 2, 'desktop outline tracks the collapsed contents boundary and recomputes immediately when it expands', { topRail, scrolledRail, expandedRail });

    const largeTextLayouts = [];
    for (const width of [320, 390]) {
      await page.setViewportSize({ width, height: 844 });
      await visit('/matrix/ch01/sec16.html');
      await page.locator('main > h1 .header').evaluate(element => { element.textContent = '1.6 直和与投影：从唯一分解、正交补到一般子空间上的投影'; });
      await page.locator('.page-toc a').first().evaluate(element => { element.textContent = '1.6.1 直和与投影的完整判据、唯一分解与正交子空间之间的联系'; });
      await choosePreferences({ skin: '莱茵档案', size: '特大' });
      await page.locator('details.page-toc-disclosure > summary').focus();
      await page.keyboard.press('Enter');
      await settle();
      largeTextLayouts.push(await page.evaluate(() => {
        const heading = document.querySelector('main > h1');
        const toc = document.querySelector('.page-toc');
        const firstLink = toc.querySelector('a');
        const textFits = element => {
          const parent = element.closest('h1')?.getBoundingClientRect() || element.getBoundingClientRect();
          const range = document.createRange();
          range.selectNodeContents(element);
          return Array.from(range.getClientRects()).every(rect => rect.left >= parent.left - 1 && rect.right <= parent.right + 1);
        };
        return {
          width: innerWidth,
          viewportFits: document.documentElement.scrollWidth <= innerWidth + 1,
          largePreference: document.documentElement.getAttribute('data-size') === 'xl',
          tocOpen: document.querySelector('details.page-toc-disclosure').open,
          headingFits: heading.scrollWidth <= heading.clientWidth + 1 && textFits(heading.querySelector('.header')),
          tocFits: toc.scrollWidth <= toc.clientWidth + 1 && firstLink.scrollWidth <= firstLink.clientWidth + 1 && textFits(firstLink),
          headingText: heading.textContent,
          linkText: firstLink.textContent
        };
      }));
    }
    check(largeTextLayouts.every(state => state.viewportFits && state.largePreference && state.tocOpen && state.headingFits && state.tocFits), '320px and 390px readers wrap long headings and page contents at the largest text size', largeTextLayouts);

    await page.setViewportSize({ width: 1280, height: 850 });
    await visit('/');
    const courseCount = await page.locator('.index-row').count();
    const displayedCounts = await page.locator('[data-course-count]').allTextContents();
    const coverStates = [];
    for (const skin of ['rhine', 'classic', 'rhine']) {
      await page.getByLabel('界面外观').selectOption(skin);
      if (skin !== 'rhine') continue;
      const covers = page.locator('.rh-course-cover img');
      await covers.evaluateAll(images => images.forEach(image => { image.loading = 'eager'; }));
      await page.waitForFunction(() => Array.from(document.querySelectorAll('.rh-course-cover img')).every(image => image.complete));
      coverStates.push(await covers.evaluateAll(images => images.map(image => ({ src: image.currentSrc, width: image.naturalWidth }))));
    }
    check(courseCount > 8 && displayedCounts.length > 0 && displayedCounts.every(value => Number(value) === courseCount) && coverStates.every(images => images.length === courseCount && images.every(image => image.width > 0)) && failedImages.length === 0, 'portal skin round trips retain accurate course counts and decoded covers without failed image requests', { courseCount, displayedCounts, coverStates, failedImages });
    check(errors.length === 0, 'visual contracts produce no uncaught JavaScript errors', errors);
    return { passed: checks.length, checks };
  } finally {
    await page.close();
  }
}
