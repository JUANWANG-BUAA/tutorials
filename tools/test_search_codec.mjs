import test from 'node:test';
import assert from 'node:assert/strict';
import { compactSearchIndex, expandSearchIndex } from './search-codec.mjs';
import vm from 'node:vm';

test('compact search trie preserves every reference, score, prefix and empty node', () => {
  const original = { index: { index: { body: { root: {
    docs: {}, df: 0,
    中: { docs: { 1: { tf: 1 }, 12: { tf: Math.sqrt(2) } }, df: 2,
      文: { docs: { 7: { tf: 4.125 } }, df: 1 } },
    a: { docs: {}, df: 0, b: { docs: { 3: { tf: 1 } }, df: 1 } }
  } } } }, documentStore: { docs: { 1: { body: '中文' } } } };
  const packed = compactSearchIndex(structuredClone(original));
  assert.ok(JSON.stringify(packed).length < JSON.stringify(original).length);
  assert.deepEqual(expandSearchIndex(structuredClone(packed)), original);
  // The generated index must restore itself without importing any module.
  const restored = vm.runInNewContext('(' + expandSearchIndex.toString() + ')(' + JSON.stringify(packed) + ')');
  assert.deepEqual(JSON.parse(JSON.stringify(restored)), original);
});
