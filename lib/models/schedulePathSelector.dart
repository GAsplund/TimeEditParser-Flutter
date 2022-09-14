import 'package:timeedit/models/link_list.dart';
import 'package:timeeditparser_flutter/models/pathSelector.dart';

class SchedulePathSelector extends PathSelector {
  @override
  String pathType = "Schedule Path";

  SchedulePathSelector({pathPrefix}) : super(pathPrefix: pathPrefix);

  Future<List<PathSelected>> getPaths() async {
    LinkList ll = new LinkList(orgName: pathPrefix.first, entryPath: pathPrefix[1], description: '', name: '');
    List<List<String>> links = await ll.getLinks();

    List<PathSelected> paths = [];
    for (List<String> link in links) {
      paths.add(PathSelected(link[0], link[2]));
    }
    return paths;
  }
}
