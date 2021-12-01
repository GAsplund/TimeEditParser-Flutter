import 'package:flutter/material.dart';
import 'package:timeeditparser_flutter/objects/schedule.dart';

class ScheduleFiltersPage extends StatefulWidget {
  ScheduleFiltersPage({this.editedSchedule, Schedule schedule});

  final Schedule editedSchedule;

  @override
  _ScheduleFiltersPageState createState() => _ScheduleFiltersPageState(editedSchedule: editedSchedule);
}

class _ScheduleFiltersPageState extends State<ScheduleFiltersPage> {
  _ScheduleFiltersPageState({this.editedSchedule});
  Schedule editedSchedule;

  @override
  Widget build(BuildContext context) {
    editedSchedule ??= new Schedule();
    List<Widget> filterItems = [];

    for (int i = 0; i < 10; i++) {
      filterItems.add(Text("Filter yes"));
    }

    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, editedSchedule);
          return;
        },
        child: Scaffold(
            body: ListView(children: [
          Text("Schedule filters"),
          ...filterItems
        ])));
  }
}
