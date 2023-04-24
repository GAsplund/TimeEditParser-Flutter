import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeedit/objects/booking.dart';
import 'package:timeedit/objects/schedule.dart';

import 'package:intl/intl.dart';

import 'package:timeeditparser_flutter/widgets/scheduleItem.dart';

const platform = const MethodChannel('scheduleNotification');

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
    bookings.forEach((booking) {
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
    });
  }
  // TODO: Fix proper platform invocation
  //await platform.invokeMethod('setNotifSchedule', scheduleItems);
}

Future<Widget> weekTitle(int week) async {
  return new Text("Week " + week.toString(), style: TextStyle(fontSize: 20));
}

List<Widget> bookingsToScheduleItems(List<Booking> bookings, int cutoff) {
  List<Widget> dayItems = [];
  final DateFormat formatter = DateFormat('HH:mm');
  int lastDay = -1;
  int dayCount = 0;
  for (Booking booking in bookings) {
    if (booking.startTime.day != lastDay) {
      lastDay = booking.startTime.day;
      dayItems.add(new Text(booking.startTime.day.toString() + "/" + booking.startTime.month.toString(), style: TextStyle(fontSize: 20)));
      dayCount++;
    }
    if (dayCount > cutoff) {
      break;
    }
    // TODO: Get the correct data from the booking headers
    //dayItems.add(new LessonScheduleWidget(name: booking.tryGetData(nameIndex), location: booking.tryGetData(locationIndex), startTime: formatter.format(booking.startTime), endTime: formatter.format(booking.endTime), tutors: booking.tryGetData(tutorIndex), idNum: booking.id));
    dayItems.add(new LessonScheduleWidget(name: booking.headersData[0], location: booking.headersData[1], startTime: formatter.format(booking.startTime), endTime: formatter.format(booking.endTime), tutors: booking.headersData[2], idNum: booking.id));
  }
  return dayItems;
}

bool dateTimeToday(DateTime dateToCheck) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final aDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
  return today == aDate;
}
