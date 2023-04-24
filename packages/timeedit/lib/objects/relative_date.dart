import 'package:timeedit/objects/timeedit_date.dart';

class TimeEditRelativeDate extends TimeEditDate {
  RelativeDateType type;
  int length;

  TimeEditRelativeDate({this.type = RelativeDateType.week, this.length = 3});

  @override
  String toString() {
    String relative = length.toString() + ".";
    switch (type) {
      case RelativeDateType.week:
        relative += "w";
        break;
      case RelativeDateType.day:
        relative += "d";
        break;
      case RelativeDateType.month:
        relative += "m";
        break;
      case RelativeDateType.hour:
        relative += "h";
        break;
    }
    return relative;
  }

  @override
  DateTime toDateTime() {
    DateTime now = DateTime.now();
    switch (type) {
      case RelativeDateType.week:
        return now.add(Duration(days: length * 7));
      case RelativeDateType.day:
        return now.add(Duration(days: length));
      case RelativeDateType.month:
        return now.add(Duration(days: length * 30));
      case RelativeDateType.hour:
        return now.add(Duration(hours: length));
    }
  }
}

enum RelativeDateType {
  month,
  week,
  day,
  hour;

  static RelativeDateType fromString(String type) {
    switch (type) {
      case "m":
        return RelativeDateType.month;
      case "d":
        return RelativeDateType.day;
      case "h":
        return RelativeDateType.hour;
      case "w":
      default:
        return RelativeDateType.week;
    }
  }
}
