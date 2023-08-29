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
  final _controller = ScrollController();

  int category = -1;
  bool isLoading = false;
  bool hasMore = true;
  int lazyLoadCount = 0;
  List<ScheduleObject> cachedObjects = [];

  @override
  void initState() {
    isLoading = true;
    hasMore = true;
    _controller.addListener(onScroll);
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
        body: SingleChildScrollView(
            controller: _controller,
            child: Column(
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
                            _clear();
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
                    ? ListView.builder(
                        itemCount: hasMore ? cachedObjects.length + 1 : cachedObjects.length,
                        itemBuilder: (context, index) {
                          if (index >= cachedObjects.length) {
                            return const Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          return ListTile(
                            title: Text(cachedObjects[index].name),
                            onTap: () => {
                              if (widget.onSelected != null) widget.onSelected!([cachedObjects[index]]),
                              Navigator.pop(context),
                            },
                          );
                        },
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                      )
                    : const Text("Select a category")
              ],
            )));
  }

  void onScroll() {
    if (_controller.position.atEdge) {
      if (_controller.position.pixels != 0 && !isLoading) {
        _lazyLoad();
      }
    }
  }

  void _clear() {
    setState(() {
      cachedObjects.clear();
      lazyLoadCount = 0;
      hasMore = true;
      _lazyLoad();
    });
  }

  void _lazyLoad() {
    print("Lazy loading");
    isLoading = true;
    widget.builder.getObjectsLazy([category], lazyLoadCount).then((List<ScheduleObject> fetchedList) {
      lazyLoadCount += fetchedList.length;
      if (fetchedList.isEmpty) {
        setState(() {
          isLoading = false;
          hasMore = false;
        });
      } else {
        setState(() {
          isLoading = false;
          cachedObjects.addAll(fetchedList);
        });
      }
    });
  }
}
