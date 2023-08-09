import 'package:duration_parser/src/iso_duration_base.dart';
import 'package:test/test.dart';

void main() {
  test('Parse duration', () {
    expect(tryParseIso8601Duration('P7D'), Duration(days: 7));
    expect(tryParseIso8601Duration('PT1H24M'), Duration(hours: 1, minutes: 24));
    expect(tryParseIso8601Duration('PT1H24M'), Duration(minutes: 84));
    expect(tryParseIso8601Duration('P11DT1H24M'), Duration(days: 11, minutes: 84));
    expect(tryParseIso8601Duration('P0DT0H0M0S'), Duration.zero);
    expect(tryParseIso8601Duration('P0D'), Duration.zero);
    expect(tryParseIso8601Duration('PT0S'), Duration.zero);
    expect(tryParseIso8601Duration('P1M5D'), Duration(days: 35));
    expect(tryParseIso8601Duration('PT0.0021S'), Duration(milliseconds: 2, microseconds: 100));
    expect(tryParseIso8601Duration('PT7.0S'), Duration(seconds: 7));
    expect(tryParseIso8601Duration('PT7.123S'), Duration(seconds: 7, milliseconds: 123));

    expect(tryParseIso8601Duration('PT-1H60M'), Duration.zero);

    expect(tryParseIso8601Duration(null), null);
    expect(tryParseIso8601Duration('PT-1H60M', zeroAsNull: true), null);

    expect(tryParseIso8601Duration('PT4D'), null);
    expect(() => parseIso8601Duration('PT4D'), throwsFormatException);
  });
}
