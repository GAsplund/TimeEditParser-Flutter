import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeedit/objects/booking.dart';
import 'package:timeedit/objects/schedule.dart';

import 'package:intl/intl.dart';

import 'package:timeedit_parser/widgets/schedule_item.dart';

const platform = MethodChannel('scheduleNotification');

// Get a list of widgets for the schedule ListView.
List<Widget> getScheduleWidgets(Schedule schedule) {
  notifySchedulePlatform(schedule.bookings);
  return bookingsToScheduleItems(schedule.bookings, 30);
}

// Send data to platform to handle platform specific events
Future<void> notifySchedulePlatform(List<Booking> bookings) async {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  List<Map<String, dynamic>> scheduleItems = [];
  DateTime dayDate = bookings.first.startTime;
  if (DateTime(dayDate.year, dayDate.month, dayDate.day) == today) {
    for (var booking in bookings) {
      scheduleItems.add({
        "NAME": booking.headersData[0],
        "LOCATION": booking.headersData[3],
        "TYPE": 0,
        "TIME": booking.startTime.millisecondsSinceEpoch
      });
      scheduleItems.add({
        "NAME": booking.headersData[0],
        "LOCATION": booking.headersData[3],
        "TYPE": 1,
        "TIME": booking.endTime.millisecondsSinceEpoch
      });
    }
  }
  // TODO: Fix proper platform invocation
  //await platform.invokeMethod('setNotifSchedule', scheduleItems);
}

Future<Widget> weekTitle(int week) async {
  return Text("Week $week", style: const TextStyle(fontSize: 20));
}

List<Widget> bookingsToScheduleItems(List<Booking> bookings, int cutoff) {
  List<Widget> dayItems = [];
  final DateFormat formatter = DateFormat('HH:mm');
  int lastDay = -1;
  int dayCount = 0;
  for (Booking booking in bookings) {
    if (booking.startTime.day != lastDay) {
      lastDay = booking.startTime.day;
      dayItems.add(Text("${booking.startTime.day}/${booking.startTime.month}", style: const TextStyle(fontSize: 20)));
      dayCount++;
    }
    if (dayCount > cutoff) {
      break;
    }
    // TODO: Get the correct data from the booking headers
    //dayItems.add(new LessonScheduleWidget(name: booking.tryGetData(nameIndex), location: booking.tryGetData(locationIndex), startTime: formatter.format(booking.startTime), endTime: formatter.format(booking.endTime), tutors: booking.tryGetData(tutorIndex), idNum: booking.id));
    dayItems.add(LessonScheduleWidget(
        name: booking.headersData[0],
        location: booking.headersData[1],
        startTime: formatter.format(booking.startTime),
        endTime: formatter.format(booking.endTime),
        tutors: booking.headersData[2],
        idNum: booking.id));
  }
  return dayItems;
}

bool dateTimeToday(DateTime dateToCheck) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final aDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
  return today == aDate;
}
