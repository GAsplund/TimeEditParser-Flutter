import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:timeedit/objects/schedule.dart';
import 'package:timeedit/utilities/schedule_builder.dart';
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
  ScheduleBuilder builder = settings.currentBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Color.fromARGB(255, 230, 230, 230),
        appBar: AppBar(title: Text("Schedule")),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: (builder == null)
            ? _buildNoSchedule()
            : ((_validScheduleSettings())
                ? FutureBuilder(
                    future: builder.getSchedule(),
                    builder: (BuildContext context, AsyncSnapshot<Schedule> snapshot) {
                      if (snapshot.hasData) {
                        List<Widget> widgets = getScheduleWidgets(snapshot.data);
                        return ListView.builder(
                          itemCount: widgets.length,
                          itemBuilder: (BuildContext bContext, int index) {
                            return widgets[index];
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
                : _buildScheduleError(true)),
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
    if (builder == null) {
      return false;
    }
    return builder.org != null && builder.entry != null /*&& builder.url != null*/ && builder.objects.isNotEmpty;
  }

  Widget _buildNoSchedule() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("No schedule selected", style: Theme.of(context).textTheme.headline4),
          Text("Please select a schedule to view it here.")
        ],
      ),
    );
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
                editedBuilder: builder,
                newBuilder: false,
              ))),
    );

    settings.currentBuilder = (result is Schedule) ? result : builder;
    builder = settings.currentBuilder;
  }
}
