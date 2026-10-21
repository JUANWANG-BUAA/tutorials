/** Run the committed browser suites through the Playwright skill CLI.
 * Serve at /tutorials/ so Pages-relative paths and worker scope are exercised.
 */
import { execFile, spawn } from 'node:child_process';
import { once } from 'node:events';
import { mkdtemp, readFile, rm, symlink } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { promisify } from 'node:util';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const execute = promisify(execFile);
const session = `tutorials-check-${process.pid}`;
const cli = ['--yes', '--package', '@playwright/cli@0.1.22', 'playwright-cli', '--json', `-s=${session}`];
const preview = await mkdtemp(join(tmpdir(), 'tutorials-browser-'));
let server;
let opened = false;

async function command(...args) {
  const { stdout } = await execute('npx', [...cli, ...args], {
    cwd: root, timeout: 300000, maxBuffer: 8 * 1024 * 1024,
  });
  const result = JSON.parse(stdout);
  if (result.isError) throw new Error(result.error || JSON.stringify(result));
  return result;
}

try {
  await readFile(join(root, '_site/index.html'));
  await symlink(join(root, '_site'), join(preview, 'tutorials'), 'dir');
  server = spawn('python3', ['-u', '-m', 'http.server', '0', '--bind', '127.0.0.1', '--directory', preview], {
    stdio: ['ignore', 'pipe', 'ignore'],
  });
  const port = await new Promise((resolvePort, reject) => {
    const timer = setTimeout(() => reject(new Error('Preview server startup timed out')), 10000);
    let output = '';
    server.stdout.on('data', data => {
      output += data.toString();
      const match = output.match(/port (\d+)/);
      if (match) { clearTimeout(timer); resolvePort(Number(match[1])); }
    });
    server.once('error', error => { clearTimeout(timer); reject(error); });
    server.once('exit', code => { clearTimeout(timer); reject(new Error(`Preview server exited: ${code}`)); });
  });
  opened = true;
  await command('open', `http://127.0.0.1:${port}/tutorials/`, '--browser=chrome');
  for (const suite of ['browser-interactions.js', 'browser-reader-variants.js', 'browser-portal.js', 'browser-cache.js']) {
    const response = await command('run-code', '--filename', `tools/${suite}`);
    const result = JSON.parse(response.result);
    if (!Number.isInteger(result.passed) || result.passed < 1 || result.checks?.length !== result.passed) {
      throw new Error(`${suite} returned an invalid result: ${response.result}`);
    }
    console.log(`${suite}: ${result.passed} checks passed`);
  }
} catch (error) {
  console.error(error.stdout || error.stderr || error.message);
  process.exitCode = 1;
} finally {
  if (opened) {
    try { await command('close'); }
    catch (error) { console.error(`Browser cleanup failed: ${error.message}`); process.exitCode = 1; }
  }
  if (server?.pid && server.exitCode === null) {
    const stopped = once(server, 'exit');
    server.kill();
    await stopped;
  }
  await rm(preview, { recursive: true, force: true });
}
