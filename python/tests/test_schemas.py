from screensteward_shared.generated import device_pb2, family_pb2


def test_family_message_roundtrip():
    f = family_pb2.Family(id="fam-abc", name="Smith family", created_at_ms=1700000000000)
    serialized = f.SerializeToString()
    f2 = family_pb2.Family()
    f2.ParseFromString(serialized)
    assert f2.id == "fam-abc"
    assert f2.name == "Smith family"


def test_child_references_family():
    c = family_pb2.Child(
        id="child-123",
        family_id="fam-abc",
        display_name="Alice",
        birth_year=2015,
        created_at_ms=1700000000000,
    )
    assert c.family_id == "fam-abc"
    assert c.birth_year == 2015


def test_child_device_carries_noise_pubkey_and_platform():
    d = device_pb2.ChildDevice(
        id="dev-1",
        child_id="child-123",
        name="Bedroom tablet",
        platform=device_pb2.PLATFORM_ANDROID,
        noise_pubkey=b"\x01\x02\x03",
        created_at_ms=1700000000000,
    )
    assert d.platform == device_pb2.PLATFORM_ANDROID
    assert d.noise_pubkey == b"\x01\x02\x03"
