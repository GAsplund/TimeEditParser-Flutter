import 'package:flutter/material.dart';
import 'package:timeedit/objects/absolute_date.dart';
import 'package:timeedit/objects/relative_date.dart';
import 'package:timeedit/objects/timeedit_date.dart';
import 'package:date_time_picker/date_time_picker.dart';

class ScheduleTimeSelector extends StatefulWidget {
  const ScheduleTimeSelector({Key? key, required this.title, this.onTimeChanged}) : super(key: key);

  final String title;
  final Function(TimeEditDate)? onTimeChanged;

  @override
  _ScheduleTimeSelectorState createState() => _ScheduleTimeSelectorState();
}

class _ScheduleTimeSelectorState extends State<ScheduleTimeSelector> {
  int dateType = 3;

  RelativeDateType relativeType = RelativeDateType.week;
  int relativeLength = 3;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(widget.title),
        subtitle: const Text("Test"),
        children: [
          Column(children: [
            DropdownButton(
              value: dateType,
              items: const [
                DropdownMenuItem(value: 3, child: Text("Now")),
                DropdownMenuItem(value: 1, child: Text("At")),
                DropdownMenuItem(value: 2, child: Text("In")),
              ],
              onChanged: (value) => setState(() {
                dateType = value as int;
              }),
            ),
            if (dateType == 1)
              DateTimePicker(
                  initialValue: DateTime.now().toString(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  onChanged: onDateChanged)
            else if (dateType == 2)
              Column(children: [
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(() {
                    relativeLength = int.tryParse(value) ?? 0;
                    onRelativeDateChanged();
                  }),
                ),
                DropdownButton(
                    value: relativeType,
                    items: const [
                      DropdownMenuItem(value: RelativeDateType.hour, child: Text("hours")),
                      DropdownMenuItem(value: RelativeDateType.day, child: Text("days")),
                      DropdownMenuItem(value: RelativeDateType.week, child: Text("weeks")),
                      DropdownMenuItem(value: RelativeDateType.month, child: Text("months")),
                    ],
                    onChanged: (value) => setState(() {
                          relativeType = value as RelativeDateType;
                          onRelativeDateChanged();
                        }))
              ]),
          ])
        ],
      ),
    );
  }

  void onDateChanged(String time) {
    final date = DateTime.parse(time);
    final timeEditDate = TimeEditAbsoluteDate.fromDateTime(date);
    widget.onTimeChanged?.call(timeEditDate);
  }

  void onRelativeDateChanged() {
    final date = TimeEditRelativeDate(length: relativeLength, type: relativeType);
    widget.onTimeChanged?.call(date);
  }
}
