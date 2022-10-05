import 'package:timeedit/objects/category.dart';
import 'package:timeedit/objects/relative_date.dart';
import 'package:timeedit/objects/timeedit_date.dart';

import '../objects/schedule.dart';

import '../objects/filter.dart';
import '../objects/filter_query.dart';

class ScheduleSearch {
  TimeEditDate startDate;
  TimeEditDate endDate = TimeEditRelativeDate();
  List<Filter> getFilters() {
    return [];
  }

  addFilterQuery(FilterQuery fq) {}

  Schedule getSchedule() {}

  List<Category> getCategories() {}
}
