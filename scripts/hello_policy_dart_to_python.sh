#!/usr/bin/env bash
# Round-trip: Dart serializes a Policy, Python deserializes and checks fields.
set -euo pipefail

export PATH="$HOME/.pub-cache/bin:$PATH"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Serialize with Dart
cd dart
dart pub get --offline >/dev/null 2>&1 || dart pub get
SERIALIZED=$(mktemp)
dart run example/hello_policy.dart > "$SERIALIZED"
cd ..

# Deserialize with Python (inside the project uv venv)
cd python
uv run python - "$SERIALIZED" <<'PY'
import sys
from screensteward_shared.generated import policy_pb2

data = open(sys.argv[1], "rb").read()
p = policy_pb2.Policy()
p.ParseFromString(data)
assert p.id == "pol-hello", f"Expected pol-hello, got {p.id}"
assert p.child_id == "child-hello", f"Expected child-hello, got {p.child_id}"
assert p.scope_type == policy_pb2.SCOPE_CHILD
assert p.rules.daily_budget_minutes == 120
assert list(p.rules.blocked_categories) == ["games", "social"]
print("OK — Dart-to-Python round-trip verified")
PY
cd ..

rm -f "$SERIALIZED"
