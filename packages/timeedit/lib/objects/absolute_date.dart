import 'package:intl/intl.dart';
import 'package:timeedit/objects/timeedit_date.dart';

class TimeEditAbsoluteDate extends TimeEditDate {
  DateTime date = DateTime.now();

  @override
  String toString() {
    return DateFormat("yyyyMMdd").format(date);
  }

  @override
  DateTime toDateTime() {
    return date;
  }
}
