import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeedit/objects/filter_query.dart';
import 'package:timeedit/objects/schedule_object.dart';
import 'package:timeedit/utilities/schedule_builder.dart';
import 'package:timeedit_parser/screens/schedule_object_selector.dart';
import 'package:timeedit_parser/screens/schedule_path_selector_page.dart';

class ScheduleBuilderEditPage extends StatefulWidget {
  const ScheduleBuilderEditPage({super.key, required this.builder});

  final ScheduleBuilder builder;

  @override
  State<ScheduleBuilderEditPage> createState() => _ScheduleBuilderEditPageState();
}

class _ScheduleBuilderEditPageState extends State<ScheduleBuilderEditPage> {
  String org = "";
  String entry = "";
  int pageId = 0;
  List<ScheduleObject> objects = [];
  List<FilterQuery> filters = [];

  @override
  void initState() {
    super.initState();

    org = widget.builder.org;
    entry = widget.builder.entry;
    pageId = widget.builder.pageId;
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
              //currentBuilder = widget.builder,
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
            subtitle: Text("${widget.builder.org}/${widget.builder.entry}/${widget.builder.pageId}"),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SchedulePathSelectorPage(
                        org: widget.builder.org, entry: widget.builder.entry, pageId: widget.builder.pageId))),
          )),
          // Objects
          Card(
              child: ListTile(
            title: const Text("Objects"),
            subtitle: Text("${objects.length.toString()} active"),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScheduleObjectSelector(builder: widget.builder, onSelected: setObjects))),
          )),
          // URL
          Card(
              child: ListTile(
            title: const Text("Copy URL"),
            onTap: () => {
              Clipboard.setData(ClipboardData(text: widget.builder.getURL())),
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

  void setObjects(List<ScheduleObject> objects) {
    setState(() {
      this.objects = objects;
    });
  }
}
