import 'package:timeedit/models/booking.dart';

abstract class ScheduleFilter {
  ScheduleFilter(this.isBlacklist);

  final bool isBlacklist;
  bool match(Booking b);
}
