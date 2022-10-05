import 'package:timeedit/utilities/schedule_search_builder.dart';

/// A class for building a [ScheduleSearchBuilder] object.
class OrgStart {
  List<String> entries = [];
  String org;

  late String entry;

  OrgStart(this.org);

  /// Builds a [ScheduleSearchBuilder] object.
  ScheduleSearchBuilder build() {
    return ScheduleSearchBuilder(org, entry);
  }
}
