
Respo Calcit Example
----

### 使用者影响：正式 Calcit 0.30.1 配对

CLI/procs保持配对正式 **0.30.1**，模块同步正式Respo0.16.126、UI0.8.1、JS-FFI0.2.6，
传递Router0.8.38。请重新安装完整依赖图、生成JS并刷新，不混用旧alpha缓存；Vite精确固定8.3.3。
本轮迁移14处旧Option/Map调用，一处padding改为等价8px String；三个输入回调的dispatch参数
从Dynamic收紧为Respo实际提供的 `Fn<Dynamic, Unit, rest Dynamic>`，不伪造封闭操作合同。
输入与计数行为、五个独立keyed memo实例、effect和页面布局不变，不新增存储或功能。
当前reload!没有HUD导入，本轮不凭空添加，也不把其他项目真实hud!改为raise。
CI保留all-defs、完整strict、原质量/业务门禁，全部预算和原断言不变，不增加验证脚本或框架。
不合并或部署生产、不发布tag/npm，原COS/CDN和服务器路径保持不变。

### 开发

当前使用配对的正式Calcit/procs0.30.1、caps0.1.1、Node24和Yarn4.18.0。
正式CLI/运行验收以当前源码和精确提交为准，旧alpha或旧绿色检查不代替本轮迁移验证。
`calcit.cirru` 是唯一的程序 Snapshot。安装与启动：

```bash
caps --strict --ci
yarn install --immutable
calcit calcit.cirru --watch # compile on changes

yarn vite # serve at localhost:5173
```

模块使用本文开头的完整正式版本图。
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
模块与工具链均固定正式版本，不新增alpha/hash引用。
原质量基线保持：schemaDynamic 4、unresolved 9，unsafe/deprecated 为 0，不放宽任何定义。
原有五处排版占位 nil 与真实异构状态边界保留，不把它们伪装成具体类型。
本 PR 不授权合并或生产部署。

`yarn dev` 先编译一次再启动Vite，实时源码编译仍另开原watch命令，不引入concurrently。
临时迁移事务只在官方Linux 0.30.1 CI生成Snapshot，本地仅只读query并核验成功产物，
不运行本地Caps或编译器检查/build/codegen/mutation。实际页面与原memo/effect测试需分别验收，
不凭版本声明或类型计数声称全部行为已验证。

### 许可证

MIT
