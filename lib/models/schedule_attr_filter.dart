import 'package:timeedit/objects/booking.dart';
import 'package:timeeditparser_flutter/models/schedule_filter.dart';

class ScheduleAttrFilter extends ScheduleFilter {
  ScheduleAttrFilter(isBlacklist, this.filter) : super(isBlacklist);

  final String filter;
  int column;
  bool match(Booking b) {
    // Perform an XOR with isBlacklist to invert match
    return isBlacklist ^ (b.headersData[column] == filter);
  }
}
