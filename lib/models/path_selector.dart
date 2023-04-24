abstract class PathSelector {
  abstract String pathType;
  List<String> pathPrefix;
  PathSelector({required this.pathPrefix});
  Future<List<PathSelected>> getPaths();
}

class PathSelected {
  final String label;
  final String path;

  PathSelected(this.label, this.path);
}
