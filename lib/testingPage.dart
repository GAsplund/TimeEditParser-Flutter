import 'package:flutter/material.dart';
import 'package:timeeditparser_flutter/scheduleSearchPage.dart';

class TestingPage extends StatefulWidget {
  TestingPage();

  @override
  _TestingPageState createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ScheduleSearchPage());
  }
}
