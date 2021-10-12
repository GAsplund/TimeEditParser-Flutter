import 'package:html/dom.dart' as dom;

// TODO: Maybe rename Filter to SearchFilter?
class Filter {
  Filter();
  String dataName;
  String dataParam;
  String dataPrefix;

  // Key: Filter name | Value: Filter value
  Map<String, String> options = new Map<String, String>();

  factory Filter.fromDomElement(dom.Element domElement) {
    Filter filter = new Filter();
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