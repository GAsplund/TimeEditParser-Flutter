//import 'dart:html';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timeeditparser_flutter/objects/schedule.dart';
import 'package:timeeditparser_flutter/util/orgSearch.dart' as search;

class OrgSearchPage extends StatefulWidget {
  @override
  _OrgSearchPageState createState() => _OrgSearchPageState();
}

class _OrgSearchPageState extends State<OrgSearchPage> {
  Schedule editedSchedule;
  String orgName;
  Timer _debounce;

  @override
  Widget build(BuildContext context) {
    editedSchedule ??= new Schedule();

    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, editedSchedule);
          return;
        },
        child: Scaffold(
            body: Column(
          children: [
            Center(
                child: Flexible(
                    child: Card(
                        elevation: 4,
                        child: Row(
                          children: [
                            Padding(padding: const EdgeInsets.all(8), child: Text("Organization")),
                            Flexible(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: TextField(
                                      controller: new TextEditingController(text: orgName),
                                      onChanged: _onSearchChanged,
                                      onSubmitted: (value) {
                                        orgName = value;
                                        setState(() {});
                                      },
                                    ))),
                          ],
                        ))))
          ],
        )));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      await search.searchOrg(query);
      // TODO: Do something with the query results
    });
  }
}
