import 'package:timeedit/objects/filter.dart';

class Category {
  int id;
  String name;
  List<Filter> filters = [];

  Category(this.id, this.name);
}
