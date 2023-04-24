import 'package:flutter/material.dart';
//import 'package:timeeditparser_flutter/screens/schedule_list_page.dart';
//import 'package:timeeditparser_flutter/screens/testing_page.dart';
import 'package:timeedit_parser/utilities/theming.dart';

import 'home_page.dart';
import 'schedule_page.dart';

class MainPage extends StatefulWidget {
  MainPage({required this.theming});

  final Theming theming;

  @override
  _MainPageState createState() => _MainPageState(theming: theming);
}

class _MainPageState extends State<MainPage> {
  _MainPageState({required this.theming});
  Theming theming;
  List<Widget> _widgetOptions = [];

  int _selectedIndex = 0;
  @override
  void initState() {
    _widgetOptions = <Widget>[
      HomePage(
        theming: theming,
      ),
      SchedulePage(),
      SchedulePage(),
      SchedulePage()
    ];
    super.initState();
  }

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
