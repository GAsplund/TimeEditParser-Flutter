import 'package:flutter/material.dart';

import '../models/pathSelector.dart';

class PathSelectionPage extends StatefulWidget {
  final PathSelector selector;
  PathSelectionPage({@required this.selector});
  @override
  _PathSelectionPageState createState() => _PathSelectionPageState(selector: selector);
}

class _PathSelectionPageState extends State<PathSelectionPage> {
  final PathSelector selector;
  _PathSelectionPageState({@required this.selector});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select ${selector.pathType}"),
        ),
        body: FutureBuilder(
            future: selector.getPaths(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data[index].label),
                        onTap: () {
                          Navigator.pop(context, snapshot.data[index].path);
                        },
                      );
                    });
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}
