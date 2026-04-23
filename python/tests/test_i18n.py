"""Verify i18n pilot bundles are internally consistent."""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
LOCALES = ROOT / "locales"


def _load_arb_keys(path: Path) -> set[str]:
    data = json.loads(path.read_text(encoding="utf-8"))
    return {k for k in data if not k.startswith("@")}


def _load_po_keys(path: Path) -> set[str]:
    keys = set()
    pattern = re.compile(r'^msgid "(.+)"$')
    for line in path.read_text(encoding="utf-8").splitlines():
        m = pattern.match(line.strip())
        if m and m.group(1) != "":
            keys.add(m.group(1))
    return keys


def test_arb_en_fr_have_same_keys():
    assert _load_arb_keys(LOCALES / "en/pilot.arb") == _load_arb_keys(LOCALES / "fr/pilot.arb")


def test_po_en_fr_have_same_keys():
    assert _load_po_keys(LOCALES / "en/pilot.po") == _load_po_keys(LOCALES / "fr/pilot.po")


def test_arb_and_po_en_match():
    assert _load_arb_keys(LOCALES / "en/pilot.arb") == _load_po_keys(LOCALES / "en/pilot.po")
