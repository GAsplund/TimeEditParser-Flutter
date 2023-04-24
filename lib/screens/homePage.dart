import 'package:flutter/material.dart';
import 'package:timeeditparser_flutter/screens/settingsPage.dart';
import 'package:timeeditparser_flutter/utilities/theming.dart';

class HomePage extends StatefulWidget {
  HomePage({@required this.theming});
  final Theming theming;

  @override
  _HomePageState createState() => _HomePageState(theming: this.theming);
}

class _HomePageState extends State<HomePage> {
  _HomePageState({@required this.theming});
  final Theming theming;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: [
            IconButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage(theming: theming)),
                    ),
                icon: const Icon(Icons.settings))
          ],
        ),
        body: ListView(children: [
          Text("Hello, Gustaf!", style: Theme.of(context).textTheme.headline4),
          Text("Today, there are 0 bookings.")
        ]));
  }
}
