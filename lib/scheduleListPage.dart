import 'package:flutter/material.dart';
import 'package:timeeditparser_flutter/scheduleModifyPage.dart';
import 'package:timeeditparser_flutter/scheduleNewPage.dart';

import 'util/settings.dart' as settings;
import 'objects/schedule.dart';

class ScheduleListPage extends StatefulWidget {
  ScheduleListPage();

  @override
  _ScheduleListPageState createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  List<Schedule> schedules = [];
  @override
  Widget build(BuildContext context) {
    schedules = settings.schedules;
    List<Widget> scheduleItems = [];
    for (int i = 0; i < schedules.length; i++) {
      scheduleItems.add(new Card(
          elevation: 4,
          child: InkWell(
            onTap: () => schedules[i] = _modifySchedule(context, schedules[i], i),
            child: Padding(child: Text(schedules[i].userCustomName), padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12)),
          )));
    }
    return Scaffold(
        body: ListView(
          children: scheduleItems,
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _addSchedule(context);
            },
            child: Icon(Icons.add)));
  }

  _addSchedule(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text("Add Schedule"),
              ),
              body: ScheduleNewPage(newSchedule: true))),
    );

    if (result is Schedule) {
      schedules.add(result);
      settings.schedules = schedules;
    }
  }

  _modifySchedule(BuildContext context, Schedule schedule, int schedulesIndex) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text("Modify Schedule"),
              ),
              body: ScheduleModifyPage(
                editedSchedule: schedule ?? new Schedule(),
                newSchedule: false,
              ))),
    );

    if (result is Schedule) schedules[schedulesIndex] = result;
  }
}
