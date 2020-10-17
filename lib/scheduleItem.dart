import 'package:flutter/material.dart';

class LessonScheduleWidget extends StatefulWidget {
  LessonScheduleWidget({@required this.courseName, @required this.tutors, @required this.startTime, @required this.endTime, @required this.location, @required this.idNum});

  final String courseName;
  final String tutors;
  final String startTime;
  final String endTime;
  final String location;
  final String idNum;

  @override
  _LessonScheduleWidgetState createState() => _LessonScheduleWidgetState(courseName: courseName, tutors: tutors, startTime: startTime, endTime: endTime, location: location, idNum: idNum);
}

class _LessonScheduleWidgetState extends State<LessonScheduleWidget> {
  _LessonScheduleWidgetState({@required this.courseName, @required this.tutors, @required this.startTime, @required this.endTime, @required this.location, @required this.idNum});

  String courseName;
  String tutors;
  String startTime;
  String endTime;
  String location;
  String idNum;

  TextStyle changedStyle = TextStyle(color: Colors.orange, fontWeight: FontWeight.bold);
  TextStyle cancelledStyle = TextStyle(color: Colors.red, fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough);

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
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Column(
                          children: [
                            Text(startTime),
                            Text("|", style: Theme.of(context).textTheme.caption),
                            Text(endTime)
                          ],
                        )),
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(courseName, style: Theme.of(context).textTheme.headline6),
                                            Padding(padding: const EdgeInsets.only(left: 8), child: Text(location))
                                          ],
                                        ),
                                        Text("ID: " + idNum)
                                      ],
                                    )),
                                Padding(padding: const EdgeInsets.only(bottom: 5), child: Text(tutors))
                              ],
                            ))),
                  ],
                ))),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        elevation: 12,
      ),
    );
  }
}
