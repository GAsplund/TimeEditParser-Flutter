//import 'dart:html';

import 'package:date_time_picker/date_time_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeeditparser_flutter/objects/schedule.dart';
import 'package:timeeditparser_flutter/orgSearchPage.dart';
import 'package:timeeditparser_flutter/scheduleColumnsPage.dart';
import 'package:timeeditparser_flutter/scheduleSearchPage.dart';
import 'package:timeeditparser_flutter/util/scheduleParser.dart';

class ScheduleNewPage extends StatefulWidget {
  ScheduleNewPage({@required this.newSchedule, this.editedSchedule});

  final bool newSchedule;
  final Schedule editedSchedule;

  @override
  _ScheduleNewPageState createState() => _ScheduleNewPageState(newSchedule: newSchedule, editedSchedule: editedSchedule);
}

class _ScheduleNewPageState extends State<ScheduleNewPage> {
  _ScheduleNewPageState({@required this.newSchedule, this.editedSchedule});
  final bool newSchedule;
  bool scheduleValid = false;
  Schedule editedSchedule;
  String orgName = "";
  @override
  Widget build(BuildContext context) {
    editedSchedule ??= new Schedule();

    return WillPopScope(
        onWillPop: () {
          // Pop without data no matter what, because the user went back.
          Navigator.pop(context, null);
          return;
        },
        child: Scaffold(
            body: Column(
          children: [
            Center(
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    elevation: 4,
                    child: InkWell(
                      onTap: () => showBottomSheet(
                          context: context,
                          builder: (context) {
                            return new OrgSearchPage();
                          }),
                      child: Padding(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Organization"),
                              TextField(
                                decoration: InputDecoration(hintText: "Enter organization name..."),
                                controller: new TextEditingController(text: orgName),
                                enabled: false,
                                onSubmitted: (value) {
                                  orgName = value;
                                  setState(() {});
                                },
                              )
                            ],
                          ),
                          padding: const EdgeInsets.all(12)),
                    )))
          ],
        )));
  }
}
