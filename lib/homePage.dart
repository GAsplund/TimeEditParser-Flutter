import 'package:flutter/material.dart';
import 'package:timeeditparser_flutter/util/scheduleParser.dart';
import 'schedulePage.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      Text("Hello, Gustaf!", style: Theme.of(context).textTheme.headline4),
      RaisedButton(
        child: Text("Try to update schedule"),
        onPressed: () {
          getSchedule();
        },
      ),
      Text("Your Schedule for Today:"),
      SchedulePage()
    ]));
  }
}
