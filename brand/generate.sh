#!/usr/bin/env bash
# Regenerates PNG exports and derivative files from SVG sources.
# Idempotent — safe to run repeatedly.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

# 1. PNG exports of icon-master.svg at all standard sizes
SIZES=(16 32 64 128 256 512 1024)
for size in "${SIZES[@]}"; do
  rsvg-convert --width "$size" --height "$size" \
    icon-master.svg -o "icon-${size}.png"
  echo "Generated icon-${size}.png"
done

# 2. PNG export of dark-alt at 512 (for dark mode alternative app icons)
rsvg-convert --width 512 --height 512 \
  icon-dark-alt.svg -o "icon-dark-alt-512.png"
echo "Generated icon-dark-alt-512.png"

echo "Brand assets regenerated."
