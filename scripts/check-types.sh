#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

calcit analyze weak-types --only coverage --coverage-level none,partial --summary-only --format json |
  jq -e '.data.summary.definitions == 0'
calcit analyze weak-types \
  --only schema-dynamic,unresolved-type-slot,code-dynamic,code-nil,unsafe-coerce,data-dynamic \
  --summary-only --format json | jq -e '.data.summary.hits == 0'
calcit analyze weak-types --only deprecated-call --summary-only --format json |
  jq -e '.data.summary.calls == 0'
calcit analyze weak-types --only dynamic-method --summary-only --format json |
  jq -e '.data.summary.findings == 0'
