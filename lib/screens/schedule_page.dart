import 'package:flutter/material.dart';

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
        body: const Text("Placeholder"));
  }
}
