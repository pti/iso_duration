import 'package:iso_duration/src/iso_duration_base.dart';
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
    expect(() => parseIso8601Duration('PT1.5H30M'), throwsFormatException); // Only the smallest component may have a decimal fraction.
    expect(() => parseIso8601Duration('PT1.75H'), throwsFormatException); // Only one decimal fraction is allowed.

    expect(tryParseIso8601Duration(null), null);
    expect(tryParseIso8601Duration(''), null);

    expect(() => parseIso8601Duration('P'), throwsFormatException);
    expect(() => parseIso8601Duration('PT'), throwsFormatException);
    expect(() => parseIso8601Duration('PT4D'), throwsFormatException); // Days in time part.
    expect(() => parseIso8601Duration('P1M1Y'), throwsFormatException); // Invalid order.
    expect(() => parseIso8601Duration('P1M1M'), throwsFormatException); // Months twice.
    expect(() => parseIso8601Duration('PT1M2H'), throwsFormatException); // Invalid order.
    expect(() => parseIso8601Duration('PT1H2H'), throwsFormatException); // Months twice.
    expect(() => parseIso8601Duration('P.9M'), throwsFormatException); // Integer part required.
    expect(() => parseIso8601Duration('PT-1H60M'), throwsFormatException); // Minus sign only allowed in the beginning.
    expect(() => parseIso8601Duration('P T1M'), throwsFormatException);
    expect(() => parseIso8601Duration('PTgarbage1M'), throwsFormatException);
    expect(() => parseIso8601Duration('PT1Mgarbage'), throwsFormatException);
    expect(() => parseIso8601Duration('PT1M '), throwsFormatException);
    expect(() => parseIso8601Duration('PT  1M'), throwsFormatException);
    expect(() => parseIso8601Duration('PTNaNM'), throwsFormatException);
  });

  test('Duration.toIso8601String', () {
    expect(Duration.zero.toIso8601String(), 'PT0S');
    expect(Duration(days: 2, hours: 1, minutes: 43).toIso8601String(), 'P2DT1H43M');
    expect(Duration(hours: -1, seconds: -42).toIso8601String(), '-PT1H42S');
    expect(Duration(milliseconds: 3154).toIso8601String(), 'PT3.2S');
    expect(Duration(days: 9).toIso8601String(), 'P1W2D');
    expect(Duration(days: 21, minutes: 5).toIso8601String(), 'P3WT5M');
    expect(Duration(days: 365).toIso8601String(), 'P52W1D'); // Week is the largest unit returned by toIso8601String().
    expect(Duration(milliseconds: 800).toIso8601String(), 'PT0.8S');
    expect(Duration(milliseconds: 833).toIso8601String(), 'PT0.8S');
    expect(Duration(hours: 0, minutes: 33, seconds: 16, milliseconds: 992).toIso8601String(), 'PT33M17S'); // 16.992 gets rounded to 17.0 => 17
    expect(Duration(hours: 0, minutes: 33, seconds: 16, milliseconds: 465).toIso8601String(), 'PT33M16.5S');
    expect(Duration(hours: 0, minutes: 33, seconds: 16, milliseconds: 57).toIso8601String(), 'PT33M16.1S');
    expect(Duration(hours: 0, minutes: 33, seconds: 16, milliseconds: 42).toIso8601String(), 'PT33M16S');
    expect(Duration(hours: 0, minutes: 33, seconds: 16, milliseconds: 0).toIso8601String(), 'PT33M16S');
  });
}
