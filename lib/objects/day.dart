import 'dart:collection';

import 'booking.dart';

class Day extends ListBase<Booking> {
  DateTime day;
  Day(DateTime day) {
    this.day = day;
  }

  final List<Booking> l = [];

  set length(int newLength) {
    l.length = newLength;
  }

  int get length => l.length;
  Booking operator [](int index) => l[index];
  void operator []=(int index, Booking value) {
    l[index] = value;
  }
}
