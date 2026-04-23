import 'package:test/test.dart';
import 'package:screen_steward_shared/src/generated/family.pb.dart';
import 'package:screen_steward_shared/src/generated/device.pb.dart';

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
}
