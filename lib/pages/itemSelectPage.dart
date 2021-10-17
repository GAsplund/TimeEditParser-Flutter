import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemSelectPage extends StatefulWidget {
  ItemSelectPage({@required this.items});
  List<List<String>> items;

  @override
  _ItemSelectPageState createState() => _ItemSelectPageState(items: this.items);
}

class _ItemSelectPageState extends State<ItemSelectPage> {
  _ItemSelectPageState({@required this.items});

  List<List<String>> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        for (List<String> item in items)
          Card(
            child: InkWell(
              child: Column(
                children: [
                  Text(item[0]),
                  Text(item[1])
                ],
              ),
              onTap: () => Navigator.pop(context, item[2]),
            ),
          )
      ],
    ));
  }
}
