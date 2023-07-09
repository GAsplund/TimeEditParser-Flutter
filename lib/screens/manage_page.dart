import 'package:flutter/material.dart';
import 'package:timeedit/utilities/schedule_builder.dart';
import 'package:timeedit_parser/utilities/settings.dart';
import 'package:timeedit_parser/widgets/schedule_builder_card.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({Key? key}) : super(key: key);

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Schedules")),
      body: Column(
        children: [
          Text("Current schedule", style: Theme.of(context).textTheme.titleLarge),
          ScheduleBuilderCard(builder: currentBuilder, onBuilderUpdated: saveCurrentBuilder),
          Text("Saved schedules", style: Theme.of(context).textTheme.titleLarge),
          Expanded(
            child: ListView.builder(
              itemCount: builders.length,
              itemBuilder: (context, index) {
                return ScheduleBuilderCard(
                    builder: builders[index], onBuilderUpdated: (builder) => saveBuilder(builder, index));
              },
            ),
          ),
        ],
      ),
    );
  }

  void saveCurrentBuilder(ScheduleBuilder builder) {
    currentBuilder = builder;
    setState(() {});
  }

  void saveBuilder(ScheduleBuilder builder, int index) {
    builders[index] = builder;
    setState(() {});
  }
}
