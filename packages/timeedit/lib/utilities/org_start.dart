import 'package:timeedit/objects/org_entry.dart';
import 'package:timeedit/objects/page_entry.dart';
import 'package:timeedit/src/timeedit_web.dart';
import 'package:timeedit/utilities/schedule_builder.dart';

/// A class for building a [ScheduleSearchBuilder] object.
class OrgStart {
  String org;

  OrgStart(this.org);

  factory OrgStart.fromJSON(Map<String, dynamic> json) {
    return OrgStart(json["id"]);
  }

  static Future<List<OrgStart>> search(String query) async {
    return await TimeEditWeb.searchOrgs(query);
  }

  Future<List<OrgEntry>> getEntries() async {
    return await TimeEditWeb.getEntries(org);
  }

  /// Builds a [ScheduleBuilder] object.
  ScheduleBuilder build(PageEntry entry) {
    return ScheduleBuilder(org, entry.entry, entry.id, []);
  }
}
