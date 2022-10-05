import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:timeedit/objects/category.dart';

const linkbase = "https://cloud.timeedit.net/";

/// A class for interacting with TimeEdit web endpoints.
class TimeEditWeb {
  /// Gets a Schedule object at [org]/[entry]/[pageId]
  /// using [objects] as filters.
  ///
  /// Returns a JSON object with the schedule.
  static Future<Map<String, dynamic>> getSchedule(String org, String entry, int pageId, List<String> objects) async {
    String url = linkbase + "$org/$entry/ri.json?sid=$pageId";

    // Add schedule objects
    url += "&objects=";
    for (String obj in objects) {
      url += "$obj,";
    }
    url = url.substring(0, url.length - 1);

    return jsonDecode(await _getURLRaw(url));
  }

  /// Gets a list of schedule objects at [org]/[entry]/[pageId].
  ///
  /// Returns a list of [String] that are the schedule objects.
  static List<String> getObjects(String org, String entry, List<int> categories, List<String> filters) {
    String url = linkbase + "$org/$entry/objects.html";
    return [];
  }

  /// Gets all available categories from [org]/[entry]/[pageId]
  ///
  /// Returns a list of [Category] objects.
  static List<Category> getCategories(String org, String entry, int pageId) {
    String url = linkbase + "$org/$entry/ri.html?sid=$pageId";
    return [];
  }

  /// Gets a list of page ids on [org]/[entry]
  ///
  /// Returns a list of [int] that are the page ids.
  static List<int> getPageIds(String org, String entry) {
    String url = linkbase + "$org/$entry/s.html";
    return [];
  }

  /// Gets a list of organisations given a [query] search.
  ///
  /// Returns a JSON object with the organisation results.
  static Future<Map<String, dynamic>> searchOrgs(String query) async {
    String url = "https://www.timeedit.net/v1/search/web?term=$query";
    return jsonDecode(await _getURLRaw(url));
  }

  static Future<String> _getURLRaw(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    return response.body;
  }

  static Future<dom.Document> _getURLDOM(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    return parser.parse(response);
  }
}
