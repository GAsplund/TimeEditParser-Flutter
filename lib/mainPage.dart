import 'package:flutter/material.dart';
import 'package:timeeditparser_flutter/scheduleListPage.dart';
import 'package:timeeditparser_flutter/testingPage.dart';
import 'package:timeeditparser_flutter/util/theming.dart';
import 'schedulePage.dart';
import 'homePage.dart';

class MainPage extends StatefulWidget {
  MainPage({this.theming});

  final Theming theming;

  @override
  _MainPageState createState() => _MainPageState(theming: theming);
}

class _MainPageState extends State<MainPage> {
  _MainPageState({this.theming});
  Theming theming;

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SchedulePage(),
    ScheduleListPage(),
    TestingPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.device_unknown),
            label: 'Test',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}

/*
Icons.home
Icons.calendar_today
Icons.settings
Icons.info
Icons.device_unknown
*/