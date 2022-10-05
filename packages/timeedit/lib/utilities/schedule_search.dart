import 'package:timeedit/objects/category.dart';
import 'package:timeedit/objects/filter_query.dart';
import 'package:timeedit/objects/relative_date.dart';
import 'package:timeedit/objects/schedule.dart';
import 'package:timeedit/objects/timeedit_date.dart';
import 'package:timeedit/utilities/timeedit_web.dart';

/// A class for building a [Schedule].
class ScheduleSearch {
  TimeEditDate startDate = TimeEditRelativeDate(type: TimeEditRelativeDateType.week, length: 0);
  TimeEditDate endDate = TimeEditRelativeDate();

  List<String> objects = [];
  String org;
  String entry;
  int pageId;

  ScheduleSearch(this.org, this.entry, this.pageId);

  List<Category> getCategories() {
    return [];
  }

  addFilterQuery(FilterQuery fq) {}

  Future<Schedule> getSchedule() async {
    Map<String, dynamic> json = await TimeEditWeb.getSchedule(org, entry, pageId, objects);
    return Schedule("", json["columnheaders"], json["reservations"], startDate, endDate);
  }
}
