import 'dart:collection';

import 'package:intl/intl.dart';

import 'day.dart';

class Week extends ListBase<Day> {
  final List<Day> l = [];
  Week();

  set length(int newLength) {
    l.length = newLength;
  }

  int get length => l.length;
  Day operator [](int index) => l[index];
  void operator []=(int index, Day value) {
    l[index] = value;
  }

  int weeknum() {
    DateTime date = l.firstWhere((element) => element != null && element.day != null).day;
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }
}
