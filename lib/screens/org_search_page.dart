import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timeedit/utilities/org_start.dart';

class OrgSearchPage extends StatefulWidget {
  final Function(String)? onOrgSelected;

  const OrgSearchPage({super.key, this.onOrgSelected});

  @override
  _OrgSearchPageState createState() => _OrgSearchPageState();
}

class _OrgSearchPageState extends State<OrgSearchPage> {
  Timer? _timer;
  String searchTerm = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: "Search organizations..."),
          onChanged: _onSearchChanged,
        )),
        body: FutureBuilder(
            future: OrgStart.search(searchTerm),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(snapshot.data![index].org),
                      onTap: () => {
                        if (widget.onOrgSelected != null) widget.onOrgSelected!(snapshot.data![index].org),
                        Navigator.pop(context)
                      },
                    ),
                  );
                },
              );
            }));
  }

  void _onSearchChanged(String value) {
    _timer?.cancel();
    _timer = Timer(
        const Duration(milliseconds: 500),
        () => setState(() {
              searchTerm = value;
            }));
  }
}
