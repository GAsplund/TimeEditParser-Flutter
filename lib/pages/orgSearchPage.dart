import 'dart:async';

import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:timeeditparser_flutter/util/orgSearch.dart' as search;

class OrgSearch extends SearchDelegate<String> {
  Timer _debounce;

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
              showSuggestions(context);
            }
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildSuggestions(BuildContext context) => FutureBuilder<List<Map<String, String>>>(
        future: _onSearchChanged(query),
        builder: (context, snapshot) {
          if (query.isEmpty) return buildNoSuggestions();

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError || snapshot.data.isEmpty) {
                return buildNoSuggestions();
              } else {
                return buildSuggestionsSuccess(snapshot.data);
              }
          }
        },
      );

  Widget buildNoSuggestions() => Center(
        child: Text(
          'No suggestions!',
          style: TextStyle(fontSize: 28),
        ),
      );

  Widget buildSuggestionsSuccess(List<Map<String, String>> suggestions) => ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final queryText = suggestion["label"].substring(0, query.length);
          final remainingText = suggestion["label"].substring(query.length);

          return ListTile(
            onTap: () {
              query = suggestion["id"];

              // 1. Show Results
              //showResults(context);

              // 2. Close Search & Return Result
              close(context, suggestion["id"]);

              // 3. Navigate to Result Page
              //  Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (BuildContext context) => ResultPage(suggestion),
              //   ),
              // );
            },
            leading: Icon(Icons.group),
            // title: Text(suggestion),
            title: RichText(
              text: TextSpan(
                text: queryText,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).textTheme.bodyText1.color),
                children: [
                  TextSpan(
                    text: remainingText,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18, color: Theme.of(context).textTheme.subtitle1.color),
                  ),
                ],
              ),
            ),
          );
        },
      );

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  void close(BuildContext context, String result) {
    _debounce?.cancel();
    super.close(context, result);
  }

  final debouncer = Debouncer<String>(Duration(milliseconds: 500), initialValue: "");

  Future<List<Map<String, String>>> _onSearchChanged(String query) async {
    debouncer.value = query;
    return await search.searchOrg(await debouncer.nextValue);
  }
}
