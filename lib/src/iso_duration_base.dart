
/// Returns `null` if the duration string format is invalid or if the duration is 0 and [zeroAsNull] is `true`.
Duration? tryParseIso8601Duration(String? str, {bool zeroAsNull = false}) {
  try {
    if (str == null || str.isEmpty) return null;
    final result = parseIso8601Duration(str);
    if (zeroAsNull && result == Duration.zero) return null;
    return result;
  } on FormatException catch (_) {
    return null;
  }
}

/// Converts an ISO 8601 duration string to a Dart [Duration] instance.
///
/// Implements a subset of the ISO 8601 Durations syntax as described in [Wikipedia](https://en.wikipedia.org/wiki/ISO_8601#Durations)
/// (8/2023). Notes:
/// - Minus sign is only allowed in the beginning of the duration string, e.g. `-PT1H`.
/// - Only one decimal fraction is allowed and only in the last component, e.g. `PT1H34.5M` or `PT1H34,5M`
/// - Number of days per month and year are fixed, 30 and 365 days respectively.
/// - Combined date and time representations, e.g. `P0003-06-04T12:30:05`, are not supported.
Duration parseIso8601Duration(String str) {
  var i = 0;
  var ch = str[i];

  var negative = ch == '-';
  if (negative || ch == '+') i++;

  ch = str[i++];
  if (ch != 'P') throw FormatException('Missing prefix P: $str');

  var start = i;
  var time = false;

  int? lastValueOrder; // Used for keeping track that components are in valid order and appear only once.
  const kOrderYears = 0;
  const kOrderMonths = 1;
  const kOrderWeeks = 2;
  const kOrderDays = 3;
  const kOrderHours = 4;
  const kOrderMinutes = 5;
  const kOrderSeconds = 6;

  // Due to a possible decimal fraction in the last component, all component values are initially 10x.
  int tyears = 0;
  int tmonths = 0;
  int tweeks = 0;
  int tdays = 0;

  int tminutes = 0;
  int thours = 0;
  int tseconds = 0;

  int checkParseValue({required int order}) {
    final end = i;
    final isLast = end == str.length - 1;
    var sub = str.substring(start, end).replaceFirst(',', '.');

    if (sub.length > 1) {

      if (sub.length != sub.trim().length) {
        throw FormatException('Whitespace not allowed in duration component value: $sub');
      }

      if (sub[0] == '-' || sub[0] == '+') {
        throw FormatException('Sign character not allowed in duration component value: $sub');
      }
    }

    int? value;
    var multiplier = 10;
    final separator = sub.length - 2;

    if (isLast && separator > 0 && (sub[separator] == '.' || sub[separator] == ',')) {
      // Allow a decimal fraction in the last component value. If less than 3 characters, then no comma or period is possible (in a valid string).
      sub = sub.substring(0, separator) + sub.substring(separator + 1);
      multiplier = 1;
    }

    value = int.tryParse(sub);

    if (value == null || value.isNaN) {
      throw FormatException('Invalid duration component value: $sub');
    }

    if (lastValueOrder != null && order <= lastValueOrder!) {
      throw FormatException('Invalid duration component order: ${str.substring(start, end + 1)}');
    }

    start = end + 1;
    lastValueOrder = order;
    return value * multiplier;
  }

  while (i < str.length) {
    ch = str[i];

    if (time) {

      switch (ch) {
        case 'H':
          thours = checkParseValue(order: kOrderHours);
          break;

        case 'M':
          tminutes = checkParseValue(order: kOrderMinutes);
          break;

        case 'S':
          tseconds = checkParseValue(order: kOrderSeconds);
          break;
      }

    } else {

      switch (ch) {
        case 'Y':
          tyears = checkParseValue(order: kOrderYears);
          break;

        case 'M':
          tmonths = checkParseValue(order: kOrderMonths);
          break;

        case 'W':
          tweeks = checkParseValue(order: kOrderWeeks);
          break;

        case 'D':
          tdays = checkParseValue(order: kOrderDays);
          break;

        case 'T':

          if (start < i) {
            throw FormatException('Garbage before time part: ${str.substring(start, i)}');
          }

          start = i + 1;
          time = true;
          break;
      }
    }

    i++;
  }

  if (lastValueOrder == null) {
    throw FormatException('At least one duration component must be defined: $str');
  }

  if (start < i) {
    throw FormatException('Garbage after the end of duration: ${str.substring(start)}');
  }

  tdays += (tyears) * _kDaysPerYear + (tmonths) * _kDaysPerMonth + (tweeks) * _kDaysPerWeek;
  var fullDays = tdays ~/ 10;

  thours += (tdays - fullDays * 10) * Duration.hoursPerDay;
  var fullHours = thours ~/ 10;

  tminutes += (thours - fullHours * 10) * Duration.minutesPerHour;
  var fullMinutes = tminutes ~/ 10;

  tseconds += (tminutes - fullMinutes * 10) * Duration.secondsPerMinute;
  var fullSeconds = tseconds ~/ 10;

  var microseconds = ((tseconds - fullSeconds * 10) * Duration.microsecondsPerSecond) ~/ 10;

  if (negative) {
    fullDays *= -1;
    fullHours *= -1;
    fullMinutes *= -1;
    fullSeconds *= -1;
    microseconds *= -1;
  }

  return Duration(
    days: fullDays,
    hours: fullHours,
    minutes: fullMinutes,
    seconds: fullSeconds,
    microseconds: microseconds
  );
}

const _kDaysPerYear = 365;
const _kDaysPerMonth = 30;
const _kDaysPerWeek = 7;

extension Iso8601DurationExtra on Duration {

  /// Returns an ISO 8601 duration format representation.
  ///
  /// Due to the ambiguities with the number of days in a year and month, the largest unit in the returned
  /// string is weeks.
  String toIso8601String() {
    if (this == Duration.zero) return 'PT0S';

    final Duration duration;
    final StringBuffer sb;

    if (isNegative) {
      sb = StringBuffer('-P');
      duration = abs();
    } else {
      sb = StringBuffer('P');
      duration = this;
    }

    // Calculate component values.
    var days = duration.inDays;
    var x = days * Duration.hoursPerDay;

    final weeks = days ~/ _kDaysPerWeek;
    days -= weeks * _kDaysPerWeek;

    final hours = duration.inHours - x;
    x = (x + hours) * Duration.minutesPerHour;

    final minutes = duration.inMinutes - x;
    x = (x + minutes) * Duration.secondsPerMinute;

    final seconds = duration.inSeconds - x;
    x = (x + seconds) * Duration.millisecondsPerSecond;

    final ds = ((duration.inMilliseconds - x) / 100.0).round();

    // Generate the string.
    if (weeks > 0) sb.write('${weeks}W');
    if (days > 0) sb.write('${days}D');

    if (hours > 0 || minutes > 0 || seconds > 0 || ds > 0) {
      sb.write('T');

      if (hours > 0) sb.write('${hours}H');
      if (minutes > 0) sb.write('${minutes}M');

      if (ds > 0) {
        sb.write('$seconds.${ds}S');
      } else if (seconds > 0) {
        sb.write('${seconds}S');
      }
    }

    return sb.toString();
  }
}
