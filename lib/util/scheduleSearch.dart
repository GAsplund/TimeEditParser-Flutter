import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:timeeditparser_flutter/objects/filter.dart';
import 'package:timeeditparser_flutter/objects/filterCategory.dart';

Future<Map<String, String>> getGroups(String link, bool useCache /* = true*/) async {
  // Initiate variables
  if (!useCache /*|| !Application.Current.Properties.ContainsKey("groupsCache")*/) {
    Map<String, String> groups = new Map<String, String>();
    http.Response response = await http.get(link /*+ "objects.html?fr=t&partajax=t&im=f&sid=3&l=sv_SE&types=183"*/);
    dom.Document document = parser.parse(response.body);
    // Select divs with classes clickable2 and searchObject
    List<dom.Element> groupElements = document.querySelectorAll(".clickable2.searchObject");
    if (groupElements.length == 0) return new Map<String, String>();
    for (dom.Element groupElement in groupElements) {
      groups[groupElement.attributes["data-name"]] = groupElement.attributes["data-id"];
    }
    return groups;
  } else {
    // Return cache for groups
    return new Map<String, String>();
    //return Application.Current.Properties["groupsCache"];
  }
}

Future<List<FilterCategory>> getFilters(String link) async {
  if (!Uri.parse(link).isAbsolute) return new List<FilterCategory>();
  http.Response response = await http.get(link + "ri1Q7.html");
  dom.Document document = parser.parse(response.body);
  List<FilterCategory> filterCategories = new List<FilterCategory>();
  dom.Element filtersList = document.querySelector("#fancytypeselector");
  if (filtersList == null) return new List<FilterCategory>();
  for (dom.Element filterOption in filtersList.querySelectorAll("option")) {
    //SearchFilterMultiChoice currentCategory = new SearchFilterMultiChoice();
    // <option value="183" selected="">Klass</option>
    FilterCategory filterCategory = new FilterCategory();
    filterCategory.name = filterOption.text;
    filterCategory.value = filterOption.attributes["value"];

    // <form id="fancyformfieldsearch" name="fancyformfieldsearch" data-loadselected="f">
    dom.Element filtersLists = document.querySelector("#fancyformfieldsearch");

    // <fieldset id="ffset183" class="fancyfieldset  fancyNoBorder">
    dom.Element filterCollectionNode = filtersLists.querySelector("#ffset" + filterCategory.value);

    // <select class="fancyformfieldsearchselect objectFieldsParam " multiple="" size="14" data-param="fe" data-tefieldkind="CATEGORY" data-name="Period" name="183_22" data-prefix="22" id="ff183_22">
    List<dom.Element> filterSelectionNodes = filterCollectionNode.querySelectorAll("select");

    if (filterSelectionNodes.length == 0) {
      filterCategories.add(filterCategory);
      continue;
    }

    for (dom.Element filterSelectionNode in filterSelectionNodes) {
      Filter filter = new Filter();
      filter.dataName = filterSelectionNode.attributes["data-name"];
      filter.dataParam = filterSelectionNode.attributes["data-param"];
      filter.dataPrefix = filterSelectionNode.attributes["data-prefix"];

      // <option value="10/11">10/11</option>
      for (dom.Element filterCheckNode in filterSelectionNode.querySelectorAll("option")) {
        filter.options[filterCheckNode.text] = filterCheckNode.attributes["value"];
      }
      filterCategory.filters.add(filter);
    }
    filterCategories.add(filterCategory);
  }
  return filterCategories;
}

Future<Map<String, String>> searchFilters(FilterCategory items, List<Filter> filters) async {
  String link = "https://cloud.timeedit.net/alingsas_ny/web/schemasok/" /*ApplicationSettings.LinkBase*/ + "objects.html?" + "fr=t&partajax=t&im=f&sid=3&l=sv_SE";
  link += "&types=" + items.value;

  filters.forEach((filter) {
    link += "&" + filter.dataParam + "=" + filter.dataPrefix + ".";
    filter.options.forEach((key, value) {
      link += value + ",";
    });
  });

  /*items.forEach((paramKey, paramValue) {
    paramValue.forEach((dataKey, dataValue) {
      link += "&" + paramKey + "=";
      for (String item in dataValue) {
        link += dataKey + "." + item;
      }
    });
  });*/
  //string itemsString = dataPrefix + "." + string.Join(",", items);
  //link += "&" + param + "=" + itemsString;
  return getGroups(link, false);
}

// Function for getting the link for schedule using the group id and the link base
String scheduleLink(String linkbase) {
  if (!linkbase.endsWith("/")) {
    linkbase += "/";
  }
  return linkbase + "ri.html?sid=3&bl=b&ds=f&objects=";
  //+ ApplicationSettings.LinkGroups.Values.join(",-1,");
}

Future<List<Widget>> filterChips() async {
  return filtersToChips(await getFilters("https://cloud.timeedit.net/alingsas_ny/web/schemasok/"));
}

List<Widget> filtersToChips(List<FilterCategory> categories) {
  List<Widget> widgets = new List<Widget>();
  for (FilterCategory cat in categories) {
    widgets.add(Padding(
        padding: const EdgeInsets.only(left: 8),
        child: ChoiceChip(
          label: Text(cat.name),
          selected: false,
          onSelected: (value) => {},
        )));
  }
  return widgets;
}
