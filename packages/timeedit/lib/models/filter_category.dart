import 'search_filter.dart';
import 'package:html/dom.dart' as dom;

class FilterCategory {
  FilterCategory(this.name, this.value);
  String name;
  String value;
  List<SearchFilter> filters = [];

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

    for (dom.Element filterSelectionNode in filterSelectionNodes) {
      filterCategory.filters.add(SearchFilter.fromDomElement(filterSelectionNode));
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
