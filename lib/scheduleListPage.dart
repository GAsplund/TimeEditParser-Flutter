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
  Schedule currentSchedule = settings.currentSchedule;

  @override
  Widget build(BuildContext context) {
    schedules = settings.schedules;
    List<Widget> scheduleItems = [];
    for (int i = 0; i < schedules.length; i++) {
      scheduleItems.add(new Card(
          elevation: 4,
          child: InkWell(
            onTap: () => _modifySchedule(context, schedules[i], i),
            child: Padding(child: Text(schedules[i].userCustomName), padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12)),
          )));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule Management"),
        actions: [
          IconButton(onPressed: () => _addSchedule(context), icon: const Icon(Icons.add))
        ],
      ),
      body: ListView(
        children: <Widget>[
          Text("Active Schedule"),
          Card(
              elevation: 4,
              child: InkWell(
                onTap: () => _modifyCurrentSchedule(context, settings.currentSchedule),
                child: Padding(child: Text(currentSchedule.userCustomName), padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12)),
              )),
          Text("Other Schedules"),
          ...scheduleItems
        ],
      ),
    );
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

  _modifyCurrentSchedule(BuildContext context, Schedule schedule) async {
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

    if (result is Schedule) settings.currentSchedule = result;
  }
}
