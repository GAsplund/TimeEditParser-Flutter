import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:timeeditparser_flutter/objects/schedule.dart';
import 'package:timeeditparser_flutter/scheduleModifyPage.dart';
import 'package:timeeditparser_flutter/util/settings.dart';
import 'util/scheduleParser.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage();

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  Schedule schedule = Settings.currentSchedule;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Color.fromARGB(255, 230, 230, 230),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: FutureBuilder(
            future: getScheduleWidgets(schedule),
            builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
              if (snapshot.hasData) {
                return ListView(children: snapshot.data);
              } else if (snapshot.hasError) {
                return Text("Error");
              } else {
                return Center(
                    child: Container(
                  child: CircularProgressIndicator(),
                  alignment: AlignmentDirectional(0.0, 0.0),
                ));
              }
            }),
        floatingActionButton: SpeedDial(animatedIcon: AnimatedIcons.menu_close, animatedIconTheme: IconThemeData(size: 22.0), child: Icon(Icons.calendar_today), children: [
          SpeedDialChild(child: Icon(Icons.refresh), backgroundColor: Colors.red, label: 'Refresh', labelStyle: TextStyle(fontSize: 18.0), onTap: () => setState(() {})),
          SpeedDialChild(
            child: Icon(Icons.edit),
            backgroundColor: Colors.blue,
            label: 'Modify Schedule',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => _modifySchedule(context),
          ),
          SpeedDialChild(
            child: Icon(Icons.add),
            backgroundColor: Colors.green,
            label: 'Add Schedule',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => showBottomSheet(
                context: context,
                builder: (context) {
                  return ScheduleModifyPage(newSchedule: true);
                }),
          ),
        ]));
  }

  _modifySchedule(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ScheduleModifyPage(
                editedSchedule: schedule ?? new Schedule(),
                newSchedule: false,
              )),
    );

    schedule = (result is Schedule) ? result : schedule;
  }
}
