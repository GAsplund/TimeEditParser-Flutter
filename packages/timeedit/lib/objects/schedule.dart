import 'package:timeedit/objects/booking.dart';
import 'package:timeedit/objects/timeedit_date.dart';

class Schedule {
  String url;
  List<String> headers;
  List<Booking> bookings;
  TimeEditDate startDate;
  TimeEditDate endDate;

  Schedule(this.url, this.headers, this.bookings, this.startDate, this.endDate);

  DateTime get startTime {
    return startDate.toDateTime();
  }

  DateTime get endTime {
    return endDate.toDateTime();
  }
}
