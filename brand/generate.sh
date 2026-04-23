#!/usr/bin/env bash
# Regenerates PNG exports and derivative files from SVG sources
# and color tokens. Idempotent — safe to run repeatedly.

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

# 3. Export palette tokens to CSS custom properties.
# Works on the subtree under .color so paths are like ["primary","500"].
cat > palette.css <<'HEADER'
/* Auto-generated from palette.json. Do not edit by hand. */
:root {
HEADER
jq -r '
  .color as $root |
  [$root | paths(type == "object" and has("value"))] |
  .[] as $p |
  "  --ss-color-" + ($p | join("-")) + ": " + ($root | getpath($p + ["value"])) + ";"
' palette.json >> palette.css
echo "}" >> palette.css
echo "Generated palette.css"

# 4. Export palette tokens to Dart (for Flutter consumers)
cat > palette.dart <<'HEADER'
// Auto-generated from palette.json. Do not edit by hand.
import 'package:flutter/painting.dart';

class SsColors {
HEADER
jq -r '
  .color as $root |
  [$root | paths(type == "object" and has("value"))] |
  .[] as $p |
  "  static const Color " + ($p | join("_")) + " = Color(0xFF" +
    (($root | getpath($p + ["value"])) | ltrimstr("#") | ascii_upcase) + ");"
' palette.json >> palette.dart
echo "}" >> palette.dart
echo "Generated palette.dart"

echo "Brand assets regenerated."
