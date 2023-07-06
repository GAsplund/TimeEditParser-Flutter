import 'package:flutter/material.dart';

class OrgSearchPage extends StatefulWidget {
  const OrgSearchPage({Key? key}) : super(key: key);

  @override
  _OrgSearchPageState createState() => _OrgSearchPageState();
}

class _OrgSearchPageState extends State<OrgSearchPage> {
  String searchTerm = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: "Search organizations..."),
          onChanged: (value) => setState(() {
            searchTerm = value;
          }),
        )),
        body: FutureBuilder(builder: (context, snapshot) {
          return ListView.builder(
            itemCount: 2,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text("Org$index"),
                  onTap: () => Navigator.pop(context),
                ),
              );
            },
          );
        }));
  }
}
