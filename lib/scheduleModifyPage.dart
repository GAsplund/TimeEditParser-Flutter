//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:timeeditparser_flutter/objects/schedule.dart';
import 'package:timeeditparser_flutter/scheduleItem.dart';
import 'package:timeeditparser_flutter/scheduleSearchPage.dart';
import 'package:timeeditparser_flutter/util/scheduleParser.dart';

enum RangeType {
  datetime,
}

class ScheduleModifyPage extends StatefulWidget {
  ScheduleModifyPage({@required this.newSchedule, this.editedSchedule});

  final bool newSchedule;
  final Schedule editedSchedule;

  @override
  _ScheduleModifyPageState createState() => _ScheduleModifyPageState(newSchedule: newSchedule, editedSchedule: editedSchedule);
}

class _ScheduleModifyPageState extends State<ScheduleModifyPage> {
  _ScheduleModifyPageState({@required this.newSchedule, this.editedSchedule});
  final bool newSchedule;
  Schedule editedSchedule;
  @override
  Widget build(BuildContext context) {
    editedSchedule ??= new Schedule();
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, editedSchedule);
        },
        child: Scaffold(
            body: ListView(
          children: [
            // TODO: Get data from sub-navs
            Text("Schedule Search Link"),
            TextField(
              controller: new TextEditingController(text: editedSchedule.linksbase),
              onSubmitted: (value) {
                editedSchedule.linksbase = value;
                setState(() {});
              },
            ),
            FutureBuilder(
                future: validLink(),
                builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data;
                  } else if (snapshot.hasError) {
                    return Text("Link is invalid.");
                  } else {
                    return Text("Checking link...");
                  }
                }),
            RaisedButton(
              onPressed: () {
                _scheduleSearch(context);
              },
              child: Text("Search Objects"),
            ),
            Text("Schedule Columns"),
            LessonScheduleWidget(
              courseName: "fgh",
              endTime: "23:59",
              idNum: "123456",
              location: "fgh",
              startTime: "00:00",
              tutors: "fgh",
            ),
            Text("Time Range")
          ],
        )));
  }

  Future<Widget> validLink() async {
    try {
      editedSchedule.headers = await getScheduleHeaders(editedSchedule.linksbase);
      return Text("Link is valid.");
    } catch (Exception) {
      return Text("Link is invalid.");
    }
  }

  _scheduleSearch(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScheduleSearchPage(schedule: editedSchedule ?? new Schedule())),
    );

    editedSchedule = (result is Schedule) ? result : editedSchedule;
  }
}
