#!/usr/bin/env bash
# 本地一键构建：与 .github/workflows/deploy.yml 的步骤一一对应。
#
# 为什么需要它：mdbook build 会清空 book/ 目录，而中文搜索索引与术语数据都是
# **构建后产物**；只跑 mdbook build 会得到一个没有索引、没有术语气泡的站点
# （前端会静默降级，但页面上会多出 404）。mdbook serve 同样不含这两步。
#
#   ./build.sh            构建六本 → _site/（与线上一致的目录结构）
#   ./build.sh serve      构建后用 python 起静态服务器（默认 8000 端口）
set -euo pipefail
cd "$(dirname "$0")"

books=(robot numerical matrix deeplearning linux agent-systems)
for book in "${books[@]}"; do
  mdbook build "$book" >/dev/null
  node tools/build_search_js.mjs "$book" | tail -1
  python3 tools/build_glossary.py "$book" | tail -1
done

rm -rf _site && mkdir -p _site
cp site-index.html _site/index.html
for book in "${books[@]}"; do cp -R "$book/book" "_site/$book"; done
python3 tools/optimize_site.py _site
echo "构建完成：_site/（六本 + 导览页）"

if [ "${1:-}" = "serve" ]; then
  echo "本地预览：http://127.0.0.1:8000/"
  cd _site && exec python3 -m http.server 8000 --bind 127.0.0.1
fi
