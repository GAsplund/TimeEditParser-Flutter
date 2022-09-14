import 'package:timeedit/models/link_list.dart';
import 'package:timeedit/models/organization.dart';
import 'package:timeeditparser_flutter/models/pathSelector.dart';

class EntryPathSelector extends PathSelector {
  @override
  String pathType = "Entry Path";

  EntryPathSelector({pathPrefix}) : super(pathPrefix: pathPrefix);

  Future<List<PathSelected>> getPaths() async {
    Organization org = new Organization(orgName: pathPrefix.first);
    List<LinkList> links = await org.getEntrances();

    List<PathSelected> paths = [];
    for (LinkList link in links) {
      paths.add(PathSelected(link.name, link.entryPath));
    }
    return paths;
  }
}
