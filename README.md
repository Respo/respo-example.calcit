
Respo Calcit Example
----

### Usages

To develop:

```bash
caps --strict --ci
yarn install --immutable
calcit calcit.cirru --watch # compile on changes

yarn vite # watching and running on localhost:5173
```

Use Calcit 0.14.16, caps 0.1.0, Node 24 and Yarn 4.12.0.
`calcit.cirru` is the single canonical source snapshot.

Validation:

```bash
calcit calcit.cirru --check-only
calcit calcit.cirru analyze quality --baseline config/calcit-quality.cirru
yarn build
node --test scripts/upgrade.test.mjs
```

The keyed memo demo should reuse all five demo components when only the counter
changes, and recompute only the affected component when its local state changes.
The regression tests enforce this behavior, not only successful compilation.

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

### License

MIT
