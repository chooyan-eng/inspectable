part of inspectable;

/// Node of a tree, representing one Widget
class Node {
  /// Object ID of the widget
  final int objectId;

  /// Type of the widget
  final Type runtimeType;

  /// Description of the widget
  final String description;

  /// Descendant nodes.
  final children = <Node>[];

  /// [Key] attatched to the widget
  final Key? key;

  Node({
    required this.objectId,
    required this.runtimeType,
    required this.description,
    this.key,
  });
}
