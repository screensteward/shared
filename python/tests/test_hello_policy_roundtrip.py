"""Roundtrip: Python serializes, Python deserializes (checks format stability).
A Dart->Python end-to-end is done via scripts/hello_policy_dart_to_python.sh.
"""
from screensteward_shared.generated import policy_pb2


def test_python_self_roundtrip_on_hello_policy():
    p1 = policy_pb2.Policy(
        id="pol-hello",
        child_id="child-hello",
        scope_type=policy_pb2.SCOPE_CHILD,
        priority=100,
        rules=policy_pb2.PolicyRules(
            daily_budget_minutes=120,
            blocked_categories=["games", "social"],
        ),
        active_from_ms=1700000000000,
        modified_at_ms=1700000000000,
        created_at_ms=1700000000000,
    )
    data = p1.SerializeToString()

    p2 = policy_pb2.Policy()
    p2.ParseFromString(data)
    assert p2.id == "pol-hello"
    assert p2.rules.daily_budget_minutes == 120
    assert list(p2.rules.blocked_categories) == ["games", "social"]
