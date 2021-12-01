import 'package:flutter/material.dart';
import 'package:timeeditparser_flutter/objects/schedule.dart';
import 'package:timeeditparser_flutter/widgets/scheduleItem.dart';

class ScheduleColumnsPage extends StatefulWidget {
  ScheduleColumnsPage({this.editedSchedule, Schedule schedule});

  final Schedule editedSchedule;

  @override
  _ScheduleColumnsPageState createState() => _ScheduleColumnsPageState(editedSchedule: editedSchedule);
}

class _ScheduleColumnsPageState extends State<ScheduleColumnsPage> {
  _ScheduleColumnsPageState({this.editedSchedule});
  Schedule editedSchedule;

  @override
  Widget build(BuildContext context) {
    editedSchedule ??= new Schedule();
    List<int> indices = editedSchedule.headers.asMap().keys.toList();

    String getHeaderValidIndex(int index) {
      if (index >= 0 && index < editedSchedule.headers.length)
        return index.toString();
      else
        return null;
    }

    // Three types: Name, people, location
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, editedSchedule);
          return;
        },
        child: Scaffold(
            body: ListView(children: [
          LessonScheduleWidget(
            name: (getHeaderValidIndex(editedSchedule.nameCatIndex) == null) ? "(Unset)" : editedSchedule.headers[editedSchedule.nameCatIndex],
            endTime: "23:59",
            idNum: "123456",
            location: (getHeaderValidIndex(editedSchedule.locCatIndex) == null) ? "(Unset)" : editedSchedule.headers[editedSchedule.locCatIndex],
            startTime: "11:59",
            tutors: (getHeaderValidIndex(editedSchedule.tutorCatIndex) == null) ? "(Unset)" : editedSchedule.headers[editedSchedule.tutorCatIndex],
          ),
          Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Card(
                  elevation: 3,
                  child: ListTile(
                    title: Text("Course name"),
                    trailing: DropdownButton(
                      value: getHeaderValidIndex(editedSchedule.nameCatIndex),
                      items: indices.map<DropdownMenuItem<String>>((int value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(editedSchedule.headers[value]),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        editedSchedule.nameCatIndex = int.tryParse(value);
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
                      value: getHeaderValidIndex(editedSchedule.tutorCatIndex),
                      items: indices.map<DropdownMenuItem<String>>((int value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(editedSchedule.headers[value]),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        editedSchedule.tutorCatIndex = int.tryParse(value);
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
                      value: getHeaderValidIndex(editedSchedule.locCatIndex),
                      items: indices.map<DropdownMenuItem<String>>((int value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(editedSchedule.headers[value]),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        editedSchedule.locCatIndex = int.tryParse(value);
                        setState(() {});
                      },
                    ),
                  ))),
        ])));
  }
}
