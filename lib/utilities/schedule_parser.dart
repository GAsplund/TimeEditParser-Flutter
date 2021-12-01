import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeedit/models/booking.dart';
import 'package:timeedit/models/day.dart';
import 'package:timeedit/models/schedule.dart';
import 'package:timeedit/models/week.dart';

import 'package:intl/intl.dart';

import 'package:timeeditparser_flutter/widgets/scheduleItem.dart';

const platform = const MethodChannel('scheduleNotification');

// Get a list of widgets for the schedule ListView.
Future<List<Widget>> getScheduleWidgets(Schedule schedule) async {
  List<Week> weeks = await schedule.getWeeks();
  notifySchedulePlatform(weeks);
  return weeksToScheduleItems(weeks, schedule.nameCatIndex, schedule.locCatIndex, schedule.tutorCatIndex);
}

// Send data to platform to handle platform specific events
Future<void> notifySchedulePlatform(List<Week> weeks) async {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  List<Map<String, dynamic>> scheduleItems = [];
  weeks.forEach((week) {
    week.forEach((day) {
      if (day != null && day.length > 0) {
        DateTime dayDate = day.first.startTime;
        if (DateTime(dayDate.year, dayDate.month, dayDate.day) == today) {
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
        }
      }
    });
  });
  await platform.invokeMethod('setNotifSchedule', scheduleItems);
}

Future<List<Widget>> weeksToScheduleItems(List<Week> weeks, int nameIndex, int locationIndex, int tutorIndex) async {
  List<Widget> weekItems = [];
  for (Week week in weeks) {
    weekItems.add(new Text("Week " + week.weeknum().toString(), style: TextStyle(fontSize: 20)));
    for (Widget widget in weekToScheduleItems(week, nameIndex, locationIndex, tutorIndex)) {
      weekItems.add(widget);
    }
  }
  return weekItems;
}

List<Widget> weekToScheduleItems(Week week, int nameIndex, int locationIndex, int tutorIndex) {
  final DateFormat formatter = DateFormat('EEEE yyyy-MM-dd');
  List<Widget> dayItems = [];
  for (Day day in week) {
    if (day != null)
      dayItems.add(new Text(formatter.format(day.day), style: TextStyle(fontSize: 20)));
    else
      dayItems.add(new Text("Unknown Data"));
    for (Widget widget in dayToScheduleItems(day, nameIndex, locationIndex, tutorIndex)) {
      dayItems.add(widget);
    }
  }
  return dayItems;
}

List<Widget> dayToScheduleItems(Day day, int nameIndex, int locationIndex, int tutorIndex) {
  List<Widget> dayItems = [];
  if (day == null) {
    dayItems.add(new LessonScheduleWidget(name: "(Empty day)", tutors: "null", startTime: "null", endTime: "null", location: "null", idNum: "null"));
    return dayItems;
  }
  final DateFormat formatter = DateFormat('HH:mm');
  for (Booking booking in day) {
    dayItems.add(new LessonScheduleWidget(name: booking.tryGetData(nameIndex), location: booking.tryGetData(locationIndex), startTime: formatter.format(booking.startTime), endTime: formatter.format(booking.endTime), tutors: booking.tryGetData(tutorIndex), idNum: booking.id));
  }
  return dayItems;
}

bool dateTimeToday(DateTime dateToCheck) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final aDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
  return today == aDate;
}
