import 'package:flutter/material.dart';
import 'package:timeedit/objects/schedule.dart';
import 'package:timeedit/utilities/schedule_builder.dart';
import 'package:timeeditparser_flutter/models/entryPathSelector.dart';
import 'package:timeeditparser_flutter/screens/pathSelectionPage.dart';
import 'package:timeeditparser_flutter/utilities/orgSearch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/schedulePathSelector.dart';
import 'orgSearchPage.dart';

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

  String orgId = "";
  String entryPath = "";
  int scheduleId = -1;
  List<String> headers = [];
  @override
  Widget build(BuildContext context) {
    //editedSchedule ??= new Schedule();

    return Scaffold(
        appBar: AppBar(
          title: Text("Add Schedule"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, new ScheduleBuilder(orgName, entryPath, scheduleId, [])), child: Text("Add"))
          ],
        ),
        body: WillPopScope(
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
                          onTap: () => _searchOrg(context),
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
                        ))),
                Center(
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        elevation: 4,
                        child: InkWell(
                          onTap: () => _selectEntryPath(context),
                          child: Padding(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Entry Path"),
                                  TextField(
                                    decoration: InputDecoration(hintText: "Enter entry path..."),
                                    controller: new TextEditingController(text: entryPath),
                                    enabled: false,
                                    onSubmitted: (value) {
                                      entryPath = value;
                                      setState(() {});
                                    },
                                  )
                                ],
                              ),
                              padding: const EdgeInsets.all(12)),
                        ))),
                Center(
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        elevation: 4,
                        child: InkWell(
                          onTap: () => _selectSchedulePath(context),
                          child: Padding(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Schedule Path"),
                                  TextField(
                                    decoration: InputDecoration(hintText: "Enter schedule path..."),
                                    controller: new TextEditingController(text: scheduleId.toString()),
                                    enabled: false,
                                    onSubmitted: (value) {
                                      scheduleId = int.tryParse(value);
                                      setState(() {});
                                    },
                                  )
                                ],
                              ),
                              padding: const EdgeInsets.all(12)),
                        )))
              ],
            ))));
  }

  Future _searchOrg(BuildContext context) async {
    final result = await showSearch(context: context, delegate: OrgSearch());
    if (result != null) {
      orgId = result;
      setState(() {
        orgName = result; /*result.label;*/
      });
    }
  }

  Future _selectEntryPath(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PathSelectionPage(
                  selector: new EntryPathSelector(pathPrefix: [
                    orgId
                  ]),
                )));
    if (result is String) {
      setState(() {
        entryPath = result;
      });
    }
  }

  Future _selectSchedulePath(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PathSelectionPage(
                  selector: new SchedulePathSelector(pathPrefix: [
                    orgId,
                    entryPath
                  ]),
                )));
    if (result is int) {
      setState(() {
        scheduleId = result;
      });
    }
  }
}
