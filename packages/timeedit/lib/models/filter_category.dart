import 'search_filter.dart';
import 'package:html/dom.dart' as dom;

/// Represents a filter for a category that can be entered in search.
class FilterCategory {
  FilterCategory(this.name, this.value);
  String name;
  String value;
  List<SearchFilter> filters = [];

  /// Instantiates a new [FilterCategory] from a DOM element.
  factory FilterCategory.fromDomElement(dom.Element domElement, dom.Element filtersLists) {
    // Example match: <option value="183" selected="">Klass</option>
    FilterCategory filterCategory = FilterCategory(domElement.text, domElement.attributes["value"] ?? "");

    // Example match: <fieldset id="ffset183" class="fancyfieldset  fancyNoBorder">
    dom.Element? filterCollectionNode = filtersLists.querySelector("#ffset" + filterCategory.value);

    // Example match:
    // <select class="fancyformfieldsearchselect objectFieldsParam " multiple="" size="14" data-param="fe" data-tefieldkind="CATEGORY" data-name="Period" name="183_22" data-prefix="22" id="ff183_22">
    List<dom.Element> filterSelectionNodes = filterCollectionNode!.querySelectorAll("select");

    if (filterSelectionNodes.isEmpty) {
      return filterCategory;
    }

    for (dom.Element node in filterSelectionNodes) {
      filterCategory.filters.add(SearchFilter.fromDomElement(node));
    }
    return filterCategory;
  }
}

/*class FilterCategory {
  FilterCategory(
      {this.name, this.value, this.dataParam, this.dataPrefix, this.dataType});
  String name;
  String value;
  String dataParam;
  String dataPrefix;
  String dataType;
}*/
