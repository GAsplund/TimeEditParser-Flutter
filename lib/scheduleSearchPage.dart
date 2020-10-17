import 'package:flutter/material.dart';

import 'package:timeeditparser_flutter/util/scheduleSearch.dart' as search;

import 'objects/filter.dart';
import 'objects/filterCategory.dart';
import 'objects/schedule.dart';

class ScheduleSearchPage extends StatefulWidget {
  ScheduleSearchPage({this.schedule});

  final Schedule schedule;

  @override
  _ScheduleSearchPageState createState() => _ScheduleSearchPageState(schedule: schedule);
}

class _ScheduleSearchPageState extends State<ScheduleSearchPage> {
  _ScheduleSearchPageState({this.schedule});
  Schedule schedule;
  Map<String, String> selectedFilters() => schedule.groups;
  Map<String, List<String>> filterCategories = new Map<String, List<String>>();
  List<FilterCategory> categoryCache;
  String currentCategory;

  Future<List<Widget>> getSelectedTags() async {
    List<Widget> selectedTags = new List<Widget>();
    selectedFilters().forEach((key, value) {
      selectedTags.add(Chip(
        label: Text(value),
        deleteIcon: Icon(Icons.cancel),
        onDeleted: () {
          selectedFilters().remove(key);
          setState(() {});
        },
      ));
    });
    return selectedTags;
  }

  Future<List<Widget>> getSearchResults() async {
    if (categoryCache == null) categoryCache = await search.getFilters("https://cloud.timeedit.net/alingsas_ny/web/schemasok/");
    List<FilterCategory> filterCategoriesLocal = new List.from(categoryCache);
    FilterCategory category = filterCategoriesLocal.firstWhere((element) => element.name == currentCategory, orElse: () => null);
    if (category == null) return new List<Widget>();

    List<Filter> filters = new List.from(category.filters);
    filters.removeWhere((filter) => !filterCategories[category.value].any((currentselectedcategory) => currentselectedcategory.startsWith(filter.dataParam + filter.dataPrefix)));
    List<Filter> newFilters = new List<Filter>();
    filters.forEach((filter) {
      Map<String, String> selectedOptions = new Map<String, String>();
      filter.options.forEach((key, value) {
        if (filterCategories[category.value].any((element) => element.endsWith(key + value))) selectedOptions[key] = value;
      });
      Filter newFilter = new Filter();
      newFilter.dataName = filter.dataName;
      newFilter.dataParam = filter.dataParam;
      newFilter.dataPrefix = filter.dataPrefix;
      newFilter.options = selectedOptions;
      newFilters.add(newFilter);
      //filter.options.removeWhere((key, value) => !filterCategories[category.value].any((element) => element.endsWith(key + value)))
    });

    List<Widget> widgets = new List<Widget>();
    Map<String, String> results = await search.searchFilters(category, newFilters);
    results.forEach((key, value) {
      widgets.add(FilterChip(
        label: Text(key),
        onSelected: (sel) {
          if (sel && !selectedFilters().containsKey(value))
            selectedFilters()[value] = key;
          else if (!sel && selectedFilters().containsKey(value)) selectedFilters().remove(value);
          setState(() {});
        },
        selected: selectedFilters().containsKey(value),
      ));
    });
    return [
      ExpansionTile(
        expandedAlignment: Alignment.center,
        title: Text("Results [" + widgets.length.toString() + " items]"),
        children: [
          Wrap(
            children: widgets,
            alignment: WrapAlignment.spaceBetween,
          )
        ],
      )
    ];
  }

  Future<List<FilterCategory>> getEmptyFilters() async {
    List<FilterCategory> categories = await search.getFilters(schedule.linksbase);
    categories.forEach((element) {
      element.filters.clear();
    });
    return categories;
  }

  Future<List<Widget>> getFilterChips() async {
    List<FilterCategory> categories = (categoryCache != null) ? categoryCache : await search.getFilters(schedule.linksbase);
    if (categoryCache == null) categoryCache = categories;
    List<Widget> filterRowWidgets = new List<Widget>();
    List<Widget> typeWidgets = new List<Widget>();
    for (FilterCategory cat in categories) {
      if (!filterCategories.containsKey(cat.value)) filterCategories[cat.value] = new List<String>();
      typeWidgets.add(Padding(
          padding: const EdgeInsets.only(left: 8),
          child: ChoiceChip(
            label: Text(cat.name),
            selected: cat.name == currentCategory,
            onSelected: (value) {
              if (cat.name != currentCategory) {
                currentCategory = cat.name;
                setState(() {});
              }
            },
          )));
      if (cat.name == currentCategory) {
        for (Filter filter in cat.filters) {
          List<Widget> filterWidgets = new List<Widget>();
          filter.options.forEach((key, optValue) {
            filterWidgets.add(Padding(
                padding: const EdgeInsets.only(left: 8),
                child: FilterChip(
                  label: Text(key),
                  onSelected: (bool value) {
                    if (value && !filterCategories[cat.value].contains(filter.dataParam + filter.dataPrefix + key + optValue)) {
                      filterCategories[cat.value].add(filter.dataParam + filter.dataPrefix + key + optValue);
                      setState(() {});
                    } else if (!value && filterCategories[cat.value].contains(filter.dataParam + filter.dataPrefix + key + optValue)) {
                      filterCategories[cat.value].remove(filter.dataParam + filter.dataPrefix + key + optValue);
                      setState(() {});
                    }
                  },
                  selected: filterCategories[cat.value].contains(filter.dataParam + filter.dataPrefix + key + optValue),
                  elevation: 0,
                )));
          });
          filterRowWidgets.add(ExpansionTile(
            expandedAlignment: Alignment.center,
            title: Text(filter.dataName),
            children: [
              Wrap(
                children: filterWidgets,
                alignment: WrapAlignment.spaceBetween,
              )
            ],
          ));
        }
      }
    }
    return [
      Row(
        children: typeWidgets,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: filterRowWidgets,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, schedule);
        },
        child: Scaffold(
            body: ListView(
          children: [
            Text("Choices"),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder(
                    future: getSelectedTags(),
                    builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                      if (snapshot.hasData) {
                        return Column(children: snapshot.data);
                      } else if (snapshot.hasError) {
                        return Text("Error");
                      } else {
                        return Center(
                            child: Container(
                          child: CircularProgressIndicator(),
                          alignment: AlignmentDirectional(0.0, 0.0),
                        ));
                      }
                    }),
              ],
            ),
            Divider(),
            Text("Type"),
            FutureBuilder(
                future: getFilterChips(),
                builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                  if (snapshot.hasData) {
                    return Column(children: snapshot.data);
                  } else if (snapshot.hasError) {
                    return Text("Error");
                  } else {
                    return Center(
                        child: Container(
                      child: CircularProgressIndicator(),
                      alignment: AlignmentDirectional(0.0, 0.0),
                    ));
                  }
                }),
            FutureBuilder(
                future: getSearchResults(),
                builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                  if (snapshot.hasData) {
                    return Column(children: snapshot.data);
                  } else if (snapshot.hasError) {
                    return Text("Error");
                  } else {
                    return Center(
                        child: Container(
                      child: CircularProgressIndicator(),
                      alignment: AlignmentDirectional(0.0, 0.0),
                    ));
                  }
                }),
          ],
        )));
  }
}
