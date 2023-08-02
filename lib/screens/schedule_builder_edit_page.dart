import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeedit/objects/filter_query.dart';
import 'package:timeedit/objects/schedule_object.dart';
import 'package:timeedit/objects/timeedit_date.dart';
import 'package:timeedit/utilities/schedule_builder.dart';
import 'package:timeedit_parser/screens/schedule_object_selector.dart';
import 'package:timeedit_parser/screens/schedule_path_selector_page.dart';
import 'package:timeedit_parser/widgets/schedule_time_selector.dart';

class ScheduleBuilderEditPage extends StatefulWidget {
  const ScheduleBuilderEditPage({super.key, required this.builder, this.onBuilderUpdated});

  final Function(ScheduleBuilder)? onBuilderUpdated;
  final ScheduleBuilder builder;

  @override
  State<ScheduleBuilderEditPage> createState() => _ScheduleBuilderEditPageState();
}

class _ScheduleBuilderEditPageState extends State<ScheduleBuilderEditPage> {
  ScheduleBuilder? currentBuilder;
  List<ScheduleObject> objects = [];
  List<FilterQuery> filters = [];

  @override
  void initState() {
    super.initState();

    currentBuilder = widget.builder;
    objects = widget.builder.objects;
    filters = widget.builder.filters;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Schedule"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => {
              if (widget.onBuilderUpdated != null) widget.onBuilderUpdated!(currentBuilder!),
              Navigator.pop(context),
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Schedule path
          Card(
              child: ListTile(
            title: const Text("Path"),
            subtitle: Text("${currentBuilder!.org}/${currentBuilder!.entry}/${currentBuilder!.pageId}"),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SchedulePathSelectorPage(
                          org: currentBuilder!.org,
                          entry: currentBuilder!.entry,
                          pageId: currentBuilder!.pageId,
                          onPathSelected: setPath,
                        ))),
          )),
          // Objects
          Card(
              child: ListTile(
            title: const Text("Objects"),
            subtitle: Text("${objects.length.toString()} active"),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScheduleObjectSelector(builder: currentBuilder!, onSelected: setObjects))),
          )),
          // Start
          ScheduleTimeSelector(title: "Start Time", onTimeChanged: setStartTime),
          // End
          ScheduleTimeSelector(title: "End Time", onTimeChanged: setStartTime),
          // URL
          Card(
              child: ListTile(
            title: const Text("Copy URL"),
            onTap: () => {
              Clipboard.setData(ClipboardData(text: currentBuilder!.getURL())),
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Copied URL to clipboard"),
                  duration: Duration(seconds: 1),
                ),
              )
            },
          )),
        ],
      ),
    );
  }

  void setPath(String org, String entry, int pageId) {
    setState(() {
      currentBuilder = ScheduleBuilder(org, entry, pageId, filters);
      currentBuilder!.objects = objects;
    });
  }

  void setObjects(List<ScheduleObject> objects) {
    setState(() {
      currentBuilder!.objects = objects;
      this.objects = objects;
    });
  }

  void setStartTime(TimeEditDate date) {
    setState(() {
      currentBuilder!.startDate = date;
    });
  }

  void setEndTime(TimeEditDate date) {
    setState(() {
      currentBuilder!.endDate = date;
    });
  }
}
