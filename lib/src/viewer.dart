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
            if (node.children.isNotEmpty)
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
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  node.runtimeType.toString(),
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: widget.colors[node.runtimeType] ??
                                        Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...node.attributes.map((attribute) => Text(
                                    attribute.trim(),
                                    style: const TextStyle(fontSize: 20),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text(
                node.runtimeType.toString(),
                style: TextStyle(
                  color: widget.colors[node.runtimeType] ?? Colors.black,
                  fontSize:
                      widget.colors.containsKey(node.runtimeType) ? 24 : 20,
                ),
              ),
            ),
            const SizedBox(width: 4),
            if (node.key != null)
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            node.key!.toString(),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.vpn_key,
                  size: 20,
                  color: Colors.red.shade300,
                ),
              ),
            if (node.subText != null)
              Text(
                node.subText!,
                style: const TextStyle(color: Colors.black54),
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
