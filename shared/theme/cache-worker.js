/* Only content-addressed resources are immutable. HTML always uses the network
 * and GitHub's normal HTTP cache, so a worker cannot pin an old tutorial page.
 * No eager downloads, third-party requests, or unbounded offline book cache.
 */
"use strict";
const ASSET_BYTES = /* ASSET_BYTES */ {};
const ROOT = new URL(self.registration.scope);
const PREFIX = "tutorials-assets:" + ROOT.pathname + ":";
const CACHE = PREFIX + "v1";
const MAX_BYTES = 64 * 1024 * 1024;
const MAX_ENTRIES = 180;
let writes = Promise.resolve();

function assetKey(request) {
  const url = new URL(request.url);
  const path = url.pathname.slice(ROOT.pathname.length);
  return request.method === "GET" && url.origin === ROOT.origin && url.pathname.startsWith(ROOT.pathname)
    && !url.search && /^shared\/cache\/[\w.-]+-[a-f0-9]{16}\.[a-z0-9]+$/.test(path)
    ? path.slice("shared/cache/".length) : null;
}

async function trim(cache) {
  const keys = await cache.keys();
  // Unknown files belong to an older deployment; count conservatively so the
  // budget still holds after updates without reading large bodies into memory.
  const sizes = keys.map(key => ASSET_BYTES[new URL(key.url).pathname.split("/").pop()] || MAX_BYTES);
  let bytes = sizes.reduce((sum, size) => sum + size, 0);
  let count = keys.length;
  for (let i = 0; i < keys.length && (bytes > MAX_BYTES || count > MAX_ENTRIES); i++) {
    await cache.delete(keys[i]);
    bytes -= sizes[i];
    count--;
  }
}

self.addEventListener("install", event => event.waitUntil(self.skipWaiting()));
self.addEventListener("activate", event => {
  event.waitUntil((async () => {
    for (const name of await caches.keys()) if (name.startsWith(PREFIX) && name !== CACHE) await caches.delete(name);
    try { await trim(await caches.open(CACHE)); } catch (error) { /* storage may be unavailable */ }
    await self.clients.claim();
  })());
});

self.addEventListener("fetch", event => {
  const key = assetKey(event.request);
  if (!key) return;
  const responsePromise = (async () => {
    let cache;
    try {
      cache = await caches.open(CACHE);
      const saved = await cache.match(event.request);
      if (saved) return saved;
    } catch (error) { /* keep the normal network path available */ }
    const response = await fetch(event.request);
    // Never persist failed responses or redirects (including HTML 404 pages).
    if (cache && response.status === 200 && !response.redirected && !/text\/html/i.test(response.headers.get("content-type") || "") && ASSET_BYTES[key] <= MAX_BYTES) {
      const copy = response.clone();
      writes = writes.catch(() => {}).then(async () => {
        await cache.put(event.request, copy);
        await trim(cache);
      });
    }
    return response;
  })();
  event.respondWith(responsePromise);
  event.waitUntil(responsePromise.then(() => writes).catch(() => {}));
});
