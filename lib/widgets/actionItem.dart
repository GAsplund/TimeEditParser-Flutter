import 'package:flutter/material.dart';

class ActionButtonWidget extends StatefulWidget {
  ActionButtonWidget(
      {required this.courseName,
      required this.tutors,
      required this.startTime,
      required this.endTime,
      required this.location,
      required this.idNum});

  final String courseName;
  final String tutors;
  final String startTime;
  final String endTime;
  final String location;
  final String idNum;

  @override
  _ActionButtonWidgetState createState() => _ActionButtonWidgetState(
      courseName: courseName, tutors: tutors, startTime: startTime, endTime: endTime, location: location, idNum: idNum);
}

class _ActionButtonWidgetState extends State<ActionButtonWidget> {
  _ActionButtonWidgetState(
      {required this.courseName,
      required this.tutors,
      required this.startTime,
      required this.endTime,
      required this.location,
      required this.idNum});

  String courseName;
  String tutors;
  String startTime;
  String endTime;
  String location;
  String idNum;

  TextStyle changedStyle = TextStyle(color: Colors.orange, fontWeight: FontWeight.bold);
  TextStyle cancelledStyle =
      TextStyle(color: Colors.red, fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6, top: 7),
      child: Card(
        child: InkWell(
            onTap: () {},
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[],
                ))),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        elevation: 12,
      ),
    );
  }
}
