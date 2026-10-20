# theme-renderer

莱茵档案三维阵列与原创课程封面源。设计见 `../../docs/rhine-redesign.md`。

- `scene.js`：三个横向磨砂档案列，中央八件对应课程；选中档案抬升，快速换选连续收敛。DOM 负责课程信息与导航。
- `build_art.py`：生成八张暖纸 SVG 目录封面。
- `package.json`：固定 Three.js 与 esbuild；运行时不请求外部模型、纹理或字体。

```sh
pnpm --dir tools/theme-renderer install
pnpm --dir tools/theme-renderer build
python3 tools/theme-renderer/build_art.py
```

提交 `shared/theme/js/rhine-scene.js` 与 `shared/theme/assets/rhine-*.svg` 构建产物。不要直接改 bundle。

场景使用不超过 1.75 DPR，离屏/隐藏时暂停，静止后停止连续绘制。减少动态效果只绘制必要帧；WebGL 失败由门户提供封面回退。dispose 释放监听器、纹理、几何体、材质与渲染器。

Three.js 采用 MIT，许可见 `shared/theme/vendor/three-LICENSE.txt`。原始 PV 仅作设计研究，不随站点分发。
