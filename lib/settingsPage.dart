import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage();

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      Text("Settings"),
      SwitchListTile(
        value: true,
        title: Text(
          "Dark Theme",
        ),
        onChanged: (bool value) {},
      ),
      ListTile(
        title: Text("Theme"),
        trailing: DropdownButton(
          items: [
            DropdownMenuItem(
              key: Key("test"),
              value: "also test",
              child: RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                    WidgetSpan(
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(Icons.wb_sunny))),
                    TextSpan(text: "Light")
                  ])),
            ),
            DropdownMenuItem(
              key: Key("test"),
              value: "also test",
              child: RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                    WidgetSpan(
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(Icons.wb_incandescent))),
                    TextSpan(text: "Dark")
                  ])),
            ),
            DropdownMenuItem(
              key: Key("test"),
              value: "also test",
              child: RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                    WidgetSpan(
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(Icons.settings))),
                    TextSpan(text: "System")
                  ])),
            ),
          ],
          onChanged: (String value) {},
        ),
      )
    ]));
  }
}
