import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:super_editor/src/serialization/node_type.dart';
import 'package:super_editor/super_editor.dart';

import '../core/document.dart';
import 'box_component.dart';
import 'styles.dart';

class EmbeddedImageNode with ChangeNotifier implements DocumentNode {
  EmbeddedImageNode({
    required this.id,
    required String imageUrl,
    required String title,
    required int counter,
  })  : _imageUrl = imageUrl,
        _title = title,
        _counter = counter;

  @override
  final String id;
  String _title;
  int _counter;

  String _imageUrl;
  String get imageUrl => _imageUrl;
  String get title => _title;
  int get counter => _counter;

  set title(String title) {
    _title = title;
    notifyListeners();
  }

  set imageUrl(String newImageUrl) {
    if (newImageUrl != _imageUrl) {
      print('Paragraph changed. Notifying listeners.');
      _imageUrl = newImageUrl;
      notifyListeners();
    }
  }

  @override
  BinaryNodePosition get beginningPosition => const BinaryNodePosition.included();

  @override
  BinaryNodePosition get endPosition => const BinaryNodePosition.included();

  @override
  BinarySelection computeSelection({
    @required dynamic base,
    @required dynamic extent,
  }) {
    return const BinarySelection.all();
  }

  @override
  String? copyContent(dynamic selection) {
    assert(selection is BinarySelection);

    return (selection as BinarySelection).position == BinaryNodePosition.included() ? _imageUrl : null;
  }

  @override
  bool hasEquivalentContent(DocumentNode other) {
    return other is EmbeddedImageNode && imageUrl == other.imageUrl && title == other.title && counter == other.counter;
  }

  @override
  NodePosition selectUpstreamPosition(NodePosition position1, NodePosition position2) {
    if (position1 is! BinaryNodePosition) {
      throw Exception('Expected a BinaryNodePosition for position1 but received a ${position1.runtimeType}');
    }
    if (position2 is! BinaryNodePosition) {
      throw Exception('Expected a BinaryNodePosition for position2 but received a ${position2.runtimeType}');
    }
    return position1;
  }

  @override
  NodePosition selectDownstreamPosition(NodePosition position1, NodePosition position2) {
    if (position1 is! BinaryNodePosition) {
      throw Exception('Expected a BinaryNodePosition for position1 but received a ${position1.runtimeType}');
    }
    if (position2 is! BinaryNodePosition) {
      throw Exception('Expected a BinaryNodePosition for position2 but received a ${position2.runtimeType}');
    }
    return position1;
  }

  factory EmbeddedImageNode.fromJson(Map<String, dynamic> json) => EmbeddedImageNode(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String,
      counter: json['counter'] as int);

  @override
  Map<String, dynamic> toJson() => {
        'nodeType': NodeType.embeddedImage.toString(),
        'id': id,
        'imageUrl': imageUrl,
        'title': title,
        'counter': counter,
      };
}

Widget? embeddedImageBuilder(ComponentContext componentContext) {
  if (componentContext.documentNode is! EmbeddedImageNode) {
    return null;
  }

  final selection =
      componentContext.nodeSelection == null ? null : componentContext.nodeSelection!.nodeSelection as BinarySelection;
  final isSelected = false;

  return EmbeddedImageComponent(
    componentKey: componentContext.componentKey,
    imageUrl: (componentContext.documentNode as EmbeddedImageNode).imageUrl,
    title: (componentContext.documentNode as EmbeddedImageNode).title,
    counter: (componentContext.documentNode as EmbeddedImageNode).counter,
    isSelected: isSelected,
    selectionColor: (componentContext.extensions[selectionStylesExtensionKey] as SelectionStyle).selectionColor,
  );
}

/// Displays an image in a document.
class EmbeddedImageComponent extends StatefulWidget {
  const EmbeddedImageComponent({
    Key? key,
    required this.componentKey,
    required this.title,
    required this.counter,
    required this.imageUrl,
    this.selectionColor = Colors.blue,
    this.isSelected = false,
  }) : super(key: key);

  final GlobalKey componentKey;
  final String imageUrl;
  final String title;
  final int counter;
  final Color selectionColor;
  final bool isSelected;

  @override
  State<EmbeddedImageComponent> createState() => _EmbeddedImageComponentState();
}

class _EmbeddedImageComponentState extends State<EmbeddedImageComponent> {
  bool isExpanded = false;
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BoxComponent(
        key: widget.componentKey,
        child: MouseRegion(
          onEnter: (_) => setState(() {
            isHover = true;
          }),
          onExit: (_) => setState(() {
            isHover = false;
          }),
          child: ExpansionPanelList(
            elevation: 0,
            expandedHeaderPadding: EdgeInsets.zero,
            expansionCallback: (index, _) => setState(() {
              isExpanded = !isExpanded;
            }),
            children: [
              ExpansionPanel(
                isExpanded: isExpanded,
                headerBuilder: (context, isOpen) => isHover || !isExpanded
                    ? Row(children: [
                        const Icon(Icons.coronavirus),
                        const SizedBox(width: 2),
                        Text(
                          widget.counter.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.title,
                          style: const TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.more_vert,
                              size: 16,
                            )),
                      ])
                    : const SizedBox.shrink(),
                body: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
