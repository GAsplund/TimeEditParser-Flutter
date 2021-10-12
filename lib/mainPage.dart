import 'package:flutter/material.dart';
import 'package:timeeditparser_flutter/testingPage.dart';
import 'package:timeeditparser_flutter/util/theming.dart';
import 'schedulePage.dart';
import 'homePage.dart';
import 'settingsPage.dart';

class MainPage extends StatefulWidget {
  MainPage({this.theming});

  final Theming theming;

  @override
  _MainPageState createState() => _MainPageState(theming: theming);
}

class _MainPageState extends State<MainPage> {
  _MainPageState({this.theming});
  Theming theming;

  Widget body = HomePage();
  String appBarText = "Home";
  @override
  Widget build(BuildContext context) {
    setScreen(int index) {
      setState(() {
        switch (index) {
          case 0:
            body = HomePage();
            appBarText = "Home";
            break;
          case 1:
            body = SchedulePage();
            appBarText = "Schedule";
            break;
          case 3:
            body = SettingsPage(theming: theming);
            appBarText = "Settings";
            break;
          case 5:
            body = TestingPage();
            appBarText = "Testing Page";
            break;
          default:
            body = HomePage();
            appBarText = "Home";
            break;
        }
      });
    }

    return Scaffold(
        body: body,
        appBar: AppBar(title: Text(appBarText)),
        drawer: Drawer(
            child: Center(
                child: ListView(
          children: <Widget>[
            Container(
                height: 80,
                child: DrawerHeader(
                    child: Text(
                      "TimeEditParser",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    decoration: BoxDecoration(color: Colors.blue))),
            ListTile(
                title: RichText(
                    text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                  WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0), child: Icon(Icons.home))),
                  TextSpan(text: "Home")
                ])),
                onTap: () {
                  Navigator.pop(context);
                  setScreen(0);
                }),
            ListTile(
                title: RichText(
                    text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                  WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0), child: Icon(Icons.calendar_today))),
                  TextSpan(text: "Schedule")
                ])),
                onTap: () {
                  Navigator.pop(context);
                  setScreen(1);
                }),
            ListTile(
                title: RichText(
                    text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                  WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0), child: Icon(Icons.settings))),
                  TextSpan(text: "Settings")
                ])),
                onTap: () {
                  Navigator.pop(context);
                  setScreen(3);
                }),
            ListTile(
                title: RichText(
                    text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                  WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0), child: Icon(Icons.info))),
                  TextSpan(text: "About")
                ])),
                onTap: () {
                  Navigator.pop(context);
                  setScreen(4);
                }),
            ListTile(
                title: RichText(
                    text: TextSpan(style: Theme.of(context).textTheme.bodyText1, children: [
                  WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0), child: Icon(Icons.device_unknown))),
                  TextSpan(text: "Test")
                ])),
                onTap: () {
                  Navigator.pop(context);
                  setScreen(5);
                })
          ],
        ))));
  }
}
