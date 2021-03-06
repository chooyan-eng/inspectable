part of inspectable;

/// Node of a tree, representing one Widget
class Node {
  /// Object ID of the widget
  final int objectId;

  /// Type of the widget
  final Type runtimeType;

  /// State of the widget if the widget is [StatefulWidget]
  final State? state;

  /// subtext of the widget
  final String? subText;

  /// Description of the widget
  final List<String> attributes;

  /// Descendant nodes.
  final children = <Node>[];

  /// [Key] attatched to the widget
  final Key? key;

  Node({
    required this.objectId,
    required this.runtimeType,
    this.state,
    this.subText,
    required this.attributes,
    this.key,
  });
}
