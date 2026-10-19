
Respo Calcit Example
----

### 开发

当前验收使用配对的 Calcit / procs 0.30.1-alpha.5、caps 0.1.1、Node 24 和 Yarn 4.18.0。
这是候选工具链验收，不代表已通过正式 0.30.1 二进制验收。
`calcit.cirru` 是唯一的程序 Snapshot。安装与启动：

```bash
caps --strict --ci
yarn install --immutable
calcit calcit.cirru --watch # compile on changes

yarn vite # serve at localhost:5173
```

模块使用正式版本 Respo 0.16.122、Respo UI 0.7.41 和 js-ffi 0.2.3。
CI 独立执行 strict Caps 解析。本次本地验收未运行 Caps；
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
渲染使用 `render-with!` 管理 memo frame。回归测试保留原有六项断言，
补充真实 `event->edn` Map 经输入回调和 updater 的测试，避免用 Struct 事件夹具掩盖 DOM 错误。
事件读取遵守 Map 合同；缓存中的插件通过实际 Struct 检查后读取，不以强转伪造类型。

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

### COS / CDN 部署

COS Action 固定到正式 1.2.0 的发布提交，配置 `public-base-url` 使用内置
逐文件公网 checksum verify，沿用默认 `verify-*` 参数，不新增验证脚本。
PR 前缀按 `Respo/respo-example.calcit/pr/<PR>/<run-id>/<attempt>/` 隔离；
每个 PR 独立排队，与生产队列分开，不取消正在上传的任务。
生产 COS 前缀与原服务器 `dist/*` 部署路径不变，Fork PR 仅构建，
不使用部署 secrets。现有类型、质量与业务测试门禁保留；
模块依赖没有新增 alpha/hash 版本，工具链候选例外如上。
质量基线仅收紧 schemaDynamic 5→4、unresolved 10→9，unsafe/deprecated 仍为 0。
原有五处排版占位 nil 与真实异构状态边界保留，不把它们伪装成具体类型。
本 PR 不授权合并或生产部署。

### 许可证

MIT
