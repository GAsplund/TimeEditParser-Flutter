import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:timeedit/models/schedule.dart';
import 'package:timeeditparser_flutter/screens/scheduleListPage.dart';
import 'package:timeeditparser_flutter/screens/scheduleModifyPage.dart';
import 'package:timeeditparser_flutter/utilities/schedule_parser.dart';
import 'package:timeeditparser_flutter/utilities/settings.dart' as settings;

class SchedulePage extends StatefulWidget {
  SchedulePage();

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  Schedule schedule = settings.currentSchedule;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Color.fromARGB(255, 230, 230, 230),
        appBar: AppBar(title: Text("Schedule")),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: (_validScheduleSettings())
            ? FutureBuilder(
                future: getScheduleWidgets(schedule),
                builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext bContext, int index) {
                        return snapshot.data[index];
                      },
                    );
                  } else if (snapshot.hasError) {
                    return _buildScheduleError(false);
                  } else {
                    return Center(
                        child: Container(
                      child: CircularProgressIndicator(),
                      alignment: AlignmentDirectional(0.0, 0.0),
                    ));
                  }
                })
            : _buildScheduleError(true),
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
            label: 'Select Schedule',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => showBottomSheet(
                context: context,
                builder: (context) {
                  return ScheduleListPage();
                }),
          ),
        ]));
  }

  bool _validScheduleSettings() {
    // Perform a basic check if the properties of the schedule are correctly set
    return schedule.orgName != null && schedule.entryPath != null && schedule.schedulePath != null && schedule.groups.isNotEmpty;
  }

  Widget _buildScheduleError(bool invalidSettings) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Text(
              invalidSettings ? "Invalid settings" : "There was an error",
              style: TextStyle(fontSize: 28),
            )),
        Padding(padding: const EdgeInsets.only(top: 2), child: Text(invalidSettings ? "Check your settings in schedule management" : "You can try reloading the schedule")),
        Padding(
            padding: const EdgeInsets.only(top: 14),
            child: ElevatedButton(
              child: Text('Reload', style: TextStyle(fontSize: 20)),
              onPressed: () => setState(() {}),
            ))
      ],
    ));
  }

  _modifySchedule(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text("Modify Schedule"),
              ),
              body: ScheduleModifyPage(
                editedSchedule: schedule ?? new Schedule(),
                newSchedule: false,
              ))),
    );

    settings.currentSchedule = (result is Schedule) ? result : schedule;
    schedule = settings.currentSchedule;
  }
}
