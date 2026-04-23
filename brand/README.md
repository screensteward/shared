# ScreenSteward Brand Assets

Visual identity assets for the ScreenSteward project: icons, logo
lockups, color palette, typography, and usage rules.

## Contents

- `icon-*.svg`, `icon-*.png` — icon in various modes and sizes
- `lockup-*.svg`, `wordmark.svg` — logo lockups
- `android/` — Android adaptive icon layers
- `fonts/` — IBM Plex Sans + Mono (SIL OFL license)
- `palette.json` — color tokens
- `typography.css` — `@font-face` and CSS variables
- `generate.sh` — regenerate PNG exports from SVG master
- `USAGE.md` — usage rules (clearspace, minimum sizes, do's and don'ts)

## Consuming these assets

This directory is a sibling of `dart/` and `python/` inside
`screensteward-shared`, so its files are **not included** in the
Dart or Python packages published to pub.dev and PyPI.

Apps that need the assets can:

- Add `screensteward-shared` as a `git submodule` to get a pinned copy
- Use `gh release download` against a `brand-vX.Y.Z` tag to grab an
  archive of this directory
- Copy the files manually into their own `assets/` folder

See `USAGE.md` for the branding rules consumers must follow.

## License

The icon, logo, and color palette are property of the ScreenSteward
project and subject to the usage rules in `USAGE.md`. The IBM Plex
fonts are distributed under the [SIL Open Font License 1.1](https://openfontlicense.org/).
