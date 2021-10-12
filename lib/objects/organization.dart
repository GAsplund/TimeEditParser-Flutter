import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:timeeditparser_flutter/objects/filter.dart';
import 'package:timeeditparser_flutter/objects/filterCategory.dart';

class Organization {
  Organization({@required this.orgName});
  final String linkbase = "https://cloud.timeedit.net/";

  final String orgName;

  // Function for getting the link for schedule using the group id and the link base
  String link() {
    return linkbase + orgName;
    //+ ApplicationSettings.LinkGroups.Values.join(",-1,");
  }

  Future<Map<String, String>> getLinks() async {
    http.Response response = await http.get("$linkbase$orgName/");
    dom.Document document = parser.parse(response.body);

    // Select object under div id entrylist
    /*
    <a class="items" href="/chalmers/web/public/">
      Öppen schemavisning <span class="text"> Public schedule search (no authentication required)</span>
    </a>
    */
    // TODO: Parse elements properly into links
    List<dom.Element> linkElements = document.querySelector("#entrylist").children;
  }

  // TODO: Move to a class that turns the filters into Chips
  /*Future<List<Widget>> filterChips() async {
    return filtersToChips(await getFilters("https://cloud.timeedit.net/chalmers/web/public/"));
  }

  List<Widget> filtersToChips(List<FilterCategory> categories) {
    List<Widget> widgets = [];
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
  }*/
}
