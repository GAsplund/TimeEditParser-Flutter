import 'package:flutter/services.dart';
import 'package:timeedit/objects/booking.dart';

enum EventType { aboutToStart, start, aboutToEnd, end }

class NotificationEvent {
  NotificationEvent({required this.eventTime, required this.eventType});
  final EventType eventType;
  final DateTime eventTime;
}

class Notification {
  static const MethodChannel _channel = MethodChannel('flutter.notification');

  Future setNotifSchedule(List<Booking> bookings) async {
    List<Map<String, int>> events = [];
    for (Booking booking in bookings.where((book) => book.endTime.isAfter(DateTime.now()))) {
      if (booking.startTime.isAfter(DateTime.now())) {
        events.add({"TYPE": EventType.start.index, "TIME": booking.startTime.millisecondsSinceEpoch});
      }

      events.add({"TYPE": EventType.end.index, "TIME": booking.endTime.millisecondsSinceEpoch});
    }
    await _channel.invokeMethod('setNotifSchedule', events);
  }
}
