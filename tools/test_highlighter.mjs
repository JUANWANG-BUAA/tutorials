import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, readdirSync, realpathSync } from 'node:fs';
import { resolve } from 'node:path';
import vm from 'node:vm';

const root = new URL('../', import.meta.url);
const context = vm.createContext({ window: {} });
vm.runInContext(readFileSync(new URL('shared/theme/vendor/highlight.js', root), 'utf8'), context);
const highlighter = context.window.hljs;

test('all eight books load the same offline highlighter before mdBook code rendering', () => {
  for (const book of ['robot', 'matrix', 'numerical', 'deeplearning', 'linux', 'agent-systems', 'distributed', 'compilers']) {
    assert.equal(realpathSync(new URL(book + '/theme/highlight.js', root)), realpathSync(new URL('shared/theme/vendor/highlight.js', root)));
  }
});

test('every fenced code language in the current source has an explicit grammar or plaintext fallback', () => {
  function visit(dir) {
    for (const entry of readdirSync(dir, { withFileTypes: true })) {
      const file = resolve(dir, entry.name);
      if (entry.isDirectory()) visit(file);
      else if (entry.name.endsWith('.md')) {
        for (const match of readFileSync(file, 'utf8').matchAll(/^```([a-zA-Z][\w+-]*)/gm)) {
          assert.ok(highlighter.getLanguage(match[1]), `${file}: unsupported ${match[1]}`);
        }
      }
    }
  }
  for (const book of ['robot', 'matrix', 'numerical', 'deeplearning', 'linux', 'agent-systems', 'distributed', 'compilers']) visit(new URL(book + '/src', root).pathname);
});

test('assembly and common tutorial languages render colored tokens and escaped code', () => {
  for (const [language, code] of [['asm', 'mov rax, 60\nsyscall'], ['python', 'def f(x):\n  return x < 2'], ['c', 'int main(void) { return 0; }'], ['rust', 'fn main() { let x = 1; }']]) {
    const rendered = highlighter.highlight(code, { language }).value;
    assert.match(rendered, /class="hljs-/);
    assert.ok(!rendered.includes('x < 2'));
  }
});
