/** Regression checks for the shared pre-paint preference boundary.
 * Run: node --test tools/test_theme_config.mjs
 */
import { readFileSync, realpathSync, existsSync, readdirSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, resolve } from 'node:path';
import vm from 'node:vm';
import test from 'node:test';
import assert from 'node:assert/strict';
const root=resolve(dirname(fileURLToPath(import.meta.url)),'..');
const source=readFileSync(resolve(root,'shared/theme/js/prefs-config.js'),'utf8');
function load(values={},denied=false){
 const attrs=new Map();const context=vm.createContext({window:{},document:{documentElement:{setAttribute:(k,v)=>attrs.set(k,v)}},localStorage:{getItem(k){if(denied)throw new Error('denied');return values[k]??null;}}});
 vm.runInContext(source,context);return {attrs,context,config:context.window.TUTORIALS_PREFS};
}
test('first-time readers retain the classic appearance with no extra attributes',()=>{const {attrs,config}=load();assert.equal(attrs.size,0);assert.equal(config.defaults.skin,'classic');});
test('existing preferences and the independent skin restore together',()=>{
 const {attrs}=load({'tutorials-prefs:skin':'rhine','tutorials-prefs:font':'serif','tutorials-prefs:palette':'blueprint','tutorials-prefs:bg':'dots','tutorials-prefs:width':'wide'});
 assert.deepEqual(Object.fromEntries(attrs),{'data-skin':'rhine','data-font':'serif','data-width':'wide','data-palette':'blueprint','data-bg':'dots'});
});
test('explicit classic selection restores the original skin while retaining reading choices',()=>{
 const {attrs,config}=load({'tutorials-prefs:skin':'classic','tutorials-prefs:size':'l'});
 assert.equal(config.defaults.skin,'classic');
 assert.equal(attrs.has('data-skin'),false);
 assert.equal(attrs.get('data-size'),'l');
});
test('invalid stored choices are ignored rather than emitted into the DOM',()=>{const {attrs}=load({'tutorials-prefs:skin':'unknown','tutorials-prefs:font':'<script>','tutorials-prefs:size':'huge'});assert.equal(attrs.size,0);});
test('blocked localStorage keeps the default site usable',()=>{assert.equal(load({},true).attrs.size,0);});
test('mdBook resource registration does not run the early script twice',()=>{const {context,config}=load();vm.runInContext(source,context);assert.equal(context.window.TUTORIALS_PREFS,config);});
test('every selectable value shares the same schema as pre-paint restoration',()=>{
 const {config}=load();for(const option of config.options)for(const choice of option.choices){
  const {attrs}=load({['tutorials-prefs:'+option.key]:choice.value});
  assert.equal(attrs.get(option.attr),choice.value===config.defaults[option.key]?undefined:choice.value);
 }
});
test('all available books resolve to one implementation and register fingerprinted resources',()=>{
 const books=readdirSync(root).filter(book=>existsSync(resolve(root,book,'book.toml')));
 assert.ok(books.length>=7);
 for(const book of books){
  const toml=readFileSync(resolve(root,book,'book.toml'),'utf8');
  for(const file of ['js/prefs-config.js','js/rhine.js','css/rhine.css']){
   assert.equal(realpathSync(resolve(root,book,'theme',file)),realpathSync(resolve(root,'shared/theme',file)));
   assert.ok(toml.includes('"theme/'+file+'"'));
  }
  const css=toml.match(/additional-css\s*=\s*\[([\s\S]*?)\]/)[1];
  assert.ok(css.indexOf('theme/css/rhine.css')<css.indexOf('theme/css/prefs.css'));
 }
});


test('the portal registers the terminal skin, single schema and scene bundle', () => {
 const html=readFileSync(resolve(root,'site-index.html'),'utf8');
 for(const needle of ['shared/theme/css/rhine.css','shared/theme/css/rhine-portal.css','shared/theme/js/portal.js','shared/theme/js/rhine-portal.js','data-scene="shared/theme/js/rhine-scene.js"','data-zh="书目"']){
  assert.ok(html.includes(needle), 'site-index must reference '+needle);
 }
 const portal=readFileSync(resolve(root,'shared/theme/js/rhine-portal.js'),'utf8');
 assert.ok(portal.includes('.index-row'), 'course data must come from the classic catalogue');
 assert.ok(portal.includes('--rh-count'), 'selector size must be derived from the catalogue');
 assert.ok(!portal.includes('books.length!==7')&&!portal.includes('books.length !== 7'), 'portal must not hard-code seven courses');
 assert.ok(portal.includes('data-scene'), 'scene URL is a declared hook');
});

test('the scene bundle is a committed build artifact, not hand-written runtime code', () => {
 const scene=readFileSync(resolve(root,'shared/theme/js/rhine-scene.js'),'utf8');
 assert.ok(scene.includes('TUTORIALS_RHINE_SCENE'));
 assert.ok(scene.length>100000, 'bundled Three.js scene should be present');
 const source=readFileSync(resolve(root,'tools/theme-renderer/scene.js'),'utf8');
 assert.ok(source.includes('new THREE.WebGLRenderer'));
 assert.ok(source.includes('prefers-reduced-motion'));
 assert.ok(source.includes('bookGroups')&&source.includes('bookAt')&&source.includes('raycaster'), 'archive objects remain selectable');
 assert.ok(source.includes('visibilitychange')&&source.includes('IntersectionObserver'), 'renderer pauses outside the visible page');
 const pkg=JSON.parse(readFileSync(resolve(root,'tools/theme-renderer/package.json'),'utf8'));
 assert.match(pkg.scripts.build,/outfile=..\/..\/shared\/theme\/js\/rhine-scene\.js/);
 assert.ok(existsSync(resolve(root,'tools/theme-renderer/build_art.py')));
});

test('all eight generated cover plates exist and are valid SVG documents', () => {
 const files=readdirSync(resolve(root,'shared/theme/assets')).filter(f=>/^rhine-.*\.svg$/.test(f));
 assert.equal(files.length,8);
 for(const f of files){
  const svg=readFileSync(resolve(root,'shared/theme/assets',f),'utf8');
  assert.match(svg,/^<svg[\s>]/);
  assert.ok(svg.trimEnd().endsWith('</svg>'));
  assert.ok(!svg.includes('& KERNEL'), 'XML ampersands must be escaped (rhine-linux.svg regression)');
 }
});

test('the skin contract is documented and the reader chrome is terminal-scoped', () => {
 const doc=readFileSync(resolve(root,'shared/theme/RHINE.md'),'utf8');
 for(const needle of ['ak.hypergryph.com','endfield.hypergryph.com','RhineLabUI','classic','prefers-reduced-motion']) assert.ok(doc.includes(needle));
 const css=readFileSync(resolve(root,'shared/theme/css/rhine.css'),'utf8');
 assert.ok(css.trimStart().includes('@media screen'));
 assert.ok(css.includes('html[data-skin="rhine"] #mdbook-menu-bar'));
 assert.ok(css.includes('background:var(--page);color:var(--ink)'), 'reader chrome follows the paper palette');
 const portal=readFileSync(resolve(root,'shared/theme/css/rhine-portal.css'),'utf8');
 assert.ok(portal.includes('.rhine-portal')&&portal.includes('.rh-stage'));
 assert.ok(portal.includes('prefers-reduced-motion'), 'motion respects reader preferences');
 assert.ok(portal.includes('.rh-boot'), 'terminal boot styles must be declared');
 const portalJs=readFileSync(resolve(root,'shared/theme/js/rhine-portal.js'),'utf8');
 assert.ok(portalJs.includes('rh-boot')&&portalJs.includes('sessionStorage')&&portalJs.includes('prefers-reduced-motion'), 'boot must be once-per-tab, skippable and motion-safe');
});
