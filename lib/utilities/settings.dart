import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeeditparser_flutter/objects/schedule.dart';
import 'package:timeeditparser_flutter/util/theming.dart';

SharedPreferences prefs;
Future<void> getSettings() async {
  prefs = await SharedPreferences.getInstance();
  _currentSchedule = Schedule.fromSettingsJson(json.decode(prefs?.getString("currentSchedule")));

  _schedules = [];
  try {
    for (String item in json.decode(prefs?.getString("schedules"))) _schedules.add(Schedule.fromSettingsJson(json.decode(item)));
  } on FormatException catch (_) {
    print('The provided string is not valid JSON');
  }
}

// schedules setting
List<Schedule> _schedules;

List<Schedule> get schedules {
  return _schedules;
}

set schedules(List<Schedule> newSchedules) {
  List<String> schedulesJson = [];
  for (Schedule schedule in newSchedules) schedulesJson.add(schedule.toSettingsJson());
  prefs?.setString("schedules", jsonEncode(schedulesJson));
  _schedules = newSchedules;
}

// currentSchedule setting
Schedule _currentSchedule;
// This will not work if you remove a schedule whose location is before the index.
// What to do?
//int _currentScheduleIndex;

Schedule get currentSchedule {
  return _currentSchedule;
}

set currentSchedule(Schedule newSchedule) {
  prefs?.setString("currentSchedule", newSchedule.toSettingsJson());
  _currentSchedule = newSchedule;
}

// useTheme setting
ThemeMode get currentTheme {
  if (prefs?.getInt("theme") == null) prefs?.setInt("theme", 0);
  return ThemeMode.values[prefs?.getInt("theme")];
}

void setCurrentTheme(ThemeMode theme, Theming theming) {
  prefs.setInt("theme", theme.index);
  theming.changeTheme(theme.index);
}
