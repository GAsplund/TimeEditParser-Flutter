import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<OrgSearchResult>> searchOrg(String term) async {
  if (term.isEmpty) return [];
  String queryLink = "https://www.timeedit.net/v1/search/web?term=$term";
  http.Response response = await http.get(Uri.parse(queryLink));
  List<OrgSearchResult> results = [];
  for (var result in json.decode(response.body)) {
    results.add(OrgSearchResult.fromJson(result));
  }
  return results;
  /*return [
    for (var result in results) result["id"]
  ];*/
}

class OrgSearchResult {
  OrgSearchResult({this.label, this.id, this.url});

  String label;
  String id;
  String url;

  factory OrgSearchResult.fromJson(Map<String, dynamic> json) {
    return OrgSearchResult(
      label: json['label'],
      id: json['id'],
      url: json['url'],
    );
  }
}
