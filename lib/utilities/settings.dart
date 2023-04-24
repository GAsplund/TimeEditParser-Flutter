import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeedit/utilities/schedule_builder.dart';
import 'package:timeedit_parser/utilities/theming.dart';

SharedPreferences? prefs;
Future<void> getSettings() async {
  prefs = await SharedPreferences.getInstance();
  _currentBuilder = ScheduleBuilder.fromJson(json.decode(prefs?.getString("currentSchedule") ?? "{}"));

  _builders = [];
  try {
    String schedulesJson = prefs!.getString("schedules") ?? "[]";
    for (String item in json.decode(schedulesJson)) {
      _builders.add(ScheduleBuilder.fromJson(json.decode(item)));
    }
  } on FormatException catch (_) {
    print('The provided string is not valid JSON');
  }
}

// schedules setting
List<ScheduleBuilder> _builders = [];

List<ScheduleBuilder> get builders {
  return _builders;
}

set schedules(List<ScheduleBuilder> newBuilders) {
  List<String> buildersJson = [];
  for (ScheduleBuilder builder in newBuilders) buildersJson.add(builder.toJson());
  prefs?.setString("schedules", jsonEncode(buildersJson));
  _builders = newBuilders;
}

// currentSchedule setting
ScheduleBuilder? _currentBuilder;
// This will not work if you remove a schedule whose location is before the index.
// What to do?
//int _currentScheduleIndex;

ScheduleBuilder get currentBuilder {
  /*if (_currentSchedule == null) {
    _currentSchedule = new Schedule(headers: [], orgName: "timeedit_sso_test", entryPath: "publik", schedulePath: "ri1Q7");
  }*/
  if (_currentBuilder == null) getSettings();
  return _currentBuilder!;
}

set currentBuilder(ScheduleBuilder newBuilder) {
  prefs?.setString("currentSchedule", newBuilder.toJson());
  _currentBuilder = newBuilder;
}

// useTheme setting
ThemeMode get currentTheme {
  if (prefs?.getInt("theme") == null) prefs?.setInt("theme", 0);
  return ThemeMode.values[prefs?.getInt("theme") ?? 0];
}

void setCurrentTheme(ThemeMode theme, Theming theming) {
  prefs?.setInt("theme", theme.index);
  theming.changeTheme(theme.index);
}
