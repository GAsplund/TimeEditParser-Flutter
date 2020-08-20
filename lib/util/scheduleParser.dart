import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timeeditparser_flutter/objects/booking.dart';
import 'package:timeeditparser_flutter/objects/day.dart';
import 'package:timeeditparser_flutter/objects/week.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:intl/intl.dart';

import '../scheduleItem.dart';

Future<List<Week>> getSchedule() async {
  http.Response response = await http.get(
      'https://cloud.timeedit.net/alingsas/web/schemasok/ri1fkXYQ53ZZ2ZQfQo07by76ykYy35oZu0QQZ78Q7Y7mQ5.html');
  dom.Document document = parser.parse(response.body);
  return Future<List<Week>>.value(parseSchedule(document));
}

List<Week> parseSchedule(dom.Document doc) {
  List<Day> weekSchedule = new List<Day>();

  for (dom.Element weekElement in doc.getElementsByClassName("weekDay")) {
    String dayDateString = weekElement
        .querySelector('.headlinebottom2')
        .text
        .replaceAll("&nbsp;", " ")
        .trim()
        .substring(3);
    DateTime dayDateTime = getFirstDateFromString(dayDateString);
    if (dayDateTime == null) continue;

    Day currentDaySchedule = new Day(dayDateTime);

    for (dom.Element element in weekElement.querySelectorAll(".bookingDiv")) {
      String lessonId = element.attributes["data-id"];

      List<String> cols = new List<String>();
      List<List<String>> teachers = new List<List<String>>();

      for (dom.Element bookingElement
          in element.querySelectorAll('[class^="c  col"]')) {
        cols.add(bookingElement.text);
      }

      // The amount of entries are incomplete. Do not add it.
      if (cols.length < 5) {
        continue;
      }

      // Check if lesson is filtered
      //if (ApplicationSettings.FilterNames.Contains(cols[1])) continue;
      //else if (ApplicationSettings.FilterIDs.Contains(lessonId)) continue;

      List<String> teacherslistsplit = cols[2].split(',').toList();
      for (int i = 0; i < teacherslistsplit.length; i += 2) {
        teachers.add(teacherslistsplit
            .getRange(i, min(i + 2, teacherslistsplit.length))
            .toList());
      }

      final DateFormat formatter = DateFormat('yyyy-MM-dd ');

      List<String> timesplit =
          element.attributes["title"].split(',').first.split(" ");
      DateTime startTime =
              DateTime.parse(formatter.format(dayDateTime) + timesplit[2]),
          endTime =
              DateTime.parse(formatter.format(dayDateTime) + timesplit[4]);

      Booking booking = new Booking(
          //classes: = cols[0].ToString(),
          courseName: cols[1],
          location: cols[3],
          //Group = cols[4].ToString(),
          teachers: teachers,
          startTime: startTime,
          endTime: endTime,
          idNum: lessonId);
      currentDaySchedule.add(booking);
    }
    // Finally, add the list of lessons to the weekSchedule before next iteration
    weekSchedule.add(currentDaySchedule);
  }
  // Return the list, **split with weeks**
  List<Week> weekList = new List<Week>();
  for (int i = 0; i < weekSchedule.length; i += 5) {
    Week currentWeek = new Week();
    for (Day currentday in weekSchedule.getRange(
        i, min(i + 5, weekSchedule.length - 1))) currentWeek.add(currentday);

    weekList.add(currentWeek);
  }

  return weekList;
}

DateTime getFirstDateFromString(String inputText) {
  var regex = new RegExp("\\b\\d{4}\\-\\d{2}-\\d{2}\\b");
  RegExpMatch match = regex.firstMatch(inputText);
  if (match != null) {
    return DateTime.parse(inputText.substring(match.start, match.end));
  }
  return null;
}

List<Widget> weeksToScheduleItems(List<Week> weeks) {
  List<Widget> weekItems = new List<Widget>();
  for (Week week in weeks) {
    for (Widget widget in weekToScheduleItems(week)) {
      weekItems.add(widget);
    }
  }
  return weekItems;
}

List<Widget> weekToScheduleItems(Week week) {
  List<Widget> dayItems = new List<Widget>();
  for (Day day in week) {
    for (Widget widget in dayToScheduleItems(day)) {
      dayItems.add(widget);
    }
  }
  return dayItems;
}

List<Widget> dayToScheduleItems(Day day) {
  List<Widget> dayItems = new List<Widget>();
  final DateFormat formatter = DateFormat('HH:mm');
  for (Booking booking in day) {
    dayItems.add(new LessonScheduleWidget(
        courseName: booking.courseName,
        location: booking.location,
        startTime: formatter.format(booking.startTime),
        endTime: formatter.format(booking.endTime),
        tutors: booking.description(),
        idNum: booking.idNum));
  }
  return dayItems;
}
