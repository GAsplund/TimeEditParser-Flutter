import 'package:flutter/material.dart';
import 'package:timeedit/objects/org_entry.dart';
import 'package:timeedit/objects/page_entry.dart';

/// Page for selecting a page ID from an org and entry
class PageIdSelectorPage extends StatefulWidget {
  final String org;
  final String entry;
  final int? pageId;
  final Function(int)? onIdSelected;

  const PageIdSelectorPage({super.key, required this.org, required this.entry, this.pageId, this.onIdSelected});

  @override
  _PageIdSelectorPageState createState() => _PageIdSelectorPageState();
}

class _PageIdSelectorPageState extends State<PageIdSelectorPage> {
  OrgEntry? entry;
  int? pageId;

  @override
  void initState() {
    super.initState();

    entry = OrgEntry(widget.org, widget.entry, "", "", false);
    pageId = widget.pageId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Select page ID")),
        body: Column(
          children: [
            FutureBuilder(
              future: entry!.getIds(),
              builder: (BuildContext context, AsyncSnapshot<List<PageEntry>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(child: Text("No entries found"));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          child: ListTile(
                              title: Text(snapshot.data![index].name),
                              subtitle: Text(snapshot.data![index].id.toString()),
                              onTap: () => {
                                    if (widget.onIdSelected != null) {widget.onIdSelected!(snapshot.data![index].id)},
                                    Navigator.pop(context)
                                  }));
                    },
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          ],
        ));
  }
}
