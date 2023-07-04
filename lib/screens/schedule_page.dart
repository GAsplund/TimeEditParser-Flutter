import 'package:flutter/material.dart';
import 'package:timeedit/objects/schedule.dart';
import 'package:timeedit_parser/utilities/settings.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Color.fromARGB(255, 230, 230, 230),
        appBar: AppBar(title: const Text("Schedule")),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: FutureBuilder(
          future: currentBuilder.getSchedule(),
          builder: (BuildContext context, AsyncSnapshot<Schedule> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.bookings.isEmpty) {
                return const Center(child: Text("No bookings for this period"));
              }

              return ListView.builder(
                  itemCount: snapshot.data!.bookings.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        title: Text(snapshot.data!.bookings[index].headersData[0]),
                        subtitle: Text(snapshot.data!.userCustomName));
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
