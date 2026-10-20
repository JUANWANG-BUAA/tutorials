# 全局交互与渲染审计 · 2026-10-20

范围：shared/theme 的脚本、CSS 配置边界与 Three.js 生命周期。未修改课程正文或主题文案。

## 修复

- 主题弹层观察 style 又重写 style：定位只在值变化时写入，避免自触发的冗余更新。
- 图片进场能力检测的 `!` / `in` 优先级错误：不支持 IntersectionObserver 时安全跳过，不留下隐藏图片状态。
- 图鉴跳转保留插图原有 tabindex；减少动态效果下不强制平滑滚动。
- 灯箱和图鉴 Escape 不再冒泡到页面快捷键；图内子控件的 Enter 不再误触发放大。
- 深链搜索重试在用户输入、离开页面和超时后清理，避免旧查询覆盖新输入。
- 莱茵皮肤默认令牌降低选择器优先级，自选深色配色可覆盖；语义盒、证明、折叠答案与标题使用阅读密度令牌。
- 阅读设置变化不再无条件删除并重建档案页头。
- 删除门户失去视觉作用的指针 RAF 与进场观察器；非模态载入提示不再全局截获 Enter/Escape。
- 三维拾取考虑前方装饰档案遮挡，避免穿透点击。上下文丢失时恢复封面，恢复后重绘；销毁释放阴影资源和 WebGL 上下文。

## 验证

- `node --test tools/test_runtime.mjs tools/test_theme_config.mjs`：14 项通过。
- `./build.sh`：八本全量构建通过。
- Chromium：主题弹层 mutation 数停止增长；深色海蓝在莱茵与经典下 accent 均为 #91bee7；偏好变化保留同一档案页头节点。
- 390×600 偏好面板：top=60、bottom=586，位于视口内。
- 连续八次经典/莱茵切换后只有一个门户和一个画布；模拟 contextlost 后封面可见，恢复后场景 ready。
- 图鉴跳转后 tabindex=0；Enter 打开灯箱、Escape 关闭。截图检查灯箱完整可见。
- 本地证据：`.qa/runtime-audit.log`、`output/playwright/runtime-lightbox.png`。

边界：上下文恢复用浏览器事件模拟，未替代真实 GPU 故障；未完成 Safari/iPhone 实机验证。本审计记录已确认的修复，不表示所有页面组合均无缺陷。
