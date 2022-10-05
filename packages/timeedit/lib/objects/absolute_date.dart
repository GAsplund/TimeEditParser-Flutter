import 'package:timeedit/objects/timeedit_date.dart';

class TimeEditAbsoluteDate extends TimeEditDate {
  DateTime date = DateTime.now();

  @override
  String toString() {
    return date.toIso8601String();
  }

  @override
  DateTime toDateTime() {
    return date;
  }
}
