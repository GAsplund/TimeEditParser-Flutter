import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeeditparser_flutter/objects/schedule.dart';
import 'package:timeeditparser_flutter/pages/orgSearchPage.dart';
import 'package:timeeditparser_flutter/pages/scheduleColumnsPage.dart';
import 'package:timeeditparser_flutter/pages/scheduleSearchPage.dart';
import 'package:timeeditparser_flutter/widgets/subMenuButton.dart';

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
  String startType;
  String startRel;
  String endType;
  String endRel;
  @override
  Widget build(BuildContext context) {
    editedSchedule ??= new Schedule();

    if (startType == null || endType == null) {
      switch (editedSchedule.rangeStartType) {
        case RelativeUnit.now:
          startType = "now";
          break;
        case RelativeUnit.setDate:
          startType = "set";
          break;
        default:
          startType = "rel";
          startRel = relToString(editedSchedule.rangeStartType);
          break;
      }

      switch (editedSchedule.rangeEndType) {
        case RelativeUnit.setDate:
          endType = "set";
          break;
        default:
          endType = "rel";
          endRel = relToString(editedSchedule.rangeEndType);
          break;
      }
    }

    // WillPopScope for returning data to invoking Widget
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, editedSchedule);
          return;
        },
        child: Scaffold(
            body: ListView(
          children: [
            Padding(padding: const EdgeInsets.all(8), child: Text("Schedule Name")),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: new TextEditingController(text: editedSchedule.userCustomName),
                  onSubmitted: (value) {
                    editedSchedule.userCustomName = value;
                    setState(() {});
                  },
                )),
            Padding(padding: const EdgeInsets.all(8), child: Text("Schedule Location")),
            // Schedule path submenu
            SubMenuButton(
              title: Text("${editedSchedule.orgName}"),
              onPressed: () => _editLocation(context),
            ),
            Padding(padding: const EdgeInsets.all(8), child: Text("Schedule Entrance")),
            // Temp, please replace later
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: new TextEditingController(text: editedSchedule.entryPath),
                  onSubmitted: (value) {
                    editedSchedule.entryPath = value;
                    setState(() {});
                  },
                )),
            Padding(padding: const EdgeInsets.all(8), child: Text("Schedule Name")),
            // Temp, please replace later
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: new TextEditingController(text: editedSchedule.schedulePath),
                  onSubmitted: (value) async {
                    editedSchedule.schedulePath = value;
                    editedSchedule.headers = await editedSchedule.getHeaders();
                    setState(() {});
                  },
                )),

            Padding(padding: const EdgeInsets.all(8), child: Text("Schedule Objects")),
            // Schedule objects selection submenu
            // TODO: Replace with SubMenuButton
            // (We dont need link validation anymore)
            FutureBuilder(
                future: validLink(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  Widget linkStatus;
                  bool disableButton = true;
                  if (snapshot.hasData) {
                    if (snapshot.data) {
                      linkStatus = Icon(Icons.arrow_forward);
                      disableButton = false;
                    } else
                      linkStatus = Icon(Icons.clear);
                  } else if (snapshot.hasError) {
                    linkStatus = Icon(Icons.clear);
                  } else {
                    linkStatus = CircularProgressIndicator();
                  }
                  return
                      // TODO: Grey out if link is not valid.

                      Padding(
                          padding: const EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 8),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                padding: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                                elevation: 2,
                              ),
                              onPressed: disableButton
                                  ? null
                                  : () {
                                      _scheduleSearch(context);
                                    },
                              child: ListTile(title: Text("Categories"), trailing: linkStatus)));
                }),
            // Schedule columns submenu
            SubMenuButton(
              title: Text("Schedule columns"),
              onPressed: () => _editColumns(context),
            ),
            // Schedule filters submenu
            SubMenuButton(
              title: Text("Schedule filters"),
              onPressed: () => _editFilters(context),
            ),

            // Setting time range
            Padding(padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0), child: Text("Time Range")),

            // Range start
            Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  elevation: 2,
                  child: Column(
                    children: [
                      // Starting from time
                      ListTile(
                        title: Text("Start"),
                        trailing: DropdownButton(
                          value: startType,
                          items: [
                            DropdownMenuItem(
                              value: "now",
                              child: RichText(
                                  text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                                WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0))),
                                TextSpan(text: "Now")
                              ])),
                            ),
                            DropdownMenuItem(
                              value: "rel",
                              child: RichText(
                                  text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                                WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0))),
                                TextSpan(text: "Relative")
                              ])),
                            ),
                            DropdownMenuItem(
                              value: "set",
                              child: RichText(
                                  text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                                WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0))),
                                TextSpan(text: "Set Time")
                              ])),
                            ),
                          ],
                          onChanged: (String value) {
                            startType = value;
                            switch (value) {
                              case "now":
                                editedSchedule.rangeStartType = RelativeUnit.now;
                                break;
                              case "rel":
                                editedSchedule.rangeStartType = RelativeUnit.weeks;
                                break;
                              case "set":
                                editedSchedule.rangeStartType = RelativeUnit.setDate;
                                break;
                            }
                            setState(() {});
                          },
                        ),
                      ),

                      // Starting relatively
                      if (startType == "rel")
                        Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
                            child: Row(children: [
                              Padding(padding: const EdgeInsets.only(right: 8), child: Text("Starting at")),
                              Flexible(
                                  child: TextField(
                                      controller: new TextEditingController(text: editedSchedule.relativeStart.toString()),
                                      onSubmitted: (value) {
                                        editedSchedule.relativeStart = int.parse(value);
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ])),
                              SizedBox(width: 8),
                              // Relative units selector
                              Flexible(
                                  flex: 0,
                                  child: DropdownButton(
                                    value: startRel,
                                    items: [
                                      DropdownMenuItem(
                                        value: "m",
                                        child: RichText(
                                            text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                                          WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0))),
                                          TextSpan(text: "Minutes")
                                        ])),
                                      ),
                                      DropdownMenuItem(
                                        value: "h",
                                        child: RichText(
                                            text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                                          WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0))),
                                          TextSpan(text: "Hours")
                                        ])),
                                      ),
                                      DropdownMenuItem(
                                        value: "d",
                                        child: RichText(
                                            text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                                          WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0))),
                                          TextSpan(text: "Days")
                                        ])),
                                      ),
                                      DropdownMenuItem(
                                        value: "w",
                                        child: RichText(
                                            text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                                          WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0))),
                                          TextSpan(text: "Weeks")
                                        ])),
                                      ),
                                      DropdownMenuItem(
                                        value: "n",
                                        child: RichText(
                                            text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                                          WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0))),
                                          TextSpan(text: "Months")
                                        ])),
                                      ),
                                    ],
                                    onChanged: (String value) {
                                      startRel = value;
                                      editedSchedule.rangeEndType = stringToRel(value);
                                      setState(() {});
                                    },
                                  ))
                            ])),
                      // Starting at set time
                      if (startType == "set")
                        Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
                            child: Row(children: [
                              Padding(padding: const EdgeInsets.only(right: 8), child: Text("Starting at")),
                              Flexible(
                                  child: DateTimePicker(
                                initialValue: editedSchedule.rangeStart.toString(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                dateLabelText: 'Date',
                                onChanged: (val) => editedSchedule.rangeStart = DateTime.parse(val),
                                validator: (val) {
                                  print(val);
                                  return null;
                                },
                                onSaved: (val) => print(val),
                              ))
                            ])),
                    ],
                  ),
                )),

            // Range end
            Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    elevation: 2,
                    child: Column(children: [
                      // Ending at setting
                      ListTile(
                        title: Text("End"),
                        trailing: DropdownButton(
                          value: endType,
                          items: [
                            DropdownMenuItem(
                              value: "rel",
                              child: RichText(
                                  text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                                WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0))),
                                TextSpan(text: "Relative")
                              ])),
                            ),
                            DropdownMenuItem(
                              value: "set",
                              child: RichText(
                                  text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                                WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0))),
                                TextSpan(text: "Set Time")
                              ])),
                            ),
                          ],
                          onChanged: (String value) {
                            endType = value;
                            switch (value) {
                              case "rel":
                                editedSchedule.rangeEndType = RelativeUnit.weeks;
                                break;
                              case "set":
                                editedSchedule.rangeEndType = RelativeUnit.setDate;
                                break;
                            }
                            setState(() {});
                          },
                        ),
                      ),

                      // Ending from time
                      if (endType == "rel")
                        Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
                            child: Row(children: [
                              Padding(padding: const EdgeInsets.only(right: 8), child: Text("Ending in")),
                              Flexible(
                                  child: TextField(
                                      controller: new TextEditingController(text: editedSchedule.relativeEnd.toString()),
                                      onSubmitted: (value) {
                                        editedSchedule.relativeEnd = int.parse(value);
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ])),
                              SizedBox(width: 8),
                              // Relative units selector
                              Flexible(
                                  flex: 0,
                                  child: DropdownButton(
                                    value: endRel,
                                    items: [
                                      DropdownMenuItem(
                                        value: "m",
                                        child: RichText(
                                            text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                                          WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0))),
                                          TextSpan(text: "Minutes")
                                        ])),
                                      ),
                                      DropdownMenuItem(
                                        value: "h",
                                        child: RichText(
                                            text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                                          WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0))),
                                          TextSpan(text: "Hours")
                                        ])),
                                      ),
                                      DropdownMenuItem(
                                        value: "d",
                                        child: RichText(
                                            text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                                          WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0))),
                                          TextSpan(text: "Days")
                                        ])),
                                      ),
                                      DropdownMenuItem(
                                        value: "w",
                                        child: RichText(
                                            text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                                          WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0))),
                                          TextSpan(text: "Weeks")
                                        ])),
                                      ),
                                      DropdownMenuItem(
                                        value: "n",
                                        child: RichText(
                                            text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                                          WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0))),
                                          TextSpan(text: "Months")
                                        ])),
                                      ),
                                    ],
                                    onChanged: (String value) {
                                      endRel = value;
                                      editedSchedule.rangeEndType = stringToRel(value);
                                      setState(() {});
                                    },
                                  ))
                            ])),
                      // Custom end date
                      if (endType != "rel")
                        Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
                            child: Row(children: [
                              Padding(padding: const EdgeInsets.only(right: 8), child: Text("Ending at")),
                              Flexible(
                                  child: DateTimePicker(
                                initialValue: editedSchedule.rangeEnd.toString(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                dateLabelText: 'Date',
                                onChanged: (val) => editedSchedule.rangeEnd = DateTime.parse(val),
                                validator: (val) {
                                  print(val);
                                  return null;
                                },
                                onSaved: (val) => print(val),
                              ))
                            ])),
                    ])))
          ],
        )));
  }

  Future<bool> validLink() async {
    try {
      editedSchedule.headers = await editedSchedule.getHeaders();
      return true;
    } catch (_) {
      return false;
    }
  }

  _scheduleSearch(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text("Search Objects"),
              ),
              body: ScheduleSearchPage(schedule: editedSchedule ?? new Schedule()))),
    );

    editedSchedule = (result is Schedule) ? result : editedSchedule;
  }

  _editColumns(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text("Schedule Columns"),
              ),
              body: ScheduleColumnsPage(editedSchedule: editedSchedule ?? new Schedule()))),
    );

    editedSchedule = (result is Schedule) ? result : editedSchedule;
  }

  _editFilters(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text("Schedule Filters"),
              ),
              body: ScheduleColumnsPage(editedSchedule: editedSchedule ?? new Schedule()))),
    );

    editedSchedule = (result is Schedule) ? result : editedSchedule;
  }

  _editLocation(BuildContext context) async {
    final result = await showSearch(context: context, delegate: OrgSearch());
    if (result != null && result.isNotEmpty && result != editedSchedule.orgName)
      setState(() {
        editedSchedule.orgName = result;
        editedSchedule.entryPath = null;
        editedSchedule.schedulePath = null;
      });
  }

  _editEntry(BuildContext context) async {
    //final result = await showSearch(context: context, delegate: OrgSearch());
    final result = null;
    if (result != null && result.isNotEmpty && result != editedSchedule.entryPath)
      setState(() {
        editedSchedule.entryPath = result;
        editedSchedule.schedulePath = null;
      });
  }

  _editSchedulePath(BuildContext context) async {
    //final result = await showSearch(context: context, delegate: OrgSearch());
    final result = null;
    if (result != null && result.isNotEmpty && result != editedSchedule.schedulePath)
      setState(() {
        editedSchedule.schedulePath = result;
      });
  }
}
