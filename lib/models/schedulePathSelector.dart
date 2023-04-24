import 'package:timeedit/utilities/schedule_search_builder.dart';
import 'package:timeedit_parser/models/pathSelector.dart';

class SchedulePathSelector extends PathSelector {
  @override
  String pathType = "Schedule Path";

  SchedulePathSelector({pathPrefix}) : super(pathPrefix: pathPrefix);

  Future<List<PathSelected>> getPaths() async {
    ScheduleSearchBuilder sb = new ScheduleSearchBuilder(pathPrefix.first, pathPrefix[1]);
    //LinkList ll = new LinkList(orgName: pathPrefix.first, entryPath: pathPrefix[1], description: '', name: '');

    List<PathSelected> paths = [];
    for (int entry in sb.pageIds) {
      // TODO: Add entry paths
      //paths.add(PathSelected(entry.url, entry.description));
    }
    return paths;
  }
}
