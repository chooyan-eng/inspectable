part of inspectable;

class _Viewer extends StatefulWidget {
  final Node root;
  final Map<Type, Color> colors;

  const _Viewer({
    Key? key,
    required this.root,
    this.colors = const {},
  }) : super(key: key);

  @override
  _ViewerState createState() => _ViewerState();
}

class _ViewerState extends State<_Viewer> {
  final _expandingNodes = <Node>[];

  @override
  Widget build(BuildContext context) {
    var rows = <Widget>[];

    void appendRowRecursively(Node node, int depth) {
      rows.add(
        Row(
          children: [
            SizedBox(width: (12 * depth).toDouble()),
            InkWell(
              onTap: () {
                setState(() {
                  if (_expandingNodes.contains(node)) {
                    _expandingNodes.remove(node);
                  } else {
                    _expandingNodes.add(node);
                  }
                });
              },
              child: Icon(
                _expandingNodes.contains(node)
                    ? Icons.expand_more
                    : Icons.chevron_right_outlined,
                size: 20,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              node.runtimeType.toString(),
              style: TextStyle(
                color: widget.colors[node.runtimeType] ?? Colors.black,
                fontSize: widget.colors.containsKey(node.runtimeType) ? 24 : 16,
              ),
            ),
          ],
        ),
      );

      if (_expandingNodes.contains(node)) {
        for (final child in node.children) {
          appendRowRecursively(child, depth + 1);
        }
      }
    }

    appendRowRecursively(widget.root, 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows
          .expand((row) => [
                row,
                const SizedBox(height: 4),
              ])
          .toList(),
    );
  }
}

//         ),
//         children: (_elementTree[element] ?? []).map(buildNode).toList(),
//       );
//     }

//     return buildNode(rootElement);
//   }
