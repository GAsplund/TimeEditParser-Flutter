import 'package:html/dom.dart' as dom;

class SearchFilter {
  SearchFilter();
  String dataName;
  String dataParam;
  String dataPrefix;

  // Key: Filter name | Value: Filter value
  Map<String, String> options = new Map<String, String>();

  factory SearchFilter.fromDomElement(dom.Element domElement) {
    SearchFilter filter = new SearchFilter();
    filter.dataName = domElement.attributes["data-name"];
    filter.dataParam = domElement.attributes["data-param"];
    filter.dataPrefix = domElement.attributes["data-prefix"];

    // Example match: <option value="10/11">10/11</option>
    for (dom.Element filterCheckNode in domElement.querySelectorAll("option")) {
      filter.options[filterCheckNode.text] = filterCheckNode.attributes["value"];
    }
    return filter;
  }
}
