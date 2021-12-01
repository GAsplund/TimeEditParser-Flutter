import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeedit/models/link_list.dart';
import 'package:timeedit/models/organization.dart';
import 'package:timeedit/models/schedule.dart';
import 'package:timeeditparser_flutter/screens/itemSelectPage.dart';
import 'package:timeeditparser_flutter/screens/orgSearchPage.dart';
import 'package:timeeditparser_flutter/screens/scheduleColumnsPage.dart';
import 'package:timeeditparser_flutter/screens/scheduleSearchPage.dart';
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
  Organization currentOrg;
  LinkList currentEntrance;
  String startType;
  String startRel;
  String endType;
  String endRel;
  @override
  Widget build(BuildContext context) {
    editedSchedule ??= new Schedule();
    currentOrg ??= (editedSchedule.orgName != null) ? Organization(orgName: editedSchedule.orgName) : null;
    currentEntrance ??= (editedSchedule.orgName != null) ? LinkList(entryPath: editedSchedule.entryPath, orgName: editedSchedule.orgName, description: '', name: '') : null;

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
            SubMenuButton(
              title: Text("${(editedSchedule.entryPath == null) ? '(Unset)' : editedSchedule.entryPath}"),
              onPressed: () => _editEntry(context),
              disabled: editedSchedule.orgName == null,
            ),
            Padding(padding: const EdgeInsets.all(8), child: Text("Schedule Name")),
            SubMenuButton(
              title: Text("${(editedSchedule.schedulePath == null) ? '(Unset)' : editedSchedule.schedulePath}"),
              onPressed: () => _editSchedulePath(context),
              disabled: editedSchedule.entryPath == null,
            ),
            Padding(padding: const EdgeInsets.all(8), child: Text("Schedule Objects")),
            // Schedule objects selection submenu
            // TODO: Replace with SubMenuButton
            // (We dont need link validation anymore)
            SubMenuButton(
              title: Text("Categories"),
              onPressed: () => _scheduleSearch(context),
              disabled: editedSchedule.schedulePath == null,
            ),
            // Schedule columns submenu
            SubMenuButton(
              title: Text("Schedule columns"),
              onPressed: () => _editColumns(context),
              disabled: editedSchedule.schedulePath == null,
            ),
            // Schedule filters submenu
            SubMenuButton(
              title: Text("Schedule filters"),
              onPressed: () => _editFilters(context),
              disabled: editedSchedule.schedulePath == null,
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
        currentOrg = Organization(orgName: result);
      });
  }

  _editEntry(BuildContext context) async {
    List<LinkList> entrances = await currentOrg?.getEntrances();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ItemSelectPage(items: [
                for (LinkList entrance in entrances)
                  [
                    entrance.name,
                    entrance.description,
                    entrance.entryPath
                  ]
              ])),
    );
    if (result != null && result.isNotEmpty && result != editedSchedule.entryPath)
      setState(() {
        editedSchedule.entryPath = result;
        editedSchedule.schedulePath = null;
        editedSchedule.groups?.clear();
        editedSchedule.headers = [];
        currentEntrance = LinkList(entryPath: result, orgName: editedSchedule.orgName, description: '', name: '');
      });
  }

  _editSchedulePath(BuildContext context) async {
    List<List<String>> links = await currentEntrance.getLinks();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ItemSelectPage(items: links)),
    );
    if (result != null && result.isNotEmpty && result != editedSchedule.schedulePath)
      setState(() {
        editedSchedule.schedulePath = result;
      });
  }
}
