import 'package:iso_duration/iso_duration.dart';

void main() {
  final duration1 = tryParseIso8601Duration('PT1H24M');
  print(duration1); // Prints `1:24:00.000000`
  print(duration1?.toIso8601String()); // Prints `PT1H24M`

  final duration2 = tryParseIso8601Duration('-P1W4DT22H8.5M');
  print(duration2); // Prints `-286:08:30.000000`
  print(duration2?.toIso8601String()); // Prints `-P1W4DT22H8M30S`

  final duration3 = parseIso8601Duration('PT0,8S');
  print(duration3); // Prints `0:00:00.800000`
  print(duration3.toIso8601String()); // Prints `PT0.8S`
}
