import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<Map<String, String>>> searchOrg(String term) async {
  if (term.isEmpty) return [];
  String queryLink = "https://www.timeedit.net/v1/search/web?term=$term";
  http.Response response = await http.get(queryLink);
  List<Map<String, String>> results = [];
  for (var result in json.decode(response.body)) {
    results.add(Map.castFrom<dynamic, dynamic, String, String>(result));
  }
  return results;
  /*return [
    for (var result in results) result["id"]
  ];*/
}
