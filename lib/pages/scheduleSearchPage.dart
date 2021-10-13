import 'package:flutter/material.dart';
import 'package:timeeditparser_flutter/objects/filter.dart';
import 'package:timeeditparser_flutter/objects/filterCategory.dart';
import 'package:timeeditparser_flutter/objects/schedule.dart';
import 'package:timeeditparser_flutter/util/scheduleSearch.dart';

class ScheduleSearchPage extends StatefulWidget {
  ScheduleSearchPage({this.schedule});

  final Schedule schedule;

  @override
  _ScheduleSearchPageState createState() => _ScheduleSearchPageState(schedule: schedule);
}

class _ScheduleSearchPageState extends State<ScheduleSearchPage> {
  _ScheduleSearchPageState({this.schedule});
  Schedule schedule;
  ScheduleSearch search;

  @override
  void initState() {
    super.initState();
    search = ScheduleSearch.fromSchedule(schedule);
  }

  Map<String, String> selectedFilters() => schedule.groups;
  Map<String, List<String>> filterCategories = new Map<String, List<String>>();
  List<FilterCategory> categoryCache;
  String currentCategory;

  Future<List<Widget>> getSelectedTags() async {
    List<Widget> selectedTags = [];
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
    if (categoryCache == null) categoryCache = await search.getFilters();
    List<FilterCategory> filterCategoriesLocal = new List.from(categoryCache);
    FilterCategory category = filterCategoriesLocal.firstWhere((element) => element.name == currentCategory, orElse: () => null);
    if (category == null) return [];

    List<SearchFilter> filters = new List.from(category.filters);
    filters.removeWhere((filter) => !filterCategories[category.value].any((currentselectedcategory) => currentselectedcategory.startsWith(filter.dataParam + filter.dataPrefix)));
    List<SearchFilter> newFilters = [];
    filters.forEach((filter) {
      Map<String, String> selectedOptions = new Map<String, String>();
      filter.options.forEach((key, value) {
        if (filterCategories[category.value].any((element) => element.endsWith(key + value))) selectedOptions[key] = value;
      });
      SearchFilter newFilter = new SearchFilter();
      newFilter.dataName = filter.dataName;
      newFilter.dataParam = filter.dataParam;
      newFilter.dataPrefix = filter.dataPrefix;
      newFilter.options = selectedOptions;
      newFilters.add(newFilter);
      //filter.options.removeWhere((key, value) => !filterCategories[category.value].any((element) => element.endsWith(key + value)))
    });

    List<Widget> widgets = [];
    Map<String, String> results = await search.getSearchFilters(category, newFilters);
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
    List<FilterCategory> categories = await search.getFilters();
    categories.forEach((element) {
      element.filters.clear();
    });
    return categories;
  }

  Future<List<Widget>> getFilterChips() async {
    List<FilterCategory> categories = (categoryCache != null) ? categoryCache : await search.getFilters();
    if (categoryCache == null) categoryCache = categories;
    List<Widget> filterRowWidgets = [];
    List<Widget> typeWidgets = [];
    for (FilterCategory cat in categories) {
      if (!filterCategories.containsKey(cat.value)) filterCategories[cat.value] = [];
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
        for (SearchFilter filter in cat.filters) {
          List<Widget> filterWidgets = [];
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
      Wrap(
        children: typeWidgets,
        alignment: WrapAlignment.spaceBetween,
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
          return;
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
