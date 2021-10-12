import 'package:flutter/material.dart';

class TestingPage extends StatefulWidget {
  TestingPage();

  @override
  _TestingPageState createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Text(
              "There was an error",
              style: TextStyle(fontSize: 28),
            )),
        Padding(padding: const EdgeInsets.only(top: 2), child: Text("You can try reloading the schedule")),
        Padding(
            padding: const EdgeInsets.only(top: 14),
            child: ElevatedButton(
              child: Text('Reload', style: TextStyle(fontSize: 20)),
              onPressed: () => setState(() {}),
            ))
      ],
    )));
  }
}
