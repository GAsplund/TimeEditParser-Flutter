import 'package:flutter/material.dart';
import 'package:timeedit_parser/screens/org_search_page.dart';

class SchedulePathSelectorPage extends StatefulWidget {
  SchedulePathSelectorPage({super.key, required this.org, required this.entry, required this.pageId});

  final String org;
  final String entry;
  final int pageId;

  @override
  _SchedulePathSelectorPageState createState() => _SchedulePathSelectorPageState();
}

class _SchedulePathSelectorPageState extends State<SchedulePathSelectorPage> {
  String? org;
  String? entry;
  int? pageId;

  @override
  void initState() {
    super.initState();

    org = widget.org;
    entry = widget.entry;
    pageId = widget.pageId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select path")),
      body: Column(
        children: [
          // Org
          Card(
              child: ListTile(
            title: const Text("Organization"),
            subtitle: Text(org ?? ""),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OrgSearchPage())),
          )),
          // Entry
          Card(
              child: ListTile(
            title: const Text("Entry"),
            subtitle: Text(entry ?? ""),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SchedulePathSelectorPage(org: widget.org, entry: widget.entry, pageId: widget.pageId))),
          )),
          // Page ID
          Card(
              child: ListTile(
            title: const Text("Page ID"),
            subtitle: Text(pageId.toString()),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SchedulePathSelectorPage(org: widget.org, entry: widget.entry, pageId: widget.pageId))),
          )),
        ],
      ),
    );
  }
}
