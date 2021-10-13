import 'package:flutter/material.dart';

import 'package:timeeditparser_flutter/util/settings.dart' as settings;
import 'package:timeeditparser_flutter/objects/schedule.dart';
//import 'package:timeeditparser_flutter/scheduleListPage.dart';
//import 'schedulePage.dart';
//import 'util/scheduleSearch.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Schedule schedule = settings.currentSchedule;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: ListView(children: [
          Text("Hello, Gustaf!", style: Theme.of(context).textTheme.headline4),
          Text("Today, there are 0 bookings.")
        ]));
  }
}
