import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

enum RelativeUnit {
  now,
  minutes, // m
  hours, // h
  days, // d
  weeks, // w
  months, // n
  setDate // use rangeStart or rangeEnd parameter
}

/// Represents a start and end for a schedule in a TimeEdit schedule.
class DateRange {
  DateRange();

  DateTime rangeStart = DateTime.now();
  DateTime rangeEnd = Jiffy().add(weeks: 3).dateTime;

  RelativeUnit rangeStartType = RelativeUnit.weeks;
  RelativeUnit rangeEndType = RelativeUnit.weeks;

  /// Gets the parameter representing the date range used for a TimeEdit link.
  String getDateParam() {
    String startParam;
    String endParam;

    startParam = dateParam(rangeStartType, relativeStart, rangeStart);
    endParam = dateParam(rangeEndType, relativeEnd, rangeEnd);

    return startParam + "," + endParam;
  }

  int relativeStart = 0;
  int relativeEnd = 3;

  String dateParam(RelativeUnit relativeUnit, int relative, DateTime range) {
    switch (relativeUnit) {
      case RelativeUnit.minutes:
        return relative.toString() + ".m";
      case RelativeUnit.hours:
        return relative.toString() + ".h";
      case RelativeUnit.days:
        return relative.toString() + ".d";
      case RelativeUnit.weeks:
        return relative.toString() + ".w";
      case RelativeUnit.months:
        return relative.toString() + ".n";
      case RelativeUnit.setDate:
        return DateFormat('yyyyMMdd').format(rangeStart) + ".x";
      case RelativeUnit.now:
      default:
        return "0.w";
    }
  }

  /// Gets the start of the range.
  DateTime getStartDate() {
    switch (rangeStartType) {
      case RelativeUnit.minutes:
        return Jiffy(DateTime.now()).add(minutes: relativeStart).dateTime;
      case RelativeUnit.hours:
        return Jiffy(DateTime.now()).add(hours: relativeStart).dateTime;
      case RelativeUnit.days:
        return Jiffy(DateTime.now()).add(days: relativeStart).dateTime;
      case RelativeUnit.weeks:
        return Jiffy(DateTime.now()).add(weeks: relativeStart).dateTime;
      case RelativeUnit.months:
        return Jiffy(DateTime.now()).add(months: relativeStart).dateTime;
      case RelativeUnit.setDate:
        return rangeStart;
      case RelativeUnit.now:
      default:
        return DateTime.now();
    }
  }

  /// Gets the end of the range.
  DateTime getEndDate() {
    switch (rangeEndType) {
      case RelativeUnit.now:
        return DateTime.now();
      case RelativeUnit.minutes:
        return Jiffy(DateTime.now()).add(minutes: relativeEnd).dateTime;
      case RelativeUnit.hours:
        return Jiffy(DateTime.now()).add(hours: relativeEnd).dateTime;
      case RelativeUnit.days:
        return Jiffy(DateTime.now()).add(days: relativeEnd).dateTime;
      case RelativeUnit.weeks:
        return Jiffy(DateTime.now()).add(weeks: relativeEnd).dateTime;
      case RelativeUnit.months:
        return Jiffy(DateTime.now()).add(months: relativeEnd).dateTime;
      case RelativeUnit.setDate:
        return rangeEnd;
      default:
        return Jiffy(DateTime.now()).add(weeks: 3).dateTime;
    }
  }

  /// Converts a [RelativeUnit] to string used in the date parameter.
  static String relToString(RelativeUnit unit) {
    switch (unit) {
      case RelativeUnit.minutes:
        return "m";
      case RelativeUnit.hours:
        return "h";
      case RelativeUnit.days:
        return "d";
      case RelativeUnit.weeks:
        return "w";
      case RelativeUnit.months:
        return "n";
      case RelativeUnit.now:
        return "now";
      case RelativeUnit.setDate:
      default: // Default should never happen, but catch it anyway
        return "set";
    }
  }

  /// Converts the string representation of a [RelativeUnit] into one.
  ///
  /// If no valid string representation is given,
  /// [RelativeUnit.setDate] will be returned.
  static RelativeUnit stringToRel(String unit) {
    switch (unit) {
      case "m":
        return RelativeUnit.minutes;
      case "h":
        return RelativeUnit.hours;
      case "d":
        return RelativeUnit.days;
      case "w":
        return RelativeUnit.weeks;
      case "n":
        return RelativeUnit.months;
      case "now":
        return RelativeUnit.now;
      case "set":
      default:
        return RelativeUnit.setDate;
    }
  }

  /// Instantiates a new [DateRange] from a JSON object.
  ///
  /// Throws an exception if parameters are missing.
  factory DateRange.fromSettingsJson(Map<String, dynamic> json) {
    DateRange range = DateRange();

    range.rangeStartType = RelativeUnit.values[json['startType']];
    range.rangeEndType = RelativeUnit.values[json['endType']];
    range.rangeStart = DateTime.fromMicrosecondsSinceEpoch(json['startDate']);
    range.rangeEnd = DateTime.fromMicrosecondsSinceEpoch(json['endDate']);
    range.relativeStart = json['relativeStart'];
    range.relativeEnd = json['relativeEnd'];

    return range;
  }

  /// Converts the instance into a JSON object string.
  String toSettingsJson() {
    return json.encode({
      'startType': rangeStartType.index,
      'endType': rangeEndType.index,
      'startDate': rangeStart.millisecondsSinceEpoch,
      'endDate': rangeEnd.millisecondsSinceEpoch,
      'relativeStart': relativeStart,
      'relativeEnd': relativeEnd
    });
  }

  /// Converts the instance into a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'startType': rangeStartType.index,
      'endType': rangeEndType.index,
      'startDate': rangeStart.millisecondsSinceEpoch,
      'endDate': rangeEnd.millisecondsSinceEpoch,
      'relativeStart': relativeStart,
      'relativeEnd': relativeEnd
    };
  }
}
