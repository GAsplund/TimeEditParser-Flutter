import 'package:flutter/material.dart';
import 'schedulePage.dart';
import 'homePage.dart';
import 'settingsPage.dart';

class MainPage extends StatefulWidget {
  MainPage();

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
            body = SettingsPage();
            appBarText = "Settings";
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
                    text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                      WidgetSpan(
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(Icons.home))),
                      TextSpan(text: "Home")
                    ])),
                onTap: () {
                  Navigator.pop(context);
                  setScreen(0);
                }),
            ListTile(
                title: RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                      WidgetSpan(
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(Icons.calendar_today))),
                      TextSpan(text: "Schedule")
                    ])),
                onTap: () {
                  Navigator.pop(context);
                  setScreen(1);
                }),
            ListTile(
                title: RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                      WidgetSpan(
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(Icons.content_paste))),
                      TextSpan(text: "Schedule Filters")
                    ])),
                onTap: () {
                  Navigator.pop(context);
                  setScreen(2);
                }),
            ListTile(
                title: RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                      WidgetSpan(
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(Icons.settings))),
                      TextSpan(text: "Settings")
                    ])),
                onTap: () {
                  Navigator.pop(context);
                  setScreen(3);
                }),
            ListTile(
                title: RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                      WidgetSpan(
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(Icons.info))),
                      TextSpan(text: "About")
                    ])),
                onTap: () {
                  Navigator.pop(context);
                  setScreen(4);
                })
          ],
        ))));
  }
}
