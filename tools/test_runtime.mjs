import test from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import vm from 'node:vm';
const core=readFileSync(new URL('../shared/theme/js/framework-core.js',import.meta.url),'utf8');
const search=core.slice(core.indexOf('  function patchDeepLinkSearch()'),core.indexOf('  var boots = []'));
function fixture(){
 let tick, cancelled=false; const listeners=new Map();
 const bar={value:'old',dispatchEvent(){}};
 const context=vm.createContext({URLSearchParams,location:{search:'?search=old'},KeyboardEvent:class {},
 setInterval(fn){tick=fn;return 1;},clearInterval(){cancelled=true;},
 window:{addEventListener(k,v){listeners.set(k,v);},removeEventListener(k){listeners.delete(k);}},
 document:{querySelectorAll(){return [];},getElementById(){return bar;},addEventListener(k,v){listeners.set(k,v);},removeEventListener(k){listeners.delete(k);}}});
 vm.runInContext(search+'\npatchDeepLinkSearch();',context);
 return {bar,listeners,tick:()=>{if(!cancelled)tick();},cancelled:()=>cancelled};
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
