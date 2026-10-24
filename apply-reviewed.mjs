import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';
import {readFileSync,writeFileSync,mkdirSync} from 'node:fs';
assert.equal(process.env.GITHUB_ACTIONS,'true');assert.equal(process.platform,'linux');
assert.equal(execFileSync('calcit',['-v'],{encoding:'utf8'}).trim(),'0.30.1');
const run=(...a)=>execFileSync('calcit',['calcit.cirru',...a],{encoding:'utf8',maxBuffer:48e6,stdio:['ignore','pipe','pipe']});
const blob=()=>execFileSync('git',['hash-object','calcit.cirru'],{encoding:'utf8'}).trim();
assert.equal(blob(),'a4316b648c192810c53da0e74a9737dab501956f');
const norm=v=>Array.isArray(v)?v.map(norm):v&&typeof v==='object'?Object.fromEntries(Object.entries(v).map(([k,x])=>[k,k==='__edn_set'?x.map(norm).sort((a,b)=>JSON.stringify(a).localeCompare(JSON.stringify(b))):norm(x)])):v;
const q=(...a)=>norm(JSON.parse(run('query',...a,'--format','json')).data);
const input=JSON.parse(readFileSync('reviewed.json','utf8'));
const before={config:norm(input.config.data),namespaces:input.namespaces.map(x=>norm(x.data)),defs:input.definitions.map(x=>norm(x.data))};
assert.equal(before.defs.length,19);assert.equal(before.defs.reduce((n,d)=>n+d.tests.length,0),1);assert.equal(before.defs.reduce((n,d)=>n+d.examples.length,0),0);
assert.deepEqual(q('config'),before.config);assert.deepEqual(q('ns').namespaces.map(n=>q('ns',n)),before.namespaces);
for(const d of before.defs)assert.deepEqual(q('def',d.id),d);
const expected=structuredClone(before),ops=[],sites=[],counts={merge:0,'option:unwrap-or':0,'option:unwrap':0,css:0,dispatchContract:0};
const show=(id,path)=>JSON.parse(run('tree','show',id,'--path','@'+path.join('.'),'--format','json')).tree;
const replace=(id,path,value)=>ops.push(['tree','replace',id,'--path','@'+path.join('.'),'--input-format','json-ast','--code',JSON.stringify(value)]);
const dispatch=['::',"'Fn",['{}',[':args',['[]',"'Dynamic"]],[':rest',"'Dynamic"],[':return',"'Unit"]]];
function walk(x,path,id){
  if(!Array.isArray(x)||['quote','quasiquote','comment',';','defmacro'].includes(x[0]))return x;
  const original=structuredClone(x);
  if(['merge','option:unwrap-or','option:unwrap'].includes(x[0])){
    const old=x[0];assert.deepEqual(show(id,path),original);const next={merge:'.merge','option:unwrap-or':'.unwrap-or','option:unwrap':'.unwrap'}[old];
    replace(id,[...path,0],next);x[0]=next;counts[old]++;sites.push({id,path,original});
  }
  if(x[0]==='{}')for(let j=1;j<x.length;j++)if(Array.isArray(x[j])&&x[j][0]===':padding'&&x[j][1]==='8'){
    assert.equal(id,'app.comp.container/comp-demo');const p=[...path,j,1];assert.equal(show(id,p),'8');replace(id,p,'|8px');x[j][1]='|8px';counts.css++;sites.push({id,path:p,before:'8',after:'|8px'});
  }
  if(x[0]==='hint-fn'){
    assert.ok(['app.comp.container/comp-container','app.comp.container/comp-demo','app.comp.container/use-log'].includes(id));
    assert.deepEqual(x,['hint-fn',['{}',[':return',"'Unit"],[':args',['[]',['::',"'Map","'Tag","'Dynamic"],"'Dynamic"]]]]);
    const p=[...path,1,2,1,2];assert.equal(show(id,p),"'Dynamic");replace(id,p,dispatch);x[1][2][1][2]=structuredClone(dispatch);counts.dispatchContract++;sites.push({id,path:p,before:"'Dynamic",after:dispatch});
  }
  return x.map((v,i)=>walk(v,[...path,i],id));
}
for(const d of expected.defs)d.code=walk(d.code,[],d.id);
assert.deepEqual(counts,{merge:2,'option:unwrap-or':4,'option:unwrap':8,css:1,dispatchContract:3});assert.equal(ops.length,18);
for(const id of ['app.main/main!','app.main/reload!','app.main/dispatch!','app.main/render-app!','app.schema/Store','app.schema/store','app.comp.container/effect-log','app.updater/updater'])assert.deepEqual(expected.defs.find(d=>d.id===id),before.defs.find(d=>d.id===id));
mkdirSync('acceptance',{recursive:true});
for(const [name,value]of Object.entries({before,expected,sites,operations:ops}))writeFileSync('acceptance/'+name+'.json',JSON.stringify(value,null,2));
const args=['edit','transaction','--file','acceptance/operations.json','--format','json'];
const preview=JSON.parse(run(...args,'--dry-run'));assert.ok(preview.scoped_revision);
writeFileSync('acceptance/preview.json',JSON.stringify(preview,null,2));writeFileSync('acceptance/applied.json',run(...args,'--expect-revision',preview.scoped_revision));
const after={config:q('config'),namespaces:q('ns').namespaces.map(n=>q('ns',n)),defs:expected.defs.map(d=>q('def',d.id))};assert.deepEqual(after,expected);
writeFileSync('acceptance/after.json',JSON.stringify(after,null,2));writeFileSync('acceptance/snapshot-after-blob.txt',blob());
writeFileSync('acceptance/summary.json',JSON.stringify({definitions:19,tests:1,examples:0,operations:18,counts,unsafeBefore:0,unsafeAfter:0,preserved:'Allschema/metadata/ns/config/test/example/main/reload/updater/effect/Store andmemo keys/args/state/counter/payloadvaluechecking untouched. 3inputhints nowexactpublishedEventHandlerdispatchFnDynamicUnitrestDynamic,notfakeclosedEnumop. NoHUDexistsoriginally;notadded/replaced. Original7Nodeassertions andqualitybaseline unchanged.'},null,2));
