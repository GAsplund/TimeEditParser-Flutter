import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeeditparser_flutter/objects/schedule.dart';

class Settings {
  //static SharedPreferences prefs = await SharedPreferences.getInstance();

  static List<Schedule> schedules;
  static Schedule currentSchedule = new Schedule();
}
