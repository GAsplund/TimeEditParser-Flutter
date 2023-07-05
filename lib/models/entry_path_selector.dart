import 'package:timeedit/objects/org_entry.dart';
import 'package:timeedit/utilities/org_start.dart';
import 'package:timeedit_parser/models/path_selector.dart';

class EntryPathSelector extends PathSelector {
  @override
  String pathType = "Entry Path";

  EntryPathSelector({pathPrefix}) : super(pathPrefix: pathPrefix);

  @override
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