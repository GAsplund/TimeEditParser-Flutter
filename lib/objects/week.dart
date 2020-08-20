import 'dart:collection';

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
}
