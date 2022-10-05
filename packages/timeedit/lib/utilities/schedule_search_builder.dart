import 'package:timeedit/utilities/schedule_search.dart';
import 'package:timeedit/src/timeedit_web.dart';

/// A class for finding and building a [ScheduleSearch] object.
class ScheduleSearchBuilder {
  List<int> pageIds = [];
  String org;
  String entry;

  late int pageId;

  ScheduleSearchBuilder(this.org, this.entry) {
    pageIds = TimeEditWeb.getPageIds(org, entry);
  }

  /// Builds a [ScheduleSearch] object.
  ScheduleSearch build() {
    return ScheduleSearch(org, entry, pageId);
  }
}
