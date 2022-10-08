import 'package:timeedit/objects/org_entry.dart';
import 'package:timeedit/src/timeedit_web.dart';
import 'package:timeedit/utilities/schedule_search_builder.dart';

/// A class for building a [ScheduleSearchBuilder] object.
class OrgStart {
  List<OrgEntry> entries = [];
  String org;

  late String entry;

  OrgStart._create(this.org);

  static Future<OrgStart> create(String org) async {
    OrgStart component = OrgStart._create(org);
    return component;
  }

  Future getEntries() async {
    entries = await TimeEditWeb.getEntries(org);
  }

  /// Builds a [ScheduleSearchBuilder] object.
  ScheduleSearchBuilder build() {
    return ScheduleSearchBuilder(org, entry);
  }
}
