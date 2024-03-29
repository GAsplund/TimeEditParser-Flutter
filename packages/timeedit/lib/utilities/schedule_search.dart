import 'package:timeedit/models/organization.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:timeedit/models/search_filter.dart';
import 'package:timeedit/models/filter_category.dart';
import 'package:timeedit/models/schedule.dart';

class ScheduleSearch extends Organization {
  ScheduleSearch({required String orgName, required this.listPath, required this.schedulePath}) : super(orgName: orgName);
  String schedulePath;
  String listPath;

  String getLink() {
    return "${super.linkbase}${super.orgName}/web/$listPath/$schedulePath.html";
  }

  // Function to get the filters for the current schedule search page.
  // Accomplishes this through web scraping the search page.
  Future<List<FilterCategory>> getFilters() async {
    // Make sure that link is valid
    if (!Uri.parse(getLink()).isAbsolute) return [];

    http.Response response = await http.get(Uri.parse(getLink()));
    dom.Document document = parser.parse(response.body);

    List<FilterCategory> filterCategories = [];

    dom.Element? filtersList = document.querySelector("#fancytypeselector");

    if (filtersList == null) return [];

    // Example match: <form id="fancyformfieldsearch" name="fancyformfieldsearch" data-loadselected="f">
    dom.Element? filtersLists = document.querySelector("#fancyformfieldsearch");

    for (dom.Element filterOption in filtersList.querySelectorAll("option")) {
      filterCategories.add(FilterCategory.fromDomElement(filterOption, filtersLists!));
    }
    return filterCategories;
  }

  // Gets every result group according to the entered filters.
  Future<Map<String, String>> getGroups(String filters, bool useCache /* = true*/) async {
    // Initiate variables
    if (!useCache /*|| !Application.Current.Properties.ContainsKey("groupsCache")*/) {
      Map<String, String> groups = <String, String>{};

      http.Response response = await http.get(Uri.parse(linkbase + orgName + "/web/$listPath/objects.html?fr=t&partajax=t&sid=3&im=f" + filters));
      dom.Document document = parser.parse(response.body);

      // Select divs with classes clickable2 and searchObject
      List<dom.Element> groupElements = document.querySelectorAll(".clickable2.searchObject");
      if (groupElements.isEmpty) return <String, String>{};

      for (dom.Element groupElement in groupElements) {
        groups[groupElement.attributes["data-name"] ?? ""] = groupElement.attributes["data-id"] ?? "";
      }

      return groups;
    } else {
      // Return cache for groups
      // TODO: Pull from cache
      // return Application.Current.Properties["groupsCache"];
      return <String, String>{};
    }
  }

  // Gets all the possible filters for the search page.
  Future<Map<String, String>> getSearchFilters(FilterCategory items, List<SearchFilter> filters) async {
    //String link = "https://cloud.timeedit.net/chalmers/web/public/" /*ApplicationSettings.LinkBase*/ + "objects.html?" + "fr=t&partajax=t&im=f&sid=3&l=sv_SE";
    String filtersText = "&types=" + items.value;

    for (SearchFilter filter in filters) {
      filtersText += "&" + filter.dataParam + "=" + filter.dataPrefix + ".";
      filter.options.forEach((key, value) {
        filtersText += value + ",";
      });
    }

    return getGroups(filtersText, false);
  }

  factory ScheduleSearch.fromSchedule(Schedule schedule) {
    return ScheduleSearch(orgName: schedule.orgName, listPath: schedule.entryPath, schedulePath: schedule.schedulePath);
  }
}
