import 'package:intl/intl.dart';
import 'package:timeedit/objects/timeedit_date.dart';

class TimeEditAbsoluteDate extends TimeEditDate {
  DateTime date = DateTime.now();

  TimeEditAbsoluteDate();
  TimeEditAbsoluteDate.fromDateTime(this.date);

  @override
  String toString() {
    return DateFormat("yyyyMMdd").format(date) + ".x";
  }

  @override
  DateTime toDateTime() {
    return date;
  }
}
