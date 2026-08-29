class MapNode {
  final String id;
  final String label;
  final String type;
  double x;
  double y;

  MapNode({
    required this.id,
    required this.label,
    this.type = 'note',
    this.x = 0,
    this.y = 0,
  });
}
