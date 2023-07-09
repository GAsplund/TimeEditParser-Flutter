class PageEntry {
  final String entry;
  final int id;
  final String name;
  final String? description;

  PageEntry(this.entry, this.id, this.name, this.description);

  @override
  String toString() {
    return "PageEntry: $name ($id)";
  }
}
