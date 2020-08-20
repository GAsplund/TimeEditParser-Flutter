import 'package:flutter/material.dart';
import 'objects/week.dart';
import 'util/scheduleParser.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage();

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 230, 230, 230),
        body: FutureBuilder(
            future: getSchedule(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Week>> snapshot) {
              return ListView(children: weeksToScheduleItems(snapshot.data));
            }));
  }
}
