import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:timeedit/models/link_list.dart';

class Organization {
  Organization({required this.orgName});
  final String linkbase = "https://cloud.timeedit.net/";

  final String orgName;

  // Function for getting the link for schedule using the group id and the link base
  String link() {
    return linkbase + orgName;
    //+ ApplicationSettings.LinkGroups.Values.join(",-1,");
  }

  Future<List<LinkList>> getEntrances() async {
    http.Response response = await http.get(Uri(path: "$linkbase$orgName/web/"));
    dom.Document document = parser.parse(response.body);

    // Get the DOM objects for the entrance links
    List<dom.Element> entries = document.getElementById("entrylist").children;

    List<LinkList> entrances = [];

    // Read the DOM objects into list
    for (dom.Element entry in entries) {
      // Check if the entry is protected. Do not add to results.
      // (No support for authentication)
      if (entry.getElementsByTagName(".lock").length > 0)
        continue;
      else {
        String description = entry.getElementsByClassName("text").first.text;
        String entrancePath = entry.attributes["href"].substring(orgName.length + 6, entry.attributes["href"].length - 1);
        entrances.add(LinkList(name: entry.text, description: description, entryPath: entrancePath, orgName: this.orgName));
      }
    }
    return entrances;
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
