import 'package:timeedit/objects/category.dart';

import '../objects/filter.dart';
import '../objects/schedule.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class TimeEditWeb {
  static Schedule getSchedule(String org, String entry, int id, List<String> objects) {
    String url = "https://cloud.timeedit.net/$org/$entry/ri.json?sid=$id";

    // Add schedule objects
    url += "&objects=";
    for (String obj in objects) {
      url += "$obj,";
    }
    url = url.substring(0, url.length - 1);
  }

  static getObjects(String org, String entry, List<int> categories, List<Filter> filters) {
    String url = "https://cloud.timeedit.net/$org/$entry/objects.html";
  }

  static getCategoriesAndFilters(String org, String entry) {
    String url = "https://cloud.timeedit.net/$org/$entry/ri.html";
  }

  static getCategories(String org, String entry) {
    String url = "https://cloud.timeedit.net/$org/$entry/ri.html";
  }

  static _getCategories() {}

  static List<dom.Element> getFilters(String org, String entry) {
    String url = "https://cloud.timeedit.net/$org/$entry/ri.html";
  }

  static _getFilters() {}

  static Future<dom.Document> _getURL(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    return parser.parse(response.body);
  }
}
