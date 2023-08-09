
final _durationPattern = RegExp(r'^P((?<years>-?\d+)Y)?((?<months>-?\d+)M)?((?<days>-?\d+)D)?(T((?<hours>-?\d+)H)?((?<minutes>-?\d+)M)?((?<seconds>-?\d+(\.\d+)?)S)?)?$');

Duration? tryParseIso8601Duration(String? str, {bool zeroAsNull = false}) {
  try {
    return parseIso8601Duration(str, zeroAsNull: zeroAsNull);
  } on FormatException catch (_) {
    return null;
  }
}

Duration? parseIso8601Duration(String? str, {bool zeroAsNull = false}) {
  if (str == null || str.isEmpty) return null;

  final match = _durationPattern.firstMatch(str);
  if (match == null) throw FormatException('Invalid ISO-8601 duration: $str');

  final years = match.namedGroup('years')?.parseInt();
  final months = match.namedGroup('months')?.parseInt();
  final days = match.namedGroup('days')?.parseInt();
  final hours = match.namedGroup('hours')?.parseInt();
  final minutes = match.namedGroup('minutes')?.parseInt();
  final seconds = match.namedGroup('seconds')?.parseDouble();

  var result = Duration.zero;

  if (years != null) result += Duration(days: 365 * years);
  if (months != null) result += Duration(days: 30 * months);
  if (days != null) result += Duration(days: days);
  if (hours != null) result += Duration(hours: hours);
  if (minutes != null) result += Duration(minutes: minutes);
  if (seconds != null) result += Duration(microseconds: (seconds * 1000000).round());

  if (zeroAsNull && result == Duration.zero) return null;

  return result;
}

extension on String {
  int parseInt() => int.parse(this);
  double parseDouble() => double.parse(this);
}
