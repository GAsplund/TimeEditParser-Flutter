import 'package:timeedit/objects/booking.dart';
import 'package:timeedit_parser/models/schedule_filter.dart';

class ScheduleAttrFilter extends ScheduleFilter {
  ScheduleAttrFilter(isBlacklist, this.filter, this.column) : super(isBlacklist);

  final String filter;
  int column;
  bool match(Booking b) {
    // Perform an XOR with isBlacklist to invert match
    return isBlacklist ^ (b.headersData[column] == filter);
  }
}
