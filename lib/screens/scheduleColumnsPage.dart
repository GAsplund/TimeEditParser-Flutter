import 'package:flutter/material.dart';
import 'package:timeedit/objects/schedule.dart';
import 'package:timeedit/utilities/schedule_builder.dart';
import 'package:timeeditparser_flutter/widgets/scheduleItem.dart';

/// A page for selecting data layout when rendering a [Booking].
class ScheduleColumnsPage extends StatefulWidget {
  ScheduleColumnsPage({@required this.editedBuilder, @required this.headers});

  final ScheduleBuilder editedBuilder;
  final List<String> headers;

  @override
  _ScheduleColumnsPageState createState() => _ScheduleColumnsPageState(editedBuilder: editedBuilder, headers: headers);
}

// TODO: Apply header changes to either the builder or separate object.
class _ScheduleColumnsPageState extends State<ScheduleColumnsPage> {
  _ScheduleColumnsPageState({@required this.editedBuilder, @required this.headers});
  ScheduleBuilder editedBuilder;
  List<String> headers;

  @override
  Widget build(BuildContext context) {
    List<int> indices = headers.asMap().keys.toList();

    String getHeaderValidIndex(int index) {
      if (index >= 0 && index < headers.length)
        return index.toString();
      else
        return null;
    }

    // Three types: Name, people, location
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, editedBuilder);
          return;
        },
        child: Scaffold(
            body: ListView(children: [
          LessonScheduleWidget(
            name: "TestName", //(getHeaderValidIndex(editedSchedule.nameCatIndex) == null) ? "(Unset)" : editedSchedule.headers[editedSchedule.nameCatIndex],
            endTime: "23:59",
            idNum: "123456",
            location: "TestLocation", //(getHeaderValidIndex(editedSchedule.locCatIndex) == null) ? "(Unset)" : editedSchedule.headers[editedSchedule.locCatIndex],
            startTime: "11:59",
            tutors: "TestTutors", //(getHeaderValidIndex(editedSchedule.tutorCatIndex) == null) ? "(Unset)" : editedSchedule.headers[editedSchedule.tutorCatIndex],
          ),
          Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Card(
                  elevation: 3,
                  child: ListTile(
                    title: Text("Course name"),
                    trailing: DropdownButton(
                      value: "-1" /*getHeaderValidIndex(editedSchedule.nameCatIndex)*/,
                      items: indices.map<DropdownMenuItem<String>>((int value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(headers[value]),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        //editedSchedule.nameCatIndex = int.tryParse(value);
                        setState(() {});
                      },
                    ),
                  ))),
          Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Card(
                  elevation: 3,
                  child: ListTile(
                    title: Text("Tutors"),
                    trailing: DropdownButton(
                      value: "-1" /*getHeaderValidIndex(editedSchedule.tutorCatIndex)*/,
                      items: indices.map<DropdownMenuItem<String>>((int value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(headers[value]),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        //editedSchedule.tutorCatIndex = int.tryParse(value);
                        setState(() {});
                      },
                    ),
                  ))),
          Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Card(
                  elevation: 3,
                  child: ListTile(
                    title: Text("Location"),
                    trailing: DropdownButton(
                      value: "-1" /*getHeaderValidIndex(editedSchedule.locCatIndex)*/,
                      items: indices.map<DropdownMenuItem<String>>((int value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(headers[value]),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        //editedSchedule.locCatIndex = int.tryParse(value);
                        setState(() {});
                      },
                    ),
                  ))),
        ])));
  }
}
