import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timeedit/objects/category.dart';
import 'package:timeedit/objects/schedule_object.dart';
import 'package:timeedit/utilities/schedule_builder.dart';

class ScheduleObjectSelector extends StatefulWidget {
  final Function(List<ScheduleObject>)? onSelected;
  final ScheduleBuilder builder;

  const ScheduleObjectSelector({super.key, this.onSelected, required this.builder});

  @override
  // ignore: library_private_types_in_public_api
  _ScheduleObjectSelectorState createState() => _ScheduleObjectSelectorState();
}

class _ScheduleObjectSelectorState extends State<ScheduleObjectSelector> {
  int category = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select Schedule Object"),
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
            const Text("Category"),
            FutureBuilder(
              future: widget.builder.getCategories(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (category == -1) category = snapshot.data!.first.id;
                  return DropdownButton<int>(
                    value: category,
                    onChanged: (int? newValue) {
                      setState(() {
                        category = newValue!;
                      });
                    },
                    items: snapshot.data!.map<DropdownMenuItem<int>>((Category cat) {
                      return DropdownMenuItem<int>(
                        value: cat.id,
                        child: Text(cat.name),
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return const CircularProgressIndicator();
              },
            ),
            const Text("Objects"),
            (category != -1)
                ? FutureBuilder(
                    future: widget.builder.getObjects([category]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(snapshot.data![index].name),
                              onTap: () => {
                                if (widget.onSelected != null) widget.onSelected!([snapshot.data![index]]),
                                Navigator.pop(context),
                              },
                            );
                          },
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      return const CircularProgressIndicator();
                    })
                : const Text("Select a category")
          ],
        ));
  }
}
