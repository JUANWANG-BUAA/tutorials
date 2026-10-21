import test from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import vm from 'node:vm';
const core=readFileSync(new URL('../shared/theme/js/framework-core.js',import.meta.url),'utf8');
const search=core.slice(core.indexOf('  function patchDeepLinkSearch()'),core.indexOf('  var boots = []'));
function fixture(){
 let tick, cancelled=false; const listeners=new Map();
 const bar={value:'old',dispatchEvent(){}};
 const location={search:'?search=old'};
 const form={classList:{contains(){return true;}}};
 const header={textContent:''};
 const context=vm.createContext({URLSearchParams,location,KeyboardEvent:class {},
 setInterval(fn){tick=fn;return 1;},clearInterval(){cancelled=true;},
 window:{addEventListener(k,v){listeners.set(k,v);},removeEventListener(k){listeners.delete(k);}},
 document:{querySelectorAll(){return [];},getElementById(id){return id==='mdbook-searchbar'?bar:id==='mdbook-searchbar-outer'?form:header;},addEventListener(k,v){listeners.set(k,v);},removeEventListener(k){listeners.delete(k);}}});
 vm.runInContext(search+'\npatchDeepLinkSearch();',context);
 return {bar,listeners,location,form,header,tick:()=>{if(!cancelled)tick();},cancelled:()=>cancelled};
}
test('deep-link retry yields permanently to an edited search query',()=>{
 const f=fixture();f.bar.value='new';f.listeners.get('input')({target:{id:'mdbook-searchbar'}});f.tick();
 assert.equal(f.bar.value,'new');assert.equal(f.cancelled(),true);assert.equal(f.listeners.size,0);
});
test('deep-link retry stops when leaving the page',()=>{
 const f=fixture();f.listeners.get('pagehide')();assert.equal(f.cancelled(),true);assert.equal(f.listeners.size,0);
});
test('deep-link retries are bounded and remove listeners on timeout',()=>{
 const f=fixture();for(let i=0;i<62;i++)f.tick();assert.equal(f.cancelled(),true);assert.equal(f.listeners.size,0);
});

test('closing search or browser history cancels an old deep-link query',()=>{
 const f=fixture();f.location.search='';f.tick();assert.equal(f.cancelled(),true);
});
test('a completed query with zero results is not retried for thirty seconds',()=>{
 const f=fixture();f.form.classList.contains=()=>false;f.header.textContent='没有命中';f.tick();assert.equal(f.cancelled(),true);
});

const registry=core.slice(core.indexOf('  var boots = []'),core.indexOf('  function wireShortcuts()'));
test('enhancements registered after DOM ready still initialize exactly once',()=>{
 const context=vm.createContext({});vm.runInContext(registry,context);
 vm.runInContext('var calls=[];register(()=>calls.push("early"));register(()=>{throw new Error("isolated");});runBoots();register(()=>calls.push("late"));',context);
 assert.deepEqual(Array.from(context.calls),['early','late']);
});

const shortcuts=core.slice(core.indexOf('  function wireShortcuts()'),core.indexOf('  function boot()'));
function shortcutGuard(){
 const document={addEventListener(){},querySelector(){return null;}};
 const window={mdbook_something_else_has_focus:e=>e.target.nodeName==='INPUT'};
 vm.runInNewContext(shortcuts+'\nwireShortcuts();',{window,document});
 return target=>window.mdbook_something_else_has_focus({target});
}
test('chapter and search shortcuts yield to controls, editable content and native inputs',()=>{
 const guard=shortcutGuard();
 assert.equal(Boolean(guard({nodeName:'INPUT',closest:()=>null})),true);
 assert.equal(Boolean(guard({nodeName:'BUTTON',closest:()=>({})})),true);
 assert.equal(Boolean(guard({nodeName:'DIV',isContentEditable:true})),true);
 assert.equal(Boolean(guard({nodeName:'P',closest:()=>null})),false);
});

const arena=readFileSync(new URL('../numerical/theme/js/arena.js',import.meta.url),'utf8');
const clock=arena.slice(arena.indexOf('  function syncTime()'),arena.indexOf('  function stopTimer()'));
test('arena time follows elapsed time when callbacks are throttled',()=>{
 let now=1000,ended=0;
 const round={active:true,left:100,deadline:11000};
 const context=vm.createContext({round,Date:{now:()=>now},updateHud(){},endRound(reason){assert.equal(reason,'timeout');round.active=false;ended++;}});
 vm.runInContext(clock,context);
 now=8500;assert.equal(context.syncTime(),true);assert.equal(round.left,25);
 now=20000;assert.equal(context.syncTime(),false);assert.equal(round.left,0);assert.equal(ended,1);
 assert.equal(context.syncTime(),false);assert.equal(ended,1);
});
const stateLoader=arena.slice(arena.indexOf('  function loadState()'),arena.indexOf('  function saveState('));
test('malformed persisted arena records recover without breaking the question bank',()=>{
 for(const stored of ['null','[]','{"best":12,"wrong":false,"cleared":[],"maxCombo":"invalid"}']){
  const result=vm.runInNewContext(stateLoader+'\nloadState();',{KEY:'test',localStorage:{getItem:()=>stored}});
  assert.equal(typeof result.best,'object');assert.equal(typeof result.wrong,'object');assert.equal(typeof result.cleared,'object');assert.equal(result.maxCombo,0);
 }
});
