import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class TimeEditWeb {
  /// Gets a Schedule object from given parameters
  static Future<Map<String, dynamic>> getSchedule(String org, String entry, int id, List<String> objects) async {
    String url = "https://cloud.timeedit.net/$org/$entry/ri.json?sid=$id";

    // Add schedule objects
    url += "&objects=";
    for (String obj in objects) {
      url += "$obj,";
    }
    url = url.substring(0, url.length - 1);

    return jsonDecode(await _getURLRaw(url));
  }

  /// Gets a list of schedule objects from given parameters
  static getObjects(String org, String entry, List<int> categories, List<String> filters) {
    String url = "https://cloud.timeedit.net/$org/$entry/objects.html";
  }

  static getCategoriesAndFilters(String org, String entry) {
    String url = "https://cloud.timeedit.net/$org/$entry/ri.html";
  }

  /// Gets all available categories from given parameters
  static Map<String, int> getCategories(String org, String entry) {
    String url = "https://cloud.timeedit.net/$org/$entry/ri.html";
  }

  static _getCategories(dom.Document doc) {}

  static List<dom.Element> getFilters(String org, String entry) {
    String url = "https://cloud.timeedit.net/$org/$entry/ri.html";
  }

  static _getFilters(dom.Document doc) {}

  static Future<String> _getURLRaw(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    return response.body;
  }

  static Future<dom.Document> _getURLDOM(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    return parser.parse(response);
  }
}
