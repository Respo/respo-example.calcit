
Respo Calcit Example
----

### 使用者影响

CLI 与 `@calcit/procs` 配对正式 **0.40.0**。升级后重新安装依赖并构建前端。模块使用已发布的 Respo **0.19.5**、UI **0.15.2** 和 JS FFI **0.2.13**，传递依赖 Router 为 **0.12.2**。

输入、计数器、五个独立 memo 实例及 effect 保持原用法。输入事件按 `RespoEvent` 读取，状态路径使用 `CoordKey`，dispatch 使用具名 `DispatchOp`。 状态树使用递归 `StateValue` union，允许文本、游标和子分支，并保留数字与文本键的身份。原完整 strict、质量基线、定义测试与七项 Node 测试继续运行。

### 开发

当前使用配对的正式Calcit/procs0.40.0、caps0.1.1、Node24和Yarn4.18.0。
正式CLI/运行验收以当前源码和精确提交为准，旧alpha或旧绿色检查不代替本轮迁移验证。
`calcit.cirru` 是唯一的程序 Snapshot。安装与启动：

```bash
caps --strict --ci
yarn install --immutable
calcit calcit.cirru --watch # compile on changes

yarn vite # serve at localhost:5173
```

模块使用本文开头的完整已发布版本图。
本地与 CI 均执行 strict Caps 解析；
本地开发仍须执行上述安装步骤，生成所需的模块链接。
挂载节点由类型化的
`js-ffi.browser/query-selector` 查询，缺失时明确报错；effect 日志使用
`js-ffi.browser/console-log!`，不直接访问 `js/document` 或 `js/console`。

验证：

```bash
calcit calcit.cirru --check-only --all-defs
calcit calcit.cirru fix --workflow strict --verify --format edn
calcit calcit.cirru test --require-match --summary-only --format json
calcit calcit.cirru analyze quality --baseline config/calcit-quality.cirru
yarn build
node --test scripts/upgrade.test.mjs
```

keyed memo 示例在计数器变化时复用五个组件，只在局部状态变化时重新计算对应组件。
渲染使用 `render-with!` 管理 memo frame。原七项Node测试及一项附着测试均保持，
包含通过 Respo `event->edn` 生成实际 `RespoEvent` 并调用输入回调和 updater 的测试。缓存中的插件经过 Struct 检查后读取。

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

### COS / CDN 部署

COS Action 使用与原SHA对应的精确正式tag v1.2.0，接受tag可移动风险，配置 `public-base-url` 使用内置
逐文件公网 checksum verify，沿用默认 `verify-*` 参数，不新增验证脚本。
PR 前缀按 `Respo/respo-example.calcit/pr/<PR>/<run-id>/<attempt>/` 隔离；
每个 PR 独立排队，与生产队列分开，不取消正在上传的任务。
生产 COS 前缀与原服务器 `dist/*` 部署路径不变，Fork PR 仅构建，
不使用部署 secrets。现有类型、质量与业务测试门禁保留；
模块固定已发布 tag，工具链使用正式 0.32.1，不使用 hash/main 模块引用。
原质量基线保持：schemaDynamic 4、unresolved 9，unsafe/deprecated 为 0，不放宽任何定义。
原有五处排版占位 nil 与真实异构状态边界保留，不把它们伪装成具体类型。
本 PR 不授权合并或生产部署。

`yarn dev` 先编译一次再启动Vite，实时源码编译仍另开原watch命令，不引入concurrently。

原排版占位nil与异构状态保留，不伪装为具体类型。既往实际页面验收不代表HMR、
全部effect卸载路径或移动端已验证；本次以精确PR提交的CI和原测试结果为准。

### 许可证

MIT
