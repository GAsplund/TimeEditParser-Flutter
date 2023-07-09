import 'package:timeedit/objects/page_entry.dart';
import 'package:timeedit/src/timeedit_web.dart';

class OrgEntry {
  String org;
  String entry;
  String name;
  String description;
  bool isLocked;

  Future<List<PageEntry>> getIds() async {
    return await TimeEditWeb.getPageIds(org, entry);
  }

  OrgEntry(this.org, this.entry, this.name, this.description, this.isLocked);

  @override
  String toString() {
    return "OrgEntry: $name ($entry)";
  }
}
