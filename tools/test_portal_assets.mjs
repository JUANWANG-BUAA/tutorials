import assert from 'node:assert/strict';
import { readFileSync, readdirSync, statSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import test from 'node:test';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const html = readFileSync(resolve(root, 'site-index.html'), 'utf8');

function attributes(source) {
  return Object.fromEntries(Array.from(source.matchAll(/([\w-]+)="([^"]*)"/g), match => [match[1], match[2]]));
}

const anchors = Array.from(html.matchAll(/<a\b([^>]*)>([\s\S]*?)<\/a>/g), match => ({
  attributes: attributes(match[1]),
  content: match[2],
}));
const catalogue = anchors.filter(anchor => anchor.attributes.class?.split(/\s+/).includes('index-row'));

function sourcePath(url) {
  assert.match(url, /^[a-z0-9-]+\/[a-zA-Z0-9/_.-]+$/);
  assert.ok(!url.split('/').includes('..'));
  if (url.startsWith('shared/')) return resolve(root, url);
  const separator = url.indexOf('/');
  return resolve(root, url.slice(0, separator), 'src', url.slice(separator + 1));
}

function assertAsset(url) {
  const path = sourcePath(url);
  assert.ok(statSync(path).isFile(), `Missing portal asset: ${url}`);
  if (url.endsWith('.svg')) {
    const source = readFileSync(path, 'utf8');
    assert.match(source, /^\s*(?:<\?xml[^>]*\?>\s*)?<svg[\s>]/);
    assert.ok(source.trimEnd().endsWith('</svg>'), `Invalid SVG: ${url}`);
  }
}

test('each catalogue course declares existing classic and archive covers', () => {
  assert.ok(catalogue.length > 0);
  const hrefs = catalogue.map(row => row.attributes.href);
  assert.equal(new Set(hrefs).size, hrefs.length);
  for (const row of catalogue) {
    const coverTag = Array.from(row.content.matchAll(/<img\b([^>]*)>/g), match => attributes(match[1]))
      .find(image => image.class?.split(/\s+/).includes('row-cover'));
    assert.ok(coverTag?.src, `Missing classic cover: ${row.attributes.href}`);
    assertAsset(coverTag.src);
    const archiveCover = row.attributes['data-rhine-cover'];
    if (archiveCover) assertAsset(archiveCover);
    assert.ok(statSync(resolve(root, row.attributes.href, 'book.toml')).isFile());
  }
});

test('generated archive plates match the explicit catalogue resources', () => {
  const declared = catalogue.map(row => row.attributes['data-rhine-cover']).filter(Boolean).sort();
  const generated = readdirSync(resolve(root, 'shared/theme/assets'))
    .filter(name => /^rhine-.*\.svg$/.test(name))
    .map(name => 'shared/theme/assets/' + name).sort();
  assert.deepEqual(generated, declared);
});

test('course totals remain accurate before JavaScript runs', () => {
  const counts = Array.from(html.matchAll(/<[^>]+\bdata-course-count(?:\s[^>]*)?>(\d+)<\//g), match => Number(match[1]));
  assert.equal(counts.length, 4);
  assert.ok(counts.every(count => count === catalogue.length), `Static totals must equal ${catalogue.length}`);
  const strip = anchors.filter(anchor => anchor.attributes.class?.split(/\s+/).includes('strip-item'));
  assert.deepEqual(strip.map(row => row.attributes.href), catalogue.map(row => row.attributes.href));
  for (const row of strip) {
    const image = row.content.match(/<img\b([^>]*)>/);
    assert.ok(image, `Missing strip cover: ${row.attributes.href}`);
    assertAsset(attributes(image[1]).src);
  }
});
