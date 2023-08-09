import 'package:iso_duration/src/iso_duration_base.dart';

void main() {
  const testData = [
    'P7D', 'PT1H24M', 'PT1H24M', 'P11DT1H24M', 'P0DT0H0M0S', 'P0D', 'PT0S', 'P1M5D', 'PT0.9S', 'PT1123.4S', 'P42D', 'PT1H34.5S', 'PT7.0S', 'PT7.1S'
  ];

  for (var n = 0; n < 100; n++) {
    final sw = Stopwatch();
    sw.start();

    for (var i = 0; i < 1000; i++) {
      for (final ds in testData) {
        parseIso8601Duration(ds);
      }
    }

    sw.stop();
    print(sw.elapsedMicroseconds);
  }

  print('2');
}