from screensteward_shared.generated import device_pb2, family_pb2, policy_pb2, usage_pb2


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


def test_policy_child_scope():
    p = policy_pb2.Policy(
        id="pol-1",
        child_id="child-123",
        scope_type=policy_pb2.SCOPE_CHILD,
        priority=100,
        rules=policy_pb2.PolicyRules(daily_budget_minutes=150),
        active_from_ms=0,
        modified_at_ms=1700000000000,
        created_at_ms=1700000000000,
    )
    assert p.scope_type == policy_pb2.SCOPE_CHILD
    assert p.rules.daily_budget_minutes == 150


def test_policy_device_scope_carries_device_id():
    p = policy_pb2.Policy(
        id="pol-2",
        child_id="child-123",
        scope_type=policy_pb2.SCOPE_DEVICE,
        scope_device_id="dev-1",
        priority=200,
        rules=policy_pb2.PolicyRules(daily_budget_minutes=90),
    )
    assert p.scope_type == policy_pb2.SCOPE_DEVICE
    assert p.scope_device_id == "dev-1"


def test_policy_time_window_rule():
    w = policy_pb2.TimeWindow(
        start_minute_of_day=8 * 60,
        end_minute_of_day=20 * 60,
        days_of_week=[0, 1, 2, 3, 4],  # Mon..Fri
    )
    p = policy_pb2.Policy(
        id="pol-3",
        child_id="child-123",
        scope_type=policy_pb2.SCOPE_CHILD,
        rules=policy_pb2.PolicyRules(allowed_windows=[w]),
    )
    assert len(p.rules.allowed_windows) == 1
    assert p.rules.allowed_windows[0].start_minute_of_day == 480


def test_policy_exception_has_granted_by_and_expiry():
    e = policy_pb2.PolicyException(
        id="exc-1",
        child_id="child-123",
        granted_by_parent_id="parent-A",
        reason="Birthday party",
        duration_minutes=30,
        granted_at_ms=1700000000000,
        expires_at_ms=1700001800000,
    )
    assert e.granted_by_parent_id == "parent-A"
    assert e.duration_minutes == 30


def test_usage_counter_aggregates_per_device():
    c = usage_pb2.UsageCounter(
        child_id="child-123",
        date_yyyymmdd=20260423,
        per_device_minutes={"dev-A": 67, "dev-B": 45, "dev-C": 20},
    )
    total = sum(c.per_device_minutes.values())
    assert total == 132


def test_usage_counter_crdt_merge_semantics():
    """G-Counter merge = max per key."""
    a = usage_pb2.UsageCounter(
        child_id="child-123",
        date_yyyymmdd=20260423,
        per_device_minutes={"dev-A": 67, "dev-B": 30},
    )
    b = usage_pb2.UsageCounter(
        child_id="child-123",
        date_yyyymmdd=20260423,
        per_device_minutes={"dev-A": 50, "dev-B": 45, "dev-C": 20},
    )
    merged_entries = {}
    for k in set(a.per_device_minutes) | set(b.per_device_minutes):
        merged_entries[k] = max(
            a.per_device_minutes.get(k, 0),
            b.per_device_minutes.get(k, 0),
        )
    assert merged_entries == {"dev-A": 67, "dev-B": 45, "dev-C": 20}


def test_usage_event_has_time_bounds():
    e = usage_pb2.UsageEvent(
        id="ev-1",
        child_id="child-123",
        device_id="dev-1",
        app_id="com.example.game",
        started_at_ms=1700000000000,
        ended_at_ms=1700000060000,
        category="games",
    )
    assert e.ended_at_ms - e.started_at_ms == 60000
