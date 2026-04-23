# ScreenSteward Shared

Source unique de vérité pour :

- **Protocol Buffers** — messages échangés entre child cores, parent apps, et (plus tard) backend.
- **Internationalisation** — clés et traductions, exportables vers ARB (Flutter) et PO (gettext/Python).
- **Types métiers** — représentations partagées.

Consommé via :

- **Dart package** : [`screen_steward_shared` sur pub.dev](https://pub.dev/packages/screen_steward_shared)
- **Python package** : [`screensteward-shared` sur PyPI](https://pypi.org/project/screensteward-shared/)

## Building

```sh
just generate   # regenerate code from .proto
just test       # run all tests (Dart + Python)
just build      # build both packages
```

## License

GNU General Public License v3.0 (GPL-3.0). Voir [LICENSE](./LICENSE).
