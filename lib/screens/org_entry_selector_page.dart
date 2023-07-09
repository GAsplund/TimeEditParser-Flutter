import 'package:flutter/material.dart';
import 'package:timeedit/objects/org_entry.dart';
import 'package:timeedit/utilities/org_start.dart';

/// Page for selecting an entry from an organization
class OrgEntrySelectorPage extends StatefulWidget {
  final String org;
  final String? entry;
  final Function(String)? onEntrySelected;
  const OrgEntrySelectorPage({super.key, required this.org, this.entry, this.onEntrySelected});

  @override
  _OrgEntrySelectorPageState createState() => _OrgEntrySelectorPageState();
}

class _OrgEntrySelectorPageState extends State<OrgEntrySelectorPage> {
  OrgStart? org;
  String? entry;

  @override
  void initState() {
    super.initState();

    org = OrgStart(widget.org);
    entry = widget.entry;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select entry")),
      body: Column(
        children: [
          // Entry
          FutureBuilder(
            future: org!.getEntries(),
            builder: (BuildContext context, AsyncSnapshot<List<OrgEntry>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Center(child: Text("No entries found"));
                }
                List<OrgEntry> entries = snapshot.data!.where((element) => !element.isLocked).toList();

                return ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: ListTile(
                      title: Text(entries[index].name),
                      subtitle: Text(entries[index].description),
                      onTap: () => {
                        if (widget.onEntrySelected != null) {widget.onEntrySelected!(entries[index].entry)},
                        Navigator.pop(context)
                      },
                    ));
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
      ),
    );
  }
}
