import 'package:timeedit/objects/category.dart';
import 'package:timeedit/objects/relative_date.dart';
import 'package:timeedit/objects/timeedit_date.dart';
import 'package:timeedit/utilities/timeedit_web.dart';

import '../objects/schedule.dart';

import '../objects/filter.dart';
import '../objects/filter_query.dart';

class ScheduleSearch {
  TimeEditDate startDate = TimeEditRelativeDate(type: TimeEditRelativeDateType.week, length: 0);
  TimeEditDate endDate = TimeEditRelativeDate();
  List<Filter> getFilters() {
    return [];
  }

  addFilterQuery(FilterQuery fq) {}

  Future<Schedule> getSchedule() async {
    Map<String, dynamic> json = await TimeEditWeb.getSchedule(org, entry, id, objects);
    return Schedule("", json["columnheaders"], json["reservations"], startDate, endDate);
  }

  List<Category> getCategories() {}
}
