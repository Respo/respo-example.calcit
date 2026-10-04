
Respo Calcit Example
----

### 开发

依赖 Calcit / procs 0.27.0、caps 0.1.1、Node 24 和 Yarn 4.18.0。
`calcit.cirru` 是唯一的程序 Snapshot。安装与启动：

```bash
caps --ci
yarn install --immutable
calcit calcit.cirru --watch # compile on changes

yarn vite # serve at localhost:5173
```

示例直接依赖 js-ffi 0.2.1-alpha.10。现有传递清单存在版本冲突，
与 CI 一样使用普通 Caps 解析，尚不宣称 `caps --strict --ci` 通过。
挂载节点由类型化的
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

### COS / CDN 部署

COS Action 固定到正式 1.2.0 的发布提交，配置 `public-base-url` 使用内置
逐文件公网 checksum verify，沿用默认 `verify-*` 参数，不新增验证脚本。
PR 前缀按 `Respo/respo-example.calcit/pr/<PR>/<run-id>/<attempt>/` 隔离；
每个 PR 独立排队，与生产队列分开，不取消正在上传的任务。
生产 COS 前缀与原服务器 `dist/*` 部署路径不变，Fork PR 仅构建，
不使用部署 secrets。现有类型、质量与业务测试门禁保留，未新增 alpha/hash 依赖。
本次只交付 COS/CDN 配置，完整 Calcit 0.28 类型迁移仍需另行完成。

### 许可证

MIT
