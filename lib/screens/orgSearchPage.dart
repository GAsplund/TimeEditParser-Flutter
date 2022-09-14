import 'dart:async';

import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:timeeditparser_flutter/utilities/orgSearch.dart' as search;

class _OrgSearchPageState extends State<OrgSearchPage> {
  final _debouncer = Debouncer<String>(Duration(milliseconds: 500), initialValue: "");
  List<search.OrgSearchResult> searchResults = [];
  String searchQuery = "";
  bool searching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Search for organization"),
        ),
        body: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: "Enter organization name..."),
              onChanged: (value) {
                searchQuery = value;
                _search();
              },
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      return Card(
                          elevation: 4,
                          child: InkWell(
                            onTap: () => _selectOrg(context, searchResults[index]),
                            child: Padding(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(searchResults[index].label),
                                    Text(searchResults[index].id, style: Theme.of(context).textTheme.caption)
                                  ],
                                ),
                                padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12)),
                          ));
                    }))
          ],
        ));
  }

  _search() async {
    setState(() {
      searching = true;
    });
    _debouncer.value = searchQuery;
    searchResults = await search.searchOrg(await _debouncer.nextValue);
    setState(() {
      searching = false;
    });
  }

  _selectOrg(BuildContext context, search.OrgSearchResult org) {
    Navigator.pop(context, org);
  }
}

class OrgSearchPage extends StatefulWidget {
  OrgSearchPage();

  @override
  _OrgSearchPageState createState() => _OrgSearchPageState();
}

// ORG SEARCH STUFF
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
  Widget buildSuggestions(BuildContext context) => FutureBuilder<List<search.OrgSearchResult>>(
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

  Widget buildSuggestionsSuccess(List<search.OrgSearchResult> suggestions) => ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final queryText = suggestion.label.substring(0, query.length);
          final remainingText = suggestion.label.substring(query.length);

          return ListTile(
            onTap: () {
              query = suggestion.id;

              // 1. Show Results
              //showResults(context);

              // 2. Close Search & Return Result
              close(context, suggestion.id);

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

  Future<List<search.OrgSearchResult>> _onSearchChanged(String query) async {
    debouncer.value = query;
    return await search.searchOrg(await debouncer.nextValue);
  }
}
