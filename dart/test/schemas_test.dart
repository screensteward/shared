import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';
import 'package:screen_steward_shared/src/generated/family.pb.dart';
import 'package:screen_steward_shared/src/generated/device.pb.dart';
import 'package:screen_steward_shared/src/generated/policy.pb.dart';

void main() {
  test('Family message can be constructed with id and name', () {
    final f = Family()
      ..id = 'fam-abc'
      ..name = 'Smith family';
    expect(f.id, 'fam-abc');
    expect(f.name, 'Smith family');
  });

  test('Child references its Family by id', () {
    final child = Child()
      ..id = 'child-123'
      ..familyId = 'fam-abc'
      ..displayName = 'Alice';
    expect(child.familyId, 'fam-abc');
    expect(child.displayName, 'Alice');
  });

  test('ChildDevice references its Child by id and carries noise_pubkey', () {
    final dev = ChildDevice()
      ..id = 'dev-1'
      ..childId = 'child-123'
      ..name = 'Bedroom tablet'
      ..platform = DevicePlatform.PLATFORM_ANDROID
      ..noisePubkey = [1, 2, 3];
    expect(dev.childId, 'child-123');
    expect(dev.platform, DevicePlatform.PLATFORM_ANDROID);
    expect(dev.noisePubkey.length, 3);
  });

  group('Policy', () {
    test('Policy with child scope applies to all devices', () {
      final p = Policy()
        ..id = 'pol-1'
        ..childId = 'child-123'
        ..scopeType = PolicyScope.SCOPE_CHILD
        ..priority = 100
        ..rules = (PolicyRules()..dailyBudgetMinutes = 150);
      expect(p.scopeType, PolicyScope.SCOPE_CHILD);
      expect(p.rules.dailyBudgetMinutes, 150);
    });

    test('Policy with device scope carries scope_device_id', () {
      final p = Policy()
        ..id = 'pol-2'
        ..childId = 'child-123'
        ..scopeType = PolicyScope.SCOPE_DEVICE
        ..scopeDeviceId = 'dev-1'
        ..priority = 200
        ..rules = (PolicyRules()..dailyBudgetMinutes = 90);
      expect(p.scopeType, PolicyScope.SCOPE_DEVICE);
      expect(p.scopeDeviceId, 'dev-1');
    });

    test('PolicyException carries granted_by_parent and expires_at', () {
      final e = PolicyException()
        ..id = 'exc-1'
        ..childId = 'child-123'
        ..grantedByParentId = 'parent-A'
        ..reason = 'Birthday party'
        ..durationMinutes = 30
        ..grantedAtMs = Int64(1700000000000)
        ..expiresAtMs = Int64(1700001800000);
      expect(e.grantedByParentId, 'parent-A');
      expect(e.durationMinutes, 30);
    });
  });
}
