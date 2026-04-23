# screen_steward_shared

Generated Protocol Buffers schemas, i18n pilot bundles, and shared types for [ScreenSteward](https://screensteward.app).

Part of the [ScreenSteward shared monorepo](https://github.com/screensteward/shared).

## Usage

```dart
import 'package:screen_steward_shared/screen_steward_shared.dart';

final policy = Policy()
  ..id = 'pol-1'
  ..childId = 'child-123'
  ..scopeType = PolicyScope.SCOPE_CHILD
  ..rules = (PolicyRules()..dailyBudgetMinutes = 120);
```

## License

GPL-3.0-or-later. See [LICENSE](https://github.com/screensteward/shared/blob/main/LICENSE).
