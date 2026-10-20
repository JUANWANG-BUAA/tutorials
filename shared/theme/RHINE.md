# 莱茵档案 · Rhine Archive

可选 `rhine` 皮肤；默认 `classic`。完整设计与研究：[整体重设计](../../docs/rhine-redesign.md)。

本轮主要参考官方 [Rhine Lab: Access](https://www.youtube.com/watch?v=-_HeLFGCw7M) 的暖灰白空间、档案阵列、黑字细线与杏金选中光。此前参考 ak.hypergryph.com / endfield.hypergryph.com 的黑青终端方案已由本设计替换。RhineLabUI 等同人项目不作为官方视觉来源。

## 页面与资源

- `css/rhine-portal.css`：门户整体构图、课程记录、图版、学习路线、响应式与夜间版。
- `css/rhine.css`：共享阅读令牌、浅色工具栏、章节、语义盒和表格；仅 screen + `[data-skin="rhine"]` 生效。
- `js/rhine-portal.js`：从经典 `.index-row` / `.path-card` 读取真实课程与路线；支持鼠标、键盘与主题往返。
- `js/prefs-config.js`：门户和阅读页共用偏好 schema；`prefs.css` 最后加载，读者偏好保持优先。
- `tools/theme-renderer/scene.js`：原创程序化横向磨砂档案阵列，中央八件映射课程；选中件原槽抬升，快速切换从当前位置接续。
- `js/rhine-scene.js`：Three.js 打包产物，不直接手改。许可在 `vendor/three-LICENSE.txt`。
- `tools/theme-renderer/build_art.py` → `assets/rhine-*.svg`：暖纸目录封面，也是 WebGL 不可用时的替代内容。

渲染只在需要动画或状态变化时运行；离开首屏/隐藏标签页暂停。`prefers-reduced-motion` 禁用入场与插值。所有课程入口都有 DOM 链接，不依赖 WebGL。

## 重建与验证

```sh
pnpm --dir tools/theme-renderer build
python3 tools/theme-renderer/build_art.py
./build.sh
node --test tools/test_theme_config.mjs
```

2026-10-20 本轮：八本完整构建通过，11 项配置/资源检查通过。Chromium 实拍桌面浅/深色、390px；门户 320/390/768/1440px 无整页溢出；八本首页和矩阵论对角化、数值分析第 10 讲、机器人位姿手机页无整页溢出。键盘选档、减少动态效果、经典往返通过；阅读页往返后正文 DOM 相同。浏览器未捕获 pageerror。

视觉闭环：基线 → 第一轮整体重构 → 降低曝光/软化阴影/提高选中档案 → 纸面标签与环组深度修正。记录与本地截图路径见设计文档。未以 Chromium 结果代替 Safari/iPhone 实机性能数据。
