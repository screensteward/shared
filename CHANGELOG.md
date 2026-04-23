# Changelog

All notable changes to this project are documented here. Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), adhering to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [dart-0.1.2] - 2026-04-23

### Changed

- Embed the ScreenSteward icon in the Dart package README, visible on pub.dev.

## [brand-0.1.0] - 2026-04-23

### Added

- Brand assets directory `brand/` with icon master SVG (1024×1024),
  PNG exports (16/32/64/128/256/512/1024), monochrome and outline
  variants, dark-mode alternative icon, Android adaptive icon layers,
  horizontal and vertical logo lockups, standalone wordmark.
- IBM Plex Sans (Regular/Medium/SemiBold/Bold) and IBM Plex Mono
  (Regular/Medium) WOFF2 files under `brand/fonts/` (SIL OFL).
- Color tokens in `brand/palette.json` with generated `palette.css`
  and `palette.dart` exports.
- `brand/typography.css` with `@font-face` declarations and type-scale
  CSS variables.
- `brand/USAGE.md` with clearspace, minimum sizes, color usage rules,
  and do's / don'ts.

## [python-0.1.0] - 2026-04-23

### Added

- Initial Python release of `screensteward-shared` on PyPI with the full protobuf schema set (Family, Parent, Child, ParentDevice, ChildDevice, Policy, PolicyException, UsageCounter, UsageEvent, ParentCommand, ChildEvent).

## [dart-0.1.1] - 2026-04-23

### Changed

- Add `topics` to the Dart package pubspec for pub.dev discoverability.

## [0.1.0] - 2026-04-23

### Added

- Initial Protocol Buffers schemas: `family`, `device`, `policy`, `usage`, `command`, `event`.
- Pilot i18n bundle with 10 keys in English and French (ARB + PO formats).
- Dart package `screen_steward_shared`.
- Python package `screensteward-shared`.
