import 'package:flutter/material.dart';
import 'package:timeedit_parser/screens/org_entry_selector_page.dart';
import 'package:timeedit_parser/screens/org_search_page.dart';
import 'package:timeedit_parser/screens/page_id_selector_page.dart';

class SchedulePathSelectorPage extends StatefulWidget {
  SchedulePathSelectorPage(
      {super.key, required this.org, required this.entry, required this.pageId, this.onPathSelected});

  final String org;
  final String entry;
  final int pageId;
  final Function(String, String, int)? onPathSelected;

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
      appBar: AppBar(
        title: const Text("Edit path"),
        actions: [
          IconButton(
              onPressed: () => {
                    if (widget.onPathSelected != null) {widget.onPathSelected!(org!, entry!, pageId!)},
                    Navigator.pop(context)
                  },
              icon: const Icon(Icons.check, color: Colors.white))
        ],
      ),
      body: Column(
        children: [
          // Org
          Card(
              child: ListTile(
            title: const Text("Organization"),
            subtitle: Text(org ?? ""),
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrgSearchPage(onOrgSelected: setOrg))),
          )),
          // Entry
          Card(
              child: ListTile(
            title: const Text("Entry"),
            subtitle: Text(entry ?? ""),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrgEntrySelectorPage(org: org!, entry: entry, onEntrySelected: setEntry))),
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
                        PageIdSelectorPage(org: org!, entry: entry!, pageId: pageId, onIdSelected: setPageId))),
          )),
        ],
      ),
    );
  }

  void setOrg(String org) {
    setState(() {
      this.org = org;
      entry = null;
      pageId = null;
    });
  }

  void setEntry(String entry) {
    setState(() {
      this.entry = entry;
      pageId = null;
    });
  }

  void setPageId(int pageId) {
    setState(() {
      this.pageId = pageId;
    });
  }
}
