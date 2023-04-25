import 'package:flutter/material.dart';
import 'package:timeedit_parser/screens/settings_page.dart';
import 'package:timeedit_parser/utilities/theming.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.theming});
  final Theming theming;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            IconButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage(theming: widget.theming)),
                    ),
                icon: const Icon(Icons.settings))
          ],
        ),
        body: ListView(children: [
          Text("Hello, Gustaf!", style: Theme.of(context).textTheme.headlineMedium),
          const Text("Today, there are 0 bookings.")
        ]));
  }
}
