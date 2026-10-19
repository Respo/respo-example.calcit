import assert from 'node:assert/strict';
import test from 'node:test';
import * as c from '../js-out/calcit.core.mjs';
import { updater } from '../js-out/app.updater.mjs';
import { store } from '../js-out/app.schema.mjs';
import { Effect } from '../js-out/respo.schema.mjs';
import { comp_container } from '../js-out/app.comp.container.mjs';
import { effect_log, use_log } from '../js-out/app.comp.container.mjs';
import { event__GT_edn } from '../js-out/respo.util.format.mjs';
import { mount_target } from '../js-out/app.main.mjs';
import { clear_cache_$x_ } from '../js-out/respo.core.mjs';
import { begin_memo_frame_$x_, finish_memo_frame_$x_, abort_memo_frame_$x_ } from '../js-out/respo.memo.mjs';

const tags = c.init_tags(['counter', 'states', 'a', 'data', 'draft']);
const read = (value, key) => c.option_$o_unwrap(c.get(value, key));
const apply = (value, source) => updater(value, c.parse_cirru_edn(source));

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
  const updated = apply(store, ':: :inc nil');
  assert.equal(read(updated, tags.counter), 1);
  assert.equal(read(store, tags.counter), 0);
  assert.equal(read(updated, tags.states), read(store, tags.states));
});

test('cursor dispatch updates the intended local state and preserves counter', () => {
  const updated = apply(store, ':: :states ([] :a) $ {} (:draft |hello)');
  const state = read(read(read(updated, tags.states), tags.a), tags.data);
  assert.equal(read(state, tags.draft), 'hello');
  assert.equal(read(updated, tags.counter), 0);
});

test('input handler accepts the real Respo event Map and updates local state', () => {
  const t = c.init_tags(['cursor', 'ui', 'children', 'node', 'event', 'input']);
  const plugin = use_log(c._$n__$M_(t.cursor, c._$L_()), 'demo');
  const inputPair = c.option_$o_unwrap(c.nth(read(read(plugin, t.ui), t.children), 1));
  const inputNode = c.option_$o_unwrap(read(inputPair, t.node));
  const input = c._$n_enum_$o_nth(inputNode, 1);
  const handler = read(read(input, t.event), t.input);
  const event = event__GT_edn({ type: 'input', target: { value: '真实 Map 🐈', checked: false } });
  assert.equal(c.map_$q_(event), true);
  let dispatched;
  handler(event, op => { dispatched = op; });
  const updated = updater(store, dispatched);
  assert.equal(read(read(read(updated, tags.states), tags.data), tags.draft), '真实 Map 🐈');
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
    renderInFrame(apply(store, ':: :inc nil'));
    assert.equal(logs.filter(line => line.startsWith('Called:')).length, 0);
    renderInFrame(apply(store, ':: :states ([] :a) $ {} (:draft |changed)'));
    assert.deepEqual(logs.filter(line => line.startsWith('Called:')), ['Called: A']);
  } finally {
    console.log = original;
    clear_cache_$x_();
  }
});

test('unknown operations preserve the store', () => {
  assert.equal(apply(store, ':: :unknown'), store);
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
  const tags = c.init_tags(['args', 'method', 'mount']);
  const effect = effect_log('demo');
  const logs = [];
  const original = console.log;
  console.log = (message) => logs.push(message);
  try {
    effect.nthAt(Effect.fields.indexOf(tags.method), tags.method)(
      effect.nthAt(Effect.fields.indexOf(tags.args), tags.args),
      c._$L_(tags.mount, null, false),
    );
  } finally {
    console.log = original;
  }
  assert.deepEqual(logs, ['Effect happen: demo :mount']);
});
