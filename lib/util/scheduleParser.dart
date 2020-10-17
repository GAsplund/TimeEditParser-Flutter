import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeeditparser_flutter/objects/booking.dart';
import 'package:timeeditparser_flutter/objects/day.dart';
import 'package:timeeditparser_flutter/objects/schedule.dart';
import 'package:timeeditparser_flutter/objects/week.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../scheduleItem.dart';

const platform = const MethodChannel('scheduleNotification');

Future<List<String>> getScheduleHeaders(String linksbase) async {
  http.Response response = await http.get(linksbase + "ri.json?sid=3");
  return List.castFrom<dynamic, String>(json.decode(response.body)["columnheaders"]);
}

Future<List<Widget>> getScheduleWidgets(Schedule schedule) async {
  schedule = await getSchedule(schedule.link());
  sendSchedule(schedule);
  return weeksToScheduleItems(schedule);
}

Future<void> sendSchedule(Schedule schedule) async {
  List<Map<String, dynamic>> scheduleItems = new List<Map<String, dynamic>>();
  schedule.forEach((week) {
    week.forEach((day) {
      day.forEach((booking) {
        scheduleItems.add({
          "NAME": booking.data[0],
          "LOCATION": booking.data[3],
          "TYPE": 0,
          "TIME": booking.startTime.millisecondsSinceEpoch
        });
        scheduleItems.add({
          "NAME": booking.data[0],
          "LOCATION": booking.data[3],
          "TYPE": 1,
          "TIME": booking.endTime.millisecondsSinceEpoch
        });
      });
    });
  });
  await platform.invokeMethod('setNotifSchedule', scheduleItems);
}

Future<Schedule> getSchedule(String link) async {
  http.Response response = await http.get(link);
  return Schedule.fromTEditJson(json.decode(response.body));
}

Future<List<Widget>> weeksToScheduleItems(List<Week> weeks) async {
  List<Widget> weekItems = new List<Widget>();
  for (Week week in weeks) {
    weekItems.add(new Text("Week " + week.weeknum().toString(), style: TextStyle(fontSize: 20)));
    for (Widget widget in weekToScheduleItems(week)) {
      weekItems.add(widget);
    }
  }
  return weekItems;
}

List<Widget> weekToScheduleItems(Week week) {
  final DateFormat formatter = DateFormat('EEEE yyyy-MM-dd');
  List<Widget> dayItems = new List<Widget>();
  for (Day day in week) {
    if (day != null)
      dayItems.add(new Text(formatter.format(day.day), style: TextStyle(fontSize: 20)));
    else
      dayItems.add(new Text("Unknown Data"));
    for (Widget widget in dayToScheduleItems(day)) {
      dayItems.add(widget);
    }
  }
  return dayItems;
}

List<Widget> dayToScheduleItems(Day day) {
  List<Widget> dayItems = new List<Widget>();
  if (day == null) {
    dayItems.add(new LessonScheduleWidget(courseName: "(Empty day)", tutors: "null", startTime: "null", endTime: "null", location: "null", idNum: "null"));
    return dayItems;
  }
  final DateFormat formatter = DateFormat('HH:mm');
  for (Booking booking in day) {
    dayItems.add(new LessonScheduleWidget(courseName: booking.data[0], location: booking.data[3], startTime: formatter.format(booking.startTime), endTime: formatter.format(booking.endTime), tutors: booking.data[2], idNum: booking.id));
  }
  return dayItems;
}

bool dateTimeToday(DateTime dateToCheck) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final aDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
  return today == aDate;
}
