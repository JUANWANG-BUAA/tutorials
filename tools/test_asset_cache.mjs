import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';

const source = readFileSync(new URL('../shared/theme/cache-worker.js', import.meta.url), 'utf8');
const base = 'https://reader.example/tutorials/';
const one = 'book-1111111111111111.js';
const two = 'book-2222222222222222.js';
function worker(manifest = { [one]: 4, [two]: 4 }) {
  const handlers = {};
  const entries = new Map();
  let requests = 0, body = 'v1', status = 200, unavailable = false;
  const cache = {
    async match(request) { return entries.get(request.url)?.clone(); },
    async put(request, response) { entries.set(request.url, response.clone()); },
    async keys() { return [...entries.keys()].map(url => new Request(url)); },
    async delete(request) { return entries.delete(request.url); }
  };
  const context = vm.createContext({ URL, Request, Response, Promise, console,
    self: { registration: { scope: base }, addEventListener(type, fn) { handlers[type] = fn; },
      skipWaiting: async () => {}, clients: { claim: async () => {} } },
    caches: { open: async () => { if (unavailable) throw new Error('denied'); return cache; }, keys: async () => [] },
    async fetch() { requests++; return new Response(body, { status, headers: { 'content-type': 'text/javascript' } }); }
  });
  vm.runInContext(source.replace('/* ASSET_BYTES */ {}', JSON.stringify(manifest)), context);
  return {
    entries, cache, requests: () => requests,
    response(text, code = 200) { body = text; status = code; },
    denyStorage() { unavailable = true; },
    trim: () => vm.runInContext('trim', context)(cache),
    async get(path, method = 'GET') {
      const pending = []; let response;
      handlers.fetch({ request: new Request(new URL(path, base), { method }),
        respondWith(promise) { response = promise; }, waitUntil(promise) { pending.push(promise); } });
      const result = response && await response;
      await Promise.all(pending);
      return result;
    }
  };
}

test('a fingerprinted asset is reused and a changed fingerprint fetches fresh bytes', async () => {
  const w = worker();
  assert.equal(await (await w.get('shared/cache/' + one)).text(), 'v1');
  w.response('v2');
  assert.equal(await (await w.get('shared/cache/' + one)).text(), 'v1');
  assert.equal(await (await w.get('shared/cache/' + two)).text(), 'v2');
  assert.equal(w.requests(), 2);
});
test('HTML, external origins, sibling projects, query strings and non-GET requests bypass the worker', async () => {
  const w = worker();
  for (const path of ['matrix/index.html', 'shared/theme/js/prefs.js', '../other/shared/cache/' + one,
    'https://cdn.example/shared/cache/' + one, 'shared/cache/' + one + '?test=1']) assert.equal(await w.get(path), undefined);
  assert.equal(await w.get('shared/cache/' + one, 'HEAD'), undefined);
  assert.equal(w.requests(), 0);
});
test('404 responses are retried and blocked storage still serves the network', async () => {
  const w = worker(); w.response('missing', 404);
  assert.equal((await w.get('shared/cache/' + one)).status, 404);
  w.response('fixed');
  assert.equal(await (await w.get('shared/cache/' + one)).text(), 'fixed');
  assert.equal(w.requests(), 2);
  w.denyStorage();
  assert.equal(await (await w.get('shared/cache/' + two)).text(), 'fixed');
});
test('byte budget evicts old assets and keeps data from other projects untouched', async () => {
  const w = worker({ [one]: 40 * 1024 * 1024, [two]: 40 * 1024 * 1024 });
  await w.get('shared/cache/' + one); await w.get('shared/cache/' + two);
  assert.equal(w.entries.size, 1);
  assert.ok([...w.entries.keys()][0].endsWith(two));
});
test('a new deployment prunes unknown old resources conservatively', async () => {
  const w = worker();
  w.entries.set(base + 'shared/cache/old-0000000000000000.js', new Response('old'));
  await w.get('shared/cache/' + one);
  assert.equal(w.entries.size, 1);
  assert.ok([...w.entries.keys()][0].endsWith(one));
});
