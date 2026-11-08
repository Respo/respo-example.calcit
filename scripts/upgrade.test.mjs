import assert from 'node:assert/strict';
import test from 'node:test';
import * as c from '../js-out/calcit.core.mjs';
import { updater } from '../js-out/app.updater.mjs';
import { DispatchOp, store } from '../js-out/app.schema.mjs';
import { Effect, EffectParams } from '../js-out/respo.schema.mjs';
import { comp_container } from '../js-out/app.comp.container.mjs';
import { effect_log, use_log } from '../js-out/app.comp.container.mjs';
import { child_pair_value, component_tree, element_children, element_event, element_name, element_$q_ } from '../js-out/respo.util.detect.mjs';
import { make_string } from '../js-out/respo.render.html.mjs';
import { event__GT_edn } from '../js-out/respo.util.format.mjs';
import { mount_target } from '../js-out/app.main.mjs';
import { clear_cache_$x_ } from '../js-out/respo.core.mjs';
import { begin_memo_frame_$x_, finish_memo_frame_$x_, abort_memo_frame_$x_ } from '../js-out/respo.memo.mjs';

const tags = c.init_tags(['counter', 'inc', 'states', 'a', 'data', 'draft']);
const read = (value, key) => c.option_$o_unwrap(c.get(value, key));
const increment = () => c._PCT__$o__$o_(DispatchOp, tags.inc);
const editDraft = (draft) => c._PCT__$o__$o_(DispatchOp, tags.states, c._$L_(tags.a), c._$n__$M_(tags.draft, draft));

// Match render-with!: tree construction runs inside a managed memo frame.
function renderInFrame(value) {
  begin_memo_frame_$x_();
  try {
    const tree = comp_container(value);
    finish_memo_frame_$x_();
    return tree;
  } catch (error) {
    abort_memo_frame_$x_();
    throw error;
  }
}

test('enum counter dispatch increments without mutating the original store', () => {
  const t = c.init_tags(['button', 'click']);
  const root = c.option_$o_unwrap(component_tree(renderInFrame(store)));
  const toolbar = child_pair_value(c.option_$o_unwrap(c.nth(element_children(root), 0)));
  const button = element_children(toolbar).toArray().map(pair => child_pair_value(pair))
    .find(node => element_$q_(node) && element_name(node) === t.button && make_string(node).includes('Inc counter'));
  let operation;
  read(element_event(button), t.click)(event__GT_edn({ type: 'click' }), value => { operation = value; });
  assert.equal(c.option_$o_unwrap(c.enum_definition(operation)), DispatchOp);
  const updated = updater(store, operation);
  assert.equal(read(updated, tags.counter), 1);
  assert.equal(read(store, tags.counter), 0);
  assert.equal(read(updated, tags.states), read(store, tags.states));
});

test('cursor dispatch updates the intended local state and preserves counter', () => {
  const updated = updater(store, editDraft('hello'));
  const state = read(read(read(updated, tags.states), tags.a), tags.data);
  assert.equal(read(state, tags.draft), 'hello');
  assert.equal(read(updated, tags.counter), 0);
});

test('input handler accepts the real RespoEvent and updates local state', () => {
  const t = c.init_tags(['cursor', 'ui', 'children', 'node', 'event', 'input']);
  const plugin = use_log(c._$n__$M_(t.cursor, c._$L_()), 'demo');
  const inputPair = c.option_$o_unwrap(c.nth(read(read(plugin, t.ui), t.children), 1));
  const inputNode = c.option_$o_unwrap(read(inputPair, t.node));
  const input = c._$n_enum_$o_nth(inputNode, 1);
  const handler = read(read(input, t.event), t.input);
  const event = event__GT_edn({ type: 'input', target: { value: '真实事件 🐈', checked: false } });
  assert.equal(c.struct_$q_(event), true);
  let dispatched;
  handler(event, op => { dispatched = op; });
  const updated = updater(store, dispatched);
  assert.equal(read(read(read(updated, tags.states), tags.data), tags.draft), '真实事件 🐈');
  assert.equal(read(updated, tags.counter), 0);
});

test('memo keys keep five demos distinct and reuse unchanged demos', () => {
  clear_cache_$x_();
  const logs = [];
  const original = console.log;
  console.log = (...args) => logs.push(args.join(' '));
  try {
    renderInFrame(store);
    assert.equal(logs.filter(line => line.startsWith('Called:')).length, 5);
    logs.length = 0;
    renderInFrame(updater(store, increment()));
    assert.equal(logs.filter(line => line.startsWith('Called:')).length, 0);
    renderInFrame(updater(store, editDraft('changed')));
    assert.deepEqual(logs.filter(line => line.startsWith('Called:')), ['Called: A']);
  } finally {
    console.log = original;
    clear_cache_$x_();
  }
});

test('the named dispatch enum rejects unknown operations and malformed state payloads', () => {
  assert.throws(() => c._PCT__$o__$o_(DispatchOp, c.init_tags(['unknown']).unknown), /unknown/);
  const data = c._$n__$M_(tags.draft, 'valid');
  assert.throws(() => c._PCT__$o__$o_(DispatchOp, tags.states, 'not a cursor', data), /states/);
  assert.throws(() => c._PCT__$o__$o_(DispatchOp, tags.states, c._$L_(tags.a), 'not a map'), /states/);
});

test('typed js-ffi mount lookup returns the host element and reports a missing mount', () => {
  const previous = Object.getOwnPropertyDescriptor(globalThis, 'document');
  const host = {};
  try {
    globalThis.document = {
      querySelector(selector) {
        assert.equal(selector, '.app');
        return host;
      },
    };
    assert.equal(mount_target(), host);
    globalThis.document.querySelector = () => null;
    assert.throws(() => mount_target(), /Missing \.app mount target/);
  } finally {
    if (previous) Object.defineProperty(globalThis, 'document', previous);
    else Reflect.deleteProperty(globalThis, 'document');
  }
});

test('effect logging crosses the typed console boundary', () => {
  const tags = c.init_tags(['args', 'method', 'mount', 'action', 'target', 'at-place?']);
  const effect = effect_log('demo');
  const logs = [];
  const original = console.log;
  console.log = (message) => logs.push(message);
  try {
    effect.nthAt(Effect.fields.indexOf(tags.method), tags.method)(
      effect.nthAt(Effect.fields.indexOf(tags.args), tags.args),
      c._$n__PCT__$M_(EffectParams, tags.action, tags.mount, tags.target, {}, tags['at-place?'], false),
    );
  } finally {
    console.log = original;
  }
  assert.deepEqual(logs, ['Effect happen: demo :mount']);
});
