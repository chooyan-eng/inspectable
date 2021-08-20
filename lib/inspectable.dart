import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

class Inspectable extends StatefulWidget {
  final Widget child;
  final Map<Type, Color> colors;

  const Inspectable({
    Key? key,
    required this.child,
    this.colors = const <Type, Color>{},
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
  final Map<Element, List<Element>> _elementTree = {};
  bool get _inspecting => _elementTree.isNotEmpty;
  final _controller = TreeController()..collapseAll();

  /// Execute inspecting widget tree.
  /// By calling this method, [Inspectable] would switch displaying UI
  /// from [child] into inspected widget tree.
  void inspect() {
    final Map<Element, List<Element>> elementTree = {};
    void inspectRecursively(Element child) {
      elementTree[child] = [];
      child.visitAncestorElements((parent) {
        if (elementTree.containsKey(parent)) {
          elementTree[parent]!.add(child);
        }
        return false;
      });
      child.visitChildren(inspectRecursively);
    }

    context.visitChildElements(inspectRecursively);

    final rootInspectable =
        context.findRootAncestorStateOfType<InspectableState>() ?? this;
    rootInspectable._openInspector(elementTree);
  }

  void _openInspector(Map<Element, List<Element>> elementTree) {
    setState(() {
      _elementTree.addAll(elementTree);
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
      body: _elementTree.isEmpty
          ? SizedBox.shrink()
          : SafeArea(
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: TreeView(
                      treeController: _controller,
                      indent: 16,
                      nodes: [
                        _buildTreeNodeRecursively(_elementTree.keys.first),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _elementTree.clear();
          });
        },
        child: Icon(Icons.restore),
      ),
    );
  }

  TreeNode _buildTreeNodeRecursively(Element rootElement) {
    TreeNode buildNode(Element element) {
      final widgetType = element.widget.runtimeType;
      print(element.widget.toStringDeep());
      return TreeNode(
        content: Text(
          widgetType.toString(),
          style: TextStyle(
            color: widget.colors[widgetType] ?? Colors.black,
            fontSize: widget.colors.containsKey(widgetType) ? 24 : 16,
          ),
        ),
        children: (_elementTree[element] ?? []).map(buildNode).toList(),
      );
    }

    return buildNode(rootElement);
  }
}
