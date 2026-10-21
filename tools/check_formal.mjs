/** Execute the committed SMT-LIB obligations with exact real arithmetic.
 * Each file checks satisfiable hypotheses before attempting to refute its claim.
 * Counterexample cases deliberately expect SAT; UNKNOWN or timeout always fails.
 */
import { createHash } from 'node:crypto';
import { execFile } from 'node:child_process';
import { promisify } from 'node:util';
import { readFile, mkdir, writeFile } from 'node:fs/promises';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const execute = promisify(execFile);
const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const directory = join(root, 'tools/formal');
const manifest = JSON.parse(await readFile(join(directory, 'manifest.json'), 'utf8'));
if (!Array.isArray(manifest) || !manifest.length || new Set(manifest.map(entry => entry.id)).size !== manifest.length) {
  throw new Error('Formal manifest must contain uniquely named obligations.');
}
const binary = process.env.Z3_BIN || 'z3';
const { stdout: solverVersion } = await execute(binary, ['-version']);
if (!/^Z3 version 4\.15\.4(?:\s|$)/.test(solverVersion)) throw new Error(`Unexpected solver: ${solverVersion.trim()}`);
console.log(solverVersion.trim());
const digest = value => createHash('sha256').update(value).digest('hex');
const results = [];
let failed = false;
for (const entry of manifest) {
  try {
    const [source, anchor] = entry.source.split('#');
    const markdown = await readFile(join(root, source), 'utf8');
    if (anchor && !markdown.includes(anchor)) throw new Error(`Source anchor missing: ${entry.source}`);
    if (!/^[a-z0-9-]+$/.test(entry.id) || !['sat', 'unsat'].includes(entry.expected?.[1]) || entry.expected[0] !== 'sat' || entry.expected.length !== 2) {
      throw new Error(`Invalid obligation entry: ${entry.id}`);
    }
    const scriptPath = join(directory, 'cases', entry.id + '.smt2');
    const script = await readFile(scriptPath, 'utf8');
    const { stdout, stderr } = await execute(binary, ['-smt2', scriptPath], {
      timeout: 35000, maxBuffer: 2 * 1024 * 1024,
    });
    const statuses = stdout.split(/\r?\n/).map(line => line.trim()).filter(line => /^(sat|unsat|unknown)$/.test(line));
    if (stderr.trim() || stdout.includes('(error ') || JSON.stringify(statuses) !== JSON.stringify(entry.expected)) {
      throw new Error(`Expected ${entry.expected}, got ${statuses}: ${stderr || stdout}`);
    }
    results.push({ ...entry, statuses, solver: solverVersion.trim(), sourceSHA256: digest(markdown), obligationSHA256: digest(script), output: stdout.trim() });
    console.log(`${entry.id}: ${statuses.join(' → ')}`);
  } catch (error) {
    failed = true;
    console.error(`${entry.id}: ${error.message}`);
    results.push({ ...entry, error: error.message });
  }
}
await mkdir(join(root, 'output/formal'), { recursive: true });
await writeFile(join(root, 'output/formal/results.json'), JSON.stringify(results, null, 2) + '\n');
if (failed) process.exitCode = 1;
else console.log(`Formal gate passed: ${results.length} obligations; ${results.filter(entry => entry.expected[1] === 'sat').length} counterexamples reproduced.`);
