import 'package:html/dom.dart' as dom;

class SearchFilter {
  SearchFilter(this.dataName, this.dataParam, this.dataPrefix);
  String dataName;
  String dataParam;
  String dataPrefix;

  // Key: Filter name | Value: Filter value
  Map<String, String> options = <String, String>{};

  factory SearchFilter.fromDomElement(dom.Element domElement) {
    SearchFilter filter = SearchFilter(domElement.attributes["data-name"] ?? "", domElement.attributes["data-param"] ?? "", domElement.attributes["data-prefix"] ?? "");

    // Example match: <option value="10/11">10/11</option>
    for (dom.Element filterCheckNode in domElement.querySelectorAll("option")) {
      filter.options[filterCheckNode.text] = filterCheckNode.attributes["value"] ?? "";
    }
    return filter;
  }
}
