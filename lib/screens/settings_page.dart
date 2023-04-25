import 'package:flutter/material.dart';
import 'package:timeedit_parser/utilities/settings.dart' as settings;
import 'package:timeedit_parser/utilities/theming.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.theming});

  final Theming theming;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: ListView(children: [
          const Text("Settings"),
          /*SwitchListTile(
        value: true,
        title: Text(
          "Dark Theme",
        ),
        onChanged: (bool value) {},
      ),*/
          ListTile(
            title: const Text("Theme"),
            trailing: DropdownButton(
              value: settings.currentTheme.index.toString(),
              items: [
                DropdownMenuItem(
                  value: "2",
                  child: RichText(
                      text: TextSpan(style: Theme.of(context).textTheme.bodyLarge, children: const [
                    WidgetSpan(
                        child: Padding(padding: EdgeInsets.symmetric(horizontal: 2.0), child: Icon(Icons.wb_sunny))),
                    TextSpan(text: "Light")
                  ])),
                ),
                DropdownMenuItem(
                  value: "1",
                  child: RichText(
                      text: TextSpan(style: Theme.of(context).textTheme.bodyLarge, children: const [
                    WidgetSpan(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.0), child: Icon(Icons.wb_incandescent))),
                    TextSpan(text: "Dark")
                  ])),
                ),
                DropdownMenuItem(
                  value: "0",
                  child: RichText(
                      text: TextSpan(style: Theme.of(context).textTheme.bodyLarge, children: const [
                    WidgetSpan(
                        child: Padding(padding: EdgeInsets.symmetric(horizontal: 2.0), child: Icon(Icons.settings))),
                    TextSpan(text: "System")
                  ])),
                ),
              ],
              onChanged: (String? value) {
                if (value == null) return;
                settings.setCurrentTheme(ThemeMode.values[int.tryParse(value) ?? 0], widget.theming);
                setState(() {});
              },
            ),
          )
        ]));
  }
}
