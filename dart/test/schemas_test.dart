import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';
import 'package:screen_steward_shared/src/generated/family.pb.dart';
import 'package:screen_steward_shared/src/generated/device.pb.dart';
import 'package:screen_steward_shared/src/generated/policy.pb.dart';
import 'package:screen_steward_shared/src/generated/usage.pb.dart';
import 'package:screen_steward_shared/src/generated/command.pb.dart';
import 'package:screen_steward_shared/src/generated/event.pb.dart';

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

  group('UsageCounter (CRDT G-Counter)', () {
    test('UsageCounter aggregates per-device counters into a total', () {
      final c = UsageCounter()
        ..childId = 'child-123'
        ..dateYyyymmdd = 20260423
        ..perDeviceMinutes.addAll({
          'dev-A': 67,
          'dev-B': 45,
          'dev-C': 20,
        });
      final total = c.perDeviceMinutes.values.fold<int>(0, (a, b) => a + b);
      expect(total, 132);
    });

    test('UsageEvent has app_id and time bounds', () {
      final e = UsageEvent()
        ..id = 'ev-1'
        ..childId = 'child-123'
        ..deviceId = 'dev-1'
        ..appId = 'com.example.game'
        ..startedAtMs = Int64(1700000000000)
        ..endedAtMs = Int64(1700000060000)
        ..category = 'games';
      final duration = e.endedAtMs - e.startedAtMs;
      expect(duration.toInt(), 60000);
    });
  });

  group('Commands and Events (parent-child protocol)', () {
    test('SetPolicyCommand carries the full Policy', () {
      final cmd = ParentCommand()
        ..id = 'cmd-1'
        ..issuedByParentId = 'parent-A'
        ..issuedAtMs = Int64(1700000000000)
        ..setPolicy = (SetPolicyCommand()
          ..policy = (Policy()
            ..id = 'pol-1'
            ..childId = 'child-123'
            ..scopeType = PolicyScope.SCOPE_CHILD
            ..priority = 100));
      expect(cmd.whichPayload(), ParentCommand_Payload.setPolicy);
      expect(cmd.setPolicy.policy.id, 'pol-1');
    });

    test('GrantExtensionCommand carries duration and reason', () {
      final cmd = ParentCommand()
        ..id = 'cmd-2'
        ..issuedByParentId = 'parent-A'
        ..issuedAtMs = Int64(1700000000000)
        ..grantExtension = (GrantExtensionCommand()
          ..childId = 'child-123'
          ..durationMinutes = 30
          ..reason = 'Birthday');
      expect(cmd.whichPayload(), ParentCommand_Payload.grantExtension);
      expect(cmd.grantExtension.durationMinutes, 30);
    });

    test('UsageUpdateEvent carries counter snapshot', () {
      final e = ChildEvent()
        ..id = 'ev-1'
        ..deviceId = 'dev-1'
        ..emittedAtMs = Int64(1700000000000)
        ..usageUpdate = (UsageUpdateEvent()
          ..counter = (UsageCounter()
            ..childId = 'child-123'
            ..dateYyyymmdd = 20260423
            ..perDeviceMinutes.addAll({'dev-1': 45})));
      expect(e.whichPayload(), ChildEvent_Payload.usageUpdate);
      expect(e.usageUpdate.counter.perDeviceMinutes['dev-1'], 45);
    });
  });
}
