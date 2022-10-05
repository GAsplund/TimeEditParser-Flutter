import 'package:timeedit/objects/timeedit_date.dart';

class TimeEditRelativeDate extends TimeEditDate {
  TimeEditRelativeDateType type;
  int length;

  TimeEditRelativeDate({this.type = TimeEditRelativeDateType.week, this.length = 3});

  @override
  String toString() {
    String relative = length.toString() + ".";
    switch (type) {
      case TimeEditRelativeDateType.week:
        relative += "w";
        break;
      case TimeEditRelativeDateType.day:
        relative += "d";
        break;
      case TimeEditRelativeDateType.month:
        relative += "m";
        break;
      case TimeEditRelativeDateType.hour:
        relative += "h";
        break;
    }
    return relative;
  }

  @override
  DateTime toDateTime() {
    DateTime now = DateTime.now();
    switch (type) {
      case TimeEditRelativeDateType.week:
        return now.add(Duration(days: length * 7));
      case TimeEditRelativeDateType.day:
        return now.add(Duration(days: length));
      case TimeEditRelativeDateType.month:
        return now.add(Duration(days: length * 30));
      case TimeEditRelativeDateType.hour:
        return now.add(Duration(hours: length));
    }
  }
}

enum TimeEditRelativeDateType { month, week, day, hour }
