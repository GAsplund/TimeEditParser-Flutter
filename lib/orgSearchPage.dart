//import 'dart:html';

import 'package:date_time_picker/date_time_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeeditparser_flutter/objects/schedule.dart';
import 'package:timeeditparser_flutter/scheduleColumnsPage.dart';
import 'package:timeeditparser_flutter/scheduleSearchPage.dart';
import 'package:timeeditparser_flutter/util/scheduleParser.dart';

class OrgSearchPage extends StatefulWidget {
  @override
  _OrgSearchPageState createState() => _OrgSearchPageState();
}

class _OrgSearchPageState extends State<OrgSearchPage> {
  Schedule editedSchedule;
  String startType;
  String startRel;
  String endType;
  String endRel;
  String orgName;
  @override
  Widget build(BuildContext context) {
    editedSchedule ??= new Schedule();

    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, editedSchedule);
          return;
        },
        child: Scaffold(
            body: Column(
          children: [
            Center(
                child: Flexible(
                    child: Card(
                        elevation: 4,
                        child: Row(
                          children: [
                            Padding(padding: const EdgeInsets.all(8), child: Text("Organization")),
                            Flexible(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: TextField(
                                      controller: new TextEditingController(text: orgName),
                                      onSubmitted: (value) {
                                        orgName = value;
                                        setState(() {});
                                      },
                                    ))),
                          ],
                        ))))
          ],
        )));
  }
}
