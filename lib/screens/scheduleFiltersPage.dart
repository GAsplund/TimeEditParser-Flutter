import 'package:flutter/material.dart';
import 'package:timeedit/objects/schedule.dart';

class ScheduleFiltersPage extends StatefulWidget {
  ScheduleFiltersPage({@required this.editedSchedule});

  final Schedule editedSchedule;

  @override
  _ScheduleFiltersPageState createState() => _ScheduleFiltersPageState(editedSchedule: editedSchedule);
}

class _ScheduleFiltersPageState extends State<ScheduleFiltersPage> {
  _ScheduleFiltersPageState({@required this.editedSchedule});
  Schedule editedSchedule;

  @override
  Widget build(BuildContext context) {
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
