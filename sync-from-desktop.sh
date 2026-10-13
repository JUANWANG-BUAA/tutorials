#!/usr/bin/env bash
# 桌面工作区 → 本仓库 的教程本体同步脚本
# 用法：在仓库根目录执行  bash sync-from-desktop.sh
#
# 只同步教程本体（book.toml / src/ / theme/ / README / requirements / 构建必需的 tools 脚本），
# 自动忽略视频、转录、构建产物等；同步后自动补写 site-url（Pages 子路径部署必需）。
set -euo pipefail
cd "$(dirname "$0")"

# 仓库子目录 → 桌面工作区目录 的映射
declare -A MAP=(
  [robot]="机器人课程第一章教材"
  [numerical]="数值分析第一章教材"
  [matrix]="矩阵论第一章教材"
)

# 构建必需的 tools 白名单（新增构建期脚本时在这里补名字）
TOOLS=(mathbook.py katex_wrapper.py build_search_js.mjs)

for book in "${!MAP[@]}"; do
  src="$HOME/Desktop/${MAP[$book]}"
  if [ ! -d "$src" ]; then echo "⚠️  跳过 $book：找不到 $src"; continue; fi

  rsync -a --delete --exclude .DS_Store "$src/src"  "$book/"
  rsync -a --delete --exclude .DS_Store "$src/theme" "$book/"
  cp "$src/book.toml"        "$book/book.toml"
  cp "$src/README.md"        "$book/README.md"        2>/dev/null || true
  cp "$src/requirements.txt" "$book/requirements.txt" 2>/dev/null || true

  mkdir -p "$book/tools"
  for t in "${TOOLS[@]}"; do
    if [ -f "$src/tools/$t" ]; then cp "$src/tools/$t" "$book/tools/$t"; fi
  done

  # 覆盖 book.toml 后补写 site-url（幂等）
  if ! grep -q '^site-url' "$book/book.toml"; then
    perl -ni -e "print; print qq(site-url = \"/tutorials/$book/\"\n) if /^no-section-label/" "$book/book.toml"
  fi
  echo "✅ $book ← ${MAP[$book]}"
done

echo
echo '=== git 变化汇总 ==='
git status --short
