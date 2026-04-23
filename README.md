# ScreenSteward Shared

Single source of truth for:

- **Protocol Buffers** — messages exchanged between child cores, parent apps, and (eventually) the backend.
- **Internationalization** — keys and translations, exportable to ARB (Flutter) and PO (gettext/Python).
- **Domain types** — shared representations.

Consumed via:

- **Dart package** — [`screen_steward_shared` on pub.dev](https://pub.dev/packages/screen_steward_shared)
- **Python package** — [`screensteward-shared` on PyPI](https://pypi.org/project/screensteward-shared/)

## Building

```sh
just generate   # regenerate code from .proto
just test       # run all tests (Dart + Python)
just build-dart
just build-python
```

Python commands run inside the project venv managed by [`uv`](https://docs.astral.sh/uv/). Run `just sync` to create or refresh it.

## License

GNU General Public License v3.0 (GPL-3.0). See [LICENSE](./LICENSE).
