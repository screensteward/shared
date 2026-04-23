import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

// Verifies that the i18n pilot bundles are consistent across locales and formats.
void main() {
  test('ARB locales have the same keys', () {
    final en = _loadArb('locales/en/pilot.arb');
    final fr = _loadArb('locales/fr/pilot.arb');
    expect(_arbUserKeys(fr), equals(_arbUserKeys(en)),
        reason: 'EN and FR ARB files must have identical user keys');
  });

  test('PO locales have the same msgid keys', () {
    final en = _loadPoKeys('locales/en/pilot.po');
    final fr = _loadPoKeys('locales/fr/pilot.po');
    expect(fr, equals(en),
        reason: 'EN and FR PO files must have identical msgid keys');
  });

  test('ARB keys == PO keys (cross-format parity) for EN', () {
    final arbKeys = _arbUserKeys(_loadArb('locales/en/pilot.arb'));
    final poKeys = _loadPoKeys('locales/en/pilot.po');
    expect(poKeys, equals(arbKeys),
        reason: 'ARB and PO files must cover the same i18n keys');
  });
}

Map<String, dynamic> _loadArb(String path) {
  // Tests run from dart/ — locales/ is at repo root.
  final root = Directory.current.parent.path;
  final file = File('$root/$path');
  return json.decode(file.readAsStringSync()) as Map<String, dynamic>;
}

Set<String> _arbUserKeys(Map<String, dynamic> arb) =>
    arb.keys.where((k) => !k.startsWith('@')).toSet();

Set<String> _loadPoKeys(String path) {
  final root = Directory.current.parent.path;
  final file = File('$root/$path');
  final keys = <String>{};
  for (final line in file.readAsLinesSync()) {
    final trimmed = line.trim();
    if (trimmed.startsWith('msgid "') && trimmed != 'msgid ""') {
      final match = RegExp(r'^msgid "(.*)"$').firstMatch(trimmed);
      if (match != null) keys.add(match.group(1)!);
    }
  }
  return keys;
}
