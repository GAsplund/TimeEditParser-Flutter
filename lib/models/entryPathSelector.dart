import 'package:timeedit/objects/org_entry.dart';
import 'package:timeedit/utilities/org_start.dart';
import 'package:timeeditparser_flutter/models/pathSelector.dart';

class EntryPathSelector extends PathSelector {
  @override
  String pathType = "Entry Path";

  EntryPathSelector({pathPrefix}) : super(pathPrefix: pathPrefix);

  Future<List<PathSelected>> getPaths() async {
    OrgStart org = await OrgStart.create(pathPrefix.first);
    List<OrgEntry> links = await org.entries;

    List<PathSelected> paths = [];
    for (OrgEntry link in links) {
      paths.add(PathSelected(link.name, link.url));
    }
    return paths;
  }
}
