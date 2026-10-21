# 交互与 GitHub Pages 加载优化（2026-10-21）

本轮修改共用浏览器代码、构建后处理与少量重复锚点，不重写教程正文。原有的课程内容与编译教程更新一并保留，下文记录本地验收结果；发布状态以 GitHub Pages 部署工作流为准。

## 对标依据

- [VitePress](https://vitepress.dev/guide/what-is-vitepress)：静态首屏、跨页面资源复用；[本地搜索](https://vitepress.dev/reference/default-theme-search)强调本地索引和多语言。保留现有 mdBook 静态架构，实现共享指纹资源、按需搜索与失败重试。
- [Hello Algo 阅读建议](https://www.hello-algo.com/chapter_preface/suggestions/)：图示与代码辅助理解。宽图可平移，键盘可操作，答题解析由读者明确选择后再推进。
- [mdBook 高亮定制](https://rust-lang.github.io/mdBook/format/theme/syntax-highlighting.html)：通过原生 theme/highlight.js 接口注册离线高亮，不在正文加载后补救或访问第三方 CDN。
- [ARIA dialog](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles/dialog_role)：灯箱打开后定位关闭控件，退出回到原图；术语定义链接可以直接通过键盘进入。

## 已修复的交互问题

- 输入法候选阶段不触发搜索；Ctrl/Cmd+K 聚焦搜索；下载失败给出重试；取消空结果深链后不再把旧查询写回地址栏。
- 按钮、折叠标题、可编辑区、画布和对话框里的键盘操作不再误触全局翻章；答题 Enter 不会同一次事件又选答案又跳题。
- 宽 SVG 有实际滚动容器；平移不误开灯箱；延迟加载与折叠中的图片展开后可增强。图鉴和灯箱克隆重映射 SVG 渐变、marker、图注等 ID，避免重复 ID 与错引用。
- 偏好面板移出被移动端侧栏 transform 位移的容器，固定定位并夹紧到视口内；在 390×600 和莱茵皮肤下可完整滚动操作。
- 数值竞技场与模拟考试按真实截止时间计时，后台节流后恢复不会少计；退出清理轮次与计时器；取消 900ms 自动推进，保留解析。错题本使用题库权威数据和文本节点。
- 打印展开解答不改写用户保存的折叠状态；阅读进度可恢复到最近的小节，过滤失效路径与打印页。
- Linux 代码块只保留一份复制按钮；备用复制通道恢复焦点与选区，并报告实际失败。
- 矩阵画布修正 CSS 缩放后的指针坐标，忽略右键和非主指针，丢失指针捕获时结束拖动。
- 补齐 distributed、compilers 缺失的 KaTeX 字体链接；修复两处重复正文锚点与一处 SVG 图注转义。
- 新离线 Highlight.js 11.12.0 覆盖汇编、C/C++、Python、Rust、LLVM 等。PromQL、sudoers、Rego 等未提供对应语法的领域格式显式使用纯文本，不错误猜测语言。高亮包约 108 KB，比原默认包减少约 21%。
- mdBook 原生 TOC 的 sessionStorage 操作与删除主题偏好的操作增加异常保护；禁止浏览器存储时目录、主题与阅读增强仍可用。

## 加载和缓存机制

线上只读检查返回 `Cache-Control: max-age=600`。GitHub Pages 的缓存响应头由托管平台管理，参见 [GitHub 社区说明](https://github.com/orgs/community/discussions/60087)。没有添加无效的 HTML cache-control 元标签或平台不支持的自定义响应头文件。

`tools/optimize_assets.py` 在所有索引、术语、图片处理完成后运行，将八本书相同的 JS、CSS、字体合并到 `shared/cache/`。文件名含最终内容的 SHA-256 前 16 位；CSS 字体依赖、搜索索引入口、动态场景入口、术语 JSON 入口和深层 HTML 引用一起改写，支持站点根目录与 `/tutorials/` 项目路径。搜索索引不再沿用 mdBook 在中文重建前生成的旧指纹。预绘制偏好脚本保留在 head，删除底部重复加载。

小型 Service Worker 只处理当前项目范围内带内容指纹的资源：缓存优先、按需写入，上限 64 MiB / 180 条；资源内容更新生成新 URL，重新获取。404、重定向、HTML 响应、其他域名和项目不进入缓存；超限和旧版本资源会淘汰。HTML 使用浏览器正常的网络/HTTP 缓存，更新仍受 GitHub 自身的 10 分钟缓存窗口影响。浏览器拒绝存储或不支持 Service Worker 时继续正常联网阅读。

不预下载整本书，也不承诺离线阅读正文。首次访问使用 HTTP 缓存；后台注册完成后，后续请求可进入资源缓存。读过的资源可以离线复用，但完整离线页面不是本轮目标。网络慢时首次中文搜索仍需下载该书索引，现已提供加载状态与重试。

索引使用无损紧凑传输格式：合并重复浮点权重、压平文档引用、去掉可推导计数和空映射；下载后恢复完全相同的 elasticlunr 索引结构。没有裁剪正文索引或摘要。修复构建探针配置误读，原有中文检索探针真正执行。

## 本地结果

基线是本轮交互修复完成、尚未加入资源缓存优化的构建；单位 MB 为十进制，gzip 是同机计算估算，不是线上传输实测。

| 指标 | 优化前 | 优化后 |
| --- | ---: | ---: |
| 整站生成文件 | 447.33 MB | 370.64 MB（减少约 17%） |
| 八本搜索索引合计 | 127.87 MB | 59.87 MB（减少 53.2%） |
| 索引 gzip 估算合计 | 21.97 MB | 18.45 MB（减少 16.0%） |
| Linux 搜索索引 | 45.82 MB | 20.92 MB |
| 部署时可合并的资源文件数 | 555 | 120 |
| 上述资源实际总量（含索引） | 72.65 MB | 62.95 MB |
| 预热后的复访指纹资源网络请求 | — | 0（本地 Chromium） |

体积减少不等于公网延迟按相同比例减少；本地资源缓存无法消除 GitHub 首次连接和跨境网络的耗时。实际线上首屏和国内网络表现需要部署后再测。

## 验证和复现

- `./build.sh`：八本完整构建；本地与 GitHub Actions 均调用图片优化、共享资源构建与资源检查。
- `node --test tools/test_runtime.mjs tools/test_theme_config.mjs tools/test_highlighter.mjs tools/test_search_codec.mjs tools/test_asset_cache.mjs`：30 项通过。
- `python3 tools/test_optimize_assets.py`：构建依赖、共享 URL、最终内容指纹、搜索回退入口、存储降级测试通过。
- `python3 tools/audit_site_assets.py _site`：632 个 HTML 页面，运行资源/CSS 字体依赖无缺失；非打印/目录页无重复 ID。该检查不等于全部正文超链接检查。
- Playwright CLI 运行 `tools/browser-interactions.js`：47 项通过，包含八本中文索引的真实查询、搜索失败重试、移动图示、计时器、打印、术语与阅读恢复。
- `tools/browser-reader-variants.js`：15 项通过，包含五主题、隐藏图示、画布键盘/右键、莱茵移动面板、减少动效、存储拒绝。
- `tools/browser-cache.js`：9 项通过，在 `/tutorials/` 路径验证 worker 作用域、跨书 URL、断网资源命中、正文不持久缓存、按需中文检索；预热后指纹资源零网络请求。版本切换、错误响应、缓存容量和项目隔离另有单元测试。
- `git diff --check` 通过。浏览器回归使用 Chromium；未完成 Safari/iPhone 实机验证。浏览器脚本不要求生产站点增加 Playwright 依赖。

本地证据位于忽略目录 `.qa/ux-*.log`、`.qa/asset-metrics.json` 与 `output/playwright/ux-*.png`。
