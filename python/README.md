# screensteward-shared

Generated Protocol Buffers schemas, i18n pilot bundles, and shared types for [ScreenSteward](https://screensteward.app).

Part of the [ScreenSteward shared monorepo](https://github.com/screensteward/shared).

## Installation

```
pip install screensteward-shared
```

## Usage

```python
from screensteward_shared.generated import policy_pb2

p = policy_pb2.Policy(
    id="pol-1",
    child_id="child-123",
    scope_type=policy_pb2.SCOPE_CHILD,
    rules=policy_pb2.PolicyRules(daily_budget_minutes=120),
)
```

## License

GPL-3.0-or-later. See [LICENSE](https://github.com/screensteward/shared/blob/main/LICENSE).
