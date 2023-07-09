import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:timeedit/objects/category.dart';
import 'package:timeedit/objects/org_entry.dart';
import 'package:timeedit/objects/page_entry.dart';
import 'package:timeedit/objects/schedule_object.dart';
import 'package:timeedit/utilities/org_start.dart';

const linkbase = "https://cloud.timeedit.net/";

/// A class for interacting with TimeEdit web endpoints.
class TimeEditWeb {
  /// Gets a Schedule object at [org]/[entry]/[pageId]
  /// using [objects] as filters.
  ///
  /// Returns a JSON object with the schedule.
  static Future<Map<String, dynamic>> getSchedule(
      String org, String entry, int pageId, List<ScheduleObject> objects) async {
    return await _getURLJSON(getScheduleURL(org, entry, pageId, objects));
  }

  static String getScheduleURL(String org, String entry, int pageId, List<ScheduleObject> objects) {
    String url = linkbase + "$org/web/$entry/ri.json?sid=$pageId";

    // Add schedule objects
    url += "&objects=";
    for (ScheduleObject obj in objects) {
      url += "${obj.id},";
    }
    url = url.substring(0, url.length - 1);

    return url;
  }

  /// Gets a list of schedule objects at [org]/[entry]/[pageId].
  ///
  /// Returns a list of up to 100 [ScheduleObject] that are the schedule objects.
  static Future<List<ScheduleObject>> getObjects(
      String org, String entry, int pageId, List<int> types, List<String> filters,
      {int max = 100, int start = 0}) async {
    String url = linkbase + "$org/web/$entry/objects.html?sid=$pageId&partajax=t&max=$max&start=$start";
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
    List<dom.Element> list = document.querySelectorAll(".searchObject");
    for (dom.Element element in list) {
      String id = element.attributes["data-id"]!;
      String name = element.attributes["data-name"]!;
      String type = element.attributes["data-type"]!;
      objects.add(ScheduleObject(name, id, type));
    }

    return objects;
  }

  /// Lazily gets a list of organisations given a [query] search.
  ///
  /// Returns a JSON object with the organisation results.
  static Future<Map<String, dynamic>> getObjectsLazy(String query, int start, int max) async {
    String url = "https://www.timeedit.net/v1/search/web?term=$query&start=$start&max=$max";
    return await _getURLJSON(url);
  }

  /// Gets all available categories from [org]/[entry]/[pageId]
  ///
  /// Returns a list of [Category] objects.
  static Future<List<Category>> getCategories(String org, String entry, int pageId) async {
    String url = linkbase + "$org/web/$entry/ri.html?sid=$pageId&objects=0";
    dom.Document document = await _getURLDOM(url);
    List<Category> categories = [];

    dom.Element? selector = document.querySelector("#fancytypeselector");
    if (selector != null) {
      for (dom.Element element in selector.children) {
        Category category = Category(int.parse(element.attributes["value"]!), element.text);
        categories.add(category);
      }
    }
    return categories;
  }

  /// Gets a list of page ids on [org]/[entry]
  ///
  /// Returns a list of [int] that are the page ids.
  static Future<List<PageEntry>> getPageIds(String org, String entry) async {
    String url = linkbase + "$org/web/$entry/s.html";
    List<PageEntry> pages = [];

    dom.Document document = await _getURLDOM(url);

    dom.Element? selector = document.querySelector("select#f0");
    if (selector == null) return pages;

    for (dom.Element element in selector.children) {
      String value = element.attributes["value"]!;
      String name = element.text.substring(value.length + 2);
      pages.add(PageEntry(entry, int.parse(value), name, ""));
    }
    return pages;
  }

  /// Gets a list of organisations given a [query] search.
  ///
  /// Returns a JSON object with the organisation results.
  static Future<List<OrgStart>> searchOrgs(String query) async {
    if (query.isEmpty) return [];

    String url = "https://www.timeedit.net/v1/search/web?term=$query";
    return (await _getURLJSON(url)).map<OrgStart>((e) => OrgStart.fromJSON(e)).toList();
  }

  /// Gets a list of entries on [org]
  static Future<List<OrgEntry>> getEntries(String org) async {
    String url = linkbase + "$org/web";
    List<OrgEntry> entries = [];

    // Get HTML
    dom.Document document = await _getURLDOM(url);

    // Get entries
    dom.Element? list = document.querySelector("#entrylist");
    if (list != null) {
      for (dom.Element entry in list.children) {
        String name = entry.text;
        String description = entry.querySelector("span")!.text;
        List<String> pathSplit = entry.attributes["href"]!.split("/");
        String path = pathSplit[pathSplit.length - 2];
        bool isLocked = entry.querySelector("img") != null;

        entries.add(OrgEntry(org, path, name, description, isLocked));
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

  static Future<dynamic> _getURLJSON(String url) async {
    return jsonDecode(await _getURLRaw(url));
  }
}
