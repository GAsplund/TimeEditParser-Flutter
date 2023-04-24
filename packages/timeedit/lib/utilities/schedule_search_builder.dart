import 'package:timeedit/utilities/schedule_builder.dart';
import 'package:timeedit/src/timeedit_web.dart';

/// A class for finding and building a [ScheduleBuilder] object.
class ScheduleSearchBuilder {
  List<int> pageIds = [];
  String org;
  String entry;

  ScheduleSearchBuilder(this.org, this.entry) {
    //pageIds = TimeEditWeb.getPageIds(org, entry);
  }

  /// Builds a [ScheduleBuilder] object.
  ScheduleBuilder build(int pageId) {
    return ScheduleBuilder(org, entry, pageId, []);
  }
}
