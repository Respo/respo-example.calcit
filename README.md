
Respo Calcit Example
----

### 0.32.0 迁移候选：使用者影响

CLI/procs 配对正式 0.32.0，需要重新安装依赖、生成 JS 并完整刷新。
Respo 0.17.0、UI 0.9.0 当前使用本地候选，JS-FFI 为 0.2.8；
正式标签整图尚待验收，不能用本地候选结果替代严格 Caps 安装。

官方转换 4 处类型写法，17 个定义 schema 保持。输入、计数器、五个独立 keyed
memo 实例、effect、开放事件入口与原 Enum 守卫不变。不放宽质量基线、添加
脚本或测试框架；npm 发布年龄门禁为一小时。本轮完整 strict、全部定义、原质量
基线、七项 Node 和一项附着测试、构建及 immutable 安装通过。实际五个 keyed
实例独立输入、主输入/Run 和计数器通过，浏览器无警告或错误，独立评审无问题。
正式依赖整图和远端 CI 尚待验收。下方 0.31 配对说明为历史记录。

### 使用者影响：正式 Calcit 0.31.0 配对

CLI/procs 配对正式 **0.31.0**，模块使用已发布 Respo 0.17.0-alpha.4、UI 0.9.0-alpha.4、JS-FFI 0.2.7，传递 Router 0.9.0-alpha.3。
UI 依赖仍在 alpha 线，请重新安装完整依赖图、生成 JS 并刷新，不与旧 0.30.x 缓存混用；Vite 仍精确固定 8.3.3。
本轮更新依赖，并将默认入口的 dispatch-op 显式绑定为原有 Dynamic 合同。dispatcher/updater 原本接受开放输入，继续由 updater 的 enum? 守卫筛选；不改函数 schema 或业务代码。输入与计数行为、五个独立 keyed memo 实例、effect 和页面布局均保留。
原完整 strict、质量预算、七项 Node 测试和一项附着测试保持不变，不增加验证脚本或框架。
当前 reload! 没有 HUD 导入，本轮不凭空添加；不合并或部署生产，不发布 tag/npm，原 COS/CDN 和服务器路径保持不变。

### 开发

当前使用配对的正式Calcit/procs0.31.0、caps0.1.1、Node24和Yarn4.18.0。
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
包含真实 `event->edn` Map 经输入回调和 updater 的测试，避免用 Struct 事件夹具掩盖 DOM 错误。
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
模块固定已发布 tag，工具链使用正式 0.31.0，不使用 hash/main 模块引用。
原质量基线保持：schemaDynamic 4、unresolved 9，unsafe/deprecated 为 0，不放宽任何定义。
原有五处排版占位 nil 与真实异构状态边界保留，不把它们伪装成具体类型。
本 PR 不授权合并或生产部署。

`yarn dev` 先编译一次再启动Vite，实时源码编译仍另开原watch命令，不引入concurrently。

### 历史：0.30.1 源码迁移验收

当时使用临时官方 Linux CI 生成 Snapshot；下述记录属于旧迁移，不代替当前 0.31.0 验收。
官方Linux 0.30.1事务CI已通过改写前后原附着测试1项、Node回归7项、all-defs167项，
改写后完整strict通过，原质量预算零增量；仍有4处真实开放类型边界，不声称Dynamic清零。
同一CI静态产物在全新localhost实际验收计数0→1→2、顶部/A/A2/插件输入、Run输出、
五实例memo隔离，以及effect mount/before-update/update日志；计数变化不重算五个memo，
A/A2输入只重算对应实例。刷新回计数0和空输入，控制台无warning/error。
未测试HMR、所有effect卸载路径或移动端，不凭版本声明或类型计数声称全部行为已验证。

### 许可证

MIT
