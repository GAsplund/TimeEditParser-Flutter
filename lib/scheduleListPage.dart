import 'package:flutter/material.dart';
import 'package:timeeditparser_flutter/scheduleModifyPage.dart';

class ScheduleListPage extends StatefulWidget {
  ScheduleListPage();

  @override
  _ScheduleListPageState createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            Text("")
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showBottomSheet(
                  context: context,
                  builder: (context) {
                    return ScheduleModifyPage(
                      newSchedule: true,
                    );
                  });
            },
            child: Icon(Icons.add)));
  }
}
