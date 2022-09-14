import 'dart:collection';

import 'booking.dart';

/// Represents one day in a TimeEdit schedule.
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

  @override
  Booking operator [](int index) => l[index];

  @override
  void operator []=(int index, Booking value) {
    l[index] = value;
  }
}
