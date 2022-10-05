import 'package:timeedit/utilities/schedule_search_builder.dart';

/// A class for building a [ScheduleSearchBuilder] object.
class EntryPageBuilder {
  List<String> entries = [];
  String org;

  late String entry;

  EntryPageBuilder(this.org) {
    //pageIds = TimeEditWeb.getPageIds(org, entry);
  }

  /// Builds a [ScheduleSearchBuilder] object.
  ScheduleSearchBuilder build() {
    return ScheduleSearchBuilder(org, entry);
  }
}
