#!/bin/zsh
# wargrace ビルドスクリプト
#   board.body.html（編集対象）+ assets/cards/*.svg
#     → board-artifact.html（Claudeアーティファクト用・body内容のみ）
#     → index.html（ローカル/PWA用・完全なHTML）
#     → app/www/（Capacitor iOS用）
set -e
cd "$(dirname "$0")"

# カードSVG → <symbol> 集
SYM=$(mktemp)
for name in back ruler guard hero spirit monster curse cyclone heal cancel growth aging; do
  sed -e "s|<svg viewBox=\"0 0 300 420\" xmlns=\"[^\"]*\"|<symbol id=\"card-$name\" viewBox=\"0 0 300 420\"|" \
      -e "s|</svg>|</symbol>|" "assets/cards/$name.svg" >> "$SYM"
done

awk -v symfile="$SYM" '/<!--SYMBOLS-->/{ while((getline l < symfile) > 0) print l; next } { print }' \
  board.body.html > board-artifact.html

{
  cat <<'HEAD'
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover, user-scalable=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="apple-mobile-web-app-title" content="wargrace">
<meta name="theme-color" content="#14101f">
<link rel="manifest" href="manifest.json">
<link rel="apple-touch-icon" href="icons/icon-180.png">
<title>wargrace</title>
</head>
<body>
HEAD
  cat board-artifact.html
  printf '</body>\n</html>\n'
} > index.html

# Capacitor 用 www を更新
mkdir -p app/www/icons
cp index.html manifest.json app/www/
cp icons/*.png app/www/icons/

rm -f "$SYM"
echo "build ok: index.html ($(wc -c < index.html | tr -d ' ') bytes), app/www 更新済み"
