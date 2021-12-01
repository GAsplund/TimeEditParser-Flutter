import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:timeedit/models/organization.dart';

class LinkList extends Organization {
  LinkList({required String orgName, required this.entryPath, required this.name, required this.description}) : super(orgName: orgName);
  String name;
  String description;
  String entryPath;

  Future<List<List<String>>> getLinks() async {
    http.Response response = await http.get(Uri(path: "$linkbase$orgName/web/$entryPath"));
    dom.Document document = parser.parse(response.body);

    // Get the DOM objects for the link entries
    List<dom.Element> entries = document.getElementsByClassName("leftlistcolumn").first.getElementsByTagName("a");

    List<List<String>> entrances = [];

    // Read the DOM objects into list
    for (dom.Element entry in entries) {
      String name = entry.getElementsByClassName("greenlink").first.innerHtml;
      String description = entry.getElementsByClassName("linklistsubtext").first.innerHtml;
      String destPath = entry.attributes["href"]!.substring(orgName.length + entryPath.length + 7, entry.attributes["href"]!.length - 5);
      entrances.add([
        name,
        description,
        destPath
      ]);
    }
    return entrances;
  }
}
