import 'package:flutter/material.dart';
import 'package:timeedit/utilities/schedule_builder.dart';
import 'package:timeeditparser_flutter/screens/scheduleNewPage.dart';
import 'package:timeeditparser_flutter/screens/scheduleModifyPage.dart';
import 'package:timeeditparser_flutter/utilities/settings.dart' as settings;

class ScheduleListPage extends StatefulWidget {
  ScheduleListPage();

  @override
  _ScheduleListPageState createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  List<ScheduleBuilder> builders = [];
  ScheduleBuilder currentSchedule = settings.currentBuilder;

  @override
  Widget build(BuildContext context) {
    builders = settings.builders;
    List<Widget> scheduleItems = [];
    for (int i = 0; i < builders.length; i++) {
      scheduleItems.add(new Card(
          elevation: 4,
          child: InkWell(
            onTap: () => _modifySchedule(context, builders[i], i),
            child: Padding(child: Text(/*builders[i].userCustomName*/ "TestName", style: Theme.of(context).textTheme.headline6), padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12)),
          )));
      scheduleItems.add(new ElevatedButton(
          onPressed: () {
            settings.currentBuilder = builders[i];
            setState(() {
              currentSchedule = settings.currentBuilder;
            });
          },
          child: Text("Set as main")));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule Management"),
        actions: [
          IconButton(onPressed: () => _addBuilder(context), icon: const Icon(Icons.add))
        ],
      ),
      body: ListView(
        children: <Widget>[
          Text("Active Schedule"),
          Card(
              elevation: 4,
              child: InkWell(
                onTap: () => (currentSchedule == null) ? null : _modifyCurrentSchedule(context, settings.currentBuilder),
                child: Padding(child: Text((currentSchedule == null) ? "No schedule" : "TestName" /*currentSchedule.userCustomName*/, style: Theme.of(context).textTheme.headline6), padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12)),
              )),
          Text("Other Schedules"),
          ...scheduleItems
        ],
      ),
    );
  }

  _addBuilder(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScheduleNewPage(newSchedule: true)),
    );

    if (result is ScheduleBuilder) {
      builders.add(result);
      settings.schedules = builders;
    }
  }

  _modifySchedule(BuildContext context, ScheduleBuilder builder, int schedulesIndex) async {
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

    if (result is ScheduleBuilder) builders[schedulesIndex] = result;
  }

  _modifyCurrentSchedule(BuildContext context, ScheduleBuilder builder) async {
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

    if (result is ScheduleBuilder) settings.currentBuilder = result;
  }
}
