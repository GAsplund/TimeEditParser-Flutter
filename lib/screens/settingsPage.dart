import 'package:flutter/material.dart';
import 'package:timeeditparser_flutter/util/settings.dart' as settings;
import 'package:timeeditparser_flutter/util/theming.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({this.theming});

  final Theming theming;

  @override
  _SettingsPageState createState() => _SettingsPageState(theming: theming);
}

class _SettingsPageState extends State<SettingsPage> {
  _SettingsPageState({@required this.theming});
  Theming theming;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      Text("Settings"),
      /*SwitchListTile(
        value: true,
        title: Text(
          "Dark Theme",
        ),
        onChanged: (bool value) {},
      ),*/
      ListTile(
        title: Text("Theme"),
        trailing: DropdownButton(
          value: settings.currentTheme.index.toString(),
          items: [
            DropdownMenuItem(
              value: "2",
              child: RichText(
                  text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0), child: Icon(Icons.wb_sunny))),
                TextSpan(text: "Light")
              ])),
            ),
            DropdownMenuItem(
              value: "1",
              child: RichText(
                  text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0), child: Icon(Icons.wb_incandescent))),
                TextSpan(text: "Dark")
              ])),
            ),
            DropdownMenuItem(
              value: "0",
              child: RichText(
                  text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0), child: Icon(Icons.settings))),
                TextSpan(text: "System")
              ])),
            ),
          ],
          onChanged: (String value) {
            settings.setCurrentTheme(ThemeMode.values[int.tryParse(value)], theming);
            setState(() {});
          },
        ),
      )
    ]));
  }
}
