Dart package for parsing and generating ISO 8601 duration strings, to and from Dart's `Duration` instances.

## Usage

```dart
final duration1 = tryParseIso8601Duration('PT1H24M');
print(duration1); // Prints `1:24:00.000000`
print(duration1?.toIso8601String()); // Prints `PT1H24M`

final duration2 = tryParseIso8601Duration('-P1W4DT22H8.5M');
print(duration2); // Prints `-286:08:30.000000`
print(duration2?.toIso8601String()); // Prints `-P1W4DT22H8M30S`

final duration3 = parseIso8601Duration('PT0,8S');
print(duration3); // Prints `0:00:00.800000`
print(duration3.toIso8601String()); // Prints `PT0.8S`
```

## Additional information

Implements a subset of the ISO 8601 Durations syntax as described in [Wikipedia](https://en.wikipedia.org/wiki/ISO_8601#Durations) (8/2023).
- Minus sign is only allowed in the beginning of the duration string, e.g. `-PT1H`.
- Only one decimal fraction is allowed and only in the last component, e.g. `PT1H34.5M` or `PT1H34,5M`
- Number of days per month and year are fixed, 30 and 365 days respectively.
- Combined date and time representations, e.g. `P0003-06-04T12:30:05`, are not supported.
- When generating duration strings, the largest unit in the returned string is weeks.
