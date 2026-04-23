# ScreenSteward Brand Usage

Rules for using the ScreenSteward visual identity. Apply to every context
where the logo, icon, or wordmark appears — internal, external, apps,
web, print.

## Clearspace

Reserve around the logo at minimum **1.2 × the icon height** on all
four sides. Nothing else fits inside this area: no text, no other icons,
no illustrations.

## Minimum sizes

| Element | Minimum size |
|---|---|
| Icon only | 16 px |
| Horizontal lockup (icon + wordmark) | 120 px wide |
| Vertical lockup | 96 px wide |
| Standalone wordmark | 120 px wide |

## Color usage

| Context | Color |
|---|---|
| Icon background (master) | Primary 500 `#c97b4f` |
| Arc and dot inside the icon | White `#ffffff` |
| Wordmark on light background | Neutral 900 `#1a1a1a` |
| Wordmark standalone (no icon) | Primary 700 `#9c5a36` |
| Primary button / CTA | Primary 500 `#c97b4f` |
| Link, active element | Primary 700 `#9c5a36` |
| Accent, "new" tag | Sage `#6a8570` |

All primary combinations pass WCAG AA; critical paths (child-facing
block prompts, alerts) target AAA.

## Do

- Use the lockups as provided — keep proportions fixed.
- Let iOS / macOS apply their squircle mask on app icons automatically.
- Switch to the dark-mode variant when the background requires it.

## Don't

- Distort the icon or the wordmark. Preserve aspect ratio.
- Change the icon background color. It stays Primary 500.
- Rotate the icon or the lockup. The arc always shelters upward.
- Replace IBM Plex Sans with another typeface in the wordmark.
- Place the lockup on a low-contrast background against the wordmark color.
- Add a tagline or slogan inside the lockup. Keep it separate from the logo.

## File map

Source of truth: this `brand/` directory inside the
[screensteward-shared](https://github.com/screensteward/shared) repo.

- `icon-master.svg` — 1024×1024 master
- `icon-*.png` — precomputed PNG exports (16, 32, 64, 128, 256, 512, 1024)
- `icon-outline.svg`, `icon-monochrome-black.svg`, `icon-monochrome-white.svg` — monochrome and outline variants
- `icon-dark-alt.svg`, `icon-dark-alt-512.png` — dark-mode alternative icon
- `android/background.svg`, `android/foreground.svg` — Android adaptive icon layers
- `lockup-horizontal.svg`, `lockup-vertical.svg`, `wordmark.svg` — logo compositions
- `fonts/IBMPlex*.woff2` — IBM Plex Sans (4 weights) and Mono (2 weights), SIL OFL
- `typography.css` — `@font-face` declarations and CSS variables
- `palette.json`, `palette.css`, `palette.dart` — color tokens (JSON source, CSS and Dart codegen)
- `generate.sh` — regenerate all derivative files from the SVG master and `palette.json`

## License

The ScreenSteward icon, logo, wordmark, and color palette are property
of the ScreenSteward project. Usage in derivative software or marketing
must respect the rules above. For any non-trivial use outside of the
ScreenSteward project itself, contact `brand@screensteward.app`.

The IBM Plex fonts in `fonts/` are distributed under the
[SIL Open Font License 1.1](https://openfontlicense.org/),
with the license text in `fonts/LICENSE.txt`.
