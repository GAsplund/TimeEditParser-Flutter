import 'dart:collection';

import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import 'day.dart';

/// Represents one week in a TimeEdit schedule.
class Week extends ListBase<Day> {
  final List<Day> l = [];
  Week(DateTime weekStart) {
    for (int d = 0; d < 6; d++) {
      l.add(Day(Jiffy(weekStart).add(days: d).dateTime));
    }
  }

  @override
  set length(int newLength) {
    l.length = newLength;
  }

  @override
  int get length => l.length;

  @override
  Day operator [](int index) => l[index];

  @override
  void operator []=(int index, Day value) {
    l[index] = value;
  }

  /// Gets the number of weeks that have passed this year
  int weeknum() {
    DateTime date = l.first.day;
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }
}
