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

    expect(tryParseIso8601Duration('-PT1H'), Duration(hours: -1));
    expect(tryParseIso8601Duration('-PT1H60M'), Duration(hours: -2));

    expect(tryParseIso8601Duration('P1.3Y'), Duration(days: 474, hours: 12));
    expect(tryParseIso8601Duration('P0000.9M'), Duration(days: 27));
    expect(tryParseIso8601Duration('P0.9M'), Duration(days: 27));
    expect(tryParseIso8601Duration('P1.4W'), Duration(days: 9, hours: 19, minutes: 12));
    expect(tryParseIso8601Duration('P4.2D'), Duration(days: 4, hours: 4, minutes: 48));
    expect(tryParseIso8601Duration('-P4.2D'), Duration(days: -4, hours: -4, minutes: -48));

    expect(tryParseIso8601Duration('PT1H34.5M'), Duration(hours: 1, minutes: 34, seconds: 30));
    expect(tryParseIso8601Duration('PT1H34,5M'), Duration(hours: 1, minutes: 34, seconds: 30));

    expect(tryParseIso8601Duration('PT1123.4S'), Duration(seconds: 1123, milliseconds: 400));
    expect(tryParseIso8601Duration('PT7.0S'), Duration(seconds: 7));
    expect(tryParseIso8601Duration('PT7.1S'), Duration(seconds: 7, milliseconds: 100));
    expect(() => parseIso8601Duration2('PT1.5H30M'), throwsFormatException); // Only the smallest component may have a decimal fraction.
    expect(() => parseIso8601Duration2('PT1.75H'), throwsFormatException); // Only one decimal fraction is allowed.

    expect(tryParseIso8601Duration(null), null);
    expect(tryParseIso8601Duration(''), null);

    expect(() => parseIso8601Duration2('P'), throwsFormatException);
    expect(() => parseIso8601Duration2('PT'), throwsFormatException);
    expect(() => parseIso8601Duration2('PT4D'), throwsFormatException); // Days in time part.
    expect(() => parseIso8601Duration2('P1M1Y'), throwsFormatException); // Invalid order.
    expect(() => parseIso8601Duration2('P1M1M'), throwsFormatException); // Months twice.
    expect(() => parseIso8601Duration2('PT1M2H'), throwsFormatException); // Invalid order.
    expect(() => parseIso8601Duration2('PT1H2H'), throwsFormatException); // Months twice.
    expect(() => parseIso8601Duration2('P.9M'), throwsFormatException); // Integer part required.
    expect(() => parseIso8601Duration2('PT-1H60M'), throwsFormatException); // Minus sign only allowed in the beginning.
    expect(() => parseIso8601Duration2('P T1M'), throwsFormatException);
    expect(() => parseIso8601Duration2('PTgarbage1M'), throwsFormatException);
    expect(() => parseIso8601Duration2('PT1Mgarbage'), throwsFormatException);
    expect(() => parseIso8601Duration2('PT1M '), throwsFormatException);
    expect(() => parseIso8601Duration2('PT  1M'), throwsFormatException);
    expect(() => parseIso8601Duration2('PTNaNM'), throwsFormatException);
  });
}
