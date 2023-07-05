import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:timeedit/utilities/schedule_builder.dart';
import 'package:timeedit_parser/screens/schedule_builder_edit_page.dart';

class ScheduleBuilderCard extends StatefulWidget {
  const ScheduleBuilderCard({super.key, required this.builder});

  final ScheduleBuilder builder;

  @override
  State<ScheduleBuilderCard> createState() => _ScheduleBuilderCardState();
}

class _ScheduleBuilderCardState extends State<ScheduleBuilderCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 7),
        child: Card(
          child: ListTile(
              title: Text(widget.builder.getURL()),
              subtitle: const Text("Test"),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ScheduleBuilderEditPage(builder: widget.builder)))),
        ));
  }
}
