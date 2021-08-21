part of inspectable;

class Inspectable extends StatefulWidget {
  /// [Widget] represents app's main contents
  final Widget child;

  /// Color palette to emphasize specific widget
  final Map<Type, Color> colors;

  /// Flag to show private widget classes.
  /// Defalut [false]
  final bool verbose;

  const Inspectable({
    Key? key,
    required this.child,
    this.colors = const <Type, Color>{},
    this.verbose = false,
  }) : super(key: key);

  /// Find [InspectableState] which is found as a closest descendant of given [context].
  /// Usually this method is used with [inspect] method.
  static InspectableState of(BuildContext context) {
    final state = context.findAncestorStateOfType<InspectableState>();
    assert(() {
      if (state == null) {
        throw FlutterError(
            'Inspectable operation requested with a context that does not include a Inspectable.\n'
            'The context used to inspect widgets from the Inspectable must be that of a '
            'widget that is a descendant of a Inspectable widget.');
      }
      return true;
    }());

    return state!;
  }

  @override
  InspectableState createState() => InspectableState();
}

/// [State] for [Inspectable].
class InspectableState extends State<Inspectable> {
  Node? _root;
  bool get _inspecting => _root != null;

  /// Execute inspecting widget tree.
  /// By calling this method, [Inspectable] would switch displaying UI
  /// from [child] into inspected widget tree.
  void inspect() {
    Node? root;
    final nodeReferences = <int, Node>{};
    void inspectRecursively(Element child) {
      final rootWidget = child.widget;

      final attributes = _parseDescription(rootWidget.toStringDeep());
      final node = Node(
        objectId: rootWidget.hashCode,
        runtimeType: rootWidget.runtimeType,
        attributes: attributes,
        key: rootWidget.key,
        subText: rootWidget is Text ? attributes.first : null,
      );

      if (widget.verbose || !node.runtimeType.toString().startsWith('_')) {
        if (root == null) {
          root = node;
        } else {
          child.visitAncestorElements((parent) {
            final parentNode = nodeReferences[parent.widget.hashCode];
            if (parentNode == null) {
              return true;
            } else {
              parentNode.children.add(node);
              return false;
            }
          });
        }

        nodeReferences[node.objectId] = node;
      }
      child.visitChildren(inspectRecursively);
    }

    context.visitChildElements(inspectRecursively);

    assert(root != null, '');

    final rootInspectable =
        context.findRootAncestorStateOfType<InspectableState>() ?? this;
    rootInspectable._openInspector(root!);
  }

  List<String> _parseDescription(String description) {
    final attributeMatches = RegExp(r'(?<=\().+(?=\))').allMatches(description);
    if (attributeMatches.isNotEmpty) {
      final matchString = attributeMatches.first.group(0);
      return matchString?.split(',') ?? [];
    }
    return [];
  }

  void _openInspector(Node root) {
    setState(() {
      _root = root;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        _inspecting ? _buildInspectResult() : SizedBox.shrink(),
      ],
    );
  }

  Widget _buildInspectResult() {
    return Scaffold(
      body: !_inspecting
          ? SizedBox.shrink()
          : SafeArea(
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: _Viewer(
                      root: _root!,
                      colors: widget.colors,
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _root = null;
          });
        },
        child: Icon(Icons.restore),
      ),
    );
  }
}
