import 'dart:collection';

import 'booking.dart';

class Day extends ListBase<Booking> {
  DateTime day;
  Day(this.day);

  final List<Booking> l = [];

  @override
  set length(int newLength) {
    l.length = newLength;
  }

  @override
  int get length => l.length;
  Booking operator [](int index) => l[index];
  void operator []=(int index, Booking value) {
    l[index] = value;
  }
}
