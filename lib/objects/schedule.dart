import 'dart:collection';

import 'package:intl/intl.dart';
import 'package:timeeditparser_flutter/objects/week.dart';

import 'booking.dart';
import 'day.dart';

enum RelativeUnit {
  now,
  minutes, // m
  hours, // h
  days, // d
  weeks, // w
  months, // n
  setDate // use rangeStart or rangeEnd parameter
}

class Schedule extends ListBase<Week> {
  final List<Week> l = [];
  Schedule({this.headers});
  List<String> headers;

  String userCustomName = "Unnamed Schedule";
  //List<String> headersOrdered = new List<String>(headers.length);

  String linksbase;

  DateTime rangeStart;
  DateTime rangeEnd;

  int relativeStart = 0;
  int relativeEnd = 3;

  RelativeUnit rangeStartType = RelativeUnit.weeks;
  RelativeUnit rangeEndType = RelativeUnit.weeks;

  String getDateParam() {
    String startParam;
    String endParam;

    startParam = dateParam(rangeStartType, relativeStart, rangeStart);
    endParam = dateParam(rangeEndType, relativeEnd, rangeEnd);

    return startParam + "," + endParam;
  }

  String dateParam(RelativeUnit relativeUnit, int relative, DateTime range) {
    switch (relativeUnit) {
      case RelativeUnit.minutes:
        return relative.toString() + ".m";
        break;
      case RelativeUnit.hours:
        return relative.toString() + ".h";
        break;
      case RelativeUnit.days:
        return relative.toString() + ".d";
        break;
      case RelativeUnit.weeks:
        return relative.toString() + ".w";
        break;
      case RelativeUnit.months:
        return relative.toString() + ".n";
        break;
      case RelativeUnit.setDate:
        return DateFormat('yyyyMMdd').format(rangeStart) + ".x";
        break;
      case RelativeUnit.now:
      default:
        return "0.w";
    }
  }

  Map<String, String> groups = new Map<String, String>();

  String link() {
    return linksbase + "ri.json?sid=3&p=" + getDateParam() + "&objects=" + groups.keys.join(",-1,");
  }

  set length(int newLength) {
    l.length = newLength;
  }

  int get length => l.length;
  Week operator [](int index) => l[index];
  void operator []=(int index, Week value) {
    l[index] = value;
  }

  factory Schedule.fromTEditJson(Map<String, dynamic> json) {
    //Stopwatch stopwatch = new Stopwatch()..start();
    List<String> headers = List.castFrom<dynamic, String>(json["columnheaders"]);
    Schedule schedule = new Schedule(headers: headers);
    List<Week> weeks = new List<Week>();

    for (dynamic item in json["reservations"]) {
      Booking booking = Booking.fromTEditJson(item);
      int currentWeek = weekNumber(booking.startTime) - 1;
      int currentWeekDayNum = booking.startTime.weekday - 1;
      if (currentWeek >= weeks.length) weeks.length = currentWeek + 1;

      if (weeks[currentWeek] == null) weeks[currentWeek] = new Week();

      if (currentWeekDayNum >= weeks[currentWeek].length) weeks[currentWeek].length = currentWeekDayNum + 1;

      if (weeks[currentWeek][currentWeekDayNum] == null) weeks[currentWeek][currentWeekDayNum] = new Day(booking.startTime);

      weeks[currentWeek][currentWeekDayNum].add(booking);
    }

    int startIndex = weeks.indexWhere((element) => element != null);
    for (Week week in weeks.getRange(startIndex, weeks.length)) schedule.add((week == null) ? new Week() : week);
    //print('Schedule.fromTEditJson(Map<String, dynamic> json) executed in ${stopwatch.elapsed}');
    return schedule;
  }
}

int weekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  return ((dayOfYear - date.weekday + 10) / 7).floor();
}
