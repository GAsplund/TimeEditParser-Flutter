import 'dart:convert';

import 'package:timeedit/objects/category.dart';
import 'package:timeedit/objects/filter_query.dart';
import 'package:timeedit/objects/relative_date.dart';
import 'package:timeedit/objects/schedule.dart';
import 'package:timeedit/objects/schedule_object.dart';
import 'package:timeedit/objects/timeedit_date.dart';
import 'package:timeedit/src/timeedit_web.dart';

import '../objects/booking.dart';

/// A class for building a [Schedule].
/// Represents a "schedule search" page in TimeEdit.
class ScheduleBuilder {
  TimeEditDate startDate = TimeEditRelativeDate(length: 0);
  TimeEditDate endDate = TimeEditRelativeDate();

  List<FilterQuery> filters = [];
  List<ScheduleObject> objects = [];

  /// The organization name.
  String org;

  /// The entry path for the collection of schedules.
  String entry;

  /// The page id for the schedule.
  int pageId;

  ScheduleBuilder(this.org, this.entry, this.pageId, this.filters);

  Future<List<Category>> getCategories() async {
    return await TimeEditWeb.getCategories(org, entry, pageId);
  }

  Future<List<ScheduleObject>> getObjects(List<int> types) async {
    return await TimeEditWeb.getObjects(org, entry, pageId, types, []);
  }

  addFilterQuery(FilterQuery fq) {}

  Future<Schedule> getSchedule() async {
    Map<String, dynamic> json = await TimeEditWeb.getSchedule(org, entry, pageId, startDate, endDate, objects);
    List<String> columnHeaders = (json["columnheaders"] as List<dynamic>).cast();
    List<Booking> reservations = (json["reservations"] as List<dynamic>).map((e) => Booking.fromJson(e)).toList();
    return Schedule("", columnHeaders, reservations, startDate, endDate, org, entry, "");
  }

  String getURL() {
    return TimeEditWeb.getScheduleURL(org, entry, pageId, startDate, endDate, objects);
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
    return json.encode({
      "org": org,
      "entry": entry,
      "pageId": pageId,
      "filters": filters,
    });
  }
}
