// Emit a serialized Policy on stdout (binary).
// Used by scripts/hello_policy_dart_to_python.sh for cross-language round-trip verification.

import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:screen_steward_shared/screen_steward_shared.dart';

void main() {
  final p = Policy()
    ..id = 'pol-hello'
    ..childId = 'child-hello'
    ..scopeType = PolicyScope.SCOPE_CHILD
    ..priority = 100
    ..rules = (PolicyRules()
      ..dailyBudgetMinutes = 120
      ..blockedCategories.addAll(['games', 'social']))
    ..activeFromMs = Int64(1700000000000)
    ..modifiedAtMs = Int64(1700000000000)
    ..createdAtMs = Int64(1700000000000);

  stdout.add(p.writeToBuffer());
}
