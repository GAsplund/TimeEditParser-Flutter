import 'package:timeedit/objects/booking.dart';
import 'package:timeedit/objects/timeedit_date.dart';

class Schedule {
  String url;
  String org;
  String entry;
  List<String> headers;
  List<Booking> bookings;
  TimeEditDate startDate;
  TimeEditDate endDate;

  String userCustomName;

  Schedule(this.url, this.headers, this.bookings, this.startDate, this.endDate, this.org, this.entry, this.userCustomName);

  DateTime get startTime {
    return startDate.toDateTime();
  }

  DateTime get endTime {
    return endDate.toDateTime();
  }
}
