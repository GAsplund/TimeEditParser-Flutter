import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:timeedit/objects/category.dart';
import 'package:timeedit/objects/org_entry.dart';
import 'package:timeedit/objects/schedule_object.dart';

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

    return await _getURLJSON(url);
  }

  /// Gets a list of schedule objects at [org]/[entry]/[pageId].
  ///
  /// Returns a list of [ScheduleObject] that are the schedule objects.
  static Future<List<ScheduleObject>> getObjects(
      String org, String entry, int pageId, List<int> types, List<String> filters) async {
    String url = linkbase + "$org/$entry/objects.html?sid=$pageId&partajax=t";
    List<ScheduleObject> objects = [];

    // Add types
    url += "&types=";
    for (int type in types) {
      url += "$type,";
    }
    url = url.substring(0, url.length - 1);

    // TODO: Add filters

    dom.Document document = await _getURLDOM(url);

    // Get all objects
    dom.Element? list = document.querySelector(".searchObject");
    if (list != null) {
      for (dom.Element element in list.children) {
        String id = element.attributes["data-id"]!;
        String name = element.attributes["data-name"]!;
        String type = element.attributes["data-type"]!;
        objects.add(ScheduleObject(id, name, type));
      }
    }

    return objects;
  }

  /// Gets all available categories from [org]/[entry]/[pageId]
  ///
  /// Returns a list of [Category] objects.
  static List<Category> getCategories(String org, String entry, int pageId) {
    String url = linkbase + "$org/$entry/ri.html?sid=$pageId&objects=0";
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
    return await _getURLJSON(url);
  }

  /// Gets a list of entries on [org]
  static Future<List<OrgEntry>> getEntries(String org) async {
    String url = linkbase + "$org/s.html";
    List<OrgEntry> entries = [];

    // Get HTML
    dom.Document document = await _getURLDOM(url);

    // Get entries
    dom.Element? list = document.querySelector("#entrylist");
    if (list != null) {
      for (dom.Element entry in list.children) {
        String name = entry.querySelector("a")!.text;
        String description = entry.querySelector("span")!.text;
        String link = entry.querySelector("a")!.attributes["href"]!;
        bool isLocked = entry.querySelector("img") != null;
        entries.add(OrgEntry(name, description, link, isLocked));
      }
    }

    return entries;
  }

  static Future<String> _getURLRaw(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    return response.body;
  }

  static Future<dom.Document> _getURLDOM(String url) async {
    return parser.parse(await _getURLRaw(url));
  }

  static Future<Map<String, dynamic>> _getURLJSON(String url) async {
    return jsonDecode(await _getURLRaw(url));
  }
}
