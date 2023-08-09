import 'package:duration_parser/iso_duration.dart';

void main() {
  final duration = tryParseIso8601Duration('PT1H24M');
  print(duration); // Prints `1:24:00.000000`

  print(duration?.toIso8601String()); // Prints `PT1H24M`
}
