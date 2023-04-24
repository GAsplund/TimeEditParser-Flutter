import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

class LessonScheduleWidget extends StatefulWidget {
  LessonScheduleWidget(
      {required this.name,
      required this.tutors,
      required this.startTime,
      required this.endTime,
      required this.location,
      required this.idNum});

  final String name;
  final String tutors;
  final String startTime;
  final String endTime;
  final String location;
  final String idNum;

  @override
  _LessonScheduleWidgetState createState() => _LessonScheduleWidgetState(
      name: name, tutors: tutors, startTime: startTime, endTime: endTime, location: location, idNum: idNum);
}

class _LessonScheduleWidgetState extends State<LessonScheduleWidget> {
  _LessonScheduleWidgetState(
      {required this.name,
      required this.tutors,
      required this.startTime,
      required this.endTime,
      required this.location,
      required this.idNum});

  String name;
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
        child: ExpansionTileCard(
          trailing: SizedBox.shrink(),
          contentPadding: const EdgeInsets.all(3),
          initialElevation: 12,
          elevation: 12,
          title: Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Column(
                    children: [Text(startTime), Text("|", style: Theme.of(context).textTheme.caption), Text(endTime)],
                  )),
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          name,
                          style: Theme.of(context).textTheme.headline6,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(bottom: 5), child: Text(tutors))
                    ],
                  )),
            ],
          ),
          children: [Padding(padding: const EdgeInsets.only(left: 8), child: Text(location)), Text("ID: " + idNum)],
        )

        /*Card(
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
                                  child: Text(
                                    name,
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                  //Padding(padding: const EdgeInsets.only(left: 8), child: Text(location)),
                                  //Text("ID: " + idNum)
                                ),
                                Padding(padding: const EdgeInsets.only(bottom: 5), child: Text(tutors))
                              ],
                            ))),
                  ],
                )),
            borderRadius: BorderRadius.circular(10)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 12,
      ),*/
        );
  }
}
