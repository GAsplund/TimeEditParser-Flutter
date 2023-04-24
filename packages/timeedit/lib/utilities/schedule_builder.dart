import 'package:timeedit/objects/category.dart';
import 'package:timeedit/objects/filter_query.dart';
import 'package:timeedit/objects/relative_date.dart';
import 'package:timeedit/objects/schedule.dart';
import 'package:timeedit/objects/timeedit_date.dart';
import 'package:timeedit/src/timeedit_web.dart';

/// A class for building a [Schedule].
/// Represents a "schedule search" page in TimeEdit.
class ScheduleBuilder {
  TimeEditDate startDate = TimeEditRelativeDate(type: RelativeDateType.week, length: 0);
  TimeEditDate endDate = TimeEditRelativeDate();

  List<FilterQuery> filters = [];
  List<String> objects = [];

  /// The organization name.
  String org;

  /// The entry path for the collection of schedules.
  String entry;

  /// The page id for the schedule.
  int pageId;

  ScheduleBuilder(this.org, this.entry, this.pageId, this.filters);

  List<Category> getCategories() {
    return [];
  }

  addFilterQuery(FilterQuery fq) {}

  Future<Schedule> getSchedule() async {
    Map<String, dynamic> json = await TimeEditWeb.getSchedule(org, entry, pageId, objects);
    return Schedule("", json["columnheaders"], json["reservations"], startDate, endDate, org, entry, "");
  }

  String getURL() {
    return TimeEditWeb.getScheduleURL(org, entry, pageId, objects);
  }

  factory ScheduleBuilder.fromJson(Map<String, dynamic> json) {
    List<FilterQuery> filters = [];
    if (json["filters"] != null) {
      for (Map<String, dynamic> filter in json["filters"]) {
        filters.add(FilterQuery.fromJson(filter));
      }
    }
    return ScheduleBuilder(json["org"], json["entry"], json["pageId"], filters);
  }

  String toJson() {
    List<String> filters = [];
    for (FilterQuery filter in this.filters) {
      filters.add(filter.toJson());
    }
    return {
      "org": org,
      "entry": entry,
      "pageId": pageId,
      "filters": filters,
    }.toString();
  }
}
