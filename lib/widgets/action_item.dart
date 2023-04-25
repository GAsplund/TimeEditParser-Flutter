import 'package:flutter/material.dart';

class ActionButtonWidget extends StatefulWidget {
  const ActionButtonWidget(
      {super.key,
      required this.courseName,
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
  State<ActionButtonWidget> createState() => _ActionButtonWidgetState();
}

class _ActionButtonWidgetState extends State<ActionButtonWidget> {
  TextStyle changedStyle = const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold);
  TextStyle cancelledStyle =
      const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6, top: 7),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        elevation: 12,
        child: InkWell(
            onTap: () {},
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: const <Widget>[],
                ))),
      ),
    );
  }
}
