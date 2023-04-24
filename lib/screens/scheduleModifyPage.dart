import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeedit/objects/absolute_date.dart';
import 'package:timeedit/objects/relative_date.dart';
import 'package:timeedit/objects/timeedit_date.dart';
import 'package:timeedit/objects/user_schedule.dart';
import 'package:timeedit/utilities/schedule_builder.dart';
import 'package:timeeditparser_flutter/screens/itemSelectPage.dart';
import 'package:timeeditparser_flutter/screens/orgSearchPage.dart';
import 'package:timeeditparser_flutter/screens/pathSelectionPage.dart';
import 'package:timeeditparser_flutter/screens/scheduleColumnsPage.dart';
import 'package:timeeditparser_flutter/screens/scheduleSearchPage.dart';
import 'package:timeeditparser_flutter/widgets/subMenuButton.dart';

import '../models/entryPathSelector.dart';
import '../models/schedulePathSelector.dart';

class ScheduleModifyPage extends StatefulWidget {
  ScheduleModifyPage({@required this.newBuilder, this.editedBuilder});

  final bool newBuilder;
  final ScheduleBuilder editedBuilder;

  @override
  _ScheduleModifyPageState createState() => _ScheduleModifyPageState(newBuilder: newBuilder, editedBuilder: editedBuilder);
}

class _ScheduleModifyPageState extends State<ScheduleModifyPage> {
  _ScheduleModifyPageState({@required this.newBuilder, this.editedBuilder});
  final bool newBuilder;
  ScheduleBuilder editedBuilder;
  String customName;
  String startType;
  String startRel;
  String endType;
  String endRel;
  @override
  Widget build(BuildContext context) {
    //editedSchedule ??= new Schedule();

    if (startType == null || endType == null) {
      switch (editedBuilder.startDate.runtimeType) {
        //case RelativeUnit.now:
        //  startType = "now";
        //  break;
        case TimeEditAbsoluteDate:
          startType = "set";
          break;
        case TimeEditRelativeDate:
        default:
          startType = "rel";
          startRel = editedBuilder.startDate.toString();
          //startRel = DateRange.relToString(editedBuilder.startDate);
          break;
      }

      switch (editedBuilder.endDate.runtimeType) {
        case TimeEditAbsoluteDate:
          endType = "set";
          break;
        case TimeEditRelativeDate:
        default:
          endType = "rel";
          endRel = editedBuilder.startDate.toString();
          break;
      }
    }

    // WillPopScope for returning data to invoking Widget
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, editedBuilder);
          return;
        },
        child: Scaffold(
            body: ListView(
          children: [
            Padding(padding: const EdgeInsets.all(8), child: Text("Schedule Name")),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: new TextEditingController(text: customName),
                  onSubmitted: (value) {
                    customName = value;
                    setState(() {});
                  },
                )),
            Padding(padding: const EdgeInsets.all(8), child: Text("Schedule Location")),
            // Schedule path submenu
            SubMenuButton(
              title: Text(editedBuilder.org),
              onPressed: () => _editLocation(context),
            ),
            Padding(padding: const EdgeInsets.all(8), child: Text("Schedule Entrance")),
            SubMenuButton(
              title: Text((editedBuilder.entry == null) ? '(Unset)' : editedBuilder.entry),
              onPressed: () => _editEntry(context),
              disabled: editedBuilder.entry == null,
            ),
            Padding(padding: const EdgeInsets.all(8), child: Text("Schedule Name")),
            SubMenuButton(
              title: Text("${(editedBuilder.entry == null) ? '(Unset)' : editedBuilder.entry}"),
              onPressed: () => _editSchedulePath(context),
              disabled: editedBuilder.entry == null,
            ),
            Padding(padding: const EdgeInsets.all(8), child: Text("Schedule Objects")),
            // Schedule objects selection submenu
            // TODO: Replace with SubMenuButton
            // (We dont need link validation anymore)
            SubMenuButton(
              title: Text("Categories"),
              onPressed: () => _scheduleSearch(context),
              //disabled: editedSchedule.url == null,
            ),
            // Schedule columns submenu
            SubMenuButton(
              title: Text("Schedule columns"),
              onPressed: () => _editColumns(context),
              //disabled: editedSchedule.url == null,
            ),
            // Schedule filters submenu
            SubMenuButton(
              title: Text("Schedule filters"),
              onPressed: () => _editFilters(context),
              //disabled: editedSchedule.url == null,
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
                                editedBuilder.startDate = TimeEditRelativeDate(length: 0);
                                break;
                              case "rel":
                                editedBuilder.startDate = TimeEditRelativeDate();
                                break;
                              case "set":
                                editedBuilder.startDate = TimeEditAbsoluteDate();
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
                                      controller: new TextEditingController(text: editedBuilder.startDate.toString()),
                                      onSubmitted: (value) {
                                        // TODO: Fix this
                                        //editedBuilder.startDate = int.parse(value);
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
                                      // TODO: Proper date parsing
                                      editedBuilder.endDate = TimeEditRelativeDate();
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
                                initialValue: editedBuilder.startDate.toString(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                dateLabelText: 'Date',
                                onChanged: (val) => editedBuilder.startDate = TimeEditAbsoluteDate.fromDateTime(DateTime.parse(val)),
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
                                editedBuilder.endDate = TimeEditRelativeDate();
                                break;
                              case "set":
                                editedBuilder.endDate = TimeEditAbsoluteDate();
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
                                      controller: new TextEditingController(text: editedBuilder.endDate.toString()),
                                      onSubmitted: (value) {
                                        // TODO: Persist type
                                        editedBuilder.endDate = TimeEditRelativeDate(length: int.parse(value));
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
                                      editedBuilder.endDate = TimeEditRelativeDate(type: RelativeDateType.fromString(value));
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
                                initialValue: editedBuilder.endDate.toString(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                dateLabelText: 'Date',
                                onChanged: (val) => editedBuilder.endDate = TimeEditAbsoluteDate.fromDateTime(DateTime.parse(val)),
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
      await editedBuilder.getSchedule();
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
              body: ScheduleSearchPage(builder: editedBuilder))),
    );

    editedBuilder = (result is ScheduleBuilder) ? result : editedBuilder;
  }

  _editColumns(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text("Schedule Columns"),
              ),
              body: ScheduleColumnsPage(editedBuilder: editedBuilder))),
    );

    editedBuilder = (result is ScheduleBuilder) ? result : editedBuilder;
  }

  _editFilters(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text("Schedule Filters"),
              ),
              body: ScheduleColumnsPage(editedBuilder: editedBuilder))),
    );

    editedBuilder = (result is ScheduleBuilder) ? result : editedBuilder;
  }

  _editLocation(BuildContext context) async {
    final result = await showSearch(context: context, delegate: OrgSearch());
    if (result != null && result.isNotEmpty && result != editedBuilder.org)
      setState(() {
        editedBuilder.org = result;
        editedBuilder.entry = null;
        editedBuilder.pageId = null;
      });
  }

  _editEntry(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PathSelectionPage(
                  selector: new EntryPathSelector(pathPrefix: [
                    editedBuilder.org
                  ]),
                )));
    if (result != null && result.isNotEmpty && result != editedBuilder.entry)
      setState(() {
        editedBuilder.entry = result;
        editedBuilder.pageId = null;
        editedBuilder.objects?.clear();
        //editedBuilder.headers = [];
      });
  }

  _editSchedulePath(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PathSelectionPage(
                  selector: new SchedulePathSelector(pathPrefix: [
                    editedBuilder.org,
                    editedBuilder.entry
                  ]),
                )));
    if (result != null && result.isNotEmpty && result != editedBuilder.pageId)
      setState(() {
        editedBuilder.pageId = result;
      });
  }

  ScheduleBuilder createBuilder() {
    return ScheduleBuilder(editedBuilder.org, editedBuilder.entry, editedBuilder.pageId, editedBuilder.filters);
  }

  UserSchedule createSchedule() {
    return UserSchedule(createBuilder(), customName);
  }
}
