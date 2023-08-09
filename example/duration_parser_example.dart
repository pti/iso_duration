import 'package:duration_parser/iso_duration.dart';

void main() {
  final duration = tryParseIso8601Duration('PT1H24M');
  print(duration);
}
