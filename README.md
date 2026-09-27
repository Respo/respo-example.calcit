
Respo Calcit Example
----

### 开发

依赖 Calcit 0.24.3、caps 0.1.1、Node 24 和 Yarn 4.18.0。
`calcit.cirru` 是唯一的程序 Snapshot。安装与启动：

```bash
caps --strict --ci
yarn install --immutable
calcit calcit.cirru --watch # compile on changes

yarn vite # serve at localhost:5173
```

示例直接依赖 js-ffi 0.2.1-alpha.3。挂载节点由类型化的
`js-ffi.browser/query-selector` 查询，缺失时明确报错；effect 日志使用
`js-ffi.browser/console-log!`，不直接访问 `js/document` 或 `js/console`。

验证：

```bash
calcit calcit.cirru --check-only
calcit calcit.cirru test --require-match --summary-only --format json
calcit calcit.cirru analyze quality --baseline config/calcit-quality.cirru
yarn build
node --test scripts/upgrade.test.mjs
```

keyed memo 示例在计数器变化时复用五个组件，只在局部状态变化时重新计算对应组件。
回归测试覆盖这一行为，也覆盖挂载节点缺失和类型化 console 路径，而不只检查编译成功。

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

### 许可证

MIT
